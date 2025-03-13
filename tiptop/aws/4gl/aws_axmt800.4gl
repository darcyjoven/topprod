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
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/09/05 By zhuying 欄位形態定義為LIKE
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
			oag02	LIKE oag_file.oag02,
			oea03	LIKE oea_file.oea03,
			oea032	LIKE oea_file.oea032,
			oea23	LIKE oea_file.oea23,
			oea32	LIKE oea_file.oea32,
			oep01	LIKE oep_file.oep01,
			oep02	LIKE oep_file.oep02,
			oep04	LIKE oep_file.oep04,
			oep06	LIKE oep_file.oep06,
			oep06b	LIKE oep_file.oep06b,
			oep07	LIKE oep_file.oep07,
			oep07b	LIKE oep_file.oep07b,
			oep08	LIKE oep_file.oep08,
			oep08b	LIKE oep_file.oep08b,
			oepuser	LIKE oep_file.oepuser,
			oeq03	LIKE oeq_file.oeq03,
			oeq041a	LIKE oeq_file.oeq041a,
			oeq041b	LIKE oeq_file.oeq041b,
			oeq04a	LIKE oeq_file.oeq04a,
			oeq04b	LIKE oeq_file.oeq04b,
			oeq05a	LIKE oeq_file.oeq05a,
			oeq05b	LIKE oeq_file.oeq05b,
			oeq12a	LIKE oeq_file.oeq12a,
			oeq12b	LIKE oeq_file.oeq12b,
			oeq13a	LIKE oeq_file.oeq13a,
			oeq13b	LIKE oeq_file.oeq13b,
			oeq14a	LIKE oeq_file.oeq14a,
			oeq14b	LIKE oeq_file.oeq14b,
			oeq15a	LIKE oeq_file.oeq15a,
			oeq15b	LIKE oeq_file.oeq15b,
			oeq50	LIKE oeq_file.oeq50,
                        ima021a LIKE ima_file.ima021,
                        ima021b LIKE ima_file.ima021,
                        azi02   LIKE azi_file.azi02
           	END RECORD,
           l_i		LIKE type_file.num5,          #No.FUN-680130 SMALLINT
           l_sql	LIKE type_file.chr1000        #No.FUN-680130 VARCHAR(1000)
    DEFINE l_detail1    LIKE ze_file.ze03,            #No.FUN-680130 VARCHAR(100)
           l_detail2    LIKE ze_file.ze03,            #No.FUN-680130 VARCHAR(100)
           l_cnt	LIKE type_file.num5,          #No.FUN-680130 SMALLINT
           l_oea14      LIKE azi_file.azi02
 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
    LET l_sql =
		"SELECT ' ', oea03, oea032, oea23, oea32, oep01, oep02,",
		" oep04, oep06, oep06b, oep07, oep07b, oep08, oep08b, oepuser,",
		" oeq03, oeq041a, oeq041b, oeq04a, oeq04b, oeq05a, oeq05b, oeq12a,",
		" oeq12b, oeq13a, oeq13b, oeq14a, oeq14b, oeq15a, oeq15b, oeq50",
                "  FROM oep_file, OUTER oeq_file, OUTER oea_file",
                " WHERE oep01 = oeq_file.oeq01 ",
                "   AND oep02 = oeq_file.oeq02 ",
                "   AND oepacti = 'Y' ",
                "   AND oep01 = oea_file.oea01 ",
                "   AND oep01 = '", g_formNum CLIPPED, "'",
                #No:8176
                "   AND oep02 = ", g_key1 CLIPPED
                ##
 
    PREPARE ef_pre FROM l_sql
    IF STATUS THEN
       CALL cl_err('prepare: ', STATUS, 0)
       LET g_strXMLInput = ''
       RETURN
    END IF
    DECLARE ef_cur CURSOR FOR ef_pre
 
    LET l_i = 1
    FOREACH ef_cur INTO sr.*
        SELECT oag02 INTO sr.oag02 FROM oag_file
         WHERE sr.oea32 = oag01
        SELECT ima021 INTO sr.ima021b FROM ima_file
         WHERE sr.oeq04b = ima01
        SELECT ima021 INTO sr.ima021a FROM ima_file
         WHERE sr.oeq04a = ima01
        SELECT azi02 INTO sr.azi02 FROM azi_file
         WHERE sr.oea23 = azi01
        IF STATUS THEN
#          CALL cl_err('foreach: ', STATUS, 0)   #No.FUN-660155
           CALL cl_err3("sel","azi_file",sr.oea23,"",STATUS,"","foreach:", 0)   #No.FUN-660155)   #No.FUN-660155
           LET g_strXMLInput = ''
           RETURN
        END IF
 
        IF l_i = 1 THEN
 
           #Determine if has detail record
           SELECT COUNT(*) INTO l_cnt FROM oeq_file
            WHERE oeq01 = sr.oep01 AND oeq02 = sr.oep02
   
#---------------------------------------------------------------------
# *CHECK POINT:
#	Call aws_efcli_XMLHeader() to compose XML Header
#	Pass corresponding formCreator & formOwner value as parameters
#
# *Another REMARK:
#       If this applicaton has compound key as unique key
#       Let g_formNum equals following type:
#           LET g_formNum = g_formNum CLIPPED, "{+}key_column=", g_key1 CLIPPED, ...
#       That means what follow & seprate by {+} is WHERE CONDITION
#---------------------------------------------------------------------
           #No:8176
           LET g_formNum = g_formNum CLIPPED, "{+}oep02=", g_key1 CLIPPED
           ##
         SELECT oea14 INTO l_oea14 FROM oea_file
            WHERE oea01 = sr.oep01
        CALL aws_efcli_XMLHeader(sr.oepuser, l_oea14)
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           LET g_strXMLInput = g_strXMLInput CLIPPED,
#           "     <oag02>", sr.oag02 CLIPPED, "</oag02>", ASCII 10,
               "     <oea03>", sr.oea03 CLIPPED, "</oea03>", ASCII 10,
               "     <oea032>", sr.oea032 CLIPPED, "</oea032>", ASCII 10,
               "     <oea23>", sr.azi02 CLIPPED, "</oea23>", ASCII 10,
               "     <oea32>", sr.oea32 CLIPPED, ' ',sr.oag02 CLIPPED, "</oea32>", ASCII 10,
               "     <oep01>", sr.oep01 CLIPPED, "</oep01>", ASCII 10,
               "     <oep02>", sr.oep02 CLIPPED, "</oep02>", ASCII 10,
               "     <oep04>", sr.oep04 CLIPPED, "</oep04>", ASCII 10,
               "     <oep06>", sr.oep06 CLIPPED, "</oep06>", ASCII 10,
               "     <oep06b>", sr.oep06b CLIPPED, "</oep06b>", ASCII 10,
               "     <oep07>", sr.oep07 CLIPPED, "</oep07>", ASCII 10,
               "     <oep07b>", sr.oep07b CLIPPED, "</oep07b>", ASCII 10,
               "     <oep08>", sr.oep08 CLIPPED, "</oep08>", ASCII 10,
               "     <oep08b>", sr.oep08b CLIPPED, "</oep08b>", ASCII 10,
               "     <oepuser>", sr.oepuser CLIPPED, "</oepuser>", ASCII 10,
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
        END IF
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose detail data
#	Modify tag name & corresponding value if want to use another one
#	If this program hasn't detail data, don't need to care about this block
#---------------------------------------------------------------------
     IF l_cnt != 0 THEN
 
        CALL cl_getmsg('aws-026',g_lang) RETURNING g_msg
        LET l_detail1 = g_msg
        CALL cl_getmsg('aws-027',g_lang) RETURNING g_msg
        LET l_detail2 = g_msg
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
         "      <oeq03>", sr.oeq03 CLIPPED, "-", l_detail1 CLIPPED, "</oeq03>", ASCII 10,
            "      <oeq041b>", sr.oeq041b CLIPPED, "</oeq041b>", ASCII 10,
            "      <oeq04b>", sr.oeq04b CLIPPED, "</oeq04b>", ASCII 10,
            "      <ima021>", sr.ima021b CLIPPED, "</ima021>", ASCII 10,
            "      <oeq05b>", sr.oeq05b CLIPPED, "</oeq05b>", ASCII 10,
            "      <oeq12b>", sr.oeq12b CLIPPED, "</oeq12b>", ASCII 10,
            "      <oeq13b>", sr.oeq13b CLIPPED, "</oeq13b>", ASCII 10,
            "      <oeq14b>", sr.oeq14b CLIPPED, "</oeq14b>", ASCII 10,
            "      <oeq15b>", sr.oeq15b CLIPPED, "</oeq15b>", ASCII 10,
            "     </record>", ASCII 10
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
         "      <oeq03>", sr.oeq03 CLIPPED, "-", l_detail2 CLIPPED, "</oeq03>", ASCII 10,
            "      <oeq041a>", sr.oeq041a CLIPPED, "</oeq041a>", ASCII 10,
            "      <oeq04a>", sr.oeq04a CLIPPED, "</oeq04a>", ASCII 10,
            "      <ima021>", sr.ima021a CLIPPED, "</ima021>", ASCII 10,
            "      <oeq05a>", sr.oeq05a CLIPPED, "</oeq05a>", ASCII 10,
            "      <oeq12a>", sr.oeq12a CLIPPED, "</oeq12a>", ASCII 10,
            "      <oeq13a>", sr.oeq13a CLIPPED, "</oeq13a>", ASCII 10,
            "      <oeq14a>", sr.oeq14a CLIPPED, "</oeq14a>", ASCII 10,
            "      <oeq15a>", sr.oeq15a CLIPPED, "</oeq15a>", ASCII 10,
            "      <oeq50>", sr.oeq50 CLIPPED, "</oeq50>", ASCII 10,
            "     </record>", ASCII 10
 
     END IF
 
        LET l_i = l_i + 1
    END FOREACH
 
#---------------------------------------------------------------------
# Call aws_efcli_XMLTrailer() to compose XML Trailer
# *Don't need to change
#---------------------------------------------------------------------
    CALL aws_efcli_XMLTrailer()
END FUNCTION
