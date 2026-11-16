
using System;

namespace _3._3
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Vad heter du?");
            string namn = Console.ReadLine().ToLower();
            if (namn == "stig")
            {
                Console.Write("Det är din namnsdag idag!!!!!!");
            }
            else if (namn == "abraham")
            {
                Console.Write("Det är din namnsdag imorogn");
            }
            else
            {
                Console.Write("Det är inte din Födelsedag idag eller imorgon");
            }

        }
    }
}
