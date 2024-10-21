from flask import Flask, render_template
from mangum import Mangum  # AWS Lambda adapter for ASGI

app = Flask(__name__)

@app.route("/")
def hello_world():
    return render_template("index.html")


# Lambda handler for AWS Lambda
#handler = Mangum(app)

# def handler(event, context):
#     with app.app_context():  # Ensure the Flask app context is active
#         asgi_handler = Mangum(app)
#         return asgi_handler(event, context)
    
def handler(event, context):
    return {
        "statusCode": 200,
        "body": hello_world(),
        "headers": {
            "Content-Type": "text/html"
        }
    }

# if __name__ == "__main__":
#     app.run(debug=True, port=8080)
