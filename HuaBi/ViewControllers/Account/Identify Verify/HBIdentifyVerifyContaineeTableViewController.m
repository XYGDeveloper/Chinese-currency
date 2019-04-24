//
//  HBIdentifyVerifyContaineeTableViewController.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBIdentifyVerifyContaineeTableViewController.h"
#import "HBCardModel+Request.h"
#import "WSCameraAndAlbum.h"
#import "UIImage+ZXCompress.h"
#import "ZJImageMagnification.h"
#import "NSObject+SVProgressHUD.h"
#import "HBIdentifyVerifyViewController.h"
#import "UITextField+ChangeClearButton.h"
#import "ICNNationalityModel+Request.h"

@interface HBIdentifyVerifyContaineeTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cardtypeLabel;
@property (weak, nonatomic) IBOutlet UIView *line1View;
@property (weak, nonatomic) IBOutlet UIView *line2View;

@property (nonatomic, strong) HBCardModel *selectedCardModel;
@property (nonatomic, strong) NSArray<HBCardModel *> *cards;

@property (weak, nonatomic) IBOutlet UIImageView *pic1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pic2ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pic3ImageView;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberOfCardTextfield;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *takeIconImageViews;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *verifiedIconImageViews;

@property (nonatomic, copy) NSString *pic1URLString;
@property (nonatomic, copy) NSString *pic2URLString;
@property (nonatomic, copy) NSString *pic3URLString;

@property (nonatomic, weak) UIImageView *currentImageView;

@property (nonatomic, assign) BOOL isShow;

// Names
@property (weak, nonatomic) IBOutlet UILabel *verifiedMsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *frontOfCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *backOfCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *holdeByHandLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *countryActivityIndicatorView;
@property (nonatomic, strong) NSArray<ICNNationalityModel *> *codesOfCountry;
@property (nonatomic, strong) ICNNationalityModel *selectedCodeOfCountry;


@property (nonatomic, assign) BOOL isImageUploadInPorgress;

@end

@implementation HBIdentifyVerifyContaineeTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kThemeColor;
    [self _setupLabelNames];
    if (self.isShow) {
        
        self.nameTextField.enabled = NO;
        self.numberOfCardTextfield.enabled = NO;
        self.nameTextField.text = self.selectedCardModel.name ?: @"--";
        self.numberOfCardTextfield.text = self.selectedCardModel.idcard ?: @"****";
        self.cardtypeLabel.text = self.selectedCardModel.cardtypeString;
        
        self.line1View.hidden = YES;
        self.line2View.hidden = YES;
        
        [self.pic1ImageView setImageURL:[NSURL URLWithString:self.selectedCardModel.pic1]];
        [self.pic2ImageView setImageURL:[NSURL URLWithString:self.selectedCardModel.pic2]];
        [self.pic3ImageView setImageURL:[NSURL URLWithString:self.selectedCardModel.pic3]];
        
        [self.takeIconImageViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
        
        [self.verifiedIconImageViews enumerateObjectsUsingBlock:^(UIView  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
        
    } else {
        self.cards = [HBCardModel geneateCards];
        UIGestureRecognizer *tapGR1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_selectImageAction:)];
        UIGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_selectImageAction:)];
        UIGestureRecognizer *tapGR3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_selectImageAction:)];
        
        [self.pic1ImageView addGestureRecognizer:tapGR1];
        [self.pic2ImageView addGestureRecognizer:tapGR2];
        [self.pic3ImageView addGestureRecognizer:tapGR3];
        
        [self.nameTextField _changeClearButton];
        [self.numberOfCardTextfield _changeClearButton];
        
        [self _requestCountryCodes];
    }
    
}

#pragma mark - Private

- (void)_requestCountryCodes {
    [self.countryActivityIndicatorView startAnimating];
    [ICNNationalityModel requestCountryListWithSuccess:^(NSArray<ICNNationalityModel *> * _Nonnull array, YWNetworkResultModel * _Nonnull model) {
        self.codesOfCountry = array;
        [self.countryActivityIndicatorView stopAnimating];
    } failure:^(NSError * _Nonnull error) {
        [self showInfoWithMessage:error.localizedDescription];
        [self.countryActivityIndicatorView stopAnimating];
    }];
}

- (void)_setupLabelNames {
    self.verifiedMsgLabel.text = kLocat(@"Identify Verify verifiedMsg");
    self.nameLabel.text = kLocat(@"Identify Verify name");
    self.cardTypeNameLabel.text = kLocat(@"Identify Verify cardTypeName");
    self.numberOfCardLabel.text = kLocat(@"Identify Verify numberOfCard");
    self.frontOfCardLabel.text = kLocat(@"Identify Verify frontOfCard");
    self.backOfCardLabel.text = kLocat(@"Identify Verify backOfCard");
    self.holdeByHandLabel.text = kLocat(@"Identify Verify holdeByHand");
    self.cardtypeLabel.text = kLocat(@"Identify Verify cardtype placehoder");
    self.nameTextField.placeholder = kLocat(@"Identify Verify name placehoder");
    self.numberOfCardTextfield.placeholder = kLocat(@"Identify Verify number placehoder");
}

#pragma mark - Actions

- (void)_selectImageAction:(UIGestureRecognizer *)recognizer {
    if (self.isImageUploadInPorgress) {
        return;
    }
    self.isImageUploadInPorgress = YES;
    UIImageView *imageView = (UIImageView *)recognizer.view;
    self.currentImageView = imageView;
    kShowHud;
    
    [WSCameraAndAlbum showSelectPicsWithController:self multipleChoice:NO selectDidDo:^(UIViewController *fromViewController, NSArray *selectedImageDatas) {
        UIImage *image = [[UIImage alloc]initWithData:selectedImageDatas[0]];
        
        HBIdentifyVerifyContaineeTableViewController *vc = (HBIdentifyVerifyContaineeTableViewController *)fromViewController;
        [vc _uploadImage:image];
    } cancleDidDo:^(UIViewController *fromViewController) {
        HBIdentifyVerifyContaineeTableViewController *vc = (HBIdentifyVerifyContaineeTableViewController *)fromViewController;
        [vc _endUploadImageAndHideHub];
    }];
}
- (void)_endUploadImageAndHideHub {
    kHideHud;
    self.isImageUploadInPorgress = NO;
}

- (void)_uploadImage:(UIImage *)image {
    if (!image) {
        [self _endUploadImageAndHideHub];
        return;
    }
    self.currentImageView.image = image;
    self.currentImageView.layer.zPosition = 1;
    kShowHud;
    [kNetwork_Tool uploadImage:image success:^(YWNetworkResultModel *data, id responseObject) {
        [self _endUploadImageAndHideHub];
        
        if ([data succeeded]) {
            NSString *imagePath = [data.result valueForKey:@"path"];
            [self _setImageURLPath:imagePath tag:self.currentImageView.tag];
        } else {
            [self showInfoWithMessage:data.message];
        }
        self.currentImageView = nil;
    } failure:^(NSError *error) {
        self.currentImageView = nil;
        [self _endUploadImageAndHideHub];
        [self showErrorWithMessage:error.localizedDescription];
    }];
}

- (void)_setImageURLPath:(NSString *)imagePath tag:(NSInteger)tag {
    switch (tag) {
        case 1:
            self.pic1URLString = imagePath;
            break;
            
        case 2:
            self.pic2URLString = imagePath;
            break;
            
        case 3:
            self.pic3URLString = imagePath;
            break;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.isShow) {
        if (indexPath.row == 1 || indexPath.row == 3) {
            return 0.;
        }
    } else {
        if (indexPath.row == 0) {
            return 0.;
        }
    }

    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isShow) {
        return;
    }
    
    if (indexPath.row == 1) {
        [self _showSelectCountrySheetVC];
    } else if (indexPath.row == 3) {
        if ([self.selectedCodeOfCountry isChina]) {
            return;
        }
        [self _showTypeOfIDSheetVC];
    }
}

#pragma mark - Public

+ (instancetype)fromStoryboard {
    return  [[UIStoryboard storyboardWithName:@"Verify" bundle:nil] instantiateViewControllerWithIdentifier:@"HBIdentifyVerifyContaineeTableViewController"];
}

- (void)submitAction {
    [self _submit];
}

- (void)showWithCardModel:(HBCardModel *)model {
    self.selectedCardModel = model;
    self.isShow = YES;
}

#pragma mark - Private

- (void)_submit {
    
    if (!self.selectedCodeOfCountry) {
        return;
    }
    NSString *name = self.nameTextField.text;
    NSString *noOfCard = self.numberOfCardTextfield.text;
    if (name.length <= 0) {
        [self showInfoWithMessage:kLocat(@"Identify Verify name placehoder")];
        [self.nameTextField becomeFirstResponder];
        return;
    }
 
    if (!self.selectedCardModel) {
        [self showInfoWithMessage:@"Identify Verify cardtype placehoder"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _showTypeOfIDSheetVC];
        });
        return;
    }
    
    if (noOfCard.length == 0) {
        [self showInfoWithMessage:kLocat(@"Identify Verify number placehoder")];
        [self.numberOfCardTextfield becomeFirstResponder];
        return;
    }
    
    if (self.pic1URLString.length <= 0) {
        [self showInfoWithMessage:kLocat(@"Identify Verify please enter front of card")];
        return;
    }
    if (self.pic2URLString.length <= 0) {
        [self showInfoWithMessage:kLocat(@"Identify Verify please enter back of card")];
        return;
    }
    
    if (self.pic3URLString.length <= 0) {
        [self showInfoWithMessage:kLocat(@"Identify Verify please enter hand-held photo")];
        return;
    }
    
    self.selectedCardModel.name = name;
    self.selectedCardModel.pic1 = self.pic1URLString;
    self.selectedCardModel.pic2 = self.pic2URLString;
    self.selectedCardModel.pic3 = self.pic3URLString;
    self.selectedCardModel.idcard = noOfCard;
    self.selectedCardModel.country_code = self.selectedCodeOfCountry.countrycode;
    
    kShowHud;
    [self.selectedCardModel verifyMemberWithSuccess:^(YWNetworkResultModel * _Nonnull obj) {
        kHideHud;
        if ([obj succeeded]) {
            [self showSuccessWithMessage:obj.message];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                HBIdentifyVerifyViewController *vc = (HBIdentifyVerifyViewController *)self.parentViewController;
                [vc showVerifyingVC];
            });
            
        } else {
            [self showInfoWithMessage:obj.message];
        }
    } failure:^(NSError * _Nonnull error) {
        kHideHud;
        [self showErrorWithMessage:error.localizedDescription];
    }];
}

- (void)_showTypeOfIDSheetVC {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:kLocat(@"Identify Verify cardtype placehoder") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self.cards enumerateObjectsUsingBlock:^(HBCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *aciton = [UIAlertAction actionWithTitle:obj.cardtypeString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.selectedCardModel = obj;
        }];
        [alertController addAction:aciton];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)_showSelectCountrySheetVC {
    if (self.codesOfCountry) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [self.codesOfCountry enumerateObjectsUsingBlock:^(ICNNationalityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *aciton = [UIAlertAction actionWithTitle:obj.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.selectedCodeOfCountry = obj;
            }];
            [alertController addAction:aciton];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kLocat(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Setters

- (void)setSelectedCardModel:(HBCardModel *)selectedCardModel {
    _selectedCardModel = selectedCardModel;
    
    self.cardtypeLabel.text = selectedCardModel.cardtypeString;
    
}

- (void)setCodesOfCountry:(NSArray<ICNNationalityModel *> *)codesOfCountry {
    _codesOfCountry = codesOfCountry;
    if (!self.selectedCodeOfCountry) {
        self.selectedCodeOfCountry = codesOfCountry.firstObject;
    }
}

- (void)setSelectedCodeOfCountry:(ICNNationalityModel *)selectedCodeOfCountry {
    _selectedCodeOfCountry = selectedCodeOfCountry;
    self.countryLabel.text = selectedCodeOfCountry.name;
    
    if ([selectedCodeOfCountry isChina]) {
        self.selectedCardModel = self.cards.firstObject;
    }
}

@end
