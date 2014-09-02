//
//  RestaurantSearchResultTableViewCell.h
//  Bite
//
//  Created by Mohit Odhrani on 8/26/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantSearchResultTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *restaurantProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *restaurantNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cuisineLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *contactNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *cellBackground;

@end
