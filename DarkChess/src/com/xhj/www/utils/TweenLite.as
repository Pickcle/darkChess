package com.xhj.www.utils
{
	import com.xhj.www.component.GameObjectBase;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.media.SoundTransform;
	import flash.utils.*;

	public class TweenLite
	{
		public static var version:Number = 5.1;
		public static var killDelayedCallsTo:Function = killTweensOf;
		private static var _sprite:GameObjectBase = new GameObjectBase(); //A reference to the sprite that we use to drive all our ENTER_FRAME events.
		private static var _listening:Boolean; //If true, the ENTER_FRAME is being listened for (there are tweens that are in the queue)
		private static var _all:Dictionary = new Dictionary(); //Holds references to all our tween targets.
		private static var _timer:Timer = new Timer(2000);
		private var _sound:SoundTransform; //We only use this in cases where the user wants to change the volume of a MovieClip (they pass in a "volume" property in the v)
		private var _endTarget:Object; //End target. It's almost always the same as this.target except for volume and color tweens. It helps us to see what object or MovieClip the tween really pertains to (so that we can killTweensOf() properly and hijack auto-overwritten ones)
		private var _active:Boolean; //If true, this tween is active.
		private var _color:ColorTransform;
		private var _endColor:ColorTransform;
		public var duration:Number; //Duration (in seconds)
		public var vars:Object; //Variables (holds things like _alpha or _y or whatever we're tweening)
		public var delay:Number; //Delay (in seconds)
		public var onComplete:Function; //The function that should be triggered when this tween has completed
		public var onCompleteParams:Array; //An array containing the parameters that should be passed to the this.onComplete when this tween has finished.
		public var onStart:Function; //The function that should be triggered when the tween starts (useful when there's a delay)
		public var onStartParams:Array; //An array containing the parameters that should be passed to the this.onStart
		public var startTime:uint; //Start time
		public var initTime:uint; //Time of initialization. Remember, we can build in delays so this property tells us when the frame action was born, not when it actually started doing anything.
		public var tweens:Object; //Contains parsed data for each property that's being tweened (each has to have a target, property, start, a change, and an ease).
		public var extraTweens:Object; //If we run into a property that's supposed to be tweening but the target has no such property, those tweens get dumped in here.
		public var target:Object; //Target object (often a MovieClip)

		public function TweenLite($target:Object, $duration:Number, $vars:Object, $delay:Number = 0, $onComplete:Function = null, $onCompleteParams:Array = null, $overwrite:Boolean = true)
		{
			if ($target == null)
			{
				return
			}
			;
			if (($vars.overwrite != false && $overwrite != false && $target != null) || _all[$target] == undefined)
			{
				delete _all[$target];
				_all[$target] = new Dictionary();
			}
			_all[$target][this] = this;
			this.vars = $vars;
			this.duration = $duration;
			this.delay = $vars.delay || $delay || 0;
			if ($duration == 0)
			{
				this.duration = 0.001; //Easing equations don't work when the duration is zero.
				if (this.delay == 0)
				{
					this.vars.runBackwards = true; //The simplest (most lightweight) way to force an immediate render of the target values
				}
			}
			this.target = _endTarget = $target;
			this.onComplete = $vars.onComplete || $onComplete;
			this.onCompleteParams = $vars.onCompleteParams || $onCompleteParams || [];
			this.onStart = $vars.onStart;
			this.onStartParams = $vars.onStartParams || [];
			if (this.vars.ease == undefined)
			{
				this.vars.ease = linear;
			}
			else if (!(this.vars.ease is Function))
			{
				trace("ERROR: You cannot use '" + this.vars.ease + "' for the TweenLite ease property. Only functions are accepted.");
			}
			if (!isNaN(Number(this.vars.autoAlpha)))
			{
				this.vars.alpha = Number(this.vars.autoAlpha);
			}
			else if (!isNaN(Number(this.vars._autoAlpha)))
			{
				this.vars.alpha = this.vars.autoAlpha = Number(this.vars._autoAlpha);
			}
			this.tweens = {};
			this.extraTweens = {};
			this.initTime = getTimer();
			if (this.vars.runBackwards == true)
			{
				initTweenVals();
			}
			_active = false;
			var a:Boolean = this.active; //Just to trigger the onStart() if necessary.
			if ($duration == 0 && this.delay == 0)
			{
				if (this.vars.autoAlpha == 0)
				{
					this.target.visible = false;
				}
				if (this.onComplete != null)
				{
					this.onComplete.apply(null, this.onCompleteParams);
				}
				removeTween(this);
			}
			else if (!_listening)
			{
				_sprite.addEventListener(Event.ENTER_FRAME, executeAll);
				_timer.addEventListener("timer", killGarbage);
				_timer.start();
				_listening = true;
			}
		}

		public function initTweenVals():void
		{
			var ndl:Number = this.delay - ((getTimer() - this.initTime) / 1000); //new delay. We need this because reversed (TweenLite.from() calls) need to maintain the delay in any sub-tweens (like for color or volume tweens) but normal TweenLite.to() tweens should have no delay because this function gets called only when the begin!
			var p:String, valChange:Number; //For looping (for p in this.vars)
			if (this.target is Array)
			{
				var endArray:Array = [];
				for (p in this.vars)
				{ //First find an instance of an array in the this.vars to match up with. There should never be more than one.
					if (this.vars[p] is Array)
					{
						endArray = this.vars[p];
						break;
					}
				}
				for (var i:int = 0; i < endArray.length; i++)
				{
					if (this.target[i] != endArray[i] && this.target[i] != undefined)
					{
						this.tweens[i.toString()] = {o: this.target, s: this.target[i], c: endArray[i] - this.target[i], e: this.vars.ease}; //o: object, s:starting value, c:change in value, e: easing function
					}
				}
			}
			else
			{
				for (p in this.vars)
				{
					if (p == "volume" && this.target is MovieClip)
					{ //If we're trying to change the volume of a MovieClip, then set up a quasai proxy using an instance of a TweenLite to control the volume.
						_sound = this.target.soundTransform;
						var volTween:TweenLite = new TweenLite(this, this.duration, {volumeProxy: this.vars[p], ease: linear, delay: ndl, overwrite: false, runBackwards: this.vars.runBackwards});
						volTween.endTarget = this.target;
					}
					else if (p.toLowerCase() == "mccolor" && this.target is DisplayObject)
					{ //If we're trying to change the color of a DisplayObject, then set up a quasai proxy using an instance of a TweenLite to control the color.
						_color = this.target.transform.colorTransform;
						_endColor = new ColorTransform();
						_endColor.alphaMultiplier = this.vars.alpha || this.target.alpha; //Otherwise it'll force it to an alpha of 1 since the colorTransform affects the alpha too.
						if (this.vars[p] != null && this.vars[p] != "")
						{ //In case they're actually trying to remove the colorization, they should pass in null or "" for the mcColor
							_endColor.color = this.vars[p];
						}
						var colorTween:TweenLite = new TweenLite(this, this.duration, {colorProxy: 1, delay: ndl, overwrite: false, runBackwards: this.vars.runBackwards});
						colorTween.endTarget = this.target;
					}
					else if (p == "delay" || p == "ease" || p == "overwrite" || p == "onComplete" || p == "onCompleteParams" || p == "runBackwards" || p == "autoAlpha" || p == "_autoAlpha" || p == "onStart" || p == "onStartParams")
					{
					}
					else
					{
						if (this.target.hasOwnProperty(p))
						{
							if (typeof(this.vars[p]) == "number")
							{
								valChange = this.vars[p] - this.target[p];
							}
							else
							{
								valChange = Number(this.vars[p]);
							}
							this.tweens[p] = {o: this.target, s: this.target[p], c: valChange, e: this.vars.ease}; //o: object, p:property, s:starting value, c:change in value, e: easing function
						}
						else
						{
							this.extraTweens[p] = {o: this.target, s: 0, c: 0, e: this.vars.ease, v: this.vars[p]}; //classes that extend this one (like TweenFilterLite) may need it (like for blurX, blurY, and other filter properties)
						}
					}
				}
			}
			if (this.vars.runBackwards == true)
			{
				var tp:Object;
				for (p in this.tweens)
				{
					tp = this.tweens[p];
					tp.s += tp.c;
					tp.c *= -1;
					if (tp.c != 0)
					{ //If there's no change, there's no need to apply it.
						tp.o[p] = tp.e(0, tp.s, tp.c, this.duration);
					}
				}
			}
			if (typeof(this.vars.autoAlpha) == "number")
			{
				this.target.visible = !(this.vars.runBackwards == true && this.target.alpha == 0);
			}
		}

		public static function to($target:Object, $duration:Number, $vars:Object, $delay:Number = 0, $onComplete:Function = null, $onCompleteParams:Array = null, $overwrite:Boolean = true):TweenLite
		{
			return new TweenLite($target, $duration, $vars, $delay, $onComplete, $onCompleteParams, $overwrite);
		}

		//This function really helps if there are objects (usually MovieClips) that we just want to animate into place (they are already at their end position on the stage for example). 
		public static function from($target:Object, $duration:Number, $vars:Object, $delay:Number = 0, $onComplete:Function = null, $onCompleteParams:Array = null, $overwrite:Boolean = true):TweenLite
		{
			$vars.runBackwards = true;
			return new TweenLite($target, $duration, $vars, $delay, $onComplete, $onCompleteParams, $overwrite);
			;
		}

		public static function delayedCall($delay:Number, $onComplete:Function, $onCompleteParams:Array = null):TweenLite
		{
			return new TweenLite($onComplete, 0, {delay: $delay, onComplete: $onComplete, onCompleteParams: $onCompleteParams, overwrite: false}); //NOTE / TO-DO: There may be a bug in the Dictionary class that causes it not to handle references to objects correctly! (I haven't verified this yet)
		}

		public static function removeTween($t:TweenLite = null):void
		{
			if ($t != null && _all[$t.endTarget] != null)
			{
				delete _all[$t.endTarget][$t];
			}
		}

		public static function killTweensOf($tg:Object = null):void
		{
			if ($tg != null)
			{
				delete _all[$tg];
			}
		}

		public function render():void
		{
			var time:Number = (getTimer() - this.startTime) / 1000;
			if (time > this.duration)
			{
				time = this.duration;
			}
			var tp:Object;
			for (var p:String in this.tweens)
			{
				tp = this.tweens[p];
				tp.o[p] = tp.e(time, tp.s, tp.c, this.duration);
					//trace(tp.o+"."+p+" = "+tp.o[p]);
			}
			if (time == this.duration)
			{ //Check to see if we're done
				if (typeof(this.vars.autoAlpha) == "number" && this.target.alpha == 0)
				{
					this.target.visible = false;
				}
				try
				{
					if (this.onComplete != null)
					{
						this.onComplete.apply(null, this.onCompleteParams);
					}
				}catch(e:Error)
				{
					trace(e.message);
				}finally
				{
					removeTween(this);
				}
			}
		}

		public static function executeAll($e:Event):void
		{
			var a:Object = _all;
			var p:Object, twp:Object, tw:Object;
			for (p in a)
			{
				for (twp in a[p])
				{
					tw = a[p][twp];
					if (tw.active)
					{
						try
						{
							tw.render();
						}
						catch(e:Object)
						{
							trace("err on executeAll");
						}
					}
				}
			}
		}

		public static function killGarbage($e:TimerEvent):void
		{
			var a:Object = _all;
			var tg_cnt:int = 0;
			var found:Boolean;
			var p:Object, twp:Object, tw:Object;
			for (p in a)
			{
				found = false;
				for (twp in a[p])
				{
					found = true;
					break;
				}
				if (!found)
				{
					delete a[p];
				}
				else
				{
					tg_cnt++;
				}
			}
			if (tg_cnt == 0)
			{
				_sprite.removeEventListener(Event.ENTER_FRAME, executeAll);
				_timer.removeEventListener("timer", killGarbage);
				_timer.stop();
				_listening = false;
			}
		}

		//Default ease function for tweens other than alpha (Regular.easeOut)
		private static function easeOut($t:Number, $b:Number, $c:Number, $d:Number):Number
		{
			return -$c * ($t /= $d) * ($t - 2) + $b;
		}
		
		private static function linear($t:Number, $b:Number, $c:Number, $d:Number):Number
		{
			return $c * ($t /= $d) + $b;
		}

		//---- GETTERS / SETTERS -----------------------------------------------------------------------
		public function get active():Boolean
		{
			if (_active)
			{
				return true;
			}
			else if ((getTimer() - this.initTime) / 1000 > this.delay)
			{
				_active = true;
				this.startTime = this.initTime + (this.delay * 1000);
				if (this.vars.runBackwards != true)
				{
					initTweenVals();
				}
				else if (typeof(this.vars.autoAlpha) == "number")
				{
					this.target.visible = true;
				}
				if (this.onStart != null)
				{
					this.onStart.apply(null, this.onStartParams);
				}
				if (this.duration == 0.001)
				{ //In the constructor, if the duration is zero, we shift it to 0.001 because the easing functions won't work otherwise. We need to offset the this.startTime to compensate too.
					this.startTime -= 1;
				}
				return true;
			}
			else
			{
				return false;
			}
		}

		public function set endTarget($t:Object):void
		{
			delete _all[_endTarget][this];
			_endTarget = $t;
			if (_all[$t] == undefined)
			{
				_all[$t] = new Dictionary();
			}
			_all[$t][this] = this;
		}

		public function get endTarget():Object
		{
			return _endTarget;
		}

		public function set volumeProxy($n:Number):void
		{ //Used as a proxy of sorts to control the volume of the target MovieClip.
			_sound.volume = $n;
			this.target.soundTransform = _sound;
		}

		public function get volumeProxy():Number
		{
			return _sound.volume;
		}

		public function set colorProxy($n:Number):void
		{
			var r:Number = 1 - $n;
			this.target.transform.colorTransform = new ColorTransform(_color.redMultiplier * r + _endColor.redMultiplier * $n, _color.greenMultiplier * r + _endColor.greenMultiplier * $n, _color.blueMultiplier * r + _endColor.blueMultiplier * $n, _color.alphaMultiplier * r + _endColor.alphaMultiplier * $n, _color.redOffset * r + _endColor.redOffset * $n, _color.greenOffset * r + _endColor.greenOffset * $n, _color.blueOffset * r + _endColor.blueOffset * $n, _color.alphaOffset * r + _endColor.alphaOffset * $n);
		}

		public function get colorProxy():Number
		{
			return 0;
		}
	/* If you want to be able to set or get the progress of a Tween, uncomment these getters/setters. 0 = beginning, 0.5 = halfway through, and 1 = complete
	public function get progress():Number {
		return ((getTimer() - this.startTime) / 1000) / this.duration || 0;
	}
	public function set progress($n:Number):void {
		var t = getTimer() - ((this.duration * $n) * 1000);
		this.initTime = t - (this.delay * 1000);
		var s = this.active; //Just to trigger all the onStart stuff.
		this.startTime = t;
		render();
	}
	*/
	}
}
