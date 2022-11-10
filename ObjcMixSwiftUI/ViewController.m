//
//  ViewController.m
//  ObjcMixSwiftUI
//
//  Created by chenhao on 2022/11/10.
//

#import "ViewController.h"
#import "ObjcMixSwiftUI-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"导航栏";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击打开swiftUI页面" forState:UIControlStateNormal];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 400, 200, 40);
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(itemCLick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)itemCLick{
    UIViewController *vc = [[TestViewController alloc] createTestViewController];
    [self.navigationController pushViewController:vc animated:YES];
    [vc.navigationController setNavigationBarHidden:YES];
}

@end
