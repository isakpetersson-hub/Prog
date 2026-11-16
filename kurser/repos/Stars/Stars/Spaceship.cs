using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace Stars
{
    internal class Spaceship : MovingObject
    {
        Texture2D gfx_engine;
        Vector2 maxSpeed;
        int textureFrame;
        double engineTimer;
        int flameFrame;

        public Spaceship() : base (new Vector2(Game1.ScreenWidth() / 4, Game1.ScreenHeight() / 2), Color.White)
        {
            // Startar skeppet en fjärdedel in från vänster och centrerat i höjdled.
            drawRect = new Rectangle(0, 0, 100, 100);
            maxSpeed = new Vector2(200);
            textureFrame = 1;       // Default: rakt fram (mittenbilden)

            engineTimer = 0;
            flameFrame = 0;
        }

        public override void LoadContent(ContentManager content)
        {
            gfx_texture = content.Load<Texture2D>("starship");
            gfx_engine = content.Load<Texture2D>("engineflames");
            
            // Räknar ut middle. Tre bilder på höjden gör att vi delar med 3 och 2 = dela med 6.
            middle = new Vector2(gfx_texture.Width / 2, gfx_texture.Height / 6);
        }

        public override bool Update(GameTime gameTime)
        {
            KeyboardState keyboardState = Keyboard.GetState();
            textureFrame = 1;       // Utgår från att man är riktad framåt.
            speed = Vector2.Zero;   // Utgår från att man står still.

            if( keyboardState.IsKeyDown(Keys.W))
            {
                speed.Y -= maxSpeed.Y;
                textureFrame--;
            }
            
            if (keyboardState.IsKeyDown(Keys.S))
            {
                speed.Y += maxSpeed.Y;
                textureFrame++;
            }

            if (keyboardState.IsKeyDown(Keys.D))
                speed.X += maxSpeed.X;

            if (keyboardState.IsKeyDown(Keys.A))
                speed.X -= maxSpeed.X;

            position += speed * (float)gameTime.ElapsedGameTime.TotalSeconds;
            if (position.X <= gfx_texture.Width/2)
            {
                position.X = gfx_texture.Width / 2;
            }
            if (position.Y <= gfx_texture.Height / 6)
            {
                position.Y = gfx_texture.Height / 6;
            }
            if (position.X >= Game1.ScreenWidth()-gfx_texture.Width/2)
            {
                position.X = Game1.ScreenWidth() - gfx_texture.Width / 2;
            }
            if (position.Y >= Game1.ScreenHeight()- gfx_texture.Height / 6)
            {
                position.Y = Game1.ScreenHeight()-gfx_texture.Height / 6;
            }
            engineTimer += gameTime.ElapsedGameTime.TotalMilliseconds;
            if(engineTimer > 100)
            {
                engineTimer = 0;
                flameFrame++;
                if (flameFrame == 2)
                    flameFrame = 0;
            }

            drawRect.Y = textureFrame * 100;        // Klipper ut rätt "frame" ur bilden.

            return true;
        }

        public override void Draw(SpriteBatch spriteBatch)
        {
            spriteBatch.Draw(gfx_engine, position - new Vector2(82,50), new Rectangle(32*flameFrame, 0, 32, 100), Color.White);
            spriteBatch.Draw(gfx_texture, position, drawRect, primaryColor, 0, middle, 1, SpriteEffects.None, 0);
        }
    }
}
