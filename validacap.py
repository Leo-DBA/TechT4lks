import shutil
import os
from tqdm import tqdm
from database import conn

# Defina o diretório remoto e o caminho do arquivo remoto
remote_dir = '\\\\Winlab01-sqldb\\b\\BACKUP\\'
remote_file = 'Northwind_FULL20230725.BAK'
db_name = 'Northwind_HML'

# Verifique se o arquivo existe no diretório remoto
if os.path.isfile(os.path.join(remote_dir, remote_file)):
    # Crie o diretório local se não existir
    local_dir = r'D:\Backups Databases\Python with SQL\\'
    os.makedirs(local_dir, exist_ok=True)

    # Obtenha o tamanho total do arquivo remoto
    total_size = os.path.getsize(os.path.join(remote_dir, remote_file))

    # Copie o arquivo do diretório remoto para o diretório local
    print('Copiando Backup para o diretorio destino')
    with open(os.path.join(remote_dir, remote_file), 'rb') as source:
        with open(os.path.join(local_dir, remote_file), 'wb') as destination:
            with tqdm(total=total_size, unit='B', unit_scale=True, unit_divisor=1024) as pbar:
                while True:
                    chunk = source.read(1024)
                    if not chunk:
                        break
                    destination.write(chunk)
                    pbar.update(len(chunk))

    print('Arquivo copiado com sucesso!')

    # cria conexão com o banco
    conexao = conn()
    cursor = conexao.cursor()
    print('Conectado no Banco de dados!!')


    cursor.execute("SET IMPLICIT_TRANSACTIONS OFF")
    conexao.commit()

    print('                                                               ')
    print('Iniciando o restore do banco de dados')
    # joga os parametros para dentro da proc
    sql = f"EXEC stp_RestoreWithPython @path='{os.path.join(local_dir, remote_file)}', @db_name='{db_name}'"
    cursor.execute(sql)
    while cursor.nextset():
        pass

    print ('Restore do database finalizado!')

    conexao.close()



else:
    print('Arquivo não encontrado!')
