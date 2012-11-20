//
//  SplitViewBarButtonItem.h
//  FlickrBrowser
//
//  Created by Zshcbka on 10/15/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.

//  This is a protocol which is adopted by the detail view (ShowImageVC) to display a bar button item

#import <UIKit/UIKit.h>

@protocol SplitViewBarButtonItemPresenter <NSObject>
@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;

@end
