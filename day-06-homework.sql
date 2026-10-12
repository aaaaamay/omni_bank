/*
1. La Raíz Computacional (El Bloqueo Exclusivo)
La caída del servicio durante 14 minutos se ocasionó por un mecanismo de bloqueo de PostgreSQL al ejecutar sentencias DDL tradicionales sobre 
tablas de gran volumen.

    - Al ejecutar un ALTER TABLE... ADD CONSTRAINT CHECK convencional, el motor solicita el nivel de bloqueo más restrictivo que existe 
    (AccessExclusiveLock). Este bloqueo impide cualquier tipo de acceso a la tabla, bloqueando tanto escrituras (INSERT, UPDATE, DELETE)
    como lecturas (SELECT).

    - Para validar que las 75 millones de filas existentes cumplieran con la condición LENGHT (TRIM(description) >= 5), PostgreSQL se vio
    obligado a leer e inspeccionar cada registro en el disco.

    - Mientras el motor escaneaba las 75 millones de filas bajo este bloqueo absoluto, todas las peticiones entrantes de los cajeros 
    automáticos y la app móvil quedaron en estado de espera. En pocos segundos, el pool de conexiones se agotó, provocando el colapso en cadena
    del backend y los errores 504 Database Gateway Timeout.
*/

/*
2. Patrón Arquitectonico de Solución en Dos Fases (NOT VALID)
Para añadir reglas de validación en tablas masivas en producción sin interrumpir el tráfico operativo, es obligatorio utilizar la estrategia
de validación diferida mediante NOT VALID. 

    Paso 1: Adición sin bloqueo de escaneo (NOT VALID)
    En esta primera etapa, la regla se activa únicamente para las nuevas inserciones y actualizaciones como no se escanean las 75 millones de 
    filas pasadas, el bloqueo AccessExclusiveLock dura solo unos pocos milisegundos.
*/

    ALTER TABLE core.transactions 
        ADD CONSTRAINT chk_transactions_description_valid
        CHECK (LENGHT(TRIM(description)) >= 5) NOT VALID;

/*
    Paso 2: La validación Pasiva Posterior (VALIDATE CONSTRAINT)
    Una vez añadida la restricción, se ejecuta un segundo comando que revisa las filas históricas en segundo plano. Esta operación utiliza un
    bloqueo ligero (ShareUpdateExclusiveLock), el cual permite que las lecturas e inserciones de los usuarios continúen operando en vivo 
    sin interrupción. 
*/

    ALTER TABLE core.transactions
        VALIDATE CONSTRAINT chk_transactions_description_valid;