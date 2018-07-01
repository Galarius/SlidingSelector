/*!
 * \file GSSlideSelectorStyle.h
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import <UIKit/UIKit.h>

#define GSSlideSelectorStyleKit [GSSlideSelectorStyle sharedInstance]

@interface GSSlideSelectorStyle : NSObject

@property (nonatomic, strong) UIFont *mainFont;
@property (nonatomic, strong) UIFont *subFont;
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) UIColor *holdTouchColor;

+ (instancetype)sharedInstance;

- (UITextField*)createTextFieldWithText:(NSString *)text;

@end
