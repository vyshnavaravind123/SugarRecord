//
//  SugarRecordRLMContext.swift
//  SugarRecord
//
//  Created by Pedro Piñera Buendía on 11/09/14.
//  Copyright (c) 2014 SugarRecord. All rights reserved.
//

import Foundation
import Realm

public class SugarRecordRLMContext: SugarRecordContext
{
    let realmContext: RLMRealm
    
    init (realmContext: RLMRealm)
    {
        self.realmContext = realmContext
    }
    
    public func beginWritting()
    {
        self.realmContext.beginWriteTransaction()
    }
    
    public func endWritting()
    {
        self.realmContext.commitWriteTransaction()
    }
    
    public func createObject(objectClass: AnyClass) -> AnyObject?
    {
        let objectClass: RLMObject.Type = objectClass as RLMObject.Type
        return objectClass()
    }
    
    public func insertObject(object: AnyObject)
    {
        self.realmContext.addObject(object as RLMObject)
    }
    
    public func find(finder: SugarRecordFinder) -> [AnyObject]?
    {
        let objectClass: RLMObject.Type = finder.objectClass as RLMObject.Type
        var filteredObjects: RLMArray? = nil
        if finder.predicate != nil {
            filteredObjects = objectClass.objectsWithPredicate(finder.predicate)
        }
        else {
            filteredObjects = objectClass.allObjectsInRealm(self.realmContext)
        }
        var sortedObjects: RLMArray = filteredObjects!
        for sorter in finder.sortDescriptors {
            sortedObjects = sortedObjects.arraySortedByProperty(sorter.key, ascending: sorter.ascending)
        }
        
        //TODO - Convert RLMArray to List ( is it possible )
        //TODO - Check elements to know what we have to return
        
        return nil
    }
    
    public func deleteObject(object: AnyObject) -> Bool
    {
        self.realmContext.deleteObject(object as RLMObject)
        return true
    }
    
    public func deleteObjects(objects: [AnyObject]) -> Bool
    {
        var objectsDeleted: Int = 0
        for object in objects {
            let objectDeleted: Bool = deleteObject(object)
            if objectDeleted {
                objectsDeleted++
            }
        }
        SugarRecordLogger.logLevelInfo.log("Deleted \(objectsDeleted) of \(objects.count)")
        return objectsDeleted == objects.count
    }
}