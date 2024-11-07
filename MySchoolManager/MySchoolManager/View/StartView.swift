//
//  StartView.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/7/24.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        Spacer()
        VStack(spacing: 236) {
            VStack(spacing:22) {
                Image("school")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 119, height: 119)
                Text("나의 학교 매니저")
                    .font(.system(size: 24, weight: .bold))
            }
            Button {
                
            } label: {
                Rectangle()
                    .frame(width:351, height: 68)
                    .cornerRadius(10)
                    .foregroundColor(.primarycolor)
                    .overlay {
                        Text("시작하기")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                    }
            }
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    StartView()
}
