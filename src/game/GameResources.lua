--需要预加载的资源
PreloadResources = {		
	--全局资源
	GlobalRes = {
		spriteFrames = {	--全局TexturePacker生成的纹理路径，将在第一次进入游戏时加载至SpriteFrameCache

		},				
		textures = {		--全局使用的图片纹理，将在第一次进入游戏时加载至TextureCache

		},					
		armatures = {	--全局CocosStudio生成的Armature动画资源，将在第一次进入游戏时异步加载至ccs.ArmatureDataManager
			
		},				
		audioClips = {		--全局音乐资源，将在第一次进入游戏时通过AudioEngine.preloadMusic加载


		},
		audioEffects = {	--全局音效资源，将在第一次进入游戏时通过AudioEngine.preloadEffect加载
			
		}
	},
	--场景资源
	TestScene = {},
} 
