//
//  VisitUnvisitButtonController.h
//  FlickrBrowser
//
//  Created by Zshcbka on 11/12/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VisitUnvisitButtonController : NSObject
@property (nonatomic) BOOL  imageToVisit;
+(UIButton *) configureButton: (UIButton *)button forImage: (NSDictionary *)flickrInfo;
@end
