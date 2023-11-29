--Dependencies
local utils = require("utils")
local player = require("player.player")
local actions = require("player.actions")
local colossus = require("colossus.colossus")
local colossusActions = require("colossus.colossusActions")


--Habilitar UTF-8 no terminal
utils.enableUtf8()

--Header
utils.printHeader()

--Obter definições do jogador


--Obter definições do monstro
local boss = colossus
local bossActions = colossusActions

--Apresentar o monstro
utils.printCreature(boss)

--Build actions
actions.build()
bossActions.build()

--Começar o loop da batalha
while true do
    --Mostrar ações para o jogador
    print(string.format("Qual será a proxima ação de %s?", player.name))
    local validPlayerActions = actions.getValidActions(player, boss)
    for i, action in pairs(validPlayerActions) do
        print(string.format("%d. %s", i, action.description))
    end
    local chosenIndex = utils.ask()
    local chosenAction = validPlayerActions[chosenIndex]
    local isActionValid = chosenAction ~= nil

    --Simular turno do jogador
    if isActionValid then
        chosenAction.execute(player, boss)
    else
        print(string.format("Sua escolha é inválida. %s perdeu a vez.", player.name))
    end
    
    --Ponto de saida: Criatura ficou sem vida
    if boss.health <= 0 then
        break
    end

    --Simular turno da criatura
    print()
    local validBossActions = bossActions.getValidActions(player, boss)
    local bossAction = validBossActions[math.random(#validBossActions)]
    bossAction.execute(player, boss)

    if player.health <= 0 then
        break
    end
end

    --Processar condição de vitória e derrota
    --Ponto de saida: Jogador ficou sem vida
    if player.health <= 0 then
        print()
        print("---------------------------------")
        print()
        print(string.format("%s não foi capaz de vencer %s", player.name, boss.name))
        print("Quem sabe na proxima vez...")
        print()

    elseif boss.health <= 0 then
        print()
        print("---------------------------------")
        print()
        print(string.format("%s prevaleceu e venceu %s", player.name, boss.name))
        print("Parabéns!!!")
        print()
    end