//
//  PhotoButton.m
//
//  Created by AT on 6/18/12.
//

#import "TMEPhotoButton.h"
#import "PBImageHelper.h"
#import "AFPhotoEditorController.h"

#define DELETE_PHOTO  @"Delete Photo"
#define CHOOSE_PHOTO  @"Choose Photo"
#define TAKE_PHOTO    @"Take Photo"

@implementation TMEPhotoButton

@synthesize viewController;
@synthesize popoverController;
@synthesize photoSize;
@synthesize hasPhoto;

- (void)resetAttributes
{
  self.hasPhoto = NO;
  [self addTarget: self action: @selector(button_clicked:) forControlEvents: UIControlEventTouchUpInside];
  [self setBackgroundImage:[UIImage imageNamed:@"add-photo-placeholder"] forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self resetAttributes];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if((self = [super initWithCoder:aDecoder])){
    [self resetAttributes];
	}
	return self;
}

- (void)button_clicked: (id)sender
{
  //Checks if button has image, if yes, add destructive button.
  id destructiveButton = self.hasPhoto ? DELETE_PHOTO : nil;
  
    // cancel button will not show up on iPad
  UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                initWithTitle:nil
                                delegate:self
                                cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:destructiveButton
                                otherButtonTitles:TAKE_PHOTO, CHOOSE_PHOTO, nil];
  actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
  [actionSheet showInView: self.viewController.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:NO completion:nil];
    
    [self beforeGetImageWithPhotoButton:self];
    
    UIImage *image = nil;
    
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
  
    [self setBackgroundImage:image forState:UIControlStateNormal];
  self.hasPhoto = YES;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)takeOrChoosePhoto:(BOOL)take
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    
    if (take) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Oh Snap" delegate:nil cancelButtonTitle:@"Failed to load the camera." otherButtonTitles:nil];
            [alert show];
        }
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; 
    }
    
    [self.viewController presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate protocol

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index
{
    if ([[actionSheet buttonTitleAtIndex:index] isEqualToString:DELETE_PHOTO]) {        // delete photo
        [self resetAttributes];
    } else if ([[actionSheet buttonTitleAtIndex:index] isEqualToString:TAKE_PHOTO]) { // take photo
        [self takeOrChoosePhoto:TRUE];
    } else if ([[actionSheet buttonTitleAtIndex:index] isEqualToString:CHOOSE_PHOTO]) { // choose photo
        [self takeOrChoosePhoto:FALSE];
    } else {                       // cancel
      return;
    }
}

#pragma mark - Blocks actions
- (void)beforeGetImageWithPhotoButton:(TMEPhotoButton *)photoButton
{
    if ([self.viewController respondsToSelector:@selector(beforeGetImageWithPhotoButton:)]) {
        [self.viewController performSelector:@selector(beforeGetImageWithPhotoButton:) withObject:self];
    }
}
- (void)didFinishGetImageWithImageUrl:(NSString *)localURL
{
    if ([self.viewController respondsToSelector:@selector(didFinishGetImageWithImageUrl:)]) {
        [self.viewController performSelector:@selector(didFinishGetImageWithImageUrl:) withObject:localURL];
    }
}

@end