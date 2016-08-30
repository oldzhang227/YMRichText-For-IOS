//
//  UILYMLabel.h
//  TestOC
//
//  Created by zhangxinwei on 16/8/25.
//  Copyright © 2016年 zhangxinwei. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop=0,
    VerticalAlignmentMiddle,//default
    VerticalAlignmentBottom,
    
}VerticalAlignment;

@interface YMAlignLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property(nonatomic)VerticalAlignment verticalAlignment;

@end