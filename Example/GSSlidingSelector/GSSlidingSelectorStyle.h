/*!
 * \file GSSlideSelectorStyle.h
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

@import Foundation.NSObject;

@import UIKit.UIFont;
@import UIKit.UIColor;
@import UIKit.UITextField;

#define GSSlidingSelectorStyleKit [GSSlidingSelectorStyle sharedInstance]

@interface GSSlidingSelectorStyle : NSObject

@property (nonatomic, strong) UIFont *mainFont;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) UIColor *holdTouchColor;

+ (instancetype)sharedInstance;

- (UITextField *)createTextFieldWithText:(NSString *)text;

@end
