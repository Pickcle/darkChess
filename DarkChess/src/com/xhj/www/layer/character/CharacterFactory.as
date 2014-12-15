package com.xhj.www.layer.character
{
	import com.xhj.www.component.AbstractSprite;
	import com.xhj.www.consts.SpriteType;

	public class CharacterFactory
	{
		public function CharacterFactory()
		{
		}
		
		
		public static function createCharacterByType(type:int):AbstractSprite
		{
			var result:AbstractSprite;
			switch(type)
			{
				case SpriteType.FARMER:
					result = new Farmer();
					break;
				case SpriteType.SOLDIER:
					result = new Solider();
					break;
				case SpriteType.WISEMAN:
					result = new WiseMan();
					break;
				case SpriteType.KING:
					result = new King();
					break;
				case SpriteType.KNIGHT:
					result = new Knight();
					break;
				case SpriteType.HERO:
					result = new Hero();
					break;
				case SpriteType.CANNON:
					result = new Cannon();
					break;
				case SpriteType.ROOK:
					result = new Rook();
					break;
			}
			return result;
		}
	}
}

