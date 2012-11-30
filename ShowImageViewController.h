//
//  ShowImageViewController.h
//  FlickrBrowser
//
//  Created by Zshcbka on 10/6/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"
#import "VacationPlanNameController.h"

@interface ShowImageViewController : UIViewController <SplitViewBarButtonItemPresenter,  UISplitViewControllerDelegate>
@property (nonatomic,strong) NSDictionary *selectedImage; //used to segue from TopPhotoVC
@property (nonatomic,weak) NSString *imageTitle; //image title will be displayed on navigation panel
@property (nonatomic, strong) UIManagedDocument *vacationDatabase;
- (void)downloadImage:(NSDictionary *)photo;
@end
