using System;

namespace _3._1
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Om du vill vara med i cupen måste du ange din ålder.");
            int ålder = int.Parse(Console.ReadLine());

            if (ålder >= 50)
            {
                Console.Write("Du får vara med i tävlingen");
            }
            if (ålder < 50)
            {
                Console.WriteLine("Du får inte vara med i tävlingen.");
            }
            
        }
    }
}
