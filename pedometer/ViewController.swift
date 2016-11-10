//
//  ViewController.swift
//  pedometer
//
//  Created by ISSHIN on 31/10/2016.
//  Copyright © 2016 ISSHIN. All rights reserved.
//

import UIKit
import CoreMotion


class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var stepShow: UILabel!
    var countStep:Int = 0
    var steps:Int = 0
    let pedometer = CMPedometer()
    //var stepNum:Int = 0
    // UserDefaults のインスタンス
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // CMPedometerの確認
        if(CMPedometer.isStepCountingAvailable()){
            
            self.pedometer.startUpdates(from: NSDate() as Date) {
                (data: CMPedometerData?, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        // 歩数
                        self.steps = self.readData()
                        self.steps += Int(data!.numberOfSteps)
                        self.label.text = "steps: \(self.steps)"
                        self.saveData(str: Int(self.steps))
                    }else{
                        self.label.text = "error"
                    }
                })
            }
        }
        // デフォルト値
        userDefaults.register(defaults: ["DataStore": readData()])
        countStep = readData()
        levelLabel.text = String(countStep)
        var countBase:Int = Int(readData())+10
        var level = 1
        if readData()==countBase{
            
            // UIAlertControllerを作成する.
            let myAlert: UIAlertController = UIAlertController(title: "タイトル", message: "メッセージ", preferredStyle: .alert)
            
            // OKのアクションを作成する.
            let myOkAction = UIAlertAction(title: "OK", style: .default) {
                action in print("Action OK!!")
            }
            // OKのActionを追加する.
            myAlert.addAction(myOkAction)
            
            // UIAlertを発動する.
            present(myAlert, animated: true, completion: nil)
            
            level += 1
            stepShow.text = String(level)
            
            var myDefault = UserDefaults.standard
            
            //データを書き込んで
            myDefault.set(countStep, forKey: "DataStore")
            
            //即反映させる
            myDefault.synchronize()
        }
        
//        if readData()>=100 {
//            stepShow.text = "めっちゃ歩いてる！！！"
//        }
//        if readData()>=80 && countStep<100 {
//            stepShow.text = "いい感じ！"
//        }
//        if readData()<80 {
//            stepShow.text="もっと歩こうぜ...."
//        }
        
        
        // アニメーション用の画像
        let image1 = UIImage(named:"para1")!
        let image2 = UIImage(named:"para2")!
        let image3 = UIImage(named:"para3")!
        let image4 = UIImage(named:"para4")!
        
        // UIImage の配列を作る
        var imageListArray :Array<UIImage> = []
        // UIImage 各要素を追加、ちょっと冗長的ですが...
        imageListArray.append(image1)
        imageListArray.append(image2)
        imageListArray.append(image3)
        imageListArray.append(image4)
        
        // 画像サイズ、元画像が少し小さいのでx2にしました
        let rect = CGRect(x:0, y:0, width:image1.size.width/2, height:image1.size.height/2)
        
        // UIImageView のインスタンス生成,ダミーでimage1を指定
        let imageView:UIImageView = UIImageView(image:image1)
        imageView.frame = rect
        
        // 画像が画面中央にくるように位置合わせ
        let screenWidth = self.view.bounds.width
        let screenHeight = self.view.bounds.height
        imageView.center = CGPoint(x:screenWidth/2, y:screenHeight/2)
        // view に追加する
        self.view.addSubview(imageView)
        
        // 画像の配列をアニメーションにセット
        imageView.animationImages = imageListArray
        
        // 1.5秒間隔
        imageView.animationDuration = 1.5
        // 無限繰り返し(0の場合は無限)
        imageView.animationRepeatCount = 0
        // アニメーションを開始
        imageView.startAnimating()
    }
    
    func saveData(str: Int){
    
        // Keyを指定して保存
        userDefaults.set(str, forKey: "DataStore")
        userDefaults.synchronize()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

