""" This module contains support for the different game objects: tank, boxes...
"""
import math
import pygame
import pymunk
import images
import sound

DEBUG = False  # Change this to set it in debug mode

explosion_group = pygame.sprite.Group()  # Define this before respawn is called


def physics_to_display(x):
    """ This function is used to convert coordinates in the physic engine into the display coordinates """
    return x * images.TILE_SIZE


class GameObject:
    """ Mostly handles visual aspects (pygame) of an object.
        Subclasses need to implement two functions:
        - screen_position    that will return the position of the object on the screen
        - screen_orientation that will return how much the object is rotated on the screen (in degrees). """

    def __init__(self, sprite):
        self.sprite = sprite

    def update(self):
        """ Placeholder, supposed to be implemented in a subclass.
            Should update the current state (after a tick) of the object."""
        return

    def post_update(self):
        """ Should be implemented in a subclass. Make updates that depend on
            other objects than itself."""
        return

    def update_screen(self, screen):
        """ Updates the visual part of the game. Should NOT need to be changed
            by a subclass."""
        sprite = self.sprite

        p = self.screen_position()  # Get the position of the object (pygame coordinates)
        sprite = pygame.transform.rotate(sprite, self.screen_orientation())  # Rotate the sprite using the rotation of the object

        # The position of the screen correspond to the center of the object,
        # but the function screen.blit expect to receive the top left corner
        # as argument, so we need to adjust the position p with an offset
        # which is the vector between the center of the sprite and the top left
        # corner of the sprite
        offset = pymunk.Vec2d(*sprite.get_size()) / 2.
        p = p - offset
        screen.blit(sprite, p)  # Copy the sprite on the screen


class GamePhysicsObject(GameObject):
    """ This class extends GameObject and it is used for objects which have a
        physical shape (such as tanks and boxes). This class handle the physical
        interaction of the objects.
    """

    def __init__(self, x, y, orientation, sprite, space, movable):
        """ Takes as parameters the starting coordinate (x,y), the orientation, the sprite (aka the image
            representing the object), the physic engine object (space) and whether the object can be
            moved (movable).
        """

        super().__init__(sprite)

        # Half dimensions of the object converted from screen coordinates to physic coordinates
        half_width = 0.5 * self.sprite.get_width() / images.TILE_SIZE
        half_height = 0.5 * self.sprite.get_height() / images.TILE_SIZE

        # Physical objects have a rectangular shape, the points correspond to the corners of that shape.
        points = [[-half_width, -half_height],
                  [-half_width, half_height],
                  [half_width, half_height],
                  [half_width, -half_height]]
        self.points = points
        # Create a body (which is the physical representation of this game object in the physic engine)
        if movable:
            # Create a movable object with some mass and moments
            # (considering the game is a top view game, with no gravity,
            # the mass is set to the same value for all objects)."""
            mass = 10
            moment = pymunk.moment_for_poly(mass, points)
            self.body = pymunk.Body(mass, moment)
        else:
            self.body = pymunk.Body(body_type=pymunk.Body.STATIC)  # Create a non movable (static) object

        self.body.position = x, y
        self.body.angle = math.radians(orientation)  # orientation is provided in degress, but pymunk expects radians.
        self.shape = pymunk.Poly(self.body, points)  # Create a polygon shape using the corner of the rectangle
        self.shape.parent = self

        # Set some value for friction and elasticity, which defines interraction in case of a colision
        # self.shape.friction = 0.5
        # self.shape.elasticity = 0.1

        # Add the object to the physic engine
        space.add(self.body, self.shape)

    def screen_position(self):
        """ Converts the body's position in the physics engine to screen coordinates. """
        return physics_to_display(self.body.position)

    def screen_orientation(self):
        """ Angles are reversed from the engine to the display. """
        return -math.degrees(self.body.angle)

    def update_screen(self, screen):
        super().update_screen(screen)
        # debug draw
        if DEBUG:
            ps = [self.body.position + p for p in self.points]

            ps = [physics_to_display(p) for p in ps]
            ps += [ps[0]]
            pygame.draw.lines(screen, pygame.color.THECOLORS["red"], False, ps, 1)


def clamp(min_max, value):
    """ Convenient helper function to bound a value to a specific interval. """
    return min(max(-min_max, value), min_max)


class Tank(GamePhysicsObject):
    """ Extends GamePhysicsObject and handles aspects which are specific to our tanks. """

    # Constant values for the tank, acessed like: Tank.ACCELERATION
    # You can add more constants here if needed later
    ACCELERATION = 0.4
    NORMAL_MAX_SPEED = 2.0
    FLAG_MAX_SPEED = NORMAL_MAX_SPEED * 0.5
    SHOT_DELAY = 90
    MAX_HITPOINTS = 3
    RESPAWN_PROTECTION = 120
    SHIELD_COLOR = (0, 255, 255, 100)  # Cyan with some transparency
    DEATH_LOCATIONS = []

    def __init__(self, x, y, orientation, sprite, space):
        super().__init__(x, y, orientation, sprite, space, True)
        # Define variable used to apply motion to the tanks
        self.acceleration = 0  # 1 forward, 0 for stand still, -1 for backwards
        self.rotation = 0  # 1 clockwise, 0 for no rotation, -1 counter clockwise

        self.time_since_last_shot = 0  # Håller koll på tiden sedan senaste skottet
        self.space = space
        self.flag = None                      # This variable is used to access the flag object, if the current tank is carrying the flag
        self.max_speed = Tank.NORMAL_MAX_SPEED     # Impose a maximum speed to the tank
        self.start_position = pymunk.Vec2d(x, y)        # Define the start position, which is also the position where the tank has to return with the flag
        self.shape.collision_type = 3
        self.score = 0
        self.current_hitpoints = Tank.MAX_HITPOINTS
        self.time_since_respawn = 0
        self.shape.filter = pymunk.ShapeFilter(categories=0x03)  # Assign category 0x03 to tanks

    def got_shot(self):
        """Kallas när tanken blir skjuten och subtraherar ett hitpoint.
            Om hp < 1, respawnar den tanken och återställer hp"""
        if self.time_since_respawn >= Tank.RESPAWN_PROTECTION:
            self.current_hitpoints -= 1
            if self.current_hitpoints < 1:
                self.respawn()
                self.current_hitpoints = Tank.MAX_HITPOINTS
                sound.Sounds.dead_sound()
        else:
            print("spawn protection")

    def respawn(self):  
        """Respawnar tanken på denns bas och om den har flaggan släpper den"""
        if self.flag is not None:
            self.flag.is_on_tank = False
            self.flag = None
        pos = physics_to_display(self.body.position)
        explosion = Explosion(pos[0], pos[1])
        explosion_group.add(explosion)
        self.DEATH_LOCATIONS.append([(pos[0], pos[1]), 15])
        self.body.position = pymunk.Vec2d(self.start_position[0], self.start_position[1])
        self.time_since_respawn = 0

    def draw_shield(self, screen):
        """Ritar ut en sköld runt tanken"""
        if self.time_since_respawn < Tank.RESPAWN_PROTECTION:
            pos = physics_to_display(self.body.position)
            pygame.draw.circle(screen, Tank.SHIELD_COLOR, (pos[0], pos[1]), 20, width=2)

    def draw_health_bar(self, screen, tank):
        """Ritar ut en health bar över tanken som uppdateras"""
        pos = physics_to_display(tank.body.position)
        health = self.current_hitpoints
        max_health = self.MAX_HITPOINTS

        bar_width = self.sprite.get_width()
        hp_width = bar_width / (max_health / health)

        health_x_pos = pos[0] - bar_width / 2
        health_y_pos = pos[1] - 20

        pygame.draw.line(screen, (255, 0, 0), (health_x_pos, health_y_pos), (health_x_pos + bar_width, health_y_pos), 4)
        pygame.draw.line(screen, (0, 255, 0), (health_x_pos, health_y_pos), (health_x_pos + hp_width, health_y_pos), 4)

    def draw_fog_of_war(self, screen, player, num_rays=100, cone_width=60, max_range=300):
        """Makes the whole map dark besides a circle around the tank
            and a cone forwards of the tank that mimmics realistic vision"""
        fog_surface = pygame.Surface(screen.get_size(), flags=pygame.SRCALPHA)
        fog_surface.fill((0, 0, 0, 255))
        pos = physics_to_display(player.body.position)
        player_x, player_y = pos[0], pos[1]
        angle = (player.body.angle) + math.radians(90)

        start_point = (player_x, player_y)
        ray_points = [start_point]  # First point is the player's position

        for i in range(num_rays + 1):
            # Calculate ray angle
            ray_angle = angle + math.radians(-cone_width / 2 + (i / num_rays) * cone_width)
            direction = (math.cos(ray_angle), math.sin(ray_angle))

            # Perform raycast
            start = (
                player.body.position[0] + direction[0] * 0.00001,  # Offset to avoid self-collision
                player.body.position[1] + direction[1] * 0.00001,
            )
            end = (
                start[0] + direction[0] * max_range,
                start[1] + direction[1] * max_range,
            )
            hit = self.space.segment_query_first(start, end, 0, pymunk.ShapeFilter(mask=pymunk.ShapeFilter.ALL_MASKS() ^ (0x01 | 0x03 | 0x04)))

            if hit:
                hit_point = physics_to_display(hit.point)
                # print(f"Hit Point: {hit.point}, Shape Categories: {hit.shape.filter.categories}")
            else:
                hit_point = physics_to_display(end)
            ray_points.append(hit_point)

        for instance in self.DEATH_LOCATIONS[:]:
            cord = instance[0]
            lifetime = instance[1]
            if lifetime > 0:
                pygame.draw.circle(fog_surface, (0, 0, 0, 0), (cord[0], cord[1]), 25)  # Transparent circle to cut the fog
            lifetime -= 1
            if lifetime <= 0:
                self.DEATH_LOCATIONS.remove(instance)
            else:
                self.DEATH_LOCATIONS[self.DEATH_LOCATIONS.index(instance)] = [(cord[0], cord[1]), lifetime]

        pygame.draw.circle(fog_surface, (0, 0, 0, 100), (player_x, player_y), 30)
        pygame.draw.polygon(fog_surface, (0, 0, 0, 0), ray_points)

        # Overlay the fog surface
        screen.blit(fog_surface, (0, 0))

    def accelerate(self):
        """ Call this function to make the tank move forward. """
        self.acceleration = 2

    def stop_moving(self):
        """ Call this function to make the tank stop moving. """
        self.acceleration = 0
        self.body.velocity = pymunk.Vec2d.zero()

    def decelerate(self):
        """ Call this function to make the tank move backward. """
        self.acceleration = -2

    def turn_left(self):
        """ Makes the tank turn left (counter clock-wise). """
        self.rotation = -2

    def turn_right(self):
        """ Makes the tank turn right (clock-wise). """
        self.rotation = 2

    def stop_turning(self):
        """ Call this function to make the tank stop turning. """
        self.rotation = 0
        self.body.angular_velocity = 0

    def update(self):
        """ A function to update the objects coordinates. Gets called at every tick of the game. """
        # Creates a vector in the direction we want accelerate / decelerate
        acceleration_vector = pymunk.Vec2d(0, self.ACCELERATION * self.acceleration).rotated(self.body.angle)
        # Applies the vector to our velocity
        self.body.velocity += acceleration_vector

        # Makes sure that we dont exceed our speed limit
        velocity = clamp(self.max_speed, self.body.velocity.length)
        self.body.velocity = pymunk.Vec2d(velocity, 0).rotated(self.body.velocity.angle)

        # Updates the rotation
        self.body.angular_velocity += self.rotation * self.ACCELERATION
        self.body.angular_velocity = clamp(self.max_speed, self.body.angular_velocity)

    def post_update(self):
        """Things that we want to update last"""
        # If the tank carries the flag, then update the positon of the flag
        if (self.flag is not None):
            self.flag.x = self.body.position[0]
            self.flag.y = self.body.position[1]
            self.flag.orientation = -math.degrees(self.body.angle)
        # Else ensure that the tank has its normal max speed
        else:
            self.max_speed = Tank.NORMAL_MAX_SPEED

        self.time_since_last_shot += 1  # Lägger till tid sen senaste skott
        self.time_since_respawn += 1

    def respawn_flag(self, current_map): 
        """Sätter flaggan i mitten efter att en tank har scorat"""
        self.flag.x = current_map.flag_position[0]
        self.flag.y = current_map.flag_position[1]
        self.is_on_tank = False
        self.flag.is_on_tank = False
        self.flag = None
        self.time_since_respawn += 1

    def try_grab_flag(self, flag):
        """ Call this function to try to grab the flag, if the flag is not on other tank
            and it is close to the current tank, then the current tank will grab the flag.
        """
        # Check that the flag is not on other tank
        if not flag.is_on_tank:
            # Check if the tank is close to the flag
            flag_pos = pymunk.Vec2d(flag.x, flag.y)
            if (flag_pos - self.body.position).length < 0.75:
                # Grab the flag !
                sound.Sounds.play_get_flag_sound()
                self.flag = flag
                self.flag.is_on_tank = True
                self.max_speed = Tank.FLAG_MAX_SPEED

    def has_scored(self):
        """ Check if the current tank has won (if it is has the flag and it is close to its start position). """
        return self.flag is not None and (self.start_position - self.body.position).length < 0.45

    def increse_score(self):
        """Increases the score by one for that specific tank"""
        self.score = self.score + 1

    def get_score(self): 
        """Retuenar score för den tanken"""
        return self.score

    def shoot(self, player=False):
        """Returns a bullet only if the delay has been reached"""

        if self.time_since_last_shot > Tank.SHOT_DELAY:
            offset_vector = pymunk.Vec2d((-math.sin(self.body.angle)), math.cos(self.body.angle))

            bullet_x = self.body.position[0] + (offset_vector[0]) / 2.5
            bullet_y = self.body.position[1] + (offset_vector[1]) / 2.5

            self.time_since_last_shot = 0

            if player:
                sound.Sounds.play_shooting_sound()

            return Bullet(bullet_x, bullet_y, math.degrees(self.body.angle), images.bullet, self.space)


class Bullet(GamePhysicsObject):
    """ This class extends the GamePhysicsObject to handle bullet objects"""

    SPEED = 6.0  # Hastigheten av Bullet
    LIFESPAN = 60  # Lifespan innan bullet försvinner

    def __init__(self, x, y, angle, sprite, space):
        super().__init__(x, y, angle, sprite, space, True)
        self.shape.collision_type = 1
        self.shape.filter = pymunk.ShapeFilter(categories=0x01)  # Assign category 0x01 to bullet

    def update(self):
        """ Update the position based on velocity"""
        self.body.velocity = pymunk.Vec2d((self.SPEED) * (-math.sin(self.body.angle)), (self.SPEED) * math.cos(self.body.angle))
        # self.lifetime -= 1  # Decrease lifetime each update

    def post_update(self):
        """Kolla om bullet hamnat utanför mappen"""
        if self.body.position[0] < 0 or self.body.position[0] > 800 or self.body.position[1] < 0 or self.body.position[1] > 600:
            self.alive = False


class Box(GamePhysicsObject):
    """ This class extends the GamePhysicsObject to handle box objects. """

    MAX_HITPOINTS = 2

    def __init__(self, x, y, sprite, movable, space, destructable):
        """ It takes as arguments the coordinate of the starting position of the box (x,y) and the box model (boxmodel). """
        super().__init__(x, y, 0, sprite, space, movable)
        self.destructable = destructable
        self.shape.collision_type = 2
        self.current_hitpoints = Box.MAX_HITPOINTS

    def got_shot(self):
        """Kallas när boxen blir skjuten och subtraherar ett hitpoint"""

        self.current_hitpoints -= 1

    def destroyed(self):
        """Om hp < 1 returnas True"""

        if self.current_hitpoints < 1:
            return True
        else:
            return False


def get_box_with_type(x, y, type, space):
    """ Create a box with the correct type at coordinate x, y.
        - type == 1 create a rock box
        - type == 2 create a wood box
        - type == 3 create a metal box
        Other values of type are invalid
    """
    (x, y) = (x + 0.5, y + 0.5)  # Offsets the coordinate to the center of the tile
    if type == 1:  # Creates a non-movable non-destructable rockbox
        return Box(x, y, images.rockbox, False, space, False)
    if type == 2:  # Creates a movable destructable woodbox
        return Box(x, y, images.woodbox, True, space, True)
    if type == 3:  # Creates a movable non-destructable metalbox
        return Box(x, y, images.metalbox, True, space, False)


class GameVisibleObject(GameObject):
    """ This class extends GameObject for object that are visible on screen but have no physical representation (bases and flag) """

    def __init__(self, x, y, sprite):
        """ It takes argument the coordinates (x,y) and the sprite. """
        self.x = x
        self.y = y
        self.orientation = 0
        super().__init__(sprite)

    def screen_position(self):
        """ Overwrite from GameObject """
        return physics_to_display(pymunk.Vec2d(self.x, self.y))

    def screen_orientation(self):
        """ Overwrite from GameObject """
        return self.orientation


class Flag(GameVisibleObject):
    """ This class extends GameVisibleObject for representing flags."""
    def __init__(self, x, y):
        self.is_on_tank = False
        self.filter = pymunk.ShapeFilter(categories=0x04)  # Assign category 0x04 to flag

        super().__init__(x, y, images.flag)


class Base(GameVisibleObject):
    """ This class extends GameVisibleObject for representing bases."""

    def __init__(self, x, y, sprite):
        super().__init__(x, y, sprite)


class Explosion(pygame.sprite.Sprite):

    def __init__(self, x, y):
        pygame.sprite.Sprite.__init__(self)
        self.images = images.explosions
        self.index = 0
        self.image = self.images[self.index]
        self.rect = self.image.get_rect()
        self.rect.center = [x, y]
        self.counter = 0

    def update(self):
        explosion_speed = 3
        # update explosion animation
        self.counter += 1

        if self.counter >= explosion_speed and self.index < len(self.images) - 1:
            self.counter = 0
            self.index += 1
            self.image = self.images[self.index]

        # if the animation is complete, reset animation index
        if self.index >= len(self.images) - 1 and self.counter >= explosion_speed:
            self.kill()


def add_world_borders(space, width, height):
    """Creates a border around the map"""

    thickness = 0
    collision_type_border = 4

    borders = [
        pymunk.Segment(space.static_body, (0, 0), (width, 0), thickness),       # Top border
        pymunk.Segment(space.static_body, (0, height), (width, height), thickness),  # Bottom border
        pymunk.Segment(space.static_body, (0, 0), (0, height), thickness),      # Left border
        pymunk.Segment(space.static_body, (width, 0), (width, height), thickness)  # Right border
    ]

    for border in borders:
        border.collision_type = collision_type_border
        space.add(border)
