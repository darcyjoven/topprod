# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
 # Modify.........: MOD-480101 04/08/05 By ECHO  SQL語法OUTER超過10個會發生錯誤
# Modify.........: No.FUN-680130 06/09/05 By zhuying 欄位形態定義為LIKE
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
#--------------------------------------------------------------------
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
			oea00	LIKE oea_file.oea00,
			oea01	LIKE oea_file.oea01,
			oea02	LIKE oea_file.oea02,
			oea03	LIKE oea_file.oea03,
			oea032	LIKE oea_file.oea032,
			occ02	LIKE occ_file.occ02,
			oea05	LIKE oea_file.oea05,
			oea06	LIKE oea_file.oea06,
			oea08	LIKE oea_file.oea08,
			oea10	LIKE oea_file.oea10,
			oea11	LIKE oea_file.oea11,
			oea12	LIKE oea_file.oea12,
			gen02	LIKE gen_file.gen02,
			gem02	LIKE gem_file.gem02,
			gec02	LIKE gec_file.gec02,
			oea211	LIKE oea_file.oea211,
			oea212	LIKE oea_file.oea212,
			oea213	LIKE oea_file.oea213,
			azi02	LIKE azi_file.azi02,
			oab02	LIKE oab_file.oab02,
			oah02	LIKE oah_file.oah02,
			oag02	LIKE oag_file.oag02,
			oea50	LIKE oea_file.oea50,
			oea61	LIKE oea_file.oea61,
			oea72	LIKE oea_file.oea72,
			oak02	LIKE oak_file.oak02,
			oeauser	LIKE oea_file.oeauser,
			ima021	LIKE ima_file.ima021,
			ima15	LIKE ima_file.ima15,
			oeb03	LIKE oeb_file.oeb03,
			oeb04	LIKE oeb_file.oeb04,
			oeb05	LIKE oeb_file.oeb05,
			oeb06	LIKE oeb_file.oeb06,
			oeb092	LIKE oeb_file.oeb092,
			oeb12	LIKE oeb_file.oeb12,
			oeb13	LIKE oeb_file.oeb13,
			oeb14	LIKE oeb_file.oeb14,
			oeb14t	LIKE oeb_file.oeb14t,
			oeb15	LIKE oeb_file.oeb15,
			oeb19	LIKE oeb_file.oeb19,
			oeb22	LIKE oeb_file.oeb22,
			oeb24	LIKE oeb_file.oeb24,
			oeb70	LIKE oeb_file.oeb70,
			oeb71	LIKE oeb_file.oeb71,
			oeb908	LIKE oeb_file.oeb908,
                        oea04   LIKE oea_file.oea04,
                        oea14   LIKE oea_file.oea14,
                        oea15   LIKE oea_file.oea15
           	END RECORD,
           l_i		LIKE type_file.num5,                     #No.FUN-680130 SMALLINT
            l_sql	LIKE type_file.chr1000#MOD-480101        #No.FUN-680130 VARCHAR(3000)
    DEFINE l_oea00      LIKE oea_file.oea00,                     #No.FUN-680130 VARCHAR(50)
           l_oea11      LIKE oea_file.oea11                      #No.FUN-680130 VARCHAR(100)
 
 
    WHENEVER ERROR CALL cl_err_msg_log
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose SQL
#	Complete remaining SQL statment to fit the needed
#---------------------------------------------------------------------
 
 #MOD-480101
    LET l_sql =                                                      
		"SELECT oea00, oea01, oea02, oea03, oea032,'', oea05,",
		" oea06, oea08, oea10, oea11, oea12, gen02, gem02, gec02,",
		" oea211, oea212, oea213, azi02, oab02, oah02, oag02, oea50,",
		" oea61, oea72, oak02, oeauser, ima021, ima15, oeb03, oeb04,",
		" oeb05, oeb06, oeb092, oeb12, oeb13, oeb14, oeb14t, oeb15,",
		" oeb19, oeb22, oeb24, oeb70, oeb71, oeb908,oea04,oea14,oea15",
                "  FROM oea_file, oeb_file ,OUTER ima_file, ",
                " OUTER gen_file, OUTER gem_file, OUTER gec_file,",
                " OUTER azi_file, OUTER oab_file, OUTER oah_file,",
                " OUTER oag_file, OUTER oak_file",
                " WHERE oea01 = oeb01 ",
                "   AND oea14 = gen_file.gen01 ",
                "   AND oea15 = gem_file.gem01 ",
                "   AND oea21 = gec_file.gec01 ",
                "   AND oea23 = azi_file.azi01 ",
                "   AND oea25 = oab_file.oab01 ",
                "   AND oea31 = oah_file.oah01 ",
                "   AND oea32 = oag_file.oag01 ",
                "   AND oeahold = oak_file.oak01 ",
                "   AND oak_file.oak03 = '1' ",
                "   AND oeb04 = ima_file.ima01 ",
                "   AND oea01 = '", g_formNum CLIPPED, "'"
 
    PREPARE ef_pre FROM l_sql
    IF SQLCA.SQLCODE THEN
       CALL cl_err('prepare: ',SQLCA.SQLCODE, 0)
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
 
        SELECT occ02 INTO sr.occ02          
          FROM occ_file 
         WHERE occ01 = sr.oea04
   
        IF SQLCA.SQLCODE THEN
           LET sr.occ02 = NULL    
        END IF
 #MOD-480101
        IF l_i = 1 THEN
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Call aws_efcli_XMLHeader() to compose XML Header
#	Pass corresponding formCreator & formOwner value as parameters
#---------------------------------------------------------------------
        CALL aws_efcli_XMLHeader(sr.oeauser, sr.oea14)
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose header data
#	Modify tag name & corresponding value if want to use another one
#---------------------------------------------------------------------
           CASE 
             WHEN sr.oea00='0' CALL cl_getmsg('aws-002',g_lang) RETURNING g_msg
             WHEN sr.oea00='1' CALL cl_getmsg('aws-003',g_lang) RETURNING g_msg
             WHEN sr.oea00='2' CALL cl_getmsg('aws-004',g_lang) RETURNING g_msg
             WHEN sr.oea00='3' CALL cl_getmsg('aws-005',g_lang) RETURNING g_msg
             WHEN sr.oea00='4' CALL cl_getmsg('aws-006',g_lang) RETURNING g_msg
             WHEN sr.oea00='5' CALL cl_getmsg('aws-007',g_lang) RETURNING g_msg
           END CASE
             LET l_oea00 = g_msg
 
           CASE
             WHEN sr.oea11='1' CALL cl_getmsg('aws-016',g_lang) RETURNING g_msg
             WHEN sr.oea11='2' CALL cl_getmsg('aws-017',g_lang) RETURNING g_msg
             WHEN sr.oea11='3' CALL cl_getmsg('aws-018',g_lang) RETURNING g_msg
             WHEN sr.oea11='4' CALL cl_getmsg('aws-019',g_lang) RETURNING g_msg
             WHEN sr.oea11='5' CALL cl_getmsg('aws-020',g_lang) RETURNING g_msg
             WHEN sr.oea11='6' CALL cl_getmsg('aws-021',g_lang) RETURNING g_msg
             WHEN sr.oea11='7' CALL cl_getmsg('aws-022',g_lang) RETURNING g_msg
           END CASE
             LET l_oea11 = g_msg
 
           LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <oea00>", sr.oea00 CLIPPED, ' ',l_oea00 CLIPPED, "</oea00>", ASCII 10,
               "     <oea01>", sr.oea01 CLIPPED, "</oea01>", ASCII 10,
               "     <oea02>", sr.oea02 CLIPPED, "</oea02>", ASCII 10,
               "     <oea03>", sr.oea03 CLIPPED, "</oea03>", ASCII 10,
               "     <oea032>", sr.oea032 CLIPPED, "</oea032>", ASCII 10,
               "     <oea04>", sr.oea04 CLIPPED, ' ',sr.occ02 CLIPPED, "</oea04>", ASCII 10,
               "     <oea05>", sr.oea05 CLIPPED, "</oea05>", ASCII 10,
               "     <oea06>", sr.oea06 CLIPPED, "</oea06>", ASCII 10,
               "     <oea08>", sr.oea08 CLIPPED, "</oea08>", ASCII 10,
               "     <oea10>", sr.oea10 CLIPPED, "</oea10>", ASCII 10,
               "     <oea11>", sr.oea11 CLIPPED, ' ',l_oea11 CLIPPED, "</oea11>", ASCII 10,
               "     <oea12>", sr.oea12 CLIPPED, "</oea12>", ASCII 10,
               "     <oea14>", sr.oea14 CLIPPED, ' ',sr.gen02 CLIPPED, "</oea14>", ASCII 10,
               "     <oea15>", sr.oea15 CLIPPED, ' ',sr.gem02 CLIPPED, "</oea15>", ASCII 10,
               "     <oea21>", sr.gec02 CLIPPED, "</oea21>", ASCII 10,
               "     <oea211>", sr.oea211 CLIPPED, "</oea211>", ASCII 10,
               "     <oea212>", sr.oea212 CLIPPED, "</oea212>", ASCII 10,
               "     <oea213>", sr.oea213 CLIPPED, "</oea213>", ASCII 10,
               "     <oea23>", sr.azi02 CLIPPED, "</oea23>", ASCII 10,
               "     <oea25>", sr.oab02 CLIPPED, "</oea25>", ASCII 10,
               "     <oea31>", sr.oah02 CLIPPED, "</oea31>", ASCII 10,
               "     <oea32>", sr.oag02 CLIPPED, "</oea32>", ASCII 10,
               "     <oea50>", sr.oea50 CLIPPED, "</oea50>", ASCII 10,
               "     <oea61>", sr.oea61 CLIPPED, "</oea61>", ASCII 10,
               "     <oea72>", sr.oea72 CLIPPED, "</oea72>", ASCII 10,
               "     <oeahold>", sr.oak02 CLIPPED, "</oeahold>", ASCII 10,
               "     <oeauser>", sr.oeauser CLIPPED, "</oeauser>", ASCII 10,
               "    </head>", ASCII 10,
               "    <body>", ASCII 10
        END IF
 
#---------------------------------------------------------------------
# *CHECK POINT:
#	Compose detail data
#	Modify tag name & corresponding value if want to use another one
#	If this program hasn't detail data, don't need to care about this block
#---------------------------------------------------------------------
        LET g_strXMLInput = g_strXMLInput CLIPPED,
            "     <record>", ASCII 10,
         "      <ima021>", sr.ima021 CLIPPED, "</ima021>", ASCII 10,
            "      <ima15>", sr.ima15 CLIPPED, "</ima15>", ASCII 10,
            "      <oeb03>", sr.oeb03 CLIPPED, "</oeb03>", ASCII 10,
            "      <oeb04>", sr.oeb04 CLIPPED, "</oeb04>", ASCII 10,
            "      <oeb05>", sr.oeb05 CLIPPED, "</oeb05>", ASCII 10,
            "      <oeb06>", sr.oeb06 CLIPPED, "</oeb06>", ASCII 10,
            "      <oeb092>", sr.oeb092 CLIPPED, "</oeb092>", ASCII 10,
            "      <oeb12>", sr.oeb12 CLIPPED, "</oeb12>", ASCII 10,
            "      <oeb13>", sr.oeb13 CLIPPED, "</oeb13>", ASCII 10,
            "      <oeb14>", sr.oeb14 CLIPPED, "</oeb14>", ASCII 10,
            "      <oeb14t>", sr.oeb14t CLIPPED, "</oeb14t>", ASCII 10,
            "      <oeb15>", sr.oeb15 CLIPPED, "</oeb15>", ASCII 10,
            "      <oeb19>", sr.oeb19 CLIPPED, "</oeb19>", ASCII 10,
            "      <oeb22>", sr.oeb22 CLIPPED, "</oeb22>", ASCII 10,
            "      <oeb24>", sr.oeb24 CLIPPED, "</oeb24>", ASCII 10,
            "      <oeb70>", sr.oeb70 CLIPPED, "</oeb70>", ASCII 10,
            "      <oeb71>", sr.oeb71 CLIPPED, "</oeb71>", ASCII 10,
            "      <oeb908>", sr.oeb908 CLIPPED, "</oeb908>", ASCII 10,
            "     </record>", ASCII 10
 
        LET l_i = l_i + 1
    END FOREACH
 
#---------------------------------------------------------------------
# Call aws_efcli_XMLTrailer() to compose XML Trailer
# *Don't need to change
#---------------------------------------------------------------------
    CALL aws_efcli_XMLTrailer()
END FUNCTION
