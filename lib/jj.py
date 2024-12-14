from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
   
    x = data.get('x')
    # Perform prediction or any other computation
    result = x * 2  # Just an example, replace with your actual logic
    return jsonify({'result': result})

if __name__ == '__main__':
    app.run(debug=True)
