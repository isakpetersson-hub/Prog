using System;

namespace _3.A
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Vill du åka bergodalbannan!");
            string svar = Console.ReadLine().ToLower();
            if (svar == "ja")
            {
                Console.WriteLine("Hur lång är du?");
                int hight = int.Parse(Console.ReadLine());
                   if(hight >= 120)
                {
                    Console.WriteLine("Du får åka");
                }
                else
                {
                    Console.WriteLine("Du får inte åka");
                }

            }
            else
            {
                Console.WriteLine("Köp korv istället!");
            }
        }
    }
}
