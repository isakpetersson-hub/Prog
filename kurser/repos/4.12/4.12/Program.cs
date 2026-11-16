using System;

namespace _4._12
{
    class Program
    {
        static void Main(string[] args)
        {
            for(int i = 1; i <=6; i++)
            {
                for (int j = 1; j <= 6; j++)
                {
                    Console.Write($"{i * j}  ");
                }
                Console.WriteLine();
            }
        }
    }
}
