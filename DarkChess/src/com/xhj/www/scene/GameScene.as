package com.xhj.www.scene
{
	import com.xhj.www.App;
	import com.xhj.www.LayerManager;
	import com.xhj.www.component.AbstractScene;
	import com.xhj.www.consts.SceneType;
	import com.xhj.www.layer.CharacterLayer;
	import com.xhj.www.layer.MapLayer;
	import com.xhj.www.layer.map.MapTile;
	
	public class GameScene extends AbstractScene
	{
		private var _mapLayer:MapLayer;
		private var _characterLayer:CharacterLayer;
		
		public function GameScene()
		{
			_sceneType = SceneType.GAME;
			super();
		}
		
		override protected function init():void
		{
			_mapLayer = new MapLayer();
			_mapLayer.createMap();
			this.addChild(_mapLayer);
			
			_characterLayer = new CharacterLayer();
			_characterLayer.createCharacters();
			this.addChild(_characterLayer);
			
			this.x = (App.stage.stageWidth - _mapLayer.getLayerWidth()) / 2;
			this.y = App.stage.stageHeight / 2 - MapTile.TILE_HEIGHT / 2;
		}
		
		public function startRound():void
		{
			_mapLayer.mouseChildren = true;
			_mapLayer.startRound();
		}
		
		public function endRound():void
		{
			_mapLayer.mouseChildren = false;
		}
	}
}