using System;

namespace _3._2
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Quiz fråga 5!!" +
                "Vilka van dammernas VM 2015?");
            string Svar = Console.ReadLine().ToLower();
            if (Svar == "usa")
            {
                Console.WriteLine("Rätt svar");
            }
            if (Svar != "usa")
            {
                Console.WriteLine("Fel svar " +
                    "Rätt svar är usa");
            }
        }
    }
}
