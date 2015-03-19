//
//  TWTMenuViewController.m
//  TWTSideMenuViewController-Sample
//
//  Created by Josh Johnson on 8/14/13.
//  Copyright (c) 2013 Two Toasters. All rights reserved.
//

#import "MenuViewController.h"
#import "MainViewController.h"
#import "TWTSideMenuViewController.h"
#import "AppDelegate.h"
#import "FileContentsTableViewTableViewController.h"
#import <Parse/Parse.h>

@interface MenuViewController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation MenuViewController

bool doload = NO;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIImage * dasImage = [MainViewController applyBlurOnImage: [UIImage imageNamed:@"bgimage"] withRadius:7];
    dasImage = [MainViewController imageWithImage:dasImage scaledToSize: CGSizeMake(self.view.frame.size.width + 639, self.view.frame.size.height + 70)];
    UIImageView *dasImageView = [[UIImageView alloc] initWithImage:dasImage];
    dasImageView.frame = CGRectMake(-35, -35, dasImage.size.width, dasImage.size.height);
    [self.view addSubview:dasImageView];
    //self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    CGRect imageViewRect = [[UIScreen mainScreen] bounds];
    imageViewRect.size.width += 589;
    self.backgroundImageView.frame = imageViewRect;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.backgroundImageView];
    
    _menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height / 3), 100, (44 * 5)) style:UITableViewStyleGrouped];
    [_menuTable setDelegate:self];
    [_menuTable setDataSource:self];
    [_menuTable setBackgroundColor:[UIColor clearColor]];
    [_menuTable setScrollEnabled:NO];
    
    
    [self.view addSubview:_menuTable];
}


- (void)viewWillAppear:(BOOL)animated {
    CGRect mainscreen = [UIScreen mainScreen].bounds;
    
    [_menuTable setFrame:CGRectMake(0, (mainscreen.size.width / 3), 100, (44 * 5))];
    [self.view addSubview:_menuTable];
}
-(void)reloadTable {
    
    
    [self.menuTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];

    
//    self.menuTable.frame = CGRectMake(0, 0, 0, 0);
//    
//    [UIView animateWithDuration:1 animations:^{
//        
//        _menuTable.frame = CGRectMake(0, (self.view.frame.size.height / 3), 100, (44 * 5));
//        [_menuTable reloadData];
//    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        NSLog(@"hit");
        //[self loadPDFFrom:nil];
        
        [self loadPrompt];
    } else if (indexPath.row == 1) {
        
        [self savePrompt];
        
    } else {
        
        NSArray * array = [self listFileAtPath:nil];
        NSLog(@"%d",array.count);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self closeButtonPressed];
    
}

- (void) loadPrompt {
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Load" message:@"Load from" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Device",@"URL",nil];
    
    [alert show];
}

- (void) loginOrSignup {
    
        
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Cloud Login" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login",@"Signup",@"Change user",nil];
        
    [alert show];
    
}

- (void) loadURLPrompt {
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"URL" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.text = @"http://www.drivhuset.se/sites/default/files/page/pdf_files/test.pdf";
    [alert show];
}

- (void) savePrompt {
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Save" message:@"Save to" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Device",nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.placeholder = @"Name";
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    AppDelegate * appD = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    if ([alertView.title isEqualToString:@"URL"]) {
        
        AppDelegate * appD = (AppDelegate *) [UIApplication sharedApplication].delegate;
        
        [appD.PDFActivityViewController loadPDF:[ alertView textFieldAtIndex:0].text];
    }
    
    if ([alertView.title isEqualToString:@"Load"]) {
        
        if (buttonIndex == 1) {
            
            AppDelegate * appD = (AppDelegate *) [UIApplication sharedApplication].delegate;
            [self closeButtonPressed];
            [appD.PDFActivityViewController loadPDFFromDevice];
           
        } else if (buttonIndex == 2) {
            
            [self loadURLPrompt];
            return;
            
        } else if (buttonIndex == 3) {
            
            [self loadURLPrompt];
            return;
        }
        
    }
    
    if ([alertView.title isEqualToString:@"Save"]) {
        
        
        if (buttonIndex == 1) {
            
            AppDelegate * appD = (AppDelegate *) [UIApplication sharedApplication].delegate;
            [ ((PDFActivityViewController *)appD.sideMenuViewController.mainViewController) writePDFToDeviceAsTitle:[ alertView textFieldAtIndex:0].text];
            [self listFileAtPath:nil];
            NSLog(@"Saved as %@",[alertView textFieldAtIndex:0].text );
            
        } else if (buttonIndex == 2) {
            
            
            
        } else if (buttonIndex == 3) {
        }
        
    }
    
    
    if ([alertView.title isEqualToString:@"Save To Device"]) {
        
    }
    

}
- (void) writePDFToDevice: (NSData *) data asTitle: (NSString *) title {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *file = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.pdf",title]];
    if (data == nil) {
        NSLog(@"NIL");
    }
    NSError *error = nil;
    if ([data writeToFile:file options:NSDataWritingAtomic error:&error]) {
    } else {
        NSLog(@"Unable to write PDF to %@. Error: %@", file, error);
    }
    [self listFileAtPath:nil];
}

-(NSArray *)listFileAtPath:(NSString *)path
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = documentsDirectory;
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSLog(@"COunt - %d",[directoryContent count]);
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    }

- (void)changeButtonPressed
{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
    [self.sideMenuViewController setMainViewController:controller animated:YES closeMenu:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (void) loadPDFFrom: (NSString *) string {
    AppDelegate * appd =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appd attemptToLoadPDF:@"http://gv.pl/pdf/lord_of_the_flies.pdf"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"Load";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        
    } else if (indexPath.row == 1) {
        
        cell.textLabel.text = @"Save";
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}

- (void)closeButtonPressed
{
    [self.sideMenuViewController closeMenuAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
