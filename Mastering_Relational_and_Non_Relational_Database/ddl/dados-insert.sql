-- Iniciando a inserção de dados mocados para o banco de dados Mottu
-- Certifique-se de que as tabelas estão vazias e as constraints FK estão no lugar.
-- Os IDs são fornecidos explicitamente.

-- Tabela TB_ENDERECO
insert into tb_endereco (
   id_endereco,
   cep,
   numero,
   logradouro,
   bairro,
   cidade,
   estado,
   pais,
   complemento,
   observacao
) values ( 1,
           '01001000',
           100,
           'Praça da Sé',
           'Sé',
           'São Paulo',
           'SP',
           'Brasil',
           'Lado par',
           'Próximo ao metrô' );
insert into tb_endereco (
   id_endereco,
   cep,
   numero,
   logradouro,
   bairro,
   cidade,
   estado,
   pais,
   complemento,
   observacao
) values ( 2,
           '20040030',
           250,
           'Avenida Rio Branco',
           'Centro',
           'Rio de Janeiro',
           'RJ',
           'Brasil',
           'Edifício Central',
           'Perto do VLT' );
insert into tb_endereco (
   id_endereco,
   cep,
   numero,
   logradouro,
   bairro,
   cidade,
   estado,
   pais,
   complemento,
   observacao
) values ( 3,
           '30110001',
           3000,
           'Avenida Afonso Pena',
           'Centro',
           'Belo Horizonte',
           'MG',
           'Brasil',
           'Sala 10',
           'Em frente à praça' );
insert into tb_endereco (
   id_endereco,
   cep,
   numero,
   logradouro,
   bairro,
   cidade,
   estado,
   pais,
   complemento,
   observacao
) values ( 4,
           '70070001',
           500,
           'SCS Quadra 7',
           'Asa Sul',
           'Brasília',
           'DF',
           'Brasil',
           'Bloco A',
           'Setor comercial' );
insert into tb_endereco (
   id_endereco,
   cep,
   numero,
   logradouro,
   bairro,
   cidade,
   estado,
   pais,
   complemento,
   observacao
) values ( 5,
           '04538133',
           1355,
           'Avenida Brigadeiro Faria Lima',
           'Itaim Bibi',
           'São Paulo',
           'SP',
           'Brasil',
           'Andar 5',
           'Próximo ao Shopping Iguatemi' );

-- Tabela TB_CONTATO
insert into tb_contato (
   id_contato,
   email,
   ddd,
   ddi,
   telefone1,
   telefone2,
   telefone3,
   celular,
   outro,
   observacao
) values ( 1,
           'cliente1@email.com',
           11,
           55,
           '30304040',
           null,
           null,
           '999998888',
           null,
           'Contato principal' );
insert into tb_contato (
   id_contato,
   email,
   ddd,
   ddi,
   telefone1,
   telefone2,
   telefone3,
   celular,
   outro,
   observacao
) values ( 2,
           'joana.silva@email.com',
           21,
           55,
           '20203030',
           '20203031',
           null,
           '988887777',
           'Recado: 2122221111',
           'Preferência por contato via celular' );
insert into tb_contato (
   id_contato,
   email,
   ddd,
   ddi,
   telefone1,
   telefone2,
   telefone3,
   celular,
   outro,
   observacao
) values ( 3,
           'pedro.santos@email.com',
           31,
           55,
           '33334444',
           null,
           null,
           '977776666',
           null,
           'Horário comercial' );
insert into tb_contato (
   id_contato,
   email,
   ddd,
   ddi,
   telefone1,
   telefone2,
   telefone3,
   celular,
   outro,
   observacao
) values ( 4,
           'anacosta@email.com',
           61,
           55,
           '32325050',
           null,
           null,
           '966665555',
           null,
           'Enviar email antes de ligar' );
insert into tb_contato (
   id_contato,
   email,
   ddd,
   ddi,
   telefone1,
   telefone2,
   telefone3,
   celular,
   outro,
   observacao
) values ( 5,
           'mottu_patio_sp@email.com',
           11,
           55,
           '40045005',
           null,
           null,
           '955554444',
           'Fax: 40045006',
           'Contato do pátio de São Paulo' );

-- Tabela TB_VEICULO (Motos)
insert into tb_veiculo (
   id_veiculo,
   placa,
   renavam,
   chassi,
   fabricante,
   modelo,
   motor,
   ano,
   combustivel
) values ( 1,
           'BRA2E19',
           '12345678901',
           '9C6KDPP00L0A00001',
           'Honda',
           'CG 160 Start',
           '160cc',
           2023,
           'Gasolina' );
insert into tb_veiculo (
   id_veiculo,
   placa,
   renavam,
   chassi,
   fabricante,
   modelo,
   motor,
   ano,
   combustivel
) values ( 2,
           'MTO1A23',
           '23456789012',
           '9C6KDPP00L0A00002',
           'Yamaha',
           'Factor 150 ED',
           '150cc',
           2022,
           'Flex' );
insert into tb_veiculo (
   id_veiculo,
   placa,
   renavam,
   chassi,
   fabricante,
   modelo,
   motor,
   ano,
   combustivel
) values ( 3,
           'MOT2U45',
           '34567890123',
           '9C6KDPP00L0A00003',
           'Honda',
           'Pop 110i',
           '110cc',
           2024,
           'Gasolina' );
insert into tb_veiculo (
   id_veiculo,
   placa,
   renavam,
   chassi,
   fabricante,
   modelo,
   motor,
   ano,
   combustivel
) values ( 4,
           'MTA3B56',
           '45678901234',
           '9C6KDPP00L0A00004',
           'Mottu',
           'Sport 110i',
           '110cc',
           2023,
           'Gasolina' );
insert into tb_veiculo (
   id_veiculo,
   placa,
   renavam,
   chassi,
   fabricante,
   modelo,
   motor,
   ano,
   combustivel
) values ( 5,
           'MTU4C67',
           '56789012345',
           '9C6KDPP00L0A00005',
           'Shineray',
           'Worker 125',
           '125cc',
           2022,
           'Gasolina' );
insert into tb_veiculo (
   id_veiculo,
   placa,
   renavam,
   chassi,
   fabricante,
   modelo,
   motor,
   ano,
   combustivel
) values ( 6,
           'HON6D78',
           '67890123456',
           '9C6KDPP00L0A00006',
           'Honda',
           'Biz 125',
           '125cc',
           2023,
           'Flex' );

-- Tabela TB_RASTREAMENTO (DATA_HORA_REGISTRO será preenchida pelo DEFAULT CURRENT_TIMESTAMP)
insert into tb_rastreamento (
   id_rastreamento,
   ips_x,
   ips_y,
   ips_z,
   gprs_latitude,
   gprs_longitude,
   gprs_altitude
) values ( 1,
           10.123,
           20.456,
           5.789,
           - 23.550520,
           - 46.633308,
           760.50 );
insert into tb_rastreamento (
   id_rastreamento,
   ips_x,
   ips_y,
   ips_z,
   gprs_latitude,
   gprs_longitude,
   gprs_altitude
) values ( 2,
           11.234,
           21.567,
           6.890,
           - 22.906847,
           - 43.172896,
           5.20 );
insert into tb_rastreamento (
   id_rastreamento,
   ips_x,
   ips_y,
   ips_z,
   gprs_latitude,
   gprs_longitude,
   gprs_altitude
) values ( 3,
           12.345,
           22.678,
           7.901,
           - 19.916681,
           - 43.934493,
           852.00 );
insert into tb_rastreamento (
   id_rastreamento,
   ips_x,
   ips_y,
   ips_z,
   gprs_latitude,
   gprs_longitude,
   gprs_altitude
) values ( 4,
           13.456,
           23.789,
           8.012,
           - 15.779728,
           - 47.929721,
           1172.00 );
insert into tb_rastreamento (
   id_rastreamento,
   ips_x,
   ips_y,
   ips_z,
   gprs_latitude,
   gprs_longitude,
   gprs_altitude
) values ( 5,
           14.567,
           24.890,
           9.123,
           - 23.561370,
           - 46.656199,
           780.75 );

-- Tabela TB_BOX
insert into tb_box (
   id_box,
   nome,
   status,
   data_entrada,
   data_saida,
   observacao
) values ( 1,
           'Box A01',
           'L',
           to_date('2025-05-01','YYYY-MM-DD'),
           to_date('2025-05-30','YYYY-MM-DD'),
           'Livre para uso' );
insert into tb_box (
   id_box,
   nome,
   status,
   data_entrada,
   data_saida,
   observacao
) values ( 2,
           'Box A02',
           'O',
           to_date('2025-05-15','YYYY-MM-DD'),
           to_date('2025-05-18','YYYY-MM-DD'),
           'Ocupado com CG 160' );
-- Corrigido STATUS de 'M' para 'O' (Ocupado) para fins de manutenção, para alinhar com DTO Pattern [LO].
-- Se 'M' for um status desejado, ajuste o DTO BoxRequestDto e considere uma CHECK constraint no DB.
insert into tb_box (
   id_box,
   nome,
   status,
   data_entrada,
   data_saida,
   observacao
) values ( 3,
           'Box B01',
           'O',
           to_date('2025-05-10','YYYY-MM-DD'),
           to_date('2025-05-20','YYYY-MM-DD'),
           'Ocupado - Em manutenção' );
insert into tb_box (
   id_box,
   nome,
   status,
   data_entrada,
   data_saida,
   observacao
) values ( 4,
           'Box C01',
           'L',
           to_date('2025-04-20','YYYY-MM-DD'),
           to_date('2025-06-20','YYYY-MM-DD'),
           null );
insert into tb_box (
   id_box,
   nome,
   status,
   data_entrada,
   data_saida,
   observacao
) values ( 5,
           'Box VIP01',
           'O',
           to_date('2025-05-17','YYYY-MM-DD'),
           to_date('2025-05-17','YYYY-MM-DD'),
           'Revisão rápida Mottu Sport' );

-- Tabela TB_PATIO
insert into tb_patio (
   id_patio,
   nome_patio,
   data_entrada,
   data_saida,
   observacao
) values ( 1,
           'Pátio Principal SP',
           to_date('2020-01-01','YYYY-MM-DD'),
           to_date('2099-12-31','YYYY-MM-DD'),
           'Pátio central de operações' );
insert into tb_patio (
   id_patio,
   nome_patio,
   data_entrada,
   data_saida,
   observacao
) values ( 2,
           'Pátio Filial RJ',
           to_date('2021-06-15','YYYY-MM-DD'),
           to_date('2099-12-31','YYYY-MM-DD'),
           'Pátio de apoio no Rio de Janeiro' );
insert into tb_patio (
   id_patio,
   nome_patio,
   data_entrada,
   data_saida,
   observacao
) values ( 3,
           'Pátio Manutenção MG',
           to_date('2022-03-10','YYYY-MM-DD'),
           to_date('2099-12-31','YYYY-MM-DD'),
           'Foco em manutenção e reparos' );
insert into tb_patio (
   id_patio,
   nome_patio,
   data_entrada,
   data_saida,
   observacao
) values ( 4,
           'Pátio Logística Sul',
           to_date('2023-08-01','YYYY-MM-DD'),
           to_date('2099-12-31','YYYY-MM-DD'),
           'Distribuição para região Sul' );
insert into tb_patio (
   id_patio,
   nome_patio,
   data_entrada,
   data_saida,
   observacao
) values ( 5,
           'Pátio Norte',
           to_date('2024-02-20','YYYY-MM-DD'),
           to_date('2099-12-31','YYYY-MM-DD'),
           null );

-- Tabela TB_ZONA
insert into tb_zona (
   id_zona,
   nome,
   data_entrada,
   data_saida,
   observacao
) values ( 1,
           'Zona de Carga',
           to_date('2020-01-01','YYYY-MM-DD'),
           to_date('2099-12-31','YYYY-MM-DD'),
           'Para carga e descarga de veículos' );
insert into tb_zona (
   id_zona,
   nome,
   data_entrada,
   data_saida,
   observacao
) values ( 2,
           'Zona de Espera',
           to_date('2020-01-01','YYYY-MM-DD'),
           to_date('2099-12-31','YYYY-MM-DD'),
           'Veículos aguardando designação' );
insert into tb_zona (
   id_zona,
   nome,
   data_entrada,
   data_saida,
   observacao
) values ( 3,
           'Zona de Manutenção A',
           to_date('2021-03-10','YYYY-MM-DD'),
           to_date('2099-12-31','YYYY-MM-DD'),
           'Manutenção preventiva' );
insert into tb_zona (
   id_zona,
   nome,
   data_entrada,
   data_saida,
   observacao
) values ( 4,
           'Zona de Lavagem',
           to_date('2022-01-01','YYYY-MM-DD'),
           to_date('2099-12-31','YYYY-MM-DD'),
           null );
insert into tb_zona (
   id_zona,
   nome,
   data_entrada,
   data_saida,
   observacao
) values ( 5,
           'Zona de Retirada Cliente',
           to_date('2020-01-01','YYYY-MM-DD'),
           to_date('2099-12-31','YYYY-MM-DD'),
           'Área para retirada de motos por clientes' );

-- Tabela TB_CLIENTE (DATA_CADASTRO será preenchida pelo DEFAULT SYSDATE)
insert into tb_cliente (
   id_cliente,
   sexo,
   nome,
   sobrenome,
   data_nascimento,
   cpf,
   profissao,
   estado_civil,
   tb_endereco_id_endereco,
   tb_contato_id_contato
) values ( 1,
           'M',
           'Carlos',
           'Alberto',
           to_date('1985-03-15','YYYY-MM-DD'),
           '11122233344',
           'Engenheiro',
           'Casado',
           1,
           1 );
insert into tb_cliente (
   id_cliente,
   sexo,
   nome,
   sobrenome,
   data_nascimento,
   cpf,
   profissao,
   estado_civil,
   tb_endereco_id_endereco,
   tb_contato_id_contato
) values ( 2,
           'H',
           'Joana',
           'Silva',
           to_date('1990-07-22','YYYY-MM-DD'),
           '22233344455',
           'Advogada',
           'Solteiro',
           2,
           2 );
insert into tb_cliente (
   id_cliente,
   sexo,
   nome,
   sobrenome,
   data_nascimento,
   cpf,
   profissao,
   estado_civil,
   tb_endereco_id_endereco,
   tb_contato_id_contato
) values ( 3,
           'M',
           'Pedro',
           'Santos',
           to_date('1978-11-30','YYYY-MM-DD'),
           '33344455566',
           'Médico',
           'Divorciado',
           3,
           3 );
insert into tb_cliente (
   id_cliente,
   sexo,
   nome,
   sobrenome,
   data_nascimento,
   cpf,
   profissao,
   estado_civil,
   tb_endereco_id_endereco,
   tb_contato_id_contato
) values ( 4,
           'H',
           'Ana',
           'Costa',
           to_date('1995-01-10','YYYY-MM-DD'),
           '44455566677',
           'Designer',
           'Solteiro',
           4,
           4 );
insert into tb_cliente (
   id_cliente,
   sexo,
   nome,
   sobrenome,
   data_nascimento,
   cpf,
   profissao,
   estado_civil,
   tb_endereco_id_endereco,
   tb_contato_id_contato
) values ( 5,
           'M',
           'Lucas',
           'Ferreira',
           to_date('2000-05-25','YYYY-MM-DD'),
           '55566677788',
           'Estudante',
           'Solteiro',
           5,
           1 ); -- Cliente Lucas usa o Contato 1

-- Tabela TB_CLIENTEVEICULO
insert into tb_clienteveiculo (
   tb_cliente_id_cliente,
   tb_cliente_tb_endereco_id_endereco,
   tb_cliente_tb_contato_id_contato,
   tb_veiculo_id_veiculo
) values ( 1,
           1,
           1,
           1 );
insert into tb_clienteveiculo (
   tb_cliente_id_cliente,
   tb_cliente_tb_endereco_id_endereco,
   tb_cliente_tb_contato_id_contato,
   tb_veiculo_id_veiculo
) values ( 2,
           2,
           2,
           3 );
insert into tb_clienteveiculo (
   tb_cliente_id_cliente,
   tb_cliente_tb_endereco_id_endereco,
   tb_cliente_tb_contato_id_contato,
   tb_veiculo_id_veiculo
) values ( 3,
           3,
           3,
           2 );
insert into tb_clienteveiculo (
   tb_cliente_id_cliente,
   tb_cliente_tb_endereco_id_endereco,
   tb_cliente_tb_contato_id_contato,
   tb_veiculo_id_veiculo
) values ( 4,
           4,
           4,
           4 );
insert into tb_clienteveiculo (
   tb_cliente_id_cliente,
   tb_cliente_tb_endereco_id_endereco,
   tb_cliente_tb_contato_id_contato,
   tb_veiculo_id_veiculo
) values ( 1,
           1,
           1,
           5 ); -- Cliente 1 (com seu endereco 1 e contato 1) alugou também a moto 5

-- Tabela TB_VEICULORASTREAMENTO
insert into tb_veiculorastreamento (
   tb_veiculo_id_veiculo,
   tb_rastreamento_id_rastreamento
) values ( 1,
           1 );
insert into tb_veiculorastreamento (
   tb_veiculo_id_veiculo,
   tb_rastreamento_id_rastreamento
) values ( 2,
           2 );
insert into tb_veiculorastreamento (
   tb_veiculo_id_veiculo,
   tb_rastreamento_id_rastreamento
) values ( 3,
           3 );
insert into tb_veiculorastreamento (
   tb_veiculo_id_veiculo,
   tb_rastreamento_id_rastreamento
) values ( 4,
           4 );
insert into tb_veiculorastreamento (
   tb_veiculo_id_veiculo,
   tb_rastreamento_id_rastreamento
) values ( 5,
           5 );

-- Tabela TB_VEICULOBOX
insert into tb_veiculobox (
   tb_veiculo_id_veiculo,
   tb_box_id_box
) values ( 2,
           2 ); -- Veiculo 2 no Box A02 (Ocupado)
insert into tb_veiculobox (
   tb_veiculo_id_veiculo,
   tb_box_id_box
) values ( 4,
           5 ); -- Veiculo 4 no Box VIP01 (Ocupado)
insert into tb_veiculobox (
   tb_veiculo_id_veiculo,
   tb_box_id_box
) values ( 1,
           1 ); -- Veiculo 1 no Box A01 (Livre, ok para associar)

-- Tabela TB_PATIOBOX
insert into tb_patiobox (
   tb_patio_id_patio,
   tb_box_id_box
) values ( 1,
           1 );
insert into tb_patiobox (
   tb_patio_id_patio,
   tb_box_id_box
) values ( 1,
           2 );
insert into tb_patiobox (
   tb_patio_id_patio,
   tb_box_id_box
) values ( 1,
           3 ); -- Box B01 (Em manutenção) no Pátio Principal SP
insert into tb_patiobox (
   tb_patio_id_patio,
   tb_box_id_box
) values ( 2,
           4 );
insert into tb_patiobox (
   tb_patio_id_patio,
   tb_box_id_box
) values ( 3,
           5 );

-- Tabela TB_ZONAPATIO
insert into tb_zonapatio (
   tb_patio_id_patio,
   tb_zona_id_zona
) values ( 1,
           1 );
insert into tb_zonapatio (
   tb_patio_id_patio,
   tb_zona_id_zona
) values ( 1,
           2 );
insert into tb_zonapatio (
   tb_patio_id_patio,
   tb_zona_id_zona
) values ( 2,
           3 );
insert into tb_zonapatio (
   tb_patio_id_patio,
   tb_zona_id_zona
) values ( 1,
           5 );
insert into tb_zonapatio (
   tb_patio_id_patio,
   tb_zona_id_zona
) values ( 3,
           4 );

-- Tabela TB_VEICULOPATIO
insert into tb_veiculopatio (
   tb_veiculo_id_veiculo,
   tb_patio_id_patio
) values ( 1,
           1 );
insert into tb_veiculopatio (
   tb_veiculo_id_veiculo,
   tb_patio_id_patio
) values ( 2,
           1 );
insert into tb_veiculopatio (
   tb_veiculo_id_veiculo,
   tb_patio_id_patio
) values ( 3,
           2 );
insert into tb_veiculopatio (
   tb_veiculo_id_veiculo,
   tb_patio_id_patio
) values ( 4,
           1 );
insert into tb_veiculopatio (
   tb_veiculo_id_veiculo,
   tb_patio_id_patio
) values ( 5,
           3 );

-- Tabela TB_VEICULOZONA
insert into tb_veiculozona (
   tb_veiculo_id_veiculo,
   tb_zona_id_zona
) values ( 1,
           2 );
insert into tb_veiculozona (
   tb_veiculo_id_veiculo,
   tb_zona_id_zona
) values ( 2,
           5 );
insert into tb_veiculozona (
   tb_veiculo_id_veiculo,
   tb_zona_id_zona
) values ( 3,
           1 );
insert into tb_veiculozona (
   tb_veiculo_id_veiculo,
   tb_zona_id_zona
) values ( 4,
           2 );
insert into tb_veiculozona (
   tb_veiculo_id_veiculo,
   tb_zona_id_zona
) values ( 5,
           3 );

-- Tabela TB_ZONABOX
insert into tb_zonabox (
   tb_zona_id_zona,
   tb_box_id_box
) values ( 2,
           1 ); -- Box A01 na Zona de Espera
insert into tb_zonabox (
   tb_zona_id_zona,
   tb_box_id_box
) values ( 2,
           2 ); -- Box A02 na Zona de Espera
insert into tb_zonabox (
   tb_zona_id_zona,
   tb_box_id_box
) values ( 3,
           3 ); -- Box B01 na Zona de Manutenção A
insert into tb_zonabox (
   tb_zona_id_zona,
   tb_box_id_box
) values ( 3,
           5 ); -- Box VIP01 na Zona de Manutenção A
insert into tb_zonabox (
   tb_zona_id_zona,
   tb_box_id_box
) values ( 1,
           4 ); -- Box C01 na Zona de Carga

-- Tabela TB_CONTATOPATIO
insert into tb_contatopatio (
   tb_patio_id_patio,
   tb_contato_id_contato
) values ( 1,
           5 );
insert into tb_contatopatio (
   tb_patio_id_patio,
   tb_contato_id_contato
) values ( 2,
           2 );
insert into tb_contatopatio (
   tb_patio_id_patio,
   tb_contato_id_contato
) values ( 3,
           3 );
insert into tb_contatopatio (
   tb_patio_id_patio,
   tb_contato_id_contato
) values ( 4,
           1 );
insert into tb_contatopatio (
   tb_patio_id_patio,
   tb_contato_id_contato
) values ( 5,
           4 );

-- Tabela TB_ENDERECIOPATIO
insert into tb_endereciopatio (
   tb_endereco_id_endereco,
   tb_patio_id_patio
) values ( 1,
           1 );
insert into tb_endereciopatio (
   tb_endereco_id_endereco,
   tb_patio_id_patio
) values ( 2,
           2 );
insert into tb_endereciopatio (
   tb_endereco_id_endereco,
   tb_patio_id_patio
) values ( 3,
           3 );
insert into tb_endereciopatio (
   tb_endereco_id_endereco,
   tb_patio_id_patio
) values ( 4,
           4 );
insert into tb_endereciopatio (
   tb_endereco_id_endereco,
   tb_patio_id_patio
) values ( 5,
           5 );

-- Tabela __EFMigrationsHistory (Exemplo, geralmente gerenciada pelo Entity Framework - descomente se necessário para seu ambiente)
-- INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion") VALUES ('20240517000000_InitialCreateMottu', '7.0.0');
-- INSERT INTO "__EFMigrationsHistory" ("MigrationId", "ProductVersion") VALUES ('20240518000000_AddExtraTablesMottu', '7.0.0');

commit;
-- Fim da inserção de dados mocados.