using System;

namespace _4B
{
    class Program
    {
        static void Main(string[] args)
        {
            int odd = 0;
            int even = 0;
            for (int i = 0; i < 10; i++)
            {
              
                Random slumpgenerator = new Random();
                int slumptal = slumpgenerator.Next(1, 3);
                if(slumptal == 1)
                {
                    odd++;
                }
                else
                {
                    even++;
                }
            }
            Console.WriteLine($"Det blev {odd} klave och {even} kronor");


        }
    }
}
