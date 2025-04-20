{10. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad  Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia:
____
Código de Provincia
Código de Localidad  Total de Votos
................................ ......................
Total de Votos Provincia:
___
…………………………………………………………..
Total General de Votos:
___
NOTA: La información está ordenada por código de provincia y código de localidad.}

program p2ej10;
const
	valor_alto = 9999;
type
	
	registro = record
		codP: integer;
		codL: integer;
		numMesa: integer;
		cantVotos: integer;
	end;
	
	archivo = file of registro;
	
procedure leerDatos (var r: registro);
begin
	writeln ('Codigo provincia:');
	readln (r.codP);
	if (r.codP <> 0) then begin
		writeln ('Codigo localidad:');
		readln (r.codL);
		writeln (' Numero de mesa:');
		readln (r.numMesa);
		writeln (' Cantida de votos:');
		readln (r.cantVotos);
		writeln ();
	end;
end;

procedure cargarArchivo (var a: archivo);
var
	r: registro;
begin
	leerDatos (r);
	while (r.codP <> 0) do begin
		write (a,r);
		leerDatos (r);
	end;
end;

procedure leer (var a: archivo; var r: registro);
begin
	if (not EOF (a)) then begin
		read (a,r);
	end
	else
		r.codP := valor_alto;
end;

procedure presentarListado (var a:archivo);
var
	r: registro;
	totLocalidad, totProvincia, totGeneral: integer;
	prov, localidad:  integer;
begin
	reset (a);
	totGeneral:= 0;
	leer(a,r);
	while (r.codP <> valor_alto) do begin
		writeln ();
		writeln (' Codigo de provincia: ', r.codP);
		prov:= r.codP;
		totProvincia:= 0;
		while (prov = r.codP) do begin
			writeln (' Codigo Localidad               Total de Votos');
			localidad:= r.codL;
			totLocalidad:= 0;
			while ((prov = r.codP) and (localidad = r.codL)) do begin
				totLocalidad:= totLocalidad + r.cantVotos;
				leer (a,r);
			end;
			writeln (localidad,'                                ',totLocalidad); //imprimo la localidad y sus votos totales
			totProvincia:= totProvincia + totLocalidad;
		end;
		writeln ('Total de votos provincia: ' ,totProvincia);
		totGeneral:= totGeneral + totProvincia;
	end;
	writeln ();
	writeln (' Total general de votos: ', totGeneral);
	close (a);
end;

var
	a: archivo;
begin
	
	assign (a, ' Archivo ');
	rewrite (a);
	cargarArchivo (a);
	close (a);
	presentarListado (a);
end.
