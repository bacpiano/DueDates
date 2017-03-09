//
//  EditDueDateVC.m
//  Due Dates
//
//  Created by Jahangir on 5/22/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import "EditDueDateVC.h"
#import "AddViewController.h"

@interface EditDueDateVC ()

@end

@implementation EditDueDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=_dueDate.subject;
    
    if (_dueDate.due_amount.length<2) {
        
        _lblDueDate.text=[NSString stringWithFormat:@"Due on %@",[self stringFromDate:_dueDate.due_date]];
        
    }else{
        _lblDueDate.text=[NSString stringWithFormat:@"%@ due on %@",_dueDate.due_amount,[self stringFromDate:_dueDate.due_date]];
    }
    
    _lblNotes.text=_dueDate.notes;
    
    if ([_dueDate.is_completed boolValue]) {
        
        _btnEdit.title=@"";
        _btnEdit.enabled=NO;
        _btnMarkComplete.hidden=YES;
        
    }
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
}

-(NSString*)stringFromDate:(NSDate*)date{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE MM/dd/YYYY"];
    
    NSString *retValue=[formatter stringFromDate:date];
    return retValue;
    
}

- (IBAction)editBtnPressed:(id)sender {
    
    AddViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    vc.dueDate=_dueDate;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)deleteBtnPressed:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This record will be deleted." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    alert.tag=10;
    [alert show];
}

- (IBAction)markCompletePressed:(id)sender {
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    
    _dueDate.is_completed=[NSNumber numberWithBool:YES];
    NSError *error;
    [theContext save:&error];
    
    [[[UIAlertView alloc] initWithTitle:@"Congarts!" message:@"Due date has been completed." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)deleteDueDate{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    [theContext deleteObject:_dueDate];
    
    NSError *error;
    [theContext save:&error];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertview delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==10 && buttonIndex==1) {
        NSLog(@"delete approved!");
        [self deleteDueDate];
    }
}
@end
