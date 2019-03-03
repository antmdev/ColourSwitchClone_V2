//
//  MenuScene.swift
//  ColourSwitcher
//
//  Created by Ant Milner on 03/03/2019.
//  Copyright © 2019 Ant Milner. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView)
    {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        addLogo()
        addLabels()
    }

    func addLogo()
    {
        let logo = SKSpriteNode(imageNamed: "logo")                                     //assign logo
        logo.size = CGSize(width: frame.width/4, height: frame.width/4)                 //define logo size
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)     //define logo position
        addChild(logo)
    }
    
    func addLabels()
    {
        let playLabel = SKLabelNode(text: "Tap to Play!")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 50.0
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playLabel)
        animateStretch(label: playLabel)
        
        //add the user defaults score value from gameScene to highscore label
        let highScoreLabel = SKLabelNode(text: "HighScore: " + "\(UserDefaults.standard.integer(forKey: "Highscore"))")
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.fontSize = 40.0
        highScoreLabel.fontColor = UIColor.white
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highScoreLabel.frame.size.height*4)
        addChild(highScoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "Recent Score: " + "\(UserDefaults.standard.integer(forKey: "RecentScore"))")
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 40.0
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highScoreLabel.position.y - recentScoreLabel.frame.size.height*2)
        addChild(recentScoreLabel)
        
    }
    
    func animateFlash(label: SKLabelNode)
    {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let sequence = SKAction.sequence([fadeOut,fadeIn])    //combine fadein/fadeout in a sequence array
        label.run(SKAction.repeatForever(sequence))            //run the sequence array
    }
    
    func animateStretch(label: SKLabelNode) {  //animate the label stretch on / off
        
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp,scaleDown])
        label.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)    //tap to play
    {
        let gameScene = GameScene(size: view!.bounds.size)                       //assigne gameScene and (fill the screen)
        view!.presentScene(gameScene)                                            //change to GameScene (fill the screen)
    }
}
