package com.xhj.www.layer.character
{
	import com.xhj.www.GlobalParam;
	import com.xhj.www.component.AbstractLayer;
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.LayerType;
	import com.xhj.www.consts.SpriteType;
	import com.xhj.www.layer.map.MapLayer;
	import com.xhj.www.layer.map.MapTile;
	import com.xhj.www.utils.HashMap;
	
	public class CharacterLayer extends AbstractLayer
	{
		public function CharacterLayer()
		{
			super();
		}
		
		public static function createCharacters():void
		{
			const length:int = GlobalParam.NUM_CHARACTER;
			const size:int = (GlobalParam.MAP_ROW - 1) * (GlobalParam.MAP_COLUMN - 1);
			var sprite:AbstractSprite;
			var randomPos:int;
			var mapTile:MapTile;
			for (var i:int = 0; i < length; ++i)
			{
				sprite = createCharacterByType(i % 8 + 1);
				sprite.setNation(i % 3 + 1);
				
				randomPos = int(Math.random() * size); 
				mapTile = MapLayer.getMapTile(randomPos);
				mapTile.setCharacter(sprite);
			}
		}
		
		public static function createCharacterByType(type:int):AbstractSprite
		{
			switch(type)
			{
				case SpriteType.FARMER:
					return new Farmer();
			}
		}
		
		override public function getPopLayer():uint
		{
			return LayerType.CHARACTER;
		}
	}
}