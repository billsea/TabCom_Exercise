//
//  ExpenseDetailTableViewController.h
//  TabCom_Exercise
//
//  Created by Loud on 6/4/18.
//  Copyright © 2018 Bill_Seaman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense+CoreDataClass.h"

@interface ExpenseDetailTableViewController : UITableViewController
@property(nonatomic) Expense* selectedExpense;
@end
