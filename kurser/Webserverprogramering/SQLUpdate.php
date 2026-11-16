<?php 
include "connect.php";
$sql = "UPDATE persons SET 
first_name='John', last_name='Mcclane', email='johnmcclane@mail.com' 
WHERE id=3";
      
if(mysqli_query($link, $sql)){
    echo "Records inserted successfully.";
} else{
    echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
}
?>