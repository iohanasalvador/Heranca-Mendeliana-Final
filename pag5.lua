local composer = require("composer")
local C = require("Constants")

local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    -- Configuração do fundo
    local paginaFundo = display.newImage(sceneGroup, "Imagens/Pag5/FUNDO.png")
    paginaFundo.x = display.contentCenterX
    paginaFundo.y = display.contentCenterY

    -- Criação do Padre
    local padre = display.newImage(sceneGroup, "Imagens/Pag5/PADRE.png")
    padre.x = C.W - 20 - C.MARGIN -- Posição inicial em X
    padre.y = C.H - 200 - C.MARGIN -- Posição inicial em Y
    padre.imageType = "PADRE" -- Tipo inicial

    -- Grupo para plantas
    local plantasGroup = display.newGroup()
    sceneGroup:insert(plantasGroup)

 -- Função para criar uma nova planta e deixá-la fixa
local function criarPlanta(x, y)
    local planta = display.newImage(plantasGroup, "Imagens/Pag5/PLANTA.png")
    planta.x = x
    planta.y = y + 50 -- Fica abaixo do padre
end

-- Função para alternar a imagem do padre para "padres"
local function alternarPadre()
    if padre.imageType == "PADRE" then
        padre.fill = { type = "image", filename = "Imagens/Pag5/PADRES.png" }
        padre.imageType = "PADRES"
    else
        padre.fill = { type = "image", filename = "Imagens/Pag5/PADRE.png" }
        padre.imageType = "PADRE"
    end
end

-- Função para mover o padre automaticamente
local function moverPadre()
    padre.x = padre.x - 2 -- Move para a esquerda

    -- Quando o padre passar de uma posição específica, ele troca para "PADRES" e cria uma planta
    if padre.x < 0 then
        padre.x = C.W -- Reinicia do lado direito
    end

    -- Cria uma planta atrás do padre sempre que ele passar por um ponto específico
    if padre.x % 100 == 0 then -- A cada 100 pixels
        criarPlanta(padre.x, padre.y)
    end

    -- Alterna a imagem do padre a cada movimento
    alternarPadre()
end

-- Variável para armazenar o timer do movimento do padre
local padreTimer

-- Função para iniciar o movimento do padre quando ele for tocado
local function iniciarMovimento(event)
    if event.phase == "began" then
        -- Inicia o movimento do padre usando um timer
        if not padreTimer then
            padreTimer = timer.performWithDelay(200, moverPadre, 0)
        end
    end
    return true -- Para evitar propagação do evento
end

-- Adiciona um listener de toque ao objeto padre
padre:addEventListener("touch", iniciarMovimento)



      -- Botão som
      local btsom = display.newImage(sceneGroup, "Imagens/Geral/LIGARSOM.png",
      C.W - 50 - C.MARGIN,
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
      composer.gotoScene("contra", { effect = "fromRight", time = 1000 })
  end
  btNext:addEventListener("tap", onNextTap)

  -- Evento para o botão anterior
  local function onAntTap()
      composer.gotoScene("pag4", { effect = "fromLeft", time = 1000 })
  end
  btAnt:addEventListener("tap", onAntTap)

  -- Áudio de fundo
  local backgroundMusic = audio.loadStream("Audio/PAG5.mp3")
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
