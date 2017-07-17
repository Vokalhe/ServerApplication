//
//  EVAPDFViewController.h
//  ServerApplication
//
//  Created by Zeus El Capitan on 7/11/17.
//  Copyright © 2017 Zeus El Capitan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParentObject;

@interface EVAPDFViewController : UIViewController

@property (strong, nonatomic) NSURL *pdfURL;
@property (weak, nonatomic) IBOutlet UINavigationItem *ibTitle;
@property (strong, nonatomic) NSString *titlePDF;
@property (strong, nonatomic) ParentObject *document;

@end
