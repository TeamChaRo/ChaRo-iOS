//
//  SecondBannerHeaderView.swift
//  ChaRo-iOS
//
//  Created by 장혜령 on 2022/06/07.
//

import UIKit

import SnapKit
import Then

final class SecondBannerHeaderView: UIView {
    
    let viewRetio: CGFloat = UIScreen.getDeviceWidth() / 375.0
    
    private let headerImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = ImageLiterals.imgPlaylistBanner
    }
    
    private let contentTextView = UITextView().then {
        $0.textColor = .gray50
        $0.font = .notoSansMediumFont(ofSize: 13)
        $0.isUserInteractionEnabled = false
        $0.text = """
        드라이브와 잘 어울리는 계절인 봄이 찾아왔습니다.

        양옆 창문 열어놓고 선선한 바람 맞으며 드라이브 하는 낭만, 다들 가지고 계시죠? 드라이브 하면서 빠질 수 없는게 음악인데요, 음악 고르는데 시간쏟지 마시고 차로가 봄 바람과 잘 어울리는 플레이리스트를 준비했습니다.
        선곡한 15곡은 밤에 드라이브할 때 어울리는 노래입니다.
        너무 신나지 않지만 조용하지 않은 노래로 골라봤습니다. 🔈
        """
    }
    
    private let descriptionLabel = UILabel().then {
        $0.textColor = .gray50
        $0.font = .notoSansMediumFont(ofSize: 14)
        $0.textAlignment = .center
        $0.text = "아래 버튼을 누르면\n전체 플레이리스트로 이동해요."
        $0.numberOfLines = 2
    }
    
    let confirmButton = UIButton().then {
        $0.backgroundColor = .mainBlue
        $0.setTitle("유튜브 플레이리스트로 이동하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.titleLabel?.font = .notoSansMediumFont(ofSize: 14)
    }
    
    private let guideLabel = UILabel().then {
        $0.textColor = .gray50
        $0.font = .notoSansMediumFont(ofSize: 14)
        $0.textAlignment = .center
        $0.text = "개별 음원을 선택하고 싶으면\n아래 앨범 커버를 클릭해주세요."
        $0.numberOfLines = 2
    }

   //MARK: - init 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContraints() {
        self.addSubviews([headerImageView, contentTextView, descriptionLabel, confirmButton, guideLabel])
        
        headerImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(headerImageView.snp.bottom).offset(17)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(70)
            $0.height.equalTo(31)
        }
        
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(confirmButton.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
