//
//  SwiftToObjcVC.m
//  ObjcMixSwiftUI
//
//  Created by chenhao on 2022/11/10.
//

#import "SwiftToObjcVC.h"

@interface SwiftToObjcVC ()

@end

@implementation SwiftToObjcVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [btn setTitle:@"点击传参到SwfitUI" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 200, 40);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(itemCLick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"返回SwiftUI" forState:UIControlStateNormal];
    [btn2 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    btn2.frame = CGRectMake(100, 400, 200, 40);
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(itemCLick2) forControlEvents:UIControlEventTouchUpInside];
    
}

/// 点击返回
-(void)itemCLick2{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onBackClick)]){
        [self.delegate onBackClick];
    }
}

/// 点击传参
-(void)itemCLick{
    if(self.delegate && [self.delegate respondsToSelector:@selector(onClick:)]){
        [self.delegate onClick:arc4random_uniform(100)];
    }
}
@end
