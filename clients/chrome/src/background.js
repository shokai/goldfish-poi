var api_url = "http://ubif.org:8932";
// var api_url = "http://localhost:8932"

$(
    function(){
        comet_get();
    }
);

chrome.self.onConnect.addListener(
    function(port, name){
        port.onMessage.addListener(
            function(info, con){
                var url = api_url+"/"+localStorage.nfc_tag;
                console.log("post API : "+url+", data : "+info.url);
                $.ajax(
                    {
                        url : url,
                        data : info.url,
                        success : function(data){
                            console.log("URL post success : "+data);
                        },
                        error : function(e){
                            console.log('URL post error');
                        },
                        type : 'POST',
                        dataType : 'text'
                    }
                );
	            // port.postMessage({url:info.url});
            }
        );
    }
);

var comet_get = function(){
    var url = api_url+"/"+localStorage.nfc_tag;
    console.log('comet_get : ' + url);
    $.ajax(
        {
            url : url,
            success : function(data){
                console.log("comet received : "+data);
                if(data && data.length > 0){
                    if(data.match(/^https?:\/\/.+/)){
                        window.open(data);
                    }
                }
                else{
                    console.log('comet error : received data null');
                }
            },
            error : function(e){
                console.log('comet error');
            },
            complete : function(e){
                comet_get();
            },
            type : 'GET',
            dataType : 'text'
        }
    );
};

