//
//  YMRichText.h
//  YMRichText
//
//  Created by zhangxinwei on 16/8/23.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YMStringParser.h"

#define DEF_WITDH       100


@interface YMRichText : UIView
{
    // 是否需要刷新 
    BOOL dirty;
    // 剩余宽度
    float leftSpace;
    // 位置
    CGPoint position;
    // 最大行宽（自动高度）
    float maxWidth;
    // 富文本字符串
    NSString* ymString;
    // 二维数组存储
    NSMutableArray* container;
}

// 回调
@property(nonatomic)           SEL      action;
@property(nonatomic,weak)      id       target;
@property(nonatomic)           int      defFontSize;
@property(nonatomic,strong)    UIColor* defFontColor;
// 初始化
-(id) init:(NSString*)richStr;
// 设置文本
-(void) setText:(NSString*)string;
//点击事件
-(void) addTarget:(id)target clickAction:(SEL)action;
// 设置位置
-(void) setPosition:(CGPoint)point;
// 设置行宽
-(void) setMaxLineWidth:(float)width;
// 根据行宽拆分行
-(void) formateText;
// 设置位置,大小
-(void) formatetRender;
// 文本
-(void) handerLabelElement:(YMStringElement*)element;
// 图片
-(void) handerImageElement:(YMStringElement*)element;
// GIF
-(void) handerEmojElement:(YMStringElement*)element;
// 链接
-(void) handerLinkElement:(YMStringElement*)element;
// 默认
-(void) handerDefsetElement:(YMStringElement*)element;
// 换行
-(void) addNewLine;
// 添加到当前行 
-(void) pushInContainer:(UIView*)view;
// 解析颜色
-(UIColor*) parserColor:(NSString*)colorStr;
@end
