-- Nodo "Aplicar Reglas de Negocio de Proveedores" de business-partners.md

CREATE TABLE bpm_supplier_rule (
    rule_id        SERIAL PRIMARY KEY,
    partner_ref    INTEGER NOT NULL,
    item_code      VARCHAR(20) NOT NULL,
    is_preferred   BOOLEAN NOT NULL DEFAULT FALSE,
    lead_time_days INTEGER NOT NULL CHECK (lead_time_days >= 0),
    moq            INTEGER NOT NULL CHECK (moq > 0),
    order_multiple INTEGER NOT NULL CHECK (order_multiple > 0),
    UNIQUE (partner_ref, item_code)
);

CREATE UNIQUE INDEX bpm_one_preferred_per_item
ON bpm_supplier_rule (item_code)
WHERE is_preferred;

INSERT INTO bpm_supplier_rule (partner_ref, item_code, is_preferred, lead_time_days, moq, order_multiple) VALUES
(1, 'CPU-RYZEN7', TRUE, 14, 10, 5),
(2, 'CPU-RYZEN7', FALSE, 21, 5, 1),
(1, 'RAM-16DDR5', TRUE, 7, 20, 10),
(3, 'SSD-1TB', TRUE, 10, 10, 10);

SELECT item_code,
       partner_ref,
       DATE '2026-12-10' - lead_time_days AS release_date,
       GREATEST(moq, CEIL(23.0 / order_multiple) * order_multiple) AS adjusted_qty
FROM bpm_supplier_rule
WHERE is_preferred AND item_code = 'CPU-RYZEN7';
