using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2._5
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.ForegroundColor = ConsoleColor.Green;
            Console.BackgroundColor = ConsoleColor.DarkBlue;
            Console.Clear();

            int Year;
            Console.Write("What year is it?");
            Year = int.Parse (Console.ReadLine());
            Console.Write("It's " + (2100 - Year) + " years to 2100");
            

            Console.ReadKey();
        }
    }
}
