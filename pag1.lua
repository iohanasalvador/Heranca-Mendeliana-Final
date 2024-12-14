local C = require('Constants')
local composer = require("composer")
local physics = require("physics")

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    -- Configuração de fundo
    local paginaFundo = display.newImage(sceneGroup, "Imagens/Pag1/FUNDO.png")
    paginaFundo.x = display.contentCenterX
    paginaFundo.y = display.contentCenterY

-- Evolução das Plantas
-- Inicialmente, carregue a primeira imagem
local plantImages = {
    "Imagens/Pag1/PLANTA1.png",
    "Imagens/Pag1/PLANTA2.png",
    "Imagens/Pag1/PLANTA3.png",
    "Imagens/Pag1/PLANTA4.png"
}

-- Índice da imagem atual
local currentImageIndex = 1

-- Cria o botão de planta com a primeira imagem e escala ajustada
local btplanta = display.newImage(sceneGroup, plantImages[currentImageIndex])
btplanta.x = C.W - 330 - C.MARGIN
btplanta.y = C.H - 200 - C.MARGIN

-- Função para alterar a imagem e redimensionar dinamicamente
local function changePlantImage()
    -- Atualiza o índice para a próxima imagem
    currentImageIndex = currentImageIndex + 1

    -- Reinicia o índice quando todas as imagens forem exibidas
    if currentImageIndex > #plantImages then
        currentImageIndex = 1
    end

    -- Atualiza a textura do botão
    btplanta.fill = { type = "image", filename = plantImages[currentImageIndex] }

    -- Ajusta o tamanho do botão com base no índice (exemplo de adaptação)
    if currentImageIndex == 1 then
        btplanta.width, btplanta.height = 200, 200
    elseif currentImageIndex == 2 then
        btplanta.width, btplanta.height = 300, 250
    elseif currentImageIndex == 3 then
        btplanta.width, btplanta.height = 500, 280
    else
        btplanta.width, btplanta.height = 500, 280
    end
end

-- Detectar sacudidas utilizando o acelerômetro
local shakeThreshold = 2.0 -- Ajuste para a sensibilidade desejada
local lastShakeTime = 0
local minShakeInterval = 500 -- Intervalo mínimo entre sacudidas (em milissegundos)

local function onAccelerometer(event)
    -- Calcula a magnitude do movimento
    local magnitude = math.sqrt(event.xInstant^2 + event.yInstant^2 + event.zInstant^2)

    -- Verifica se excedeu o limiar e respeita o intervalo mínimo
    if magnitude > shakeThreshold and system.getTimer() - lastShakeTime > minShakeInterval then
        lastShakeTime = system.getTimer()
        changePlantImage()
    end
end

-- Adiciona o listener do acelerômetro
Runtime:addEventListener("accelerometer", onAccelerometer)

    -- Botão som
    local btsom = display.newImage(sceneGroup, "Imagens/Geral/LIGARSOM.png",
        C.W - 60 - C.MARGIN,
        C.H - 850 - C.MARGIN)
    local isSoundOn = false -- Inicialização

    -- Botão próximo
    local btNext = display.newImage(sceneGroup, "Imagens/Geral/PROXIMO.png",
        C.W - 250 - C.MARGIN,
        C.H + 1 - C.MARGIN)

    -- Botão anterior
    local btAnt = display.newImage(sceneGroup, "Imagens/Geral/ANTERIOR.png",
        C.W - 350 - C.MARGIN,
        C.H + 1 - C.MARGIN)

    -- Evento para o botão próximo
    local function onNextTap()
        composer.gotoScene("pag2", { effect = "fromRight", time = 1000 })
    end
    btNext:addEventListener("tap", onNextTap)
  
    -- Evento para o botão anterior
    local function onAntTap()
        composer.gotoScene("capa", { effect = "fromLeft", time = 1000 })
    end
    btAnt:addEventListener("tap", onAntTap)

    -- Áudio de fundo
    local backgroundMusic = audio.loadStream("Audio/PAG1.mp3")
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

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código executado antes da cena aparecer na tela
    elseif (phase == "did") then
        -- Código executado quando a cena está visível
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Código executado antes da cena desaparecer
    elseif (phase == "did") then
        -- Código executado depois que a cena saiu da tela
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    -- Limpeza de objetos e listeners
end

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
