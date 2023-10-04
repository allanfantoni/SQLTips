-- Not recommended

INSERT INTO AllanFantoni.dbo.Teste (Conta) VALUES ('Teste1');
INSERT INTO AllanFantoni.dbo.Teste (Conta) VALUES ('Teste2');
INSERT INTO AllanFantoni.dbo.Teste (Conta) VALUES ('Teste3');

-- Recommended

INSERT INTO AllanFantoni.dbo.Teste (Conta)
VALUES
    ('Teste1'),
    ('Teste2'),
    ('Teste3')