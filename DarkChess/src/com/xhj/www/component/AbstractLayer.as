package com.xhj.www.component
{
	import com.xhj.www.interfaces.IPopable;

	public class AbstractLayer extends GameObjectBase implements IPopable
	{
		public function AbstractLayer()
		{
			super();
		}
		
		public function getPopLayer():uint
		{
			return 0;
		}
	}
}