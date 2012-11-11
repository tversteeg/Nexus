package nexus.interfaces {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public interface IPhysAble {
		
		function set mass(m:Number):void;
		function get mass():Number;
		
		function set velocity(p:Point):void;
		function get velocity():Point;
		
		function set position(p:Point):void;
		function get position():Point;
		
		function set isPoly(b:Boolean):void;
		function get isPoly():Boolean;
	}
	
}