#!/usr/bin/php -q

<?php
set_time_limit(30);
require('phpagi.php');
require("descripcion.inc");
$agi = new AGI();
$agi->answer();
//$option = $agi->request['agi_callerid'];
$option = $agi->get_variable('__IVR_DIGIT_PRESSED');
$agi->verbose($option);

$opcion = $argv[1];

if($opcion==1){ //Consultar lavadoras disponibles

$agi->exec_agi("googletts.agi,\"Consultando lavadoras disponibles\",es");
$test=$agi->get_data('beep', 6000, 30)['result'];

$agi->exec_agi("googletts.agi,\"Ingrese su número de cedula\",es");
$cedula=$agi->get_data('beep', 6000, 30)['result'];
$agi->verbose($cedula);
sleep(1);
$agi->exec_agi("googletts.agi,\"Ingrese  número de apartamento\",es");
$apartamento=$agi->get_data('beep', 6000, 30)['result'];
$agi->verbose($apartamento);
//$agi->exec_agi("googletts.agi,\"El numero es ".$cedula." y el apartamento es ".$apartamento."\",es");
$a=$option['result'];
$b=$option['data'];
//$agi->exec_agi("googletts.agi,\"Resultado ".$opcion." y data es ".$b."\",es");


$link = mysql_connect(HOST, USUARIO,CLAVE); 
mysql_select_db(DB, $link); 
$result = mysql_query("SELECT identificacion,nombres FROM  inquilino where identificacion=".$cedula." and apartamento=".$apartamento."", $link); 
$flag_inquilino=0;

while ($row=mysql_fetch_array($result)){ 

	$flag_inquilino=$flag_inquilino+1;
	$agi->exec_agi("googletts.agi,\"Bienvenido estimado".$row['nombres']."\",es");
	
} 


if($flag_inquilino==0){

	$agi->exec_agi("googletts.agi,\"Cédula ".$cedula."y Apartamento ".$apartamento." no estan registrados\",es");
}
else{

	$query="select lavadoras.id,lavadoras.descripcion from lavadoras where lavadoras.tipo=1 and id not in (select lavadoras.id
	from lavadoras inner join reservas on lavadoras.id=reservas.lavadora 
	inner join servicios on reservas.id=servicios.reserva where lavadoras.tipo=1)";	
	$result=mysql_query($query, $link);
	$flag_lavadoras=0;
	
	while ($row = mysql_fetch_array($result)){ 
	
		$flag_lavadoras++;
		$agi->exec_agi("googletts.agi,\" Lavadora disponible".$row['descripcion']."\",es");
		
	} 


}




}

if($opcion==2){ //Reservar Turno

	
$agi->exec_agi("googletts.agi,\"Reserva de turnos \",es");
$test=$agi->get_data('beep', 6000, 30)['result'];

$agi->exec_agi("googletts.agi,\"Ingrese su número de cedula\",es");
$cedula=$agi->get_data('beep', 6000, 30)['result'];
$agi->verbose($cedula);
sleep(1);

$link = mysql_connect(HOST, USUARIO,CLAVE); 
mysql_select_db(DB, $link); 
$result = mysql_query("SELECT identificacion,nombres FROM  inquilino where identificacion=".$cedula."", $link); 
$flag_inquilino=0;
$user="";
$lavadora=0;

while ($row=mysql_fetch_array($result)){ 

	$flag_inquilino=$flag_inquilino+1;
	$user=$row['nombres'];
	

	
} 


if($flag_inquilino==0){

	$agi->exec_agi("googletts.agi,\"Cedula ".$cedula." no esta registrado\",es");
}
else {

	 //Asginenele un turno

	$result2=mysql_query("select lavadoras.id,lavadoras.descripcion from lavadoras where lavadoras.tipo=1 and id not in (select lavadoras.id
	from lavadoras inner join reservas on lavadoras.id=reservas.lavadora 
	inner join servicios on reservas.id=servicios.reserva where lavadoras.tipo=1)", $link);
	$flag_lavadoras=0;
	
	while ($row=mysql_fetch_array($result2)){ 
	
		$flag_lavadoras++;
		$lavadora=$row['id'];
	    break;
		
	} 


	$agi->verbose($user);
	$agi->verbose($lavadora);


	if($cedula!="" && $lavadora!=0){

		if(mysql_query("Insert into reservas (lavadora, inquilino) values (".$lavadora.", ".$cedula.")", $link)){
			
			$agi->exec_agi("googletts.agi,\"Estimado ".$user." su reserva ha sido registrada con éxito\",es");
			
		}

		else{

			$agi->exec_agi("googletts.agi,\"Estimado ".$user." su reserva ha fallado\",es");
		}


	}



}


}

if($opcion==3){

	$agi->exec_agi("googletts.agi,\"Consultar el estado de sus turno\",es");
	$test=$agi->get_data('beep', 6000, 30)['result'];
	
	//$query="select count(*) from (select id,hora from reservas r1 where id not in (select hora from reservas  r2  where r1.hora<r2.hora and r2.id=3)) as data where data.id not in  (select servicios.reserva from servicios)";	
	
	$agi->exec_agi("googletts.agi,\"Ingrese su número de cedula\",es");
	$cedula=$agi->get_data('beep', 6000, 30)['result'];
	$agi->verbose($cedula);
	sleep(1);

	$link = mysql_connect(HOST, USUARIO,CLAVE); 
	mysql_select_db(DB, $link); 

	$result3=mysql_query("select count(*) as espera from (select id,hora from reservas r1 where id not in (select hora from reservas  r2  where r1.hora<r2.hora and r2.inquilino=".$cedula.")) as data where data.id not in  (select servicios.reserva from servicios)", $link);
	$flag_reservas=0;
	$turno=0;
	while ($row=mysql_fetch_array($result3)){ 
	
		$flag_reservas++;
		//$agi->exec_agi("googletts.agi,\" Lavadora disponible".$row['descripcion']."\",es");
		$turno=$row['espera'];
		
		
	} 
	 

	$agi->verbose($mensaje);

	if($flag_reservas!=0){

		//$agi->exec_agi("googletts.agi,\"Su reserva esta garantizada, debe esperar".$mensaje." turnos para se atendido\",es");
		//$agi->exec_agi("googletts.agi,\"Reserva está garantizada, debe esperar ".$mensaje." turnos para ser atendido \",es");
		$agi->exec_agi("googletts.agi,\"Debe esperar ".$turno." turnos para ser atendido\",es");


	}

	else{

		$agi->exec_agi("googletts.agi,\"Fallo en la operación\",es");
	}
	
	


}




$agi->exec_agi("googletts.agi,\"Gracias por utilizar nuestro sistema hasta pronto \",es");

sleep(4);
$agi->hangup();





?>