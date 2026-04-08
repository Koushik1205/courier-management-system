CLASS lhc_ShipItem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE ShipItem.
    METHODS delete FOR MODIFY IMPORTING keys    FOR DELETE ShipItem.
    METHODS read   FOR READ   IMPORTING keys    FOR READ   ShipItem RESULT result.
    METHODS rba_ShipHeader FOR READ
      IMPORTING keys_rba FOR READ ShipItem\_ShipHeader
      FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_ShipItem IMPLEMENTATION.
  METHOD update.
    DATA ls_itm TYPE zcit_shpi22am022.
    LOOP AT entities INTO DATA(ls_entity).
      ls_itm = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).
      IF ls_itm-shipmentid IS NOT INITIAL.
        SELECT SINGLE FROM zcit_shpi22am022 FIELDS shipmentid
          WHERE shipmentid = @ls_itm-shipmentid
            AND itemnumber = @ls_itm-itemnumber
          INTO @DATA(lv_ex).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcit_cts_util_22am022=>get_instance( ).
          lo_util->set_itm_value( EXPORTING im_itm = ls_itm
                                  IMPORTING ex_created = DATA(lv_ok) ).
          IF lv_ok EQ abap_true.
            APPEND VALUE #( shipmentid = ls_itm-shipmentid
                            itemnumber = ls_itm-itemnumber ) TO mapped-shipitem.
            APPEND VALUE #( %key = ls_entity-%key
                            %msg = new_message( id = 'ZCIT_CTS_22AM022'
                                                number = 001
                                                v1 = 'Item Updated'
                                                severity = if_abap_behv_message=>severity-success )
                          ) TO reported-shipitem.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entity-%cid_ref
                          shipmentid = ls_itm-shipmentid
                          itemnumber = ls_itm-itemnumber ) TO failed-shipitem.
          APPEND VALUE #( %cid = ls_entity-%cid_ref
                          shipmentid = ls_itm-shipmentid
                          %msg = new_message( id = 'ZCIT_CTS_22AM022'
                                              number = 003
                                              v1 = 'Item Not Found'
                                              severity = if_abap_behv_message=>severity-error )
                        ) TO reported-shipitem.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_util) = zcit_cts_util_22am022=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      lo_util->set_itm_for_deletion(
        im_itm_key = VALUE #( shipmentid = ls_key-shipmentid
                              itemnumber = ls_key-itemnumber ) ).
      APPEND VALUE #( %cid = ls_key-%cid_ref
                      shipmentid = ls_key-shipmentid
                      itemnumber = ls_key-itemnumber
                      %msg = new_message( id = 'ZCIT_CTS_22AM022'
                                          number = 001
                                          v1 = 'Package Item Deleted'
                                          severity = if_abap_behv_message=>severity-success )
                    ) TO reported-shipitem.
    ENDLOOP.
  ENDMETHOD.

  METHOD read. ENDMETHOD.
  METHOD rba_ShipHeader. ENDMETHOD.
ENDCLASS.
