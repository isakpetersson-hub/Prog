using System;

namespace _4._10
{
    class Program
    {
        static void Main(string[] args)
        {
            for (int i = 1; i <= 30; i++)
            {
                if(i == 12 || i == 27)
                {
                    continue;
                }
               Console.WriteLine(i);
            }
        }
    }
}
