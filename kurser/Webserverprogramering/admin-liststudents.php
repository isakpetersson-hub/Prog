<!DOCTYPE html>
<html lang="sv">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/mall.css">
	<title>Forms</title>
	<?php
	include "connect.php"; 
	?>
</head>
<body>
	<nav class="leftnav">
		<h2>Start</h2>
		<a>Start</a><br>
		<h2>Modifiera</h2>
		<a href="admin-add.php">Lägg till</a>
		<a href="admin-edit.php">Redigera</a><br>
		<h2>Lista</h2>
		<a href="admin-listsubjects.php">Alla ämnen</a>
		<a class="activepage">Alla elever</a><br>
		<h2>Admin</h2>
		<a>Källkoder</a>
		<a>Återställ databasen</a>
	</nav>
	<div class="rightpanel">
		<h1>Visa alla elever</h1>
		<div class="formbox">
			<table>
				<thead>
					<tr>
						<th>#</th><th>Elev</th><th>Födelsedag</th><th>Ämnekoder</th>
					</tr>
				</thead>
				<tbody>
					<?php
					$counter = 1;
 $sql = "SELECT * FROM Elevdatabas";
if($result = mysqli_query($link, $sql)){
    if(mysqli_num_rows($result) > 0){
        while($row = mysqli_fetch_array($result)){
                echo  '<tr> <td>'.$counter .'<td>'.$row['first_name'].' '. $row['last_name'].'</td><td>'.$row['birthday'].'</td><td>'.$row['subject'].'</td></tr>';
                $counter++;
        }
        mysqli_free_result($result);
    } else{
        echo "No records matching your query were found.";
    }
} else{
    echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
}
?>
				</tbody>
				
			</table>
		</div>
	</div>
</body>
</html>