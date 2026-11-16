<?php
  include 'top.php';
  include "connect.php"; 
?>
<form action="loggain.php" method="GET">
    <label for="username">Username:</label>
    <input type="text" name="username" id="username">
    <label for="password">Password:</label>
    <input type="text" name="password" id="password">	
    <input type="submit" value="Submit">
</form>
<?php
$username = $_REQUEST['username'];
$password = $_REQUEST['password'];

$sql = "SELECT * FROM Users
WHERE password = .$password AND username = $username";
if(){
	echo "Good"
}
else {
	echo "Fail";
}
?>
<?php
  include 'bottom.php' 
?>