//
//  GameScene.swift
//  modelling
//
//  Created by 小渡広和 on 2014/11/26.
//  Copyright (c) 2014年 odo. All rights reserved.
//

import SpriteKit

/*
var moving: Int = 30 //ここの60分の1をjumpとdownのdurationに代入
var jp: Int = 0
var time:Int = moving*/

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player : SKSpriteNode!
//    var afterpos: CGPoint!
    var moving:SKNode!
    var jumpNow: CGPoint!
    var canRestart = Bool()

    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1

    var check = 1

    override func didMoveToView(view: SKView) {
        canRestart = false
        moving = SKNode()
        self.addChild(moving)

        // setup physics
        self.physicsWorld.gravity = CGVectorMake( -10.0, 0.0 )
        self.physicsWorld.contactDelegate = self


        // setup our player
        let playerTexture1 = SKTexture(imageNamed: "player-01")
        playerTexture1.filteringMode = .Nearest
        let playerTexture2 = SKTexture(imageNamed: "player-02")
        playerTexture2.filteringMode = .Nearest
        let playerTexture3 = SKTexture(imageNamed: "player-03")
        playerTexture1.filteringMode = .Nearest
        let playerTexture4 = SKTexture(imageNamed: "player-04")
        playerTexture2.filteringMode = .Nearest


        let anim = SKAction.animateWithTextures([playerTexture1, playerTexture2, playerTexture3, playerTexture4], timePerFrame: 0.05)
        let flap = SKAction.repeatActionForever(anim)

        player = SKSpriteNode(texture: playerTexture1)
        player.setScale(1.0)
        player.position = CGPoint(x: self.frame.size.width * 0.30, y:self.frame.size.height * 0.8)
        jumpNow = player.position
        player.runAction(flap)

        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2.0)
        player.physicsBody?.dynamic = false
        player.physicsBody?.allowsRotation = false

        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = worldCategory
        player.physicsBody?.contactTestBitMask = worldCategory

        self.addChild(player)

        //プレイヤーとなるキャラクター画像
//        self.player = SKSpriteNode(imageNamed:"bou")
//        self.addChild(player)
//        self.player.position = CGPointMake(300,300)
//        player.size = CGSizeMake(40, 40)
//        afterpos = CGPointmake(300,600)
//      player.physicsBody = SKPhysicsBody(circleOfRadius: 16)
//      player.physicsBody?.dynamic = false
//      physicsWorld.gravity = CGVectorMake(0,-0.5)


    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if (moving.speed > 0)  {
//        player.position.x == jumpNow.x + 1
            if(check == 1){
            for touch: AnyObject in touches {
                player.physicsBody?.dynamic = true
                let location = touch.locationInNode(self)

                player.physicsBody?.velocity = CGVectorMake(600, 0)
                player.physicsBody?.applyImpulse(CGVectorMake(0, 0))

                let playerTexture1 = SKTexture(imageNamed: "player-04")
                playerTexture1.filteringMode = .Nearest
                let playerTexture2 = SKTexture(imageNamed: "player-02")
                playerTexture2.filteringMode = .Nearest

                let stop = SKAction.animateWithTextures([playerTexture1, playerTexture2], timePerFrame: 0.05)
                let dlap = SKAction.repeatActionForever(stop)
                player.runAction(dlap)

                check = 0
            }
        }else if canRestart {
           self.resetScene()
        }
        }

/*        for touch: AnyObject in touches {


            if(jp == 0){
                if(time >= moving){
                    jump()
                    jp = 1
                    time = 0
                }
            }
        }*/
}


        func clamp(min: CGFloat, max: CGFloat, value: CGFloat) -> CGFloat {
            if( value > max ) {
                return max
            } else if( value < min ) {
                return min
            } else {
                return value
            }
        }

     override func update(currentTime: CFTimeInterval) {
/*        time += 1
        if(jp == 1){
            if(time >= moving){
                down()
                jp = 0
                time = 0
            }
        }*/

        /* Called before each frame is rendered */
        player.zRotation = clamp( -1, max: 0.5, value: player.physicsBody!.velocity.dy * ( player.physicsBody!.velocity.dy < 0 ? 0.003 : 0.001 ) )

   /*     if(player.position.x < jumpNow.x){
            player.physicsBody?.dynamic = false
        }*/
        if(player.position.x < jumpNow.x){
            player.physicsBody?.dynamic = false
            self.resetScene()
        }
        
    }

    func jump(){
/*        afterpos = CGPointMake(300,500)
        let travelTime = SKAction.moveTo(afterpos, duration: 0.5)
        self.player.runAction(travelTime)
         player.physicsBody?.dynamic = false*/
    }

    func down(){
/*        afterpos = CGPointMake(300,300)
        let travelTime2 = SKAction.moveTo(afterpos, duration: 0.5)
        self.player.runAction(travelTime2)*/
    }


    func resetScene (){
        // Move player to original position and reset velocity
        player.position.x = jumpNow.x
        player.physicsBody?.velocity = CGVectorMake( 0, 0 )
        player.physicsBody?.collisionBitMask = worldCategory
        player.speed = 1.0
        player.zRotation = 0.0

        // Reset _canRestart
        canRestart = false

        // Restart animation
        moving.speed = 1

        let playerTexture1 = SKTexture(imageNamed: "player-01")
        playerTexture1.filteringMode = .Nearest
        let playerTexture2 = SKTexture(imageNamed: "player-02")
        playerTexture2.filteringMode = .Nearest
        let playerTexture3 = SKTexture(imageNamed: "player-03")
        playerTexture1.filteringMode = .Nearest
        let playerTexture4 = SKTexture(imageNamed: "player-04")
        playerTexture2.filteringMode = .Nearest


        let anim = SKAction.animateWithTextures([playerTexture1, playerTexture2, playerTexture3, playerTexture4], timePerFrame: 0.05)
        let flap = SKAction.repeatActionForever(anim)
        player.runAction(flap)

        check = 1
    }
}