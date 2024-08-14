from flask import Flask, request, jsonify
import hashlib

app = Flask(__name__)


@app.route('/', methods=['GET'])
def home_page():
    # Use a different function name
    return '''
   <!doctype html>
    <html>
    <body style="background-image: url('/static/bubble-float.gif'); background-size: cover; height: 100vh; color: white;">
        <form method=POST enctype=multipart/form-data action="/upload" style="padding-top: 20px;">
            <input type=file name=file>
            <input type=submit value=Upload>
        </form>
        <footer style="position: fixed; left: 0; bottom: 0; width: 100%; text-align: center; background-color: rgba(0, 0, 0, 0.7); color: white;">
            <p>Designed by Olisa Arinze  August 2024</p>
        </footer>
    </body>
    </html>
    '''


@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400

    file = request.files['file']

    if file.filename == '':
        return jsonify({'error': 'No file selected for uploading'}), 400

    file_contents = file.read()
    md5_hash = hashlib.md5(file_contents).hexdigest()

    return jsonify({'filename': file.filename, 'md5_hash': md5_hash})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
