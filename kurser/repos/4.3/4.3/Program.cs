using System;

namespace _4._3
{
    class Program
    {
        static void Main(string[] args)
        {
            string val = "";
            while (val != "3")
            {
                Console.WriteLine("Välj ett av följande alternernativ \n1.1. Omvandla meter till kilometer\n2.Omvandla kilometer till meter\n3.Avsluta programmet");
                val = Console.ReadLine();

                switch (val)
                {
                    case "1":
                        Console.WriteLine("Skirv in antal meter");
                        int meter = int.Parse(Console.ReadLine());
                        Console.WriteLine($"{meter / 1000}");
                        break;
                    case "2":
                        Console.WriteLine("Skirv in antal kilometer");
                        int kmeter = int.Parse(Console.ReadLine());
                        Console.WriteLine($"{kmeter * 1000}");
                        break;
                    case "3":
                        Console.WriteLine("Programmet avslutas");
                        break;
                    default:
                        Console.WriteLine("Du valde inte ett altervativ");
                        break;
                }

                
            }
        }
    }
}
