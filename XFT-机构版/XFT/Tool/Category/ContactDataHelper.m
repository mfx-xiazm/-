//
//  ContactDataHelper.m
//  WeChatContacts-demo
//
//  Created by shen_gh on 16/3/12.
//  Copyright © 2016年 com.joinup(Beijing). All rights reserved.
//

#import "ContactDataHelper.h"
#import <UIKit/UIKit.h>
#import "NSString+HXNExtension.h"

@implementation ContactDataHelper
// 按首字母分组排序数组
+(NSDictionary *)sortObjectsAccordingToInitialWith:(NSArray *)willSortArr SortKey:(NSString *)sortkey {
    
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    NSMutableArray *firstChar = [NSMutableArray arrayWithCapacity:10];
    //将每个名字分到某个section下
    for (id Model in willSortArr) {
        //获取name属性的值所在的位置，比如"林丹"，首字母是L，在A~Z中排第11（第一位是0），sectionNumber就为11
        NSInteger sectionNumber = [collation sectionForObject:Model collationStringSelector:NSSelectorFromString(sortkey)];
        
        //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:Model];
        
        //拿出每名字的首字母
        NSString * str= collation.sectionTitles[sectionNumber];
        [firstChar addObject:str];
    }
    
    //返回首字母排好序的数据
    NSArray *firstCharResult = [self SortFirstChar:firstChar];
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
        }
    }
    return @{@"CYPinyinGroupResultArray":finalArr,
             @"CYPinyinGroupCharArray":firstCharResult};
}
+(NSArray *)SortFirstChar:(NSArray *)firstChararry{
    
    //数组去重复
    NSMutableArray *noRepeat = [[NSMutableArray alloc]init];
    NSMutableSet *set = [[NSMutableSet alloc]initWithArray:firstChararry];
    [set enumerateObjectsUsingBlock:^(id obj , BOOL *stop){
        [noRepeat addObject:obj];
    }];
    
    //字母排序
    NSArray *resultkArrSort1 = [noRepeat sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //把”#“放在最后一位
    NSMutableArray *resultkArrSort2 = [[NSMutableArray alloc]initWithArray:resultkArrSort1];
    if ([resultkArrSort2 containsObject:@"#"]) {
        [resultkArrSort2 removeObject:@"#"];
        [resultkArrSort2 addObject:@"#"];
    }
    
    return resultkArrSort2;
}
@end
