package com.math {
	/**
	 * ...
	 * @author Thomas Versteeg Et Al, 2012
	 */
	public final class Math2 {

		private static var FASTRANDOMTOFLOAT:Number = 1 / uint.MAX_VALUE;
		private static var FASTRANDOMSEED:uint = Math.random() * uint.MAX_VALUE;

		/**
		 * A faster way then Math.random()
		 * @param	amount the random is multiplied with
		 * @return	returns a number between 0 and amount
		 */
		public static function random(amount:Number = 1):Number {
			FASTRANDOMSEED ^=  (FASTRANDOMSEED << 21);
			FASTRANDOMSEED ^=  (FASTRANDOMSEED >>> 35);
			FASTRANDOMSEED ^=  (FASTRANDOMSEED << 4);

			return (FASTRANDOMSEED * FASTRANDOMTOFLOAT * amount);
		}
		
		public static var RADTODEGREE:Number = 180 / Math.PI;
		public static var DEGREETORAD:Number = Math.PI / 180;
		public static var HALFPI:Number = Math.PI * 0.5;
		
		/**
		 * A faster way then Math.abs()
		 * @param	n the number thats going to be positive
		 * @return	returns a positive number
		 */
		public static function abs(n:Number):Number {
			if (n < 0) {
				return n * -1;
			} else {
				return n;
			}
		}
		
		/**
		 * A faster way then Math.min()
		 * @param	n the first number that must be compared
		 * @param	m the second number that must be compared
		 * @return	returns the smallest number of the two
		 */
		public static function min(n:Number, m:Number):Number {
			return (n < m) ? n : m;
		}
		
		/**
		 * A faster way then Math.max()
		 * @param	n the first number that must be compared
		 * @param	m the second number that must be compared
		 * @return	returns the largest number of the two
		 */
		public static function max(n:Number, m:Number):Number {
			return (n > m) ? n : m;
		}
		
		/**
		 * A faster way to find the distance then using Pythagoras, although it is a bit less accurate
		 * @param	x delta-x, the difference between the x position of two points
		 * @param	y delta-y, the difference between the y position of two points
		 * @return  returns the distance as absolute number
		 */
		public static function dis(x:Number, y:Number):Number {
			if (x*y<0) {
				return abs(x - y);
			} else {
				return abs(x + y);
			}
		}
		
	}

}