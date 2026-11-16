package se.liu.isape817.lab3;

import se.liu.isape817.lab1.Person;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class ListManipulator
{
    public List<Person> elements = new ArrayList<>();

    public boolean add(final Person person) {
	return elements.add(person);
    }

    public Iterator<Person> iterator() {
	return elements.iterator();
    }

    public boolean contains(final Object o) {
	return elements.contains(o);
    }

    public boolean isEmpty() {
	return elements.isEmpty();
    }

    public int size() {
	return elements.size();
    }

    public boolean remove(final Object o) {
	return elements.remove(o);
    }

    public void clear() {
	elements.clear();
    }
}
