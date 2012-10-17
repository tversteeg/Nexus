![Logo](http://student-kmt.hku.nl/~thomas24/Modules/DesignResearch1/Nexus%20Logo.png)
------------
AS3 2D GPU accelerated engine, easy to use.
In later editions there will be integrated physics.

Example Code:
```actionscript
var w:World = new World(stageWidth, stageHeight, framesPerSecond);
// Creates a new Stage.

w.addSpriteSheet(spriteSheetImage, spriteSheetPositionsJSON);
/* Adds a sprite sheet to the stage, you can embed them or create a loader,
*  the positions JSON file has the following format:
*  {"frames": [ {
*   "frame": {"x":153,"y":0,"w":69,"h":60},
* 	"offset": {"x":1,"y":11,"w":77,"h":75}}
*  ]};
*/

w.initialize(stage, {antiAliasing:2, mipmap:false, backColor:0xFFFFFF});
// Initializes the stage, in this fase the shaders are loaded and the textures
// uploaded to the graphics card (if available). The {} brackets are a object
// with the initializing variables, you can also load custom shaders this way.

var s:Box = w.addSprite(spriteNumber, Box);
// Creates a new Sprite from the sprite sheet, the number connects with the
// positions file. You can use position (x and y) and size
// (width, height, scaleX and scaleY) and also rotation and alpha on the object.
// And you can remove the object simply by using s.die().

stage.addEventListener(Event.ENTER_FRAME, updateFrame);
// Creates an event listener that updates the stage every frame.

function updateFrame(e:Event):void{
  w.updateTimeStep();
  // Updates the frame and draws it, you can also pass an {} object with vertex
  // and/or fragment Vector.<Number> constants.
}
```