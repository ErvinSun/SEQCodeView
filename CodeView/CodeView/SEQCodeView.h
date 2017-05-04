//
//  SEQCodeView.h
//  YMShiHang
//
//  Created by ervin on 17/5/3.
//  Copyright © 2017年 ervin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CodeViewType) {
    CodeViewTypeCustom,//普通样式
    CodeViewTypeSecret//密文样式
};
@interface SEQCodeView : UIView
/**
 输入完成回调
 */
@property (nonatomic, copy) void(^endEditBlcok)(NSString *codeText);

/**
 样式,CodeViewTypeCustom 为明文样式
    CodeViewTypeSecret 为密文样式
 */
@property (nonatomic, assign) CodeViewType codeType;

/**
 下划线颜色
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 字体颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 字体大小
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 键盘类型
 */
@property (nonatomic, assign) UIKeyboardType keyBoardType;

/**
 初始化
 
 @param frame frame
 @param num 输入个数
 @return CodeView
 */
- (instancetype)initWithFrame:(CGRect)frame numOfChart:(NSInteger)num;
@end
