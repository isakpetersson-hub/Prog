using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;

namespace AdventureGame
{
    public class Game1 : Game
    {
        static int screenWidth = 1024;
        static int screenHeight = 768;
        private GraphicsDeviceManager _graphics;
        private SpriteBatch _spriteBatch;

        
        Player player;
        SpriteFont myFont;

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

            player = new Player(new Vector2(800, 600), Color.Wheat);

            base.Initialize();
        }

        protected override void LoadContent()
        {
            _spriteBatch = new SpriteBatch(GraphicsDevice);
            player.LoadContent(Content);
            myFont = Content.Load<SpriteFont>("MenuFont");
            TileEngine.LoadLevel(Content, "karta32.tmx", "tilemap32", new Vector2(0, 0));

            Level.LoadSounds(Content);
        }

        protected override void Update(GameTime gameTime)
        {
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
                Exit();

            player.Update(gameTime);
            TileEngine.UpdateCamera(player.Getpostion());

            base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime)
        {
            GraphicsDevice.Clear(Color.CornflowerBlue);

            _spriteBatch.Begin(SpriteSortMode.BackToFront);
            TileEngine.Draw(_spriteBatch);
            player.Draw(_spriteBatch);
            _spriteBatch.End();

            base.Draw(gameTime);
        }
        public static int ScreenWidth()
        {
            return screenWidth;
        }
        public static int ScreenHeight()
        {
            return screenHeight;
        }
    }
}