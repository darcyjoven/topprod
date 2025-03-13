# Prog. Version..: '5.30.06-13.03.12(00001)'     #
######################################################################
#
# NOTE:
#	   Maker: '{%}' means this block needed to do modification by hand
#	Variable: 'g_strXMLInput' means XML string sending to EasyFlow
#	Varaible: 'g_formNum' means form number, could be used in SQL as key value
#
#	Ohter variables refer to 'awsef.4gl' if need to use it
#
######################################################################
# Modify.........: No:FUN-CA0001 12/10/23 By Abby 新建立 

DATABASE ds
#FUN-CA0001

#---------------------------------------------------------------------
# Include global variable file: awsef.4gl
# *Don't need to change
#---------------------------------------------------------------------
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"

#---------------------------------------------------------------------
# Function name is: aws_efcli2_cf()
# *Don't need to change
#---------------------------------------------------------------------
FUNCTION aws_efcli2_cf()

#---------------------------------------------------------------------
# *CHECK POINT:
#	Define variable record that retrieves data from SQL
#	If needed, add other variable using by this program
#---------------------------------------------------------------------
    DEFINE sr	RECORD
{%}		        oqt01   LIKE oqt_file.oqt01,
			oqt02	LIKE oqt_file.oqt02,
			oqt23	LIKE oqt_file.oqt23,
			oqt04	LIKE oqt_file.oqt04,
			oqt041	LIKE oqt_file.oqt041,
			oqt03	LIKE oqt_file.oqt03,
			oqt07	LIKE oqt_file.oqt07,
			oqt06	LIKE oqt_file.oqt06,
			oqt09	LIKE oqt_file.oqt09,
                        oqt24   LIKE oqt_file.oqt24,
			oqt10	LIKE oqt_file.oqt10,
                        oqt25   LIKE oqt_file.oqt25,
			oqt11	LIKE oqt_file.oqt11,
                        oqt26   LIKE oqt_file.oqt26,
                        oqt27   LIKE oqt_file.oqt27,
			oqt08	LIKE oqt_file.oqt08,
			oqt12	LIKE oqt_file.oqt12,
			oqu02	LIKE oqu_file.oqu02,
			oqu03	LIKE oqu_file.oqu03,
			oqu04	LIKE oqu_file.oqu04,
			oqu031	LIKE oqu_file.oqu031,
			oqu032	LIKE oqu_file.oqu032,
			oqu09	LIKE oqu_file.oqu09,
			oqu10	LIKE oqu_file.oqu10,
			oqu14	LIKE oqu_file.oqu14,
			oqu08	LIKE oqu_file.oqu08,
			oqw02	LIKE oqw_file.oqw02,
			oqu05	LIKE oqu_file.oqu05,
			oqu06	LIKE oqu_file.oqu06,
			oqu07	LIKE oqu_file.oqu07,
			oqu11	LIKE oqu_file.oqu11,
			oqu12	LIKE oqu_file.oqu12,
			oqu13	LIKE oqu_file.oqu13 
                END RECORD,
           l_i		LIKE type_file.num5,          #SMALLINT
           l_sql	LIKE type_file.chr1000,       #CHAR(1000)
           l_owner      STRING 
    DEFINE sr1  RECORD
                        oqv03   LIKE oqv_file.oqv03,
                        oqv04   LIKE oqv_file.oqv04,
                        oqv05   LIKE oqv_file.oqv05
                END RECORD,
           l_j          LIKE type_file.num5          #SMALLINT
    DEFINE l_gen02    LIKE gen_file.gen02,
           l_gem02    LIKE gem_file.gem02,
           l_oah02    LIKE oah_file.oah02,
           l_ged02    LIKE ged_file.ged02

    WHENEVER ERROR CALL cl_err_msg_log

#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
    LET l_sql =
{%}		"SELECT oqt01, oqt02, oqt23, oqt04, oqt041, oqt03, oqt07, oqt06, oqt09, oqt24, oqt10, oqt25, oqt11, oqt26, oqt27, oqt08, oqt12,",
  		" oqu02, oqu03, oqu04, oqu031, oqu032, oqu09, oqu10, oqu14, oqu08, oqw02, oqu05, oqu06, oqu07, oqu11, oqu12, oqu13",
                "  FROM oqt_file, oqu_file, OUTER oqw_file",
                " WHERE oqt01 = oqu01 ",
                "   AND oqw_file.oqw01 = oqu08 ",
                "   AND oqt01 = '", g_formNum CLIPPED, "'"
    PREPARE ef_pre FROM l_sql
    IF STATUS THEN
       CALL cl_err('prepare: ', STATUS, 0)
       LET g_strXMLInput = ''
       RETURN
    END IF
    DECLARE ef_cur CURSOR FOR ef_pre

    DECLARE oqv_cur CURSOR FOR SELECT oqv03, oqv04, oqv05
                                 FROM oqv_file 
                                WHERE oqv01 = ? AND oqv02 = ?

    LET l_i = 1
    FOREACH ef_cur INTO sr.*
        IF STATUS THEN
           CALL cl_err('foreach: ', STATUS, 0)
           LET g_strXMLInput = ''
           RETURN
        END IF

        IF l_i = 1 THEN

#---------------------------------------------------------------------
# *CHECK POINT:
#	Call aws_efcli2_XMLHeader() to compose XML Header
#	Pass corresponding formCreator & formOwner value as parameters
#---------------------------------------------------------------------
      


{%}        CALL aws_efcli2_XMLHeader()

           IF NOT cl_null(sr.oqt07) THEN
              SELECT gen02 INTO l_gen02 FROM gen_file  WHERE gen01 = sr.oqt07
           END IF

           IF NOT cl_null(sr.oqt06) THEN
              SELECT gem02 INTO l_gem02 FROM gem_file  WHERE gem01 = sr.oqt06
           END IF

           IF NOT cl_null(sr.oqt10) THEN
              SELECT oah02 INTO l_oah02 FROM oah_file  WHERE oah01 = sr.oqt10
           END IF

           IF NOT cl_null(sr.oqt11) THEN
              SELECT ged02 INTO l_ged02 FROM ged_file  WHERE ged01 = sr.oqt11
           END IF

#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           LET g_strXMLInput = g_strXMLInput CLIPPED,
               "     <oqt01>", sr.oqt01 CLIPPED, "</oqt01>", ASCII 10,
               "     <oqt02>", sr.oqt02 CLIPPED, "</oqt02>", ASCII 10,
               "     <oqt23>", sr.oqt23 CLIPPED, "</oqt23>", ASCII 10,
               "     <oqt04>", sr.oqt04 CLIPPED, "</oqt04>", ASCII 10,
               "     <oqt041>", sr.oqt041 CLIPPED, "</oqt041>", ASCII 10,
               "     <oqt03>", sr.oqt03 CLIPPED, "</oqt03>", ASCII 10,
               "     <oqt07>", sr.oqt07 CLIPPED, "</oqt07>", ASCII 10,
               "     <oqt06>", sr.oqt06 CLIPPED, "</oqt06>", ASCII 10,
               "     <oqt09>", sr.oqt09 CLIPPED, "</oqt09>", ASCII 10,
               "     <oqt24>", sr.oqt24 CLIPPED, "</oqt24>", ASCII 10,
               "     <oqt10>", sr.oqt10 CLIPPED, "</oqt10>", ASCII 10,
               "     <oqt25>", sr.oqt25 CLIPPED, "</oqt25>", ASCII 10,
               "     <oqt11>", sr.oqt11 CLIPPED, "</oqt11>", ASCII 10,
               "     <oqt26>", sr.oqt26 CLIPPED, "</oqt26>", ASCII 10,
               "     <oqt27>", sr.oqt27 CLIPPED, "</oqt27>", ASCII 10,
               "     <oqt08>", sr.oqt08 CLIPPED, "</oqt08>", ASCII 10,
               "     <oqt12>", sr.oqt12 CLIPPED, "</oqt12>", ASCII 10,
               "     <gen02>", l_gen02 CLIPPED, "</gen02>", ASCII 10,
               "     <gem02>", l_gem02 CLIPPED, "</gem02>", ASCII 10,
               "     <oah02>", l_oah02 CLIPPED, "</oah02>", ASCII 10,
               "     <ged02>", l_ged02 CLIPPED, "</ged02>", ASCII 10,
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
        END IF

#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose detail data
#	Modify tag name & corresponding value if want to use another one
#	If this program hasn't detail data, don't need to care about this block
#---------------------------------------------------------------------
        CASE sr.oqt12
           WHEN 'Y'
              LET l_j = 1
              FOREACH oqv_cur USING sr.oqt01, sr.oqu02 INTO sr1.*
                  IF l_j = 1 THEN
                     LET g_strXMLInput = g_strXMLInput CLIPPED,
                         "     <record>", ASCII 10,
{%}                      "      <oqu02>", sr.oqu02 CLIPPED, "</oqu02>", ASCII 10,
                         "      <oqu03>", sr.oqu03 CLIPPED, "</oqu03>", ASCII 10,
                         "      <oqu04>", sr.oqu04 CLIPPED, "</oqu04>", ASCII 10,
                         "      <oqu031>", sr.oqu031 CLIPPED, "</oqu031>", ASCII 10,
                         "      <oqu032>", sr.oqu032 CLIPPED, "</oqu032>", ASCII 10,
                         "      <oqu09>", sr.oqu09 CLIPPED, "</oqu09>", ASCII 10,
                         "      <oqu10>", sr.oqu10 CLIPPED, "</oqu10>", ASCII 10,
                         "      <oqu14>", sr.oqu14 CLIPPED, "</oqu14>", ASCII 10,
                         "      <oqu08>", sr.oqu08 CLIPPED, "</oqu08>", ASCII 10,
                         "      <oqw02>", sr.oqw02 CLIPPED, "</oqw02>", ASCII 10,
                         "      <oqu05>", sr.oqu05 CLIPPED, "</oqu05>", ASCII 10,
                         "      <oqu06>", sr.oqu06 CLIPPED, "</oqu06>", ASCII 10,
                         "      <oqu07>", sr.oqu07 CLIPPED, "</oqu07>", ASCII 10,
                         "      <oqu11>", sr.oqu11 CLIPPED, "</oqu11>", ASCII 10,
                         "      <oqu12>", sr.oqu12 CLIPPED, "</oqu12>", ASCII 10,
                         "      <oqu13>", sr.oqu13 CLIPPED, "</oqu13>", ASCII 10,
                         "      <oqv03>", sr1.oqv03 CLIPPED, "</oqv03>", ASCII 10,
                         "      <oqv04>", sr1.oqv04 CLIPPED, "</oqv04>", ASCII 10,
                         "      <oqv05>", sr1.oqv05 CLIPPED, "</oqv05>", ASCII 10,
                         "     </record>", ASCII 10
                  ELSE
                     LET g_strXMLInput = g_strXMLInput CLIPPED,
                         "     <record>", ASCII 10, 
                         "      <oqu02></oqu02>", ASCII 10,
                         "      <oqu03></oqu03>", ASCII 10,
                         "      <oqu04></oqu04>", ASCII 10,
                         "      <oqu031></oqu031>", ASCII 10,
                         "      <oqu032></oqu032>", ASCII 10,
                         "      <oqu09></oqu09>", ASCII 10,
                         "      <oqu10></oqu10>", ASCII 10,
                         "      <oqu14></oqu14>", ASCII 10,
                         "      <oqu08></oqu08>", ASCII 10,
                         "      <oqw02></oqw02>", ASCII 10,
                         "      <oqu05></oqu05>", ASCII 10,
                         "      <oqu06></oqu06>", ASCII 10,
                         "      <oqu07></oqu07>", ASCII 10,
                         "      <oqu11></oqu11>", ASCII 10,
                         "      <oqu12></oqu12>", ASCII 10,
                         "      <oqu13></oqu13>", ASCII 10,
                         "      <oqv03>", sr1.oqv03 CLIPPED, "</oqv03>", ASCII 10,
                         "      <oqv04>", sr1.oqv04 CLIPPED, "</oqv04>", ASCII 10,
                         "      <oqv05>", sr1.oqv05 CLIPPED, "</oqv05>", ASCII 10,
                         "     </record>", ASCII 10
                  END IF

                  LET l_j = l_j + 1
              END FOREACH
           OTHERWISE
              LET g_strXMLInput = g_strXMLInput CLIPPED,
                  "     <record>", ASCII 10,
{%}               "      <oqu02>", sr.oqu02 CLIPPED, "</oqu02>", ASCII 10,
                  "      <oqu03>", sr.oqu03 CLIPPED, "</oqu03>", ASCII 10,
                  "      <oqu04>", sr.oqu04 CLIPPED, "</oqu04>", ASCII 10,
                  "      <oqu031>", sr.oqu031 CLIPPED, "</oqu031>", ASCII 10,
                  "      <oqu032>", sr.oqu032 CLIPPED, "</oqu032>", ASCII 10,
                  "      <oqu09>", sr.oqu09 CLIPPED, "</oqu09>", ASCII 10,
                  "      <oqu10>", sr.oqu10 CLIPPED, "</oqu10>", ASCII 10,
                  "      <oqu14>", sr.oqu14 CLIPPED, "</oqu14>", ASCII 10,
                  "      <oqu08>", sr.oqu08 CLIPPED, "</oqu08>", ASCII 10,
                  "      <oqw02>", sr.oqw02 CLIPPED, "</oqw02>", ASCII 10,
                  "      <oqu05>", sr.oqu05 CLIPPED, "</oqu05>", ASCII 10,
                  "      <oqu06>", sr.oqu06 CLIPPED, "</oqu06>", ASCII 10,
                  "      <oqu07>", sr.oqu07 CLIPPED, "</oqu07>", ASCII 10,
                  "      <oqu11>", sr.oqu11 CLIPPED, "</oqu11>", ASCII 10,
                  "      <oqu12>", sr.oqu12 CLIPPED, "</oqu12>", ASCII 10,
                  "      <oqu13>", sr.oqu13 CLIPPED, "</oqu13>", ASCII 10,
                  "     </record>", ASCII 10
        END CASE

        LET l_i = l_i + 1
    END FOREACH

#---------------------------------------------------------------------
# Call aws_efcli2_XMLTrailer() to compose XML Trailer
# *Don't need to change
#---------------------------------------------------------------------
    LET g_strXMLInput = g_strXMLInput CLIPPED,
                        "    </body>", ASCII 10

    CALL aws_efcli2_XMLTrailer()
END FUNCTION
