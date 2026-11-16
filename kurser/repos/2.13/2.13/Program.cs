using System;

namespace _2._13
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv in lönnen för alla antällda på olika rader");
            int första = int.Parse(Console.ReadLine());
            int andra = int.Parse(Console.ReadLine());
            int tredje = int.Parse(Console.ReadLine());
            Console.WriteLine($"Medelönen är {(första + andra + tredje) / 3.0}kr");
            
        }
    }
}
