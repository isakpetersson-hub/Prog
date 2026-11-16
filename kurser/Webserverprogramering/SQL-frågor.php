<?php
  include 'top.php'; 
 ?>
<div class="container mt-5" >
        <div class="row">
          <div class="col-sm-12">
          <h4>Övningar i SQL (alla uppgifter ska lösas med SQL-kod)</h4>
          <h5>Svaren ska finnas på den här sidan</h5>
          <br>  
          <!-- **** 1 **** -->
          <h5>1. Öppna PHPMyAdmin  
          Skapa en databas med namnet StorKomp </h5>
          <code>Create DATABASE StorKomp</code>
          <br>
          <!-- **** 2 **** -->
          <h5>2. Skapa tabell AVD enligt: </h5>
          <code>Namn: AVD<br>
            AvdNr (int Primary key)<br>
            AvdNamn(char)<br>
            Ort (char)<br>
            Chef (char)<br>
          </code>
          <br>
          <code>CREATE TABLE AVD<br>
              (<br>
              AvdNr int Primary KEY,<br>
              AvdNamn char(255),<br>
              Ort char(255),<br>
              Chef char(255)<br>
              )<br>
          </code>
          <!-- **** 3 **** -->
          <h5>3. Skapa tabell ANST enligt:</h5>
          <code>Namn: ANST<br>
            AnstNr (int primary key auto increment)<br>
            AnstNamn (char)<br>
            Titel (char)<br>
            Lön (int)<br>
            AnstDatum (date)<br>
            AvdNr (int)<br>
          </code>
          <code>CREATE TABLE ANST(<br>
            AnstNr int primary key AUTO_INCREMENT,<br>
            AnstNamn char,<br>
            Titel char,<br>
            Lön int,<br>
            AnstDatum date,<br>
            AvdNr int<br>
          )</code>
          <!-- **** 4 **** -->
          <h5>4. Skrivar först ut ANST och sedan AVD.</h5>
          <br>
          <code>SELECT * FROM ANST;<br>
                SELECT * FROM AVD;</code>
          <h5>5. Lägg till poster i tabell <b>AVD</b>:</h5>
          <img src="image/tabel1.png" class="img-fluid" alt="">
          <code>INSERT INTO AVD (AvdNr, AvdNamn, Ort, Chef)<br>
VALUES (10, "Administartor", "Göteborg","AA"),<br>
(20,"Försäljning","Mölndal","BB"),<br>
(30,"Produkt","Kungälv","CC")<br>
    </code>
          <br>
          <h5>6. Lägg till poster i tabell <b>ANST</b>:</h5>
          <img src="image/tabel2.png" class="img-fluid" alt="">
          <code>INSERT INTO ANST(AnstNr,AnstNamn,Titel,Lön,AnstDatum,AvdNr)<br>
VALUES(1,"Svensson","Försäljare",17000,"2000-11-01",20),<br>
(2,"Larssson","Försäljare",18000,"2000-11-01",20),<br>
(3,"Carlsson","Prod.chef",19500,"200-11-01",30),<br>
(4,"Bengtsson","Försäljn.chef",19800,"2000-11-01",20),<br>
(5,"Johansson","Maskinist",15000,"2000-11-01",30),<br>
(6,"Swahn", "Kontorist",15000,"2000-10-01",10),<br>
(7,"Andersson","VD",32000,"1999-01-01",10),<br>
(8,"Nilsson","Maskinist",14000,"2000-11-01",30)<br>
 </code>
          <h5>7. Skriv ut hela innehållet i ANST:</h5>
          <code>SELECT * FROM ANST</code>
          <h5>8. Skriv ut hela innehållet i AVD:</h5>
          <code>SELECT * FROM AVD</code>
          <h5>9. Skriv ut all info om alla maskinister:</h5>
          <code>SELECT * FROM ANST
            WHERE Titel = "Maskinist"
          </code>
          <h5>10. Skriv ut lönen för alla kontorister:</h5>
          <br>
          <code>SELECT Lön FROM ANST<br>
WHERE Titel = "Kontorist"<br>
</code>
          <h5>11. Skriv ut den minsta lönen:</h5>
          <code>SELECT MIN(Lön) FROM ANST</code>
          <h5>12. Skriv ut lönesumman på respektive ort:</h5>
          <code>SELECT AvdNr,SUM(Lön) FROM ANST WHERE AvdNr = 10; SELECT AvdNr,SUM(Lön) FROM ANST WHERE AvdNr = 20; SELECT AvdNr,SUM(Lön) FROM ANST WHERE AvdNr = 30;</code>
          <h5>13. Skriv ut tabellen ANST sorterat efter Lön (högsta lön först):</h5>
          <br>
          <code>SELECT * FROM ANST<br>
          ORDER BY Lön DESC</code>
          <h5>14. Skriv ut tabellen ANST men bara AnstNamn, Titel, Lön:</h5>
          <code>SELECT AnstNamn, Titel, Lön FROM ANST</code>
          <h5>15. Skriv ut tabellen ANST med endast dom som jobbar på avdelning 30:</h5>
          <code>SELECT * FROM `ANST` WHERE 1</code>
          <h5>16. Skriv ut tabellen ANST med endast dom som jobbar på avdelning 30 och är försäljare:</h5>
          <code>SELECT * FROM ANST<br>
WHERE AnstNr = 30 AND Titel = "Försäljare"</code>
          <h5>17. Skriv ut tabellen ANST med endast dom som jobbar på avdelning 20 eller har större lön än 19000 kr:</h5>
          <code>
            SELECT<br>
            *<br>
            FROM<br>
            ANST<br>
            WHERE<br>
            AvdNr = 20 OR Lön > 19000<br>
          </code>
          <h5>18. Skriv ut tabellen ANST med all personal, lön mellan 18000 och 25000 kr:</h5>
          <code>SELECT * FROM ANST<br>
WHERE AvdNr = 20 OR Lön BETWEEN 18000 AND 25000</code>
          <br>
          <h5>19. Skriv ut tabellen ANST ordna titel efter bokstavsordning:</h5>
          <code>SELECT * FROM ANST<br>
ORDER by Titel ASC</code>
          <h5>20. Skriv ut tabellen ANST med efternamn som börjar på bokstaven 'S':</h5>
          <code>SELECT * FROM ANST<br>
WHERE AnstNamn LIKE "s%" </code>
          <h5>21. Skriv ut tabellen ANST med efternamn som har 'sson' i sig:</h5>
          <code>SELECT * FROM ANST<br>
WHERE AnstNamn LIKE "%sson" </code>
          <h5>22. Skriv ut tabellen ANST med dom som inte jobbar på avdelning 30:</h5>
          <code>SELECT * FROM ANST<br>
WHERE AvdNr != 30</code>
          <br>
          <h5>23. Skriv ut persona från tabellen ANST som inte jobbar på avd 10 i ordning efter lön, fallande:</h5>
          <code>SELECT * FROM ANST<br>
WHERE AvdNr != 10<br>
ORDER BY Lön DESC</code>
          <h5>24. Räkna ut årslönen för alla och skriv ut Årslön från tabellen ANST:</h5>
          <code>SELECT <br>
AnstNr,<br>
AnstNamn,<br>
Titel,<br>
Lön * 12,<br>
AnstDatum,<br>
AvdNr<br>
FROM <br>
ANST</code>
          <h5>25. Visa de fem anställda som har högst lön från tabellen ANST:</h5>
          <code>SELECT * FROM ANST<br>
ORDER BY Lön DESC<br>
LIMIT 5</code>
          <h5>26. Använd formeln COUNT för att visa antalet rader i tabellen ANST:</h5>
          <code>SELECT COUNT(*)FROM ANST</code>
          <h5>27. Visa den totala lönesumman från tabellen ANST:</h5>
          <code>SELECT SUM(Lön)FROM ANST</code>
          <h5>28. Visa medellönen från tabellen ANST:</h5>
          <code>SELECT AVG(Lön)FROM ANST</code>
          <br>  
          <h5>29. Visa den största lönen från tabellen ANST:</h5>
          <code>SELECT MAX(Lön)FROM ANST</code>
          <h5>30. Visa medellönen för de olika jobben grupperad med titlarna:</h5>
          <code>SELECT AVG(Lön),Titel FROM ANST<br>
WHERE Titel = "Försäljare";<br>
<br>
SELECT AVG(Lön),Titel FROM ANST<br>
WHERE Titel = "Prod.chef";<br>
<br>
SELECT AVG(Lön),Titel FROM ANST<br>
WHERE Titel = "Försäljn.chef";<br>
<br>
SELECT AVG(Lön),Titel FROM ANST<br>
WHERE Titel = "Maskinist";<br>
<br>
SELECT AVG(Lön),Titel FROM ANST<br>
WHERE Titel = "VD";<br>
<br>
SELECT AVG(Lön),Titel FROM ANST<br>
WHERE Titel = "Kontorist";</code>
          <h5>31. Som ovan med alias:</h5>
          <br>
          <code>SELECT AVG(Lön),Titel AS Alias FROM ANST<br>
WHERE Titel = "Försäljare";<br>
<br>
SELECT AVG(Lön),Titel AS Alias FROM ANST<br>
WHERE Titel = "Prod.chef";<br>
<br>
SELECT AVG(Lön),Titel AS Alias FROM ANST<br>
WHERE Titel = "Försäljn.chef";<br>
<br>
SELECT AVG(Lön),Titel AS Alias FROM ANST<br>
WHERE Titel = "Maskinist";<br>
<br>
SELECT AVG(Lön),Titel AS Alias FROM ANST<br>
WHERE Titel = "VD";<br>
<br>
SELECT AVG(Lön),Titel AS Alias FROM ANST<br>
WHERE Titel = "Kontorist";</code>
          <h5>32. Join tabellerna AVD och ANST:</h5>
          <code>SELECT<br>
    *<br>
FROM<br>
    AVD<br>
JOIN ANST ON AVD.AvdNr = ANST.AvdNr</code>
          <h5>33. Join tabellerna AVD och ANST. Visa info om anställda samt om den avdelning som de jobbar på:</h5>
          <code>SELECT<br>
    ANST.AnstNamn,<br>
    AVD.Ort<br>
FROM<br>
    AVD<br>
JOIN ANST ON AVD.AvdNr = ANST.AvdNr<br>
 
</code>
          <h5>34. Som ovan, men bara för avdelning 30:</h5>
          <br>
          <code>SELECT<br>
    ANST.AnstNamn,<br>
    AVD.Ort,<br>
    AVD.AvdNr<br>
FROM<br>
    AVD<br>
JOIN ANST ON AVD.AvdNr = ANST.AvdNr<br>
WHERE AVD.AvdNr = 30<br>
</code>
          <h5>35. Skriv ut AnstNamn, AvdNamn och Ort för alla anställda:</h5>
          <code>SELECT<br>
    ANST.AnstNamn,<br>
    AVD.Ort,<br>
    AVD.AvdNamn<br>
FROM<br>
    AVD<br>
JOIN ANST ON AVD.AvdNr = ANST.AvdNr<br>
</code>
          <h5>36. Skriv ut AnstNamn, AvdNamn och Ort för alla anställda - Sortera efter AnstNamn i bokstavsordning:</h5>
          <code>SELECT<br>
    ANST.AnstNamn,<br>
    AVD.Ort,<br>
    AVD.AvdNamn<br>
FROM<br>
    AVD<br>
JOIN ANST ON AVD.AvdNr = ANST.AvdNr<br>
ORDER BY AnstNamn</code>
          <h5>37. Skriv ut AnstNamn, AvdNamn och Ort för alla som heter Svensson:</h5>    
          <code>SELECT<br>
    ANST.AnstNamn,<br>
    AVD.Ort,<br>
    AVD.AvdNamn<br>
FROM<br>
    AVD<br>
JOIN ANST ON AVD.AvdNr = ANST.AvdNr<br>
WHERE AnstNamn = 'Svensson'</code>
          <h5>38. Skriv ut AnstNamn, AvdNamn och Ort för alla vars efternamn börjar på 'S':</h5>
          <br>
          <code>SELECT<br>
    ANST.AnstNamn,<br>
    AVD.Ort,<br>
    AVD.AvdNamn<br>
FROM<br>
    AVD<br>
JOIN ANST ON AVD.AvdNr = ANST.AvdNr<br>
WHERE AnstNamn LIKE 'S%'</code>
          <h5>39. Alla ska få sin lön ökad med 1000 kronor:</h5>
          <code>UPDATE ANST<br>
SET Lön = Lön+1000</code>
          <h5>40. Uppdatera VD:ns lön med 15 %:</h5>
          <code>UPDATE ANST<br>
SET Lön = Lön*1.15<br>
WHERE Titel = 'VD'</code>
          <h5>41. Den anställde som har anställningsnummer 102 blir uppsagd. Ta bort posten ur tabellen:</h5>
          <code>DELETE FROM ANST<br>
WHERE AnstNr = 102</code>
          <h5>42. Lägg till ett nytt fält i tabellen "kommentar" i AVD-tabellen:</h5>
          <code>ALTER TABLE<br>
ANST ADD Kommentar varchar(255);</code>



          </div>
        </div>
      </div>
<?php
  include 'bottom.php' 
 ?>

