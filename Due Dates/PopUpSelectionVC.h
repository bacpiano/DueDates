//
//  PopUpSelectionVC.h
//  Due Dates
//
//  Created by Jahangir on 6/3/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpSelectionVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSDate *date;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
- (IBAction)cancelBtnPressed:(id)sender;

@end
