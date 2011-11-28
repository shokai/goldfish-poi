var api_url = "http://ubif.org:8932";
// var api_url = "http://localhost:8932"

chrome.self.onConnect.addListener(
    function(port, name) {
        port.onMessage.addListener(
            function(info, con) {
	            xhr = new XMLHttpRequest();
	            xhr.open("POST", api_url+"/"+localStorage.nfc_tag, true);
	            xhr.setRequestHeader("Content-Type" , "application/x-www-form-urlencoded");
	            xhr.send(info.url);
	            port.postMessage({url:info.url});
            }
        );
    }
);
