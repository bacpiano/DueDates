//
//  DueTableViewCell.h
//  Due Dates
//
//  Created by Jahangir on 5/22/16.
//  Copyright © 2016 bisma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DueTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblSubject;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIButton *btnInfo;

@end
