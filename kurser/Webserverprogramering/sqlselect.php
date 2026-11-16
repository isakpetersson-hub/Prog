<?php
 
include "connect.php";
// Attempt select query execution
$sql = "SELECT * FROM Member";
if($result = mysqli_query($link, $sql)){
    if(mysqli_num_rows($result) > 0){
        while($row = mysqli_fetch_array($result)){
                echo  $row['MemberId'] . "<br>";
                echo  $row['FirstName'] . "<br>";
                echo  $row['LastName'] . "<br>";
                echo  $row['Age'];
        }
        // Free result set
        mysqli_free_result($result);
    } else{
        echo "No records matching your query were found.";
    }
} else{
    echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
}
 
// Close connection
mysqli_close($link);
?>