using System;

namespace _4._9
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hur många kvadrat tal vill du ha.");
            int tal = int.Parse(Console.ReadLine());

            for (int i = 1; i <= tal; i++)
            {
                Console.WriteLine($"{i * i}");
            }


        }
    }
}
