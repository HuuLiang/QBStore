//
//  QBSTicketInstruction.h
//  QBStore
//
//  Created by Sean Yue on 2016/11/10.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBSJSONResponse.h"

@interface QBSTicketInstruction : QBSJSONResponse

@property (nonatomic,retain) NSArray<NSString *> *exUsageSpecList;

@end
