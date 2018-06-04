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

@interface ExpensesTableViewController () {
	NSMutableArray* _data;
}

@end

@implementation ExpensesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedString(@"Expenses", nil);
	
	//Get Data
	RequestData* req = [[RequestData alloc] init];
	[req requestDataWithResource:@"groceries.json"];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self fetchData];
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
	cell.shopLabel.text = expense.shop;
	cell.paidLabel.text = [NSString stringWithFormat:@"%f",expense.paid];
    
	return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
