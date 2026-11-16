using System.Xml;

namespace ReadXML
{
    internal class Program
    {
        static int tileWidth, tileHeight;              // Storlek på en tile. Ex 16x16 eller 32x32
        static int worldWidth, worldHeight;            // Storlek på världen i antal tiles.
        static ushort[,] worldData;                    // Tiledatan för världen som användaren ser.
        static ushort[,] ontopData;                    // Tiles som ligger ovanpå världen, blommor, stenar etc.
        static ushort[,] walkBehindData;               // Tiles som man kan gå bakom, trädkronor etc.
        static byte[,] tileInfo;                       // Info om vilket underlag man går på, kolliderar mot m.m.

        static void Main(string[] args)
        {
            ReadTmx("karta32.tmx");
            Console.ReadKey();
        }

        private static void ReadTmx(string file)
        {
            using (XmlReader xmlReader = XmlReader.Create(@file))
            {
                Console.WriteLine("Output using XMLReader");
                int width = 0;
                int height = 0;
                int firstgid = 0;                                                       // Vilket nummer tiles i den andra tilemappen börjar på.
                string layer = "";

                while (xmlReader.Read())
                {
                    if (xmlReader.IsStartElement())
                    {
                        string name = xmlReader.Name.ToString();
                        if (name == "map")
                        {
                            if (xmlReader.HasAttributes)                                // Det borde finnas attribut att läsa i map-taggen.
                            {
                                while (xmlReader.MoveToNextAttribute())                 // Går igenom alla attribut
                                {
                                    if (xmlReader.Name == "width")
                                        worldWidth = int.Parse(xmlReader.Value);

                                    if (xmlReader.Name == "height")
                                        worldHeight = int.Parse(xmlReader.Value);

                                    if (xmlReader.Name == "tilewidth")
                                        tileWidth = int.Parse(xmlReader.Value);

                                    if (xmlReader.Name == "tileheight")
                                        tileHeight = int.Parse(xmlReader.Value);
                                }

                                xmlReader.MoveToElement();                              // "Hoppar tillbaka" till element-nivå.
                            }
                        }
                        if (name == "tileset")
                        {
                            if (xmlReader.HasAttributes)                                // Det borde finnas attribut att läsan.
                            {
                                while (xmlReader.MoveToNextAttribute())                 // Går igenom alla attribut
                                {
                                    if (xmlReader.Name == "firstgid" && xmlReader.Value != "1")
                                        firstgid = int.Parse(xmlReader.Value);          // Läser in vilket nummer den andra tilemappen börjar sina tiles på.
                                }

                                xmlReader.MoveToElement();                              // "Hoppar tillbaka" till element-nivå.
                            }
                        }
                        if (name == "layer")
                        {
                            if (xmlReader.HasAttributes)                                // Det borde finnas attribut att läsa i layer-taggen.
                            {
                                while (xmlReader.MoveToNextAttribute())                 // Går igenom alla attribut
                                {
                                    if (xmlReader.Name == "name")
                                        layer = xmlReader.Value;                        // Sparar undan layer-namnet så vi läser till rätt array.

                                    if (xmlReader.Name == "width")
                                        width = int.Parse(xmlReader.Value);

                                    if (xmlReader.Name == "height")
                                        height = int.Parse(xmlReader.Value);
                                }

                                Console.WriteLine($"\n*** Layer: {layer} ***");
                                xmlReader.MoveToElement();                              // "Hoppar tillbaka" till element-nivå.
                            }
                        }

                        if (name == "data")
                        {
                            string[] content = xmlReader.ReadElementContentAsString().Split(",");
                            int index = 0;

                            switch (layer)                                              // Sätter rätt storlek på arrayen som ska läsas in.
                            {
                                case "ground":
                                    worldData = new ushort[width, height]; break;

                                case "ontop":
                                    ontopData = new ushort[width, height]; break;

                                case "walkbehind":
                                    walkBehindData = new ushort[width, height]; break;

                                case "collision":
                                    tileInfo = new byte[width, height]; break;
                            }

                            for (int y = 0; y < height; y++)                            // Läser in all tiledata, rad för rad.
                            {
                                for (int x = 0; x < width; x++)
                                {
                                    content[index] = content[index].Replace("\n", "");
                                    switch (layer)
                                    {
                                        case "ground":
                                            worldData[x, y] = ushort.Parse(content[index]); break;

                                        case "ontop":
                                            ontopData[x, y] = ushort.Parse(content[index]); break;

                                        case "walkbehind":
                                            walkBehindData[x, y] = ushort.Parse(content[index]); break;

                                        case "collision":
                                            tileInfo[x, y] = Convert.ToByte(ushort.Parse(content[index]) - firstgid); break;
                                    }
                                    // Utskrift!!
                                    if(layer == "collision")
                                        Console.Write(int.Parse(content[index])-firstgid);
                                    else
                                        Console.Write(content[index]);
                                    index++;
                                }
                            }
                        }
                    }
                }       // Slut på while-loopen.
                Console.WriteLine($"\ntileWidth: {tileWidth}\ntileHeight: {tileHeight}\nworldWidth: {worldWidth}\nworldHeight:{worldHeight}");
            }
        }
        
    }
}