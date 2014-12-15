package com.xhj.www.layer.map
{
	import com.xhj.www.component.GameObjectBase;
	
	public class AStarNode extends GameObjectBase
	{
		protected var _f:Number;
		protected var _g:Number;
		protected var _h:Number;
		protected var _posX:int;
		protected var _posY:int;
		
		protected var _parentNode:AStarNode;
		protected var _block:Boolean = false;
		
		public function AStarNode()
		{
			super();
		}

		public function get f():Number
		{
			return _f;
		}

		public function set f(value:Number):void
		{
			_f = value;
		}
		
		public function get g():Number
		{
			return _g;
		}
		
		public function set g(value:Number):void
		{
			_g = value;
		}
		
		public function get h():Number
		{
			return _h;
		}
		
		public function set h(value:Number):void
		{
			_h = value;
		}
		
		public function getPosX():int
		{
			return _posX;
		}
		
		public function getPosY():int
		{
			return _posY;
		}

		public function get parentNode():AStarNode
		{
			return _parentNode;
		}

		public function set parentNode(value:AStarNode):void
		{
			_parentNode = value;
		}
		

	}
}