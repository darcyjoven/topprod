# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmr512.4gl
# Descriptions...: 料件採購單價明細表列印作業
# Date & Author..: 93/05/18  By  Felicity  Tseng
# Modify.........: No.FUN-4C0095 04/12/23 By Mandy 報表轉XML
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.FUN-580004 05/08/04 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-5B0105 05/12/16 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-5B0212 05/11/30 By kevin 項次沒對齊
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6B0137 06/11/27 By jamie 當使用計價單位,但不使用多單位時,單位一是NULL,導致單位註解內容為空
# Modify.........: No.FUN-7C0034 07/12/25 By sherry 報表改由CR輸出 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17    #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5    #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
 
   DEFINE tm  RECORD
             #wc      VARCHAR(500),   #TQC-630166
              wc      STRING,      #TQC-630166 mark
              s       LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3)
              t       LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3) 
              u       LIKE type_file.chr3,     #No.FUN-680136 VARCHAR(3) 
              more    LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1) 
              END RECORD,
          g_orderA    ARRAY[3] OF LIKE aaf_file.aaf03    #No.FUN-680136 VARCHAR(40) 
 
   DEFINE g_i         LIKE type_file.num5      #count/index for any purpose  #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580004 --end--
 
#No.FUN-7C0034---Begin                                                       
DEFINE g_sql     STRING                                                      
DEFINE g_str     STRING                                                      
DEFINE l_table   STRING                                                      
#No.FUN-7C0034---End  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
   #No.FUN-7C0034---Begin
   LET g_sql = "pmn04.pmn_file.pmn04,",
               "pmn041.pmn_file.pmn041,",
               "ima021.ima_file.ima021,",
               "pmm09.pmm_file.pmm09,",
               "pmc03.pmc_file.pmc03,",
               "pmm01.pmm_file.pmm01,",
               "pmn02.pmn_file.pmn02,",
               "pmm04.pmm_file.pmm04,",
               "pmm22.pmm_file.pmm22,",
               "pmm25.pmm_file.pmm25,",
               "pmn31.pmn_file.pmn31,",
               "l_str2.type_file.chr1000,",
               "pmn07.pmn_file.pmn07,",
               "pmn20.pmn_file.pmn20,",
               "pmn86.pmn_file.pmn86,",
               "pmn87.pmn_file.pmn87,", 
               "azi03.azi_file.azi03 "
   LET l_table = cl_prt_temptable('apmr512',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                
   #No.FUN-7C0034---End
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r512_tm(0,0)
      ELSE CALL r512()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r512_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000) 
 
   LET p_row = 4 LET p_col = 12
 
   OPEN WINDOW r512_w AT p_row,p_col WITH FORM "apm/42f/apmr512"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON pmn04, pmm09, pmm01, pmm04, pmm22
#No.FUN-570243 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
            IF INFIELD(pmn04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmn04
               NEXT FIELD pmn04
            END IF
#No.FUN-570243 --end--
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r520_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
 
   INPUT BY NAME
                 #UI
                 tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
                 tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r512_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='apmr512'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr512','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr512',g_time,l_cmd)
      END IF
      CLOSE WINDOW r512_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r512()
   ERROR ""
END WHILE
   CLOSE WINDOW r512_w
END FUNCTION
 
FUNCTION r512()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name            #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,          # Used time for running the job       #No.FUN-680136 VARCHAR(8)
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166 mark  #No.FUN-680136 VARCHAR(1000) 
          l_sql     STRING,                       # RDSQL STATEMENT   #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE aaf_file.aaf03,              #No.FUN-680136 VARCHAR(40) 
          i         LIKE type_file.num5,     #No.FUN-580004       #No.FUN-680136 SMALLINT
          sr               RECORD order1 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40) 
                                  order2 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40) 
                                  order3 LIKE aaf_file.aaf03,     #No.FUN-680136 VARCHAR(40) 
                                  pmm01 LIKE pmm_file.pmm01,  #採購單號
                                  pmm04 LIKE pmm_file.pmm04,  #採購日期
                                  pmm09 LIKE pmm_file.pmm09,  #廠商編號
                                  pmm22 LIKE pmm_file.pmm22,  #幣別
                                  pmm25 LIKE pmm_file.pmm25,  #狀況碼
                                  pmn02 LIKE pmn_file.pmn02,  #採購單項次
                                  pmn04 LIKE pmn_file.pmn04,  #料號
                                  pmn041 LIKE pmn_file.pmn041,#品名
                                  pmn31 LIKE pmn_file.pmn31,  #採購單價
                                  pmn07 LIKE pmn_file.pmn07,  #採購單位
                                  pmn20 LIKE pmn_file.pmn20,  #採購數量
                                  pmc03 LIKE pmc_file.pmc03,  #廠商簡稱
                                  azi03 LIKE azi_file.azi03,  #幣別
#No.FUN-580004 --start--
                                  pmn80 LIKE pmn_file.pmn80,
                                  pmn82 LIKE pmn_file.pmn82,
                                  pmn83 LIKE pmn_file.pmn83,
                                  pmn85 LIKE pmn_file.pmn85,
                                  pmn86 LIKE pmn_file.pmn86,
                                  pmn87 LIKE pmn_file.pmn87
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5          #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
#No.FUN-7C0034---Begin
  DEFINE l_ima906       LIKE ima_file.ima906                                    
  DEFINE l_str2         LIKE type_file.chr1000                             
  DEFINE l_pmn85        STRING                                                  
  DEFINE l_pmn82        STRING                                                  
  DEFINE l_pmn20        STRING  
  DEFINE l_ima021       LIKE ima_file.ima021
#No.FUN-7C0034---End
#No.FUN-580004 --end--
     CALL cl_del_data(l_table)         #No.FUN-7C0034
 
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-7C0034
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 " pmm01, pmm04, pmm09, pmm22, pmm25, ",
                 " pmn02, pmn04, pmn041, pmn31, pmn07, pmn20, pmc03,azi03, ",
                 " pmn80, pmn82, pmn83,  pmn85, pmn86, pmn87 ",  #No.FUN-580004
                 " FROM pmm_file, pmn_file,",
                 " OUTER pmc_file, OUTER azi_file",
                 " WHERE pmn01 = pmm01 ",
                 " AND pmc_file.pmc01 = pmm_file.pmm09 ",
                 " AND azi_file.azi01 = pmm_file.pmm22 ",
                 " AND pmm18 <> 'X' AND ", tm.wc CLIPPED
#    LET l_sql = l_sql CLIPPED," ORDER BY pmm01"
     PREPARE r512_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
     END IF
     DECLARE r512_curs1 CURSOR FOR r512_prepare1
     #No.FUN-7C0034---Begin
     #CALL cl_outnam('apmr512') RETURNING l_name        
 
##No.FUN-580004  --start
     #IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
     #       LET g_zaa[42].zaa06 = "Y"
     #       LET g_zaa[43].zaa06 = "Y"
     #       LET g_zaa[45].zaa06 = "N"
     #       LET g_zaa[46].zaa06 = "N"
     #ELSE
     #       LET g_zaa[46].zaa06 = "Y"
     #       LET g_zaa[45].zaa06 = "Y"
     #       LET g_zaa[43].zaa06 = "N"
     #       LET g_zaa[42].zaa06 = "N"
     #END IF
     IF g_sma115 = "Y" OR g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
     #       LET g_zaa[44].zaa06 = "N"
             LET l_name = 'apmr512'
     ELSE
     #       LET g_zaa[44].zaa06 = "Y"
             LET l_name = 'apmr512_1'
     END IF
     #CALL cl_prt_pos_len()
##No.FUN-580004 --end
     #START REPORT r512_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-7C0034---End
     FOREACH r512_curs1 INTO sr.*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          #No.FUN-7C0034---Begin
          #FOR g_i = 1 TO 3
          #    CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pmn04
          #                                  LET g_orderA[g_i]= g_x[11]
          #         WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pmm09
          #                                  LET g_orderA[g_i]= g_x[13]
          #         WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pmm01
          #                                  LET g_orderA[g_i]= g_x[22]
          #         WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.pmm04 USING 'YYYYMMDD'
          #                                  LET g_orderA[g_i]= g_x[16]
          #         WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.pmm22
          #                                  LET g_orderA[g_i]= g_x[17]
          #         OTHERWISE LET l_order[g_i]  = '-'
          #                   LET g_orderA[g_i] = ' '          #清為空白
          #    END CASE
          #END FOR
          #LET sr.order1 = l_order[1]
          #LET sr.order2 = l_order[2]
          #LET sr.order3 = l_order[3]
          SELECT ima021 INTO l_ima021                                               
            FROM ima_file                                                           
           WHERE ima01 = sr.pmn04                                                   
                                                                                
          SELECT ima906 INTO l_ima906 FROM ima_file                                 
                       WHERE ima01=sr.pmn04                                   
          LET l_str2 = ""                                                           
          IF g_sma115 = "Y" THEN                                                    
             CASE l_ima906                                                          
               WHEN "2"                                                            
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85                 
                LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED                         
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN                       
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82             
                    LET l_str2 = l_pmn82, sr.pmn80 CLIPPED                      
                ELSE                                                            
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN               
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82           
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED 
                   END IF                                                       
                END IF
               WHEN "3"                                                            
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN                  
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85             
                    LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED                     
                END IF                                                          
             END CASE                                                               
          ELSE                                                                      
          END IF                                                                    
          IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076                     
              #IF sr.pmn80 <> sr.pmn86 THEN     #NO.TQC-6B0137  mark               
               IF sr.pmn07 <> sr.pmn86 THEN     #NO.TQC-6B0137  mod                
                  CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20                  
                  LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"     
               END IF                                                              
          END IF 
          EXECUTE insert_prep USING sr.pmn04,sr.pmn041,l_ima021,sr.pmm09,
                                    sr.pmc03,sr.pmm01,sr.pmn02,sr.pmm04,
                                    sr.pmm22,sr.pmm25,sr.pmn31,l_str2,sr.pmn07,
                                    sr.pmn20,sr.pmn86,sr.pmn87,sr.azi03
              
          #OUTPUT TO REPORT r512_rep(sr.*)
          #No.FUN-7C0034---End
     END FOREACH
 
     #No.FUN-7C0034---Begin
     #FINISH REPORT r512_rep
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'pmn04,pmm09,pmm01,pmm04,pmm22')                                   
        RETURNING g_str                                                         
     END IF              
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.u[1,1],";",
                 tm.u[2,2],";",tm.u[3,3],";",g_sma115,";",g_sma.sma116                                                         
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED 
     CALL cl_prt_cs3('apmr512',l_name,l_sql,g_str)
     #No.FUN-7C0034---End
END FUNCTION
 
#
REPORT r512_rep(sr)
  #DEFINE l_str        VARCHAR(50)   #列印排列順序說明 #FUN-4C0095   #TQC-630166 mark
   DEFINE l_str        STRING     #列印排列順序說明 #FUN-4C0095   #TQC-630166
   DEFINE l_ima021     LIKE ima_file.ima021     #FUN-4C0095
   DEFINE l_sum1_pmn20 LIKE pmn_file.pmn20      #FUN-4C0095
   DEFINE l_sum2_pmn20 LIKE pmn_file.pmn20      #FUN-4C0095
   DEFINE l_sum3_pmn20 LIKE pmn_file.pmn20      #FUN-4C0095
   DEFINE l_last_sw    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
          sr               RECORD order1 LIKE aaf_file.aaf03, #No.FUN-680136 VARCHAR(40)
                                  order2 LIKE aaf_file.aaf03, #No.FUN-680136 VARCHAR(40)
                                  order3 LIKE aaf_file.aaf03, #No.FUN-680136 VARCHAR(40)
                                  pmm01 LIKE pmm_file.pmm01,  #採購單號
                                  pmm04 LIKE pmm_file.pmm04,  #採購日期
                                  pmm09 LIKE pmm_file.pmm09,  #廠商編號
                                  pmm22 LIKE pmm_file.pmm22,  #幣別
                                  pmm25 LIKE pmm_file.pmm25,  #狀況碼
                                  pmn02 LIKE pmn_file.pmn02,  #採購單項次
                                  pmn04 LIKE pmn_file.pmn04,  #料號
                                  pmn041 LIKE pmn_file.pmn041,#品名
                                  pmn31 LIKE pmn_file.pmn31,  #採購單價
                                  pmn07 LIKE pmn_file.pmn07,  #採購單位
                                  pmn20 LIKE pmn_file.pmn20,  #採購數量
                                  pmc03 LIKE pmc_file.pmc03,  #廠商簡稱
                                  azi03 LIKE azi_file.azi03,  #幣別
#No.FUN-580004 --start--
                                  pmn80     LIKE    pmn_file.pmn80,
                                  pmn82     LIKE    pmn_file.pmn82,
                                  pmn83     LIKE    pmn_file.pmn83,
                                  pmn85     LIKE    pmn_file.pmn85,
                                  pmn86     LIKE    pmn_file.pmn86,
                                  pmn87     LIKE    pmn_file.pmn87
                        END RECORD
  DEFINE l_ima906       LIKE ima_file.ima906
 #DEFINE l_str2         VARCHAR(100)   #TQC-630166 mark
  DEFINE l_str2         STRING      #TQC-630166
  DEFINE l_pmn85        STRING
  DEFINE l_pmn82        STRING
  DEFINE l_pmn20        STRING
#No.FUN-580004 --end--
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
      #FUN-4C0095----
      LET l_str=g_x[26] CLIPPED,g_orderA[1] CLIPPED,'-',
                                g_orderA[2] CLIPPED,'-',
                                g_orderA[3] CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT l_str
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40], #FUN-4C0095 印表頭
            g_x[41],g_x[44],g_x[42],g_x[43],g_x[45],g_x[46]  #No.FUN-580004
      PRINT g_dash1
      #FUN-4C0095(end)
      LET l_last_sw = 'n'
 
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
         THEN SKIP TO TOP OF PAGE
      END IF
   #FUN-4C0095----
   ON EVERY ROW
      SELECT ima021 INTO l_ima021
        FROM ima_file
       WHERE ima01 = sr.pmn04
 
#No.FUN-580004 --start--
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pmn04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                IF cl_null(sr.pmn85) OR sr.pmn85 = 0 THEN
                    CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                    LET l_str2 = l_pmn82, sr.pmn80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pmn82) AND sr.pmn82 > 0 THEN
                      CALL cl_remove_zero(sr.pmn82) RETURNING l_pmn82
                      LET l_str2 = l_str2 CLIPPED,',',l_pmn82, sr.pmn80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pmn85) AND sr.pmn85 > 0 THEN
                    CALL cl_remove_zero(sr.pmn85) RETURNING l_pmn85
                    LET l_str2 = l_pmn85 , sr.pmn83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
           #IF sr.pmn80 <> sr.pmn86 THEN     #NO.TQC-6B0137  mark
            IF sr.pmn07 <> sr.pmn86 THEN     #NO.TQC-6B0137  mod
               CALL cl_remove_zero(sr.pmn20) RETURNING l_pmn20
               LET l_str2 = l_str2 CLIPPED,"(",l_pmn20,sr.pmn07 CLIPPED,")"
            END IF
      END IF
      PRINT COLUMN g_c[31], sr.pmn04 CLIPPED, #FUN-5B0014 [1,20],    #No.FUN-580004
            COLUMN g_c[32], sr.pmn041,
            COLUMN g_c[33], l_ima021,
            COLUMN g_c[34], sr.pmm09,
            COLUMN g_c[35], sr.pmc03,
            COLUMN g_c[36], sr.pmm01,
            COLUMN g_c[37], sr.pmn02 USING '####',#No.TQC-5B0212
            COLUMN g_c[38], sr.pmm04,
            COLUMN g_c[39], sr.pmm22,
            COLUMN g_c[40], sr.pmm25,
            COLUMN g_c[41], cl_numfor(sr.pmn31,41,sr.azi03) CLIPPED,
            COLUMN g_c[44], l_str2 CLIPPED, #No.FUN-580004
            COLUMN g_c[42], sr.pmn07,
            COLUMN g_c[43], cl_numfor(sr.pmn20,43,2),
            COLUMN g_c[45], sr.pmn86,
            COLUMN g_c[46], cl_numfor(sr.pmn87,46,2)
#No.FUN-580004 --end--
   #FUN-4C0095(end)
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_sum1_pmn20 = GROUP SUM(sr.pmn20) #FUN-4C0095
         PRINT COLUMN 108, g_orderA[1] CLIPPED,g_x[25] CLIPPED,
               COLUMN g_c[43],cl_numfor(l_sum1_pmn20,41,2) #FUN-4C0095
         PRINT ''
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_sum2_pmn20 = GROUP SUM(sr.pmn20) #FUN-4C0095
         PRINT COLUMN 108, g_orderA[2] CLIPPED,g_x[24] CLIPPED,
               COLUMN g_c[43],cl_numfor(l_sum2_pmn20,43,2) #FUN-4C0095
         PRINT ''
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.u[3,3] = 'Y' THEN
         LET l_sum3_pmn20 = GROUP SUM(sr.pmn20) #FUN-4C0095
         PRINT COLUMN 108, g_orderA[3] CLIPPED,g_x[23] CLIPPED,
               COLUMN g_c[43],cl_numfor(l_sum3_pmn20,41,2) #FUN-4C0095
         PRINT ''
      END IF
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'apa01,apa02,apa03,apa04,apa05')
              RETURNING tm.wc
         PRINT g_dash
        #TQC-630166
        #     IF tm.wc[001,070] > ' ' THEN            # for 80
        #PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
        #     IF tm.wc[071,140] > ' ' THEN
        #PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
        #     IF tm.wc[141,210] > ' ' THEN
        #PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
        #     IF tm.wc[211,280] > ' ' THEN
        #PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
        CALL cl_prt_pos_wc(tm.wc)
        PRINT g_dash
        #END TQC-630166
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[510,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[510,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
      END IF
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #FUN-4C0095
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash #FUN-4C0095
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #FUN-4C0095
         ELSE SKIP 2 LINE
      END IF
END REPORT
