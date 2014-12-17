package com.xhj.www.component
{
	import com.xhj.www.GlobalParam;
	import com.xhj.www.LayerManager;
	import com.xhj.www.RoundManager;
	import com.xhj.www.consts.NationType;
	import com.xhj.www.layer.MapLayer;
	import com.xhj.www.layer.map.MapTile;
	import com.xhj.www.utils.AStar;
	import com.xhj.www.utils.BitmapUtil;
	import com.xhj.www.utils.DisplayObjectUtil;
	import com.xhj.www.utils.MapTileUtil;
	import com.xhj.www.utils.TweenLite;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 人物基类
	 * @author ASUS
	 * 
	 */	
	public class AbstractSprite extends GameObjectBase
	{
		protected var _pos:uint;		//坐标
		protected var _nation:int;		//国家
		protected var _type:int;		//人物种类
		protected var _targetList:Array = [];//可移动格子列表
		protected var _isDark:Boolean;
		
		protected var _spriteImg:Bitmap;
		protected var _spriteName:TextField;
		
		public function AbstractSprite()
		{
			super();
		}
		
		override protected function installComponent():void
		{
			_spriteImg = new Bitmap();
			this.addChild(_spriteImg);
			
			var tf:TextFormat = new TextFormat();
			tf.align = TextFieldAutoSize.CENTER;
			tf.size = 16;
			
			_spriteName = new TextField();
			_spriteName.width = 80;
			_spriteName.height = 25;
			_spriteName.textColor = getNationColor();
			_spriteName.defaultTextFormat = tf;
			_spriteName.text = getSpriteName();
			this.addChild(_spriteName);
			
			setIsDark(true);
			
			_spriteName.x = (_spriteImg.width - _spriteName.width) / 2;
			_spriteName.y = 10;
		}
		
		override protected function uninstallComponent():void
		{
			if (_targetList)
			{
				_targetList.length = 0;
			}
			_targetList = null;
		}
		
		override protected function installListener():void
		{
		}
		
		override protected function uninstallListener():void
		{
		}
		
		protected function getSpriteName():String
		{
			return "";
		}
		
		public function goto(mapTile:MapTile):void
		{
			var oldTile:MapTile = MapTileUtil.getMapTile(_pos);
			oldTile.setCharacter(null);
			var ways:Array = getWays(oldTile, mapTile);
			if (mapTile.getEmpty())//空地
			{
				move(ways);
			}
			else//敌人
			{
				move(ways);
//				attack(mapTile);
			}
		}
		
		public function die():void
		{
			DisplayObjectUtil.removeFromParent(this);
			LayerManager.removeCharacter(this);
		}
		
		protected function getWays(startTile:MapTile, endTile:MapTile):Array
		{
			return AStar.find(startTile, endTile);
		}
		
		protected function move(ways:Array):void
		{
			if (0 == ways.length)
			{
				return;
			}
			if (this.parent)
			{
				this.parent.setChildIndex(this, this.parent.numChildren - 1);//将活跃人物置顶层
			}
			var nextTile:MapTile = ways.pop();
			if (nextTile.getPos() != _pos)//不是当前格子
			{
				moveThisToTile(nextTile, ways);
			}
			else
			{
				move(ways);
			}
		}
		
		protected function moveThisToTile(targetTile:MapTile, ways:Array):void
		{
			var crtTile:MapTile = MapTileUtil.getMapTile(_pos);
			var dltX:Number = (targetTile.getPosX() - crtTile.getPosX());
			var dltY:Number = (targetTile.getPosY() - crtTile.getPosY());
			var targetX:Number = this.x + (dltX + dltY) * MapTile.TILE_WIDTH / 2;
			var targetY:Number = this.y + (dltY - dltX) * MapTile.TILE_HEIGHT / 2;
			
			TweenLite.to(this, 0.6, {x:targetX, y:targetY}, 0, moveComplete, [targetTile, ways]);
		}
		
		protected function moveComplete(targetTile:MapTile, ways:Array):void
		{
			if (0 == ways.length)
			{
				targetTile.clear();//原先敌人死亡
				targetTile.setCharacter(this);
				RoundManager.nextRound();
			}
			else
			{
				_pos = targetTile.getPos();		//目前移动到pos上
				move(ways);
			}
		}
		
		public function flip():void
		{
			setIsDark(false);
			updatePosition();
			RoundManager.nextRound();
		}
		
		private function setIsDark(value:Boolean):void
		{
			_isDark = value;
			_spriteImg.bitmapData = _isDark ? BitmapUtil.getBitmapData("SPRITE_9") : BitmapUtil.getBitmapData("SPRITE_" + _type);
			_spriteName.visible = !_isDark;
		}
		
		/**
		 * 高亮可攻击范围
		 * 
		 */		
		public function showAttackRange():void
		{
			var tiles:Array = getAttackRangeList();
			for each (var mapTile:MapTile in tiles)
			{
				mapTile.turnGreen();
			}
			_targetList = tiles;
		}
		
		/**
		 * 取消高亮
		 * 
		 */		
		public function hideAttackRange():void
		{
			for each (var mapTile:MapTile in _targetList)
			{
				mapTile.turnWhite();
			}
		}
		
		public function checkInTargetList(mapTile:MapTile):Boolean
		{
			return _targetList.indexOf(mapTile) != -1;
		}
		
		protected function getAttackRangeList():Array
		{
			return [];
		}
		
		protected function getNationColor():uint
		{
			var result:uint;
			switch (_nation)
			{
				case NationType.SHU:
					result = 0x00ff00;
					break;
				case NationType.WEI:
					result = 0x0000ff;
					break;
				case NationType.WU:
					result = 0xff0000;
					break;
			}
			return result;
		}
		
		protected function updatePosition():void
		{
			var mapTile:MapTile = MapTileUtil.getMapTile(_pos);
			if (mapTile)
			{
				const offsetY:int = GlobalParam.NUM_OFFSET_SPRITE_ON_MAPTILE_Y;
				this.x = mapTile.x + (mapTile.width - this.width) / 2;
				this.y = mapTile.y + (this.height == 85 ? offsetY : offsetY + 8);
			}
		}
		
		public function setNation(nation:int):void
		{
			_nation = nation;
			_spriteName.textColor = getNationColor();
		}
		
		public function getNation():int
		{
			return _nation;
		}
		
		public function setPos(pos:int):void
		{
			_pos = pos;
			
			updatePosition();
		}
		
		public function getPos():uint
		{
			return _pos;
		}
		
		public function getIsDark():Boolean
		{
			return _isDark;
		}
	}
}