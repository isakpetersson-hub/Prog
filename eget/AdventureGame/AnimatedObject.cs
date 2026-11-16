using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Audio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdventureGame
{
    internal abstract class AnimatedObject : MovingObject
    {
        protected int[] animSequence = new int[201];
        protected int currentFrame;
        protected int framesInRow;
        protected int animSpeed;
        protected int animTimer;
        protected Vector2 spriteSize;

        public AnimatedObject(Vector2 position,  float scale = 1, float angle = 0)
            :base(position,Color.White,scale,angle)
        {
            
        }
        public AnimatedObject(Vector2 position, Color color, float scale = 1, float angel = 0, float alpha = 1)
            :base(position,color,scale,angel,alpha)
        {

        }
        protected void SetFrame(int n)
        {
            drawRect.Y = (int)(spriteSize.Y * (n / framesInRow));
            drawRect.X = (int)(spriteSize.X * (n % framesInRow));
        }

        protected void UpdateAnimation(GameTime gameTime)
        {
            animTimer += (int)gameTime.ElapsedGameTime.TotalMilliseconds;
            if (animTimer >= animSpeed)
            {
                animTimer -= animSpeed;
                currentFrame = animSequence[currentFrame];
                SetFrame(currentFrame);
            }
        }
    }
}
