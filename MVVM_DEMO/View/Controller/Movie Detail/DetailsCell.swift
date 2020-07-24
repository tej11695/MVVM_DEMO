//
//  DetailsCell.swift
//  MVVM_DEMO
//
//  Created by esparkbiz on 2/17/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {
    
    @IBOutlet var lblValue: UILabel!
    @IBOutlet var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
