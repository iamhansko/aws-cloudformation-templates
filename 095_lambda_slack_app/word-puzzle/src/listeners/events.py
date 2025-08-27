import os
import sys
sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
from listeners.handlers import game

def listener(app):
    app.event("app_mention")(
        ack=respond_within_3_seconds,  
        lazy=[game.handler]  
    )

def respond_within_3_seconds(ack):
    ack()