<?php 
$flag = $_GET["flag"];
$arr = array();
$arr["flag"] = $flag;
$sleepTime = rand(3,10);
sleep($sleepTime);
echo json_encode($arr);
?>
