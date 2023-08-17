use mcdonaldsales;



select * from sales
where dt_venda <= NOW() - INTERVAL 3 MONTH;



/* precisamos ver se a variavel EVENT no mysql está habilitada*/
SHOW VARIABLES LIKE 'event%';

/* se estiver desabilitada, com esse comando iremos habilitar*/
SET GLOBAL event_scheduler = ON; 


/* criaremos a procedure que ira executar o delete*/

CREATE PROCEDURE stp_purge_tblsales()

    DELETE FROM sales
    WHERE dt_venda <= NOW() - INTERVAL 3 MONTH;



CREATE EVENT  IF NOT EXISTS purge_sale_bck
ON SCHEDULE AT CURRENT_TIMESTAMP 
ON COMPLETION PRESERVE
COMMENT 'Event criado para executar a Procedure de Expurgo na tabela sales'
DO

	CALL stp_purge_tblsales;
	

/*para visualizar os events que existem para o seu database
execute esse comando*/
show events from mcdonaldsales;

-- outra forma de criar é para ele executar na hora(TOME CUIDADO COM ESSE) 



CREATE EVENT  IF NOT EXISTS purge_sale_bck
ON SCHEDULE  EVERY 1 DAY
STARTS '2023-08-15 04:00:00'
ENDS '2053-12-31 04:00:00'
ON COMPLETION PRESERVE
COMMENT 'Event criado para executar a Procedure de Expurgo na tabela sales'
DO

	CALL stp_purge_tblsales;
	




CREATE EVENT  IF NOT EXISTS purge_sale_bck
ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 2 MINUTE
ON COMPLETION PRESERVE
COMMENT 'Event criado para executar a Procedure de Expurgo na tabela sales'
DO

	CALL stp_purge_tblsales;
	

