using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2._4
{
    internal class Program
    {
        static void Main(string[] args)
        {
            int tal1;
            int tal2;

            Console.WriteLine("Gigaräknare deluxe V.420,69");
            Console.WriteLine("Skriv in förta talet");
            tal1 = int.Parse( Console.ReadLine());
            Console.WriteLine("Skrive tal 2");
            tal2 = int.Parse(Console.ReadLine());
            Console.WriteLine("Gigaräknare 2000 säger att de talen tillsammans blir " + (tal1 + tal2));
            Console.ReadKey();
            Console.WriteLine("Megaräknaren ger att multiplikationen av talen blir "+ (tal2 * tal1));
            Console.ReadKey();
        }
    }
}
