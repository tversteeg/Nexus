Nexus
=====

AS3 2D GPU accelerated engine, easy to use.
In later editions there will be integrated physics, here is an example program:

var w:World;
w = new World(800, 600, 1/30);
w.addSpriteSheet(sheet1, sheetPos1);
w.initialize(stage, { antiAliasing:2, mipmap:false, backColor:0xCCCCCC } );
w.addEventListener(MessageEvent.CONTENT_ACTIVE, wActive, false, 0 , true);

private function wActive(e:MessageEvent):void {
  	switch(e.message) {
			case "init":
				trace("Engine initialized");
        var s:Object = w.addSprite(1, Box);
				break;
		}
}