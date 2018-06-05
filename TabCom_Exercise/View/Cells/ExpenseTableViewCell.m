//
//  ExpenseTableViewCell.m
//  TabCom_Exercise
//
//  Created by Loud on 6/4/18.
//  Copyright © 2018 Bill_Seaman. All rights reserved.
//

#import "ExpenseTableViewCell.h"

@implementation ExpenseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

	_statusImage.layer.cornerRadius =_statusImage.frame.size.width / 2;
	_statusImage.layer.masksToBounds = YES;
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
