{1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program p2ej1;
const
	valor_alto = 9999;
type
	
	empleado = record
		cod: integer;
		nombre: string[15];
		monto: real;
	end;
	
	arc_empleados = file of empleado;
	
procedure leerEmpleado (var e: empleado);
begin
	write (' Codigo: ');
	readln (e.cod);
	if (e.cod <> -1) then begin
		write (' Nombre: ');
		readln (e.nombre);
		write (' Monto: ');
		readln (e.monto);
	end;
end;

procedure cargarDetalle (var aDet: arc_empleados);
var

	e: empleado;
	
begin
	
	assign (aDet, 'Archivo Detalle');
	rewrite (aDet);
	writeln (' Ingrese los datos del empleado: ');
	leerEmpleado (e);
	while (e.cod <> -1) do begin
		write (aDet, e);
		writeln (' Ingrese los datos de otro empleado: ');
		leerEmpleado (e);
	end;
	close (aDet);
end;

procedure leer (var aDet: arc_empleados; var eD: empleado);
begin
	if (not EOF (aDet)) then begin
		read (aDet, eD);
	end
	else 
		eD.cod := valor_alto;
end;

procedure cargarCompacto (var aDet,aMae: arc_empleados);
var
	eD,eM: empleado;
begin
	
	reset (aDet); //abro el archivo detalle
	assign (aMae, ' Archivo Maestro ');
	rewrite (aMae); //creo el archivo maestro
	leer (aDet, eD); 
	while (eD.cod <> valor_alto) do begin
		eM.cod := eD.cod;
		eM.monto := 0;
		eM.nombre := eD.nombre;
		while ((eD.cod <> valor_alto) and (eM.cod = eD.cod)) do begin
			eM.monto := eM.monto + eD.monto;
			leer (aDet, eD);
		end;
		write (aMae,eM);
	end;
	close (aDet);
	close (aMae);
end;

procedure imprimirArchivo (var aMae: arc_empleados);
var
	e: empleado;
begin
	reset (aMae);
	while (not EOF (aMae)) do begin
		read (aMae, e);
		writeln (' Empleado: ');
		write (e.cod, ' | ', e.nombre, ' | ', e.monto:0:2, ' | ');
		writeln ();
	end;
	close (aMae);
end;
	
var

	aDetalle: arc_empleados;
	aMaestro: arc_empleados;
	
begin
	
	cargarDetalle (aDetalle);
	cargarCompacto (aDetalle, aMaestro);
	imprimirArchivo (aMaestro);

end.
