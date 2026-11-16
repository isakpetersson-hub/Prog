using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2._6
{
    internal class Program
    {
        static void Main(string[] args)
        {
            //Här är variablerna
            double tal1;
            double tal2;
            //Här frågas om number och de sparas på variablerna 
            Console.WriteLine("The new and improvde gigaräknare now with extra content");
            Console.WriteLine("Write your first number");
            tal1 = double.Parse (Console.ReadLine());
            Console.WriteLine("Write your second number");
            tal2 = double.Parse(Console.ReadLine());
            //Här räknas och svaret skrivs ut
            Console.WriteLine("Medelvärdet av dinna tal är " +((tal1+tal2)/2));
            Console.ReadKey();
        }
    }
}
