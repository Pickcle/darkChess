package com.xhj.www.layer.map
{
	import com.xhj.www.App;
	import com.xhj.www.GlobalParam;
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.component.GameObjectBase;
	import com.xhj.www.utils.BitmapUtil;
	import com.xhj.www.utils.DisplayObjectUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class MapTile extends GameObjectBase
	{
		public static var TILE_WIDTH:int;
		public static var TILE_HEIGHT:int;
		
		protected var _tileImg:Bitmap;
		protected var _posX:int;
		protected var _posY:int;
		protected var _pos:int;
		protected var _hitShape:GameObjectBase;
		protected var _sprite:AbstractSprite;
		
		protected var _onClickFunction:Function;
		
		public function MapTile(posX:int, posY:int)
		{
			_posX = posX;
			_posY = posY;
			_pos = _posX * GlobalParam.MAP_ROW + _posY;
			super();
		}
		
		override protected function installComponent():void
		{
			_tileImg = BitmapUtil.getBitmap("TILE_EMPTY");
			this.addChild(_tileImg);
			
			TILE_WIDTH = _tileImg.width;
			TILE_HEIGHT = _tileImg.height;
			
			move();
			
			_hitShape = new GameObjectBase();
			_hitShape.graphics.beginFill(0x000000, 0);
			_hitShape.graphics.moveTo(0, TILE_HEIGHT / 2);
			_hitShape.graphics.lineTo(TILE_WIDTH / 2, 0);
			_hitShape.graphics.lineTo(TILE_WIDTH, TILE_HEIGHT / 2);
			_hitShape.graphics.lineTo(TILE_WIDTH / 2, TILE_HEIGHT);
			_hitShape.graphics.lineTo(0, TILE_HEIGHT / 2);
			_hitShape.graphics.endFill();
			this.addChild(_hitShape);
			_hitShape.addEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		public function setCharacter(sprite:AbstractSprite):void
		{
			_sprite = sprite;
			if (_sprite)
			{
				_sprite.setPos(_pos);
			}
		}
		
		public function getCharacter():AbstractSprite
		{
			return _sprite;
		}
		
		public function clear():void
		{
			if (_sprite)
			{
				_sprite.die();
			}
			_sprite = null;
		}
		
		public function reset():void
		{
			if (getIsDark())
			{
				turnBlack();
			}
			else
			{
				turnWhite();
			}
		}
		
		public function turnRed():void
		{
			BitmapUtil.disposeBitmap(_tileImg);
			_tileImg = BitmapUtil.getBitmap("TILE_RED");
		}
		
		public function turnGreen():void
		{
			BitmapUtil.disposeBitmap(_tileImg);
			_tileImg = BitmapUtil.getBitmap("TILE_GREEN");
		}
		
		public function turnWhite():void
		{
			BitmapUtil.disposeBitmap(_tileImg);
			_tileImg = BitmapUtil.getBitmap("TILE_EMPTY");
		}
		
		public function turnBlack():void
		{
			BitmapUtil.disposeBitmap(_tileImg);
			_tileImg = BitmapUtil.getBitmap("TILE_BLOCK");
		}
		
		protected function onClickHandler(e:MouseEvent):void
		{
			if (null != onClickFunction)
			{
				onClickFunction(e);
			}
		}
		
		protected function move():void
		{
			this.x = (_posX + _posY) * (TILE_WIDTH / 2);
			this.y = (_posY - _posX) * (TILE_HEIGHT / 2);
		}
		
		public function getEmpty():Boolean
		{
			return null == _sprite;
		}
		
		public function getPosX():int
		{
			return _posX;
		}
		
		public function getPosY():int
		{
			return _posY;
		}
		
		public function getPos():int
		{
			return _pos;
		}
		
		public function getIsDark():Boolean
		{
			return _sprite && _sprite.getIsDark();
		}
		
		public function getIsSameNation(nation:int):Boolean
		{
			return _sprite && (_sprite.getNation() == nation);
		}

		public function get onClickFunction():Function
		{
			return _onClickFunction;
		}

		public function set onClickFunction(value:Function):void
		{
			_onClickFunction = value;
		}

	}
}