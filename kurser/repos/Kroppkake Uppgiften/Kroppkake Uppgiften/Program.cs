using System;

namespace Kroppkake_Uppgiften
{
    class Program
    {
        static void Main(string[] args)
        {
            //Här får man välj mat
            Console.WriteLine("Välj en maträtt\n1. Kroppkaka\n2. Ungspankaka\n3. Ostkaka");
            string mat = Console.ReadLine();

            //Här väljer man tillbehör
            Console.WriteLine("Välj Tillbehör\n1. Lingonsylt\n2. Jordgubbssylt");
            string till = Console.ReadLine();

            //Här får användare svar med en Switch case från vilket nummer användare skrev in.
            switch (mat)
            {
                case "1":

                    if (till == "1")
                    {
                        Console.WriteLine("Du har valt en bra komination");
                    }
                    else if (till == "2")
                    {
                        Console.WriteLine("Du har valt en dålig komination");
                    }
                    else{
                        Console.WriteLine("Skirv in ett av nummrena för tillbehör");
                    }
                    break;


                case "2":

                    if (till == "1" || till == "2")
                    {
                        Console.WriteLine("Du har valt en bra komination");
                    }
                    else
                    {
                        Console.WriteLine("Skirv in ett av nummrena för tillbehör");

                    }
                    break;


                case "3":

                    if (till == "2")
                    {
                        Console.WriteLine("Du har valt en bra komination");
                    }
                    else if (till == "1")
                    {
                        Console.WriteLine("Du har valt en dålig komination");
                    }
                    else
                    {
                        Console.WriteLine("Skirv in ett av nummrena för tillbehör");

                    }
                    break;


                default:
                    {
                        Console.WriteLine("Skirv in ett av nummerna för mat");
                    }
                    break;

            }


        }
    }
}
