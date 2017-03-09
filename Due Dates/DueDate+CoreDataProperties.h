//
//  DueDate+CoreDataProperties.h
//  Due Dates
//
//  Created by Jahangir on 5/23/16.
//  Copyright © 2016 bisma. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DueDate.h"

NS_ASSUME_NONNULL_BEGIN

@interface DueDate (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *alarm;
@property (nullable, nonatomic, retain) NSDate *created_at;
@property (nullable, nonatomic, retain) NSString *due_amount;
@property (nullable, nonatomic, retain) NSDate *due_date;
@property (nullable, nonatomic, retain) NSNumber *is_completed;
@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) NSString *subject;
@property (nullable, nonatomic, retain) NSNumber *is_alarm;

@end

NS_ASSUME_NONNULL_END
