/*!
 * \file GSSlideSelectorViewController.h
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import "GSSlidingSelectorDelegate.h"
#import "GSSlidingSelectorDelegate.h"

#import <UIKit/UIKit.h>

@interface GSSlidingSelectorViewController : UIViewController

@property(weak, nonatomic) id<GSSlidingSelectorDelegate> delegate;

/*!
 * \brief Initiate data reloading
 * \see GSSlideSelectorDelegate methods
 */
- (void)reloadData;

@end
