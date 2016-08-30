//
//  YMStringParser.m
//  RichText
//
//  Created by zhangxinwei on 16/8/23.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import "YMStringParser.h"

@implementation YMStringParser



// 返回拆分解析后数组
-(NSArray*) parser:(NSString*)str
{
    if(elements == nil)
    {
        elements = [NSMutableArray array];
    }
    const char* p = [str UTF8String];
    while (*p != '\0')
    {
        switch (*p)
        {
            case '[':
            {
                bool isFormatter = false;
                int len = [self checkAttrsString:p + 1];
                if (len > 0)
                {
                    const char* s = [self geneAttrsString:p];
                    if (s != p)
                    {
                        p = s;
                        isFormatter = true;
                    }
                }
                if (!isFormatter)
                {
                    p = [self geneNormalString:p];
                }
            }
                break;
            case  '\n':
            {
                p = [self genBreakString:p];
            }
                break;
            default:
            {
                p = [self geneNormalString:p];
            }
                break;
        }
        
    }
    return elements;
}

// 特殊字符转义
-(NSString*) encode:(NSString*)str
{
    return nil;
}
-(NSString*) decode:(NSString*)str
{
    return nil;
}

// 截止到特殊字符
-(int) checkNormalString:(const char*)p
{
    if (*p == '\0')
    {
        return 0;
        
    }
    else
    {
        int len = 0;
        do
        {
            p++;
            len++;
            if (*p == '[' || *p == '\n')
            {
                break;
            }
        } while (*p != '\0');
        return len;
    }
}
// 截取[]内容
-(int) checkAttrsString:(const char*)p
{
    int len = 0;
    while (*p != '\0')
    {
        switch (*p)
        {
            case '[':
            case '\n':
            {
                return 0;
            }
                break;
            case  ']':
            {
                return len + 1;
            }
                break;
            default:
            {
                p++;
                len++;
            }
                break;
        }
    }
    return 0;
}
// 生成纯字符文本
-(const char*) geneNormalString:(const char*)p
{
    int len = [self checkNormalString:p];
    NSString* content = [self stringFromChar:p :len];
    YMStringElement* element = [[YMStringElement alloc]init];
    [element setContentStr:content];
    [self pushYMStringElement:element];
    p += len;
    return p;
}
// 生成带属性文本
-(const char*) geneAttrsString:(const char*)p
{
    const char* s = p;
    s++;
    const char* t = s;
    YMStringElement* element = [[YMStringElement alloc]init];
    NSString* key = @"";
    NSString* value = @"";
    while (*s != '\0')
    {
        switch (*s)
        {
            case '/':
            {
                if ([element getContentStr] == nil)
                {
                    NSString* content = [self stringFromChar:t : (int)(s-t)];
                    [element setContentStr:content];
                    t = s + 1;
                }
            }
                break;
            case '=':
            {
                if (key.length == 0)
                {
                    key = [self stringFromChar:t : (int)(s-t)];
                    t = s + 1;
                }
            }
                break;
            case '&':
            {
                value = [self stringFromChar:t : (int)(s-t)];
                t = s + 1;
                if ([key length] != 0 && [value length] != 0)
                {
                    [element addAttrValue:key :value];
                    key = @"";
                    value = @"";
                }
                else
                {
                    //[element release];
                    return p;
                }
            }
                break;
            case ']':
            {
                value = [self stringFromChar:t : (int)(s-t)];
                t = s + 1;
                if ([key length] != 0 && [value length] != 0)
                {
                   [element addAttrValue:key :value];
                }
                else
                {
                   //[element release];
                    return p;
                }
            }
                break;
        }
        if (*s == ']')
        {
            break;
        }
        s++;
    }
    [self pushYMStringElement:element];
    
    return ++s;
}
// 换行
-(const char*) genBreakString:(const char*)p
{
    YMStringElement* element = [[YMStringElement alloc] init];
    [element setType:YMString_break];
    [self pushYMStringElement:element];
    
    return ++p;
}
// 合并连续的纯字符文本
-(void) pushYMStringElement:(YMStringElement*)element
{
    if(element == nil) return;
    [element formatType];
    if ([element isNormalString])
    {
        NSInteger len = [elements count];
        if (len > 0)
        {
            YMStringElement* lastElement = elements[len - 1];
            if ([lastElement isNormalString])
            {
                NSString* newContent = [[lastElement getContentStr] stringByAppendingString:[element getContentStr]];
                [lastElement setContentStr:newContent];
            }
            else
            {
                [elements addObject:element];
            }
        }
        else
        {
            [elements addObject:element];
        }
    }
    else
    {
        [elements addObject:element];
    }
}

-(NSString*) stringFromChar:(const char *)p :(int)len
{
    NSString* string = [NSString stringWithUTF8String:p];
    char* s = (char*)[string UTF8String];
    *(s + len) = '\0';
    string = [NSString stringWithUTF8String:s];
    return string;
}



@end
