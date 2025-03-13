# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: atmr244.4gl
# Descriptions...: 客戶訂單追蹤表
# Date & Author..: 06/03/29 by yoyo
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換 
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/26 By Hellen 本原幣取位修改
# Modify.........: TQC-6A0079 06/11/01 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By bnlent l_time轉g_time
# Modify.........: No.TQC-710043 07/01/11 By wujie  修正漏打印程序名稱
# Modify.........: No.FUN-750129 07/06/18 By Carrier 報表轉Crystal Report格式
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
DEFINE tm  RECORD
           wc      STRING,
           s       LIKE type_file.chr4,      #No.FUN-680120 VARCHAR(03)
           t       LIKE type_file.chr4,      #No.FUN-680120 VARCHAR(03)
           u       LIKE type_file.chr4,      #No.FUN-680120 VARCHAR(03)
           a       LIKE type_file.chr1,    #No.FUN-680120 VARCHAR(01)
           more    LIKE type_file.chr1     #No.FUN-680120 VARCHAR(01)
           END RECORD
DEFINE   g_orderA        ARRAY[3] OF LIKE zaa_file.zaa08    #No.FUN-680120 VARCHAR(10) # TQC-6A0079
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_head1         STRING
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE g_sma116         LIKE sma_file.sma116
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE l_table          STRING  #No.FUN-750129
DEFINE g_str            STRING  #No.FUN-750129
DEFINE g_sql            STRING  #No.FUN-750129
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
   #No.FUN-750129  --Begin
   LET g_sql = " order1.bnb_file.bnb06,",
               " order2.bnb_file.bnb06,",
               " order3.bnb_file.bnb06,",
               " oea00.oea_file.oea00,",
               " oea01.oea_file.oea01,",
               " oea02.oea_file.oea02,",
               " oea03.oea_file.oea03,",
               " oea032.oea_file.oea032,",
               " oea04.oea_file.oea04,",
               " occ02.occ_file.occ02,",
               " oea1004.oea_file.oea1004,",
               " occ02b.occ_file.occ02,",
               " oea1015.oea_file.oea1015,",
               " pmc02.pmc_file.pmc02,",
               " gen02.gen_file.gen02,",
               " gem02.gem_file.gem02,",
               " oea23.oea_file.oea23,",
               " oeb03.oeb_file.oeb03,",
               " oeb1003.oeb_file.oeb1003,",
               " oeb04.oeb_file.oeb04,",
               " oeb1012.oeb_file.oeb1012,",
               " oeb06.oeb_file.oeb06,",
               " oeb05.oeb_file.oeb05,",
               " oeb12.oeb_file.oeb12,",
               " oeb13.oeb_file.oeb13,",
               " oeb14.oeb_file.oeb14,",
               " oeb15.oeb_file.oeb15,",
               " oeb910.oeb_file.oeb910,",
               " oeb912.oeb_file.oeb912,",
               " oeb913.oeb_file.oeb913,",
               " oeb915.oeb_file.oeb915,",
               " oeb916.oeb_file.oeb916,",
               " oeb917.oeb_file.oeb917,",
               " oea14.oea_file.oea14,",
               " oea15.oea_file.oea15,",
               " oga01.oga_file.oga01,",
               " oga02.oga_file.oga02,",
               " ogb03.ogb_file.ogb03,",
               " ogb12.ogb_file.ogb12,",
               " ogb13.ogb_file.ogb13,",
               " ogb14.ogb_file.ogb14,",
               " ogb23.oga_file.oga23,",
               " oma01.oma_file.oma01,",
               " oma10.oma_file.oma10,",
               " omb03.omb_file.omb03,",
               " t_azi03.azi_file.azi03,",
               " t_azi04.azi_file.azi04,",
               " t_azi05.azi_file.azi05,",
               " ima021.ima_file.ima021,",
               " l_azi03.azi_file.azi03,",
               " l_azi04.azi_file.azi04,",
               " l_str4.type_file.chr1000 "
 
   LET l_table = cl_prt_temptable('aglr900',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?  )  "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-750129  --End
               
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = 'N'
   LET g_prtway = ARG_VAL(5)
   LET g_copies = 1
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.a  = ARG_VAL(11)
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r244_tm(0,0)
      ELSE CALL r244()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION r244_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01                  
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(1000)
 
   LET p_row = 2 LET p_col = 17
 
   OPEN WINDOW r244_w AT p_row,p_col WITH FORM "atm/42f/atmr244"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '3'
   LET tm2.u1  = 'Y'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.a    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oea03,oea04,oea01,oea02,oea14,oea15,oea23,oeb15
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
        ON ACTION CONTROLP                 
           IF INFIELD(oea03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea03
              NEXT FIELD oea03
           END IF
           IF INFIELD(oea04) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_occ"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea04
              NEXT FIELD oea04
           END IF
           IF INFIELD(oea14) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea14
              NEXT FIELD oea14
           END IF
           IF INFIELD(oea15) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gem"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO oea15
              NEXT FIELD oea15
           END IF
 
       ON ACTION locale
          LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                 
          EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r244_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.a,tm.more  WITHOUT DEFAULTS
		
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[123]' THEN NEXT FIELD a END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r244_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='atmr244'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('atmr244','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",           
                         " '",g_template CLIPPED,"'"           
         CALL cl_cmdat('atmr244',g_time,l_cmd)
      END IF
      CLOSE WINDOW r244_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r244()
   ERROR ""
END WHILE
   CLOSE WINDOW r244_w
END FUNCTION
 
FUNCTION r244()
DEFINE l_name    LIKE type_file.chr20            #No.FUN-680120 VARCHAR(20)        # External(Disk) file name
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6B0014
DEFINE l_sql     LIKE type_file.chr1000          # RDSQL STATEMENT   #No.FUN-680120 VARCHAR(1000)
DEFINE l_za05    LIKE ima_file.ima01             #No.FUN-680120 VARCHAR(40)
DEFINE l_order   ARRAY[5] OF LIKE oea_file.oea03 #No.FUN-680120 VARCHAR(20)                         #
DEFINE sr        RECORD order1 LIKE bnb_file.bnb06,   #No.FUN-680120 VARCHAR(20)
                        order2 LIKE bnb_file.bnb06,   #No.FUN-680120 VARCHAR(20)
                        order3 LIKE bnb_file.bnb06,   #No.FUN-680120 VARCHAR(20)
                        oea00   LIKE oea_file.oea00,
                        oea01   LIKE oea_file.oea01,
                        oea02   LIKE oea_file.oea02,
                        oea03   LIKE oea_file.oea03,
                        oea032  LIKE oea_file.oea032,		#客戶簡稱
                        oea04   LIKE oea_file.oea04,		#客戶編號
                        occ02   LIKE occ_file.occ02,		#客戶簡稱
                        oea1004 LIKE oea_file.oea1004,
                        occ02b  LIKE occ_file.occ02,
                        oea1015 LIKE oea_file.oea1015,
                        pmc02   LIKE pmc_file.pmc02,
                        gen02   LIKE gen_file.gen02,
                        gem02   LIKE gem_file.gem02,
                        oea23   LIKE oea_file.oea23,
                        oeb03   LIKE oeb_file.oeb03,
                        oeb1003 LIKE oeb_file.oeb1003,
                        oeb04   LIKE oeb_file.oeb04,
                        oeb1012 LIKE oeb_file.oeb1012,
                        oeb06   LIKE oeb_file.oeb06,
                        oeb05   LIKE oeb_file.oeb05,
                        oeb12   LIKE oeb_file.oeb12,
                        oeb13   LIKE oeb_file.oeb13,
                        oeb14   LIKE oeb_file.oeb14,
                        oeb15   LIKE oeb_file.oeb15,
                        oeb910  LIKE oeb_file.oeb910,            
                        oeb912  LIKE oeb_file.oeb912,            
                        oeb913  LIKE oeb_file.oeb913,            
                        oeb915  LIKE oeb_file.oeb915,            
                        oeb916  LIKE oeb_file.oeb916,            
                        oeb917  LIKE oeb_file.oeb917,            
                        oea14   LIKE oea_file.oea14,              
                        oea15   LIKE oea_file.oea15               
                        END RECORD
#No.FUN-750129  --Begin
DEFINE l_oga            RECORD
                        oga01    LIKE oga_file.oga01,
                        oga02    LIKE oga_file.oga02,
                        ogb03    LIKE ogb_file.ogb03,
                        ogb12    LIKE ogb_file.ogb12,
                        ogb13    LIKE ogb_file.ogb13,  
                        ogb14    LIKE ogb_file.ogb14,
                        oga23    LIKE oga_file.oga23  
                        END RECORD 
DEFINE l_oma            RECORD
                        oma01    LIKE oma_file.oma01,
                        oma10    LIKE oma_file.oma10,
                        omb03    LIKE omb_file.omb03
                        END RECORD
DEFINE l_azi03          LIKE azi_file.azi03   
DEFINE l_azi04          LIKE azi_file.azi04   
DEFINE l_ima021         LIKE ima_file.ima021  
DEFINE l_oeb915         STRING
DEFINE l_oeb912         STRING
DEFINE l_oeb12          STRING
DEFINE l_str4           LIKE type_file.chr1000
DEFINE l_ima906         LIKE ima_file.ima906
DEFINE l_cnt            LIKE type_file.num5
#No.FUN-750129  --End     
 
     #No.FUN-750129  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-750129  --End
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
 
#NO.CHI-6A0004 --START
#    SELECT azi03,azi04,azi05
#      INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#      FROM azi_file
#     WHERE azi01=g_aza.aza17
#NO.CHI-6A0004 --END
     LET l_sql = "SELECT '','','',",
                 "oea00, oea01, oea02, oea03, oea032, oea04, occ02, oea1004,'',oea1015,'',gen02,",
                 "gem02, oea23, oeb03, oeb1003, oeb04, oeb1012,",
                 "oeb06, oeb05, oeb12,",
                 "oeb13, oeb14, oeb15,oeb910,oeb912,oeb913,oeb915,oeb916,oeb917,oea14, oea15  ",       
                 " FROM oea_file, OUTER occ_file, ",
                 " OUTER gen_file, OUTER gem_file, oeb_file ",
                 " WHERE oea_file.oea04 = occ_file.occ01 AND oea_file.oea14 = gen_file.gen01 ",  #No.FUN-750129
		 "   AND oea_file.oea15 = gem_file.gem01  AND oea01 = oeb01 ",          #No.FUN-750129
                 "   AND oea00 <>'0' ", 
                 "   AND oeaconf = 'Y' AND oeahold IS NULL AND ", tm.wc CLIPPED
     CASE tm.a
         WHEN '1'        #已交
            LET l_sql = l_sql CLIPPED," AND oeb24 > 0 "
         WHEN '2'        #未交 BugNo:4038 已結案訂單不可納入
             LET l_sql = l_sql CLIPPED," AND (oeb12-oeb24+oeb25-oeb26) > 0 AND oeb70 != 'Y'"  #MOD-570213 add
 
     END CASE
display 'l_sql:',l_sql
     PREPARE r244_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
     DECLARE r244_curs1 CURSOR FOR r244_prepare1
     #No.FUN-750129  --Begin
     #CALL cl_outnam('atmr244') RETURNING l_name
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
     #IF g_sma.sma116 MATCHES '[23]' THEN    
     #       LET g_zaa[45].zaa06 = "Y"
     #       LET g_zaa[46].zaa06 = "Y"
     #       LET g_zaa[59].zaa06 = "N"
     #       LET g_zaa[60].zaa06 = "N"
     #ELSE
     #       LET g_zaa[45].zaa06 = "N"
     #       LET g_zaa[46].zaa06 = "N"
     #       LET g_zaa[59].zaa06 = "Y"
     #       LET g_zaa[60].zaa06 = "Y"
     #END IF
     #IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[23]' THEN    
     #       LET g_zaa[58].zaa06 = "N"
     #ELSE
     #       LET g_zaa[58].zaa06 = "Y"
     #END IF
     # CALL cl_prt_pos_len()
     #START REPORT r244_rep TO l_name
     #LET g_pageno = 0
     IF g_sma116 MATCHES '[23]' THEN
        LET l_name = 'atmr244a'
     END IF
     IF g_sma116 NOT MATCHES '[23]' AND g_sma115 = 'Y' THEN
        LET l_name = 'atmr244b'
     END IF
     IF g_sma116 NOT MATCHES '[23]' AND g_sma115 = 'N' THEN
        LET l_name = 'atmr244c'
     END IF
     #No.FUN-750129  --End  
     FOREACH r244_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          #No.FUN-750129  --Begin
          #FOR g_i = 1 TO 3
          #    CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.oea03
          #                                  LET g_orderA[g_i]= g_x[19]
          #         WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.oea04
          #                                  LET g_orderA[g_i]= g_x[20]
          #         WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.oea01
          #                                  LET g_orderA[g_i]= g_x[17]
          #         WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.oea02 USING 'yyyymmdd'
          #                                  LET g_orderA[g_i]= g_x[18]
          #         WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.oea14
          #                                  LET g_orderA[g_i]= g_x[21]
          #         WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.oea15
          #                                  LET g_orderA[g_i]= g_x[22]
          #         WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.oea23
          #                                  LET g_orderA[g_i]= g_x[23]
          #         WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.oeb15 USING 'yyyymmdd'
          #                                  LET g_orderA[g_i]= g_x[24]
          #         OTHERWISE LET l_order[g_i]  = '-'
          #                   LET g_orderA[g_i] = ' '          #清為空白
          #    END CASE
          #END FOR
          #LET sr.order1 = l_order[1]
          #LET sr.order2 = l_order[2]
          #LET sr.order3 = l_order[3]
          #OUTPUT TO REPORT r244_rep(sr.*)
          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
            FROM azi_file
           WHERE azi01=sr.oea23
          SELECT occ02 INTO sr.occ02b 
            FROM occ_file
           WHERE occ01=sr.oea1004
          SELECT pmc02 INTO sr.pmc02 
            FROM pmc_file
           WHERE pmc01=sr.oea1015
          IF sr.oeb04[1,4] !='MISC' THEN
             SELECT ima021 INTO l_ima021 FROM ima_file
              WHERE ima01 = sr.oeb04
          ELSE
             LET l_ima021 = ''
          END IF
          SELECT ima906 INTO l_ima906 FROM ima_file
                             WHERE ima01=sr.oeb04
          LET l_str4 = ""
          IF g_sma115 = "Y" THEN
             CASE l_ima906
                WHEN "2"
                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                    LET l_str4 = l_oeb915 , sr.oeb913 CLIPPED
                    IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
                        CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                        LET l_str4 = l_oeb912, sr.oeb910 CLIPPED
                    ELSE
                       IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
                          CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
                          LET l_str4 = l_str4 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
                       END IF
                    END IF
                WHEN "3"
                    IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
                        CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
                        LET l_str4 = l_oeb915 , sr.oeb913 CLIPPED
                    END IF
             END CASE
          ELSE
          END IF
          IF g_sma.sma116 MATCHES '[23]' THEN   
                IF sr.oeb910 <> sr.oeb916 THEN
                   CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
                   LET l_str4 = l_str4 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
                END IF
          END IF
          INITIALIZE l_oga.* TO NULL
          INITIALIZE l_oma.* TO NULL
          LET l_azi03 = NULL
          LET l_azi04 = NULL
          SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
           WHERE oga01=ogb01 AND ogb31=sr.oea01
             AND ogb32=sr.oeb03 AND ogaconf='Y'
             AND oga09 not IN ('1','5','7','9')  
          IF l_cnt = 0 THEN
             EXECUTE insert_prep USING
                     sr.*,l_oga.*,l_oma.*,t_azi03,t_azi04,t_azi05,
                     l_ima021,l_azi03,l_azi04,l_str4
 
          ELSE
             DECLARE r244_c1 CURSOR FOR
                 SELECT oga01,oga02,ogb03,ogb12,ogb13,ogb14,oga23 FROM oga_file,ogb_file
                  WHERE oga01=ogb01 AND ogb31=sr.oea01
                    AND ogb32=sr.oeb03 AND ogaconf='Y'
                    AND oga09 not IN ('1','5','7','9')  
                    ORDER BY oga01,ogb03
             FOREACH r244_c1 INTO l_oga.*
                IF STATUS THEN
                   CALL cl_err('for oga:',STATUS,1)
                   EXIT FOREACH
                END IF
                SELECT azi03,azi04 INTO l_azi03,l_azi04 FROM azi_file
                 WHERE azi01=l_oga.oga23
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM oma_file,omb_file
                 WHERE oma01=omb01 AND omb31=l_oga.oga01
                   AND omb32=l_oga.ogb03 AND omaconf='Y'
                IF l_cnt=0 THEN
                   INITIALIZE l_oma.* TO NULL
                   EXECUTE insert_prep USING
                           sr.*,l_oga.*,l_oma.*,t_azi03,t_azi04,t_azi05,
                           l_ima021,l_azi03,l_azi04,l_str4
                ELSE
                   LET l_oma.oma01=''
                   LET l_oma.oma10=''
                   LET l_oma.omb03=''
                   DECLARE r244_c2 CURSOR FOR
                      SELECT oma01,oma10,omb03 FROM oma_file,omb_file
                       WHERE oma01=omb01 AND omb31=l_oga.oga01
                         AND omb32=l_oga.ogb03 AND omaconf='Y'
                         ORDER BY oma01,omb03
                   FOREACH r244_c2 INTO l_oma.oma01,l_oma.oma10,l_oma.omb03
                      IF SQLCA.sqlcode THEN
                         EXIT FOREACH
                      END IF
                      EXECUTE insert_prep USING
                              sr.*,l_oga.*,l_oma.*,t_azi03,t_azi04,t_azi05,
                              l_ima021,l_azi03,l_azi04,l_str4
                   END FOREACH
                END IF
             END FOREACH
          END IF
          #No.FUN-750129  --End  
     END FOREACH
 
     #No.FUN-750129  --Begin
     #FINISH REPORT r244_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'oea03,oea14,oea04,oea15,oea01,oea23,oea02,oeb15')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t,";",tm.u,";",tm.a
     CALL cl_prt_cs3('atmr244',l_name,g_sql,g_str)
     #No.FUN-750129  --End  
END FUNCTION
 
#No.FUN-750129  --Begin
#REPORT r244_rep(sr)
#DEFINE l_last_sw    LIKE type_file.chr1                 #No.FUN-680120 VARCHAR(1)
#DEFINE sr           RECORD order1 LIKE bnb_file.bnb06,  #No.FUN-680120 VARCHAR(20)
#                           order2 LIKE bnb_file.bnb06,  #No.FUN-680120 VARCHAR(20)
#                           order3 LIKE bnb_file.bnb06,  #No.FUN-680120 VARCHAR(20)
#                        oea00   LIKE oea_file.oea00,
#                        oea01   LIKE oea_file.oea01,
#                        oea02   LIKE oea_file.oea02,
#                        oea03   LIKE oea_file.oea03,
#                        oea032  LIKE oea_file.oea032,		#客戶簡稱
#                        oea04   LIKE oea_file.oea04,		#客戶編號
#                        occ02   LIKE occ_file.occ02,		#客戶簡稱
#                        oea1004 LIKE oea_file.oea1004,
#                        occ02b  LIKE occ_file.occ02,
#                        oea1015 LIKE oea_file.oea1015,
#                        pmc02   LIKE pmc_file.pmc02,
#                        gen02   LIKE gen_file.gen02,
#                        gem02   LIKE gem_file.gem02,
#                        oea23   LIKE oea_file.oea23,
#                        oeb03   LIKE oeb_file.oeb03,
#                        oeb1003 LIKE oeb_file.oeb1003,
#                        oeb04   LIKE oeb_file.oeb04,
#                        oeb1012 LIKE oeb_file.oeb1012,
#                        oeb06   LIKE oeb_file.oeb06,
#                        oeb05   LIKE oeb_file.oeb05,
#                        oeb12   LIKE oeb_file.oeb12,
#                        oeb13   LIKE oeb_file.oeb13,
#                        oeb14   LIKE oeb_file.oeb14,
#                        oeb15   LIKE oeb_file.oeb15,
#                        oeb910  LIKE oeb_file.oeb910,            
#                        oeb912  LIKE oeb_file.oeb912,           
#                        oeb913  LIKE oeb_file.oeb913,            
#                        oeb915  LIKE oeb_file.oeb915,            
#                        oeb916  LIKE oeb_file.oeb916,            
#                        oeb917  LIKE oeb_file.oeb917,            
#                        oea14   LIKE oea_file.oea14,              
#                        oea15   LIKE oea_file.oea15               
#                    END RECORD,
#		l_rowno  LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#		l_rowno1 LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#		l_cnt    LIKE type_file.num5,             #No.FUN-680120 SMALLINT
#		l_sum1   LIKE oeb_file.oeb14,
#		l_sum2   LIKE oeb_file.oeb14,
#		l_sum3   LIKE oeb_file.oeb14,
#		sum1     LIKE oeb_file.oeb14,
#		sum2     LIKE oeb_file.oeb14,
#		sum3     LIKE oeb_file.oeb14,
#		l_tot1   LIKE oeb_file.oeb12,
#		l_tot2   LIKE oeb_file.oeb12,
#      l_oga    RECORD
#                 oga01    LIKE oga_file.oga01,
#                 oga02    LIKE oga_file.oga02,
#                 ogb03    LIKE ogb_file.ogb03,
#                 ogb12    LIKE ogb_file.ogb12,
#                 ogb13    LIKE ogb_file.ogb13,  
#                 ogb14    LIKE ogb_file.ogb14,
#                 ogb23    LIKE oga_file.oga23  
#               END RECORD,
#      l_oma    RECORD
#                 oma01    LIKE oma_file.oma01,
#                 oma10    LIKE oma_file.oma10,
#                 omb03    LIKE omb_file.omb03
#               END RECORD,
#               l_str      LIKE ima_file.ima01,   #No.FUN-680120 VARCHAR(40)      
#               l_str1     LIKE ima_file.ima01,   #No.FUN-680120 VARCHAR(40)      
#               l_str2     LIKE ima_file.ima01,   #No.FUN-680120 VARCHAR(40)     
#               l_str3     LIKE ima_file.ima01,   #No.FUN-680120 VARCHAR(40)      
#               l_azi03    LIKE azi_file.azi03,  
#               l_azi04    LIKE azi_file.azi04,  
#               l_ima021   LIKE ima_file.ima021  
#   DEFINE  l_oeb915    STRING
#   DEFINE  l_oeb912    STRING
#   DEFINE  l_oeb12     STRING
#   DEFINE  l_str4      STRING
#   DEFINE  l_ima906    LIKE ima_file.ima906
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.oea01
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#
#      LET l_str3= ''
#      CASE tm.a
#           WHEN '1' LET l_str3=g_x[14] CLIPPED;
#           WHEN '2' LET l_str3=g_x[15] CLIPPED;
#           WHEN '3' LET l_str3=g_x[16] CLIPPED;
#      END CASE
#      LET g_head1 = g_x[13] CLIPPED,
#                    g_orderA[1] CLIPPED,'-',
#                    g_orderA[2] CLIPPED,'-',
#                    g_orderA[3] CLIPPED
#      PRINT g_head1 CLIPPED,
#            COLUMN g_c[35],l_str3 CLIPPED
#
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[61],
#            g_x[62],
#            g_x[37],
#            g_x[38],
#            g_x[39],
#            g_x[40],
#            g_x[41],
#            g_x[63],
#            g_x[42],
#            g_x[64],
#            g_x[43],
#            g_x[44],
#            g_x[45],
#            g_x[46],
#            g_x[47],
#            g_x[48],
#            g_x[49],
#            g_x[50],
#            g_x[51],
#            g_x[52],
#            g_x[53],
#            g_x[54],
#            g_x[66],
#            g_x[55],
#            g_x[56],
#            g_x[57],
#            g_x[58],           
#            g_x[59],          
#            g_x[60]           
#      PRINT g_dash1
#
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y'
#         THEN SKIP TO TOP OF PAGE
#      END IF
#   BEFORE GROUP OF sr.oea01
#      LET l_rowno = 1
##     SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05   #NO.CHI-6A0004
#      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05   #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.oea23
#      SELECT occ02 INTO sr.occ02b 
#        FROM occ_file
#       WHERE occ01=sr.oea1004
#      SELECT pmc02 INTO sr.pmc02 
#        FROM pmc_file
#       WHERE pmc01=sr.oea1015
#
#      PRINT COLUMN g_c[31],sr.oea01 CLIPPED,
#            COLUMN g_c[32],sr.oea02,
#            COLUMN g_c[33],sr.oea03 CLIPPED,
#            COLUMN g_c[34],sr.oea032 CLIPPED,
#            COLUMN g_c[35],sr.oea04,
#            COLUMN g_c[36],sr.occ02;
#      IF sr.oea00 = '7' THEN
#         PRINT COLUMN g_c[61],sr.oea1015 CLIPPED,
#               COLUMN g_c[62],sr.pmc02;
#      END IF
#      IF sr.oea00 = '6' THEN
#         PRINT COLUMN g_c[61],sr.oea1004 CLIPPED,
#               COLUMN g_c[62],sr.occ02b;
#      END IF
#      PRINT COLUMN g_c[37],sr.oea14,
#            COLUMN g_c[38],sr.gen02,
#            COLUMN g_c[39],sr.oea15,
#            COLUMN g_c[40],sr.gem02[1,10];
#
#   ON EVERY ROW
#      IF sr.oeb04[1,4] !='MISC' THEN
#         SELECT ima021 INTO l_ima021 FROM ima_file
#          WHERE ima01 = sr.oeb04
#      ELSE
#         LET l_ima021 = ''
#      END IF
#
#
#      SELECT ima906 INTO l_ima906 FROM ima_file
#                         WHERE ima01=sr.oeb04
#      LET l_str4 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                LET l_str4 = l_oeb915 , sr.oeb913 CLIPPED
#                IF cl_null(sr.oeb915) OR sr.oeb915 = 0 THEN
#                    CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                    LET l_str4 = l_oeb912, sr.oeb910 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.oeb912) AND sr.oeb912 > 0 THEN
#                      CALL cl_remove_zero(sr.oeb912) RETURNING l_oeb912
#                      LET l_str4 = l_str4 CLIPPED,',',l_oeb912, sr.oeb910 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.oeb915) AND sr.oeb915 > 0 THEN
#                    CALL cl_remove_zero(sr.oeb915) RETURNING l_oeb915
#                    LET l_str4 = l_oeb915 , sr.oeb913 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      IF g_sma.sma116 MATCHES '[23]' THEN   
#            IF sr.oeb910 <> sr.oeb916 THEN
#               CALL cl_remove_zero(sr.oeb12) RETURNING l_oeb12
#               LET l_str4 = l_str4 CLIPPED,"(",l_oeb12,sr.oeb05 CLIPPED,")"
#            END IF
#      END IF
##FUN-580004--end
#      PRINT COLUMN g_c[41],sr.oeb03 USING '####',
#            COLUMN g_c[63],sr.oeb1003,
#            COLUMN g_c[42],sr.oeb04 clipped,  
#            COLUMN g_c[64],sr.oeb1012,
#            COLUMN g_c[58],l_str4 CLIPPED,  
#            COLUMN g_c[43],sr.oeb06,
#            COLUMN g_c[44],l_ima021,
#            COLUMN g_c[59],sr.oeb916 ,                              
#            COLUMN g_c[60],sr.oeb917 USING '###########&.##',      
#            COLUMN g_c[45],sr.oeb05,
#            COLUMN g_c[46],sr.oeb12 USING '###########.###',
##           COLUMN g_c[47],cl_numfor(sr.oeb13,47,g_azi03),  #NO.CHI-6A0004
#            COLUMN g_c[47],cl_numfor(sr.oeb13,47,t_azi03),  #NO.CHI-6A0004
##           COLUMN g_c[48],cl_numfor(sr.oeb14,48,g_azi04),  #NO.CHI-6A0004
#            COLUMN g_c[48],cl_numfor(sr.oeb14,48,t_azi04),  #NO.CHI-6A0004
#            COLUMN g_c[49],sr.oeb15;
# 
#      SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
#       WHERE oga01=ogb01 AND ogb31=sr.oea01
#         AND ogb32=sr.oeb03 AND ogaconf='Y'
#         AND oga09 not IN ('1','5','7','9')  
#      IF l_cnt = 0 THEN
#         PRINT ' '
#      ELSE
#         DECLARE r244_c1 CURSOR FOR
#             SELECT oga01,oga02,ogb03,ogb12,ogb13,ogb14,oga23 FROM oga_file,ogb_file
#              WHERE oga01=ogb01 AND ogb31=sr.oea01
#                AND ogb32=sr.oeb03 AND ogaconf='Y'
#                AND oga09 not IN ('1','5','7','9')  
#                ORDER BY oga01,ogb03
#         FOREACH r244_c1 INTO l_oga.*
#            IF STATUS THEN
#               CALL cl_err('for oga:',STATUS,1)
#               PRINT ' '
#               EXIT FOREACH
#            END IF
#            SELECT azi03,azi04 INTO l_azi03,l_azi04 FROM azi_file
#             WHERE azi01=l_oga.oga23
#            PRINT  COLUMN g_c[50],l_oga.oga01,
#                   COLUMN g_c[51],l_oga.ogb03 USING '####',
#                   COLUMN g_c[52],l_oga.oga02,
#                   COLUMN g_c[53],l_oga.ogb12 USING '###########.###',
#                   COLUMN g_c[54],cl_numfor(l_oga.ogb13,54,l_azi03),
#                   COLUMN g_c[66],cl_numfor(l_oga.ogb14,66,l_azi04);
#            LET l_cnt = 0
#            SELECT COUNT(*) INTO l_cnt FROM oma_file,omb_file
#             WHERE oma01=omb01 AND omb31=l_oga.oga01
#               AND omb32=l_oga.ogb03 AND omaconf='Y'
#            IF l_cnt=0 THEN
#               PRINT ' '
#            ELSE
#               LET l_oma.oma01=''
#               LET l_oma.oma10=''
#               LET l_oma.omb03=''
#               DECLARE r244_c2 CURSOR FOR
#                  SELECT oma01,oma10,omb03 FROM oma_file,omb_file
#                   WHERE oma01=omb01 AND omb31=l_oga.oga01
#                     AND omb32=l_oga.ogb03 AND omaconf='Y'
#                     ORDER BY oma01,omb03
#               FOREACH r244_c2 INTO l_oma.oma01,l_oma.oma10,l_oma.omb03
#                  IF SQLCA.sqlcode THEN
#                     PRINT ''
#                     EXIT FOREACH
#                  END IF
#                  PRINT  COLUMN g_c[55],l_oma.oma01,
#                         COLUMN g_c[56],l_oma.omb03 USING '####',
#                         COLUMN g_c[57],l_oma.oma10
#               END FOREACH
#            END IF
#         END FOREACH
#      END IF
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN
#         LET l_tot1 = GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' and sr.oeb1012!='Y'
#         LET l_sum1 = GROUP SUM(sr.oeb14) WHERE sr.oeb1003='1' 
#         LET l_tot2 = GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' and sr.oeb1012 ='Y'
#         LET l_sum3 = GROUP SUM(sr.oeb14) WHERE sr.oeb1003='2' 
#         PRINT ''
#         PRINT COLUMN g_c[52],g_orderA[1] CLIPPED,
#	       COLUMN g_c[53],g_x[67] CLIPPED,
#               COLUMN g_c[54],l_tot1 USING '###########.###',
##              COLUMN g_c[66],cl_numfor(l_sum1,66,g_azi05)   #NO.CHI-6A0004
#               COLUMN g_c[66],cl_numfor(l_sum1,66,t_azi05)   #NO.CHI-6A0004
#	 PRINT COLUMN g_c[53],g_x[68] CLIPPED,
#               COLUMN g_c[54],l_tot2 USING '###########.###'
#	 PRINT COLUMN g_c[53],g_x[70] CLIPPED,
##              COLUMN g_c[66],cl_numfor(l_sum3,66,g_azi05)   #NO.CHI-6A0004
#               COLUMN g_c[66],cl_numfor(l_sum3,66,t_azi05)   #NO.CHI-6A0004
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#         LET l_tot1 = GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' and sr.oeb1012!='Y'
#         LET l_sum1 = GROUP SUM(sr.oeb14) WHERE sr.oeb1003='1' 
#         LET l_tot2 = GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' and sr.oeb1012 ='Y'
#         LET l_sum3 = GROUP SUM(sr.oeb14) WHERE sr.oeb1003='2' 
#         PRINT ''
#         PRINT COLUMN g_c[52],g_orderA[2] CLIPPED,
#	       COLUMN g_c[53],g_x[67] CLIPPED,
#               COLUMN g_c[54],l_tot1 USING '###########.###',
##              COLUMN g_c[66],cl_numfor(l_sum1,66,g_azi05)   #NO.CHI-6A0004
#               COLUMN g_c[66],cl_numfor(l_sum1,66,t_azi05)   #NO.CHI-6A0004
#	 PRINT COLUMN g_c[53],g_x[68] CLIPPED,
#               COLUMN g_c[54],l_tot2 USING '###########.###'
#	 PRINT COLUMN g_c[53],g_x[70] CLIPPED,
##              COLUMN g_c[66],cl_numfor(l_sum3,66,g_azi05)   #NO.CHI-6A0004
#               COLUMN g_c[66],cl_numfor(l_sum3,66,t_azi05)   #NO.CHI-6A0004
#         PRINT ''
#      END IF
#
#   AFTER GROUP OF sr.order3
#      IF tm.u[3,3] = 'Y' THEN
#         LET l_tot1 = GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' and sr.oeb1012!='Y'
#         LET l_sum1 = GROUP SUM(sr.oeb14) WHERE sr.oeb1003='1' 
#         LET l_tot2 = GROUP SUM(sr.oeb12) WHERE sr.oeb1003='1' and sr.oeb1012 ='Y'
#         LET l_sum3 = GROUP SUM(sr.oeb14) WHERE sr.oeb1003='2' 
#         PRINT ''
#         PRINT COLUMN g_c[52],g_orderA[3] CLIPPED,
#	       COLUMN g_c[53],g_x[67] CLIPPED,
#               COLUMN g_c[54],l_tot1 USING '###########.###',
##              COLUMN g_c[66],cl_numfor(l_sum1,66,g_azi05)     #NO.CHI-6A0004
#               COLUMN g_c[66],cl_numfor(l_sum1,66,t_azi05)     #NO.CHI-6A0004
#	 PRINT COLUMN g_c[53],g_x[68] CLIPPED,
#               COLUMN g_c[54],l_tot2 USING '###########.###'
#	 PRINT COLUMN g_c[53],g_x[70] CLIPPED,
##              COLUMN g_c[66],cl_numfor(l_sum3,66,g_azi05)     #NO.CHI-6A0004
#               COLUMN g_c[66],cl_numfor(l_sum3,66,t_azi05)     #NO.CHI-6A0004
#         PRINT ''
#      END IF
#
#   ON LAST ROW
#      PRINT ''
#      LET sum1 = SUM(sr.oeb14) WHERE sr.oeb1003='1'
#      LET sum3 = SUM(sr.oeb14) WHERE sr.oeb1003='2'
#      PRINT COLUMN g_c[52],g_x[12] CLIPPED,
#            COLUMN g_c[53],g_x[71] CLIPPED,
##           COLUMN g_c[66],cl_numfor(sum1,66,g_azi05)   #NO.CHI-6A0004
#            COLUMN g_c[66],cl_numfor(sum1,66,t_azi05)   #NO.CHI-6A0004
#      PRINT COLUMN g_c[53],g_x[73] CLIPPED,
##           COLUMN g_c[66],cl_numfor(sum3,66,g_azi05)   #NO.CHI-6A0004
#            COLUMN g_c[66],cl_numfor(sum3,66,t_azi05)   #NO.CHI-6A0004
#      IF g_zz05 = 'Y' THEN     
#         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea04,oea05')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#         CALL cl_prt_pos_wc(tm.wc)
#
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#     PRINT  g_x[5],COLUMN (g_len-9), g_x[7] CLIPPED     #No.TQC-710043
#
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[5],COLUMN (g_len-9), g_x[6] CLIPPED  #No.TQC-710043
#      ELSE
#         SKIP 2 LINE
#      END IF
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[4]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[4]
#             PRINT g_memo
#      END IF
#
#END REPORT
#No.FUN-750129  --End
