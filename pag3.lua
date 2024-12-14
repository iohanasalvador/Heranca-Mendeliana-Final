local composer = require("composer")
local physics = require("physics")
local C = require("Constants")

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view
    physics.start()
    physics.setGravity(0, 0) -- Desativar a gravidade

    -- Configuração de fundo inicial
    local paginaFundo = display.newImage(sceneGroup, "Imagens/Pag3/FUNDO.png")
    paginaFundo.x = display.contentCenterX
    paginaFundo.y = display.contentCenterY

    -- Elementos iniciais com suas posições iniciais armazenadas
    local elementoV = display.newImage(sceneGroup, "Imagens/Pag3/ELEMENTOVV.png",
        C.W - 500 - C.MARGIN, C.H - 270 - C.MARGIN)
    elementoV.startX, elementoV.startY = elementoV.x, elementoV.y

    local elementov = display.newImage(sceneGroup, "Imagens/Pag3/ELEMENTOv.png",
        C.W - 250 - C.MARGIN, C.H - 270 - C.MARGIN)
    elementov.startX, elementov.startY = elementov.x, elementov.y

    physics.addBody(elementoV, "dynamic", { radius = 50, isSensor = true })
    physics.addBody(elementov, "dynamic", { radius = 50, isSensor = true })

    -- Elementos resultantes (invisíveis inicialmente)
    local elementoVV = display.newImage(sceneGroup, "Imagens/Pag3/ELEMENTOW.png",
        C.W - 500 - C.MARGIN, 
        C.H - 170 - C.MARGIN)
    elementoVV.isVisible = false
    physics.addBody(elementoVV, "dynamic", { radius = 50, isSensor = true })

    local elementoVv = display.newImage(sceneGroup, "Imagens/Pag3/VELEMENTOv.png",
        C.W - 250 - C.MARGIN, 
        C.H - 170 - C.MARGIN)
    elementoVv.isVisible = false
    physics.addBody(elementoVv, "dynamic", { radius = 50, isSensor = true })

    -- Função para redefinir a posição dos elementos
    local function resetPosition(object)
        object.x = object.startX
        object.y = object.startY
    end

    -- Verifica colisão inicial entre ElementoV e Elementov
    local function onCollisionInicial(event)
        if (event.phase == "began") then
            if (event.object1 == elementoV and event.object2 == elementov) or
                (event.object1 == elementov and event.object2 == elementoV) then

                -- Reseta as posições dos elementos
                resetPosition(elementoV)
                resetPosition(elementov)

                -- Mostra os novos elementos sem esconder os antigos
                elementoVV.isVisible = true
                elementoVv.isVisible = true
            end
        end
    end

    -- Verifica colisão entre ElementoVV e ElementoVv para gerar os filhos
    local function onCollisionFinal(event)
        if (event.phase == "began") then
            if (event.object1 == elementoVV and event.object2 == elementoVv) or
                (event.object1 == elementoVv and event.object2 == elementoVV) then

                -- Reseta as posições dos elementos resultantes
                resetPosition(elementoVV)
                resetPosition(elementoVv)

                -- Mostra a imagem dos filhos
                local filhos = display.newImage(sceneGroup, "Imagens/Pag3/FILHOS.png",
                C.W - 350 - C.MARGIN, 
                C.H - 80 - C.MARGIN)

                -- Função para voltar ao início ao tocar nos filhos
                local function onFilhosTap()
                    composer.gotoScene("inicio", { effect = "fade", time = 1000 })
                end

                filhos:addEventListener("tap", onFilhosTap)
            end
        end
    end

    -- Adiciona eventos de colisão
    Runtime:addEventListener("collision", onCollisionInicial)
    Runtime:addEventListener("collision", onCollisionFinal)

    -- Função de arraste genérica
    local function onDragTouch(event)
        local target = event.target
        if event.phase == "began" then
            target.isFocus = true
            target.offsetX = event.x - target.x
            target.offsetY = event.y - target.y
            display.getCurrentStage():setFocus(target)
        elseif target.isFocus then
            if event.phase == "moved" then
                target.x = event.x - target.offsetX
                target.y = event.y - target.offsetY
            elseif event.phase == "ended" or event.phase == "cancelled" then
                target.isFocus = false
                display.getCurrentStage():setFocus(nil)
            end
        end
        return true
    end

    -- Permitir arraste dos elementos
    elementoV:addEventListener("touch", onDragTouch)
    elementov:addEventListener("touch", onDragTouch)
    elementoVV:addEventListener("touch", onDragTouch)
    elementoVv:addEventListener("touch", onDragTouch)

    -- Botão próximo
    local btNext = display.newImage(sceneGroup, "Imagens/Geral/PROXIMO.png",
    C.W - 250 - C.MARGIN,
    C.H + 1 - C.MARGIN)

    local function onNextTap()
        composer.gotoScene("pag4", { effect = "fromRight", time = 1000 })
    end
    btNext:addEventListener("tap", onNextTap)

    -- Botão anterior
    local btAnt = display.newImage(sceneGroup, "Imagens/Geral/ANTERIOR.png",
    C.W - 350 - C.MARGIN,
    C.H + 1 - C.MARGIN)

    local function onAntTap()
        composer.gotoScene("pag2", { effect = "fromLeft", time = 1000 })
    end
    btAnt:addEventListener("tap", onAntTap)

    -- Áudio de fundo
    local btsom = display.newImage(sceneGroup, "Imagens/Geral/LIGARSOM.png",
        C.W - 60 - C.MARGIN,
        C.H - 850 - C.MARGIN)


    -- Áudio de fundo
    local backgroundMusic = audio.loadStream("Audio/PAG3.mp3")
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

-- Funções padrão do Composer
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
