package se.liu.isape817.calender;

public class Appointment
{
    private String subject;
    private SimpleDate date;
    private TimeSpan timeSpan;

    public Appointment(final String subject, final SimpleDate date, final TimeSpan timeSpan) {
	this.subject = subject;
	this.date = date;
	this.timeSpan = timeSpan;
    }

    @Override public String toString() {
	return "Appointment om " + subject + " Den " + date + " kl " + timeSpan;
    }

    public String getSubject() {
	return subject;
    }

    public SimpleDate getDate() {
	return date;
    }

    public TimeSpan getTimeSpan() {
	return timeSpan;
    }

}
