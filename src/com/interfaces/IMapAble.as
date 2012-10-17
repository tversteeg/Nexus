package com.interfaces {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public interface IMapAble {
		
		function get list():Vector.<Point>;
		
		function set shapeId(id:int):void;
		function get shapeId():int;
		
		function set mapId(id:int):void;
		function get mapId():int;
		
		function set sheetId(id:int):void;
		function get sheetId():int;
		
		function set alpha(v:Number):void;
		function get alpha():Number;
		
		function set visible(v:Boolean):void;
		function get visible():Boolean;
		
		function set active(v:Boolean):void;
		function get active():Boolean;
		
		function set respawned(v:Boolean):void;
		function get respawned():Boolean;
		
		function update():Boolean;
	}
	
}