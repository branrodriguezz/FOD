{Realizar un algoritmo que cree un archivo de números enteros no ordenados y 
permita incorporar datos al archivo. Los números son ingresados desde teclado. 
El nombre del archivo debe ser proporcionado por el usuario desde teclado. 
La carga finaliza cuando se ingrese el número 30000, que no debe incorporarse al archivo.}

program ejercicio1;
type 
	archivo = file of integer;
	
procedure agregarNumeros (var arc_logico: archivo);
var
	n: integer;
	
begin

	reset(arc_logico);
	writeln (' Ingrese un numero: ');
	readln (n);
	while (n <> 30000) do begin
		write (arc_logico,n);
		writeln (' Ingrese un numero: ');
		readln (n);
	end;
	close (arc_logico);
	
end;

procedure imprimir (var arc_logico: archivo);
var
	num: integer;
begin

	reset (arc_logico);
	while (not EOF(arc_logico)) do
	begin
		read(arc_logico, num);
		writeln (num , ' | ' );
	end;
	close (arc_logico);
end;

var
	arc_fisico: string [15];
	arc_logico: archivo;
	
begin
	
	writeln (' Ingrese el nombre de archivo: ');
	readln (arc_fisico);
	assign (arc_logico, arc_fisico);
	rewrite (arc_logico);
	agregarNumeros (arc_logico);
	imprimir (arc_logico);
end.


