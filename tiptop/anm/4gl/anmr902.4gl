# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: anmr902.4gl
# Descriptions...: 銀行對帳明細表
# Date & Author..: 970124 by lydia
# Modify.........: No.FUN-4C0098 05/03/03 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.TQC-5B0043 05/11/08 By Smapmin 調整報表
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.TQC-770065 07/07/11 By wujie   打印某對賬年月的所有未入賬明細的資料，每增加一頁則表名稱后會增加一個年月的顯示，即如有四頁，第四頁表名后有四個相同的年月顯示。
# Modify.........: No.FUN-830154 08/04/14 By destiny 報表改為CR輸出
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.TQC-960162 09/06/15 By sabrina 資料庫無nmq03、nmq04這個欄位
# Modify.........: No.TQC-960453 09/07/01 By destiny 把select npc_file.* 改為npc01,npc02...的型式 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(600)
              yy      LIKE type_file.num5,   #No.FUN-680107 SMALLINT
              mm      LIKE type_file.num5,   #No.FUN-680107 SMALLINT
              p       LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01) #1:已入帳 2:未入帳
              more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(01)
              END RECORD,
          g_dash_1    LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(120)	
          g_bdate     LIKE type_file.dat,    #No.FUN-680107 DATE
          g_edate     LIKE type_file.dat,    #No.FUN-680107 DATE
          l_yy,l_mm   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose        #No.FUN-680107 SMALLINT
#No.FUN-830154--begin--
   DEFINE g_sql       STRING                                                                                                        
   DEFINE l_table     STRING                                                                                                        
   DEFINE g_str       STRING
#No.FUN-830154--end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
#No.FUN-830154--begin--
   LET g_sql= "group1.type_file.chr1,",
              "npc02.npc_file.npc02,",
              "npc03.npc_file.npc03,",       
              "npc06.npc_file.npc06,",
              "nme13.nme_file.nme13,",
              "npc04.npc_file.npc04,",
              "npc05.npc_file.npc05,",
              "npc07.npc_file.npc07,",
              "npc08.npc_file.npc08,",
              "nme09.nme_file.nme09,",
              "npc01.npc_file.npc01,",
              "nma02.nma_file.nma02,",
              "l_amt.type_file.num10,",
              "l_amt2.type_file.num10,",
              "this_amt.type_file.num10,",
              "bef_amt.type_file.num10,",   
              "nmp19.nmp_file.nmp19"     
   LET l_table = cl_prt_temptable('anmr902',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                     
               "        ?,?,?,?,?, ?,?)"                                                                                     
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
#No.FUN-830154--end--
 
   LET g_pdate = ARG_VAL(1)            # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)   #TQC-610058
   LET tm.mm = ARG_VAL(9)   #TQC-610058
   LET tm.p = ARG_VAL(10)   #TQC-610058
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r902_tm(0,0)
      ELSE CALL r902()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r902_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,        #No.FUN-680107 SMALLINT
          l_cmd       LIKE type_file.chr1000      #No.FUN-680107 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW r902_w AT p_row,p_col
        WITH FORM "anm/42f/anmr902"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)-1
   LET tm.p = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON npc01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r902_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.yy,tm.mm,tm.p,tm.more
                 WITHOUT DEFAULTS
      BEFORE INPUT
         DISPLAY BY NAME tm.p
         #No.FUN-580031 --start--
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
   AFTER INPUT
      CALL s_azn01(tm.yy,tm.mm) RETURNING g_bdate,g_edate
      CALL s_lsperiod(tm.yy,tm.mm) RETURNING l_yy,l_mm
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
      LET INT_FLAG = 0 CLOSE WINDOW r902_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr902'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr902','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",   #TQC-610058
                         " '",tm.mm CLIPPED,"'",   #TQC-610058
                         " '",tm.p CLIPPED,"'",   #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('anmr902',g_time,l_cmd)
      END IF
      CLOSE WINDOW r902_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r902()
   ERROR ""
END WHILE
   CLOSE WINDOW r902_w
END FUNCTION
 
FUNCTION r902()
   DEFINE l_name    LIKE type_file.chr20,           # External(Disk) file name        #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,         # RDSQL STATEMENT        #No.FUN-680107 VARCHAR(2000)
          bal1,bal2,bal3,bal4,l_d1,l_d2,l_c1,l_c2    LIKE tlf_file.tlf18, #No.FUN-680107 DEC(13,3)
          g_yy,g_mm LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_wc      LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(300)
          c_date    LIKE type_file.dat,    #No.FUN-680107 VARCHAR(6)
          l_chr     LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(40)
          sr               RECORD
                 group     LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1) #'1' 當月 2 非當月
                 npc01     LIKE npc_file.npc01,   #No.FUN-680107 VARCHAR(6) #銀行編號
                 npc02     LIKE npc_file.npc02,   #No.FUN-680107 DATE    #異動日期
                 npc021    LIKE type_file.dat,    #No.FUN-680107 VARCHAR(5) #異動時間
                 npc03     LIKE npc_file.npc03,   #No.FUN-680107 VARCHAR(10)#交易摘要
                 npc04     LIKE npc_file.npc04,   #No.FUN-680107 VARCHAR(1) #收支別 1:收 2:支
                 npc05     LIKE npc_file.npc05,   #No.FUN-680107 DEC(20,6) #金額
                 npc06     LIKE npc_file.npc06,   #No.FUN-680107 VARCHAR(10)#票據號碼
                 npc07     LIKE npc_file.npc07,   #No.FUN-680107 VARCHAR(1) #對帳碼1:已入帳2:公司未入帳
                 npc08     LIKE npc_file.npc08,   #No.FUN-680107 INTEGER
                 nme09     LIKE nme_file.nme09    #No.FUN-680107 VARCHAR(2)
                        END RECORD
#No.FUN-830154--begin-- 
  DEFINE yy,mm        LIKE type_file.chr1000,
         l_amt        LIKE type_file.num10,
         l_amt2       LIKE type_file.num10,
         l_nme13      LIKE nme_file.nme13,
         this_amt,bef_amt LIKE type_file.num10,
         l_nmp19      LIKE nmp_file.nmp19,
         l_npc04      LIKE type_file.chr2,
         l_nma02      LIKE nma_file.nma02
#No.FUN-830154--end--
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr902'
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog          #No.FUN-830154                                               
     CALL cl_del_data(l_table)                                         #No.FUN-830154
#No.FUN-830154--begin--
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#     FOR g_i = 1 TO g_len
#         LET g_dash[g_i,g_i] = '='
#         LET g_dash_1[g_i,g_i] = '-'
#     END FOR
#No.FUN-830154--end--
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND npcuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND npcgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND npcgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('npcuser', 'npcgrup')
     #End:FUN-980030
 
     DROP TABLE a
     IF tm.p='1' THEN #已入帳
#       LET l_sql="SELECT '',npc_file.*,'' FROM npc_file",                                                         #No.TQC-960453
        LET l_sql="SELECT '',npc01,npc02,npc021,npc03,npc04,npc05,npc06,npc07,npc08,'' FROM npc_file",    #No.TQC-960453            
                  " WHERE npc02 BETWEEN '",g_bdate, "' AND '",g_edate,"'",
                  " AND npc07='1' ",
                  " AND ", tm.wc CLIPPED,
                  " ORDER BY 1,2,3"
     ELSE             #當月公司未入
#       LET l_sql=" SELECT '1',npc_file.*,'' FROM npc_file",                                                       #No.TQC-960453
        LET l_sql="SELECT '1',npc01,npc02,npc021,npc03,npc04,npc05,npc06,npc07,npc08,'' FROM npc_file",   #No.TQC-960453            
                  " WHERE npc02 BETWEEN '",g_bdate, "' AND '",g_edate,"'",
                  " AND npc07<>'1' ",
                  " AND ", tm.wc CLIPPED
        LET l_wc=change_string(tm.wc,"npc01","nme01")
        LET l_sql=l_sql CLIPPED," UNION ALL ",  #當月銀行未入
              " SELECT '1',nme01,nme16,'',nmc02,nmc03,nme04,nme17,'3',0,nme09",
                  " FROM nme_file,nmc_file ",
                  " WHERE nme16 BETWEEN '",g_bdate,"' AND '",g_edate,"' ",
                  " AND nme20 IS NULL ",
                  " AND nme03=nmc01 ",
                  " AND ", l_wc CLIPPED,
                  " UNION ALL ",  #非當月銀行未入帳
              " SELECT '2',nme01,nme16,'',nmc02,nmc03,nme04,nme17,'3',0,nme09",
                  " FROM nme_file,nmc_file,nmk_file ",
                  " WHERE nme16 < '",g_bdate,"'",
                  " AND nme20 IS NULL ",
                  " AND nme03=nmc01 ",
                  " AND nme09=nmk01 ",
                  " AND ", l_wc CLIPPED,
                  " ORDER BY 1,2,3"
     END IF
 
     PREPARE r902_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
           
     END IF
     DECLARE r902_curs1 CURSOR FOR r902_prepare1
#     CALL cl_outnam('anmr902') RETURNING l_name                     #No.FUN-830154 
#     START REPORT r902_rep TO l_name                                #No.FUN-830154
#     LET g_pageno = 0                                               #No.FUN-830154
     FOREACH r902_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
#No.FUN-830154--begin--
       SELECT nme13 INTO l_nme13 FROM nme_file
      WHERE nme17=sr.npc06
      IF STATUS=NOTFOUND THEN LET l_nme13=null END IF
      IF sr.npc04='1' THEN 
         LET l_amt=l_amt-sr.npc05
      ELSE                
         LET l_amt=l_amt+sr.npc05
      END IF
      SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.npc01
      IF STATUS=NOTFOUND THEN LET l_nma02=null END IF
      IF sr.group='1' THEN
         LET this_amt=l_amt
      ELSE
         LET bef_amt=l_amt
      END IF
      SELECT nmp19 INTO l_nmp19 FROM nmp_file    
        WHERE nmp01=sr.npc01 AND nmp02=tm.yy AND nmp03=tm.mm
        IF STATUS=NOTFOUND THEN LET l_nmp19=0 END IF
     #CALL get_nmq(sr.npc01) RETURNING l_amt2    #TQC-960162 mark
      LET l_amt2 = 0                           #TQC-960162 add
      EXECUTE insert_prep USING sr.group,sr.npc02,sr.npc03,sr.npc06,l_nme13,l_npc04,sr.npc05,sr.npc07,
                                sr.npc08,sr.nme09,sr.npc01,l_nma02,l_amt,l_amt2,this_amt,bef_amt,l_nmp19
#       OUTPUT TO REPORT r902_rep(sr.*)
#No.FUN-830154--end--
     END FOREACH
#No.FUN-830154--begin--
     IF g_zz05 = 'Y' THEN                                                                                                           
       CALL cl_wcchp(tm.wc,'npc01')                                                                   
        RETURNING tm.wc                                                                                                             
        LET g_str =tm.wc                                                                                                            
     END IF     
     LET yy=tm.yy USING '####'
     LET mm=tm.mm USING '##'                                                                                                                      
     LET g_str =g_str,";",yy,";",mm,";",tm.p,";",g_azi04,";",g_azi05,";",tm.p
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     CALL cl_prt_cs3('anmr902','anmr902',g_sql,g_str)
#     FINISH REPORT r902_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-830154--end--
END FUNCTION
#No.FUN-830154--begin--
#REPORT r902_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,        #No.FUN-680107 VARCHAR(1)
#         l_nma02      LIKE nma_file.nma02,
#         l_amt        LIKE type_file.num10,       #No.FUN-680107 INTEGER
#         l_amt2       LIKE type_file.num10,       #No.FUN-680107 INTEGER
#         l_nme13      LIKE nme_file.nme13,
#         this_amt,bef_amt LIKE type_file.num10,   #No.FUN-680107 INTEGER
#         l_lsamt      LIKE type_file.num10,       #No.FUN-680107 INTEGER
#         l_nmp19      LIKE nmp_file.nmp19,        #No.FUN-680107 INTEGER
#          l_npc04      LIKE npc_file.npc04,        #No.FUN-680107 VARCHAR(2)  #No.TQC-6A0110
#         l_npc04      LIKE type_file.chr2,        #No.TQC-6A0110
#         sr               RECORD
#                group     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)    #'1' 當月 2 非當月
#                npc01     LIKE npc_file.npc01,    #No.FUN-680107 VARCHAR(6)    #銀行編號
#                npc02     LIKE npc_file.npc02,    #No.FUN-680107 DATE    #異動日期
#                npc021    LIKE npc_file.npc021,   #No.FUN-680107 VARCHAR(5)    #異動時間
#                npc03     LIKE npc_file.npc03,    #No.FUN-680107 VARCHAR(10)    #交易摘要
# Prog. Version..: '5.30.06-13.03.12(01)    #收支別 1:收 2:支
#                npc05     LIKE npc_file.npc05,    #No.FUN-680107 DEC(20,6)    #金額
#                npc06     LIKE npc_file.npc06,    #No.FUN-680107 VARCHAR(10)    #票據號碼
#                npc07     LIKE npc_file.npc07,    #No.FUN-680107 VARCHAR(1)    #對帳碼1:已對帳2:錯帳
#                npc08     LIKE npc_file.npc08,    #No.FUN-680107 INTEGER
#                nme09     LIKE nme_file.nme09     #No.FUN-680107 VARCHAR(2)
#                       END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#No.TQC-6A0110 -- begin --
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN 35, tm.yy USING '####',' ',g_x[21] CLIPPED,' / ',
#                       tm.mm USING '##',' ',g_x[22] CLIPPED,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_x[49] CLIPPED,' ',g_x[50] CLIPPED
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN (g_len-FGL_WIDTH(g_user)-15),'FROM:',g_user CLIPPED,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     LET g_x[1] = g_x[1],"(",tm.yy USING '####',g_x[21] CLIPPED,tm.mm USING '##',g_x[22] CLIPPED,")"    #No.TQC-770065
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED,"(",tm.yy USING '####',g_x[21] CLIPPED,tm.mm USING '##',g_x[22] CLIPPED,")"    #No.TQC-770065
#     PRINT g_x[49] CLIPPED
#No.TQC-6A0110 -- end --
#     PRINT g_dash[1,g_len]
#     PRINT COLUMN 1,g_x[51] CLIPPED,
#           COLUMN 39,g_x[52] CLIPPED,
#           COLUMN 80,g_x[53] CLIPPED
#TQC-5B0043
#      PRINT "-------- -------- ---------- -------- --",
#            COLUMN 42,"------------------- ------ ---------- ------"
#     PRINT "-------- -------- ---------------- -------- ------",
#           COLUMN 52,"------------------- ------ ---------- ------"
#END TQC-5B0043
 
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#     IF sr.npc04='1' THEN
#        LET l_npc04=g_x[61] CLIPPED
#     ELSE
#        LET l_npc04=g_x[62] CLIPPED
#     END IF
#     SELECT nme13 INTO l_nme13 FROM nme_file
#     WHERE nme17=sr.npc06
#     IF STATUS=NOTFOUND THEN LET l_nme13=null END IF
#     PRINT COLUMN 01, sr.npc02 CLIPPED,
#           COLUMN 10, sr.npc03[1,8],
#           COLUMN 19, sr.npc06[1,10],
#TQC-5B0045
#           COLUMN 30, l_nme13[1,10],
#           COLUMN 40, l_npc04[1,2],
#           COLUMN 42, cl_numfor(sr.npc05,18,g_azi04),
#           COLUMN 62, sr.npc07,
#           COLUMN 69, sr.npc08 USING '##########',
#           COLUMN 80, sr.nme09
#           COLUMN 36, l_nme13[1,10],
#           COLUMN 45, l_npc04[1,2],
#           COLUMN 52, cl_numfor(sr.npc05,18,g_azi04),
#           COLUMN 72, sr.npc07,
#           COLUMN 79, sr.npc08 USING '##########',
#           COLUMN 90, sr.nme09
#END TQC-5B0045
#     IF sr.npc04='1' THEN #收
#        LET l_amt=l_amt-sr.npc05
#     ELSE                 #支
#        LET l_amt=l_amt+sr.npc05
#     END IF
 
#  BEFORE GROUP OF sr.npc01
#     SKIP TO TOP OF PAGE
#     SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=sr.npc01
#     IF STATUS=NOTFOUND THEN LET l_nma02=null END IF
#     PRINT g_x[11] CLIPPED,sr.npc01,'  ',l_nma02
 
#  AFTER GROUP OF sr.group
#     IF sr.group='1' THEN
#TQC-5B0043
#         PRINT COLUMN 30,g_x[54] CLIPPED,
#               COLUMN 42,cl_numfor(l_amt,18,g_azi05)
#        PRINT COLUMN 36,g_x[54] CLIPPED,
#              COLUMN 48,cl_numfor(l_amt,18,g_azi05)
#TQC-5B0043
#        LET this_amt=l_amt
#     ELSE
#TQC-5B0043
#         PRINT COLUMN 30,g_x[55] CLIPPED,
#               COLUMN 42,cl_numfor(l_amt,18,g_azi05)
#        PRINT COLUMN 36,g_x[55] CLIPPED,
#              COLUMN 48,cl_numfor(l_amt,18,g_azi05)
#TQC-5B0043
#        LET bef_amt=l_amt
#     END IF
#     LET l_amt=0
#     PRINT ''
#  AFTER GROUP OF sr.npc01
#     PRINT g_dash[1,g_len]
#     IF tm.p<>'1' THEN #
#       PRINT COLUMN 5,g_x[56] CLIPPED,
#             COLUMN 35,g_x[16] CLIPPED,
#             COLUMN 64,g_x[57] CLIPPED
#       PRINT "--------------------------  -------------------",
#             "  ----------------------------------------------"
#       SELECT nmp19 INTO l_nmp19 FROM nmp_file     #get公司帳
#       WHERE nmp01=sr.npc01 AND nmp02=tm.yy AND nmp03=tm.mm
#       IF STATUS=NOTFOUND THEN LET l_nmp19=0 END IF
#       PRINT g_x[29] CLIPPED,
#             COLUMN 29,cl_numfor(l_nmp19,18,g_azi05)
#       PRINT g_x[30] CLIPPED,g_x[58] CLIPPED
#             ,COLUMN 29,cl_numfor(this_amt,18,g_azi05)
#       PRINT g_x[30] CLIPPED,g_x[59] CLIPPED
#             ,COLUMN 29,cl_numfor(bef_amt,18,g_azi05)
#       CALL get_nmq(sr.npc01) RETURNING l_amt2
#       PRINT g_x[33] CLIPPED,g_x[60] CLIPPED
#             ,COLUMN 29,cl_numfor(l_amt2,18,g_azi05)
#       PRINT g_x[35] CLIPPED,COLUMN 29,
#             cl_numfor((l_nmp19+this_amt+bef_amt-l_amt2),18,g_azi05)
#     END IF
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     IF g_zz05='Y' THEN
#        PRINT g_dash_1[1,g_len]
#        PRINT tm.wc CLIPPED
#     ELSE
#        SKIP 2 LINE
#     END IF
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     ELSE
#        SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-830154--end--
FUNCTION change_string(old_string, old_sub, new_sub)
DEFINE query_text   LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(300)
DEFINE AA           LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)    
DEFINE old_string   LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(300)
       xxx_string   LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(300)
       old_sub      LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(128)
       new_sub      LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(128)
       first_byte   LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(01)
       nowx_byte    LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(01)
       next_byte    LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(01)
       this_byte    LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(01)
       length1, length2, length3   LIKE type_file.num5,     #No.FUN-680107 SMALLINT
                     pu1, pu2      LIKE type_file.num5,     #No.FUN-680107 SMALLINT
       ii, jj, kk, ff, tt          LIKE type_file.num5      #No.FUN-680107 SMALLINT
 
LET length1 = length(old_string)
LET length2 = length(old_sub)
LET length3 = length(new_sub)
LET first_byte = old_sub[1,1]
LET xxx_string = " "
let pu1 = 0
 
FOR ii = 1 TO length1
    LET this_byte = old_string[ii, ii]
    LET nowx_byte = this_byte
    IF this_byte = first_byte THEN
        FOR jj = 2 TO length2
            let this_byte = old_string[ ii + jj - 1, ii + jj - 1]
            let next_byte = old_sub[ jj, jj]
            IF this_byte <> next_byte THEN
                let jj = 29999
                exit for
            END IF
        END FOR
        IF jj < 29999 THEN
           let pu1 = pu1 + 1
           let pu2 = pu1 + length3 - 1
           LET xxx_string[pu1, pu2] = new_sub CLIPPED
           LET ii = ii + length2 - 1
           LET pu1 = pu2
        ELSE
            let pu1 = pu1 + 1
            LET xxx_string[pu1,pu1] = nowx_byte
        END IF
    ELSE
        LET pu1 = pu1 + 1
        LET xxx_string[pu1,pu1] = nowx_byte
    END IF
end for
let query_text = xxx_string
RETURN query_text
END FUNCTION
 
#TQC-960162---mark---start
#FUNCTION get_nmq(l_nma01)
#DEFINE l_amt,l_nmq04_dr,l_nmq04_cr  LIKE type_file.num10,    #No.FUN-680107 INTEGER
#       l_nma01                      LIKE nma_file.nma01
#   SELECT SUM(nmq04) INTO l_nmq04_dr
#   FROM nmq_file,nmk_file
#   WHERE nmq01 = l_nma01 AND nmq03 = nmk01 AND nmk03='+'
#   AND nmq05 <= g_edate
#   IF l_nmq04_dr IS NULL THEN LET l_nmq04_dr=0 END IF
#
#   SELECT SUM(nmq04) INTO l_nmq04_cr
#   FROM nmq_file,nmk_file
#   WHERE nmq01 = l_nma01 AND nmq03 = nmk01 AND nmk03='-'
#   AND nmq05 <= g_edate
#   IF l_nmq04_cr IS NULL THEN LET l_nmq04_cr=0 END IF
#   LET l_amt=l_nmq04_dr-l_nmq04_cr
#
#   RETURN l_amt
#END FUNCTION
#TQC-960162---mark---end
#Patch....NO.TQC-610036 <001> #
#FUN-870144
