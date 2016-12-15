//
//  ViewController.swift
//  WarGame
//
//  Created by Dami Or on 4/16/16.
//  Copyright © 2016 Dami Or. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstCardImageView: UIImageView!
    @IBOutlet weak var secondCardImageView: UIImageView!
    @IBOutlet weak var playRoundButton: UIButton!
    @IBOutlet weak var BackgroundImage: UIImageView!
    
    //Scoring 
    @IBOutlet weak var PlayerScoreLabel: UILabel!
    @IBOutlet weak var EnemyScoreLabel: UILabel!
    
    var secret:String = "a04RHt63bpKc8633s"
    
    var playerScore:Int = 0
    var enemyScore:Int = 0
    
    var cardNamesArray: [String] = ["card2", "card3","card4", "card5", "card6", "card7", "card8", "card9", "card10", "card11", "card12", "card13", "card1"]
    
    var auth_key:String = "M02cnQ51Ji97vwT4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // self.playRoundButton.setTitle("Play", forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playRoundTapped(sender: UIButton) {
        
        //change the play button to play round
        //self.playRoundButton.setTitle("Play Round", forState: UIControlState.Normal)
       
        //randomizing the first card image and changing the string format
        let firstcardNum = Int(arc4random_uniform(13))
        //let firstCardString:String = String(format: "card%i", firstcardNum)
        let firstCardString:String = self.cardNamesArray[firstcardNum]
        
        
        //randomizing the second card
        let secondcardNum = Int(arc4random_uniform(13))
        //let secondCardString:String = String(format: "card%i", secondcardNum)
         let secondCardString:String = self.cardNamesArray[secondcardNum]
        
        
        self.firstCardImageView.image = UIImage(named: firstCardString)
        self.secondCardImageView.image = UIImage(named: secondCardString)
        
        //Determine the winner / higher card
        
        if firstcardNum > secondcardNum {
            //First card is winner
            
            self.playerScore += 1
            self.PlayerScoreLabel.text = String(self.playerScore)
        }
        
        else if firstcardNum < secondcardNum {
            // Second card is winner
            
            self.enemyScore += 1
            self.EnemyScoreLabel.text = String(self.enemyScore)
        }
        
        else {
            // tie! Both cards same
            //do nothing
        }
        
    }

}

