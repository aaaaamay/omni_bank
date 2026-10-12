INSERT INTO core.customers (cliente_id, nombre, apellido, email, telefono, tax_id, fecha_nacimiento)
VALUES
 ('11111111-1111-1111-1111-111111111111', 'John', 'Doe', 'john.doe@email.com', '555-0100', 'TAX-100', '1985-04-12'),
 ('22222222-2222-2222-2222-222222222222', 'Jane', 'Smith', 'jane.smith@email.com', '555-0200', 'TAX-200', '1990-08-25'),
 ('33333333-3333-3333-3333-333333333333', 'Alice', 'Johnson', 'alice.j@email.com', '555-0300', 'TAX-300', '1978-11-05')
ON CONFLICT (email) DO NOTHING;

INSERT INTO core.accounts (cuenta_id, cliente_id, numero_cuenta, tipo_cuenta, saldo, limite_credito)
VALUES
 ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa','11111111-1111-1111-1111-111111111111','ACCT-1001','CHECKING',5000, 0),
 ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb','22222222-2222-2222-2222-222222222222','ACCT-2001','SAVINGS',15000, 0),
 ('cccccccc-cccc-cccc-cccc-cccccccccccc','33333333-3333-3333-3333-333333333333','ACCT-3001','CREDIT',0, 10000)
ON CONFLICT (numero_cuenta) DO NOTHING;


INSERT INTO core.transactions (cuenta_origen_id, cuenta_destino_id, monto_tx, tipo_moneda, tipo_transaccion, estado, descripcion)
VALUES
 ('11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 150, 'USD', 'TRANSFER', 'COMPLETED', 'Pago de Cena'),
 ('22222222-2222-2222-2222-222222222222', '33333333-3333-3333-3333-333333333333', 300, 'USD', 'TRANSFER', 'COMPLETED', 'Abono a tarjeta de credito'),
 ('11111111-1111-1111-1111-111111111111', NULL, 50, 'USD', 'FEE', 'COMPLETED', 'Comision mensual bancaria');

 UPDATE core.accounts
 SET saldo = saldo - 150
 WHERE numero_cuenta = 'ACCT-1001';
 RETURNING numero_cuenta, saldo;