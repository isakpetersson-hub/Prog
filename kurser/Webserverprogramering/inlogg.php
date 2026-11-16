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
  <br>
    <form method="get" action="<?php echo $_SERVER["PHP_SELF"];?>">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username">
        <label for="password">Password:</label>
        <input type="text" name="password" id="password">	
        <input type="submit" value="Submit">
    </form>
    <?php 
    	if (isset($_GET['username'])) {
        $_SESSION['username'] = $_GET['username'];
        $_SESSION['password'] = $_GET['password'];
    		header("Location: https://isakpetersson.kaggteknik.se/checkinlogg.php");
    	}
    ?>
</body>
</html>
<?php
  include "bottom.php"
?>