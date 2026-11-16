using AdventureGame;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using SharpDX.Direct2D1.Effects;
using System;
using Microsoft.Xna.Framework.Audio;

namespace Auto_Chess
{
    internal class Pawn : Pieces
    {
        public bool IsEnPassant = false;
        private bool PieceHasMoved = false;


        public Pawn(int startingposition,int Piecenumber) : base(startingposition, Piecenumber)
        {
            currentposition = startingposition;
            destinationRect = Game1.Tileposition(currentposition);
        }
        public override void Initalize(Texture2D gfx_pieces_array, Texture2D gfx_dot_image, SoundEffect sfx_piecemove, SoundEffect sfx_caputre)
        {
            gfx_pieces = gfx_pieces_array;
            gfx_dot = gfx_dot_image;
            sfx_move = sfx_piecemove;
            sfx_capture = sfx_caputre;
            if (Piecenumber >= 1) //Pjäsen är vit om Piecenumber är positivt
            {
                drawRect = new Rectangle(5 * gfx_pieces.Width / 6, gfx_pieces.Height / 2, gfx_pieces.Width / 6, gfx_pieces.Height / 2);
                IsWhite = true;
                Game1.ChangeTileInfo(currentposition, Piecenumber);
            }
            else   //Pjäsen är svart om Piecenumber är negativt
            {
                drawRect = new Rectangle(5 * gfx_pieces.Width / 6, 0, gfx_pieces.Width / 6, gfx_pieces.Height / 2);
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
            if ((currentposition <= 7 || currentposition >= 56) && captured == false)
            {
                Game1.ChangeTurn();
                Game1.Promotion(currentposition, Piecenumber);
                captured = true;
            }
            if (captured == false)  //Stänger av Update om pjäsen är fångad
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
                            //Kollar om ett drag är möjligt för vit
                            if (Game1.Tileposition(currentposition - 8).Contains(mousePosition) && Game1.TileInfo(currentposition - 8) == 0)
                            {
                                Move(-8);
                            }
                            if (PieceHasMoved == false && Game1.Tileposition(currentposition - 16).Contains(mousePosition) && Game1.TileInfo(currentposition - 16) == 0 && Game1.TileInfo(currentposition - 8) == 0)
                            {
                                IsEnPassant = true;
                                Move(-16);
                            }
                            if (Game1.Tileposition(currentposition - 7).Contains(mousePosition) && Game1.TileInfo(currentposition - 7) <= -1 && currentposition % 8 != 7)
                            {
                                Move(-7);
                            }
                            if (Game1.Tileposition(currentposition - 9).Contains(mousePosition) && Game1.TileInfo(currentposition - 9) <= -1 && currentposition % 8 != 0)
                            {
                                Move(-9);
                            }
                            if ((Game1.Tileposition(currentposition - 9).Contains(mousePosition) && Game1.TileInfo(currentposition - 1) <= -1) && Game1.IsEnPassant(Game1.TileInfo(currentposition-1)) == true && currentposition % 8 != 0)
                            {
                                Move(-9);
                                Game1.ChangeTileInfo(currentposition + 8, 0);
                            }
                            if ((Game1.Tileposition(currentposition - 7).Contains(mousePosition) && Game1.TileInfo(currentposition + 1) <= -1) && Game1.IsEnPassant(Game1.TileInfo(currentposition + 1)) == true && currentposition % 8 != 7)
                            {
                                Move(-7);
                                Game1.ChangeTileInfo(currentposition + 8, 0);
                            }
                        }
                        else if(IsWhite == false && Game1.WhosTurn() == false)
                        {
                            //Kollar om ett drag är möjligt för svart
                            if (Game1.Tileposition(currentposition + 8).Contains(mousePosition) && Game1.TileInfo(currentposition + 8) == 0)
                            {
                                Move(8);
                            }
                            if (PieceHasMoved == false && Game1.Tileposition(currentposition + 16).Contains(mousePosition) && Game1.TileInfo(currentposition + 16) == 0 && Game1.TileInfo(currentposition + 8) == 0)
                            {
                                IsEnPassant = true;
                                Move(16);
                            }
                            if (Game1.Tileposition(currentposition + 7).Contains(mousePosition) && Game1.TileInfo(currentposition + 7) >= 1 && currentposition % 8 != 0)
                            {
                                Move(7);
                            }
                            if (Game1.Tileposition(currentposition + 9).Contains(mousePosition) && Game1.TileInfo(currentposition + 9) >= 1 && currentposition % 8 != 7)
                            {
                                Move(9);
                            }
                            if ((Game1.Tileposition(currentposition + 9).Contains(mousePosition) && Game1.TileInfo(currentposition + 1) >= 1) && Game1.IsEnPassant(Game1.TileInfo(currentposition + 1)) == true && currentposition % 8 != 7)
                            {
                                Move(9);
                                Game1.ChangeTileInfo(currentposition - 8, 0);
                            }
                            if ((Game1.Tileposition(currentposition + 7).Contains(mousePosition) && Game1.TileInfo(currentposition - 1) >= 1) && Game1.IsEnPassant(Game1.TileInfo(currentposition - 1)) == true && currentposition % 8 != 0)
                            {
                                Move(7);
                                Game1.ChangeTileInfo(currentposition - 8, 0);
                            }
                        }
                        if(destinationRect.Contains(mousePosition) == false)
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
                                if (Game1.TileInfo(currentposition - 8) == 0)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition - 8));
                                }
                                if (PieceHasMoved == false && Game1.TileInfo(currentposition - 16) == 0 && Game1.TileInfo(currentposition - 8) == 0)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition - 16));
                                }
                                if (Game1.TileInfo(currentposition - 7) <= -1 && currentposition % 8 != 7)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition - 7));
                                }
                                if (Game1.TileInfo(currentposition - 9) <= -1 && currentposition % 8 != 0)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition - 9));
                                }
                                if ((Game1.TileInfo(currentposition - 1) <= -1) && Game1.IsEnPassant(Game1.TileInfo(currentposition - 1)) == true && currentposition % 8 != 0)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition - 9));
                                }
                                if ((Game1.TileInfo(currentposition + 1) <= -1) && Game1.IsEnPassant(Game1.TileInfo(currentposition + 1)) == true && currentposition % 8 != 7)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition - 7));
                                }
                            }
                            else if (IsWhite == false && Game1.WhosTurn() == false)
                            {
                                //Visar alla möjliga drag för svart
                                if (Game1.TileInfo(currentposition + 8) == 0)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition + 8));
                                }
                                if (PieceHasMoved == false && Game1.TileInfo(currentposition + 16) == 0 && Game1.TileInfo(currentposition + 8) == 0)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition + 16));
                                }
                                if (Game1.TileInfo(currentposition + 7) >= 1 && currentposition % 8 != 0)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition + 7));
                                }
                                if (Game1.TileInfo(currentposition + 9) >= 1 && currentposition % 8 != 7)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition + 9));
                                }
                                if ((Game1.TileInfo(currentposition + 1) >= 1) && Game1.IsEnPassant(Game1.TileInfo(currentposition + 1)) == true && currentposition % 8 != 7)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition + 9));
                                }
                                if ((Game1.TileInfo(currentposition - 1) >= 1) && Game1.IsEnPassant(Game1.TileInfo(currentposition - 1)) == true && currentposition % 8 != 0)
                                {
                                    dotrectangle.Add(Game1.Tileposition(currentposition + 7));
                                }
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
            if (captured == false)  //Stänger av draw om pjäsen är fångad
            {
                spriteBatch.Draw(gfx_pieces, destinationRect, drawRect, Color.White, angle, middle, SpriteEffects.None, 0.3f);
                for (int i = 0; i < dotrectangle.Count; i++)
                {
                    spriteBatch.Draw(gfx_dot, dotrectangle[i], null, Color.White*0.5f, angle, middle,SpriteEffects.None, 0.4f);
                }
            }
        }
        private void Move(int position)     //Metod för att kolla om ett drag är möjligt
        {
            if (position == 8 || position == 16 || position == -8 || position == -16)
            {
                sfx_move.Play();
            }
            else
            {
                sfx_capture.Play();
            }
            Game1.ChangeTileInfo(currentposition, 0);
            currentposition += position;
            PieceHasMoved = true;
            destinationRect = Game1.Tileposition(currentposition);
            PieceSelected = false;
            Game1.ChangeTileInfo(currentposition, Piecenumber);
            dotrectangle.Clear();
            Game1.ChangeTurn();
        }
    }
}
