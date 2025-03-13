# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify.........: No.FUN-680130 06/09/05 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-930113 09/03/19 By mike 將oah_file-->pnz_file
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
			pnb20a	LIKE pnb_file.pnb20a,
			pnb20b	LIKE pnb_file.pnb20b,
			pnb31a	LIKE pnb_file.pnb31a,
			pnb31b	LIKE pnb_file.pnb31b,
			pnb33a	LIKE pnb_file.pnb33a,
			pnb33b	LIKE pnb_file.pnb33b,
			pnb50	LIKE pnb_file.pnb50,
                        ima021a LIKE ima_file.ima021,
                        ima021b LIKE ima_file.ima021,
                        tota    LIKE pnb_file.pnb31a,
                        totb    LIKE pnb_file.pnb31b
           	END RECORD,
           l_i		LIKE type_file.num5,         #No.FUN-680130 SMALLINT
           l_sql	LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(1000)
    DEFINE l_detail1    LIKE ze_file.ze03,           #No.FUN-680130 VARCHAR(100)
           l_detail2    LIKE ze_file.ze03,           #No.FUN-680130 VARCHAR(100)
           l_amt        LIKE ze_file.ze03,           #No.FUN-680130 VARCHAR(50)
           l_cnt	LIKE type_file.num5          #No.FUN-680130 SMALLINT
    DEFINE l_pma02      LIKE  pma_file.pma02, 
           l_pma02b     LIKE  pma_file.pma02, 
           l_pnz02      LIKE  pnz_file.pnz02, #FUN-930113 
           l_pnz02b     LIKE  pnz_file.pnz02, #FUN-930113 
           l_pme031_11  LIKE  pme_file.pme031,
           l_pme032_11  LIKE  pme_file.pme032,
           l_pme031_12  LIKE  pme_file.pme031,
           l_pme032_12  LIKE  pme_file.pme032,
           l_pme031_11b LIKE  pme_file.pme031,
           l_pme032_11b LIKE  pme_file.pme032,
           l_pme031_12b LIKE  pme_file.pme031,
           l_pme032_12b LIKE  pme_file.pme032,
           l_pmm12      LIKE  pmm_file.pmm12,
           l_qty        LIKE type_file.num10,                #No.FUN-680130 INTEGER
           l_up         LIKE type_file.num10                 #No.FUN-680130 INTEGER
 
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
                " pnb20a,pnb20b, pnb31a,pnb31b, pnb33a, pnb33b, ",
                " pnb50, ' ', ' ', ' ', ' '",
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
        LET sr.totb = sr.pnb20b * sr.pnb31b
 
       IF cl_null(sr.pnb20a) THEN    #變更後沒有數量取變更前
           LET l_qty=sr.pnb20b
        ELSE
           LET l_qty=sr.pnb20a
        END IF
        IF cl_null(sr.pnb31a) THEN    #變更後沒有單價取變更前
           LET l_up=sr.pnb31b
        ELSE
           LET l_up=sr.pnb31a
        END IF
        LET sr.tota = l_qty * l_up
        #LET sr.tota = sr.pnb20a * sr.pnb31a
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
#	Call aws_efcli_XMLHeader() to compose XML Header
#	Pass corresponding formCreator & formOwner value as parameters
#
# *Another REMARK:
#       If this applicaton has compound key as unique key
#       Let g_formNum equals following type:
#           LET g_formNum = g_formNum CLIPPED, "{+}key_column=", g_key1 CLIPPED, ....
#       That means what follow & seprate by {+} is WHERE CONDITION
#---------------------------------------------------------------------
           #No:8176
           LET g_formNum = g_formNum CLIPPED, "{+}pna02=", g_key1 CLIPPED
           ##
 
           SELECT pmm12 INTO l_pmm12 FROM pmm_file where pmm01 = sr.pna01
           display l_pmm12
        CALL aws_efcli_XMLHeader(sr.pnauser, l_pmm12)
 
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
              IF SQLCA.sqlcode THEN LET l_pnz02 ='' END IF #FUN-930113 
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
 
           LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <pna01>", sr.pna01  CLIPPED, "</pna01>",  ASCII 10,
               "     <pna02>", sr.pna02  CLIPPED, "</pna02>",  ASCII 10,
               "     <pna04>", sr.pna04  CLIPPED, "</pna04>",  ASCII 10,
               "     <pna08>", sr.pna08  CLIPPED, "</pna08>",  ASCII 10,
               "     <pna08b>",sr.pna08b CLIPPED, "</pna08b>", ASCII 10,
               "     <pna09>", sr.pna09  CLIPPED, ' ', l_pnz02   CLIPPED, "</pna09>",  ASCII 10, #FUN-930113 
               "     <pna09b>",sr.pna09b CLIPPED, ' ', l_pnz02b  CLIPPED, "</pna09b>", ASCII 10, #FUN-930113 
               "     <pna10>", sr.pna10  CLIPPED, ' ', l_pma02   CLIPPED, "</pna10>",  ASCII 10,
               "     <pna10b>",sr.pna10b CLIPPED, ' ', l_pma02b  CLIPPED, "</pna10b>", ASCII 10,
               "     <pna11>", sr.pna11  CLIPPED, ' ', l_pme031_11  CLIPPED, l_pme032_11  CLIPPED, "</pna11>",  ASCII 10,
               "     <pna11b>",sr.pna11b CLIPPED, ' ', l_pme031_11b CLIPPED, l_pme032_11b CLIPPED, "</pna11b>", ASCII 10,
               "     <pna12>", sr.pna12  CLIPPED, ' ', l_pme031_12  CLIPPED, l_pme032_12  CLIPPED, "</pna12>",  ASCII 10,
               "     <pna12b>",sr.pna12b CLIPPED, ' ', l_pme031_12b CLIPPED, l_pme032_12b CLIPPED, "</pna12b>", ASCII 10,
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
            "     <record>", ASCII 10,
            "      <dummy01>", sr.pnb03 CLIPPED, "-", l_detail1 CLIPPED, "</dummy01>", ASCII 10,
            "      <dummy02>", sr.pnb04b CLIPPED, "</dummy02>", ASCII 10,
            "      <dummy03>", sr.pnb041b CLIPPED, "</dummy03>", ASCII 10,
            "      <dummy04>", sr.ima021b CLIPPED, "</dummy04>", ASCII 10,
            "      <dummy05>", sr.pnb20b CLIPPED, "</dummy05>", ASCII 10,
            "      <dummy06>", sr.pnb07b CLIPPED, "</dummy06>", ASCII 10,
            "      <dummy07>", sr.pnb31b CLIPPED, "</dummy07>", ASCII 10,
            "      <dummy08>", sr.totb CLIPPED, "</dummy08>", ASCII 10,
            "      <dummy09>", sr.pnb33b CLIPPED, "</dummy09>", ASCII 10,
            "      <dummy10></dummy10>", ASCII 10,
            "     </record>", ASCII 10
 
        LET g_strXMLInput = g_strXMLInput CLIPPED,            #變更後
            "     <record>", ASCII 10,
            "      <dummy01>", sr.pnb03 CLIPPED, "-", l_detail2 CLIPPED, "</dummy01>", ASCII 10,
            "      <dummy02>", sr.pnb04a CLIPPED, "</dummy02>", ASCII 10,
            "      <dummy03>", sr.pnb041a CLIPPED, "</dummy03>", ASCII 10,
            "      <dummy04>", sr.ima021a CLIPPED, "</dummy04>", ASCII 10,
            "      <dummy05>", sr.pnb20a CLIPPED, "</dummy05>", ASCII 10,
            "      <dummy06>", sr.pnb07a CLIPPED, "</dummy06>", ASCII 10,
            "      <dummy07>", sr.pnb31a CLIPPED, "</dummy07>", ASCII 10,
            "      <dummy08>", sr.tota CLIPPED, "</dummy08>", ASCII 10,
            "      <dummy09>", sr.pnb33a CLIPPED, "</dummy09>", ASCII 10,
            "      <dummy10>", sr.pnb50 CLIPPED, "</dummy10>", ASCII 10,
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
