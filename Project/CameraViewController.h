//
//  CameraViewController.h
//  Project
//
//  Created by tomer aronovsky on 1/2/16.
//  Copyright © 2016 Adi Azarya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property UIImageView* imageToDisplay;

- (IBAction)takePhoto:(id)sender;
- (IBAction)selectFromLib:(id)sender;
- (IBAction)postThisPhoto:(id)sender;


@end
