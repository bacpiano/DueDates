//
//  AddViewController.h
//  Due Dates
//
//  Created by Jahangir on 5/20/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"

@interface AddViewController : UIViewController<UITextFieldDelegate,CKCalendarDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet CKCalendarView *dueDateCalander;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dueDateHeight;

@property (strong,nonatomic) DueDate *dueDate;
@property (weak, nonatomic) IBOutlet UITextField *txtSubject;
@property (weak, nonatomic) IBOutlet UIDatePicker *alarmDatePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alarmHeight;
@property (weak, nonatomic) IBOutlet UITextField *txtAmount;
@property (weak, nonatomic) IBOutlet UISwitch *switchAlarm;
@property (weak, nonatomic) IBOutlet GCPlaceholderTextView *txtNotes;
- (IBAction)alarmSwitchValueChanged:(id)sender;

@end
