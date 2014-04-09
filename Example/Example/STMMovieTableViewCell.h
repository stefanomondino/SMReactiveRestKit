//
//  SMMovieTableViewCell.h
//  SMQuickRestKit
//
//  Created by Stefano Mondino on 19/03/14.
//  Copyright (c) 2014 Stefano Mondino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STMMovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_poster;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_genre;

@end
