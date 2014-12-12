package com.xhj.www
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.layer.map.MapTile;
	import com.xhj.www.utils.HashMap;
	
	import flash.display.DisplayObject;

	public class LayerManager
	{
		private static var _mapCharacter:HashMap;
		
		public function LayerManager()
		{
		}
		
		public static function removeCharacter(sprite:AbstractSprite):void
		{
			var spr:AbstractSprite;
			for each (var i:int in _mapCharacter.keys())
			{
				spr = _mapCharacter.get(i);
				if (spr == sprite)
				{
					_mapCharacter.remove(i);
					break;
				}
			}
			sprite.destroy();
		}
		
		public static function getCharacterArrayByNation(nation:int):Array
		{
			var ary:Array = [];
			for each (var sprite:AbstractSprite in _mapCharacter)
			{
				if (sprite.getNation() == nation)
				{
					ary.push(sprite);
				}
			}
			return ary;
		}
		
		public static function getCharacter(pos:int):AbstractSprite
		{
			return _mapCharacter.get(pos);
		}
		
		public static function set mapCharacter(value:HashMap):void
		{
			_mapCharacter = value;
		}

	}
}