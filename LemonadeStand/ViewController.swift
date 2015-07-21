//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Akki on 7/10/15.
//  Copyright (c) 2015 Akshatsaini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myMoney: UILabel!
    @IBOutlet weak var myLemons: UILabel!
    @IBOutlet weak var myIceCubes: UILabel!
    @IBOutlet weak var purchaseSuppliesLemonQuantity: UILabel!
    @IBOutlet weak var purchaseSuppliesIceQuantity: UILabel!
    @IBOutlet weak var mixLemonadeLemonQuantity: UILabel!
    @IBOutlet weak var mixLemonadeIceQuantity: UILabel!
    
    var supplies = Supplies(aMoney: 10, aLemons: 1, aIceCubes: 1)
    var price = Price()
    
    var lemonsToPurchase = 0
    var iceCubesToPurchase = 0
    
    var lemonsToMix = 0
    var iceCubesToMix = 0
    
    var weatherArray: [[Int]] = [[-10, -9, -5, -7], [5, 8, 10, 9], [22, 25, 27, 23]]
    var weatherToday: [Int] = [0, 0, 0, 0]
    
    var weatherImageView:UIImageView = UIImageView(frame: CGRect(x: 20, y: 50, width: 50, height: 50))
    
       override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(weatherImageView)
        updateMainView()
        simulateWeatherToday()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //IBActions
    
    @IBAction func purchaseSuppliesAddLemon(sender: UIButton) {
        if supplies.money > price.lemon {
            lemonsToPurchase += 1
            supplies.money -= price.lemon
            supplies.lemons += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough money!")
        }
        
    }
    @IBAction func purchaseSuppliesRemoveLemon(sender: UIButton) {
        if lemonsToPurchase > 1 {
            lemonsToPurchase -= 1
            supplies.money += price.lemon
            supplies.lemons -= 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have anything to return")
        }
        
    }
    @IBAction func purchaseSuppliesAddIce(sender: UIButton) {
        if supplies.money > price.iceCube {
            iceCubesToPurchase += 1
            supplies.money -= price.iceCube
            supplies.iceCubes += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough money!")
        }

    }
    @IBAction func purchaseSuppliesRemoveIce(sender: UIButton) {
        if iceCubesToPurchase > 1 {
            iceCubesToPurchase -= 1
            supplies.money += price.iceCube
            supplies.iceCubes += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have anything to return")
        }
    }
    @IBAction func mixLemonadeAddLemon(sender: UIButton) {
        if supplies.lemons > 0 {
            lemonsToPurchase = 0
            lemonsToMix += 1
            supplies.lemons -= 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough lemons")
        }
    }
    @IBAction func mixLemonadeRemoveLemon(sender: UIButton) {
        if lemonsToMix > 0 {
            lemonsToPurchase = 0
            lemonsToMix -= 1
            supplies.lemons += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough lemon in your inventory")
        }
    }
    @IBAction func mixLemonadeAddIce(sender: UIButton) {
        if supplies.lemons > 0 {
            iceCubesToPurchase = 0
            iceCubesToMix += 1
            supplies.iceCubes -= 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough ice cubes")
        }
    }
    @IBAction func mixLemonadeRemoveIce(sender: UIButton) {
        if iceCubesToMix > 0 {
            iceCubesToPurchase = 0
            iceCubesToMix -= 1
            supplies.iceCubes += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You have nothing to remove")
        }
    }
    @IBAction func startDayButton(sender: UIButton) {
        let average = findAverage(weatherToday)
        let customers = Int(arc4random_uniform(UInt32(average)))
        println("Customers: \(customers) ")
        
        if lemonsToMix == 0 || iceCubesToMix == 0 {
            showAlertWithText( message: "You need to add atleast 1 Lemon and atleast 1 IceCube")
        }
        else {
            let lemonadeRatio = Double(lemonsToMix) / Double(iceCubesToMix)
          // This means that we will iterate the loop from 0 till the number of customers, which is randomly chosen by the random number generator function.
            for x in 0...customers{
                let preference = Double(arc4random_uniform(UInt32(101))) / 100
                if preference < 0.4 && lemonadeRatio > 1 {
                    supplies.money += 1
                    println("Paid")
                }
                else if preference > 0.6 && lemonadeRatio < 1 {
                    supplies.money += 1
                    println("Paid")
                }
                else if preference >= 0.4 && preference <= 0.6 && lemonadeRatio == 1{
                    supplies.money += 1
                    println("Paid")
                }
                else {
                    println("else statement evaluating")
                }
                
            }
            lemonsToPurchase = 0
            iceCubesToPurchase = 0
            lemonsToMix = 0
            iceCubesToMix = 0
            
            simulateWeatherToday()
            updateMainView()
            
        }
        
    }
    
    
    //Helper Functions
    
    func updateMainView () {
        //updates "you have"
        myMoney.text = "$\(supplies.money)"
        myLemons.text = "\(supplies.lemons) Lemons"
        myIceCubes.text = "\(supplies.lemons) IceCubes"
        
        //updates part 1
        purchaseSuppliesLemonQuantity.text = "\(lemonsToPurchase)"
        purchaseSuppliesIceQuantity.text = "\(iceCubesToPurchase)"
        
        //updates part 2
        mixLemonadeLemonQuantity.text = "\(lemonsToMix)"
        mixLemonadeIceQuantity.text = "\(iceCubesToMix)"
        
        
    }
    
    //Helper func for showing an Alert
    func showAlertWithText (header: String = "Warning", message: String) {
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        //adding an action will allow the user to close the message.
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        
        //We can present the UIAlertController instance on the screen by adding the presentViewController func.
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func simulateWeatherToday () {
        let index = Int(arc4random_uniform(UInt32(weatherArray.count)))
        weatherToday = weatherArray[index]
        switch index {
        case 0: weatherImageView.image = UIImage(named: "Cold")
        case 1: weatherImageView.image = UIImage(named: "Mild")
        case 2: weatherImageView.image = UIImage(named: "Warm")
        default: weatherImageView.image = UIImage(named: "Warm")
        }
    }

    func findAverage(data:[Int]) -> Int {
        var sum = 0
        for x in data {
            sum += x
        }
        var average:Double = Double(sum) / Double(data.count)
        var rounded:Int = Int(ceil(average))
        return rounded
    }
    
    

}

