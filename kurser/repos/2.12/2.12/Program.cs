using System;

namespace _2._12
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hur många kilometer ska du köra?");
            int Sträcka = int.Parse(Console.ReadLine());

            Console.WriteLine("Hur många dagar ska du ha bilen?");
            int Dagar = int.Parse(Console.ReadLine());
            int Kostnade = (Dagar - 1) * 500;
            Console.WriteLine($"Du kommer betala {Kostnade + 300 + Sträcka}kr");
        }
    }
}
