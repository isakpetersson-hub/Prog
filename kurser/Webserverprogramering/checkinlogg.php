<?php
  session_start();
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
  include "top.php"
?>
    <?php
    if(($_SESSION["username"]) == "admin" && ($_SESSION["password"]) == "admin"){
    	header("Location: https://isakpetersson.kaggteknik.se/admin.php");
    }
    else{
    	echo "Wrong username or password";
    }
    ?>
<?php
  include "bottom.php"
?>
</body>
</html>