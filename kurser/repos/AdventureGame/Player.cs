using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using Microsoft.Xna.Framework.Audio;
using System.Collections.Generic;


namespace AdventureGame
{
    internal class Player : AnimatedObject 
    {
        private static MouseState mousestate; 
        int maxSpeed = 100;
        int currentTileType = 0;
        Vector2 feet;
        SoundEffect[] sfx_walk = new SoundEffect[5];
        SoundEffectInstance walkSfxInstance;
        private static List<string> inventory = new List<string>();
        enum figureState
        {
            standing,
            walking
        };
        figureState currentState;

        enum directionframe
        {
            walkDown = 48,
            walkleft = 40,
            walkright = 32,
            walkup = 56
        };
        directionframe faceing;
        public Player(Vector2 position, Color primaryColor, float scale = 1, float angle = 0, float alpha = 1) : base(position, primaryColor, scale, angle, alpha)
        {
            spriteSize = new Vector2(160, 160);
            drawRect = new Rectangle(0, 0, (int)spriteSize.X, (int)spriteSize.Y);
        }

        public override void LoadContent(ContentManager Content)
        {
            gfx_player1 = Content.Load<Texture2D>("Player1");
            middle = new Vector2(gfx_player1.Width / 16, gfx_player1.Height / 80);
            feet = new Vector2(0, middle.Y);
            sfx_walk[0] = Content.Load<SoundEffect>("Steps_Sand");
            sfx_walk[1] = Content.Load<SoundEffect>("Steps_Grass");
            sfx_walk[2] = Content.Load<SoundEffect>("Steps_ShallowWater");
            sfx_walk[3] = Content.Load<SoundEffect>("Steps_Wood");
            sfx_walk[4] = Content.Load<SoundEffect>("Steps_Stone");
            walkSfxInstance = sfx_walk[0].CreateInstance();
            walkSfxInstance.IsLooped = true;
            currentTileType = 0;
            framesInRow = 8;
            faceing = directionframe.walkDown;
            animSpeed = 100;
            animTimer = 0;
            int[] values = {
                1, 2, 3, 0, 0, 0, 0, 0,
                9, 10, 11, 8, 0, 0, 0, 0, 
                17, 18, 19, 16, 0, 0, 0, 0, 
                25, 26, 27, 24, 0, 0, 0, 0, 
                33, 34, 35, 36, 37, 38, 39, 32,
                41, 42, 43, 44, 45, 46, 47, 40,
                49, 50, 51, 52, 53, 54, 55, 48,
                57, 58, 59, 60, 61 ,62, 63, 56,
                65, 66, 67, 68, 69, 70, 71, 64,
                73, 74, 75, 76, 77, 78, 79, 72,
                81, 82, 83, 84, 85, 86, 87, 80,
                89, 90, 91, 92, 93, 94, 95, 88,
                97, 98, 99, 100, 101, 96, 0, 0,
                105, 106, 107, 108, 109, 104, 0, 0,
                113, 114, 115, 116, 117, 112, 0, 0,
                121, 122, 123, 124, 125, 120, 0, 0,
                129, 130, 131, 132, 133, 128, 0, 0,
                137, 138, 139, 136, 0, 0, 0, 0,
                145, 146, 147, 144, 0, 0, 0, 0,
                153, 154, 155, 152, 0, 0, 0, 0,
                161, 162, 163, 160, 0, 0, 0, 0,
                169, 170, 171, 172, 173, 168, 0, 0,
                177, 178, 179, 180, 181, 176, 0, 0,
                185, 186, 187, 188, 189, 184, 0, 0,
                193, 194, 195, 196, 197, 192, 0, 0,
            };

            for (int i = 0; i < values.Length; i++)
            {
                animSequence[i] = values[i];
            }

        }

        public override bool Update(GameTime gameTime)
        {
            mousestate = Mouse.GetState();
            directionframe newDirection = directionframe.walkDown;
            KeyboardState keyboardState = Keyboard.GetState();

            speed = Vector2.Zero;

            if (keyboardState.IsKeyDown(Keys.W))
            {
                speed.Y -= 1;
                newDirection = directionframe.walkup;
            }

            if (keyboardState.IsKeyDown(Keys.S))
            {
                speed.Y += 1;
                newDirection = directionframe.walkDown;

            }

            if (keyboardState.IsKeyDown(Keys.A))
            {
                speed.X -= 1;
                newDirection = directionframe.walkleft;

            }
            if (keyboardState.IsKeyDown(Keys.D))
            {
                speed.X += 1;
                newDirection = directionframe.walkright;
            }
            if (speed.Length() > 0) 
            {
                if (faceing != newDirection)
                {
                    faceing = newDirection;
                    currentFrame = (int)faceing;
                    SetFrame(currentFrame);

                }
                if (currentState == figureState.standing)
                {
                    currentState = figureState.walking; 
                    walkSfxInstance.Play();
                }
            }
            else 
            {
                if (currentState == figureState.walking) 
                {
                    walkSfxInstance.Pause();
                    currentState = figureState.standing; 
                    currentFrame = (int)faceing;
                    SetFrame(currentFrame);
                }
            }
            speed.Normalize();
            speed *= maxSpeed * (float)gameTime.ElapsedGameTime.TotalSeconds;

            if (GetTileProperty(position + feet + speed) == true)
            {
                position += speed;
            }
            else
            {
                speed = Vector2.Zero;
            }
            if (currentState == figureState.walking)
            {
                UpdateAnimation(gameTime);
            }
            if (mousestate.LeftButton == ButtonState.Pressed == true)
            {

            }
            if (keyboardState.IsKeyDown(Keys.H))
            {
                Additem(potionCrafter.createHealingPotion());
            }
            return true;



        }
        public override void Draw(SpriteBatch spriteBatch)
        {
            spriteBatch.Draw(gfx_player1, position - TileEngine.GetCamera(), drawRect, Color.White, angle, middle, 1, SpriteEffects.None, 0.3f);
        }

        private bool GetTileProperty(Vector2 place) 
        {
            int TileType;
            TileType = TileEngine.GetTileType(place);
            if (TileType == -1 || TileType == 4)
            {
                return false;
            }
            if (TileType == currentTileType)
            {
                return true;
            }
            if (TileType == 11)
            {
                return Level.TileEvent(place);
                
            }
            currentTileType = TileType;
            walkSfxInstance.Stop();
            walkSfxInstance = sfx_walk[TileType % 6].CreateInstance();
            walkSfxInstance.IsLooped = true;
            walkSfxInstance.Play();
            if (TileType % 6 == 1 || TileType % 6 == 2)
            {
                maxSpeed = 60;
            }
            else
            {
                maxSpeed = 100;
            }

            return true;

        }

        public static bool Contains(string item)
        {
            if (inventory.Contains(item))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static void Additem(string item)
        {
            if (inventory.Contains(item))
            {
                return;
            }
            else
            {
                inventory.Add(item);
                return;
            }
        }

        public static void Removeitem(string item)
        {
            if (inventory.Contains(item))
            {
                inventory.Remove(item);
                return;
            }
            else
            {
                return;
            }
        }
    }
}
