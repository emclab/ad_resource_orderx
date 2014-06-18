// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
    return $('#order_customer_name_autocomplete').autocomplete({
        minLength: 1,
        source: $('#order_customer_name_autocomplete').data('autocomplete-source'),  //'#..' can NOT be replaced with this
        select: function(event, ui) {
            //alert('fired!');
            $('#order_customer_name_autocomplete').val(ui.item.value);
        },
    });
});

$(function() {
	$( "#order_order_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#order_order_start_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#order_order_end_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#order_gm_approved_by_date" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#order_start_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
	$( "#order_end_date_s" ).datepicker({dateFormat: 'yy-mm-dd'});
});