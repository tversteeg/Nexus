package nexus.utils {
	/**
	 * ...
	 * @author Thomas Versteeg
	 */
	public final class Random {
		
		private var _seed:Number;
		
		public function Random(seed:Number) {
			_seed = seed;
		}
		
		public function set seed(value:Number):void {
			_seed = value;
		}
		
		public function get nextNumber():Number {
			// Divided by 2147483647
			return generate() * 0.0000000004656613;
		}
		
		public function getNumberSeed(seed:Number):Number {
			_seed = seed;
			return generate() * 0.0000000004656613;
		}
		
		public function get nextSigned():Number {
			return generate() * 0.0000000009313226 - 1;
		}
		
		public function getSignedSeed(seed:Number):Number {
			_seed = seed;
			return generate() * 0.0000000009313226 - 1;
		}
		
		public function get nextInt():int {
			return generate();
		}
		
		public function generate():Number {
			return _seed = (_seed * 16807) % 2147483647;
		}
		
	}

}