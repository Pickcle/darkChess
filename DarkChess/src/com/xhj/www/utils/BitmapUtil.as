package com.xhj.www.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class BitmapUtil
	{
		public function BitmapUtil()
		{
		}
		
		public static function disposeBitmap(bitmap:Bitmap):void
		{
			if (bitmap && bitmap.bitmapData)
			{
				bitmap.bitmapData.dispose();
				bitmap.bitmapData = null;
			}
		}
		
		public static function getBitmap(resName:String):Bitmap
		{
			var resClass:Class = getDefinitionByName(resName) as Class;
			var bmd:BitmapData = BitmapData(new resClass());
			return new Bitmap(bmd);
		}
			
	}
}