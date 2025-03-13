# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify.........: No.FUN-550069 05/05/25 By Will 單據編號放大
# Modify.........: No.FUN-680130 06/09/04 By zhuying 欄位形態定義為LIKE 
# Modify.........: No.FUN-930113 09/03/19 By mike 將oah_file-->pnz_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#將 Global 變數檔(awsef.4gl)包含進來
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
 
#Function name 固定為 aws_efcli_cf()
FUNCTION aws_efcli_cf()
    #定義 RECORD for SELECT SQL
    DEFINE sr	RECORD
                	pmk01	LIKE pmk_file.pmk01,
                        pmk02   LIKE pmk_file.pmk02,
                	pmk03	LIKE pmk_file.pmk03,
                	pmk04	LIKE pmk_file.pmk04,
                        pmk06   LIKE pmk_file.pmk06,
                        pmk09   LIKE pmk_file.pmk09,
                        pmk10   LIKE pmk_file.pmk10,
                        pmk11   LIKE pmk_file.pmk11,
                        pmk12   LIKE pmk_file.pmk12,
                	pmk13	LIKE pmk_file.pmk13,
                	pmk14	LIKE pmk_file.pmk14,
                	pmk15	LIKE pmk_file.pmk15,
                	pmk16	LIKE pmk_file.pmk16,
                	pmk17	LIKE pmk_file.pmk17,
                	pmk20	LIKE pmk_file.pmk20,
                	pmk21	LIKE pmk_file.pmk21,
                	pmk22	LIKE pmk_file.pmk22,
                	pmk30	LIKE pmk_file.pmk30,
                	pmk41	LIKE pmk_file.pmk41,
                	pmk42	LIKE pmk_file.pmk42,
                	pmk43	LIKE pmk_file.pmk43,
                	pmk45	LIKE pmk_file.pmk45,
                	pmkuser	LIKE pmk_file.pmkuser,
                	gem02	LIKE gem_file.gem02,
                        pmc03   LIKE pmc_file.pmc03,
                	pma02	LIKE pma_file.pma02,
                	pnz02	LIKE pnz_file.pnz02, #FUN-930113 
                	pme031	LIKE pme_file.pme031,
                	pme032	LIKE pme_file.pme032,
                	pml02	LIKE pml_file.pml02,
                	pml04	LIKE pml_file.pml04,
                	pml041	LIKE pml_file.pml041,
                	pml06	LIKE pml_file.pml06,
                	pml07	LIKE pml_file.pml07,
                        pml12   LIKE pml_file.pml12,
                        pml121  LIKE pml_file.pml121,
                        pml122  LIKE pml_file.pml122,
                	pml20	LIKE pml_file.pml20,
                        pml21   LIKE pml_file.pml21,
                	pml33	LIKE pml_file.pml33,
                	pml41	LIKE pml_file.pml41,
                        ima021  LIKE ima_file.ima021
           	END RECORD
    DEFINE l_pme031	LIKE pme_file.pme031,
           l_pme032	LIKE pme_file.pme032,
           l_afa02      LIKE afa_file.afa02,
           l_gen02_12   LIKE gen_file.gen02, 
           l_gen02_15   LIKE gen_file.gen02, 
           l_gem02_14   LIKE gem_file.gem02,
           l_pmc03_17   LIKE pmc_file.pmc03,
           l_pmk02desc  LIKE gae_file.gae04,         #No.FUN-680130 VARCHAR(100)
           l_i		LIKE type_file.num5,         #No.FUN-680130 SMALLINT
           l_sql	LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(1000)
        
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    #抓取資料的 SQL
    LET l_sql = "SELECT pmk01,pmk02,pmk03,pmk04,pmk06,pmk09,pmk10,",
                "       pmk11,pmk12,pmk13,pmk14,pmk15,pmk16,pmk17,",
                "       pmk20,pmk21,pmk22,pmk30,pmk41,pmk42,pmk43,",
                "       pmk45,pmkuser,",
                "       gem02,pmc03,pma02,pnz02,pme031,pme032,", #FUN-930113 oah-->pnz
                "       pml02,pml04,pml041,pml06,pml07,pml12,pml121,pml122,",
                "       pml20,pml21,pml33,pml41, ",
                "       ima021",
                "  FROM pmk_file,pml_file,OUTER smy_file,OUTER pmc_file, ",
                " OUTER pme_file,OUTER pma_file,OUTER gem_file,",
                " OUTER pnz_file,OUTER ima_file", #FUN-930113 oah-->pnz
                " WHERE pmk01 = pml01 ",
#                "   AND smy_file.smyslip= SUBSTR(pmk01,1,3) ",
                "   AND pmk01 like smyslip || '-%' ",   #No.FUN-550069
                "   AND pmc_file.pmc01 = pmk09 ",
                "   AND pme_file.pme01 = pmk10 ",
                "   AND pma_file.pma01 = pmk20 ",
                "   AND gem_file.gem01 = pmk13 ",
                "   AND pnz_file.pnz01 = pmk41 ", #FUN-930113 oah-->pnz
                "   AND pml04 = ima_file.ima01 ",
                "   AND pmkacti='Y' ",
                "   AND pmk01 = '", g_formNum CLIPPED, "'"
 
    PREPARE ef_pre FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:', SQLCA.sqlcode, 1) 
       LET g_strXMLInput = ''   #不成功則為空字串
       RETURN
    END IF
    DECLARE ef_cur CURSOR FOR ef_pre
 
    LET l_i = 1
    FOREACH ef_cur INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:', SQLCA.sqlcode, 1) 
           LET g_strXMLInput = ''   #不成功則為空字串
           RETURN
        END IF
 
        #當 l_i = 1時, 組單頭資訊
        IF l_i = 1 THEN
           #-->預算說明
           SELECT afa02 INTO l_afa02 
                  FROM afa_file WHERE afa01 = sr.pmk06
           IF SQLCA.sqlcode THEN LET l_afa02  = '' END IF
 
           #-->帳單地址
           SELECT pme031, pme032 INTO l_pme031, l_pme032 
                  FROM pme_file WHERE pme01 = sr.pmk11
           IF SQLCA.sqlcode THEN 
              LET l_pme031 = ''   LET l_pme032 = ''
           END IF
           #-->請購人員姓名
           SELECT gen02  INTO l_gen02_12
                  FROM gen_file WHERE gen01 = sr.pmk12
           IF SQLCA.sqlcode THEN 
              LET l_gen02_12 = '' 
           END IF
           #-->確認人員姓名
           SELECT gen02  INTO l_gen02_15
                  FROM gen_file WHERE gen01 = sr.pmk15
           IF SQLCA.sqlcode THEN 
              LET l_gen02_15 = '' 
           END IF
           #-->收貨部門簡稱  
           SELECT gem02  INTO l_gem02_14
                  FROM gem_file WHERE gem01 = sr.pmk14
           IF SQLCA.sqlcode THEN 
              LET l_gem02_14  = '' 
           END IF
           #-->代理商簡稱  
           SELECT pmc03  INTO l_pmc03_17
                  FROM pmc_file WHERE pmc01 = sr.pmk17
           IF SQLCA.sqlcode THEN 
              LET l_pmc03_17  = '' 
           END IF
           
           LET g_msg = "pmk02_", sr.pmk02 CLIPPED
         
            ### MOD-4A0298 ###
           SELECT gae04 INTO l_pmk02desc FROM gae_file 
              WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang AND gae11 = 'Y'
           IF SQLCA.sqlcode THEN 
             SELECT gae04 INTO l_pmk02desc FROM gae_file 
               WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang
              AND (gae11 IS NULL OR gae11 = 'N')
           END IF
             ### END MOD-4A0298 ###
 
           IF SQLCA.sqlcode THEN 
              LET l_pmk02desc  = '' 
           END IF
 
           #呼叫 aws_efcli_XMLHeader() 並傳入填表人跟關係人組出 XML Header 資訊
           CALL aws_efcli_XMLHeader(sr.pmkuser, sr.pmk12)
 
           #將單頭的資訊加入
           LET g_strXMLInput = g_strXMLInput CLIPPED,
               "     <pmk01>", sr.pmk01 CLIPPED, "</pmk01>", ASCII 10,
               "     <pmk02>", sr.pmk02 CLIPPED, ' ', l_pmk02desc CLIPPED, "</pmk02>", ASCII 10,
               "     <pmk03>", sr.pmk03 CLIPPED, "</pmk03>", ASCII 10,
               "     <pmk04>", sr.pmk04 CLIPPED, "</pmk04>", ASCII 10,
               "     <pmk06>", sr.pmk06 CLIPPED, ' ', l_afa02    CLIPPED, "</pmk06>", ASCII 10,
               "     <pmk09>", sr.pmk09 CLIPPED, ' ', sr.pmc03   CLIPPED, "</pmk09>", ASCII 10,
               "     <pmk10>", sr.pmk10 CLIPPED, ' ', sr.pme031  CLIPPED, ' ', sr.pme032 CLIPPED, "</pmk10>", ASCII 10,
               "     <pmk11>", sr.pmk11 CLIPPED, ' ', l_pme031   CLIPPED, ' ', l_pme032  CLIPPED, "</pmk11>", ASCII 10,
               "     <pmk12>", sr.pmk12 CLIPPED, ' ', l_gen02_12 CLIPPED, "</pmk12>", ASCII 10,
               "     <pmk13>", sr.pmk13 CLIPPED, ' ', sr.gem02   CLIPPED, "</pmk13>", ASCII 10,
               "     <pmk14>", sr.pmk14 CLIPPED, ' ', l_gem02_14 CLIPPED, "</pmk14>", ASCII 10,
               "     <pmk15>", sr.pmk15 CLIPPED, ' ', l_gen02_15 CLIPPED, "</pmk15>", ASCII 10,
               "     <pmk16>", sr.pmk16 CLIPPED, "</pmk16>", ASCII 10,
               "     <pmk17>", sr.pmk17 CLIPPED, ' ', l_pmc03_17 CLIPPED, "</pmk17>", ASCII 10,
               "     <pmk20>", sr.pmk20 CLIPPED, ' ', sr.pma02 CLIPPED, "</pmk20>", ASCII 10,
               "     <pmk21>", sr.pmk21 CLIPPED, "</pmk21>", ASCII 10,
               "     <pmk22>", sr.pmk22 CLIPPED, "</pmk22>", ASCII 10,
               "     <pmk30>", sr.pmk30 CLIPPED, "</pmk30>", ASCII 10,
               "     <pmk41>", sr.pmk41 CLIPPED, ' ', sr.pnz02 CLIPPED, "</pmk41>", ASCII 10, #FUN-930113 
               "     <pmk42>", sr.pmk42 CLIPPED, "</pmk42>", ASCII 10,
               "     <pmk43>", sr.pmk43 CLIPPED USING '<<&.&&', "</pmk43>", ASCII 10,
               "     <pmk45>", sr.pmk45 CLIPPED, "</pmk45>", ASCII 10,
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
        END IF
 
        #將單身的資訊加入
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
            "      <pml02>", sr.pml02 CLIPPED, "</pml02>", ASCII 10,
            "      <pml04>", sr.pml04 CLIPPED, "</pml04>", ASCII 10,
            "      <pml041>", sr.pml041 CLIPPED, "</pml041>", ASCII 10,
            "      <ima021>", sr.ima021 CLIPPED, "</ima021>", ASCII 10,
            "      <pml07>", sr.pml07 CLIPPED, "</pml07>", ASCII 10,
            "      <pml20>", sr.pml20 CLIPPED, "</pml20>", ASCII 10,
            "      <pml21>", sr.pml21 CLIPPED, "</pml21>", ASCII 10,
            "      <pml33>", sr.pml33 CLIPPED, "</pml33>", ASCII 10,
            "      <pml41>", sr.pml41 CLIPPED, "</pml41>", ASCII 10,
            "      <pml12>", sr.pml12 CLIPPED, "</pml12>", ASCII 10,
            "      <pml121>", sr.pml121 CLIPPED, "</pml121>", ASCII 10,
            "      <pml122>", sr.pml122 CLIPPED, "</pml122>", ASCII 10,
            "      <pml06>", sr.pml06 CLIPPED, "</pml06>", ASCII 10,
            "     </record>", ASCII 10
 
        LET l_i = l_i + 1
    END FOREACH
 
    #呼叫 aws_efcli_XMLTrailer() 組出 XML Trailer 資訊
    CALL aws_efcli_XMLTrailer()
END FUNCTION
