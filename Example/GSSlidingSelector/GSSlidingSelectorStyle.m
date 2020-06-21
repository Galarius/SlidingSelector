/*!
 * \file GSSlideSelectorStyle.h
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import "GSSlidingSelectorStyle.h"

static const NSInteger GSMainFontSize = 32;

@implementation GSSlidingSelectorStyle

- (instancetype)init
{
    self = [super init];
    if(self) {
        // Check if specific custom fonts are available
        NSString *customFont = @"Titillium Web";
        // Check if custom font is installed
        NSArray *familyNames = [UIFont familyNames];
        NSUInteger index = [familyNames indexOfObject:customFont];
        if(index != NSNotFound) {
            NSLog(@"%@ is installed!", customFont);
            _mainFont = [UIFont fontWithName:@"titilliumweb-regular" size:GSMainFontSize];
        } else {
            NSLog(@"%@ is not installed! Selecting 'Helvetica'...", customFont);
            _mainFont = [UIFont fontWithName:@"Helvetica" size:GSMainFontSize];
        }
        // Setup other style consts
        _mainColor = [UIColor colorWithRed:240/255.0f green:235/255.0f blue:180/255.0f alpha:1.0f];
        _holdTouchColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.2f];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}

- (UITextField*)createTextFieldWithText:(NSString *)text;
{
    UITextField *tField = [[UITextField alloc] init];
    tField.backgroundColor = [UIColor clearColor];
    tField.textAlignment = NSTextAlignmentCenter;
    tField.textColor = [UIColor blackColor];
    tField.returnKeyType = UIReturnKeyDone;
    tField.userInteractionEnabled = NO;
    tField.font = self.mainFont;
    tField.opaque = YES;
    tField.text = text;
    return tField;
}

@end
