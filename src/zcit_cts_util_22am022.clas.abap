CLASS zcit_cts_util_22am022 DEFINITION
  PUBLIC FINAL CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_ship_hdr,
             shipmentid TYPE c LENGTH 10,
           END OF ty_ship_hdr,
           BEGIN OF ty_ship_itm,
             shipmentid TYPE c LENGTH 10,
             itemnumber TYPE int2,
           END OF ty_ship_itm.
    TYPES: tt_ship_hdr TYPE STANDARD TABLE OF ty_ship_hdr,
           tt_ship_itm TYPE STANDARD TABLE OF ty_ship_itm.

    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zcit_cts_util_22am022.

    METHODS:
      set_hdr_value IMPORTING im_hdr     TYPE zcit_ship22am022
                    EXPORTING ex_created TYPE abap_boolean,
      get_hdr_value EXPORTING ex_hdr     TYPE zcit_ship22am022,
      set_itm_value IMPORTING im_itm     TYPE zcit_shpi22am022
                    EXPORTING ex_created TYPE abap_boolean,
      get_itm_value EXPORTING ex_itm     TYPE zcit_shpi22am022,
      set_hdr_for_deletion  IMPORTING im_hdr_key TYPE ty_ship_hdr,
      set_itm_for_deletion  IMPORTING im_itm_key TYPE ty_ship_itm,
      get_hdrs_for_deletion EXPORTING ex_hdrs    TYPE tt_ship_hdr,
      get_itms_for_deletion EXPORTING ex_itms    TYPE tt_ship_itm,
      set_hdr_delete_flag   IMPORTING im_flag    TYPE abap_boolean,
      get_delete_flags      EXPORTING ex_hdr_del TYPE abap_boolean,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA gs_hdr_buff TYPE zcit_ship22am022.
    CLASS-DATA gs_itm_buff TYPE zcit_shpi22am022.
    CLASS-DATA gt_del_hdrs TYPE tt_ship_hdr.
    CLASS-DATA gt_del_itms TYPE tt_ship_itm.
    CLASS-DATA gv_hdr_del  TYPE abap_boolean.
    CLASS-DATA mo_instance TYPE REF TO zcit_cts_util_22am022.
ENDCLASS.

CLASS zcit_cts_util_22am022 IMPLEMENTATION.
  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    IF im_hdr-shipmentid IS NOT INITIAL.
      gs_hdr_buff = im_hdr.
      ex_created  = abap_true.
    ENDIF.
  ENDMETHOD.
  METHOD get_hdr_value.  ex_hdr = gs_hdr_buff.  ENDMETHOD.

  METHOD set_itm_value.
    IF im_itm IS NOT INITIAL.
      gs_itm_buff = im_itm.
      ex_created  = abap_true.
    ENDIF.
  ENDMETHOD.
  METHOD get_itm_value.  ex_itm = gs_itm_buff.  ENDMETHOD.

  METHOD set_hdr_for_deletion.  APPEND im_hdr_key TO gt_del_hdrs.  ENDMETHOD.
  METHOD set_itm_for_deletion.  APPEND im_itm_key TO gt_del_itms.  ENDMETHOD.
  METHOD get_hdrs_for_deletion. ex_hdrs = gt_del_hdrs. ENDMETHOD.
  METHOD get_itms_for_deletion. ex_itms = gt_del_itms. ENDMETHOD.
  METHOD set_hdr_delete_flag.   gv_hdr_del = im_flag.  ENDMETHOD.
  METHOD get_delete_flags.      ex_hdr_del = gv_hdr_del. ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gs_hdr_buff, gs_itm_buff, gt_del_hdrs, gt_del_itms, gv_hdr_del.
  ENDMETHOD.
ENDCLASS.
