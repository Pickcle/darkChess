package com.xhj.www.layer
{
	import com.xhj.www.App;
	import com.xhj.www.GameManager;
	import com.xhj.www.GlobalParam;
	import com.xhj.www.LayerManager;
	import com.xhj.www.RoundManager;
	import com.xhj.www.component.AbstractLayer;
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.component.GameObjectBase;
	import com.xhj.www.consts.LayerType;
	import com.xhj.www.layer.map.MapTile;
	import com.xhj.www.utils.HashMap;
	import com.xhj.www.utils.MapTileUtil;
	
	import flash.events.MouseEvent;
	
	public class MapLayer extends AbstractLayer
	{
//		private static var _mapTile:HashMap = new HashMap();
		private var _floor:GameObjectBase;
		private var _selectedSprite:AbstractSprite;	//当前选中士兵
		private var _status:int;			//当前地图状态 0 = 不可选， 1 = 选择目标， 2 = 选择二级目标
		
		public function MapLayer()
		{
			super();
		}
		
		public function createMap():void
		{
			_floor = new GameObjectBase();
			this.addChild(_floor);
			
			var mapTile:MapTile;
			var map:HashMap = new HashMap();
			for (var i:int = 0; i < GlobalParam.MAP_ROW; ++i)
			{
				for (var j:int = 0; j < GlobalParam.MAP_COLUMN; ++j)
				{
					mapTile = new MapTile(i, j);
					mapTile.onClickFunction = onClickHandler;
					map.put(mapTile.getPos(), mapTile);
					_floor.addChild(mapTile);
				}
			}
			MapTileUtil.mapTile = map;
		}
		
		public function startRound():void
		{
			this.mouseChildren = true;
			_status = 1;
			resetMapTile();
		}
		
		public function endRound():void
		{
			this.mouseChildren = false;
		}
		
		private function resetMapTile():void
		{
			for each (var tile:MapTile in MapTileUtil.getAllTiles())
			{
				tile.reset();
			}
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			if (_status == 0)
			{
				return;
			}
			var targetTile:MapTile = ((e.currentTarget as GameObjectBase).parent as MapTile);
			if (targetTile.getEmpty())//点击空地
			{
				if (_status == 2 && _selectedSprite.checkInTargetList(targetTile))//移动
				{
					_selectedSprite.goto(targetTile);
				}
				return;
			}
			var sprite:AbstractSprite = targetTile.getCharacter();
			if (sprite.getIsDark())//翻棋
			{
				sprite.flip();
				return;
			}
			if (sprite.getNation() == GameManager.getCurrentNation())//点击自己士兵
			{
				_status = 2;
				if (_selectedSprite)
				{
					_selectedSprite.hideAttackRange();
				}
				_selectedSprite = sprite;
				sprite.showAttackRange();
				return;
			}
			if (sprite.getNation() != GameManager.getCurrentNation() && _status == 2  && _selectedSprite.checkInTargetList(targetTile))//点击敌人
			{
				_selectedSprite.goto(targetTile);
				return;
			}
		}
		
		public function getLayerWidth():Number
		{
			return _floor.width;
		}
		
		public function getLayerHeight():Number
		{
			return _floor.height;
		}
		
		override public function getPopLayer():uint
		{
			return LayerType.MAP;
		}
	}
}