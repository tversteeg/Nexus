![Logo](http://student-kmt.hku.nl/~thomas24/Modules/DesignResearch1/Nexus%20Logo.png)
------------
AS3 2D GPU accelerated engine, easy to use.
In later editions there will be integrated physics.
------------
When you want to generate sprite sheets using Adobe Flash CS6, follow these instructions:

1. Save `JSON-Nexus.plugin.jsfl` from the root folder of the github repo to `Program Files\Adobe\Adobe Flash CS6\Common\Configuration\Sprite Sheet Plugins`.
2. Now open Flash CS6, select the files you want to save as a sprite sheet in your library, press right mouse and click on `Generate Sprite Sheet...`.
3. Click on the `Data format:` menu and select `JSON-Fixed`, and dont select `Rotate`, you can select `Trim` and `Stack Frames` if you like. The engine uses alpha maps so I would recommend using PNG's without a background color, I also recommend a Shape padding of about 10 pixels when you want to generate normal maps.
4. Press on Browse and select the location where the source files of your project are, press `Save` and then press `Export`.

Example Code:
```actionscript
var world:SimpleWorld = new SimpleWorld(stage, spriteSheet, spritesPosition, normalMap);
/* 
*  Creates a new World instance, this initializes the GPU for rendering
*  The first variable is the stage so it can get the size of the stage and the framerate
*  The second variable is the sprite sheet texture map, this map contains all the objects you want to draw
*  The third variable is a string containing the positions passed by the JSON script used to create the sprite sheet
*  The last variable is optional, it is a normal map which you can generate using the sprite sheet map
*/

DebugSpriteSheet.saveAsPnG(spriteSheet, spritesPosition, 2048, 2048);
/*
*  Optional, this saves a image to your computer where each sprite is labelled with the sprite id that must be used to call on it
*  This is very usefull for debugging so you dont have to remember all the id's
*  The first variable is the sprite sheet you want to disect
*  The second variable is the JSON string used for the sprites positions
*  The third and fourth variables are the size of the image you want to saveAsPnG
*/

var object:Box = world.addSprite(spriteId, Box);
/*
*  This creates a sprite which is pooled automatically, you can destroy it by using object.die()
*  The first variable is the id of the sprite, you can find this using the DebugSpriteSheet function
*  The second variable is the type of the object, you can use StaticBox (No scale and rotation), Box, and MovieBox(Animated using multiple sprites)
*/

// Inside a enterFrame Event listener:
world.render(new Point(lightPositionX, lightPositionY));
/*
*  This function renders the stage, when you supplied a normal map with the constructor function it uses 3 render passes, and otherwise 1
*  The variable that is passes is the position of the light used with the normal map as a Point
*/
```
