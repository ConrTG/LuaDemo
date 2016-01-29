
cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")

-- CC_USE_DEPRECATED_API = true
require "cocos.init"

-- cclog
cclog = function(...)
print(string.format(...))
end



local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    
    -- 取得螢幕大小與座標.
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local origin = cc.Director:getInstance():getVisibleOrigin()
    
    -- initialize director
    
    local schedulerID = 0
    
    --support debug
    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
    if (cc.PLATFORM_OS_IPHONE == targetPlatform) or (cc.PLATFORM_OS_IPAD == targetPlatform) or
        (cc.PLATFORM_OS_ANDROID == targetPlatform) or (cc.PLATFORM_OS_WINDOWS == targetPlatform) or
        (cc.PLATFORM_OS_MAC == targetPlatform) then
        cclog("targetPlatform is " .. targetPlatform)
        
    end
    
    ---------------
    
    
    -- create menu
    local function createUpdateLayer()
        local baseLayer = cc.Layer:create()
        local visibleSize = cc.Director:getInstance():getVisibleSize()

        -- 使用plist載入圖片資源.
        local frameCache = cc.SpriteFrameCache:getInstance()
        frameCache:addSpriteFrames("StartScene.plist");
        
        local sprite=cc.Sprite:createWithSpriteFrameName("ddwm00040001.png")
        sprite:setPosition(origin.x + visibleSize.width / 2, origin.y + visibleSize.height / 2)
        baseLayer:addChild(sprite)
        
        local function menuCallbackOpenPopup()
            print("MenuCallBack")
        end
        
        -- 建立 Menu.
        local menuToolsItem = cc.MenuItemImage:create("menu1.png", "menu1.png")
        menuToolsItem:setPosition(0, 0)
        menuToolsItem:registerScriptTapHandler(menuCallbackOpenPopup)
        menuTools = cc.Menu:create(menuToolsItem)
        local itemWidth = menuToolsItem:getContentSize().width
        local itemHeight = menuToolsItem:getContentSize().height
        menuTools:setPosition(origin.x + itemWidth/2, origin.y + itemHeight/2)
        
        baseLayer:addChild(menuTools)
        
        
        return baseLayer
    end
    
    -- 播放背景音樂 及 預載音效.
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3")
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
    local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
    
    
    -- 畫面create function.
    function createUpdateScene()
        local updateScene = cc.Scene:create()
        updateScene(createUpdateLayer())
        
        cc.Director:getInstance():replaceScene(updateScene)
    end
    
end

-- ---------------------------
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cclog("----------------------------------------")
    cclog("LUA ERROR: " .. tostring(msg) .. "\n")
    cclog(debug.traceback())
    cclog("----------------------------------------")
    return msg
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
