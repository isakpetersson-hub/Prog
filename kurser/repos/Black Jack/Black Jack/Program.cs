using System;

namespace Black_Jack
{
    class Program
    {
        static void Main(string[] args)
        {
            Random slump = new Random();
            string vinnare = "Ingen har vunnit än";
            Console.WriteLine("Välkommen till Black Jack");
            string val = "0";
            while (val != "4")
            {
            Console.WriteLine("Välj ett av alternativen\n1.Spela Black Jack \n2.Visa vinnarna\n3.Se regler\n4.Avlsuta programmet");
            val = Console.ReadLine();
            Console.WriteLine();
                
            switch (val)
                {
                    case "1":
                        int spelare = 0;
                        int dator = 0;
                        Console.WriteLine("Nu drars två kort var.");
                        spelare += slump.Next(1,11);
                        spelare += slump.Next(1,11);
                        dator += slump.Next(1, 11);
                        dator += slump.Next(1, 11);

                        string kort = "j";
                        while (kort != "n" && spelare <= 21)
                        {
                            Console.WriteLine($"Din poäng: {spelare}");
                            Console.WriteLine($"Datorns poäng: {dator}");
                            Console.WriteLine("Vill du ha ett till kort? (j/n)");
                            kort = Console.ReadLine();
                            if (kort == "j")
                            {
                                spelare += slump.Next(1, 11);
                                Console.WriteLine($"Din nya poäng är {spelare}");

                            }
                        }
                        if(spelare > 21)
                        {
                            Console.WriteLine("Du har mer än 21 och har förlorat");
                        }
                        while (dator < spelare && dator <= 21)
                        {
                            dator += slump.Next(1, 11);
                            Console.WriteLine($"Datorns nya poäng är {dator}");
                        }

                        Console.WriteLine($"Dinna poäng är {spelare}");
                        Console.WriteLine($"Datorns poäng är {dator}");

                        if(spelare > dator || dator > 21)
                        {
                            Console.WriteLine("Du van");
                            Console.WriteLine("Skirv in ditt namn");
                            vinnare = Console.ReadLine();
                        }
                        else
                        {
                            Console.WriteLine("Du förlorade");
                        }
                        break;
                    case "2":
                        Console.WriteLine($"Senaste vinnaren är {vinnare}");
                        break;

                    case "3":
                        Console.WriteLine("Ditt mål är att tvinga datorn att få mer än 21 poäng.");
                        Console.WriteLine("Du får poäng genom att dra kort, varje kort har 1-10 poäng.");
                        Console.WriteLine("Om du får mer än 21 poäng har du förlorat.");
                        Console.WriteLine("Både du och datorn får två kort i början. Därefter får du");
                        Console.WriteLine("dra fler kort tills du är nöjd eller får över 21.");
                        Console.WriteLine("När du är färdig drar datorn kort till den har");
                        Console.WriteLine("mer poäng än dig eller över 21 poäng.");
                        break;

                    case "4":
                        break;

                    default:
                        Console.WriteLine("Du valde inte ett giltigt alternativ");
                        break;

                }
                Console.WriteLine();
            }
        }
    }
}
