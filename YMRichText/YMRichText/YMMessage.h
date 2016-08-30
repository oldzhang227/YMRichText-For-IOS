//
//  YMMessage.h
//  YMRIchText
//
//  Created by zhangxinwei on 16/8/29.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import <Foundation/Foundation.h>


#define HEAD_WIDTH  50
#define HEAD_SPACE  30


@interface YMMessage : NSObject

// 内容
@property (nonatomic, strong) NSString* content;
// 高度
@property(nonatomic)          float     height;
//箭头方向
@property(nonatomic)          BOOL      isLeft;

// 计算高度
-(void)cacluteHeight;


@end
