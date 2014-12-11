package com.xhj.www.component
{
	import com.xhj.www.LayerManager;
	import com.xhj.www.RoundManager;
	import com.xhj.www.consts.NationType;
	import com.xhj.www.layer.MapLayer;
	import com.xhj.www.layer.map.MapTile;
	import com.xhj.www.utils.BitmapUtil;
	import com.xhj.www.utils.DisplayObjectUtil;
	import com.xhj.www.utils.MapTileUtil;
	
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
		protected var _targetList:Array;//可移动格子列表
		protected var _isDark:Boolean;
		
		protected var _spriteImg:Bitmap;
		protected var _spriteName:TextField;
		
		public function AbstractSprite()
		{
			super();
		}
		
		override protected function installComponent():void
		{
			setIsDark(true);
			this.addChild(_spriteImg);
			
			var tf:TextFormat = new TextFormat();
			tf.align = TextFieldAutoSize.CENTER;
			tf.size = 16;
			
			_spriteName = new TextField();
			_spriteName.width = 80;
			_spriteName.height = 25;
			_spriteName.textColor = getNationColor();
			_spriteName.x = (_spriteImg.width - _spriteName.width) / 2;
			_spriteName.y = 15;
			_spriteName.defaultTextFormat = tf;
			_spriteName.text = getSpriteName();
			this.addChild(_spriteName);
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		override protected function uninstallComponent():void
		{
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
			if (oldTile.getEmpty())//空地
			{
				move(mapTile);
			}
			else//敌人
			{
				attack(mapTile);
			}
			oldTile.setCharacter(null);
			mapTile.setCharacter(this);
		}
		
		public function die():void
		{
			DisplayObjectUtil.removeFromParent(this);
			LayerManager.removeCharacter(this);
		}
		
		protected function move(mapTile:MapTile):void
		{
			doMoveAction(mapTile);
		}
		
		protected function attack(mapTile:MapTile):void
		{
			mapTile.clear();
			doAttackAction(mapTile);
		}
		
		protected function doMoveAction(mapTile:MapTile):void
		{
			
			RoundManager.nextRound();
		}
		
		protected function doAttackAction(mapTile:MapTile):void
		{
			
			RoundManager.nextRound();
		}
		
		public function flip():void
		{
			setIsDark(false);
			RoundManager.nextRound();
		}
		
		private function setIsDark(value:Boolean):void
		{
			_isDark = value;
			_spriteImg = _isDark ? BitmapUtil.getBitmap("SPRITE_9") : BitmapUtil.getBitmap("SPRITE_" + _type);
		}
		
		public function showAttackRange():void
		{
			var tiles:Array = getAttackRangeList();
			for each (var mapTile:MapTile in tiles)
			{
				mapTile.turnGreen();
			}
		}
		
		protected function getAttackRangeList():Array
		{
			return null;
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
		
		public function checkCanReach(mapTile:MapTile):Boolean
		{
			return _targetList.indexOf(mapTile) != -1;
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