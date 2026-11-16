using System;

namespace _3._17
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("skirv in två tal");
            int nummer1 = int.Parse(Console.ReadLine());
            int nummer2 = int.Parse(Console.ReadLine());

            Console.WriteLine("Välj ett räknesätt");
            Console.WriteLine("1. Addition");
            Console.WriteLine("2. Subtraktion");
            Console.WriteLine("3. Multiplikatio");
            Console.WriteLine("3. Divintion");
            string val = Console.ReadLine();

            switch (val)
            {
                case "1":
                    Console.WriteLine($"Ditt svar är {nummer1+nummer2}");
                    break;
                case "2":
                    Console.WriteLine($"Ditt svar är {nummer1-nummer2}");
                    break;
                case "3":
                    Console.WriteLine($"Ditt svar är {nummer1*nummer2}");
                    break;
                case "4":
                    Console.WriteLine($"Ditt svar är {nummer1/nummer2}");
                    break;
                default:
                    Console.WriteLine("Välj ett sätt nästa gång");
                    break;
            }


        }
    }
}
