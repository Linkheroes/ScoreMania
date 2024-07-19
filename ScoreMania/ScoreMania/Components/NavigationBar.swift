//
//  NavigationBar.swift
//  ScoreMania
//
//  Created by Alexandre Ricard on 06/07/2024.
//

import SwiftUI
import GameKit

enum Tab: String, CaseIterable {
    case timer
    case gamecontroller
    case person
}

struct NavigationBar: View {
    @Binding var selectedTab: Tab
    @State private var localPlayer: GKLocalPlayer = GKLocalPlayer.local
    @State private var playerAvatar: UIImage? = nil
    
    var body: some View {
        VStack() {
            HStack() {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    if tab == .person {
                        if let avatar = playerAvatar {
                            Image(uiImage: avatar)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                                .font(.system(size: 22))
                                .frame(width: 32, height: 32)
                                .shadow(radius: 5)
                                .onTapGesture {
                                    withAnimation(.easeIn(duration: 0.1)) {
                                        selectedTab = tab
                                    }
                                }
                        } else {
                            Image(systemName: tab.rawValue)
                                .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                                .foregroundColor(selectedTab == tab ? .blue : Color(uiColor: .label))
                                .font(.system(size: 22))
                                .onTapGesture {
                                    withAnimation(.easeIn(duration: 0.1)) {
                                        selectedTab = tab
                                    }
                                }
                        }
                    } else {
                        Image(systemName: tab.rawValue)
                            .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                            .foregroundColor(selectedTab == tab ? .blue : Color(uiColor: .label))
                            .font(.system(size: 22))
                            .onTapGesture {
                                withAnimation(.easeIn(duration: 0.1)) {
                                    selectedTab = tab
                                }
                            }
                    }
                    Spacer()
                }
            }
            .frame(width: nil, height: 60)
            .background(.thinMaterial)
            .cornerRadius(10)
            .padding()
        }
        .onAppear(perform: {
            authenticateUser()
        })
    }
    
    func authenticateUser() {
            localPlayer.authenticateHandler = { viewController, error in
                if let vc = viewController {
                    return
                } else if localPlayer.isAuthenticated {
                    loadAvatar()
                } else {
                    print(error?.localizedDescription)
                }
            }
        }
        
    func loadAvatar() {
        localPlayer.loadPhoto(for: .normal) { image, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let image = image {
                // Set the avatar image
                playerAvatar = image
            } else {
                print("No image")
            }
        }
    }
}

#Preview {
    NavigationBar(selectedTab: .constant(.gamecontroller))
}

/*
 
 enum Tab: String, CaseIterable {
     case bell
     case house
     case magnifyingglass
     case person
 }

 struct NavigationBar: View {
     
     @Binding var selectedTab: Tab
     @Binding var pp: String
     @Binding var ppAlt: String
     private var fillImage: String {
         if selectedTab != .magnifyingglass {
             return selectedTab.rawValue + ".fill"
         } else {
             return selectedTab.rawValue
         }
     }
     
     var body: some View {
         VStack() {
             HStack() {
                 ForEach(Tab.allCases, id: \.rawValue) { tab in
                     Spacer()
                     if tab == .person {
                         if pp.isEmpty {
                             Image(self.ppAlt)
                                 .resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .clipShape(Circle())
                                 .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                                 .font(.system(size: 22))
                                 .frame(width: 32, height: 32)
                                 .shadow(radius: 5)
                                 .onTapGesture {
                                     withAnimation(.easeIn(duration: 0.1)) {
                                         selectedTab = tab
                                     }
                                 }
                         } else {
                             AsyncImage(url: URL(string: self.pp)) { image in
                                 image
                                     .resizable()
                             } placeholder: {
                                 ProgressView()
                             }
                             .aspectRatio(contentMode: .fill)
                             .clipShape(Circle())
                             .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                             .font(.system(size: 22))
                             .frame(width: 32, height: 32)
                             .shadow(radius: 5)
                             .onTapGesture {
                                 withAnimation(.easeIn(duration: 0.1)) {
                                     selectedTab = tab
                                 }
                             }
                         }
                     } else {
                         Image(systemName: selectedTab == tab ? fillImage : tab.rawValue)
                             .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                             .foregroundColor(selectedTab == tab ? .blue : Color(uiColor: .label))
                             .font(.system(size: 22))
                             .onTapGesture {
                                 withAnimation(.easeIn(duration: 0.1)) {
                                     selectedTab = tab
                                 }
                             }
                     }
                     Spacer()
                 }
             }
             .frame(width: nil, height: 60)
             .background(.thinMaterial)
             .cornerRadius(10)
             .padding()
         }
     }
 }

 struct NavigationBar_Previews: PreviewProvider {
     static var previews: some View {
         NavigationBar(selectedTab: .constant(Tab.house), pp: .constant(""), ppAlt: .constant("pp1"))
     }
 }
 */
