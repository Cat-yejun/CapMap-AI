import torch
import coremltools as ct
from torchvision import models

# MPS 장치 확인
device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
print(f"Using device: {device}")

# 클래스 수 설정 (모델 학습시 사용했던 class_names로 수정)
num_classes = 2  # 예: ['Asahi', 'Heineken']

# 모델 로드
model = models.resnet18(pretrained=False)  # 사전 학습된 가중치 사용 안 함
num_ftrs = model.fc.in_features
model.fc = torch.nn.Linear(num_ftrs, num_classes)

# 학습된 모델 가중치 로드
model.load_state_dict(torch.load('beer_classifier_v2.pth', map_location=device))
model = model.to(device).to(torch.float32)
model.eval()

# CoreML 변환에 사용될 더미 입력 (Swift에서 입력할 이미지 크기와 동일한 224x224 크기)
example_input = torch.rand(1, 3, 224, 224).to(device).to(torch.float32)

# TorchScript로 변환
traced_model = torch.jit.trace(model, example_input)

# PyTorch 모델을 CoreML로 변환
# 모델을 mlprogram 형식으로 변환, 이 형식은 iOS 15 이상에서 사용 가능
mlmodel = ct.convert(
    traced_model,
    inputs=[ct.ImageType(shape=(1, 3, 224, 224), scale=1/255.0, bias=[-0.485, -0.456, -0.406], color_layout="RGB")],
    convert_to="mlprogram"  # Swift에서 사용될 mlprogram 형식
)

# CoreML 모델 저장
mlmodel.save("beer_classifier.mlpackage")
print("CoreML 모델이 'beer_classifier.mlpackage'로 저장되었습니다.")
