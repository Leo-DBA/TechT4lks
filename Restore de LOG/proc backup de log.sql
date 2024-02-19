use PADARIA
go

CREATE PROCEDURE geraBckLog
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DataHora NVARCHAR(100);
    SET @DataHora = REPLACE(REPLACE(CONVERT(NVARCHAR(30), GETDATE(), 120), '-', ''), ' ', '_');
    SET @DataHora = REPLACE(REPLACE(REPLACE(@DataHora, ':', ''), '.', ''), '_', '');

    DECLARE @NomeArquivo NVARCHAR(255);
    SET @NomeArquivo = 'D:\Backups Databases\Padaria\LOG\PADARIA_' + @DataHora + '.trn';

    DECLARE @ComandoBackup NVARCHAR(MAX);
    SET @ComandoBackup = 'BACKUP LOG PADARIA TO DISK = ''' + @NomeArquivo + '''';

    EXEC(@ComandoBackup);
END;
