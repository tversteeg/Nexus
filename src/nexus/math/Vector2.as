package nexus.math {
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Thomas Versteeg Et Al, 2012
	 */
	public class Vector2 {
		
		private var _x:Number;
		private var _y:Number;
		
		/**
		 * Create a 2 dimensional vector, which has many math functions, it's a bit slower then Flash his default Point
		 * @param	x the x length of the vector
		 * @param	y the y length of the vector
		 */
		public function Vector2(x:Number = 0, y:Number = 0) {
			_x = x;
			_y = y;
		}
		
		/**
		 * Transform the vector based on a transformation matrix
		 */
		public function transform(m:Matrix):Vector2 {
			var v:Vector2 = new Vector2(_x, _y);
			v.x = _x * m.a + _y * m.c + m.tx;
			v.y = _x * m.b + _y * m.d + m.ty;
			return v;
		}
		
		 /**
		 * Sets the angle while maintaining the length
		 */
		public function set angle(n:Number):void {
			var l:Number = magnitude;
			_x = Math.cos(n) * l;
			_y = Math.sin(n) * l;
		}
		
		/**
		 * Returns the angle of the vector
		 */
		public function get angle():Number {
			return Math.atan2(_y, _x);
		}
		
		/**
		 * Sets the length of the vector
		 */
		public function set magnitude(n:Number):void {
			var a:Number = angle;
			_x = Math.cos(a) * n;
			_y = Math.sin(a) * n;
			if(Math2.abs(_x) < 0.00000001) _x = 0;
			if (Math2.abs(_y) < 0.00000001) _y = 0;
		}
		
		/**
		 * Returns the length of the vector
		 */
		public function get magnitude():Number {
			return Math.sqrt(_x * _x + _y * _y);
		}
		
		/**
		 * Gives the vector a length of one
		 */
		public function normalize():Vector2 {
			var l:Number = magnitude;
			if (l == 0) {
				return this;
			}
			_x /= l;
			_y /= l;
			return this;
		}
		
		/**
		 * Returns the dot product of the vector
		 */
		public function dotProduct(v:Vector2):Number {
			return _x * v.x + _y * v.y;
		}
		
		/**
		 * Makes an exact copy of this vector
		 */
		public function copy():Vector2 {
			return new Vector2(_x, _y);
		}
		
		// Getters and setters
		public function get x():Number {
			return _x;
		}
		
		public function set x(n:Number):void {
			_x = n;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function set y(n:Number):void {
			_y = n;
		}
		
		public function get point():Point {
			return new Point(_x, _y);
		}
		
		public function set point(p:Point):void {
			_x = p.x;
			_y = p.y;
		}
		
		public function toString():String {
			return new String("X:" + _x + " Y:" + _y);
		}
		
	}

}