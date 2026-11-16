""" This file contains function and classes for the Artificial Intelligence used in the game.
"""

import math
from collections import defaultdict, deque

import pygame
import pymunk
from pymunk import Vec2d
import gameobjects
import time

# NOTE: use only 'map0' during development!

MIN_ANGLE_DIF = math.radians(3)   # 3 degrees, a bit more than we can turn each tick


def angle_between_vectors(vec1, vec2):
    """ Since Vec2d operates in a cartesian coordinate space we have to
        convert the resulting vector to get the correct angle for our space.
    """
    vec = vec1 - vec2
    vec = vec.perpendicular()
    return vec.angle


def periodic_difference_of_angles(angle1, angle2):
    """ Compute the difference between two angles.
    """
    return (angle1 % (2 * math.pi)) - (angle2 % (2 * math.pi))


class Ai:
    """ A simple ai that finds the shortest path to the target using
    a breadth first search. Also capable of shooting other tanks and or wooden
    boxes. """

    def __init__(self, tank, game_objects_list, tanks_list, space, currentmap):
        self.tank = tank
        self.game_objects_list = game_objects_list
        self.tanks_list = tanks_list
        self.space = space
        self.currentmap = currentmap
        self.flag = None
        self.max_x = currentmap.width - 1
        self.max_y = currentmap.height - 1
        self.shoot_interval = 5
        self.last_shot_time = 0
        self.current_time = pygame.time.Clock()
        self.path = deque()
        self.move_cycle = Ai.move_cycle_gen(self)
        self.update_grid_pos()

    def update_grid_pos(self):
        """ This should only be called in the beginning, or at the end of a move_cycle. """
        self.grid_pos = self.get_tile_of_position(self.tank.body.position)

    def move_cycle_gen(self):
        """En Gen so kallar på find_shortest_path för att få kortaste vägen
            och får sedan ai att flytta till den tilen som är näst på tur"""
        while True:
            path = Ai.find_shortest_path(self)
            if len(path) > 0: # Tar bort den första tilen i vägen
                path.popleft()
            if not path: # Om ingen path finns börja om
                yield
                continue  # Start from the top of our cycle
            next_coord = path.popleft()
            yield
            while not Ai.correct_angle(self, next_coord): # Om Ai inte kolla åt rätt hål sväng den så den åker åt rätt håll
                Ai.turn(self, next_coord)
                yield
            start = time.time()
            while not Ai.correct_pos(self, next_coord): # Om Ai inte är på rätt tile accerlera till den kommer dit
                self.tank.accelerate()
                end = time.time()
                if end - start > 1:
                    self.tank.stop_moving()
                    break
                yield

    def decide(self): 
        """Funktionen som kallas från Update och avgör vad ai:n ska göra"""
        self.update_grid_pos()
        self.maybe_shoot()
        next(self.move_cycle)

    def turn(self, next): 
        """Vänder Ai så den pekar på nästa tile i sekvensen"""
        position = self.grid_pos
        dx = position[0] - next[0]
        dy = position[1] - next[1]
        rads = math.atan2(dx, -dy)
        rads %= 2 * math.pi
        current_angle = self.tank.body.angle % (2 * math.pi)

    # Calculate the difference in angles, wrap it between [-π, π]
        angle_diff = (rads - current_angle + math.pi) % (2 * math.pi) - math.pi

        # If the difference is positive, turn right (clockwise), otherwise turn left (counter-clockwise)
        if angle_diff > 0:
            self.tank.turn_right()  # Turn clockwise
        else:
            self.tank.turn_left()

    def correct_angle(self, next):
        """Kollar om den korrekta vinklen har uppnnåts så att Ai kollar på nästa tile"""
        position = self.grid_pos
        dx = position[0] - next[0]
        dy = position[1] - next[1]
        rads = math.atan2(dx, -dy)
        rads %= 2 * math.pi
        if (self.tank.body.angle) % (2 * math.pi) - rads <= MIN_ANGLE_DIF and (self.tank.body.angle) % (2 * math.pi) - rads >= -MIN_ANGLE_DIF:
            self.tank.stop_turning()
            return True
        else:
            return False

    def correct_pos(self, next):
        """
        Kollar om den tanken har kommit fram till nästa tile
        Räknas bara om tanken är nära mitten av tanken (med
        hjälp av TOLERANCE)
        """
        TOLERANCE = 0.15

        target_center = Vec2d(next[0] + 0.5, next[1] + 0.5)
        distance_to_center = self.tank.body.position.get_distance(target_center)

        if next == self.grid_pos and distance_to_center <= TOLERANCE:
            self.tank.stop_moving()
            return True
        else:
            return False

    def maybe_shoot(self): 
        """Kollar om det finns en tank framför Ai om det gör det kallar vi på Shoot funktionen"""
        hit = self.perform_raycast()
        if hit:
            hit_obj = hit.shape.parent if hasattr(hit.shape, 'parent') else None

            if hit_obj and getattr(hit_obj, 'destructable', False):
                # print("Detected destructable item, shooting")
                self.game_objects_list.append(self.tank.shoot())
            elif hit.shape.collision_type == 3:
                # print("Detected player, shooting")
                self.game_objects_list.append(self.tank.shoot())
                # print(f"DETECTED TARGET AT {hit.point}")
        # pass  # To be implemented

    def get_shoot_direction(self):
        """Returnerar vilket håll tanken är vinklad åt"""
        return pymunk.Vec2d((-math.sin(self.tank.body.angle)), math.cos(self.tank.body.angle))

    def perform_raycast(self, max_range=100):
        """Gör en raycast för att se om tanken skulle kunna skjuta en box eller tank"""
        offset = 0.3
        direction = self.get_shoot_direction()
        start = (self.tank.body.position[0] + direction[0] * offset, self.tank.body.position[1] + direction[1] * offset)
        end = (start[0] + direction[0] * max_range, start[1] + direction[1] * max_range)
        hit = self.space.segment_query_first(start, end, 0, pymunk.ShapeFilter())
        if hit and hit.shape.collision_type in {2, 3}:
            return hit
        return None

    def find_shortest_path(self): 
        """ A simple Breadth First Search using integer coordinates as our nodes.
            Edges are calculated as we go, using an external function.
        """
        target_tile = Ai.get_target_tile(self)
        tank_tile = self.grid_pos
        queue = deque([tank_tile])
        visited = set([tank_tile])
        parent = {tank_tile: None}
        while len(queue) > 0:
            node = queue.popleft()  # current explore tile
            if node == target_tile:
                shortest_path = deque()  # store the path
                while node:  # Trace back to start from the target
                    shortest_path.appendleft(node)  # appends each tile left of deque
                    node = parent[node]  # current target = previous tile for the target
                return shortest_path
            for neighbor in Ai.get_tile_neighbors(self, node):  # iterates through neighbor tiles
                if neighbor not in visited:
                    queue.append(neighbor)  # add unvisited tile to queue
                    visited.add((neighbor[0], neighbor[1]))  # mark queue tile as visisted
                    parent[neighbor] = node  # parent is set to current tile. This links tiles together
        return deque()

    def get_target_tile(self):
        """ Returns position of the flag if we don't have it. If we do have the flag,
            return the position of our home base.
        """
        if self.tank.flag is not None:
            x, y = self.tank.start_position
        else:
            self.get_flag()  # Ensure that we have initialized it.
            x, y = self.flag.x, self.flag.y
        return Vec2d(int(x), int(y))

    def get_flag(self):
        """ This has to be called to get the flag, since we don't know
            where it is when the Ai object is initialized.
        """
        if self.flag is None:
            # Find the flag in the game objects list
            for obj in self.game_objects_list:
                if isinstance(obj, gameobjects.Flag):
                    self.flag = obj
                    break
        return self.flag

    def get_tile_of_position(self, position_vector):
        """ Converts and returns the float position of our tank to an integer position. """
        x, y = position_vector
        return Vec2d(int(x), int(y))

    def get_tile_neighbors(self, coord_vec):
        """ Returns all bordering grid squares of the input coordinate.
            A bordering square is only considered accessible if it is grass
            or a wooden box.
        """
        # Find the coordinates of the tiles' four neighbors, top, bottom, right, left
        neighbors = [
            coord_vec + Vec2d(0, 1),
            coord_vec + Vec2d(0, -1),
            coord_vec + Vec2d(1, 0),
            coord_vec + Vec2d(-1, 0)
        ]
        return filter(self.filter_tile_neighbors, neighbors)

    def filter_tile_neighbors(self, coord):
        """ Used to filter the tile to check if it is a neighbor of the tank.
        """
        if self.currentmap.boxAt(coord[0], coord[1]) != 1 and coord[0] >= 0 and coord[0] <= self.max_x and coord[1] <= self.max_y and coord[1] >= 0:
            return True
        else:
            return False
