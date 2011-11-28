$(
    function(){
        $('#nfc_tag').val(localStorage.nfc_tag);
        $('#btn_save').click(
            function(){
                localStorage.nfc_tag = $('#nfc_tag').val();
                alert('saved!');
            }
        );
    }
);
