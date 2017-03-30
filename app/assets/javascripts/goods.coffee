# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#goods').dataTable
    sPaginationType: "full_numbers"
    bJQueryUI: true
    bProcessing: true
    bServerSide: true
    aoColumnDefs: [
      { bSortable: false, aTargets: [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ] }
    ]
    sAjaxSource: $('#goods').data('source')