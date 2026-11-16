using System;

namespace _3._7
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv din ålder och se om kdu kan få extra billigt kaffe");
            int ålder = int.Parse(Console.ReadLine());
            if (ålder <= 18 && ålder >= 10 || ålder >= 65)
            {
                Console.WriteLine("Du får extra billigt kaffe");
            }
            else
            {
                Console.WriteLine("Du får tyvärr inte extra billigt kaffe.");
            }

        }
    }
}
