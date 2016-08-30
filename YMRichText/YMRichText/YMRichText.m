//
//  YMRichText.m
//  YMRichText
//
//  Created by zhangxinwei on 16/8/23.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//

#import "YMRichText.h"

#import "YMLinkLabel.h"
#import "YMAlignLabel.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@implementation YMRichText

-(id) init:(NSString *)richStr
{
    self = [super initWithFrame:CGRectMake(0, 0, DEF_WITDH, DEF_WITDH)];
    if (self) {
        dirty = YES;
        position = CGPointZero;
        leftSpace = CGFLOAT_MAX;
        maxWidth = CGFLOAT_MAX;
        ymString = richStr;
        container = [NSMutableArray array];
        self.defFontSize = 20;
        self.defFontColor = [UIColor whiteColor];
        }
    return self;
}
-(void) addTarget:(id)target clickAction:(SEL)action
{
    self.target = target;
    self.action = action;
}

-(void) drawRect:(CGRect)rect
{
    [self formateText];
}
-(void) setMaxLineWidth:(float)width
{
    maxWidth = width;
    dirty = YES;
    [self setNeedsDisplay];
}

-(void) setText:(NSString *)string
{
    ymString = string;
    dirty = YES;
    [self setNeedsDisplay];
}

-(void) setPosition:(CGPoint)point
{
    position = point;
    dirty = YES;
    [self setNeedsDisplay];
}

-(void) formateText
{
    if (dirty == NO) {
        return;
    }
    for (UIView* view in [self subviews]) {
        [view removeFromSuperview];
    }
    [container removeAllObjects];
    
    if (ymString == nil) {
        return;
    }
    
    // 解析文本
    NSArray* result = [[[YMStringParser alloc] init]parser:ymString];
    if (result)
    {
        [self addNewLine];
        for (YMStringElement* element in result) {
            
            [element toString];
            switch ([element type]) {
                case YMString_text:
                    [self handerLabelElement:element];
                    break;
                case YMString_emoj:
                    [self handerEmojElement:element];
                    break;
                case YMString_image:
                    [self handerImageElement:element];
                    break;
                case YMString_link:
                    [self handerLinkElement:element];
                    break;
                case YMString_break:
                    [self addNewLine];
                    break;
                case YMString_defset:
                    [self handerDefsetElement:element];
                    break;
                default:
                    break;
            }
        }
    }
    [self formatetRender];
    dirty = NO;
}

-(void) formatetRender
{
    // 计算每行行高
    NSMutableArray* heightArray = [NSMutableArray array];
    for (NSMutableArray* row in container) {
        float maxHeight = 0.0f;
        for (UIView* view in row) {
            float h = view.bounds.size.height;
            if (h > maxHeight) {
                maxHeight = h;
            }
        }
        [heightArray addObject:[NSNumber numberWithFloat:maxHeight]];
    }
    // 设置子节点位置
    float maxX = 0.0f;
    float y = 0.0f;
    for (int i = 0; i < [container count]; ++i) {
        NSNumber* maxHeight = [heightArray objectAtIndex:i];
        float x = 0.0f;
        NSArray* row = [container objectAtIndex:i];
        for (UIView* view in row) {
            CGSize size = view.bounds.size;
            size.height = [maxHeight floatValue];
            CGRect frame = CGRectMake(x, y, size.width, size.height);
            view.frame = frame;
            [self addSubview:view];
            x += size.width;
        }
        y += [maxHeight floatValue];
        if (x > maxX) {
            maxX = x;
        }
    }
    
    if (maxWidth >= CGFLOAT_MAX) {
         self.frame = CGRectMake(position.x, position.y, maxX, y);
    }
    else
    {
         self.frame = CGRectMake(position.x, position.y, maxWidth, y);
    }
    
}

-(void) addNewLine
{
    leftSpace = maxWidth;
    [container addObject:[NSMutableArray array]];
}

-(void) pushInContainer:(UIView *)view
{
    NSMutableArray* lastRow = [container lastObject];
    if (lastRow) {
        [lastRow addObject:view];
    }
}

-(UIColor*) parserColor:(NSString*)colorStr
{
    // #ARGB
    colorStr = [colorStr substringFromIndex:1];
    
    UInt32 num = (UInt32)strtoul([colorStr UTF8String], nil, 16);
    CGFloat a = (UInt8)(num >> 24) / 255.0f;
    CGFloat r = ((UInt8)(num >> 16)) / 255.0f;
    CGFloat g = ((UInt8)(num >> 8)) / 255.0f;
    CGFloat b = ((UInt8)(num)) / 255.0f;

    return [[UIColor alloc]initWithRed:r green:g blue:b alpha:a];
}

-(void) handerLabelElement:(YMStringElement *)element
{
    NSString* attr = nil;
    int fontSize = self.defFontSize;
    if ((attr = [element getAttrValue:ATTR_SIZE])) {
        fontSize = [attr intValue];
    }
    UIColor* color = self.defFontColor;
    if ((attr = [element getAttrValue:ATTR_CORLOR])) {
        color = [self parserColor:attr];
    }
    NSString* contentStr = [element getContentStr];
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    NSDictionary* sizeAttrs = @{NSFontAttributeName:font};
    CGSize size = [contentStr sizeWithAttributes: sizeAttrs];
    if (size.width < leftSpace) {
        YMAlignLabel* lable = [[YMAlignLabel alloc] init];
        [lable setVerticalAlignment:VerticalAlignmentBottom];
        lable.font = font;
        //lable.backgroundColor = [UIColor redColor];
        lable.textColor = color;
        lable.text = contentStr;
        lable.bounds = CGRectMake(0, 0, size.width, size.height);
        [self pushInContainer:lable];
        leftSpace -= size.width;
    }
    else
    {
        for (int i = 0;  i < [contentStr length]; ++i) {
            CGSize size = [[contentStr substringWithRange:NSMakeRange(i, 1)]sizeWithAttributes:sizeAttrs];
            leftSpace -= size.width;
            if (leftSpace < 0 ) {
                NSString* str = [contentStr substringToIndex:i];
                size = [str sizeWithAttributes:sizeAttrs];
                YMAlignLabel* lable = [[YMAlignLabel alloc] init];
                [lable setVerticalAlignment:VerticalAlignmentBottom];
                lable.font = font;
                lable.textColor = color;
                lable.text = str;
                lable.bounds = CGRectMake(0, 0, size.width, size.height);
                [self pushInContainer:lable];
                [self addNewLine];
                [element setContentStr:[contentStr substringFromIndex:i]];
                [self handerLabelElement:element];
                break;
            }
        }
    }
}

-(void) handerImageElement:(YMStringElement *)element
{
    NSString* attr = nil;
    int width = 0, height = 0;
    if ((attr = [element getAttrValue:ATTR_WIDTH])) {
        width = [attr intValue];
    }
    if ((attr = [element getAttrValue:ATTR_HEIGHT])) {
        height = [attr intValue];
    }
    NSString* fileName = nil;
    if ((attr = [element getAttrValue:ATTR_IMAGE])) {
        fileName = attr;
    }
    UIImage* image = [UIImage imageNamed:fileName];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    if (width != 0 && height != 0) {
        imageView.bounds = CGRectMake(0, 0, width, height);
    }
    float w = imageView.bounds.size.width;
    leftSpace -= w;
    if (leftSpace < 0) {
        [self addNewLine];
        leftSpace -= w;
    }
    [self pushInContainer:imageView];
}

-(void) handerEmojElement:(YMStringElement *)element
{
    NSString* attr = nil;
    int width = 0, height = 0;
    if ((attr = [element getAttrValue:ATTR_WIDTH])) {
        width = [attr intValue];
    }
    if ((attr = [element getAttrValue:ATTR_HEIGHT])) {
        height = [attr intValue];
    }
    NSString* name = [element getAttrValue:ATTR_EMOJ];
    NSString* path = nil;
    int numx = 0;
    for (int i = 0; i < 4; ++i) {
        NSString* n = name;
        if (i != 0) {
            n = [name stringByAppendingString:[NSString stringWithFormat:@"@%ix",i]];
        }
        path = [[NSBundle mainBundle]pathForResource:n ofType:@"gif"];
        if (path) {
            numx = i;
            break;
        }
    }
    
    FLAnimatedImageView* imageView = [[FLAnimatedImageView alloc]init];
    NSData* data = [NSData dataWithContentsOfFile:path];
    FLAnimatedImage* image = [FLAnimatedImage animatedImageWithGIFData:data];
    imageView.animatedImage = image;
    CGSize size = image.size;
    if (numx != 0) {
        size = CGSizeMake(size.width / numx, size.height / numx);
    }
    if (width != 0 && height != 0) {
        size = CGSizeMake(width, height);
    }
    //imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.bounds = CGRectMake(0, 0, size.width, size.height);
    leftSpace -= size.width;
    if (leftSpace < 0) {
        [self addNewLine];
        leftSpace -= size.width;
    }
    [self pushInContainer:imageView];
}

-(void) handerLinkElement:(YMStringElement *)element
{
    NSString* attr = nil;
    int fontSize = self.defFontSize;
    if ((attr = [element getAttrValue:ATTR_SIZE])) {
        fontSize = [attr intValue];
    }
    UIColor* color = self.defFontColor;
    if ((attr = [element getAttrValue:ATTR_CORLOR])) {
        color = [self parserColor:attr];
    }
    NSString* linkData = @"";
    if ((attr = [element getAttrValue:ATTR_LINK])) {
        linkData = attr;
    }
    
    NSString* contentStr = [element getContentStr];
    UIFont* font = [UIFont systemFontOfSize:fontSize];
    NSDictionary* sizeAttrs = @{NSFontAttributeName:font};
    CGSize size = [contentStr sizeWithAttributes: sizeAttrs];
    if (size.width < leftSpace) {
        YMLinkLabel* lable = [[YMLinkLabel alloc] init];
        [lable setVerticalAlignment:VerticalAlignmentBottom];
        lable.font = font;
        lable.textColor = color;
        lable.linkData = linkData;
        [lable setText:contentStr];
        [lable addTarget:self.target clickAction:self.action];
        lable.bounds = CGRectMake(0, 0, size.width, size.height);
        [self pushInContainer:lable];
        leftSpace -= size.width;
    }
    else
    {
        for (int i = 0;  i < [contentStr length]; ++i) {
            CGSize size = [[contentStr substringWithRange:NSMakeRange(i, 1)]sizeWithAttributes:sizeAttrs];
            leftSpace -= size.width;
            if (leftSpace < 0 ) {
                NSString* str = [contentStr substringToIndex:i];
                size = [str sizeWithAttributes:sizeAttrs];
                YMLinkLabel* lable = [[YMLinkLabel alloc] init];
                [lable setVerticalAlignment:VerticalAlignmentBottom];
                lable.font = font;
                lable.textColor = color;
                lable.linkData = linkData;
                [lable setText:str];
                [lable addTarget:self.target clickAction:self.action];
                lable.bounds = CGRectMake(0, 0, size.width, size.height);
                [self pushInContainer:lable];
                [self addNewLine];
                [element setContentStr:[contentStr substringFromIndex:i]];
                [self handerLinkElement:element];
                break;
            }
        }
    }
}

-(void) handerDefsetElement:(YMStringElement *)element
{
    NSString* attr = nil;
    if ((attr = [element getAttrValue:ATTR_DEFS])) {
        self.defFontSize = [attr intValue];
    }
    if ((attr = [element getAttrValue:ATTR_DEFC])) {
        self.defFontColor = [self parserColor:attr];
    }
}





@end
