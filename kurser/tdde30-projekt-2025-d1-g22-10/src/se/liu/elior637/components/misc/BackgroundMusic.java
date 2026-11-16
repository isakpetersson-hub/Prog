package se.liu.elior637.components.misc;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.FloatControl;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import javax.swing.*;
import java.awt.*;
import java.io.IOException;
import java.net.URL;

/**
 * Handels the logic with the background music in the game
 */
public class BackgroundMusic
{
    private Clip clip = null;

    /**
     * Method to play a continious sound loop, used for background music.
     * @param file The URL to to play.
     * @param volume db for how loud the track should be.
     */
    public BackgroundMusic(URL file, float volume) {
	try{
	    AudioInputStream ais = AudioSystem.getAudioInputStream(file);
	    this.clip = AudioSystem.getClip();
	    this.clip.open(ais);

	    FloatControl gainControl = (FloatControl) clip.getControl(FloatControl.Type.MASTER_GAIN);
	    gainControl.setValue(volume);

	    clip.loop(Clip.LOOP_CONTINUOUSLY);
	} catch (IOException e) {
	    JOptionPane.showMessageDialog(new Frame(), e.getMessage(), "IOException", JOptionPane.ERROR_MESSAGE);
	} catch (LineUnavailableException e) {
	    JOptionPane.showMessageDialog(new Frame(), e.getMessage(), "LineUnavailableException", JOptionPane.ERROR_MESSAGE);
	} catch (UnsupportedAudioFileException e) {
	    JOptionPane.showMessageDialog(new Frame(), e.getMessage(), "UnsupportedAudioFileException", JOptionPane.ERROR_MESSAGE);
	}
    }

    /**
     * Play track if track is not already playing
     */
    public void play() {
	if (clip!=null&&!clip.isRunning()) {
	    clip.setFramePosition(0);
	    clip.start();
	}
    }

    /**
     * Stop active track
     */
    public void stop() {
	if (clip!=null&&clip.isRunning()) {
	    clip.stop();
	}
    }

    /**
     * Stop current track
     */
    public void close(){
	if (clip!=null){
	    clip.close();
	}
    }
}
