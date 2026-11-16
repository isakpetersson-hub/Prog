using System;

namespace _3._20
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv in ett ord");
            string ord1 = Console.ReadLine();
            Console.WriteLine("Skriv in ett till ord (ej samma som det första)");
            string ord2 = Console.ReadLine();
            Console.WriteLine("Skriv in ett tredje ord (ej samma som något av de tidigare)");
            string ord3 = Console.ReadLine();

            if (ord1.CompareTo(ord2) < 0 && ord1.CompareTo(ord3) < 0)
            {
                Console.WriteLine("Det första ordet kommer först i bokstavsordning av de tre orden.");
            }
            else if (ord2.CompareTo(ord1) < 0 && ord2.CompareTo(ord3) < 0)
            {
                Console.WriteLine("Det andra ordet kommer först i bokstavsordning av de tre orden.");
            }
            else
            {
                Console.WriteLine("Det tredje ordet kommer först i bokstavsordning av de tre orden.");
            }
        }
    }
}
