//
//  GameRoomVC.swift
//  BaccaratLiveStream
//  Created by Kamesh Bala on 05/09/23.
// swiftlint:disable superfluous_disable_command cyclomatic_complexity type_body_length file_length type_name function_body_length
import UIKit
import SpreadsheetView
import AVFoundation
import SocketRocket
import Network

class GameRoomVC: UIViewController {
    let mapObj = BaccaratRoadMaps()
    @IBOutlet weak var zoomOutBtn: UIButton!
    @IBOutlet weak var zoomInBtn: UIButton!
    @IBOutlet weak var videoViewLeading: NSLayoutConstraint!
    @IBOutlet weak var videoViewTrailing: NSLayoutConstraint!
    //  @IBOutlet weak var gameRuleView: UIView!
    @IBOutlet weak var resultView: GradientView!
    @IBOutlet weak var commBgImagView: UIImageView!
    @IBOutlet weak var bankerStackWidth: NSLayoutConstraint!
    @IBOutlet weak var playerStackWidth: NSLayoutConstraint!
    @IBOutlet weak var videoViewBottom: NSLayoutConstraint!
    @IBOutlet weak var videoViewTop: NSLayoutConstraint!
    @IBOutlet weak var matchNumStackLeft: NSLayoutConstraint!
    var ySpaceOdd = 20
    var ySpaceEven = 20
    let coinPositionValueVU: CGFloat = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6 ) ? 25: 35
    let yPositionCoinExtra = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6 ) ? 0: 10
    let yRepeatPositionCoinExtra = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6 ) ? 10: 15
    var playerPoints = 0
    var bankersPoints = 0
    var gamePlayerArr = [PlayerData]()
    var yourGameRound: Int = 0
    var previousVCDelegate: RefreshPreviousVCDelegate?
    // .. Circular view & timer
    var roomList: [CasinoTableData]!
    @IBOutlet weak var circularProgressBarView: CircularProgressBarView!
    @IBOutlet weak var circularProgressHeightConst: NSLayoutConstraint!
    var countdownTimer: Timer!
    var countdownSocket: Timer!
    var totalwaitingSocketTime = 0
    @IBOutlet weak var statusLabel: UILabel!
    var totalBetTime = 20
    // . Room Outlets
    @IBOutlet weak var pRoomTitleLbl: UILabel!
    @IBOutlet weak var pRoomValueLbl: UILabel!
    @IBOutlet weak var pPRoomTitleLbl: UILabel!
    @IBOutlet weak var pPRoomValueLbl: UILabel!
    @IBOutlet weak var bRoomTitleLbl: UILabel!
    @IBOutlet weak var bRoomValueLbl: UILabel!
    @IBOutlet weak var bPRoomTitleLbl: UILabel!
    @IBOutlet weak var bPRoomValueLbl: UILabel!
    @IBOutlet weak var tieRoomTitleLbl: UILabel!
    @IBOutlet weak var tieRoomValueLbl: UILabel!
    @IBOutlet weak var matchBetLimitRoomLbl: UILabel!
    @IBOutlet weak var matchNumRoomLbl: UILabel!
    // Bet Pots Outlets
    @IBOutlet weak var pRoomBetPotValueLbl: UILabel!
    @IBOutlet weak var pPRoomBetPotValueLbl: UILabel!
    @IBOutlet weak var bRoomBetPotValueLbl: UILabel!
    @IBOutlet weak var bPRoomBetPotValueLbl: UILabel!
    @IBOutlet weak var tieRoomBetPotValueLbl: UILabel!
    // Bet Pots Count Outlets
    @IBOutlet weak var pRoomBetPotCountLbl: UILabel!
    @IBOutlet weak var pPRoomBetPotCountLbl: UILabel!
    @IBOutlet weak var bRoomBetPotCountLbl: UILabel!
    @IBOutlet weak var bPRoomBetPotCountLbl: UILabel!
    @IBOutlet weak var tieRoomBetPotCountLbl: UILabel!
    
    // .. match,player, bankers...etc numbers for Baccarat Map
    @IBOutlet weak var tieNumberValueLbl: UILabel!
    @IBOutlet weak var playerNumberValueLbl: UILabel!
    @IBOutlet weak var playerWinLbl: UILabel!
    @IBOutlet weak var bankerWinLbl: UILabel!
    @IBOutlet weak var playerWinView: UIView!
    @IBOutlet weak var bankerWinView: UIView!
    @IBOutlet weak var playerPairNumberValueLbl: UILabel!
    @IBOutlet weak var bankerNumberValueLbl: UILabel!
    @IBOutlet weak var bankerPairNumberValueLbl: UILabel!
    @IBOutlet weak var roundNumberValueLbl: UILabel!
    @IBOutlet weak var tieNumberTitleLbl: UILabel!
    @IBOutlet weak var playerNumberTitleLbl: UILabel!
    @IBOutlet weak var playerPairNumberTitleLbl: UILabel!
    @IBOutlet weak var bankerNumberTitleLbl: UILabel!
    @IBOutlet weak var bankerPairNumberTitleLbl: UILabel!
    @IBOutlet weak var roundNumberTitleLbl: UILabel!
    // .. banker, player prediction imageIcon for Baccarat Map
    @IBOutlet weak var bankerPreditBigIcon: UIImageView!
    @IBOutlet weak var bankerPreditSmalIcon: UIImageView!
    @IBOutlet weak var bankerPreditCRoachIcon: UIImageView!
    @IBOutlet weak var playerPreditBigIcon: UIImageView!
    @IBOutlet weak var playerPreditSmalIcon: UIImageView!
    @IBOutlet weak var playerPreditCRoachIcon: UIImageView!
    @IBOutlet weak var bRoadTitleLbl: UILabel!
    @IBOutlet weak var pRoadTitleLbl: UILabel!
    var backClicked = false
    var tableInfoData: TableRoomData?
    var groupData: TableGroupData?
    @IBOutlet weak var logoImage: UIImageView!
    var soundBtn = UIButton(type: .custom)
    @IBOutlet weak var gameRoomView: UIView!
    var safeAreaLead = 0.0
    var safeAreaTrail = 0.0
    var tieOn = false
    @IBOutlet weak var spreadsheetViewBigMap: SpreadsheetView!
    @IBOutlet weak var spreadsheetViewBigEye: SpreadsheetView!
    @IBOutlet weak var spreadsheetViewSmallEye: SpreadsheetView!
    @IBOutlet weak var spreadsheetViewCockRoachEye: SpreadsheetView!
    @IBOutlet weak var spreadsheetViewBreadPlate: SpreadsheetView!
    var predictNode = PredictionNode()
    var bigMapPredictArr = [BigRoadMapData]()
    var bigEyePredictArr = [BigRoadMapData]()
    var smallEyePredictArr = [BigRoadMapData]()
    var cockRoachEyePredictArr = [BigRoadMapData]()
    var breadPlatePredictArr = [BigRoadMapData]()
    // ....
    var stackHeight: CGFloat = 0
    var player: AVAudioPlayer!
    @IBOutlet weak var roadMapHeight: NSLayoutConstraint!
    @IBOutlet weak var bigEyeHeight: NSLayoutConstraint!
    @IBOutlet weak var bigMapHeight: NSLayoutConstraint!
    @IBOutlet weak var breadPlatMapWidth: NSLayoutConstraint!
    @IBOutlet weak var videoViewRatioCons: NSLayoutConstraint!
    var cellHeightBP = 50.0
    var cellHeightBI = 50.0
    var cellHeightBE = 50.0
    var initialCellColumnCountBP = 40
    var initialCellColumnCountBI = 40
    var initialCellColumnCountBE = 40
    var widthOfMapContainer = 0.0
    //  var cellHeight = 50.0
    @IBOutlet weak var bankerWinCountLbl: UILabel!
    @IBOutlet weak var playerWinCountLbl: UILabel!
    @IBOutlet weak var tieCountLbl: UILabel!
    @IBOutlet weak var bankerPairCountLbl: UILabel!
    @IBOutlet weak var playerPairCountLbl: UILabel!
    @IBOutlet weak var naturalCountLbl: UILabel!
    var tableResultVoArr = [GameTableResultVo]()
    // ... End Road map Variables
    var casinoData: CasinoTableData?
    var eventHandler: GameRoomUIInterface?
    var userInfo = ConfigurationDataManager.shared.userInfo
    var webSocket: SRWebSocket!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var placeholderActivityIndc: UIActivityIndicatorView!
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var coinTable: UICollectionView!
    var coinSelectedIndex = 2
    var coins = [CasinoChip]()
    var selectedCoins: CasinoChip?
    @IBOutlet weak var tableContainerView: ViewDesign!
    @IBOutlet weak var bankerView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var bPairView: UIView!
    @IBOutlet weak var tieView: UIView!
    @IBOutlet weak var pPairView: UIView!
    @IBOutlet weak var repeatButton: ButtonDesign!
    @IBOutlet weak var cancelButton: ButtonDesign!
    @IBOutlet weak var confirmButton: ButtonDesign!
    @IBOutlet weak var commFreeButton: UIButton!
    @IBOutlet weak var coinContainerView: UIView!
    @IBOutlet weak var cardContainerView: ViewDesign!
    @IBOutlet weak var playerCardView: ViewDesign!
    @IBOutlet weak var bankerCardView: ViewDesign!
    @IBOutlet weak var playerCardImage1: UIImageView!
    @IBOutlet weak var playerCardImage2: UIImageView!
    @IBOutlet weak var playerCardImage3: UIImageView!
    @IBOutlet weak var bankerCardImage1: UIImageView!
    @IBOutlet weak var bankerCardImage2: UIImageView!
    @IBOutlet weak var bankerCardImage3: UIImageView!
    @IBOutlet weak var playerCardValueLabel: GradientLabel!
    @IBOutlet weak var bankerCardValueLabel: GradientLabel!
    @IBOutlet weak var playerCardTitleLabel: UILabel!
    @IBOutlet weak var bankerCardTitleLabel: UILabel!
    @IBOutlet weak var tieIndicatorView: ViewDesign!
    @IBOutlet weak var otherPlayerView: UIView!
    var totalOtherPlayers: Int = 0
    var walletLabel: UILabel?
    var totalBetAmount: Double = 0.0
    var pPairStack = [ChipStack]()
    var tiePairStack = [ChipStack]()
    var bPairStack  = [ChipStack]()
    var playerStack = [ChipStack]()
    var bankerStack = [ChipStack]()
    
    // Confirm Bet Stack
    var confirmpPairStack = [ChipStack]()
    var confirmtiePairStack = [ChipStack]()
    var confirmbPairStack  = [ChipStack]()
    var confirmplayerStack = [ChipStack]()
    var confirmbankerStack = [ChipStack]()
    
    var pPairValueVU = ChipValueView()
    var tiePairValueVU = ChipValueView()
    var bPairValueVU = ChipValueView()
    var playerValueVU = ChipValueView()
    var bankerValueVU = ChipValueView()
    var chipSpacing: CGFloat = 1
    lazy var streamingPlayer = StreamingVideoPlayer()
    let statusView = StatusView(isDisplayBg: true)
    
    @IBOutlet weak var actionButtonStack: UIStackView!
    var isRepeatActive = false
    var countTimer = 0
    let emptyView = EmptyStateView()
    var isInternetAvailable = true
    let monitor = NWPathMonitor()
    var currentGameStatus: Int?
    var currentRoundNum = 0
    var repeatAmount =  0
    var isRepeatDraw = false
    var otherTotalPlayerView: Int = 0
    var otherTotalPpairView: Int = 0
    var otherTotalBankerView: Int = 0
    var otherTotalBpairView: Int = 0
    var otherTotalTieView: Int = 0
    var actualVideoWidth = 0.0
    var videoBottomSpace = 0.0
    var videoTopSpace = 0.0
    var actualVideoViewTrailing = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showViewForOtherPlayer()
        currentVC = self
        if Display.typeIsLike == .ipad {
            NSLayoutConstraint.setMultiplier(201/91, of: &videoViewRatioCons)
        } else if Display.typeIsLike == .iphone6 {
            NSLayoutConstraint.setMultiplier(131/92, of: &videoViewRatioCons)
        }
        self.statusLabel.text = ""
        circularProgressBarView.isHidden = true
        self.playerCardImage3.isHidden = true
        self.bankerCardImage3.isHidden = true
        self.bankerCardValueLabel.text = "0"
        self.playerCardValueLabel.text = "0"
        self.languageSetup()
        setupTapGesture()
        self.createCustomBarButton(userInfo: self.userInfo)
        coinTable.delegate = self
        coinTable.dataSource = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupVideoPlayer()
            if let url = self.casinoData?.liveURL as? String {
                self.startLiveStreaming(url: url)
            }
        }
        self.setUpRoom()
        self.initiateSpreadSheet()
        self.manageHeight()
        DispatchQueue.main.async {
            self.setupChipValueVU()
        }
        
        setupChipValueVU()
        
        GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .enter, addInQueue: true)
        self.handleEnterForeground()
        initializeEmptyView()
        addTapGestureToOtherPlayerView()
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        if Display.typeIsLike == .iphone5 ||  Display.typeIsLike == .iphone6 {
            circularProgressHeightConst.constant = 56
            videoViewBottom.constant = -50
        }
        let ruleBtn = UIButton(type: .custom)
        ruleBtn.addTarget(self, action: #selector(showGameRules), for: .touchUpInside)
        ruleBtn.setImage(UIImage(named: "gameRule"), for: .normal)
        ruleBtn.setImage(UIImage(named: "gameRule"), for: .highlighted)
        ruleBtn.setImage(UIImage(named: "gameRule"), for: .selected)
        let ruleBarItem = UIBarButtonItem(customView: ruleBtn)
        
        soundBtn.addTarget(self, action: #selector(soundSettings), for: .touchUpInside)
        soundBtn.setImage(UIImage(named: "volumeMedium"), for: .normal)
        soundBtn.setImage(UIImage(named: "volumeMedium"), for: .highlighted)
        soundBtn.setImage(UIImage(named: "volumeMedium"), for: .selected)
        let soundBarItem = UIBarButtonItem(customView: soundBtn)
        
        let refreshBtn = UIButton(type: .custom)
        refreshBtn.addTarget(self, action: #selector(videoRefresh), for: .touchUpInside)
        refreshBtn.setImage(UIImage(named: "tableRefresh"), for: .normal)
        refreshBtn.setImage(UIImage(named: "tableRefresh"), for: .highlighted)
        refreshBtn.setImage(UIImage(named: "tableRefresh"), for: .selected)
        let refreshBarItem = UIBarButtonItem(customView: refreshBtn)
        self.navigationItem.rightBarButtonItems = [refreshBarItem, ruleBarItem, soundBarItem]
        circularProgressBarView.bringSubviewToFront(statusLabel)
        playerCardValueLabel.gradientColors = [UIColor(hex: "FAEB5B").cgColor, UIColor(hex: "EE7C28").cgColor]
        bankerCardValueLabel.gradientColors = [UIColor(hex: "FAEB5B").cgColor, UIColor(hex: "EE7C28").cgColor]
        playerWinLbl.transform =  CGAffineTransform(rotationAngle: -45)
        bankerWinLbl.transform =  CGAffineTransform(rotationAngle: 45)
        let tableColor = (self.casinoData?.tableColorNew ?? "530002").replacingOccurrences(of: "#", with: "")
        self.gameRoomView.backgroundColor = UIColor(hex: tableColor)
        self.resultView.updateColorbyTableNum(tableColor: tableColor)
        self.bankerStackWidth.constant = 94
        self.playerStackWidth.constant = 94
        self.videoPlayer.backgroundColor = UIColor(hex: tableColor)
        // UIApplication.statusBarBackgroundColor = UIColor(hex: tableColor)
        self.placeholderView.backgroundColor = UIColor(hex: tableColor)
        self.circularProgressBarView.circleLayer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
        actualVideoWidth = Utils.screenWidth + (videoViewTrailing.constant * 2)
        videoBottomSpace = (self.videoViewBottom.constant) * -1
        actualVideoViewTrailing = videoViewTrailing.constant
        videoTopSpace = (self.videoViewTop.constant) * -1
        self.adjustVideoFirstTime()
    }
    func adjustVideoFirstTime() {
        let maxZoom = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6 ) ? 144.0 : 250.0
        let ratio: CGFloat = 1/self.videoViewRatioCons.multiplier
        let actualVideoHeight = actualVideoWidth * ratio
        let trailvalue = self.videoViewTrailing.constant + ((actualVideoWidth * 25)/100)
        let currentVideoWidth = Utils.screenWidth + (trailvalue * 2)
        let currentVideoHeight = currentVideoWidth * ratio
        
        if trailvalue < maxZoom {
            self.videoViewLeading.constant =  trailvalue * -1 // Update Video Leading
            self.videoViewTrailing.constant =  trailvalue // Update Video Trailing
            let diffInHeight = currentVideoHeight - actualVideoHeight // Change in Video Height
            let topDiff = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6) ? (diffInHeight * 45)/100 : (diffInHeight * 30)/100
            let bottomDiff = diffInHeight - topDiff
            print("diffInHeight ==>", diffInHeight)
            print("topDiff ==>", topDiff)
            print("bottomDiff ==>", bottomDiff)
               // videoViewTop.constant = (videoTopSpace + (diffInHeight/2)) * -1 // Update Video Top Space
              //  self.videoViewBottom.constant = (videoBottomSpace + diffInHeight/2) * -1
                videoViewTop.constant = (videoTopSpace + (topDiff)) * -1
                self.videoViewBottom.constant = (videoBottomSpace + bottomDiff) * -1

        }
    }
    // Video Zoom in & Zoom out
    @IBAction func videoZoomInOut(btn: UIButton) {
        let maxZoom = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6 ) ? 144.0 : 250.0
        let ratio: CGFloat = 1/self.videoViewRatioCons.multiplier
        let actualVideoHeight = actualVideoWidth * ratio
        // Video Zoom Out button clicked
        if btn.tag == 1 {
            self.zoomInBtn.isEnabled = true
            let trailvalue = self.videoViewTrailing.constant + 20
            let currentVideoWidth = Utils.screenWidth + (trailvalue * 2)
            let currentVideoHeight = currentVideoWidth * ratio
            
            if trailvalue < maxZoom {
                self.videoViewLeading.constant =  trailvalue * -1 // Update Video Leading
                self.videoViewTrailing.constant =  trailvalue // Update Video Trailing
                let diffInHeight = currentVideoHeight - actualVideoHeight // Change in Video Height
                videoViewTop.constant = (videoTopSpace + (diffInHeight/2)) * -1 // Update Video Top Space
                self.videoViewBottom.constant = (videoBottomSpace + diffInHeight/2) * -1 // Update Video Bottom Space
                if (trailvalue + 20) > maxZoom {
                    self.zoomOutBtn.isEnabled = false
                }
            }
        } else { // Video Zoom In button clicked
            self.zoomOutBtn.isEnabled = true
            let trailvalue = self.videoViewTrailing.constant - 20
            let currentVideoWidth = Utils.screenWidth + (trailvalue * 2)
            let currentVideoHeight = currentVideoWidth * ratio
            if trailvalue > actualVideoViewTrailing {
                self.videoViewLeading.constant =  trailvalue * -1
                self.videoViewTrailing.constant =  trailvalue
                let diffInHeight = currentVideoHeight - actualVideoHeight 
                let currentBottom = videoBottomSpace + (diffInHeight/2)
                if currentBottom >= videoBottomSpace {
                    self.videoViewBottom.constant = currentBottom * -1
                    videoViewTop.constant = (videoTopSpace + (diffInHeight/2)) * -1
                } else {
                    self.videoViewBottom.constant = -videoBottomSpace
                    videoViewTop.constant = videoTopSpace * -1
                }
            } else {
                self.zoomInBtn.isEnabled = false
                self.videoViewLeading.constant =  actualVideoViewTrailing * -1
                self.videoViewTrailing.constant =  actualVideoViewTrailing
                videoViewTop.constant =  videoTopSpace * -1
                self.videoViewBottom.constant = -videoBottomSpace
            }
        }
    }
    @objc func showOfflineDeviceUI(notification: Notification) {
        if Datamanager.shared.isUserAuthenticated {
            if NetworkMonitor.shared.isConnected {
                if self.isInternetAvailable == false {
                    self.checkVideoPlayerStatus()
                    self.pingToWebSocket()
                }
                self.isInternetAvailable = true
            } else {
                self.isInternetAvailable = false
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        currentVC = self
    }
    func addTapGestureToOtherPlayerView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showOtherPlayers))
        otherPlayerView.addGestureRecognizer(tap)
    }
    @objc func showOtherPlayers() {
        print("Show other players in a tooltip list")
    }
    func checkVideoPlayerStatus() {
        DispatchQueue.main.async {
            if self.streamingPlayer.liveManager.playState == .playStatePaused ||
                self.streamingPlayer.liveManager.playState == .playStatePlayFailed ||
                self.streamingPlayer.liveManager.playState == .playStatePlayStopped {
                self.setupVideoPlayer()
                if let url = self.casinoData?.liveURL as? String {
                    self.startLiveStreaming(url: url)
                }
            }
        }
    }
    func initializeEmptyView() {
        self.view.addSubview(emptyView)
        emptyView.tryAgainButton.addTarget(self, action: #selector(tryAgainButtonAction), for: .touchUpInside)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: gameRoomView.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: gameRoomView.centerYAnchor),
            emptyView.leftAnchor.constraint(equalTo: gameRoomView.leftAnchor),
            emptyView.rightAnchor.constraint(equalTo: gameRoomView.rightAnchor)
        ])
    }
    @objc func tryAgainButtonAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.setupVideoPlayer()
            if let url = self.casinoData?.liveURL as? String {
                self.startLiveStreaming(url: url)
            }
        }
        self.setUpRoom()
    }
    func handleEnterForeground() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackgroundGR(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegroundGR(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveGR(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActiveGR(_:)), name: UIApplication.willResignActiveNotification, object: nil)
    }
    @objc func willResignActiveGR(_ notification: NotificationCenter) {
        if let vc = self.navigationController?.viewControllers.last {
            if (vc is GameRoomVC) && Datamanager.shared.isUserAuthenticated {
                //    self.videoRefresh()
            }
        }
    }
    @objc func didBecomeActiveGR(_ notification: NotificationCenter) {
        if let vc = self.navigationController?.viewControllers.last {
            if (vc is GameRoomVC) && Datamanager.shared.isUserAuthenticated {
                // self.placeholderImageView.isHidden = false
                //  self.view.bringSubviewToFront(self.placeholderImageView)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    //   self.videoRefresh()
                }
            }
        }
    }
    @objc func applicationDidEnterBackgroundGR(_ notification: NotificationCenter) {
        if let vc = self.navigationController?.viewControllers.last {
            if (vc is GameRoomVC) && Datamanager.shared.isUserAuthenticated {
                AudioManager.stopSound()
                AudioManager.soundQueue.removeAll()
                self.closeWebSocketConnection()
            }
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.userInterfaceStyle == .dark {
            print("User Interface is Dark")
            // User Interface is Dark
        } else {
            print("User Interface is Light")
            // User Interface is Light
        }
 }
    
    @objc func applicationWillEnterForegroundGR(_ notification: NotificationCenter) {
        if let vc = self.navigationController?.viewControllers.last {
            if (vc is GameRoomVC) && Datamanager.shared.isUserAuthenticated {
                Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
                isRepeatActive = false
                self.checkVideoPlayerStatus()
                self.setUpRoom()
                self.repeatButtonHandle(isEnable: false)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSoundIcon()
    }
    deinit {
        print("deinit called")
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.closeWebSocketConnection()
        videoPlayer.isHidden = true
        NotificationCenter.default.removeObserver(self)
    }
    func setupSoundIcon() {
        let sliderValue: Int = (Int(floor(Datamanager.shared.gameSoundVolume)) + Int(floor(Datamanager.shared.gameVoiceVolume))) / 2
        var soundImage =  "volumeMedium"
        switch sliderValue {
        case 8...10:
            soundImage = "volumeHigh"
        case 5...7:
            soundImage = "volumeMedium"
        case 1...4:
            soundImage = "volumeLow"
        case 0:
            soundImage = "volumeMute"
        default:
            break
        }
        self.soundBtn.setImage(UIImage(named: soundImage), for: .normal)
        self.soundBtn.setImage(UIImage(named: soundImage), for: .highlighted)
        self.soundBtn.setImage(UIImage(named: soundImage), for: .selected)
    }
    func showMarqueAnimation(selected: UserType) {
        switch selected {
        case .player:
            // Shows marque animation to player view
            bankerCardView.hideMarqueAnimation()
            playerCardView.showMarqueAnimation()
            self.playerWinView.isHidden = false
        case .banker:
            // Shows marque animation to banker view
            playerCardView.hideMarqueAnimation()
            bankerCardView.showMarqueAnimation()
            self.bankerWinView.isHidden = false
        case .noOne:
            // Hide animation on both View
            playerCardView.hideMarqueAnimation()
            bankerCardView.hideMarqueAnimation()
            self.playerWinView.isHidden = true
            self.bankerWinView.isHidden = true
        }
    }
    func showTieIndicator() {
        tieIndicatorView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.tieIndicatorView.alpha = 1
        }
    }
    func hideTieIndicator() {
        UIView.animate(withDuration: 0.3) {
            self.tieIndicatorView.alpha = 0
        }
    }
    func setupChipValueVU() {
        pPairValueVU.frame = CGRect(origin: pPairView.center, size: CGSize(width: 60, height: 20))
        tiePairValueVU.frame = CGRect(origin: tieView.center, size: CGSize(width: 60, height: 20))
        bPairValueVU.frame = CGRect(origin: bPairView.center, size: CGSize(width: 60, height: 20))
        playerValueVU.frame = CGRect(origin: playerView.center, size: CGSize(width: 60, height: 20))
        bankerValueVU.frame = CGRect(origin: bankerView.center, size: CGSize(width: 60, height: 20))
        pPairValueVU.updateView(player: " ", amount: " ")
        tiePairValueVU.updateView(player: " ", amount: " ")
        bPairValueVU.updateView(player: " ", amount: " ")
        playerValueVU.updateView(player: " ", amount: " ")
        bankerValueVU.updateView(player: " ", amount: " ")
        tableContainerView.superview?.addSubview(pPairValueVU)
        tableContainerView.superview?.addSubview(tiePairValueVU)
        tableContainerView.superview?.addSubview(bPairValueVU)
        tableContainerView.superview?.addSubview(playerValueVU)
        tableContainerView.superview?.addSubview(bankerValueVU)
        pPairValueVU.isHidden = true
        tiePairValueVU.isHidden = true
        bPairValueVU.isHidden = true
        playerValueVU.isHidden = true
        bankerValueVU.isHidden = true
        // Set up Auto Layout constraints
        pPairValueVU.translatesAutoresizingMaskIntoConstraints = false
        tiePairValueVU.translatesAutoresizingMaskIntoConstraints = false
        bPairValueVU.translatesAutoresizingMaskIntoConstraints = false
        playerValueVU.translatesAutoresizingMaskIntoConstraints = false
        bankerValueVU.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pPairValueVU.centerXAnchor.constraint(equalTo: pPairView.centerXAnchor),
            pPairValueVU.topAnchor.constraint(equalTo: pPairView.centerYAnchor, constant: coinPositionValueVU),
            pPairValueVU.heightAnchor.constraint(equalToConstant: 20),
            
            tiePairValueVU.centerXAnchor.constraint(equalTo: tieView.centerXAnchor),
            tiePairValueVU.topAnchor.constraint(equalTo: tieView.centerYAnchor, constant: coinPositionValueVU),
            tiePairValueVU.heightAnchor.constraint(equalToConstant: 20),
            
            bPairValueVU.centerXAnchor.constraint(equalTo: bPairView.centerXAnchor),
            bPairValueVU.topAnchor.constraint(equalTo: bPairView.centerYAnchor, constant: coinPositionValueVU),
            bPairValueVU.heightAnchor.constraint(equalToConstant: 20),
            
            playerValueVU.centerXAnchor.constraint(equalTo: playerView.centerXAnchor),
            playerValueVU.topAnchor.constraint(equalTo: playerView.centerYAnchor, constant: coinPositionValueVU),
            playerValueVU.heightAnchor.constraint(equalToConstant: 20),
            
            bankerValueVU.centerXAnchor.constraint(equalTo: bankerView.centerXAnchor),
            bankerValueVU.topAnchor.constraint(equalTo: bankerView.centerYAnchor, constant: coinPositionValueVU),
            bankerValueVU.heightAnchor.constraint(equalToConstant: 20)
        ])
        pPairValueVU.setSelfStatus()
        tiePairValueVU.setSelfStatus()
        bPairValueVU.setSelfStatus()
        playerValueVU.setSelfStatus()
        bankerValueVU.setSelfStatus()
    }
    func setUpRoom() {
        self.repeatAmount = 0
        self.totalBetAmount = 0
        AudioManager.soundQueue.removeAll()
        AudioManager.stopSound()
        tieIndicatorView.alpha = 0
        self.bankerPreditBigIcon.image = UIImage(named: "empty")
        self.playerPreditBigIcon.image = UIImage(named: "empty")
        self.bankerPreditSmalIcon.image = UIImage(named: "empty")
        self.playerPreditSmalIcon.image = UIImage(named: "empty")
        self.bankerPreditCRoachIcon.image = UIImage(named: "empty")
        self.playerPreditCRoachIcon.image = UIImage(named: "empty")
        self.statusLabel.text = ""
        self.statusLabel.textColor =  UIColor.white
        self.circularProgressBarView.progressLayer.strokeColor = UIColor.clear.cgColor
        self.playerCardImage3.isHidden = true
        self.bankerCardImage3.isHidden = true
        self.bankerCardValueLabel.text = "0"
        self.playerCardValueLabel.text = "0"
        hideCardContainerView()
        if let data = self.casinoData {
            self.eventHandler?.getTableInfoData(data: data)
        }
        coinTable.delegate = self
        coinTable.dataSource = self
        self.cancelButtonHandle(isEnable: false)
        self.repeatButtonHandle(isEnable: false)
        self.confirmButtonHandle(isEnable: false)
        initializeStatusView()
        DispatchQueue.main.async {
            self.initiateUserCoins()
        }
    }
    func resetGameRoom() {
        self.repeatAmount = 0
        self.totalBetAmount = 0
        self.resetRoadMaps()
        self.reloadAllSpreadSheet()
        self.hideCardContainerView()
        predictNode = PredictionNode()
        self.bankerPreditBigIcon.image = UIImage(named: "empty")
        self.playerPreditBigIcon.image = UIImage(named: "empty")
        self.bankerPreditSmalIcon.image = UIImage(named: "empty")
        self.playerPreditSmalIcon.image = UIImage(named: "empty")
        self.bankerPreditCRoachIcon.image = UIImage(named: "empty")
        self.playerPreditCRoachIcon.image = UIImage(named: "empty")
        self.playerCardImage3.isHidden = true
        self.bankerCardImage3.isHidden = true
        self.bankerCardValueLabel.text = "0"
        self.playerCardValueLabel.text = "0"
        self.cancelButtonHandle(isEnable: false)
        self.confirmButtonHandle(isEnable: false)
        roundNumberValueLbl.text = "0"
        playerNumberValueLbl.text = "0"
        playerPairNumberValueLbl.text = "0"
        bankerNumberValueLbl.text = "0"
        bankerPairNumberValueLbl.text = "0"
        tieNumberValueLbl.text = "0"
        self.clearStack(removeConfirmBet: true)
        self.removePreviousBetData()
        self.clearUnconfirmBet()
        self.removeOtherPlayersVU()
        Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
        isRepeatActive = false
        self.repeatButtonHandle(isEnable: false)
        if self.countdownTimer == nil || self.countdownTimer.isValid == false {
            self.startSocketTimer()
        }
        AudioManager.soundQueue.removeAll()
        AudioManager.stopSound()
        
    }
    func initiateUserCoins() {
        coins = GameRoomVM.shared.fetchAllChips()
        if let chips = userInfo?.chips?.split(separator: ",").compactMap({ Int($0) }) {
            coins = coins.filter({ chips.contains($0.value) })
            if let addChip = GameRoomVM.shared.fetchCasinoChips().first {
                coins.insert(addChip, at: 0)
            }
            DispatchQueue.main.async {
                self.coinTable.reloadData()
            }
        }
    }
    func initializeStatusView() {
        view.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statusView.widthAnchor.constraint(equalToConstant: 230),
            statusView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
    }
    func setUpCircularProgressBarView() {
        circularProgressBarView.progressAnimation(duration: TimeInterval(totalBetTime))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "limitInfoPopup" {
            if segue.destination is LimitInfoPopupVC {
                (segue.destination as? LimitInfoPopupVC)!.tableInfoData =  self.tableInfoData
            }
            if let presentationController = segue.destination.popoverPresentationController { // 1
                presentationController.delegate = self // 2
            }
        } else if segue.identifier == "playerListPopup" {
            if segue.destination is PlayerListPopupVC {
                (segue.destination as? PlayerListPopupVC)!.gamePlayerArr =  self.gamePlayerArr
            }
            if let presentationController = segue.destination.popoverPresentationController { // 1
                presentationController.delegate = self // 2
            }
        }
    }
    func languageSetup() {
        // Set Room Title label Language Localize String
        Utils.setButtonAttributedTitleGameRoom(btn: self.cancelButton, text: "Cancel".localizable)
        Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
        Utils.setButtonAttributedTitleGameRoom(btn: self.confirmButton, text: "Confirm".localizable)
        Utils.setCommissionFeeButtonAttributedTitle(btn: self.commFreeButton,
                                                    text: "",
                                                    bgImage: self.commBgImagView)
        self.tieRoomTitleLbl.text = "TIE".localizable
        self.pPRoomTitleLbl.text = "P PAIR".localizable
        self.pRoomTitleLbl.text = "PLAYER".localizable
        self.bPRoomTitleLbl.text = "B PAIR".localizable
        self.bRoomTitleLbl.text = "BANKER".localizable
        self.pRoadTitleLbl.text = "P ROAD".localizable
        self.bRoadTitleLbl.text = "B road".localizable
        self.tieNumberTitleLbl.text = "Tie".localizable
        self.playerNumberTitleLbl.text = "P".localizable
        self.playerPairNumberTitleLbl.text = "PP".localizable
        self.bankerNumberTitleLbl.text = "B".localizable
        self.bankerPairNumberTitleLbl.text = "BP".localizable
        self.roundNumberTitleLbl.text = "Total".localizable
        self.playerCardTitleLabel.text = "PLAYER".localizable
        self.bankerCardTitleLabel.text = "BANKER".localizable
        self.bankerWinLbl.text = "WIN".localizable
        self.playerWinLbl.text = "WIN".localizable
    }
    func showViewForOtherPlayer() {
        if self.gamePlayerArr.count > 0 {
            self.otherPlayerView.isHidden = false
            self.matchNumStackLeft.constant = 5
        } else {
            self.otherPlayerView.isHidden = true
            self.matchNumStackLeft.constant = -25
        }
    }
    // MARK: Show & Hide Card Container View with Animation
    func showCardContainerView(type: String,
                               cardNum: String,
                               point: Int) {
        if self.tableInfoData?.tableResultType ?? 0 == 2 {
//            playerCardValueLabel.isHidden = true
//            bankerCardValueLabel.isHidden = true
//            self.playerCardImage1.isHidden = true
//            self.playerCardImage2.isHidden = true
//            self.playerCardImage3.isHidden = true
//            self.bankerCardImage1.isHidden = true
//            self.bankerCardImage2.isHidden = true
//            self.bankerCardImage3.isHidden = true
//            self.playerCardTitleLabel.isHidden = true
//            self.bankerCardTitleLabel.isHidden = true
//            self.cardContainerView.isHidden = true
            return
        }
        self.cardContainerView.isHidden = true
        var typeImageView = self.playerCardImage1
        // Rotate ImageView
        let rotationAngle = CGFloat.pi / 2.0 // 90 degrees in radians
        // Apply the rotation transformation to the UIImageView
        playerCardValueLabel.isHidden = false
        bankerCardValueLabel.isHidden = false
        bankerCardImage3.transform = CGAffineTransform(rotationAngle: rotationAngle)
        playerCardImage3.transform =  CGAffineTransform(rotationAngle: -rotationAngle)
        switch type {
        case "player1":
            typeImageView = self.playerCardImage1
            self.playerCardValueLabel.text = "\(point)"
            self.playerPoints = point
        case "player2":
            typeImageView = self.playerCardImage2
            self.playerCardValueLabel.text =  "\(point)"
            self.playerPoints = point
        case "player3":
            self.playerCardImage3.isHidden = false
            typeImageView = self.playerCardImage3
            self.playerStackWidth.constant = 158
            self.playerCardValueLabel.text = "\(point)"
            self.playerPoints = point
        case "banker1":
            typeImageView = self.bankerCardImage1
            self.bankerCardValueLabel.text = "\(point)"
            self.bankersPoints = point
        case "banker2":
            typeImageView = self.bankerCardImage2
            self.bankerCardValueLabel.text = "\(point)"
            self.bankersPoints = point
        case "banker3":
            self.bankerCardImage3.isHidden = false
            self.bankerStackWidth.constant = 158
            typeImageView = self.bankerCardImage3
            self.bankerCardValueLabel.text = "\(point)"
            self.bankersPoints = point
        case "open":
            self.playerPoints = 0
            self.bankersPoints = 0
            self.playerCardImage1.image = UIImage(named: "poke")
            self.playerCardImage2.image = UIImage(named: "poke")
            self.bankerCardImage1.image = UIImage(named: "poke")
            self.bankerCardImage2.image = UIImage(named: "poke")
            self.bankerCardValueLabel.text = "0"
            self.playerCardValueLabel.text = "0"
            return
        default:
            self.playerPoints = 0
            self.bankersPoints = 0
            self.bankerCardValueLabel.text = "0"
            self.playerCardValueLabel.text = "0"
        }
        UIView.animate(withDuration: 1) {
            //   self.cardContainerHeightConstraint.constant = 122
            self.cardContainerView.isHidden = false
        } completion: { _ in
            if !type.isEmpty {
                self.flipImage(typeImageView!, image: cardNum)
            }
        }
    }
    func hideCardContainerView() {
        self.playerStackWidth.constant = 94
        self.bankerStackWidth.constant = 94
        showMarqueAnimation(selected: .noOne)
        tieIndicatorView.alpha = 0
        let backCardImage = UIImage(named: "poke")
        self.playerCardImage1.image = backCardImage
        self.playerCardImage2.image = backCardImage
        self.playerCardImage3.image = UIImage(named: "poke")
        self.bankerCardImage1.image = backCardImage
        self.bankerCardImage2.image = backCardImage
        self.bankerCardImage3.image = UIImage(named: "poke")
        self.bankerCardValueLabel.text = "0"
        self.playerCardValueLabel.text = "0"
        self.playerCardImage3.isHidden = true
        self.bankerCardImage3.isHidden = true
        playerCardValueLabel.isHidden = true
        bankerCardValueLabel.isHidden = true
        self.playerWinView.isHidden = true
        self.bankerWinView.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.cardContainerView.isHidden = true
        }
    }
    func flipImage(_ sender: UIImageView, image: String) {
        GameAudioVM.shared.playAudio(audioType: .sound, sound: .openpoke, voice: nil, addInQueue: true)
        UIView.transition(with: sender, duration: 0.4,
                          options: UIView.AnimationOptions.transitionFlipFromLeft,
                          animations: {
            sender.image = UIImage(named: image)
        }, completion: nil)
    }
    // MARK: All table view tap gesture setup
    func setupTapGesture() {
        let pPairTap = UITapGestureRecognizer(target: self, action: #selector(pPairViewTapped))
        pPairView.addGestureRecognizer(pPairTap)
        let tieTap = UITapGestureRecognizer(target: self, action: #selector(tieViewTapped))
        tieView.addGestureRecognizer(tieTap)
        let bPairTap = UITapGestureRecognizer(target: self, action: #selector(bPairViewTapped))
        bPairView.addGestureRecognizer(bPairTap)
        let playerTap = UITapGestureRecognizer(target: self, action: #selector(playerViewTapped))
        playerView.addGestureRecognizer(playerTap)
        let bankerTap = UITapGestureRecognizer(target: self, action: #selector(bankerViewTapped))
        bankerView.addGestureRecognizer(bankerTap)
    }
    @objc func pPairViewTapped() {
        if pPairStack.isEmpty {
            chipSpacing = 0
        }
        getPointstoAnimate(pPairView)
    }
    @objc func tieViewTapped() {
        if tiePairStack.isEmpty {
            chipSpacing = 0
        }
        getPointstoAnimate(tieView)
    }
    @objc func bPairViewTapped() {
        if bPairStack.isEmpty {
            chipSpacing = 0
        }
        getPointstoAnimate(bPairView)
    }
    @objc func playerViewTapped() {
        if playerStack.isEmpty {
            chipSpacing = 0
        }
        getPointstoAnimate(playerView)
    }
    @objc func bankerViewTapped() {
        if bankerStack.isEmpty {
            chipSpacing = 0
        }
        getPointstoAnimate(bankerView)
    }
    // MARK: Live Stream Events
    func setupVideoPlayer() {
        streamingPlayer.add(to: videoPlayer, placeholder: placeholderView, activityIndicator: self.placeholderActivityIndc)
    }
    func startLiveStreaming(url: String) {
        streamingPlayer.play(url: url)
    }
    func stopLiveStream() {
        streamingPlayer.stop()
    }
    // MARK: Socket Connection
    func callSocketRoom(data: TableGroupData) {
        self.closeWebSocketConnection()
        if Datamanager.shared.isUserAuthenticated {
            // Get Room List when user authenticated
            let groupNo = data.groupNo ?? ""
            let token = Datamanager.shared.accessToken
            let gameUrl = "\(groupNo)/\(token ?? "")"
            let urlForRoom  = Constants.SOCKETURLROOM.endpoint.appendingPathComponent(gameUrl)
            print("urlForRoom ==>", urlForRoom)
            webSocket = SRWebSocket(url: urlForRoom)
            webSocket.delegate = self
            webSocket.open()
        } else {
            self.endTimer()
            self.endSocketTimer()
        }
    }
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        safeAreaLead = view.safeAreaInsets.left
        safeAreaTrail = view.safeAreaInsets.right
        self.manageHeight()
    }
    func createCustomBarButton(userInfo: UserInfo?) {
        // Create Custom User Profile Bar Button
        if self.userInfo != nil {
            let btn = UIButton(type: .custom)
            btn.addTarget(self, action: #selector(backBtnClicked), for: .touchUpInside)
            btn.setImage(UIImage(named: "gameBack"), for: .normal)
            btn.setImage(UIImage(named: "gameBack"), for: .highlighted)
            btn.setImage(UIImage(named: "gameBack"), for: .selected)
            let leftBarButton = UIBarButtonItem()
            let (customView, walletLabel) = userProfileView(userInfo: userInfo!, color: .white, isNameRequired: false)
            leftBarButton.customView = customView
            customView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            customView.layer.cornerRadius = 5
            customView.clipsToBounds = true
            self.walletLabel = walletLabel
            // Tap Gesture to open Record VC On Profile Tap
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentRecordVC))
            leftBarButton.customView?.addGestureRecognizer(tapGesture)
            let backBtn = UIBarButtonItem(customView: btn)
            backBtn.tintColor = UIColor.white
            navigationItem.leftBarButtonItems = [backBtn, leftBarButton]
        } else {
            let backBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"),
                                          style: .done, target: self,
                                          action: #selector(backBtnClicked))
            backBtn.tintColor = UIColor.white
            navigationItem.leftBarButtonItems = [backBtn]
        }
    }
    @objc func backBtnClicked() {
        AudioManager.soundQueue.removeAll()
        if let gData = self.groupData, Datamanager.shared.isUserAuthenticated {
            self.eventHandler?.leaveTableGroup(groupNo: gData.groupNo ?? "")
        } else {
            self.previousVCDelegate?.handlePreviousVCData()
            self.navigationController?.popViewController(animated: true)
        }
        AudioManager.soundQueue.removeAll()
        AudioManager.stopSound()
    }
    @objc func presentRecordVC() {
        let navVC = storyboard?.instantiateViewController(withIdentifier: "recordsNav") as? UINavigationController
        navVC?.isModalInPresentation = true
        present(navVC!, animated: true)
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        clearStack(removeConfirmBet: true)
        clearUnconfirmBet()
        self.setbetIsDrawStatus(status: false)
        pPairStack = GameRoomStack.shared.pPairStack
        tiePairStack = GameRoomStack.shared.tiePairStack
        bPairStack = GameRoomStack.shared.bPairStack
        playerStack = GameRoomStack.shared.playerStack
        bankerStack = GameRoomStack.shared.bankerStack
        self.repeatAmount =  0
        self.totalBetAmount = 0
        self.isRepeatDraw = false
        _ = confirmpPairStack.count + confirmtiePairStack.count + confirmbPairStack.count + confirmplayerStack.count + confirmbankerStack.count
        
    }
    @IBAction func repeatButtonAction(_ sender: Any) {
        if isRepeatActive {
            let temppPairStack = pPairStack + confirmpPairStack
            let tempTiePairStack = tiePairStack + confirmtiePairStack
            let tempbPairStack = bPairStack + confirmbPairStack
            let tempPlayerStack = playerStack + confirmplayerStack
            let tempBankerStack = bankerStack + confirmbankerStack
            
            let pPairSum = temppPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            let tieSum = tempTiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            let bPairSum = tempbPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            let playerSum = tempPlayerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            let bankerSum = tempBankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            let repeatTotal = pPairSum + tieSum + bPairSum + playerSum + bankerSum
            let confirmedAmount = self.getConfirmedPlacedAmount()
            _ = repeatTotal - confirmedAmount
            if validateTimer() && validateRepeatTableLimit(pPairSum: pPairSum,
                                                           tieSum: tieSum,
                                                           bPairSum: bPairSum,
                                                           playerSum: playerSum,
                                                           bankerSum: bankerSum) {
                pPairStack += confirmpPairStack
                tiePairStack += confirmtiePairStack
                bPairStack += confirmbPairStack
                playerStack += confirmplayerStack
                bankerStack += confirmbankerStack
                Utils.modifiedStack.removeAll()
                validateAndAddChips()
                if repeatAmount > 0 {
                    self.isRepeatDraw = true
                }
                if confirmpPairStack.count > 0 {
                    repeatAmount += confirmpPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                }
                if confirmtiePairStack.count > 0 {
                    repeatAmount += confirmtiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                }
                if confirmbPairStack.count > 0 {
                    repeatAmount += confirmbPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                }
                if confirmplayerStack.count > 0 {
                    repeatAmount += confirmplayerStack.map({$0.chip.value ?? 0}).reduce(0, +)
                }
                if confirmbankerStack.count > 0 {
                    repeatAmount += confirmbankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
                }
                self.setbetIsDrawStatus(status: true)
            } else {
                // Show Alert
            }
        } else {
            Utils.vibrateDevice()
        }
    }
    // Function for repeat Coins
    func validateAndAddChips() {
        let startPoint = actionButtonStack.convert(repeatButton.center, to: actionButtonStack.superview) // repeatButton.center
        let playerNumber = self.groupData?.seatNo ?? "0"
        let pPairSum = pPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
        let tieSum = tiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
        let bPairSum = bPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
        let playerSum = playerStack.map({$0.chip.value ?? 0}).reduce(0, +)
        let bankerSum = bankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
        GameAudioVM.shared.playAudio(audioType: .sound, sound: .bet, voice: nil, addInQueue: true)
        let pPairEndPoint = tableContainerView.convert(pPairView.center, to: tableContainerView.superview)
        let tieEndPoint = tableContainerView.convert(tieView.center, to: tableContainerView.superview)
        let bPairEndPoint = tableContainerView.convert(bPairView.center, to: tableContainerView.superview)
        let playerEndPoint = tableContainerView.convert(playerView.center, to: tableContainerView.superview)
        let bankerEndPoint = tableContainerView.convert(bankerView.center, to: tableContainerView.superview)
        
        confirmpPairStack.forEach { stack in
            pPairValueVU.isHidden = false
            addChip(to: pPairView,
                    startPoint: startPoint,
                    endPoint: CGPoint(x: pPairEndPoint.x, y: pPairEndPoint.y + CGFloat(yRepeatPositionCoinExtra)),
                    isRepeat: true,
                    coin: stack.chip)
            pPairValueVU.updateView(player: playerNumber,
                                    amount: (userInfo?.symbol ?? "$").appending("\(pPairSum)"))
        }
        
        confirmtiePairStack.forEach { stack in
            tiePairValueVU.isHidden = false
            addChip(to: tieView,
                    startPoint: startPoint,
                    endPoint: CGPoint(x: tieEndPoint.x, y: tieEndPoint.y + CGFloat(yRepeatPositionCoinExtra)),
                    isRepeat: true,
                    coin: stack.chip)
            tiePairValueVU.updateView(player: playerNumber,
                                      amount: (userInfo?.symbol ?? "$").appending("\(tieSum)"))
        }
        
        confirmbPairStack.forEach { stack in
            bPairValueVU.isHidden = false
            addChip(to: bPairView,
                    startPoint: startPoint,
                    endPoint: CGPoint(x: bPairEndPoint.x, y: bPairEndPoint.y + CGFloat(yRepeatPositionCoinExtra)),
                    isRepeat: true,
                    coin: stack.chip)
            bPairValueVU.updateView(player: playerNumber,
                                    amount: (userInfo?.symbol ?? "$").appending("\(bPairSum)"))
        }
        
        confirmplayerStack.forEach { stack in
            playerValueVU.isHidden = false
            addChip(to: playerView,
                    startPoint: startPoint,
                    endPoint: CGPoint(x: playerEndPoint.x, y: playerEndPoint.y + CGFloat(yRepeatPositionCoinExtra)),
                    isRepeat: true,
                    coin: stack.chip)
            playerValueVU.updateView(player: playerNumber,
                                     amount: (userInfo?.symbol ?? "$").appending("\(playerSum)"))
        }
        
        confirmbankerStack.forEach { stack in
            bankerValueVU.isHidden = false
            addChip(to: bankerView,
                    startPoint: startPoint,
                    endPoint: CGPoint(x: bankerEndPoint.x, y: bankerEndPoint.y + CGFloat(yRepeatPositionCoinExtra)),
                    isRepeat: true,
                    coin: stack.chip)
            bankerValueVU.updateView(player: playerNumber,
                                     amount: (userInfo?.symbol ?? "$").appending("\(bankerSum)"))
        }
        
        // Updating Stack after modification
        pPairStack = modifyStack(isRepeat: true, stacks: &pPairStack, endPoint: CGPoint(x: pPairEndPoint.x, y: pPairEndPoint.y + CGFloat(yRepeatPositionCoinExtra)))
        
        tiePairStack = modifyStack(isRepeat: true, stacks: &tiePairStack, endPoint: CGPoint(x: tieEndPoint.x, y: tieEndPoint.y + CGFloat(yRepeatPositionCoinExtra)))
        
        bPairStack = modifyStack(isRepeat: true, stacks: &bPairStack, endPoint: CGPoint(x: bPairEndPoint.x, y: bPairEndPoint.y + CGFloat(yRepeatPositionCoinExtra)))
        
        playerStack = modifyStack(isRepeat: true, stacks: &playerStack, endPoint: CGPoint(x: playerEndPoint.x, y: playerEndPoint.y + CGFloat(yRepeatPositionCoinExtra)))
        bankerStack = modifyStack(isRepeat: true, stacks: &bankerStack, endPoint: CGPoint(x: bankerEndPoint.x, y: bankerEndPoint.y + CGFloat(yRepeatPositionCoinExtra)))
    }
    func showPreviousChipData() {
        let playerNumber = self.groupData?.seatNo ?? "0"
        pPairStack = GameRoomStack.shared.pPairStack
        tiePairStack = GameRoomStack.shared.tiePairStack
        bPairStack = GameRoomStack.shared.bPairStack
        playerStack = GameRoomStack.shared.playerStack
        bankerStack = GameRoomStack.shared.bankerStack
        
        confirmpPairStack = GameRoomStack.shared.pPairStack
        confirmtiePairStack = GameRoomStack.shared.tiePairStack
        confirmbPairStack = GameRoomStack.shared.bPairStack
        confirmplayerStack = GameRoomStack.shared.playerStack
        confirmbankerStack  = GameRoomStack.shared.bankerStack
        
        let totalCount = pPairStack.count + tiePairStack.count + bPairStack.count + playerStack.count + bankerStack.count
        if totalCount == 0 {
            //    repeatButton.backgroundColor = .white.withAlphaComponent(0.3)
            Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
            //  isRepeatActive = false
            isRepeatActive = false
            //  repeatButton.isUserInteractionEnabled = false
            self.repeatButtonHandle(isEnable: false)
        } else {
            // repeatButton.backgroundColor = .secondary
            Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
            isRepeatActive = true
            // repeatButton.isUserInteractionEnabled = true
            self.repeatButtonHandle(isEnable: true)
        }
        if pPairStack.count > 0 {
            pPairStack.forEach { tableContainerView.superview?.addSubview($0.chipView) }
            pPairValueVU.isHidden = false
            let pPairSum = pPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            pPairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(pPairSum)"))
            confirmpPairStack = pPairStack
        }
        if tiePairStack.count > 0 {
            tiePairStack.forEach { tableContainerView.superview?.addSubview($0.chipView) }
            tiePairValueVU.isHidden = false
            let tieSum = tiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            tiePairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(tieSum)"))
            confirmtiePairStack = tiePairStack
        }
        if bPairStack.count > 0 {
            bPairStack.forEach { tableContainerView.superview?.addSubview($0.chipView) }
            bPairValueVU.isHidden = false
            let bPairSum = bPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            bPairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(bPairSum)"))
            confirmbPairStack = bPairStack
        }
        if playerStack.count > 0 {
            playerStack.forEach { tableContainerView.superview?.addSubview($0.chipView) }
            playerValueVU.isHidden = false
            let playerSum = playerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            playerValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(playerSum)"))
            confirmplayerStack = playerStack
        }
        if bankerStack.count > 0 {
            bankerStack.forEach { tableContainerView.superview?.addSubview($0.chipView) }
            bankerValueVU.isHidden = false
            let bankerSum = bankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            bankerValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(bankerSum)"))
            confirmbankerStack = bankerStack
        }
        // Show Other Players Chip
        showOtherPlayerVU()
    }
    @IBAction func confirmButtonAction(_ sender: Any) {
        totalBetAmount = 0.0
        self.isRepeatDraw =  true
        var arrCoinsValue: [[String: Any]] = []
        // set Player total sum
        if playerStack.count > 0 {
            var totalPlayerValue = playerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmount += Double(totalPlayerValue)
            if self.isRepeatDraw == true {
                let totalPlayerValueC = GameRoomStack.shared.playerStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBetAmount -= Double(totalPlayerValueC)
            }
            if totalPlayerValue > 0 {
                let dicPlayer = ["betCode": "1", "betMoney": totalPlayerValue] as [String: Any]
                arrCoinsValue.append(dicPlayer)
            }
        }
        // set Player Pair total sum
        if pPairStack.count > 0 {
            let totalPlayerPValue = pPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmount += Double(totalPlayerPValue)
            if self.isRepeatDraw == true {
                let totalPlayerValueC = GameRoomStack.shared.pPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBetAmount -= Double(totalPlayerValueC)
            }
            if totalPlayerPValue > 0 {
                let dicPlayerP = ["betCode": "5", "betMoney": totalPlayerPValue] as [String: Any]
                arrCoinsValue.append(dicPlayerP)
            }
        }
        // set Banker total sum
        if bankerStack.count > 0 {
            let totalBankerValue = bankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmount += Double(totalBankerValue)
            if self.isRepeatDraw == true {
                let totalPlayerValueC = GameRoomStack.shared.bankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBetAmount -= Double(totalPlayerValueC)
            }
            if totalBankerValue > 0 {
                let dicBanker = ["betCode": "4", "betMoney": totalBankerValue] as [String: Any]
                arrCoinsValue.append(dicBanker)
            }
        }
        // set Banker Pair total sum
        if bPairStack.count > 0 {
            var totalBankerPValue = bPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmount += Double(totalBankerPValue)
            if self.isRepeatDraw == true {
                let totalPlayerValueC = GameRoomStack.shared.bPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBetAmount -= Double(totalPlayerValueC)
            }
            if totalBankerPValue > 0 {
                let dicBankerP = ["betCode": "8", "betMoney": totalBankerPValue] as [String: Any]
                arrCoinsValue.append(dicBankerP)
            }
        }
        // set Tie total sum
        if tiePairStack.count > 0 {
            var totalTieValue = tiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmount += Double(totalTieValue)
            if self.isRepeatDraw == true {
                let totalPlayerValueC = GameRoomStack.shared.tiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBetAmount -= Double(totalPlayerValueC)
            }
            if totalTieValue > 0 {
                let dicTie = ["betCode": "7", "betMoney": totalTieValue] as [String: Any]
                arrCoinsValue.append(dicTie)
            }
        }
        // Validate add chip limit
        if validateBetAmount() && validateTimer() {
            if arrCoinsValue.count > 0 {
                let currency = self.userInfo?.currency ?? ""
                let boothNum = self.tableInfoData?.gameTableStatusVo?.bootNo ?? ""
                let freeStatus = (self.tableInfoData?.userFreeStatus ?? true == true) ? "true" : "false"
                let groupNum = self.groupData?.groupNo ?? ""
                let roundNo = self.tableInfoData?.gameTableStatusVo?.roundNo ?? ""
                let betData = BetData(currency: currency, boothNum: boothNum,
                                      freeStatus: freeStatus, groupNum: groupNum,
                                      roundNo: roundNo,
                                      arrCoinsValue: arrCoinsValue)
                self.eventHandler?.setBetData(betData: betData)
            }
        }
    }
    func getUnConfirmedPlacedAmount() -> Double {
        var totalBetAmountValue = 0.0
        // set Player total sum
        if playerStack.count > 0 {
            let totalPlayerValue = playerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmountValue += Double(totalPlayerValue)
            let totalPlayerValueC = confirmplayerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmountValue -= Double(totalPlayerValueC)
        }
        // set Player Pair total sum
        if pPairStack.count > 0 {
            let totalPlayerPValue = pPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmountValue += Double(totalPlayerPValue)
            let totalPlayerValueC = confirmpPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmountValue -= Double(totalPlayerValueC)
        }
        // set Banker total sum
        if bankerStack.count > 0 {
            let totalBankerValue = bankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmountValue += Double(totalBankerValue)
            let totalPlayerValueC = confirmbankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmountValue -= Double(totalPlayerValueC)
        }
        // set Banker Pair total sum
        if bPairStack.count > 0 {
            let totalBankerPValue = bPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmountValue += Double(totalBankerPValue)
            let totalPlayerValueC = confirmbPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmountValue -= Double(totalPlayerValueC)
        }
        // set Tie total sum
        if tiePairStack.count > 0 {
            let totalTieValue = tiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmountValue += Double(totalTieValue)
            let totalPlayerValueC = confirmtiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            totalBetAmountValue -= Double(totalPlayerValueC)
        }
        if totalBetAmountValue > 0 {
            return totalBetAmountValue
        } else if totalBetAmountValue == 0 {
            return 0
        } else {
            return totalBetAmountValue * -1
        }
    }
    func getConfirmedPlacedAmount() -> Int {
        var totalBetAmountValue = 0
        if self.isRepeatDraw == true {
            // set Player total sum
            if confirmplayerStack.count > 0 {
                let totalPlayerValue = confirmplayerStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBetAmountValue += totalPlayerValue
                
            }
            // set Player Pair total sum
            if confirmpPairStack.count > 0 {
                let totalPlayerPValue = confirmpPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBetAmountValue += totalPlayerPValue
                
            }
            // set Banker total sum
            if confirmbankerStack.count > 0 {
                let totalBankerValue = confirmbankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBetAmountValue += totalBankerValue
                
            }
            // set Banker Pair total sum
            if confirmbPairStack.count > 0 {
                let totalBankerPValue = confirmbPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBetAmountValue += totalBankerPValue
                
            }
            // set Tie total sum
            if confirmtiePairStack.count > 0 {
                let totalTieValue = confirmtiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBetAmountValue += totalTieValue
            }
        }
        return totalBetAmountValue
    }
    func setbetIsDrawStatus(status: Bool) {
        // set isConfirm status for confirm stack
        for index in 0 ..< confirmpPairStack.count {
            confirmpPairStack[index].isDraw = status
        }
        for index in 0 ..< confirmbPairStack.count {
            confirmbPairStack[index].isDraw = status
        }
        for index in 0 ..< confirmplayerStack.count {
            confirmplayerStack[index].isDraw = status
        }
        for index in 0 ..< confirmbankerStack.count {
            confirmbankerStack[index].isDraw = status
        }
        for index in 0 ..< confirmtiePairStack.count {
            confirmtiePairStack[index].isDraw = status
        }
        // GameRoomStack set status
        for index in 0 ..< GameRoomStack.shared.pPairStack.count {
            GameRoomStack.shared.pPairStack[index].isDraw = status
        }
        for index in 0 ..< GameRoomStack.shared.bPairStack.count {
            GameRoomStack.shared.bPairStack[index].isDraw = status
        }
        for index in 0 ..< GameRoomStack.shared.playerStack.count {
            GameRoomStack.shared.playerStack[index].isDraw = status
        }
        for index in 0 ..< GameRoomStack.shared.bankerStack.count {
            GameRoomStack.shared.bankerStack[index].isDraw = status
        }
        for index in 0 ..< GameRoomStack.shared.tiePairStack.count {
            GameRoomStack.shared.tiePairStack[index].isDraw = status
        }
    }
    func validateBetAmount() -> Bool {
        if totalBetAmount > (self.userInfo?.userMoney ?? 0.0) {
            showAlert(withTitle: "Alert".localizable, message: "Insufficient balance".localizable)
            return false
        } else if totalBetAmount > self.tableInfoData?.tableLimit ?? 0.0 {
            showAlert(withTitle: "Alert".localizable, message: "The betting amount is higher than the betting limit".localizable)
            return false
        } else {
            return true
        }
    }
    func validateTimer() -> Bool {
        // Validate Game Timer
        if tableInfoData?.gameTableStatusVo?.status == 1 && totalBetTime >= 2 {
            return true
        } else {
            return false
        }
    }
    func validateRepeatTableLimit(pPairSum: Int, tieSum: Int, bPairSum: Int, playerSum: Int, bankerSum: Int) -> Bool {
        if let dict = tableInfoData?.bacGameLimitPlanContent {
            let bankerLimit = Int(dict["bankerMax"] ?? 0)
            let playerLimit = Int(dict["playerMax"] ?? 0)
            let tieLimit = Int(dict["tieMax"] ?? 0)
            let bankerPairLimit = Int(dict["bankerPairMax"] ?? 0)
            let playerPairLimit = Int(dict["playerPairMax"] ?? 0)
            
            if pPairSum <= playerPairLimit && bPairSum <= bankerPairLimit && tieSum <= tieLimit && bankerSum <= bankerLimit && playerSum <= playerLimit {
                return true
            } else {
                showAlert(withTitle: "Alert".localizable, message: "The betting amount is higher than the betting limit".localizable)
                return false
            }
        } else {
            return false
        }
    }
    func validateTableBetLimit(_ sender: UIView, chip: CasinoChip) -> Bool {
        if let dict = tableInfoData?.bacGameLimitPlanContent {
            let bankerLimit = Int(dict["bankerMax"] ?? 0)
            let playerLimit = Int(dict["playerMax"] ?? 0)
            let tieLimit = Int(dict["tieMax"] ?? 0)
            let bankerPairLimit = Int(dict["bankerPairMax"] ?? 0)
            let playerPairLimit = Int(dict["playerPairMax"] ?? 0)
            if sender == bankerView {
                var totalBankerValue = bankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBankerValue += chip.value
                if chip.value <= bankerLimit && totalBankerValue <= bankerLimit {
                    return true
                }
            } else if sender == playerView {
                var totalPlayerValue = playerStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalPlayerValue += chip.value
                if chip.value <= playerLimit && totalPlayerValue <= playerLimit {
                    return true
                }
            } else if sender == tieView {
                var totalTieValue = tiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalTieValue += chip.value
                if chip.value <= tieLimit && totalTieValue <= tieLimit {
                    return true
                }
            } else if sender == bPairView {
                var totalBPairValue = bPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalBPairValue += chip.value
                if chip.value <= bankerPairLimit && totalBPairValue <= bankerPairLimit {
                    return true
                }
            } else if sender == pPairView {
                var totalPPairValue = pPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                totalPPairValue += chip.value
                if chip.value <= playerPairLimit && totalPPairValue <= playerPairLimit {
                    return true
                }
            }
        }
        showAlert(withTitle: "Alert".localizable, message: "The betting amount is higher than the betting limit".localizable)
        return false
    }
    @IBAction func showCommissionFeePopUp(_ sender: Any) {
        if (self.tableInfoData?.gameTableStatusVo?.status ?? 0) != 4 && (self.tableInfoData?.gameTableStatusVo?.status ?? 0) != 2 {
            showFeeStatusVC()
        }
    }
    func showFeeStatusVC() {
        let popupVC = storyboard?.instantiateViewController(withIdentifier: "FeesStatusVC") as? FeesStatusVC
        popupVC?.modalPresentationStyle = .overCurrentContext
        popupVC?.modalTransitionStyle = .crossDissolve
        popupVC?.tableInfoData = self.tableInfoData
        popupVC?.groupData = self.groupData
        popupVC?.freeStatusDelegate = self
        let presentationVC = popupVC?.popoverPresentationController
        presentationVC?.permittedArrowDirections = .any
        present(popupVC!, animated: true)
    }
    @IBAction func switchTableButtonAction(_ sender: Any) {
        let destVC = self.storyboard?.instantiateViewController(withIdentifier: "SwitchGameRoomVC") as? SwitchGameRoomVC
        if #available(iOS 15.0, *) {
            if let presentationController = destVC!.presentationController as? UISheetPresentationController {
                presentationController.detents = [.medium()]
            }
        } else {
            // Fallback on earlier versions
        }
        destVC?.casinoCurrentData = self.casinoData
        destVC?.roomList = self.roomList
        destVC?.switchDelegate = self
        self.present(destVC!, animated: true)
    }
    @IBAction func bankerPlayerPredictAction(btn: UIButton) {
        self.setPredictImageAnimation(tag: btn.tag)
    }
    @objc func videoRefresh() {
        if placeholderView.isHidden == true {
            self.setupVideoPlayer()
            if let url = self.casinoData?.liveURL as? String {
                self.startLiveStreaming(url: url)
            }
        }
    }
    @objc func soundSettings() {
        let popupVC = storyboard?.instantiateViewController(withIdentifier: "SoundVC") as? SoundVC
        popupVC?.modalPresentationStyle = .overCurrentContext
        popupVC?.modalTransitionStyle = .crossDissolve
        popupVC?.delegate = self
        let presentationVC = popupVC?.popoverPresentationController
        presentationVC?.permittedArrowDirections = .any
        present(popupVC!, animated: true)
    }
    @objc func showGameRules() {
        let navVC = UINavigationController()
        let destVC = storyboard?.instantiateViewController(withIdentifier: "RollingRulesVC") as? RollingRulesVC
        navVC.viewControllers = [destVC!]
        present(navVC, animated: true)
    }
    func setBetInfoData(data: [BetPotDetailVo]) {
        for item in data {
            if item.location == "1" {
                self.pRoomBetPotValueLbl.text = item.potMoneyDisplay
                self.pRoomBetPotCountLbl.text = "\(item.potCount ?? 0)"
            } else if item.location == "5" {
                self.pPRoomBetPotValueLbl.text = item.potMoneyDisplay
                self.pPRoomBetPotCountLbl.text = "\(item.potCount ?? 0)"
            } else if item.location == "4"{
                self.bRoomBetPotValueLbl.text = item.potMoneyDisplay
                self.bRoomBetPotCountLbl.text = "\(item.potCount ?? 0)"
            } else if item.location ==  "8" {
                self.bPRoomBetPotValueLbl.text = item.potMoneyDisplay
                self.bPRoomBetPotCountLbl.text = "\(item.potCount ?? 0)"
            } else if item.location ==  "7" {
                self.tieRoomBetPotValueLbl.text = item.potMoneyDisplay
                self.tieRoomBetPotCountLbl.text = "\(item.potCount ?? 0)"
            }
            
        }
    }
    func pingToWebSocket() {
        if Datamanager.shared.isUserAuthenticated {
            self.checkVideoPlayerStatus()
            if self.webSocket != nil && self.webSocket.readyState == .OPEN {
                do {
                    try self.webSocket.sendPing(nil)
                } catch { }
            } else if self.webSocket != nil && self.groupData != nil && self.webSocket.readyState == .CLOSED {
                self.callSocketRoom(data: self.groupData!)
            } else if self.webSocket != nil && self.groupData != nil && self.webSocket.readyState == .CLOSING {
                self.callSocketRoom(data: self.groupData!)
            } else if self.webSocket != nil && self.groupData != nil && self.webSocket.readyState == .CONNECTING {
                do {
                    try self.webSocket.sendPing(nil)
                } catch { }
            }
        }
    }
    func closeWebSocketConnection() {
        if webSocket != nil && webSocket.readyState == .OPEN {
            webSocket.close()
            webSocket.delegate = nil
            webSocket = nil
        }
    }
    func showOtherChipData(bet: BetRecordVo) {
        GameRoomStack.shared.previousRoundNumber = tableInfoData?.gameTableInfoStatisticsVo?.roundNum ?? 0
        var betInfo = BetInfo(gameID: 0,
                              betCode: "1",
                              symbol: bet.symbol ?? "",
                              betMoney: 0,
                              groupID: self.groupData?.groupID ?? 0,
                              placeID: self.tableInfoData?.placeID ?? 0,
                              userID: bet.userID ?? 0,
                              bootNo: self.tableInfoData?.gameTableStatusVo?.bootNo ?? "",
                              currency: bet.currency ?? "",
                              roundNo: self.tableInfoData?.gameTableStatusVo?.roundNo ?? "",
                              seatNo: bet.seatNo ?? "",
                              username: bet.username ?? "",
                              tableNo: self.tableInfoData?.tableNo ?? "")
        if let betAmount = bet.betDetails?.player {
            betInfo.betMoney = betAmount
            betInfo.betCode = "1"
            addChipsForOtherPlayers(info: betInfo, firstTimeDraw: true)
        }
        if let betAmount = bet.betDetails?.banker {
            betInfo.betMoney = betAmount
            betInfo.betCode = "4"
            addChipsForOtherPlayers(info: betInfo, firstTimeDraw: true)
        }
        if let betAmount = bet.betDetails?.playerPair {
            betInfo.betMoney = betAmount
            betInfo.betCode = "5"
            addChipsForOtherPlayers(info: betInfo, firstTimeDraw: true)
        }
        if let betAmount = bet.betDetails?.tie {
            betInfo.betMoney = betAmount
            betInfo.betCode = "7"
            addChipsForOtherPlayers(info: betInfo, firstTimeDraw: true)
        }
        if let betAmount = bet.betDetails?.bankerPair {
            betInfo.betMoney = betAmount
            betInfo.betCode = "8"
            addChipsForOtherPlayers(info: betInfo, firstTimeDraw: true)
        }
        
    }
    func showOwnChipData(bet: BetRecordVo) {
        playerStack.removeAll()
        bankerStack.removeAll()
        pPairStack.removeAll()
        bPairStack.removeAll()
        tiePairStack.removeAll()
        confirmplayerStack.removeAll()
        confirmbankerStack.removeAll()
        confirmpPairStack.removeAll()
        confirmbPairStack.removeAll()
        confirmtiePairStack.removeAll()
        self.removePreviousBetData()
        if let betAmount = bet.betDetails?.player {
            playerStack = createChipStack(sender: playerView, sum: betAmount)
        }
        if let betAmount = bet.betDetails?.banker {
            bankerStack = createChipStack(sender: bankerView, sum: betAmount)
        }
        if let betAmount = bet.betDetails?.playerPair {
            pPairStack = createChipStack(sender: pPairView, sum: betAmount)
        }
        if let betAmount = bet.betDetails?.tie {
            tiePairStack = createChipStack(sender: tieView, sum: betAmount)
        }
        if let betAmount = bet.betDetails?.bankerPair {
            bPairStack = createChipStack(sender: bPairView, sum: betAmount)
        }
        confirmplayerStack = playerStack
        confirmbankerStack = bankerStack
        confirmpPairStack = pPairStack
        confirmtiePairStack = tiePairStack
        confirmbPairStack = bPairStack
        let playerNumber = self.groupData?.seatNo ?? "0"
        let pPairSum = confirmpPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
        let tieSum = confirmtiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
        let bPairSum = confirmbPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
        let playerSum = confirmplayerStack.map({$0.chip.value ?? 0}).reduce(0, +)
        let bankerSum = confirmbankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
        let startPoint = coinContainerView.convert(coinTable.center, to: coinContainerView.superview) //
        confirmpPairStack.forEach { stack in
            pPairValueVU.isHidden = false
            addChipForOwnBets(to: pPairView, startPoint: startPoint, endPoint: stack.chipView.frame.origin, isRepeat: false, stack: stack)
            pPairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(pPairSum)"))
        }
        
        confirmtiePairStack.forEach { stack in
            tiePairValueVU.isHidden = false
            addChipForOwnBets(to: tieView, startPoint: startPoint, endPoint: stack.chipView.frame.origin, isRepeat: true, stack: stack)
            tiePairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(tieSum)"))
        }
        
        confirmbPairStack.forEach { stack in
            bPairValueVU.isHidden = false
            addChipForOwnBets(to: bPairView, startPoint: startPoint, endPoint: stack.chipView.frame.origin, isRepeat: true, stack: stack)
            bPairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(bPairSum)"))
        }
        
        confirmplayerStack.forEach { stack in
            playerValueVU.isHidden = false
            addChipForOwnBets(to: playerView, startPoint: startPoint, endPoint: stack.chipView.frame.origin, isRepeat: true, stack: stack)
            playerValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(playerSum)"))
        }
        
        confirmbankerStack.forEach { stack in
            bankerValueVU.isHidden = false
            addChipForOwnBets(to: bankerView, startPoint: startPoint, endPoint: stack.chipView.frame.origin, isRepeat: true, stack: stack)
            bankerValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(bankerSum)"))
        }
        let totalCount = pPairStack.count + tiePairStack.count + bPairStack.count + playerStack.count + bankerStack.count
        if totalCount == 0 {
            Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
            isRepeatActive = false
            self.repeatButtonHandle(isEnable: false)
        } else {
            Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
            isRepeatActive = true
            self.repeatButtonHandle(isEnable: true)
        }
        DispatchQueue.main.async {
            self.cancelButtonHandle(isEnable: false)
            self.confirmButtonHandle(isEnable: false)
            self.repeatButtonHandle(isEnable: self.isRepeatActive)
            Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
        }
        playerStack = confirmplayerStack
        bankerStack = confirmbankerStack
        pPairStack = confirmpPairStack
        tiePairStack = confirmtiePairStack
        bPairStack = confirmbPairStack
        GameRoomStack.shared.pPairStack = confirmpPairStack
        GameRoomStack.shared.tiePairStack = confirmtiePairStack
        GameRoomStack.shared.bPairStack = confirmbPairStack
        GameRoomStack.shared.playerStack = confirmplayerStack
        GameRoomStack.shared.bankerStack = confirmbankerStack
        self.setbetIsDrawStatus(status: true)
        self.isRepeatDraw = true
    }
    func createChipStack(sender: UIView, sum: Int) -> [ChipStack] {
        // Exact Position where the chip needs to be placed
        // EndPoint is origin now
        let endPoint = tableContainerView.convert(sender.center, to: tableContainerView.superview)
        Utils.modifiedStack.removeAll()
        let chipArray = Utils.checkChipExistRange(chipValue: sum)
        var modifiedStack = [ChipStack]()
        // Redraw updated Chips
        var spacing: CGFloat = 5.0
        for chip in chipArray {
            let imageView = UIImageView(frame: CGRect(x: endPoint.x - 10,
                                                      y: (endPoint.y + 10) - spacing, width: 20, height: 20))
            imageView.image = chip.slandingImage
            let chipStack = ChipStack(chip: chip, chipView: imageView)
            modifiedStack.append(chipStack)
            spacing += 5.0
        }
        modifiedStack.forEach { tableContainerView.superview?.addSubview($0.chipView)}
        return modifiedStack
    }
    func addChipForOwnBets(to view: UIView, startPoint: CGPoint, endPoint: CGPoint, isRepeat: Bool, stack: ChipStack) {
        let extraSpace1: CGFloat = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6 ) ? 10: 15
        self.cancelButtonHandle(isEnable: true)
        self.confirmButtonHandle(isEnable: true)
        
        GameAudioVM.shared.playAudio(audioType: .sound, sound: .bet, voice: nil, addInQueue: false)
        stack.chipView.bringSubviewToFront(tableContainerView)
        tableContainerView.superview?.addSubview(stack.chipView)
        stack.chipView.frame.origin = startPoint
        UIView.animate(withDuration: 0.5) {
            stack.chipView.frame.origin = CGPoint(x: endPoint.x, y: endPoint.y + extraSpace1)
        } completion: { _ in
        }
        self.otherPlayerBetShowOnFront()
    }
}

// MARK: Add Chip Animation
extension GameRoomVC {
    func addChipsForOtherPlayers(info: BetInfo, firstTimeDraw: Bool) {
        if info.betCode == "1" {
            // Player
            getOtherPlayerPointsToAnimate(playerView, info: info, firstTimeDraw: firstTimeDraw)
        } else if info.betCode == "5" {
            // Player Pair
            getOtherPlayerPointsToAnimate(pPairView, info: info, firstTimeDraw: firstTimeDraw)
        } else if info.betCode == "4" {
            // Banker
            getOtherPlayerPointsToAnimate(bankerView, info: info, firstTimeDraw: firstTimeDraw)
        } else if info.betCode == "8" {
            // Banker Pair
            getOtherPlayerPointsToAnimate(bPairView, info: info, firstTimeDraw: firstTimeDraw)
        } else if info.betCode == "7" {
            // Tie
            getOtherPlayerPointsToAnimate(tieView, info: info, firstTimeDraw: firstTimeDraw)
        }
    }
    
    func getOtherPlayerPointsToAnimate(_ sender: UIView, info: BetInfo, firstTimeDraw: Bool) {
        let startPoint = otherPlayerView.convert(CGPoint(x: 0, y: otherPlayerView.center.y), to: otherPlayerView.superview)
        // Finding the players seat no and defining endpoints
        // get end point
        let (endPoint, isReapeatTemp) = self.getEndPointOfOtherPlayer(sender: sender, info: info)
        Utils.modifiedStack.removeAll()
        let chipArray = Utils.checkChipExistRange(chipValue: info.betMoney)
        var chipStacks = [ChipStack]()
        for chip in chipArray {
            let imageView = UIImageView(frame: CGRect(x: startPoint.x,
                                                      y: (startPoint.y), width: 20, height: 20))
            imageView.image = chip.slandingImage
            let chipStack = ChipStack(chip: chip, chipView: imageView)
            chipStacks.append(chipStack)
        }
        chipStacks.forEach {
            tableContainerView.superview?.addSubview($0.chipView)
        }
        animateOtherPlayerChip(chipStacks: chipStacks, endPoint: endPoint, info: info, isReapeat: isReapeatTemp)
    }
    func animateOtherPlayerChip(chipStacks: [ChipStack], endPoint: CGPoint, info: BetInfo, isReapeat: Bool) {
        let endPoint = CGPoint(x: endPoint.x, y: endPoint.y + (isReapeat == true ? 0: 20))
        var spacing = 0
        chipStacks.forEach { chip in
            UIView.animate(withDuration: 0.3) {
                chip.chipView.frame.origin = CGPoint(x: endPoint.x, y: (endPoint.y - CGFloat(spacing)))
                chip.chipView.frame.size = CGSize(width: 16, height: 16)
                spacing += 5
            } completion: { _ in
            }
        }
        let chipValueVU = ChipValueView()
        tableContainerView.superview?.addSubview(chipValueVU)
        tableContainerView.superview?.bringSubviewToFront(chipValueVU)
        chipValueVU.translatesAutoresizingMaskIntoConstraints = false
        let firstStack = chipStacks.first!
        
        NSLayoutConstraint.activate([
            chipValueVU.centerXAnchor.constraint(equalTo: firstStack.chipView.centerXAnchor),
            chipValueVU.topAnchor.constraint(equalTo: firstStack.chipView.centerYAnchor, constant: 5),
            chipValueVU.heightAnchor.constraint(equalToConstant: 20)
        ])
        chipValueVU.updateView(player: info.seatNo, amount: info.symbol + "\(info.betMoney)")
        // Storing [ChipStack] and ChipValueView in ChipTuple
        GameRoomStack.shared.chipTuple.append((info.seatNo, info.betCode, chipStacks, chipValueVU))
    }
    func getEndPointOfOtherPlayer(sender: UIView, info: BetInfo) -> (CGPoint, Bool) {
        var totalOtherPlayers = 0
        var endPoint = CGPoint()
        let containsElement = GameRoomStack.shared.chipTuple.contains { element in
            if element.0 == info.seatNo && element.1 == info.betCode {
                if let chipImage = element.2.first?.chipView, let chipUI = element.2.first?.chipView {
                    endPoint = CGPoint(x: chipUI.frame.origin.x, y: chipImage.frame.origin.y)
                }
            }
            return element.0 == info.seatNo && element.1 == info.betCode
        }
        if containsElement {
            _ = [(String, String, [ChipStack], ChipValueView)]()
            for item in GameRoomStack.shared.chipTuple where item.0 == info.seatNo && item.1 == info.betCode {
                let chips = item.2
                item.3.removeFromSuperview()
                for chip in chips {
                    chip.chipView.removeFromSuperview()
                }
            }
            GameRoomStack.shared.chipTuple.removeAll { (seatNo, betCode, _, _) in
                return seatNo == info.seatNo && betCode == info.betCode
            }
            return (endPoint, true)
        }
        let xSpacing = 20
        let ySpacing = 20
        if !containsElement {
            if info.betCode == "1" {
                // Player
                self.otherTotalPlayerView += 1
            } else if info.betCode == "5" {
                // Player Pair
                self.otherTotalPpairView += 1
            } else if info.betCode == "4" {
                // Banker
                self.otherTotalBankerView += 1
            } else if info.betCode == "8" {
                // Banker Pair
                self.otherTotalBpairView += 1
            } else if info.betCode == "7" {
                // Tie
                self.otherTotalTieView += 1
            }
        }
        if info.betCode == "1" {
            // Player
            totalOtherPlayers = self.otherTotalPlayerView
        } else if info.betCode == "5" {
            // Player Pair
            totalOtherPlayers = self.otherTotalPpairView
        } else if info.betCode == "4" {
            // Banker
            totalOtherPlayers = self.otherTotalBankerView
        } else if info.betCode == "8" {
            // Banker Pair
            totalOtherPlayers = self.otherTotalBpairView
        } else if info.betCode == "7" {
            // Tie
            totalOtherPlayers = self.otherTotalTieView
        }
        if containsElement {
            
        }
        if totalOtherPlayers % 2 == 0 {
            let xPosition = ((totalOtherPlayers / 2) * (xSpacing / 2)) + 10
            let yPosition = (totalOtherPlayers / 2) * ySpacing + 8
            endPoint = tableContainerView.convert(CGPoint(x: Int(sender.center.x) + xPosition, y: Int(sender.center.y) - yPosition), to: tableContainerView.superview)
        } else {
            let xPosition: Double = Double(((totalOtherPlayers % 2) * xSpacing) + 10)
            var yPosition: Double = (Double(totalOtherPlayers) * 0.5)  * Double(ySpacing + 10)
            if totalOtherPlayers == 1 {
                
                yPosition += (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6 ) ? 12: 8
            }
            
            let divvalue = (totalOtherPlayers % 2)
            endPoint = tableContainerView.convert(CGPoint(x: sender.center.x - xPosition, y: sender.center.y - yPosition), to: tableContainerView.superview)
        }
        return (endPoint, false)
    }
    
    func getPointstoAnimate(_ sender: UIView) {
        if (self.tableInfoData?.gameTableStatusVo?.status ?? 0) == 1 {
            let endPointT = tableContainerView.convert(sender.center, to: tableContainerView.superview)
            let endPoint = CGPoint(x: endPointT.x, y: endPointT.y + 15)
            let index: IndexPath = IndexPath(row: coinSelectedIndex, section: 0)
            if let cell = coinTable.cellForItem(at: index) as? CoinCVCell {
                let cellCenter = coinTable.convert(cell.center, to: coinTable.superview?.superview?.superview)
                let currentChip = self.coins[self.coinSelectedIndex]
                if validateTimer() && validateTableBetLimit(sender, chip: currentChip) {
                    addChip(to: sender, startPoint: cellCenter, endPoint: endPoint, isRepeat: false, coin: nil)
                }
            } else {
                let visibleCellsCount  = coinTable.visibleCells.count
                let centerCellIndex = Int(visibleCellsCount/2) - 1
                if centerCellIndex > 0 {
                    if let cell = coinTable.visibleCells[centerCellIndex] as? CoinCVCell {
                        //  let cellCenter = coinTable.convert(cell.center, to: coinTable.superview?.superview?.superview)
                        let cellCenter = gameRoomView.convert(coinTable.center, from: coinTable.superview)
                        let currentChip = self.coins[self.coinSelectedIndex]
                        if validateTimer() && validateTableBetLimit(sender, chip: currentChip) {
                            addChip(to: sender, startPoint: cellCenter, endPoint: endPoint, isRepeat: false, coin: nil)
                        }
                    } else {
                        
                        Utils.vibrateDevice()
                    }
                }
            }
        } else {
            Utils.vibrateDevice()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          //  self.otherPlayerBetShowOnFront()
        }
    }
    func addChip(to view: UIView, startPoint: CGPoint, endPoint: CGPoint, isRepeat: Bool, coin: CasinoChip?) {
        if coinSelectedIndex != 0 {
            let extraSpace1: CGFloat = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6 ) ? 0: 3
            let endPoint = CGPoint(x: endPoint.x, y: endPoint.y + extraSpace1)
            self.cancelButtonHandle(isEnable: true)
            self.confirmButtonHandle(isEnable: true)
            GameAudioVM.shared.playAudio(audioType: .sound, sound: .bet, voice: nil, addInQueue: false)
            
            var stack: ChipStack!
            var chipImage: UIImageView!
            if isRepeat {
                chipImage = UIImageView(frame: CGRect(x: startPoint.x,
                                                      y: startPoint.y, width: 60, height: 60))
                guard let coin = coin else { return }
                
                chipImage.image = coin.slandingImage
            } else {
                chipImage = UIImageView(frame: CGRect(x: startPoint.x - 40,
                                                      y: startPoint.y - 40, width: 60, height: 60))
                chipImage.image = coins[coinSelectedIndex].slandingImage
                stack = ChipStack(chip: self.coins[self.coinSelectedIndex], chipView: chipImage)
            }
           // chipImage.bringSubviewToFront(tableContainerView)
            tableContainerView.superview?.addSubview(chipImage)
            
            if !isRepeat {
                
                if view.tag == 1 {
                    // Player Pair
                    self.pPairStack.append(stack)
                    self.chipSpacing = CGFloat(self.pPairStack.count * 5)
                } else if view.tag == 2 {
                    // Tie
                    self.tiePairStack.append(stack)
                    self.chipSpacing = CGFloat(self.tiePairStack.count * 5)
                } else if view.tag == 3 {
                    // Banker Pair
                    self.bPairStack.append(stack)
                    self.chipSpacing = CGFloat(self.bPairStack.count * 5)
                } else if view.tag == 4 {
                    // Player View
                    self.playerStack.append(stack)
                    self.chipSpacing = CGFloat(self.playerStack.count * 5)
                } else if view.tag == 5 {
                    // Banker View
                    self.bankerStack.append(stack)
                    self.chipSpacing = CGFloat(self.bankerStack.count * 5)
                }
            }
            
            UIView.animate(withDuration: 0.5) {
                if isRepeat {
                    chipImage.frame.origin = CGPoint(x: endPoint.x - 10, y: endPoint.y)
                } else {
                    chipImage.frame.origin = CGPoint(x: endPoint.x - 10, y: (endPoint.y + CGFloat(self.yPositionCoinExtra)) - self.chipSpacing)
                }
                chipImage.frame.size = CGSize(width: 20, height: 20)
            } completion: { _ in
                DispatchQueue.main.async {
                    if !isRepeat {
                        self.checkChips(in: view, endPoint: endPoint)
                    } else {
                        chipImage.removeFromSuperview()
                    }
                    self.otherPlayerBetShowOnFront()
                }
            }
        }
    }
    func checkChips(in view: UIView, endPoint: CGPoint) {
        let extraSpace: CGFloat = (Display.typeIsLike == .iphone5 || Display.typeIsLike == .iphone6 ) ? 7: 0
        let endPoint = CGPoint(x: endPoint.x, y: endPoint.y - extraSpace)
        let playerNumber = self.groupData?.seatNo ?? "0"
        if view.tag == 1 {
            // Player Pair
            if pPairStack.count > 1 {
                // Updating Stack after modification
                pPairStack = modifyStack(isRepeat: false, stacks: &pPairStack, endPoint: endPoint)
                let totalAmount = pPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                pPairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(totalAmount)"))
            } else {
                if let first = pPairStack.first {
                    pPairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(first.chip.value!)"))
                }
            }
            DispatchQueue.main.async {
                self.pPairValueVU.isHidden = false
            }
        } else if view.tag == 2 {
            // Tie
            if tiePairStack.count > 1 {
                tiePairStack = modifyStack(isRepeat: false, stacks: &tiePairStack, endPoint: endPoint)
                let totalAmount = tiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                tiePairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(totalAmount)"))
            } else {
                if let first = tiePairStack.first {
                    tiePairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(first.chip.value!)"))
                }
            }
            DispatchQueue.main.async {
                self.tiePairValueVU.isHidden = false
            }
        } else if view.tag == 3 {
            // Banker Pair
            if bPairStack.count > 1 {
                bPairStack = modifyStack(isRepeat: false, stacks: &bPairStack, endPoint: endPoint)
                let totalAmount = bPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
                bPairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(totalAmount)"))
            } else {
                if let first = bPairStack.first {
                    bPairValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(first.chip.value!)"))
                }
            }
            DispatchQueue.main.async {
                self.bPairValueVU.isHidden = false
            }
        } else if view.tag == 4 {
            // Player View
            if playerStack.count > 1 {
                playerStack = modifyStack(isRepeat: false, stacks: &playerStack, endPoint: endPoint)
                let totalAmount = playerStack.map({$0.chip.value ?? 0}).reduce(0, +)
                playerValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(totalAmount)"))
            } else {
                if let first = playerStack.first {
                    playerValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(first.chip.value!)"))
                }
            }
            DispatchQueue.main.async {
                self.playerValueVU.isHidden = false
            }
        } else if view.tag == 5 {
            // Banker View
            if bankerStack.count > 1 {
                bankerStack = modifyStack(isRepeat: false, stacks: &bankerStack, endPoint: endPoint)
                let totalAmount = bankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
                bankerValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(totalAmount)"))
            } else {
                if let first = bankerStack.first {
                    bankerValueVU.updateView(player: playerNumber, amount: (userInfo?.symbol ?? "$").appending("\(first.chip.value!)"))
                }
            }
            DispatchQueue.main.async {
                self.bankerValueVU.isHidden = false
            }
        }
        pPairValueVU.bringSubviewToFront(tableContainerView.superview!)
        tiePairValueVU.bringSubviewToFront(tableContainerView.superview!)
        bPairValueVU.bringSubviewToFront(tableContainerView.superview!)
        playerValueVU.bringSubviewToFront(tableContainerView.superview!)
        bankerValueVU.bringSubviewToFront(tableContainerView.superview!)
    }
    func modifyStack(isRepeat: Bool, stacks: inout [ChipStack], endPoint: CGPoint) -> [ChipStack] {
        stacks.forEach { $0.chipView.removeFromSuperview() }
        // Modify Chips based on chip range
        Utils.modifiedStack.removeAll()
        let totalSum = stacks.map({$0.chip.value ?? 0}).reduce(0, +)
        return checkChipExist(isRepeat: isRepeat, endPoint: endPoint, sum: totalSum)
    }
    func checkChipExist(isRepeat: Bool, endPoint: CGPoint, sum: Int) -> [ChipStack] {
        let chipArray = Utils.checkChipExistRange(chipValue: sum)
        var modifiedStack = [ChipStack]()
        // Redraw updated Chips
        var spacing: CGFloat = 5.0
        for chip in chipArray {
            let imageView = UIImageView(frame: CGRect(x: endPoint.x - 10,
                                                      y: (endPoint.y + 10) - spacing, width: 20, height: 20))
            imageView.image = chip.slandingImage
            let chipStack = ChipStack(chip: chip, chipView: imageView)
            modifiedStack.append(chipStack)
            spacing += 5.0
        }
        modifiedStack.forEach { tableContainerView.superview?.addSubview($0.chipView)}
        return modifiedStack
    }
    func playerRoundResultSetup(data: LobbySocketData) {
        self.playerWinView.isHidden = true
        self.bankerWinView.isHidden = true
        // Banker Points Sound
        GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .banker, addInQueue: true)
        GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: Utils.getVoiceByPoints(points: bankersPoints), addInQueue: true)
        // player Points Sound
        GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .player, addInQueue: true)
        GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: Utils.getVoiceByPoints(points: playerPoints), addInQueue: true)
        switch data.data?.result ?? "" {
        case "1":   // player win
            playerView.startBlinking(blinkCount: 16)
            showMarqueAnimation(selected: .player)
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .playerWin, addInQueue: true)
        case "15": // player win with Player Pair
            playerView.startBlinking(blinkCount: 16)
            pPairView.startBlinking(blinkCount: 16)
            showMarqueAnimation(selected: .player)
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .playerPair, addInQueue: true)
        case "18": // player win with Banker Pair
            playerView.startBlinking(blinkCount: 16)
            bPairView.startBlinking(blinkCount: 16)
            showMarqueAnimation(selected: .player)
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .bankerPair, addInQueue: true)
        case "12":   // player win with Player Pair & Banker Pair
            playerView.startBlinking(blinkCount: 16)
            pPairView.startBlinking(blinkCount: 16)
            bPairView.startBlinking(blinkCount: 16)
            showMarqueAnimation(selected: .player)
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .playerSqueezing, addInQueue: true)
        case "4": // banker win
            bankerView.startBlinking(blinkCount: 16)
            showMarqueAnimation(selected: .banker)
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .bankerWin, addInQueue: true)
        case "45":  // banker win with Player Pair
            bankerView.startBlinking(blinkCount: 16)
            pPairView.startBlinking(blinkCount: 16)
            showMarqueAnimation(selected: .banker)
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .playerPair, addInQueue: true)
        case "48":   // banker win with Banker Pair
            bankerView.startBlinking(blinkCount: 16)
            bPairView.startBlinking(blinkCount: 16)
            showMarqueAnimation(selected: .banker)
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .bankerPair, addInQueue: true)
        case "42": // banker win with Player Pair & Banker Pair
            bankerView.startBlinking(blinkCount: 16)
            pPairView.startBlinking(blinkCount: 16)
            bPairView.startBlinking(blinkCount: 16)
            showMarqueAnimation(selected: .banker)
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .bankerSqueezing, addInQueue: true)
        case "7":
            // Tie
            tieView.startBlinking(blinkCount: 16)
            showTieIndicator()
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .tie, addInQueue: true)
        case "75":
            // Match Tie with Player Pair
            tieView.startBlinking(blinkCount: 16)
            pPairView.startBlinking(blinkCount: 16)
            showTieIndicator()
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .tie, addInQueue: true)
        case "78":
            // Match Tie with Banker Pair
            tieView.startBlinking(blinkCount: 16)
            bPairView.startBlinking(blinkCount: 16)
            showTieIndicator()
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .tie, addInQueue: true)
        case "72":
            // Match Tie with Player Pair & Banker Pair
            tieView.startBlinking(blinkCount: 16)
            pPairView.startBlinking(blinkCount: 16)
            bPairView.startBlinking(blinkCount: 16)
            showTieIndicator()
            GameAudioVM.shared.playAudio(audioType: .voice, sound: nil, voice: .tie, addInQueue: true)
        default:
            break
        }
    }
    func sortChipStacksDescending(_ stacks: inout [ChipStack]) -> [ChipStack] {
        for index in 0..<stacks.count {
            for indexJ in 0..<(stacks.count - 1 - index)
            where (stacks[indexJ].chip.value) < (stacks[indexJ + 1].chip.value) {
                //  if (stacks[indexJ].chip.value) < (stacks[indexJ + 1].chip.value) {
                let temp = stacks[indexJ]
                stacks[indexJ] = (stacks[indexJ + 1])
                stacks[indexJ + 1] = temp
                let tempFrame = stacks[indexJ].chipView.frame
                stacks[indexJ].chipView.frame = stacks[indexJ+1].chipView.frame
                stacks[indexJ + 1].chipView.frame = tempFrame
                stacks[indexJ + 1].chipView.sendSubviewToBack(tableContainerView)
                //  }
            }
        }
        return stacks
    }
    func addMoreChipSetting() {
        // Show add more coins VC
        self.selectedCoins = coins[self.coinSelectedIndex]
        let popupVC = storyboard?.instantiateViewController(withIdentifier: "AddCoinsVC") as? AddCoinsVC
        popupVC?.modalPresentationStyle = .overCurrentContext
        popupVC?.modalTransitionStyle = .crossDissolve
        popupVC?.updateChipDelegate = self
        let presentationVC = popupVC?.popoverPresentationController
        presentationVC?.permittedArrowDirections = .any
        present(popupVC!, animated: true)
    }
    func removePreviousBetData() {
        // Removing prevGameRoomStack.shared.pPairStackious coins from Superview
        GameRoomStack.shared.pPairStack.forEach({ $0.chipView.removeFromSuperview() })
        GameRoomStack.shared.tiePairStack.forEach({ $0.chipView.removeFromSuperview() })
        GameRoomStack.shared.bPairStack.forEach({ $0.chipView.removeFromSuperview() })
        GameRoomStack.shared.playerStack.forEach({ $0.chipView.removeFromSuperview() })
        GameRoomStack.shared.bankerStack.forEach({ $0.chipView.removeFromSuperview() })
        // Clear previous stack
        GameRoomStack.shared.pPairStack.removeAll()
        GameRoomStack.shared.tiePairStack.removeAll()
        GameRoomStack.shared.bPairStack.removeAll()
        GameRoomStack.shared.playerStack.removeAll()
        GameRoomStack.shared.bankerStack.removeAll()
        GameRoomStack.shared.previousRoundNumber = 0
    }
    func clearUnconfirmBet() {
        // Removing coins from SuperView
        pPairStack.forEach({ $0.chipView.removeFromSuperview() })
        tiePairStack.forEach({ $0.chipView.removeFromSuperview() })
        bPairStack.forEach({ $0.chipView.removeFromSuperview() })
        playerStack.forEach({ $0.chipView.removeFromSuperview() })
        bankerStack.forEach({ $0.chipView.removeFromSuperview() })
        // Clear all Stack
        pPairStack.removeAll()
        tiePairStack.removeAll()
        bPairStack.removeAll()
        playerStack.removeAll()
        bankerStack.removeAll()
        
        let playerNumber = self.groupData?.seatNo ?? "0"
        if GameRoomStack.shared.pPairStack.count > 0 {
            GameRoomStack.shared.pPairStack.forEach { tableContainerView.superview?.addSubview($0.chipView)}
            let totalAmount = GameRoomStack.shared.pPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            DispatchQueue.main.async {
                self.pPairValueVU.isHidden = false
                self.pPairValueVU.updateView(player: playerNumber, amount: (self.userInfo?.symbol ?? "$").appending("\(totalAmount)"))
            }
        } else {
            pPairValueVU.isHidden = true
        }
        if GameRoomStack.shared.tiePairStack.count > 0 {
            GameRoomStack.shared.tiePairStack.forEach { tableContainerView.superview?.addSubview($0.chipView)}
            let totalAmount = GameRoomStack.shared.tiePairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            DispatchQueue.main.async {
                self.tiePairValueVU.isHidden = false
                self.tiePairValueVU.updateView(player: playerNumber, amount: (self.userInfo?.symbol ?? "$").appending("\(totalAmount)"))
            }
        } else {
            tiePairValueVU.isHidden = true
        }
        if GameRoomStack.shared.bPairStack.count > 0 {
            GameRoomStack.shared.bPairStack.forEach { tableContainerView.superview?.addSubview($0.chipView)}
            let totalAmount = GameRoomStack.shared.bPairStack.map({$0.chip.value ?? 0}).reduce(0, +)
            DispatchQueue.main.async {
                self.bPairValueVU.isHidden = false
                self.bPairValueVU.updateView(player: playerNumber, amount: (self.userInfo?.symbol ?? "$").appending("\(totalAmount)"))
            }
        } else {
            bPairValueVU.isHidden = true
        }
        if GameRoomStack.shared.playerStack.count > 0 {
            GameRoomStack.shared.playerStack.forEach { tableContainerView.superview?.addSubview($0.chipView)}
            let totalAmount = GameRoomStack.shared.playerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            DispatchQueue.main.async {
                self.playerValueVU.isHidden = false
                self.playerValueVU.updateView(player: playerNumber, amount: (self.userInfo?.symbol ?? "$").appending("\(totalAmount)"))
            }
        } else {
            playerValueVU.isHidden = true
        }
        if GameRoomStack.shared.bankerStack.count > 0 {
            GameRoomStack.shared.bankerStack.forEach { tableContainerView.superview?.addSubview($0.chipView)}
            let totalAmount = GameRoomStack.shared.bankerStack.map({$0.chip.value ?? 0}).reduce(0, +)
            DispatchQueue.main.async {
                self.bankerValueVU.isHidden = false
                self.bankerValueVU.updateView(player: playerNumber, amount: (self.userInfo?.symbol ?? "$").appending("\(totalAmount)"))
            }
        } else {
            bankerValueVU.isHidden = true
        }
        self.cancelButtonHandle(isEnable: false)
        self.confirmButtonHandle(isEnable: false)
        self.otherPlayerBetShowOnFront()
        
    }
    func otherPlayerBetShowOnFront() {
        for item in GameRoomStack.shared.chipTuple {
            tableContainerView.superview?.bringSubviewToFront(item.3)
            print("item.3 bringSubviewToFront")
        }
    }
    func clearBettingAreaView() {
        pPairView.removeBlink()
        bPairView.removeBlink()
        playerView.removeBlink()
        bankerView.removeBlink()
        tieView.removeBlink()
        pPairView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.12)
        bPairView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.12)
        playerView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.12)
        bankerView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.12)
        tieView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.12)
    }
    func clearStack(removeConfirmBet: Bool) {
        // Removing coins from SuperView
        totalOtherPlayers = 0
        otherTotalPlayerView = 0
        otherTotalPpairView = 0
        otherTotalBankerView = 0
        otherTotalBpairView = 0
        otherTotalTieView = 0
        pPairStack.forEach({ $0.chipView.removeFromSuperview() })
        tiePairStack.forEach({ $0.chipView.removeFromSuperview() })
        bPairStack.forEach({ $0.chipView.removeFromSuperview() })
        playerStack.forEach({ $0.chipView.removeFromSuperview() })
        bankerStack.forEach({ $0.chipView.removeFromSuperview() })
        // Clear all Stack
        pPairStack.removeAll()
        tiePairStack.removeAll()
        bPairStack.removeAll()
        playerStack.removeAll()
        bankerStack.removeAll()
        // Removing Chip Value View
        DispatchQueue.main.async {
            self.pPairValueVU.isHidden = true
            self.tiePairValueVU.isHidden = true
            self.bPairValueVU.isHidden = true
            self.playerValueVU.isHidden = true
            self.bankerValueVU.isHidden = true
        }
        
        // Remove ConfirmBet Chips
        if removeConfirmBet {
            confirmbPairStack.forEach({ $0.chipView.removeFromSuperview() })
            confirmtiePairStack.forEach({ $0.chipView.removeFromSuperview() })
            confirmpPairStack.forEach({ $0.chipView.removeFromSuperview() })
            confirmplayerStack.forEach({ $0.chipView.removeFromSuperview() })
            confirmbankerStack.forEach({ $0.chipView.removeFromSuperview() })
            
            if GameRoomStack.shared.previousRoundNumber != tableInfoData?.gameTableInfoStatisticsVo?.roundNum {
                removeOtherPlayersVU()
            }
        }
        
        if confirmpPairStack.count > 0 || confirmtiePairStack.count > 0 || confirmbPairStack.count > 0 || confirmplayerStack.count > 0 || confirmbankerStack.count > 0 {
            Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
            isRepeatActive = true
        } else {
            Utils.setButtonAttributedTitleGameRoom(btn: self.repeatButton, text: "Repeat".localizable)
            isRepeatActive = false
        }
        self.cancelButtonHandle(isEnable: false)
        self.confirmButtonHandle(isEnable: false)
        self.repeatButtonHandle(isEnable: isRepeatActive)
    }
    func showOtherPlayerVU() {
        if GameRoomStack.shared.chipTuple.count > 0 {
            GameRoomStack.shared.chipTuple.forEach { (seatNo, betCode, chipStacks, chipValueVU) in
                chipStacks.forEach {
                    self.tableContainerView.superview?.addSubview($0.chipView)
                }
                self.tableContainerView.superview?.addSubview(chipValueVU)
                NSLayoutConstraint.activate([
                    chipValueVU.centerXAnchor.constraint(equalTo: chipStacks.first!.chipView.centerXAnchor),
                    chipValueVU.topAnchor.constraint(equalTo: chipStacks.first!.chipView.centerYAnchor, constant: 8),
                    chipValueVU.heightAnchor.constraint(equalToConstant: 20)
                ])
            }
        }
    }
    func removeOtherPlayersVU() {
        if GameRoomStack.shared.chipTuple.count > 0 {
            GameRoomStack.shared.chipTuple.forEach { (seatNo, betCode, chipStack, chipValueVU) in
                chipStack.forEach({ $0.chipView.removeFromSuperview() })
                chipValueVU.removeFromSuperview()
            }
            GameRoomStack.shared.chipTuple.removeAll()
        }
    }
}
// Extending Sound Delegate Methods
extension GameRoomVC: SoundDelegate {
    func updatedSound() {
        DispatchQueue.main.async {
            self.setupSoundIcon()
        }
    }
}
