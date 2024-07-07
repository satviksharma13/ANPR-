from flask import Flask, request, jsonify
import cv2
import pytesseract
import numpy as np

app = Flask(__name__)

# Path to Tesseract executable
pytesseract.pytesseract.tesseract_cmd = r"C:/Program Files/Tesseract-OCR/tesseract.exe"

# Load the pre-trained Haar Cascade for license plate detection
plate_cascade = cv2.CascadeClassifier('haarcascade_russian_plate_number.xml')

@app.route('/process_image', methods=['POST'])
def process_image():
    image_data = request.data
    nparr = np.frombuffer(image_data, np.uint8)
    img_np = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    # Convert the image to grayscale
    gray = cv2.cvtColor(img_np, cv2.COLOR_BGR2GRAY)

    # Perform license plate detection
    plates = plate_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5)

    # Recognize license plates using Tesseract OCR
    plate_texts = recognize_license_plates(gray, plates)
    
    return jsonify({"plates": plate_texts})

def recognize_license_plates(gray_image, plates):
    plate_texts = []
    for (x, y, w, h) in plates:
        plate_img = gray_image[y:y+h, x:x+w]
        plate_text = pytesseract.image_to_string(plate_img, config='--psm 8')
        plate_texts.append(plate_text.strip())
    return plate_texts

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
