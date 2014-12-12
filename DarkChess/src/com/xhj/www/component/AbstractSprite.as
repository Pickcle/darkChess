package com.xhj.www.component
{
	import com.xhj.www.GlobalParam;
	import com.xhj.www.LayerManager;
	import com.xhj.www.RoundManager;
	import com.xhj.www.consts.NationType;
	import com.xhj.www.layer.MapLayer;
	import com.xhj.www.layer.map.MapTile;
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
			
			setIsDark(false);
			
			_spriteName.x = (_spriteImg.width - _spriteName.width) / 2;
			_spriteName.y = 10;
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
			oldTile.setCharacter(null);
			if (mapTile.getEmpty())//空地
			{
				move(mapTile);
			}
			else//敌人
			{
				attack(mapTile);
			}
		}
		
		public function die():void
		{
			DisplayObjectUtil.removeFromParent(this);
			LayerManager.removeCharacter(this);
		}
		
		protected function moveThisToTile(targetTile:MapTile, callback:Function):void
		{
			var crtTile:MapTile = MapTileUtil.getMapTile(_pos);
			var dltX:Number = (targetTile.getPosX() - crtTile.getPosX());
			var dltY:Number = (targetTile.getPosY() - crtTile.getPosY());
			var targetX:Number;
			var targetY:Number;
			if (dltX > 0 || dltY > 0)//向右
			{
				targetX = this.x + MapTile.TILE_WIDTH / 2;
			}
			else//向左
			{
				targetX = this.x - MapTile.TILE_WIDTH / 2;
			}
			if (dltX - dltY > 0)//向上
			{
				targetY = this.y - MapTile.TILE_HEIGHT / 2;
			}
			else//向下
			{
				targetY = this.y + MapTile.TILE_HEIGHT / 2;
			}
			TweenLite.to(this, 1, {x:targetX, y:targetY}, 0, callback);
		}
		
		protected function move(mapTile:MapTile):void
		{
			doMoveAction(mapTile, actionCompleteHandler);
		}
		
		protected function attack(mapTile:MapTile):void
		{
			doAttackAction(mapTile, actionCompleteHandler);
		}
		
		protected function actionCompleteHandler(mapTile:MapTile):void
		{
			mapTile.clear();
			mapTile.setCharacter(this);
			RoundManager.nextRound();
		}
		
		protected function doMoveAction(mapTile:MapTile, callback:Function):void
		{
			moveThisToTile(mapTile, function():void
			{
				if (null != callback)
				{
					callback.apply(this, [mapTile]);
				}
			}
			);
			
		}
		
		protected function doAttackAction(mapTile:MapTile, callback:Function):void
		{
			moveThisToTile(mapTile, function():void
			{
				if (null != callback)
				{
					callback.apply(this, [mapTile]);
				}
			}
			);
		}
		
		public function flip():void
		{
			setIsDark(false);
			RoundManager.nextRound();
		}
		
		private function setIsDark(value:Boolean):void
		{
			_isDark = value;
			_spriteImg.bitmapData = _isDark ? BitmapUtil.getBitmapData("SPRITE_9") : BitmapUtil.getBitmapData("SPRITE_" + _type);
			_spriteName.visible = !_isDark;
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
			
			var mapTile:MapTile = MapTileUtil.getMapTile(_pos);
			if (mapTile)
			{
				const offsetY:int = GlobalParam.NUM_OFFSET_SPRITE_ON_MAPTILE_Y;
				this.x = mapTile.x + (mapTile.width - this.width) / 2;
				this.y = mapTile.y + (this.height == 85 ? offsetY : offsetY + 8);
			}
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