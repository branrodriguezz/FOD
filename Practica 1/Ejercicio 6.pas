{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}

program p1ej6;
type
 
	celular = record
		codigo: integer;
		nombre: string[15];
		descripcion: string[15];
		marca: string[15];
		precio: real;
		stock_min: integer;
		stock_dispo: integer;
	end;
	
	archivo = file of celular;

procedure leerCelular (var c: celular);
begin
	
	writeln ('Ingrese un codigo: ');
	readln (c.codigo);
	if (c.codigo <> 0) then begin
		writeln (' Ingrese un nombre: ');
		readln (c.nombre);
		writeln (' Ingrese una descripcion: ');
		readln (c.descripcion);
		writeln (' Ingrese una marca: ');
		readln (c.marca);
		writeln (' Ingrese un precio: ');
		readln (c.precio);
		writeln (' Ingrese el stock minimo: ');
		readln (c.stock_min);
		writeln (' Ingrese el stock disponible: ');
		readln (c.stock_dispo);
	end;
end;

procedure imprimirCelular (c: celular);
begin
	writeln (' | Codigo: ' , c.codigo, ' | Nombre: ' , c.nombre, ' | Descripcion: ', c.descripcion, ' | Marca: ' , c.marca , ' | Precio: ' , c.precio, ' | Stock minimo: ' , c.stock_min, ' | Stock disponible: ', c.stock_dispo, ' | ');
	writeln ();
end;

procedure crearArchivo (var arc_logico: archivo; var arc_celulares: text);
var
	arc_fisico: string[15];
	c: celular;
begin
	
	writeln (' Ingrese nombre del archivo: ');
	readln (arc_fisico);
	
	assign (arc_logico, arc_fisico);
	

	reset (arc_celulares);
	
	writeln ('Hola');
	rewrite (arc_logico);
	
	writeln ('Holaa version 2');
	
	while (not EOF (arc_celulares)) do begin
		writeln ('holsiis');
		readln (arc_celulares, c.codigo, c.precio, c.marca);
		readln (arc_celulares, c.stock_dispo,c.stock_min,c.descripcion);
		readln (arc_celulares, c.nombre);
		write (arc_logico, c);
	end;
	writeln (' Archivo binario cargado ');
	close(arc_celulares);
	close(arc_logico);
end;

procedure stockMenor (var arc_logico: archivo);
var
	c: celular;
begin
	
	reset (arc_logico);
	while (not EOF(arc_logico)) do begin
		read (arc_logico,c);
		if (c.stock_dispo < c.stock_min) then
			imprimirCelular(c);
	end;
	close (arc_logico);
end;

procedure descripcion (var arc_logico: archivo);
var
	descrip: string[15];
	c: celular;
	
begin

	reset (arc_logico);
	writeln (' Ingrese una cadena a comparar con la descripcion: ');
	readln (descrip);
	
	while (not EOF(arc_logico)) do begin
		read (arc_logico, c);
		writeln(c.descripcion);
		delete(c.descripcion,1,1); //funcion para eliminar el espacio en blanco del archivo de texto
		if (c.descripcion = descrip ) then
			imprimirCelular (c);
	end;
	
end;

procedure exportarArchivo (var arc_logico: archivo; var arc_celulares: text);
var
	c: celular;
begin

	reset (arc_logico);
	rewrite (arc_celulares);
	
	while (not EOF(arc_logico)) do begin
		read (arc_logico, c);
		writeln (arc_celulares, c.codigo, c.precio, c.marca);
		writeln (arc_celulares, c.stock_dispo, c.stock_min, c.descripcion);
		writeln (arc_celulares, c.nombre);
	end;
	
	close (arc_logico);
	close (arc_celulares);
end;

procedure crearArchivoTexto (var arc_celulares: text);
var
	arc_fisico_text: string[15];
	c: celular;
begin
	
	writeln (' Ingrese un nombre para el archivo de texto: ');
	readln (arc_fisico_text);
	
	assign (arc_celulares,arc_fisico_text);
	
	rewrite (arc_celulares);
	
	writeln (' Proporcione los datos para el archivo de texto ');
	leerCelular (c);
	
	while (c.codigo <> 0) do begin
		writeln (arc_celulares, c.codigo, ' ', c.precio:2:2, ' ', c.marca); //mucho muy importante los espacios en blanco en los archivos de texto
		writeln (arc_celulares, c.stock_dispo, ' ', c.stock_min, ' ', c.descripcion);
		writeln (arc_celulares, c.nombre);
		writeln (' Proporcione los datos para el archivo de texto ');
		leerCelular (c);
	end;
	
	close (arc_celulares);
end;

function estaRepetido (var arc_logico: archivo; nombre: string): boolean;
var
	c: celular;
	repetido: boolean;
begin
	repetido:= false;
	while (not EOF(arc_logico) and (not repetido)) do begin
		read (arc_logico, c);
		if (c.nombre = nombre) then begin
			repetido:= true;
		end;
	end;
	estaRepetido:= repetido;
end;

procedure aniadirCelular (var arc_logico: archivo);
var
	c: celular;
begin
	reset (arc_logico);
	
	writeln (' Ingrese los datos del nuevo celular: ');
	leerCelular (c);
	while (c.nombre <> 'alcatel') do begin
		if (not estaRepetido (arc_logico, c.nombre)) then begin
			seek (arc_logico, fileSize(arc_logico));
			write (arc_logico, c);
		end;
		writeln (' Ingrese los datos de otro celular: ');
		leerCelular (c);
	end;
	close (arc_logico);
end;

procedure modificarStock (var arc_logico: archivo);
var
	celu: string[15];
	c: celular;
	encontre: boolean;
	nStock: integer;
	
begin
	
	encontre:= false;
	reset (arc_logico);
	
	writeln (' Ingrese el nombre de un celular: ');
	readln (celu);
	
	while (not EOF(arc_logico) and (not encontre)) do begin
		read (arc_logico, c);
		if (c.nombre = celu) then begin
			writeln (' El celular se ha encontrado, porfavor introduzca un nuevo stock');
			readln (nSTock);
			c.stock_dispo:= nStock;
			encontre:= true;
			writeln (' Cambios realizados con exito ');
		end;
		
	end;
	if (encontre = false) then
		writeln (' El celular no se ha encontrado');
		
	close(arc_logico);
end;

procedure exportarArchivoSinStock (var arc_logico: archivo; var arc_celulares_sin_stock: text);
var
	c: celular;
begin

	reset (arc_logico);
	assign (arc_celulares_sin_stock, 'arc_celulares_sin_stock.txt');
	
	rewrite (arc_celulares_sin_stock);
	
	while (not EOF(arc_logico)) do begin
		read (arc_logico, c);
		if (c.stock_dispo = 0) then begin
			writeln (arc_celulares_sin_stock, c.codigo, c.precio, c.marca);
			writeln (arc_celulares_sin_stock, c.stock_dispo, c.stock_min, c.descripcion);
			writeln (arc_celulares_sin_stock, c.nombre);
		end;
	end;
	
	close (arc_logico);
	close (arc_celulares_sin_stock);
	
end;

procedure menuOpciones (var arc_logico: archivo; var arc_celulares: text; var arc_celulares_sin_stock: text);
var
	opcion: integer;
begin
	
	opcion:= -1;
	
	while (opcion <> 9) do begin
		writeln (' ----------------------------------------------- MENU DE OPCIONES --------------------------------------------------- ');
		writeln (' Ingrese una opcion: ');
		writeln (' 1: Crear archivo de texto ' );
		writeln (' 2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo. ');
		writeln (' 3: Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario. ');
		writeln (' 4: Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo. ');
		writeln (' 5: Crear un archivo de registros no ordenados de celulares');
		writeln (' 6: Añadir uno o más celulares al final del archivo con sus datos ingresados por teclado.');
		writeln (' 7: Modificar stock de un celular dado. ');
		writeln (' 8: Exportar el contenido del archivo binario a un archivo de texto denominado: ”SinStock.txt”, con aquellos celulares que tengan stock 0');		
		writeln (' 9: Salir del menu y terminar el programa ');
		readln (opcion);
		case opcion of
			1: crearArchivoTexto (arc_celulares); 
			2: stockMenor (arc_logico);
			3: descripcion (arc_logico);
			4: exportarArchivo (arc_logico, arc_celulares);
			5: crearArchivo (arc_logico, arc_celulares);
			6: aniadirCelular (arc_logico);
			7: modificarStock (arc_logico);
			8: exportarArchivoSinStock (arc_logico, arc_celulares_sin_stock);
		else
			writeln (' La opcion ingresada no esta disponible ');
		end;
	end;
	
end;

var

	arc_logico: archivo;
	arc_celulares: text;
	arc_celulares_sin_stock: text;
	
begin

	menuOpciones (arc_logico,arc_celulares,arc_celulares_sin_stock);
	close (arc_logico);
	
end.
