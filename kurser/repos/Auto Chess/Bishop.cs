using AdventureGame;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using SharpDX.Direct2D1.Effects;
using Microsoft.Xna.Framework.Audio;

namespace Auto_Chess
{
    internal class Bishop : Pieces
    {
        public Bishop(int startingposition, int Piecenumber) : base(startingposition, Piecenumber)
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
                drawRect = new Rectangle(4 * gfx_pieces.Width / 6, gfx_pieces.Height / 2, gfx_pieces.Width / 6, gfx_pieces.Height / 2);
                IsWhite = true;
                Game1.ChangeTileInfo(currentposition, Piecenumber);
            }
            else   //Pjäsen är svart om Piecenumber är negativt
            {
                drawRect = new Rectangle(4 * gfx_pieces.Width / 6, 0, gfx_pieces.Width / 6, gfx_pieces.Height / 2);
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
                            MoveWhite(9, 0);
                            MoveWhite(7, 7);
                            MoveWhite(-7, 0);
                            MoveWhite(-9, 7);
                        }
                        else if (IsWhite == false && Game1.WhosTurn() == false)
                        {
                            //Kollar om ett move är möjligt för svart
                            MoveBlack(9, 0);
                            MoveBlack(7, 7);
                            MoveBlack(-7, 0);
                            MoveBlack(-9, 7);
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
                                SuggestMoveWhite(9, 0);
                                SuggestMoveWhite(7, 7);
                                SuggestMoveWhite(-7, 0);
                                SuggestMoveWhite(-9, 7);
                            }
                            else if (IsWhite == false && Game1.WhosTurn() == false)
                            {
                                //Visar alla möjliga drag för svart
                                SuggestMoveBlack(9, 0);
                                SuggestMoveBlack(7, 7);
                                SuggestMoveBlack(-7, 0);
                                SuggestMoveBlack(-9, 7);
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
        public void MoveWhite(int position, int row)     //Metod för att kolla om ett drag är möjligt för vit
        {
            for (int i = 1; i < 8; i++)
            {
                if (Game1.TileInfo(currentposition + position * i) == 0 && (currentposition + position * i) % 8 != row)
                {
                    if (Game1.Tileposition(currentposition + position * i).Contains(mousePosition))
                    {
                        if (Game1.TileInfo(currentposition + position * i) == 0)
                        {
                            sfx_move.Play();
                        }
                        else
                        {
                            sfx_capture.Play();
                        }
                        Game1.ChangeTileInfo(currentposition, 0);
                        currentposition += position * i;
                        destinationRect = Game1.Tileposition(currentposition);
                        PieceSelected = false;
                        Game1.ChangeTileInfo(currentposition, Piecenumber);
                        dotrectangle.Clear();
                        Game1.ChangeTurn();
                        break;
                    }
                }
                else if (Game1.TileInfo(currentposition + position * i) <= -1 && (currentposition + position * i) % 8 != row)
                {
                    if (Game1.Tileposition(currentposition + position * i).Contains(mousePosition))
                    {
                        if (Game1.TileInfo(currentposition + position * i) == 0)
                        {
                            sfx_move.Play();
                        }
                        else
                        {
                            sfx_capture.Play();
                        }
                        Game1.ChangeTileInfo(currentposition, 0);
                        currentposition += position * i;
                        destinationRect = Game1.Tileposition(currentposition);
                        PieceSelected = false;
                        Game1.ChangeTileInfo(currentposition, Piecenumber);
                        dotrectangle.Clear();
                        Game1.ChangeTurn();
                    }
                    break;
                }
                else
                {
                    break;
                }
            }
        }
        public void MoveBlack(int position, int row)     //Metod för att kolla om ett drag är möjligt för svart
        {
            for (int i = 1; i < 8; i++)
            {
                if (Game1.TileInfo(currentposition + position * i) == 0 && (currentposition + position * i) % 8 != row)
                {
                    if (Game1.Tileposition(currentposition + position * i).Contains(mousePosition))
                    {
                        if (Game1.TileInfo(currentposition + position * i) == 0)
                        {
                            sfx_move.Play();
                        }
                        else
                        {
                            sfx_capture.Play();
                        }
                        Game1.ChangeTileInfo(currentposition, 0);
                        currentposition += position * i;
                        destinationRect = Game1.Tileposition(currentposition);
                        PieceSelected = false;
                        Game1.ChangeTileInfo(currentposition, Piecenumber);
                        dotrectangle.Clear();
                        Game1.ChangeTurn();
                        break;
                    }
                }
                else if (Game1.TileInfo(currentposition + position * i) >= 1 && (currentposition + position * i) % 8 != row)
                {
                    if (Game1.Tileposition(currentposition + position * i).Contains(mousePosition))
                    {
                        if (Game1.TileInfo(currentposition + position * i) == 0)
                        {
                            sfx_move.Play();
                        }
                        else
                        {
                            sfx_capture.Play();
                        }
                        Game1.ChangeTileInfo(currentposition, 0);
                        currentposition += position * i;
                        destinationRect = Game1.Tileposition(currentposition);
                        PieceSelected = false;
                        Game1.ChangeTileInfo(currentposition, Piecenumber);
                        dotrectangle.Clear();
                        Game1.ChangeTurn();
                    }
                    break;
                }
                else
                {
                    break;
                }
            }
        }
        public void SuggestMoveWhite(int position, int row)    //Visar alla möjliga drag för vit
        {
            for (int i = 1; i < 8; i++)
            {
                if (Game1.TileInfo(currentposition + position * i) == 0 && (currentposition + position * i) % 8 != row)
                {
                    dotrectangle.Add(Game1.Tileposition(currentposition + position * i));
                }
                else if (Game1.TileInfo(currentposition + position * i) <= -1 && (currentposition + position * i) % 8 != row)
                {
                    dotrectangle.Add(Game1.Tileposition(currentposition + position * i));
                    break;
                }
                else
                {
                    break;
                }
            }
        }
        public void SuggestMoveBlack(int position, int row)    //Visar alla möjliga drag för svart
        {
            for (int i = 1; i < 8; i++)
            {
                if (Game1.TileInfo(currentposition + position * i) == 0 && (currentposition + position * i) % 8 != row)
                {
                    dotrectangle.Add(Game1.Tileposition(currentposition + position * i));
                }
                else if (Game1.TileInfo(currentposition + position * i) >= 1 && (currentposition + position * i) % 8 != row)
                {
                    dotrectangle.Add(Game1.Tileposition(currentposition + position * i));
                    break;
                }
                else
                {
                    break;
                }
            }
        }
    }
}
