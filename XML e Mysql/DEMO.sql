
select * from produtos;
SELECT CONCAT(
    '<produtos>',
    GROUP_CONCAT(
        CONCAT(
            '<produto>',
            '<id>', id_prod, '</id>',
            '<nome>', nm_produto, '</nome>',
            '<quantidade>', qtde_estoque, '</quantidade>'
            '<validade>', validade, '</validade>',
            '</cliente>'
        )
        SEPARATOR ''
    ),
    '</produtos>'
)
FROM produtos;
