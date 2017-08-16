<?php
/*require("init.php");

$username = $_POST["login"];
$password = $_POST["mp"];

echo $username."<br>";
echo $password."<br>";

$query = "select * from users where username ='".$username."' and password ='".$password."';";
	
$result = $mysqli->query($query);
echo $mysqli->affected_rows."<br>";

//Puisque le champ username de la table users est primaire. 
//On est certain que la requête va sélectionner 0 ou un seul 
//enregistrement.



if ( $mysqli->affected_rows == 1) {
		$row = mysqli_fetch_assoc($result);
		echo 'Bienvenue '.$row['username'].'<br>';
}
else if ($mysqli->affected_rows == 0) 
		echo 'Désolé username et/ou mot de passe incorrecte<br>';*/


$username = $_POST["login"];
$password = $_POST["mp"];


echo $username."<br>";
echo $password."<br>";

//$username = preg_replace('~[.[:cntrl:][:space:]]~', '', $username);
$pass = 'ocean2016';

if (strcmp($password, $pass) == 0) 
		echo 'Bienvenue '.$username.'<br>';

else 
		echo 'Désolé username et/ou mot de passe incorrecte<br>';	
	
?>
