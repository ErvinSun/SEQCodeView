//
//  ViewController.m
//  CodeView
//
//  Created by ervin on 17/5/3.
//  Copyright © 2017年 ervin. All rights reserved.
//

#import "ViewController.h"
#import "SEQCodeView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    SEQCodeView *codeView = [[SEQCodeView alloc]initWithFrame:CGRectMake(100, 100, 200, 50) numOfChart:6];
    codeView.lineColor = [UIColor grayColor];
    codeView.textColor = [UIColor blueColor];
    codeView.textFont  = [UIFont systemFontOfSize:20];
    codeView.codeType = CodeViewTypeCustom;
    codeView.endEditBlcok = ^(NSString *codeString){
        NSLog(@"codeString == %@",codeString);
    };
    [self.view addSubview:codeView];
    
    
    SEQCodeView *codeViewt = [[SEQCodeView alloc]initWithFrame:CGRectMake(100, 200, 200, 50) numOfChart:6];
    codeViewt.lineColor = [UIColor greenColor];
    codeViewt.textColor = [UIColor grayColor];
    codeViewt.textFont  = [UIFont systemFontOfSize:20];
    codeViewt.codeType = CodeViewTypeSecret;
    codeViewt.endEditBlcok = ^(NSString *codeString){
        NSLog(@"codeString == %@",codeString);
    };
    [self.view addSubview:codeViewt];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
