storage, fuel_id = {                                 --|
    posts = {}                                       --|
}, {                                                 --|
    ["gasoline"] = 1,                                --|
    ["alcohol"] = 2                                  --|
}                                                    --|
----------------------- NÂO MEXER ---------------------;
cust_post_fuel = false -- Ative para gastar o combustível do POSTO caso alguém compre alguma quantia, ex:
    -- Comprei 10L diminuirá 10L do posto, vamos supor... tem 1000/1000 ficaria 990/1000
    -- Obs: Caso ative, você deve ter algum SCRIPT para abastecer o sistema.
fuel_types = {
    [1] = {
        type = "gasoline", --> Propriedade do combustível [ Recomendado não mexer ]
        count = 1, cust = 4}, --> Altere ao seu gosto.
        --|         | Preço PADRÂO que será definido quando criar um POSTO.
        --| Quantidade que gasta a cada 5000 tick
    [2] = {
        type = "alcohol",  --> Propriedade do combustível [ Recomendado não mexer ]
        count = 2, cust = 2} --> Altere ao seu gosto.
        --|         | Preço PADRÂO que será definido quando criar um POSTO.
        --| Quantidade que gasta a cada 5000 tick
}