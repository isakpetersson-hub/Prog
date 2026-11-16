
import pygame as py
import time
import os

# py.init()

py.mixer.init(frequency=44100, channels=2, buffer=512)


class Sounds:

    CURRENT_DIR = os.path.dirname(__file__)

    sounds = {
        "driving": py.mixer.Sound(os.path.join(CURRENT_DIR, "data", "audio", "driving_sound.mp3")),
        "reload": py.mixer.Sound(os.path.join(CURRENT_DIR, "data", "audio", "Shotgun_cocking.wav")),
        "explosion": py.mixer.Sound(os.path.join(CURRENT_DIR, "data", "audio", "small_explosion.wav")),
        "shoot": py.mixer.Sound(os.path.join(CURRENT_DIR, "data", "audio", "heavy-artillery-shot.wav")),
        "get_flag": py.mixer.Sound(os.path.join(CURRENT_DIR, "data", "audio", "powerup.wav")),
        "hit": py.mixer.Sound(os.path.join(CURRENT_DIR, "data", "audio", "hit.wav")),
        "reverse": py.mixer.Sound(os.path.join(CURRENT_DIR, "data", "audio", "beep.wav")),
        "crawling": py.mixer.Sound(os.path.join(CURRENT_DIR, "data", "audio", "crawling.mp3")),
        "point": py.mixer.Sound(os.path.join(CURRENT_DIR, "data", "audio", "win.mp3")),
        "background": os.path.join(CURRENT_DIR, "data", "audio", "background.wav"),
        # "shooting": py.mixer.Sound(os.path.join(CURRENT_DIR, "data", "audio", "Shooting_sound.mp3"))
    }

    def setup_sounds():
        py.mixer.set_num_channels(20)
        Sounds.play_background()

    def play_driving_sound():
        if not py.mixer.Channel(1).get_busy():
            py.mixer.Channel(1).play(Sounds.sounds["crawling"])

    def play_reverse_sound():
        if not py.mixer.Channel(1).get_busy():
            py.mixer.Channel(1).play(Sounds.sounds["reverse"])

    def play_reload_sound():
        if not py.mixer.Channel(2).get_busy():
            py.mixer.Channel(2).play(Sounds.sounds["reload"])

    def play_shooting_sound():
        if not py.mixer.Channel(3).get_busy():
            py.mixer.Channel(3).play(Sounds.sounds["shoot"])

    def play_get_flag_sound():
        py.mixer.Channel(4).play(Sounds.sounds["get_flag"])

    def play_point_sound():
        py.mixer.Channel(4).play(Sounds.sounds["point"])

    def play_background():
        py.mixer.music.set_volume(0.5)
        py.mixer.music.load(Sounds.sounds["background"])
        py.mixer.music.play(loops=-1, start=0.0)

    def play_collision_sound():
        for i in range(12, 15):
            if not py.mixer.Channel(i).get_busy():
                py.mixer.Channel(i).play(Sounds.sounds["hit"])

    def dead_sound():
        for i in range(16, 19):
            if not py.mixer.Channel(i).get_busy():
                py.mixer.Channel(i).play(Sounds.sounds["explosion"])
