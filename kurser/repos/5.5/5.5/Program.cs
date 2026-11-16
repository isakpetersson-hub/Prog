using System;

namespace _5._5
{
    class Program
    {
        static void Main(string[] args)
        {
            int antal = 0;
            int[] ålder = new int[100];
            for (antal = 0; antal < 100; antal++)
            {
                Console.WriteLine("Skriv in åldrarna för de boende");
                ålder[antal] = int.Parse(Console.ReadLine());
                Console.WriteLine("Vill du skriva in fler namn? j/n");
                string svar = Console.ReadLine();
                if (svar == "n") break;
            }
            for(int i = 0; i < antal; i++)
            Console.WriteLine($"{ålder[i]}");
        }
    }
}
