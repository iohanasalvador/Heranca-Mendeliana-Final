local C = require('Constants')
local composer = require("composer")
display.setDefault("magTextureFilter", "nearest")

local scene = composer.newScene()

-- Variável global para controlar o estado do som
local isSoundOn = false

-- Criação da tela
function scene:create(event)
    local sceneGroup = self.view

    -- Configuração do Fundo da tela
    local fundo = display.newImage(sceneGroup, "Imagens/Contracapa/FUNDO.png")
    fundo.x = display.contentCenterX
    fundo.y = display.contentCenterY 

        -- Botão próximo
        local btNext = display.newImage(sceneGroup, "Imagens/Contracapa/CAPA.png",
        C.W - 250 - C.MARGIN,
        C.H + 1 - C.MARGIN)
    
        local function onNextTap()
            composer.gotoScene("capa", { effect = "fromRight", time = 1000 })
        end
        btNext:addEventListener("tap", onNextTap)

     -- Botão anterior
     local btAnt = display.newImage(sceneGroup, "Imagens/Geral/ANTERIOR.png",
     C.W - 350 - C.MARGIN,
     C.H + 1 - C.MARGIN)
 
     local function onAntTap()
         composer.gotoScene("pag5", { effect = "fromLeft", time = 1000 })
     end
     btAnt:addEventListener("tap", onAntTap)

    -- Botão som
    local btsom = display.newImage(
        sceneGroup, "Imagens/Geral/LIGARSOM.png",
        C.W - 30 - C.MARGIN,
        C.H - 850 - C.MARGIN
    )

    -- Carregue o arquivo de áudio
    local backgroundMusic = audio.loadStream("Audio/CONTRACAPA.mp3")
    local backgroundMusicChannel -- Canal para o áudio
    local isSoundOn = false -- Estado inicial do som
    
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

    -- Evento para ir para a próxima página
    local function onNextTap(event)
        composer.gotoScene("capa", { effect = "fromRight", time = 1000 })
    end

    -- Adiciona listener ao botão próximo
    btNext:addEventListener('tap', onNextTap)
end

-- Funções padrão do Composer
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
