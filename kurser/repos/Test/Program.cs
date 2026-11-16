using System;

namespace test
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.Write("Skriv två  ord");
            Console.ReadLine();
            string orden;
            orden = Console.ReadLine();
            int mellanslag = orden.IndexOf(" ");
            string första = orden[..mellanslag];
            string andra = orden[(mellanslag+ 1)..];
            Console.Write(andra +" "+ första);
            Console.ReadKey();
        }
    }
}
