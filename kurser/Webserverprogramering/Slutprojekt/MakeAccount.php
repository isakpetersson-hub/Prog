<!DOCTYPE html>
<html lang="sv">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Make Account</title>
	<link rel="stylesheet" type="text/css" href="css/style.css?v=<?php echo time();?>">
	<?php
		include "../connect.php"; 
	?>
</head>
<body>
	<div class="container">
		<div class="top"><!--Top som inehåller hela bannern på topen av varje sida-->
			<div class="top__title">
				Digiotek	
			</div>
			<div class="top__text">
				Ditt online bibliotek
			</div>
		</div>
		<div class="main-Make">
			<div class="loggain-form__title">
				Skapa ett konto
			</div>
			<form class="loggain-form" method="POST" action="<?php echo $_SERVER["PHP_SELF"];?>"><!--From för sql-->
				<div> 
					<label for="username" class="loggain-form__username-label">Username:</label>
    				<input type="text" name="username" id="username" class="loggain-form__username-input">
				</div>
				<div>
				    <label for="password" class="loggain-form__password-label">Password:</label>
    				<input type="password" name="password" id="password" class="loggain-form__password-input">		
				</div>
    			<input type="submit" value="Submit" class="loggain-form__submit">
			</form>
			<?php //Kollar om formen är submitat och skriver in informationen i UserDataBas
    			if (isset($_POST['username'])) {
    				$username = $_POST['username'];
    				$password = $_POST['password'];
    				$hashed_password = password_hash($password, PASSWORD_DEFAULT);
					$sql = "SELECT * FROM
					UserDataBas
					WHERE
					Username = '$username'
					AND
					Password = '$hashed_password'";

					if ($result = mysqli_query($link,$sql)) 
					{
						if (mysqli_num_rows($result)==0) {
							$sql = "INSERT INTO UserDataBas(Username,Password) VALUES (?, ?)";
							if($stmt = mysqli_prepare($link, $sql)){
    							mysqli_stmt_bind_param($stmt, "ss", $username, $hashed_password);
    							mysqli_stmt_execute($stmt);
    							header("Location: https://isakpetersson.kaggteknik.se/Slutprojekt/index.php");
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
   			<div class="main-Make__div"><a class="main-Make__link" href="index.php">Tillbaka</a></div>
		</div>
	</div>
</body>
</html>
