using System;

namespace _3._11
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Välj en fråge sports kategori");
            Console.WriteLine("1. Musik");
            Console.WriteLine("2. Geografi");
            Console.WriteLine("3. Historia");

            string Val = Console.ReadLine();
            string svar;

            switch (Val)
            {
                case "1":
                    Console.WriteLine("Vilka gjorde låten Mr. Blue sky?");
                    svar = Console.ReadLine();
                    break;
                case "2":
                    Console.WriteLine("Vilket land ligger mäst söder ut?");
                    svar = Console.ReadLine();
                    break;
                default:
                    Console.WriteLine("Vilket år slutat WW1");
                    svar = Console.ReadLine();
                    break;
            }
            if ((Val == "1" && svar == "Electric Light Orchestra")||(Val == "2" && svar == "Argentian")|| (Val == "3" && svar == "1918"))
            {
                Console.WriteLine("Du svarade rätt");
            }
            else
            {
                Console.WriteLine("Du svarde fel");
            }

        }
    }
}
