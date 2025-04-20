{8. Se quiere optimizar la gestión del consumo de yerba mate en distintas provincias de
Argentina. Para ello, se cuenta con un archivo maestro que contiene la siguiente
información: código de provincia, nombre de la provincia, cantidad de habitantes y cantidad
total de kilos de yerba consumidos históricamente.
Cada mes, se reciben 16 archivos de relevamiento con información sobre el consumo de
yerba en los distintos puntos del país. Cada archivo contiene: código de provincia y cantidad
de kilos de yerba consumidos en ese relevamiento. Un archivo de relevamiento puede
contener información de una o varias provincias, y una misma provincia puede aparecer
cero, una o más veces en distintos archivos de relevamiento.
Tanto el archivo maestro como los archivos de relevamiento están ordenados por código de
provincia.
Se desea realizar un programa que actualice el archivo maestro en base a la nueva
información de consumo de yerba. Además, se debe informar en pantalla aquellas
provincias (código y nombre) donde la cantidad total de yerba consumida supere los 10.000
kilos históricamente, junto con el promedio consumido de yerba por habitante. Es importante
tener en cuenta tanto las provincias actualizadas como las que no fueron actualizadas.
Nota: cada archivo debe recorrerse una única vez.}

program p2ej8;
const	
	valor_alto = 999;
	dF = 16;
	
type
	subrango = 1..dF;
	
	registro_maestro = record
		cod_provincia : integer;
		nombre_provincia : string[15];
		cant_habitantes : integer;
		cant_total_yerba : integer; //en kilos 
	end;
	
	registro_detalle = record
		cod_provincia : integer;
		cant_yerba : integer;
	end;
	
	archivo_maestro = file of registro_maestro;
	archivo_detalle = file of registro_detalle;
	
	registro_aux = record
		reg: registro_detalle;
		arc: archivo_detalle;
	end;
	
	vector_detalles = array [subrango] of registro_aux; //trabajar con un vector de registros o dos vectores independientes?
	
	
procedure leer (var r: registro_aux); 
begin
	if (not EOF(r.arc)) then
		read (r.arc, r.reg);
	end
	else
		r.reg.cod_provincia:= valor_alto;
end;

procedure minimo (var v: vector_detalles; var min: registro_detalle); 
var
	i,pos: subrango;
begin
	
	min.cod:= valor_alto;
	for i:= 1 to dF do begin
		if (v[i].reg.cod_provincia < min.cod) then
			min.cod:= v[i].reg.cod_provincia;
			pos:= i;
	end;
	
	if (min.cod <> valor_alto) then //hay elementos todavia
		leer(v[pos]);

end;

procedure actualizarMaestro (var aM: archivo_maestro; var v: vector_detalles);
var
	
	min: registro_detalle;
	i: subrango;
	rM: registro_maestro;
	act, cant: integer;
	
begin

	for i:= 1 to dF do begin
		reset (v[i].arc); //tiene sentido leer todos los archivos aca?
	end;
	
	reset (aM);
	
	read (aM,rM); //esta mal leer aca el maestro?
	minimo (v,min);
	
	while (min.cod_provincia <> valor_alto) do begin
		act:= min.cod_provincia;
		cant:= 0;
		while ((min.cod_provinvia <> valor_alto) and (min.cod_provincia = act)) do begin  //necesaria repetir la primera condicion?
			cant:= cant + min.cant_yerba;
			minimo (v,min);
		end;
		
		//busco en el maestro 
		while (rM.cod_pronvincia <> act) do begin
			read (aM, rM);
		end;
		
		rM.cant_total_yerba:= rM.cant_total_yerba + cant;
		seek (aM,filepos(aM)-1);
		write (aM,rM);
		
		if (not EOF(aM)) then
			read (aM, rM); //esta bien? 
	end;
	
	close (aM);
	
	for i:= 1 to dF do begin
		reset (v[i].arc);
	end;
	
end;

procedure informar (var aM: archivo_maestro);
var
	rM: registro_maestro;
begin

	reset (aM);
	while (not EOF (aM)) do begin //cuenta como un recorrido extra?
		read (aM, rM);
		if (rM.cant_total_yerba > 10000) then begin
			writeln ('En la provincia: 'rM.nombre_provincia,'se consumieron mas de 10000 kilos de yerba historicamente.');
			writeln (' Promedio consumido de yerba por habitante: ', rM.cant_total_yerba / rM.cant_habitantes);
		end;
	end;
	close (aM);
end;

var
	
	v: vector_detalles;
	
begin

	cargarDetalle (v); //se dispone 
	assign (aM, ' Archivo Maestro ');
	rewrite (aM);
	actualizarMaestro (aM, v);
	close (aM);
	informar (aM);
	
end.
