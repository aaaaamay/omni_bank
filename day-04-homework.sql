CREATE DOMAIN monto_financiero AS NUMERIC(15, 2)
    CHECK (VALUE >= 0.00);

CREATE DOMAIN texto_obligatorio AS VARCHAR(100)
    CHECK (VALUE <> '' AND LENGTH(TRIM(VALUE)) > 0);

--monto_financiero se ocuparía únicamente en Cuentas pues se tiene el dato de saldo_actual y también se usaría en Transacciones 
--pues se tiene el campo del monto 