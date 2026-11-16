<!DOCTYPE html>
<html lang="sv">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Lägg till böcker</title>
	<link rel="stylesheet" type="text/css" href="css/style.css?v=<?php echo time();?>">
	<?php
		session_start();
		$namn = $_SESSION["username"];
		include "../connect.php"; 
	?>
</head>
<body>
	<div class="container-add">
		<div class="top"> <!--Top som inehåller hela bannern på topen av varje sida-->
			<div class="top__title">
				Digiotek	
			</div>
			<div class="top__text">
				Välkommen <?php echo $namn?> till ditt online bibliotek
			</div>
			<nav class="banner">
				<div class="banner__div"><a class="banner__link" href="home.php">Hem</a></div>
				<div class="banner__div"><a class="banner__link" href="library.php">Vårt Bibliotek</a></div>
				<div class="banner__div"><a class="banner__link__current" href="add-books.php">Lägg till böcker</a></div>
				<div class="banner__div"><a class="banner__link" href="php/Loggaut.php">Logga ut</a></div>
			</nav>
		</div>
		<div class="main-add">
			<div class="Reklam-add"><!--Templates för saker som kan vara på sidan-->
				Reklam
			</div>
			<div class="E-böcker"><!--Templates för saker som kan vara på sidan-->
				E-böcker
			</div>
			<div class="Ljudböcker"><!--Templates för saker som kan vara på sidan-->
				Ljudböcker
			</div>
			<div class="add-books">
				<form class="add-books__form" method="POST" action="<?php echo $_SERVER["PHP_SELF"];?>"><!--From för sql-->
					<div class="add-books__title">Ny Bok:</div>
					<div class="add-books__input">
						<label for="BookID">Book</label><br>
						<select id="BookID" name="BookID">
							<?php //Skriver ut all böcker i en select tabell
								$sql = "SELECT * FROM BokDataBas
 								JOIN AutorDataBas
 								ON BokDataBas.Author = AutorDataBas.AuthorID
 								ORDER BY AuthorName";
								if($result = mysqli_query($link, $sql)){
							    	if(mysqli_num_rows($result) > 0){
							        	while($row = mysqli_fetch_array($result)){
							                echo  "<option value=".$row['Id'].">".$row['Title']."</option>";
							        	}	
							        	mysqli_free_result($result);
							    	}
								}
							?>
						</select>
					</div>
					<div>
						<input class="add-books__submit" type="submit" value="Lägg till">
					</div>		
						<?php //Kollar om formet har blivit submitat och lägger in värderna från formet till tablen UsersBoksDataBas
						$ID = $_SESSION["ID"];
						if (isset($_POST['BookID'])) {
							$BookID = $_POST['BookID'];
							$sql = "SELECT * FROM
							UsersBoksDataBas
							WHERE
							BookID = '$BookID'
							AND
							UserID	= '$ID'";

							if ($result = mysqli_query($link,$sql)) 
							{
								if (mysqli_num_rows($result)==0) {
									$sql = "INSERT INTO UsersBoksDataBas(BookID,UserID) VALUES (?, ?)";
									if($stmt = mysqli_prepare($link, $sql)){
					    				mysqli_stmt_bind_param($stmt, "ii", $BookID, $ID);
					    				mysqli_stmt_execute($stmt);
					    				echo("Records inserted successfully");
									}
								}
								else{
									echo("This record already exsits");
								}   
							}
							else{
					    		echo "ERROR: Could not able to execute $sql. " .mysqli_error($link);
							}
						}
					?>
				</form>	
			</div>
		</div>
	</div>
</body>
</html>