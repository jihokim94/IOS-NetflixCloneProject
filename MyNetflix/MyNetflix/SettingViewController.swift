//
//  SettingViewController.swift
//  MyNetflix
//
//  Created by 김지호 on 2021/08/19.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    let settingList: [SettingSection] = SettingSection.generateListOfSetting()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "더보기"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? SettingDetailViewController else {
            return }
        if segue.identifier == "appSetting" {
            destinationVC.appSettingSection = APPSettingSection.generateListOfSetting()
        } else {
            destinationVC.infoSettingSection = InfoSettingSection.generateListOfSetting()
        }

    }
}


extension SettingViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingList.count //섹션 개수
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList[section].list.count // 섹션당 로우 개수
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let target : SettingItem = settingList[indexPath.section].list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: target.type.rawValue, for: indexPath) as! SettingTableViewCell
        
        switch target.type {
        case .imageCell:
            cell.settingImage.image = UIImage(named: target.imageName!)
        default:
            cell.title.text = target.title
            cell.settingImageForSecond.image = UIImage(systemName: target.imageName!)
        }
        return cell
    }
}

extension SettingViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch (indexPath.section, indexPath.row) {
        case (1,0):
            break
            self.performSegue(withIdentifier: "appSetting", sender: nil)
        default:
            self.performSegue(withIdentifier: "infoSetting", sender: nil)
        }
        
        
        let target = settingList[indexPath.section].list[indexPath.row]
        

        
        
        
        
        
        
        
    }
}


class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var settingImageForSecond: UIImageView!
    
    @IBOutlet weak var settingImage: UIImageView!
}

enum CellType: String {
    case imageCell
    case settingCell
    case disclosure
    case action
    case checkmark
    case `switch`
}
enum AppCellType : String {
    case disclosure
    case action
    case checkmark
    case `switch`
}

struct SettingItem {
    let type: CellType
    let title: String?
    var imageName: String?
}

struct AppSettingItem {
    let title: String
    var imageName: String
    var cellType : AppCellType
    var on : Bool
}
struct InfoSettinItem{
    let title: String
    var imageName: String
    var cellType : AppCellType
    var on : Bool
}


// 고객센터섹션
struct InfoSettingSection{
    let list : [InfoSettinItem]
    let header  : String

    static func generateListOfSetting() -> [InfoSettingSection]{
        let firstSection  =  InfoSettingSection(list: [InfoSettinItem(title: "더미~1", imageName: "gearshape.fill", cellType: .action, on: false),InfoSettinItem(title: "더미~2", imageName: "gearshape.fill", cellType: .checkmark, on: false)], header: "header1")
        
        let SecondSection  =  InfoSettingSection(list: [InfoSettinItem(title: "더미~3", imageName: "gearshape.fill", cellType: .action, on: false)], header: "")
        
        return [firstSection , SecondSection ]
    }
}

// 더보기 섹션
struct SettingSection{
    let list : [SettingItem]
    
    
    static func generateListOfSetting() -> [SettingSection]{
        let firstSection = SettingSection(list: [SettingItem(type: .imageCell, title: nil, imageName: "img_netflix")])
        let secondSection = SettingSection(list: [SettingItem(type: .settingCell, title: "앱설정", imageName: "gearshape.fill"), SettingItem(type: .settingCell, title: "고객센터", imageName: "exclamationmark.triangle")])
        
        return [firstSection , secondSection]
        
    }
}

// 앱세팅 섹션
struct APPSettingSection{
    let list : [AppSettingItem]
    let header : String
    
    static func generateListOfSetting() -> [APPSettingSection]{
        let firstSection = APPSettingSection(list: [AppSettingItem(title: "모바일 데이터 이용 설정", imageName: "antenna.radiowaves.left.and.right", cellType: .disclosure, on: false)], header: "콘텐츠 재생 설정")
        
        let SecondSection =
            APPSettingSection(list:
                                [AppSettingItem(title: "Wi-Fi에서만 저장", imageName: "wifi", cellType: .switch, on: true),
                                 AppSettingItem(title: "스마트 저장", imageName: "square.and.arrow.down", cellType: .switch, on: true), AppSettingItem(title: "동영상 화질", imageName: "square.stack.3d.down.right", cellType: .disclosure, on: false),
                                AppSettingItem(title: "저장한 콘텐츠 모두 삭제", imageName: "trash", cellType: .action, on: false)],
                              header: "콘텐츠 저장 설정")
        
        let ThirdSection = APPSettingSection(list: [AppSettingItem(title: "인터넷 속도 측정", imageName: "checkmark.circle.fill", cellType: .disclosure, on: false)], header: "앱 정보")
        
        return  [ firstSection ,  SecondSection , ThirdSection ]
        
    }
}
