
<!DOCTYPE html>
<html lang="sv">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" type="text/css" href="css/mall.css">
	<title>Forms</title>
</head>
<?php
include "connect.php"; 
if (isset($_POST['fname'])) {
	$förnamn = $_POST['fname'];
	$efternamn = $_POST['lname'];
	$födelsedag = $_POST['birthday'];
	$ämne = $_POST['subject_student'];

	$sql = "SELECT * FROM Elevdatabas
	WHERE
	first_name = '$förnamn'
	AND
	last_name = '$efternamn'
	AND
	birthday = '$födelsedag'";

	if ($result = mysqli_query($link,$sql)) 
	{
		if (mysqli_num_rows($result)==0) {
			$sql = "INSERT INTO Elevdatabas (first_name, last_name, birthday) 
					VALUES ('$förnamn', '$efternamn', '$födelsedag')";
			if (mysqli_query($link,$sql)) {
				$sql2 = "SELECT id FROM Elevdatabas
						WHERE last_name = '$efternamn' AND first_name = '$förnamn'";
				if($result = mysqli_query($link, $sql2)){
    				if(mysqli_num_rows($result) > 0){
        				while($row = mysqli_fetch_array($result)){
                				$studentid = $row['id'];
						}
					}
				}
				$sql3 = "INSERT INTO ElevSubject (ElevID,SubjectID)
					VALUES('$studentid','$ämne')";
			}
		}
		else{
		echo("This student already exsits");
		}	
	}



	$sql2 = "SELECT * FROM
	Elevdatabas
	WHERE
	id = '$ämne'";

	if ($result = mysqli_query($link,$sql2)) 
	{
		if (mysqli_num_rows($result)==0) {
			$sql3 = "INSERT INTO Elevdatabas (first_name, last_name, birthday ) 
					VALUES ('$förnamn', '$efternamn', '$födelsedag')";

			if (mysqli_query($link,$sql3)) {
				echo "Records inserted successfully.";
			}
			else{
				echo "ERROR: Could not able to execute $sql. " .mysqli_error($link);
			}
		}
		else{
			echo("This student already exsits");
		}
	}
 
}
if (isset($_POST['subject_name'])) {
	$subject_name = $_POST['subject_name'];
	$subject_code = $_POST['subject_code'];
	$subject_start = $_POST['subject_start'];
	$subject_end = $_POST['subject_end'];

	$sql = "SELECT * FROM
	Ämnedatabas
	WHERE
	subject = '$subject_name'
	AND
	subjectcode = '$subject_code'
	AND
	startdate = '$subject_start'
	AND
	enddate = '$subject_end'";

	if ($result = mysqli_query($link,$sql)) 
	{
		if (mysqli_num_rows($result)==0) {
			$sql = "INSERT INTO Ämnedatabas(subject,subjectcode,startdate,enddate)
					VALUES('$subject_name','$subject_code','$subject_start','$subject_end')";

			if (mysqli_query($link,$sql)) {
				echo "Records inserted successfully.";
			}
			else{
				echo "ERROR: Could not able to execute $sql. " .mysqli_error($link);
			}
		}
		else{
			echo("This subject already exsits");
		}
	}       
}
 ?>
<body>
	<nav class="leftnav">
		<h2>Start</h2>
		<a>Start</a><br>
		<h2>Modifiera</h2>
		<a class="activepage">Lägg till</a>
		<a href="admin-edit.php">Redigera</a><br>
		<h2>Lista</h2>
		<a href="admin-listsubjects.php">Alla ämnen</a>
		<a href="admin-liststudents.php">Alla elever</a><br>
		<h2>Admin</h2>
		<a>Källkoder</a>
		<a>Återställ databasen</a>
	</nav>
	<div class="rightpanel">
		<h1>Lägg till en post</h1>
		<div class="formbox">
			<form method="post" action="<?php echo $_SERVER["PHP_SELF"];?>">
				<div>
					<h2>Ny elev:</h2>
				</div>
				<div class="form_lefthalf">
					<label for="fname">Förnamn</label><br>
					<input type="text" id="fname" name="fname"><br>
					<label for="birthday">Födelsedag</label><br>
					<input type="date" id="birthday" name="birthday">
				</div>
				<div class="form_righthalf">
					<label for="lname">Efternamn</label><br>
					<input type="text" id="lname" name="lname"><br>
					<label for="subject_student">Ämne</label><br>
					<select id="subject_student" name="subject_student">
						<?php
							$sql = "SELECT subject,id FROM Ämnedatabas";
							if($result = mysqli_query($link, $sql)){
							    if(mysqli_num_rows($result) > 0){
							        while($row = mysqli_fetch_array($result)){
							                echo  "<option value=".$row['id'].">".$row['subject']."</option>";
							        }
							        mysqli_free_result($result);
							    } else{
							        echo "No records matching your query were found.";
							    }
							} else{
							    echo "ERROR: Could not able to execute $sql. " . mysqli_error($link);
							}
						?>
					</select>
					<input class="submit" type="submit" value="Lägg till">
				</div>
			</form>
		</div>
		<div class="formbox">
			<form method="post" action="<?php echo $_SERVER["PHP_SELF"];?>">
				<div>
					<h2>Nytt ämne:</h2>
				</div>
				<div class="form_left70">
					<label for="subject_name">Namn på ämnet</label><br>
					<input type="text" id="subject_name" name="subject_name">
				</div>
				<div class="form_right30">
					<label for="subject_code">Ämnets kod</label><br>
					<input type="text" id="subject_code" name="subject_code">
				</div>
				<div class="form_lefthalf">
					<label for="subject_start">Startdatum</label><br>
					<input type="date" id="subject_start" name="subject_start">
				</div>				<div class="form_righthalf">
					<label for="subject_end">Slutdatum</label><br>
					<input type="date" id="subject_end" name="subject_end"><br>
					<input class="submit" type="submit" value="Lägg till">
				</div>
			</form>
		</div>
	</div>
</body>
</html>