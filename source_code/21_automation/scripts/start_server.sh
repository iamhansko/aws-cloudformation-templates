dnf install -y python3-pip
kill $(pgrep -f 'python3') > /dev/null 2> /dev/null
export FLASK_ENV=development
python3 -m pip install flask
python3 /home/ec2-user/app.pyc > /dev/null 2> /dev/null < /dev/null &