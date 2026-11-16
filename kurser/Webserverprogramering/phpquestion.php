<?php
  include "top.php"
?>

  <div class="container mt-5">
    <div class="row">
      <div class="col-sm-12">

        <!-- *********************************************************************
        Här ligger alla frågor om PHP där du ska vara på varje fråga med PHP-kod.
        Du ska anväda taggen <code></code> där du lägger in din PHP-kod 

        I detta dokument så ska svara på frågorna, man ska se php koden på sidan 
        Man ska se php koden på hemsidan.
        Använd 
        <code></code> 
        Se exempel i uppgift 1
        ********************************************************************* -->

        <h2 class="pt-1 font-weight-bolder">Övningar i PHP</h2>

        <!-- *************************** -->
        <!-- ********** Basic ********** -->
        <h4 class="font-weight-bolder">Basic och data typer</h4>
        
        <h5 class="pt-1">Svaren ska finnas på den här sidan. (Använd html-taggen code) <br>
          <b>OBS: Det är bara PHP koden som ska synas på sidan</b>
       </h5>
      
        <p class="pt-3"><b>1.</b> Skriv ut "Hello world" med hjälp av php</p>
        <code> echo"Hello World";</code> 

        <p class="pt-5"><b>2.</b> Skriv ut "Hello World", en kommentar och en kommentar som sträcker sig över flera rader.</p>
        <code>
          echo"Hello World";<br>
          // Kommentar<br>
          /*<br>
          Fler raders kommentar<br>
          */<br>
        </code>

        <p class="pt-5"><b>3.</b> Skriv ett program för att skriva ut "hello PHP" med hjälp av en php-variabel?<br>
              Exempel: <br>
              Hello PHP</p>
        <code>
          $text = "Hello PHP";<br>
          echo $text;<br>
        </code>

        <p class="pt-5"><b>4.</b> Skapa 3 variabler – color, Color och COLOR. Lägg in Blå, Röd och Grön<br>
            Skriv ut med echo/print:<br>
            Exempel: <br>
            Himmelens färg är blå<br>
            Solens färg är röd<br>
            Trädets färg är grön</p>
        <code>
          $color = "blå";<br>
          $Color = "röd";<br>
          $COLOR = "grön";<br>
          echo "Himmelens färg är". $color;<br>
          echo "Solens färg är" . $Color;<br>
          echo "Trädets färg är" . $COLOR;<br>
        </code>

        <!-- ************************************* -->
        <!-- ********** String - Texter ********** -->
        <h4 class="pt-5 font-weight-bolder">String</h4>

        <p class="pt-3"><b>5.</b> Skapa en variabel med innehållet "WebbServerProgrammering 1", du skall nu med olika strängfunktioner få fram, och skriva ut, olika strängar.</p>

        <p class="pt-3"><b>5.a</b> Skriv ett program som vänder på en strängen.</p>
        <code>
          $string = "WebbServerProgrammering 1";<br>
          echo strrev($string);<br>
        </code>
        <p class="pt-5"><b>5.b</b> Skriv ett program som skriver ut strängens längd.</p>
        <code>
          $string = "WebbServerProgrammering 1";<br>
          echo strlen($string);<br>
        </code>
        <p class="pt-5"><b>5.c</b> Skriv ett program som skriver ut strängens i gemener.( webbserverprogrammering 1 )</p>
        <code>
          $string = "WebbServerProgrammering 1";<br>
          echo strtolower($string);<br>
        </code>
        <p class="pt-5"><b>5.d</b> Skriv ett program som skriver ut strängens i versaler.(WEBBSERVERPROGRAMMERING 1 )</p>
        <code>
          $string = "WebbServerProgrammering 1";<br>
          echo strtoupper($string);<br>
        </code>
        <!-- ******************************** -->
        <!-- ********** Operatorer **********  -->
        <h4 class="pt-5 font-weight-bolder">Operators</h4>

        <p class="pt-3"><b>6.</b> Gör två variabler x=10 och y=4. Addera, subtrahera, multiplicera, och dividera skriv ut frågan och svaret.<br>
          (x+y=14)
        </p>
        <code>        
          $x = 10;<br>
          $y = 4;<br>
          echo "Adderaing blir ". $x+$y <br>
          echo "Subtrahering blir ". $x-$y <br>
          echo "Multiplication blir ". $x*$y <br>
          echo "Dividering blir ". $x/$y <br>
        </code>  
        <h4 class="pt-5 font-weight-bolder">If-satser</h4>
        
        <p class="pt-3"><b>7.</b> Skapa en variabel och kontrollera om ett tal är positivt, negativt eller noll.</p>
        <code>
        $nummer = 4;<br>
        if (nummer > 0){<br>
          echo "Talet är positivt"<br>
        }<br>
        else if(nummer = 0){<br>
          echo "nummer är noll"<br>
        }<br>
        else{<br>
          echo "talet är negativit"<br>
        }<br>
        </code>
        <p class="pt-5"><b>8.</b> Gör ett program som räknar ut porto för att skicka ett paket.<br>
            Skapa en variabel för vikten.<br>
            Paket som väger mindre än 20g kostar 5kr.<br>
            Paket upp till 100g kostar 10kr.<br>
            Paket över 100g kostar 20kr.</p>
            <code>
              $vikt = 80;<br>
              if (vikt < 20){<br>
                echo "priset blir 5kr"<br>
              }<br>
              else if (vikt <= 100){<br>
                echo "priset blir 10kr"<br><br>
              }<br>
              else{<br>
                echo "priset blir 20kr"<br>
              }<br>
            </code>
        <h4 class="pt-5 font-weight-bolder">Loopar</h4>

        <p class="pt-3"><b>9.</b> Skriv ett program som lägger ihop(plussar) alla tal mellan 1 och 100.</p>
        <code>
          for ($i = 1; $i <= 100; $i++) {
          $nummer  += i;
        }
        </code>
        <p class="pt-5"><b>10.</b> Skriv ett program för att skriva ut siffror mellan 1 och 100, vilka är delbara med 3, 5 och båda.<br>
            <b>Svar:</b><br>
            <code>
                for ($i = 1; $i <= 100; $i++) {<br>
                if ($i % 3 == 0 ){<br>
                  if ($i % 5 == 0){<br>
                    echo $i. " Delbart med 3 och 5";<br>
                  }<br>
                  else{<br>
                    echo $i. " Delbart med 3";<br>
                  }<br>
                }<br>
                else if ($i % 5 == 0){<br>
                  echo $i. " Delbart med 5";<br>
                }<br>
                else{<br>
                  echo $i. " Delbart med inget";<br>
                }<br>
              } <br>
            </code>
        <p class="pt-5"><b>11.</b> Ulf har satt in 10 000kr på ett konto med 3 % årlig ränta, hur mycket pengar finns på kontot efter 15 år? Inga fler insättningar görs.
          Välj själv hur du vill skriva ut svaret, med en enda rad eller en rad för varje år.<br>
        </p>
        <code>
          $pengar = 10000;<br>
          for ($i = 0; $i < 15; $i++){<br>
            $pengar *= 1.03;<br>
          }<br>
          echo "Vid 15 år finns det " .(int)$pengar ." kvar";<br>
        </code>        
        <p class="pt-5"><b>12.</b> Antalet råttor i en stad är 100 stycken, varje månad dubblas populationen av råttor, hur många månader dröjer det innan det finns en miljon råttor i staden?<br>
        Välj själv hur du vill skriva ut svaret, med en enda rad eller en rad för varje månad.</p>
        <code>
        $rat = 100;<br>
        $månad = 0;<br>
        while ($rat <= 1000000){<br>
          $rat *= 2;<br>
          $månad++;<br>
        }<br>
        echo "Det tar " .$månad ." månader till det blir 1 miljon råttor"<br>
        }<br>
        </code>
        <h4 class="pt-5 font-weight-bolder">Array</h4>

        <p class="pt-3"><b>13.</b> Skapa en array med Kalmar, Nybro, Smedby. <br>
          Skriv sen ut Smedby.</p>
          <code>
          $städer = array("Kalmar", "Nybro", "Smedby");<br>
          echo $städer[2];
          </code>         
          <p class="pt-5"><b>14.</b> Skapa en array med 10 städer och 10 nummer.<br>
          Sortera båda array med sort(); och skriv ut.<br>
          Sortera båda array också med rsort(); och skriv ut.</p>
        <code> 
        $nummer = array(1, 8, 3, 6, 9, 14, 81, 2, 70, 7);<br>
        $städer = array("Kalmar", "Stockholm", "Göteborg", "Malmö", "Paris", "London", "Rom", "Madrid", "Athen", "Köpenhamn");<br>
        sort($nummer);<br>
        sort($städer);<br>
        for ($i=0; $i < 10; $i++) { <br>
          echo $nummer[$i] ." ";<br>
        }<br>
        for ($i=0; $i < 10; $i++) { <br>
          echo $städer[$i] ." ";<br>
        }<br>
        rsort($nummer);<br>
        rsort($städer);<br>
        for ($i=0; $i < 10; $i++) { <br>
          echo $nummer[$i] ." ";<br>
        }<br>
        for ($i=0; $i < 10; $i++) { <br>
          echo $städer[$i] ." ";<br>
        }<br>
        </code>
        <p class="pt-5"><b>15.</b>Skapa en array och lägg in info nedan, skriv sedan ut info från arrayen istället.<br>
          Inte översta raden, Plats, Lag eller Poäng, ska stå kvar.
        </p>
        <table class="table">
          <thead>
            <tr>
              <th scope="col">Plats</th>
              <th scope="col">Lag</th>
              <th scope="col">Poäng</th>
            </tr>
          </thead>
          <tbody>
            <code>
            $plats = array(1,2,3);<br>
            $namn = array("IFK Göteborg", "Malmö FF", "Kalmar FF");<br>
            $poäng = array(22, 19, 18);<br>
            echo "&lt;tr&gt; &lt;td&gt;" .$plats[0] ."&lt;/td&gt; &lt;td&gt;" .$namn[0] ."&lt;/td&gt; &lt;td&gt;" .$poäng[0] ."&lt;/td&gt; &lt;/tr&gt;";<br>
            echo "&lt;tr&gt; &lt;td&gt;" .$plats[1] ."&lt;/td&gt; &lt;td&gt;" .$namn[1] ."&lt;/td&gt; &lt;td&gt;" .$poäng[1] ."&lt;/td&gt; &lt;/tr&gt;";<br>
            echo "&lt;tr&gt; &lt;td&gt;" .$plats[2] ."&lt;/td&gt; &lt;td&gt;" .$namn[2] ."&lt;/td&gt; &lt;td&gt;" .$poäng[2] ."&lt;/td&gt; &lt;/tr&gt;";<br>
            </code>
          </tbody>
        </table>

        <!-- ******************************** -->
        <!-- ********** Funktioner ********** --> 
        <h4 class="pt-5 font-weight-bolder">Funktioner</h4>

        <p class="pt-3"><b>16.</b> Skapa en variabel och lägg i talet 456.<br> 
          Skapa en funktion som tar en variabelen som argument.<br>
          Skriv ut variblen i funktionen<br>
        </p>
        <code>
        $nummer = 456;<br>
        function test($nummer){<br>
          echo $nummer;<br>
        }<br>
        test($nummer);<br>
        </code>
        <p class="pt-5"><b>17.</b> Skriv en funktion som tar 3 heltal som argument och som returnerar det största av dessa till en variabel i huvudprogrammet, skriv sen ut den variabelns värde.</p>
        <code>
        $nummer1 = 4;<br>
        $nummer2 = 12;<br>
        $nummer3 = 6;<br>
<br>
        echo störstnummer($nummer1, $nummer2, $nummer3);<br>
<br>
        function störstnummer($num1, $num2, $num3){<br>
          if ($num1 > $num2 && $num3) {<br>
            return $num1;<br>
          }<br>
          else if ($num2 > $num3){<br>
            return $num2;<br>
          }<br>
          else{<br>
            return $num3;<br>
          }<br>
        }
        </code>        
        <p class="pt-5"><b>18.</b> Läs in en lista på valfritt antal tal i en array (eller slumpa), anropa en funktion som beräknar medianvärdet och som returnerar medianvärdet.  </p>
        <code>
        $tal = array(2,5,82,16,13,78,21,45,6,2,9);<br>
        sort($tal);<br>
        echo $tal[6];<br>
        </code>
        <h4 class="pt-5 font-weight-bolder">Date</h4>

        <p class="pt-3"><b>19.</b> Skriv ut dagens datum 2020-05-12 21:14:54</p>
        <code>
          echo date("Y/m/d/H:i:s")<br>
        </code>
        <p class="pt-5"><b>20.</b> Skriv ut datum i olika formet:<br>
            Today is 2020/09/06<br>
            Today is 2020.09.06<br>
            Today is 2020-09-06<br>
            Today is Friday<br>
            <code>
              echo "Today is " . date("Y/m/d");<br>
              echo "Today is " . date("Y.m.d");<br>
              echo "Today is " . date("Y-m-d");<br>
              echo "Today is " . date("l");<br>
             </code> 
        </p>

        <p class="pt-5"><b>21.</b> Skriv ett program som kolla om du får rösta.</p>
        <code> 
        echo "Kan du Rösta Ja eller Nej?";<div>
        echo "Om nej, Du får inte rösta";<div>
        echo "Om ja, Du får rösta";<div>
        </div>
      </div>
    </div>
  </div>
<?php
  include "bottom.php"
?>
