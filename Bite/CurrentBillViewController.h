//
//  CurrentBillViewController.h
//  Bite
//
//  Created by Mohit Odhrani on 8/25/14.
//  Copyright (c) 2014 Bite. All rights reserved.
//

#import "LaunchViewController.h"
#import "CurrentBillViewController.h"

@interface CurrentBillViewController : LaunchViewController
@property NSString *oneTableNumber;
@property int tableNumber;
@property PFObject *resaurantObject;
@property NSMutableArray *listOfFriends;
@end
