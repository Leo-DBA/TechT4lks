import pyodbc
from dotenv import load_dotenv
import os

load_dotenv()

# configuração de conexão com o banco de dados destino
def conn():
    try:
        server = 'DESKTOP-DBA\SQL2019'
        database = 'Alerts'
        username = os.getenv('user_namedb')
        password = os.getenv('passDB')

        conexao = pyodbc.connect('Driver={SQL Server};'
                                 f'Server={server};'
                                 f'Database={database};'
                                 f'UID={username};'
                                 f'PWD={password};')
        print('Conexão estabelecida com sucesso no banco de dados!')



        return conexao

    except pyodbc.Error as ex:
        print("Erro ao conectar ao banco de dados:", ex)
