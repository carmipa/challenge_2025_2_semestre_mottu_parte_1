   SET SERVEROUTPUT ON;

declare
  -- Cursor para veículos em boxes, com nome do box e pátio
   cursor c_veiculos_em_boxes is
   select v.placa as placa_veiculo,
          v.modelo as modelo_veiculo,
          b.nome as nome_box,
          p.nome_patio
     from tb_veiculo v
     join tb_veiculobox vb
   on v.id_veiculo = vb.tb_veiculo_id_veiculo
     join tb_box b
   on vb.tb_box_id_box = b.id_box
     join tb_patiobox pb
   on b.id_box = pb.tb_box_id_box
     join tb_patio p
   on pb.tb_patio_id_patio = p.id_patio
    where b.status = 'O' -- Considerar apenas boxes ocupados
    order by p.nome_patio,
             b.nome;

  -- Cursor para listar clientes e a quantidade de veículos associados
   cursor c_clientes_contagem_veiculos is
   select c.nome as nome_cliente,
          c.sobrenome as sobrenome_cliente,
          count(cv.tb_veiculo_id_veiculo) as quantidade_veiculos
     from tb_cliente c
     left join tb_clienteveiculo cv
   on c.id_cliente = cv.tb_cliente_id_cliente -- LEFT JOIN para incluir clientes sem veículos
    group by c.id_cliente,
             c.nome,
             c.sobrenome
    order by quantidade_veiculos desc,
             c.nome,
             c.sobrenome;

  -- Cursor para Zonas, Pátios e quantidade de veículos em cada zona
   cursor c_zonas_patios_veiculos is
   select z.nome as nome_zona,
          p.nome_patio,
          count(distinct vz.tb_veiculo_id_veiculo) as quantidade_veiculos_na_zona
     from tb_zona z
     join tb_zonapatio zp
   on z.id_zona = zp.tb_zona_id_zona
     join tb_patio p
   on zp.tb_patio_id_patio = p.id_patio
     left join tb_veiculozona vz
   on z.id_zona = vz.tb_zona_id_zona -- Veículos naquela zona (independente do pátio do veículo)
    group by z.nome,
             p.nome_patio
    order by p.nome_patio,
             z.nome;

begin
   dbms_output.put_line('--- Consulta 1: Veículos Atualmente em Boxes (Ocupados) ---');
   dbms_output.put_line('--------------------------------------------------------');
   for rec in c_veiculos_em_boxes loop
      dbms_output.put_line('Pátio: '
                           || rec.nome_patio
                           || ' | Box: '
                           || rec.nome_box
                           || ' | Veículo Placa: '
                           || rec.placa_veiculo
                           || ' | Modelo: '
                           || rec.modelo_veiculo);
   end loop;
   dbms_output.put_line(chr(10)); -- Linha em branco

   dbms_output.put_line('--- Consulta 2: Clientes e Quantidade de Veículos Associados ---');
   dbms_output.put_line('-------------------------------------------------------------');
   for rec in c_clientes_contagem_veiculos loop
      dbms_output.put_line('Cliente: '
                           || rec.nome_cliente
                           || ' '
                           || rec.sobrenome_cliente
                           || ' | Quantidade de Veículos: '
                           || rec.quantidade_veiculos);
   end loop;
   dbms_output.put_line(chr(10)); -- Linha em branco

   dbms_output.put_line('--- Consulta 3: Zonas por Pátio e Quantidade de Veículos Designados à Zona ---');
   dbms_output.put_line('---------------------------------------------------------------------------');
   for rec in c_zonas_patios_veiculos loop
      dbms_output.put_line('Pátio: '
                           || rec.nome_patio
                           || ' | Zona: '
                           || rec.nome_zona
                           || ' | Veículos na Zona: '
                           || rec.quantidade_veiculos_na_zona);
   end loop;
   dbms_output.put_line(chr(10)); -- Linha em branco

exception
   when others then
      dbms_output.put_line('Erro ao executar o Bloco Anônimo 2: ' || sqlerrm);
end;
/