package com.xhj.www.utils
{
	import com.xhj.www.layer.map.MapTile;

	/**
	 * A*寻路
	 * @author xiaohj
	 * 
	 */	
	public class AStar
	{
		public function AStar()
		{
		}
		
		public static function find(startTile:MapTile, endTile:MapTile):Array
		{
			var ary:Array = MapTileUtil.getAllTiles();
			var open:Array = [];
			var close:Array = [];
			var rtn:Array = [];
			var i:int;
			var j:int;
			for each (var t:MapTile in ary)
			{
				t.f = t.g = t.h = 0;
				t.parentNode = null;
			}
			
			open.push(startTile);
			
			while(open.length > 0)
			{
				var tile:MapTile = open.shift();//从open中移除
				if (tile == endTile)//到达终点
				{
					return getPath(tile);
				}
				close.push(tile);//放入close
				for (j = 0; j < 4; ++j)//获取相邻格子
				{
					var dltX:int = Math.sin(j * Math.PI / 2);
					var dltY:int = Math.cos(j * Math.PI / 2);
					var nearTile:MapTile = MapTileUtil.getMapTileByXY(tile.getPosX() + dltX, tile.getPosY() + dltY);
					//相邻格子存在且不是障碍且不在close中
					if ((nearTile && !nearTile.getIsBlock() && close.indexOf(nearTile) == -1) || nearTile == endTile)
					{
						if (open.indexOf(nearTile) == -1)
						{
 							nearTile.parentNode = tile;
							nearTile.g = tile.g + 1;
							//使用曼哈顿估算方法
							nearTile.h = manhattan(nearTile, endTile);
							nearTile.f = nearTile.g + nearTile.h;
							open.push(nearTile);
						}
						else//如果open中已存在
						{
							if (tile.g + 1 < nearTile.g)//使用较小g值的格子替换原先格子
							{
								nearTile.parentNode = tile;
								nearTile.g = tile.g + 1;
								nearTile.f = nearTile.g + nearTile.h;
								open.sort(sortByF);
							}
						}
					}
					else
					{
						continue;
					}
				}
				open.sort(sortByF);
			}
			return [];
		}
		
		public static function sortByF(tileA:MapTile, tileB:MapTile):int
		{
			return tileA.f - tileB.f;
		}
		
		public static function getPath(tile:MapTile):Array
		{
			var ary:Array = [tile];
			while (tile.parentNode)
			{
				ary.push(tile.parentNode);
				tile = tile.parentNode as MapTile;
			}
			return ary;
		}
		
		/**
		 * 曼哈顿启发函数
		 
		 */
		public static function manhattan(startTile:MapTile, endTile:MapTile):Number
		{
			return Math.abs(endTile.getPosX() - startTile.getPosX()) + Math.abs(endTile.getPosY() - startTile.getPosY());
		}
		
	}
}