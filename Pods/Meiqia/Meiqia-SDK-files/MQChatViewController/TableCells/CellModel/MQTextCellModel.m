//
//  MQTextCellModel.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQTextCellModel.h"
#import "MQTextMessageCell.h"
#import "MQChatBaseCell.h"
#import "MQChatFileUtil.h"
#import "MQStringSizeUtil.h"
#import <UIKit/UIKit.h>
#import "MQChatViewConfig.h"
#import "MQImageUtil.h"
#import "TTTAttributedLabel.h"
#import "MQChatEmojize.h"
#import "MQServiceToViewInterface.h"
#ifndef INCLUDE_MEIQIA_SDK
#import "UIImageView+WebCache.h"
#endif

/**
 * 敏感词汇提示语的长度
 */
static CGFloat const kMQTextCellSensitiveWidth = 150.0;
/**
 * 敏感词汇提示语的高度
 */
static CGFloat const kMQTextCellSensitiveHeight = 25.0;

@interface MQTextCellModel()

/**
 * @brief cell中消息的id
 */
@property (nonatomic, readwrite, strong) NSString *messageId;

/**
 * @brief 消息的文字
 */
@property (nonatomic, readwrite, copy) NSAttributedString *cellText;

/**
 * @brief 消息的文字属性
 */
@property (nonatomic, readwrite, copy) NSDictionary *cellTextAttributes;

/**
 * @brief 消息的时间
 */
@property (nonatomic, readwrite, copy) NSDate *date;

/**
 * @brief 发送者的头像Path
 */
@property (nonatomic, readwrite, copy) NSString *avatarPath;

/**
 * @brief 发送者的头像的图片名字
 */
@property (nonatomic, readwrite, copy) UIImage *avatarImage;

/**
 * @brief 用户名字，暂时没用
 */
@property (nonatomic, readwrite, copy) NSString *userName;

/**
 * @brief 聊天气泡的image
 */
@property (nonatomic, readwrite, copy) UIImage *bubbleImage;

/**
 * @brief 消息气泡的frame
 */
@property (nonatomic, readwrite, assign) CGRect bubbleImageFrame;

/**
 * @brief 消息气泡中的文字的frame
 */
@property (nonatomic, readwrite, assign) CGRect textLabelFrame;

/**
 * @brief 发送者的头像frame
 */
@property (nonatomic, readwrite, assign) CGRect avatarFrame;

/**
 * @brief 发送状态指示器的frame
 */
@property (nonatomic, readwrite, assign) CGRect sendingIndicatorFrame;

/**
 * @brief 发送出错图片的frame
 */
@property (nonatomic, readwrite, assign) CGRect sendFailureFrame;

/**
 * @brief 消息的来源类型
 */
@property (nonatomic, readwrite, assign) MQChatCellFromType cellFromType;

/**
 * @brief 消息文字中，数字选中识别的字典 [number : range]
 */
@property (nonatomic, readwrite, strong) NSDictionary *numberRangeDic;

/**
 * @brief 消息文字中，url选中识别的字典 [url : range]
 */
@property (nonatomic, readwrite, strong) NSDictionary *linkNumberRangeDic;

/**
 * @brief 消息文字中，email选中识别的字典 [email : range]
 */
@property (nonatomic, readwrite, strong) NSDictionary *emailNumberRangeDic;

/**
 * @brief cell的宽度
 */
@property (nonatomic, readwrite, assign) CGFloat cellWidth;

/**
 * @brief cell的高度
 */
@property (nonatomic, readwrite, assign) CGFloat cellHeight;

/**
 * @brief 消息文字中，是否包含敏感词汇
 */
@property (nonatomic, readwrite, assign) BOOL isSensitive;

/**
 * @brief cell中消息的会话id
 */
@property (nonatomic, readwrite, strong) NSString *conversionId;

/**
 * @brief 敏感词汇提示语frame
 */
@property (nonatomic, readwrite, assign) CGRect sensitiveLableFrame;

/**
 * @brief 标签签的tagList
 */
@property (nonatomic, readwrite, strong) MQTagListView *cacheTagListView;

/**
 * @brief 标签的数据源
 */
@property (nonatomic, readwrite, strong) NSArray *cacheTags;


@property (nonatomic, strong) TTTAttributedLabel *textLabelForHeightCalculation;

@property (nonatomic, strong) NSString *messageContent;

@end

@implementation MQTextCellModel

- (MQTextCellModel *)initCellModelWithMessage:(MQTextMessage *)message
                                    cellWidth:(CGFloat)cellWidth
                                     delegate:(id<MQCellModelDelegate>)delegator
{
    if (self = [super init]) {
        self.textLabelForHeightCalculation = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        self.textLabelForHeightCalculation.numberOfLines = 0;
        self.messageId = message.messageId;
        self.conversionId = message.conversionId;
        self.sendStatus = message.sendStatus;
        self.isSensitive = message.isSensitive;
        self.cellFromType = message.fromType == MQChatMessageIncoming ? MQChatCellIncoming : MQChatCellOutgoing;
        self.messageContent = message.content;
        self.cellWidth = cellWidth;
        if (message.tags) {
            CGFloat maxWidth = cellWidth - kMQCellAvatarToHorizontalEdgeSpacing - kMQCellAvatarDiameter - kMQCellAvatarToBubbleSpacing - kMQCellBubbleToTextHorizontalLargerSpacing - kMQCellBubbleToTextHorizontalSmallerSpacing - kMQCellBubbleMaxWidthToEdgeSpacing;
            NSMutableArray *titleArr = [NSMutableArray array];
            for (MQMessageBottomTagModel * model in message.tags) {
                [titleArr addObject:model.name];
            }
            self.cacheTagListView = [[MQTagListView alloc] initWithTitleArray:titleArr andMaxWidth:maxWidth tagBackgroundColor:[UIColor colorWithWhite:1 alpha:0] tagTitleColor:[UIColor grayColor] tagFontSize:12.0 needBorder:YES];
            self.cacheTags = message.tags;
        }
        NSMutableParagraphStyle *contentParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        contentParagraphStyle.lineSpacing = kMQTextCellLineSpacing;
        contentParagraphStyle.lineHeightMultiple = 1.0;
        contentParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        contentParagraphStyle.alignment = NSTextAlignmentLeft;
        NSMutableDictionary *contentAttributes
          = [[NSMutableDictionary alloc]
           initWithDictionary:@{
                                NSParagraphStyleAttributeName : contentParagraphStyle,
                                NSFontAttributeName : [UIFont systemFontOfSize:kMQCellTextFontSize]
                                }];
        if (message.fromType == MQChatMessageOutgoing) {
            [contentAttributes setObject:(__bridge id)[MQChatViewConfig sharedConfig].outgoingMsgTextColor.CGColor forKey:(__bridge id)kCTForegroundColorAttributeName];
        } else {
            [contentAttributes setObject:(__bridge id)[MQChatViewConfig sharedConfig].incomingMsgTextColor.CGColor forKey:(__bridge id)kCTForegroundColorAttributeName];
        }
        self.cellTextAttributes = [[NSDictionary alloc] initWithDictionary:contentAttributes];
        self.cellText = [[NSAttributedString alloc] initWithString:[MQServiceToViewInterface convertToUnicodeWithEmojiAlias:message.content] attributes:self.cellTextAttributes];
        self.date = message.date;
        self.cellHeight = 44.0;
        self.delegate = delegator;
        if (message.userAvatarImage) {
            self.avatarImage = message.userAvatarImage;
        } else if (message.userAvatarPath.length > 0) {
            self.avatarPath = message.userAvatarPath;
            [MQServiceToViewInterface downloadMediaWithUrlString:message.userAvatarPath progress:^(float progress) {
            } completion:^(NSData *mediaData, NSError *error) {
                if (mediaData && !error) {
                    self.avatarImage = [UIImage imageWithData:mediaData];
                } else {
                    self.avatarImage = message.fromType == MQChatMessageIncoming ? [MQChatViewConfig sharedConfig].incomingDefaultAvatarImage : [MQChatViewConfig sharedConfig].outgoingDefaultAvatarImage;
                }
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(didUpdateCellDataWithMessageId:)]) {
                        //通知ViewController去刷新tableView
                        [self.delegate didUpdateCellDataWithMessageId:self.messageId];
                    }
                }
            }];
        } else {
            self.avatarImage = [MQChatViewConfig sharedConfig].incomingDefaultAvatarImage;
            if (message.fromType == MQChatMessageOutgoing) {
                self.avatarImage = [MQChatViewConfig sharedConfig].outgoingDefaultAvatarImage;
            }
        }
        [self configCellWidth:cellWidth];
        //匹配消息文字中的正则
        self.numberRangeDic = [self createRegexMap:[MQChatViewConfig sharedConfig].numberRegexs for:message.content];
        self.linkNumberRangeDic = [self createRegexMap:[MQChatViewConfig sharedConfig].linkRegexs for:message.content];
        self.emailNumberRangeDic = [self createRegexMap:[MQChatViewConfig sharedConfig].emailRegexs for:message.content];
        
        //防止邮件地址被解析为连接地址
        NSMutableDictionary *tempLinkNumberRangDic = [self.linkNumberRangeDic mutableCopy];
        for ( NSString *email in self.emailNumberRangeDic.allKeys) {
            for (NSString *link in self.linkNumberRangeDic.allKeys) {
                if ([email rangeOfString:link].length != 0) {
                    [tempLinkNumberRangDic removeObjectForKey:link];
                }
            }
        }
        self.linkNumberRangeDic = tempLinkNumberRangDic;
    }
    return self;
}

- (NSDictionary *)createRegexMap:(NSArray *)regexs for:(NSString *)s {
    NSMutableDictionary *regexDic = [[NSMutableDictionary alloc] init];
    for (NSString *linkRegex in regexs) {
        
        for (NSTextCheckingResult *matchedResult in [self matchWithRegex:linkRegex in:s]) {
            if (matchedResult.range.location != NSNotFound) {
                [regexDic setValue:[NSValue valueWithRange:matchedResult.range] forKey:[s substringWithRange:matchedResult.range]];
            }
        }
    }
    return regexDic;
}

- (NSArray *)matchWithRegex:(NSString *)r in:(NSString *)string {
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:r options:(NSRegularExpressionCaseInsensitive) error:nil];
    NSArray *matchResults = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    return matchResults;
}

- (void)configCellWidth:(CGFloat)cellWidth {
    //文字最大宽度
    CGFloat maxLabelWidth = cellWidth - kMQCellAvatarToHorizontalEdgeSpacing - kMQCellAvatarDiameter - kMQCellAvatarToBubbleSpacing - kMQCellBubbleToTextHorizontalLargerSpacing - kMQCellBubbleToTextHorizontalSmallerSpacing - kMQCellBubbleMaxWidthToEdgeSpacing;
    //文字高度
    //        CGFloat messageTextHeight = [MQStringSizeUtil getHeightForAttributedText:self.cellText textWidth:maxLabelWidth];
    self.textLabelForHeightCalculation.attributedText = self.cellText;
    CGSize messageTextSize = [self.textLabelForHeightCalculation sizeThatFits:CGSizeMake(maxLabelWidth, MAXFLOAT)];
    CGFloat messageTextHeight = messageTextSize.height;
    
    //判断文字中是否有emoji
//    if ([MQChatEmojize stringContainsEmoji:[self.cellText string]]) {
//        NSAttributedString *oneLineText = [[NSAttributedString alloc] initWithString:@"haha" attributes:self.cellTextAttributes];
//        CGFloat oneLineTextHeight = [MQStringSizeUtil getHeightForAttributedText:oneLineText textWidth:maxLabelWidth];
//        NSInteger textLines = ceil(messageTextHeight / oneLineTextHeight);
//        messageTextHeight += 8 * textLines;
//    }
    //文字宽度
    CGFloat messageTextWidth = [MQStringSizeUtil getWidthForAttributedText:self.cellText textHeight:messageTextHeight];
    if (messageTextSize.width > messageTextWidth) {
        messageTextWidth = messageTextSize.width;
    }
    //#warning 注：这里textLabel的宽度之所以要增加，是因为TTTAttributedLabel的bug，在文字有"."的情况下，有可能显示不出来，开发者可以帮忙定位TTTAttributedLabel的这个bug^.^
    NSRange periodRange = [self.messageContent rangeOfString:@"."];
    if (periodRange.location != NSNotFound) {
        messageTextWidth += 8;
    }
    if (messageTextWidth > maxLabelWidth) {
        messageTextWidth = maxLabelWidth;
    }
    //气泡高度
    CGFloat bubbleHeight = messageTextHeight + kMQCellBubbleToTextVerticalSpacing * 2;
    //气泡宽度
    CGFloat bubbleWidth = messageTextWidth + kMQCellBubbleToTextHorizontalLargerSpacing + kMQCellBubbleToTextHorizontalSmallerSpacing;
    
    //根据消息的来源，进行处理
    UIImage *bubbleImage = [MQChatViewConfig sharedConfig].incomingBubbleImage;
    if ([MQChatViewConfig sharedConfig].incomingBubbleColor) {
        bubbleImage = [MQImageUtil convertImageColorWithImage:bubbleImage toColor:[MQChatViewConfig sharedConfig].incomingBubbleColor];
    }
    if (self.cellFromType == MQChatMessageOutgoing) {
        //发送出去的消息
        bubbleImage = [MQChatViewConfig sharedConfig].outgoingBubbleImage;
        if ([MQChatViewConfig sharedConfig].outgoingBubbleColor) {
            bubbleImage = [MQImageUtil convertImageColorWithImage:bubbleImage toColor:[MQChatViewConfig sharedConfig].outgoingBubbleColor];
        }
        
        //头像的frame
        if ([MQChatViewConfig sharedConfig].enableOutgoingAvatar) {
            self.avatarFrame = CGRectMake(cellWidth-kMQCellAvatarToHorizontalEdgeSpacing-kMQCellAvatarDiameter, kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarDiameter, kMQCellAvatarDiameter);
        } else {
            self.avatarFrame = CGRectMake(cellWidth-kMQCellAvatarToHorizontalEdgeSpacing-kMQCellAvatarDiameter, kMQCellAvatarToVerticalEdgeSpacing, 0, 0);
        }
        //气泡的frame
        self.bubbleImageFrame = CGRectMake(cellWidth-self.avatarFrame.size.width-kMQCellAvatarToHorizontalEdgeSpacing-kMQCellAvatarToBubbleSpacing-bubbleWidth, kMQCellAvatarToVerticalEdgeSpacing, bubbleWidth, bubbleHeight);
        //文字的frame
        self.textLabelFrame = CGRectMake(kMQCellBubbleToTextHorizontalSmallerSpacing, kMQCellBubbleToTextVerticalSpacing, messageTextWidth, messageTextHeight);
        //敏感词汇提示语的frame
        self.sensitiveLableFrame = CGRectMake(CGRectGetMaxX(self.bubbleImageFrame) - kMQTextCellSensitiveWidth, CGRectGetMaxY(self.bubbleImageFrame), kMQTextCellSensitiveWidth, self.isSensitive ? kMQTextCellSensitiveHeight : 0);
    } else {
        //收到的消息
        //头像的frame
        if ([MQChatViewConfig sharedConfig].enableIncomingAvatar) {
            self.avatarFrame = CGRectMake(kMQCellAvatarToHorizontalEdgeSpacing, kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarDiameter, kMQCellAvatarDiameter);
        } else {
            self.avatarFrame = CGRectMake(kMQCellAvatarToHorizontalEdgeSpacing, kMQCellAvatarToVerticalEdgeSpacing, 0, 0);
        }
        //气泡的frame
        self.bubbleImageFrame = CGRectMake(self.avatarFrame.origin.x+self.avatarFrame.size.width+kMQCellAvatarToBubbleSpacing, self.avatarFrame.origin.y, bubbleWidth, bubbleHeight);
        //文字的frame
        self.textLabelFrame = CGRectMake(kMQCellBubbleToTextHorizontalLargerSpacing, kMQCellBubbleToTextVerticalSpacing, messageTextWidth, messageTextHeight);
        //敏感词汇提示语的frame
        self.sensitiveLableFrame = CGRectMake(CGRectGetMinX(self.bubbleImageFrame), CGRectGetMaxY(self.bubbleImageFrame), kMQTextCellSensitiveWidth, self.isSensitive ? kMQTextCellSensitiveHeight : 0);
    }
    
    //气泡图片
    self.bubbleImage = [bubbleImage resizableImageWithCapInsets:[MQChatViewConfig sharedConfig].bubbleImageStretchInsets];
    
    //发送消息的indicator的frame
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kMQCellIndicatorDiameter, kMQCellIndicatorDiameter)];
    self.sendingIndicatorFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-indicatorView.frame.size.width, self.bubbleImageFrame.origin.y+self.bubbleImageFrame.size.height/2-indicatorView.frame.size.height/2, indicatorView.frame.size.width, indicatorView.frame.size.height);
    
    //发送失败的图片frame
    UIImage *failureImage = [MQChatViewConfig sharedConfig].messageSendFailureImage;
    CGSize failureSize = CGSizeMake(ceil(failureImage.size.width * 2 / 3), ceil(failureImage.size.height * 2 / 3));
    self.sendFailureFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-failureSize.width, self.bubbleImageFrame.origin.y+self.bubbleImageFrame.size.height/2-failureSize.height/2, failureSize.width, failureSize.height);
    
    if (self.cacheTagListView) {
        [self.cacheTagListView updateLayoutWithMaxWidth:maxLabelWidth];
        self.cacheTagListView.frame = CGRectMake(self.bubbleImageFrame.origin.x,  CGRectGetMaxY(self.bubbleImageFrame) + kMQCellBubbleToIndicatorSpacing, self.cacheTagListView.bounds.size.width, self.cacheTagListView.bounds.size.height);
    }
    
    //计算cell的高度
    self.cellHeight = self.bubbleImageFrame.origin.y + self.bubbleImageFrame.size.height + kMQCellAvatarToVerticalEdgeSpacing + (self.isSensitive ? kMQTextCellSensitiveHeight : 0) + (self.cacheTagListView != nil ? self.cacheTagListView.frame.size.height + kMQCellBubbleToIndicatorSpacing : 0);
}

#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return self.cellHeight > 0 ? self.cellHeight : 0;
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

- (NSDate *)getCellDate {
    return self.date;
}

- (BOOL)isServiceRelatedCell {
    return true;
}

- (NSString *)getCellMessageId {
    return self.messageId;
}

- (NSString *)getMessageConversionId {
    return self.conversionId;
}

- (void)updateCellSendStatus:(MQChatMessageSendStatus)sendStatus {
    self.sendStatus = sendStatus;
}

- (void)updateCellMessageId:(NSString *)messageId {
    self.messageId = messageId;
}

- (void)updateCellConversionId:(NSString *)conversionId {
    self.conversionId = conversionId;
}

- (void)updateCellMessageDate:(NSDate *)messageDate {
    self.date = messageDate;
}

-(void)updateSensitiveState:(BOOL)state cellText:(NSString *)cellText{
    self.isSensitive = state;
    self.cellText = [[NSAttributedString alloc] initWithString:[MQServiceToViewInterface convertToUnicodeWithEmojiAlias:cellText] attributes:self.cellTextAttributes];
    [self configCellWidth:self.cellWidth];
}

- (void)updateCellFrameWithCellWidth:(CGFloat)cellWidth {
    self.cellWidth = cellWidth;
    [self configCellWidth:cellWidth];
}

- (void)updateOutgoingAvatarImage:(UIImage *)avatarImage {
    if (self.cellFromType == MQChatCellOutgoing) {
        self.avatarImage = avatarImage;
    }
}

@end
