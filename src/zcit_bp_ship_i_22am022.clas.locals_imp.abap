CLASS lsc_ZCIT_SHIP_I DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize        REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save            REDEFINITION.
    METHODS cleanup         REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_ZCIT_SHIP_I IMPLEMENTATION.
  METHOD finalize.         ENDMETHOD.
  METHOD check_before_save. ENDMETHOD.
  METHOD cleanup_finalize. ENDMETHOD.

  METHOD save.
    DATA(lo_util) = zcit_cts_util_22am022=>get_instance( ).

    lo_util->get_hdr_value( IMPORTING ex_hdr = DATA(ls_hdr) ).
    lo_util->get_itm_value( IMPORTING ex_itm = DATA(ls_itm) ).
    lo_util->get_hdrs_for_deletion( IMPORTING ex_hdrs = DATA(lt_del_hdrs) ).
    lo_util->get_itms_for_deletion( IMPORTING ex_itms = DATA(lt_del_itms) ).
    lo_util->get_delete_flags( IMPORTING ex_hdr_del = DATA(lv_del_hdr) ).

    " 1 – Persist / update Header
    IF ls_hdr IS NOT INITIAL.
      MODIFY zcit_ship22am022 FROM @ls_hdr.
    ENDIF.

    " 2 – Persist / update Item
    IF ls_itm IS NOT INITIAL.
      MODIFY zcit_shpi22am022 FROM @ls_itm.
    ENDIF.

    " 3 – Handle deletions
    IF lv_del_hdr = abap_true.
      " Header delete -> cascade delete all its items too
      LOOP AT lt_del_hdrs INTO DATA(ls_del_h).
        DELETE FROM zcit_ship22am022  WHERE shipmentid = @ls_del_h-shipmentid.
        DELETE FROM zcit_shpi22am022  WHERE shipmentid = @ls_del_h-shipmentid.
      ENDLOOP.
    ELSE.
      " Only individual header rows
      LOOP AT lt_del_hdrs INTO ls_del_h.
        DELETE FROM zcit_ship22am022 WHERE shipmentid = @ls_del_h-shipmentid.
      ENDLOOP.
      " Individual item rows
      LOOP AT lt_del_itms INTO DATA(ls_del_i).
        DELETE FROM zcit_shpi22am022
          WHERE shipmentid = @ls_del_i-shipmentid
            AND itemnumber = @ls_del_i-itemnumber.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    zcit_cts_util_22am022=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.
ENDCLASS.
