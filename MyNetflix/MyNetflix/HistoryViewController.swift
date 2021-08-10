//
//  HistoryViewController.swift
//  MyNetflix
//
//  Created by 김지호 on 2021/08/09.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchTerms : [SearchTerm]? = []
    
    
    let db = Database.database().reference().child("searchHistory")
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        db.observeSingleEvent(of: .value) { (snapshot) in
            
            // 데이터 있는지 확인
            guard let searchHistory = snapshot.value as? [String : Any] else {
                print("저장되있는 데이터 없음")
                return }
            print("Snapshot Values ---> \(searchHistory.values)")
            do {
                let data = try JSONSerialization.data(withJSONObject: Array(searchHistory.values), options: [])
                print(data)
          
                let decorder = JSONDecoder()
                let searchHistories = try decorder.decode([SearchTerm].self, from: data)
                print(searchHistories)
                
                let sortedHistory = searchHistories.sorted { term1, term2 in
                    return term1.timestamp > term2.timestamp
                }
                // 소팅된히스토리 배열 형태로 넣기
                self.searchTerms? = sortedHistory
                self.tableView.reloadData()
                
            } catch let error {
                print(error)
                print(error.localizedDescription)
            }
           

        }
    }
    
}


class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var searchTerm: UILabel!
}

extension HistoryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTerms?.count ?? 0
    }
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "검색 히스토리"
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryCell else { return UITableViewCell() }

        cell.searchTerm.text = searchTerms?[indexPath.row].term
        
        return cell
    }
    
    
}



struct SearchTerm : Codable{
    let term: String
    let timestamp : TimeInterval
}
