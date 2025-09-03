import tensorflow as tf
from tensorflow.keras.preprocessing import image
import numpy as np
from PIL import Image

# 모델 로드
model = tf.keras.models.load_model('asahi_classifier_model.h5')

# 클래스 이름 설정 (train 시 사용한 클래스 순서대로 설정)
class_names = ['Asahi', 'Not_Asahi']  # 예시

def preprocess_image(img_path, img_height=224, img_width=224):
    # 이미지 로드 및 크기 조정
    img = Image.open(img_path)
    img = img.resize((img_width, img_height))
    
    # 이미지를 배열로 변환하고 정규화
    img_array = np.array(img) / 255.0
    
    # 배치 차원을 추가하여 (1, img_height, img_width, 3) 형태로 변환
    img_array = np.expand_dims(img_array, axis=0)
    
    return img_array

def predict_image(model, img_array):
    # 예측 수행
    predictions = model.predict(img_array)
    
    # 가장 높은 확률의 클래스 예측
    predicted_class = np.argmax(predictions[0])
    predicted_label = class_names[predicted_class]
    
    return predicted_label, predictions[0]

# 테스트할 이미지 경로 설정
img_path = 'test2.jpg'  # 테스트할 이미지 경로

# 이미지 전처리
img_array = preprocess_image(img_path)

# 예측 수행
predicted_label, probabilities = predict_image(model, img_array)

# 결과 출력
print(f"Predicted class: {predicted_label}")
print(f"Probabilities: {probabilities}")
