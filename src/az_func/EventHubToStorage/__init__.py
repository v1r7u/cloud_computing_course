import logging
import os
import json
import azure.functions as func
from azure.storage.blob import BlobClient

def main(event: func.EventHubEvent):
    message_body=event.get_body().decode()
    partition=event.metadata['PartitionContext']['PartitionId']
    logging.info(f'EH: Function triggered to process a message: {message_body}')
    logging.info(f'EH:   EnqueuedTimeUtc = {event.enqueued_time}')
    logging.info(f'EH:   PartitionId = {partition}')
    logging.info(f'EH:   SequenceNumber = {event.sequence_number}')
    logging.info(f'EH:   Offset = {event.offset}')

    # Metadata
    for key in event.metadata:
        logging.info(f'EH: Metadata: {key} of type {type(event.metadata[key])} = {event.metadata[key]}')

    blobContent = {
        "enqueuedAt": f'{event.enqueued_time}',
        "partitionId": partition,
        "eventContent": message_body
        }
    blobName=f'{blobContent["partitionId"]}/{event.enqueued_time.year}/{event.enqueued_time.month}/{event.enqueued_time.day}/{event.enqueued_time.hour}_{event.sequence_number}_{event.offset}'

    sa_cs = os.environ["StorageAccountConnectionString"]
    sa_container = os.environ["StorageAccountContainerName"]
    blob = BlobClient.from_connection_string(conn_str=sa_cs, container_name=sa_container, blob_name=blobName)

    blob.upload_blob(json.dumps(blobContent))
