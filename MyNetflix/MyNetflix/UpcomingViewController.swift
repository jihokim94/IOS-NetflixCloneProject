//
//  UpcomingViewController.swift
//  MyNetflix
//
//  Created by 김지호 on 2021/08/08.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    var awardRecommendListViewController: RecommendListViewController!
    var hotRecommendListViewController: RecommendListViewController!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { 
        if segue.identifier == "award" {
            let destinationVC = segue.destination as? RecommendListViewController
            awardRecommendListViewController = destinationVC
            awardRecommendListViewController.viewModel.updateType(.award)
            awardRecommendListViewController.viewModel.fetchItems()
        } else if segue.identifier == "hot" {
            let destinationVC = segue.destination as? RecommendListViewController
            hotRecommendListViewController = destinationVC
            hotRecommendListViewController.viewModel.updateType(.hot)
            hotRecommendListViewController.viewModel.fetchItems()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
}
