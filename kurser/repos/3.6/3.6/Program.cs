using System;

namespace _3._6
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("För att åka i  berg-och-dalbanan måste du skirva din längd");
            double  längd = double .Parse(Console.ReadLine());

            if (längd >= 1.5 && längd <= 1.9)
            {
                Console.WriteLine("Du får åka du berg-och-dalbanan");
            }
            else
            {
                Console.WriteLine("Du får inte åka berg-och-dalbanan");
            }
        }
    }
}
