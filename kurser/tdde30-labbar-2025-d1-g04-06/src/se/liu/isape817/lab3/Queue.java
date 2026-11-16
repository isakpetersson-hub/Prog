package se.liu.isape817.lab3;

import se.liu.isape817.lab1.Person;

public class Queue extends ListManipulator
{
    public void enqueue(Person person) {
	elements.add(person);
    }

    public Person dequeue() {
	if (elements.isEmpty()) {
	    return null;
	} else {
	    return elements.removeFirst();
	}
    }

}
