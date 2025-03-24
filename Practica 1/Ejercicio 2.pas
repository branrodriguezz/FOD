{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados creados en el ejercicio 1, 
informe por pantalla cantidad de números menores a 1500 y el promedio de los números ingresados. 
El nombre del archivo a procesar debe ser proporcionado por el usuario una única vez. 
Además, el algoritmo deberá listar el contenido del archivo en pantalla.}

program p1ej2;
type
	archivo = file of integer;
	
procedure procesarArchivo (var arc_logico: archivo; var cant: integer; var promedio: real);
var
	nro, prom: integer;
begin
	reset (arc_logico);
	
	prom:= 0;
	while (not EOF (arc_logico)) do begin
		read (arc_logico, nro);
		write (' | ', nro , ' | ');
		if (nro < 1500) then
			cant:= cant + 1;
		prom:= prom + nro;
	end;
	
	promedio:= prom / fileSize (arc_logico);
	
	close (arc_logico);
end;

var
	arc_logico: archivo;
	arc_fisico: string[15];
	cant: integer;
	promedio: real;
	
begin

	writeln (' Ingrese el nombre del archivo del ejercicio 1: ');
	readln (arc_fisico);
	assign (arc_logico,arc_fisico);
	
	cant:= 0;
	promedio:= 0;
	
	procesarArchivo(arc_logico, cant, promedio);
	
	writeln ();
	writeln ('La cantidad de numeros ingresados menores a 1500 es: ' , cant);
	writeln (' El promedio de los numeros ingresados es: ' , promedio);
	
end.

