using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Audio;
using System.Collections.Generic;

namespace AdventureGame
{
    internal static class PotionCrafting
    {
        
    public static HealingPotion createHealingPotion()
        {
            return new HealingPotion();
        }
    }
}
