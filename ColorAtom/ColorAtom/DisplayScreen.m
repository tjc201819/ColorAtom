//
//  DisplayScreen.m
//  ColorAtom
//
//  Created by 杨萧玉 on 14-4-19.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//

#import "DisplayScreen.h"
#import "Define.h"
#import "GameOverScene.h"
#import "PlayFieldScene.h"
#import <objc/runtime.h>
#import "GameConstants.h"
#import "AgainstResult.h"

@implementation DisplayScreen
@synthesize atomCount;
@synthesize score;
@synthesize rank;
@synthesize sharp;
@synthesize atomCountLabel;
@synthesize scoreLabel;
@synthesize rankLabel;
@synthesize atomIcon;
@synthesize pauseLabel;
-(instancetype)initWithAtomCount:(NSInteger) count{
    if (self = [super init]) {
        self.name = (NSString *)DisplayScreenName;
        atomCount = count;
        score = 0;
        sharp = 1;
        rank = 1;
        atomCountLabel = [SKLabelNode labelNodeWithFontNamed:FontString];
        atomCountLabel.fontSize = 20;
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:FontString];
        scoreLabel.fontSize = 20;
        rankLabel = [SKLabelNode labelNodeWithFontNamed:FontString];
        rankLabel.fontSize = 20;
        pauseLabel = [SKLabelNode labelNodeWithFontNamed:FontString];
        pauseLabel.fontSize = 40;
        pauseLabel.alpha = 0;
        atomCountLabel.text = [NSString stringWithFormat:@"%ld",(long)atomCount];
        scoreLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"Score:%ld/%ld", @"") ,(long)score,(long)(((PlayFieldScene *)self.scene).updateScore)];
        rankLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"Rank:%ld", @""),(long)rank];
        pauseLabel.text = NSLocalizedString(@"PAUSE", @"");
        [self addChild:atomCountLabel];
        [self addChild:scoreLabel];
        [self addChild:rankLabel];
        [self addChild:pauseLabel];
        atomIcon = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"Atomplus"]];
        atomIcon.size = CGSizeMake(20, 20);
        [self addChild:atomIcon];
    }
    return self;
    
}
-(void)setPosition{
    self.size = CGSizeMake(self.scene.size.width, self.scene.size.height-AtomRadius*2);
    self.position = CGPointMake(self.scene.size.width/2, self.scene.size.height/2+AtomRadius);
    atomCountLabel.position = CGPointMake(-self.size.width/2+atomCountLabel.frame.size.width/2+atomIcon.size.width, -self.size.height/2+atomCountLabel.frame.size.height/2);
    scoreLabel.position = CGPointMake(0, self.size.height/2-scoreLabel.frame.size.height);
    rankLabel.position = CGPointMake(self.size.width/2-rankLabel.frame.size.width/2, -self.size.height/2+rankLabel.frame.size.height/2);
    atomIcon.position = CGPointMake(-self.size.width/2+atomIcon.size.width/2, -self.size.height/2+3*atomIcon.size.height/4);
    pauseLabel.position = CGPointMake(0, 0);

}
-(void)AtomMinusKilled{
    atomCount+=3;
    score+=10;
    atomCountLabel.text = [NSString stringWithFormat:@"%ld",(long)atomCount];
    scoreLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"Score:%ld/%ld", @""),(long)score,(long)(((PlayFieldScene *)self.scene).updateScore)];
    rankLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"Rank:%ld", @""),(long)rank];
    [self gameCheck];
    [self setPosition];
}

-(void)AtomPlusUsed:(NSInteger) num{
    atomCount-=num;
    score+=5*num;
    atomCountLabel.text = [NSString stringWithFormat:@"%ld",(long)atomCount];
    scoreLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"Score:%ld/%ld", @""),(long)score,(long)(((PlayFieldScene *)self.scene).updateScore)];
    rankLabel.text = [NSString localizedStringWithFormat:NSLocalizedString(@"Rank:%ld", @""),(long)rank];
    [self gameCheck];
    [self setPosition];
}

-(void)AtomMinusAttacked{
    atomCount-=10*rank;
    atomCountLabel.text = [NSString stringWithFormat:@"%ld",(long)atomCount];
    [self gameCheck];
    [self setPosition];
}

-(void)gameCheck{
    if (atomCount<=0) {
        NSString *bodyClassName = @(class_getName(self.scene.class));
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
        NSString *modeString = [standardDefaults objectForKey:@"mode"][bodyClassName];
        if ([modeString isEqualToString: (NSString *)AgainstMode]) {
            MessageGameOver mg;
            mg.message.messageType = kMessageTypeGameOver;
            NSData *packet = [NSData dataWithBytes:&mg length:sizeof(MessageGameOver)];
            [[GameKitHelper sharedGameKitHelper] sendData:packet withCompleteBlock:^{
                SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
                SKScene * gameOverScene = [[AgainstResult alloc] initWithSize:self.scene.size win:NO];
                [self.scene.view presentScene:gameOverScene transition: reveal];
            }];
            
        }
        else {
            SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
            SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.scene.size score:score mode:modeString];
            [self.scene.view presentScene:gameOverScene transition: reveal];
        }
        
    }
}

-(void)pause{
    pauseLabel.alpha = 1;
    [((PlayFieldScene *)self.scene) hideGame];
}

-(void)resume{
    pauseLabel.alpha = 0;
    [((PlayFieldScene *)self.scene) showGame];
}
@end
