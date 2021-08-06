

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var controllView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    
    let player = AVPlayer() // 플레이어 인스턴스 생성
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    } // 가로뷰 인터페이스 조정하기~~
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.player = player // 재생을 보여줄 ui에 플레이어 초기화
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        play()
    }
    
    @IBAction func togglePlayButton(_ sender: Any) {
        if player.isPlaying {
            pause()
        } else {
            play()
        }
//        // 누를때 마다 스위칭
//        playButton.isSelected = !playButton.isSelected
    }
    
    func play(){
        player.play()
        playButton.isSelected = true
    }
    func pause(){
        player.pause()
        playButton.isSelected = false
    }
    
    func reset() { // 리셋 설정
        pause()
        player.replaceCurrentItem(with: nil) // 현재 올려져있는 커렌트 아이템을 nil로 교체 해준다
    }
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        // player 초기화 하기 클로즈 버튼 클릭시
        reset()
        dismiss(animated: false, completion: nil)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false } // 현재 player에 올려져있는 아이템 확인 없으면 false리턴
        // 아이템이 올려져있다면 현재 재생중인지 확인 0이 아닐시 중지 상태가 아니므로 true리턴 0.0~ 1.0
        //값이 1.0이면 현재 항목이 자연스러운 속도로 재생
        return self.rate != 0
        
    }
    
}
