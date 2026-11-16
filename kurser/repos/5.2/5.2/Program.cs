using System;

namespace _5._2
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hur många sporter har du testat");
            int antal = int.Parse(Console.ReadLine());
            string[] sport = new string[antal];

            for (int i = 0; i < antal; i++)
            {
                Console.WriteLine("Skriv vilka sporter du har spelat");
                sport[i] = Console.ReadLine();
            }
            for(int i = 0; i < antal; i++)
            Console.WriteLine($"{sport[i]}");
        }
    }
}
