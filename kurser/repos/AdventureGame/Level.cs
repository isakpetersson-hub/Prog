using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Audio;
using System.Collections.Generic;
using Microsoft.Xna.Framework.Media;
using System;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection.Metadata;

namespace AdventureGame
{
    internal static class Level
    {
        static int level = 1;
        static List<string> happenings = new List<string>();
        static SoundEffect sfx_item;
        static SoundEffect sfx_Castledoor;
        static Song gameSong;

        public static void LoadSounds(ContentManager content)
        {
            sfx_item = content.Load<SoundEffect>("PickItem");
            sfx_Castledoor = content.Load<SoundEffect>("UnlockAndOpen");
            gameSong = content.Load<Song>("overworld");
            MediaPlayer.IsRepeating = true;
            MediaPlayer.Volume = 0.2f;
            MediaPlayer.Play(gameSong);

        }

        public static bool TileEvent(Vector2 position)
        {
            int x = TileEngine.GetCol(position);
            int y = TileEngine.GetRow(position);

            if (level == 1)
            {
                if (x == 25 && y == 8)
                {
                    if (Player.Contains("KeyCastle") == true)
                    {
                        sfx_Castledoor.Play();
                        TileEngine.changeTileWorld(x, y, 29);
                        TileEngine.changeTileInfo(x, y, 4);
                        Player.Removeitem("KeyCastle");
                        return false;
                    }
                }
                if (x == 43 && y == 39)
                {
                    sfx_item.Play();
                    TileEngine.changeTileInfo(x, y, 0);
                    TileEngine.changeTileOnTop(x, y, 0);
                    Player.Additem("KeyCastle");
                    return true;
                }
            }
            return false;
        }
    }
}
