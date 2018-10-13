CLASS ltcl_zcl_trip_distance_sum DEFINITION DEFERRED.
CLASS zcl_trip_distance_sum DEFINITION LOCAL FRIENDS ltcl_zcl_trip_distance_sum.
CLASS ltcl_zcl_trip_distance_sum DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS:
      first_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_zcl_trip_distance_sum IMPLEMENTATION.

  METHOD first_test.
    DATA(lo_cut) =   NEW zcl_trip_distance_sum(  ).


    lo_cut->mt_all_flight_data =  VALUE #(
(   MANDT = '100'   CARRID = 'JL'   CONNID = '0407' COUNTRYFR = 'JP'    CITYFROM = 'TOKYO'  AIRPFROM = 'NRT'
COUNTRYTO = 'DE'    CITYTO = 'FRANKFURT'    AIRPTO = 'FRA'  FLTIME = '725 ' DEPTIME = '133000'
ARRTIME = '173500'  DISTANCE = '9100.0000 ' DISTID = 'KM'   )
(   MANDT = '100'   CARRID = 'JL'   CONNID = '0408' COUNTRYFR = 'DE'    CITYFROM = 'FRANKFURT'  AIRPFROM = 'FRA'
COUNTRYTO = 'JP'    CITYTO = 'TOKYO'    AIRPTO = 'NRT'  FLTIME = '675 ' DEPTIME = '202500'
ARRTIME = '154000'  DISTANCE = '9100.0000 ' DISTID = 'KM'   FLTYPE = 'X'    PERIOD = '1 '   )
(   MANDT = '100'   CARRID = 'AZ'   CONNID = '0789' COUNTRYFR = 'JP'    CITYFROM = 'TOKYO'  AIRPFROM = 'TYO'
COUNTRYTO = 'IT'    CITYTO = 'ROME' AIRPTO = 'FCO'  FLTIME = '940 ' DEPTIME = '114500'
ARRTIME = '192500'  DISTANCE = '6130.0000 ' DISTID = 'MI'   )
    ).




    lo_cut->build_sum( ).

    cl_abap_unit_assert=>assert_equals(
      EXPORTING
        act                  = lo_cut->ms_distance_sum-distance    " Data object with current value
        exp                  = CONV s_distance( '28065.2787' )    " Data object with expected type
    ).
  ENDMETHOD.

ENDCLASS.
