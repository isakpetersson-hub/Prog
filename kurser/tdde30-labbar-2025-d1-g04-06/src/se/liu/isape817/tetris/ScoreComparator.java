package se.liu.isape817.tetris;

import java.util.Comparator;
import java.util.List;

public class ScoreComparator
{
    public static List<HighScore> sortHighScores(List<HighScore> highScores) {
	highScores.sort(Comparator.comparingInt(HighScore::getScore).reversed()); // Sorterar highScores i fallande ordning
	return highScores;
    }

}
