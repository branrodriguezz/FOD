{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program p3p1ej2;
type
	
	asistente = record
		nro: integer;
		apellido: string[15];
		nombre: string[15];
		email: string[15];
		telefono: integer;
		dni: integer;
	end;
	
	archivo = file of asistente;
	

procedure leerAsistente (var a: asistente);
begin
	writeln ('Nro: ');
	readln (a.nro);
	if (a.nro <> 0) then begin
		writeln ('Apellido: ');
		readln (a.apellido);
		writeln ('Nombre: ');
		readln (a.nombre);
		writeln ('Email: ');
		readln (a.email);
		writeln ('Telefono: ');
		readln (a.telefono);
		writeln ('DNI: ');
		readln (a.dni);
	end;
end;

procedure cargarArchivo (var arc: archivo);
var
	a: asistente;
begin
	rewrite (arc);
	writeln (' Carga de Archivo: ');
	leerAsistente (a);
	while (a.nro <> 0) do begin
		write (arc,a);
		leerAsistente (a);
	end;
	close (arc);
end;

procedure imprimirArchivo (var arc: archivo);
var
	a: asistente;
begin
	
	reset (arc);
	while (not EOF (arc)) do begin
		read (arc,a);
		writeln ('Asistente: ', a.nro, '|' , a.apellido, '|' , a.nombre, '|', a.email, '|', a.telefono, '|', a.dni, '|');
		writeln ();
	end;
	close (arc);
end;

procedure eliminadoLogico (var arc: archivo);
var
	a: asistente;
begin
	reset (arc);
	while (not EOF(arc)) do begin
		read (arc,a);
		if (a.nro < 1000) then begin
			seek (arc,filePos(arc)-1); //vuelvo al anterior
			a.apellido:= '@' + a.apellido; //modifico el registro
			write (arc,a); //lo escribo
		end;
	end;
	
	close (arc);
end;

var
	a: archivo;
begin
	
	assign (a,'Archivo de asistentes a un congreso');
	cargarArchivo (a);
	writeln ('Archivo pre borrado logico');
	imprimirArchivo (a);
	eliminadoLogico (a);
	writeln ('Archivo post borrado logico');
	imprimirArchivo (a);
end.
