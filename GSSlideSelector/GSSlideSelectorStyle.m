/*!
 * \file GSSlideSelectorStyle.h
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import "GSSlideSelectorStyle.h"

static const NSInteger GSMainFontSize = 18;
static const NSInteger GSSubFontSize = 16;

@implementation GSSlideSelectorStyle

- (id)init
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
            _mainFont = [UIFont fontWithName:@"titilliumweb-semibold" size:GSMainFontSize];
            _subFont = [UIFont fontWithName:@"titilliumweb-regular" size:GSSubFontSize];
        } else {
            NSLog(@"%@ is not installed! Selecting 'Helvetica'...", customFont);
            _mainFont = [UIFont fontWithName:@"Helvetica" size:GSMainFontSize];
            _subFont = [UIFont fontWithName:@"Helvetica" size:GSSubFontSize];
        }
        // Setup other style consts
        _mainColor = [UIColor colorWithRed:240/255.0f green:235/255.0f blue:180/255.0f alpha:1.0f];
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
    tField.backgroundColor = self.mainColor;
    tField.textAlignment = NSTextAlignmentCenter;
    tField.textColor = [UIColor darkGrayColor];
    tField.returnKeyType = UIReturnKeyDone;
    tField.userInteractionEnabled = NO;
    tField.font = self.mainFont;
    tField.opaque = YES;
    tField.text = text;
    return tField;
}

@end
