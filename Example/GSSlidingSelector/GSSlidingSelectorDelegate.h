/*!
 * \file GSSlideSelectorDelegate.h
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

@import Foundation.NSObject;

@class GSSlidingSelectorViewController;

@protocol GSSlidingSelectorDelegate <NSObject>

@required

/*!
 * \brief Called when item selected in slide selector
 */
- (void)slideSelector:(GSSlidingSelectorViewController*)selector didSelectItemAtIndex:(NSUInteger)index;

@end
