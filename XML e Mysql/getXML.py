from database import conn  
import xml.etree.ElementTree as ET

cursor = conn.cursor()

xml = ("vendas.xml")


# analisa o XML
tree = ET.parse(xml)
root = tree.getroot()

# insert na tabela com o de para
for venda in root.findall('venda'):
    cd_venda = int(venda.find('codigo_da_venda').text)
    quantidade = int(venda.find('quantidade_de_produtos').text)
    valor_venda = float(venda.find('valor_da_venda').text)
    data_da_venda = venda.find('data_da_venda').text
    codigo_do_vendedor = int(venda.find('codigo_do_vendedor').text)
    codigo_do_cliente = int(venda.find('codigo_do_cliente').text)
    
    qry_insert ="""
        INSERT INTO vendas_online (id, qtde_produtos, valor_venda, dt_venda, vendedor_id, cliente_id)
        VALUES (%s, %s, %s, %s, %s, %s)
        """ 

    cursor.execute(qry_insert, (cd_venda, quantidade, valor_venda, data_da_venda, codigo_do_vendedor, codigo_do_cliente))

# commit e fecha a conexão
conn.commit()

# Verificar se o comando de inserção foi bem-sucedido
if cursor.rowcount > 0:
    print("Inserção bem-sucedida!")
else:
    print("Nenhum registro inserido.")

cursor.close()
conn.close()
