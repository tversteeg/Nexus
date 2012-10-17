package com.shapes {
	import com.interfaces.IMapAble;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public dynamic class MovieBox extends Box implements IMapAble {
		protected var _c:int;//Current frame
		protected var _f:Vector.<int>;//List holding the frames
		protected var _py:Boolean;// Playing condition
		protected var _ud:Boolean;// Updated
		
		public function MovieBox(frame:int = 1,x:Number=0, y:Number=0, width:Number=0, height:Number=0, rotation:Number=0) {
			super(x, y, width, height, rotation);
			_c = frame;
			_py = false;
			_ud = true;
		}
		
		/**
		 * Updates the current frame
		 * @param	loop when the animation reaches the last frame, repeat or not
		 */
		public override function update(loop:Boolean = false):Boolean {
			_ud = false;
			if (_py) {
				_c++;
				_ud = true;
				if (_c > _f.length) {
					if (loop) {
						_c = 0;
					}else {
						_py = false;
					}
				}
			}
			return _ud;
		}
		
		/**
		 * Goes to the frame and stops there
		 * @param	frame the frame to stop at
		 */
		public function gotoAndStop(frame:int):void {
			_py = false;
			_c = frame;
		}
		
		/**
		 * Goes to the frame and plays from that point
		 * @param	frame the frame to play from
		 */
		public function gotoAndPlay(frame:int):void {
			_py = true;
			_c = frame;
		}
		
		/**
		 * Stops at the current point
		 */
		public function stop():void {
			_py = false;
		}
		
		/**
		 * Plays from the current point
		 */
		public function play():void {
			_py = true;
		}
		
		public function get currentFrame():int {
			return _c; 
		}
		public function set currentFrame(v:int):void {
			_c = v;
		}
		
		public function get frameList():Vector.<int> {
			return _f;
		}
		public function set frameList(value:Vector.<int>):void {
			_f = value;
		}
		
		public function get updated():Boolean {
			return _ud;
		}
		
	}

}