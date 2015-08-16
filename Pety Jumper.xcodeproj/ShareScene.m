//
//  ShareScene.m
//  PetyJumper
//
//  Created by Sosnovik on 14.08.15.
//  Copyright (c) 2015 Ivan Sosnovik. All rights reserved.
//

#import "ShareScene.h"
#import "Colors.h"
#import "GameScene.h"
#import "GameResult.h"

@interface ShareScene()

@property (strong, nonatomic) UIDocumentInteractionController *docController;
@property (strong, nonatomic) UIImage *imageToShare;

@end

@implementation ShareScene 


-(void)didMoveToView:(SKView *)view{
    self.backgroundColor = [Colors skyColor];
    
    self.imageToShare = [self makeImageToShare];


    self.anchorPoint = CGPointMake(0.5 , 0.5);
    // draw new game
    SKLabelNode *newGame=[SKLabelNode labelNodeWithFontNamed:@"Menlo-Bold"];
    newGame.text=@"↻";
    newGame.position=CGPointMake(0, -220);
    newGame.fontSize=120;
    newGame.color = [UIColor whiteColor];
    newGame.name=@"NEW_GAME";
    [self  addChild:newGame];
    // draw instagram
    SKSpriteNode *instagram = [SKSpriteNode spriteNodeWithImageNamed:@"instagram"];
    instagram.size = CGSizeMake(90.0, 90.0);
    instagram.position = CGPointMake(-80.0 , -60.0);
    instagram.name = @"INSTAGRAM";
    instagram.alpha = 0.0;
    SKAction *appear = [SKAction fadeAlphaTo:1.0 duration:0.3 ];
    [instagram runAction:appear];
    [self addChild:instagram];
    //draw vk
    SKSpriteNode *vk = [SKSpriteNode spriteNodeWithImageNamed:@"vk"];
    vk.size = CGSizeMake(90.0, 90.0);
    vk.position = CGPointMake(80.0 , -60.0);
    vk.name = @"VK";
    vk.alpha = 0.0;
    [vk runAction:appear];
    [self addChild:vk];
    
    //draw image to share
    SKTexture *texture = [SKTexture textureWithImage:self.imageToShare];
    SKSpriteNode *image = [SKSpriteNode spriteNodeWithTexture:texture];
    image.position = CGPointMake(0, 200);
    image.size = CGSizeMake(320, 320);
//    image.alpha = 0.0;
//    [image runAction:appear];
    [self addChild:image];
    SKShapeNode *borders = [SKShapeNode shapeNodeWithRect:CGRectMake(-165.0, 35.0, 330.0, 330.0)];
    borders.fillColor = [Colors darkSkyColor];
    borders.strokeColor = borders.fillColor;
    borders.zPosition = image.zPosition-1;
//    borders.alpha = 0.0;
//    [borders runAction:appear];
    [self addChild:borders];
    
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch=[touches anyObject];
    SKNode *node=[self nodeAtPoint:[touch locationInNode:self]];
    
    //Logic
    
    if ([node.name isEqualToString:@"NEW_GAME"]) {
        GameScene *scene = [[GameScene alloc] initWithSize:self.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
       // SKTransition *transition = [SKTransition fadeWithColor:[Colors skyColor] duration:0.0];
        [self.view presentScene:scene];
    }
    
    if ([node.name isEqualToString:@"INSTAGRAM"]) {

        [self shareInstagram];
    }
}

-(UIImage *)makeImageToShare{
    UIImage *image = [UIImage imageNamed:@"ResultImage"];
    CGPoint point = CGPointMake(320, 160);
    NSString *text = [NSString stringWithFormat:@"%ld", self.score];
    
    UIImage *newImage = [self drawFront:image text:text atPoint:point];
    return newImage;
}

-(void)shareInstagram{
    NSString *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.igo"];
    [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
    
    //choose sharing image
    UIImage *image = self.imageToShare;
    //
    
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    
    
    self.docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
    self.docController.delegate = self;
    self.docController.UTI = @"com.instagram.exclusivegram";
    [self.docController presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];

}




-(UIImage*)drawFront:(UIImage*)image text:(NSString*)text atPoint:(CGPoint)point
{
    UIFont *font = [UIFont fontWithName:@"Menlo-Bold" size:120];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, (point.y - 5), image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = NSMakeRange(0, [attString length]);
    
    [attString addAttribute:NSFontAttributeName value:font range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowOffset = CGSizeMake(1.0f, 1.5f);
//    [attString addAttribute:NSShadowAttributeName value:shadow range:range];
    
    [attString drawInRect:CGRectIntegral(rect)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}





@end
