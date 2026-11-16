using System;

namespace _4._8
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv in ett tal");
            string tal = Console.ReadLine();
            bool finns = false;
            for (int i = 0; i < tal.Length; i++) 
            {
                if (tal[i] == '3' || tal[i] == '7')
                {
                    finns = true;
                }
            }
            if(finns == false)
            {
                Console.WriteLine("Det finns inga 3 eller 7");
            }
            else
            {
                Console.WriteLine("Det finns mist en 3 eller 7");
            }


        }
    }
}
