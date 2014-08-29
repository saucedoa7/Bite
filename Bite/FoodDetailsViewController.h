//
//  FoodDetailsViewController.h
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "LaunchViewController.h"

@interface FoodDetailsViewController : LaunchViewController
@property NSString *itemName;
@property NSString *itemDescription;
@property NSNumber *itemPrice;
@property PFFile *foodImage;

@end
