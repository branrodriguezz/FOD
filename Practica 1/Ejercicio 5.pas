{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos ingresados desde un archivo de texto denominado “celulares.txt”. 
Los registros correspondientes a los celulares, deben contener: código de celular, el nombre, descripcion, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo.
NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario una única vez.
NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en tres líneas consecutivas: 
en la primera se especifica: código de celular, el precio y marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera nombre en ese orden.
 Cada celular se carga leyendo tres líneas del archivo “celulares.txt”.}
 
 program p1ej5;
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
		readln (arc_celulares, c.stock_dispo, c.stock_min, c.descripcion);
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
	
	close (arc_logico);
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

procedure menuOpciones (var arc_logico: archivo; var arc_celulares: text);
var
	opcion: integer;
begin
	
	opcion:= -1;
	
	while (opcion <> 6) do begin
		writeln (' ----------------------------------------------- MENU DE OPCIONES --------------------------------------------------- ');
		writeln (' Ingrese una opcion: ');
		writeln (' 1: Crear un archivo de registros no ordenados de celulares' );
		writeln (' 2: Listar en pantalla los datos de aquellos celulares que tengan un stock menor al stock mínimo. ');
		writeln (' 3: Listar en pantalla los celulares del archivo cuya descripción contenga una cadena de caracteres proporcionada por el usuario. ');
		writeln (' 4: Exportar el archivo creado en el inciso a) a un archivo de texto denominado “celulares.txt” con todos los celulares del mismo. ');
		writeln (' 5: Crear archivo de texto');
		writeln (' 6: Salir del menu y terminar el programa ');
		readln (opcion);
		case opcion of
			1: crearArchivo (arc_logico, arc_celulares);
			2: stockMenor (arc_logico);
			3: descripcion (arc_logico);
			4: exportarArchivo (arc_logico, arc_celulares);
			5: crearArchivoTexto (arc_celulares);
		else
			writeln (' La opcion ingresada no esta disponible ');
		end;
	end;
	
end;

var

	arc_logico: archivo;
	arc_celulares: text;
	
begin

	menuOpciones (arc_logico,arc_celulares);
	
end.
