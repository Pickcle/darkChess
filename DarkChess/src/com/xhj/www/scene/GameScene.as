package com.xhj.www.scene
{
	import com.xhj.www.App;
	import com.xhj.www.GlobalParam;
	import com.xhj.www.LayerManager;
	import com.xhj.www.component.AbstractScene;
	import com.xhj.www.consts.SceneType;
	import com.xhj.www.layer.ButtonLayer;
	import com.xhj.www.layer.CharacterLayer;
	import com.xhj.www.layer.MapLayer;
	import com.xhj.www.layer.map.MapTile;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class GameScene extends AbstractScene
	{
		private var _mapLayer:MapLayer;
		private var _characterLayer:CharacterLayer;
		private var _buttonLayer:ButtonLayer;
		
		private var _mouseX:Number;
		private var _mouseY:Number;
		
		public function GameScene()
		{
			_sceneType = SceneType.GAME;
			super();
		}
		
		override protected function installComponent():void
		{
			_mapLayer = new MapLayer();
			_mapLayer.createMap();
			this.addChild(_mapLayer);
			
			_characterLayer = new CharacterLayer();
			_characterLayer.createCharacters();
			this.addChild(_characterLayer);
			
			_buttonLayer = new ButtonLayer();
			_buttonLayer.createButtons();
			_buttonLayer.y = -(GlobalParam.MAP_COLUMN - 1) * MapTile.TILE_HEIGHT / 2;
			this.addChild(_buttonLayer);
			
//			this.x = (App.stage.stageWidth - _mapLayer.getLayerWidth()) / 2;
			this.y = (GlobalParam.MAP_COLUMN - 1) * MapTile.TILE_HEIGHT / 2;
		}
		
		override protected function installListener():void
		{
			_mapLayer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
//			_mapLayer.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			_mapLayer.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOutHandler);
		}
		
		override protected function uninstallListener():void
		{
			_mapLayer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_mapLayer.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			_mapLayer.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			_mapLayer.removeEventListener(MouseEvent.ROLL_OUT, onMouseRollOutHandler);
		}
		
		override protected function init():void
		{
		}
		
		public function startRound():void
		{
			_mapLayer.startRound();
			_buttonLayer.startRound();
		}
		
		public function endRound():void
		{
			_mapLayer.endRound();
		}
		
		private function onMouseDownHandler(e:MouseEvent):void
		{
			var canMoveWidth:Number = _mapLayer.getLayerWidth() - stage.stageWidth;
			var canMoveHeight:Number = _mapLayer.getLayerHeight() - stage.stageHeight;
			
			var rect:Rectangle = new Rectangle(0, 0, -canMoveWidth, -canMoveHeight);
			_mapLayer.startDrag(false, rect);
			
			_mapLayer.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			_mapLayer.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}
		
		private function onMouseUpHandler(e:MouseEvent):void
		{
			_mapLayer.stopDrag();
			_mapLayer.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			_mapLayer.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
		}
		
		private function onMouseRollOutHandler(e:MouseEvent):void
		{
//			onMouseUpHandler(null);
		}
		
		private function onMouseMoveHandler(e:MouseEvent):void
		{
			_characterLayer.x = _mapLayer.x;
			_characterLayer.y = _mapLayer.y;
		}
	}
}