//
//  YMStringParser.h
//  RichText
//
//  Created by zhangxinwei on 16/8/23.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

/*
	解析字符串生成拆分后的富文本数组
 
	规则：
	[]:对括号内的内容解析
	/:正常文本与属性内容的分隔
	=:属性名=属性值
	&:多个属性连接
 
	示例:
	[文本/c=red&s=20]
	[/image=图片.png]
	[/emoj=表情名]
	[文本/blink={json}]
 */

#import <Foundation/Foundation.h>
#import "YMStringElement.h"

@interface YMStringParser : NSObject
{
    // 结果
    NSMutableArray* elements;
}

// 返回拆分解析后数组
-(NSArray*) parser:(NSString*)str;

// 特殊字符转义
-(NSString*) encode:(NSString*)str;
-(NSString*) decode:(NSString*)str;

// 截止到特殊字符
-(int) checkNormalString:(const char*)p;
// 截取[]内容
-(int) checkAttrsString:(const char*)p;
// 生成纯字符文本
-(const char*) geneNormalString:(const char*)p;
// 生成带属性文本
-(const char*) geneAttrsString:(const char*)p;
// 换行
-(const char*) genBreakString:(const char*)p;
// 合并连续的纯字符文本
-(void) pushYMStringElement:(YMStringElement*)element;
// 截取字符串
-(NSString*) stringFromChar:(const char*)p :(int)len;
@end
