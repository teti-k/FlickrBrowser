//
//  MapViewController.h
//  FlickrBrowser
//
//  Created by Zshcbka on 10/17/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject> 
- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface MapViewController : UIViewController 
@property (nonatomic,strong) NSArray *annotations; //array of map annotations
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
@property CLLocationCoordinate2D centerCoordinate;


@end
