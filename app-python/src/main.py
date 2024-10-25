from datetime import date
from flask import Flask, request, jsonify, render_template, redirect, url_for, flash
from flask_bootstrap import Bootstrap5
from flask_ckeditor import CKEditor
from flask_gravatar import Gravatar
from functools import wraps
from werkzeug.security import generate_password_hash, check_password_hash
# Import your forms from the forms.py

import os, boto3, random, json, base64, time

app = Flask(__name__)
app.config['SECRET_KEY'] = '8BYkEfBA6O6donzWlSihBXox7C0sKR6b'

app.config['SERVER_NAME'] = os.environ.get("API_GW")
app.config['APPLICATION_ROOT'] = '/'
app.config['PREFERRED_URL_SCHEME'] = 'https'


os.environ["S3_ARN"]="https://my-flask-static-content.s3.amazonaws.com"
S3_ARN = os.environ.get("S3_ARN")

Bootstrap5(app)

# For adding profile images to the comment section
gravatar = Gravatar(app,
                    size=100,
                    rating='g',
                    default='retro',
                    force_default=False,
                    force_lower=False,
                    use_ssl=False,
                    base_url=None)

@app.route('/')
def get_all_posts():
    # TODO GET ALL POSTS FROM DB
  
    get_lambda_client = boto3.client('lambda')
            
    payload = {
                "action": "get_all"
            }
    
    response = get_lambda_client.invoke(
        FunctionName='InsertDynamoDBFunction',
        InvocationType='RequestResponse',
        Payload=json.dumps(payload)
    )
    posts =  json.loads(response['Payload'].read().decode('utf-8'))
    posts = json.loads(posts.get("body"))
    
    print(type(posts))
    print(f"Posts: {posts}")

    for post in posts:
        print(type(post))
        print(post.get("id"))
    
    return render_template("index.html", all_posts=posts, current_user=0,  S3_ARN = S3_ARN)

@app.route("/post/<int:post_id>", methods=["GET", "POST"])
def show_post(post_id):
    get_lambda_client = boto3.client('lambda')
            
    payload = {
                "action": "get_one",
                "item": {
                    "id":f"{post_id}"
                }
            }
    
    response = get_lambda_client.invoke(
        FunctionName='InsertDynamoDBFunction',
        InvocationType='RequestResponse',
        Payload=json.dumps(payload)
    )
    post =  json.loads(response['Payload'].read().decode('utf-8'))
    post = json.loads(post.get("body"))
    return render_template("post.html", post=post, current_user=0)

# Add a POST method to be able to post comments
@app.route("/newpost", methods=["GET", "POST"])
def add_post():
    if request.method == "GET":
        return render_template("make-post.html")
    elif request.method == "POST":
        # Retrieve form data from the POST request
        try:
            print(request)
            title = request.form.get('title')
            subtitle = request.form.get('subtitle')
            image_url = request.form.get('image_url')
            content = request.form.get('content')

            # For demonstration purposes, print the form data
            print(f'Title: {title}, Subtitle: {subtitle}, Image URL: {image_url}, Content: {content}')

            # Handle the post and return a response
            #return redirect(url_for("get_all_posts"))
            
            post_lambda_client = boto3.client('lambda')
            
            payload = {
                "action": "put",
                "item": {
                    "id": f"{int(time.time())}",
                    "title": title,
                    "subtitle": subtitle,
                    "image_url": image_url,
                    "content": content,
                }
            }
    
            response = post_lambda_client.invoke(
                FunctionName='InsertDynamoDBFunction',
                InvocationType='RequestResponse',
                Payload=json.dumps(payload)
            )
            
            print(f"lambda_response {response}")
            return redirect(url_for('get_all_posts'))

        except Exception as e:
            return jsonify({'error': str(e)})
    
        
# Use a decorator so only an admin user can delete a post
@app.route("/delete/<int:post_id>")
def delete_post(post_id):
    delete_lambda_client = boto3.client('lambda')
            
    payload = {
                "action": "delete",
                "item": {
                    "id":f"{post_id}"
                }
            }
    
    response = delete_lambda_client.invoke(
        FunctionName='InsertDynamoDBFunction',
        InvocationType='RequestResponse',
        Payload=json.dumps(payload)
    )
   
    return redirect(url_for('get_all_posts'))
    
@app.route("/edit-post/<int:post_id>", methods=["GET", "POST"])
def edit_post(post_id):
    
    return render_template("home.html", form=[], is_edit=True, current_user=0)


@app.route("/about")
def about():
    return render_template("about.html", current_user=0,  S3_ARN = S3_ARN)


@app.route("/contact", methods=["GET","POST"])
def contact():
    return render_template("contact.html", current_user=0,  S3_ARN = S3_ARN)


def handler(event, context):
    # Convert API Gateway event to Flask request
    path = event.get('rawPath')
    method = event.get('requestContext').get('http').get('method')
    headers = event.get("headers")
     
    if event.get('isBase64Encoded'):
        body = base64.b64decode(event.get('body'))
    
    else:
        body = event.get('body')

    print(f"body: {body}")
    print(f"event: {event}")

    #with app.app_context():
    with app.test_request_context(path=path, method=method, data=body, headers=headers):
        response = app.full_dispatch_request()
        return {
            'statusCode': response.status_code,
            'headers': dict(response.headers),
            'body': response.get_data(as_text=True)
        }


if __name__ == "__main__":
    app.run(debug=True, port=5001)
