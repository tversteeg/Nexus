package nexus.events{
	import flash.events.Event;

	public class MessageEvent extends Event {

		public static const CONTENT_ACTIVE:String = "contentActive";
		public static const CONTENT_DEACTIVE:String = "contentDeactive";

		public var message:String;

		public function MessageEvent(type:String, message:String = "", bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type,bubbles,cancelable);

			this.message = message;
		}

		public override function clone():Event {
			return new MessageEvent(type, message, bubbles, cancelable);
		}

	}

}