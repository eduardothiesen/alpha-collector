//
//  ViewController.swift
//  Accelerometer Collector
//
//  Created by Eduardo Thiesen on 08/08/16.
//  Copyright © 2016 thiesen. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet var startButton: UIButton!
    @IBOutlet var startButtonLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var exportDataButton: UIButton!
    
    let manager: CMMotionManager = CMMotionManager()
    let formatter: NSDateFormatter = NSDateFormatter()
    let fileManager: NSFileManager = NSFileManager.defaultManager()
    
    var currentStatus: String!
    
    var loader: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss.sssss"
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentStatus = "WALKING_SLOW"
            break
        case 1:
            currentStatus = "WALKING_MEDIUM"
            break
        case 2:
            currentStatus = "WALKING_FAST"
            break
        case 3:
            currentStatus = "JOGGING"
            break
        case 4:
            currentStatus = "RUNNING"
            break
        default:
            break
        }

        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
        let textFileDataPath = documentsPath?.stringByAppendingString("/data")
        
        if !fileManager.fileExistsAtPath(textFileDataPath!) {
            do {
                try fileManager.createDirectoryAtPath(textFileDataPath!, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("DEU MERDA!!!!!")
            }
        }
        
        let filepath1 = textFileDataPath!.stringByAppendingString("data.txt")

        if !fileManager.fileExistsAtPath(filepath1) {
            fileManager.createFileAtPath(filepath1, contents: nil, attributes: nil)
        }
        
        loader = LoadingView.sharedInstance.loadSpinner()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(stopRecording as Void -> Void), name: "applicationWillResignActive", object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
        let textFileDataPath = documentsPath?.stringByAppendingString("/data")
        
        let filepath = textFileDataPath!.stringByAppendingString("data.txt")
        
        stopRecording(filepath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    @IBAction func segmentedControlSelectedIndexChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentStatus = "WALKING_SLOW"
            UIView.animateWithDuration(0.34, animations: {
               self.view.backgroundColor = UIColor(red: 145.0/255.0, green: 209.0/255.0, blue: 236.0/255.0, alpha: 1.0)
                self.startButtonLabel.textColor = UIColor(red: 145.0/255.0, green: 209.0/255.0, blue: 236.0/255.0, alpha: 1.0)
                
            })
            break
        case 1:
            currentStatus = "WALKING_MEDIUM"
            UIView.animateWithDuration(0.34, animations: {
                self.view.backgroundColor = UIColor(red: 169.0/255.0, green: 185.0/255.0, blue: 205.0/255.0, alpha: 1.0)
                self.startButtonLabel.textColor = UIColor(red: 169.0/255.0, green: 185.0/255.0, blue: 205.0/255.0, alpha: 1.0)
            })
            break
        case 2:
            currentStatus = "WALKING_FAST"
            UIView.animateWithDuration(0.34, animations: {
                self.view.backgroundColor = UIColor(red: 194.0/255.0, green: 161.0/255.0, blue: 176.0/255.0, alpha: 1.0)
                self.startButtonLabel.textColor = UIColor(red: 194.0/255.0, green: 161.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            })
            break
        case 3:
            currentStatus = "JOGGING"
            UIView.animateWithDuration(0.34, animations: {
                self.view.backgroundColor = UIColor(red: 217.0/255.0, green: 137.0/255.0, blue: 146.0/255.0, alpha: 1.0)
                self.startButtonLabel.textColor = UIColor(red: 217.0/255.0, green: 137.0/255.0, blue: 146.0/255.0, alpha: 1.0)
            })
            break
        case 4:
            currentStatus = "RUNNING"
            UIView.animateWithDuration(0.34, animations: {
                self.view.backgroundColor = UIColor(red: 241.0/255.0, green: 114.0/255.0, blue: 117.0/255.0, alpha: 1.0)
                self.startButtonLabel.textColor = UIColor(red: 241.0/255.0, green: 114.0/255.0, blue: 117.0/255.0, alpha: 1.0)
            })
            break
        default:
            break
        }
    }
    @IBAction func exportData(sender: AnyObject) {
        if let alert = Reachability.verifyConnection() {
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            
            let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
            let textFileDataPath = documentsPath?.stringByAppendingString("/data")
            
            let filepath = textFileDataPath!.stringByAppendingString("data.txt")
            
            let file = NSFileHandle(forReadingAtPath: filepath)
            
            if file == nil {
                print("File open failed")
                
                let alertController: UIAlertController = UIAlertController(title: "Atenção", message: "Não há nenhum arquivo para ser salvo no servidor.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                let databuffer = file?.readDataToEndOfFile()
                
                LoadingView.sharedInstance.startLoader(self.loader)
                
                RestAPIManager.sharedInstance.uploadFile(databuffer!) { (json: JSON) in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ 
                        LoadingView.sharedInstance.stopLoader(self.loader)
                    })
                    
                    print(json)
                    if json["status"] == "CREATED" {
                        do {
                         try self.fileManager.removeItemAtPath(filepath)
                        } catch {
                            print("Não deletou")
                        }
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            let alertController: UIAlertController = UIAlertController(title: "Pronto", message: "Arquivo salvo com sucesso.", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })
                    } else if json["arquivo"] == "The submitted file is empty." {
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            let alertController: UIAlertController = UIAlertController(title: "Atenção", message: "Não há nenhum arquivo para enviar ao servidor.", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })
                    } else {
                        NSOperationQueue.mainQueue().addOperationWithBlock({
                            let alertController: UIAlertController = UIAlertController(title: "Atenção", message: "Houve um erro ao tentar salvar o arquivo no servidor. Tente novamente.", preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alertController, animated: true, completion: nil)
                        })
                    }
                }
                
                file?.closeFile()
            }
        }
    }
    
    @IBAction func startRecording(sender: AnyObject) {
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
        let textFileDataPath = documentsPath?.stringByAppendingString("/data")

        let filepath = textFileDataPath!.stringByAppendingString("data.txt")
        if !fileManager.fileExistsAtPath(filepath) {
            fileManager.createFileAtPath(filepath, contents: nil, attributes: nil)
        }
        
        if startButtonLabel.text == "Começar" {
            self.startButtonLabel.text = "Parar"
            self.segmentedControl.enabled = false
            self.exportDataButton.enabled = false
            
            if manager.accelerometerAvailable {
                manager.accelerometerUpdateInterval = 0.000000000001
                manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: { (data: CMAccelerometerData?, error: NSError?) in
                    let reading: NSString = NSString(format: "%f,%f,%f,%f,%@\n", NSDate().timeIntervalSince1970, (data?.acceleration.x)!, (data?.acceleration.y)!, (data?.acceleration.z)!, self.currentStatus)
                    
                    let file: NSFileHandle? = NSFileHandle(forUpdatingAtPath: filepath)
                    
                    if file == nil {
                        print("File open failed")
                    } else {
                        let data = reading.dataUsingEncoding(NSUTF8StringEncoding)
                        file?.seekToEndOfFile()
                        file?.writeData(data!)
                        file?.closeFile()
                    }
                })
            }
        } else {
            stopRecording(filepath)
        }
    }
    
    func stopRecording(filepath: String) {
        self.startButtonLabel.text = "Começar"
        self.segmentedControl.enabled = true
        self.exportDataButton.enabled = true
        
        manager.stopAccelerometerUpdates()
        
        let file = NSFileHandle(forReadingAtPath: filepath)
        
        if file == nil {
            print("File open failed")
            
            let alertController: UIAlertController = UIAlertController(title: "Atenção", message: "Houve um erro ao finalizar a gravação.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let databuffer = file?.readDataToEndOfFile()
            
            let theString : NSString = NSString(data: databuffer!, encoding: NSUTF8StringEncoding)!
            print(theString)
            
            file?.closeFile()
            
            let alertController: UIAlertController = UIAlertController(title: "Pronto", message: "Gravação concluída.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)

        }
    }
    
    func stopRecording() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first
        let textFileDataPath = documentsPath?.stringByAppendingString("/data")
        
        let filepath = textFileDataPath!.stringByAppendingString("data.txt")

        stopRecording(filepath)
    }
}

