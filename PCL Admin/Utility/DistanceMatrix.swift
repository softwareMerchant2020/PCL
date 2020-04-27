//
//  distanceMatrix.swift
//  PCL Admin
//
//  Created by Varun Nair on 4/24/20.
//  Copyright © 2020 Abihshek. All rights reserved.
//

import Foundation

class DistanceMatrixAPI
{
    
    func URLGenForDistanceMatrixAPI(startPoint: [Double], endPoint: [Double])-> String
    {
        let URL1 = DistanceMatrixAPIuptoOriginURL //"https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins="
        let URL2 = DistanceMatrixAPIdestinationURL //"&destinations="
        let URL3 = DistanceMatrixAPIkeyURL //"&key="
        
        let key = DistanceMatrixAPIkey
        
        let URLForUse = URL1+String(startPoint[0])+","+String(startPoint[1])+URL2+String(endPoint[0])+","+String(endPoint[1])+URL3+key
        return(URLForUse)
    }
    
    func distanceMatrixAPICall(URLForUse: String, completion:@escaping(DistanceMatrixObj?, NSError?) -> Void )
    {
        RestManager.APIData(url: URLForUse , httpMethod: "get", body: nil) { (Data, Error) in
            if Error == nil{
                do {
                    let distanceMatrixReturn = try JSONDecoder().decode(DistanceMatrixObj.self, from: Data as! Data )
                    completion(distanceMatrixReturn, nil)
                } catch let JSONErr{
                    print(JSONErr)
                }
            }
            completion(nil,Error as NSError?)
        }
    }
}
