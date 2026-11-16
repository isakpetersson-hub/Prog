<?php
	session_start();

	include "top.php"
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title></title>
</head>
<body>
	<?php 
	if (isset($_COOKIE['username'])) {
		echo "Hi ". $_COOKIE['username']. " welcome back!<br>";
		echo "Senaste gången du var här var för ". time()-$_SESSION['Date']. " sekunder sedan";
	}
	else{
		echo "welcome new guest";
	}
	setcookie("username","Jonte", time()+30*24*60*60);
	$_SESSION['Date'] = time();
	?>
</body>
</html>
<?php
	include "bottom.php"
?>