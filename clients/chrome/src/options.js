$(
    function(){
        $('#nfc_tag').val(localStorage.nfc_tag||"a1b2ce34df");
        $('#btn_save').click(
            function(){
                localStorage.nfc_tag = $('#nfc_tag').val();
                alert('saved!');
            }
        );
    }
);
