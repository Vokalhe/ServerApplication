//
//  EVAWebTableViewController.m
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/10/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import "EVAWebTableViewController.h"

#import "EVAVideo.h"
#import "EVAAudio.h"
#import "EVADocument.h"

#import "EVATableViewCell.h"
#import "EVAHeaderTableViewCell.h"

#import "EVAVideoViewController.h"
#import "EVAAudioViewController.h"
#import "EVAPDFViewController.h"

#import <NSMutableArray+SWUtilityButtons.h>
#import <AFNetworking.h>

@interface EVAWebTableViewController () <NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfVideos;
@property (strong, nonatomic) NSMutableArray *arrayOfAudios;
@property (strong, nonatomic) NSMutableArray *arrayOfDocuments;

@property (strong, nonatomic) NSMutableArray *arraySelectedSectionIndex;
@property (assign, nonatomic) BOOL isMultipleExpansionAllowed;

@end

@implementation EVAWebTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];

    self.arrayOfVideos = [NSMutableArray array];
    self.arrayOfAudios = [NSMutableArray array];
    self.arrayOfDocuments = [NSMutableArray array];
    
    self.isMultipleExpansionAllowed = YES;
    
    self.arraySelectedSectionIndex = [[NSMutableArray alloc] init];

    NSString *path = @"http://localhost:8888/index.xml";
    NSURL *urlString = [NSURL URLWithString:path];
    NSLog(@"%@", urlString);

    NSData *data = [NSData dataWithContentsOfURL:urlString];
    
    [self createPlist];
    
    //temp
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    //
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"video"]) {
        
        EVAVideo *video = [[EVAVideo alloc] initWithDictionary:attributeDict];
        [self.arrayOfVideos addObject:video];
        
    }else if ([elementName isEqualToString:@"audio"]) {
        
        EVAAudio *audio = [[EVAAudio alloc] initWithDictionary:attributeDict];
        [self.arrayOfAudios addObject:audio];
        
    }else if ([elementName isEqualToString:@"document"]) {
        
        EVADocument *document = [[EVADocument alloc] initWithDictionary:attributeDict];
        [self.arrayOfDocuments addObject:document];
    }
   
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self.tableView reloadData];

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.arraySelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
    {
        if (section == 0) {
            return [self.arrayOfVideos count];
        }else if (section == 1) {
            return [self.arrayOfAudios count];
        }else{
            return [self.arrayOfDocuments count];
        }
        
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *arrayTemp = [self compareIndexPath:indexPath];
    
    static NSString *cellIdentifier = @"EVATableViewCell";
    
    EVATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        [tableView registerClass:[EVATableViewCell class] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    }
    
    ParentObject *tempObject = [arrayTemp objectAtIndex:indexPath.row];
    cell.delegate = self;

    NSString* path =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,    NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:tempObject.name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    [cell setRightUtilityButtons:[self rightButtonsWithBool:fileExists] WithButtonWidth:100.0];

    
    [cell configureCellForName:tempObject viewController:self];

    cell.ibNameLabel.text = [NSString stringWithFormat:@"%@", tempObject.name];
    NSLog(@"object - %@ = cell - %@", tempObject.name, cell.ibNameLabel.text);
    cell.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *arrayTemp = [self compareIndexPath:indexPath];
    ParentObject *object = [arrayTemp objectAtIndex:indexPath.row];
    
    return [EVATableViewCell heightForName:object viewController:self];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [EVAHeaderTableViewCell heightForHeader];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *cellIdentifier = @"EVAHeaderTableViewCell";
    EVAHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (headerCell ==nil)
    {
        [tableView registerClass:[EVAHeaderTableViewCell class] forCellReuseIdentifier:cellIdentifier];
        headerCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    }
    
    NSString *title;
    if (section == 0) {
        title = @"Videos";
    }else if (section == 1) {
        title = @"Audios";
    }else{
        title = @"Documents";
    }
    
    if ([self.arraySelectedSectionIndex containsObject:[NSNumber numberWithInteger:section]])
    {
        headerCell.ibOpenButton.selected = YES;
    }
    
    [headerCell configureCellForHeaderViewController:self state:headerCell.ibOpenButton.selected];
    headerCell.ibTitleLabel.text = title;
    [headerCell.ibOpenButton addTarget:self action:@selector(buttonTapShowHideSection:) forControlEvents:UIControlEventTouchUpInside];
    
    [[headerCell ibOpenButton] setTag:section];
    
    return headerCell.contentView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ParentObject *object;
    
    if (indexPath.section == 0) {
        
        object = [self.arrayOfVideos objectAtIndex:indexPath.row];
        EVAVideoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EVAVideoViewController"];
        vc.video = object;
        vc.url = object.url;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (indexPath.section == 1){
        
        object = [self.arrayOfAudios objectAtIndex:indexPath.row];
        EVAAudioViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EVAAudioViewController"];
        vc.audio = object;
        vc.url = object.url;
        vc.titleAudio = object.name;
        [self presentViewController:vc animated:YES completion:nil];
        
    }else{
        
        object = [self.arrayOfDocuments objectAtIndex:indexPath.row];
        EVAPDFViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EVAPDFViewController"];
        vc.document = object;
        vc.pdfURL = object.url;
        vc.titlePDF = object.name;
        [self presentViewController:vc animated:YES completion:nil];

    }
    
}

#pragma mark - SWTableViewCellDelegate

- (BOOL)swipeableTableViewCell:(SWTableViewCell*)cell canSwipeToState:(SWCellState)state{
    return YES;
}

- (void)swipeableTableViewCell:(EVATableViewCell*)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    ParentObject *object;
    
    if (cellIndexPath.section == 0) {
        
        object = [self.arrayOfVideos objectAtIndex:cellIndexPath.row];
        
    }else if (cellIndexPath.section == 1){
        
        object = [self.arrayOfAudios objectAtIndex:cellIndexPath.row];
        
    }else{
        
        object = [self.arrayOfDocuments objectAtIndex:cellIndexPath.row];

    }
    
    NSString* path =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,    NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingPathComponent:object.name];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (fileExists) {
        [self actionDeleteFileWithURL:object.url andObject:object];

    } else {
        [self actionDownloadFileWithURL:object.url andObject:object];

    }
}


#pragma mark - Private Method

-(void) createPlist{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
}

-(NSMutableArray*) compareIndexPath:(NSIndexPath*) indexPath{
    
    NSMutableArray *arrayTemp = [NSMutableArray array];
    
    if (indexPath.section == 0) {
        [arrayTemp addObjectsFromArray:self.arrayOfVideos];
    }else if (indexPath.section == 1) {
        [arrayTemp addObjectsFromArray:self.arrayOfAudios];
    }else{
        [arrayTemp addObjectsFromArray:self.arrayOfDocuments];
    }
    return arrayTemp;
    
}

- (NSArray *)rightButtonsWithBool:(BOOL) isFile
{
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    if (isFile) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                    title:@"Delete"];
    } else {
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor colorWithRed:0.19f green:0.8f blue:0.19f alpha:1.0]
                                                    title:@"Download"];
    }
    
    return rightUtilityButtons;
}
#pragma mark - Actions

-(void) buttonTapShowHideSection:(UIButton*)sender{
    
    if (!sender.selected)
    {
        if (!self.isMultipleExpansionAllowed) {
            [self.arraySelectedSectionIndex replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:sender.tag]];
        }else {
            [self.arraySelectedSectionIndex addObject:[NSNumber numberWithInteger:sender.tag]];
        }
        
        sender.selected = YES;

    }else{
        
        sender.selected = NO;
        
        if ([self.arraySelectedSectionIndex containsObject:[NSNumber numberWithInteger:sender.tag]])
        {
            [self.arraySelectedSectionIndex removeObject:[NSNumber numberWithInteger:sender.tag]];
        }
    }
    if (!self.isMultipleExpansionAllowed) {
        [self.tableView reloadData];
    }else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}

-(void) actionDownloadFileWithURL:(NSURL*) url andObject:(ParentObject*) object{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self.tableView reloadData];
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    [downloadTask resume];
    
}

-(void) actionDeleteFileWithURL:(NSURL*) url andObject:(ParentObject*) object{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:object.name];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        [self.tableView reloadData];
        NSLog(@"all good");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
    
    
}
@end
