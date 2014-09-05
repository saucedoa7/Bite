//
//  CheckInToTableTableViewCell.m
//  Bite
//
//  Created by Mohit Odhrani on 9/1/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "CheckInToTableTableViewCell.h"

@implementation CheckInToTableTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// Cell Spacing

- (void)setFrame:(CGRect)frame {
    frame.origin.y += 4;
    frame.size.height -= 1 * 2;
    [super setFrame:frame];
}

@end
