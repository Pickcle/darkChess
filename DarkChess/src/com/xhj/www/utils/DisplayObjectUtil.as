package com.xhj.www.utils
{
	import com.xhj.www.interfaces.IDestroyable;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;

	public class DisplayObjectUtil
	{
		public function DisplayObjectUtil()
		{
		}
		
		public static function destroyChildren(displayObject:DisplayObjectContainer):void
		{
			if (!displayObject)
			{
				return;
			}
			var object:DisplayObject;
			while (displayObject.numChildren > 0)
			{
				object = displayObject.getChildAt(0);
				if (object is IDestroyable)
				{
					(object as IDestroyable).destroy();
				}
				else if (object is Bitmap)
				{
					BitmapUtil.disposeBitmapData(object as Bitmap);
				}
				else if (object is TextField)
				{
					
				}
				
				removeFromParent(object);
			}
		}
		
		public static function removeFromParent(dis:DisplayObject):void
		{
			if (dis && dis.parent)
			{
				dis.parent.removeChild(dis);
			}
		}
		
		public static function centerDisplayObject(displayObject:DisplayObject, targetDisplayObject:DisplayObject):void
		{
			if (displayObject && targetDisplayObject)
			{
				displayObject.x = (targetDisplayObject.width - displayObject.width) / 2;
				displayObject.y = (targetDisplayObject.height - displayObject.height) / 2;
			}
		}
	}
}