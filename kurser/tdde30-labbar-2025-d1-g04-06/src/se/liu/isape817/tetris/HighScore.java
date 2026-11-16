package se.liu.isape817.tetris;

public class HighScore
{
    private int score = 0;
    private String playerName = null;

    public HighScore(final int score, final String playerName) {
	this.score = score;
	this.playerName = playerName;
    }

    public int getScore() {
	return score;
    }

    @Override public String toString() {
	return "Name: " + playerName + ", Score: " + score +"\n";
    }
}
