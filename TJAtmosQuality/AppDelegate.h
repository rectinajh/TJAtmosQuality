//
//  AppDelegate.h
//  TJAtmosQuality
//
//  Created by 李巍 on 15/1/17.
//  Copyright (c) 2015年 LW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "BMapKit.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate> {
    BMKMapManager *_mapManager;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

