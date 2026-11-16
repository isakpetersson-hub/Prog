using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace AdventureGame
{
    internal static class TileEngine
    {
        static Texture2D tileMap;
        static Vector2 camerapostion;
        static int tileWidth;
        static int tileHeight;
        static int worldWidth;
        static int worldHeight;
        static ushort[,] worldData;
        static ushort[,] ontopData;
        static ushort[,] walkBehindData;
        static byte[,] tileInfo;
        static int mapTilesWide;
        static Rectangle sourceRect;
        static int ScreenRows;
        static int ScreenCols;

        public static void LoadLevel(ContentManager content, string mapFile,string tilemap,Vector2 startposition)
        {
            tileMap = content.Load<Texture2D>(tilemap);
            camerapostion = startposition;
            ReadTmx(mapFile);
            mapTilesWide = tileMap.Width/tileWidth;
            ScreenRows = Game1.ScreenHeight() / tileHeight;
            ScreenCols = Game1.ScreenWidth() / tileWidth;
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
                            sourceRect = new Rectangle(0, 0, tileWidth, tileHeight);
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
                                    index++;
                                }
                            }
                        }
                    }
                }
            }
        }

        public static void UpdateCamera(Vector2 centerPos)
        {
            camerapostion.X = centerPos.X - (Game1.ScreenWidth()/2);
            camerapostion.Y = centerPos.Y - (Game1.ScreenHeight()/2);

            if (camerapostion.X < 0)
            {
                camerapostion.X = 0;
            }
            if (camerapostion.Y < 0)
            {
                camerapostion.Y = 0;
            }
            if (camerapostion.X > tileWidth * (worldWidth-ScreenCols))
            {
                camerapostion.X = tileWidth * (worldWidth - ScreenCols);
            }
            if (camerapostion.Y > tileHeight * (worldHeight-ScreenRows))
            {
                camerapostion.Y = tileHeight * (worldHeight - ScreenRows);
            }
        }

        public static Vector2 GetCamera() => camerapostion;

        public static int GetTileType(Vector2 position)
        {
            int x = (int)position.X / tileWidth;
            int y = (int)position.Y / tileHeight;

            if (x < 0 || x >= worldWidth || y < 0 || y >= worldHeight)
            {
                return -1;
            }
            return tileInfo[x, y];
        }

        public static int GetRow(Vector2 position) => (int)position.Y / tileHeight;
        public static int GetCol(Vector2 position) => (int)position.X / tileWidth;

        public static void changeTileInfo(int x, int y, byte n)
        {
            if (x >= 0 && x < worldWidth && y >= 0 && y < worldHeight)
            {
                tileInfo[x, y] = n;
            }
        }
        public static void changeTileWorld(int x, int y, ushort n)
        {
            if (x >= 0 && x < worldWidth && y >= 0 && y < worldHeight)
            {
                worldData[x, y] = n;
            }
        }
        public static void changeTileOnTop(int x, int y, byte n)
        {
            if (x >= 0 && x < worldWidth && y >= 0 && y < worldHeight)
            {
                ontopData[x, y] = n;
            }
        }
        public static void Draw(SpriteBatch spritebatch)
        {
            int startX = (int)(camerapostion.X / tileWidth);
            int startY = (int)(camerapostion.Y / tileHeight);

            int endX = startX + ScreenCols;
            int endY = startY + ScreenRows;

            Vector2 position = Vector2.Zero;

            for(int y = startY; y <= endY && y < worldData.GetLength(1); y++)
            {
                for (int x = startX; x <= endX && x < worldData.GetLength(0); x++)
                {
                    position.X = (int)(x * tileWidth - camerapostion.X);
                    position.Y = (int)(y * tileHeight - camerapostion.Y);

                    int index = worldData[x, y]-1; //Minus 1 för att talen i filen böjar på 0 = tom.
                    if (index >= 0)
                    {
                        sourceRect.X = index % mapTilesWide * tileWidth;
                        sourceRect.Y = index / mapTilesWide * tileHeight;
                        spritebatch.Draw(tileMap, position, sourceRect, Color.White, 0, Vector2.Zero, 1, SpriteEffects.None, 0.5f);
                    }

                    index = ontopData[x, y]-1; //Minus 1 för att talen i filen böjar på 0 = tom.
                    if (index >= 0)
                    {
                        sourceRect.X = index % mapTilesWide * tileWidth;
                        sourceRect.Y = index / mapTilesWide * tileHeight;
                        spritebatch.Draw(tileMap, position, sourceRect, Color.White, 0, Vector2.Zero, 1, SpriteEffects.None, 0.4f);
                    }

                    index = walkBehindData[x, y]-1; //Minus 1 för att talen i filen böjar på 0 = tom.
                    if (index >= 0)
                    {
                        sourceRect.X = index % mapTilesWide * tileWidth;
                        sourceRect.Y = index / mapTilesWide * tileHeight;
                        spritebatch.Draw(tileMap, position, sourceRect, Color.White, 0, Vector2.Zero, 1, SpriteEffects.None, 0.2f);
                    }
                }
            }
        }
    }
}
