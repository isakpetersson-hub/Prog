<?php
  include 'top.php';
  include "connect.php"; 
 ?>
<form action="registrera.php" method="Post">
    <p>
        <label for="firstName">First Name:</label>
        <input type="text" name="first_name" id="firstName">
    </p>
    <p>
        <label for="lastName">Last Name:</label>
        <input type="text" name="last_name" id="lastName">
    </p>
    <p>
        <label for="username">Användarnamn:</label>
        <input type="text" name="username" id="username">
    </p>
    <p>
        <label for="password">Lösenord:</label>
        <input type="text" name="password" id="password">
    </p>
    <input type="submit" value="Submit">
</form>
<?php

$f_Name = $_REQUEST['first_name'];
$l_Name = $_REQUEST['last_name'];
$username = $_REQUEST['username'];
$password = $_REQUEST['password'];

$sql = "INSERT INTO Users (first_name, last_name, usernamn, password) 
VALUES ('".$f_Name."', '".$l_Name."', ' ".$username."', '".$password."')";
	
if(mysqli_query($link, $sql)){
    echo "Records inserted successfully.";
} else{
    echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
}
?>
<?php
  include 'bottom.php' 
?>