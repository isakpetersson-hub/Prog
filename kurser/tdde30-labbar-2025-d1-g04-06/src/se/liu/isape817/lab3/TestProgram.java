package se.liu.isape817.lab3;

import se.liu.isape817.lab1.Person;

import java.time.LocalDate;

public class TestProgram
{
    public static void main(String[] args) {
	Stack stack = new Stack();
	stack.add(new Person("Isak", LocalDate.of(2004,10,24)));
	stack.add(new Person("Ludvig", LocalDate.of(1993,2,1)));
	stack.add(new Person("Wilfred", LocalDate.of(2004,1,31)));
	stack.add(new Person("Joel", LocalDate.of(2024,1,24)));
	stack.add(new Person("Viggo", LocalDate.of(1900,10,24)));
	while (!stack.isEmpty()){
	    System.out.println(stack.pop());
	}
	Queue queue = new Queue();
	queue.add(new Person("Hugo", LocalDate.of(2004,10,24)));
	queue.add(new Person("David", LocalDate.of(1993,2,1)));
	queue.add(new Person("Alfred", LocalDate.of(2004,1,31)));
	queue.add(new Person("Adam", LocalDate.of(2024,1,24)));
	queue.add(new Person("Kevin", LocalDate.of(1900,10,24)));
	while (!queue.isEmpty()){
	    System.out.println(queue.dequeue());
	}
    }
}
