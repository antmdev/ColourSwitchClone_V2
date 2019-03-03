//
//  GameScene.swift
//  ColourSwitcher
//
//  Created by Ant Milner on 03/03/2019.
//  Copyright © 2019 Ant Milner. All rights reserved.
//

import SpriteKit

// MARK: Public Data
/**********************************************************************/

enum PlayColors             //Set up posssible colours
{
    
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
    
}

enum SwitchState: Int       //set up switch statement for colour states
{
    case red, yellow, green, blue
}



// MARK: GameScene Class
/**********************************************************************/

class GameScene: SKScene
{
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red           //intiial state of the game
    var currentColorIndex: Int?                  //use this for colors sub-script leave optional for now
    
    override func didMove(to view: SKView)
    {
        setupPhysics()                                              //set game level physics
        layoutScene()                                               //call the screen layout function
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
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0) //set background colour
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")                           //intialise the node
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)  //so colourswitch isnt stuck at bottom of screen
        
        //adding physics to the Scene
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2) //add physics body to circle (colour switch)
        //define the category of the physics body
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false                                          //stops the physics body being affected by forces!
        addChild(colorSwitch)
        
        spawnBall()
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
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2) //add physics body to ball
        //define the category of the physics body
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory      //aassign bitmask category
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory //define which category of bodies caused intersection
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none     //defines which physics bodies can collide
        addChild(ball)
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
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    //Game Over Method
    /********************************************************/
    func gameOver()
    {
        print("GameOver!")
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
            if let ball = contact.bodyA.node?.name == "Ball" ?
            contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as?
            SKSpriteNode
            {
                if currentColorIndex == switchState.rawValue
                {
                    print("Correct!")
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion:
                        {
                            ball.removeFromParent()
                            self.spawnBall()
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
