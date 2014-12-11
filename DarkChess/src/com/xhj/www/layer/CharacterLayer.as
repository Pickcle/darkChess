package com.xhj.www.layer
{
	import com.xhj.www.GlobalParam;
	import com.xhj.www.LayerManager;
	import com.xhj.www.component.AbstractLayer;
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.component.GameObjectBase;
	import com.xhj.www.consts.LayerType;
	import com.xhj.www.layer.character.CharacterFactory;
	import com.xhj.www.layer.map.MapTile;
	import com.xhj.www.utils.HashMap;
	
	public class CharacterLayer extends AbstractLayer
	{
		private var _layer:GameObjectBase;
		
		public function CharacterLayer()
		{
			super();
		}
		
		override protected function installComponent():void
		{
			_layer = new GameObjectBase();
			this.addChild(_layer);
		}
		
		public function createCharacters():void
		{
			const length:int = GlobalParam.NUM_CHARACTER;
			const size:int = GlobalParam.MAP_ROW * GlobalParam.MAP_COLUMN;
			var sprite:AbstractSprite;
			var randomIndex:int;
			var randomPos:int;
			var mapTile:MapTile;
			var map:HashMap = new HashMap();
			var posAry:Array = [];
			var i:int;
			for (i = 0; i < size; ++i)
			{
				posAry.push(i);
			}
			for (i = 0; i < length; ++i)
			{
				//创建sprite
				sprite = CharacterFactory.createCharacterByType(i % 8 + 1);
				sprite.setNation(i % 3 + 1);
				
				//将sprite随机位置
				randomIndex = int(Math.random() * posAry.length); 
				randomPos = posAry[randomIndex];
				posAry.splice(randomIndex, 1);
				
				//将sprite绑定到tile
				mapTile = LayerManager.getMapTile(randomPos);
				mapTile.setCharacter(sprite);
				
				//将sprite添加到layer上
				_layer.addChild(sprite);
				sprite.x = mapTile.x + (mapTile.width - sprite.width) / 2;
				sprite.y = mapTile.y + (sprite.height == 85 ? -25 : -17);
				
				//记录sprite
				map.put(i, sprite);
			}
			LayerManager.mapCharacter = map;
		}
		
		override public function getPopLayer():uint
		{
			return LayerType.CHARACTER;
		}
	}
}