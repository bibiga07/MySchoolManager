//
//  SelectView.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/7/24.
//

import SwiftUI

struct SelectView: View {
    @State private var selectedEducation = "대구광역시교육청"
    @State var selectedSchool: String = ""
    
    let education = ["서울특별시교육청", "부산광역시교육청", "대구광역시교육청", "인천광역시교육청", "광주광역시교육청", "대전광역시교육청", "울산광역시교육청", "세종특별자치시교육청", "경기도교육청", "강원도교육청", "충청북도교육청", "충청남도교육청", "전북특별자치도교육청", "전라남도교육청", "경상북도교육청", "경상남도 교육청", "제주특별자치도교육청", "재외한국학교교육청"]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("당신의 학교를 알려주세요")
                    .font(.system(size: 20, weight: .medium))
                Text("처음 한번만 등록하면 다음부턴 하지 않아도 괜찮아요")
                    .font(.system(size: 13, weight: .light))
                Picker("교육청을 선택하세요", selection: $selectedEducation) {
                    ForEach(education, id: \.self) { education in
                        Text(education)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 351)
                .padding(.bottom, 50)
                .padding(.top, 50)
                
                TextField("학교를 입력해주세요", text: $selectedSchool)
                    .padding(.leading, 33)
                Rectangle()
                    .frame(width: 351, height: 1)
                
                Spacer().frame(height: 230)
                
                VStack(spacing: 8) {
                    Button {
                        
                    } label: {
                        Rectangle()
                            .frame(width:351, height: 61)
                            .cornerRadius(20)
                            .foregroundColor(.cPrimary)
                            .overlay {
                                Text("등록하기")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                    }
                    Text("최초 한번 등록한 이후 마이페이지에서 변경 가능해요 !")
                        .font(.system(size: 13, weight: .light))
                }
            }
        }
    }
}

#Preview {
    SelectView()
}
