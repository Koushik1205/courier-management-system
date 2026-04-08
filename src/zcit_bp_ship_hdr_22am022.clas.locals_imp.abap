CLASS lhc_ShipHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR ShipHeader RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations
      FOR ShipHeader RESULT result.
    METHODS create FOR MODIFY IMPORTING entities FOR CREATE ShipHeader.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE ShipHeader.
    METHODS delete FOR MODIFY IMPORTING keys    FOR DELETE ShipHeader.
    METHODS read   FOR READ   IMPORTING keys    FOR READ   ShipHeader RESULT result.
    METHODS lock   FOR LOCK   IMPORTING keys    FOR LOCK   ShipHeader.
    METHODS rba_ShipItem FOR READ
      IMPORTING keys_rba FOR READ ShipHeader\_ShipItem
      FULL result_requested RESULT result LINK association_links.
    METHODS cba_ShipItem FOR MODIFY
      IMPORTING entities_cba FOR CREATE ShipHeader\_ShipItem.
ENDCLASS.

CLASS lhc_ShipHeader IMPLEMENTATION.
  METHOD get_instance_authorizations. ENDMETHOD.
  METHOD get_global_authorizations.   ENDMETHOD.
  METHOD lock. ENDMETHOD.

  METHOD create.
    DATA ls_hdr TYPE zcit_ship22am022.
    LOOP AT entities INTO DATA(ls_entity).
      ls_hdr = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).
      IF ls_hdr-shipmentid IS NOT INITIAL.
        SELECT SINGLE FROM zcit_ship22am022 FIELDS shipmentid
          WHERE shipmentid = @ls_hdr-shipmentid
          INTO @DATA(lv_existing).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcit_cts_util_22am022=>get_instance( ).
          lo_util->set_hdr_value( EXPORTING im_hdr = ls_hdr
                                  IMPORTING ex_created = DATA(lv_ok) ).
          IF lv_ok EQ abap_true.
            APPEND VALUE #( %cid = ls_entity-%cid
                            shipmentid = ls_hdr-shipmentid ) TO mapped-shipheader.
            APPEND VALUE #( %cid = ls_entity-%cid
                            shipmentid = ls_hdr-shipmentid
                            %msg = new_message( id = 'ZCIT_CTS_22AM022'
                                                number = 001
                                                v1 = 'Shipment Created'
                                                severity = if_abap_behv_message=>severity-success )
                          ) TO reported-shipheader.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entity-%cid
                          shipmentid = ls_hdr-shipmentid ) TO failed-shipheader.
          APPEND VALUE #( %cid = ls_entity-%cid
                          shipmentid = ls_hdr-shipmentid
                          %msg = new_message( id = 'ZCIT_CTS_22AM022'
                                              number = 002
                                              v1 = 'Duplicate Shipment ID'
                                              severity = if_abap_behv_message=>severity-error )
                        ) TO reported-shipheader.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA ls_hdr TYPE zcit_ship22am022.
    LOOP AT entities INTO DATA(ls_entity).
      ls_hdr = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).
      IF ls_hdr-shipmentid IS NOT INITIAL.
        SELECT SINGLE FROM zcit_ship22am022 FIELDS shipmentid
          WHERE shipmentid = @ls_hdr-shipmentid
          INTO @DATA(lv_existing).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcit_cts_util_22am022=>get_instance( ).
          lo_util->set_hdr_value( EXPORTING im_hdr = ls_hdr
                                  IMPORTING ex_created = DATA(lv_ok) ).
          IF lv_ok EQ abap_true.
            APPEND VALUE #( shipmentid = ls_hdr-shipmentid ) TO mapped-shipheader.
            APPEND VALUE #( %key = ls_entity-%key
                            %msg = new_message( id = 'ZCIT_CTS_22AM022'
                                                number = 001
                                                v1 = 'Shipment Updated'
                                                severity = if_abap_behv_message=>severity-success )
                          ) TO reported-shipheader.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entity-%cid_ref
                          shipmentid = ls_hdr-shipmentid ) TO failed-shipheader.
          APPEND VALUE #( %cid = ls_entity-%cid_ref
                          shipmentid = ls_hdr-shipmentid
                          %msg = new_message( id = 'ZCIT_CTS_22AM022'
                                              number = 003
                                              v1 = 'Shipment Not Found'
                                              severity = if_abap_behv_message=>severity-error )
                        ) TO reported-shipheader.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_util) = zcit_cts_util_22am022=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      lo_util->set_hdr_for_deletion(
        im_hdr_key = VALUE #( shipmentid = ls_key-shipmentid ) ).
      lo_util->set_hdr_delete_flag( im_flag = abap_true ).
      APPEND VALUE #( %cid = ls_key-%cid_ref
                      shipmentid = ls_key-shipmentid
                      %msg = new_message( id = 'ZCIT_CTS_22AM022'
                                          number = 001
                                          v1 = 'Shipment Deleted'
                                          severity = if_abap_behv_message=>severity-success )
                    ) TO reported-shipheader.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zcit_ship22am022 FIELDS *
        WHERE shipmentid = @ls_key-shipmentid
        INTO @DATA(ls_hdr).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_ShipItem.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT FROM zcit_shpi22am022 FIELDS *
        WHERE shipmentid = @ls_key-shipmentid
        INTO TABLE @DATA(lt_items).
      LOOP AT lt_items INTO DATA(ls_item).
        APPEND CORRESPONDING #( ls_item ) TO result.
        APPEND VALUE #( source-shipmentid = ls_key-shipmentid
                        target-shipmentid = ls_item-shipmentid
                        target-itemnumber = ls_item-itemnumber ) TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_ShipItem.
    DATA ls_itm TYPE zcit_shpi22am022.
    LOOP AT entities_cba INTO DATA(ls_cba).
      DATA(ls_target) = ls_cba-%target[ 1 ].
      ls_itm = CORRESPONDING #( ls_target MAPPING FROM ENTITY ).
      IF ls_itm-shipmentid IS NOT INITIAL AND ls_itm-itemnumber IS NOT INITIAL.
        SELECT SINGLE FROM zcit_shpi22am022 FIELDS shipmentid
          WHERE shipmentid = @ls_itm-shipmentid
            AND itemnumber = @ls_itm-itemnumber
          INTO @DATA(lv_ex).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcit_cts_util_22am022=>get_instance( ).
          lo_util->set_itm_value( EXPORTING im_itm = ls_itm
                                  IMPORTING ex_created = DATA(lv_ok) ).
          IF lv_ok EQ abap_true.
            APPEND VALUE #( %cid       = ls_target-%cid
                            shipmentid = ls_itm-shipmentid
                            itemnumber = ls_itm-itemnumber ) TO mapped-shipitem.
            APPEND VALUE #( %cid       = ls_target-%cid
                            shipmentid = ls_itm-shipmentid
                            %msg = new_message( id       = 'ZCIT_CTS_22AM022'
                                                number   = 001
                                                v1       = 'Package Item Added'
                                                severity = if_abap_behv_message=>severity-success )
                          ) TO reported-shipitem.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid       = ls_target-%cid
                          shipmentid = ls_itm-shipmentid
                          itemnumber = ls_itm-itemnumber ) TO failed-shipitem.
          APPEND VALUE #( %cid       = ls_target-%cid
                          shipmentid = ls_itm-shipmentid
                          %msg = new_message( id       = 'ZCIT_CTS_22AM022'
                                              number   = 002
                                              v1       = 'Duplicate Package Item'
                                              severity = if_abap_behv_message=>severity-error )
                        ) TO reported-shipitem.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
