package se.liu.elior637.components.misc;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.FloatControl;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;
import java.io.IOException;
import java.net.URL;

/**
 * Handler class for playing sound effects.
 */
public class SoundHandler
{
    private Clip clip = null;

    public SoundHandler(URL f) {
	try{
	    AudioInputStream ais = AudioSystem.getAudioInputStream(f);
	    this.clip = AudioSystem.getClip();
	    clip.open(ais);

	    FloatControl gainControl = (FloatControl) clip.getControl(FloatControl.Type.MASTER_GAIN);
	    gainControl.setValue(-10.0f);
	}catch(IOException | UnsupportedAudioFileException | LineUnavailableException e){
	    e.printStackTrace();
	}
    }

    /**
     * Play sound if sound is not already playing.
     */
    public void playSound(){
	new Thread(() -> {
	    if (clip!=null){
		if (clip.isRunning()){
		    clip.stop();
		}
		clip.setFramePosition(0);
		clip.start();
	    }
	}).start();

    }
}
