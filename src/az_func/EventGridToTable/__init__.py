import json
import logging
import sys

import azure.functions as func
from azure.eventgrid import EventGridEvent

def main(event: func.EventGridEvent, message: func.Out[str]):
    logging.info(sys.version)
    logging.info(event)

    data = {
        "PartitionKey": event.subject,
        "RowKey": event.id,
        "data": event.get_json()
    }

    logging.info(data)

    message.set(json.dumps(data))
