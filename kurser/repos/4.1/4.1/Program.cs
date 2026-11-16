using System;

namespace _4._1
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Vilket är världes största land?");
            string svar =  Console.ReadLine().ToLower();

            while (svar != "ryssland")
            {
                Console.WriteLine("Du svarade fel försök igen");
                svar = Console.ReadLine().ToLower();
            }

            Console.WriteLine("Du svarde rätt");
           
        }
    }
}
