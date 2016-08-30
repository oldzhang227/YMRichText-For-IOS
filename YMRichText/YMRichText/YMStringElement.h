//
//  YMStringElement.h
//  RichText
//
//  Created by zhangxinwei on 16/8/23.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//


#import <Foundation/Foundation.h>

#define ATTR_CORLOR @"c"     //文字颜色
#define ATTR_SIZE   @"s"     //文字大小
#define ATTR_WIDTH  @"w"     //宽度
#define ATTR_HEIGHT @"h"     //高度
#define ATTR_IMAGE  @"image" //图片路径
#define ATTR_EMOJ   @"emoj"  //表情名
#define ATTR_LINK   @"link"  //链接内容
#define ATTR_DEFC   @"defc"  //默认字体颜色
#define ATTR_DEFS   @"defs"  //默认字体大小

// 富文本类型
enum YMStringType
{
    YMString_nil		= 0,// 默认
    YMString_text		= 1,// [文字/c=#ARGB&s=20]
    YMString_image      = 2,// [/image=图片.png&w=100&h=100]
    YMString_emoj		= 3,// [/emoj=xxxx]
    YMString_link		= 4,// [文字/link={json}]
    YMString_break      = 5,// \n
    YMString_defset     = 6,// [defc=#ARGB&defs=20]
};

@interface YMStringElement : NSObject
{
    enum YMStringType stringType;
    NSString* contentStr;
    NSMutableDictionary* attrsDic;
}

-(id) init;

-(void) setContentStr:(NSString*)content;
-(NSString*) getContentStr;
-(void) addAttrValue:(NSString*)key :(NSString*)value;
-(NSString*) getAttrValue:(NSString*)key;
-(void) formatType;
-(void) setType:(enum YMStringType)type;
-(NSString*) toString;
-(BOOL) isNormalString;
-(enum YMStringType) type;


@end
