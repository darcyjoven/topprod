# Prog. Version..: '5.30.06-13.03.12(00003)'     #
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
# Modify........: No.FUN-5A0136 05/12/06 Echo 欠缺欄位:資料所有者中文姓名
# Modify........: No.FUN-680130 06/09/04 By zhuying 欄位形態定義為LIKE
# Modify........: No.TQC-870026 08/08/15 By Vicky 新增欄位
# Modify........: No.FUN-930113 09/03/19 By mike 將oah_file-->pnz_file
# Modify........: No.MOD-940176 09/04/14 By Smapmin 新增採購項次時,無法開單
# Modify........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify........: No:MOD-B50217 11/05/30 By Summer 金額計算改用計價數量
# Modify........: No:FUN-BB0061 11/11/10 By Jay EasyFlow送簽時針對數值資料增加XML tag內容
 
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
			pna01	LIKE pna_file.pna01,
			pna02	LIKE pna_file.pna02,
			pna04	LIKE pna_file.pna04,
			pna08	LIKE pna_file.pna08,
			pna08b	LIKE pna_file.pna08b,
			pna09	LIKE pna_file.pna09,
			pna09b	LIKE pna_file.pna09b,
			pna10	LIKE pna_file.pna10,
			pna10b	LIKE pna_file.pna10b,
			pna11	LIKE pna_file.pna11,
			pna11b	LIKE pna_file.pna11b,
			pna12	LIKE pna_file.pna12,
			pna12b	LIKE pna_file.pna12b,
                        pnauser LIKE pna_file.pnauser,
			pnb03	LIKE pnb_file.pnb03,
			pnb04a	LIKE pnb_file.pnb04a,
			pnb04b	LIKE pnb_file.pnb04b,
			pnb041a	LIKE pnb_file.pnb041a,
			pnb041b	LIKE pnb_file.pnb041b,
			pnb07a	LIKE pnb_file.pnb07a,
			pnb07b	LIKE pnb_file.pnb07b,
			#pnb20a	LIKE pnb_file.pnb20a,   #MOD-B50217
			#pnb20b	LIKE pnb_file.pnb20b,   #MOD-B50217
			pnb87a	LIKE pnb_file.pnb87a,   #MOD-B50217
			pnb87b	LIKE pnb_file.pnb87b,   #MOD-B50217
			pnb31a	LIKE pnb_file.pnb31a,
			pnb31b	LIKE pnb_file.pnb31b,
			pnb33a	LIKE pnb_file.pnb33a,
			pnb33b	LIKE pnb_file.pnb33b,
			pnb50	LIKE pnb_file.pnb50,
                        ima021a LIKE ima_file.ima021,
                        ima021b LIKE ima_file.ima021,
                        tota    LIKE pnb_file.pnb31a,
                        totb    LIKE pnb_file.pnb31b,
                        #--TQC-870026--start--
                        pna15  LIKE pna_file.pna15,
                        pnb90  LIKE pnb_file.pnb90,
                        pnb91  LIKE pnb_file.pnb91,
                        pnb90b LIKE pnb_file.pnb90, #變更前請購單號
                        pnb91b LIKE pnb_file.pnb91, #變更前請購單號項次
                        pnb32a LIKE pnb_file.pnb32a,
                        pnb32b LIKE pnb_file.pnb32b,
                        totta  LIKE pnb_file.pnb32a,
                        tottb  LIKE pnb_file.pnb32b
                        #--TQC-870026--end--
           	END RECORD,
           l_i		LIKE type_file.num5,         #No.FUN-680130 SMALLINT
           l_sql	LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(1000)
    DEFINE l_detail1    LIKE ze_file.ze03,           #No.FUN-680130 VARCHAR(100)
           l_detail2    LIKE ze_file.ze03,           #No.FUN-680130 VARCHAR(100)
           l_amt        LIKE ze_file.ze03,           #No.FUN-680130 VARCHAR(50)
           l_cnt	LIKE type_file.num5,         #No.FUN-680130 SMALLINT
           l_cnt2       LIKE type_file.num5          #MOD-940176 
    DEFINE l_pma02      LIKE  pma_file.pma02, 
           l_pma02b     LIKE  pma_file.pma02, 
           l_pnz02      LIKE  pnz_file.pnz02,  #FUN-930113 
           l_pnz02b     LIKE  pnz_file.pnz02,  #FUN-930113 
           l_pme031_11  LIKE  pme_file.pme031,
           l_pme032_11  LIKE  pme_file.pme032,
           l_pme031_12  LIKE  pme_file.pme031,
           l_pme032_12  LIKE  pme_file.pme032,
           l_pme031_11b LIKE  pme_file.pme031,
           l_pme032_11b LIKE  pme_file.pme032,
           l_pme031_12b LIKE  pme_file.pme031,
           l_pme032_12b LIKE  pme_file.pme032,
           l_pmm12      LIKE  pmm_file.pmm12,
           l_qty        LIKE  pnb_file.pnb20a,         #No.FUN-680130 INTEGER
           l_up         LIKE  pnb_file.pnb31a,         #No.FUN-680130 INTEGER
           lt_up        LIKE  pnb_file.pnb32a          #TQC-870026
#FUN-5A0136
DEFINE     l_zx02       LIKE  zx_file.zx02,
           l_azi02      LIKE  azi_file.azi02,      
           l_azi02b     LIKE  azi_file.azi02,
           #--TQC-870026--start--
           l_pmm09      LIKE  pmm_file.pmm09, #(供應廠商)
           l_pmc03      LIKE  pmc_file.pmc03,
           l_pmm21      LIKE  pmm_file.pmm21, #(稅別)
           l_pmm43      LIKE  pmm_file.pmm43,
           l_gec07      LIKE  gec_file.gec07, #(單價含稅)
           l_azf03      LIKE  azf_file.azf03
           #--TQC-870026--end--
#FUN-5A0136
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
    LET l_sql =
		"SELECT  pna01,  pna02, pna04,  pna08,  pna08b, pna09, pna09b,",
		" pna10, pna10b, pna11, pna11b, pna12,  pna12b, pnauser, ",
                " pnb03, pnb04a, pnb04b,pnb041a,pnb041b,pnb07a, pnb07b,",
                #" pnb20a,pnb20b, pnb31a,pnb31b, pnb33a, pnb33b, ",   #MOD-B50217
                " pnb87a,pnb87b, pnb31a,pnb31b, pnb33a, pnb33b, ",   #MOD-B50217
                " pnb50, ' ', ' ', ' ', ' ', ",
                " pna15,pnb90, pnb91, '', '', ",     #TQC-870026
                " pnb32a, pnb32b, '', '' ",         #TQC-870026
                "  FROM pna_file, OUTER pnb_file",
                " WHERE pna01 = pnb_file.pnb01 ",
                "   AND pna02 = pnb_file.pnb02 ",
                "   AND pnaacti = 'Y' ",
                "   AND pna01 = '", g_formNum CLIPPED, "'",
                #No:8176
                "   AND pna02 = ", g_key1 CLIPPED
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
       IF NOT cl_null(sr.pnb04b) THEN
        SELECT ima021 INTO sr.ima021b FROM ima_file
         WHERE sr.pnb04b = ima01
       ELSE
        LET sr.ima021b = ' '
       END IF
       IF NOT cl_null(sr.pnb04a) THEN
        SELECT ima021 INTO sr.ima021a FROM ima_file
         WHERE sr.pnb04a = ima01
       ELSE
        LET sr.ima021a = ' '
       END IF
 
       #-----MOD-B50217---------
       #LET sr.totb = sr.pnb20b * sr.pnb31b
       #LET sr.tottb = sr.pnb20b * sr.pnb32b  #--TQC-870026
       # 
       #IF cl_null(sr.pnb20a) THEN    #變更後沒有數量取變更前
       #    LET l_qty=sr.pnb20b
       # ELSE
       #    LET l_qty=sr.pnb20a
       #END IF

       LET sr.totb = sr.pnb87b * sr.pnb31b
       LET sr.tottb = sr.pnb87b * sr.pnb32b  #--TQC-870026
       
       IF cl_null(sr.pnb87a) THEN    #變更後沒有數量取變更前
           LET l_qty=sr.pnb87b
       ELSE
           LET l_qty=sr.pnb87a
       END IF
       #-----END MOD-B50217-----
       IF cl_null(sr.pnb31a) THEN    #變更後沒有未稅單價取變更前
          LET l_up=sr.pnb31b
       ELSE
          LET l_up=sr.pnb31a
       END IF
       #--TQC-870026--start--
       IF cl_null(sr.pnb32a) THEN    #變更後沒有含稅單價取變更前
          LET lt_up=sr.pnb32b
       ELSE
          LET lt_up=sr.pnb32a
       END IF
       #--TQC-870026--End--
 
        LET sr.tota = l_qty * l_up
        #LET sr.tota = sr.pnb20a * sr.pnb31a
        LET sr.totta = l_qty*lt_up       #--TQC-870026
 
        #-----MOD-940176---------
        LET l_cnt2 = 0 
        SELECT COUNT(*) INTO l_cnt2 FROM pmn_file
          WHERE pmn01 = sr.pna01 AND pmn02 = sr.pnb03
        IF l_cnt2 > 0 THEN
        #-----END MOD-940176-----  
           #--TQC-870026--Start--
           SELECT pmn24,pmn25 INTO sr.pnb90b,sr.pnb91b
             FROM pmn_file
            WHERE pmn01= sr.pna01  AND pmn02 = sr.pnb03
           
           #IF SQLCA.sqlcode THEN
           #   LET sr.pnb90b = ""
           #   LET sr.pnb91b = ""
           #END IF
           #--TQC-870026--End--
        #-----MOD-940176---------
        ELSE
           LET sr.pnb90b = ""
           LET sr.pnb91b = ""
        END IF
        #-----END MOD-940176-----  
 
        IF STATUS THEN
           CALL cl_err('foreach: ', STATUS, 0)
           LET g_strXMLInput = ''
           RETURN
        END IF
 
        IF l_i = 1 THEN
 
           #Determine if has detail record
           SELECT COUNT(*) INTO l_cnt FROM pnb_file
            WHERE pnb01 = sr.pna01 AND pnb02 = sr.pna02
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Call aws_efcli2_XMLHeader() to compose XML Header
#	Pass corresponding formCreator & formOwner value as parameters
#
# *Another REMARK:
#       If this applicaton has compound key as unique key
#       Let g_formNum equals following type:
#           LET g_formNum = g_formNum CLIPPED, "{+}key_column=", g_key1 CLIPPED, ....
#       That means what follow & seprate by {+} is WHERE CONDITION
#---------------------------------------------------------------------
        CALL aws_efcli2_XMLHeader()
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           IF NOT cl_null(sr.pna10) THEN
              SELECT pma02 INTO l_pma02 FROM pma_file
               WHERE pma01 = sr.pna10
              IF SQLCA.sqlcode THEN LET l_pma02 ='' END IF 
           END IF
           IF NOT cl_null(sr.pna10b) THEN
              SELECT pma02 INTO l_pma02b FROM pma_file
               WHERE pma01 = sr.pna10b
              IF SQLCA.sqlcode THEN LET l_pma02b ='' END IF 
           END IF
           
           IF NOT cl_null(sr.pna09) THEN
              SELECT pnz02 INTO l_pnz02 FROM pnz_file #FUN-930113 oah-->pnz
               WHERE pnz01 = sr.pna09 #FUN-930113 oah-->pnz
              IF SQLCA.sqlcode THEN LET l_pnz02 ='' END IF  #FUN-930113 
           END IF
           IF NOT cl_null(sr.pna09b) THEN
              SELECT pnz02 INTO l_pnz02b FROM pnz_file #FUN-930113 oah-->pnz
               WHERE pnz01 = sr.pna09b #FUN-930113 oah-->pnz
              IF SQLCA.sqlcode THEN LET l_pnz02b ='' END IF #FUN-930113 
           END IF
 
           SELECT pme031, pme032 INTO l_pme031_11,l_pme032_11 FROM pme_file
            WHERE pme01 = sr.pna11 AND pme02 != '1'
           IF SQLCA.sqlcode THEN 
              LET l_pme031_11 = ''  LET l_pme032_11 = ''
           END IF
           SELECT pme031, pme032 INTO l_pme031_11b,l_pme032_11b FROM pme_file
            WHERE pme01 = sr.pna11b AND pme02 != '1'
           IF SQLCA.sqlcode THEN 
              LET l_pme031_11b = ''  LET l_pme032_11b = ''
           END IF
 
           SELECT pme031, pme032 INTO l_pme031_12, l_pme032_12 FROM pme_file
            WHERE pme01 = sr.pna12 AND pme02 != '0'
           IF SQLCA.sqlcode THEN 
              LET l_pme031_12 = ''  LET l_pme032_12 = ''
           END IF
 
           SELECT pme031, pme032 INTO l_pme031_12b, l_pme032_12b FROM pme_file
            WHERE pme01 = sr.pna12b AND pme02 != '0'
           IF SQLCA.sqlcode THEN 
              LET l_pme031_12b = ''  LET l_pme032_12b = ''
           END IF
 
           #FUN-5A0136
           SELECT zx02 INTO l_zx02 FROM zx_file
            WHERE zx01 = sr.pnauser
 
           SELECT azi02 INTO l_azi02 FROM azi_file             
            WHERE azi01 = sr.pna08
 
           SELECT azi02 INTO l_azi02b FROM azi_file          
            WHERE azi01 = sr.pna08b
 
           #END FUN-5A0136
 
           #--TQC-870026 --start--
           SELECT pmm09,pmc03,pmm21,pmm43,gec07
             INTO l_pmm09,l_pmc03,l_pmm21,l_pmm43,l_gec07
             FROM pmm_file,OUTER pmc_file,OUTER gec_file
            WHERE pmm01 = sr.pna01
              AND pmm09 = pmc_file.pmc01
              AND pmm21 = gec_file.gec01
 
                 IF cl_null(l_pmm09) THEN
                         LET l_pmm09=""
                 END IF
 
                 IF cl_null(l_pmc03) THEN
                         LET l_pmc03=""
                 END IF
 
                IF cl_null(l_pmm21) THEN
                         LET l_pmm21=""
                END IF
 
                IF cl_null(l_pmm43) THEN
                         LET l_pmm43=""
                END IF
 
                IF cl_null(l_gec07) THEN
                         LET l_gec07=""
                END IF
 
               SELECT azf03 INTO l_azf03
                 FROM azf_file
                WHERE azf01 = sr.pna15
                  AND azf02 = '2'
 
                  IF cl_null(l_azf03) THEN
                           LET l_azf03=""
                  END IF
         #--TQC-870026 --end--
 
           LET g_strXMLInput = g_strXMLInput CLIPPED,
               #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
			   "     <pna01 type=\"0\">", sr.pna01  CLIPPED, "</pna01>",  ASCII 10,
               "     <pna02 type=\"1\">", sr.pna02  CLIPPED, "</pna02>",  ASCII 10,
               "     <pna04 type=\"0\">", sr.pna04  CLIPPED, "</pna04>",  ASCII 10,
               "     <pna08 type=\"0\">", sr.pna08  CLIPPED, ' ', l_azi02   CLIPPED, "</pna08>",  ASCII 10, #FUN-5A0136
               "     <pna08b type=\"0\">",sr.pna08b CLIPPED, ' ', l_azi02b  CLIPPED, "</pna08b>", ASCII 10, #FUN-5A0136
               "     <pna09 type=\"0\">", sr.pna09  CLIPPED, ' ', l_pnz02   CLIPPED, "</pna09>",  ASCII 10, #FUN-930113 
               "     <pna09b type=\"0\">",sr.pna09b CLIPPED, ' ', l_pnz02b  CLIPPED, "</pna09b>", ASCII 10, #FUN-930113 
               "     <pna10 type=\"0\">", sr.pna10  CLIPPED, ' ', l_pma02   CLIPPED, "</pna10>",  ASCII 10,
               "     <pna10b type=\"0\">",sr.pna10b CLIPPED, ' ', l_pma02b  CLIPPED, "</pna10b>", ASCII 10,
               "     <pna11 type=\"0\">", sr.pna11  CLIPPED, ' ', l_pme031_11  CLIPPED, l_pme032_11  CLIPPED, "</pna11>",  ASCII 10,
               "     <pna11b type=\"0\">",sr.pna11b CLIPPED, ' ', l_pme031_11b CLIPPED, l_pme032_11b CLIPPED, "</pna11b>", ASCII 10,
               "     <pna12 type=\"0\">", sr.pna12  CLIPPED, ' ', l_pme031_12  CLIPPED, l_pme032_12  CLIPPED, "</pna12>",  ASCII 10,
               "     <pna12b type=\"0\">",sr.pna12b CLIPPED, ' ', l_pme031_12b CLIPPED, l_pme032_12b CLIPPED, "</pna12b>", ASCII 10,
               "     <pnauser type=\"0\">",sr.pnauser CLIPPED,' ',l_zx02 CLIPPED, "</pnauser>", ASCII 10,   #FUN-5A0136
               #--TQC-870026--start--
               "     <pna15 type=\"0\">", sr.pna15  CLIPPED, "</pna15>",  ASCII 10,
               "     <pmm09 type=\"0\">", l_pmm09  CLIPPED, "</pmm09>",  ASCII 10,
               "     <pmc03 type=\"0\">", l_pmc03  CLIPPED, "</pmc03>",  ASCII 10,
               "     <pmm21 type=\"0\">", l_pmm21  CLIPPED, "</pmm21>",  ASCII 10,
               "     <pmm43 type=\"1\">", l_pmm43  CLIPPED, "</pmm43>",  ASCII 10,
               "     <gec07 type=\"0\">", l_gec07  CLIPPED, "</gec07>",  ASCII 10,
               "     <azf03 type=\"0\">", l_azf03  CLIPPED, "</azf03>",  ASCII 10,
               #--TQC-870026--end--
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
        CALL cl_getmsg('aws-028',g_lang) RETURNING g_msg
        LET l_amt = g_msg
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,            #變更前
		    #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
            "     <record>", ASCII 10,
            "      <dummy01 type=\"0\">", sr.pnb03 CLIPPED, "-", l_detail1 CLIPPED, "</dummy01>", ASCII 10,
            "      <dummy02 type=\"0\">", sr.pnb04b CLIPPED, "</dummy02>", ASCII 10,
            "      <dummy03 type=\"0\">", sr.pnb041b CLIPPED, "</dummy03>", ASCII 10,
            "      <dummy04 type=\"0\">", sr.ima021b CLIPPED, "</dummy04>", ASCII 10,
            "      <dummy05 type=\"0\">", sr.pnb07b CLIPPED, "</dummy05>", ASCII 10,
            #"      <dummy06>", sr.pnb20b CLIPPED, "</dummy06>", ASCII 10,   #MOD-B50217
            "      <dummy06 type=\"1\">", sr.pnb87b CLIPPED, "</dummy06>", ASCII 10,   #MOD-B50217
            "      <dummy07 type=\"1\">", sr.pnb31b CLIPPED, "</dummy07>", ASCII 10,
            "      <dummy08 type=\"1\">", sr.totb CLIPPED, "</dummy08>", ASCII 10,
            "      <dummy09 type=\"0\">", sr.pnb33b CLIPPED, "</dummy09>", ASCII 10,
            "      <dummy10 type=\"0\"></dummy10>", ASCII 10,
            #--TQC-870026 --start--
            "      <dummy11 type=\"0\">", sr.pnb90b CLIPPED, "</dummy11>", ASCII 10,
            "      <dummy12 type=\"1\">", sr.pnb91b CLIPPED, "</dummy12>", ASCII 10,
            "      <dummy071 type=\"1\">", sr.pnb32b CLIPPED, "</dummy071>", ASCII 10,
            "      <dummy088 type=\"1\">", sr.tottb CLIPPED, "</dummy088>", ASCII 10,
            #--TQC-870026 --end--
            "     </record>", ASCII 10
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,            #變更後
            "     <record>", ASCII 10,
            "      <dummy01 type=\"0\">", sr.pnb03 CLIPPED, "-", l_detail2 CLIPPED, "</dummy01>", ASCII 10,
            "      <dummy02 type=\"0\">", sr.pnb04a CLIPPED, "</dummy02>", ASCII 10,
            "      <dummy03 type=\"0\">", sr.pnb041a CLIPPED, "</dummy03>", ASCII 10,
            "      <dummy04 type=\"0\">", sr.ima021a CLIPPED, "</dummy04>", ASCII 10,
            "      <dummy05 type=\"0\">", sr.pnb07a CLIPPED, "</dummy05>", ASCII 10,
            #"      <dummy06>", sr.pnb20a CLIPPED, "</dummy06>", ASCII 10,   #MOD-B50217
            "      <dummy06 type=\"1\">", sr.pnb87a CLIPPED, "</dummy06>", ASCII 10,   #MOD-B50217
            "      <dummy07  type=\"1\">", sr.pnb31a CLIPPED, "</dummy07>", ASCII 10,
            "      <dummy08 type=\"1\">", sr.tota CLIPPED, "</dummy08>", ASCII 10,
            "      <dummy09 type=\"0\">", sr.pnb33a CLIPPED, "</dummy09>", ASCII 10,
            "      <dummy10 type=\"0\">", sr.pnb50 CLIPPED, "</dummy10>", ASCII 10,
            #--TQC-870026 --start--
            "      <dummy11 type=\"0\">", sr.pnb90 CLIPPED, "</dummy11>", ASCII 10,
            "      <dummy12 type=\"1\">", sr.pnb91 CLIPPED, "</dummy12>", ASCII 10,
            "      <dummy071 type=\"1\">", sr.pnb32a CLIPPED, "</dummy071>", ASCII 10,
            "      <dummy088 type=\"1\">", sr.totta CLIPPED, "</dummy088>", ASCII 10,
            #--TQC-870026 --end--
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
