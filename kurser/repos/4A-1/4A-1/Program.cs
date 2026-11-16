using System;

namespace _4A_1
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv in 10 st tal efter varandara");
            int summa = 0;
            int max = 0;
            for(int i = 0; i < 10; i++)
            {
                int tal = int.Parse(Console.ReadLine());
                summa += tal;
                if (tal > max)
                {
                    max = tal;
                }
            }
            Console.WriteLine($"Medal talet av alla är {summa / 10}");
            Console.WriteLine($"Det största talet är {max}");


        }
    }
}
