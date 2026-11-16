<!DOCTYPE html>
<html lang="sv">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Home</title>
	<link rel="stylesheet" type="text/css" href="css/style.css?v=<?php echo time();?>">
	<script src="https://kit.fontawesome.com/88e090cdab.js" crossorigin="anonymous"></script>
	<?php
		session_start();
		include "../connect.php";
		$ID = $_SESSION["ID"];
		$namn = $_SESSION["username"];
	?>
</head>
<body>
	<div class="container-home">
		<div class="top"><!--Top som inehåller hela bannern på topen av varje sida-->
			<div class="top__title">
				Digiotek	
			</div>
			<div class="top__text">
				Välkommen <?php echo $namn?> till ditt online bibliotek
			</div>
			<nav class="banner">
				<div class="banner__div"><a class="banner__link__current" href="home.php">Hem</a></div>
				<div class="banner__div"><a class="banner__link" href="library.php">Vårt Bibliotek</a></div>
				<div class="banner__div"><a class="banner__link" href="add-books.php">Lägg till böcker</a></div>
				<div class="banner__div"><a class="banner__link" href="php/Loggaut.php">Logga ut</a></div>
			</nav>
		</div>
		<div class="main-home">
			<div class="Reklam"><!--Templates för saker som kan vara på sidan-->
				Reklam
			</div>
			<div class="LånaBöcker"><!--Templates för saker som kan vara på sidan-->
				Låna ut böcker
			</div>
			<div class="KöpBöcker"><!--Templates för saker som kan vara på sidan-->
				Köp böcker
			</div>
			<table class="table"><!--Table som vissar alla data från databasen-->
				<thead class="table__head">
					<tr>
						<th>Titel</th><th>Författare</th><th>Datum</th><th></th>
					</tr>
				</thead>
				<tbody class="table__body">
					<?php //Skriver ut värderna som använderen ska ha från tabellen UserBokDataBas som är joinad med BokDataBas och AuthorDataBas i en list
 						$sql = "SELECT * FROM UsersBoksDataBas
								JOIN BokDataBas
								ON UsersBoksDataBas.BookID = BokDataBas.Id
								JOIN AutorDataBas
 								ON BokDataBas.Author = AutorDataBas.AuthorID
 								WHERE UserID = $ID
 								ORDER BY AuthorName";
						if($result = mysqli_query($link, $sql)){
    						if(mysqli_num_rows($result) > 0){
        						while($row = mysqli_fetch_array($result)){
                					echo  '<tr>
                							<td>'.$row['Title'].'</td>
                							<td>'. $row['AuthorName'].'</td>
                							<td>'.$row['RealeaseDate'].'</td>
                							<td><i id="'.$row['ID'].'" class="fa-solid fa-trash"></i></td>
                						   </tr>';
                				}
       						} 
       					}
					?>
				</tbody>
			</table>
		</div>
	</div>
	<script src="scripts/script.js"></script>
</body>
</html>