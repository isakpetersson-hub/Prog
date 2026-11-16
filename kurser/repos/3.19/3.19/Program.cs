using System;

namespace _3._19
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv in en addition eller subtraktion");
            string tal =Console.ReadLine();
            int tal1;
            int tal2;
            int tecken;
            if (tal.Contains("+"))
            {
                tecken = tal.IndexOf("+");
                tal1 = int.Parse(tal[..tecken]);
                tal2 = int.Parse(tal[(tecken + 1)..]);
                Console.WriteLine($"Svar = {tal1 + tal2}");
            }
            else
            {
                tecken = tal.IndexOf("-");
                tal1 = int.Parse(tal[..tecken]);
                tal2 = int.Parse(tal[(tecken + 1)..]);
                Console.WriteLine($"Svar = {tal1 - tal2}");
            }

        }
    }
}
