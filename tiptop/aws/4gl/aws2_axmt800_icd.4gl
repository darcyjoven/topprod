# Prog. Version..: '5.30.06-13.03.12(00002)'     #
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
#
# Modify........: No.FUN-5B0146 05/12/06 Echo 增加傳送送貨地址、收款條件說明、幣別說明
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/09/04 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-750017 07/06/13 By JackLai 將代號與名稱拆成不同欄位
# Modify.........: No.TQC-870026 08/08/15 By Vicky  新增欄位
# Modify.........: No.FUN-930153 09/03/25 By Vicky 調整SQL語句欄位指定錯誤 sr.oep01b => sr.oep01
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0208 09/12/03 By Dido 調整給予sr.ima021a,sr.ima021b,sr.azi02預設值為空白 
#---------------------以上資訊為aws_axct800.4gl的更新記錄------------------------------------------
# Modify.........: No:FUN-A50082 11/01/25 By Lilan New 4gl:Copy From "aws2_axmt800.4gl"=>新增ICD欄位
# Modify.........: No:FUN-BB0061 11/11/10 By Jay EasyFlow送簽時針對數值資料增加XML tag內容

DATABASE ds
 
#---------------------------------------------------------------------
# Include global variable file: awsef.4gl
# *Don't need to change
#---------------------------------------------------------------------
GLOBALS "../4gl/awsef.4gl"
GLOBALS "../../config/top.global"
 
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
                        #--TQC-870026--start--
                        oep10   LIKE oep_file.oep10,
                        oep11   LIKE oep_file.oep11,
                        oep10b  LIKE oep_file.oep10b,
                        oep11b  LIKE oep_file.oep11b,
                        oeq28a  LIKE oeq_file.oeq28a,
                        oeq28b  LIKE oeq_file.oeq28b,
                        oeq29a  LIKE oeq_file.oeq29a,
                        oeq29b  LIKE oeq_file.oeq29b,
                        #--TQC-870026--end--
                        #FUN-A50082 add str ---
                        oeqiicd01a LIKE oeqi_file.oeqiicd01a,
                        oeqiicd01b LIKE oeqi_file.oeqiicd01b,
                        oeqiicd02a LIKE oeqi_file.oeqiicd02a,
                        oeqiicd02b LIKE oeqi_file.oeqiicd02b,
                        oeqiicd03a LIKE oeqi_file.oeqiicd03a,
                        oeqiicd03b LIKE oeqi_file.oeqiicd03b,
                        oeqiicd04a LIKE oeqi_file.oeqiicd04a,
                        oeqiicd04b LIKE oeqi_file.oeqiicd04b,
                        #FUN-A50082 add end ---
                        ima021a LIKE ima_file.ima021,
                        ima021b LIKE ima_file.ima021,
                        azi02   LIKE azi_file.azi02
           	END RECORD,
           l_i		LIKE type_file.num5,         #No.FUN-680130 SMALLINT
           l_sql        STRING                       # type_file.chr1000 => STRING #FUN-A50082 mod
    DEFINE l_detail1    LIKE ze_file.ze03,           #No.FUN-680130 VARCHAR(100)
           l_detail2    LIKE ze_file.ze03,           #No.FUN-680130 VARCHAR(100)
           l_cnt	LIKE type_file.num5,         #No.FUN-680130 SMALLINT
           l_oea14      LIKE azi_file.azi02
    #FUN-5B0146
    DEFINE l_oep08                    LIKE azi_file.azi02,
           l_oep08b                   LIKE azi_file.azi02,
           l_oep07                    LIKE oag_file.oag02,
           l_oep07b                   LIKE oag_file.oag02,
           l_oep06                    LIKE oep_file.oep06,         #No.FUN-680130 STRING
           l_oep06b                   LIKE oep_file.oep06b         #No.FUN-680130 STRING
    DEFINE l_add1,l_add2,l_add3       LIKE occ_file.occ241         #No.FUN-680130 VARCHAR(36)
    #END FUN-5B0146
 
 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
   #FUN-A50082 add l_sql ---------------------------------------------
    LET l_sql =
       "SELECT ' ', oea03, oea032, oea23, oea32, oep01, oep02, ",
       "        oep04, oep06, oep06b, oep07, oep07b, oep08, oep08b, ",
       "       oepuser, oeq03, oeq041a, oeq041b, oeq04a, oeq04b, ",
       "       oeq05a, oeq05b, oeq12a, oeq12b, oeq13a, oeq13b, oeq14a, oeq14b, ",
       "       oeq15a, oeq15b, oeq50, oep10, oep11, oep10b, oep11b, ",
       "       oeq28a, oeq28b, oeq29a, oeq29b, oeqiicd01a, oeqiicd01b, ",
       "       oeqiicd02a, oeqiicd02b, oeqiicd03a, oeqiicd03b, ",
       "       oeqiicd04a, oeqiicd04b, '', '', '' ",
       "  FROM oep_file ",
       "  LEFT OUTER JOIN", 
       "       (SELECT oeq01, oeq02, oeq03, oeq041a, oeq041b, oeq04a, oeq04b, ",
       "               oeq05a, oeq05b, oeq12a, oeq12b, oeq13a, oeq13b, oeq14a, ",
       "               oeq14b, oeq15a, oeq15b, oeq50, oeq28a, oeq28b, ",
       "               oeq29a, oeq29b, ",
       "               oeqiicd01a, oeqiicd01b, oeqiicd02a, oeqiicd02b, ",
       "               oeqiicd03a, oeqiicd03b, oeqiicd04a, oeqiicd04b ",
       "          FROM oeq_file ",
       "         LEFT OUTER JOIN oeqi_file ON oeq_file.oeq01=oeqi_file.oeqi01 AND",
       "                                      oeq_file.oeq02=oeqi_file.oeqi02 AND",
       "                                      oeq_file.oeq03=oeqi_file.oeqi03 ",
       "        ) a ON oep_file.oep01=a.oeq01 AND oep_file.oep02=a.oeq02 ",
       "  LEFT OUTER JOIN oea_file ON oep_file.oep01=oea_file.oea01",
       " WHERE oepacti = 'Y' ",
       "   AND oep01 = '", g_formNum CLIPPED, "'",
       "   AND oep02 = ", g_key1 CLIPPED
   #FUN-A50082 end --------------------------------------------------
 
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
#	Call aws_efcli2_XMLHeader() to compose XML Header
#	Pass corresponding formCreator & formOwner value as parameters
#
# *Another REMARK:
#       If this applicaton has compound key as unique key
#       Let g_formNum equals following type:
#           LET g_formNum = g_formNum CLIPPED, "{+}key_column=", g_key1 CLIPPED, ...
#       That means what follow & seprate by {+} is WHERE CONDITION
#---------------------------------------------------------------------
        CALL aws_efcli2_XMLHeader()
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           #FUN-5B0146
           #收款條件
           SELECT oag02 INTO l_oep07  FROM oag_file WHERE oag01 = sr.oep07
           SELECT oag02 INTO l_oep07b FROM oag_file WHERE oag01 = sr.oep07b
           #幣別
           SELECT azi02 INTO l_oep08  FROM azi_file WHERE azi01 = sr.oep08
           SELECT azi02 INTO l_oep08b FROM azi_file WHERE azi01 = sr.oep08b
           #送貨地址
           CASE
            WHEN sr.oep06 IS NULL
                 SELECT occ241,occ242,occ243 INTO l_add1,l_add2,l_add3
                     FROM occ_file WHERE occ01= sr.oea03
            WHEN sr.oep06 = 'MISC'
                 SELECT oap041,oap042,oap043 INTO l_add1,l_add2,l_add3
                     FROM oap_file WHERE oap01= sr.oep01
            OTHERWISE SELECT ocd221,ocd222,ocd223
                        INTO l_add1,l_add2,l_add3 FROM ocd_file
                        WHERE ocd01=sr.oea03 AND ocd02=sr.oep06
           END CASE
           LET l_oep06=l_add1 CLIPPED,l_add2 CLIPPED, l_add3 CLIPPED
           LET l_add1 = ''
           LET l_add2 = ''
           LET l_add3 = ''
           IF sr.oep06b = 'MISC' THEN
                 SELECT oap041,oap042,oap043 INTO l_add1,l_add2,l_add3
                     FROM oap_file WHERE oap01= sr.oep01    #FUN-930153 sr.oep01b => sr.oep01
           ELSE
                 SELECT ocd221,ocd222,ocd223 INTO l_add1,l_add2,l_add3
                     FROM ocd_file WHERE ocd01=sr.oea03 AND ocd02=sr.oep06b
           END IF
           LET l_oep06b=l_add1 CLIPPED,l_add2 CLIPPED, l_add3 CLIPPED
 
           LET g_strXMLInput = g_strXMLInput CLIPPED,
		       #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
#              "     <oag02 type=\"0\">",  sr.oag02 CLIPPED,  "</oag02>", ASCII 10,
               "     <oea03 type=\"0\">",  sr.oea03 CLIPPED,  "</oea03>", ASCII 10,
               "     <oea032 type=\"0\">", sr.oea032 CLIPPED, "</oea032>", ASCII 10,
               "     <oea23 type=\"0\">",  sr.oea23 CLIPPED,  ' ',sr.azi02 CLIPPED, "</oea23>", ASCII 10,
               #"     <oea32>",  sr.oea32 CLIPPED,  ' ',sr.oag02 CLIPPED, "</oea32>", ASCII 10, #No.FUN-750017
               "     <oea32 type=\"0\">",  sr.oea32 CLIPPED,  "</oea32>", ASCII 10,    #No.FUN-750017
               "     <oag02 type=\"0\">",  sr.oag02 CLIPPED,  "</oag02>", ASCII 10,    #No.FUN-750017
               "     <oep01 type=\"0\">",  sr.oep01 CLIPPED,  "</oep01>", ASCII 10,
               "     <oep02 type=\"1\">",  sr.oep02 CLIPPED,  "</oep02>", ASCII 10,
               "     <oep04 type=\"0\">",  sr.oep04 CLIPPED,  "</oep04>", ASCII 10,
               "     <oep06 type=\"0\">",  sr.oep06 CLIPPED,  ' ',l_oep06  CLIPPED,"</oep06>", ASCII 10,
               "     <oep06b type=\"0\">", sr.oep06b CLIPPED, ' ',l_oep06b CLIPPED,"</oep06b>", ASCII 10,
               "     <oep07 type=\"0\">",  sr.oep07 CLIPPED,  ' ',l_oep07  CLIPPED,"</oep07>", ASCII 10,
               "     <oep07b type=\"0\">", sr.oep07b CLIPPED, ' ',l_oep07b CLIPPED,"</oep07b>", ASCII 10,
               "     <oep08 type=\"0\">",  sr.oep08 CLIPPED,  ' ',l_oep08  CLIPPED,"</oep08>", ASCII 10,
               "     <oep08b type=\"0\">", sr.oep08b CLIPPED, ' ',l_oep08b CLIPPED,"</oep08b>", ASCII 10,
               "     <oepuser type=\"0\">",sr.oepuser CLIPPED,"</oepuser>", ASCII 10,
               #--TQC-870026 --start--
               "     <oep10 type=\"0\">", sr.oep10 CLIPPED, "</oep10>", ASCII 10,
               "     <oep11 type=\"0\">", sr.oep11 CLIPPED, "</oep11>", ASCII 10,
               "     <oep10b type=\"0\">", sr.oep10b CLIPPED, "</oep10b>", ASCII 10,
               "     <oep11b type=\"0\">", sr.oep11b CLIPPED, "</oep11b>", ASCII 10,
               #--TQC-870026 --end--
               #---FUN-BB0061---end-----
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
           #END FUN-5B0146
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
			#---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
            "      <dummy01 type=\"0\">", sr.oeq03 CLIPPED, "-", l_detail1 CLIPPED, "</dummy01>", ASCII 10,
            "      <dummy02 type=\"0\">", sr.oeq04b CLIPPED, "</dummy02>", ASCII 10,  #--TQC-870026
            "      <dummy03 type=\"0\">", sr.oeq041b CLIPPED,  "</dummy03>", ASCII 10,  #--TQC-870026
            "      <dummy04 type=\"0\">", sr.ima021b CLIPPED, "</dummy04>", ASCII 10,
            "      <dummy05 type=\"0\">", sr.oeq05b CLIPPED,  "</dummy05>", ASCII 10,
            "      <dummy06 type=\"1\">", sr.oeq12b CLIPPED,  "</dummy06>", ASCII 10,
            "      <dummy07 type=\"1\">", sr.oeq13b CLIPPED,  "</dummy07>", ASCII 10,
            "      <dummy08 type=\"1\">", sr.oeq14b CLIPPED,  "</dummy08>", ASCII 10,
            "      <dummy09 type=\"0\">", sr.oeq15b CLIPPED,  "</dummy09>", ASCII 10,
            "      <dummy10 type=\"0\"></dummy10>", ASCII 10,
            #--TQC-870026 --start--
            "      <dummy11 type=\"0\">", sr.oeq28b CLIPPED,  "</dummy11>", ASCII 10,
            "      <dummy12 type=\"0\">", sr.oeq29b CLIPPED,  "</dummy12>", ASCII 10,
            #--TQC-870026 --end--
            #FUN-A50082 --start--
            "      <dummy13 type=\"0\">", sr.oeqiicd01b CLIPPED,  "</dummy13>", ASCII 10,
            "      <dummy14 type=\"1\">", sr.oeqiicd02b CLIPPED,  "</dummy14>", ASCII 10,
            "      <dummy15 type=\"0\">", sr.oeqiicd03b CLIPPED,  "</dummy15>", ASCII 10,
            "      <dummy16 type=\"0\">", sr.oeqiicd04b CLIPPED,  "</dummy16>", ASCII 10,
            #FUN-A50082 --end--
            "     </record>", ASCII 10
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
            "      <dummy01 type=\"0\">", sr.oeq03 CLIPPED, "-", l_detail2 CLIPPED, "</dummy01>", ASCII 10,
            "      <dummy02 type=\"0\">", sr.oeq04a CLIPPED,"</dummy02>", ASCII 10, #--TQC-870026
            "      <dummy03 type=\"0\">", sr.oeq041a CLIPPED, "</dummy03>", ASCII 10,  #--TQC-870026
            "      <dummy04 type=\"0\">", sr.ima021a CLIPPED,"</dummy04>", ASCII 10,
            "      <dummy05 type=\"0\">", sr.oeq05a CLIPPED, "</dummy05>", ASCII 10,
            "      <dummy06 type=\"1\">", sr.oeq12a CLIPPED, "</dummy06>", ASCII 10,
            "      <dummy07 type=\"1\">", sr.oeq13a CLIPPED, "</dummy07>", ASCII 10,
            "      <dummy08 type=\"1\">", sr.oeq14a CLIPPED, "</dummy08>", ASCII 10,
            "      <dummy09 type=\"0\">", sr.oeq15a CLIPPED, "</dummy09>", ASCII 10,
            "      <dummy10 type=\"0\">", sr.oeq50 CLIPPED,  "</dummy10>", ASCII 10,
            #--TQC-870026 --start--
            "      <dummy11 type=\"0\">", sr.oeq28a CLIPPED,  "</dummy11>", ASCII 10,
            "      <dummy12 type=\"0\">", sr.oeq29a CLIPPED,  "</dummy12>", ASCII 10,
            #--TQC-870026 --end--
            #FUN-A50082 --start--
            "      <dummy13 type=\"0\">", sr.oeqiicd01a CLIPPED,  "</dummy13>", ASCII 10,
            "      <dummy14 type=\"1\">", sr.oeqiicd02a CLIPPED,  "</dummy14>", ASCII 10,
            "      <dummy15 type=\"0\">", sr.oeqiicd03a CLIPPED,  "</dummy15>", ASCII 10,
            "      <dummy16 type=\"0\">", sr.oeqiicd04a CLIPPED,  "</dummy16>", ASCII 10,
            #FUN-A50082 --end--
            #---FUN-BB0061---end-----
            "     </record>", ASCII 10
 
     END IF
 
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
