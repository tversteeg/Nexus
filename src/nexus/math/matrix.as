package nexus.math 
{
	import flash.geom.Point;
	public class matrix {
		
		public var rows:uint;
		public var columns:uint;
		public var elements:uint;
		
		private var m:Vector.<Number>
		
		public function matrix(rows:uint, ... args):void {
			this.elements = args.length;
			this.rows = rows;
			this.columns = elements / rows;
			
			m = new Vector.<Number>(elements, true);
			
			var i:uint, j:Number
			for (i = 0; i < elements; i ++) {
				j = args[i];
				m[i] = j
			}
		}
		
		public function update():void {
			elements = m.length;
			columns = elements / rows;
		}
		
		public function setElement(x:uint, y:uint, v:Number):void{
			m[x + y * columns] = v;
		}
		
		public function getElement(x:uint, y:uint):Number {
			return m[x + y * columns];
		}
		
		public function equalTo(m2:matrix):Boolean {
			if (rows != m2.rows || columns != m2.columns) {
				return false;
			}
			var i:uint;
			for (i = 0; i < elements; i ++) {
				if (m[i] != m2.m[i]) {
					return false;
				}
			}
			
			return true;
		}
		
		public function transpose():void {
			var n:uint = 0;
			if (rows == columns) {
				n = Math.sqrt(elements);
			}else {
				var t:uint = rows;
				rows = columns;
				columns = t;
			}
			var i:uint;
			var j:uint;
			var temp:Number
			for (i = 0; i < n; ++i) {
				for (j = i + 1; j < n; ++j) {
					temp = m[n * i + j];
					m[n * i + j] = m[n * j + i];
					m[n * j + i] = temp;
				}
			}
		}
		
		public function add(m2:matrix):matrix{
			var tm:Vector.<Number> = new Vector.<Number>(elements, true);
			var m3:matrix = new matrix(rows);
			
			var i:uint;
			for (i = 0; i < elements; i ++) {
				tm[i] = m[i] + m2.m[i];
			}
			m3.m = tm;
			m3.update();
			
			return m3;
		}
		
		public function subtract(m2:matrix):matrix{
			var tm:Vector.<Number> = new Vector.<Number>(elements, true);
			var m3:matrix = new matrix(rows);
			
			var i:uint;
			for (i = 0; i < elements; i ++) {
				tm[i] = m[i] - m2.m[i];
			}
			m3.m = tm;
			m3.update();
			
			return m3;
		}
		
		public function multiplyBy(n:Number):void {
			var i:uint;
			for (i = 0; i < elements; i ++) {
				m[i] *= n;
			}
		}
		
		public function multiplyWith(m2:matrix):matrix {
			var tm:Vector.<Number> = new Vector.<Number>();
			var m3:matrix = new matrix(rows);
			
			var x:uint, y:uint, cur:Number, n:uint, i:uint = 0;
			for (x = 0; x < m2.columns; x++) {
				for (y = 0; y < rows; y ++) {
					cur = 0;
					for (n = 0; n < columns; n++ ) {
						cur += m2.getElement(x, n) * getElement(n, y);
					}
					tm[i] = cur;
					i++;
				}
			}
			m3.m = tm;
			m3.update();
			
			return m3;
		}
		
		public function identity():void {
			if (rows == columns) {
				var x:uint, y:uint;
				for (y = 0; y < rows; y++) {
					for (x = 0; x < columns; x++) {
						if (x == y) {
							setElement(x, y, 1);
						}else {
							setElement(x, y, 0);
						}
					}
				}
			}
		}
		
		public function get determinant():Number{
			if (elements == 1) {
				return m[0];
			}else if (elements == 4 && rows == columns) {
				return m[0] * m[3] - m[1] * m[2];
			}else if (elements == 9 && rows == columns) {
				return m[0] * (m[4] * m[8] - m[5] * m[7]) + m[1] * (m[5] * m[6] - m[3] * m[8]) + m[2] * (m[3] * m[7] - m[4] * m[6]);
			}else {
				return 0;
			}
		}
		
		public function orient(a:Point, b:Point, c:Point):matrix{
			return new matrix(2, a.x - c.x, a.y - c.y, b.x - c.x, b.y - c.y);
		}
		
		public function toString():String {
			return m.toString();
		}
		
	}

}