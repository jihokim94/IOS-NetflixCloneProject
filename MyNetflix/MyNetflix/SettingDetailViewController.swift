//
//  SettingTableViewController.swift
//  MyNetflix
//
//  Created by 김지호 on 2021/08/19.
//  Copyright © 2021 com.joonwon. All rights reserved.
//

import UIKit

class SettingDetailViewController: UIViewController {

    var appSettingSection : [APPSettingSection]? 
    var infoSettingSection : [InfoSettingSection]?
    
    var objectList : [Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(appSettingSection)
        print(infoSettingSection)

    }
}

    // MARK: - Table view data source
    
extension SettingDetailViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let appSettingSection = appSettingSection else { return infoSettingSection?.count ?? 0 }
        return appSettingSection.count
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let appSettingSection = appSettingSection
        else   { return infoSettingSection![section].list.count }
        return appSettingSection[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        if let appSettingSection = appSettingSection {
            let target = appSettingSection[indexPath.section].list[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: target.cellType.rawValue, for: indexPath)
            
            switch target.cellType {
            case .disclosure:
                cell.textLabel?.text = target.title
                cell.imageView?.image = UIImage(systemName: target.imageName ?? "")
            case .switch :
                cell.textLabel?.text = target.title
                if let switchView = cell.accessoryView as? UISwitch {
                    switchView.isOn = target.on
                }
            case .action :
                cell.textLabel?.text = target.title
            case .checkmark :
                cell.textLabel?.text = target.title
                cell.accessoryType = target.on ? .checkmark : .none
            }
            return cell
            
        } else {
            let target = infoSettingSection![indexPath.section].list[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: target.cellType.rawValue, for: indexPath)
            
            switch target.cellType {
            case .disclosure:
                cell.textLabel?.text = target.title
                cell.imageView?.image = UIImage(systemName: target.imageName ?? "")
            case .switch :
                cell.textLabel?.text = target.title
                if let switchView = cell.accessoryView as? UISwitch {
                    switchView.isOn = target.on
                }
            case .action :
                cell.textLabel?.text = target.title
            case .checkmark :
                cell.textLabel?.text = target.title
                cell.accessoryType = target.on ? .checkmark : .none
            }
            return cell
        }
        
    
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let appSettingSection = appSettingSection
        else { return infoSettingSection?[section].header }
        return appSettingSection[section].header
    }
    
        
//    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }

    }


class AppSettingCell : UITableViewCell {
    
}
        







