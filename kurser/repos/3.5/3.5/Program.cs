using System;

namespace _3._5
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hur gammal är du?");
            int age = int.Parse(Console.ReadLine());
            Console.WriteLine("Hur mycket tjännar du i månaden?");
            int salary = int.Parse(Console.ReadLine());
            if (age > 39)
            {
                Console.WriteLine("Du är älder än medelålder i Göteborg");
            }
            else if (age == 39)
            {
                Console.WriteLine("Du är lika gammak som medelåldern i Göteborg");
            }
            else
            {
                Console.WriteLine("Du är ungre än medel ålder i Göteborg");
            }
            if (salary > 36100)
            {
                Console.WriteLine("Du kännar mer än medelönen");
            }
            else if (salary == 36100)
            {
                Console.WriteLine("Du kännar lika mycket som medelönen");
            }
            else
            {
                Console.WriteLine("Du kännar mindre än medelönen");
            }
        }
    }
}
