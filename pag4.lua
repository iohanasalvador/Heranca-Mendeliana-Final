local composer = require("composer")
local C = require("Constants")

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    -- Configuração de fundo inicial
sceneGroup.fundo = display.newImage(sceneGroup, "Imagens/Pag4/FUNDO.png")
sceneGroup.fundo.x = display.contentCenterX
sceneGroup.fundo.y = display.contentCenterY

-- Ervilha
local objeto = display.newImage(sceneGroup, "Imagens/Pag4/ERVILHA.png")
objeto.x = C.W - 328 - C.MARGIN
objeto.y = C.H - 150 - C.MARGIN
objeto:scale(1, 1) -- Escala inicial da ervilha

-- Variáveis para rastrear o estado do movimento de pinça
local initialDistance = 0
local initialScale = 1

-- Função para calcular a distância entre dois pontos
local function calcularDistancia(touch1, touch2)
    local dx = touch2.x - touch1.x
    local dy = touch2.y - touch1.y
    return math.sqrt(dx * dx + dy * dy)
end

-- Função de toque para detectar o movimento de pinça
local function onMultitouch(event)
    if event.numTouches == 2 then
        if event.phase == "began" then
            -- Registra a distância inicial entre os dois toques
            initialDistance = calcularDistancia(event, event)
            initialScale = objeto.xScale
        elseif event.phase == "moved" then
            -- Calcula a nova distância entre os dois toques
            local currentDistance = calcularDistancia(event, event)
            if initialDistance > 0 then
                -- Calcula o fator de escala com base na distância atual e inicial
                local scaleFactor = currentDistance / initialDistance

                -- Aplica o zoom ao objeto
                objeto.xScale = initialScale * scaleFactor
                objeto.yScale = initialScale * scaleFactor

                -- Define limites para o zoom
                if objeto.xScale < 0.5 then
                    objeto.xScale = 0.5
                    objeto.yScale = 0.5
                elseif objeto.xScale > 2.0 then
                    objeto.xScale = 2.0
                    objeto.yScale = 2.0
                end
            end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            -- Reseta as variáveis quando o toque termina
            initialDistance = 0
        end
    end
    return true
end

-- Adiciona o listener para multitouch
Runtime:addEventListener("touch", onMultitouch)



    -- Botão som
    local btsom = display.newImage(sceneGroup, "Imagens/Geral/LIGARSOM.png",
        C.W - 60 - C.MARGIN,
        C.H - 850 - C.MARGIN
    )
    local isSoundOn = false -- Inicialização do som

    -- Botão próximo
    local btNext = display.newImage(sceneGroup, "Imagens/Geral/PROXIMO.png",
        C.W - 250 - C.MARGIN,
        C.H + 1 - C.MARGIN
    )

    -- Botão anterior
    local btAnt = display.newImage(sceneGroup, "Imagens/Geral/ANTERIOR.png",
        C.W - 350 - C.MARGIN,
        C.H + 1 - C.MARGIN
    )

    -- Evento para o botão próximo
    local function onNextTap()
        composer.gotoScene("pag5", { effect = "fromRight", time = 1000 })
    end
    btNext:addEventListener("tap", onNextTap)

    -- Evento para o botão anterior
    local function onAntTap()
        composer.gotoScene("pag3", { effect = "fromLeft", time = 1000 })
    end
    btAnt:addEventListener("tap", onAntTap)

    -- Áudio de fundo
    local backgroundMusic = audio.loadStream("Audio/PAG4.mp3")
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
                backgroundMusicChannel = audio.play(backgroundMusic)
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
end
    
-- Listener padrão da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
