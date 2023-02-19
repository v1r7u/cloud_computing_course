# README

1. Create and activate virtual environment

    ```sh
    python3 -m venv .venv
    source .venv/bin/activate
    ```

2. Run locally: `func start`

3. Deploy function

    ```sh
    az account set -s $SUBCRIPTION_ID
    func azure functionapp publish $FUNCTION_APP_NAME
    ```

4. To insert event

    ```sh
    ### Local run
    echo $(date) | xargs -I{} curl -d '{"name":"the first", "time":"{}"}' -X POST http://localhost:7071/api/HttpToEventHub

    ### Azure run
    # Get function URL from Code+Test view
    FUNCTION_URL=https://cloudcomp-dv5o-func.azurewebsites.net/api/HttpToEventHub?code=9eIGWkAv7RKq6m3ykUWhWRLn2ZLcG4ZEGqtLN9HRaK/UkhJH5tjaBg==
    echo $(date) | xargs -I{} curl -d '{"name":"the first", "time":"{}"}' -X POST $FUNCTION_URL
    ```
