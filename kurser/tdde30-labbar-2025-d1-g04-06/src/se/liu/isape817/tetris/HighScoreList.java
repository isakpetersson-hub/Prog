package se.liu.isape817.tetris;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

public class HighScoreList
{
    private List<HighScore> highScoreList = new ArrayList<>();
    private File tempFile = new File("highscores_temp.json");
    private File originalFile = new File("highscores.json");

    public void addHighScores(HighScore highScore) throws IOException, FileNotFoundException {
	highScoreList.add(highScore); // Lägger till den nya highscoret
	ScoreComparator.sortHighScores(highScoreList); // Sortar listan
	saveHighScores(); // Sparar den nya listan
    }

    public void saveHighScores() throws IOException, FileNotFoundException {
	Gson gson = new Gson();
	try (PrintWriter writer = new PrintWriter(tempFile)) { // Testar om vi kan spara listan i en temp fil
	    writer.println(gson.toJson(highScoreList));
	}
	if (originalFile.exists() && !originalFile.delete()) { // Försöker ta bort den gammla filen
	    throw new IOException("Could not delete original file");
	}
	if (!tempFile.renameTo(originalFile)) { // Försöker bytta namn till den riktiga filen
	    throw new IOException("Could not rename temporary file");
	}
    }

    public void loadHighScores() throws IOException, FileNotFoundException {
	Gson gson = new Gson();
	try (FileReader reader = new FileReader(originalFile)) { // Försöker load in highscore listan
	    highScoreList = gson.fromJson(reader, new TypeToken<ArrayList<HighScore>>(){}.getType());
	    if (highScoreList == null) { // Finns ingen lista skapa en ny
		highScoreList = new ArrayList<>();
	    }
	}
    }

    public List<HighScore> getHighScoreList() {
	return highScoreList;
    }

    @Override public String toString() {
	return "HighScoreList: " + highScoreList;
    }
}
