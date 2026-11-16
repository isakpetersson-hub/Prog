using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Audio;

namespace MeatballSimulator
{
    public class Game1 : Game
    {
        private GraphicsDeviceManager _graphics;
        private SpriteBatch _spriteBatch;

        public static Vector2 screenSize = new Vector2(1366, 768);

        Meatball[] meatballs = new Meatball[10];
 
        public Game1()  // Konstruktor, Anropas först!
        {
            _graphics = new GraphicsDeviceManager(this);
            Content.RootDirectory = "Content";
            IsMouseVisible = false;
            _graphics.IsFullScreen = false;
        }

        protected override void Initialize()  // Körs automatiskt efter Game1
        {
            _graphics.PreferredBackBufferWidth = (int)screenSize.X;
            _graphics.PreferredBackBufferHeight = (int)screenSize.Y;
            _graphics.ApplyChanges();
            for (int i = 0; i < meatballs.Length; i++)
                meatballs[i] = new Meatball();

            base.Initialize();
        }

        protected override void LoadContent()
        {
            _spriteBatch = new SpriteBatch(GraphicsDevice);

            for (int i = 0; i < meatballs.Length; i++)
                meatballs[i].LoadContent(Content);


        }

        protected override void Update(GameTime gameTime)  // Körs efter LoadContent.. flera gånger!
        {
            if (GamePad.GetState(PlayerIndex.One).Buttons.Back == ButtonState.Pressed || Keyboard.GetState().IsKeyDown(Keys.Escape))
                Exit();

            //leif.Update(gameTime);
            for (int i = 0; i < meatballs.Length; i++)
                meatballs[i].Update(gameTime);

                base.Update(gameTime);
        }

        protected override void Draw(GameTime gameTime) // Körs efter LoadContent, flera gånger.
        {
            GraphicsDevice.Clear(Color.CornflowerBlue);

            _spriteBatch.Begin();

            for (int i = 0; i < meatballs.Length; i++)
                meatballs[i].Draw(_spriteBatch);

                _spriteBatch.End();

            base.Draw(gameTime);
        }
    }
}