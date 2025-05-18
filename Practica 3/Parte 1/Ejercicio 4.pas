{4. Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo: integer;
end;
tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente
procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.
5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);}

program p3p1ej4y5;
type
	reg_flor = record
		nombre: String[45];
		codigo: integer;
	end;
	
	tArchFlores = file of reg_flor;

procedure leerFlor (var f: reg_flor);
begin
	writeln (' Codigo: ');
	readln (f.codigo);
	if (f.codigo <> -1) then begin
		writeln (' Nombre: ');
		readln (f.nombre);
	end;
end;

procedure cargarArchivo (var fA: tArchFlores);
var
	f: reg_flor;
begin
	assign (fA, 'ArchivoFlores');
	rewrite (fA);
	f.codigo := 0;
	f.nombre := 'Cabecera';
	write (fA, f);
	leerFlor (f);
	while (f.codigo <> -1) do begin
		write (fA, f);
		leerFlor (f);
	end;
	close (fA);
end;

procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo: integer);
var
	f, cabecera, eliminado: reg_flor; //preguntar
	posLibre: integer;
begin
	reset (a);
	read (a, cabecera); //leo la cabecera
	f.codigo := codigo; //me guardo en f los datos a agregar
	f.nombre := nombre; //me guardo en f los datos a agregar
	if (cabecera.codigo = 0) then begin //no hay espacio libre eliminado
		seek (a, filesize (a)); 
		write (a, f); //escribo al final
	end
	else begin //hay espacio libre 
		posLibre:= cabecera.codigo * -1;
		seek (a, posLibre); 
		read (a, eliminado); //leo el registro eliminado
		seek (a, posLibre); //vuelvo a la pos libre
		write (a, f); //escribo la nueva flor en esa pos
		cabecera.codigo:= eliminado.codigo;
		seek (a, 0); //vuelvo a la cabecera
		write (a, cabecera); //actualizo cod cabecera
	end;
	writeln ('Alta realizada efectivamente');
	close (a);
end;

procedure eliminarFlor (var a: tArchFlores; flor: reg_flor);
var
	f, cabecera: reg_Flor;
	pos: integer;
	ok: boolean;
begin
	ok:= false;
	reset (a);
	read(a, cabecera); //leo la cabecera
	while (not EOF (a) and (not ok)) do begin
		read (a,f); //leo el archivo
		if (f.codigo = flor.codigo) then begin
			ok:= true;
			pos:= filepos (a) -1; //guardo la pos actual de reg a eliminar
			seek (a, pos);
			f.codigo:= cabecera.codigo; //encadeno con la lista libre
			write (a,f);
			//actualizo cabecera para que apunte a la nueva pos libre
			cabecera.codigo := -pos;
			seek (a, 0);
			write (a,cabecera);
			
		end;
	end;
	close (a);
	if (ok) then
		writeln ('Se elimino la flor')
	else
		writeln ('No se encontro la flor de ese codigo');
	
end;

procedure imprimirArchivo (var a: tArchFlores);
var
	f: reg_flor;
begin
	reset (a);
	while (not EOF(a)) do begin
		read (a,f);
		if (f.codigo > 0) then begin
			writeln (' Flor: ', f.nombre, ' Codigo: ', f.codigo, ' | ');
			writeln ();
		end;
	end;
	close (a);
end;

var
	fa : tArchFlores;
	f: reg_flor;
begin
	cargarArchivo (fa);
	imprimirArchivo (fa);
	agregarFlor (fa, 'Jazmin',20);
	imprimirArchivo (fa);
	f.codigo := 20;
	eliminarFlor (fa,f);
	imprimirArchivo (fa);
end.
