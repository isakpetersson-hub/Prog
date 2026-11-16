using System;

namespace _3._18
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine ("Skriv in ditt för och efter namn");
            string namn = Console.ReadLine();

            int mellanslag = namn.IndexOf(" ");
            string förnamn = namn[..mellanslag];
            string efternamn = namn[(mellanslag + 1)..];

            if(förnamn.CompareTo(efternamn) < 0)
            {
                Console.WriteLine($"{förnamn} kommer före {efternamn} i bokstavsordning");
            }
            else
            {
                Console.WriteLine($"{efternamn} kommer före {förnamn} i bokstavsordning");

            }
        }
    }
}
