# Blog Project

A simple web Flask project with frontend and backend. 

## How do I run this app locally?

### Set python virtual environment
1. pyenv install 3.10.12 (Install python3 version 3.10.12)
2. pyenv virtualenv 3.10.12 app_python (Create virtualenv app_python)
3. pyenv activate app_python (Activate virtualenv)
4. pip install -r requirements.txt (Install dependencies)
5. cd app-python/src && python3 main.py (It should start local website at http://localhost:5001)

## How do I deploy to this app to my aws account?
1. Install aws CLI following [AWS CLI setup](https://docs.aws.amazon.com/cli/v1/userguide/install-linux.html)
2. Configure aws CLI credentials following the method better suits your needs. See [AWS Credentials](https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-configure.html)
2. Make sure you have the **make** command installed. (Ubuntu users can run apt-get install make)
2. terraform init
3. terraform apply --auto-approve
# final_project
