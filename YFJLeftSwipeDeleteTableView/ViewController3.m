//
//  ViewController3.m
//  YFJLeftSwipeDeleteTableView
//
//  Created by Yuichi Fujiki on 6/26/13.
//  Copyright (c) 2013 Yuichi Fujiki. All rights reserved.
//

#import "ViewController3.h"
#import "YFJLeftSwipeDeleteTableView.h"
#import "YFJMenuButton.h"

@interface ViewController3 () {
    NSMutableArray * _dataArray;
    UIButton * _deleteButton;
    NSIndexPath * _editingIndexPath;

    UISwipeGestureRecognizer * _leftGestureRecognizer;
    UISwipeGestureRecognizer * _rightGestureRecognizer;
    UITapGestureRecognizer * _tapGestureRecognizer;
}

@property (nonatomic, strong) YFJLeftSwipeDeleteTableView * tableView;

@end

@implementation ViewController3

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _dataArray = [@[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10)] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = self.view.bounds;
    self.tableView = [[YFJLeftSwipeDeleteTableView alloc] initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    ViewController3 * __weak weakSelf = self;

    UIView* swipeView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 128, 44)];

    YFJMenuButton * deleteButton = [[YFJMenuButton alloc] initWithTitle:@"Delete" backgroundColor:[UIColor redColor] actionBlock:^(NSIndexPath * indexPath) {
        ViewController3 * strongSelf = weakSelf;
        NSLog(@"Delete button tapped at section : %d, row : %d, data : %@", indexPath.section, indexPath.row, strongSelf->_dataArray[indexPath.row]);
        [strongSelf.tableView.dataSource tableView:strongSelf.tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
    }];

    deleteButton.frame = CGRectMake(0, 0, 64, 44);

    YFJMenuButton * moreButton = [[YFJMenuButton alloc] initWithTitle:@"More" backgroundColor:[UIColor lightGrayColor] actionBlock:^(NSIndexPath * indexPath) {
        ViewController3 * strongSelf = weakSelf;
        NSLog(@"More button tapped at section : %d, row : %d, data : %@", indexPath.section, indexPath.row, strongSelf->_dataArray[indexPath.row]);
    }];

    moreButton.frame = CGRectMake(64, 0, 64, 44);

    [swipeView addSubview:deleteButton];
    [swipeView addSubview:moreButton];

    swipeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

    self.tableView.swipeView = swipeView;

    [self.view addSubview:self.tableView];

    self.title = @"Customize Delete Button Sample";
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
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Data at Row %@", _dataArray[indexPath.row]];

    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [(YFJLeftSwipeDeleteTableView*)tableView hideSwipeView];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
