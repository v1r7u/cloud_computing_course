import logging
import datetime
import json
import os

import azure.functions as func

from azure.core.credentials import AzureKeyCredential
from azure.eventgrid import EventGridPublisherClient, EventGridEvent

key = os.environ["eventGridTopicKey"]
endpoint = os.environ["eventGridTopicEndpoint"]

# authenticate client
credential = AzureKeyCredential(key)
client = EventGridPublisherClient(endpoint, credential)

def main(req: func.HttpRequest) -> str:
    req_body = req.get_json()
    name = req_body.get('name')
    createdAt = req_body.get('time')

    timestamp = datetime.datetime.utcnow()
    logging.info('[HTTP] Message created at: %s with name: %s', timestamp, name)

    eventContent = {
        "createdAt": createdAt,
        "name": name,
        "processedAt": f'{timestamp}'
    }
    event = EventGridEvent(
            subject="HTTP_Events",
            data=eventContent,
            event_type="Cloud.Computing.Demo",
            data_version="2.0"
            )

    client.send(event)

    return json.dumps(eventContent)
