<?php
include "connect.php";

$sql = "INSERT INTO persons (first_name, last_name, email) VALUES
            ('John', 'Rambo', 'johnrambo@mail.com'),
            ('Clark', 'Kent', 'clarkkent@mail.com'),
            ('John', 'Carter', 'johncarter@mail.com'),
            ('Harry', 'Potter', 'harrypotter@mail.com')";
if (mysqli_query($link, $sql)) {
	echo "Table created successfully";
} else
	echo "ERROR: Could not able to execute $sql. " . mysqli_error($link)
?>