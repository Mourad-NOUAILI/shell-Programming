<?php	
$mysqli = new mysqli("localhost", "root", "123456", "dbBotWeb");
if ($mysqli->connect_errno) {
    echo "Echec lors de la connexion à MySQL : (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
}
echo $mysqli->host_info . "\n";
?>
