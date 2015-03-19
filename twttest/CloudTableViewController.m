//
//  CloudTableViewController.m
//  twttest
//
//  Created by Jon Kotowski on 5/26/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import "CloudTableViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface CloudTableViewController ()

@end

@implementation CloudTableViewController


NSMutableArray * dataItems;
NSMutableArray * dataAssociated;
 
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dataItems = [[NSMutableArray alloc] init];
    dataAssociated = [[NSMutableArray alloc] init];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    PFQuery *query = [PFQuery queryWithClassName:@"PDFThing"];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        
//       
//        if (!error) {
//            NSMutableArray * arr = [[NSMutableArray alloc] init];
//            for (PFObject* obj in objects) {
//                
//                PFFile * file = [obj objectForKey:@"File"];
//                
//                [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//                    NSLog(@"%@",file.name);
//                    
//                    if (data != nil) {
//                        
//                        //[arr addObject:data];
//                        [dataItems addObject:[NSString stringWithFormat:@"%@",file.name ]];
//                        [dataAssociated addObject:data];
//                        
//                        [self.tableView reloadData];
//                    } else {
//                        NSLog(@"Data is nil.");
//                    }
//                    
//                    //
//                }];
//                
//            }
//            
//        }
//    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Counting %d",dataItems.count);
    // Return the number of rows in the section.
    return dataItems.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString * string = dataItems[indexPath.row];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",string];
     NSLog(@"%@ is here",string);
    
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [del.PDFActivityViewController loadPDFFromData:dataAssociated[indexPath.row]];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
