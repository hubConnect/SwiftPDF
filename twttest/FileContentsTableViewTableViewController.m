//
//  FileContentsTableViewTableViewController.m
//  twttest
//
//  Created by Jon Kotowski on 5/21/14.
//  Copyright (c) 2014 Jon Kotowski. All rights reserved.
//

#import "AppDelegate.h"
#import "FileContentsTableViewTableViewController.h"

@interface FileContentsTableViewTableViewController ()

@end

@implementation FileContentsTableViewTableViewController


NSArray * dataItems;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear {
    
    dataItems = [((PDFActivityViewController *)self.parentViewController) listFileAtPath:nil];
    [self.tableView reloadData];
    NSLog(@"Coming in");
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *but;
    UITextField *field;    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

-(void) setDataItems: (NSArray * ) data {
    
    NSMutableArray * arrayOfItems = [data mutableCopy];

    [arrayOfItems removeObject:@"cache.pdf"];
    dataItems = arrayOfItems;
    
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
    
    // Return the number of rows in the section.
    return dataItems.count;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Hitting it");
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dataItems[indexPath.row]];
    
    // Configure the cell...
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *localDocumentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName =dataItems[indexPath.row] ;
    NSString *localDocumentsDirectoryPdfFilePath = [localDocumentsDirectory
                                                    stringByAppendingPathComponent:pdfFileName];
    
    
    AppDelegate * appD = (AppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"%@",localDocumentsDirectoryPdfFilePath);
    appD.urlToLoad = [[NSURL alloc] initFileURLWithPath:localDocumentsDirectoryPdfFilePath];
    [appD attemptToLoadPDF:dataItems[indexPath.row]];
    
    //[appD.PDFActivityViewController loadPDF:localDocumentsDirectoryPdfFilePath];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGRect newScreen;
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    
    
    
    if (UIInterfaceOrientationIsLandscape( toInterfaceOrientation) ) {
        newScreen = CGRectMake(0, 0, mainScreen.size.height, mainScreen.size.width);
    } else {
        newScreen = CGRectMake(0, 0, mainScreen.size.width, mainScreen.size.height);
    }
    
    self.view.frame = newScreen;
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsPath = [paths objectAtIndex:0];
        NSString * filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", dataItems[indexPath.row]]];
        [fileManager removeItemAtPath:filePath error:NULL];
        
        NSMutableArray *array = [dataItems mutableCopy];
        
        [array removeObjectAtIndex:indexPath.row];
        dataItems = array;
        NSLog(@"%@", self.parentViewController.class);
        
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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
