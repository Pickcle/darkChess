package
{
	import com.xhj.www.App;
	import com.xhj.www.AssetsManager;
	import com.xhj.www.SceneManager;
	import com.xhj.www.consts.SceneType;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	
	[SWF(frameRete="30", width="1280", height="720")]
	public class DarkChess extends Sprite
	{
		public function DarkChess()
		{
			Security.allowDomain ("*");
			Security.allowInsecureDomain ("*");
			if (stage)
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			App.stage = stage;
			App.myNation = 1;
			AssetsManager.init(startGame);
			
//			MonsterDebugger.initialize(this);
		}
		
		private function startGame():void
		{
			SceneManager.changeScene(SceneType.GAME);
		}
		
		
	}
}