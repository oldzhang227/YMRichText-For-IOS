//
//  YMLinkLabel.m
//  TestOC
//
//  Created by zhangxinwei on 16/8/26.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import "YMLinkLabel.h"

@implementation YMLinkLabel

-(id) init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}
-(void) addTarget:(nullable id)target clickAction:(nullable SEL)action
{
    self.target = target;
    self.action = action;
}
-(void) setText:(NSString *)str
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary* dic = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                          NSUnderlineColorAttributeName:self.textColor};
    [attrString setAttributes:dic range:NSMakeRange(0, [str length])];
    self.attributedText = attrString;

}

-(void) setUnderLineColor:(UIColor *)color
{
    NSString* str = self.attributedText.string;
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary* dic = @{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],
                          NSUnderlineColorAttributeName:self.textColor};
    [attrString setAttributes:dic range:NSMakeRange(0, [str length])];
    self.attributedText = attrString;
}

-(void) onClick
{
    NSLog(@"YMLinkLabel on Click");
    if (self.target && self.action &&
        [self.target respondsToSelector:self.action] == YES)
    {
        [self.target performSelector:self.action withObject:self.linkData afterDelay:0.0f];
    }
}


@end
