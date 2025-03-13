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
# Modify.........: No.FUN-B70014 11/07/06 By Lilan 新建立
# Modify.........: No:FUN-BB0061 11/11/10 By Jay EasyFlow送簽時針對數值資料增加XML tag內容
 
DATABASE ds
 
#---------------------------------------------------------------------
# Include global variable file: awsef.4gl
# *Don't need to change
#---------------------------------------------------------------------
##FUN-B70014 

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
    DEFINE sr RECORD
                pne01   LIKE pne_file.pne01, 
                pne02   LIKE pne_file.pne02, 
                pne03   LIKE pne_file.pne03, 
                pne04   LIKE pne_file.pne04, 
                azf03   LIKE azf_file.azf03,
                pne05   LIKE pne_file.pne05, 
                gen02   LIKE gen_file.gen02, 
                pne09   LIKE pne_file.pne09, 
                pne09b  LIKE pne_file.pne09b, 
                pne10   LIKE pne_file.pne10, 
                pne10b  LIKE pne_file.pne10b, 
                pne11   LIKE pne_file.pne11, 
                pne11b  LIKE pne_file.pne11b, 
                pne12   LIKE pne_file.pne12, 
                pne12b  LIKE pne_file.pne12b, 
                pne13   LIKE pne_file.pne13, 
                pne13b  LIKE pne_file.pne13b, 
                pneuser LIKE pne_file.pneuser,
                pnf03   LIKE pnf_file.pnf03, 
                pnf04b  LIKE pnf_file.pnf04b, 
                pnf04a  LIKE pnf_file.pnf04a, 
                pnf041b LIKE pnf_file.pnf041b, 
                pnf041a LIKE pnf_file.pnf041a,    
                ima021b LIKE ima_file.ima021, 
                ima021a LIKE ima_file.ima021, 
                pnf20b  LIKE pnf_file.pnf20b,
                pnf20a  LIKE pnf_file.pnf20a,
                pnf07b  LIKE pnf_file.pnf07b,
                pnf07a  LIKE pnf_file.pnf07a,
                pnf41b  LIKE pnf_file.pnf41b,
                pnf41a  LIKE pnf_file.pnf41a,
                pnf12b  LIKE pnf_file.pnf12b, 
                pnf12a  LIKE pnf_file.pnf12a, 
                pnf121b LIKE pnf_file.pnf121b, 
                pnf121a LIKE pnf_file.pnf121a, 
                pnf122b LIKE pnf_file.pnf122b, 
                pnf122a LIKE pnf_file.pnf122a, 
                pnf33b  LIKE pnf_file.pnf33b, 
                pnf33a  LIKE pnf_file.pnf33a, 
                pnf50   LIKE pnf_file.pnf50 
              END RECORD,
           l_i		LIKE type_file.num5,         
           l_sql	LIKE type_file.chr1000       
    DEFINE l_detail1    LIKE ze_file.ze03,          
           l_detail2    LIKE ze_file.ze03,         
           l_cnt	LIKE type_file.num5         
    DEFINE l_pne09                    LIKE azi_file.azi02,  #幣別
           l_pne09b                   LIKE azi_file.azi02,  #幣別
           l_pne10                    LIKE pma_file.pma02,  #付款條件
           l_pne10b                   LIKE pma_file.pma02,  #付款條件
           l_pne11                    LIKE pnz_file.pnz02,  #價格條件       
           l_pne11b                   LIKE pnz_file.pnz02,  #價格條件      
           l_pne12                    STRING,               #送貨地址
           l_pne12b                   STRING, 
           l_pne13                    STRING,               #帳款地址
           l_pne13b                   STRING 
    DEFINE l_add1,l_add2,l_add3,
           l_add4,l_add5              LIKE pme_file.pme031  #地址         
 
 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
    LET l_sql = "SELECT a.pne01, a.pne02, a.pne03, a.pne04, c.azf03,",
                "       a.pne05, d.gen02, a.pne09, a.pne09b,", 
                "       a.pne10, a.pne10b, a.pne11, a.pne11b, ",
                "       a.pne12, a.pne12b, a.pne13, a.pne13b, a.pneuser,",
                "       b.pnf03, b.pnf04b, b.pnf04a, b.pnf041b, b.pnf041a,",    
                "       e.ima021 ima021b, f.ima021 ima021a, b.pnf20b, b.pnf20a,",
                "       b.pnf07b, b.pnf07a, b.pnf41b, b.pnf41a,", 
                "       b.pnf12b, b.pnf12a, b.pnf121b, b.pnf121a, b.pnf122b, b.pnf122a,", 
                "       b.pnf33b, b.pnf33a, b.pnf50",
                "  FROM pne_file a",
                " INNER JOIN pnf_file b on a.pne01=b.pnf01 AND a.pne02=b.pnf02", 
                "  LEFT JOIN azf_file c on a.pne04=c.azf01 ",
                "  LEFT JOIN gen_file d on a.pne05=d.gen01 ",
                "  LEFT JOIN ima_file e on b.pnf04b=e.ima01",
                "  LEFT JOIN ima_file f on b.pnf04a=f.ima01",
                " WHERE a.pnemksg = 'Y'",                        #是否簽核
                "   AND a.pneacti = 'Y'",                        #有效資料
                "   AND a.pne01 = '",g_formNum CLIPPED, "'",     #變更單號
                "   AND a.pne02 = ", g_key1 CLIPPED              #變更版本

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
           #Determine if has detail record
           SELECT COUNT(*) INTO l_cnt 
             FROM pnf_file
            WHERE pnf01 = sr.pne01 
              AND pnf02 = sr.pne02
   
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

           #幣別
           SELECT azi02 INTO l_pne09  FROM azi_file WHERE azi01 = sr.pne09
           SELECT azi02 INTO l_pne09b FROM azi_file WHERE azi01 = sr.pne09b

           #付款條件
           SELECT pma02 INTO l_pne10  FROM pma_file WHERE pma01 = sr.pne10
           SELECT pma02 INTO l_pne10b FROM pma_file WHERE pma01 = sr.pne10b

           #價格條件
           SELECT pnz02 INTO l_pne11  FROM pnz_file WHERE pnz01 = sr.pne11
           SELECT pnz02 INTO l_pne11b FROM pnz_file WHERE pnz01 = sr.pne11b

           #送貨地址
           SELECT pme031,pme032,pme033,pme034,pme035
             INTO l_add1,l_add2,l_add3,l_add4,l_add5 
             FROM pme_file WHERE pme01 = sr.pne12
           LET l_pne12 = l_add1 CLIPPED,l_add2 CLIPPED, l_add3 CLIPPED, l_add4 CLIPPED, l_add5 CLIPPED

           LET l_add1 = ''
           LET l_add2 = '' 
           LET l_add3 = ''
           LET l_add4 = ''
           LET l_add5 = ''
           SELECT pme031,pme032,pme033,pme034,pme035
             INTO l_add1,l_add2,l_add3,l_add4,l_add5
             FROM pme_file WHERE pme01 = sr.pne12b
           LET l_pne12b = l_add1 CLIPPED,l_add2 CLIPPED, l_add3 CLIPPED, l_add4 CLIPPED, l_add5 CLIPPED

           #帳款地址
           LET l_add1 = ''
           LET l_add2 = '' 
           LET l_add3 = ''
           LET l_add4 = ''
           LET l_add5 = ''
           SELECT pme031,pme032,pme033,pme034,pme035
             INTO l_add1,l_add2,l_add3,l_add4,l_add5
             FROM pme_file WHERE pme01 = sr.pne13
           LET l_pne13 = l_add1 CLIPPED,l_add2 CLIPPED, l_add3 CLIPPED, l_add4 CLIPPED, l_add5 CLIPPED

           LET l_add1 = ''
           LET l_add2 = '' 
           LET l_add3 = ''
           LET l_add4 = ''
           LET l_add5 = ''
           SELECT pme031,pme032,pme033,pme034,pme035
             INTO l_add1,l_add2,l_add3,l_add4,l_add5
             FROM pme_file WHERE pme01 = sr.pne13b
           LET l_pne13b = l_add1 CLIPPED,l_add2 CLIPPED, l_add3 CLIPPED, l_add4 CLIPPED, l_add5 CLIPPED

           LET g_strXMLInput = g_strXMLInput CLIPPED,
		       #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
               "     <pne01 type=\"0\">",  sr.pne01 CLIPPED,  "</pne01>", ASCII 10,
               "     <pne02 type=\"1\">",  sr.pne02 CLIPPED, "</pne02>", ASCII 10,
               "     <pne03 type=\"0\">",  sr.pne03 CLIPPED,  "</pne03>", ASCII 10,
               "     <pne04 type=\"0\">",  sr.pne04 CLIPPED,  "</pne04>", ASCII 10,    
               "     <azf03 type=\"0\">",  sr.azf03 CLIPPED,  "</azf03>", ASCII 10,   
               "     <pne05 type=\"0\">",  sr.pne05 CLIPPED,  "</pne05>", ASCII 10,
               "     <gen02 type=\"0\">",  sr.gen02 CLIPPED,  "</gen02>", ASCII 10,
               "     <pne09 type=\"0\">",  sr.pne09 CLIPPED,  ' ',l_pne09  CLIPPED,"</pne09>", ASCII 10,
               "     <pne09b type=\"0\">", sr.pne09b CLIPPED, ' ',l_pne09b CLIPPED,"</pne09b>", ASCII 10,
               "     <pne10 type=\"0\">",  sr.pne10 CLIPPED,  ' ',l_pne10  CLIPPED,"</pne10>", ASCII 10,
               "     <pne10b type=\"0\">", sr.pne10b CLIPPED, ' ',l_pne10b CLIPPED,"</pne10b>", ASCII 10,
               "     <pne11 type=\"0\">",  sr.pne11 CLIPPED,  ' ',l_pne11  CLIPPED,"</pne11>", ASCII 10,
               "     <pne11b type=\"0\">", sr.pne11b CLIPPED, ' ',l_pne11b CLIPPED,"</pne11b>", ASCII 10,
               "     <pne12 type=\"0\">",  sr.pne12 CLIPPED,  ' ',l_pne12  CLIPPED,"</pne12>", ASCII 10,
               "     <pne12b type=\"0\">", sr.pne12b CLIPPED, ' ',l_pne12b CLIPPED,"</pne12b>", ASCII 10,
               "     <pne13 type=\"0\">",  sr.pne13 CLIPPED,  ' ',l_pne13  CLIPPED,"</pne13>", ASCII 10,
               "     <pne13b type=\"0\">", sr.pne13b CLIPPED, ' ',l_pne13b CLIPPED,"</pne13b>", ASCII 10,
               "     <pneuser type=\"0\">",sr.pneuser CLIPPED,"</pneuser>", ASCII 10,
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
               "      <dummy01 type=\"1\">", sr.pnf03 CLIPPED, "-", l_detail1 CLIPPED, "</dummy01>", ASCII 10,
               "      <dummy02 type=\"0\">", sr.pnf04b CLIPPED, "</dummy02>", ASCII 10,
               "      <dummy03 type=\"0\">", sr.pnf041b CLIPPED, "</dummy03>", ASCII 10,
               "      <dummy04 type=\"0\">", sr.ima021b CLIPPED, "</dummy04>", ASCII 10,
               "      <dummy06 type=\"1\">", sr.pnf20b CLIPPED, "</dummy06>", ASCII 10,
               "      <dummy05 type=\"0\">", sr.pnf07b CLIPPED, "</dummy05>", ASCII 10,
               "      <dummy11 type=\"0\">", sr.pnf41b CLIPPED, "</dummy11>", ASCII 10,
               "      <dummy07 type=\"0\">", sr.pnf12b CLIPPED, "</dummy07>", ASCII 10,
               "      <dummy071 type=\"0\">", sr.pnf121b CLIPPED, "</dummy071>", ASCII 10,
               "      <dummy08 type=\"0\">", sr.pnf122b CLIPPED, "</dummy08>", ASCII 10,
               "      <dummy09 type=\"0\">", sr.pnf33b CLIPPED, "</dummy09>", ASCII 10,
			   #---FUN-BB0061---end-------
               "      <dummy10></dummy10>", ASCII 10,
               "     </record>", ASCII 10
    
           LET g_strXMLInput = g_strXMLInput CLIPPED,
               "     <record>", ASCII 10,
			   #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
               "      <dummy01 type=\"1\">", sr.pnf03 CLIPPED, "-", l_detail2 CLIPPED, "</dummy01>", ASCII 10,
               "      <dummy02 type=\"0\">", sr.pnf04a CLIPPED, "</dummy02>", ASCII 10,
               "      <dummy03 type=\"0\">", sr.pnf041a CLIPPED, "</dummy03>", ASCII 10,
               "      <dummy04 type=\"0\">", sr.ima021a CLIPPED, "</dummy04>", ASCII 10,
               "      <dummy06 type=\"1\">", sr.pnf20a CLIPPED, "</dummy06>", ASCII 10,
               "      <dummy05 type=\"0\">", sr.pnf07a CLIPPED, "</dummy05>", ASCII 10,
               "      <dummy11 type=\"0\">", sr.pnf41a CLIPPED, "</dummy11>", ASCII 10,
               "      <dummy07 type=\"0\">", sr.pnf12a CLIPPED, "</dummy07>", ASCII 10,
               "      <dummy071 type=\"0\">", sr.pnf121a CLIPPED, "</dummy071>", ASCII 10,
               "      <dummy08 type=\"0\">", sr.pnf122a CLIPPED, "</dummy08>", ASCII 10,
               "      <dummy09 type=\"0\">", sr.pnf33a CLIPPED, "</dummy09>", ASCII 10,
               "      <dummy10 type=\"0\">", sr.pnf50 CLIPPED, "</dummy10>", ASCII 10,
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
