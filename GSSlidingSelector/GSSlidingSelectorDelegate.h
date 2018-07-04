/*!
 * \file GSSlideSelectorDelegate.h
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class GSSlidingSelectorViewController;

@protocol GSSlidingSelectorDelegate <NSObject>

@required
/*!
 * \brief Number of items that will be displayed in slide selector.
 */
- (NSUInteger)numberOfItemsInSlideSelector:(GSSlidingSelectorViewController*)selector;
/*!
 * \brief Title for each item
 * \see numberOfItemsInSlideSelector:
 */
- (NSString *)slideSelector:(GSSlidingSelectorViewController*)selector titleForItemAtIndex:(NSUInteger)index;
/*!
 * \brief Called when item selected in slide selector
 */
- (void)slideSelector:(GSSlidingSelectorViewController*)selector didSelectItemAtIndex:(NSUInteger)index;

@end
