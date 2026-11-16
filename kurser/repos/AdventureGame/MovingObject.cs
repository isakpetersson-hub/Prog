using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AdventureGame
{
    // Hela klassen är abstract.
    // Det betyder att man INTE kan skapa något objekt av klassen.
    internal abstract class MovingObject
    {
        // Protected betyder att man kan komma åt variabeln/objekt/metoder
        // i den här egna klassen OCH i klasser som ärver av den (star och spaceship).
        protected static Random random = new Random();
        protected Texture2D gfx_player1;
        protected Vector2 position;
        protected Vector2 speed;
        protected Vector2 middle;
        protected Color primaryColor;
        protected Rectangle drawRect;
        protected float scale;
        protected float angle;              // Vinkeln att rita texturen med
        protected float alpha;              // genomskinlighet 0 - 1

        public MovingObject(Vector2 position, Color primaryColor, float scale = 1, float angle = 0, float alpha = 1)
        {
            this.position = position;
            this.primaryColor = primaryColor;
            this.scale = scale;
            this.angle = angle;
            this.alpha = alpha;
        }

        // En abstract metod får inte ha något innehåll här.
        // Den är bara till för att tvinga alla subklasser att
        // implementera sin egen version av metoden.
        public abstract bool Update(GameTime gameTime);

        public abstract void LoadContent(ContentManager content);

        // En metod som är virtual kan ha ett "default" innehåll som kan användas
        // av klasserna som ärver. Om det innehållet inte duger så kan klasserna
        // skriva över (override) metoden med ett eget nytt innehåll.
        public virtual void Draw(SpriteBatch spriteBatch)
        {
            spriteBatch.Draw(gfx_player1, position-TileEngine.GetCamera(), drawRect, primaryColor * alpha, angle, middle, scale, SpriteEffects.None, 0);
        }

        public virtual Vector2 Getpostion() => position;
    }
}
