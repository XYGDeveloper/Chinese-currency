//
//  HBCardModel.m
//  HuaBi
//
//  Created by 前海数交（ZJ） on 2018/11/29.
//  Copyright © 2018年 前海数交平台运营. All rights reserved.
//

#import "HBCardModel.h"

@interface HBCardModel ()

@property (nonatomic, copy, readwrite) NSString *cardtypeString;

@end

@implementation HBCardModel

#pragma mark - Getters

- (NSString *)cardtypeString {
    if (!_cardtypeString) {
        
        switch (self.cardtype) {
            case HBCardModelTypeIdentifyCard:
                _cardtypeString = kLocat(@"Identify Verify ID");
                break;
                
            case HBCardModelTypePassport:
                _cardtypeString = kLocat(@"Identify Verify Passport");
                break;
                
            case HBCardModelTypeDriverLicense:
                _cardtypeString = kLocat(@"Identify Verify Driver Licence");
                break;
                
            case HBCardModelTypeOther:
                _cardtypeString = kLocat(@"Identify Verify Other");
                break;
        }
    }
    
    return _cardtypeString;
}

#pragma mark - Public

+ (NSArray<HBCardModel *> *)geneateCards {
    
    HBCardModel *card1 = [HBCardModel new];
    card1.cardtype = HBCardModelTypeIdentifyCard;
    
    HBCardModel *card2 = [HBCardModel new];
    card2.cardtype = HBCardModelTypeDriverLicense;
    
    HBCardModel *card3 = [HBCardModel new];
    card3.cardtype = HBCardModelTypePassport;
    
    HBCardModel *card4 = [HBCardModel new];
    card4.cardtype = HBCardModelTypeOther;
    
    return @[card1, card2, card3, card4];
}


@end
