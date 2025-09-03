import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, models, transforms
from torch.utils.data import DataLoader
import time
import copy
import matplotlib.pyplot as plt
from PIL import Image

# MPS 장치 확인 (Apple 실리콘 사용 시)
device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
print(f"Using device: {device}")

# 데이터 전처리 및 Augmentation 설정 (Swift CoreML 입력과 동일한 전처리)
data_transforms = {
    'train': transforms.Compose([
        transforms.Resize(256),  # Swift에서 요구되는 입력 크기
        transforms.CenterCrop(224),
        transforms.RandomHorizontalFlip(),  # Augmentation
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])  # Swift와 동일한 정규화
    ]),
    'valid': transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])  # Swift와 동일한 정규화
    ]),
}

# 데이터셋 경로 설정
data_dir = 'Capmap-1'
image_datasets = {x: datasets.ImageFolder(f"{data_dir}/{x}", data_transforms[x]) for x in ['train', 'valid']}
dataloaders = {x: DataLoader(image_datasets[x], batch_size=32, shuffle=True) for x in ['train', 'valid']}
dataset_sizes = {x: len(image_datasets[x]) for x in ['train', 'valid']}
class_names = image_datasets['train'].classes
print(f"Classes: {class_names}")

# ResNet18 모델 로드 (사전 학습된 가중치 사용)
model = models.resnet18(pretrained=True)
num_ftrs = model.fc.in_features
model.fc = nn.Linear(num_ftrs, len(class_names))

# 모델을 MPS 장치로 이동
model = model.to(device).to(torch.float32)

# 손실 함수 및 옵티마이저 정의
criterion = nn.CrossEntropyLoss()
optimizer = optim.SGD(model.parameters(), lr=0.001, momentum=0.9)
exp_lr_scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=7, gamma=0.1)

# 학습 기록을 저장할 리스트
train_losses = []
valid_losses = []
train_accs = []
valid_accs = []

# 모델 학습 및 검증 함수
def train_model(model, criterion, optimizer, scheduler, num_epochs=25):
    best_model_wts = copy.deepcopy(model.state_dict())
    best_acc = 0.0

    for epoch in range(num_epochs):
        print(f'Epoch {epoch}/{num_epochs - 1}')
        print('-' * 10)

        for phase in ['train', 'valid']:
            if phase == 'train':
                model.train()
            else:
                model.eval()

            running_loss = 0.0
            running_corrects = 0

            for inputs, labels in dataloaders[phase]:
                inputs = inputs.to(device).to(torch.float32)
                labels = labels.to(device)

                optimizer.zero_grad()

                with torch.set_grad_enabled(phase == 'train'):
                    outputs = model(inputs)
                    _, preds = torch.max(outputs, 1)
                    loss = criterion(outputs, labels)

                    if phase == 'train':
                        loss.backward()
                        optimizer.step()

                running_loss += loss.item() * inputs.size(0)
                running_corrects += torch.sum(preds == labels.data)

            if phase == 'train':
                scheduler.step()

            epoch_loss = running_loss / dataset_sizes[phase]
            epoch_acc = running_corrects.float() / dataset_sizes[phase]

            print(f'{phase} Loss: {epoch_loss:.4f} Acc: {epoch_acc:.4f}')

            if phase == 'train':
                train_losses.append(epoch_loss)
                train_accs.append(epoch_acc)
            else:
                valid_losses.append(epoch_loss)
                valid_accs.append(epoch_acc)

            if phase == 'valid' and epoch_acc > best_acc:
                best_acc = epoch_acc
                best_model_wts = copy.deepcopy(model.state_dict())

    print(f'Best val Acc: {best_acc:.4f}')
    model.load_state_dict(best_model_wts)
    return model

# 모델 저장 함수
def save_model(model, path='best_model.pth'):
    torch.save(model.state_dict(), path)
    print(f"Model saved to {path}")

# 학습 완료 후 모델 저장
model = train_model(model, criterion, optimizer, exp_lr_scheduler, num_epochs=25)
save_model(model, 'beer_classifier_v2.pth')

# 모델 평가 함수
def test_model(model):
    model.eval()
    corrects = 0
    total = 0
    with torch.no_grad():
        for inputs, labels in dataloaders['valid']:
            inputs = inputs.to(device).to(torch.float32)
            labels = labels.to(device)
            outputs = model(inputs)
            _, preds = torch.max(outputs, 1)
            corrects += torch.sum(preds == labels.data)
            total += labels.size(0)

    acc = corrects.float() / total
    print(f'Validation Accuracy: {acc:.4f}')

# 학습 결과 그래프 그리기
def plot_training_results(train_losses, valid_losses, train_accs, valid_accs):
    epochs = range(1, len(train_losses) + 1)
    train_accs = [acc.cpu().item() for acc in train_accs]
    valid_accs = [acc.cpu().item() for acc in valid_accs]

    plt.figure(figsize=(12, 4))

    # Loss 그래프
    plt.subplot(1, 2, 1)
    plt.plot(epochs, train_losses, label='Train Loss')
    plt.plot(epochs, valid_losses, label='Valid Loss')
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    plt.title('Loss over Epochs')

    # Accuracy 그래프
    plt.subplot(1, 2, 2)
    plt.plot(epochs, train_accs, label='Train Accuracy')
    plt.plot(epochs, valid_accs, label='Valid Accuracy')
    plt.xlabel('Epochs')
    plt.ylabel('Accuracy')
    plt.legend()
    plt.title('Accuracy over Epochs')

    plt.show()

plot_training_results(train_losses, valid_losses, train_accs, valid_accs)

# 분류할 이미지를 입력으로 받아 예측하는 함수
def classify_image(image_path, model):
    model.eval()
    transform = transforms.Compose([
        transforms.Resize(256),
        transforms.CenterCrop(224),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
    ])

    img = Image.open(image_path)
    img = transform(img).unsqueeze(0)
    img = img.to(device).to(torch.float32)

    with torch.no_grad():
        outputs = model(img)
        _, preds = torch.max(outputs, 1)
        predicted_class = class_names[preds[0]]
    
    return predicted_class

# 모델 테스트 및 평가
test_model(model)
