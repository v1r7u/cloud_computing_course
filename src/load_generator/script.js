import http from "k6/http";

export default function() {
    var url = 'https://cloudcomp-fewy-func.azurewebsites.net/api/httptoeventhub?code=3LTsGOX/2lS93v5ROa46XMTh150kxfvieDZRYgIkr2COmVLfAApxmQ==';
    var payload = JSON.stringify({
      name: Math.random().toString(16).substr(2, 16),
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