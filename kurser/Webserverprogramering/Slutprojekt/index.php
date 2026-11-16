<!DOCTYPE html>
<html lang="sv">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Biblotek</title>
	<link rel="stylesheet" type="text/css" href="css/style.css?v=<?php echo time();?>">
	<?php
		session_start();
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
		<div class="main-index">
			<div class="loggain-form__title">
				Logga in
			</div>
			<form class="loggain-form" method="POST" action="<?php echo $_SERVER["PHP_SELF"];?>"><!--From för inlogg-->
				<div class="loggain-form__username"> 
					<label for="loggain-form__username-input" class="loggain-form__username-label">Username:</label>
    				<input type="text" name="username" id="loggain-form__username-input" class="loggain-form__username-input">
				</div>
				<div class="loggain-form__password">
				    <label for="loggain-form__password-input" class="loggain-form__password-label">Password:</label>
    				<input type="password" name="password" id="loggain-form__password-input" class="loggain-form__password-input">		
				</div>
    			<input type="submit" value="Logga in" class="loggain-form__submit">
			</form>
			<?php //Kollar när formet blir submitat och sparar värderna med session
    			if (isset($_POST['username'])) {
        			$_SESSION['username'] = $_POST['username'];
        			$_SESSION['password'] = $_POST['password'];
    				header("Location: https://isakpetersson.kaggteknik.se/Slutprojekt/checkinlogg.php");
    			}
   			?>
   			<div class="loggain-form__makeaccount">
   				Har du inget Konto? <a href="MakeAccount.php" class="loggain-form__MakeAccount__link">Skapa ett</a>
   			</div>
		</div>
	</div>
</body>
</html>
