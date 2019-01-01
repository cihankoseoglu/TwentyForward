//
//  GameScene.swift
//  Twenty Forward
//
//  Created by Cihan on 24.12.2018.
//  Copyright © 2018 Cihan Koseoglu. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none: UInt32 = 0b01
    static let ball: UInt32 = 0b10
    static let boundary: UInt32 = 0b11
}

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var currentScore : Int = 0
    
    override func sceneDidLoad() {
        lastUpdateTime = 0
        backgroundColor = SKColor.white
    }
    
    override func didMove(to view: SKView) {
        let leftBoundary = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 10, height: frame.height))
        let rightBoundary = SKShapeNode(rect: CGRect(x: frame.width, y: 0, width: 0, height: frame.height))
        
        leftBoundary.physicsBody?.isDynamic = false
        rightBoundary.physicsBody?.isDynamic = false
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        leftBoundary.physicsBody?.categoryBitMask = PhysicsCategory.boundary
        rightBoundary.physicsBody?.categoryBitMask = PhysicsCategory.boundary
        leftBoundary.physicsBody?.collisionBitMask = PhysicsCategory.ball
        rightBoundary.physicsBody?.collisionBitMask = PhysicsCategory.ball
        leftBoundary.fillColor = SKColor(red: 0, green: 0, blue: 33.0/255.0, alpha: 1.0)
        
        addChild(leftBoundary)
        addChild(rightBoundary)
        
        // Set the speed of the ball based on score with var 'speed'
        
        addBall(withSpeed: ballSpeed())
    }
    
    // Return speed of the ball based on the score on a tiered system
    func ballSpeed() -> CGFloat {
        var defaultSpeed : CGFloat = -80.0
        
        defaultSpeed = defaultSpeed - CGFloat(integerLiteral: currentScore) / 10 * 20
        return defaultSpeed
    }
    
    func addBall(withSpeed: CGFloat) {
        let ball = SKSpriteNode(imageNamed: "genericball")
        ball.size = CGSize(width: 60, height: 60)
        ball.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: frame.size.width/2)
        ball.physicsBody?.mass = 0.1
        ball.physicsBody?.friction = 0.0;
        ball.physicsBody?.restitution = 1.0;
        ball.physicsBody?.linearDamping = 0.0;
        ball.physicsBody?.isDynamic = true;
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.ball
        
        addChild(ball)
        ball.physicsBody?.applyImpulse(CGVector(dx: -20.0, dy: -20.0))
        
        // Set the ball color based on speed.
        
    }
    
    func randomVector() -> CGVector {
        let x = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let y = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        return CGVector(dx: x, dy: y)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
}
