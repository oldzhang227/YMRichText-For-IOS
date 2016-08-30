//
//  YMBubbleText.m
//  YMRIchText
//
//  Created by zhangxinwei on 16/8/29.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import "YMBubbleText.h"
#import "YMRichText.h"
@implementation YMBubbleText
{
    BOOL            dirty;
    CGRect          offset;
    CGPoint         position;
    UIImageView*    imageView;
    YMRichText*     richText;
}

-(id) init
{
    self = [super initWithFrame:CGRectMake(0, 0, DEF_WITDH, DEF_WITDH)];
    if (self) {
        dirty = YES;
        position = CGPointZero;
        offset = CGRectZero;
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEF_WITDH, DEF_WITDH)];
        richText = [[YMRichText alloc]init:@""];
        richText.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        [self addSubview:richText];
    }
    return  self;
}
-(void) setMaxLineWidth:(float)width
{
    if (richText) {
        [richText setMaxLineWidth:width];
    }
}

-(void) setPosition:(CGPoint)point
{
    position = point;
    dirty = YES;
    [self setNeedsDisplay];
}

-(void) setOffset:(CGRect)rect
{
    offset = rect;
    dirty = YES;
    [self setNeedsDisplay];
}
-(void) setText:(NSString *)string
{
    [richText setText:string];
    dirty = YES;
    [self setNeedsDisplay];
}

-(void) setStretchableImage:(UIImage *)image LeftCapWidth:(float)left topCapHeight:(float)top
{
    if (imageView) {
        imageView.image = [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
        dirty = YES;
        [self setNeedsDisplay];
    }
}

-(void) drawRect:(CGRect)rect
{
    [self adjustFrame];
}

-(void) adjustFrame
{
    if (dirty) {
        // 调整位置，大小
        [richText setPosition:offset.origin];
        [richText formateText];
        CGSize size = richText.bounds.size;
        float w = size.width + offset.origin.x + offset.size.width;
        float h = size.height + offset.origin.y + offset.size.height;
        imageView.frame = CGRectMake(0, 0, w, h);
        self.frame = CGRectMake(position.x, position.y, w , h);
        dirty = NO;
    }
}

-(void) addTarget:(id)target clickAction:(SEL)action
{
    if (richText) {
        [richText addTarget:target clickAction:action];
    }
}



@end
