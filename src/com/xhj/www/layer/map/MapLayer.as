package com.xhj.www.layer.map
{
	import com.xhj.www.App;
	import com.xhj.www.GlobalParam;
	import com.xhj.www.component.AbstractLayer;
	import com.xhj.www.component.GameObjectBase;
	import com.xhj.www.consts.LayerType;
	import com.xhj.www.utils.DisplayObjectUtil;
	import com.xhj.www.utils.HashMap;
	
	import flash.events.MouseEvent;
	
	public class MapLayer extends AbstractLayer
	{
		private static var _mapTile:HashMap = new HashMap();
		private var _mapSprite:GameObjectBase;
		
		public function MapLayer()
		{
			super();
		}
		
		public function createMap():void
		{
			_mapSprite = new GameObjectBase();
			_mapSprite.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			_mapSprite.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			this.addChild(_mapSprite);
			
			var mapTile:MapTile;
			for (var i:int = 0; i < GlobalParam.MAP_ROW; ++i)
			{
				for (var j:int = 0; i < GlobalParam.MAP_COLUMN; ++i)
				{
					mapTile = new MapTile(i, j);
					_mapTile.put(mapTile.getPos(), mapTile);
					_mapSprite.addChild(mapTile);
				}
			}
			DisplayObjectUtil.centerDisplayObject(_mapSprite, App.stage);
		}
		
		private function onMouseDownHandler(e:MouseEvent):void
		{
			_mapSprite.startDrag(true);
		}
		
		private function onMouseUpHandler(e:MouseEvent):void
		{
			_mapSprite.stopDrag();
		}
		
		public static function getMapTile(pos:uint):MapTile
		{
			return _mapTile.get(pos);
		}
		
		override public function getPopLayer():uint
		{
			return LayerType.MAP;
		}
	}
}