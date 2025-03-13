# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
######################################################################
#
# NOTE:
#	   Maker: '{@}' means this block needed to do modification by hand
#	Variable: 'g_strXMLInput' means XML string sending to EasyFlow
#	Varaible: 'g_formNum' means form number, could be used in SQL as key value
#
#	Ohter variables refer to 'awsef.4gl' if need to use it
# Modify.........: No.FUN-680130 06/09/01 By zhuying 欄位形態定義為LIKE
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
{@}			apa01	LIKE apa_file.apa01,
			apa02	LIKE apa_file.apa02,
			apa05	LIKE apa_file.apa05,
			apa06	LIKE apa_file.apa06,
			apa07	LIKE apa_file.apa07,
			apa08	LIKE apa_file.apa08,
			apa11	LIKE apa_file.apa11,
			apa12	LIKE apa_file.apa12,
			apa13	LIKE apa_file.apa13,
			apa14	LIKE apa_file.apa14,
			apa15	LIKE apa_file.apa15,
			apa16	LIKE apa_file.apa16,
			apa19	LIKE apa_file.apa19,
			apa20	LIKE apa_file.apa20,
			apa21	LIKE apa_file.apa21,
			apa22	LIKE apa_file.apa22,
			apa24	LIKE apa_file.apa24,
			apa25	LIKE apa_file.apa25,
			apa31f	LIKE apa_file.apa31f,
			apa32f	LIKE apa_file.apa32f,
			apa33	LIKE apa_file.apa33,
			apa34f	LIKE apa_file.apa34f,
			apa35f	LIKE apa_file.apa35f,
			apa36	LIKE apa_file.apa36,
			apa44	LIKE apa_file.apa44,
			apa51	LIKE apa_file.apa51,
			apa52	LIKE apa_file.apa52,
			apa54	LIKE apa_file.apa54,
			apa55	LIKE apa_file.apa55,
			apa56	LIKE apa_file.apa56,
			apa57	LIKE apa_file.apa57,
			apa58	LIKE apa_file.apa58,
			apa64	LIKE apa_file.apa64,
			apa65f	LIKE apa_file.apa65f,
			apa66	LIKE apa_file.apa66,
			apa99	LIKE apa_file.apa99,
			apainpd	LIKE apa_file.apainpd,
			apauser	LIKE apa_file.apauser,
			apr02	LIKE apr_file.apr02,
			pma11	LIKE pma_file.pma11,
			apb02	LIKE apb_file.apb02,
			apb06	LIKE apb_file.apb06,
			apb07	LIKE apb_file.apb07,
			apb08	LIKE apb_file.apb08,
			apb09	LIKE apb_file.apb09,
			apb10	LIKE apb_file.apb10,
			apb11	LIKE apb_file.apb11,
			apb12	LIKE apb_file.apb12,
			apb21	LIKE apb_file.apb21,
			apb22	LIKE apb_file.apb22,
			apb23	LIKE apb_file.apb23,
			apb24	LIKE apb_file.apb24,
			apb25	LIKE apb_file.apb25,
			apb26	LIKE apb_file.apb26,
			apb27	LIKE apb_file.apb27,
			apb28	LIKE apb_file.apb28,
			apb29	LIKE apb_file.apb29,
                        pmc03   LIKE pmc_file.pmc03,
                        apo02   LIKE apo_file.apo02,
                        gen02   LIKE gen_file.gen02,
                        gem02   LIKE gem_file.gem02,
                        apa60f  LIKE apa_file.apa60f,
                        apa61f  LIKE apa_file.apa61f,
                        apa31   LIKE apa_file.apa31,
                        apa32   LIKE apa_file.apa32,
                        apa65   LIKE apa_file.apa65,
                        apa34   LIKE apa_file.apa34,
                        apa35   LIKE apa_file.apa35,
                        apa60   LIKE apa_file.apa60,
                        apa61   LIKE apa_file.apa61     
                       
           	END RECORD,
           l_i		LIKE type_file.num5,          #No.FUN-680130 SMALLINT
           l_sql	STRING,        
           l_net        LIKE oox_file.oox10,        #No.FUn-680130 DEC(15,3)
           l_apa56_pername LIKE gae_file.gae04,       #No.FUN-680130 VARCHAR(30)
           l_apa56_zename LIKe gae_file.gae02,        #No.FUN-680130 VARCHAR(30)
           l_pma11_name LIKE gae_file.gae04,          #No.FUN-680130 VARCHAR(30)
           l_apa55_name LIKE gae_file.gae04,          #No.FUN-680130 VARCHAR(30)
           l_apb29_name LIKE type_file.chr1000,       #No.FUN-680130 VARCHAR(30)
           g_msg        LIKE ze_file.ze03             #No.FUN-680130 VARCHAR(30)
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
    LET l_sql =	"SELECT apa01, apa02, apa05, apa06, apa07, apa08, apa11, apa12,",
		"       apa13, apa14, apa15, apa16, apa19, apa20, apa21, apa22,",
		"       apa24, apa25, apa31f, apa32f, apa33, apa34f, apa35f, apa36,",
		"       apa44, apa51, apa52, apa54, apa55, apa56, apa57,",
		"       apa58, apa64, apa65f, apa66, apa99, apainpd, apauser, apr02,",
		"       pma11, apb02, apb06, apb07, apb08, apb09, apb10,",
		"       apb11, apb12, apb21, apb22, apb23, apb24, apb25, apb26,",
		"       apb27, apb28, apb29, pmc03, apo02, gen02, gem02,  ",
                "       apa60f,apa61f,apa31, apa32, apa65, apa34, apa35, apa60, apa61 ",
                " FROM apa_file, OUTER apb_file, OUTER apr_file, OUTER pma_file,",
                " OUTER pmc_file, OUTER apo_file, OUTER gen_file, OUTER gem_file ",
                " WHERE apa01 = apb_file.apb01 ",
                "   AND apr_file.apr01 = apa36 ",
                "   AND pma_file.pma01 = apa11 ",
                "   AND pmc_file.pmc01 = apa05 ",
                "   AND apo_file.apo01 = apa19 ",
                "   AND gen_file.gen01 = apa21 ",
                "   AND gem_file.gem01 = apa22 ",
                "   AND apaacti='Y' ",
                "   AND apa01 = '", g_formNum CLIPPED ,"'"
 
    PREPARE ef_pre FROM l_sql
    IF STATUS THEN
       CALL cl_err('prepare ef_pre: ', STATUS, 0)
       LET g_strXMLInput = ''
       RETURN
    END IF
    DECLARE ef_cur CURSOR FOR ef_pre
    LET l_i = 1
    FOREACH ef_cur INTO sr.*
        IF STATUS THEN
           CALL cl_err('foreach ef_cur: ', STATUS, 0)
           LET g_strXMLInput = ''
           RETURN
        END IF
 
        IF l_i = 1 THEN
 
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
           #LET g_formNum = g_formNum CLIPPED, "{+}column=", g_key1 CLIPPED
        CALL aws_efcli_XMLHeader(sr.apauser, sr.apa21)
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
            SELECT SUM(oox10) INTO l_net FROM oox_file
             WHERE oox00 = 'AP' AND oox03 = sr.apa01
            IF cl_null(l_net) THEN
               LET l_net = 0
            END IF
 
  ### MOD-4A0298 ###
      CASE WHEN sr.apa56 = '0'
              CALL cl_getmsg('aap-282',g_lang) RETURNING g_msg
              LET l_apa56_zename= g_msg
           WHEN sr.apa56 = '1'
              CALL cl_getmsg('aap-283',g_lang) RETURNING g_msg
              LET l_apa56_zename= g_msg
           WHEN sr.apa56 = '2'
              CALL cl_getmsg('aap-284',g_lang) RETURNING g_msg
              LET l_apa56_zename= g_msg
           WHEN sr.apa56 = '3'
              CALL cl_getmsg('aap-285',g_lang) RETURNING g_msg
              LET l_apa56_zename= g_msg
           OTHERWISE
              LET l_apa56_zename = ''
      END CASE
 
           LET g_msg = "apa56_", sr.apa56 CLIPPED
              SELECT gae04 INTO l_apa56_pername FROM gae_file
              WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang AND gae11 ='Y'
           IF SQLCA.sqlcode THEN
              SELECT gae04 INTO l_apa56_pername FROM gae_file
                WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang 
                AND (gae11 IS NULL OR gae11 ='N')
           END IF
 
           LET g_msg = "pma11_", sr.pma11 CLIPPED
 
           SELECT gae04 INTO l_pma11_name FROM gae_file
              WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang AND gae11 ='Y'
           IF SQLCA.sqlcode THEN
              SELECT gae04 INTO l_pma11_name FROM gae_file
                WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang 
                AND (gae11 IS NULL OR gae11 ='N')
           END IF
  ### END MOD-4A0298 ### 
 
           IF SQLCA.sqlcode THEN
              LET l_pma11_name = ''
           END IF
 
           LET g_msg = "apa55_", sr.apa55 CLIPPED
 
            ### MOD-4A0298 ###
           SELECT gae04 INTO l_apa55_name FROM gae_file
              WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang AND gae11 ='Y'
           IF SQLCA.sqlcode THEN
              SELECT gae04 INTO l_apa55_name FROM gae_file
                WHERE gae01 = g_prog AND gae02 = g_msg AND gae03 = g_lang
                AND (gae11 IS NULL OR gae11 ='N')
           END IF
            ### END MOD-4A0298 ###
 
           IF SQLCA.sqlcode THEN
              LET l_pma11_name = ''
           END IF
 
           LET g_strXMLInput = g_strXMLInput CLIPPED,
{@}            "     <apa01>", sr.apa01 CLIPPED, "</apa01>", ASCII 10,
               "     <apa02>", sr.apa02 CLIPPED, "</apa02>", ASCII 10,
               "     <apa05>", sr.apa05 CLIPPED, ' ', sr.pmc03 CLIPPED, "</apa05>", ASCII 10,
               "     <apa06>", sr.apa06 CLIPPED, ' ', sr.apa07 CLIPPED, "</apa06>", ASCII 10,
               "     <apa08>", sr.apa08 CLIPPED, "</apa08>", ASCII 10,
               "     <apa11>", sr.apa11 CLIPPED, "</apa11>", ASCII 10,
               "     <apa12>", sr.apa12 CLIPPED, "</apa12>", ASCII 10,
               "     <apa13>", sr.apa13 CLIPPED, "</apa13>", ASCII 10,
               "     <apa14>", sr.apa14 CLIPPED, "</apa14>", ASCII 10,
               "     <apa15>", sr.apa15 CLIPPED, "</apa15>", ASCII 10,
               "     <apa16>", sr.apa16 CLIPPED, "</apa16>", ASCII 10,
               "     <apa19>", sr.apa19 CLIPPED, "</apa19>", ASCII 10,
               "     <apa20>", sr.apa20 CLIPPED, "</apa20>", ASCII 10,
               "     <apa21>", sr.apa21 CLIPPED, ' ', sr.gen02 CLIPPED, "</apa21>", ASCII 10,
               "     <apa22>", sr.apa22 CLIPPED, ' ', sr.gem02 CLIPPED, "</apa22>", ASCII 10,
               "     <apa24>", sr.apa24 CLIPPED, "</apa24>", ASCII 10,
               "     <apa25>", sr.apa25 CLIPPED, "</apa25>", ASCII 10,
               "     <apa31f>", sr.apa31f CLIPPED, "</apa31f>", ASCII 10,
               "     <apa32f>", sr.apa32f CLIPPED, "</apa32f>", ASCII 10,
               "     <apa33>", sr.apa33 CLIPPED, "</apa33>", ASCII 10,
               "     <apa34f>", sr.apa34f CLIPPED, "</apa34f>", ASCII 10,
               "     <apa35f>", sr.apa35f CLIPPED, "</apa35f>", ASCII 10,
               "     <apa36>", sr.apa36 CLIPPED, "</apa36>", ASCII 10,
               "     <apa44>", sr.apa44 CLIPPED, "</apa44>", ASCII 10,
               "     <apa51>", sr.apa51 CLIPPED, "</apa51>", ASCII 10,
               "     <apa52>", sr.apa52 CLIPPED, "</apa52>", ASCII 10,
               "     <apa54>", sr.apa54 CLIPPED, "</apa54>", ASCII 10,
               "     <apa55>", sr.apa55 CLIPPED,' ', l_apa55_name, "</apa55>", ASCII 10,
               "     <apa56>", sr.apa56 CLIPPED,' ', l_apa56_pername, "</apa56>", ASCII 10,
               "     <apa56_name>", l_apa56_zename, "</apa56_name>", ASCII 10,
               "     <apa57>", sr.apa57 CLIPPED, "</apa57>", ASCII 10,
               "     <apa58>", sr.apa58 CLIPPED, "</apa58>", ASCII 10,
               "     <apa64>", sr.apa64 CLIPPED, "</apa64>", ASCII 10,
               "     <apa65f>", sr.apa65f CLIPPED, "</apa65f>", ASCII 10,
               "     <apa66>", sr.apa66 CLIPPED, "</apa66>", ASCII 10,
               "     <apa99>", sr.apa99 CLIPPED, "</apa99>", ASCII 10,
               "     <apainpd>", sr.apainpd CLIPPED, "</apainpd>", ASCII 10,
               "     <apauser>", sr.apauser CLIPPED, "</apauser>", ASCII 10,
               "     <apr02>", sr.apr02 CLIPPED, "</apr02>", ASCII 10,
               "     <net>", l_net CLIPPED, "</net>", ASCII 10,
               "     <pma11>", sr.pma11 CLIPPED,' ', l_pma11_name, "</pma11>", ASCII 10,
               "     <apa60f>", sr.apa60f CLIPPED, "</apa60f>", ASCII 10,
               "     <apa61f>", sr.apa61f CLIPPED, "</apa61f>", ASCII 10,
               "     <apa31>", sr.apa31 CLIPPED, "</apa31>", ASCII 10,
               "     <apa32>", sr.apa32 CLIPPED, "</apa32>", ASCII 10,
               "     <apa65>", sr.apa65 CLIPPED, "</apa65>", ASCII 10,
               "     <apa34>", sr.apa34 CLIPPED, "</apa34>", ASCII 10,
               "     <apa35>", sr.apa35 CLIPPED, "</apa35>", ASCII 10,
               "     <apa60>", sr.apa60 CLIPPED, "</apa60>", ASCII 10,
               "     <apa61>", sr.apa61 CLIPPED, "</apa61>", ASCII 10,
               "     <apo02>", sr.apo02 CLIPPED, "</apo02>", ASCII 10,
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
        END IF
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose detail data
#	Modify tag name & corresponding value if want to use another one
#	If this program hasn't detail data, don't need to care about this block
#---------------------------------------------------------------------
      IF g_prog = "aapt110" THEN
 
         LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
{@}         "      <apb02>", sr.apb02 CLIPPED, "</apb02>", ASCII 10,
            "      <apb21>", sr.apb21 CLIPPED, "</apb21>", ASCII 10,
            "      <apb22>", sr.apb22 CLIPPED, "</apb22>", ASCII 10,
            "      <apb06>", sr.apb06 CLIPPED, "</apb06>", ASCII 10,
            "      <apb07>", sr.apb07 CLIPPED, "</apb07>", ASCII 10,
            "      <apb12>", sr.apb12 CLIPPED, "</apb12>", ASCII 10,
            "      <apb27>", sr.apb27 CLIPPED, "</apb27>", ASCII 10,
            "      <apb09>", sr.apb09 CLIPPED, "</apb09>", ASCII 10,
            "      <apb28>", sr.apb28 CLIPPED, "</apb28>", ASCII 10,
            "      <apb25>", sr.apb25 CLIPPED, "</apb25>", ASCII 10,
            "      <apb26>", sr.apb26 CLIPPED, "</apb26>", ASCII 10,
            "      <apb23>", sr.apb23 CLIPPED, "</apb23>", ASCII 10,
            "      <apb24>", sr.apb24 CLIPPED, "</apb24>", ASCII 10,
            "      <apb08>", sr.apb08 CLIPPED, "</apb08>", ASCII 10,
            "      <apb10>", sr.apb10 CLIPPED, "</apb10>", ASCII 10,
            "     </record>", ASCII 10
        ELSE
 
         LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
{@}         "      <apb02>", sr.apb02 CLIPPED, "</apb02>", ASCII 10,
            "      <apb12>", sr.apb12 CLIPPED, "</apb12>", ASCII 10,
            "      <apb27>", sr.apb27 CLIPPED, "</apb27>", ASCII 10,
            "      <apb09>", sr.apb09 CLIPPED, "</apb09>", ASCII 10,
            "      <apb28>", sr.apb28 CLIPPED, "</apb28>", ASCII 10,
            "      <apb25>", sr.apb25 CLIPPED, "</apb25>", ASCII 10,
            "      <apb26>", sr.apb26 CLIPPED, "</apb26>", ASCII 10,
            "      <apb23>", sr.apb23 CLIPPED, "</apb23>", ASCII 10,
            "      <apb24>", sr.apb24 CLIPPED, "</apb24>", ASCII 10,
            "      <apb08>", sr.apb08 CLIPPED, "</apb08>", ASCII 10,
            "      <apb10>", sr.apb10 CLIPPED, "</apb10>", ASCII 10,
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
