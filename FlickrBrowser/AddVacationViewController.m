//
//  AddVacationViewController.m
//  FlickrBrowser
//
//  Created by Zshcbka on 11/16/12.
//  Copyright (c) 2012 Zshcbka. All rights reserved.
//

#import "AddVacationViewController.h"
#import "VacationHelper.h"

@interface AddVacationViewController ()
@property (nonatomic, strong) IBOutlet UITextField *vacationName;
@property (nonatomic,strong) IBOutlet UITextField *vacationDescription;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

@end

@implementation AddVacationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.saveButton addTarget:self action:@selector(saveVacation) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self action:@selector(cancelSave) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem.leftBarButtonItem setTitle:@"Back"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL) disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) cancelSave
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) saveVacation
{
    NSString *name = self.vacationName.text;
    //NSString *description = self.vacationName.text;
    if ([name isEqualToString:@""])
    {
        UIAlertView *emptyFiledAllert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emptyFiledAllert show];
        return;
    }
    if (name.length < 3)
    {
        UIAlertView *emptyFiledAllert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Name should contain at least 3 symbols" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emptyFiledAllert show];
        return;
    }
    
    if (name.length > 20)
    {
        UIAlertView *emptyFiledAllert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The name is too long" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [emptyFiledAllert show];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *vacationPlan = [[defaults objectForKey:VACATION_PLANS_ARRAY] mutableCopy];
    if (!vacationPlan) vacationPlan = [NSMutableArray array];
    NSSet *set = [NSSet setWithArray:vacationPlan];
        if ([set containsObject:name])
        {
            UIAlertView *emptyFiledAllert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There is already a plan with such name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [emptyFiledAllert show];
        }
        else
        {
            [vacationPlan addObject:name];
        }
    [defaults setObject:vacationPlan forKey:VACATION_PLANS_ARRAY];
    NSLog(@"vacation plans/AddVacation VC %d",[vacationPlan count]);
    [defaults synchronize];
    UIAlertView *emptyFiledAllert = [[UIAlertView alloc] initWithTitle:nil message:@"Done!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [emptyFiledAllert show];
}

@end
