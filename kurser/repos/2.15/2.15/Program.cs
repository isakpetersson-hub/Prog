using System;

namespace _2._15
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv en mening med tre ord och en punkt i slutet.");
            string Mening = Console.ReadLine();
            int mellan1 = Mening.IndexOf(" ");
            int mellan2 = Mening.IndexOf(" ", (mellan1+1));
            int punkt = Mening.IndexOf(".");

            string ord1 = Mening[..mellan1];
            string ord2 = Mening[(mellan1 + 1)..mellan2];
            string ord3 = Mening[(mellan2+1)..punkt];

            Console.Write($"{ord3} {ord2} {ord1}.");




        }
    }
}
