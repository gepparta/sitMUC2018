CLASS zcl_trip_distance_sum DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: run.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ts_flight,
             carr_id TYPE s_carr_id,
             conn_id TYPE s_conn_id,
           END OF ts_flight,
           tt_flights TYPE STANDARD TABLE OF ts_flight WITH EMPTY KEY,
           BEGIN OF ts_distance,
             distance      TYPE s_distance,
             distance_unit TYPE s_distid,
           END OF ts_distance.

    DATA: mt_flights         TYPE                   tt_flights,
          mo_user_input      TYPE REF TO            if_demo_input,
          ms_distance_sum    TYPE                   ts_distance,
          mt_all_flight_data TYPE STANDARD TABLE OF spfli WITH KEY carrid connid.


    METHODS:
      get_distances,
      get_cities_of_trips,
      calculate_sum,
      show_result,
      add_fields_for_flight_no
        IMPORTING
          iv_number TYPE i
        CHANGING
          cs_flight TYPE zcl_trip_distance_sum=>ts_flight,
      build_sum.
ENDCLASS.



CLASS zcl_trip_distance_sum IMPLEMENTATION.


  METHOD run.
    get_cities_of_trips( ).
    calculate_sum( ).
    show_result( ).
  ENDMETHOD.


  METHOD get_cities_of_trips.

    DATA: ls_flight_1 TYPE ts_flight,
          ls_flight_2 TYPE ts_flight,
          ls_flight_3 TYPE ts_flight,
          lv_number   TYPE i VALUE 1.

    mo_user_input = cl_demo_input=>new( ).

    add_fields_for_flight_no( EXPORTING iv_number = 1 CHANGING cs_flight = ls_flight_1 ).
    add_fields_for_flight_no( EXPORTING iv_number = 2 CHANGING cs_flight = ls_flight_2 ).
    add_fields_for_flight_no( EXPORTING iv_number = 3 CHANGING cs_flight = ls_flight_3 ).

    mo_user_input->request( ).

    IF ls_flight_1 IS NOT INITIAL.
      APPEND ls_flight_1 TO mt_flights.
    ENDIF.
    IF ls_flight_2 IS NOT INITIAL.
      APPEND ls_flight_2 TO mt_flights.
    ENDIF.
    IF ls_flight_3 IS NOT INITIAL.
      APPEND ls_flight_3 TO mt_flights.
    ENDIF.

  ENDMETHOD.


  METHOD calculate_sum.
    get_distances( ).
    build_sum( ).
  ENDMETHOD.


  METHOD get_distances.

    LOOP AT mt_flights INTO DATA(ls_flight).
      SELECT *
          FROM spfli
              APPENDING TABLE @mt_all_flight_data
                  WHERE carrid EQ @ls_flight-carr_id AND
                        connid EQ @ls_flight-conn_id.
    ENDLOOP.
  ENDMETHOD.

  METHOD build_sum.
    CHECK mt_all_flight_data[] IS NOT INITIAL.

    LOOP AT mt_all_flight_data INTO DATA(ls_flight_data).
        ms_distance_sum-distance = ms_distance_sum-distance  + ls_flight_data-distance.
    ENDLOOP.

    ms_distance_sum-distance_unit = |KM|. "we only fly in europe so should not be a problem
  ENDMETHOD.




  METHOD add_fields_for_flight_no.
    mo_user_input->add_field(  EXPORTING
                                  text  = |{ iv_number }. Flight - Carrier ID|
                               CHANGING
                                  field = cs_flight-carr_id   ).
    mo_user_input->add_field(  EXPORTING
                                  text  = |{ iv_number }. Flight - Connection ID|
                               CHANGING
                                  field = cs_flight-conn_id ).
  ENDMETHOD.




  METHOD show_result.
    cl_demo_output=>display(  EXPORTING data = ms_distance_sum    " Text or Data
                                        name = |Calculated distance sum of your trips|    ).
  ENDMETHOD.


ENDCLASS.
