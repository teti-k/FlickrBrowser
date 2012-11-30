//
//  VacationPlanNameController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 11/19/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "VacationPlanNameController.h"
#import "VacationHelper.h"

@interface VacationPlanNameController ()
@property (nonatomic, strong) NSArray *vacationPlans;
@property (nonatomic,strong) NSMutableArray *selectedVacation;
@end

@implementation VacationPlanNameController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void) setVacationPlans:(NSArray *)vacationPlans
{
    if(_vacationPlans != vacationPlans)
    {
        _vacationPlans = vacationPlans;
    }
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view setFrame:CGRectMake(120, 0, 200, 300)];
    self.selectedVacation = [NSMutableArray array];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.vacationPlans = [[NSUserDefaults standardUserDefaults] objectForKey:VACATION_PLANS_ARRAY];
    //NSLog(@"vacation plans in defaults %d", self.vacationPlans.count);
    return self.vacationPlans.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Plan";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = (self.vacationPlans)[indexPath.row];
    //NSLog(@"cell %@", cell.textLabel.text);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setAllowsMultipleSelection:YES];

    id data = (self.vacationPlans)[indexPath.row];
    [self.selectedVacation addObject:data];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (data)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    NSLog(@"selected vacation %d", self.selectedVacation.count);
}

@end
