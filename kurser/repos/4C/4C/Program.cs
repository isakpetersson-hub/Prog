using System;

namespace _4C
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Gissa talet");
            int tal;
            int giss;
            
            Random slumpgenerator = new Random();
            tal = slumpgenerator.Next(1, 101);
            giss = int.Parse(Console.ReadLine());
            
            while (giss != tal)
            {
                if (giss > tal)
                {
                    Console.WriteLine("Too high");
                }
                if (giss < tal)
                {
                    Console.WriteLine("Too low");
                }
            giss = int.Parse(Console.ReadLine());

            }
            Console.WriteLine("Correct");
        }
    }
}
