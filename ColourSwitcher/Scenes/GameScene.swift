//
//  GameScene.swift
//  ColourSwitcher
//
//  Created by Ant Milner on 03/03/2019.
//  Copyright © 2019 Ant Milner. All rights reserved.
//

import SpriteKit
import AVFoundation

// MARK: Public Data
/**********************************************************************/

//Set Up possible Colours
/********************************************************/
enum PlayColors             //Set up posssible colours
{
    
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
    
}

//Set Up possible states
/********************************************************/
enum SwitchState: Int
{
    case red, yellow, green, blue
}



// MARK: GameScene Class
/**********************************************************************/

class GameScene: SKScene
{
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red           //intiial state of the game
    var currentColorIndex: Int?                 //use this for colors sub-script leave optional for now
    let scoreLabel = SKLabelNode(text: "0")     //define score label
    var score = 0                               //define base score
    
    override func didMove(to view: SKView)
    {
        setupPhysics()                                              //set game level physics
        layoutScene()                                               //call the screen layout function
        inGameMusic()                                               //adding in game music

    }
    
    //Set Up Music In Game
    /********************************************************/
    
    func inGameMusic()
    {
       
        if let musicURL = Bundle.main.url(forResource: "Platformer2", withExtension: "mp3")
        {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
    }
    
    //Set Up game physics
    /********************************************************/
    func setupPhysics()     //Setup world gravity
    {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)          //set gravity
        physicsWorld.contactDelegate = self             //To register the physics contact between 2 bodies
    }
    
    //Call scene layout
    /********************************************************/
    func layoutScene()      //Layout Scene
    {
        //Define background colours
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0) //set background colour
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")                           //intialise the node
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)  //so colourswitch isnt stuck at bottom of screen
        colorSwitch.zPosition = ZPositions.colorSwitch //tap into enum settings to assign zposition value
        //adding physics to the Scene
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2) //add physics body to circle (colour switch)
        //define the category of the physics body
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false                                          //stops the physics body being affected by forces!
        addChild(colorSwitch)
        
        //Define Score Label Settings
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    //Update the score label
    /********************************************************/
    func updateScoreLabel()
    {
        scoreLabel.text = "\(score)"
    }
    
    //Spawn the ball method
    /********************************************************/
    func spawnBall()
    {
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!],
            size: CGSize(width: 30.0, height: 30.0))        //just generates random colour each time its called
        ball.colorBlendFactor = 1.0                         //makes sure the color is applied to the texture
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2) //add physics body to ball
        //define the category of the physics body
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory      //aassign bitmask category
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory //define which category of bodies caused intersection
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none     //defines which physics bodies can collide
        addChild(ball)
        
        increaseBallGravitySpeed()
    }
    
    //Making the game more complicated increasing gravity
    /********************************************************/
    func increaseBallGravitySpeed()
    {
       
        let gravityMultiplier = [-2.0, -3.0, -4.0, -5.0, -6.0, -7.0, -8.0, -9.0, -10.0]
    
        // TO DO - change physics setting to remove acceleration from top of ball drop
        
        // TO DO Text text to say game is speeding up!
                    
        //TO DO SWitch statement for score!
        
        switch score
        {
            case 0...2:
                physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityMultiplier[0])
                print("level 0, Your score is: " + "\(score)")
            case 3...5:
                 GettingFaster()
                physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityMultiplier[1])
                print("level 1, Your score is: " + "\(score)")
            case 6...8:
                physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityMultiplier[2])
                print("level 2, Your score is: " + "\(score)")
            
            //TO DO  - MAYBE leave a case where it sets to default for a break???
            
            case 9...11:
                physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityMultiplier[3])
                print("level 3, Your score is: " + "\(score)")

            case 12...14:
                physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityMultiplier[4])
                print("level 4, Your score is: " + "\(score)")
            case 15...17:
                physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityMultiplier[5])
                print("level 5, Your score is: " + "\(score)")
            case 18...20:
                physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityMultiplier[6])
                print("level 6, Your score is: " + "\(score)")
            case 21...22:
                physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityMultiplier[7])
                print("level 7, Your score is: " + "\(score)")
            default:
                physicsWorld.gravity = CGVector(dx: 0.0, dy: gravityMultiplier[0])
                print("level 0 - Default" + "\(score)")
        }
        
        
    }
                //OnScreen Text for Game Speed
                /********************************************************/
                func GettingFaster()
                {
                    let goingFasterLabel = SKLabelNode(text: "Getting Faster!")
                    goingFasterLabel.fontName = "AvenirNext-Bold"
                    goingFasterLabel.fontSize = 50.0
                    goingFasterLabel.fontColor = UIColor.white
                    goingFasterLabel.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
                    addChild(goingFasterLabel)
                    animateStretch(label: goingFasterLabel)
//                    goingFasterLabel.removeFromParent()
            
                }
    
                func animateStretch(label: SKLabelNode) {  //animate the label stretch on / off
                    
                    let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
                    let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
                    let pause = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([scaleUp,scaleDown, pause])
                    label.run(SKAction.repeat(sequence, count: 2))
                }
    
    //Custom method to turn the Wheel
    /********************************************************/
    func turnWheel()
    {
        if let newState = SwitchState(rawValue: switchState.rawValue + 1)
            {
                switchState = newState
            }
            else
            {
                switchState = .red
            }
            
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.20))
        
        //Added code for sound for nudging movement
        
        let pling = SKAudioNode(fileNamed: "nudge.mp3")
        pling.autoplayLooped = false                    //only play sound once
        backgroundMusic.addChild(pling)
        backgroundMusic.run(SKAction.sequence([
            SKAction.wait(forDuration: 0.0),
            SKAction.run()
                {
                    pling.run(SKAction.play())
            }
            ])
        )
    }
    
    
    //Game Over Method
    /********************************************************/
    func gameOver()
    {
        
        //UserDefaults set up key value pairs (like a library) great for saving small pieces of data
        //you can then assign an integer value to a text value so score will = Recent Score
        //Then we check if the current score is greater than the current high score
        // if there's nothing here it returns zero
        //if it is bigger than the highscore - then we set the current score to ne highscore
    
        UserDefaults.standard.set(score, forKey: "RecentScore")
        
        if score > UserDefaults.standard.integer(forKey: "Highscore")
        {
            
            //TO DO SET A NEW HIGHSCORE NOTIFCATION - POSSIBLY OUTSIDE OF GAME OVER
            
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)                      //setting a new scene on gameover
        
//        run(SKAction.stop())
        run(SKAction.playSoundFileNamed("crash.wav", waitForCompletion: true))  //play crash sound - true so it finishes
        run(SKAction.changePlaybackRate(by: 0.8, duration: 0.8))                //reduced time of sound so menu appears sooner
        {
            self.view!.presentScene(menuScene) //bring us back to menu from MenuScene class
        }
        
    }
            
    //Touches Began - whenever a new touch is recognised in current view
    /********************************************************/
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
    
}


// MARK: GameScene Extension Class for Delegates
/**********************************************************************/
extension GameScene: SKPhysicsContactDelegate //extension adds functinoality to existing class
    
{
    func didBegin(_ contact: SKPhysicsContact)   //begin contact did begin method, get all info aboutthis contact
    {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask //contactMask defined when either node has contact
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory
        {
            //Basically check which node is the ball - Then assign it the constant ball
            if let ball = contact.bodyA.node?.name == "Ball" ?
            contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as?
            SKSpriteNode
            {
                //Now check that the colour is correct and matches the switchstate value
                if currentColorIndex == switchState.rawValue
                {
                    run(SKAction.playSoundFileNamed("bling.wav", waitForCompletion: false))     //play sound
                    score += 1                                                  //increase the score by 1
                    updateScoreLabel()                                          //call update method
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: //fadeout ball as passes through
                        {
                            ball.removeFromParent() //remove old ball from the scene (frees up memory)
                            self.spawnBall() // spawn new ball (we're in closure block so need to explicitly refer to gamescene class with self)
                        })
                }
                else
                {
                    gameOver()
                }
                    
            }
        }
    }
}
