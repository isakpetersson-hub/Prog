using System;

namespace Matte_project
{
    class Program
    {
        static void Main(string[] args)
        {
            double val = int.Parse(Console.ReadLine());
            double summa = 0;
            double två = 2;
            for (int i = 0; i < val; i++)
            {
                två = 2;
                for (int j = 0; j < i; j++)
                {
                    två = två * 2;
                }
                summa = summa + 1 / två;
            }

            Console.WriteLine(summa);
        }
    }
}
