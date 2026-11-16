using System;

namespace _4._13
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Bestäm höjd");
            int höjd = int.Parse(Console.ReadLine());
            Console.WriteLine("Bestäm bredden");
            int bredden = int.Parse(Console.ReadLine());
            
            for(int i = 0; i < höjd; i++)
            {
                for(int j = 0; j < bredden; j++)
                {
                    if (i == 0 || i == höjd - 1 || j == 0 || j == bredden - 1)
                    {
                        Console.Write("X");
                    }
                    else
                    {
                       Console.Write(" ");
                    }
                }
                Console.WriteLine();
            }
        }
    }
}
