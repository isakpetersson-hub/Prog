using System;

namespace _2._11
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hur långt hoppade ELin?");
            double Elin = double.Parse (Console.ReadLine());

            Console.WriteLine("Hur långt hoppade Alma?");
            double Alma = double.Parse(Console.ReadLine());

            double skillnade = Elin - Alma;
            Console.WriteLine($"Elin hoppade {skillnade.ToString("#.##")} meter längre än Alma");
        }
    }
}
