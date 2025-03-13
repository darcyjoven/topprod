# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify.........: No.FUN-550069 05/05/25 By Will 單據編號放大
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
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
			aba00	LIKE aba_file.aba00,
			aba01	LIKE aba_file.aba01,
			aba02	LIKE aba_file.aba02,
			aba03	LIKE aba_file.aba03,
			aba04	LIKE aba_file.aba04,
			aba06	LIKE aba_file.aba06,
			aba07	LIKE aba_file.aba07,
			aba08	LIKE aba_file.aba08,
			aba09	LIKE aba_file.aba09,
			aba10	LIKE aba_file.aba10,
			aba11	LIKE aba_file.aba11,
			aba18	LIKE aba_file.aba18,
			aba21	LIKE aba_file.aba21,
			abamksg	LIKE aba_file.abamksg,
			abapost	LIKE aba_file.abapost,
			abaprno	LIKE aba_file.abaprno,
			abasign	LIKE aba_file.abasign,
			abauser	LIKE aba_file.abauser,
			abb00	LIKE abb_file.abb00,
			abb01	LIKE abb_file.abb01,
			abb02	LIKE abb_file.abb02,
			aag02	LIKE aag_file.aag02,
			abb04	LIKE abb_file.abb04,
			gem02	LIKE gem_file.gem02,
			abb06	LIKE abb_file.abb06,
			abb07	LIKE abb_file.abb07,
			abb08	LIKE abb_file.abb08,
			abb11	LIKE abb_file.abb11,
			abb12	LIKE abb_file.abb12,
			abb13	LIKE abb_file.abb13,
			abb14	LIKE abb_file.abb14,
			abb15	LIKE abb_file.abb15,
                        aac02   LIKE aac_file.aac02
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
		"SELECT aba00, aba01, aba02, aba03, aba04, aba06, aba07,",
		" aba08, aba09, aba10, aba11, aba18, aba21, abamksg, abapost,",
		" abaprno, abasign, abauser, abb00, abb01, abb02, aag02, abb04,",
		" gem02, abb06, abb07, abb08, abb11, abb12, abb13, abb14,",
		" abb15,aac02",
                "  FROM aba_file, abb_file, OUTER aag_file,OUTER gem_file,",
                " OUTER aac_file",
                " WHERE aba00 = abb00",
                "   AND aba01 = abb01",
                "   AND abb05 = gem_file.gem01",
                "   AND abb03 = aag_file.aag01",  #No.FUN-730020
                "   AND abb00 = aag_file.aag00",  #No.FUN-730020
                "   AND aba06 = 'GL'",
                "   AND aba19 = 'Y'",
                "   AND aba20 = '0'",
                "   AND abamksg = 'Y'",
                "   AND abaacti = 'Y'",
#                "   AND aac_file.aac01 = SUBSTR(aba01,1,3)",
                "   AND aba01 like aac01 || '-%'",   #No.FUN-550069
                "   AND aba01 = '", g_formNum CLIPPED, "'"
 
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
        CALL aws_efcli_XMLHeader(sr.abauser, sr.abauser)
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           CALL cl_getmsg('aws-001',g_lang) RETURNING g_msg
 
           LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <aba00>", sr.aba00 CLIPPED, "</aba00>", ASCII 10,
               "     <aba01>", sr.aba01 CLIPPED, "</aba01>", ASCII 10,
               "     <aba02>", sr.aba02 CLIPPED, "</aba02>", ASCII 10,
               "     <aba03>", sr.aba03 CLIPPED, "</aba03>", ASCII 10,
               "     <aba04>", sr.aba04 CLIPPED, "</aba04>", ASCII 10,
               "     <aba06>", g_msg    CLIPPED, "</aba06>", ASCII 10,
               "     <aba07>", sr.aba07 CLIPPED, "</aba07>", ASCII 10,
               "     <aba08>", sr.aba08 CLIPPED, "</aba08>", ASCII 10,
               "     <aba09>", sr.aba09 CLIPPED, "</aba09>", ASCII 10,
               "     <aba10>", sr.aba10 CLIPPED, "</aba10>", ASCII 10,
               "     <aba11>", sr.aba11 CLIPPED, "</aba11>", ASCII 10,
               "     <aba18>", sr.aba18 CLIPPED, "</aba18>", ASCII 10,
               "     <aba21>", sr.aba21 CLIPPED, "</aba21>", ASCII 10,
               "     <abamksg>", sr.abamksg CLIPPED, "</abamksg>", ASCII 10,
               "     <abapost>", sr.abapost CLIPPED, "</abapost>", ASCII 10,
               "     <abaprno>", sr.abaprno CLIPPED, "</abaprno>", ASCII 10,
               "     <abasign>", sr.abasign CLIPPED, "</abasign>", ASCII 10,
               "     <abauser>", sr.abauser CLIPPED, "</abauser>", ASCII 10,
               "     <aac02>", sr.aac02 CLIPPED, "</aac02>", ASCII 10,
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
         "      <abb00>", sr.abb00 CLIPPED, "</abb00>", ASCII 10,
            "      <abb01>", sr.abb01 CLIPPED, "</abb01>", ASCII 10,
            "      <abb02>", sr.abb02 CLIPPED, "</abb02>", ASCII 10,
            "      <abb03>", sr.aag02 CLIPPED, "</abb03>", ASCII 10,
            "      <abb04>", sr.abb04 CLIPPED, "</abb04>", ASCII 10,
            "      <abb05>", sr.gem02 CLIPPED, "</abb05>", ASCII 10,
            "      <abb06>", sr.abb06 CLIPPED, "</abb06>", ASCII 10,
            "      <abb07>", sr.abb07 CLIPPED, "</abb07>", ASCII 10,
            "      <abb08>", sr.abb08 CLIPPED, "</abb08>", ASCII 10,
            "      <abb11>", sr.abb11 CLIPPED, "</abb11>", ASCII 10,
            "      <abb12>", sr.abb12 CLIPPED, "</abb12>", ASCII 10,
            "      <abb13>", sr.abb13 CLIPPED, "</abb13>", ASCII 10,
            "      <abb14>", sr.abb14 CLIPPED, "</abb14>", ASCII 10,
            "      <abb15>", sr.abb15 CLIPPED, "</abb15>", ASCII 10,
            "     </record>", ASCII 10
 
        LET l_i = l_i + 1
    END FOREACH
 
#---------------------------------------------------------------------
# Call aws_efcli_XMLTrailer() to compose XML Trailer
# *Don't need to change
#---------------------------------------------------------------------
    CALL aws_efcli_XMLTrailer()
END FUNCTION
