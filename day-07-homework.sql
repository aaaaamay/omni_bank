/*
El uso del patrón Read-Before-Write está estrictamente prohibido. Este enfoque presenta fallas criticas para un entorno bancario.

    - Para un lote de 1,000,000 de registros, el bucle actual realiza 2,000,000 de viajes de red (1 SELECT + 1 INSERT/UPDATE por fila).
    La sobrecarga de transmisión de red convierte un proceso de pocos minutos en un cuello de botella de más de 4 horas.

    - Si dos instancias del microservicio ejecutan el proceso en paralelo, ocurre una brecha temporal entre el momento en que la instancia
    A lee la tabla (SELECT) y el momento en que intenta escribir (INSERT). Si la instancia B consulta el mismo registro en ese intervalo,
    ambos concluirán que el cliente no existe. Al insertar ambas la misma clave primaria, la segunda transacción fallará cancelando el lote 
    por la restricción de unicidad.

    - El pesudocódigo propuesto utiliza concatenación directa de cadenas, lo cual representa una brecha crítica de inyección de código SQL
    en la infraestructura core del banco. 
*/

INSERT INTO core.customers (first_name, last_name, email, phone_number)
VALUES
    ('John', 'Doe', 'johndoe@email.com', '555-0100')
ON CONFLICT (email) DO UPDATE SET
    first_name = EXCLUDED.first_name,
    last_name = EXCLUDED.last_name,
    phone_number = EXCLUDED.phone_number;
RETURNING customer_id, email;