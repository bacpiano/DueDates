//
//  AddViewController.m
//  Due Dates
//
//  Created by Jahangir on 5/20/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController{
    
    NSDate *selectedDate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *saveBtn=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtnPressed)];
    self.navigationItem.rightBarButtonItem=saveBtn;
    
//    _alarmDatePicker
    
    float width=[UIScreen mainScreen].bounds.size.width;
    
    if ([UIScreen mainScreen].bounds.size.height<600) {
        width=width+30;
    }
    
    _dueDateHeight.constant=width;
    _contentHeight.constant=_contentHeight.constant+width;
    _dueDateCalander.backgroundColor=[UIColor colorWithRed:25.0/255.0 green:72.0/255.0 blue:90.0/255.0 alpha:1.0];
    _dueDateCalander.delegate = self;

    
    _txtNotes.placeholderColor=[UIColor darkGrayColor];
    _txtNotes.placeholder=@"Type some notes here";
    
    _txtNotes.layer.cornerRadius=5.0f;
    _txtNotes.layer.borderColor=[UIColor darkGrayColor].CGColor;
    _txtNotes.layer.borderWidth=0.5f;
    
    NSLocale *locale=[_dueDateCalander locale];
    NSLog(@"%@",locale);
    
    if (_dueDate) {
        
        _txtSubject.text=_dueDate.subject;
        _txtAmount.text=_dueDate.due_amount;
        _txtNotes.text=_dueDate.notes;
        selectedDate=_dueDate.due_date;
        _alarmDatePicker.date=_dueDate.alarm;
        [_switchAlarm setOn:[_dueDate.is_alarm boolValue]];
        if (!_switchAlarm.isOn) {
            _alarmHeight.constant=0;
        }
        [_dueDateCalander selectDate:_dueDate.due_date makeVisible:YES];
        
    }else{
        
        [_dueDateCalander selectDate:[NSDate date] makeVisible:YES];
        self.navigationItem.rightBarButtonItem.enabled=NO;
        [_switchAlarm setOn:NO];
        _alarmHeight.constant=0;
        _txtAmount.text=@"$";
    }
    
}

-(void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date{

    selectedDate=date;
    if (selectedDate) {
         _alarmDatePicker.date=selectedDate;
    }
}
-(void)calendar:(CKCalendarView *)calendar didDeselectDate:(NSDate *)date{
    selectedDate=nil;
    
}


-(void)saveBtnPressed{
    
    if (!selectedDate) {
        
//        NSDateFormatter *df=[[NSDateFormatter alloc] init];
//        [df setDateFormat:@"YYYY-MM-dd"];
//        NSString *dateStr=[df stringFromDate:[NSDate date]];
////        NSString *newStrWithTime=[NSString stringWithFormat:@"%@ 19:00:00 +0000",dateStr];
////        [df setDateFormat:@"YYYY-MM-dd HH:mm:ssz"];
//        selectedDate=[_dueDateCalander.dateFormatter dateFromString:dat];
        
        selectedDate=[NSDate date];
        NSArray *allDates=[_dueDateCalander datesShowing];
        
        for (NSDate *date in allDates) {
            
            if ([_dueDateCalander date:date isSameDayAsDate:selectedDate]) {
                
                selectedDate=date;
                break;
            }
        }
        
    }
    
    if (_dueDate) {
        [self updateExistingEntry];
         [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self saveNewEntry];
         [self.navigationController popViewControllerAnimated:YES];
    }
    
   
    
}

-(void)updateExistingEntry{
 
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];

    _dueDate.subject=_txtSubject.text;
    _dueDate.due_amount=_txtAmount.text;
    _dueDate.notes=_txtNotes.text;
    _dueDate.due_date=selectedDate;
    _dueDate.alarm=_alarmDatePicker.date;
    
        
    [self cancelNotificationForCreationDate:_dueDate.created_at];
    _dueDate.created_at=[NSDate date];
    
    if (_switchAlarm.isOn) {
        _dueDate.is_alarm=@YES;
        
        NSString *msg=[NSString stringWithFormat:@"Due Date for %@ is approching",_txtSubject.text];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
        localNotification.soundName=@"Tick-tock-sound.mp3";
        localNotification.alertBody = msg;
        localNotification.userInfo=@{@"ID":[self stringUIDForDate:_dueDate.created_at]};
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }else{
        _dueDate.is_alarm=@NO;
    }

    
    NSError *erro;
    [theContext save:&erro];
    
}

-(void)saveNewEntry{
    
    AppDelegate *appdelegate=[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *theContext=[appdelegate managedObjectContext];
    DueDate *dueDate=[NSEntityDescription insertNewObjectForEntityForName:@"DueDate" inManagedObjectContext:theContext];
    dueDate.created_at=[NSDate date];
    dueDate.subject=_txtSubject.text;
    dueDate.due_amount=_txtAmount.text;
    dueDate.notes=_txtNotes.text;
    
    dueDate.due_date=selectedDate;
    
    if (_switchAlarm.isOn) {
        dueDate.is_alarm=@YES;
        
        NSString *msg=[NSString stringWithFormat:@"Due Date for %@ is approching",_txtSubject.text];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
        localNotification.soundName=@"Tick-tock-sound.mp3";
        localNotification.alertBody = msg;
        localNotification.userInfo=@{@"ID":[self stringUIDForDate:dueDate.created_at]};
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }else{
        dueDate.is_alarm=@NO;
    }
    dueDate.alarm=_alarmDatePicker.date;
    dueDate.is_completed=@NO;

    
    NSError *erro;
    [theContext save:&erro];
}

-(NSString*)stringUIDForDate:(NSDate*)date{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY-HH-mm-ss"];
    NSString *retValue=[dateFormatter stringFromDate:date];
    return retValue;
}

-(void)cancelNotificationForCreationDate:(NSDate*)date{
    
    
    NSString *myIDToCancel = [self stringUIDForDate:date];
    UILocalNotification *notificationToCancel=nil;
    for(UILocalNotification *aNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[aNotif.userInfo objectForKey:@"ID"] isEqualToString:myIDToCancel]) {
            notificationToCancel=aNotif;
            break;
        }
    }
    if(notificationToCancel)
        [[UIApplication sharedApplication] cancelLocalNotification:notificationToCancel];
}

#pragma mark - TextField Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newStr=[textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField==_txtSubject){
        
        if (newStr.length>0) {
            
            self.navigationItem.rightBarButtonItem.enabled=YES;
        }else{
            self.navigationItem.rightBarButtonItem.enabled=NO;
        }
    }
        
        
    if (textField==_txtAmount && range.location==0) {
        
        return NO;
    }else{
        return YES;
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)alarmSwitchValueChanged:(id)sender {
    
    if (_switchAlarm.isOn) {
        
        _alarmHeight.constant=100;
        
        if (selectedDate) {
            _alarmDatePicker.date=selectedDate;
        }
    }else{
        
        _alarmHeight.constant=0;
    }
    
    [self.view layoutIfNeeded];
}
@end
