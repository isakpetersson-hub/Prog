package se.liu.isape817.lab1;

import se.liu.isape817.calender.Month;

import java.time.LocalDate;
import java.time.Period;

public class Person
{
    private String name;
    private LocalDate birthDay;

    public Person(final String name, final LocalDate birthDay){
	this.name = name;
	this.birthDay = birthDay;
    }

    private int getAge(LocalDate b) {
	return Period.between(b,LocalDate.now()).getYears();
    }

    @Override public String toString() {
	return name + " " + getAge(birthDay);
    }

    public static void main(String[] args) {
	Person me = new Person("Isak", LocalDate.of(2004,10,24));
	Person test = new Person("test", LocalDate.of(2018,1,15));
	Person test2 = new Person("test2", LocalDate.of(1985,7,21));
	System.out.println(me.getAge(me.birthDay));
	System.out.println(me +"\n"+ test +"\n"+ test2);

    }
}
