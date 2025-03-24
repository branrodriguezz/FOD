{3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con datos ingresados desde teclado. 
De cada empleado se registra: número de empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con DNI 00. 
La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario una única vez.}

program p1ej3;
type
	empleado = record
		numero: integer;
		apellido: string[15];
		nombre: string[15];
		edad: integer;
		dni: string;
	end;
	
	archivo = file of empleado;

// ------------------------------------------ IMPRIMIR EMPLEADOS ---------------------------------------------------------------------
procedure imprimirEmpleado (e: empleado);
begin
	write (' | Numero: ' , e.numero , ' | Apellido: ' , e.apellido , ' | Nombre: ' , e.nombre , ' | Edad: ' , e.edad , ' | DNI: ' , e.dni , ' | ');
	writeln ();
end;
// ------------------------------------------ IMPRIMIR EMPLEADOS ---------------------------------------------------------------------


// ------------------------------------------ A --------------------------------------------------------------------------------------
procedure leerEmpleado(var e: empleado);
begin
	writeln (' Ingrese apellido: ');
	readln (e.apellido);
	if (e.apellido <> 'fin') then begin
		writeln (' Ingrese numero de empleado: ');
		readln (e.numero);
		writeln ('Ingrese nombre: ' );
		readln (e.nombre);
		writeln (' Ingrese edad: ');
		readln (e.edad);
		writeln (' Ingrese DNI: ');
		readln (e.dni);
	end;
end;

procedure cargarEmpleados (var arc_logico: archivo);
var
	e: empleado;
begin
	leerEmpleado (e);
	while (e.apellido <> 'fin') do begin
		write (arc_logico,e);
		leerEmpleado (e);
	end;
end;
// ------------------------------------------ A --------------------------------------------------------------------------------------

// ------------------------------------------ B ---------------------------------------------------------------------
// i
function cumple (nombre, apellido, dato: string): boolean;
begin
	cumple:= ((nombre = dato) or (apellido = dato));
end;

procedure datosDeterminado (var arc_logico: archivo);
var
	dato: string[15];
	e: empleado;
	
begin
	reset (arc_logico);
	writeln (' Ingrese un nombre o un apellido: ');
	readln (dato);
	writeln (' ------------------------------ LISTADO DE EMPLEADOS CON EL DATO PROPORCIONADO POR USTED -------------------------------------- ');
	while (not EOF(arc_logico)) do begin
		read (arc_logico, e);
		if (cumple(e.nombre, e.apellido, dato)) then 
			imprimirEmpleado (e);
	end;
	close (arc_logico);
end;
//i

//ii
procedure datosEmpleados (var arc_logico: archivo);
var
	e: empleado;
begin
	reset (arc_logico);
	writeln (' ------------------------------ LISTADO DE TODOS LOS EMPLEADOS -------------------------------------- ');
	while (not EOF(arc_logico)) do begin
		read (arc_logico, e);
		imprimirEmpleado (e);
	end;
	close (arc_logico);
end;

//ii

//iii
procedure datosMayores70 (var arc_logico: archivo);
var
	e: empleado;
begin
	reset (arc_logico);
	writeln (' ------------------------------ LISTADO DE EMPLEADOS PRÓXIMOS A JUBILARSE -------------------------------------- ');
	while (not EOF(arc_logico)) do begin
		read (arc_logico, e);
		if (e.edad >= 70) then 
			imprimirEmpleado (e);
	end;
	close (arc_logico);
end;

//iii

procedure elegirOpcion (var arc_logico: archivo);
var
	opcion: integer;
begin
	writeln (' ---------------------------------------- ELEGIR OPCION: ------------------------------------------------------ ' );
	writeln (' 1: LISTADO DE EMPLEADOS CON NOMBRE O APELLIDO DETERMINADO ');
	writeln (' 2: LISTADO DE TODOS LOS EMPLEADOS ' );
	writeln (' 3: LISTADO DE EMPLEADOS MAYORES A 70 AÑOS, PROXIMOS A JUBILARSE ');
	writeln (' 4: SALIR Y TERMINAR EL PROGRAMA ');
	readln (opcion);
	
	while (opcion <> 4) do begin
		case opcion of
			1: datosDeterminado (arc_logico);
			2: datosEmpleados (arc_logico);
			3: datosMayores70 (arc_logico);
		else
			writeln (' LA OPCION INGRESADA NO ESTA DISPONIBLE ');
		end;
		
		writeln (' ---------------------------------------- ELEGIR OPCION: ------------------------------------------------------ ' );
		writeln (' 1: LISTADO DE EMPLEADOS CON NOMBRE O APELLIDO DETERMINADO ');
		writeln (' 2: LISTADO DE TODOS LOS EMPLEADOS ' );
		writeln (' 3: LISTADO DE EMPLEADOS MAYORES A 70 AÑOS, PROXIMOS A JUBILARSE ');
		writeln (' 4: SALIR Y TERMINAR EL PROGRAMA ');
		readln (opcion);
	end;	
end;

var
	arc_logico: archivo;
	arc_fisico: string[15];
begin

	writeln (' Ingrese el nombre de archivo: ');
	readln (arc_fisico);
	assign (arc_logico, arc_fisico);
	rewrite (arc_logico); //creo un archivo nuevo
	cargarEmpleados (arc_logico);
	elegirOpcion (arc_logico);
	
end.
