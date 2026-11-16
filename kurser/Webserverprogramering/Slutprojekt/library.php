<!DOCTYPE html>
<html lang="sv">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Library</title>
	<link rel="stylesheet" type="text/css" href="css/style.css?v=<?php echo time();?>">
	<?php
		session_start();
		$namn = $_SESSION["username"];
		include "../connect.php"; 
	?>
</head>
<body>
	<div class="container-index">
		<div class="top"><!--Top som inehåller hela bannern på topen av varje sida-->
			<div class="top__title">
				Digiotek	
			</div>
			<div class="top__text">
				Välkommen <?php echo $namn?> till ditt online bibliotek
			</div>
			<nav class="banner">
				<div class="banner__div"><a class="banner__link" href="home.php">Hem</a></div>
				<div class="banner__div"><a class="banner__link__current" href="library.php">Vårt Bibliotek</a></div>
				<div class="banner__div"><a class="banner__link" href="add-books.php">Lägg till böcker</a></div>
				<div class="banner__div"><a class="banner__link" href="php/Loggaut.php">Logga ut</a></div>
			</nav>
		</div>
		<div class="main">
			<table class="table"><!--Table som vissar alla data från databasen-->
				<thead class="table__head">
					<tr>
						<th>Titel</th><th>Författare</th><th>Datum</th>
					</tr>
				</thead>
				<tbody class="table__body">
					<?php //Skriver ut all data från BokDataBas
 						$sql = "SELECT * FROM BokDataBas
 								JOIN AutorDataBas
 								ON BokDataBas.Author = AutorDataBas.AuthorID
 								ORDER BY AuthorName";
						if($result = mysqli_query($link, $sql)){
    						if(mysqli_num_rows($result) > 0){
        						while($row = mysqli_fetch_array($result)){
                					echo  '<tr><td>'.$row['Title'].'</td><td>'. $row['AuthorName'].'</td><td>'.$row['RealeaseDate'].'</td></tr>';
                					}
       						mysqli_free_result($result);} 
       					}
					?>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>