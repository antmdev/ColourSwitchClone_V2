//
//  GameScene.swift
//  ColourSwitcher
//
//  Created by Ant Milner on 03/03/2019.
//  Copyright © 2019 Ant Milner. All rights reserved.
//

import SpriteKit

class GameScene: SKScene
{
    var colorSwitch: SKSpriteNode!
    
    override func didMove(to view: SKView)
    {
        setupPhysics()                                              //set game level physics
        layoutScene()                                               //call the screen layout function
    }
    
    func setupPhysics()     //Setup world gravity
    {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)          //set gravity
        physicsWorld.contactDelegate = self             //To register the physics contact between 2 bodies
    }
    
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
    
    func spawnBall()        //Spawn the ball
    {
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: 30.0, height: 30.0)
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
       
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2) //add physics body to ball
        //define the category of the physics body
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory      //aassign bitmask category
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory //define which category of bodies caused intersection
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none     //defines which physics bodies can collide
        addChild(ball)
    }
    
}

extension GameScene: SKPhysicsContactDelegate //extension adds functinoality to existing class
    
{
    func didBegin(_ contact: SKPhysicsContact)   //begin contact did begin method, get all info aboutthis contact
    {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask //contactMask defined when either node has contact
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory
        {
            print("Contact")
        }
    }
}
