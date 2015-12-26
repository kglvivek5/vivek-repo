//
//  QuizTopicsTableViewController.m
//  QuizBeta
//
//  Created by Lakshmi Narasimma KG on 19/12/15.
//  Copyright © 2015 Lakshmi Narasimma KG. All rights reserved.
//

#import "QuizTopicsTableViewController.h"
#import "AppDelegate.h"
#import "Question+CoreDataProperties.h"
#import "Answer+CoreDataProperties.h"
#import "QuestionDetailViewController.h"


@interface QuizTopicsTableViewController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *topics; // to hold the topics

@end

@implementation QuizTopicsTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Get the Managed Object Context from Application Delegate
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = app.managedObjectContext;
    
    NSError *error;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Question"];
    request.resultType = NSDictionaryResultType;
    request.returnsDistinctResults = YES;
    // Used to retrieve only particular property/column from Core data
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"topic", nil]];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"topic" ascending:YES];
    request.sortDescriptors = @[sort];
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    self.topics = [[NSMutableArray alloc] init];
    for (id currentRecord in results) {
        [self.topics addObject:[currentRecord objectForKey:@"topic"]];
    }
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
    return [self.topics count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.topics[indexPath.row];
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[QuestionDetailViewController class]]) {
        QuestionDetailViewController *qttvc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        qttvc.topic = self.topics[indexPath.row];
        qttvc.context = self.managedObjectContext;
    }
    
}


@end
