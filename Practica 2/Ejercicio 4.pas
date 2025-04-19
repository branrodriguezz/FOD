{4. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}

program p2ej4;
const

	valor_alto = 9999;
	dF = 4;
	
type
	
	subrango = 1..dF;
	
	registro_maestro = record
		cod: integer;
		nombre: string[15];
		descripcion: string[15];
		stock_dispo: integer;
		stock_min: integer;
		precio: real;
	end;
	
	registro_detalle = record
		cod: integer;
		cant: integer;
	end;
	
	maestro = file of registro_maestro;
	detalle = file of registro_detalle;
	
	registro_datos = record
		reg: registro_detalle;
		archivo: detalle;
	end;
	
	vector_detalle = array [subrango] of registro_datos; //vector de detalles
	
procedure leerMaestro (var rM: registro_maestro);
begin
	writeln (' Codigo: ');
	readln (rM.cod);
	if (rM.cod > 0) then begin
		writeln (' Nombre: ');
		readln (rM.nombre);
		writeln (' Descripcion: ');
		readln (rM.descripcion);
		writeln (' Stock disponible: ');
		readln (rM.stock_dispo);
		writeln (' Stock minimo: ');
		readln (rM.stock_min);
		writeln (' Precio: ');
		readln (rM.precio);
		writeln ();
	end;
end;

procedure cargarMaestro (var aM: maestro);
var
	rM: registro_maestro;
begin

	writeln (' Carga de archivo maestro ');
	rewrite (aM);
	leerMaestro (rM);
	while (rM.cod > 0) do begin
		write (aM,rM);
		leerMaestro (rM);
	end;
	close (aM);
	writeln (' Carga de archivo maestro finalizada');
end;

procedure leerDetalle (var rD: registro_detalle);
begin
	writeln (' Codigo: ');
	readln (rD.cod);
	if (rD.cod > 0) then begin
		writeln (' Cantidad vendida: ');
		readln (rD.cant);
		writeln ();
	end;
end;

procedure cargarDetalle (var d: detalle);
var

	rD: registro_detalle;
	
begin
	
	rewrite (d);
	leerDetalle (rD);
	while (rD.cod > 0) do begin
		write (d, rD);
		leerDetalle (rD);
	end;
	close (d);
end;

procedure generarDetalles (var vec: vector_detalle);
var
	i: integer;
	nombre: string;
begin
	writeln (' Cargando archivos detalles ');
	for i := 1 to dF do begin
		str (i, nombre);
		assign (vec[i].archivo, 'detalle ' + nombre + '.dat');
		cargarDetalle (vec[i].archivo);
	end;
	writeln (' Carga de archivos detalles finalizada ');
end;

procedure leer (var rD: registro_datos); //recibo el nuevo registro que tiene codigo y archivo
begin
	if (not EOF (rD.archivo)) then begin
		read (rD.archivo, rD.reg);
		writeln('Leído: Cod=', rD.reg.cod, ' Cant=', rD.reg.cant);
	end
	else
		rD.reg.cod:= valor_alto;
		writeln('Archivo vacío o fin de archivo');
end;

procedure reporteTexto (var aM: maestro);
var
	t: text;
	rM: registro_maestro;
begin
	
	assign (t, 'reporte.txt');
	rewrite (t);
	reset (aM);
	while (not EOF (aM)) do begin
		read (aM, rM);
		if (rM.stock_dispo < rM.stock_min) then
			writeln (t, rM.cod, ' ', rM.stock_dispo, ' ', rM.nombre);
			writeln (t, rM.stock_min, ' ', rM.precio, ' ', rM.descripcion);
	end;
	close (aM);
	close (t);
end;

procedure minimo (var vec: vector_detalle; var min: registro_detalle);
var
	i, pos: subrango;
begin
	
	min.cod := valor_alto;
	for i := 1 to dF do begin
		if (vec[i].reg.cod < min.cod) then begin
			min.cod:= vec[i].reg.cod;
			pos:= i;
		end;
	end;
	if (min.cod <> valor_alto) then
		leer (vec[pos]);
end;

procedure actualizarMaestro (var aM: maestro; var vec: vector_detalle);
var

	min: registro_detalle;
	i: subrango;
	aux, cant: integer;
	rM: registro_maestro;
	
begin

	reset (aM);
	read (aM, rM); //leo x lo menos una vez el maestro 
	for i := 1 to dF do begin
		reset (vec[i].archivo);
		writeln('Archivo detalle ', i, ' abierto correctamente.');
		leer (vec[i]);
	end;
	
	minimo (vec,min);
	while (min.cod <> valor_alto) do begin
		aux:= min.cod;
		cant:= 0;
		while ((min.cod <> valor_alto) and (aux = min.cod)) do begin 
			cant:= cant + min.cant;
			minimo (vec, min); //leo el siguiente 
		end;
		
		//busco en el maestro
		while (rM.cod <> aux) do begin
			read (aM, rM);
		end; 
		//lo encontre entonces escribo
		seek (aM, filepos(aM)-1);
		rM.stock_dispo:= rM.stock_dispo - cant;
		write (aM, rM);
		
		if (not EOF (aM)) then begin
			read (aM, rM);
		end;
	end;
	
	reporteTexto (aM);
	close (aM);
	for i:= 1 to dF do begin
		close (vec[i].archivo);
	end;
end;


procedure imprimirMaestro (var aM: maestro);
var
	rM: registro_maestro;
begin
	
	reset (aM);
	while (not EOF (aM)) do begin
		read (aM,rM);
		write (' Producto: | ', ' Codigo: ' , rM.cod, ' | ', rM.nombre , ' | Descripcion: ', rM.descripcion, ' | Stock disponible: ', rM.stock_dispo, ' | Stock minimo: ', rM.stock_min, ' | Precio: ', rM.precio:0:2, ' | ');
		writeln ();
	end;
	close (aM);
end;

var

	vec: vector_detalle;
	aM: maestro;
	
begin

	//-------------- carga ------------------
	assign (aM, 'Archivo maestro');	
	cargarMaestro (aM);
	generarDetalles (vec);
	imprimirMaestro (aM);
	//-------------- actualizacion ---------------
	writeln (' Actualizacion de maestro ');
	actualizarMaestro (aM, vec);
	imprimirMaestro (aM);
end.
