<?php //Tar bort raden med rätt id som skickades över från javascriptet
  include "../../connect.php"; 

$id = $_POST['id'];

$sql = "DELETE FROM UsersBoksDataBas WHERE ID = $id";

if (mysqli_query($link, $sql)) {
  header( "Location: https://isakpetersson.kaggteknik.se/Slutprojekt/home.php");
  echo 'Row deleted successfully';
} else {
  echo 'Error deleting row: ' . mysqli_error($conn);
}
mysqli_close($link);
?>
