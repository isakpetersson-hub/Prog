using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace Stars
{
    internal class Star : MovingObject
    {
        public Star() : base(Vector2.Zero, Color.White) // Anropar konstruktorn i superklassen/basklassen
        {
            position = new Vector2(random.Next(Game1.ScreenWidth()), random.Next(Game1.ScreenHeight()));

            int type = random.Next(3);
            switch(type)
            {
                case 0:
                    speed.X = -30;
                    primaryColor = new Color(80, 80, 80);
                    break;
                case 1:
                    speed.X = -60;
                    primaryColor = new Color(130, 130, 130);
                    break;
                case 2:
                    speed.X = -120;
                    primaryColor = new Color(255, 255, 255);
                    break;
            }
        }

        private void Initialize()
        {
            position.X = Game1.ScreenWidth();
            position.Y = random.Next(Game1.ScreenHeight());
        }

        public override void LoadContent(ContentManager content)
        {
            gfx_texture = content.Load<Texture2D>("star3x3");
            middle = new Vector2(gfx_texture.Width / 2, gfx_texture.Height / 2);
            drawRect = new Rectangle(0, 0, gfx_texture.Width, gfx_texture.Height);
        }

        public override bool Update(GameTime gameTime)
        {
            position += speed * (float)(gameTime.ElapsedGameTime.TotalSeconds);

            if (position.X < 0)
                Initialize();

            return true;
        }
    }
}
