<!DOCTYPE html>
<html lang="sv">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/style.css?v=<?php echo time();?>">
	<title>Admin</title>
	<?php
		include "../connect.php"; 
		session_start();
		$namn = $_SESSION["username"];
	?>
</head>
<body>
		<div class="top"><!--Top som inehåller hela bannern på topen av varje sida-->
			<div class="top__title">
				Digiotek	
			</div>
			<div class="top__text">
				Välkommen <?php echo $namn?>
			</div>
			<div class="banner__div"><a class="banner__link" href="php/Loggaut.php">Logga ut</a></div>
		</div>
	<div class="main-admin">
		<div class="formbox">
			<h1>Redigera en bok</h1>
			<form method="POST" action="<?php echo $_SERVER["PHP_SELF"];?>"><!--From för sql-->
				<div>
					<label for="BookEdit">Book to edit</label><br>
					<select id="BookEdit" name="BookEdit">
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
							    else{
							        echo "No records matching your query were found.";
							    }
							} 
							else{
							    echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
							}
						?>
					</select>
				</div>
				<div class="form_lefthalf">
					<label for="Title">Title</label><br>
					<input type="text" id="Title" name="Title"><br>
					<label for="Author">Author</label><br>
					<input type="text" id="Author" name="Author"><br>
					<label for="Releasedate">Release date</label><br>
					<input type="number" id="Releasedate" name="Releasedate"><br>
				</div>
				<div>
					<br><input class="submit" type="submit" value="Uppdatera">
				</div>
			</form>
				<?php //Kollar om formet har blivit submitat och updatera värderna från formet till tablen BokDataBAs
					if (isset($_POST['Title'])) {
						$Title = $_POST['Title'];
						$Author = $_POST['Author'];
						$Releasedate = $_POST['Releasedate'];
						$BookEdit = $_POST['BookEdit'];

						$sql = "SELECT * FROM
						BokDataBas
						WHERE
						Title = '$Title'
						AND
						Author = '$Author'
						AND
						RealeaseDate = '$Releasedate'";

						if ($result = mysqli_query($link,$sql)) 
						{
							if (mysqli_num_rows($result)==0) {
								$sql = "UPDATE BokDataBas SET Title=?, Author=?, RealeaseDate=? 
								WHERE
								Id = ?";
								if($stmt = mysqli_prepare($link, $sql)){
			    					mysqli_stmt_bind_param($stmt, "siii", $Title, $Author, $Releasedate, $BookEdit);
			    					mysqli_stmt_execute($stmt);
			    					echo "Records updated successfully";
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
		</div>
		<div class="formbox">
			<h1>Redigera en Författare</h1>
			<form method="POST" action="<?php echo $_SERVER["PHP_SELF"];?>"><!--From för sql-->
				<div>
					<label for="Författare">Författare att ändra</label><br>
					<select id="Författare" name="Författare">
						<?php //Skriver ut all böcker i en select tabell
							$sql = "SELECT * FROM AutorDataBas
 								ORDER BY AuthorName";
							if($result = mysqli_query($link, $sql)){
							    if(mysqli_num_rows($result) > 0){
							        while($row = mysqli_fetch_array($result)){
							                echo  "<option value=".$row['AuthorID'].">".$row['AuthorName']."</option>";

							        }
							        mysqli_free_result($result);
							    } 
							    else{
							        echo "No records matching your query were found.";
							    }
							} 
							else{
							    echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
							}
						?>
					</select>
				</div>
				<div class="form_lefthalf">
					<label for="AuthorName">Author</label><br>
					<input type="text" id="AuthorName" name="AuthorName"><br>
				</div>
				<div>
					<br><input class="submit" type="submit" value="Uppdatera">
				</div>
			</form>
				<?php  //Kollar om formet har blivit submitat och updatera värderna från formet till tablen AuthorDatabas
					if (isset($_POST['AuthorName'])) {
						$AuthorName = $_POST['AuthorName'];
						$Författare = $_POST['Författare'];

						$sql = "SELECT * FROM
						AutorDataBas
						WHERE
						AuthorName = '$AuthorName'";

						if ($result = mysqli_query($link,$sql)) 
						{
							if (mysqli_num_rows($result)==0) {
								$sql = "UPDATE AutorDataBas SET AuthorName=?
								WHERE
								AuthorID = ?";
								if($stmt = mysqli_prepare($link, $sql)){
			    					mysqli_stmt_bind_param($stmt, "si", $AuthorName, $Författare);
			    					mysqli_stmt_execute($stmt);
			    					echo "Records updated successfully";
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
		</div>
		<div class="banner__div"><a class="banner__link" href="index.php">Tillbaka</a></div>
	</div>
</body>
</html>


