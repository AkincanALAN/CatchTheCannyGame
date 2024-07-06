//
//  ViewController.swift
//  CatchTheCannyGame
//
//  Created by Akıncan ALAN on 6/2/24.
//

import UIKit

class ViewController: UIViewController {
   
    //Variables
    
    var cannyArray = [UIImageView]()
    var counter = 10
    var launchScore = 0
    var timerDecrease = Timer()
    var timerHide = Timer()
    var highScore = 0
    
    //Views
    
    @IBOutlet weak var Canny1: UIImageView!
    @IBOutlet weak var Canny2: UIImageView!
    @IBOutlet weak var Canny3: UIImageView!
    @IBOutlet weak var Canny4: UIImageView!
    @IBOutlet weak var Canny5: UIImageView!
    @IBOutlet weak var Canny6: UIImageView!
    @IBOutlet weak var Canny7: UIImageView!
    @IBOutlet weak var Canny8: UIImageView!
    @IBOutlet weak var Canny9: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    //Functions
    
    @objc func timerDecreaseFunc() {
        counter -= 1
        timeLabel.text = "Time: \(String(counter))"
        if counter == 0 {
            timerDecrease.invalidate()
            timerHide.invalidate()
            
            //Highscore
            
            if launchScore > highScore {
                highScore = launchScore
                highScoreLabel.text = " Highscore: \(highScore)"
                UserDefaults.standard.set(highScore, forKey: "highscore")
            }
            
            //Alert
            
            let alert = UIAlertController(title: "Time's Up!", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            let playAgainButton = UIAlertAction(title: "Play Again", style: UIAlertAction.Style.default) { UIAlertAction in
                // Replay Function
                self.launchScore = 0
                self.scoreLabel.text = " Score: \(String(self.launchScore))"
                self.counter = 10
                self.timeLabel.text = " Time: \(String(self.counter))"
                
                self.timerDecrease = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerDecreaseFunc), userInfo: nil, repeats: true)
                self.timerHide = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hideCanny) , userInfo: nil, repeats: true)
            }
            
            alert.addAction(playAgainButton)
            alert.addAction(cancelButton)
            self.present(alert, animated: true)
        }
    }
    
    @objc func scoreIncrease() {
        launchScore += 1
        scoreLabel.text = "Score: \(String(launchScore))"
        }

    @objc func hideCanny() {
        for canny in cannyArray {
            canny.isHidden = true
        }
        let random = Int(arc4random_uniform(UInt32(cannyArray.count - 1)))
        cannyArray[random].isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cannyArray = [Canny1, Canny2, Canny3, Canny4, Canny5, Canny6, Canny7, Canny8, Canny9]
        
        // Highscore check
        
        if let storedScore = UserDefaults.standard.object(forKey: "highscore") as? Int {
            highScore = storedScore
            highScoreLabel.text = "Highscore: \(highScore)"
        } else {
            highScore = 0
            highScoreLabel.text = "Highscore: \(highScore)"
        }
            
        //Images
        
        for interaction in cannyArray {
            interaction.isUserInteractionEnabled = true
        }
        
        for gestures in cannyArray {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(scoreIncrease))
            gestures.addGestureRecognizer(gestureRecognizer)
        }
        
        //Timer
        
        timerDecrease = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDecreaseFunc), userInfo: nil, repeats: true)
        timerHide = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(hideCanny) , userInfo: nil, repeats: true)
        }
}

