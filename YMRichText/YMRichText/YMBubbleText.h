//
//  YMBubbleText.h
//  YMRIchText
//
//  Created by zhangxinwei on 16/8/29.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMBubbleText : UIView

// 设置宽度
-(void) setMaxLineWidth:(float)width;
// 设置位置
-(void) setPosition:(CGPoint)point;
// 文字相对背景图偏移
-(void) setOffset:(CGRect)rect;
// 设置文本
-(void) setText:(NSString*)string;
// 设置背景图
-(void) setStretchableImage:(UIImage*)image LeftCapWidth:(float)left topCapHeight:(float)top;
// 调整
-(void) adjustFrame;
//点击事件
-(void) addTarget:(id)target clickAction:(SEL)action;

@end