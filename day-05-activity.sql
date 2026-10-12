CREATE SCHEMA IF NOT EXISTS core;

CREATE TYPE core.moneda AS ENUM ('USD', 'EUR', 'MXN');
CREATE TYPE core.cuentas AS ENUM ('CHECKING', 'SAVINGS', 'CREDIT');
CREATE TYPE core.movimiento AS ENUM ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER');
CREATE TYPE core.estado AS ENUM ('ACTIVO', 'INACTIVO');

CREATE DOMAIN core.monto_financiero AS NUMERIC(15,2)
    CHECK (VALUE >= 0);

CREATE DOMAIN core.interes AS NUMERIC(5,2)
    CHECK (VALUE > 0); 

CREATE TABLE core.customers (
    cliente_id UUID DEFAULT gen_random_uuid(),
    nombre_completo VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    telefono VARCHAR(100) NOT NULL,
    created_at TIMESTAMPZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,

    CONSTRAINT pk_clientes PRIMARY KEY (cliente_id),
    CONSTRAINT uq_clientes_email UNIQUE (email)
);

CREATE TABLE core.accounts (
    numero_cuenta UUID DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL,
    tipo_moneda core.moneda NOT NULL,
    tipo_cuenta core.cuentas NOT NULL,
    saldo_actual core.monto_financiero NOT NULL,

    CONSTRAINT pk_cuentas PRIMARY KEY (numero_cuenta),
    CONSTRAINT fk_clientes_id FOREIGN KEY (cliente_id) 
        REFERENCES core.customers (cliente_id) ON DELETE RESTRICT
); 

CREATE TABLE core.loans (
    prestamo_id UUID DEFAULT gen_random_uuid(),
    cliente_id UUID NOT NULL,
    monto_prestamo core.monto_financiero NOT NULL,
    tasa_interes core.interes NOT NULL,
    estado core.estado DEFAULT 'ACTIVO' NOT NULL,

    CONSTRAINT pk_prestamos PRIMARY KEY (prestamo_id),
    CONSTRAINT fk_clientes_id FOREIGN KEY (cliente_id) 
        REFERENCES core.customers (cliente_id) ON DELETE RESTRICT
);

CREATE TABLE core.transactions (
    transaccion_id UUID DEFAULT gen_random_uuid(),
    numero_cuenta UUID NOT NULL,
    monto_tx core.monto_financiero NOT NULL, 
    tipo_transaccion core.movimiento NOT NULL,
    fecha_tx TIMESTAMPZ DEFAULT CURRENT_TIMESTAMP NOT NULL,

    CONSTRAINT pk_transacciones PRIMARY KEY (transaccion_id),
    CONSTRAINT fk_cuentas_id FOREIGN KEY (numero_cuenta)
        REFERENCES core.accounts (numero_cuenta) ON DELETE RESTRICT
);