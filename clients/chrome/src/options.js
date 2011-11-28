var log = function(msg){
    console.log(msg);
    $('#notify').html(msg).fadeIn(
        'slow',
        function(){
            $(this).fadeOut(1000);
        }
    );
};

$(
    function(){
        $('#nfc_tag').val(localStorage.nfc_tag||"your-nfc-tag-id");
        $('#btn_save').click(
            function(){
                localStorage.nfc_tag = $('#nfc_tag').val();
                log('saved!');
            }
        );
    }
);
