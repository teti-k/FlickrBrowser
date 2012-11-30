//
//  ShowImageViewController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 10/6/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "ShowImageViewController.h"
#import "SplitViewBarButtonItemPresenter.h"
#import "VacationHelper.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "VacationPlanNameController.h"


@interface ShowImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar; //to put there a bar button item for split view
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSMutableData *photoData;
@end

@implementation ShowImageViewController
unsigned long long const resonableCache = 10000; //the size of the cache

@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self downloadImage:self.selectedImage];

}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addButton];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0;
    //self.scrollView.contentSize = self.scrollView.frame.size;
    self.scrollView.contentSize = self.imageView.frame.size;
}
- (void) addButton
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    UIButton *button = [UIButton buttonWithType:UIBarButtonItemStyleBordered];
    button.frame = CGRectMake(80.0, 300.0, 50, 30.0);
    button.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [VacationHelper openVacation:@"My vacation plan" usingBlock:^(UIManagedDocument *vacation)
     {
         NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
         request.predicate = [NSPredicate predicateWithFormat:@"unique = %@",[self.selectedImage objectForKey:FLICKR_PHOTO_ID]];
         NSError *error = nil;
         NSArray *matches = [vacation.managedObjectContext executeFetchRequest:request error:&error];
         
         if (matches.count == 0)
         {
             [button setTitle:@"Visit" forState:UIControlStateNormal];
             [button addTarget:self
                        action:@selector(useDocument)
              forControlEvents:UIControlEventTouchUpInside];
         }
         else
         {
             [button setTitle:@"Unvisit" forState:UIControlStateNormal];
             [button addTarget:self
                        action:@selector(deleteDocument)
              forControlEvents:UIControlEventTouchUpInside];
         }
         [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
     }];
    NSLog(@"button name %@", button.titleLabel.text);
}

-(void) deleteDocument
{
    [VacationHelper openVacation:@"My vacation plan" usingBlock:^(UIManagedDocument *vacation){
        //[self deletePhotoWithFlickrInfo:self.selectedImage inManagedObjectContext:vacation.managedObjectContext];
        [Photo deletePhotoWithFlickrInfo:self.selectedImage inManagedObjectContext:vacation.managedObjectContext];
        [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
    }];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"The photo was deleted from vacation plan!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) useDocument
{
    [VacationHelper openVacation:@"My vacation plan" usingBlock:^(UIManagedDocument *vacation){
            [self fetchFlickrDataIntoDocument:vacation];
    }];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                    message:@"The photo was saved to Virtual vacation plan!"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
}

- (void)fetchFlickrDataIntoDocument:(UIManagedDocument *)document
{
    [Photo photoWithFlickrInfo:self.selectedImage inManagedObjectContext:document.managedObjectContext];
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
}

//split view controller's configuration
- (void)awakeFromNib  // always try to be the split view's delegate
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (id <SplitViewBarButtonItemPresenter>)splitViewBarButtonItemPresenter
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)]) {
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Back";
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

//add a button to the toolbar in SplitView
- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}
//End of splitView implementation

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

//download image for topPhoto and second VCs
- (void)downloadImage:(NSDictionary *)photo

{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner startAnimating];
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    [self.view bringSubviewToFront:spinner];
        __block NSData *data;
        dispatch_queue_t downloadQueue = dispatch_queue_create("Download", NULL);
        dispatch_async(downloadQueue, ^{
            NSError *error;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *rootDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *folderPath = [rootDirectory stringByAppendingPathComponent:@"CachedFlickrPhotos"];
            
            if (![fileManager fileExistsAtPath:folderPath])
            {
                [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
            }
            //define filepath for selectedPhoto
            NSString *filePath = [folderPath stringByAppendingPathComponent:photo[FLICKR_PHOTO_ID]];
            if(![fileManager fileExistsAtPath:filePath])
            {
                //if we don't have image in cache
                //define url depending on the construction of photo
                NSURL *url;
                if (!photo[FLICKR_URL])
                {
                    url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
                }
                else url = photo[FLICKR_URL];
                
                //get data from url
                data = [[NSData alloc] initWithContentsOfURL:url];
                [fileManager createFileAtPath:filePath contents:data attributes:nil];
                //add date of file modification to an array
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *modificationsLog = [[defaults objectForKey:@"defaults"] mutableCopy];
                if (modificationsLog == nil) modificationsLog = [NSMutableArray array];
                [modificationsLog addObject:filePath];
                [defaults setObject:modificationsLog forKey:@"defaults"];
                [defaults synchronize];
            }
            else
            {
                data = [fileManager contentsAtPath:filePath];
            }
            
            //check for the Cache folder size
            unsigned int size = 0;
            size = [[fileManager attributesOfItemAtPath:folderPath error:&error][NSFileSize] unsignedIntegerValue];
            
            //if it is more than 10Mb, delete the oldest file
            if( size > resonableCache )
            {
                NSMutableArray *modificationsLog = [[[NSUserDefaults standardUserDefaults] objectForKey:@"defaults"] mutableCopy];
                [fileManager removeItemAtPath:modificationsLog[0]  error:&error];
                [modificationsLog removeObjectAtIndex:0];
                [[NSUserDefaults standardUserDefaults] setObject:modificationsLog forKey:@"defaults"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               [spinner stopAnimating];
                               [spinner removeFromSuperview];
                               self.imageView.image = [UIImage imageWithData:data];
                               self.navigationItem.title = self.imageTitle;
                               self.scrollView.delegate = self;

                           });
                       });
        dispatch_release(downloadQueue);
}

@end
