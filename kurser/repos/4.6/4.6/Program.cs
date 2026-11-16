using System;

namespace _4._6
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv in ett namn");
            string namn = Console.ReadLine();

            for (int i = namn.Length -1 ; i >= 0; i--)
                Console.WriteLine(namn[i]);
        }
    }
}
