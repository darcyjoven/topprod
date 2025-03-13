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
# Modify.........: No.FUN-930120 09/03/17 By sabrina 建立 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9C0016 09/12/09 By Dido gae_file key值調整 
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
			sfb01	LIKE sfb_file.sfb01,
			sfb101	LIKE sfb_file.sfb101,
			sfb44	LIKE sfb_file.sfb44,
			sfb81	LIKE sfb_file.sfb81,
			sfb02	LIKE sfb_file.sfb02,
			sfb39	LIKE sfb_file.sfb39,
			sfb98	LIKE sfb_file.sfb98,
			sfb82	LIKE sfb_file.sfb82,
			sfb102	LIKE sfb_file.sfb102,
			sfb22	LIKE sfb_file.sfb22,
			sfb221	LIKE sfb_file.sfb221,
			sfb91	LIKE sfb_file.sfb91,
			sfb92	LIKE sfb_file.sfb92,
			sfb86	LIKE sfb_file.sfb86,
			sfb05	LIKE sfb_file.sfb05,
			sfb08	LIKE sfb_file.sfb08,
			sfb07	LIKE sfb_file.sfb07,
			sfb071	LIKE sfb_file.sfb071,
			sfb93	LIKE sfb_file.sfb93,
			sfb06	LIKE sfb_file.sfb06,
			sfb13	LIKE sfb_file.sfb13,
			sfb15	LIKE sfb_file.sfb15,
			sfb23	LIKE sfb_file.sfb23,
			sfb24	LIKE sfb_file.sfb24,
			sfb41	LIKE sfb_file.sfb41,
			sfb99	LIKE sfb_file.sfb99,
			sfb94	LIKE sfb_file.sfb94,
			sfb100	LIKE sfb_file.sfb100,
			sfb34	LIKE sfb_file.sfb34,
			sfb97	LIKE sfb_file.sfb97,
			sfb30	LIKE sfb_file.sfb30,
			sfb31	LIKE sfb_file.sfb31,
			sfb32	LIKE sfb_file.sfb32,
			sfb33	LIKE sfb_file.sfb33,
			sfb222	LIKE sfb_file.sfb222 
           	END RECORD,
           l_i		LIKE type_file.num5,     
           l_sql	LIKE type_file.chr1000
     DEFINE sr1 RECORD
			sfa27  	LIKE sfa_file.sfa27,
			sfa08  	LIKE sfa_file.sfa08,
			sfa26  	LIKE sfa_file.sfa26,
			sfa28 	LIKE sfa_file.sfa28,
			sfa03  	LIKE sfa_file.sfa03,
			sfa12  	LIKE sfa_file.sfa12,
			sfa13  	LIKE sfa_file.sfa13,
			sfa11  	LIKE sfa_file.sfa11,
			sfa161 	LIKE sfa_file.sfa161,
			sfa100 	LIKE sfa_file.sfa100,
			sfa05  	LIKE sfa_file.sfa05,
			sfa065 	LIKE sfa_file.sfa065,
			sfa06  	LIKE sfa_file.sfa06,
			sfa062 	LIKE sfa_file.sfa062,
			sfa07  	LIKE sfa_file.sfa07,
			sfa063 	LIKE sfa_file.sfa063,
			sfa064 	LIKE sfa_file.sfa064,
			sfa30  	LIKE sfa_file.sfa30,
			sfa31  	LIKE sfa_file.sfa31
                END RECORD,
           l_j          LIKE type_file.num5,
           l_sql2       LIKE type_file.chr1000 
     DEFINE sr2 RECORD
                        ecm03   LIKE ecm_file.ecm03,
                        ecm04   LIKE ecm_file.ecm04,    
                        ecm45   LIKE ecm_file.ecm45,    
                        ecm06   LIKE ecm_file.ecm06,    
                        ecm14   LIKE ecm_file.ecm14,    
                        ecm13   LIKE ecm_file.ecm13,    
                        ecm16   LIKE ecm_file.ecm16,    
                        ecm15   LIKE ecm_file.ecm15,    
                        ecm49   LIKE ecm_file.ecm49,    
                        ecm50   LIKE ecm_file.ecm50,    
                        ecm51   LIKE ecm_file.ecm51,    
                        ecm05   LIKE ecm_file.ecm05,    
                        ecm52   LIKE ecm_file.ecm52,    
                        ecm53   LIKE ecm_file.ecm53,    
                        ecm54   LIKE ecm_file.ecm54,    
                        ecm55   LIKE ecm_file.ecm55,    
                        ecm56   LIKE ecm_file.ecm56,    
                        ecm57   LIKE ecm_file.ecm57,    
                        ecm58   LIKE ecm_file.ecm58,    
                        ecm59   LIKE ecm_file.ecm59
                END RECORD,
           l_k          LIKE type_file.num5,  
           l_sql3	LIKE type_file.chr1000
    DEFINE l_smydesc    LIKE smy_file.smydesc, 
           l_t1         LIKE smy_file.smyslip,
           l_gen02      LIKE gen_file.gen02,
           l_gem02      LIKE gem_file.gem02,
           l_pmc03      LIKE pmc_file.pmc03,
           l_ima55      LIKE ima_file.ima55,
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,
           l_ima02_b    LIKE ima_file.ima02,
           l_ima021_b   LIKE ima_file.ima021,
           ima08_b      LIKE ima_file.ima08,
           l_ima08_b    STRING, 
           l_eca02      LIKE eca_file.eca02,
           l_cnt        LIKE type_file.num5,
           l_cnt2       LIKE type_file.num5,
           l_sfb02      STRING, 
           l_sfb39      STRING, 
           l_sfb100     STRING,
           l_sfa26      STRING,
           l_sfa11      STRING,
           l_gae04      STRING
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
     LET l_sql =
		"SELECT sfb01, sfb101, sfb44, sfb81, sfb02, sfb39, sfb98, sfb82,", 
                "sfb102, sfb22, sfb221, sfb91, sfb92, sfb86, sfb05, sfb08, sfb07, sfb071,",          
                "sfb93, sfb06, sfb13, sfb15, sfb23, sfb24, sfb41, sfb99, sfb94, sfb100,",
                "sfb34, sfb97, sfb30, sfb31, sfb32, sfb33, sfb222 ",
                " FROM sfb_file",
                " WHERE sfbacti = 'Y' ",
                "   AND sfb01 = '", g_formNum CLIPPED, "'" 
 
    PREPARE ef_pre FROM l_sql
    IF STATUS THEN
       CALL cl_err('prepare: ', STATUS, 0)
       LET g_strXMLInput = ''
       RETURN
    END IF
    DECLARE ef_cur CURSOR FOR ef_pre
 
    LET l_sql2 =
	       "SELECT sfa27, sfa08, sfa26, sfa28, sfa03, sfa12, sfa13, sfa11, sfa161, sfa100, sfa05, ", 
               "sfa065, sfa06, sfa062, sfa07, sfa063, sfa064, sfa30, sfa31",
	       " FROM sfa_file, sfb_file",
	       " WHERE sfaacti = 'Y' ",
               "   AND sfa01 = sfb_file.sfb01 ",
               "   AND sfa01 = '", g_formNum CLIPPED, "'" 
   PREPARE ef_pre2 FROM l_sql2
   IF STATUS THEN
      CALL cl_err('prepare: ', STATUS, 0)
      LET g_strXMLInput = ''
      RETURN
   END IF
   DECLARE ef_cur2 CURSOR FOR ef_pre2
 
    LET l_sql3 = 
		"SELECT ecm03, ecm04, ecm45, ecm06, ecm14, ecm13, ecm16, ecm15, ",
                "ecm49, ecm50, ecm51, ecm05, ecm52, ecm53, ecm54, ecm55, ecm56, ",
                "ecm57, ecm58, ecm59 ",
                " FROM ecm_file, sfb_file",
                " WHERE ecm01 = sfb_file.sfb01 ",
                "   AND ecmacti = 'Y' ",
                "   AND ecm01 = '", g_formNum CLIPPED, "'" 
    PREPARE ef_pre3 FROM l_sql3
    IF STATUS THEN
    CALL cl_err('prepare: ', STATUS, 0)
    LET g_strXMLInput = ''
    RETURN
    END IF
    DECLARE ef_cur3 CURSOR FOR ef_pre3
 
    LET l_i = 1
    FOREACH ef_cur INTO sr.*
      SELECT gen02 INTO l_gen02 FROM gen_file
       WHERE sr.sfb44 = gen01
      SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE sr.sfb98 = gem01
      IF (sr.sfb02=7 OR sr.sfb02=8 ) THEN
         SELECT pmc03 INTO l_pmc03 FROM pmc_file  
         WHERE sr.sfb82 = pmc01     
      ELSE
         SELECT gem02 INTO l_pmc03 FROM gem_file
          WHERE gem01=sr.sfb82
      END IF            
      SELECT ima55,ima02,ima021 INTO l_ima55,l_ima02,l_ima021 FROM ima_file
       WHERE sr.sfb05 = ima01
     
      IF NOT cl_null(sr.sfb02) THEN
         CALL i301_per('sfb02',sr.sfb02) RETURNING l_gae04
         LET l_sfb02 = sr.sfb02,":",l_gae04
         LET l_sfb02 = l_sfb02.trim()
      END IF
 
      IF NOT cl_null(sr.sfb39) THEN
         CALL i301_per('sfb39',sr.sfb39) RETURNING l_gae04
         LET l_sfb39 = sr.sfb39,":",l_gae04
         LET l_sfb39 = l_sfb39.trim()
      END IF
 
      IF NOT cl_null(sr.sfb100) THEN
         CALL i301_per('sfb100',sr.sfb100) RETURNING l_gae04
         LET l_sfb100 = sr.sfb100,":",l_gae04
         LET l_sfb100 = l_sfb100.trim()
      END IF
 
     LET l_t1 = s_get_doc_no(sr.sfb01)
     SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip = l_t1
     IF cl_null(l_smydesc) THEN
        LET l_smydesc = ""
     END IF
 
      IF STATUS THEN
           CALL cl_err('foreach: ', STATUS, 0)
           LET g_strXMLInput = ''
           RETURN
      END IF
      IF l_i = 1 THEN
 
       #Determine if has detail record
       #SELECT COUNT(*) INTO l_cnt FROM sfa_file
       # WHERE sfa01 = sr.sfb01 AND sfa03 = sr.sfa03 
       #   AND sfa08 = sr.sfa08 AND sfa12 = sr.sfa12
 
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
           LET g_strXMLInput = g_strXMLInput CLIPPED,
		       #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
               "     <sfb01 type=\"0\">", sr.sfb01  CLIPPED, "</sfb01>",  ASCII 10,
               "     <smydesc type=\"0\">", l_smydesc  CLIPPED, "</smydesc>",  ASCII 10,
               "     <sfb101 type=\"1\">", sr.sfb101  CLIPPED, "</sfb101>",  ASCII 10,
               "     <sfb44 type=\"0\">", sr.sfb44  CLIPPED, "</sfb44>",  ASCII 10,
               "     <gen02 type=\"0\">", l_gen02  CLIPPED, "</gen02>",  ASCII 10,
               "     <sfb81 type=\"0\">", sr.sfb81  CLIPPED, "</sfb81>",  ASCII 10,
               "     <sfb02 type=\"1\">", l_sfb02  CLIPPED, "</sfb02>",  ASCII 10,
               "     <sfb39 type=\"0\">", l_sfb39  CLIPPED, "</sfb39>",  ASCII 10,
               "     <sfb98 type=\"0\">", sr.sfb98  CLIPPED, "</sfb98>",  ASCII 10,
               "     <gem02 type=\"0\">", l_gem02  CLIPPED, "</gem02>",  ASCII 10,
               "     <sfb82 type=\"0\">", sr.sfb82  CLIPPED, "</sfb82>",  ASCII 10,
               "     <pmc03 type=\"0\">", l_pmc03  CLIPPED, "</pmc03>",  ASCII 10,
               "     <sfb102 type=\"0\">", sr.sfb102  CLIPPED, "</sfb102>",  ASCII 10,
               "     <sfb22 type=\"0\">", sr.sfb22  CLIPPED, "</sfb22>",  ASCII 10,
               "     <sfb221 type=\"1\">", sr.sfb221  CLIPPED, "</sfb221>",  ASCII 10,
               "     <sfb91 type=\"0\">", sr.sfb91  CLIPPED, "</sfb91>",  ASCII 10,
               "     <sfb92 type=\"1\">", sr.sfb92  CLIPPED, "</sfb92>",  ASCII 10,
               "     <sfb86 type=\"0\">", sr.sfb86  CLIPPED, "</sfb86>",  ASCII 10,
               "     <sfb05 type=\"0\">", sr.sfb05  CLIPPED, "</sfb05>",  ASCII 10,
               "     <ima55 type=\"0\">", l_ima55  CLIPPED, "</ima55>",  ASCII 10,
               "     <ima02 type=\"0\">", l_ima02  CLIPPED, "</ima02>",  ASCII 10,
               "     <ima021 type=\"0\">", l_ima021  CLIPPED, "</ima021>",  ASCII 10,
               "     <sfb08 type=\"1\">", sr.sfb08  CLIPPED, "</sfb08>",  ASCII 10,
               "     <sfb07 type=\"0\">", sr.sfb07  CLIPPED, "</sfb07>",  ASCII 10,
               "     <sfb071 type=\"0\">", sr.sfb071  CLIPPED, "</sfb071>",  ASCII 10,
               "     <sfb93 type=\"0\">", sr.sfb93  CLIPPED, "</sfb93>",  ASCII 10,
               "     <sfb06 type=\"0\">", sr.sfb06  CLIPPED, "</sfb06>",  ASCII 10,
               "     <sfb13 type=\"0\">", sr.sfb13  CLIPPED, "</sfb13>",  ASCII 10,
               "     <sfb15 type=\"0\">", sr.sfb15  CLIPPED, "</sfb15>",  ASCII 10,
               "     <sfb23 type=\"0\">", sr.sfb23  CLIPPED, "</sfb23>",  ASCII 10,
               "     <sfb24 type=\"0\">", sr.sfb24  CLIPPED, "</sfb24>",  ASCII 10,
               "     <sfb41 type=\"0\">", sr.sfb41  CLIPPED, "</sfb41>",  ASCII 10,
               "     <sfb99 type=\"0\">", sr.sfb99  CLIPPED, "</sfb99>",  ASCII 10,
               "     <sfb94 type=\"0\">", sr.sfb94  CLIPPED, "</sfb94>",  ASCII 10,
               "     <sfb100 type=\"0\">", l_sfb100  CLIPPED, "</sfb100>",  ASCII 10,
               "     <sfb34 type=\"1\">", sr.sfb34  CLIPPED, "</sfb34>",  ASCII 10,
               "     <sfb97 type=\"0\">", sr.sfb97  CLIPPED, "</sfb97>",  ASCII 10,
               "     <sfb30 type=\"0\">", sr.sfb30  CLIPPED, "</sfb30>",  ASCII 10,
               "     <sfb31 type=\"0\">", sr.sfb31  CLIPPED, "</sfb31>",  ASCII 10,
               "     <sfb32 type=\"0\">", sr.sfb32  CLIPPED, "</sfb32>",  ASCII 10,
               "     <sfb33 type=\"0\">", sr.sfb33  CLIPPED, "</sfb33>",  ASCII 10,
               "     <sfb222 type=\"0\">", sr.sfb222  CLIPPED, "</sfb222>",  ASCII 10,
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
         LET l_j = 1
         FOREACH ef_cur2 INTO sr1.*
 
           SELECT ima02,ima021,ima08 INTO l_ima02_b,l_ima021_b,ima08_b FROM ima_file
            WHERE sr1.sfa03 = ima01
 
           IF NOT cl_null(sr1.sfa26) THEN
              CALL i301_per('sfa26',sr1.sfa26) RETURNING l_gae04
              LET l_sfa26 = sr1.sfa26,":",l_gae04
              LET l_sfa26 = l_sfa26.trim()
           END IF
 
           IF NOT cl_null(sr1.sfa11) THEN
              CALL i301_per('sfa11',sr1.sfa11) RETURNING l_gae04
              LET l_sfa11 = sr1.sfa11,":",l_gae04
              LET l_sfa11 = l_sfa11.trim()
           END IF
 
           IF NOT cl_null(ima08_b) THEN
              CALL i301_per('ima08_b',ima08_b) RETURNING l_gae04
              LET l_ima08_b =ima08_b,":",l_gae04
              LET l_ima08_b = l_ima08_b.trim()
           END IF
 
               LET g_strXMLInput = g_strXMLInput CLIPPED,
                   "     <record>", ASCII 10,
				   #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
                   "      <sfa27 type=\"0\">",    sr1.sfa27  CLIPPED, "</sfa27>", ASCII 10,
                   "      <sfa08 type=\"0\">",    sr1.sfa08  CLIPPED, "</sfa08>", ASCII 10,
                   "      <sfa26 type=\"0\">",    l_sfa26    CLIPPED, "</sfa26>", ASCII 10,
                   "      <sfa28 type=\"1\">",    sr1.sfa28  CLIPPED, "</sfa28>", ASCII 10,
                   "      <sfa03 type=\"0\">",    sr1.sfa03  CLIPPED, "</sfa03>", ASCII 10,
                   "      <ima02_b type=\"0\">",  l_ima02_b  CLIPPED, "</ima02_b>", ASCII 10,
                   "      <ima021_b type=\"0\">", l_ima021_b CLIPPED, "</ima021_b>", ASCII 10,
                   "      <ima08_b type=\"0\">",  l_ima08_b  CLIPPED, "</ima08_b>", ASCII 10,
                   "      <sfa12 type=\"0\">",    sr1.sfa12  CLIPPED, "</sfa12>", ASCII 10,
                   "      <sfa13 type=\"1\">",    sr1.sfa13  CLIPPED, "</sfa13>", ASCII 10,
                   "      <sfa11 type=\"0\">",    l_sfa11    CLIPPED, "</sfa11>", ASCII 10,
                   "      <sfa161 type=\"1\">",   sr1.sfa161 CLIPPED, "</sfa161>", ASCII 10,
                   "      <sfa100 type=\"1\">",   sr1.sfa100 CLIPPED, "</sfa100>", ASCII 10,
                   "      <sfa05 type=\"1\">",    sr1.sfa05  CLIPPED, "</sfa05>", ASCII 10,
                   "      <sfa065 type=\"1\">",   sr1.sfa065 CLIPPED, "</sfa065>", ASCII 10,
                   "      <sfa06 type=\"1\">",    sr1.sfa06  CLIPPED, "</sfa06>", ASCII 10,
                   "      <sfa062 type=\"1\">",   sr1.sfa062 CLIPPED, "</sfa062>", ASCII 10,
                   "      <sfa07 type=\"1\">",    sr1.sfa07  CLIPPED, "</sfa07>", ASCII 10,
                   "      <sfa063 type=\"1\">",   sr1.sfa063 CLIPPED, "</sfa063>", ASCII 10,
                   "      <sfa064 type=\"1\">",   sr1.sfa064 CLIPPED, "</sfa064>", ASCII 10,
                   "      <sfa30 type=\"0\">",    sr1.sfa30  CLIPPED, "</sfa30>", ASCII 10,
                   "      <sfa31 type=\"0\">",    sr1.sfa31  CLIPPED, "</sfa31>", ASCII 10,
				   #---FUN-BB0061---end-------
                   "     </record>", ASCII 10
             LET l_j = l_j + 1
         END FOREACH
         #OTHERWISE
         IF sr.sfb93 = 'Y' THEN
            LET l_k = 1
            LET g_strXMLInput = g_strXMLINput CLIPPED,
                                "    </body>", ASCII 10,
                                "    <body>", ASCII 10 
 
            FOREACH ef_cur3 INTO sr2.*
 
            SELECT eca02 INTO l_eca02 FROM eca_file
             WHERE eca01 = sr2.ecm06
 
                  LET g_strXMLInput = g_strXMLInput CLIPPED,
                      "     <record>", ASCII 10,
					  #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
                      "      <ecm03 type=\"1\">", sr2.ecm03 CLIPPED, "</ecm03>", ASCII 10,
                      "      <ecm04 type=\"0\">", sr2.ecm04 CLIPPED, "</ecm04>", ASCII 10,
                      "      <ecm45 type=\"0\">", sr2.ecm45 CLIPPED, "</ecm45>", ASCII 10,
                      "      <ecm06 type=\"0\">", sr2.ecm06 CLIPPED, "</ecm06>", ASCII 10,
                      "      <eca02 type=\"1\">", l_eca02   CLIPPED, "</eca02>", ASCII 10,
                      "      <ecm14 type=\"1\">", sr2.ecm14 CLIPPED, "</ecm14>", ASCII 10,
                      "      <ecm13 type=\"1\">", sr2.ecm13 CLIPPED, "</ecm13>", ASCII 10,
                      "      <ecm16 type=\"1\">", sr2.ecm16 CLIPPED, "</ecm16>", ASCII 10,
                      "      <ecm15 type=\"1\">", sr2.ecm15 CLIPPED, "</ecm15>", ASCII 10,
                      "      <ecm49 type=\"1\">", sr2.ecm49 CLIPPED, "</ecm49>", ASCII 10,
                      "      <ecm50 type=\"0\">", sr2.ecm50 CLIPPED, "</ecm50>", ASCII 10,
                      "      <ecm51 type=\"0\">", sr2.ecm51 CLIPPED, "</ecm51>", ASCII 10,
                      "      <ecm05 type=\"0\">", sr2.ecm05 CLIPPED, "</ecm05>", ASCII 10,
                      "      <ecm52 type=\"0\">", sr2.ecm52 CLIPPED, "</ecm52>", ASCII 10,
                      "      <ecm53 type=\"0\">", sr2.ecm53 CLIPPED, "</ecm53>", ASCII 10,
                      "      <ecm54 type=\"0\">", sr2.ecm54 CLIPPED, "</ecm54>", ASCII 10,
                      "      <ecm55 type=\"0\">", sr2.ecm55 CLIPPED, "</ecm55>", ASCII 10,
                      "      <ecm56 type=\"0\">", sr2.ecm56 CLIPPED, "</ecm56>", ASCII 10,
                      "      <ecm57 type=\"0\">", sr2.ecm57 CLIPPED, "</ecm57>", ASCII 10,
                      "      <ecm58 type=\"0\">", sr2.ecm58 CLIPPED, "</ecm58>", ASCII 10,
                      "      <ecm59 type=\"1\">", sr2.ecm59 CLIPPED, "</ecm59>", ASCII 10,
					  #---FUN-BB0061---end-------
                      "     </record>", ASCII 10
             LET l_k = l_k +1
            END FOREACH
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
 
FUNCTION i301_per(l_feld,l_val)
DEFINE l_feld  STRING
DEFINE l_val   STRING
DEFINE l_gae04 LIKE gae_file.gae04
DEFINE l_gae02 LIKE gae_file.gae02
 
 LET l_gae02 = l_feld, "_",l_val
 
 SELECT gae04 INTO l_gae04 FROM gae_file
  WHERE gae01 = 'asfi301'
    AND gae02 = l_gae02
    AND gae03 = g_lang
    AND gae11 = 'Y'                           #CHI-9C0016
    AND gae12 = g_sma.sma124                  #CHI-9C0016
#-CHI-9C0016-add- 
 IF SQLCA.sqlcode THEN 
   SELECT gae04 INTO l_gae04 
     FROM gae_file 
    WHERE gae01 = 'asfi301' 
      AND gae02 = l_gae02 
      AND gae03 = g_lang
      AND (gae11 IS NULL OR gae11 = 'N')
      AND gae12 = g_sma.sma124 
 END IF
 IF SQLCA.SQLCODE THEN   #失敗的話以欄位名稱當作欄位的說明
    SELECT gaq03 INTO l_gae04 
      FROM gaq_file 
     WHERE gaq01 = l_gae02 
       AND gaq02 = g_lang 

    IF SQLCA.SQLCODE THEN
       LET l_gae04 = l_gae02 
    END IF
 END IF
#-CHI-9C0016-end- 
 
 RETURN l_gae04
END FUNCTION
 
#FUN-930120
