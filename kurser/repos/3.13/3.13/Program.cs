using System;

namespace _3._13
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hur gammal är du?");
            int ålder = int.Parse(Console.ReadLine());

            if (ålder >= 16 && ålder <= 19)
            {
                Console.WriteLine("Du får vara med");
            }
            else if (ålder < 16)
            {
                Console.WriteLine("Du är för ung");
            }
            else
            {
                Console.WriteLine("Du är för gammal");
            }
            
        }
    }
}
