local composer = require("composer")
local physics = require("physics")
local C = require("Constants")

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    -- Configuração de fundo inicial
    local paginaFundo = display.newImage(sceneGroup, "Imagens/Pag2/FUNDO.png")
    paginaFundo.x = display.contentCenterX
    paginaFundo.y = display.contentCenterY

     -- LINHA
     local linha  = display.newImage(sceneGroup, "Imagens/Pag2/LINHA.png",
     C.W - 330 - C.MARGIN,
     C.H - 160 - C.MARGIN
 )
    
    -- BOTÃO 1
    local btAno1 = display.newImage(sceneGroup, "Imagens/Pag2/BOTAO1.png",
        C.W - 530 - C.MARGIN,
        C.H - 160 - C.MARGIN)
    
    -- BOTÃO 2
    local btAno2 = display.newImage(sceneGroup, "Imagens/Pag2/BOTAO2.png",
        C.W - 320 - C.MARGIN,
        C.H - 160 - C.MARGIN)
    
    -- BOTÃO 3
    local btAno3 = display.newImage(sceneGroup, "Imagens/Pag2/BOTAO3.png",
        C.W - 120 - C.MARGIN,
        C.H - 160 - C.MARGIN)
    
    -- BOTÃO VOLTAR
    local btVoltar = display.newImage(sceneGroup, "Imagens/Pag2/VOLTAR.png",
        C.W - 120 - C.MARGIN,
        C.H - 280 - C.MARGIN)
    btVoltar.isVisible = false -- O botão voltar começa invisível

   -- Cenários
local cenarios = {
    CENARIO1 = "Imagens/Pag2/CENARIO1.png",
    CENARIO2 = "Imagens/Pag2/CENARIO2.png",
    CENARIO3 = "Imagens/Pag2/CENARIO3.png",
}

-- Variável para armazenar a referência do cenário atual
local currentCenario

-- Função para mostrar um cenário
local function showCenario(cenarioKey)
    -- Se já existir um cenário na tela, remova-o
    if currentCenario then
        currentCenario.isVisible = false  -- Torna o cenário invisível
    end

    -- Verifica se o cenário existe no banco de dados
    if cenarios[cenarioKey] then
        -- Cria e exibe o novo cenário
        currentCenario = display.newImage(sceneGroup, cenarios[cenarioKey],
            C.W - 330 - C.MARGIN,
            C.H - 110 - C.MARGIN
        )
    else
        print("Cenário não encontrado: " .. tostring(cenarioKey))
    end
end 

-- Função para ativar um botão e esconder os outros, além de exibir o botão voltar
local function onButtonTap(activatedButton)
    -- Esconde todos os botões
    btAno1.isVisible = false
    btAno2.isVisible = false
    btAno3.isVisible = false
    linha.isVisible = false  -- Esconde a linha (se houver)

    -- Exibe o botão "Voltar"
    btVoltar.isVisible = true
end

-- Função para voltar ao estado inicial (onde os botões 1, 2 e 3 estão visíveis)
local function onVoltarTap()
    -- Esconde o botão "Voltar"
    btVoltar.isVisible = false

    -- Exibe todos os botões novamente
    btAno1.isVisible = true
    btAno2.isVisible = true
    btAno3.isVisible = true
    linha.isVisible = true  -- Exibe a linha novamente (se houver)

    -- Torna o cenário invisível
    if currentCenario then
        currentCenario.isVisible = false  -- Torna o cenário invisível
     else
        print("Nenhum cenário encontrado para tornar invisível.")
    end
end

-- Evento para o Botão 1
btAno1:addEventListener("tap", function()
    onButtonTap(btAno1)
    showCenario("CENARIO1")  -- Mostra o cenário 1
end)

-- Evento para o Botão 2
btAno2:addEventListener("tap", function()
    onButtonTap(btAno2)
    showCenario("CENARIO2")  -- Mostra o cenário 2
end)

-- Evento para o Botão 3
btAno3:addEventListener("tap", function()
    onButtonTap(btAno3)
    showCenario("CENARIO3")  -- Mostra o cenário 3
end)

-- Evento para o Botão "Voltar"
btVoltar:addEventListener("tap", onVoltarTap)        
    
    -- Botão Som
    local btsom = display.newImage(sceneGroup, "Imagens/Geral/LIGARSOM.png",
        C.W - 60 - C.MARGIN,
        C.H - 850 - C.MARGIN)
    local isSoundOn = false

    -- Carregue o arquivo de áudio
    local backgroundMusic = audio.loadStream("Audio/PAG2.mp3")
    local backgroundMusicChannel -- Canal para o áudio
    
    -- Função para controle do som
    function btsom:touch(event)
        if event.phase == "began" then
            if isSoundOn then
                -- Pausar o som e alterar a imagem
                audio.stop(backgroundMusicChannel)
                isSoundOn = false
                btsom.fill = { type = "image", filename = "Imagens/Geral/LIGARSOM.png" }
            else
                -- Tocar o som e alterar a imagem
                backgroundMusicChannel = audio.play(backgroundMusic, { loops = -1 }) -- Loop infinito
                isSoundOn = true
                btsom.fill = { type = "image", filename = "Imagens/Geral/DESLIGARSOM.png" }
            end
        end
        return true
    end

                -- Botão Próximo
                local btNext = display.newImage(sceneGroup, "Imagens/Geral/PROXIMO.png",
                C.W - 280 - C.MARGIN,
                C.H - 40)
                 btNext:addEventListener("tap", function()
                  composer.gotoScene("pag3", { effect = "fromRight", time = 1000 })
                end)
        
            -- Botão Anterior
                local btAnt = display.newImage(sceneGroup, "Imagens/Geral/ANTERIOR.png",
                C.W - 380 - C.MARGIN,
                C.H - 40)
                btAnt:addEventListener("tap", function()
                composer.gotoScene("pag1", { effect = "fromLeft", time = 1000 })
                end)    
    

    -- Evento para interromper o som ao sair da cena
    function scene:hide(event)
        if event.phase == "will" then
            -- Parar o áudio antes de sair da cena
            audio.stop(backgroundMusicChannel)
            backgroundMusicChannel = nil -- Limpar o canal
        end
    end
        
    -- Evento para liberar recursos ao encerrar a cena
    function scene:destroy(event)
        audio.dispose(backgroundMusic)
        backgroundMusic = nil
    end
        
    -- Adicionar o listener ao botão de som
    btsom:addEventListener("touch", btsom)

end


-- Evento para ocultar a cena
function scene:hide(event)
    if event.phase == "will" then
        -- Parar o áudio antes de sair da cena
        audio.stop()
    end
end

-- Evento para destruir a cena
function scene:destroy(event)
    audio.dispose()
end
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
