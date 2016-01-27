//
//  CameraViewController.m
//  Project
//
//  Created by Adi Azarya on 23/12/2015.
//  Copyright © 2015 Adi Azarya. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PostUploadViewController.h"


@implementation CameraViewController
AVCaptureStillImageOutput *stillImageOutput;
@synthesize imageView;


-(void)viewDidLoad{
    [super viewDidLoad];
}


-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setAllowsEditing:YES];
    [imagePicker setDelegate:self];
    
    //place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];

}


- (IBAction)selectFromLib:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (IBAction)postThisPhoto:(id)sender {
}


//This is called when the UIImagePickerController successfully picks up an image from the image roll.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = selectedImage;
    
    if([picker sourceType] == UIImagePickerControllerSourceTypeCamera){//check if the object is from the camera or from the lib.
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, nil, nil);
    }
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//This is called when user presses the Cancel button on the UIImagePickerView.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"postToShare"]){
        PostUploadViewController *post = segue.destinationViewController;
        self.imageToDisplay = self.imageView;
        post.imageToDisplay = self.imageToDisplay;
        
    }
}

@end
