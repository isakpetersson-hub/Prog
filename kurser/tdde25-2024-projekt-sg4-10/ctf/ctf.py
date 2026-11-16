""" Main file for the game.
"""
import pygame
from pygame.locals import *
from pygame.color import *
import pymunk
import ai
import images
import gameobjects
import maps
from sound import Sounds
FRAMERATE = 50


class Game():
    def __init__(self):
        pygame.init()
        Sounds.setup_sounds()

        self.clock = pygame.time.Clock()
        self.current_map = maps.map0
        self.screen = pygame.display.set_mode(self.current_map.rect().size)
        pygame.display.toggle_fullscreen()
        pygame.font.init()
        self.my_font = pygame.font.Font(None, 36)
        # Physics engine
        self.space = pymunk.Space()
        self.space.gravity = (0.0, 0.0)
        self.space.damping = 0.1
        # Setup game objects
        self.game_objects_list = []
        self.tank_list = []
        self.ai_list = []
        self.flag = None
        self.player = None
        self.skip_update = 0
        self.map_width = 0
        self.map_height = 0
        self.background = self.create_background()
        # Create objects on the map
        self.create_boxes()
        self.create_tanks_and_bases()
        self.create_flag()
        self.initialize_Collisions()

    def create_background(self): 
        """Creates background"""
        self.map_width, self.map_height = pygame.display.get_surface().get_size()
        gameobjects.add_world_borders(self.space, self.current_map.width, self.current_map.height)
        background = pygame.Surface(self.screen.get_size())
        for x in range(0, self.current_map.width):
            for y in range(0, self.current_map.height):
                background.blit(images.grass, (x * images.TILE_SIZE, y * images.TILE_SIZE))
        return background

    def create_boxes(self): 
        """Skapar boxar enligt maps"""
        for x in range(0, self.current_map.width):
            for y in range(0, self.current_map.height):
                box_type = self.current_map.boxAt(x, y)
                if (box_type != 0):
                    box = gameobjects.get_box_with_type(x, y, box_type, self.space)
                    self.game_objects_list.append(box)

    def create_tanks_and_bases(self):
        """Skapar tanks och basar och sätter alla utom den första tanken till en ai"""
        for i, pos in enumerate(self.current_map.start_positions):
            base = gameobjects.Base(pos[0], pos[1], images.bases[i])
            tank = gameobjects.Tank(pos[0], pos[1], pos[2], images.tanks[i], self.space)
            self.game_objects_list.append(base)
            self.tank_list.append(tank)
            if i == 0:
                self.player = self.tank_list[i]
            else:
                AI = ai.Ai(tank, self.game_objects_list, self.tank_list, self.space, self.current_map)
                self.ai_list.append(AI)

    def create_flag(self): 
        """Skapar flaggan"""
        self.flag = gameobjects.Flag(self.current_map.flag_position[0], self.current_map.flag_position[1])
        self.game_objects_list.append(self.flag)

    def eventhandler(self):
        """(Close button of the window) or if the user press the escape key."""
        for event in pygame.event.get():
            if event.type == QUIT or (event.type == KEYDOWN and event.key == K_ESCAPE):
                self.running = False

    def initialize_Collisions(self): 
        """Funktioner för att starta igång kollisioner"""
        handler_bullet_box = self.space.add_collision_handler(1, 2)
        handler_bullet_box.pre_solve = self.collision_bullet_box

        handler_bullet_tank = self.space.add_collision_handler(1, 3)
        handler_bullet_tank.pre_solve = self.collision_bullet_tank

        handler_bullet_border = self.space.add_collision_handler(1, 4)
        handler_bullet_border.pre_solve = self.collision_bullet_border

    def collision_bullet_box(self, arb, space, data):
        """Hanterar kollision när ett skott träffar en box"""
        shape1, shape2 = arb.shapes
        bullet, box = shape1.parent, shape2.parent
        space.remove(bullet.shape, bullet.body)
        if bullet in self.game_objects_list:
            self.game_objects_list.remove(bullet)
        if box in self.game_objects_list:
            if box.destructable:
                box.got_shot()
                if box.destroyed():
                    self.space.remove(box.shape, box.body)
                    self.game_objects_list.remove(box)
        Sounds.play_collision_sound()
        return True  # True blir boxen rör på sig när man skjuter den

    def collision_bullet_tank(self, arb, space, data):
        """Hanterar kollision när ett skott träffar en pansarvagn"""
        shape1, shape2 = arb.shapes
        bullet, tank = shape1.parent, shape2.parent
        space.remove(bullet.shape, bullet.body)
        if bullet in self.game_objects_list:
            self.game_objects_list.remove(bullet)
        # tank.respawn()
        tank.got_shot()
        return False

    def collision_bullet_border(self, arb, space, data):
        """Hanterar kollision när ett skott träffar kanten av kartan"""
        shape1 = arb.shapes[0]
        bullet = shape1.parent
        space.remove(bullet.shape, bullet.body)
        if bullet in self.game_objects_list:
            self.game_objects_list.remove(bullet)
        return False

    def update(self):
        """ Uppdaterar movement"""
        keys = pygame.key.get_pressed()
        if keys[K_UP] and not keys[K_DOWN]:
            self.player.accelerate()
            Sounds.play_driving_sound()
        elif keys[K_DOWN] and not keys[K_UP]:
            self.player.decelerate()
            Sounds.play_reverse_sound()
        else:
            self.player.stop_moving()
        if keys[K_LEFT] and not keys[K_RIGHT]:
            self.player.turn_left()
        elif keys[K_RIGHT] and not keys[K_LEFT]:
            self.player.turn_right()
        else:
            self.player.stop_turning()
        if keys[K_SPACE]:
            self.game_objects_list.append(self.player.shoot(True))
        if keys[K_k]:
            self.player.respawn()
        # Uppdaterar alla tanks och objects
        for obj in self.tank_list:
            obj.update()
            obj.try_grab_flag(self.flag)
            obj.post_update()
        for obj in self.ai_list:
            obj.decide()
        for obj in self.game_objects_list:
            if obj is not None:
                obj.update()
        self.space.step(1 / FRAMERATE)

    def render(self): # Updaterar skärmen
        self.screen.blit(self.background, (0, 0))
        for obj in self.game_objects_list:
            if obj is not None:
                obj.post_update()
                obj.update_screen(self.screen)
        for obj in self.tank_list:
            obj.update_screen(self.screen)
            obj.draw_shield(self.screen)
            obj.draw_health_bar(self.screen, obj)
        self.player.draw_fog_of_war(self.screen, self.player)
        gameobjects.explosion_group.draw(self.screen)
        gameobjects.explosion_group.update()
        pygame.display.flip()

    def scored(self, obj): 
        # Körs när en tank har tagit flaggan till basen och ökar dens score, respawnar flaggan 
        # och skriver ut current score med en pause på några sekunder
        obj.respawn_flag(self.current_map)
        obj.increse_score()
        text = []
        for i, obj in enumerate(self.tank_list):
            text.append("Player " + str(i + 1) + ": " + str(obj.get_score()))
        self.total_text_height = len(text) * self.my_font.size(text[0])[1]
        self.start_y = (self.map_height / 2) - (self.total_text_height / 2)
        for i, line in enumerate(text):
            self.text_surface = self.my_font.render(line, True, (255, 255, 255))
            self.text_width = self.text_surface.get_width()
            self.text_height = self.text_surface.get_height()
            x = (self.map_width / 2) - (self.text_width / 2)
            y = self.start_y + (i * self.text_height)
            self.screen.blit(self.text_surface, (x, y))
        pygame.display.flip()
        pygame.time.delay(2000)

    def run(self): # Den yttersta loopen som körs när programmet startas
        self.running = True
        while self.running:
            self.eventhandler()
            self.update()
            self.render()
            self.clock.tick(FRAMERATE)
            for obj in self.tank_list:
                if obj.has_scored():
                    Sounds.play_point_sound()
                    self.scored(obj)


game = Game()
game.run()
