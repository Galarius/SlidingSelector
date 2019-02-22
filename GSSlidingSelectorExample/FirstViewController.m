/*!
 * \file FirstViewController.m
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import "GSSlidingSelectorViewController.h"
#import "GSSlidingSelector-Swift.h"
#import "FirstViewController.h"

const static NSUInteger GSDefaultSelectedIndex = 3;   // [1 - 7]
const static CGFloat GSTransformImageAnimationTime = 0.4f;

@interface FirstViewController () <GSSlidingSelectorDelegate, GSSlidingSelectorDataSource>

@property (strong, nonatomic) NSArray *items;

@property (strong, nonatomic) GSSlidingSelectorViewController *selector;

@property (strong, nonatomic) UIImageView *imgViewLeft;
@property (strong, nonatomic) UIImageView *imgViewSelected;
@property (strong, nonatomic) UIImageView *imgViewRight;

@property (strong, nonatomic) NSArray *constraintsPortraitArray;
@property (strong, nonatomic) NSArray *constraintsLandscapeArray;

@property (nonatomic) NSUInteger prevSelectedIndex;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = GSSlidingSelectorStyle.shared.mainColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tabBarController.tabBar.backgroundColor = [UIColor yellowColor];
    
    _items = @[@"Mercury",@"Venus",@"Earth",@"Mars",@"Jupiter",@"Saturn",@"Uranus",@"Neptune",@"Pluto"];
    
    // Create GSSlidingSelectorViewController
    _selector = [[GSSlidingSelectorViewController alloc] init];
    self.selector.delegate = self;
    self.selector.dataSource = self;
    [self addChildViewController:self.selector];
    [self.view addSubview:self.selector.view];
    [self.selector didMoveToParentViewController:self];

    // Create Image Views
    _imgViewSelected = [[UIImageView alloc] init];
    self.imgViewSelected.contentMode = UIViewContentModeScaleAspectFit;
    self.imgViewSelected.clipsToBounds = YES;
    [self.view addSubview:self.imgViewSelected];
    
    _imgViewLeft = [[UIImageView alloc] init];
    self.imgViewLeft.contentMode = UIViewContentModeScaleAspectFit;
    self.imgViewLeft.clipsToBounds = YES;
    [self.view addSubview:self.imgViewLeft];
    
    _imgViewRight = [[UIImageView alloc] init];
    self.imgViewRight.contentMode = UIViewContentModeScaleAspectFit;
    self.imgViewRight.clipsToBounds = YES;
    [self.view addSubview:self.imgViewRight];
    
    [self.selector reloadData];
    self.selector.selectedIndex = GSDefaultSelectedIndex;
    
    // Set default images
    self.prevSelectedIndex = GSDefaultSelectedIndex;
    self.imgViewLeft.image     = [self imageFromIndex:GSDefaultSelectedIndex-1];
    self.imgViewSelected.image = [self imageFromIndex:GSDefaultSelectedIndex];
    self.imgViewRight.image    = [self imageFromIndex:GSDefaultSelectedIndex+1];
    
    // Setup Constraints Programmatically
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    [self installConstraintForOrientation:orientation];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        [self installConstraintForOrientation:orientation];
        
        if(UIInterfaceOrientationIsLandscape(orientation)) {
            self.imgViewLeft.contentMode = UIViewContentModeCenter;
            self.imgViewSelected.contentMode = UIViewContentModeCenter;
            self.imgViewRight.contentMode = UIViewContentModeCenter;
        } else {
            self.imgViewLeft.contentMode = UIViewContentModeScaleAspectFit;
            self.imgViewSelected.contentMode = UIViewContentModeScaleAspectFit;
            self.imgViewRight.contentMode = UIViewContentModeScaleAspectFit;
        }
        
    } completion:nil];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (BOOL)isiPhoneXType
{
    CGFloat h = [UIScreen mainScreen].nativeBounds.size.height;
    if(h == 2436 /*iPhone X, Xs*/ ||
       h == 2688 /*iPhone Xs Max*/ ||
       h == 1792 /*iPhone Xr*/) {
        return YES;
    }
    return NO;
}

- (void)setupConstraints
{
    self.selector.view.translatesAutoresizingMaskIntoConstraints   = NO;
    self.imgViewLeft.translatesAutoresizingMaskIntoConstraints     = NO;
    self.imgViewSelected.translatesAutoresizingMaskIntoConstraints = NO;
    self.imgViewRight.translatesAutoresizingMaskIntoConstraints    = NO;
    
    NSDictionary *views = @{@"selectorView"    : self.selector.view,
                            @"imgViewLeft"     : self.imgViewLeft,
                            @"imgViewSelected" : self.imgViewSelected,
                            @"imgViewRight"    : self.imgViewRight,
                            };
    
    // Install fixed constraints
    CGFloat top;
    NSArray *constraints;
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[selectorView]|"
                                                          options:0 metrics:nil views:views];
    [self.view addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[imgViewLeft]-[imgViewSelected(==imgViewLeft)]-[imgViewRight(==imgViewLeft)]-|" options:0 metrics:nil views:views];
    [self.view addConstraints:constraints];
    
    // Save portrait constraints
    top = [self isiPhoneXType] ? 40.0 : 20.0;
    _constraintsPortraitArray = @[
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[selectorView(==50)]-10-[imgViewLeft]-10-|"
                                              options:0 metrics:@{@"top":@(top)} views:views],
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[selectorView(==50)]-10-[imgViewSelected]-10-|"
                                              options:0 metrics:@{@"top":@(top)} views:views],
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[selectorView(==50)]-10-[imgViewRight]-10-|"
                                              options:0 metrics:@{@"top":@(top)} views:views],
                                  ];
    // Save landscape constraints
    top = [self isiPhoneXType] ? 0.0 : 20.0;
    _constraintsLandscapeArray = @[
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[selectorView(==50)]-10-[imgViewLeft]-10-|"
                                              options:0 metrics:@{@"top":@(top)} views:views],
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[selectorView(==50)]-10-[imgViewSelected]-10-|"
                                              options:0 metrics:@{@"top":@(top)} views:views],
      [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[selectorView(==50)]-10-[imgViewRight]-10-|"
                                              options:0 metrics:@{@"top":@(top)} views:views],
                                  ];
}

- (void)installConstraintForOrientation:(UIInterfaceOrientation)orientation
{
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        for(NSArray *constraints in self.constraintsPortraitArray)
            [self.view removeConstraints:constraints];
        for(NSArray *constraints in self.constraintsLandscapeArray)
            [self.view addConstraints:constraints];
    } else {
        for(NSArray *constraints in self.constraintsLandscapeArray)
            [self.view removeConstraints:constraints];
        for(NSArray *constraints in self.constraintsPortraitArray)
            [self.view addConstraints:constraints];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)imageFromIndex:(NSUInteger)index
{
    NSString *name = [self.items objectAtIndex:index];
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", name]];
}

#pragma mark - GSSlidingSelectorDataSource

- (NSUInteger)numberOfItemsInSlideSelector:(GSSlidingSelectorViewController*)selector
{
    return self.items.count;
}

- (NSString *)slideSelector:(GSSlidingSelectorViewController*)selector titleForItemAtIndex:(NSUInteger)index
{
    return [self.items objectAtIndex:index];
}

#pragma mark - GSSlideSelectorDelegate

- (void)slideSelector:(GSSlidingSelectorViewController*)selector didSelectItemAtIndex:(NSUInteger)index
{
    if(index == self.prevSelectedIndex) {
        return;
    }
    
    NSLog(@"[GSSlidingSelectorViewController] Selected item at index: %lu (%@)",
          (unsigned long)index, [self.items objectAtIndex:index]);
    
    UIImage *prevImage = nil;
    UIImage *selectedImage = nil;
    UIImage *nextImage = nil;
    
    if(index > 0) {
        prevImage = [self imageFromIndex:index-1];
    }
    selectedImage = [self imageFromIndex:index];
    if(index < self.items.count-1) {
        nextImage = [self imageFromIndex:index+1];
    }
    
    [UIView transitionWithView:self.imgViewLeft
                      duration:GSTransformImageAnimationTime
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.imgViewLeft.image = prevImage;
                    } completion:nil];
    
    [UIView transitionWithView:self.imgViewSelected
                      duration:GSTransformImageAnimationTime
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.imgViewSelected.image = selectedImage;
                    } completion:nil];
    
    [UIView transitionWithView:self.imgViewRight
                      duration:GSTransformImageAnimationTime
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        self.imgViewRight.image = nextImage;
                    } completion:nil];
    
    self.prevSelectedIndex = index;
}

@end
