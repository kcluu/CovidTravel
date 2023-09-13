//
//  StateStruct.swift
//  Covid19
//
//  Created by Yongjae Lim on 4/15/21.
//  Copyright © 2021 Yongjae Lim. All rights reserved.
//

import SwiftUI

struct StateStruct: Hashable, Codable, Identifiable {
    var id: UUID
    var name: String
    var restrictions: String
    var photoName: String
}

/*
 {
 "name": "Alabama",
 "restrictions": "As of April 12, 2021, Alabama had not issued any travel restrictions."
 }
 */
