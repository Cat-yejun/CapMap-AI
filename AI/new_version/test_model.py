import torch
from torchvision import models, transforms
from PIL import Image
import torch.nn as nn

# MPS 장치 확인
device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
print(f"Using device: {device}")

# 학습된 모델 불러오기 함수
def load_model(path='best_model.pth', num_classes=2):
    # ResNet18 모델 정의
    model = models.resnet18(pretrained=False)  # 사전 학습된 가중치 불러오지 않음
    num_ftrs = model.fc.in_features
    model.fc = nn.Linear(num_ftrs, num_classes)  # 클래스 수에 맞게 수정
    model.load_state_dict(torch.load(path, map_location=device))  # 저장된 가중치 로드
    model = model.to(device).to(torch.float32)
    model.eval()  # 평가 모드로 설정
    print(f"Model loaded from {path}")
    return model

# 이미지를 입력으로 받아 분류하는 함수
def classify_image(image_path, model, class_names):
    model.eval()
    # 이미지 전처리
    transform = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

    # 이미지 로드 및 변환
    img = Image.open(image_path)
    img = transform(img).unsqueeze(0)  # 배치 차원 추가

    img = img.to(device).to(torch.float32)

    # 모델 예측
    with torch.no_grad():
        outputs = model(img)
        _, preds = torch.max(outputs, 1)
        predicted_class = class_names[preds[0]]
    
    return predicted_class

# 클래스 이름 목록 (예: 'Asahi', 'Heineken')
class_names = ['Asahi', 'Heineken']  # 이 부분을 데이터셋에 맞게 수정

# 저장된 모델 불러오기
model = load_model('beer_classifier_v2.pth', num_classes=len(class_names))

# 분류할 이미지 경로 설정
image_path = 'heineken_test.jpeg'  # 여기에 테스트할 이미지 경로를 입력하세요.

# 이미지 분류 수행
predicted_class = classify_image(image_path, model, class_names)
print(f'Predicted Class: {predicted_class}')
