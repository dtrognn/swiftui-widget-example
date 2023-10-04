//
//  ContentView.swift
//  widget-example
//
//  Created by dtrognn on 03/10/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var manager = DataManager.shared

    var body: some View {
        VStack {
            countText

            increaseButton
        }
    }
}

extension ContentView {
    var countText: some View {
        Text("\(manager.count)").font(.system(size: 16, weight: .bold))
    }

    var increaseButton: some View {
        Button {
            manager.count += 1
            manager.saveDataWithUserDefaults()
        } label: {
            Text("Increase").font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.orange)
                .cornerRadius(8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
