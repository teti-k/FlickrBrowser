//
//  VacationViewController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 11/2/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "VacationViewController.h"
#import "VacationHelper.h"

@interface VacationViewController ()
@property (nonatomic, weak) NSArray *vacationPlans;
@end

NSString *vacationPlan;
@implementation VacationViewController

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Your virtual vacations";
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.vacationPlans = [[NSUserDefaults standardUserDefaults] objectForKey:VACATION_PLANS_ARRAY];
    [self.tableView reloadData];
}

-(void) setVacationPlans:(NSMutableArray *)vacationPlans
{
    if (_vacationPlans != vacationPlans)
    {
        _vacationPlans = vacationPlans;
    }
}

#pragma mark - Table view data source
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vacationPlans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.vacationPlans objectAtIndex:indexPath.row];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //send to next view controllers the name of chosen Vacation Plan
    vacationPlan = [[[self.tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    
}


@end
