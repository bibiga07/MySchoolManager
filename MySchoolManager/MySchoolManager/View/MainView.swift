//
//  MainView.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/19/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            VStack(spacing: 37) {
                    Text("대구소프트웨어마이스터고등학교 2학년 2반")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                HStack {
                    Text("2024년 11월 19일 화요일")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                    Button {
                        
                    } label: {
                        Image(systemName: "calendar")
                            .resizable()
                            .frame(width: 19, height: 18)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 19)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            VStack {
                Color(.cPrimary).frame(height: 295).ignoresSafeArea()
                Spacer()
            }
        }
    }
}

#Preview {
    MainView()
}
