//
//  CAPSViewController.m
//  CustomCellForiOS7
//
//  Created by Ben Gordon on 10/9/13.
//  Copyright (c) 2013 CAPS. All rights reserved.
//

#import "CAPSViewController.h"
#import "LoremIpsum.h"
#import "CAPSCustomCell.h"

@interface CAPSViewController ()

@property (weak, nonatomic) IBOutlet UITableView *resizeTableView;
@property (nonatomic, retain) NSMutableArray *loremIpsumArray;

@end

@implementation CAPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set up Lorem Ipsum array with 50 Strings
    [self setUpLoremIpsumArrayWithCount:50];
    
    // Set up the TableView
    [self setUpResizeTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Set Up LoremIpsumArray
- (void)setUpLoremIpsumArrayWithCount:(int)count {
    self.loremIpsumArray = [NSMutableArray array];
    for (int x = 0; x < count; x++) {
        // Create a LoremIpsum string with 1-50 words in it
        NSString *loremString = [LoremIpsum generateLoremIpsumWithWords:((arc4random() % 50) + 1) punctuation:@"!"];
        [self.loremIpsumArray addObject:loremString];
    }
}


#pragma mark - Set Up TableView
- (void)setUpResizeTableView {
    //
    // THIS IS IMPORTANT!
    //  - The separator insets start your cell off at xOrigin = 15, instead of 0
    //  - like in iOS 6 and lower. Calling responds to selector means this won't break
    //  - in iOS 6 and lower either!
    //
    if ([self.resizeTableView respondsToSelector:@selector(separatorInset)]) {
        self.resizeTableView.separatorInset = UIEdgeInsetsZero;
    }
}


#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.loremIpsumArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CAPSCustomCell";
    CAPSCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CAPSCustomCell" owner:self options:nil];
        cell = views[0];
    }
    
    // Set Cell Content
    [cell setCellContentWithLoremIpsumString:self.loremIpsumArray[indexPath.row]];
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CAPSCustomCell heightForLoremIpsumString:self.loremIpsumArray[indexPath.row] tableView:tableView];
}


#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
