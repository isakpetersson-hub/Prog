using System;

namespace _3._9
{
    class Program
    {

        static void Main(string[] args)
        {
            Console.WriteLine("Skriv en mening valfri mängd + och -");
            string mening = Console.ReadLine();
            if (mening.Contains("+"))
            {
                if (mening.Contains("-"))
                {
                    Console.WriteLine("Mening inehåller både - och +");
                }

                else
                {
                    Console.WriteLine("Meningen inehåller ett +");
                }
            }

            else
            {
                if (mening.Contains("-"))
                {
                    Console.WriteLine("Meningen inehåller ett -");
                }

                else
                {
                    Console.WriteLine("Meningen inehåller varken + eller -");
                }
            }
        }
    }
}
