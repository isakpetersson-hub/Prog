using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection.Metadata;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Audio;

namespace AdventureGame
{
    // Hela klassen är abstract.
    // Det betyder att man INTE kan skapa något objekt av klassen.
    internal abstract class Pieces
    {
        // Protected betyder att man kan komma åt variabeln/objekt/metoder
        // i den här egna klassen OCH i klasser som ärver av den (star och spaceship).
        protected Vector2 middle;
        protected Rectangle drawRect;     //Vilken del av ChessPiecesArray ska ritas
        protected Rectangle destinationRect;      //Vart pjäsen ska ritas
        protected List<Rectangle> dotrectangle = new List<Rectangle>();      //Lista av alla dots som anvädends för att vissa möjliga drag
        protected float angle;              // Vinkeln att rita texturen med
        protected int startingposition;     // Vilken Rectangel som pjäsen ska börja på
        protected static Texture2D gfx_pieces;
        protected static Texture2D gfx_dot;
        protected static SoundEffect sfx_move;
        protected static SoundEffect sfx_capture;
        protected MouseState mousestate;
        protected Point mousePosition;
        protected bool PieceSelected = false;
        protected bool IsWhite;
        protected bool changemousestate = true;  //Anvädes så man inte klickar flera gånger och väljer pjäsen igen
        protected bool captured = false;
        protected int currentposition;
        protected int Piecenumber;

        public Pieces(int startingposition, int Piecenumber)
        {
            this.startingposition = startingposition;
            this.Piecenumber = Piecenumber;
        }

        // En abstract metod får inte ha något innehåll här.
        // Den är bara till för att tvinga alla subklasser att
        // implementera sin egen version av metoden.
        public abstract bool Update(GameTime gameTime);

        public abstract void Initalize(Texture2D gfx_pieces_array, Texture2D gfx_dot_image, SoundEffect sfx_move, SoundEffect sfx_caputre);

        // En metod som är virtual kan ha ett "default" innehåll som kan användas
        // av klasserna som ärver. Om det innehållet inte duger så kan klasserna
        // skriva över (override) metoden med ett eget nytt innehåll.
        public virtual void Draw(SpriteBatch spriteBatch)
        {
        }
    }
}
