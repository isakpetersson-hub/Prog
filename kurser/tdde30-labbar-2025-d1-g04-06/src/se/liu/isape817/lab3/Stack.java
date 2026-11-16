package se.liu.isape817.lab3;

import se.liu.isape817.lab1.Person;

public class Stack extends ListManipulator
{
    public void push(Person person) {
	elements.add(person);
    }

    public Person pop() {
	return elements.removeLast();
    }
}
