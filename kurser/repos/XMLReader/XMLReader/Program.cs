using System.ComponentModel;
using System.Globalization;
using System.Xml;

namespace XMLReader
{
    internal class Program
    {
        static int tilewidth, tileheight;
        static int worldwidth, worldheight;
        static ushort[,] worldData;
        static ushort[,] ontopData;
        static ushort[,] walkBehindData;
        static byte[,] tileinfo;

        static string layer;

        static void Main(string[] args)
        {
            ReadTMX("karta32.tmx");
            Console.ReadKey();
        }
        private static void ReadTMX(String file)
        {
            Console.WriteLine("Output using XML reader");
            using (XmlReader xmlreader = XmlReader.Create(@file))
            {
                while (xmlreader.Read())
                {
                    string name = xmlreader.Name;
                    Console.WriteLine(name);
                
                    if (name == "map")
                    {
                        if (xmlreader.HasAttributes)
                        {
                            while (xmlreader.MoveToNextAttribute())
                            {
                                if (xmlreader.Name == "tilewidth")
                                {
                                    tilewidth = int.Parse(xmlreader.Value);
                                    Console.WriteLine(tilewidth);
                                }
                                if (xmlreader.Name == "tileheight")
                                {
                                    tileheight = int.Parse(xmlreader.Value);
                                    Console.WriteLine(tileheight);
                                }
                                if (xmlreader.Name == "width")
                                {
                                    worldwidth = int.Parse(xmlreader.Value);
                                    Console.WriteLine(worldwidth);

                                }
                                if (xmlreader.Name == "height")
                                {
                                    worldheight = int.Parse(xmlreader.Value);
                                    Console.WriteLine(worldheight);

                                }
                            }
                            xmlreader.MoveToElement();
                        }
                    }
                    if (name == "layer")
                    {
                        if (xmlreader.HasAttributes)
                        {
                            while (xmlreader.MoveToNextAttribute())
                            {
                                if (xmlreader.Name == "name")
                                {
                                    layer = xmlreader.Value;
                                }
                            }
                            xmlreader.MoveToElement();
                        }
                    }
                    if (name == "data")
                    {
                        string[] content = xmlreader.ReadElementContentAsString().Split(",");
                        int index = 0;

                        if (layer == "collision")
                        {
                            tileinfo = new byte[worldwidth, worldheight];
                            int firstgrid = 668;
                            content[index] = content[index].Replace("\n", "");
                            for (int y = 0; y < worldheight; y++)
                            {
                                for (int x = 0; x < worldwidth; x++)
                                {
                                    tileinfo[x, y] = Convert.ToByte(ushort.Parse(content[index]) - firstgrid);
                                    Console.Write(tileinfo[x, y]);
                                    index++;
                                }
                                Console.WriteLine();
                            }
                        }
                        if (layer == "walkbehind")
                        {
                            walkBehindData = new ushort[worldwidth, worldheight];
                            content[index] = content[index].Replace("\n", "");
                            for (int y = 0; y < worldheight; y++)
                            {
                                for (int x = 0; x < worldwidth; x++)
                                {
                                    walkBehindData[x, y] = ushort.Parse(content[index]);
                                    Console.Write(walkBehindData[x, y]);
                                    index++;
                                }
                                Console.WriteLine();
                            }
                        }
                        if (layer == "ontop")
                        {
                            ontopData = new ushort[worldwidth, worldheight];
                            content[index] = content[index].Replace("\n", "");
                            for (int y = 0; y < worldheight; y++)
                            {
                                for (int x = 0; x < worldwidth; x++)
                                {
                                    ontopData[x, y] = ushort.Parse(content[index]);
                                    Console.Write(ontopData[x, y]);
                                    index++;
                                }
                                Console.WriteLine();
                            }
                        }
                        if (layer == "ground")
                        {
                            worldData = new ushort[worldwidth, worldheight];
                            content[index] = content[index].Replace("\n", "");
                            for (int y = 0; y < worldheight; y++)
                            {
                                for (int x = 0; x < worldwidth; x++)
                                {
                                    worldData[x, y] = ushort.Parse(content[index]);
                                    Console.Write(worldData[x, y]);
                                    index++;
                                }
                                Console.WriteLine();
                            }
                        }
                    }
                }
            }
        }
    }
}