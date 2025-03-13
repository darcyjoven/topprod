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
# Modify.........: No.FUN-680130 06/09/04 By zhuying 欄位形態定義為LIKE
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
			bmr01	LIKE bmr_file.bmr01,
			bmr02	LIKE bmr_file.bmr02,
			bmr03	LIKE bmr_file.bmr03,
			bmr04	LIKE bmr_file.bmr04,
			bmr05	LIKE bmr_file.bmr05,
			bmr06	LIKE bmr_file.bmr06,
			bmr07	LIKE bmr_file.bmr07,
			bmr16	LIKE bmr_file.bmr16,
			bmr17	LIKE bmr_file.bmr17,
			bmr18	LIKE bmr_file.bmr18,
			bmr19	LIKE bmr_file.bmr19,
			bmr20	LIKE bmr_file.bmr20,
			bmr21	LIKE bmr_file.bmr21,
			bmr22	LIKE bmr_file.bmr22,
			bmr23	LIKE bmr_file.bmr23,
			bmr24	LIKE bmr_file.bmr24,
			bmr25	LIKE bmr_file.bmr25,
			bmr26	LIKE bmr_file.bmr26,
			bmr27	LIKE bmr_file.bmr27,
			bmr30	LIKE bmr_file.bmr30,
			bmr31	LIKE bmr_file.bmr31,
			bmr32	LIKE bmr_file.bmr32,
			bmr33	LIKE bmr_file.bmr33,
			bmr34	LIKE bmr_file.bmr34,
			bmr35	LIKE bmr_file.bmr35,
			bmruser	LIKE bmr_file.bmruser,
			ima02	LIKE ima_file.ima02,
			ima021	LIKE ima_file.ima021,
			occ02	LIKE occ_file.occ02,
                        gem02   LIKE gem_file.gem02,
                        gen02   LIKE gen_file.gen02
           	END RECORD,
           l_i		LIKE type_file.num5,          #No.FUN-680130 SMALLINT
           l_sql	STRING         
    DEFINE l_bmr16      LIKE bmr_file.bmr16,          #No.FUN-680130 STRING
           l_bmr18      LIKE bmr_file.bmr18,          #No.FUN-680130 STRING
           l_bmr20      LIKE bmr_file.bmr20,          #No.FUN-680130 STRING
           l_bmr22      LIKE bmr_file.bmr22,          #No.FUN-680130 STRING
           l_bmr24      LIKE bmr_file.bmr24           #No.FUN-680130 STRING
 
 
    WHENEVER ERROR CONTINUE
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
    LET l_sql =
		"SELECT bmr01, bmr02, bmr03, bmr04, bmr05, bmr06, bmr07,",
		" bmr16, bmr17, bmr18, bmr19, bmr20, bmr21, bmr22, bmr23,",
		" bmr24, bmr25, bmr26, bmr27, bmr30, bmr31, bmr32, bmr33,",
		" bmr34, bmr35, bmruser, ima02, ima021, occ02, gem02, gen02",
                "  FROM bmr_file,OUTER ima_file,OUTER occ_file,OUTER gem_file,",
                " OUTER gen_file",
                " WHERE gem_file.gem01 = bmr05 ",
                "   AND gen_file.gen01 = bmr06 ",
                "   AND gen_file.gen03 = bmr05 ",
                "   AND ima_file.ima01 = bmr07 ",
                "   AND occ_file.occ01 = bmr04 ",
                "   AND bmr01 = '", g_formNum CLIPPED, "'"
 
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
        CALL aws_efcli_XMLHeader(sr.bmruser, sr.bmr06)
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           CALL aws_i901_memo(sr.bmr16)
           LET l_bmr16 = g_msg
           CALL aws_i901_memo(sr.bmr18)
           LET l_bmr18 = g_msg
           CALL aws_i901_memo(sr.bmr20)
           LET l_bmr20 = g_msg
           CALL aws_i901_memo(sr.bmr22)
           LET l_bmr22 = g_msg
           CALL aws_i901_memo(sr.bmr24)
           LET l_bmr24 = g_msg
 
           LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <bmr01>", sr.bmr01 CLIPPED, "</bmr01>", ASCII 10,
               "     <bmr02>", sr.bmr02 CLIPPED, "</bmr02>", ASCII 10,
               "     <bmr03>", sr.bmr03 CLIPPED, "</bmr03>", ASCII 10,
               "     <bmr04>", sr.bmr04 CLIPPED, "</bmr04>", ASCII 10,
               "     <occ02>", sr.occ02 CLIPPED, "</occ02>", ASCII 10,
               "     <bmr05>", sr.bmr05 CLIPPED, ' ', sr.gem02 CLIPPED, "</bmr05>", ASCII 10,
               "     <bmr06>", sr.bmr06 CLIPPED, ' ', sr.gen02 CLIPPED, "</bmr06>", ASCII 10,
               "     <bmr07>", sr.bmr07 CLIPPED, "</bmr07>", ASCII 10,
               "     <ima02>", sr.ima02 CLIPPED, "</ima02>", ASCII 10,
               "     <ima021>", sr.ima021 CLIPPED, "</ima021>", ASCII 10,
               "     <bmr16>", sr.bmr16 CLIPPED, ' ', l_bmr16 CLIPPED, "</bmr16>", ASCII 10,
               "     <bmr17>", sr.bmr17 CLIPPED, "</bmr17>", ASCII 10,
               "     <bmr18>", sr.bmr18 CLIPPED, ' ', l_bmr18 CLIPPED, "</bmr18>", ASCII 10,
               "     <bmr19>", sr.bmr19 CLIPPED, "</bmr19>", ASCII 10,
               "     <bmr20>", sr.bmr20 CLIPPED, ' ', l_bmr20 CLIPPED, "</bmr20>", ASCII 10,
               "     <bmr21>", sr.bmr21 CLIPPED, "</bmr21>", ASCII 10,
               "     <bmr22>", sr.bmr22 CLIPPED, ' ', l_bmr22 CLIPPED, "</bmr22>", ASCII 10,
               "     <bmr23>", sr.bmr23 CLIPPED, "</bmr23>", ASCII 10,
               "     <bmr24>", sr.bmr24 CLIPPED, ' ', l_bmr24 CLIPPED, "</bmr24>", ASCII 10,
               "     <bmr25>", sr.bmr25 CLIPPED, "</bmr25>", ASCII 10,
               "     <bmr26>", sr.bmr26 CLIPPED, "</bmr26>", ASCII 10,
               "     <bmr27>", sr.bmr27 CLIPPED, "</bmr27>", ASCII 10,
               "     <bmr30>", sr.bmr30 CLIPPED, "</bmr30>", ASCII 10,
               "     <bmr31>", sr.bmr31 CLIPPED, "</bmr31>", ASCII 10,
               "     <bmr32>", sr.bmr32 CLIPPED, "</bmr32>", ASCII 10,
               "     <bmr33>", sr.bmr33 CLIPPED, "</bmr33>", ASCII 10,
               "     <bmr34>", sr.bmr34 CLIPPED, "</bmr34>", ASCII 10,
               "     <bmr35>", sr.bmr35 CLIPPED, "</bmr35>", ASCII 10,
               "     <bmruser>", sr.bmruser CLIPPED, "</bmruser>", ASCII 10,
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
        END IF
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose detail data
#	Modify tag name & corresponding value if want to use another one
#	If this program hasn't detail data, don't need to care about this block
#---------------------------------------------------------------------
 
        LET l_i = l_i + 1
    END FOREACH
 
#---------------------------------------------------------------------
# Call aws_efcli_XMLTrailer() to compose XML Trailer
# *Don't need to change
#---------------------------------------------------------------------
    CALL aws_efcli_XMLTrailer()
END FUNCTION
 
FUNCTION aws_i901_memo(l_column)
DEFINE l_column LIKE type_file.chr1               #No.FUN-680130 VARCHAR(30)
 
    CASE
      WHEN l_column='A' CALL cl_getmsg('aws-060',g_lang) RETURNING g_msg
      WHEN l_column='B' CALL cl_getmsg('aws-061',g_lang) RETURNING g_msg
      WHEN l_column='C' CALL cl_getmsg('aws-062',g_lang) RETURNING g_msg
      WHEN l_column='D' CALL cl_getmsg('aws-063',g_lang) RETURNING g_msg
      WHEN l_column='E' CALL cl_getmsg('aws-064',g_lang) RETURNING g_msg
    END CASE
END FUNCTION
