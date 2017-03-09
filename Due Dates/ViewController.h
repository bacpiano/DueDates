//
//  ViewController.h
//  Due Dates
//
//  Created by Jahangir on 5/19/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnDoneSel;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;

@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBr;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnChooseDate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAdd;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;

- (IBAction)addNewBtnPressed:(id)sender;
- (IBAction)chooseDateBtnPressed:(id)sender;
- (IBAction)segmentVslueChanged:(id)sender;
- (IBAction)doneSelectionPressed:(id)sender;
- (IBAction)selectBtnPressed:(id)sender;
@end

