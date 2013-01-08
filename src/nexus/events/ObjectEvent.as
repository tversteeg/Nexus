package nexus.events{
	import flash.events.Event;

	public class ObjectEvent extends Event {

		public static const OBJECT_LOADED:String = "objectLoaded";
		public static const OBJECT_DISPOSED:String = "objectDisposed";
		public static const OBJECT_REQUEST:String = "objectRequest";

		public var object:Object;

		public function ObjectEvent(type:String, object:Object, bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type,bubbles,cancelable);

			this.object = object;
		}

		public override function clone():Event {
			return new ObjectEvent(type, object, bubbles, cancelable);
		}

	}

}