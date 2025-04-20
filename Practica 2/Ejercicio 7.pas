{7. Se dispone de un archivo maestro con información de los alumnos de la Facultad de
Informática. Cada registro del archivo maestro contiene: código de alumno, apellido, nombre,
cantidad de cursadas aprobadas y cantidad de materias con final aprobado. El archivo
maestro está ordenado por código de alumno.
Además, se tienen dos archivos detalle con información sobre el desempeño académico de
los alumnos: un archivo de cursadas y un archivo de exámenes finales. El archivo de
cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa si la
cursada fue aprobada o desaprobada). Por su parte, el archivo de exámenes finales
contiene información sobre los exámenes finales rendidos. Cada registro incluye: código de
alumno, código de materia, fecha del examen y nota obtenida. Ambos archivos detalle
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia
muchas veces, así como también podría rendir el final de una materia en múltiples
ocasiones.
Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la
información de los archivos detalle. Las reglas de actualización son las siguientes:
● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas
aprobadas.
● Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad
de materias con final aprobado.
Notas:
● Los archivos deben procesarse en un único recorrido.
● No es necesario comprobar que no haya inconsistencias en la información de los
archivos detalles. Esto es, no puede suceder que un alumno apruebe más de una
vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar
ocurre con los exámenes finales.}

program p2ej7;
const
	valor_alto = 9999;
type
	
	registro_maestro = record
		cod: integer;
		apellido: string[15];
		nombre: string[15];
		cursadasAprobadas: integer;
		cantMateriasFinalAprobado: integer;
	end;
	
	registro_cursada = record
		codAlumno: integer;
		codMateria: integer;
		anioCursada: integer;
		aprobado: boolean; //resultado, true or false
	end;
	
	registro_finales = record
		codAlumno: integer;
		codMateria: integer;
		fecha: string;
		nota: integer;
	end;
	
	archivo_maestro = file of registro_maestro;
	archivo_detalle_cursada = file of registro_cursada;
	archivo_detalle_finales = file of registro_finales;

procedure leerC (var aDC: archivo_detalle_cursada; var rC: registro_cursada);
begin
	if (not EOF (aDC)) then begin
		read (aDC,rC);
	end
	else
		rC.cod := valor_alto;
end;

procedure leerF (var aDF: archivo_detalle_finales; var rF: registro_finales);
begin
	if (not EOF (aDF)) then begin
		read (aDF, rF);
	end
	else
		rF.cod := valor_alto;
end;
	
procedure actualizarMaestro (var aM: archivo_maestro; var aDC: archivo_detalle_cursada; var aDF: archivo_detalle_finales);
var

	regC: registro_cursada;
	regF: registro_finales;
	regM: registro_maestro;
	materias, finales, codActual: integer;
	
begin
	
	reset (aM); reset (aDC); reset (aDF);
	leerC (aDC,regC); leerF (aDF,regF);
	while ((regC.cod <> valor_alto) or (regF.cod <> valor_alto))do begin
		
		materias:= 0; finales:= 0;
		
		if (regC.cod = regF.cod) then begin //coincide el alumno
			codActual:= regC.cod;
			
			while ((regC.cod = regF.cod) and (codActual = regC.cod)) and  do begin
				if (regC.aprobado) then
					materias:= materias + 1;
				if (regF.nota >= 4) then
					finales:= finales + 1;
				leerC (aDC, regC); leerF (aDF,regF);
			end;
			
		end;
		
		if (regC.cod < regF.cod) then begin //hay mas finales que cursadas de ese alumno
			codActual:= regC.cod;
			while (regC.cod = codActual) do begin
				if (regC.aprobado) then
					materias:= materias + 1;
				leerC (aDC, regC);
			end;
		end
		
		else begin
			if (regF.cod < regC.cod) then begin //hay mas cursadas que finales de ese alumno
				codActual:= regF.cod;
				while (regF.cod = codActual) do begin 
					if (regF.nota >= 4) then
						finales:= finales + 1;
					leerF (aDF, regF);
				end;
			end;
		end;
		
		//buscar en el maestro al alumno
		read (aM, regM);
		while (regM.cod <> codActual) do begin
			read (aM, regM);
		end;
		
		//lo encontre entonces lo escribo
		regM.cursadasAprobadas:= regM.cursadasAprobadas + materias;
		regM.cantMateriasFinalAprobado:= regM.cantMateriasFinalAprobado + finales;
		seek (aM, filepos(aM)-1);
		write (aM, regM);
		close (aM); close (aDC); close (aDF);
		
	end;
	
	
end;


var
	
	aM: archivo_maestro;
	aDC: archivo_detalle_cursada;
	aDF: archivo_detalle_finales;
	
begin
	
	assign (aM, 'Archivo maestro');
	rewrite (aM)
	cargarMaestro (aM); //se dispone
	close (aM);
	assign (aDC, 'Archivo Detalle Cursada');
	rewrite (aDC);
	cargarDetalleC (aDC); //se dipone
	close (aDC);
	assign (aDF, 'Archivo Detalle Finales');
	rewrite (aDF);
	cargarDetalleF (aDF); //se dispone
	close (aDF);
	actualizarMaestro (aM, aDC, aDF);
end;
