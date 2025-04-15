{2. El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
●Ambos archivos están ordenados por código de producto.
●Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
●El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté por debajo del stock mínimo permitido.}

program p2ej2;
const
	valor_alto = 9999;
type
	
	producto = record
		cod: integer;
		nomComercial: string [15];
		precio: real;
		stock_actual: integer;
		stock_minimo: integer;
	end;
	
	venta = record
		codProd: integer;
		cant_vendida: integer;
	end;
	
	arc_maestro = file of producto;
	arc_detalle = file of venta;
	
procedure leerProducto (var p: producto);
begin
	write (' Codigo: ');
	readln (p.cod);
	if (p.cod > 0) then begin
		write (' Nombre: ');
		readln (p.nomComercial);
		write (' Precio: ');
		readln (p.precio);
		write (' Stock actual: ');
		readln (p.stock_actual);
		write (' Stock minimo: ');
		readln (p.stock_minimo);
	end;
end;

procedure cargarArchivoMaestro (var aM: arc_maestro);
var
	p: producto;
begin
	
	rewrite (aM);
	writeln (' Ingrese los datos del producto: ');
	leerProducto (p);
	while (p.cod > 0) do begin
		write (aM,p);
		writeln (' Ingrese los datos de otro producto: ');
		leerProducto (p);
	end;
	close (aM);
end;

procedure leerVenta (var v: venta);
begin
	
	write (' Codigo: ');
	readln (v.codProd);
	if (v.codProd > 0) then begin
		write (' Cantidad de unidades vendidas: ');
		readln (v.cant_vendida);
	end;
end;

procedure cargarArchivoDetalle (var aD: arc_detalle);
var
	v: venta;
begin
	rewrite (aD);
	writeln (' Ingrese los datos de la venta de producto: ');
	leerVenta (v);
	while (v.codProd > 0) do begin
		write (aD,v);
		writeln (' Ingrese los datos de otra venta: ');
		leerVenta (v);
	end;
	close (aD);
end;

procedure leer (var aD: arc_detalle; var rV: venta);
begin
	if (not EOF (aD)) then begin
		read (aD,rV);
	end
	else
		rV.codProd := valor_alto;
		
end;

procedure actualizarArchivo (var aM: arc_maestro; var aD: arc_detalle);
var
	rP: producto;
	rV: venta;
	cant, aux: integer;
	
begin
	reset (aM); reset (aD);
	leer (aD, rV);
	read(aM, rP); //primera lectura del arc maestro
	while (rV.codProd <> valor_alto) do begin
		aux:= rV.codProd;
		cant:= 0; 
		while ((rV.codProd <> valor_alto) and (rV.codProd = aux)) do begin
			cant:= cant + rV.cant_vendida;
			leer (aD,rV);
		end;
		
		while (rP.cod <> aux) do begin //busco el producto del detalle en el maestro
			read (aM,rP); //mientras no lo encuntre sigo leyendo
		end;
		
		//lo encontre, actualizo
		rP.stock_actual:= rP.stock_actual - cant; //modifico y actualizo el stock actual
		seek (aM, filepos(aM)-1); //el read me lo dejo apuntando al prox pos
		write (aM, rP); //escribir todo el registro esta mal?
		if (not EOF (aM)) then
			read (aM, rP);	
	end;
	close (aM); close (aD);
end;

procedure listarArchivoTxt (var aM: arc_maestro);
var
	t: text;
	rP: producto;
begin
	reset (aM);
	assign (t,'stock_minimo.txt');
	rewrite (t);
	while (not EOF (aM)) do begin
		read (aM,rP); //leo y me guardo un producto
		if (rP.stock_actual < rP.stock_minimo) then begin
			writeln (t, rP.cod, ' ',rP.precio, ' ', rP.stock_actual,' ', rP.stock_minimo, ' ', rP.nomComercial);
		end;
	end;
	close (aM); close (t);
end;


procedure imprimirArchivoMaestro (var aM: arc_maestro);
var
	rP: producto;
begin
	reset (aM);
	while (not EOF (aM)) do begin
		read (aM, rP);
		writeln (' Producto ');
		write (' Codigo: ' , rP.cod, ' | Nombre: ', rP.nomComercial, ' | Precio: ', rP.precio, ' | Stock actual: ' , rP.stock_actual, ' | Stock minimo: ', rP.stock_minimo);
		writeln ();
	end;
	close (aM);
end;

procedure menuOpciones (var aM: arc_maestro; var aD: arc_detalle);
var
	op: integer;
begin
	op:= -1;
	writeln (' ---------------- BIENVENIDO AL MENU DE OPCIONES DEL SUPER -----------------');
	
	while (op <> 4) do begin
		writeln (' Opcion 1: Actualizar el archivo maestro con el archivo detalle ');
		writeln (' Opcion 2: Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté por debajo del stock mínimo permitido ');
		writeln (' Opcion 3: Imprimir archivo maestro ');
		writeln (' Opcion 4: Salir del menu y terminar el programa ' );
		readln (op);
		case op of
			1: actualizarArchivo (aM,aD);
			2: listarArchivoTxt (aM);
			3: imprimirArchivoMaestro (aM);
		else
			writeln (' La opcion ingresada no esta disponible ');
		end;
	end;
end;

var
	aM: arc_maestro;
	aD: arc_detalle;
	
begin
	
	assign (aM, 'Archivo Maestro');
	assign (aD, 'Archivo Detalle');
	cargarArchivoMaestro (aM);
	cargarArchivoDetalle (aD);
	menuOpciones (aM,aD);
	
end.
