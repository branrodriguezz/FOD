{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir uno o más empleados al final del archivo con sus datos ingresados por teclado.
b. Modificar edad a uno o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}

program p1ej4;
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

//iv
function estaRepetido (var arc_logico: archivo; numero: integer): boolean;
var
	e: empleado;
	repetido: boolean;
begin
	repetido:= false;
	while (not EOF(arc_logico) and (not repetido)) do begin
		read (arc_logico,e);
		if (e.numero = numero) then 
			repetido:= true;
	end;
	estaRepetido:= repetido;
end;


procedure agregarEmpleados (var arc_logico: archivo);
var
	e: empleado;
begin
	
	reset (arc_logico);
	writeln (' Ingrese datos del nuevo empleado ');
	leerEmpleado (e);
	while (e.apellido <> 'fin') do begin
		//verifico si esta repetido 
		if (not estaRepetido(arc_logico, e.numero)) then begin //agrego al final si me devuelve falso nada mas
			seek (arc_logico, fileSize(arc_logico));
			write (arc_logico, e);
	    end;
	    writeln (' Ingrese datos del nuevo empleado ');
		leerEmpleado (e);
	end;
	
	close (arc_logico);
end;

//iv 

//v
procedure modificarEdad (var arc_logico: archivo);
var
	e: empleado;
	numero, edad: integer;
	encontre: boolean;
begin
	
	reset (arc_logico);
	encontre:= false;
	writeln (' Ingrese el numero de empleado a modificar la edad ');
	readln (numero);
	
	while (not EOF(arc_logico) and (not encontre)) do begin
		read (arc_logico,e);
		if (e.numero = numero) then begin
			encontre:= true;
			writeln (' Ingrese la edad modificada ');
			readln (edad);
			e.edad:= edad;
			seek (arc_logico, fileSize(arc_logico)-1);
			write (arc_logico, e); //se puede escribir solo el campo edad o se reescribe todo el registro de nuevo?
		end;
	end;
	if (encontre) then 
		writeln ('Cambios guardados')
	else
		writeln ('No se encontro el numero de empleado dentro del archivo');
	close (arc_logico);
end;

//v

//vi
procedure exportarArchivo (var arc_logico: archivo);
var
	arc_texto: text;
	e: empleado;
	
begin
	
	assign (arc_texto, 'todos_empleados.txt');
	rewrite (arc_texto);
	reset (arc_logico);
	while (not EOF(arc_logico)) do begin
		read (arc_logico, e);
		writeln (arc_texto, e.numero, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' ', e.dni, ' ');
	end;
	//hacer close del archivo nuevo?
	writeln (' ARCHIVO EXPORTADO CORRECTAMENTE '); 
	close (arc_logico);
end;

//vi

//vii
procedure exportarArchivoDNI(var arc_logico: archivo);
var
	arc_texto_dni: text;
	e: empleado;
	
begin
	assign (arc_texto_dni,'faltaDNIEmpleado.txt');
	rewrite (arc_texto_dni);
	reset (arc_logico);
	while (not EOF(arc_logico)) do begin
		read (arc_logico, e);
		if (e.dni = '00') then 
			writeln (arc_texto_dni, e.numero, ' ', e.apellido, ' ', e.nombre, ' ', e.edad, ' ', e.dni, ' ');
	end;
	writeln (' ARCHIVO EXPORTADO CORRECTAMENTE ');
	close (arc_logico);
end;

//vii


procedure elegirOpcion (var arc_logico: archivo);
var
	opcion: integer;
begin
	writeln (' ---------------------------------------- ELEGIR OPCION: ------------------------------------------------------ ' );
	writeln (' 1: LISTADO DE EMPLEADOS CON NOMBRE O APELLIDO DETERMINADO ');
	writeln (' 2: LISTADO DE TODOS LOS EMPLEADOS ' );
	writeln (' 3: LISTADO DE EMPLEADOS MAYORES A 70 AÑOS, PROXIMOS A JUBILARSE ');
	writeln (' 4: AGREGAR UNO O MÁS EMPLEADOS ');
	writeln (' 5: MODIFICAR EDAD A UNO O MAS EMPLEADOS ');
	writeln (' 6: EXPORTAR EL CONTENIDO DEL ARCHIVO A UN ARCHIVO DE TEXTO LLAMADO "TODOS_EMPLEADOS.TXT" ');
	writeln (' 7: EXPORTAR A UN ARCHIVO DE TEXTO LLAMADO: " FALTADNIEMPLEADO.TXT " , LOS EMPLEADOS QUE NO TENGAN CARGADO EL DNI (DNI en 00)');
	writeln (' 8: SALIR Y TERMINAR EL PROGRAMA ');
	readln (opcion);
	
	while (opcion <> 8) do begin
		case opcion of
			1: datosDeterminado (arc_logico);
			2: datosEmpleados (arc_logico);
			3: datosMayores70 (arc_logico);
			4: agregarEmpleados (arc_logico);
			5: modificarEdad (arc_logico);
			6: exportarArchivo (arc_logico);
			7: exportarArchivoDNI (arc_logico);
		else
			writeln (' LA OPCION INGRESADA NO ESTA DISPONIBLE ');
		end;
		
		writeln (' ---------------------------------------- ELEGIR OPCION: ------------------------------------------------------ ' );
		writeln (' 1: LISTADO DE EMPLEADOS CON NOMBRE O APELLIDO DETERMINADO ');
		writeln (' 2: LISTADO DE TODOS LOS EMPLEADOS ' );
		writeln (' 3: LISTADO DE EMPLEADOS MAYORES A 70 AÑOS, PROXIMOS A JUBILARSE ');
		writeln (' 4: AGREGAR UNO O MÁS EMPLEADOS ');
		writeln (' 5: MODIFICAR EDAD A UNO O MAS EMPLEADOS ');
		writeln (' 6: EXPORTAR EL CONTENIDO DEL ARCHIVO A UN ARCHIVO DE TEXTO LLAMADO "TODOS_EMPLEADOS.TXT" ');
		writeln (' 7: EXPORTAR A UN ARCHIVO DE TEXTO LLAMADO: " FALTADNIEMPLEADO.TXT " , LOS EMPLEADOS QUE NO TENGAN CARGADO EL DNI (DNI en 00)');
		writeln (' 8: SALIR Y TERMINAR EL PROGRAMA');
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
