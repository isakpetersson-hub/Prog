using System;

namespace _3._12
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hur många datorer äger du?");
            int antal = int.Parse(Console.ReadLine());

            string ord = antal == 1 ? "dator" : "datorer";

            Console.WriteLine($"Du har {antal} {ord}");
        }
    }
}
