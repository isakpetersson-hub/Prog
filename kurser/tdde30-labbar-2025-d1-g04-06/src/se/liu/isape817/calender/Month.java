package se.liu.isape817.calender;

import java.util.Map;

public class Month
{
    private int number;
    private String name;
    private int days;
    private final static Map<String,Integer> MONTH_NAME_TO_LENGTH = Map.ofEntries(
	    Map.entry("Januari", 31),
	    Map.entry("Februari", 28),
	    Map.entry("Mars",31),
	    Map.entry("April",30),
	    Map.entry("Maj",31),
	    Map.entry("Juni",30),
	    Map.entry("Juli",31),
	    Map.entry("Augusti",31),
	    Map.entry("September",30),
	    Map.entry("Oktober",31),
	    Map.entry("November",30),
	    Map.entry("December",31));
    private final static Map<String,Integer> MONTH_NAME_TO_NUMBER = Map.ofEntries(
	    Map.entry("Januari", 1),
	    Map.entry("Februari", 2),
	    Map.entry("Mars",3),
	    Map.entry("April",4),
	    Map.entry("Maj",5),
	    Map.entry("Juni",6),
	    Map.entry("Juli",7),
	    Map.entry("Augusti",8),
	    Map.entry("September",9),
	    Map.entry("Oktober",10),
	    Map.entry("November",11),
	    Map.entry("December",12));


    public Month(final int days, final String name, final int number) {
	this.days = days;
	this.name = name;
	this.number = number;
    }
    public int getNumber() {
	return number;
    }

    public String getName() {
	return name;
    }

    public int getDays() {
	return days;
    }
    public static int getMonthNumber(String name){
	return MONTH_NAME_TO_NUMBER.getOrDefault(name,-1);
    }
    public static int getMonthDays(String name) {
	return MONTH_NAME_TO_LENGTH.getOrDefault(name,-1);
    }
}
