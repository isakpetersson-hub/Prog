using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2._3
{
    internal class Program
    {
        static void Main(string[] args)
        {
            double Höjd;
            Console.Write("Hur högt kan du hoppa i höjdhopp?");
           Höjd = double.Parse ( Console.ReadLine() );
            Console.WriteLine("Du kan är "+(2.45-Höjd)+" meter från världsrekodet");
            Console.ReadKey();
        }
    }
}
