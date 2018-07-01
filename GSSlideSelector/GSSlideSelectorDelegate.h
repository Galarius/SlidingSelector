/*!
 * \file GSSlideSelectorDelegate.h
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class GSSlideSelectorViewController;

@protocol GSSlideSelectorDelegate <NSObject>

@required
/*!
 * \brief Number of items that will be displayed in slide selector.
 */
- (NSUInteger)numberOfItemsInSlideSelector:(GSSlideSelectorViewController*)selector;
/*!
 * \brief Title for each item
 * \see numberOfItemsInSlideSelector:
 */
- (NSString *)slideSelector:(GSSlideSelectorViewController*)selector titleForItemAtIndex:(NSUInteger)index;
/*!
 * \brief Called when item selected in slide selector
 */
- (void)slideSelector:(GSSlideSelectorViewController*)selector didSelectItemAtIndex:(NSUInteger)index;

@end
