<!doctype html>
<html lang="en">
<?php
  $namn = "Isak";
?>
  <head> 
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Webbserverprogrammering</title>
 
    <!-- Bootstrap CSS ska finnas kvar-->
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEAg3QhqLMpG8r+8fhAXLRk2vvoC2f3B09zVXn8CA5QIVfZOJ3BCsw2P0p/We" crossorigin="anonymous">

    <!-- Egen CSS -->

    <link rel="stylesheet" type="text/css" href="css/style.css">
  </head>
  <body>  
    <div class="jumbotron text-center pt-5 pb-5 bg-secondary text-white">
      <?php echo '<h1>WebbServerProgrammering år '. date("Y") .'</h1>';
       echo " <h3>". $namn ?>
    </div>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
      <div class="container-fluid">
        <a class="navbar-brand" href="index.php">Start</a>
        
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
           <li class="nav-item">
            <a class="nav-link" href="phpquestion.php">PHP-Frågor</a>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="info.php">Test</a>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="//webutveckling\Aga.se/index.php">Webbutveckling 2</a>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="cookies.php">Cookies</a>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="inlogg.php">Logg in</a>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="https://theta.hostup.se/phpMyAdmin/">Databas</a>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="SQL-frågor.php">SQL-Frågor</a>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="nätbutukphpfrågor.php">Nätbutik-Frågor</a>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="registrera.php">Registrera</a>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="loggain.php">Logga in</a>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="admin-add.php">Elevdatabas</a>
            </li>
            </li>
            <li class="nav-item">
            <a class="nav-link" href="Slutprojekt/index.php">Slutprojekt</a>
            </li>
             <!-- mer länkar här -->
          </ul>
        </div>
      </div>
    </nav>