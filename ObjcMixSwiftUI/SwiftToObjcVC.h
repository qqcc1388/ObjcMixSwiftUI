//
//  SwiftToObjcVC.h
//  ObjcMixSwiftUI
//
//  Created by chenhao on 2022/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SwiftToObjcVCDelegate <NSObject>

/// 点击回调
-(void)onClick:(NSInteger)value;

/// 点击返回
-(void)onBackClick;

@end


@interface SwiftToObjcVC : UIViewController

@property (nonatomic,assign) id<SwiftToObjcVCDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
