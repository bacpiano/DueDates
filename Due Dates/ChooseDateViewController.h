//
//  ChooseDateViewController.h
//  Due Dates
//
//  Created by Jahangir on 5/19/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"

@interface ChooseDateViewController : UIViewController<CKCalendarDelegate>

@property (strong,nonatomic) NSDate *selectedDate;

@property (strong,nonatomic) NSMutableArray *datesArry;

- (IBAction)doneBtnPressed:(id)sender;
- (IBAction)cancelBtnPressed:(id)sender;
@end
