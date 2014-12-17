package com.xhj.www.utils
{
	import flash.utils.Dictionary;

	public class HashMap
	{
		private var length:int;
		private var content:Dictionary;
		
		public function HashMap()
		{
			length = 0;
			content = new Dictionary();
		}
		
		public function size():int
		{
			return length;
		}
		
		public function isEmpty():Boolean
		{
			return length == 0;
		}
		
		public function keys():Array
		{
			var ary:Array = new Array(length);
			for (var key:* in content)
			{
				ary.push(key);
			}
			return ary;
		}
		
		public function eachKey(func:Function):void
		{
			for (var key:* in content)
			{
				func(key);
			}
		}
		
		public function eachValue(func:Function):void
		{
			for each (var key:* in content)
			{
				func(key);
			}
		}
		
		public function values():Array
		{
			var ary:Array = new Array(length);
			for each (var value:* in content)
			{
				ary.push(value);
			}
			return ary;
		}
		
		public function containsValue(value:*):Boolean
		{
			for each (var v:* in content)
			{
				if (value == v)
				{
					return true;
				}
			}
			return false;
		}
		
		public function containsKey(key:*):Boolean
		{
			for (var k:* in content)
			{
				if (k == key)
				{
					return true;
				}
			}
			return false;
		}
		
		public function get(key:*):*
		{
			var value:* = content[key];
			if (undefined == value)
			{
				return null;
			}
			return value;
		}
		
		public function remove(key:*):*
		{
			if (!containsKey(key))
			{
				return null;
			}
			var value:* = content[key];
			delete content[key];
			length--;
			return value;
		}
		
		public function put(key:*, value:*):*
		{
			if (null == key)
			{
				return undefined;
			}
			if (!containsKey(key))
			{
				length++;
			}
			var result:* = get(key);
			content[key] = value;
			return result;
		}
		
		public function clear():void
		{
			length = 0;
			content = new Dictionary();
		}
		
		public function clone():HashMap
		{
			var map:HashMap = new HashMap();
			for (var key:* in content)
			{
				map.put(key, content[key]);
			}
			return map;
		}
	}
}