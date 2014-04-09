//
//  STMMovieTableViewCell.m
//  STMQuickRestKit
//
//  Created by Stefano Mondino on 19/03/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import "STMMovieTableViewCell.h"

@implementation STMMovieTableViewCell

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

@end
