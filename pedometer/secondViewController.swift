//
//  secondViewController.swift
//  pedometer
//
//  Created by ISSHIN on 09/11/2016.
//  Copyright © 2016 ISSHIN. All rights reserved.
//

import UIKit
import HealthKit

class secondViewController: UIViewController {
    @IBOutlet weak var allCountSteps: UILabel!
    @IBOutlet weak var allCalLabel: UILabel!
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    // HealthStoreの生成.
    let myHealthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // デフォルト値
        userDefaults.register(defaults: ["DataStore": readData()])
        allCountSteps.text = String(readData())
        
        requestAuthorization()
        
        // Do any additional setup after loading the view.
    }
    
    private func requestAuthorization() {
        // 書き込みを許可する型.
        let typeOfWrites = Set(arrayLiteral:
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        )
        
        // 読み込みを許可する型.
        // HKCharacteristicTypeIdentifierDateOfBirthは、readしかできない.
        let typeOfReads = Set(arrayLiteral:
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
                              HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!
        )
        
        //  HealthStoreへのアクセス承認をおこなう.
        myHealthStore.requestAuthorization(toShare: typeOfWrites, read: typeOfReads, completion: { (success, error) in
            if let e = error {
                print("Error: \(e.localizedDescription)")
                return
            }
            
            print(success ? "Success!" : " Failure!")
        })
        
        wreadData()
    }
    
    
    func readData() -> Int {
        // Keyを指定して読み込み
        var int = userDefaults.object(forKey: "DataStore")
        if(int==nil) {
            int=0
            return int as! Int
        }else{
            return int as! Int
        }
    }
    
    private func wreadData() {
        let typeOfWeight = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
        let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let startDate = calendar.startOfDay(for: now)
        let endDate = calendar.date(byAdding: Calendar.Component.day, value: 1, to: startDate)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions.strictStartDate)
        let statsOptions: HKStatisticsOptions = [HKStatisticsOptions.discreteMin, HKStatisticsOptions.discreteMax]
        
        let query = HKStatisticsQuery(quantityType: typeOfWeight!, quantitySamplePredicate: predicate, options: statsOptions, completionHandler: { (query, result, error) in
            if let e = error {
                print("Error: \(e.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                guard result != nil else {
                    return
                }
            }
            
            print(result!)
        })
        myHealthStore.execute(query)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
