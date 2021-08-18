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
    
    //    var term : String = ""
    
    var searchHistories : SearchHistory?
    
    
    let db = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        db.child("searchHistory").observeSingleEvent(of: .value) { (snapshot) in
            
            // 데이터 있는지 확인
            guard let searchHistory = snapshot.value as? [String : Any] else {
                print("저장되있는 데이터 없음")
                return }
            print("Snapshot Values ---> \(searchHistory)")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetail" {
            if let vc = segue.destination as? DetailViewController {
                
                if let indexPath = tableView.indexPathForSelectedRow {
                    let term = searchTerms?[indexPath.row].term
                    vc.searchName = term!
                }
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
extension HistoryViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let searchTerms = self.searchTerms else { return }
        if editingStyle == .delete {
            let target = searchTerms[indexPath.row]

//            let targetId =
            //디비에서 삭제
            let searchId = target.searchId
            db.child("searchHistory").child(searchId).removeValue()
            
            
            self.searchTerms?.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = self.searchTerms?[indexPath.row]
        guard let selectedTerm = selectedData?.term else { return }
        print("--->\(indexPath.row)")
        print("--->\(indexPath.row)")
        print(selectedTerm)
        print(selectedTerm)
        
        //        performSegue(withIdentifier: "movieDetail", sender: self)
        
        
    }
}

struct SearchHistory {
    let histories : [History]
}

struct SearchTerm : Codable{
    let searchId : String
    let term: String
    let timestamp : TimeInterval
}

struct History {
    let id : String
    let searchTerms : SearchTerm
}
