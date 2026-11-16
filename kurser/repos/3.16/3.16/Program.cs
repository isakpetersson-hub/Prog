using System;

namespace _3._16
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hur lång är din låt?");
            int minuter = int.Parse(Console.ReadLine());
            int sekunder = int.Parse(Console.ReadLine());
            minuter = minuter * 60;
            int tid = minuter + sekunder;
            if (tid >= 165 && tid <= 260)
            {
                Console.WriteLine("Din låt får spelas");
            }
            else
            {
                Console.WriteLine("Din låt fir inte spelas");
            }
        }
    }
}
