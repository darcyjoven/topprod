# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
######################################################################
#
# NOTE:
#	   Maker: '' means this block needed to do modification by hand
#	Variable: 'g_strXMLInput' means XML string sending to EasyFlow
#	Varaible: 'g_formNum' means form number, could be used in SQL as key value
#
#	Ohter variables refer to 'awsef.4gl' if need to use it
#
######################################################################
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#---------------------------------------------------------------------
# Include global variable file: awsef.4gl
# *Don't need to change
#---------------------------------------------------------------------
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
 
#---------------------------------------------------------------------
# Function name is: aws_efcli_cf()
# *Don't need to change
#---------------------------------------------------------------------
FUNCTION aws_efcli_cf()
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Define variable record that retrieves data from SQL
#	If needed, add other variable using by this program
#---------------------------------------------------------------------
    DEFINE sr	RECORD
			gem02	LIKE gem_file.gem02,
			gen02	LIKE gen_file.gen02,
			oqt01	LIKE oqt_file.oqt01,
			oqt02	LIKE oqt_file.oqt02,
			oqt03	LIKE oqt_file.oqt03,
			oqt04	LIKE oqt_file.oqt04,
			oqt041	LIKE oqt_file.oqt041,
			oqt06	LIKE oqt_file.oqt06,
			oqt07	LIKE oqt_file.oqt07,
			oqt08	LIKE oqt_file.oqt08,
			oqt09	LIKE oqt_file.oqt09,
			oqt10	LIKE oqt_file.oqt10,
			oqt11	LIKE oqt_file.oqt11,
			oqt12	LIKE oqt_file.oqt12,
			oqt22	LIKE oqt_file.oqt22,
			oqtuser	LIKE oqt_file.oqtuser,
			oqu02	LIKE oqu_file.oqu02,
			oqu03	LIKE oqu_file.oqu03,
			oqu031	LIKE oqu_file.oqu031,
			oqu032	LIKE oqu_file.oqu032,
			oqu04	LIKE oqu_file.oqu04,
			oqu05	LIKE oqu_file.oqu05,
			oqu06	LIKE oqu_file.oqu06,
			oqu07	LIKE oqu_file.oqu07,
			oqu08	LIKE oqu_file.oqu08,
			oqu09	LIKE oqu_file.oqu09,
			oqu10	LIKE oqu_file.oqu10,
			oqu11	LIKE oqu_file.oqu11,
			oqu12	LIKE oqu_file.oqu12,
			oqu13	LIKE oqu_file.oqu13
           	END RECORD,
           l_i		LIKE type_file.num5,         #No.FUN-680130 SMALLINT
           l_sql	LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(1000)
 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
    LET l_sql =
		"SELECT gem02, gen02, oqt01, oqt02, oqt03, oqt04, oqt041,",
		" oqt06, oqt07, oqt08, oqt09, oqt10, oqt11, oqt12, oqt22,",
		" oqtuser, oqu02, oqu03, oqu031, oqu032, oqu04, oqu05, oqu06,",
		" oqu07, oqu08, oqu09, oqu10, oqu11, oqu12, oqu13",
                "  FROM oqt_file, oqu_file, OUTER gem_file, OUTER gen_file",
                " WHERE oqt01 = oqu01 ",
                "   AND gen_file.gen01 = oqt07 ",
                "   AND gem_file.gem01 = oqt06 ",
                "   AND oqt01 = '", g_formNum CLIPPED, "'"
 
    PREPARE ef_pre FROM l_sql
    IF STATUS THEN
       CALL cl_err('prepare: ', STATUS, 0)
       LET g_strXMLInput = ''
       RETURN
    END IF
    DECLARE ef_cur CURSOR FOR ef_pre
 
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
#	Call aws_efcli_XMLHeader() to compose XML Header
#	Pass corresponding formCreator & formOwner value as parameters
#---------------------------------------------------------------------
        CALL aws_efcli_XMLHeader(sr.oqtuser, sr.oqt07)
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           LET g_strXMLInput = g_strXMLInput CLIPPED,
               "     <oqt01>", sr.oqt01 CLIPPED, "</oqt01>", ASCII 10,
               "     <oqt02>", sr.oqt02 CLIPPED, "</oqt02>", ASCII 10,
               "     <oqt03>", sr.oqt03 CLIPPED, "</oqt03>", ASCII 10,
               "     <oqt04>", sr.oqt04 CLIPPED, "</oqt04>", ASCII 10,
               "     <oqt041>", sr.oqt041 CLIPPED, "</oqt041>", ASCII 10,
               "     <oqt06>", sr.oqt06 CLIPPED, ' ', sr.gem02 CLIPPED, "</oqt06>", ASCII 10,
               "     <oqt07>", sr.oqt07 CLIPPED, ' ', sr.gen02 CLIPPED, "</oqt07>", ASCII 10,
               "     <oqt08>", sr.oqt08 CLIPPED, "</oqt08>", ASCII 10,
               "     <oqt09>", sr.oqt09 CLIPPED, "</oqt09>", ASCII 10,
               "     <oqt10>", sr.oqt10 CLIPPED, "</oqt10>", ASCII 10,
               "     <oqt11>", sr.oqt11 CLIPPED, "</oqt11>", ASCII 10,
               "     <oqt12>", sr.oqt12 CLIPPED, "</oqt12>", ASCII 10,
               "     <oqt22>", sr.oqt22 CLIPPED, "</oqt22>", ASCII 10,
               "     <oqtuser>", sr.oqtuser CLIPPED, "</oqtuser>", ASCII 10,
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
        END IF
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose detail data
#	Modify tag name & corresponding value if want to use another one
#	If this program hasn't detail data, don't need to care about this block
#---------------------------------------------------------------------
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
         "      <oqu02>", sr.oqu02 CLIPPED, "</oqu02>", ASCII 10,
            "      <oqu03>", sr.oqu03 CLIPPED, "</oqu03>", ASCII 10,
            "      <oqu031>", sr.oqu031 CLIPPED, "</oqu031>", ASCII 10,
            "      <oqu032>", sr.oqu032 CLIPPED, "</oqu032>", ASCII 10,
            "      <oqu04>", sr.oqu04 CLIPPED, "</oqu04>", ASCII 10,
            "      <oqu05>", sr.oqu05 CLIPPED, "</oqu05>", ASCII 10,
            "      <oqu06>", sr.oqu06 CLIPPED, "</oqu06>", ASCII 10,
            "      <oqu07>", sr.oqu07 CLIPPED, "</oqu07>", ASCII 10,
            "      <oqu08>", sr.oqu08 CLIPPED, "</oqu08>", ASCII 10,
            "      <oqu09>", sr.oqu09 CLIPPED, "</oqu09>", ASCII 10,
            "      <oqu10>", sr.oqu10 CLIPPED, "</oqu10>", ASCII 10,
            "      <oqu11>", sr.oqu11 CLIPPED, "</oqu11>", ASCII 10,
            "      <oqu12>", sr.oqu12 CLIPPED, "</oqu12>", ASCII 10,
            "      <oqu13>", sr.oqu13 CLIPPED, "</oqu13>", ASCII 10,
            "     </record>", ASCII 10
 
        LET l_i = l_i + 1
    END FOREACH
 
#---------------------------------------------------------------------
# Call aws_efcli_XMLTrailer() to compose XML Trailer
# *Don't need to change
#---------------------------------------------------------------------
    CALL aws_efcli_XMLTrailer()
END FUNCTION
