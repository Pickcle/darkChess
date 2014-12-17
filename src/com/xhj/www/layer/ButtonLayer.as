package com.xhj.www.layer
{
	import com.xhj.www.RoundManager;
	import com.xhj.www.component.AbstractLayer;
	import com.xhj.www.component.GameObjectBase;
	import com.xhj.www.consts.LayerType;
	import com.xhj.www.consts.NationType;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ButtonLayer extends AbstractLayer
	{
		private var _nationFlag:TextField;
		
		public function ButtonLayer()
		{
			super();
		}
		
		override protected function installComponent():void
		{
			var tf:TextFormat = new TextFormat();
			tf.size = 20;
			tf.bold = true;
			tf.align = TextFieldAutoSize.CENTER;
			
			_nationFlag = new TextField();
			_nationFlag.width = 100;
			_nationFlag.height = 30;
			_nationFlag.defaultTextFormat = tf;
			this.addChild(_nationFlag);
		}
		
		public function startRound():void
		{
			switch (RoundManager.getCurrentRound())
			{
				case NationType.SHU:
					_nationFlag.text = "蜀国行动";
					_nationFlag.textColor = 0x00ff00;
					break;
				case NationType.WEI:
					_nationFlag.text = "魏国行动";
					_nationFlag.textColor = 0x0000ff;
					break;
				case NationType.WU:
					_nationFlag.text = "吴国行动";
					_nationFlag.textColor = 0xff0000;
					break;
			}
		}
		
		public function createButtons():void
		{
			
		}
		
		override public function getPopLayer():uint
		{
			return LayerType.BUTTON;
		}
	}
}