var log = function(msg){
    console.log(msg);
    $('ul#log').prepend(
        $('<li>').html(msg)
    );
};

$(
    function(){
        $('.panel').hide();
        $('#action').show();
        poi.on('copy', function(e){
                   console.log(e);
                   poi.request(e)
               });
        poi.on('paste', function(e){
                   console.log(e);
                   poi.request(e);
               });
        poi.run();
    }
);

var poi = {
    callbacks : {},
    request : {}
};

poi.on = function(event, callback){
    poi.callbacks[String(event)] = callback;
};

poi.dispatch = function(event){
    var e = String(event);
    poi.callbacks[e](e);
};

poi.run = function(){
    var count = 0;
    var id = setInterval(
        function(){
            var acc = goldfish.accelerometer();
            if(acc.x < -9){
                if(count > 0) count = 0;
                count--;
                if(count < -10){
                    clearInterval(id);
                    poi.dispatch('copy');
                }
            }
            else if(9 < acc.x){
                if(count < 0) count = 0;
                count++;
                if(10 < count){
                    clearInterval(id);
                    poi.dispatch('paste');
                }
            }
        }, 10
    );    
};

poi.request = function(action){
    if(action == null || action.length < 1) return;
    $.ajax(
        {
            url : app_root+'/tag/'+goldfish.tag()+'/'+action,
            data : {
                poi : goldfish.id()
            },
            success : function(e){
                if(action == 'paste'){
                    $('#result').html('pasted');
                    // goldfish.finish();
                }
                else{
                    $('#result').html(e);
                }
            },
            error : function(e){
                $('#result').html('error');
            },
            complete : function(e){
                $('.panel').hide();
                $('#result').show();
            },
            type : 'POST',
            dataType : 'text'
        }
    );
};
