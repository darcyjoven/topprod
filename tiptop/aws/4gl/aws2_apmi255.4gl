# Prog. Version..: '5.30.06-13.03.12(00004)'     #
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
# Modify.........: No.FUN-680130 06/09/01 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-750017 07/06/13 By JackLai 將代號與名稱拆成不同欄位
# Modify.........: No.TQC-870026 08/08/15 By Vicky 新增欄位
# Modify.........: No.FUN-920106 09/02/23 By sabrina apmi265與apmi255共用此hardcode，但此兩支程式單身欄位有落差  
#                                                    所以用參數來判斷EF送簽時需傳的XML格式  
# Modify.........: No.TQC-930094 09/03/12 By sabrina 調整單身欄位XML順序
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.CHI-9B0005 09/11/05 BY liuxqa substr 修改。
# Modify.........: No:FUN-BB0061 11/11/10 By Jay EasyFlow送簽時針對數值資料增加XML tag內容
 
DATABASE ds
 
#---------------------------------------------------------------------
# Include global variable file: awsef.4gl
# *Don't need to change
#---------------------------------------------------------------------
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
 
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
			pmc03	LIKE pmc_file.pmc03,
			pmi01	LIKE pmi_file.pmi01,
			pmi02	LIKE pmi_file.pmi02,
                        pmi09   LIKE pmi_file.pmi09,    #TQC-870026
			pmi03	LIKE pmi_file.pmi03,
           	        pmi08   LIKE pmi_file.pmi08,    #TQC-870026
                        pmi081  LIKE pmi_file.pmi081,   #TQC-870026
			pmi04	LIKE pmi_file.pmi04,
			pmi05	LIKE pmi_file.pmi05,
			pmiuser	LIKE pmi_file.pmiuser,
			pmj02	LIKE pmj_file.pmj02,
			pmj03	LIKE pmj_file.pmj03,
			pmj031	LIKE pmj_file.pmj031,
			pmj032	LIKE pmj_file.pmj032,
			pmj04	LIKE pmj_file.pmj04,
			pmj05	LIKE pmj_file.pmj05,
			pmj06	LIKE pmj_file.pmj06,
			pmj07	LIKE pmj_file.pmj07,
			pmj08	LIKE pmj_file.pmj08,
			pmj09	LIKE pmj_file.pmj09,
			pmj10	LIKE pmj_file.pmj10,
                        pmj06t  LIKE pmj_file.pmj06t,   #TQC-870026
                        pmj07t  LIKE pmj_file.pmj07t,   #TQC-870026
                        pmj13   LIKE pmj_file.pmj13     #FUN-920106
         #darcy:2023/08/04 add s---
         ,ta_pmj01 like pmj_file.ta_pmj01,
         ta_pmj02 like pmj_file.ta_pmj02,
         ta_pmj03 like pmj_file.ta_pmj03,
         ta_pmj04 like pmj_file.ta_pmj04,
         ta_pmj05 like pmj_file.ta_pmj05,
         ta_pmj06 like pmj_file.ta_pmj06
         #darcy:2023/08/04 add e---
                END RECORD,
           l_i		LIKE type_file.num5,          #No.FUN-680130 SMALLINT
           l_sql	LIKE type_file.chr1000,       #No.FUN-680130 VARCHAR(1000)
           l_pmi01      LIKE pmi_file.pmi01,          #CHI-9B0001 mod
           l_owner      STRING 
    DEFINE sr1  RECORD
                        pmr03   LIKE pmr_file.pmr03,
                        pmr04   LIKE pmr_file.pmr04,
                        pmr05   LIKE pmr_file.pmr05,
                        pmr05t  LIKE pmr_file.pmr05t    #FUN-920106
                END RECORD,
           l_j          LIKE type_file.num5          #No.FUN-680130 SMALLINT
    #--TQC-870026--start--
    DEFINE l_gen02    LIKE gen_file.gen02,
           l_gec07    LIKE gec_file.gec07,
           l_ima44    LIKE ima_file.ima44,
           g_argv1    LIKE type_file.chr1,           #FUN-920106
           l_smydesc  LIKE smy_file.smydesc            #FUN-920106
    #--TQC-870026--end--
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
  LET g_argv1 = ARG_VAL(1)   #FUN-920106
   if cl_null(g_argv1) then
      select pmi10 into g_argv1 from pmi_file 
       where pmi01 = g_formNum
   end if
    LET l_sql =
		"SELECT pmc03, pmi01, pmi02, pmi09, pmi03, pmi08, pmi081, pmi04, pmi05,",   #TQC-870026 add pmi09,pmi08,pmi081
  		" pmiuser, pmj02, pmj03, pmj031, pmj032, pmj04, pmj05, pmj06, pmj07,",
		" pmj08, pmj09, pmj10,",
                " pmj06t, pmj07t, pmj13",     #TQC-870026  #FUN-920106 add pmj13
                " ,ta_pmj01,ta_pmj02,ta_pmj03,ta_pmj04,ta_pmj05,ta_pmj06 ", #darcy:2023/08/04 add
                "  FROM pmi_file, pmj_file, OUTER pmc_file",
                " WHERE pmi01 = pmj01 ",
                "   AND pmc_file.pmc01 = pmi03 ",
                "   AND pmi01 = '", g_formNum CLIPPED, "'"
    PREPARE ef_pre FROM l_sql
    IF STATUS THEN
       CALL cl_err('prepare: ', STATUS, 0)
       LET g_strXMLInput = ''
       RETURN
    END IF
    DECLARE ef_cur CURSOR FOR ef_pre
 
    DECLARE pmr_cur CURSOR FOR SELECT pmr03, pmr04, pmr05, pmr05t     #FUN-920106 add pmr05t 
                                 FROM pmr_file 
                                WHERE pmr01 = ? AND pmr02 = ?
 
    LET l_i = 1
    FOREACH ef_cur INTO sr.*
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
#---------------------------------------------------------------------
      
 
 
        CALL aws_efcli2_XMLHeader()
 
           #--TQC-870026 --start--
           IF NOT cl_null(sr.pmi09) THEN
              SELECT gen02 INTO l_gen02 FROM gen_file  WHERE gen01 = sr.pmi09
           END IF
 
           IF NOT cl_null(sr.pmi08) THEN
              SELECT gec07 INTO l_gec07 FROM gec_file WHERE gec01 = sr.pmi08 AND gec011='1'
           END IF
 
           IF cl_null(l_gec07) THEN
              LET l_gec07 = 'N'
           END IF
           #--TQC-870026 --end--
           #FUN-920106---add---start
           IF NOT cl_null(sr.pmi01) THEN
              #SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=substr(sr.pmi01,1,3)
              LET l_pmi01 = sr.pmi01                                    #CHI-9B0005 mod
              LET l_pmi01 = l_pmi01[1,3]                                #CHI-9B0005 mod
              SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=l_pmi01   #CHI-9B0005 mod
           END IF
           #FUN-920106---ad---end---
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           LET g_strXMLInput = g_strXMLInput CLIPPED,
		       #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
               "     <pmi01 type=\"0\">", sr.pmi01 CLIPPED, "</pmi01>", ASCII 10,
               "     <smydesc type=\"1\">", l_smydesc CLIPPED, "</smydesc>", ASCII 10,    #FUN-910036 add
               "     <pmi02 type=\"0\">", sr.pmi02 CLIPPED, "</pmi02>", ASCII 10,
               #No.FUN-750017 --start--
               #"    <pmi03>", sr.pmi03 CLIPPED, ' ', sr.pmc03 CLIPPED, "</pmi03>", ASCII 10,
               "     <pmi03 type=\"0\">", sr.pmi03 CLIPPED, "</pmi03>", ASCII 10,
               "     <pmc03 type=\"0\">", sr.pmc03 CLIPPED, "</pmc03>", ASCII 10,
               #No.FUN-750017 --end--
               "     <pmi04 type=\"0\">", sr.pmi04 CLIPPED, "</pmi04>", ASCII 10,
               "     <pmi05 type=\"0\">", sr.pmi05 CLIPPED, "</pmi05>", ASCII 10,
               #--TQC-870026 --start--
               "     <pmi08 type=\"0\">", sr.pmi08 CLIPPED, "</pmi08>", ASCII 10,
               "     <pmi09 type=\"0\">", sr.pmi09 CLIPPED, "</pmi09>", ASCII 10,
               "     <pmi081 type=\"1\">", sr.pmi081 CLIPPED, "</pmi081>", ASCII 10,
               "     <gen02 type=\"0\">", l_gen02 CLIPPED, "</gen02>", ASCII 10,
               "     <gec07 type=\"0\">", l_gec07 CLIPPED, "</gec07>", ASCII 10,
               #--TQC-870026 --end--
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
        CASE sr.pmi05
             WHEN 'Y'
                  LET l_j = 1
                  FOREACH pmr_cur USING sr.pmi01, sr.pmj02 INTO sr1.*
                      IF l_j = 1 THEN
                         #--TQC-870026 --start--
                         LET l_ima44 = ""
                         IF NOT cl_null(sr.pmj03) THEN
                            SELECT ima44 INTO l_ima44 FROM ima_file
                             WHERE ima01=sr.pmj03
 
                            IF SQLCA.sqlcode THEN
                                  LET l_ima44 = ""
                            END IF
                         END IF
                         #--TQC-870026 --end--
                         IF g_argv1 = '1'  THEN       #FUN-920106
                            LET g_strXMLInput = g_strXMLInput CLIPPED,
                                "     <record>", ASCII 10,
								#---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
                                "      <pmj02 type=\"1\">", sr.pmj02 CLIPPED, "</pmj02>", ASCII 10,
                                "      <pmj03 type=\"0\">", sr.pmj03 CLIPPED, "</pmj03>", ASCII 10,
                                "      <pmj031 type=\"0\">", sr.pmj031 CLIPPED, "</pmj031>", ASCII 10,
                                "      <pmj032 type=\"0\">", sr.pmj032 CLIPPED, "</pmj032>", ASCII 10,
                                "      <pmj04 type=\"0\">", sr.pmj04 CLIPPED, "</pmj04>", ASCII 10,
                                "      <ima44 type=\"0\">", l_ima44 CLIPPED, "</ima44>", ASCII 10,     #TQC-930094
                                "      <pmj05 type=\"0\">", sr.pmj05 CLIPPED, "</pmj05>", ASCII 10,
                                "      <pmj06 type=\"1\">", sr.pmj06 CLIPPED, "</pmj06>", ASCII 10,
                                "      <pmj06t type=\"1\">", sr.pmj06t CLIPPED, "</pmj06t>", ASCII 10, #TQC-930094
                                "      <pmj07 type=\"1\">", sr.pmj07 CLIPPED, "</pmj07>", ASCII 10,
                                "      <pmj07t type=\"1\">", sr.pmj07t CLIPPED, "</pmj07t>", ASCII 10, #TQC-930094
                                "      <pmj08 type=\"0\">", sr.pmj08 CLIPPED, "</pmj08>", ASCII 10,
                                "      <pmj09 type=\"0\">", sr.pmj09 CLIPPED, "</pmj09>", ASCII 10,
                                "      <pmj10 type=\"0\">", sr.pmj10 CLIPPED, "</pmj10>", ASCII 10,
                                "      <pmr03 type=\"1\">", sr1.pmr03 CLIPPED, "</pmr03>", ASCII 10,
                                "      <pmr04 type=\"1\">", sr1.pmr04 CLIPPED, "</pmr04>", ASCII 10,
                                "      <pmr05 type=\"1\">", sr1.pmr05 CLIPPED, "</pmr05>", ASCII 10,
                                "      <pmr05t type=\"1\">", sr1.pmr05t CLIPPED, "</pmr05t>", ASCII 10,      #FUN-920106
                                #--TQC-870026 --start--
                               #"      <pmj06t>", sr.pmj06t CLIPPED, "</pmj06t>", ASCII 10, #TQC-930094 mark 
                               #"      <pmj07t>", sr.pmj07t CLIPPED, "</pmj07t>", ASCII 10, #TQC-930094 mark
                               #"      <ima44>", l_ima44 CLIPPED, "</ima44>", ASCII 10,     #TQC-930094 mark
                                #--TQC-870026 --end--
                                #darcy:2023/08/04 add s---
                                "      <ta_pmj01 type=\"1\">", sr.ta_pmj01 CLIPPED, "</ta_pmj01>", ASCII 10,
                                "      <ta_pmj02 type=\"1\">", sr.ta_pmj02 CLIPPED, "</ta_pmj02>", ASCII 10,
                                "      <ta_pmj03 type=\"1\">", sr.ta_pmj03 CLIPPED, "</ta_pmj03>", ASCII 10,
                                "      <ta_pmj04 type=\"1\">", sr.ta_pmj04 CLIPPED, "</ta_pmj04>", ASCII 10,
                                "      <ta_pmj05 type=\"0\">", sr.ta_pmj05 CLIPPED, "</ta_pmj05>", ASCII 10,
                                "      <ta_pmj06 type=\"0\">", sr.ta_pmj06 CLIPPED, "</ta_pmj06>", ASCII 10,
                                #darcy:2023/08/04 add e---
                                "     </record>", ASCII 10
                         #FUN-920106---add---start---
                         ELSE
                            LET g_strXMLInput = g_strXMLInput CLIPPED,
                                "     <record>", ASCII 10,
                                "      <pmj02 type=\"1\">", sr.pmj02 CLIPPED, "</pmj02>", ASCII 10,
                                "      <pmj03 type=\"0\">", sr.pmj03 CLIPPED, "</pmj03>", ASCII 10,
                                "      <pmj031 type=\"0\">", sr.pmj031 CLIPPED, "</pmj031>", ASCII 10,
                                "      <pmj032 type=\"0\">", sr.pmj032 CLIPPED, "</pmj032>", ASCII 10,
                                "      <pmj04 type=\"0\">", sr.pmj04 CLIPPED, "</pmj04>", ASCII 10,
                                "      <ima44 type=\"0\">", l_ima44 CLIPPED, "</ima44>", ASCII 10,      #TQC-930094
                                "      <pmj10 type=\"0\">", sr.pmj10 CLIPPED, "</pmj10>", ASCII 10,
                                "      <pmj13 type=\"0\">", sr.pmj13 CLIPPED, "</pmj13>", ASCII 10,
                                "      <pmj05 type=\"0\">", sr.pmj05 CLIPPED, "</pmj05>", ASCII 10,
                                "      <pmj06 type=\"1\">", sr.pmj06 CLIPPED, "</pmj06>", ASCII 10,
                                "      <pmj06t type=\"1\">", sr.pmj06t CLIPPED, "</pmj06t>", ASCII 10,  #TQC-930094
                                "      <pmj07 type=\"1\">", sr.pmj07 CLIPPED, "</pmj07>", ASCII 10,
                                "      <pmj07t type=\"1\">", sr.pmj07t CLIPPED, "</pmj07t>", ASCII 10,  #TQC-930094
                                "      <pmj08 type=\"0\">", sr.pmj08 CLIPPED, "</pmj08>", ASCII 10,
                                "      <pmj09 type=\"0\">", sr.pmj09 CLIPPED, "</pmj09>", ASCII 10,
                                "      <pmr03 type=\"1\">", sr1.pmr03 CLIPPED, "</pmr03>", ASCII 10,
                                "      <pmr04 type=\"1\">", sr1.pmr04 CLIPPED, "</pmr04>", ASCII 10,
                                "      <pmr05 type=\"1\">", sr1.pmr05 CLIPPED, "</pmr05>", ASCII 10,
                                "      <pmr05t type=\"1\">", sr1.pmr05t CLIPPED, "</pmr05t>", ASCII 10,    
                                #--TQC-870026 --start--
                               #"      <pmj06t>", sr.pmj06t CLIPPED, "</pmj06t>", ASCII 10,  #TQC-930094 mark 
                               #"      <pmj07t>", sr.pmj07t CLIPPED, "</pmj07t>", ASCII 10,  #TQC-930094 mark
                               #"      <ima44>", l_ima44 CLIPPED, "</ima44>", ASCII 10,      #TQC-930094 mark
                                #--TQC-870026 --end--
                                #darcy:2023/08/04 add s---
                                "      <ta_pmj01 type=\"1\">", sr.ta_pmj01 CLIPPED, "</ta_pmj01>", ASCII 10,
                                "      <ta_pmj02 type=\"1\">", sr.ta_pmj02 CLIPPED, "</ta_pmj02>", ASCII 10,
                                "      <ta_pmj03 type=\"1\">", sr.ta_pmj03 CLIPPED, "</ta_pmj03>", ASCII 10,
                                "      <ta_pmj04 type=\"1\">", sr.ta_pmj04 CLIPPED, "</ta_pmj04>", ASCII 10,
                                "      <ta_pmj05 type=\"0\">", sr.ta_pmj05 CLIPPED, "</ta_pmj05>", ASCII 10,
                                "      <ta_pmj06 type=\"0\">", sr.ta_pmj06 CLIPPED, "</ta_pmj06>", ASCII 10,
                                #darcy:2023/08/04 add e---
                                "     </record>", ASCII 10
                         END IF
                         #FUN-920106---add---end---   
                      ELSE
                         IF g_argv1 = '1' THEN       #FUN-920106 add
                            LET g_strXMLInput = g_strXMLInput CLIPPED,
                                "     <record>", ASCII 10, 
                                "      <pmj02 type=\"1\"></pmj02>", ASCII 10,
                                "      <pmj03 type=\"0\"></pmj03>", ASCII 10,
                                "      <pmj031 type=\"0\"></pmj031>", ASCII 10,
                                "      <pmj032 type=\"0\"></pmj032>", ASCII 10,
                                "      <pmj04 type=\"0\"></pmj04>", ASCII 10,
                                "      <ima44 type=\"0\"></ima44>", ASCII 10,     #TQC-930094
                                "      <pmj05 type=\"0\"></pmj05>", ASCII 10,
                                "      <pmj06 type=\"1\"></pmj06>", ASCII 10,
                                "      <pmj06t type=\"1\"></pmj06t>", ASCII 10,   #TQC-930094
                                "      <pmj07 type=\"1\"></pmj07>", ASCII 10,
                                "      <pmj07t type=\"1\"></pmj07t>", ASCII 10,   #TQC-930094
                                "      <pmj08 type=\"0\"></pmj08>", ASCII 10,
                                "      <pmj09 type=\"0\"></pmj09>", ASCII 10,
                                "      <pmj10 type=\"0\"></pmj10>", ASCII 10,
                                "      <pmr03 type=\"1\">", sr1.pmr03 CLIPPED, "</pmr03>", ASCII 10,
                                "      <pmr04 type=\"1\">", sr1.pmr04 CLIPPED, "</pmr04>", ASCII 10,
                                "      <pmr05 type=\"1\">", sr1.pmr05 CLIPPED, "</pmr05>", ASCII 10,
                                "      <pmr05t type=\"1\">", sr1.pmr05t CLIPPED, "</pmr05t>", ASCII 10,     #FUN-920106
                                #--TQC-870026 --start--
                               #"      <pmj06t></pmj06t>", ASCII 10,   #TQC-930094 mark
                               #"      <pmj07t></pmj07t>", ASCII 10,   #TQC-930094 mark
                               #"      <ima44></ima44>", ASCII 10,     #TQC-930094 mark
                                #--TQC-870026 --end--
                                #darcy:2023/08/04 add s---
                                "      <ta_pmj01 type=\"1\">", sr.ta_pmj01 CLIPPED, "</ta_pmj01>", ASCII 10,
                                "      <ta_pmj02 type=\"1\">", sr.ta_pmj02 CLIPPED, "</ta_pmj02>", ASCII 10,
                                "      <ta_pmj03 type=\"1\">", sr.ta_pmj03 CLIPPED, "</ta_pmj03>", ASCII 10,
                                "      <ta_pmj04 type=\"1\">", sr.ta_pmj04 CLIPPED, "</ta_pmj04>", ASCII 10,
                                "      <ta_pmj05 type=\"0\">", sr.ta_pmj05 CLIPPED, "</ta_pmj05>", ASCII 10,
                                "      <ta_pmj06 type=\"0\">", sr.ta_pmj06 CLIPPED, "</ta_pmj06>", ASCII 10,
                                #darcy:2023/08/04 add e---
                                "     </record>", ASCII 10
                         #FUN-920106---add---start---
                         ELSE
                            LET g_strXMLInput = g_strXMLInput CLIPPED,
                                "     <record>", ASCII 10,
                                "      <pmj02 type=\"1\"></pmj02>", ASCII 10,
                                "      <pmj03 type=\"0\"></pmj03>", ASCII 10,
                                "      <pmj031 type=\"0\"></pmj031>", ASCII 10,
                                "      <pmj032 type=\"0\"></pmj032>", ASCII 10,
                                "      <pmj04 type=\"0\"></pmj04>", ASCII 10,
                                "      <ima44 type=\"0\"></ima44>", ASCII 10,    #TQC-930094
                                "      <pmj10 type=\"0\"></pmj10>", ASCII 10,
                                "      <pmj13 type=\"0\"></pmj13>", ASCII 10,
                                "      <pmj05 type=\"0\"></pmj05>", ASCII 10,
                                "      <pmj06 type=\"1\"></pmj06>", ASCII 10,
                                "      <pmj06t type=\"1\"></pmj06t>", ASCII 10,  #TQC-930094
                                "      <pmj07 type=\"1\"></pmj07>", ASCII 10,
                                "      <pmj07t type=\"1\"></pmj07t>", ASCII 10,  #TQC-930094
                                "      <pmj08 type=\"0\"></pmj08>", ASCII 10,
                                "      <pmj09 type=\"0\"></pmj09>", ASCII 10,
                                "      <pmr03 type=\"1\">", sr1.pmr03 CLIPPED, "</pmr03>", ASCII 10,
                                "      <pmr04 type=\"1\">", sr1.pmr04 CLIPPED, "</pmr04>", ASCII 10,
                                "      <pmr05 type=\"1\">", sr1.pmr05 CLIPPED, "</pmr05>", ASCII 10,
                                "      <pmr05t type=\"1\">", sr1.pmr05t CLIPPED, "</pmr05t>", ASCII 10,  
                                #---FUN-BB0061---end------- 								
                                #--TQC-870026 --start--
                               #"      <pmj06t>", sr.pmj06t CLIPPED, "</pmj06t>", ASCII 10,  #TQC-930094 mark
                               #"      <pmj07t>", sr.pmj07t CLIPPED, "</pmj07t>", ASCII 10,  #TQC-930094 mark
                               #"      <ima44>", l_ima44 CLIPPED, "</ima44>", ASCII 10,      #TQC-930094 mark
                                #--TQC-870026 --end--
                                #darcy:2023/08/04 add s---
                                "      <ta_pmj01 type=\"1\">", sr.ta_pmj01 CLIPPED, "</ta_pmj01>", ASCII 10,
                                "      <ta_pmj02 type=\"1\">", sr.ta_pmj02 CLIPPED, "</ta_pmj02>", ASCII 10,
                                "      <ta_pmj03 type=\"1\">", sr.ta_pmj03 CLIPPED, "</ta_pmj03>", ASCII 10,
                                "      <ta_pmj04 type=\"1\">", sr.ta_pmj04 CLIPPED, "</ta_pmj04>", ASCII 10,
                                "      <ta_pmj05 type=\"0\">", sr.ta_pmj05 CLIPPED, "</ta_pmj05>", ASCII 10,
                                "      <ta_pmj06 type=\"0\">", sr.ta_pmj06 CLIPPED, "</ta_pmj06>", ASCII 10,
                                #darcy:2023/08/04 add e---
                                "     </record>", ASCII 10
                         END IF
                         #FUN-920106---add---end---   
                      END IF
 
                      LET l_j = l_j + 1
                  END FOREACH
             OTHERWISE
                  #--TQC-870026 --start--
                  LET l_ima44 = ""
 
                  IF NOT cl_null(sr.pmj03) THEN
                     SELECT ima44 INTO l_ima44 FROM ima_file
                      WHERE ima01=sr.pmj03
 
                     IF SQLCA.sqlcode THEN
                           LET l_ima44 = ""
                     END IF
                  END IF
                  #--TQC-870026 --end--
              IF g_argv1 = '1' THEN     #FUN-920106 add
                  LET g_strXMLInput = g_strXMLInput CLIPPED,
                      "     <record>", ASCII 10,
					  #---FUN-BB0061---start-----每個tag中增加type="0"(文字):type="1"(數字)屬性給EasyFlow判斷
                      "      <pmj02 type=\"1\">", sr.pmj02 CLIPPED, "</pmj02>", ASCII 10,
                      "      <pmj03 type=\"0\">", sr.pmj03 CLIPPED, "</pmj03>", ASCII 10,
                      "      <pmj031 type=\"0\">", sr.pmj031 CLIPPED, "</pmj031>", ASCII 10,
                      "      <pmj032 type=\"0\">", sr.pmj032 CLIPPED, "</pmj032>", ASCII 10,
                      "      <pmj04 type=\"0\">", sr.pmj04 CLIPPED, "</pmj04>", ASCII 10,
                      "      <ima44 type=\"0\">", l_ima44 CLIPPED, "</ima44>", ASCII 10,      #TQC-930094
                      "      <pmj05 type=\"0\">", sr.pmj05 CLIPPED, "</pmj05>", ASCII 10,
                      "      <pmj06 type=\"1\">", sr.pmj06 CLIPPED, "</pmj06>", ASCII 10,
                      "      <pmj06t type=\"1\">", sr.pmj06t CLIPPED, "</pmj06t>", ASCII 10,  #TQC-930094
                      "      <pmj07 type=\"1\">", sr.pmj07 CLIPPED, "</pmj07>", ASCII 10,
                      "      <pmj07t type=\"1\">", sr.pmj07t CLIPPED, "</pmj07t>", ASCII 10,  #TQC-930094
                      "      <pmj08 type=\"0\">", sr.pmj08 CLIPPED, "</pmj08>", ASCII 10,
                      "      <pmj09 type=\"0\">", sr.pmj09 CLIPPED, "</pmj09>", ASCII 10,
                      #TQC-870026 --start
                     #"      <pmj06t>", sr.pmj06t CLIPPED, "</pmj06t>", ASCII 10,  #TQC-930094 mark
                     #"      <pmj07t>", sr.pmj07t CLIPPED, "</pmj07t>", ASCII 10,  #TQC-930094 mark
                     #"      <ima44>", l_ima44 CLIPPED, "</ima44>", ASCII 10,      #TQC-930094 mark
                      #TQC-870026 --end
                     #darcy:2023/08/04 add s---
                     "      <ta_pmj01 type=\"1\">", sr.ta_pmj01 CLIPPED, "</ta_pmj01>", ASCII 10,
                     "      <ta_pmj02 type=\"1\">", sr.ta_pmj02 CLIPPED, "</ta_pmj02>", ASCII 10,
                     "      <ta_pmj03 type=\"1\">", sr.ta_pmj03 CLIPPED, "</ta_pmj03>", ASCII 10,
                     "      <ta_pmj04 type=\"1\">", sr.ta_pmj04 CLIPPED, "</ta_pmj04>", ASCII 10,
                     "      <ta_pmj05 type=\"0\">", sr.ta_pmj05 CLIPPED, "</ta_pmj05>", ASCII 10,
                     "      <ta_pmj06 type=\"0\">", sr.ta_pmj06 CLIPPED, "</ta_pmj06>", ASCII 10,
                     #darcy:2023/08/04 add e---
                      "     </record>", ASCII 10
          #FUN-920106---add
              ELSE 
                  LET g_strXMLInput = g_strXMLInput CLIPPED,
                      "     <record>", ASCII 10,
                      "      <pmj02 type=\"1\">", sr.pmj02 CLIPPED, "</pmj02>", ASCII 10,
                      "      <pmj03 type=\"0\">", sr.pmj03 CLIPPED, "</pmj03>", ASCII 10,
                      "      <pmj031 type=\"0\">", sr.pmj031 CLIPPED, "</pmj031>", ASCII 10,
                      "      <pmj032 type=\"0\">", sr.pmj032 CLIPPED, "</pmj032>", ASCII 10,
                      "      <pmj04 type=\"0\">", sr.pmj04 CLIPPED, "</pmj04>", ASCII 10,
                      "      <ima44 type=\"0\">", l_ima44 CLIPPED, "</ima44>", ASCII 10,     #TQC-930094
                      "      <pmj10 type=\"0\">", sr.pmj10 CLIPPED, "</pmj10>", ASCII 10,
                      "      <pmj13 type=\"0\">", sr.pmj13 CLIPPED, "</pmj13>", ASCII 10,
                      "      <pmj05 type=\"0\">", sr.pmj05 CLIPPED, "</pmj05>", ASCII 10,
                      "      <pmj06 type=\"1\">", sr.pmj06 CLIPPED, "</pmj06>", ASCII 10,
                      "      <pmj06t type=\"1\">", sr.pmj06t CLIPPED, "</pmj06t>", ASCII 10, #TQC-930094
                      "      <pmj07 type=\"1\">", sr.pmj07 CLIPPED, "</pmj07>", ASCII 10,
                      "      <pmj07t type=\"1\">", sr.pmj07t CLIPPED, "</pmj07t>", ASCII 10, #TQC-930094
                      "      <pmj08 type=\"0\">", sr.pmj08 CLIPPED, "</pmj08>", ASCII 10,
                      "      <pmj09 type=\"0\">", sr.pmj09 CLIPPED, "</pmj09>", ASCII 10,
                      #---FUN-BB0061---end-------
                      #TQC-870026 --start
                     #"      <pmj06t>", sr.pmj06t CLIPPED, "</pmj06t>", ASCII 10,    #TQC-930094 mark
                     #"      <pmj07t>", sr.pmj07t CLIPPED, "</pmj07t>", ASCII 10,    #TQC-930094 mark
                     #"      <ima44>", l_ima44 CLIPPED, "</ima44>", ASCII 10,        #TQC-930094 mark
                      #TQC-870026 --end
                     #darcy:2023/08/04 add s---
                     "      <ta_pmj01 type=\"1\">", sr.ta_pmj01 CLIPPED, "</ta_pmj01>", ASCII 10,
                     "      <ta_pmj02 type=\"1\">", sr.ta_pmj02 CLIPPED, "</ta_pmj02>", ASCII 10,
                     "      <ta_pmj03 type=\"1\">", sr.ta_pmj03 CLIPPED, "</ta_pmj03>", ASCII 10,
                     "      <ta_pmj04 type=\"1\">", sr.ta_pmj04 CLIPPED, "</ta_pmj04>", ASCII 10,
                     "      <ta_pmj05 type=\"0\">", sr.ta_pmj05 CLIPPED, "</ta_pmj05>", ASCII 10,
                     "      <ta_pmj06 type=\"0\">", sr.ta_pmj06 CLIPPED, "</ta_pmj06>", ASCII 10,
                     #darcy:2023/08/04 add e---
                      "     </record>", ASCII 10
              END IF
          #FUN-920106---add---end
        END CASE
 
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
