
using System;

namespace Uppgift_1
{
    class Program
    {
        static void Main(string[] args)
        {
            //Loopar i oändlighet
            bool loop = true;
            while(loop == true)
            {
                //Frågan om tal (Den första är där för att annars skrevs talen ut på sammarad även om det var en WriteLine och inte Write.)
                Console.WriteLine("");
                Console.WriteLine("Skiv in ett tal mellan 1 och 10");

                //Sparar svaret
                int tal = int.Parse(Console.ReadLine());

                //If stats om den är mellan 1 och 5 och skirver den lika många gånger som talet
                if (tal <= 5 && tal > 0)
                {
                    Console.Write($"Utskirft: {tal}");

                    for (int j = 1; j < tal; j++)
                    {
                        Console.Write($"{tal}");
                    }
                }

                //Om talet är mellan 6 och 10 så skrivs talet
                else if (tal >= 6 && tal <= 10)
                {
                    Console.Write($"Utskirft: {tal}");
                }

                //Om talet är 0 så avslutas pogrammet
                else if (tal == 0)
                {
                    Console.WriteLine("Utskrift: Slut");
                    loop = false;
                }

            }
        }
    }
}
