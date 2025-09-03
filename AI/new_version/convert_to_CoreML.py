import torch
import coremltools as ct
from torchvision import models

# ResNet18 모델 불러오기
model = models.resnet18(pretrained=False)
model.fc = torch.nn.Linear(model.fc.in_features, 2)  # 2개의 클래스로 출력

# 학습된 모델 가중치 로드
model.load_state_dict(torch.load('beer_classifier.pth'))
model.eval()

# 예시 입력 텐서 정의 (입력 크기: [1, 3, 224, 224])
example_input = torch.rand(1, 3, 224, 224)

# 모델을 TorchScript로 변환
traced_model = torch.jit.trace(model, example_input)

# TorchScript 모델을 CoreML로 변환
mlmodel = ct.convert(
    traced_model,
    inputs=[ct.ImageType(shape=example_input.shape)],  # 입력 크기 [1, 3, 224, 224]
    convert_to="neuralnetwork"  # NeuralNetwork 형식으로 변환
)

# CoreML 모델 저장
mlmodel.save("beer_classifier_fixed.mlmodel")
