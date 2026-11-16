<!DOCTYPE html>
<html lang="sv">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>CheckLoggin</title>
  <?php
    session_start();
    include "../connect.php"; 
  ?>
</head>
<body>
  <?php //Kollor om inloggnings värderan är korrekta
    $username =  $_SESSION['username'];
    $password = $_SESSION['password'];
    $sql = "SELECT Password,UserID FROM UserDataBas where Username = '$username'";
    if($result = mysqli_query($link, $sql)){
      if(mysqli_num_rows($result) > 0){
        $row = mysqli_fetch_assoc($result);
        $hashed_password = $row['Password']; 
        $id = $row['UserID'];   
        if (password_verify($password, $hashed_password)) {
          $_SESSION['ID'] = $id;
          header("Location: https://isakpetersson.kaggteknik.se/Slutprojekt/home.php"); 
        }
        else{
          header("Location: https://isakpetersson.kaggteknik.se/Slutprojekt/index.php");
        }
      }
      if(($_SESSION["username"]) == "admin" && ($_SESSION["password"]) == "admin"){
          header("Location: https://isakpetersson.kaggteknik.se/Slutprojekt/admin.php");
        }
      else{
        echo "Wrong username or password";
      }
    }
  ?>
</body>
</html>