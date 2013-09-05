//
//  FilterView.m
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 Little Peculiar. All rights reserved.
//

#import "FilterView.h"
#import "FilterCell.h"


// NSDictionary keys
#define kKEY_TITLE     @"title"
#define kKEY_SELECT    @"isSelected"

// customize table cells
NSString * const REUSE_FILTER_ID = @"FilterCell";


@interface FilterView ()

// creating UI programmatically
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UITableView *listTable;
@property (nonatomic, strong) UIButton *noFilterButton;
@property (nonatomic, strong) UIImageView *selectIndImage;

- (void)createMainView;

@end


@implementation FilterView

- (void)loadView
{
    [super loadView];
    
    [self createMainView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if (self.listArray == nil)
        self.listArray = [[NSArray alloc] init];
    if (self.titlesArray == nil)
        self.titlesArray = [[NSMutableArray alloc] init];
    if (self.selectedArray == nil)
        self.selectedArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.selectIndImage.hidden = NO;
    [self.noFilterButton setSelected:YES];
    [self loadListTable];
}

// load and set all items as not selected
- (void)loadListTable
{
    [self.titlesArray removeAllObjects];
    [self.selectedArray removeAllObjects];
    
    for (NSString *itemTitle in self.listArray)
    {
        NSDictionary *item = @{kKEY_TITLE:itemTitle, kKEY_SELECT:[NSNumber numberWithBool:NO]};
        [self.titlesArray addObject:item];
    }
    
    [self.listTable reloadData];
    
    if ([self.titlesArray count] > 0)
    {
        [self.listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:0 animated:NO];
    }
}

- (void)createMainView
{
    // create mainView
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 600)];
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.mainView];
    
    // create a container view for header and noFilter stuff
    UIView *container =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 350, 135)];
    [container setBackgroundColor:[UIColor clearColor]];
    [self.mainView addSubview:container];
    
    // add header to container
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 350, 75)];
    [headerLabel setBackgroundColor:[UIColor darkGrayColor]];
    [container addSubview:headerLabel];
    
    // add header title to container
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 40)];
    [titleLabel setText:@"Choose Filter:"];
    [titleLabel setFont:[UIFont fontWithName:@"American Typewriter" size:30]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [container addSubview:titleLabel];
    
    // add header button to container
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"genbutton.png"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(goBack:)forControlEvents:UIControlEventTouchDown];
    [doneButton setFrame:CGRectMake(260, 17, 75, 40)];
    [container addSubview:doneButton];
    
    // add filter button to container - make it look like a normal table row
    self.noFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.noFilterButton setBackgroundImage:[UIImage imageNamed:@"cell_top.png"] forState:UIControlStateNormal];
    [self.noFilterButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.noFilterButton addTarget:self action:@selector(noFilter:)forControlEvents:UIControlEventTouchDown];
    [self.noFilterButton setFrame:CGRectMake(0, 75, 350, 60)];
    [container addSubview:self.noFilterButton];
    
    // add noFilter label on top of button, or so it will seems...
    UILabel *noFilterLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 100, 30)];
    [noFilterLabel setText:@"NO Filter:"];
    [noFilterLabel setFont:[UIFont systemFontOfSize:20]];
    [noFilterLabel setTextColor:[UIColor blackColor]];
    [noFilterLabel setBackgroundColor:[UIColor clearColor]];
    [container addSubview:noFilterLabel];
    
    // add selection image
    self.selectIndImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 85, 40, 40)];
    [self.selectIndImage setImage:[UIImage imageNamed:@"check.png"]];
    [container addSubview:self.selectIndImage];
    
    // add the table and we're done
    self.listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, 350, 465) style:UITableViewStylePlain];
    [self.listTable setDataSource:self];
    [self.listTable setDelegate:self];
    [self.listTable setBackgroundColor:[UIColor clearColor]];
    [self.listTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.mainView addSubview:self.listTable];
}

// method to customize table cells
- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath*)indexPath withRowCount:(NSInteger)rowCount
{
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0)
    {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    else if (rowIndex == rowCount - 1)
    {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    }
    else
    {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}

// make this a simple toggle
- (IBAction)noFilter:(id)sender
{
    self.noFilterButton.selected = !self.noFilterButton.selected;
    
    if (self.noFilterButton.selected)
    {
        self.selectIndImage.hidden = NO;
        [self loadListTable];   // reset the table
    }
    else
    {
        self.selectIndImage.hidden = YES;
    }
}

- (IBAction)goBack:(id)sender
{
    // notify SecondViewController we are done with our classes
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissFilterView:)])
    {
        [self.delegate dismissFilterView:self.selectedArray];
    }
    else
        NSLog(@"FilterView::no one is listening:%@", self.delegate);
}


#pragma mark Table Data Source and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titlesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterCell *cell = (FilterCell *)[self.listTable dequeueReusableCellWithIdentifier:REUSE_FILTER_ID];
    if (cell == nil)
    {
        cell = [[FilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REUSE_FILTER_ID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    }
    
    [self configureFilterCell:(FilterCell *)cell forRowAtIndexPath:indexPath];
    return cell;
}

// configure the cells for classes - only filter for now
- (void)configureFilterCell:(FilterCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.titlesArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [item valueForKey:kKEY_TITLE];
    BOOL isSelected = [[item valueForKey:kKEY_SELECT] boolValue];
    
    if (isSelected == NO)
    {
        [cell.selectIndImage setHidden:YES];
    }
    else
    {
        [cell.selectIndImage setHidden:NO];
    }
    
    // customize the cell background
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath withRowCount:[self.titlesArray count]];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cell.backgroundView = cellBackgroundView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // check or uncheck the cell
    FilterCell *cell = (FilterCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *item = [self.titlesArray objectAtIndex:indexPath.row];
    NSString *itemTitle = [item valueForKey:kKEY_TITLE];
    BOOL isSelected = [[item valueForKey:kKEY_SELECT] boolValue];
    
    if (isSelected == NO)
    {
        [cell.selectIndImage setHidden:NO];
        [self.selectedArray addObject:itemTitle];
        
        self.selectIndImage.hidden = YES;
        [self.noFilterButton setSelected:NO];
    }
    else
    {
        [cell.selectIndImage setHidden:YES];
        [self.selectedArray removeObject:itemTitle];
    }
    
    isSelected = !isSelected;
    NSDictionary *replace = @{kKEY_TITLE:itemTitle, kKEY_SELECT:[NSNumber numberWithBool:isSelected]};
    [self.titlesArray replaceObjectAtIndex:indexPath.row withObject:replace];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;      // all other cell heights
}

- (NSString *)reuseFilterIDForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // return the custom cell
    return REUSE_FILTER_ID;
}

- (void) dealloc
{
    NSLog(@"Dealloc FilterViewController");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"** didReceiveMemoryWarning FilterViewConroller ****");
    
    self.delegate = nil;
    self.listArray = nil;
    self.titlesArray = nil;
    self.selectedArray = nil;
    self.listTable = nil;
    self.selectIndImage = nil;
    self.noFilterButton = nil;
}

@end
