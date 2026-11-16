using System;

namespace _3._4
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hur mycket poång fick du på matte provet?");
            int points = int.Parse(Console.ReadLine());
            if (points >= 55)
            {
                Console.Write("Du fick ett A");
            }
            else if (points >= 46)
            {
                Console.Write("Du fick ett B");
            }
            else if (points >= 35)
            {
                Console.Write("Du fick ett C");
            }
            else if (points >= 27)
            {
                Console.Write("Du fick ett D");
            }
            else if (points >= 18)
            {
                Console.Write("Du fick ett E");
            }
            else
            {
                Console.Write("Du failade din idiot");
            }
        }
    }
    
}
