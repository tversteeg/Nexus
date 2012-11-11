package nexus.collision {
	import flash.geom.Point;
	import nexus.math.Math2;
	import nexus.shapes.Box;
	/**
	 * ...
	 * @author Thomas Versteeg Et Al, 2012
	 */
	public class Intersection {
		
		/**
		 * Checks the collision between two boxes using the SAT/OBB technique.
		 * @param	box1 the first box that must be checked
		 * @param	box2 the second box that must be checked
		 * @return	returns intersection data, which contains information about the collision
		 */
		public static function getBoxIntersection(box1:Box, box2:Box):IntersectionData {
			var l1:Vector.<Vector2> = box1.list;
			var l2:Vector.<Vector2> = box2.list;
			
			var id:IntersectionData = new IntersectionData();
			if (!getAABB(box1, box2)) {
				id.collided = false;
				return id;
			}
			
			id = getSAT(l1, l2, box1.position, box2.position);
			if (id.collided) {
				id = getSAT(l2, l1, box2.position, box2.position);
				if (!id.collided) {
					id.collided = false;
				}
			}
			return id;
		}
		
		/**
		 * Returns collision data of the intersection-test between
		 * two shapes, the intersection test is performed with SAT/
		 * OBB.
		 * TODO: Fix multiple point poly's
		 * @param shape1Points, the translated points of the first shape
		 * @param shape2Points, the translated points of the second shape
		 * @param shape1Position, the position of the center of the first shape
		 * @param shape2Position, the position of the center of the second shape
		 * @return returns intersection data, which contains distance, intersection point and overlap
		 */
		public static function getSAT(shape1Points:Vector.<Vector2>, shape2Points:Vector.<Vector2>, shape1Position:Vector2, shape2Position:Vector2):IntersectionData {
			
			var test1:Number, test2:Number, testNum:Number, min1:Number, max1:Number, min2:Number, max2:Number, offset:Number, shortestDistance:Number = Number.MAX_VALUE;
			var axis:Vector2, vectorOffset:Vector2, temp:Vector2;
			
			var colData:IntersectionData = new IntersectionData();
		
			var vectors1:Vector.<Vector2> = shape1Points.concat();
			var vectors2:Vector.<Vector2> = shape2Points.concat();
			
			vectorOffset = new Vector2(shape1Position.x - shape2Position.x, shape1Position.y - shape2Position.y);
			
			var i:int, j:int, k:int;
			var l:int = vectors1.length;
			var l2:int = vectors2.length;
			for (i = 0; i < l; i++) {
				axis = findNormalAxis(vectors1, i);
				min1 = axis.dotProduct(vectors1[0]);
				max1 = min1;
				
				for (j = 1; j < l; j++) {
					testNum = axis.dotProduct(vectors1[j]);
					if (testNum < min1) min1 = testNum;
					if (testNum > max1) max1 = testNum;
				}
				
				min2 = axis.dotProduct(vectors2[0]);
				max2 = min2;
				
				for (k = 1; k < l2; k++) {
					testNum = axis.dotProduct(vectors2[k]);
					if (testNum < min2) min2 = testNum;
					if (testNum > max2) max2 = testNum;
				}
				
				test1 = min2 - max1;
				test2 = min1 - max2; 
				if (test1 > 0 || test2 > 0) {
					colData.collided = false;
					return colData;
				}
				var distance:Number = -(max2 - min1);
				if(Math2.abs(distance) < shortestDistance) {
					colData.unitVector = axis;
					colData.overlap = distance;
					shortestDistance = Math2.abs(distance);
				}
			}
			colData.collided = true;
			colData.seperation = new Vector2(colData.unitVector.x * colData.overlap, colData.unitVector.y * colData.overlap);
			
			return colData;
		}
		
		/**
		 * Function used to get the normal between the vertices
		 * @param	vertices the shape points you want to find the normal between
		 * @param	index which point your currently at
		 * @return  returns a Vector2 with the normal of the two points
		 */
		private static function findNormalAxis(vertices:Vector.<Vector2>, index:int):Vector2{
			var vector1:Vector2 = vertices[index];
			var vector2:Vector2 = (index >= vertices.length - 1) ? vertices[0] : vertices[index + 1]; 
			 
			var normalAxis:Vector2 = new Vector2( -(vector2.y - vector1.y), vector2.x - vector1.x);
			normalAxis.normalize();
			return normalAxis;
		}
		
		/**
		 * Retrieves a simple bound-bound collision, useful for optimising the SAT collision
		 * @param	box1 the first box to check the collision with
		 * @param	box2 the second box to check the collision with
		 * @return	returns a Boolean, true if there is a collision, false if there isn't
		 */
		public static function getAABB(box1:Box, box2:Box):Boolean {
			if (box2.lowerBound.x < box1.upperBound.x) return false;
			if (box2.lowerBound.y < box1.upperBound.y) return false;
			
			if (box1.lowerBound.x < box2.upperBound.x) return false;
			if (box1.lowerBound.y < box2.upperBound.y) return false;

			return true;
		}
	}

}