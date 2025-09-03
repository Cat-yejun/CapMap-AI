import torch
import torch.nn as nn
from torchvision import models

# ResNet18 모델 불러오기 (pretrained=False로 사전 학습된 가중치 사용하지 않음)
model = models.resnet18(pretrained=False)

# 모델의 마지막 레이어(fc)를 2개의 클래스 출력으로 수정
num_ftrs = model.fc.in_features
model.fc = nn.Linear(num_ftrs, 2)  # 2개의 클래스

# 저장된 가중치 로드
model.load_state_dict(torch.load('beer_classifier.pth'))

# 모델 확인
print(model)

from PIL import Image
from torchvision import transforms
import torch

# 전처리 설정 (이미지를 PyTorch 텐서로 변환)
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

# 이미지 로드
img = Image.open("heineken_test.jpeg")

# 이미지를 전처리하고 배치 차원을 추가
img_tensor = preprocess(img).unsqueeze(0)

# 모델을 평가 모드로 설정
model.eval()

# 예측
with torch.no_grad():
    output = model(img_tensor)
    _, predicted = torch.max(output, 1)
    print(f'Predicted class: {predicted.item()}')


import torch
import coremltools as ct

# 예시 입력 텐서 정의
example_input = torch.rand(1, 3, 224, 224)

# 모델을 트레이스하여 TorchScript 모델로 변환
traced_model = torch.jit.trace(model, example_input)

# TorchScript 모델을 CoreML 모델로 변환
mlmodel = ct.convert(
    traced_model,
    inputs=[ct.ImageType(shape=example_input.shape)],
    convert_to="neuralnetwork"  # NeuralNetwork 형식으로 변환
)

# CoreML 모델 저장
mlmodel.save("beer_classifier.mlmodel")

