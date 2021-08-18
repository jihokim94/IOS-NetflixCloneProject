//
//  DetailViewController.swift
//  MyNetflix
//
//  Created by 김지호 on 2021/08/10.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation
import Firebase


class DetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    
    var searchName : String = ""
    var movie : Movie?
    
    @IBAction func play(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Player", bundle: nil)
        guard let vc = sb.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return }
        
        // 무비 인스턴스
        let url = URL(string: movie!.previewURL)
        let item = AVPlayerItem(url: url!)
        vc.player.replaceCurrentItem(with: item) // player 객체에 재생할 avplayeritem 넣기
        //player fullscreen으로 보여주기
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SearchAPI.search(searchName) { movies in
            guard movies.count >= 1 else { return }
            
            let firstMoive = movies.first
            self.movie = firstMoive
            
            DispatchQueue.main.async {
                guard let movie = self.movie else { return }
                
                    guard let imagePathURL = URL(string: movie.thumnailPath) else { return }
                    self.image.kf.setImage(with: imagePathURL)
                    self.movieTitle.text = movie.title
                    self.movieDescription.text = movie.description
                
                    }
            }
        }
        
      
    override func viewDidLoad() {
        super.viewDidLoad()
        print("전달된 데이터 \(searchName)")
       
    }
    
    
}
