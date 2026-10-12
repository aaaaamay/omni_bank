CREATE TYPE moneda AS ENUM ('USD', 'EUR', 'MXN');
CREATE TYPE cuentas AS ENUM ('CHECKING', 'SAVINGS', 'CREDIT');
CREATE TYPE movimiento_transaccional AS ENUM ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER');

CREATE DOMAIN dinero_positivo AS NUMERIC (10, 2)
    CHECK (VALUE > = 0.00);

CREATE DOMAIN correo_formaro AS VARCHAR(150)
    CHECK (VALUE ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

[Clientes]
- cliente_id UUID (PK)
- nombre VARCHAR(100)                   -- Para todas las Llaves Primarias (PK) y las foráneas (FK) se usarán UUID pues para mayor seguridad se crean
- correo: correo_formaro                   ids unicos universales.

[Cuentas]
- numero_cuenta (PK)
- cliente_id (FK) UUID
- sucursal_id (FK) UUID
- tipo_moneda: moneda 
- tipo_cuenta: cuentas 
- saldo_actual: dinero_positivo

[Transacciones]
- transaccion_id (PK) UUID
- numero_cuenta (FK)
- fecha_tx: TIMESTAMPZ
- monto: dinero_positivo