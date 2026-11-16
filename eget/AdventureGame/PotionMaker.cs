using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Audio;
using System.Collections.Generic;

namespace AdventureGame
{
    internal static class PotionMaker
    {
        private static var healPotion = new Vector<float>(1,0);


        public static isValidPotion(var input)
        {
            if (input == healPotion)
                return true;
            return false;
        }
    }
}
