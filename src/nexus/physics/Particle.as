package nexus.physics {
	import nexus.math.Point2;
	import nexus.math.Vector2;
	/**
	 * ...
	 * @author Thomas Versteeg, 2012
	 */
	public class Particle {
		
		public function Particle(x:Number = 0, y:Number = 0) {
			_s.x = x;
			_s.y = y;
		}
		
		/**
		 * This function takes the current state, and advances it with deltaTime; then it derives it
		 * @param	initial the state it must be updated from
		 * @param	derivative the derivative the state must be derived with
		 * @param	time the total time the simulation is running
		 * @param	deltaTime the amount if time that is passed between the frames
		 * @return	returns a derivative, used for the change in position
		 */
		public function evaluate(initial:Point2, derivative:Point2, time:Number, deltaTime:Number):Point2 {
			// Creates a new position using the old one
			var s:Point2 = new Point2();
			s.x = initial.x + derivative.x * deltaTime;
			s.y = initial.y + derivative.y * deltaTime;
			s.vx = initial.vx + _d.vx * deltaTime;
			s.vy = initial.vy + _d.vy * deltaTime;
			
			// Creates a new derivative according to the previous points
			var d:Point2 = new Point2(s.x, s.y);
			d.velocity = acceleration(s, time + deltaTime);
			return d;
		}
		
		/**
		 * Integrates the state, adding the new position to it
		 * @param	state the state you want to be integrated
		 * @param	time the total time the simulation is running
		 * @param	deltaTime the time a frame takes
		 */
		public function integrate(state:Point2, time:Number, deltaTime:Number):void {
			var a:Point2 = evaluate(state, new Point2(), time, 0);
			var b:Point2 = evaluate(state, a, time, deltaTime * 0.5);
			var c:Point2 = evaluate(state, b, time, deltaTime * 0.5);
			var d:Point2 = evaluate(state, c, time, deltaTime);
			
			var dxdt:Number = 1 / 6 * (a.x + 2 * (b.x + c.x) + d.x);
			var dydt:Number = 1 / 6 * (a.y + 2 * (b.y + c.y) + d.y);
			
			var dvxdt:Number = 1 / 6 * (a.vx + 2 * (b.vx + c.vx) + d.vx);
			var dvydt:Number = 1 / 6 * (a.vy + 2 * (b.vy + c.vy) + d.vy);
			
			state.x += dxdt * deltaTime;
			state.y += dydt * deltaTime;
			
			state.vx += dvxdt * deltaTime;
			state.vy += dvydt * deltaTime;
		}
		
		public function acceleration(p:Point2, t:Number):Vector2 {
			return new Vector2( -10 * p.x - 1 * p.vx, -10 * p.y - 1 * p.vy);
		}
		
		protected var _s:Point2;//State contains position and velocity
		public function set state(s:Point2):void {
			_s = s;
		}
		public function get state():Point2 {
			return _s;
		}
		
		protected var _d:Point2;//Derivative contains derived position and velocity
		public function set derivative(d:Point2):void {
			_d = d;
		}
		public function get derivative():Point2 {
			return _d;
		}
	}

}