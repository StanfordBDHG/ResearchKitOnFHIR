//
// This source file is part of the ResearchKitOnFHIR open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import SwiftUI


struct JSONView: View {
    let json: String?
    
    
    var body: some View {
        if let json {
            ScrollView {
                Text(json)
                    .font(.footnote)
                    .monospaced()
                    .multilineTextAlignment(.leading)
                    .padding()
            }
        } else {
            VStack(spacing: 16) {
                Image(systemName: "x.circle")
                    .font(.system(size: 80))
                    .foregroundColor(.red)
                Text("JSON_ERROR_MESSAGE")
            }
        }
    }
}


struct JSONView_Previews: PreviewProvider {
    static var previews: some View {
        JSONView(json: #"{ "name": "Paul" }"#)
        JSONView(json: nil)
    }
}
