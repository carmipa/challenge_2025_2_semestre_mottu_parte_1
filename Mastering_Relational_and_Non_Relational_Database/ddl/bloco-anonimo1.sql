   SET SERVEROUTPUT ON;

declare
  -- Cursor para listar clientes e seus veículos
   cursor c_clientes_veiculos is
   select c.nome as nome_cliente,
          c.sobrenome as sobrenome_cliente,
          v.placa as placa_veiculo,
          v.modelo as modelo_veiculo,
          v.fabricante as fabricante_veiculo
     from tb_cliente c
     join tb_clienteveiculo cv
   on c.id_cliente = cv.tb_cliente_id_cliente
     join tb_veiculo v
   on cv.tb_veiculo_id_veiculo = v.id_veiculo
    order by c.nome,
             v.placa;

  -- Cursor para contar veículos por fabricante que estão em algum pátio
   cursor c_veiculos_fabricante_patio is
   select v.fabricante,
          v.modelo,
          p.nome_patio,
          count(v.id_veiculo) as quantidade_veiculos
     from tb_veiculo v
     join tb_veiculopatio vp
   on v.id_veiculo = vp.tb_veiculo_id_veiculo
     join tb_patio p
   on vp.tb_patio_id_patio = p.id_patio
    group by v.fabricante,
             v.modelo,
             p.nome_patio
    order by v.fabricante,
             v.modelo,
             p.nome_patio;

  -- Cursor para listar pátios e a quantidade de boxes em cada um
   cursor c_patios_boxes is
   select p.nome_patio,
          count(pb.tb_box_id_box) as quantidade_boxes
     from tb_patio p
     left join tb_patiobox pb
   on p.id_patio = pb.tb_patio_id_patio -- Usando LEFT JOIN para incluir pátios sem boxes
    group by p.nome_patio
    order by p.nome_patio;

begin
   dbms_output.put_line('--- Consulta 1: Clientes e Seus Veículos Alugados ---');
   dbms_output.put_line('----------------------------------------------------');
   for rec in c_clientes_veiculos loop
      dbms_output.put_line('Cliente: '
                           || rec.nome_cliente
                           || ' '
                           || rec.sobrenome_cliente
                           || ' | Veículo Placa: '
                           || rec.placa_veiculo
                           || ' | Modelo: '
                           || rec.modelo_veiculo
                           || ' ('
                           || rec.fabricante_veiculo
                           || ')');
   end loop;
   dbms_output.put_line(chr(10)); -- Linha em branco

   dbms_output.put_line('--- Consulta 2: Quantidade de Veículos por Fabricante em Cada Pátio ---');
   dbms_output.put_line('---------------------------------------------------------------------');
   for rec in c_veiculos_fabricante_patio loop
      dbms_output.put_line('Fabricante: '
                           || rec.fabricante
                           || ' | Modelo: '
                           || rec.modelo
                           || ' | Pátio: '
                           || rec.nome_patio
                           || ' | Quantidade: '
                           || rec.quantidade_veiculos);
   end loop;
   dbms_output.put_line(chr(10)); -- Linha em branco

   dbms_output.put_line('--- Consulta 3: Pátios e Quantidade de Boxes ---');
   dbms_output.put_line('----------------------------------------------');
   for rec in c_patios_boxes loop
      dbms_output.put_line('Pátio: '
                           || rec.nome_patio
                           || ' | Quantidade de Boxes: '
                           || rec.quantidade_boxes);
   end loop;
   dbms_output.put_line(chr(10)); -- Linha em branco

exception
   when others then
      dbms_output.put_line('Erro ao executar o Bloco Anônimo 1: ' || sqlerrm);
end;
/