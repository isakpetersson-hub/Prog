using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2._7
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.Write("Skriv två  ord");
            string orden;
            orden = Console.ReadLine();
            int mellanslag = orden.IndexOf(" ");
            string första = orden[5..8];
            //string andra = orden[(mellanslag+ 1)..];
            //Console.Write(andra + första);
            Console.ReadKey();
        }
    }
}
