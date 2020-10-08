//
//  WikiSearch.swift
//  Landmark ID
//
//  Created by Pete Chambers on 30/10/2018.
//  Copyright © 2018 Pete Chambers. All rights reserved.
//

import Foundation
import WikipediaKit
import UIKit

class WikiSearch: SharedImagePickerController {
    
    let wikipedia = Wikipedia()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
    
extension ImageSourceViewController {
    
    func landmarkSearch() {
        
        let language = WikipediaLanguage("en")
        
        let title = landmarkResults.text
        
        let _ = Wikipedia.shared.requestArticleSummary(language: language, title: title!) { (article, error) in
            if error == nil, let article = article {
                self.wikiResults.text = article.displayText
            } else {
                self.wikiResults.text = "No description available"
            }
            self.saveToHistory()
        }
    }
}


