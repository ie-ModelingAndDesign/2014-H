//
//  GameScene.swift
//  modelling
//
//  Created by 小渡広和 on 2014/11/26.
//  Copyright (c) 2014年 odo. All rights reserved.
//

import SpriteKit
import AVFoundation//追加

class GameScene: SKScene, SKPhysicsContactDelegate {

    var delegate_escape: SceneEscapeProtocol?

    //chida
    let redCategory: UInt32 = 0x1 << 0    //赤のブロックのカテゴリー（障害物に）
    let greenCategory: UInt32 = 0x1 << 3  //緑のブロックのカテゴリー（主人公に）
    let blueCategory : UInt32 = 0x1 << 3  //青
    let blackCategory : UInt32 = 0x1 << 3 //黒
//    let yellowCategory: UInt32 = 0x1 << 2    //黄のブロックのカテゴリー（障害物に）
    
    //Takamiyagi 変数指定
    var Wall1 : SKSpriteNode!
    var Wall2 : SKSpriteNode!
    var fukidasi : SKSpriteNode!
    var fukidasi_num = 0
    var fukidasi_flag = 0
    var timecount = 0
    var score = 0
    var count = 0
    var gameover_flag = 0
    
    //takamiyagi chida tuika
    var Wallred1 : SKSpriteNode!
    var Wallred2 : SKSpriteNode!
    var playergreen : SKSpriteNode!
    var playerblue : SKSpriteNode!
    var playerblack : SKSpriteNode!
    var yellowSquare : SKSpriteNode!
    
    
    
    var player : SKSpriteNode!
    var moving:SKNode!
    var jumpNow: CGPoint!
    var canRestart = Bool()

    let playerCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1

    var check = 1
    
    //naotarou
    var qed = 0
    var player2 : SKSpriteNode!
    var player3 : SKSpriteNode!
    var targetMarker : SKSpriteNode!
    var a = 0
    var backGround : SKSpriteNode!
    var w : CGFloat!
    var h : CGFloat!

    var nowScene : SKScene?

    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    override func didMoveToView(view: SKView) {
        
        
        canRestart = false
        moving = SKNode()
        self.addChild(moving)
        importBGM("harunopayapaya.mp3")

        // setup physics
        self.physicsWorld.gravity = CGVectorMake( 0, -9.8 )
        self.physicsWorld.contactDelegate = self


        // setup our player
        let playerTexture1 = SKTexture(imageNamed: "sima1")
        playerTexture1.filteringMode = .Nearest
        let playerTexture2 = SKTexture(imageNamed: "sima2")
        playerTexture2.filteringMode = .Nearest

        let anim = SKAction.animateWithTextures([playerTexture1, playerTexture2], timePerFrame: 0.05)
        let flap = SKAction.repeatActionForever(anim)

        player = SKSpriteNode(texture: playerTexture1)
        player.setScale(0.2)
        player.position = CGPoint(x: self.frame.size.width * 0.2, y:self.frame.size.height * 0.2)
        jumpNow = player.position
        player.runAction(flap)

        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.height / 2.0)
        player.physicsBody?.dynamic = false
        player.physicsBody?.allowsRotation = false

        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = worldCategory
        player.physicsBody?.contactTestBitMask = worldCategory

        self.addChild(player)
        
        
        
        //chida
        //緑
        playergreen = SKSpriteNode(color: UIColor.greenColor(), size: CGSizeMake(15, 15))//青い四角
        playergreen.position.x = self.frame.size.width * 0.2 //場所
        playergreen.position.y = self.frame.size.height * 0.9 //場所
        
        self.playergreen.zPosition = -110
        
        playergreen.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(15, 15))//当たり判定
        
        
        // カテゴリを設定する。
        playergreen.physicsBody?.categoryBitMask = greenCategory
        playergreen.physicsBody?.contactTestBitMask = redCategory
        playergreen.physicsBody?.contactTestBitMask = blueCategory
        playergreen.physicsBody?.contactTestBitMask = blackCategory
//        player.physicsBody?.contactTestBitMask = yellowCategory
        
        playergreen.physicsBody?.affectedByGravity = false
        playergreen.physicsBody?.dynamic = false
        
        self.addChild(playergreen)
        
        
        //青
        playerblue = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(15, 15))//青い四角
        playerblue.position.x = self.frame.size.width * 0.2 + 25 //場所
        playerblue.position.y = self.frame.size.height * 0.9 //場所
        
        self.playerblue.zPosition = -110
        
        playerblue.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(15, 15))//当たり判定
        
        
        
        // カテゴリを設定する。
        playerblue.physicsBody?.categoryBitMask = blueCategory
        playerblue.physicsBody?.contactTestBitMask = redCategory
        playerblue.physicsBody?.contactTestBitMask = greenCategory
        playerblue.physicsBody?.contactTestBitMask = blackCategory
        //        player.physicsBody?.contactTestBitMask = yellowCategory
        
        playerblue.physicsBody?.affectedByGravity = false
        playerblue.physicsBody?.dynamic = false
        
        self.addChild(playerblue)
        
        
        //黒
        playerblack = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(15, 15))//青い四角
        playerblack.position.x = self.frame.size.width * 0.2 - 25 //場所
        playerblack.position.y = self.frame.size.height * 0.9 //場所
        
        self.playerblack.zPosition = -110
        
        playerblack.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(15, 15))//当たり判定
        
        
        
        // カテゴリを設定する。
        playerblack.physicsBody?.categoryBitMask = blackCategory
        playerblack.physicsBody?.contactTestBitMask = redCategory
        playerblack.physicsBody?.contactTestBitMask = greenCategory
        playerblack.physicsBody?.contactTestBitMask = blueCategory
        playerblack.physicsBody?.contactTestBitMask = blackCategory
        //    player.physicsBody?.contactTestBitMask = yellowCategory
        
        playerblack.physicsBody?.affectedByGravity = false
        playerblack.physicsBody?.dynamic = false
        
        self.addChild(playerblack)

        
        // 赤い正方形1。ここを障害物と重ねる
        Wallred1 = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(5, 5))
        
        
        Wallred1.position.x = self.frame.size.width * 1.1 //場所
        Wallred1.position.y = self.frame.size.height * 0.9 //場所
        
        self.Wallred1.zPosition = -110
        
        Wallred1.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(5, 5)) //当たり判定
        
        
        Wallred1.physicsBody?.affectedByGravity = false
//        Wallred.physicsBody?.dynamic = false
        
        
        // カテゴリを設定する。
        Wallred1.physicsBody?.categoryBitMask = redCategory
        Wallred1.physicsBody?.contactTestBitMask = greenCategory
        Wallred1.physicsBody?.contactTestBitMask = blueCategory
        Wallred1.physicsBody?.contactTestBitMask = blackCategory
        
        self.addChild(Wallred1)
        
        
        
        // 赤い正方形2。ここを障害物と重ねる
        Wallred2 = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(5, 5))
        
        
        Wallred2.position.x = self.frame.size.width * 1.1 //場所
        Wallred2.position.y = self.frame.size.height * 0.9 //場所
        
        self.Wallred2.zPosition = -110
        
        Wallred2.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(5, 5)) //当たり判定
        
        Wallred2.physicsBody?.affectedByGravity = false
        //        Wallred.physicsBody?.dynamic = false
        
        
        // カテゴリを設定する。
        Wallred2.physicsBody?.categoryBitMask = redCategory
        Wallred2.physicsBody?.contactTestBitMask = greenCategory
        Wallred2.physicsBody?.contactTestBitMask = blueCategory
        Wallred2.physicsBody?.contactTestBitMask = blackCategory
        
        self.addChild(Wallred2)
        
        
        // 黄色正方形。ここを障害物と重ねる
/*        yellowSquare = SKSpriteNode(color: UIColor.yellowColor(), size: CGSizeMake(10, 10)) //黄色い四角
        
        
        yellowSquare.position.x = self.frame.size.width * 0.2 //場所
        yellowSquare.position.y = self.frame.size.height * 0.23 //場所
        
        self.yellowSquare.zPosition = 110
        
//        yellowSquare.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 50)) //当たり判定
        
        
        yellowSquare.physicsBody?.affectedByGravity = false
        yellowSquare.physicsBody?.dynamic = false
        
        
        // カテゴリを設定する。
/*        yellowSquare.physicsBody?.categoryBitMask = yellowCategory
        yellowSquare.physicsBody?.contactTestBitMask = greenCategory
*/
        self.addChild(yellowSquare)
*/
        
        //Takamiyagi Wall(障害物)の設定
        
//        let WallTexture1 = SKTexture(imageNamed: "Object")                                          //使用する画像
//        Wall1 = SKSpriteNode(texture: WallTexture1)
//        Wall1.setScale(1.5)                                                                         //使用する画像の大きさ（元の画像の大きさの割合）
//        Wall1.position = CGPoint(x: self.frame.size.width * 1.2, y:self.frame.size.height * 0.40)  //使用する画像の初期位置
//        self.addChild(Wall1)
        
//        let WallTexture2 = SKTexture(imageNamed: "Object")
//        Wall2 = SKSpriteNode(texture: WallTexture2)
//        Wall2.setScale(0.4)
//        Wall2.position = CGPoint(x: self.frame.size.width * 1.7, y:self.frame.size.height * 0.40)
//        self.addChild(Wall2)
        
        
        let WallTexture2 = SKTexture(imageNamed: "Object")
        Wall2 = SKSpriteNode(texture: WallTexture2)
        Wall2.setScale(0.4)
        Wall2.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.15)
        Wall2.zPosition = 1
        self.addChild(Wall2)
        
        var fukidasiTexture = SKTexture(imageNamed: "fukidasi")
        fukidasi = SKSpriteNode(texture: fukidasiTexture)
        fukidasi.setScale(0.4)
        fukidasi.zPosition = -110
        self.addChild(fukidasi)

        
        
        
        
        //naotarou
        //背景画像。SKSPriteNodeで画像を読み込む。
        
        var frame = UIScreen.mainScreen().applicationFrame
        var buttonFrame = CGRect()
        var texxture = SKTexture(imageNamed: "asd.png")
        texxture.filteringMode = SKTextureFilteringMode.Nearest
        self.backGround = SKSpriteNode(texture: texxture)
        self.addChild(backGround)
        self.backGround.zPosition = -100
        self.backGround.size = CGSizeMake(self.frame.size.width, self.frame.size.height)
        
        backGround.position = CGPointMake(self.frame.size.width/2,self.frame.size.height/2)
        
        
        
        var texture = SKTexture(imageNamed: "asd.png")
        texture.filteringMode = SKTextureFilteringMode.Nearest
        self.player2 = SKSpriteNode(texture: texture)
        self.addChild(player2)
        self.player2.size = CGSizeMake(self.frame.size.width, self.frame.size.height)
        self.player2.zPosition = -101
        player2.position = CGPointMake(10000,111112)
        
        self.player2.position = CGPointMake(23333,self.frame.size.height * 0.5)
        
    }
    

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if(check == 2){
        }else if(moving.speed > 0) {
        player.position.x == jumpNow.x + 1
            if(check == 1){
            for touch: AnyObject in touches {
                player.physicsBody?.dynamic = true
                let location = touch.locationInNode(self)

                player.physicsBody?.velocity = CGVectorMake(0, 550)
                player.physicsBody?.applyImpulse(CGVectorMake(0, 0))

                let playerTexture1 = SKTexture(imageNamed: "sima1")
                playerTexture1.filteringMode = .Nearest
                let playerTexture2 = SKTexture(imageNamed: "sima1")
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
        
        //　Takamiyagi
        if(timecount <= -1){
            
        }
        else if(timecount <= 60){
            
        }
        else if(timecount <= 660){
           wallmove()
        }
        else if(timecount <= 1260){
            wallmove2()
        }
        else if(timecount <= 1860){
            wallmove3()
        }
        else if(timecount <= 2460){
            wallmove4()
        }
        else if(timecount <= 3060){
            wallmove5()
        }
        else if(timecount <= 3660){
            wallmove6()
        }
        else if(timecount <= 3960){
            wallmove5()
        }
        else if(timecount <= 4200){
            wallmove()
        }
        else{
            wallmove6()
        }
        
        if(timecount >= -420 && timecount < 0){
            delegate_escape!.sceneEscape(self)
        }

        
        
        timecount = timecount+1
        
        if(fukidasi_flag == 1){
            if(timecount - fukidasi_num >= 60){
                fukidasi.zPosition = -110
                fukidasi_flag = 0
            }
        }
        
        
        //naotarou and takamiyagi(止める処理)
        
        if(timecount % 60 == 0 && timecount != 0){
            score = score + 1
        }
        
        if(timecount > 0 ){
          self.backGround.position.x -= 10
          
          self.player2.position.x -= 10
          if(self.backGround.position.x <= self.frame.size.width * 0.5 && self.backGround.position.x >= self.frame.size.width * 0.5 - 10){
              self.player2.position.x = self.backGround.position.x + self.frame.size.width
          }
        
          if(self.player2.position.x <= self.frame.size.width * 0.5 && self.player2.position.x >= self.frame.size.width * 0.5 - 10){
              self.backGround.position.x = self.player2.position.x + self.frame.size.width
          }
        }
        
        
        if(player.position.y < jumpNow.y){
            player.physicsBody?.dynamic = false
            self.resetScene()
        }
        
    }
    
    
    //naotarou
    func getScreenSize() -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds.size;
        if NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1
            && UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
                return CGSizeMake(screenSize.height, screenSize.width)
        }
        return screenSize
    }

    
    
    
    //takamiyagi
    func player_fukidasi(){
        fukidasi.zPosition = 10
        fukidasi.position = CGPoint(x: player.position.x + 80, y: player.position.y + 50)
        
        
        fukidasi_flag = 1
        fukidasi_num = timecount
    }
    
    
    
    func wallmove(){
        
//        if(Wall1.position.x >= self.frame.size.width * 0.7){
//            var movepos1 = CGPoint(x: self.frame.size.width * -0.8, y:self.frame.size.height * 0.40)
//            let travelTime = SKAction.moveTo(movepos1, duration: 2.0)
//            self.Wall1.runAction(travelTime)
//        }
//        else{
//            Wall1.position = CGPoint(x: self.frame.size.width * 1.2, y:self.frame.size.height * 0.40)
//        }
        
        
//        if(Wall2.position.x >= self.frame.size.width * 1.2){
//            var movepos2 = CGPoint(x: self.frame.size.width * -0.3, y:self.frame.size.height * 0.40)
//            let travelTime = SKAction.moveTo(movepos2, duration: 2.0)
//            self.Wall2.runAction(travelTime)
//        }
//        else{
//            Wall2.position = CGPoint(x: self.frame.size.width * 1.7, y:self.frame.size.height * 0.40)
//        }
        
        
        if(Wall2.position.x >= self.frame.size.width * 1.0){
            var movepos1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.15)
            var moveposred1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.9)
            let travelTime = SKAction.moveTo(movepos1, duration: 2.5)
            self.Wall2.runAction(travelTime)
            let travelTimered = SKAction.moveTo(moveposred1, duration : 2.5)
            self.Wallred2.runAction(travelTimered)
        }
        
        if(Wall2.position.x <= self.frame.size.width * 0.0) {
            Wall2.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.15)
            Wallred2.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.9)
            
        }

    }
    
    
    //takamiyagi
    func wallmove2(){
        if(Wall2.position.x >= self.frame.size.width * 1.0){
            var movepos1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.15)
            var moveposred1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.9)
            let travelTime = SKAction.moveTo(movepos1, duration: 2.0)
            self.Wall2.runAction(travelTime)
            let travelTimered = SKAction.moveTo(moveposred1, duration : 2.0)
            self.Wallred1.runAction(travelTimered)
        }
        
        if(Wall2.position.x <= self.frame.size.width * 0.0) {
            Wall2.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.15)
            Wallred1.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.9)
        }
    }
    
    
    func wallmove3(){
        if(Wall2.position.x >= self.frame.size.width * 1.0){
            var movepos1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.15)
            var moveposred1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.9)
            let travelTime = SKAction.moveTo(movepos1, duration: 1.5)
            self.Wall2.runAction(travelTime)
            let travelTimered = SKAction.moveTo(moveposred1, duration : 1.5)
            self.Wallred1.runAction(travelTimered)
        }
        
        if(Wall2.position.x <= self.frame.size.width * 0.0) {
            Wall2.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.15)
            Wallred1.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.9)
        }
    }
    //障害物の残りのパターンは下部へ


    

    func resetScene (){
        // Move player to original position and reset velocity
        player.position.y = jumpNow.y
        player.physicsBody?.velocity = CGVectorMake( 0, 0 )
        player.physicsBody?.collisionBitMask = worldCategory
        player.speed = 1.0
        player.zRotation = 0.0

        // Reset _canRestart
        canRestart = false

        // Restart animation
        moving.speed = 1

        let playerTexture1 = SKTexture(imageNamed: "sima1")
        playerTexture1.filteringMode = .Nearest
        let playerTexture2 = SKTexture(imageNamed: "sima2")
        playerTexture2.filteringMode = .Nearest

        let anim = SKAction.animateWithTextures([playerTexture1, playerTexture2], timePerFrame: 0.05)
        let flap = SKAction.repeatActionForever(anim)
        player.runAction(flap)

        check = 1
    }
    
    
    
    
    // 衝突したとき（赤と緑）。ここをいろいろ表示出来るようにする
    func didBeginContact(contact: SKPhysicsContact!) {
        
        var firstBody, secondBody, thirdBody : SKPhysicsBody
        
        // firstを赤、secondを緑とする。
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            //thirdBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            //thirdBody = contact.bodyA
            secondBody = contact.bodyA
        }
        println("first:")
        println(contact.bodyA.categoryBitMask)
        println("second:")
        println(contact.bodyB.categoryBitMask)
        if (contact.bodyA.categoryBitMask > 100000000){
            return//壁の当たり判定をなくす
        }
        if (contact.bodyB.categoryBitMask > 100000000){
            return//壁の当たり判定をなくす
        }
        
        
        // 赤と緑が接したときの処理。ここをキャラクターと障害物の接触したときのアクションにする
        if firstBody.categoryBitMask & redCategory != 0 &&
            secondBody.categoryBitMask & greenCategory != 0 {
                //ここを主人公が衝突したいときにgameoverになるようにする
                if (player.position.y - 30) <= self.frame.size.height * 0.16{
                    gameover()
                }
                else if (player.position.y - 30) <= self.frame.size.height * 0.23{
                    count += 1
                    if(score < 0){
                        score = 0
                    }
                    player_fukidasi()
                }
        }
        
        //赤と青
        if firstBody.categoryBitMask & redCategory != 0 &&
            secondBody.categoryBitMask & blueCategory != 0 {
                if (player.position.y - 30) <= self.frame.size.height * 0.16{
                    gameover()
                }
                else if (player.position.y - 30) <= self.frame.size.height * 0.23{
                    count += 1
                    if(score < 0){
                        score = 0
                    }
                    
                    player_fukidasi()
                    
                }
        }
        
        //赤と黒
        if firstBody.categoryBitMask & redCategory != 0 &&
            secondBody.categoryBitMask & blackCategory != 0 {
                if (player.position.y - 30) <= self.frame.size.height * 0.16{
                    gameover()
                    }
                else if (player.position.y - 30) <= self.frame.size.height * 0.23{
                    count += 1
                    if(score < 0){
                        score = 0
                    }
                    player_fukidasi()
                }
        }
    }
    
    //追加
    var BGM:AVAudioPlayer!
    
    func importBGM(filename: String){
        let url = NSBundle.mainBundle().URLForResource(filename, withExtension: nil)
        if(url == nil){
        println("aa:\(filename)")
        return
        }
        var error: NSError? = nil
        BGM = AVAudioPlayer(contentsOfURL: url, error: &error)
        if BGM == nil{
            println("Could not create audio player: ¥(error!)")
            return
        }
        
        BGM.numberOfLoops = -1
        BGM.prepareToPlay()
        BGM.play()
        
    }
    
    func gameover(){
        if(gameover_flag == 0){
            let myLabel = SKLabelNode(fontNamed:"HelveticaNeue-Bold")
            //myLabel.text = "ゲームオーバー \(score)";
            myLabel.text = "ゲームオーバー"
            myLabel.fontSize = 48;
            myLabel.fontColor = UIColor.redColor()
            myLabel.position = CGPoint(x: self.frame.size.width * 0.5, y:self.frame.size.height * 0.5)
            self.addChild(myLabel)
            
            
            let playerTexture1 = SKTexture(imageNamed: "damage")
            playerTexture1.filteringMode = .Nearest
            let playerTexture2 = SKTexture(imageNamed: "damage")
            playerTexture2.filteringMode = .Nearest
            let stop = SKAction.animateWithTextures([playerTexture1, playerTexture2], timePerFrame: 0.05)
            let dlap = SKAction.repeatActionForever(stop)
            player.runAction(dlap)
            check = 2
            
            score -= count
            appDelegate.data = score
            
            timecount = -600
            gameover_flag = 1
        }
    }
    
    func wallmove4(){
        if(Wall2.position.x >= self.frame.size.width * 1.0){
            var movepos1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.15)
            var moveposred1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.9)
            let travelTime = SKAction.moveTo(movepos1, duration: 1.0)
            self.Wall2.runAction(travelTime)
            let travelTimered = SKAction.moveTo(moveposred1, duration : 1.0)
            self.Wallred1.runAction(travelTimered)
        }
        
        if(Wall2.position.x <= self.frame.size.width * 0.0) {
            Wall2.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.15)
            Wallred1.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.9)
        }
    }
    
    func wallmove5(){
        if(Wall2.position.x >= self.frame.size.width * 1.0){
            var movepos1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.15)
            var moveposred1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.9)
            let travelTime = SKAction.moveTo(movepos1, duration: 0.7)
            self.Wall2.runAction(travelTime)
            let travelTimered = SKAction.moveTo(moveposred1, duration : 0.7)
            self.Wallred1.runAction(travelTimered)
        }
        
        if(Wall2.position.x <= self.frame.size.width * 0.0) {
            Wall2.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.15)
            Wallred1.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.9)
        }
    }
    
    func wallmove6(){
        if(Wall2.position.x >= self.frame.size.width * 1.0){
            var movepos1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.15)
            var moveposred1 = CGPoint(x: self.frame.size.width * -0.1, y:self.frame.size.height * 0.9)
            let travelTime = SKAction.moveTo(movepos1, duration: 7.5)
            self.Wall2.runAction(travelTime)
            let travelTimered = SKAction.moveTo(moveposred1, duration : 7.5)
            self.Wallred1.runAction(travelTimered)
        }
        
        if(Wall2.position.x <= self.frame.size.width * 0.0) {
            Wall2.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.15)
            Wallred1.position = CGPoint(x: self.frame.size.width * 1.1, y:self.frame.size.height * 0.9)
        }
    }
    
}








