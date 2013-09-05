//
//  FilterView.h
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 Little Peculiar. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FilterCompleteDelegate <NSObject>
@required
- (void)dismissFilterView:(NSMutableArray*)filteredArray;
@end


@interface FilterView : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id <FilterCompleteDelegate> delegate;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;

- (IBAction)noFilter:(id)sender;
- (IBAction)goBack:(id)sender;

- (void)loadListTable;


@end
