from flask import Flask, request,json
import emoji
app = Flask(__name__)

your_name = "Mikhail Kozhevnikov"
index_response_curl="""
█████████████████████████████████████
█████████████████████████████████████
████ ▄▄▄▄▄ █▀▄█▀ █  ▀▀ ▄▀█ ▄▄▄▄▄ ████
████ █   █ █▄   ▄█ ▀█ ▀▄██ █   █ ████
████ █▄▄▄█ █ ▀█▀█▄█   ▄▀██ █▄▄▄█ ████
████▄▄▄▄▄▄▄█ ▀▄█ █▄█▄▀ █▄█▄▄▄▄▄▄▄████
████▄▄▀▄█▀▄▄██ ▀▄▄▄▄▄██▄▀█ ▄▄▀▄▄▀████
██████  ▀ ▄▄▀▄▄█▀▀██▀▄▀ █▄██ ▄  █████
████▄ ▀█▄▄▄▄▀█▀█ ▄▀██▄▀▄  ▄██▄█▄▄████
████▀ ▄██▀▄▀███▄█▀██▀▀▄█ ▀ ▄▄ ▄ ▄████
████▄█ ▄█▀▄▀██ ▀ ▀█▄▀ ██ ▀▀ █▀█▄▀████
████▄███  ▄ ▄▀ █▄▄ █▀▀▄█▀ █  ██  ████
████▄██▄█▄▄▄▀ ▄▄▀▄█▄ ▀█  ▄▄▄ █ ▀▀████
████ ▄▄▄▄▄ █▄  █▀ █▀▄█▀█ █▄█ ▀▀ █████
████ █   █ █▀█ █▀▄█▄▄ ▀▀ ▄   ▀▀█▄████
████ █▄▄▄█ █▀█▀▄▀ ▀█ ▀█  ▀██ ▄▄▀▄████
████▄▄▄▄▄▄▄█▄█▄▄▄██▄█▄██▄▄▄▄▄▄█▄█████
█████████████████████████████████████
█████████████████████████████████████

"""

index_response_noncurl="""
<img src="https://raw.githubusercontent.com/MikeKozhevnikov/devops-cource/main/media/ansible/QR_Code_github.png">
"""

@app.route('/', methods=['GET'])
def index():
    user_agent = request.headers.get('User-Agent') 
    user_agent_pos = user_agent.find('curl')
    # for curl
    if user_agent_pos != -1:
        return index_response_curl
    # for browsers
    else:
        return index_response_noncurl

@app.route('/', methods=['POST'])
def recieve_json():
    response=""
    data = request.get_data()
    try:
        data = json.loads(data)
        request_animal = data["animal"]
        request_sound  = data["sound"]
        request_count  = int(data["count"])
        if request_count <= 0:
            raise ValueError('count value is incorrect')
    except:
        return "Bad request: use POST JSON query: {\"animal\":\"cow\", \"sound\":\"moooo\", \"count\": 3}\nor curl -XPOST -d'{\"animal\":\"cow\", \"sound\":\"moooo\", \"count\": 3}' http://ip/\n"

    for i in range(int(request_count)):
        response+=emoji.emojize(":" + request_animal + ":") + " says " +  request_sound +"\n"
    response+="Made with " + emoji.emojize(':victory_hand:', use_aliases=True) + "  by " + your_name + "\n"
    return response

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False)