using System;

namespace _3._8
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv inte 3 olika ord efter varandra");
            string ord1 = Console.ReadLine();
            string ord2 = Console.ReadLine(); 
            string ord3 = Console.ReadLine();
            if (ord1.CompareTo(ord2) < 0 && ord1.CompareTo(ord3) < 0)
            {
                Console.WriteLine($"{ord1} kommer först i bokstavs ordning");
            }
            else
            {
                Console.WriteLine($"{ord1} kommer inte först i bokstavs ordning");
            }

        }
    }
}
