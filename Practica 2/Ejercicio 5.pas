{5. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,tiempo_total_de_sesiones_abiertas.
Notas:
●Cada archivo detalle está ordenado por cod_usuario y fecha.
●Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o inclusive, en diferentes máquinas.
●El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}

program p2ej5;
const
	valor_alto = 9999;
	dF = 3;
type

	subrango = 1..dF;
	registro_maestro = record
		cod_usuario: integer;
		fecha: string;
		tiempo_total_sesiones_abiertas: integer;
	end;
	
	registro_detalle = record
		cod_usuario: integer;
		fecha: string;
		tiempo_sesion: integer;
	end;
	
	detalle = file of registro_detalle;
	maestro = file of registro_maestro;
	
	registro = record
		reg: registro_detalle;
		arc: detalle;
	end;
	
	vector_detalles = array [subrango] of registro;
	

procedure leerDetalle (var regD: registro_detalle);
begin
	writeln (' Codigo de usuario: ');
	readln (regD.cod_usuario);
	if (regD.cod_usuario <> -1) then begin
		writeln (' Fecha: ');
		readln (regD.fecha);
		writeln (' Tiempo de sesion: ');
		readln (regD.tiempo_sesion);
	end;
	
end;

procedure cargarDetalle (var d: detalle);
var
	nombre: string;
	regD: registro_detalle;
begin
    writeln('Ingrese un nombre para el archivo detalle');
    readln(nombre);
    assign(d, nombre);
    rewrite(d);
    leerDetalle (regD);
	while (regD.cod_usuario <> -1) do begin
		write (d, regD);
		leerDetalle (regD);
	end;
    close (d);
end;

procedure generarDetalle (var vec: vector_detalles);
var
	i: subrango;
begin
	for i:= 1 to dF do begin
		cargarDetalle (vec[i].arc);
	end;
end;

procedure leer (var r: registro);
begin
	if (not EOF (r.arc)) then begin
		read (r.arc,r.reg);
	end
	else
		r.reg.cod_usuario:= valor_alto;
		
end;

procedure minimo (var vec: vector_detalles; var min: registro_detalle);
var
	i,pos: subrango;
begin
	min.cod_usuario:= valor_alto;
	min.fecha:= 'zzz';
	for i := 1 to dF do begin
		if ((vec[i].reg.cod_usuario < min.cod_usuario) or 
		(vec[i].reg.cod_usuario = min.cod_usuario) and 
		(vec[i].reg.fecha < min.fecha)) then begin
			min:= vec[i].reg;
			pos:= i;
		end;
	end;
	if (min.cod_usuario <> valor_alto) then begin
		leer (vec[pos]);
	end;
	
end;

procedure cargarMaestro (var m: maestro; var vec: vector_detalles);
var
	min: registro_detalle;
	aux: registro_maestro;
	i: subrango;
	
begin
	
	rewrite (m);
	for i:= 1 to dF do begin
		reset (vec[i].arc);
		leer (vec[i]);
	end;
	
	minimo (vec,min);
	while (min.cod_usuario <> valor_alto) do begin
		aux.cod_usuario:= min.cod_usuario;
		
		while (aux.cod_usuario = min.cod_usuario) do begin
			aux.fecha:= min.fecha;
			aux.tiempo_total_sesiones_abiertas:= 0;
			
			while ((aux.cod_usuario = min.cod_usuario) and (aux.fecha = min.fecha)) do begin
				aux.tiempo_total_sesiones_abiertas:= aux.tiempo_total_sesiones_abiertas + min.tiempo_sesion;
				minimo (vec,min);
			end;
			write (m,aux);
		end;
	end;
	for i:= 1 to dF do begin
		close (vec[i].arc);
	end;
	close (m);
end;


procedure imprimirMaestro (var m: maestro);
var
	r: registro_maestro;
	
begin
	reset (m);
	while (not EOF (m)) do begin
		read (m,r);
		writeln (' Maquina: | ', r.cod_usuario, ' | ', r.fecha, ' | ', r.tiempo_total_sesiones_abiertas);
	end;
	close (m);
end;

var

	vec: vector_detalles;
	m: maestro;
	
begin

	assign (m, 'Maestro');
	generarDetalle (vec);
	cargarMaestro (m,vec);
	imprimirMaestro (m);
end.
