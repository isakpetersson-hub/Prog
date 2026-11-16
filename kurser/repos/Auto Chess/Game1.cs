using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Audio;
using System;

namespace Auto_Chess
{
    public class Game1 : Game
    {
        private static int screenWidth = 830;     //Sätter storlek på skärmen
        private static int screenHeight = 830;      //Sätter storlek på skrämen
        private static int currentposition;      //Håller koll på vilken rectangle pjäsen är på
        private static int piecenumber;      //Ett unikt nummer för varje pjäs
        private static int queennumber = 2;      //Antal queens
        private static int rooknumber = 4;      //Antal Rooks
        private static int bishopnumber = 4;      //Antal Bishops
        private static int horsenumber = 4;      //Antal Horses
        private static int[] Boardstatus = new int[64];      //En array som säger vad som står på varje recangle -1 = är black 0 = tom 1 = vit
        private static Pawn[] pawn = new Pawn[16];     //Array med alla pawns
        private static Rook[] rook = new Rook[20];     //Array med alla rooks
        private static Knight[] knight = new Knight[20];       //Array med alla Knights
        private static Bishop[] bishop = new Bishop[20];     //Array med alla Bishops
        private static Queen[] queen = new Queen[18];      //Array med alla Queens har upp tll 18 för promotions
        private static King[] king = new King[2];      //Array med båda kings
        private static Rectangle[] Tiles = new Rectangle[64];      //Array med alla rutors rectangle som ger position
        private static Rectangle[] promotion_tile = new Rectangle[5];      //Används under promotion för att klicka på
        private static bool Turn = true;      //Håller koll på vems tur det är true = vit false = svart
        private static bool promotion = false;      //Håller koll om en promotion är pågång
        private static bool changemousestate = false;      //Håller koll så du klickar flera gånger på samma ställe
        private static bool gameover;      //Stänger av spelet när kungen blir fångad
        private static bool gameover_black;      //Samma fast den om svart vinner
        private static Vector2 promotion_position;      //Sätter ut promotion rutan på rätt ställe
        private static MouseState mousestate;      //Använder för att kunna klicka
        private static Point mousePosition;
        private static GraphicsDeviceManager _graphics;
        private static SpriteBatch _spriteBatch;
        private static Texture2D gfx_chessboard;
        private static Texture2D gfx_pieces;
        private static Texture2D gfx_dot;
        private static Texture2D gfx_promotion;
        private static Texture2D gfx_promotion_black;
        private static SoundEffect sfx_move;
        private static SoundEffect sfx_capture;
        private static SpriteFont myFont;

        public Game1()
        {
            _graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
            IsMouseVisible = true;
            _graphics.PreferredBackBufferWidth = screenWidth;
            _graphics.PreferredBackBufferHeight = screenHeight;
            _graphics.ApplyChanges();
        }

        protected override void Initialize()
        {
            for (int x = 0; x < 8; x++)
            {
                for (int y = 0; y < 8; y++)
                {
                    Boardstatus[x + (y * 8)] = 0;
                }
            }
            base.Initialize();
        }

        protected override void LoadContent()
        {
            myFont = Content.Load<SpriteFont>("MenuFont");
            _spriteBatch = new SpriteBatch(GraphicsDevice);
            gfx_chessboard = Content.Load<Texture2D>("chessboard");
            gfx_dot = Content.Load<Texture2D>("dot");
            gfx_pieces = Content.Load<Texture2D>("ChessPiecesArray");
            gfx_promotion = Content.Load<Texture2D>("promotion");
            gfx_promotion_black = Content.Load<Texture2D>("promotion_black");
            sfx_move = Content.Load<SoundEffect>("move-self");
            sfx_capture = Content.Load<SoundEffect>("capture");
            for (int x = 0; x < 8; x++)
            {
                for (int y = 0; y < 8; y++)
                {
                    Tiles[x + (y * 8)] = new Rectangle(x * gfx_chessboard.Width / 8, y * gfx_chessboard.Height / 8, gfx_chessboard.Width / 8, gfx_chessboard.Height / 8);
                }
            }
            promotion_tile[4] = new Rectangle(400, 0, 50, 100);
            for (int i = 0; i < 16; i++)
            {
                if (i < 8)
                {
                    pawn[i] = new Pawn(48 + i, i+1);
                }
                if (i >= 8)
                {
                    pawn[i] = new Pawn(i, i-16);
                }
            }

            for (int i = 0; i < 16; i++)
            {
                pawn[i].Initalize(gfx_pieces, gfx_dot,sfx_move,sfx_capture);
            }
            rook[0] = new Rook(56, 9);
            rook[1] = new Rook(63, 10);
            rook[2] = new Rook(0, -9);
            rook[3] = new Rook(7, -10);

            knight[0] = new Knight(57, 11);
            knight[1] = new Knight(62, 12);
            knight[2] = new Knight(1, -11);
            knight[3] = new Knight(6, -12);

            bishop[0] = new Bishop(58, 13);
            bishop[1] = new Bishop(61, 14);
            bishop[2] = new Bishop(2, -13);
            bishop[3] = new Bishop(5, -14);

            for (int i = 0; i < 4; i++)
            {
                rook[i].Initalize(gfx_pieces, gfx_dot, sfx_move, sfx_capture);
                knight[i].Initalize(gfx_pieces, gfx_dot, sfx_move, sfx_capture);
                bishop[i].Initalize(gfx_pieces, gfx_dot, sfx_move, sfx_capture);
            }
            queen[0] = new Queen(59, 15);
            queen[1] = new Queen(3, -15);
            king[0] = new King(60, 16);
            king[1] = new King(4, -16);
            for (int i = 0; i < 2; i++)
            {
                queen[i].Initalize(gfx_pieces, gfx_dot, sfx_move, sfx_capture);
                king[i].Initalize(gfx_pieces, gfx_dot, sfx_move, sfx_capture);
            }
        }

        protected override void Update(GameTime gameTime)
        {
            if (gameover == false && gameover_black == false) //Stänger av hela spelet när någon vinner
            {
                if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
                    Exit();
                for (int i = 0; i < 16; i++)
                {
                    pawn[i].Update(gameTime);
                }
                for (int i = 0; i < rooknumber; i++)
                {
                    rook[i].Update(gameTime);
                }
                for (int i = 0; i < bishopnumber; i++)
                {
                    bishop[i].Update(gameTime);
                }
                for (int i = 0; i < horsenumber; i++)
                {
                    knight[i].Update(gameTime);
                }
                for (int i = 0; i < queennumber; i++)
                {
                    queen[i].Update(gameTime);
                }
                for (int i = 0; i < 2; i++)
                {
                    king[i].Update(gameTime);
                }
                if (promotion == true)
                {
                    CheckPromotion();
                }
                Draw(gameTime);


                base.Update(gameTime);
            }
        }

        protected override void Draw(GameTime gameTime)
        {
            _spriteBatch.Begin();
            _spriteBatch.Draw(gfx_chessboard, new Vector2(0, 0),null, Color.White);
            for (int i = 0; i < 16; i++)
            {
                pawn[i].Draw(_spriteBatch);
            }
            for (int i = 0; i < rooknumber; i++)
            {
                rook[i].Draw(_spriteBatch);
            }
            for (int i = 0; i < bishopnumber; i++)
            {
                bishop[i].Draw(_spriteBatch);
            }
            for (int i = 0; i < horsenumber; i++)
            {
                knight[i].Draw(_spriteBatch);
            }
            for (int i = 0; i < queennumber; i++)
            {
                queen[i].Draw(_spriteBatch);
            }
            for (int i = 0; i < 2; i++)
            {
                king[i].Draw(_spriteBatch);
            }
            if (promotion == true)
            {
                if(piecenumber >= 1)
                {
                    _spriteBatch.Draw(gfx_promotion, promotion_position, null, Color.White);
                }
                else if(piecenumber <= -1)
                {
                    _spriteBatch.Draw(gfx_promotion_black, promotion_position, null, Color.White);
                }
            }
            if(gameover == true)
            {
                _spriteBatch.DrawString(myFont, "GAME OVER White Wins", new Vector2(150, 375), Color.Gray);
            }
            if(gameover_black == true)
            {
                _spriteBatch.DrawString(myFont, "GAME OVER Black Wins", new Vector2(150, 375), Color.Gray);
            }
            _spriteBatch.End();
            base.Draw(gameTime);
        }
        public static Rectangle Tileposition(int tile) //Returnar Rectanglen för det nummret som skickas in
        {
            if (tile >= 0 && tile <= 63)
            {
                return Tiles[tile];
            }
            else
            {
                return new Rectangle(0, 0, 0, 0);
            }
        }
        public static int TileInfo(int tile)      //Retunerar vad som finns på rutan för det nummer som kommer in
        {
            if (tile >= 0 && tile <= 63)
            {
                return Boardstatus[tile];
            }
            else
            {
                return 0;
            }
        }
        public static void ChangeTileInfo(int tile, int value)      //Ändar värde på Boardstatus
        {
            Boardstatus[tile] = value;   
        }
        public static void ChangeTurn()      //Ändrar vems tur det är och tar bort IsEnPassant för alla pawns
        {
            Turn = !Turn;
            if (Turn == true)
            {
                for (int i = 0; i < 8; i++)
                {
                    pawn[i].IsEnPassant = false;
                }
            }
            else
            {
                for (int i = 8; i < 16; i++)
                {
                    pawn[i].IsEnPassant = false;
                }
            }
        }
        public static bool WhosTurn()      //Retunerar vems tur det är
        {
            return Turn;
        }
        public static bool IsEnPassant(int Piece)      //Kollar om en pawn kan En Passantas
        {  
                if (Piece > 0)
                {
                    Piece--;
                }
                if (Piece < 0)
                {
                    Piece = Piece + 16;
                }
            return pawn[Piece].IsEnPassant;
        }
        public static bool Rookhasmoved(int piecenumber) //Kollar om en rook har flyttas
        {
            return rook[piecenumber].PieceHasMoved;
        }
        public static void MoveRook(int piecenumber, int position)      //Flyttar på en rook denna och förra användes vid casteling
        {
            rook[piecenumber].Move(position);
        }
        public static void Promotion(int currentpoition,int piece_number)      //Aktiveras när en pawn kommer till slutet och ritar ut en rutan 
        {
            promotion = true;
            currentposition = currentpoition;
            piecenumber = piece_number;
            promotion_position.X = Tileposition(currentpoition).X;
            promotion_position.Y = Tileposition(currentpoition).Y;
            if (piecenumber <= -1)
            {
                promotion_position.Y -= 340;
            }
            if (piecenumber >= 1)
            {
                for (int i = 0; i < promotion_tile.Length - 1; i++)
                {
                    promotion_tile[i] = new Rectangle(0, 100 * i, 100, 100);
                }
            }
            else if (piecenumber <= -1)
            {
                for (int i = 0; i < promotion_tile.Length; i++)
                {
                    promotion_tile[i] = new Rectangle(0,-100*i,100,100);
                }
            }
            if(piecenumber >= 1)
            {
                for (int i = 0; i < 5; i++)
                {
                    promotion_tile[i].X += Tileposition(currentposition).X;
                    promotion_tile[i].Y += Tileposition(currentposition).Y;
                }
            }
            else if(piecenumber <= -1)
            {
                for (int i = 0; i < 5; i++)
                {
                    {
                        promotion_tile[i].X += Tileposition(currentposition).X;
                        promotion_tile[i].Y += Tileposition(currentposition).Y;
                    }
                }
            }
        }
        public static void CheckPromotion()      //Kollar om man trycker på promotion rutan
        {
            mousestate = Mouse.GetState();
            mousePosition = new Point(mousestate.X, mousestate.Y);
            if (mousestate.LeftButton == ButtonState.Pressed && changemousestate == true)
            {
                changemousestate = false;
                if (promotion_tile[0].Contains(mousePosition))
                {
                    queen[queennumber] = new Queen(currentposition, piecenumber);
                    queen[queennumber].Initalize(gfx_pieces, gfx_dot, sfx_move, sfx_capture);
                    queennumber++;
                    promotion = false;
                    ChangeTurn();
                }
                else if (promotion_tile[1].Contains(mousePosition))
                {
                    knight[horsenumber] = new Knight(currentposition, piecenumber);
                    knight[horsenumber].Initalize(gfx_pieces, gfx_dot, sfx_move, sfx_capture);
                    horsenumber++;
                    promotion = false;
                    ChangeTurn();
                }
                else if (promotion_tile[2].Contains(mousePosition))
                {
                    rook[rooknumber] = new Rook(currentposition, piecenumber);
                    rook[rooknumber].Initalize(gfx_pieces, gfx_dot, sfx_move, sfx_capture);
                    rooknumber++;
                    promotion = false;
                    ChangeTurn();
                }
                else if (promotion_tile[3].Contains(mousePosition))
                {
                    bishop[bishopnumber] = new Bishop(currentposition, piecenumber);
                    bishop[bishopnumber].Initalize(gfx_pieces, gfx_dot, sfx_move, sfx_capture);
                    bishopnumber++;
                    promotion = false;
                    ChangeTurn();
                }
                else if (promotion_tile[4].Contains(mousePosition))
                {

                }
            }
            else if(mousestate.LeftButton != ButtonState.Pressed)
            {
                changemousestate = true;
            }
        }
        public static void GameOver(int piecenumber)      //Kollar vem som vann
        {
            if (piecenumber == -16)
            {
                gameover = true;
            }
            else if (piecenumber == 16)
            {
                gameover_black = true;
            }
        }
    }
}