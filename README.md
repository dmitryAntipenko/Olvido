# Game Scene Base Class

- To use game scenes make .sks file, build your scene, create custom class subclassed from OGGameScene.
- Your custom class should call super's didMoveToView and didBeginContact in its implementation.

OGGameScene contains:
- References to OGAccessComponent and OGTransitionComponent for portal and OGMovementControlComponent for player.
- Array of sprite nodes on scene. You can add node from scene via addSpriteNode:(OGSpriteNode *)node
- Scene Delegate which method should be called to finish the game propely.

# Nodes

## SKButtonNode

In "*.sks" file :
- Make your spriteNode custom class = OGButtonNode.

- In "UserData" block add next fields:
    1. touchesTexture (String) - Name of texture that will be showed when you touch down on button.
    2. nextScene (String) - Name of next scene file name that will be presented when you click on button. WITHOUT EXTENSION!
    3. selector (String) - Name of selector that will be performed when you click on button
    

# Components

*your description here*