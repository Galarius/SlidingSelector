/*!
 * \file FirstViewController.m
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import "FirstViewController.h"
#import "GSSlideSelectorViewController.h"
#import "GSSlideSelectorStyle.h"

@interface FirstViewController () <GSSlideSelectorDelegate>

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) GSSlideSelectorViewController *selector;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _items = @[@"Earth", @"Moon", @"Mars", @"Neptune"];
    _selector = [[GSSlideSelectorViewController alloc] init];
    self.selector.delegate = self;
    [self addChildViewController:self.selector];
    [self.view addSubview:self.selector.view];
    [self.selector didMoveToParentViewController:self];
    
    self.imgView.image = [UIImage imageNamed:[self.items firstObject]];
    
    self.view.backgroundColor = GSSlideSelectorStyleKit.mainColor;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.selector.view.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 50);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GSSlideSelectorDelegate

- (NSUInteger)numberOfItemsInSlideSelector:(GSSlideSelectorViewController*)selector
{
    return self.items.count;
}

- (NSString *)slideSelector:(GSSlideSelectorViewController*)selector titleForItemAtIndex:(NSUInteger)index
{
    return [self.items objectAtIndex:index];
}

- (void)slideSelector:(GSSlideSelectorViewController*)selector didSelectItemAtIndex:(NSUInteger)index
{
    NSLog(@"Selected item at index: %lu (%@)", (unsigned long)index, [self.items objectAtIndex:index]);
    self.imgView.image = [UIImage imageNamed:[self.items objectAtIndex:index]];
}

@end
