# Prog. Version..: '5.30.06-13.03.12(00001)'     #
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
# Modify........: No.FUN-920208 08/03/06 sabrina  asft803 EF整合段
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-BB0061 11/11/10 By Jay EasyFlow送簽時針對數值資料增加XML tag內容
 
DATABASE ds
 
#FUN-920208
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
                    #單頭
			snb01   LIKE snb_file.snb01,   #工單單號
			snb02   LIKE snb_file.snb02,   #變更版本
			snb022  LIKE snb_file.snb022,  #變更日期
			snb08b  LIKE snb_file.snb08b,  #變更前生產數量
			snb08a  LIKE snb_file.snb08a,  #變更後生產數量
			snb13b  LIKE snb_file.snb13b,  #變更前預計開工日
			snb13a  LIKE snb_file.snb13a,  #變更後預計開工日
			snb15b  LIKE snb_file.snb15b,  #變更前預計完工日
			snb15a  LIKE snb_file.snb15a,  #變更後預計完工日
			snb82b  LIKE snb_file.snb82b,  #變更前部門/供應商
			snb82a  LIKE snb_file.snb82a,  #變更後部門/供應商
			snbuser LIKE snb_file.snbuser, #資料所有者
			snbconf LIKE snb_file.snbconf, #發出
 
                        sfb05   LIKE sfb_file.sfb05,   #料號
			sfb02   LIKE sfb_file.sfb02,   #工單性質
                        sfb09   LIKE sfb_file.sfb09,   #完工入庫量
                    #單身
			sna04	LIKE sna_file.sna04,   #項次
			sna03a	LIKE sna_file.sna03a,  #變更後料號
			sna03b	LIKE sna_file.sna03b,  #變更前料號
			sna05a	LIKE sna_file.sna05a,  #數量(變更後)
			sna05b	LIKE sna_file.sna05b,  #數量(變更前)
			sna161a	LIKE sna_file.sna161a, #實際QPA(變更後)  
			sna161b	LIKE sna_file.sna161b, #實際QPA(變更前)
			sna28a  LIKE sna_file.sna28a,  #替代率(後)
			sna28b  LIKE sna_file.sna28b,  #替代率(前)
			sna12a	LIKE sna_file.sna12a,  #單位(後)
			sna12b	LIKE sna_file.sna12b,  #單位(前)
			sna13a	LIKE sna_file.sna13a,  #轉換率(後)
			sna13b	LIKE sna_file.sna13b,  #轉換率(前)
			sna11a	LIKE sna_file.sna11a,  #旗標(後)
			sna11b	LIKE sna_file.sna11b,  #旗標(前)
			sna08a	LIKE sna_file.sna08a,  #作業代號(後)
			sna08b	LIKE sna_file.sna08b,  #作業代號(前)
			sna50	LIKE sna_file.sna50,   #備註
                        ima02a LIKE ima_file.ima02,    #品名(後)
                        ima02b LIKE ima_file.ima02     #品名(前)
           	END RECORD,
           l_i		LIKE type_file.num5,       
           l_sql	LIKE type_file.chr1000    
    DEFINE l_detail1    LIKE ze_file.ze03,       
           l_detail2    LIKE ze_file.ze03,      
           l_cnt	LIKE type_file.num5,   
           l_gfe02b     LIKE gfe_file.gfe02,
           l_gfe02a     LIKE gfe_file.gfe02,
           l_ima02      LIKE ima_file.ima02,#單頭品名
           l_sfb02_d    LIKE ze_file.ze03,  #工單性質說明
           l_snbconf    LIKE ze_file.ze03,  #發出
           l_sna11b_d   LIKE ze_file.ze03,  #變更前旗標說明
           l_sna11a_d   LIKE ze_file.ze03   #變更後旗標說明
    DEFINE l_ze01       LIKE ze_file.ze01   
 
 
 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
    LET l_sql ="SELECT ",
     "snb01 ,snb02,  snb022 ,snb08b,snb08a,snb13b,snb13a,snb15b,snb15a,snb82b, ",
     "snb82a,snbuser,snbconf,sfb05, sfb02 ,sfb09 ,sna04 ,sna03a,sna03b,sna05a,",
     "sna05b,sna161a,sna161b,sna28a ,sna28b,sna12a,sna12b,sna13a,sna13b,sna11a,",
     "sna11b,sna08a,sna08b ,sna50, '','' ",
     "  FROM snb_file, OUTER sna_file, OUTER sfb_file",
     " WHERE snb01 = sna_file.sna01 ",
     "   AND snb02 = sna_file.sna02 ",
     "   AND snb01 = sfb_file.sfb01 ",
     "   AND snb01 = '", g_formNum CLIPPED, "'",
     "   AND snb02 = ", g_key1 CLIPPED
 
 
    PREPARE ef_pre FROM l_sql
    IF STATUS THEN
       CALL cl_err('prepare: ', STATUS, 0)
       LET g_strXMLInput = ''
       RETURN
    END IF
    DECLARE ef_cur CURSOR FOR ef_pre
 
    LET l_i = 1
    FOREACH ef_cur INTO sr.*
        SELECT ima02 INTO sr.ima02b FROM ima_file
         WHERE ima01 = sr.sna03b
        SELECT ima02 INTO sr.ima02a FROM ima_file
         WHERE ima01 = sr.sna03a
 
        IF NOT cl_null(sr.sna12b) THEN
          SELECT gfe02 INTO l_gfe02b FROM gfe_file
           WHERE gfe01 = sr.sna12b
          IF STATUS THEN
             CALL cl_err3("sel","gfe_file",sr.sna12b,"",STATUS,"","foreach:", 0)   #No.FUN-660155)   #No.FUN-660155
             LET g_strXMLInput = ''
             RETURN
          END IF
        END IF
        IF NOT cl_null(sr.sna12a) THEN
          SELECT gfe02 INTO l_gfe02a FROM gfe_file
           WHERE gfe01 = sr.sna12a
          IF STATUS THEN
             CALL cl_err3("sel","gfe_file",sr.sna12a,"",STATUS,"","foreach:", 0)   #No.FUN-660155)   #No.FUN-660155
             LET g_strXMLInput = ''
             RETURN
          END IF
        END IF
 
      #單身旗標(後)
        LET l_sna11b_d = NULL
        IF NOT cl_null(sr.sna11b) THEN
          CASE WHEN sr.sna11b ='N' LET l_ze01="aws-050" 
               WHEN sr.sna11b ='E' LET l_ze01="aws-051" 
               WHEN sr.sna11b ='V' LET l_ze01="aws-052" 
               WHEN sr.sna11b ='U' LET l_ze01="aws-053" 
               WHEN sr.sna11b ='R' LET l_ze01="aws-054" 
          END CASE
          SELECT ze03 INTO l_sna11b_d FROM ze_file
             WHERE ze01 = l_ze01 AND ze02 = g_lang
        END IF
 
      #單身旗標(前)
        LET l_sna11a_d = NULL
        IF NOT cl_null(sr.sna11a) THEN
          CASE WHEN sr.sna11a ='N' LET l_ze01="aws-050" 
               WHEN sr.sna11a ='E' LET l_ze01="aws-051" 
               WHEN sr.sna11a ='V' LET l_ze01="aws-052" 
               WHEN sr.sna11a ='U' LET l_ze01="aws-053" 
               WHEN sr.sna11a ='R' LET l_ze01="aws-054" 
          END CASE
          SELECT ze03 INTO l_sna11a_d FROM ze_file
             WHERE ze01 = l_ze01 AND ze02 = g_lang
        END IF 
 
 
 
        IF l_i = 1 THEN
 
           #Determine if has detail record
           SELECT COUNT(*) INTO l_cnt FROM snb_file
            WHERE snb01 = sr.snb01 AND snb02 = sr.snb02
   
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
           #工單性質
            CASE WHEN sr.sfb02 = 1 LET l_ze01="asf-841" 
                 WHEN sr.sfb02 = 5 LET l_ze01="asf-842" 
                 WHEN sr.sfb02 = 7 LET l_ze01="asf-843" 
                 WHEN sr.sfb02 = 8 LET l_ze01="asf-856" 
                 WHEN sr.sfb02 =11 LET l_ze01="asf-853" 
                 WHEN sr.sfb02 =13 LET l_ze01="asf-844" 
                 WHEN sr.sfb02 =15 LET l_ze01="asf-855" 
            END CASE
              SELECT ze03 INTO l_sfb02_d FROM ze_file
                 WHERE ze01 = l_ze01 AND ze02 = g_lang
 
         #發出
            CASE WHEN sr.snbconf = 'Y' LET l_ze01="aws-055" 
                 WHEN sr.snbconf = 'N' LET l_ze01="aws-056" 
            END CASE
              SELECT ze03 INTO l_snbconf FROM ze_file
                 WHERE ze01 = l_ze01 AND ze02 = g_lang
         ###
 
           LET g_strXMLInput = g_strXMLInput CLIPPED,
		       #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
               "     <snb01 type=\"0\">",sr.snb01 CLIPPED   ,"</snb01>",  ASCII 10,
               "     <snb02 type=\"1\">",sr.snb02 CLIPPED   ,"</snb02>",  ASCII 10,
               "     <snb022 type=\"0\">",sr.snb022 CLIPPED ,"</snb022>", ASCII 10,
               "     <snb08b type=\"1\">",sr.snb08b CLIPPED ,"</snb08b>", ASCII 10,
               "     <snb08a type=\"1\">",sr.snb08a CLIPPED ,"</snb08a>", ASCII 10,
               "     <snb13b type=\"0\">",sr.snb13b CLIPPED ,"</snb13b>", ASCII 10,
               "     <snb13a type=\"0\">",sr.snb13a CLIPPED ,"</snb13a>", ASCII 10,
               "     <snb15b type=\"0\">",sr.snb15b CLIPPED ,"</snb15b>", ASCII 10,
               "     <snb15a type=\"0\">",sr.snb15a CLIPPED ,"</snb15a>", ASCII 10,
               "     <snb82b type=\"0\">",sr.snb82b CLIPPED ,"</snb82b>", ASCII 10,
               "     <snb82a type=\"0\">",sr.snb82a CLIPPED ,"</snb82a>", ASCII 10,
               "     <snbuser type=\"0\">",sr.snbuser CLIPPED,"</snbuser>",ASCII 10,
               "     <snbconf type=\"0\">",sr.snbconf CLIPPED,':',l_snbconf CLIPPED,"</snbconf>",ASCII 10,
               "     <sfb05 type=\"0\">",sr.sfb05 CLIPPED,' ',l_ima02 CLIPPED  ,"</sfb05>",  ASCII 10,
               "     <sfb02 type=\"1\">",sr.sfb02 CLIPPED,"</sfb02>",  ASCII 10,
               "     <sfb02_d type=\"0\">",l_sfb02_d CLIPPED ,"</sfb02_d>",  ASCII 10, 
               "     <sfb09 type=\"1\">",sr.sfb09  ,"</sfb09>",  ASCII 10,
			   #---FUN-BB0061---end-------
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
			#---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
            "      <dummy01 type=\"1\">",  sr.sna04 CLIPPED, "-", l_detail1 CLIPPED, "</dummy01>", ASCII 10,
            "      <dummy02 type=\"0\">",  sr.sna03b CLIPPED, "</dummy02>", ASCII 10,
            "      <dummy03 type=\"0\">",  sr.ima02b CLIPPED, "</dummy03>", ASCII 10, 
            "      <dummy04 type=\"1\">",  sr.sna05b CLIPPED, "</dummy04>", ASCII 10,
            "      <dummy05 type=\"1\">",  sr.sna161b CLIPPED,"</dummy05>", ASCII 10,
            "      <dummy051 type=\"1\">", sr.sna28b CLIPPED, "</dummy051>", ASCII 10,
            "      <dummy06 type=\"0\">",  sr.sna12b CLIPPED, "</dummy06>", ASCII 10,
            "      <dummy07 type=\"1\">",  sr.sna13b CLIPPED, "</dummy07>", ASCII 10,
            "      <dummy08 type=\"0\">",  sr.sna11b CLIPPED,' ',l_sna11b_d CLIPPED,  "</dummy08>", ASCII 10,
            "      <dummy09 type=\"0\">",  sr.sna08b CLIPPED, "</dummy09>", ASCII 10,
            "      <dummy10 type=\"0\"></dummy10>", ASCII 10,
            "     </record>", ASCII 10
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
            "      <dummy01 type=\"1\">",  sr.sna04 CLIPPED, "-", l_detail2 CLIPPED, "</dummy01>", ASCII 10,
            "      <dummy02 type=\"0\">",  sr.sna03a CLIPPED, "</dummy02>", ASCII 10,
            "      <dummy03 type=\"0\">",  sr.ima02a CLIPPED, "</dummy03>", ASCII 10,
            "      <dummy04 type=\"1\">",  sr.sna05a CLIPPED, "</dummy04>", ASCII 10,
            "      <dummy05 type=\"1\">",  sr.sna161a CLIPPED,"</dummy05>", ASCII 10,
            "      <dummy051 type=\"1\">", sr.sna28a CLIPPED, "</dummy051>", ASCII 10,
            "      <dummy06 type=\"0\">",  sr.sna12a CLIPPED, "</dummy06>", ASCII 10,
            "      <dummy07 type=\"1\">",  sr.sna13a CLIPPED, "</dummy07>", ASCII 10,
            "      <dummy08 type=\"0\">",  sr.sna11a CLIPPED,' ',l_sna11a_d CLIPPED,  "</dummy08>", ASCII 10,
            "      <dummy09 type=\"0\">",  sr.sna08a CLIPPED, "</dummy09>", ASCII 10,
            "      <dummy10 type=\"0\">",  sr.sna50 CLIPPED,  "</dummy10>", ASCII 10,
			#---FUN-BB0061---end-------
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
