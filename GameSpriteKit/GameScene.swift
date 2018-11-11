//
//  GameScene.swift
//  GameSpriteKit
//
//  Created by Flávio Silvério on 11/11/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import SpriteKit
import GameplayKit

struct ColliderType {

    static let Player: UInt32 = 1
    static let Enemy: UInt32 = 2

}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var player = SKSpriteNode()
    var direction: Int = 1
    var pointsLabel = SKLabelNode()
    var score: Int = 0 {
        didSet {
            pointsLabel.text = String(score)
        }
    }

    override func didMove(to view: SKView) {


        self.anchorPoint = CGPoint(x: 0.5,y: 0.5)
        self.physicsWorld.contactDelegate = self

        player = SKSpriteNode(imageNamed: "mario")
        player.name = "Player"
        player.setScale(0.1)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: 0, y: -200)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = ColliderType.Player
        player.physicsBody?.collisionBitMask = ColliderType.Enemy
        player.physicsBody?.contactTestBitMask = ColliderType.Enemy

        self.addChild(player)

//        self.physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
//        self.physicsBody?.friction = 0

        pointsLabel = self.childNode(withName: "label") as! SKLabelNode

        addEnemy()
    }

    func addEnemy(){

        let number = arc4random_uniform(2)
        var enemy =  SKSpriteNode(imageNamed: "mario")
        enemy.name = "Enemy"
        enemy.setScale(0.1)
        enemy.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let number2 = Int.random(in: -200 ... 200)

        enemy.position = CGPoint(x: CGFloat(number2), y: 100)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        enemy.physicsBody?.affectedByGravity = true
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.categoryBitMask = ColliderType.Enemy
        enemy.physicsBody?.friction = 10.0

        self.addChild(enemy)

        //score = score + 1

        self.run(SKAction.wait(forDuration: 2)) {
            self.addEnemy()
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {


        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()

        if contact.bodyA.node?.name == "Player" {

            firstBody = contact.bodyA
            secondBody = contact.bodyB

        } else {

            firstBody = contact.bodyB
            secondBody = contact.bodyA

        }

        if firstBody.node?.name == "Player" && secondBody.node?.name == "Enemy" {

            secondBody.node?.removeFromParent()
            score += score + 1

        } else {
            print("walls")
        }

    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        direction = direction * -1

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
        player.position.x = player.position.x + CGFloat(direction * 2)
    }
}
