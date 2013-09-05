//
//  ViewController.m
//  SimplePopover
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 Little Peculiar. All rights reserved.
//

#import "ViewController.h"
#import "FilterView.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController () <UIPopoverControllerDelegate, FilterCompleteDelegate>
{
    NSArray *_listArray;
    UIPopoverController *_popoverController;
    FilterView *_filterController;
}

- (IBAction)showFilterOptions:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // add list to test data
    _listArray = @[@"Soccer", @"Football", @"Baseball", @"Tennis", @"Swimming", @"Running", @"Walking"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showFilterOptions:(id)sender
{
    // setup the viewController for filtering by class
    if (_filterController == nil)
    {
        _filterController = [[FilterView alloc] init];
        _filterController.listArray = [NSArray arrayWithArray:_listArray];
        [_filterController setDelegate:self];
    }
    
    if (_popoverController == nil)
    {
        _popoverController = [[UIPopoverController alloc] initWithContentViewController:_filterController];
        [_popoverController setDelegate:self];
    }
    
    _popoverController.passthroughViews = [NSArray arrayWithObject:self.view];       // lockdown
    [_popoverController setPopoverContentSize:CGSizeMake(350, 600) animated:YES];
    [_popoverController presentPopoverFromRect:CGRectMake(470, 310, 100, 100)
                                        inView:self.view permittedArrowDirections:0 animated:YES];
}

// delegate method from FilterViewController
- (void)dismissFilterView:(NSMutableArray*)filteredArray
{
    // dismiss the filter popover
    [_popoverController dismissPopoverAnimated:YES];
    
    // do something with selected list of items
    NSLog(@"nbr of items selected from filtered list: %i", filteredArray.count);
}

@end
