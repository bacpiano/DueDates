//
//  PopUpSelectionVC.m
//  Due Dates
//
//  Created by Jahangir on 6/3/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import "PopUpSelectionVC.h"

@interface PopUpSelectionVC ()

@end

@implementation PopUpSelectionVC{
    
    NSMutableArray *dataArry;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self getAllData:_date];
}

-(void)getAllData:(NSDate *)choosedDate{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContecxt=[appdelegate managedObjectContext];
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"DueDate"];
    NSSortDescriptor *sortDesc=[[NSSortDescriptor alloc] initWithKey:@"due_date" ascending:NO];
    [req setSortDescriptors:@[sortDesc]];
    
    NSError *error;
    NSArray *results=[theContecxt executeFetchRequest:req error:&error];
    dataArry=[[NSMutableArray alloc] init];
    
    if (choosedDate) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"dd-MM-yyyy";
        NSString *stringDate = [format stringFromDate:choosedDate];
        
        for (DueDate *dd in results) {
            
            NSString *ddStr=[format stringFromDate:dd.due_date];
            
            if ([ddStr isEqualToString:stringDate]) {
                
                [dataArry addObject:dd];
            }
        }
    }
    [_tblView reloadData];
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataArry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[_tblView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    DueDate *dueDate=[dataArry objectAtIndex:indexPath.row];
    
    UILabel *titleLbl=[cell viewWithTag:10];
    UILabel *detailLbl=[cell viewWithTag:20];
    
    titleLbl.text=dueDate.subject;
    if ([dueDate.is_completed boolValue]) {
        
        detailLbl.text=@"Completed";
    }else{
        
        detailLbl.text=@"In-Progress";
    }
   
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (IBAction)cancelBtnPressed:(id)sender {
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
        
    }];
}
@end
