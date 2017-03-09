//
//  ChooseDateViewController.m
//  Due Dates
//
//  Created by Jahangir on 5/19/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import "ChooseDateViewController.h"
#import "PopUpSelectionVC.h"

@interface ChooseDateViewController ()

@end

@implementation ChooseDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CKCalendarView *calendar = [[CKCalendarView alloc] init];
    
    calendar.frame=CGRectMake(20, 40, 260, 135);
    [self.view addSubview:calendar];
    calendar.datesArryForDots=_datesArry;
    calendar.delegate = self;
    calendar.backgroundColor=[UIColor colorWithRed:25.0/255.0 green:72.0/255.0 blue:90.0/255.0 alpha:1.0];
    
}

- (IBAction)doneBtnPressed:(id)sender {
    
    _selectedDate=nil;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
        
    }];
}

- (IBAction)cancelBtnPressed:(id)sender {
    
    _selectedDate=nil;
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
        
    }];
}

-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date{
    _selectedDate=date;
    
    [calendar deselectDate:date];
    [calendar.delegate calendar:calendar didDeselectDate:date];
    for (DueDate *dd in calendar.datesArryForDots) {
        if ([calendar date:dd.due_date isSameDayAsDate:date]) {
            
            [self showPopUpTable:dd.due_date];
            break;
        }
    }
}
-(void)calendar:(CKCalendarView *)calendar didDeselectDate:(NSDate *)date{
    _selectedDate=nil;
    
}

-(void)showPopUpTable:(NSDate*)date{
    
    PopUpSelectionVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PopUpSelectionVC"];
    vc.date=date;
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
//        [self getAllData:nil];
//        
//        ChooseDateViewController *vc=(ChooseDateViewController*)presentedControll;
//        
//        [self getAllData:vc.selectedDate];
//        NSLog(@"selected date: %@",vc.selectedDate);
        
    };
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
        NSLog(@"goingggggg");
        
    }];

    
}

@end
