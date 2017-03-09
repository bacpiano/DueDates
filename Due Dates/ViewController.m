//
//  ViewController.m
//  Due Dates
//
//  Created by Jahangir on 5/19/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import "ViewController.h"
#import "ChooseDateViewController.h"
#import "EditDueDateVC.h"
#import "DueTableViewCell.h"

@interface ViewController ()

@end

@implementation ViewController{
    
    NSMutableArray *dataArry;
    NSMutableArray *searchedArry;
    NSInteger selectedRow;
    NSMutableArray *selectionArry;
    BOOL isDeleting;
    BOOL selectionEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    selectionArry=[[NSMutableArray alloc] init];
    _btnDoneSel.hidden=YES;
    _btnSelect.hidden=NO;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self getAllData:nil];
}
-(void)getAllData:(NSDate *)choosedDate{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContecxt=[appdelegate managedObjectContext];
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"DueDate"];
    NSSortDescriptor *sortDesc=[[NSSortDescriptor alloc] initWithKey:@"due_date" ascending:NO];
    [req setSortDescriptors:@[sortDesc]];
    
    if (_segment.selectedSegmentIndex==0) {
        
        [req setPredicate:[NSPredicate predicateWithFormat:@"is_completed == %@",@NO]];
    }else{
        
        [req setPredicate:[NSPredicate predicateWithFormat:@"is_completed == %@",@YES]];
    }
    
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
    }else{
        [dataArry addObjectsFromArray:results];
    }

    
    searchedArry=[[NSMutableArray alloc] initWithArray:dataArry];
    [_tblView reloadData];
}
-(NSMutableArray*)allDateFromDB{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContecxt=[appdelegate managedObjectContext];
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"DueDate"];
    
    NSError *error;
    NSArray *results=[theContecxt executeFetchRequest:req error:&error];
    return [[NSMutableArray alloc] initWithArray:results];
    
}

#pragma mark - Button Pressed
- (IBAction)addNewBtnPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"add" sender:self];
}

- (IBAction)chooseDateBtnPressed:(id)sender {
    
    ChooseDateViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseDateViewController"];
    vc.datesArry=[self allDateFromDB];
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.presentedFormSheetSize = CGSizeMake(300, 340);
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    
    [[MZFormSheetController sharedBackgroundWindow] setBackgroundBlurEffect:YES];
    [[MZFormSheetController sharedBackgroundWindow] setBlurRadius:3.5];
    [[MZFormSheetController sharedBackgroundWindow] setBackgroundColor:[UIColor clearColor]];
    
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
    
    
    formSheet.willDismissCompletionHandler=^(UIViewController *presentedControll){
        
        NSLog(@"backkkkk");
        [self getAllData:nil];
        
        ChooseDateViewController *vc=(ChooseDateViewController*)presentedControll;
        
        [self getAllData:vc.selectedDate];
        NSLog(@"selected date: %@",vc.selectedDate);
        
    };
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
        NSLog(@"goingggggg");
        
    }];

   
    
}

- (IBAction)segmentVslueChanged:(id)sender {
    
    [_tblView setEditing:NO];
    [self getAllData:nil];
}

- (IBAction)doneSelectionPressed:(id)sender {
    
    if (selectionArry.count>0) {
        
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"Choose Action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:@"Share", nil];
        sheet.tag=20;
        [sheet showInView:self.view];

    }else{
        
        selectionEnabled=NO;
        _btnSelect.hidden=NO;
        _btnDoneSel.hidden=YES;
        [selectionArry removeAllObjects];
        [_tblView reloadData];
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"No row selected!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }
    
}

- (IBAction)selectBtnPressed:(id)sender {
    
    
    if (searchedArry.count) {
        
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"Selection" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"All" otherButtonTitles:@"Several", nil];
        sheet.tag=10;
        [sheet showInView:self.view];
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"No data found!" message:@"Please create an item first." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
    }
}
-(NSString*)stringFromDate:(NSDate*)date{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/YYYY"];
    
    NSString *retValue=[formatter stringFromDate:date];
    return retValue;
    
}

-(int)numberOfDaysForDate:(NSDate*)date{
    
//    NSTimeInterval secondsBetween = [date timeIntervalSinceDate:[NSDate date]];
//    
//    int numberOfDays = secondsBetween / 86400;
    
//    NSDateFormatter *f = [[NSDateFormatter alloc] init];
//    [f setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate;
    NSDate *endDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&startDate
                 interval:NULL forDate:[NSDate date]];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&endDate
                 interval:NULL forDate:date];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:startDate toDate:endDate options:0];
    NSInteger numberOfDays=[difference day];
    return (int)numberOfDays;
}

#pragma mark - TableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return searchedArry.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DueTableViewCell *cell=[_tblView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    NSNumber *num=@(indexPath.row);
    
    BOOL found=NO;
    for (NSNumber *nm in selectionArry) {
        
        if ([nm isEqualToNumber:num]) {
            
            found=YES;
            break;
        }
    }
    
    if (found) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
//    if (!isDeleting) {
//         cell.editingAccessoryType = UITableViewCellAccessoryCheckmark;
//    }else{
//         cell.editingAccessoryType = UITableViewCellAccessoryNone;
//    }
    
    
   
    
    DueDate *dueDate=[searchedArry objectAtIndex:indexPath.row];
    cell.lblSubject.text=dueDate.subject;
    cell.lblDate.text=[NSString stringWithFormat:@"Due on   %@",[self stringFromDate:dueDate.due_date]];
    cell.btnInfo.tag=indexPath.row;
    
    [cell.btnInfo addTarget:self action:@selector(infoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self numberOfDaysForDate:dueDate.due_date]>1) {
        cell.btnInfo.selected=NO;
    }else{
        cell.btnInfo.selected=YES;
    }
    
    if (_segment.selectedSegmentIndex==0) {
        cell.btnInfo.hidden=NO;
    }else{
        cell.btnInfo.hidden=YES;
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (selectionEnabled) {
        
        NSNumber *num=@(indexPath.row);
        
        BOOL found=NO;
        for (NSNumber *nm in selectionArry) {
            
            if ([nm isEqualToNumber:num]) {
                
                found=YES;
                break;
            }
        }
        
        if (found) {
            [selectionArry removeObject:num];
        }else{
            [selectionArry addObject:num];
        }
        
        [_tblView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }else{
        [_tblView deselectRowAtIndexPath:indexPath animated:YES];
        selectedRow=indexPath.row;
        [self performSegueWithIdentifier:@"deatil" sender:self];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}


-(void)infoBtnPressed:(UIButton*)btn{
    
    NSString *msg;
    DueDate *dd=[searchedArry objectAtIndex:btn.tag];
    if (btn.selected) {
        
        int remaining=[self numberOfDaysForDate:dd.due_date];
        
        if (remaining==1) {
            
             msg=@"This payment is due tomorrow.";
            
        }else if (remaining==0) {
            msg=@"Today is your last day for making this payment.";
        }else{
            
            remaining=remaining*-1;
            msg=[NSString stringWithFormat:@"You are %i days behind.",remaining];
            
        }
        
        
    }else{
        msg=[NSString stringWithFormat:@"You have %i days left for making this payment.",[self numberOfDaysForDate:dd.due_date]];
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Info" message:msg delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil] show];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    

    if ([segue.identifier isEqualToString:@"deatil"]) {
        
        EditDueDateVC *vc=[segue destinationViewController];
        vc.dueDate=[searchedArry objectAtIndex:selectedRow];
    }
}

#pragma mark - Search
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO];
    [searchedArry removeAllObjects];
    [searchedArry addObjectsFromArray:dataArry];
    [_tblView reloadData];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [searchedArry removeAllObjects];
    
    for (DueDate *dd in dataArry) {
        
        NSString *subject=dd.subject;
        if ([subject rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound && subject) {
            
            [searchedArry addObject:dd];
            
        }
    }
    
    [_tblView reloadData];
    
}

-(void)selectAllRows{
    
    [selectionArry removeAllObjects];
    
    for (int i=0; i<[searchedArry count]; i++) {
        
        [selectionArry addObject:[NSNumber numberWithInteger:i]];
    }
    [_tblView reloadData];
}

#pragma mark - ActionSheet Delegate

-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    
    if (actionSheet.tag==20) {
        
      
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==10) {
        
        if (buttonIndex==0) {
            
            _btnSelect.hidden=YES;
            _btnDoneSel.hidden=NO;
            
            [self selectAllRows];
            
        }else if (buttonIndex==1){
            
            _btnSelect.hidden=YES;
            _btnDoneSel.hidden=NO;
            selectionEnabled=YES;
            
             [selectionArry removeAllObjects];
            if (searchedArry.count>0) {
                
                [selectionArry addObject:@(0)];
            }
            [_tblView reloadData];
           
        }
        
    }else if (actionSheet.tag==20){
        
        if (buttonIndex==0) {
            
            [self deleteData];
            
        }else if(buttonIndex==1){
            
            [self writeToTextFile];
            
//            isDeleting=NO;
//            _tblView.allowsMultipleSelectionDuringEditing=YES;
//            [_tblView reloadData];
//            [_tblView setEditing:YES];
        }else{
            
            selectionEnabled=NO;
            _btnSelect.hidden=NO;
            _btnDoneSel.hidden=YES;
            [selectionArry removeAllObjects];
            [_tblView reloadData];
            
        }
        
    }
}

- (BOOL)tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)deleteData{
    
    AppDelegate *appdeleget=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdeleget managedObjectContext];
    NSError *error;
    
    for (NSNumber *num in selectionArry) {
        
        if (searchedArry.count> [num integerValue]) {
            
            DueDate *dd=[searchedArry objectAtIndex:[num integerValue]];
            [theContext deleteObject:dd];
            [dataArry removeObject:dd];
            [searchedArry removeObject:dd];
        }
    }
    
    selectionEnabled=NO;
    _btnSelect.hidden=NO;
    _btnDoneSel.hidden=YES;
    [selectionArry removeAllObjects];
    [theContext save:&error];
    [_tblView reloadData];
}

#pragma mark - Export
-(void) writeToTextFile{
    
    NSMutableArray *allData=[[NSMutableArray alloc] init];
    
    for (NSNumber *num in selectionArry) {
        
        if (searchedArry.count> [num integerValue]) {
            
            DueDate *dd=[searchedArry objectAtIndex:[num integerValue]];
            [allData addObject:dd];
        }
    }
    
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@/DueDates.txt",
                          documentsDirectory];
    
    NSMutableString *content=[[NSMutableString alloc] init];
   
    
    for (DueDate *dd in allData) {
        
        NSString *status;
        if ([dd.is_completed boolValue]) {
            status=@"Status: Completed";
        }else{
            status=@"Status: In progress";
        }
        
        NSString *part=[NSString stringWithFormat:@"%@ due on %@, %@ \n",dd.subject,[self stringFromDate:dd.due_date],status];
        [content appendString:part];
    }
    
    NSError *error;
    [content writeToFile:fileName
              atomically:NO
                encoding:NSStringEncodingConversionAllowLossy
                   error:&error];
    
    if (!error) {
        selectionEnabled=NO;
        _btnSelect.hidden=NO;
        _btnDoneSel.hidden=YES;
        [selectionArry removeAllObjects];
        [_tblView reloadData];
        [self showExportFileAt:fileName];
    }
}

-(void)showExportFileAt:(NSString *)file{
    
    NSURL *fileUrl     = [NSURL fileURLWithPath:file];
    
    NSArray *itemsToShare = @[fileUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[ UIActivityTypeCopyToPasteboard];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        CGRect rectInTableView = CGRectMake(0, 0, 0, 0);
        //        CGRect rectInSuperview = [self.tblView convertRect:rectInTableView toView:[self.tblView superview]];
        NSLog(@"%f",rectInTableView.origin.y);
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, rectInTableView.origin.y+120, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else{
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    
}



@end
