//
//  MainView.swift
//  Meedly
//
//  Created by Illia Poliakov on 20.11.22.
//

import UIKit
import SnapKit

class MainViewControllerTmp: UIView {
  
  lazy var tableView: UITableView = UITableView(frame: .zero)
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  let labe
  
  func setupView() {
    view.addSubview(firstView)
    
    firstView.snp.makeConstraints { make in
      make.width.height.equalToSuperview()
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
    }
    
    UIView.animate(withDuration: 1, delay: 0) {
      self.firstView.snp.updateConstraints { make in
        make.top.equalToSuperview().offset(300)
      }
      
      self.view.layoutIfNeeded()
    }
  }
}
