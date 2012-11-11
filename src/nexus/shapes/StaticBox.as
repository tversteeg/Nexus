package nexus.shapes {
	import nexus.interfaces.IMapAble;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public dynamic class StaticBox implements IMapAble{
		
		public function StaticBox() {
			_list = new Vector.<Point>(4,true)
			var i:int;
			for (i = 0; i < 4; i++) {
				_list[i] = new Point();
			}
		}
		
		private var _tr:Boolean = true;
		
		private var _w:Number;// Width
		public function set width(w:Number):void {
			_w = w;
			_tr = true;
		}
		
		public function get width():Number {
			return _w;
		}
		
		private var _h:Number;// Height
		public function set height(h:Number):void {
			_h = h;
			_tr = true;
		}
		
		public function get height():Number {
			return _h;
		}
		
		private var _x:Number;// X position
		public function set x(x:Number):void {
			_x = x;
			_tr = true;
		}
		public function get x():Number {
			return _x;
		}
		
		private var _y:Number;// Y position
		public function set y(y:Number):void {
			_y = y;
			_tr = true;
		}
		public function get y():Number {
			return _y;
		}
		
		public function get upperBound():Point {
			return _list[0];
		}
		
		public function get lowerBound():Point {
			return _list[3];
		}
		
		/* INTERFACE nexus.interfaces.IMapAble */
		
		private var _list:Vector.<Point>; // list
		public function get list():Vector.<Point> {
			if (_tr) {
				_list[0].x = _x;
				_list[0].y = _y;
				_list[1].x = _x + _w;
				_list[1].y = _y;
				_list[2].x = _x + _w;
				_list[2].y = _y + _h;
				_list[3].x = _x;
				_list[3].y = _y + _h;
				_tr = false;
			}
			return _list;
		}
		public function set shapeId(value:int):void {
			_shapeId = value;
		}
		
		private var _shapeId:int; // shapeId
		public function get shapeId():int {
			return _shapeId;
		}
		public function set mapId(value:int):void {
			_mapId = value;
		}
		
		private var _mapId:int; // mapId
		public function get mapId():int {
			return _mapId;
		}
		public function set sheetId(value:int):void {
			_sheetId = value;
		}
		
		private var _sheetId:int; // sheetId
		public function get sheetId():int {
			return _sheetId;
		}
		public function set alpha(value:Number):void {
			_alpha = value;
		}
		
		private var _alpha:Number; // alpha
		public function get alpha():Number {
			return _alpha;
		}
		public function set visible(value:Boolean):void {
			_visible = value;
		}
		
		private var _visible:Boolean; // visible
		public function get visible():Boolean {
			return _visible;
		}
		public function set active(value:Boolean):void {
			_active = value;
		}
		
		private var _active:Boolean; // active
		public function get active():Boolean {
			return _active;
		}
		public function set respawned(value:Boolean):void {
			_respawned = value;
		}
		
		private var _respawned:Boolean; // respawned
		public function get respawned():Boolean {
			return _respawned;
		}
		
		public function update():Boolean {
			return false;
		}
		
		public function die():void {
			_active = false;
			_visible = false;
		}
		
	}

}