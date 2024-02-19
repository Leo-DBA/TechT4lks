# Defina as variáveis do seu ambiente
$DatabaseOrigem = "PADARIA"
$DatabaseDestino = "PADARIA"
$CaminhoBackupFull = "D:\Backups Databases\Padaria\FULL\PADARIA_BCK_1.bak"
$CaminhoBackupDiff = "N/A"
$CaminhoPastaLog = "D:\Backups Databases\Padaria\LOG\"
$logicalName = "PADARIA_novo"
$logicalNamelog =  "PADARIA_log_novo"
# Defina se o backup deve substituir uma base de dados existente
$Replace = 1  # Defina como 1 para substituir uma base existente, 0 para criar uma nova base

# Obtém a data de criação dos backups Full e Diff
$DataCriacaoFull = (Get-Item $CaminhoBackupFull).CreationTime
$DataCriacaoDiff = if (Test-Path $CaminhoBackupDiff) { (Get-Item $CaminhoBackupDiff).CreationTime } else { Get-Date }

# Lista todos os arquivos de log na pasta especificada e filtra os que foram criados após as datas dos backups Full e Diff
$ArquivosLog = Get-ChildItem -Path $CaminhoPastaLog -Filter *.trn | Where-Object { $_.CreationTime -gt $DataCriacaoFull -or $_.CreationTime -gt $DataCriacaoDiff }
# 
# Cria o script de restauração para o backup full
$ScriptRestauracao = "USE master`n"

# Verifica se a opção REPLACE deve ser usada
if ($Replace -eq 1) {
    $ScriptRestauracao += "RESTORE DATABASE $DatabaseDestino FROM DISK = '$CaminhoBackupFull' WITH REPLACE, NORECOVERY, STATS = 1`n"
} else {
    # Adiciona a cláusula MOVE para o arquivo de dados e o arquivo de log
    $ScriptRestauracao += "RESTORE DATABASE $DatabaseDestino FROM DISK = '$CaminhoBackupFull' WITH NORECOVERY, STATS = 1,"
    $ScriptRestauracao += "MOVE 'PADARIA' TO 'D:\SQL22\MSSQL16.LMDS22\MSSQL\DATA\$logicalName.mdf',"
    $ScriptRestauracao += "MOVE 'PADARIA_LOG' TO 'D:\SQL22\MSSQL16.LMDS22\MSSQL\DATA\$logicalNamelog.ldf'`n"
}

# Adiciona a restauração do backup diferencial, se existir
if (Test-Path $CaminhoBackupDiff) {
    $ScriptRestauracao += "RESTORE DATABASE $DatabaseDestino FROM DISK = '$CaminhoBackupDiff' WITH NORECOVERY`n"
}

# Adiciona a restauração dos backups de log
foreach ($ArquivoLog in $ArquivosLog) {
    $ScriptRestauracao += "RESTORE LOG $DatabaseDestino FROM DISK = '$($ArquivoLog.FullName)' WITH NORECOVERY`n"
}

# Finaliza a restauração deixando o banco de dados online
$ScriptRestauracao += "RESTORE DATABASE $DatabaseDestino WITH RECOVERY`n"

# Exibe o script de restauração gerado
Write-Output $ScriptRestauracao
