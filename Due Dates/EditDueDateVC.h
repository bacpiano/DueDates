//
//  EditDueDateVC.h
//  Due Dates
//
//  Created by Jahangir on 5/22/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDueDateVC : UIViewController<UIAlertViewDelegate>

@property (strong,nonatomic) DueDate *dueDate;
@property (weak, nonatomic) IBOutlet UIButton *btnMarkComplete;

@property (weak, nonatomic) IBOutlet UILabel *lblDueDate;
@property (weak, nonatomic) IBOutlet UILabel *lblNotes;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnDelete;
- (IBAction)editBtnPressed:(id)sender;
- (IBAction)deleteBtnPressed:(id)sender;
- (IBAction)markCompletePressed:(id)sender;

@end
