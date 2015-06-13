-----------------
--统一声音管理
-----------------

local SoundManager = class("SoundManager" , function () --@return scene
    return {}
end)

SoundManager.__index = SoundManager

AudioClips = {
    coin = "res/audio/coin.wav",
    buttonClicked = "res/audio/button-clicked.mp3",
    speedup = "res/audio/speedup.mp3",
    skillJump = "res/audio/intro_jump.mp3",
    skillSprint = "res/audio/jump3.wav",
    getItem = "res/audio/powerup_activate_magnet.mp3",
    gameOver = "res/audio/game_failed.mp3",
    backgroundMusic = "res/audio/LetsHuntAliens.mp3",
    homeBackgroundMusic = "res/audio/WCSelect.mp3",
    runNormal = "res/audio/hero_run_1.mp3",
    heroDeath = "res/audio/hero_death_generic_1.mp3",
    betterCoin = "res/audio/diamond_gold_collected.mp3",
    enemyKicked = "res/audio/enemy_stomped_3.mp3",
    boss = "res/audio/boss.mp3",
    wind = "res/audio/wind.mp3",
    flyWing = "res/audio/wing.wav"
}
function SoundManager:init()
    Log.d("SoundManager初始化音频管理器")
    Log.d("默认背景音乐关闭？："..Engine:getConfigLoader():loadValue("BACKGROUND_MUSIC_OFF",false))
    Log.d("默认音效关闭？："..Engine:getConfigLoader():loadValue("EFFECT_MUSIC_OFF",false))
--AudioEngine.preloadMusic(backgroundMusic)
    
end

function SoundManager:clear()
    
end

local instance = nil
function SoundManager:getInstance()
    if instance == nil then
        instance = SoundManager.new()
        instance:init()
    end
    
    return instance
end

function SoundManager:isAudioOn()
    return Engine:getConfigLoader():loadValue("EFFECT_MUSIC_OFF",false) ~= "1"
end

function SoundManager:isMusicOn()
    return Engine:getConfigLoader():loadValue("BACKGROUND_MUSIC_OFF",false) ~= "1"
end


function SoundManager:closeMusic(close)
    if close then
        Log.i("关闭背景音乐")
        Engine:getConfigLoader():saveValue("BACKGROUND_MUSIC_OFF","1",false)
    else
        Log.i("开启背景音乐")
        Engine:getConfigLoader():saveValue("BACKGROUND_MUSIC_OFF","0",false)
    end
end

function SoundManager:closeEffect(close)
    if close then
        Log.i("关闭音效")
        Engine:getConfigLoader():saveValue("EFFECT_MUSIC_OFF","1",false)
    else
        Log.i("开启音效")
        Engine:getConfigLoader():saveValue("EFFECT_MUSIC_OFF","0",false)
    end
end

function SoundManager:playBackgroundMusic(audioclip, loop)
    if Engine:getConfigLoader():loadValue("BACKGROUND_MUSIC_OFF",false) ~= "1" then
        audio.stopMusic(false)
        audio.playMusic(audioclip, loop)
    end   
end

function SoundManager:playEffect(audioclip,loop)
    if Engine:getConfigLoader():loadValue("EFFECT_MUSIC_OFF",false) ~= "1" then
        return audio.playSound(audioclip, loop)
    end   
end

function SoundManager:stopEffect(eid)
    if eid == nil then
        Log.i("stop all")
        audio.stopAllSounds()
    else
        audio.stopSound(eid)
    end
end
function SoundManager:stopBackgroundMusic()
    audio.stopMusic()
end



function SoundManager:clear()
    --self:stopBackgroundMusic()
end

return SoundManager