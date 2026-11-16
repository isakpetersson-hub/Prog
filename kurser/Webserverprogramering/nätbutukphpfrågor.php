
<?php
  include 'top.php'; 
 ?>
1. Lista namn och stad på alla användare som har beställt något i september 2017. <br>
<code>SELECT NAME<br>
    ,<br>
    city<br>
FROM<br>
    UsersDB<br>
JOIN Orders ON Orders.userId = UsersDB.id<br>
WHERE<br>
    Orders.orderDate LIKE "2017-09%"<br></code>
<br>
2. Ta fram namnet på den som har beställt ordern med id=25? <br>
<code>SELECT NAME<br>
FROM<br>
    UsersDB<br>
JOIN Orders ON Orders.userId = UsersDB.id<br>
WHERE<br>
    Orders.id LIKE 25<br></code>
<br>
3. Visa en lista på vilka månader som det har lagts ordrar (inga dubletter). <br>
<code>SELECT DISTINCT<br>
    DATE_FORMAT(orderDate, "%b")<br>
FROM<br>
    Orders</code>
<br>
4. Hur många ordrar har det lagts i respektive månad? <br>
<code>SELECT<br>
    COUNT(orderDate)<br>
FROM<br>
    Orders<br>
WHERE<br>
    DATE_FORMAT(orderDate, "%b") LIKE "AUG";<br>
SELECT<br>
    COUNT(orderDate)<br>
FROM<br>
    Orders<br>
WHERE<br>
    DATE_FORMAT(orderDate, "%b") LIKE "SEP";<br>
SELECT<br>
    COUNT(orderDate)<br>
FROM<br>
    Orders<br>
WHERE<br>
    DATE_FORMAT(orderDate, "%b") LIKE "OCT";<br>
SELECT<br>
    COUNT(orderDate)<br>
FROM<br>
    Orders<br>
WHERE<br>
    DATE_FORMAT(orderDate, "%b") LIKE "NOV"</code>
<br>
5. Ta fram id på alla ordrar som inte har blivit levererade.<br>
<code>SELECT<br>
    id<br>
FROM<br>
    Orders<br>
WHERE<br>
    delivered IS NULL</code>
<br>
6. Vilka varor beställdes den 3 september (mer än en beställning)<br>
<code>SELECT<br>
    *<br>
FROM<br>
    ArticlesOrdered<br>
JOIN Orders ON ArticlesOrdered.orderId = Orders.id<br>
JOIN ArticlesDB ON ArticlesOrdered.articleId = ArticlesDB.id<br>
WHERE<br>
    orderDate LIKE "2017-09-03%"</code>
<br>
7. Lista orderid samt titlar och antal på alla artiklar ur ordern med id=25. <br>
<br>
8. Fulgunnar har lagt två beställningar. Lista orderId och innehållet i dom. <br>
<br>
9. Vilka användare (namn, ålder) har lagt mer än en beställning? <br>
<br>
10. Hannibal med användarid 6, har gjort en beställning. Vad väger den totalt? <br>
<br>
11. Visa en topplista på vilka produkter det har sålts mest av? (Glöm inte att räkna med “quantity”) <br>
<br>
12. Lista de tio första beställningarna med namn och stad på beställaren tillsammans med vad hen har beställt (även antal), orderId och datum (dag månad år) då beställningen gjordes.<br>
 <?php
  include 'bottom.php' 
 ?>