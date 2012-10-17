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
		protected var _lo:Boolean;// Loop
		
		public function MovieBox(frame:int = 0,x:Number=0, y:Number=0, width:Number=0, height:Number=0, rotation:Number=0) {
			super(x, y, width, height, rotation);
			_c = frame;
			_py = false;
			_ud = false;
			_lo = true;
		}
		
		/**
		 * Updates the current frame
		 * @param	loop when the animation reaches the last frame, repeat or not
		 */
		public override function update():Boolean {
			var u:Boolean = false;
			if (_py) {
				_c++;
				u = true;
				if (_c >= _f.length) {
					if (_lo) {
						_c = 0;
					}else {
						_c--;
						_py = false;
					}
				}
				shapeId = _f[_c];
			}else if(_ud){
				_ud = false;
				u = true;
				shapeId = _f[_c];
			}
			return u;
		}
		
		/**
		 * Goes to the frame and stops there
		 * @param	frame the frame to stop at
		 */
		public function gotoAndStop(frame:int):void {
			_py = false;
			_ud = true;
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
		
		public function get loop():Boolean {
			return _lo;
		}
		
		public function set loop(value:Boolean):void {
			_lo = value;
		}
		
	}

}