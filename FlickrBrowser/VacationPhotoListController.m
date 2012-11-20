//
//  VacationPhotoListController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 11/8/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "VacationPhotoListController.h"
#import "Photo.h"
#import "ShowImageViewController.h"
#import "FlickrFetcher.h"

@interface VacationPhotoListController ()
@property (nonatomic, strong) NSMutableArray *photoArray;
@end

@implementation VacationPhotoListController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"self.photos %@", self.photos);
}

-(void) setPhotos:(NSSet *)photos
{
    if(_photos != photos)
    {
        _photos = photos;
    }
    self.photoArray = [NSMutableArray array];
    [self.photos enumerateObjectsUsingBlock:^(Photo *photo, BOOL *success)
     {
         [self.photoArray addObject:photo];
     }];

}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Photo";

      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
            cell.textLabel.text = [[self.photoArray objectAtIndex:indexPath.row] title];
            cell.detailTextLabel.text = [[self.photoArray objectAtIndex:indexPath.row] subtitle];
            //return cell;

    return cell;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"show location picture"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ShowImageViewController *destLocation = [segue destinationViewController];
        Photo *photo = [self.photoArray objectAtIndex:indexPath.row];
        NSMutableDictionary *image = [NSMutableDictionary dictionaryWithObjectsAndKeys:photo.unique, FLICKR_PHOTO_ID, photo.imageURL,FLICKR_URL, nil];
        destLocation.selectedImage = image;
        
    }
}

@end