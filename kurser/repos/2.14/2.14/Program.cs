using System;

namespace _2._14
{
    class Program
    {
        static void Main(string[] args)
        {
           Console.WriteLine("Gigamax räkanre är tillbaka nu med ännu mer funkoner och den kommer inte att explodera som innan. Men skriv nu in en multiplikation");
            string talen = Console.ReadLine();
            int Multi = talen.IndexOf("*");
            string text1 = talen[..Multi];
            string text2 = talen[(Multi + 1)..];

            Double tal1 = double.Parse(text1);
            Double tal2 = double.Parse(text2);

            Console.Write($"Multiplikation blir {tal1 * tal2} Lås upp rästen genom att betal 99.99$ per second.");

        }
    }
}
