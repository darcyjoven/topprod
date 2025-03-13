# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify.........: No.FUN-680130 06/09/04 By zhuying 欄位形態定義為LIKE
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
			pmc03	LIKE pmc_file.pmc03,
			pmi01	LIKE pmi_file.pmi01,
			pmi02	LIKE pmi_file.pmi02,
			pmi03	LIKE pmi_file.pmi03,
			pmi04	LIKE pmi_file.pmi04,
			pmi05	LIKE pmi_file.pmi05,
			pmiuser	LIKE pmi_file.pmiuser,
			pmj02	LIKE pmj_file.pmj02,
			pmj03	LIKE pmj_file.pmj03,
			pmj031	LIKE pmj_file.pmj031,
			pmj032	LIKE pmj_file.pmj032,
			pmj04	LIKE pmj_file.pmj04,
			pmj05	LIKE pmj_file.pmj05,
			pmj06	LIKE pmj_file.pmj06,
			pmj07	LIKE pmj_file.pmj07,
			pmj08	LIKE pmj_file.pmj08,
			pmj09	LIKE pmj_file.pmj09,
			pmj10	LIKE pmj_file.pmj10
           	END RECORD,
           l_i		LIKE type_file.num5,          #No.FUN-680130 SMALLINT
           l_sql	LIKE type_file.chr1000,       #No.FUN-680130 VARCHAR(100)
           l_owner      STRING
    DEFINE sr1  RECORD
                        pmr03   LIKE pmr_file.pmr03,
                        pmr04   LIKE pmr_file.pmr04,
                        pmr05   LIKE pmr_file.pmr05
                END RECORD,
           l_j          LIKE type_file.num5          #No.FUN-680130 SMALLINT
 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
    LET l_sql =
		"SELECT pmc03, pmi01, pmi02, pmi03, pmi04, pmi05, pmiuser,",
		" pmj02, pmj03, pmj031, pmj032, pmj04, pmj05, pmj06, pmj07,",
		" pmj08, pmj09, pmj10",
                "  FROM pmi_file, pmj_file, OUTER pmc_file",
                " WHERE pmi01 = pmj01 ",
                "   AND pmc_file.pmc01 = pmi03 ",
                "   AND pmi01 = '", g_formNum CLIPPED, "'"
 
    PREPARE ef_pre FROM l_sql
    IF STATUS THEN
       CALL cl_err('prepare: ', STATUS, 0)
       LET g_strXMLInput = ''
       RETURN
    END IF
    DECLARE ef_cur CURSOR FOR ef_pre
 
    DECLARE pmr_cur CURSOR FOR SELECT pmr03, pmr04, pmr05 
                                 FROM pmr_file 
                                WHERE pmr01 = ? AND pmr02 = ?
 
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
      
 
 
        CALL aws_efcli_XMLHeader(sr.pmiuser, sr.pmiuser)
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           LET g_strXMLInput = g_strXMLInput CLIPPED,
               "     <pmi01>", sr.pmi01 CLIPPED, "</pmi01>", ASCII 10,
               "     <pmi02>", sr.pmi02 CLIPPED, "</pmi02>", ASCII 10,
               "     <pmi03>", sr.pmi03 CLIPPED, ' ', sr.pmc03 CLIPPED, "</pmi03>", ASCII 10,
               "     <pmi04>", sr.pmi04 CLIPPED, "</pmi04>", ASCII 10,
               "     <pmi05>", sr.pmi05 CLIPPED, "</pmi05>", ASCII 10,
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
        END IF
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose detail data
#	Modify tag name & corresponding value if want to use another one
#	If this program hasn't detail data, don't need to care about this block
#---------------------------------------------------------------------
        CASE sr.pmi05
             WHEN 'Y'
                  LET l_j = 1
                  FOREACH pmr_cur USING sr.pmi01, sr.pmj02 INTO sr1.*
                      IF l_j = 1 THEN
                         LET g_strXMLInput = g_strXMLInput CLIPPED,
                             "     <record>", ASCII 10,
                             "      <pmj02>", sr.pmj02 CLIPPED, "</pmj02>", ASCII 10,
                             "      <pmj03>", sr.pmj03 CLIPPED, "</pmj03>", ASCII 10,
                             "      <pmj031>", sr.pmj031 CLIPPED, "</pmj031>", ASCII 10,
                             "      <pmj032>", sr.pmj032 CLIPPED, "</pmj032>", ASCII 10,
                             "      <pmj04>", sr.pmj04 CLIPPED, "</pmj04>", ASCII 10,
                             "      <pmj05>", sr.pmj05 CLIPPED, "</pmj05>", ASCII 10,
                             "      <pmj06>", sr.pmj06 CLIPPED, "</pmj06>", ASCII 10,
                             "      <pmj07>", sr.pmj07 CLIPPED, "</pmj07>", ASCII 10,
                             "      <pmr03>", sr1.pmr03 CLIPPED, "</pmr03>", ASCII 10,
                             "      <pmr04>", sr1.pmr04 CLIPPED, "</pmr04>", ASCII 10,
                             "      <pmr05>", sr1.pmr05 CLIPPED, "</pmr05>", ASCII 10,
                             "      <pmj08>", sr.pmj08 CLIPPED, "</pmj08>", ASCII 10,
                             "      <pmj09>", sr.pmj09 CLIPPED, "</pmj09>", ASCII 10,
                             "      <pmj10>", sr.pmj10 CLIPPED, "</pmj10>", ASCII 10,
                             "     </record>", ASCII 10
                      ELSE
                         LET g_strXMLInput = g_strXMLInput CLIPPED,
                             "     <record>", ASCII 10, 
                             "      <pmj02></pmj02>", ASCII 10,
                             "      <pmj03></pmj03>", ASCII 10,
                             "      <pmj031></pmj031>", ASCII 10,
                             "      <pmj032></pmj032>", ASCII 10,
                             "      <pmj04></pmj04>", ASCII 10,
                             "      <pmj05></pmj05>", ASCII 10,
                             "      <pmj06></pmj06>", ASCII 10,
                             "      <pmj07></pmj07>", ASCII 10,
                             "      <pmr03>", sr1.pmr03 CLIPPED, "</pmr03>", ASCII 10,
                             "      <pmr04>", sr1.pmr04 CLIPPED, "</pmr04>", ASCII 10,
                             "      <pmr05>", sr1.pmr05 CLIPPED, "</pmr05>", ASCII 10,
                             "      <pmj08></pmj08>", ASCII 10,
                             "      <pmj09></pmj09>", ASCII 10,
                             "      <pmj10></pmj10>", ASCII 10,
                             "     </record>", ASCII 10
                      END IF
 
                      LET l_j = l_j + 1
                  END FOREACH
             OTHERWISE
                  LET g_strXMLInput = g_strXMLInput CLIPPED,
                      "     <record>", ASCII 10,
                   "      <pmj02>", sr.pmj02 CLIPPED, "</pmj02>", ASCII 10,
                      "      <pmj03>", sr.pmj03 CLIPPED, "</pmj03>", ASCII 10,
                      "      <pmj031>", sr.pmj031 CLIPPED, "</pmj031>", ASCII 10,
                      "      <pmj032>", sr.pmj032 CLIPPED, "</pmj032>", ASCII 10,
                      "      <pmj04>", sr.pmj04 CLIPPED, "</pmj04>", ASCII 10,
                      "      <pmj05>", sr.pmj05 CLIPPED, "</pmj05>", ASCII 10,
                      "      <pmj06>", sr.pmj06 CLIPPED, "</pmj06>", ASCII 10,
                      "      <pmj07>", sr.pmj07 CLIPPED, "</pmj07>", ASCII 10,
                      "      <pmj08>", sr.pmj08 CLIPPED, "</pmj08>", ASCII 10,
                      "      <pmj09>", sr.pmj09 CLIPPED, "</pmj09>", ASCII 10,
                      "      <pmj10>", sr.pmj10 CLIPPED, "</pmj10>", ASCII 10,
                      "     </record>", ASCII 10
        END CASE
 
        LET l_i = l_i + 1
    END FOREACH
 
#---------------------------------------------------------------------
# Call aws_efcli_XMLTrailer() to compose XML Trailer
# *Don't need to change
#---------------------------------------------------------------------
    CALL aws_efcli_XMLTrailer()
END FUNCTION
