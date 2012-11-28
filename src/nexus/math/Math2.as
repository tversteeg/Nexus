package nexus.math {
	import flash.display.InteractiveObject;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import nexus.utils.Random;
	/**
	 * ...
	 * @author Thomas Versteeg Et Al, 2012
	 */
	public final class Math2 {

		private static var FASTRANDOMTOFLOAT:Number = 1 / uint.MAX_VALUE;
		private static var FASTRANDOMSEED:uint = Math.random() * uint.MAX_VALUE;
		public static var seed:int = 602366;

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
		
		private static var mRawData:Vector.<Number> = new<Number>[1, 0, 0, 0,  0, 1, 0, 0,  0, 0, 1, 0,  0, 0, 0, 1];
		
		/**
		 * Converts a 2D Matrix to a Matrix3D, deprecated
		 * @param	m the source Matrix
		 * @param	m3D the Matrix that has to be converted
		 * @return	a converted Matrix3D
		 */
		public static function matrixToMatrix3D(m:Matrix, m3D:Matrix3D=null):Matrix3D {
			if (m3D == null) m3D = new Matrix3D();
            
            mRawData[0] = m.a;
            mRawData[1] = m.b;
            mRawData[4] = m.c;
            mRawData[5] = m.d;
            mRawData[12] = m.tx;
            mRawData[13] = m.ty;
            
            m3D.copyRawDataFrom(mRawData);
            return m3D;
		}
		
		public static function intNoise(x:int, y:int, random:Random):Number {
			//trace(random.getSignedSeed(x + y * 57));
			random.seed = ((x * (y ^ x) * 26.216) * y + (y & x) + x) * 0.0001243 ;
			random.generate();
			random.generate();
			random.generate();
			return random.nextSigned
		}
		
		public static function smoothNoise(x:int, y:int, r:Random):Number {
			var corners:Number = (intNoise(x - 1, y - 1, r) + intNoise(x + 1, y - 1, r) + intNoise(x - 1, y + 1, r) + intNoise(x + 1, y + 1, r)) * 0.0625;
			var sides:Number = (intNoise(x - 1, y, r) + intNoise(x + 1, y, r) + intNoise(x, y + 1, r) + intNoise(x, y - 1, r)) * 0.125;
			var center:Number = intNoise(x, y, r) * 0.25;
			return corners + sides + center;
		}
		
		public static function interpolateCosine(a:Number, b:Number, x:Number):Number {
			var ft:Number = x * 3.1415927;
			var f:Number = (1 - Math.cos(ft)) * 0.5;
			return a * (1 - f) + b * f;
			//return a * (1 - x) + b * x;
		}
		
		public static function interpolateNoise(x:Number, y:Number,random:Random):Number {
			var intX:int = x | 0;
			var intY:int = y | 0;
			var fracX:Number = x - intX
			var fracY:Number = y - intY
			
			var v1:Number = smoothNoise(intX, intY, random);
			var v2:Number = smoothNoise(intX + 1, intY, random);
			var v3:Number = smoothNoise(intX, intY + 1, random);
			var v4:Number = smoothNoise(intX + 1, intY + 1, random);
			
			var i1:Number = interpolateCosine(v1, v2, fracX);
			var i2:Number = interpolateCosine(v3, v4, fracX);
			return interpolateCosine(i1, i2, fracY)
		}
		
		public static function perlinNoise(x:Number, y:Number, randomSeed:Number = 0, octave:int = 10, persistance:Number = 1, zoom:Number = 1):Number {
			var amp:Number = 1, freq:Number = 1, invZoom:Number = 1 / zoom, total:Number = 0
			var n:int = octave-1;
			var i:int
			var r:Random = new Random(0);
			for (i = 0; i < n; i++) {
				freq = Math.pow(2, i);
				amp = Math.pow(persistance, i);
				
				total += interpolateNoise(x * freq * invZoom + randomSeed, y * freq * invZoom + randomSeed, r) * amp;
			}
			return total;
		}
		
		/**
		 * Returns the nearest power of 2, example 266 becomes 512
		 * @param	n the input
		 * @return a integer that is the power of 2
		 */
		public static function nearesPowerTwo(n:int):int {
			var v:int = n;
			v--;
			v |= v >> 1;
			v |= v >> 2;
			v |= v >> 4;
			v |= v >> 8;
			v |= v >> 16;
			v++;
			return v;
		}
		
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
		 * Clamps the numbers, between max and min
		 * @param	n the first number that must be compared
		 * @param	max the largets possible number
		 * @param	min the smallest possible number
		 * @return returns the number between max and min
		 * @example clamp(1.5, 1, 0) = 1, clamp(-1.5, 1, 0) = 0, clamp(0.5, 1, 0) = 0.5
		 */
		public static function clamp(n:Number, max:Number, min:Number):Number {
			return (n < max) ? ((n > min) ? n : min) : max;
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