package com.xhj.www.component
{
	import com.xhj.www.interfaces.IDestroyable;
	import com.xhj.www.utils.DisplayObjectUtil;
	
	import flash.display.Sprite;
	
	public class GameObjectBase extends Sprite implements IDestroyable
	{
		public function GameObjectBase()
		{
			super();
			installComponent();
			installListener();
		}
		
		protected function installComponent():void
		{
			
		}
		
		protected function uninstallComponent():void
		{
			
		}
		
		protected function installListener():void
		{
			
		}
		
		protected function uninstallListener():void
		{
			
		}
		
		public function destroy():void
		{
			uninstallListener();
			uninstallComponent();
			DisplayObjectUtil.destroyChildren(this);
		}
	}
}