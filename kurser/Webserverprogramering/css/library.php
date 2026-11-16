<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Library</title>
	<link rel="stylesheet" type="text/css" href="css/style.css?v=<?php echo time();?>">
	<?php
		include "../connect.php"; 
	?>
</head>
<body>
	<div class="container">
		<div class="top">
			Bibliotek
		</div>
		<div class="banner">
			<div class="banner__div"><a class="banner__link" href="home.php">Hem</a></div>
			<div class="banner__div__current"><a class="banner__link" href="library.php">Vårt Bibliotek</a></div>
			<div class="banner__div"><a class="banner__link" href="add-books.php">Lägg till böcker</a></div>
		</div>
		<div class="main">
			<table class="library-table">
				<thead class="library-table__head">
					<tr>
						<th>Titel</th><th>Författare</th><th>Datum</th>
					</tr>
				</thead>
				<tbody class="library-table__body">
					<?php
 						$sql = "SELECT * FROM BokDataBas
 								JOIN AutorDataBas
 								ON BokDataBas.Author = AutorDataBas.AuthorID";
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