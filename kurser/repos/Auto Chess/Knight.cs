using AdventureGame;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using SharpDX.Direct2D1.Effects;
using SharpDX.DirectWrite;
using Microsoft.Xna.Framework.Audio;

namespace Auto_Chess
{
    internal class Knight : Pieces
    {
        public Knight(int startingposition, int Piecenumber) : base(startingposition, Piecenumber)
        {
            currentposition = startingposition;
            destinationRect = Game1.Tileposition(currentposition);
        }
        public override void Initalize(Texture2D gfx_pieces_array, Texture2D gfx_dot_image, SoundEffect sfx_piecemove, SoundEffect sfx_caputre)
        {
            sfx_move = sfx_piecemove;
            sfx_capture = sfx_caputre;
            if (Piecenumber >= 1)   //Pjäsen är vit om Piecenumber är positivt
            {
                drawRect = new Rectangle(3 * gfx_pieces.Width / 6, gfx_pieces.Height / 2, gfx_pieces.Width / 6, gfx_pieces.Height / 2);
                IsWhite = true;
                Game1.ChangeTileInfo(currentposition, Piecenumber);
            }
            else   //Pjäsen är svart om Piecenumber är negativt
            {
                drawRect = new Rectangle(3 * gfx_pieces.Width / 6, 0, gfx_pieces.Width / 6, gfx_pieces.Height / 2);
                IsWhite = false;
                Game1.ChangeTileInfo(currentposition, Piecenumber);

            }
        }
        public override bool Update(GameTime gameTime)
        {
            if (Game1.TileInfo(currentposition) >= 1 && IsWhite == false || Game1.TileInfo(currentposition) <= -1 && IsWhite == true || Game1.TileInfo(currentposition) == 0)   //Kollar om en pjäs är fångad
            {
                captured = true;
            }
            if (captured == false)   //Stänger av Update om pjäsen är fångad
            {
                mousestate = Mouse.GetState();
                mousePosition = new Point(mousestate.X, mousestate.Y);
                if (mousestate.LeftButton == ButtonState.Pressed && changemousestate == true)
                {
                    changemousestate = false;
                    if (PieceSelected == true)
                    {
                        if (IsWhite == true && Game1.WhosTurn() == true)
                        {
                            //Kollar om ett move är möjligt för vit
                            MoveWhite(-15, 7, 7);
                            MoveWhite(-17, 0, 0);
                            MoveWhite(-6, 6, 7);
                            MoveWhite(-10, 1, 0);
                            MoveWhite(10, 6, 7);
                            MoveWhite(6, 1, 0);
                            MoveWhite(15, 0, 0);
                            MoveWhite(17, 7, 7);
                        }
                        else if (IsWhite == false && Game1.WhosTurn() == false)
                        {
                            //Kollar om ett move är möjligt för svart
                            MoveBlack(-15, 7, 7);
                            MoveBlack(-17, 0, 0);
                            MoveBlack(-6, 6, 7);
                            MoveBlack(-10, 1, 0);
                            MoveBlack(10, 6, 7);
                            MoveBlack(6, 1, 0);
                            MoveBlack(15, 0, 0);
                            MoveBlack(17, 7, 7);
                        }
                        if (destinationRect.Contains(mousePosition) == false)
                        {
                            //Deselectar pjäsen
                            PieceSelected = false;
                            dotrectangle.Clear();
                        }
                    }
                    else
                    {
                        if (destinationRect.Contains(mousePosition))
                        {
                            PieceSelected = true;
                            if (IsWhite == true && Game1.WhosTurn() == true)
                            {
                                //Visar alla möjliga drag för vit
                                SuggestMoveWhite(-15, 7, 7);
                                SuggestMoveWhite(-17, 0, 0);
                                SuggestMoveWhite(-6, 6, 7);
                                SuggestMoveWhite(-10, 1, 0);
                                SuggestMoveWhite(10, 6, 7);
                                SuggestMoveWhite(6, 1, 0);
                                SuggestMoveWhite(15, 0, 0);
                                SuggestMoveWhite(17, 7, 7);
                            }
                            else if (IsWhite == false && Game1.WhosTurn() == false)
                            {
                                //Visar alla möjliga drag för svart
                                SuggestMoveBlack(-15, 7, 7);
                                SuggestMoveBlack(-17, 0, 0);
                                SuggestMoveBlack(-6, 6, 7);
                                SuggestMoveBlack(-10, 1, 0);
                                SuggestMoveBlack(10, 6, 7);
                                SuggestMoveBlack(6, 1, 0);
                                SuggestMoveBlack(15, 0, 0);
                                SuggestMoveBlack(17, 7, 7);
                            }
                        }
                    }
                }
                else if (mousestate.LeftButton != ButtonState.Pressed)
                {
                    changemousestate = true;
                }
            }
            return true;
        }
        public override void Draw(SpriteBatch spriteBatch)
        {
            if (captured == false)   //Stänger av draw om pjäsen är fångad
            {
                spriteBatch.Draw(gfx_pieces, destinationRect, drawRect, Color.White, angle, middle, SpriteEffects.None, 0.3f);
                for (int i = 0; i < dotrectangle.Count; i++)
                {
                    spriteBatch.Draw(gfx_dot, dotrectangle[i], null, Color.White * 0.5f, angle, middle, SpriteEffects.None, 0.4f);
                }
            }
        }
        public void MoveWhite(int position, int row, int rowbeside)     //Metod för att kolla om ett drag är möjligt för vit
        {
            if (Game1.Tileposition(currentposition + position).Contains(mousePosition) && Game1.TileInfo(currentposition + position) <= 0 && currentposition % 8 != row && currentposition % 8 != rowbeside)
            {
                if (Game1.TileInfo(currentposition + position) == 0)
                {
                    sfx_move.Play();
                }
                else
                {
                    sfx_capture.Play();
                }
                Game1.ChangeTileInfo(currentposition, 0);
                currentposition += position;
                destinationRect = Game1.Tileposition(currentposition);
                PieceSelected = false;
                Game1.ChangeTileInfo(currentposition, Piecenumber);
                dotrectangle.Clear();
                Game1.ChangeTurn();
            }
        }
        public void MoveBlack(int position, int row, int rowbeside)     //Metod för att kolla om ett drag är möjligt för svart
        {
            if (Game1.Tileposition(currentposition + position).Contains(mousePosition) && Game1.TileInfo(currentposition + position) >= 0 && currentposition % 8 != row && currentposition % 8 != rowbeside)
            {
                if (Game1.TileInfo(currentposition + position) == 0)
                {
                    sfx_move.Play();
                }
                else
                {
                    sfx_capture.Play();
                }
                Game1.ChangeTileInfo(currentposition, 0);
                currentposition += position;
                destinationRect = Game1.Tileposition(currentposition);
                PieceSelected = false;
                Game1.ChangeTileInfo(currentposition, Piecenumber);
                dotrectangle.Clear();
                Game1.ChangeTurn();
            }
        }
        public void SuggestMoveWhite(int position, int row, int rowbeside)    //Visar alla möjliga drag för vit
        {
            if (Game1.TileInfo(currentposition + position) <= 0 && currentposition % 8 != row && currentposition % 8 != rowbeside)
            {
                dotrectangle.Add(Game1.Tileposition(currentposition + position));
            }
        }
        public void SuggestMoveBlack(int position, int row, int rowbeside)    //Visar alla möjliga drag för svart
        {
            if (Game1.TileInfo(currentposition + position) >= 0 && currentposition % 8 != row && currentposition % 8 != rowbeside)
            {
                dotrectangle.Add(Game1.Tileposition(currentposition + position));
            }
        }
    }
}
