package com.objects {
	import com.interfaces.IMapAble;
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
		public function respawn(shapeId:int, className:Class, sheetId:int):* {
			var l:int = _l.length, i:int;
			var c:IMapAble
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
		
		private var _l:Vector.<IMapAble> = new Vector.<IMapAble>();//The pool where the boxes are
		public function set children(v:Vector.<IMapAble>):void {
			_l = v;
		}
		public function get children():Vector.<IMapAble> {
			return _l;
		}
		
	}

}