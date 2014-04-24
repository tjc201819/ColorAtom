//
//  YXYMyScene.h
//  ColorAtom
//

//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class PlayerArea;
@class Background;
@class DisplayScreen;
@class YXYDebugNode;

@interface PlayFieldScene : SKScene <SKPhysicsContactDelegate>

@property YXYDebugNode* debugOverlay;
@property CGPoint longPressPosition;
@property CGPoint panPosition;
@property PlayerArea *playArea;
@property Background *background;
@property DisplayScreen *displayScreen;
@property NSInteger rank;
@property NSInteger sharpCount;
@property NSInteger updateScore;
@property SKSpriteNode *sharpButton;

-(void)createAtomMinus;
@end
