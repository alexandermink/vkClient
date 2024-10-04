//
//  AuthView.swift
//  VKClient
//
//  Created by Александр Минк on 30.09.2024.
//

import SwiftUI

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()

    var body: some View {
        if viewModel.showNoInternetPlaceholder {
            VStack {
                Text("No internet connection")
                    .font(.headline)
                    .padding()
                
                Button(action: {
                    viewModel.checkInternetConnection()
                }) {
                    Text("Retry")
                }
                .padding()
            }
        } else {
            NavigationView {
                VStack {
                    if viewModel.isLoggedIn {
                        FeedView()
                    } else {
                        WebView(viewModel: viewModel)
                            .onOpenURL { url in
                                viewModel.handleCallback(url: url)
                            }
                    }
                }
            }
        }
    }
}

#Preview {
    AuthView()
}
