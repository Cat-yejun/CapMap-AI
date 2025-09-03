import os
import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, transforms, models
from torch.utils.data import DataLoader, random_split

def main():
    # 장치 설정 (MPS 사용 가능 여부 확인)
    device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
    print('사용할 장치:', device)

    # 데이터셋 경로 설정 (데이터가 있는 위치로 수정)
    data_dir = "input_dataset"
    batch_size = 32
    img_height = 224
    img_width = 224
    val_split = 0.2  # 검증 데이터셋 비율

    # 데이터 전처리
    data_transforms = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(img_height),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

    # 전체 데이터셋 로드
    full_dataset = datasets.ImageFolder(root=data_dir, transform=data_transforms)

    # 데이터셋 분할
    train_size = int((1 - val_split) * len(full_dataset))
    val_size = len(full_dataset) - train_size
    train_dataset, val_dataset = random_split(full_dataset, [train_size, val_size])

    # 데이터 로더 생성
    train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True, num_workers=4)
    val_loader = DataLoader(val_dataset, batch_size=batch_size, shuffle=False, num_workers=4)

    # 모델 정의 (pretrained ResNet18 사용)
    model = models.resnet18(weights='IMAGENET1K_V1')
    num_ftrs = model.fc.in_features
    model.fc = nn.Linear(num_ftrs, len(full_dataset.classes))

    model = model.to(device)

    # 손실 함수와 옵티마이저 설정
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.SGD(model.parameters(), lr=0.001, momentum=0.9)

    # 모델 학습 함수 정의
    def train_model(model, criterion, optimizer, num_epochs=10):
        for epoch in range(num_epochs):
            print(f'Epoch {epoch+1}/{num_epochs}')
            print('-' * 10)

            # 각 epoch마다 학습 단계와 검증 단계 나눔
            for phase in ['train', 'val']:
                if phase == 'train':
                    model.train()
                    dataloader = train_loader
                else:
                    model.eval()
                    dataloader = val_loader

                running_loss = 0.0
                running_corrects = 0

                # 데이터 반복
                for inputs, labels in dataloader:
                    inputs = inputs.to(device).float()  # float32로 변환
                    labels = labels.to(device)

                    optimizer.zero_grad()

                    # 순전파
                    with torch.set_grad_enabled(phase == 'train'):
                        outputs = model(inputs)
                        _, preds = torch.max(outputs, 1)
                        loss = criterion(outputs, labels)

                        # 학습 시 역전파 + 최적화
                        if phase == 'train':
                            loss.backward()
                            optimizer.step()

                    running_loss += loss.item() * inputs.size(0)
                    running_corrects += torch.sum(preds == labels.data)

                epoch_loss = running_loss / len(dataloader.dataset)
                epoch_acc = running_corrects.double() / len(dataloader.dataset)

                print(f'{phase} Loss: {epoch_loss:.4f} Acc: {epoch_acc:.4f}')

        return model

    # 모델 학습
    model = train_model(model, criterion, optimizer, num_epochs=10)

    # 학습 완료 후 모델 저장 (선택 사항)
    torch.save(model.state_dict(), "asahi_classifier_model.pth")

if __name__ == '__main__':
    main()
