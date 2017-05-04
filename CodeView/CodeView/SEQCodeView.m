//
//  SEQCodeView.m
//  YMShiHang
//
//  Created by ervin on 17/5/3.
//  Copyright © 2017年 ervin. All rights reserved.
//

#import "SEQCodeView.h"
#import "NSString+Category.h"
#define Space 5  //间隔
#define LineWidth (self.frame.size.width - self.lineNum * 2 * Space)/self.lineNum //下划线宽
#define LineHeight 2 //下划线高
#define LineBottomHeight 5 //下标线距离底部高度
#define RADIUS 5 //密码风格 圆点半径
@interface SEQCodeView() <UITextFieldDelegate>

/**
 用于存放每个字符
 */
@property (nonatomic, strong) NSMutableArray *textArr;

/**
 个数
 */
@property (nonatomic, assign) NSInteger lineNum;

/**
 输入框
 */
@property (nonatomic, strong) UITextField *textField;
@end

@implementation SEQCodeView

- (instancetype)initWithFrame:(CGRect)frame numOfChart:(NSInteger)num {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textArr = [NSMutableArray new];
        self.lineNum = num;
        self.codeType = CodeViewTypeCustom;//样式默认明文
        
        self.textField = [[UITextField alloc] init];
        self.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.textField.hidden = YES;
        self.textField.delegate = self;
        [self addSubview:self.textField];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit)];
        [self addGestureRecognizer:tapGesture];
        
        [self beginEdit];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self lineToSubView];
}
- (void)setKeyBoardType:(UIKeyboardType)keyBoardType{
    self.textField.keyboardType = keyBoardType;
}
/**
 添加下划线
 */
- (void)lineToSubView{
    for (int i = 0; i < self.lineNum; i ++) {
        CAShapeLayer *lineShapeLayer = [CAShapeLayer layer];
        lineShapeLayer.fillColor = self.lineColor.CGColor;
        UIBezierPath *linePath = [UIBezierPath bezierPathWithRect:CGRectMake(Space * (2 * i + 1) + i * LineWidth, self.frame.size.height - LineBottomHeight, LineWidth, LineHeight)];
        lineShapeLayer.path = linePath.CGPath;
        lineShapeLayer.hidden = self.textArr.count > i;
        [self.layer addSublayer:lineShapeLayer];
    }
}

/**
 重新绘制
 */
- (void)drawRect:(CGRect)rect{
    switch (self.codeType) {
        case CodeViewTypeCustom:
            [self codeViewCustom];
            break;
        case CodeViewTypeSecret:
            [self codeViewSecret];
            break;
        default:
            break;
    }
}

/**
 明文绘制
 */
- (void)codeViewCustom{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < self.textArr.count; i ++ ) {
        NSString *numString = [self.textArr objectAtIndex:i];
        CGFloat wordWidth = [numString stringSizeWithFont:self.textFont Size:CGSizeMake(MAXFLOAT, self.textFont.lineHeight)].width;
        
        CGFloat startX = self.frame.size.width/self.lineNum * i + (self.frame.size.width/self.lineNum - wordWidth)/2;
        CGFloat startY = (self.frame.size.height - self.textFont.lineHeight - LineBottomHeight - LineHeight)/2;
        [numString drawInRect:CGRectMake(startX, startY, wordWidth, self.textFont.lineHeight + 5) withAttributes:@{NSFontAttributeName:self.textFont,NSForegroundColorAttributeName:self.textColor}];
    }
    CGContextDrawPath(context, kCGPathFill);
}

/**
 密文绘制
 */
- (void)codeViewSecret{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < self.textArr.count ;  i ++) {
        CGFloat pointX = self.frame.size.width/self.lineNum/2 * (2 * i + 1);
        CGFloat pointY = self.frame.size.height/2;
        CGContextAddArc(context, pointX, pointY, RADIUS, 0, 2*M_PI, 0);
    }
    CGContextDrawPath(context, kCGPathFill);
}
#pragma mark - textfield
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self endEdit];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location > self.lineNum - 1) {
        return NO;
    }
    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        
        if (character < 48) return NO; // 48 unichar for 0
        
        if (character > 57 && character < 65) return NO; //
        
        if (character > 90 && character < 97) return NO;
        
        if (character > 122) return NO;
        
    }
    
    NSInteger length = range.location;
    if (length == self.textArr.count) {
        [self.textArr addObject:string];
    }else{
        [self.textArr removeLastObject];
    }
    //需要重新绘制
    [self setNeedsDisplay];
    
    if (self.textArr.count == self.lineNum && self.endEditBlcok) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *checkString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            NSLog(@"codeString === %@",checkString);
            [self endEdit];
            self.endEditBlcok(checkString);
        });
    }
    
    return YES;
}

/**
 开始编辑，弹出键盘
 */
- (void)beginEdit{
    [self.textField becomeFirstResponder];
}

/**
 结束编辑
 */
- (void)endEdit {
    [self.textField resignFirstResponder];
}
@end
