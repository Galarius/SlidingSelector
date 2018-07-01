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
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedItem;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _items = @[@"Winter", @"Spring", @"Summer", @"Autumn"];
    _selector = [[GSSlideSelectorViewController alloc] init];
    self.selector.delegate = self;
    [self addChildViewController:self.selector];
    [self.view addSubview:self.selector.view];
    [self.selector didMoveToParentViewController:self];
    
    _lblSelectedItem.font = [GSSlideSelectorStyleKit mainFont];
    _lblSelectedItem.text = [self.items firstObject];
    _lblSelectedItem.backgroundColor = [UIColor clearColor];
    _lblSelectedItem.textColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.selector.view.frame = CGRectMake(0, 40, CGRectGetWidth(self.view.frame), 60);
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
    _lblSelectedItem.text = [self.items objectAtIndex:index];
    switch (index) {
        case 0:
            self.view.backgroundColor = [UIColor blueColor];
            _lblSelectedItem.textColor = [UIColor whiteColor];
            break;
        case 1:
            self.view.backgroundColor = [UIColor greenColor];
            _lblSelectedItem.textColor = [UIColor blackColor];
            break;
        case 2:
            self.view.backgroundColor = [UIColor yellowColor];
            _lblSelectedItem.textColor = [UIColor blackColor];
            break;
        case 3:
            self.view.backgroundColor = [UIColor redColor];
            _lblSelectedItem.textColor = [UIColor whiteColor];
            break;
    }
}

@end
