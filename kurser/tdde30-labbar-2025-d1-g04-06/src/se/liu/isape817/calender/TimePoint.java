package se.liu.isape817.calender;

public class TimePoint
{
    private int hour;
    private int minute;

    public TimePoint(final int hour, final int minute) {
	this.hour = hour;
	this.minute = minute;
    }

    @Override public String toString() {
	return String.format("%02d:%02d", hour, minute);
    }

    public int getHour() {
	return hour;
    }

    public int getMinute() {
	return minute;
    }
    public int compareTo(TimePoint other){
	if(this.getHour() > other.getHour()) return 1;
	if(this.getHour() == other.getHour()){
	    if(this.getMinute() > other.getMinute()) return 1;
	    if(this.getMinute() == other.getMinute()){
		return 0;
	    }
	}
	return -1;
    }
}
