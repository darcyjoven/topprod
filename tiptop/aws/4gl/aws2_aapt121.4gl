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
# Modify.........: No.FUN-920077 09/02/10 By sabrina 建立 
# Modify.........: No.TQC-930094 09/03/12 By sabrina apamksg、apa63、apa41、apa42不傳送到easyflow
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
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
			apa01	LIKE apa_file.apa01,
                        apa02   LIKE apa_file.apa02,
                        apa06   LIKE apa_file.apa06,
                        apa07   LIKE apa_file.apa07,
                        apa22   LIKE apa_file.apa22,
                        apa930  LIKE apa_file.apa930,
                        apa36   LIKE apa_file.apa36,
                        apa13   LIKE apa_file.apa13,
                        apa14   LIKE apa_file.apa14,
                        apa08   LIKE apa_file.apa08,
                        apa11   LIKE apa_file.apa11,
                        apa12   LIKE apa_file.apa12,
                        apa24   LIKE apa_file.apa24,
                        apa64   LIKE apa_file.apa64,
                        apa55   LIKE apa_file.apa55,
                        apa31f  LIKE apa_file.apa31f,
                        apa31   LIKE apa_file.apa31,
                        apa65f  LIKE apa_file.apa65f,
                        apa65   LIKE apa_file.apa65,
                        apa37f  LIKE apa_file.apa37,
                        apa37   LIKE apa_file.apa37,
                        apa34f  LIKE apa_file.apa34f,
                        apa34   LIKE apa_file.apa34,
                        apa35f  LIKE apa_file.apa35f,
                        apa35   LIKE apa_file.apa35,
                        apa35_uf  LIKE apa_file.apa35f,
                        apa35_u  LIKE apa_file.apa35,
                        apa19   LIKE apa_file.apa19,
                        apa20   LIKE apa_file.apa20,
                        apainpd LIKE apa_file.apainpd,
                        apa66   LIKE apa_file.apa66,
                        apa25   LIKE apa_file.apa25,
                        apa100  LIKE apa_file.apa100,
                        apa99   LIKE apa_file.apa99,
                        apa51   LIKE apa_file.apa51,
                        apa54   LIKE apa_file.apa54,
                        apa101  LIKE apa_file.apa101,
                        apa102  LIKE apa_file.apa102,
                        apa44   LIKE apa_file.apa44,
                        apa57   LIKE apa_file.apa57,
                       #apa63   LIKE apa_file.apa63,  
                       #apamksg LIKE apa_file.apamksg,  
                       #apa42   LIKE apa_file.apa42,  
                       #apa41   LIKE apa_file.apa41, 
                        apb02   LIKE apb_file.apb02,
                        apb33   LIKE apb_file.apb33,
                        apb31   LIKE apb_file.apb31,
                        apb32   LIKE apb_file.apb32,
                        apb25   LIKE apb_file.apb25,
                        apb26   LIKE apb_file.apb26,
                        apb930  LIKE apb_file.apb930,
                        apb24   LIKE apb_file.apb24,
                        apb10   LIKE apb_file.apb10   
           	END RECORD,
           l_i		LIKE type_file.num5,     
           l_sql	LIKE type_file.chr1000  
    DEFINE l_azi02      LIKE azi_file.azi02, 
           l_pma02      LIKE pma_file.pma02,
           l_nma02      LIKE nma_file.nma02,
           l_nmc02      LIKE nmc_file.nmc02,
           l_gem02      LIKE gem_file.gem02,
           l_gem02b     LIKE gem_file.gem02,
           l_apr02      LIKE apr_file.apr02,
           l_pma11      LIKE pma_file.pma11,
           l_net        LIKE apv_file.apv04,
           l_apo02      LIKE apo_file.apo02,
           l_azp02      LIKE azp_file.azp02,
           l_a51        LIKE aag_file.aag02,
           l_a54        LIKE aag_file.aag02,
           l_b25        LIKE aag_file.aag02,
           l_b26        LIKE gem_file.gem02, 
           l_gja02      LIKE gja_file.gja02,
           l_gen02      LIKE gen_file.gen02,
           l_afa02      LIKE afa_file.afa02, 
           l_gem02c     LIKE gem_file.gem02,
           l_chr        STRING,
           l_chr2       STRING 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
#   IF g_apz.apz59 = 'Y' THEN
     LET l_sql =
		"SELECT  apa01, apa02, apa06, apa07, apa22, apa930, apa36,",
                "apa13, apa14, apa08, apa11, apa12, apa24, apa64, apa55,",          
                "apa31f, apa31, apa65f, apa65, apa37f, apa37, apa34f, apa34,",
                "apa35f, apa35, apa35 as apa35_uf, apa35f as apa35_uf, apa19,",
                "apa20, apainpd, apa66, apa25, apa100, apa99, apa51, apa54, apa101, apa102, apa44,",
               #"apa57, apa63, apamksg, apa42, apa41,",  #TQC-930094 mark
                "apa57,",     #TQC-930094 add
                "apb02, apb33, apb31, apb32, apb25, apb26, apb930, apb24, apb10 ",
                " FROM apa_file, OUTER apb_file",
                " WHERE apa01 = apb_file.apb01 ",
                "   AND apaacti = 'Y' ",
                "   AND apa01 = '", g_formNum CLIPPED, "'"
   
    PREPARE ef_pre FROM l_sql
    IF STATUS THEN
       CALL cl_err('prepare: ', STATUS, 0)
       LET g_strXMLInput = ''
       RETURN
    END IF
    DECLARE ef_cur CURSOR FOR ef_pre
 
    LET l_i = 1
    FOREACH ef_cur INTO sr.*
      SELECT apr02 INTO l_apr02 FROM apr_file
       WHERE sr.apa36 = apr01
      SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE sr.apa22 = gem01
      SELECT gem02 INTO l_gem02b FROM gem_file
       WHERE sr.apa930 = gem01
      SELECT pma11 INTO l_pma11 FROM pma_file
       WHERE sr.apa11 = pma01
      SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE sr.apa100 = azp01
      SELECT apa34 - apa35 INTO sr.apa35_u FROM apa_file
       WHERE sr.apa01 = apa01
      SELECT apa34f- apa35f INTO sr.apa35_uf FROM apa_file
       WHERE sr.apa01 = apa01
      IF g_apz.apz59 = 'Y' THEN
        SELECT aag02 INTO l_b25 FROM aag_file
         WHERE sr.apb25 = aag01
        SELECT gem02 INTO l_b26 FROM gem_file
         WHERE sr.apb26 = gem01
        SELECT gen02 INTO l_gen02 FROM gen_file
         WHERE sr.apb32 = gen01
        SELECT gem02 INTO l_gem02c FROM gem_file
         WHERE sr.apb930 = gem01
      END IF
      
      CALL t110_comp_oox(sr.apa01) RETURNING l_net
      IF STATUS THEN
           CALL cl_err('foreach: ', STATUS, 0)
           LET g_strXMLInput = ''
           RETURN
        END IF
        IF l_i = 1 THEN
 
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
          IF NOT cl_null(sr.apa13) THEN
             SELECT azi02 INTO l_azi02 FROM azi_file
              WHERE azi01 = sr.apa13
             IF SQLCA.sqlcode THEN LET l_azi02 ='' END IF
          END IF
 
          IF NOT cl_null(sr.apa19) THEN
             SELECT apo02 INTO l_apo02 FROM azi_file
              WHERE apo01 = sr.apa19
             IF SQLCA.sqlcode THEN LET l_apo02 ='' END IF
          END IF
 
          IF NOT cl_null(sr.apa11) THEN
             SELECT pma02 INTO l_pma02 FROM pma_file
              WHERE pma01 = sr.apa11
             IF SQLCA.sqlcode THEN LET l_pma02 ='' END IF
          END IF
 
          IF NOT cl_null(sr.apa51) THEN
             SELECT aag02 INTO l_a51 FROM aag_file
              WHERE aag01 = sr.apa51
          END IF
 
          IF NOT cl_null(sr.apa54) THEN
             SELECT aag02 INTO l_a54 FROM aag_file
              WHERE aag01 = sr.apa54
          END IF
 
          IF NOT cl_null(sr.apa101) THEN
             SELECT nma02 INTO l_nma02 FROM nma_file
              WHERE nma01 = sr.apa101
             IF SQLCA.sqlcode THEN LET l_nma02 ='' END IF
          END IF
 
          IF NOT cl_null(sr.apa102) THEN
             SELECT nmc02 INTO l_nmc02 FROM nmc_file
              WHERE nmc01 = sr.apa102
             IF SQLCA.sqlcode THEN LET l_nmc02 ='' END IF
         END IF
 
         IF NOT cl_null(sr.apa66) THEN
            SELECT gja02 INTO l_gja02 FROM gja_file
             WHERE gja01 = sr.apa66
            IF SQLCA.sqlcode THEN LET l_nmc02 ='' END IF
         END IF
 
           LET g_strXMLInput = g_strXMLInput CLIPPED,
		       #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
               "     <apa01 type=\"0\">", sr.apa01  CLIPPED, "</apa01>",  ASCII 10,
               "     <apa02 type=\"0\">", sr.apa02  CLIPPED, "</apa02>",  ASCII 10,
               "     <apa06 type=\"0\">", sr.apa06  CLIPPED, "</apa06>",  ASCII 10,
               "     <apa07 type=\"0\">", sr.apa07  CLIPPED, "</apa07>",  ASCII 10,
               "     <apa22 type=\"0\">", sr.apa22  CLIPPED, "</apa22>",  ASCII 10,
               "     <gem02 type=\"0\">", l_gem02  CLIPPED, "</gem02>",  ASCII 10,
               "     <apa930 type=\"0\">", sr.apa930  CLIPPED, "</apa930>",  ASCII 10,
               "     <gem02b type=\"0\">", l_gem02b  CLIPPED, "</gem02b>",  ASCII 10,
               "     <apa36 type=\"0\">", sr.apa36  CLIPPED, "</apa36>",  ASCII 10,
               "     <apr02 type=\"0\">", l_apr02  CLIPPED, "</apr02>",  ASCII 10,
               "     <apa13 type=\"0\">", sr.apa13  CLIPPED, ' ', l_azi02   CLIPPED, "</apa13>",  ASCII 10,
               "     <apa14 type=\"1\">", sr.apa14  CLIPPED, "</apa14>",  ASCII 10,
               "     <apa08 type=\"0\">", sr.apa08  CLIPPED, "</apa08>",  ASCII 10,
               "     <apa11 type=\"0\">", sr.apa11  CLIPPED, ' ', l_pma02   CLIPPED, "</apa11>",  ASCII 10,
               "     <pma11 type=\"0\">", l_pma11  CLIPPED, "</pma11>",  ASCII 10,
               "     <apa12 type=\"0\">", sr.apa12  CLIPPED, "</apa12>",  ASCII 10,
               "     <apa24 type=\"1\">", sr.apa24  CLIPPED, "</apa24>",  ASCII 10,
               "     <apa64 type=\"0\">", sr.apa64  CLIPPED, "</apa64>",  ASCII 10,
               "     <apa55 type=\"0\">", sr.apa55  CLIPPED, "</apa55>",  ASCII 10,
               "     <apa31 type=\"1\">", sr.apa31  CLIPPED, "</apa31>",  ASCII 10,
               "     <apa31f type=\"1\">", sr.apa31f  CLIPPED, "</apa31f>",  ASCII 10,
               "     <apa65 type=\"1\">", sr.apa65  CLIPPED, "</apa65>",  ASCII 10,
               "     <apa65f type=\"1\">", sr.apa65f  CLIPPED, "</apa65f>",  ASCII 10,
               "     <apa37 type=\"1\">", sr.apa37  CLIPPED, "</apa37>",  ASCII 10,
               "     <apa37f type=\"1\">", sr.apa37f  CLIPPED, "</apa37f>",  ASCII 10,
               "     <apa34 type=\"1\">", sr.apa34  CLIPPED, "</apa34>",  ASCII 10,
               "     <apa34f type=\"1\">", sr.apa34f  CLIPPED, "</apa34f>",  ASCII 10,
               "     <apa35 type=\"1\">", sr.apa35  CLIPPED, "</apa35>",  ASCII 10,
               "     <apa35f type=\"1\">", sr.apa35f  CLIPPED, "</apa35f>",  ASCII 10,
               "     <apa35_u type=\"1\">", sr.apa35_u  CLIPPED, "</apa35_u>",  ASCII 10,
               "     <apa35_uf type=\"1\">", sr.apa35_uf  CLIPPED, "</apa35_uf>",  ASCII 10,
               "     <net type=\"1\">", l_net  CLIPPED, "</net>",  ASCII 10,
               "     <apa19 type=\"0\">", sr.apa19  CLIPPED, "</apa19>",  ASCII 10,
               "     <apo02 type=\"0\">", l_apo02  CLIPPED, "</apo02>",  ASCII 10,
               "     <apa20 type=\"1\">", sr.apa20  CLIPPED, "</apa20>",  ASCII 10,
               "     <apainpd type=\"0\">", sr.apainpd  CLIPPED, "</apainpd>",  ASCII 10,
               "     <apa66 type=\"0\">", sr.apa66  CLIPPED, ' ', l_gja02   CLIPPED, "</apa66>",  ASCII 10,
               "     <apa25 type=\"0\">", sr.apa25  CLIPPED, "</apa25>",  ASCII 10,
               "     <apa100 type=\"0\">", sr.apa100  CLIPPED, "</apa100>",  ASCII 10,
               "     <azp02 type=\"0\">", l_azp02  CLIPPED, "</azp02>",  ASCII 10,
               "     <apa99 type=\"0\">", sr.apa99  CLIPPED, "</apa99>",  ASCII 10,
               "     <apa51 type=\"0\">", sr.apa51  CLIPPED, "</apa51>",  ASCII 10,
               "     <a51 type=\"0\">", l_a51  CLIPPED, "</a51>",  ASCII 10,
               "     <apa54 type=\"0\">", sr.apa54  CLIPPED, "</apa54>",  ASCII 10,
               "     <a54 type=\"0\">", l_a54  CLIPPED, "</a54>",  ASCII 10,
               "     <apa101 type=\"0\">", sr.apa101  CLIPPED, ' ', l_nma02   CLIPPED, "</apa101>",  ASCII 10,
               "     <apa102 type=\"0\">", sr.apa102  CLIPPED, ' ', l_nmc02   CLIPPED, "</apa102>",  ASCII 10,
               "     <apa44 type=\"0\">", sr.apa44  CLIPPED, "</apa44>",  ASCII 10,
               "     <apa57 type=\"1\">", sr.apa57  CLIPPED, "</apa57>",  ASCII 10,
               #---FUN-BB0061---end-------
			  #TQC-930094---mark---start---
              #"     <apa63>", sr.apa63  CLIPPED, "</apa63>",  ASCII 10,
              #"     <apamksg>", sr.apamksg  CLIPPED, "</apamksg>",  ASCII 10,
              #"     <apa42>", sr.apa42  CLIPPED, "</apa42>",  ASCII 10,
              #"     <apa41>", sr.apa41  CLIPPED, "</apa41>",  ASCII 10,
              #TQC-930094---mark---end---
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
        END IF
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose detail data
#	Modify tag name & corresponding value if want to use another one
#	If this program hasn't detail data, don't need to care about this block
#---------------------------------------------------------------------
     IF g_apz.apz59 = 'Y' THEN
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
			#---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
            "      <apb02 type=\"1\">", sr.apb02 CLIPPED, "</apb02>", ASCII 10,
            "      <apb33 type=\"0\">", sr.apb33 CLIPPED, "</apb33>", ASCII 10,
            "      <apb31 type=\"0\">", sr.apb31 CLIPPED, "</apb31>", ASCII 10,
            "      <apb32 type=\"0\">", sr.apb32 CLIPPED, ' ',l_gen02   CLIPPED, "</apb32>", ASCII 10,
            "      <apb25 type=\"0\">", sr.apb25 CLIPPED, "</apb25>", ASCII 10,
            "      <b25 type=\"0\">", l_b25 CLIPPED, "</b25>", ASCII 10,
            "      <apb26 type=\"0\">", sr.apb26 CLIPPED, "</apb26>", ASCII 10,
            "      <b26 type=\"0\">", l_b26 CLIPPED, "</b26>", ASCII 10,
            "      <apb930 type=\"0\">", sr.apb930 CLIPPED, "</apb930>", ASCII 10,
            "      <gem02c type=\"0\">", l_gem02c CLIPPED, "</gem02c>", ASCII 10,
            "      <apb24 type=\"1\">", sr.apb24 CLIPPED, "</apb24>", ASCII 10,
            "      <apb10 type=\"1\">", sr.apb10 CLIPPED, "</apb10>", ASCII 10,
            "     </record>", ASCII 10
     ELSE
        #apz59='N'單身資料傳空值
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
            "      <apb02 type=\"1\"></apb02>", ASCII 10,
            "      <apb33 type=\"0\"></apb33>", ASCII 10,
            "      <apb31 type=\"0\"></apb31>", ASCII 10,
            "      <apb32 type=\"0\"></apb32>", ASCII 10,
            "      <apb25 type=\"0\"></apb25>", ASCII 10,
            "      <b25 type=\"0\"></b25>", ASCII 10,
            "      <apb26 type=\"0\"></apb26>", ASCII 10,
            "      <b26 type=\"0\"></b26>", ASCII 10,
            "      <apb930 type=\"0\"></apb930>", ASCII 10,
            "      <gem02c type=\"0\"></gem02c>", ASCII 10,
            "      <apb24 type=\"1\"></apb24>", ASCII 10,
            "      <apb10 type=\"1\"></apb10>", ASCII 10,
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
#FUN-920077----end
