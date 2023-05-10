import http from "k6/http";

export default function() {
    var url = 'https://cloud23-dz6y-func.azurewebsites.net/api/httptoeventgrid?code=eBSs_qgOQKR5S5YEUD8_U8SNuMJQUqKBKdk3EA8ONxEyAzFu6gqC6Q==';
    var payload = JSON.stringify({
      name: Math.random().toString(16).substring(2, 16),
      time: new Date(),
    });

    var params = {
      headers: {
        'Content-Type': 'application/json',
      },
    };

    //console.log(payload);

    http.post(url, payload, params);
};