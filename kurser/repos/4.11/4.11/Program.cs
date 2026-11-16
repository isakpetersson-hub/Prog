using System;

namespace _4._11
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Vilket är Europas mest folkrika land");
            for (int i = 0; i <= 4; i++)
            {
                string svar = Console.ReadLine().ToLower();
                    if (svar == "ryssland")
                {
                    Console.WriteLine("Rätt svar");
                    break;
                }
                else
                {
                    Console.WriteLine("Fel försök igen");
                }
            }

        }
    }
}
