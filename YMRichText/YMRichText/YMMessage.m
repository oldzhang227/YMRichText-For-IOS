//
//  YMMessage.m
//  YMRIchText
//
//  Created by zhangxinwei on 16/8/29.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import "YMMessage.h"
#import "YMBubbleText.h"
@implementation YMMessage




-(void)cacluteHeight
{
    float width = [UIScreen mainScreen].bounds.size.width - HEAD_WIDTH - HEAD_SPACE;
    YMBubbleText* bubbleText = [[YMBubbleText alloc]init];
    [bubbleText setText:_content];
    if (_isLeft) {
         [bubbleText setOffset:CGRectMake(20, 10, 10, 10)];
    }
    else
    {
         [bubbleText setOffset:CGRectMake(10, 20, 10, 10)];
    }
   
    [bubbleText setMaxLineWidth:width];
    [bubbleText adjustFrame];
    
    _height = bubbleText.frame.size.height;
    
}
@end
