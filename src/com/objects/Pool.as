package com.objects {
	import com.shapes.Box;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public class Pool {
		
		public function Pool() {
			
		}
		
		/**
		 * Checks if a sprite that's inactive exists, when there is none create a new one
		 * @param	shapeId the id of the sprite where it is positioned in the spritesheet
		 * @return a new Box wich is either respawned or new
		 */
		public function respawn(shapeId:int, className:Class, sheetId:int):Object {
			var l:int = _l.length, i:int;
			var c:Box;
			for (i = 0; i < l; i++) {
				c = _l[i];
				if (!c.active && c.shapeId == shapeId) {
					c.active = true;
					c.visible = true;
					c.respawned = true;
					c.mapId = i;
					return c;
				}
			}
			c = new className();
			c.active = true;
			c.visible = true;
			c.shapeId = shapeId;
			c.sheetId = sheetId;
			c.mapId = l;
			_l[l] = c;
			
			return c;
		}
		
		private var _l:Vector.<Box> = new Vector.<Box>();//The pool where the boxes are
		public function set children(v:Vector.<Box>):void {
			_l = v;
		}
		public function get children():Vector.<Box> {
			return _l;
		}
		
	}

}