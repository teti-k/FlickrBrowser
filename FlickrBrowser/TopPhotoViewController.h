//
//  TopPhotoViewController.h
//  FlickrBrowser
//
//  Created by Zshcbka on 10/5/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopPhotoViewController : UITableViewController 
@property (nonatomic,strong) NSArray *photos; //array of photo Dictionaries
@property (nonatomic,strong) NSDictionary *selectedLocation; //used to segue the selected location from FirstTVC
@property (nonatomic,weak) NSString *title; //used to segue From FirstVC a location title for navigation item

@end