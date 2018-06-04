//
//  ExpenseTableViewCell.h
//  TabCom_Exercise
//
//  Created by Loud on 6/4/18.
//  Copyright © 2018 Bill_Seaman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *shopLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusImage;

@end
