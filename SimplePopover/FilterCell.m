//
//  FilterCell.m
//  SimplePopover
//
//  Created by Gina Mullins on 9/4/13.
//  Copyright (c) 2013 Little Peculiar. All rights reserved.
//

#import "FilterCell.h"

@implementation FilterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // configure cell
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 275, 30)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont fontWithName:@"American Typewriter" size:20.0f];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.titleLabel];
        
        self.selectIndImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 5, 40, 40)];
        self.selectIndImage.image = [UIImage imageNamed:@"check.png"];
        
        [self addSubview:self.selectIndImage];
    }
    return self;
}

@end
