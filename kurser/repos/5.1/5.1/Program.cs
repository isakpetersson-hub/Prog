using System;

namespace _5._1
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv in en Svenska stad inte Stockholm eller Göteborg.");
            string[] städer = new string[3];
            städer[0] = "Stockholm";
            städer[1] = "Göteborg";
            städer[2] = Console.ReadLine();
            for (int i = 0; i < 3; i++)
                Console.Write($"{städer[i]} ");
        }
    }
}
