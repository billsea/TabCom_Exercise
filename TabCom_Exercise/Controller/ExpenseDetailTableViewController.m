//
//  ExpenseDetailTableViewController.m
//  TabCom_Exercise
//
//  Created by Loud on 6/4/18.
//  Copyright © 2018 Bill_Seaman. All rights reserved.
//

#import "ExpenseDetailTableViewController.h"
#import "ExpenseTableViewCell.h"
#import "Expense_Items+CoreDataClass.h"
#import "Total.h"
#import "Utility.h"

#define kTotalFontSize 24

@interface ExpenseDetailTableViewController () {
	NSMutableArray* _data;
}

@end

@implementation ExpenseDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = _selectedExpense.shop;
	
	[self buildData];
}

- (void)buildData {
	_data = [[_selectedExpense.expense_items allObjects] mutableCopy];
	
	Total* blankRow = [[Total alloc] init];
	[_data addObject:blankRow];
	
	float expenseTotal = 0;
	Total* totalExpense = [[Total alloc] init];
	totalExpense.name = NSLocalizedString(@"Total:", nil);
	
	for(Expense_Items* ei in _selectedExpense.expense_items){
		expenseTotal = expenseTotal + ei.price;
	}
	totalExpense.totalAmount = expenseTotal;
	
	[_data addObject:totalExpense];
	
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *simpleTableIdentifier = @"ExpenseCell";
	
	ExpenseTableViewCell *cell = (ExpenseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ExpenseTableViewCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	cell.statusImage.backgroundColor = [UIColor clearColor];
	
	if([[_data objectAtIndex:indexPath.row] isKindOfClass:[Expense_Items class]]){
		Expense_Items* expense_item = (Expense_Items*)[_data objectAtIndex:indexPath.row];
		cell.titleLabel.text = expense_item.name;
		cell.amountLabel.text = [NSString stringWithFormat:@"$%@",[Utility formatNumber: [NSNumber numberWithFloat:expense_item.price]]];
	} else {
		Total* total_amount = (Total*)[_data objectAtIndex:indexPath.row];
		[cell.titleLabel setFont:[UIFont systemFontOfSize:kTotalFontSize weight:UIFontWeightRegular]];
		cell.titleLabel.text = total_amount.name;
		[cell.amountLabel setFont:[UIFont systemFontOfSize:kTotalFontSize weight:UIFontWeightRegular]];
		cell.amountLabel.text = total_amount.totalAmount > 0 ? [NSString stringWithFormat:@"$%@",[Utility formatNumber: [NSNumber numberWithFloat:total_amount.totalAmount]]] : @"";
	}
	
	return cell;
}

@end
