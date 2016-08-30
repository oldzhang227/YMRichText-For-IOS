//
//  YMLinkLabel.h
//  TestOC
//
//  Created by zhangxinwei on 16/8/26.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import "YMAlignLabel.h"

@interface YMLinkLabel : YMAlignLabel

// 用户数据
@property(nullable,strong,nonatomic)    NSString*           linkData;
// 回调
@property(nullable, nonatomic)          SEL                 action;
@property(nullable, nonatomic,weak)     id                  target;

// 点击事件
-(void) addTarget:(nullable id)target clickAction:(nullable SEL)action;
// 文本
-(void) setText:(nullable NSString*)string;
// 下划线颜色
-(void) setUnderLineColor:(nullable UIColor*)color;
//
-(void) onClick;

@end
