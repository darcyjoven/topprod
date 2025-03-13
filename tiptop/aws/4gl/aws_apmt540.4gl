# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Modify.........: No.FUN-680130 06/09/04 By zhuying 欄位形態定義為LIKE
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
			pmm01	LIKE pmm_file.pmm01,
			pmm02	LIKE pmm_file.pmm02,
			pmm03	LIKE pmm_file.pmm03,
			pmm04	LIKE pmm_file.pmm04,
			pmm06	LIKE pmm_file.pmm06,
			pmm09	LIKE pmm_file.pmm09,
                        pmm10   LIKE pmm_file.pmm10,
                        pmm11   LIKE pmm_file.pmm11,
                        pmm12   LIKE pmm_file.pmm12,
			pmm13	LIKE pmm_file.pmm13,
			pmm14	LIKE pmm_file.pmm14,
			pmm15	LIKE pmm_file.pmm15,
			pmm16	LIKE pmm_file.pmm16,
			pmm17	LIKE pmm_file.pmm17,
			pmm20	LIKE pmm_file.pmm20,
			pmm21	LIKE pmm_file.pmm21,
			pmm22	LIKE pmm_file.pmm22,
			pmm30	LIKE pmm_file.pmm30,
			pmm40	LIKE pmm_file.pmm40,
			pmm41	LIKE pmm_file.pmm41,
			pmm42	LIKE pmm_file.pmm42,
			pmm43	LIKE pmm_file.pmm43,
			pmm44	LIKE pmm_file.pmm44,
			pmm45	LIKE pmm_file.pmm45,
			pmm905	LIKE pmm_file.pmm905,
			pmm99	LIKE pmm_file.pmm99,
			pmmuser LIKE pmm_file.pmmuser,
                        pme031  LIKE pme_file.pme031, 
                        pme032  LIKE pme_file.pme032, 
                        pnz02   LIKE pnz_file.pnz02, #FUN-930113 
                        pma02   LIKE pma_file.pma02,
			pmn02	LIKE pmn_file.pmn02,
			pmn04	LIKE pmn_file.pmn04,
			pmn041	LIKE pmn_file.pmn041,
			pmn07	LIKE pmn_file.pmn07,
			pmn16	LIKE pmn_file.pmn16,
			pmn20	LIKE pmn_file.pmn20,
			pmn24	LIKE pmn_file.pmn24,
			pmn25	LIKE pmn_file.pmn25,
			pmn31	LIKE pmn_file.pmn31,
			pmn33	LIKE pmn_file.pmn33,
			pmn34	LIKE pmn_file.pmn34,
			pmn41	LIKE pmn_file.pmn41,
			pmn42	LIKE pmn_file.pmn42,
			pmn43	LIKE pmn_file.pmn43,
			pmn431	LIKE pmn_file.pmn431,
			pmn63	LIKE pmn_file.pmn63,
			pmn64	LIKE pmn_file.pmn64,
			pmn65	LIKE pmn_file.pmn65,
			pmn68	LIKE pmn_file.pmn68,
			pmn69	LIKE pmn_file.pmn69,
			pmn122	LIKE pmn_file.pmn122,
			ima021	LIKE ima_file.ima021
           	END RECORD,
           l_i		LIKE type_file.num5,         #No.FUN-680130 SMALLINT
           l_sql	LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(1000)
    DEFINE l_pmm02      LIKE gae_file.gae04,         #No.FUN-680130 VARCHAR(100)
           l_pmm44      LIKE gae_file.gae04          #No.FUN-680130 CARCHAR(100)
    DEFINE l_afa02 	LIKE afa_file.afa02, 
           l_pmc03_09   LIKE pmc_file.pmc03,
           l_pmc03_17   LIKE pmc_file.pmc03,
           l_pme031	LIKE pme_file.pme031,
           l_pme032	LIKE pme_file.pme032,
           l_gen02_12   LIKE gen_file.gen02,
           l_gen02_15   LIKE gen_file.gen02,
           l_gem02_13   LIKE gem_file.gem02,
           l_gem02_14   LIKE gem_file.gem02
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
    LET l_sql =
		"SELECT  pmm01, pmm02, pmm03, pmm04, pmm06, ",
                " pmm09, pmm10, pmm11, pmm12, pmm13, pmm14, pmm15, pmm16,",
                " pmm17, pmm20, pmm21, pmm22, pmm30, pmm40, pmm41, pmm42,",
                " pmm43, pmm44, pmm45, pmm905,pmm99, pmmuser,",
                " pme031,pme032, pnz02,pma02,", #FUN-930113 oah-->pnz
                " pmn02, pmn04, pmn041, pmn07, pmn16, pmn20,",
		" pmn24, pmn25, pmn31,  pmn33, pmn34, pmn41,",
                " pmn42, pmn43, pmn431, pmn63, pmn64, pmn65, pmn68,",
                " pmn69, pmn122,",
                " ima021 ",
                "  FROM pmm_file,pmn_file, OUTER pme_file,",
                "  OUTER pnz_file, OUTER pma_file,", #FUN-930113 oah-->pnz
                "  OUTER ima_file ",
                " WHERE pmm01 = pmn01 ",
                "   AND pme_file.pme01 = pmm10 ",
                "   AND pnz_file.pnz01 = pmm41 ", #FUN-930113 oah-->pnz
                "   AND pma_file.pma01 = pmm20 ",
                "   AND ima_file.ima01 = pmn04 ",
                "   AND pmmacti='Y' ",
                "   AND pmm01 = '", g_formNum CLIPPED, "'"
 
 
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
        IF cl_null(sr.pmn20) THEN LET sr.pmn20=0 END IF
        IF cl_null(sr.pmn31) THEN LET sr.pmn31=0 END IF
 
        IF l_i = 1 THEN
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Call aws_efcli_XMLHeader() to compose XML Header
#	Pass corresponding formCreator & formOwner value as parameters
#---------------------------------------------------------------------
        CALL aws_efcli_XMLHeader(sr.pmmuser, sr.pmm12)
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           LET g_msg = "pmm02_", sr.pmm02 CLIPPED
         
            ### MOD-4A0298 ###
           SELECT gae04 INTO l_pmm02 FROM gae_file 
               WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang AND gae11 = 'Y'
           IF SQLCA.SQLCODE THEN
              SELECT gae04 INTO l_pmm02 FROM gae_file 
               WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang
               AND (gae11 IS NULL OR gae11 = 'N')
           END IF
            ### END MOD-4A0298 ###
 
           IF SQLCA.SQLCODE THEN
              LET l_pmm02 = ''
           END IF
 
           LET g_msg = "pmm44_", sr.pmm44 CLIPPED
 
            ###MOD-4A0298###
           SELECT gae04 INTO l_pmm44 FROM gae_file 
               WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang AND gae11 = 'Y'
           IF SQLCA.SQLCODE THEN
              SELECT gae04 INTO l_pmm44 FROM gae_file 
               WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang
                 AND (gae11 IS NULL OR gae11 = 'N')
           END IF
            ### END MOD-4A0298 ###
 
           IF SQLCA.SQLCODE THEN
              LET l_pmm44 = ''
           END IF
 
           #-->預算說明
           SELECT afa02 INTO l_afa02 FROM afa_file 
            WHERE afa01 = sr.pmm06
           IF SQLCA.sqlcode THEN LET l_afa02 = '' END IF
 
           #-->供應商簡稱
           SELECT pmc03 INTO l_pmc03_09 FROM pmc_file
            WHERE pmc01 = sr.pmm09
           IF SQLCA.sqlcode THEN LET l_pmc03_09 = '' END IF
           #-->代理商簡稱
           SELECT pmc03 INTO l_pmc03_17 FROM pmc_file
            WHERE pmc01 = sr.pmm17
           IF SQLCA.sqlcode THEN LET l_pmc03_17 = '' END IF
 
           #-->帳單地址  
           SELECT pme031, pme032 INTO l_pme031, l_pme032 
                  FROM pme_file WHERE pme01 = sr.pmm11
           IF SQLCA.sqlcode THEN 
              LET l_pme031 = ''  LET l_pme032 = ''
           END IF
 
           #-->採購員簡稱
           SELECT gen02 INTO l_gen02_12 FROM gen_file
            WHERE gen01 = sr.pmm12
           IF SQLCA.sqlcode THEN LET l_gen02_12 = '' END IF
 
           #-->確認人簡稱
           SELECT gen02 INTO l_gen02_15 FROM gen_file
            WHERE gen01 = sr.pmm15
           IF SQLCA.sqlcode THEN LET l_gen02_15 = '' END IF
 
           #-->採購部門簡稱
           SELECT gem02 INTO l_gem02_13 FROM gem_file
            WHERE gem01 = sr.pmm13
           IF SQLCA.sqlcode THEN LET l_gem02_13 = '' END IF
 
           #-->收貨部門簡稱
           SELECT gem02 INTO l_gem02_14 FROM gem_file
            WHERE gem01 = sr.pmm14
           IF SQLCA.sqlcode THEN LET l_gem02_14 = '' END IF
 
 
           LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <pmm01>", sr.pmm01 CLIPPED, "</pmm01>", ASCII 10,
               "     <pmm02>", sr.pmm02 CLIPPED, ' ', l_pmm02 CLIPPED, "</pmm02>", ASCII 10,
               "     <pmm03>", sr.pmm03 CLIPPED, "</pmm03>", ASCII 10,
               "     <pmm04>", sr.pmm04 CLIPPED, "</pmm04>", ASCII 10,
               "     <pmm06>", sr.pmm06 CLIPPED, ' ', l_afa02    CLIPPED, "</pmm06>", ASCII 10,
               "     <pmm09>", sr.pmm09 CLIPPED, ' ', l_pmc03_09 CLIPPED, "</pmm09>", ASCII 10,
               "     <pmm10>", sr.pmm10 CLIPPED, ' ', sr.pme031  CLIPPED, ' ', sr.pme032 CLIPPED, "</pmm10>", ASCII 10,
               "     <pmm11>", sr.pmm11 CLIPPED, ' ', l_pme031   CLIPPED, ' ', l_pme032  CLIPPED, "</pmm11>", ASCII 10,
               "     <pmm12>", sr.pmm12 CLIPPED, ' ', l_gen02_12 CLIPPED, "</pmm12>", ASCII 10,
               "     <pmm13>", sr.pmm13 CLIPPED, ' ', l_gem02_13 CLIPPED, "</pmm13>", ASCII 10,
               "     <pmm14>", sr.pmm14 CLIPPED, ' ', l_gem02_14 CLIPPED, "</pmm14>", ASCII 10,
               "     <pmm15>", sr.pmm15 CLIPPED, ' ', l_gen02_15 CLIPPED, "</pmm15>", ASCII 10,
               "     <pmm16>", sr.pmm16 CLIPPED, "</pmm16>", ASCII 10,
               "     <pmm17>", sr.pmm17 CLIPPED, ' ', l_pmc03_17 CLIPPED, "</pmm17>", ASCII 10,
               "     <pmm20>", sr.pmm20 CLIPPED, ' ', sr.pma02   CLIPPED, "</pmm20>", ASCII 10,
               "     <pmm21>", sr.pmm21 CLIPPED, "</pmm21>", ASCII 10,
               "     <pmm22>", sr.pmm22 CLIPPED, "</pmm22>", ASCII 10,
               "     <pmm30>", sr.pmm30 CLIPPED, "</pmm30>", ASCII 10,
               "     <pmm40>", sr.pmm40 CLIPPED, "</pmm40>", ASCII 10,
               "     <pmm41>", sr.pmm41 CLIPPED, ' ', sr.pnz02 CLIPPED, "</pmm41>", ASCII 10, #FUN-930113 
               "     <pmm42>", sr.pmm42 CLIPPED, "</pmm42>", ASCII 10,
               "     <pmm43>", sr.pmm43 CLIPPED, "</pmm43>", ASCII 10,
               "     <pmm44>", sr.pmm44 CLIPPED, ' ', l_pmm44 CLIPPED, "</pmm44>", ASCII 10,
               "     <pmm45>", sr.pmm45 CLIPPED, "</pmm45>", ASCII 10,
               "     <pmm905>",sr.pmm905 CLIPPED,"</pmm905>",ASCII 10,
               "     <pmm99>", sr.pmm99 CLIPPED, "</pmm99>", ASCII 10,
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
        END IF
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose detail data
#	Modify tag name & corresponding value if want to use another one
#	If this program hasn't detail data, don't need to care about this block
#---------------------------------------------------------------------
 
        CASE 
            WHEN g_prog CLIPPED = "apmt540"
                 LET g_strXMLInput = g_strXMLInput CLIPPED,
                     "     <record>", ASCII 10,
                     "      <pmn02>", sr.pmn02  CLIPPED, "</pmn02>",  ASCII 10,
                     "      <pmn24>", sr.pmn24  CLIPPED, "</pmn24>",  ASCII 10,
                     "      <pmn25>", sr.pmn25  CLIPPED, "</pmn25>",  ASCII 10,
                     "      <pmn42>", sr.pmn42  CLIPPED, "</pmn42>",  ASCII 10,
                     "      <pmn16>", sr.pmn16  CLIPPED, "</pmn16>",  ASCII 10,
                     "      <pmn04>", sr.pmn04  CLIPPED, "</pmn04>",  ASCII 10,
                     "      <pmn041>",sr.pmn041 CLIPPED, "</pmn041>", ASCII 10,
                     "      <ima021>",sr.ima021 CLIPPED, "</ima021>", ASCII 10,
                     "      <pmn07>", sr.pmn07  CLIPPED, "</pmn07>",  ASCII 10,
                     "      <pmn20>", sr.pmn20  CLIPPED, "</pmn20>",  ASCII 10,
                     "      <pmn68>", sr.pmn68  CLIPPED, "</pmn68>",  ASCII 10,
                     "      <pmn69>", sr.pmn69  CLIPPED, "</pmn69>",  ASCII 10,
                     "      <pmn31>", sr.pmn31  CLIPPED, "</pmn31>",  ASCII 10,
                     "      <pmn64>", sr.pmn64  CLIPPED, "</pmn64>",  ASCII 10,
                     "      <pmn63>", sr.pmn63  CLIPPED, "</pmn63>",  ASCII 10,
                     "      <pmn33>", sr.pmn33  CLIPPED, "</pmn33>",  ASCII 10,
                     "      <pmn34>", sr.pmn34  CLIPPED, "</pmn34>",  ASCII 10,
                     "      <pmn122>",sr.pmn122 CLIPPED, "</pmn122>", ASCII 10,
                     "     </record>", ASCII 10
 
            WHEN g_prog CLIPPED = "apmt590"
                 LET g_strXMLInput = g_strXMLInput CLIPPED,
                     "     <record>", ASCII 10,
                     "      <pmn02>", sr.pmn02  CLIPPED, "</pmn02>",  ASCII 10,
                     "      <pmn24>", sr.pmn24  CLIPPED, "</pmn24>",  ASCII 10,
                     "      <pmn25>", sr.pmn25  CLIPPED, "</pmn25>",  ASCII 10,
                     "      <pmn65>", sr.pmn65  CLIPPED, "</pmn65>",  ASCII 10,
                     "      <pmn41>", sr.pmn41  CLIPPED, "</pmn41>",  ASCII 10,
                     "      <pmn42>", sr.pmn42  CLIPPED, "</pmn42>",  ASCII 10,
                     "      <pmn16>", sr.pmn16  CLIPPED, "</pmn16>",  ASCII 10,
                     "      <pmn04>", sr.pmn04  CLIPPED, "</pmn04>",  ASCII 10,
                     "      <pmn041>",sr.pmn041 CLIPPED, "</pmn041>", ASCII 10,
                     "      <ima021>",sr.ima021 CLIPPED, "</ima021>", ASCII 10,
                     "      <pmn07>", sr.pmn07  CLIPPED, "</pmn07>",  ASCII 10,
                     "      <pmn20>", sr.pmn20  CLIPPED, "</pmn20>",  ASCII 10,
                     "      <pmn68>", sr.pmn68  CLIPPED, "</pmn68>",  ASCII 10,
                     "      <pmn69>", sr.pmn69  CLIPPED, "</pmn69>",  ASCII 10,
                     "      <pmn31>", sr.pmn31  CLIPPED, "</pmn31>",  ASCII 10,
                     "      <pmn64>", sr.pmn64  CLIPPED, "</pmn64>",  ASCII 10,
                     "      <pmn63>", sr.pmn63  CLIPPED, "</pmn63>",  ASCII 10,
                     "      <pmn33>", sr.pmn33  CLIPPED, "</pmn33>",  ASCII 10,
                     "      <pmn34>", sr.pmn34  CLIPPED, "</pmn34>",  ASCII 10,
                     "      <pmn122>",sr.pmn122 CLIPPED, "</pmn122>", ASCII 10,
                     "      <pmn43>", sr.pmn43  CLIPPED, "</pmn43>",  ASCII 10,
                     "      <pmn431>",sr.pmn431 CLIPPED, "</pmn431>", ASCII 10,
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
