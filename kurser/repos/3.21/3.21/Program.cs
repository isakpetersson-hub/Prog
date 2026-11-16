using System;

namespace _3._21
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv in ett tal");
            string tal = Console.ReadLine();
            int Plus1 = tal.IndexOf("+");

            string Tal1 = tal[..Plus1];
            double tal1 = double.Parse(Tal1);

            string Efter = tal[(Plus1 + 1)..];

           if (Efter.Contains("+"))
            {
                int Plus2 = Efter.IndexOf("+");
                string Tal2 = Efter[..Plus2];
                double tal2 = double.Parse(Tal2);

                string efter2 = Efter[(Plus2 + 1)..];
                double Tal3 = double.Parse(efter2);
               Console.WriteLine($"Uttryckets värde är {tal1+tal2+Tal3}");
            }
            else
            {
                double tal2 = double.Parse(Efter);
                Console.WriteLine($"Svar = {tal1+tal2}");
            }

        }
    }
}
