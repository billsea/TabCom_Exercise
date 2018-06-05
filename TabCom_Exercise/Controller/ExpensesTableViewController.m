//
//  ExpensesTableViewController.m
//  TabCom_Exercise
//
//  Created by Loud on 6/4/18.
//  Copyright © 2018 Bill_Seaman. All rights reserved.
//

#import "ExpensesTableViewController.h"
#import "RequestData.h"
#import "Utility.h"
#import "Expense+CoreDataClass.h"
#import "ExpenseTableViewCell.h"
#import "ExpenseDetailTableViewController.h"

@interface ExpensesTableViewController () {
	NSMutableArray* _data;
}

@end

@implementation ExpensesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Expenses", nil);
	
	//clear old data
	[Utility deleteAllObjectsForEntity:@"Expense"];
	[Utility deleteAllObjectsForEntity:@"Expense_Items"];
	
	//Get Data
	RequestData* req = [[RequestData alloc] init];
	[req requestDataWithResource:@"groceries.json"];
	req.callback = ^(bool done){
		[self fetchData];
	};
}

- (void)fetchData {
	// Fetch data from persistent data store;
	_data = [Utility dataForEntity:@"Expense" andSortKey:@"paid"];
	[[self tableView] reloadData];
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
	
	Expense* expense = (Expense*)[_data objectAtIndex:indexPath.row];
	cell.titleLabel.text = expense.shop;
	cell.amountLabel.text = [NSString stringWithFormat:@"%f",expense.paid];
	
	return cell;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Expense detail
	ExpenseDetailTableViewController* expenseDetailTableViewController =
	[[ExpenseDetailTableViewController alloc] initWithNibName:@"ExpenseDetailTableViewController" bundle:nil];

	expenseDetailTableViewController.selectedExpense = (Expense*)[_data objectAtIndex:indexPath.row];
	
	[self.navigationController pushViewController:expenseDetailTableViewController
																			 animated:YES];
}


@end
