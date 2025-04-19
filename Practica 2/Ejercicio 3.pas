{3. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program p2ej3;
const
	valor_alto = 'ZZZ';
type
	
	datos = record
		nomProv: string[15];
		cantPer: integer;
		totalEncuestados: integer;
	end;
	
	agencia = record
		nomProv: string[15];
		codLocalidad: integer;
		cantAlfabetizados: integer;
		cantEncuestados: integer;
	end;
	
	maestro = file of datos;
	detalle = file of agencia;
	
procedure leerMaestro (var d: datos);
begin
	writeln (' Nombre de la provincia: ');
	readln (d.nomProv);
	if (d.nomProv <> 'ZZZ') then begin
		writeln (' Cantidad de personas: ');
		readln (d.cantPer);
		writeln (' Total de encuestados: ');
		readln (d.totalEncuestados);
	end;
end;

procedure cargarMaestro (var aM: maestro);
var
	d: datos;
begin
	rewrite (aM);
	writeln (' CARGA - ARCHIVO MAESTRO ');
	leerMaestro (d);
	while (d.nomProv <> 'ZZZ') do begin
		write (aM, d);
		leerMaestro (d);
	end;
	close (aM);
end;

procedure leerDetalle (var a: agencia);
begin
	writeln (' Nombre de la provincia: ');
	readln (a.nomProv);
	if (a.nomProv <> 'ZZZ') then begin
		writeln (' Codigo localidad: ');
		readln (a.codLocalidad);
		writeln (' Cantidad de alfabetizados: ');
		readln (a.cantAlfabetizados);
		writeln (' Cantidad de encuestados: ');
		readln (a.cantEncuestados);
	end;
end;

procedure cargarDetalle (var aD: detalle; num: integer);
var
	a: agencia;
begin
	rewrite (aD);
	writeln (' CARGA - ARCHIVO DETALLE ',num);
	leerDetalle (a);
	while (a.nomProv <> 'ZZZ') do begin
		write (aD, a);
		leerDetalle (a);
	end;
	close (aD);
end;


procedure leer (var aD: detalle; var a: agencia);
begin
	if (not EOF (aD)) then begin
		read (aD, a);
	end
	else
		a.nomProv:= valor_alto;
end;

procedure actualizar (var aM: maestro; var aD: detalle);
var
	d: datos; //registro de maestro
	a: agencia; //registro de detalle
	totEncuestados, totAlfabetizados: integer;
	aux: string[15];
	
begin
	
	writeln ('Actualizando');
	reset (aM);
	reset (aD);
	read (aM, d); //leo por lo menos una vez el maestro
	leer (aD, a); //leo el detalle
	while (a.nomProv <> valor_alto) do begin //recorro el archivo detalle
		aux:= a.nomProv;
		totEncuestados:= 0;
		totAlfabetizados:= 0;
		while (aux = a.nomProv) do begin  //mientras siga en la misma provincia, acumulo 
			
			totEncuestados:= totEncuestados + a.cantEncuestados;
			totAlfabetizados:= totAlfabetizados + a.cantAlfabetizados;
			leer (aD, a);
			
		end;
		
		//busco en el maestro
		while (d.nomProv <> aux)do begin
			read (aM, d);
		end;
		//lo encontre entonces modifico
		d.cantPer:= d.cantPer + totAlfabetizados;
		d.totalEncuestados:= d.totalEncuestados + totEncuestados;
		seek (aM, filepos (aM)-1); //reubico el archivo
		write (aM,d);
		if (not EOF (aM)) then begin
			read (aM, d);
		end;
		
	end;
	close (aM); close (aD);
	writeln ('Actualizacion finalizada');
	
end;

procedure imprimirArchivo (var aM: maestro);
var
	d: datos;
begin
	
	writeln (' ARCHIVO MAESTRO ');
	reset (aM);
	while (not EOF (aM)) do begin
	
		read (aM, d);
		write (' Nombre de provincia: ', d.nomProv, ' | ');
		write (' Alfabetizados: ', d.cantPer, ' | ');
		write (' Total encuestados: ', d.totalEncuestados, ' | ');
		
	end;
	close (aM);
end;

var
	
	aM: maestro;
	aD1,aD2: detalle;
	
begin

	// -------------------------------------- cargas ---------------------------
	assign (aM, 'Archivo Maestro');
	assign (aD1, 'Archivo Detalle 1' );
	assign (aD2, 'Archivo Detalle 2' );
	
	cargarMaestro (aM);
	cargarDetalle (aD1,1);
	cargarDetalle (aD2,2);
	// ------------------------------------- actualizacion --------------------------
	imprimirArchivo (aM); //previa a la actualizacion
	actualizar (aM, aD1);
	actualizar (aM, aD2);
	imprimirArchivo (aM);
end.
