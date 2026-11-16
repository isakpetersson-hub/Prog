using System;

namespace _4._14
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Skriv ett ord");
            string ord = Console.ReadLine();
            bool sant = true;

            for(int i = 0; i > ord.Length; i++)
            {
                bool sant2 = false;
                for(int j = 0; j > ord.Length; j++)
                {
                    if (i != j && ord[i] == ord[j])
                    {
                        sant2 = true;
                    }
                }
                if (sant2 == false)
                {
                   sant = false;
                }
            }
            if(sant == true)
            {
                Console.WriteLine("Alla tecken föekommer minst två gånger");
            }
            else
            {
                Console.WriteLine("De förekommer inte minst två gånger.");
            }
        }
    }
}
