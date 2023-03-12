# 2. (20 pt) Function as a Service project

**The goal**: try in the wild seceral cloud services.

You have to implement two Functions:
- HTTP-triggered Function, which ingests event to Event Stream;  
- Function automatically triggered  on new event in Event Stream, and stores event content in a cloud Object Storage as json file.

### Requirements

- Incoming HTTP request should have randomly generated identifier that is propagated through the whole pipeline: HTTP -> Event Stream -> Object Store.
- Function was deployed to your cloud account
- HTTP Function does not allow anonymous access
- json file in Object Store should have incoming request-id
- New requests does not override any existing file in Object Store

### Deliveries

- Reference to git repository with project sources
- Cloud web-interface screenshots to prove function successful invocation:
    - function invocation logs from cloud interface
    - created files in Object Storage
