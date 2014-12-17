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
	import com.xhj.www.utils.MapTileUtil;
	
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
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function createCharacters():void
		{
			const arySpriteNum:Array = GlobalParam.SPRITE_NUM;
			const size:int = GlobalParam.MAP_ROW * GlobalParam.MAP_COLUMN;
			var map:HashMap = new HashMap();
			var posAry:Array = [];
			var arySprite:Array = [];
			var i:int;
			var j:int;
			for (i = 0; i < arySpriteNum.length; ++i)
			{
				var spriteCount:int = arySpriteNum[i];
				while (spriteCount > 0)
				{
					arySprite.push(i + 1);
					--spriteCount;
				}
			}
			for (i = 0; i < size; ++i)
			{
				posAry.push(i);
			}
			for (i = 1; i <= GlobalParam.NUM_NATION; ++i)
			{
				var randomIndex:int;
				var randomPos:int;
				var mapTile:MapTile;
				var sprite:AbstractSprite;
				const len:int = arySprite.length;
				for (j = 0; j < len; ++j)
				{
					//创建sprite
					sprite = CharacterFactory.createCharacterByType(arySprite[j]);
					sprite.setNation(i);
					
					//将sprite随机位置
					randomIndex = int(Math.random() * posAry.length); 
					randomPos = posAry[randomIndex];
					posAry.splice(randomIndex, 1);
					
					//将sprite绑定到tile
					mapTile = MapTileUtil.getMapTile(randomPos);
					mapTile.setCharacter(sprite);
					
					//将sprite添加到layer上
					_layer.addChild(sprite);
					
					//记录sprite
					map.put(randomPos, sprite);
				}
			}
			LayerManager.mapCharacter = map;
		}
		
		override public function getPopLayer():uint
		{
			return LayerType.CHARACTER;
		}
	}
}