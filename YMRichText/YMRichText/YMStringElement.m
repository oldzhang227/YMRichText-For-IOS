//
//  YMStringElement.m
//  RichText
//
//  Created by zhangxinwei on 16/8/23.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import "YMStringElement.h"

@implementation YMStringElement


-(id) init
{
    self = [super init];
    if (self) {
        stringType = YMString_nil;
        contentStr = nil;
        attrsDic = nil;
    }
    return self;
}

-(void) setContentStr:(NSString *)content
{
    contentStr = content;
}

-(NSString*) getContentStr
{
    return contentStr;
}

-(void) addAttrValue:(NSString*)key :(NSString*)value
{
    if (attrsDic == nil) {
        attrsDic = [NSMutableDictionary dictionary];
    }
    [attrsDic setObject:value forKey:key];
    
}
-(NSString*) getAttrValue:(NSString*)key
{
    NSString* value = nil;
    if (attrsDic) {
        value = [attrsDic objectForKey:key];
    }
    return  value;
}
-(void) formatType
{
    // 通过是否包含关键字来判断
    if ([self getAttrValue:ATTR_IMAGE]) {
        
        stringType = YMString_image;
    }
    if ([self getAttrValue:ATTR_LINK]) {
        
        stringType = YMString_link;
    }
    if ([self getAttrValue:ATTR_EMOJ]) {
        
        stringType = YMString_emoj;
    }
    if ([self getAttrValue:ATTR_DEFC] || [self getAttrValue:ATTR_DEFS]) {
        stringType = YMString_defset;
    }
    if (stringType == YMString_nil && [contentStr length] > 0) {
        
        stringType = YMString_text;
    }
}
-(void) setType:(enum YMStringType)type
{
    stringType = type;
}
-(NSString*) toString
{
    if (stringType == YMString_break)
    {
        return @"\n";
    }
    if ([[attrsDic allKeys] count] == 0)
    {
        return contentStr;
    }
    else
    {
        NSString* s = [NSString stringWithFormat:@"[%@/", contentStr];
        
        NSEnumerator* iter = [attrsDic keyEnumerator];
        NSString* key = [iter nextObject];
        while (key) {
            s = [[[s stringByAppendingString:key]stringByAppendingString:@"="]stringByAppendingString:[attrsDic objectForKey:key]];
            key = [iter nextObject];
            if (key) {
                s = [s stringByAppendingString:@"&"];
            }
        }

        s = [s stringByAppendingString:@"]"];
        return s;
    }
    
}
-(BOOL) isNormalString
{
    if (stringType == YMString_text && [[attrsDic allKeys]count] == 0)
    {
        return YES;
    }
    return NO;
}
-(enum YMStringType) type
{
    return stringType;
}



@end
