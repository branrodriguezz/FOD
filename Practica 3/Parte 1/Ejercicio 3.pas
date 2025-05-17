{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario}

program p3p1ej3;
type
	
	novela = record
		codigo: integer;
		genero: string;
		nombre: string;
		duracion: real;
		director: string;
		precio: real;
	end;
	
	archivo = file of novela;

procedure leerNovela (var n: novela);
begin
	writeln (' Codigo: ');
	readln (n.codigo);
	if (n.codigo <> -1) then begin
		writeln (' Genero: ');
		readln (n.genero);
		writeln (' Nombre: ');
		readln (n.nombre);
		writeln (' Duracion: ');
		readln (n.duracion);
		writeln (' Director: ');
		readln (n.director);
		writeln (' Precio: ');
		readln (n.precio);
	end;
end;
	
procedure cargarArchivo (var a: archivo);
var
	n: novela;
begin
	writeln (' Carga de archivos en proceso '); //tecnica de lista invertida
	assign (a, 'Archivo_Novelas.dat');
	rewrite (a);
	n.codigo := 0;
	n.genero := '';
	n.nombre := '';
	n.duracion := 0;
	n.director := '';
	n.precio := 0;
	write (a,n);
	leerNovela (n);
	while (n.codigo <> -1) do begin
		write(a,n);
		leerNovela(n);
	end;
	close (a);
	writeln (' Carga de archivos exitosa ' );
end;
//------------------------------------------------------------- carga ---------------------------------------------------------------

procedure darAlta (var a: archivo);
var
	n, aux: novela;
begin
	
	reset (a);
	read (a, aux);
	leerNovela (n);
	if (aux.codigo = 0) then begin  //si no hay espacio libre -> si cod = 0 en el primer registro, no hay espacio libre reutilizable
		seek (a, filesize(a)); //se posiciona al final
		write (a,n); //agrega la nueva novela
	end
	else begin
		seek (a, aux.codigo * -1); //va a la pos del primer espacio libre
		read (a, aux); //leo el registro libre que se va a usar ahora
		seek (a, filepos(a)-1); //retrocede para sobreescribir ese espacio
		write (a, n); //escribe la nueva novela ahi
		seek (a, 0); //vuelvo al encabezado
		write (a, aux); //actualiza el encabezado con el nuevo inicio de la lista libre
	end;
	close (a);
end;
//----------------------------------------------------- dar de alta -----------------------------------------------

procedure modificar (var n: novela);
var
	opcion: integer;
begin
	
	opcion := -1;
	while (opcion <> 6) do begin
	
		writeln (' ---------------------------------- MODIFICAR NOVELA -------------------------------------');
		writeln (' Opcion 1: Modificar genero ');
		writeln (' Opcion 2: Modificar nombre ');
		writeln (' Opcion 3: Modificar duracion ');
		writeln (' Opcion 4: Modificar director ');
		writeln (' Opcion 5: Modificar precio ');
		writeln (' Opcion 6: Salir del menu ');
		
		writeln (' Ingrese una opcion ');
		readln (opcion);
		
		case opcion of 
			
			1:
				begin
					writeln (' Ingrese un genero ');
					readln (n.genero);
				end;
			2:
				begin
					writeln (' Ingrese un nombre ');
					readln (n.nombre);
				end;
			3:
				begin
					writeln (' Ingrese una duracion ');
					readln (n.duracion);
				end;
			4:
				begin
					writeln (' Ingrese un director ');
					readln (n.director);
				end;
			5:
				begin
					writeln (' Ingrese un precio ');
					readln (n.precio);
				end;
				
		else
			writeln (' Opcion invalida ');
		end;
			
	end;
	
end;

procedure modificarNovela (var a: archivo);
var
	n: novela;
	cod: integer;
	ok: boolean;
	
begin
	ok:= false;
	reset (a);
	writeln (' Ingrese el codigo de novela a modificar: ');
	readln (cod);
	while (not EOF(a) and (not ok)) do begin
		read (a,n);
		if (n.codigo = cod) then begin
			ok:= true;
			modificar (n);
			seek (a, filepos(a)-1);
			write (a,n);
		end;
	end;
	if (ok) then
		writeln (' Se modifico la novela exitosamente ')
	else
		writeln (' Codigo invalido - novela no existente ');
	close (a);
end;
//------------------------------------------------------------- modificar novela -------------------------------------------

procedure darBaja (var a: archivo);
var
	n, aux: novela;
	cod, pos: integer;
	ok: boolean;
begin
	ok:= false;
	reset (a);
	writeln (' Ingrese el codigo de novela a eliminar: ');
	readln (cod);
	read (a, aux);
	while (not EOF (a) and (not ok)) do begin //preguntar
		read (a,n);
		if (n.codigo = cod) then begin
			ok:= true;
			pos := filepos(a) - 1;
			n.codigo := aux.codigo;
			seek (a, pos); //me paro en el ant
			write (a, n); // Sobreescribo el registro eliminado con: su campo codigo apuntando al inicio de la lista libre
			//actualizo la cabecera con el nuevo inicio de la lista libre
			aux.codigo := -pos;
			seek (a,0); //vuelvo al inicio
			write (a, aux);
		end;
	end;
	
	if (ok) then
		writeln (' Se elimino la novela correctamente')
	
	else
		writeln (' No se encontro la novela de ese codigo');
		
	close (a);
end;


//--------------------------------------------------------------- eliminar/dar de baja una novela ---------------------------


procedure listarTexto (var a: archivo);
var
	txt: text;
	n: novela;
begin
	reset (a);
	seek (a,1); //saltea la cabecera
	
	assign (txt, 'Archivo_Novela.txt');
	rewrite (txt);
	
	while (not EOF (a)) do begin
		read (a, n);
		if (n.codigo < 1) then
			write (txt , 'Novela eliminada');
		write (txt, ' Codigo: ', n.codigo ,' Genero: ', n.genero ,'Nombre: ',n.nombre, ' Duracion: ',n.duracion:0:2, ' Director: ', n.director, ' Precio: ', n.precio:0:2);
	end;
	
	writeln ('Archivo de texto creado');
	close (txt);
	close (a);
end;
//-------------------------------------------------------- listar a texto -----------------------------------------

procedure imprimirArchivo (var a: archivo);
var
	n: novela;
begin

	reset (a);
	while (not EOF(a)) do begin
		read (a,n);
		if (n.codigo < 1) then
			write (' Novela eliminada ');
		writeln (' | Codigo: ', n.codigo ,' Genero: ', n.genero ,'Nombre: ',n.nombre, ' Duracion: ',n.duracion:0:2, ' Director: ', n.director, ' Precio: ', n.precio:0:2, ' | ');
		writeln ();
	end;
	close (a);
end;

//------------------------------------------------------ imprimir Archivo ----------------------------------------
var

	a: archivo;
	opcion: integer;
	
begin

	opcion:= -1;
	while (opcion <> 7) do begin
		writeln (' -------------------------- MENU DE OPCIONES ------------------------');
		writeln ('Opcion 1: Crear archivo');
		writeln ('Opcion 2: Dar de alta una novela');
		writeln ('Opcion 3: Modificar los datos de una novela');
		writeln ('Opcion 4: Eliminar una novela');
		writeln ('Opcion 5: Listar en archivo de texto todas las novelas - incluyendo las borradas');
		writeln ('Opcion 6: Imprimir archivo');
		writeln ('Opcion 7: Salir del menu de opciones'); 
		
		writeln (' Ingrese una opcion ');
		readln (opcion);
		
		case opcion of 
			1: cargarArchivo (a);
			2: darAlta (a);
			3: modificarNovela (a);
			4: darBaja (a);
			5: listarTexto(a);
			6: imprimirArchivo (a);
		else
			writeln (' Opcion invalida ');
		end;	
	end;	
end.
