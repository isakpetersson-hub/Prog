using System;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Content;

namespace MeatballSimulator
{
    internal class Meatball
    {
        Texture2D gfx_meatball;
        Vector2 position;
        Vector2 speed;
        Vector2 middle;

        float gravity = 300f;
        float angle;
        float rotationSpeed;    // radianer per sekund

        SoundEffect sfx_splat;

        static Random slump = new Random(100);

        // Konstruktor! Anropas när en köttbulle skapas (new).
        // Har ingen returtyp (skickar inte tillbaka något).
        // Måste vara public och heta exakt likadant som klassen.
        public Meatball()
        {
            position = new Vector2(slump.Next(100,(int)Game1.screenSize.X-100), slump.Next(100,(int)Game1.screenSize.Y-100));
            angle = 0;
            rotationSpeed = 2;
            speed = new Vector2(-240, 300);
        }

        public void LoadContent(ContentManager content)
        {
            gfx_meatball = content.Load<Texture2D>("meatball");
            sfx_splat = content.Load<SoundEffect>("splat");
            middle = new Vector2(gfx_meatball.Width / 2, gfx_meatball.Height / 2);
        }

        public void Update(GameTime gameTime)
        {
            if (position.X - middle.X <= 0 || position.X + middle.X >= Game1.screenSize.X)
            {
                speed.X = -speed.X;
                sfx_splat.Play();
            }

            if (position.Y - middle.Y <= 0 || position.Y + middle.Y >= Game1.screenSize.Y)
            {
                speed.Y = -speed.Y;
                sfx_splat.Play();
            }
            else
            {
                speed.Y += gravity * (float)gameTime.ElapsedGameTime.TotalSeconds;
            }

            angle += rotationSpeed * (float)gameTime.ElapsedGameTime.TotalSeconds;
            position += speed * (float)gameTime.ElapsedGameTime.TotalSeconds;
        }

        public void Draw(SpriteBatch spriteBatch)
        {
            // sourceRectangle = del av bilden som ritas, null blir hela bilden.
            // rotation räknas i radianer, 360 grader = 6,28 rad
            // origin anger rotationspunkt och "positionspunkt"
            // scale anger skala, 1 = normal.
            spriteBatch.Draw(gfx_meatball, position, null, Color.White, angle, middle, 1, SpriteEffects.None, 0);

        }

    }
}
