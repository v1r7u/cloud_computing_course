import logging
import datetime
import json
import azure.functions as func


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
    return json.dumps(eventContent)
