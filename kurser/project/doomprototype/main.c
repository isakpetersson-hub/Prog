#include <stdio.h>
#include <stdbool.h>
#include <SDL.h>
#include <math.h>
		


#define SCREEN_WIDTH	128
#define SCREEN_HEIGHT	128

// Define MAX and MIN macros
#define MAX(X, Y) (((X) > (Y)) ? (X) : (Y))
#define MIN(X, Y) (((X) < (Y)) ? (X) : (Y))

typedef struct 
{
    int input[256];
    int w,s,a,d;           //move up, down, left, right
    int l,r;             //turn left, right 
    int m;                 //move up, down, look up, down
}keys; keys K;

struct point {
	int x;
	int y;
};

struct wall {
	struct point a;
	struct point b;
};

//struct section {
//	struct wall walls[];
//	int floor_height;
//	int roof_height;
//};


int main (int argc, char* argv[])
{
	(void) argc;
	(void) argv;
	
	// --- SETUP ---
	
	SDL_Window *window = SDL_CreateWindow("Basic C SDL project",
                                          SDL_WINDOWPOS_UNDEFINED,
                                          SDL_WINDOWPOS_UNDEFINED,
                                          SCREEN_WIDTH*8, SCREEN_HEIGHT*8,
                                          SDL_WINDOW_SHOWN);
	
	SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
	SDL_RenderSetScale(renderer, 8, 8);
	
	//--- TEST STUFF ---
	Uint64 NOW = SDL_GetPerformanceCounter();
	Uint64 LAST = 0;
	double delta = 0;
	
	int xp = 0;
	bool quit = false;
	while(!quit)
	{
		Uint32 start_time, frame_time;
		float fps;
  		start_time = SDL_GetTicks();


		// delta time
		LAST = NOW;
		NOW = SDL_GetPerformanceCounter();
		delta = (double)((NOW - LAST)*1000 / (double)SDL_GetPerformanceFrequency() );

		SDL_Event e;
        //SDL_WaitEvent(&e);
        SDL_Event event;
        while( SDL_PollEvent(&event) )
        {
        	if (event.type == SDL_QUIT) 
		{
        	quit = true;
		}
		switch( event.type ){
     	    case SDL_KEYDOWN:
			    K.input[event.key.keysym.scancode] = true;
     			break;
   			case SDL_KEYUP:
			    K.input[event.key.keysym.scancode] = false;
     			break;

     		default:
     		    break;
   		}

        K.w = K.input[SDL_SCANCODE_W];
        K.s = K.input[SDL_SCANCODE_S];
        K.a = K.input[SDL_SCANCODE_A];
        K.d = K.input[SDL_SCANCODE_D];
        K.l = K.input[SDL_SCANCODE_LEFT];
        K.r = K.input[SDL_SCANCODE_RIGHT];


    }
		// --- RENDERING ---

  		// Initialize renderer color black for the background
        SDL_SetRenderDrawColor(renderer, 0x00, 0x00, 0x00, 0x00);

        // Clear screen
        SDL_RenderClear(renderer);

        // Set renderer color red to draw the square
        SDL_SetRenderDrawColor(renderer, 0xFF, 0x00, 0x00, 0xFF);

	    //if (x >= 128) { x=0; }
		xp += K.w;
        xp -= K.s;
		for(int y = 0; y < SCREEN_HEIGHT; y++){
			for(int x = 0; x < SCREEN_WIDTH; x++){
				if (x==y){
					SDL_RenderDrawPoint(renderer, x+xp, y);
				}
			}
		}

		// Update screen
        SDL_RenderPresent(renderer);
	}

	// Destroy renderer
	SDL_DestroyRenderer(renderer);
        
    // Destroy window
    SDL_DestroyWindow(window);
    
    SDL_Quit();
    return 0;
}
