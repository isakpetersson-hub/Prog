package se.liu.isape817.calender;

import java.util.ArrayList;
import java.util.List;

public class Cal
{
    private List<Appointment> appointments;

    public Cal(final List<Appointment> appointments) {
	this.appointments = new ArrayList<>();
    }

    public void show() {
	for (Appointment element : appointments){
	    System.out.println(element);
	}
    }
    public void book(int year, String month, int day,
		     int startHour, int startMinute, int endHour,
		     int endMinute, String subject){
	if(inputsCorrect(year, month, day, startHour, startMinute, endHour, endMinute)){
	    TimePoint start = new TimePoint(startHour, startMinute);
	    TimePoint end = new TimePoint(endHour, endMinute);
	    TimeSpan timeSpan = new TimeSpan(start, end);
	    Month monthNEW = new Month(Month.getMonthDays(month),month,Month.getMonthNumber(month));
	    SimpleDate date = new SimpleDate(year,monthNEW,day);
	    appointments.add(new Appointment(subject,date,timeSpan));
	}
	else throw new IllegalArgumentException("felmeddelande");

    }

    private static boolean inputsCorrect(final int year, final String month, final int day, final int startHour, final int startMinute,
				      final int endHour, final int endMinute)
    {
	return year > 1970 && startHour >= 0 && startHour <= 23 && startMinute >= 0 && startMinute <= 59 &&
	       Month.getMonthDays(month) >= day && endHour >= 0 && endHour <= 23 && endMinute >= 0 && endMinute <= 59 &&
	       Month.getMonthNumber(month) != -1;
    }

    public static void main(String[] args) {
	List<Appointment> appointments = new ArrayList<>();
	Cal cal = new Cal(appointments);
	cal.book(2025, "Oktober", 24, 13, 0, 16, 20, "Möte");
	cal.book(2025, "September", 24, 9, 20, 15, 30, "Möte2");
	cal.book(1972, "Februari", 28, 9, 0, 16, 0, "Möte3");
	cal.book(2025, "Januari", 23, 21, 30, 23, 59, "Möte4");
	cal.book(2005, "Juni", 1, 15, 0, 16, 0, "Möte5");
	cal.book(2025, "Januari", 3, 15, 0, 16, 10, "Möte6");
	cal.book(1999, "Februari", 13, 5, 0, 11, 0, "Möte7");
	cal.book(2000, "Januari", 31, 1, 10, 16, 0, "Möte8");
	cal.show();
    }
}

