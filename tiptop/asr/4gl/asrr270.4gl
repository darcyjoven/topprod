# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asrr270.4gl
# Descriptions...: 異常&除外工時分析表
# Date & Author..: 2006/03/31 By Joe
# Modify.........: No.TQC-630251 06/03/27 By Joe 超過10種以上的異常原因 要列印在第二頁以後
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-770070 07/05/28 By TSD.Achick報表改寫由Crystal Report產出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80063 11/08/05 By fanbj  EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      STRING, 
              bdate   LIKE type_file.dat,       #No.FUN-680130 DATE
              edate   LIKE type_file.dat,       #No.FUN-680130 DATE
              more    LIKE type_file.chr1       #No.FUN-680130 VARCHAR(1)
              END RECORD,
     g_line_1 DYNAMIC ARRAY OF RECORD
              line    LIKE srf_file.srf03,
              qty     LIKE srh_file.srh05
              END RECORD,
        g_res DYNAMIC ARRAY OF RECORD
              res     LIKE srh_file.srh04,
              qty     LIKE srh_file.srh05
              END RECORD
   DEFINE     g_i LIKE type_file.num5,          # count/index for any purpose        #No.FUN-680130 SMALLINT
              g_line_ac LIKE type_file.num10,   #No.FUN-680130 INTEGER
              g_res_ac  LIKE type_file.num10,   #No.FUN-680130 INTEGER
              g_tqty LIKE srh_file.srh05
 
DEFINE l_table     STRING                       ### FUN-770070 add ###
DEFINE g_sql       STRING                       ### FUN-770070 add ###
DEFINE g_str       STRING                       ### FUN-770070 add ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
 
   #str FUN-770070 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-770070 *** ##
   LET g_sql = "srf03.srf_file.srf03,",
               "eci06.eci_file.eci06,",
               "srh04.srh_file.srh04,",
               "sgb05.sgb_file.sgb05,",
               "srh05.srh_file.srh05"
 
   LET l_table = cl_prt_temptable('asrr270',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?)"
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   CALL r270_cre_tmp()

   CALL cl_used(g_prog,g_time,1) RETURNING g_time      # FUN-B80063--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r270_tm(0,0)
   ELSE 
      CALL r270()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
END MAIN
 
FUNCTION r270_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680130 SMALLINT 
          l_cmd          LIKE type_file.chr1000       #No.FUN-680130 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r270_w AT p_row,p_col
        WITH FORM "asr/42f/asrr270"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.bdate= g_today
   LET tm.edate= g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc = ' 1=1'
 
   WHILE TRUE
      WHILE TRUE
         CONSTRUCT BY NAME tm.wc ON srf03
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
   
         ON ACTION controlp     
            CASE WHEN INFIELD(srf03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_eci"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO srf03
                 NEXT FIELD srf03
            END CASE
    
         ON ACTION locale
            CALL cl_show_fld_cont()                
            LET g_action_choice = "locale"
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
            CLOSE WINDOW r270_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
            EXIT PROGRAM
         END IF
         IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
         CALL cl_err('',9046,0)
      END WHILE
      INPUT BY NAME tm.bdate,tm.edate,tm.more WITHOUT DEFAULTS
   
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
   
         AFTER FIELD bdate
             IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
   
         AFTER FIELD edate
             IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
             IF tm.edate < tm.bdate THEN NEXT FIELD edate END IF
   
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
         CLOSE WINDOW r270_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
                WHERE zz01='asrr270'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asrr270','9031',1)   
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
                            " '",tm.bdate CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",           
                            " '",g_rep_clas CLIPPED,"'",           
                            " '",g_template CLIPPED,"'"            
            CALL cl_cmdat('asrr270',g_time,l_cmd)
         END IF
         CLOSE WINDOW r270_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r270()
      ERROR ""
   END WHILE
   CLOSE WINDOW r270_w
END FUNCTION
 
FUNCTION r270()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name      #No.FUN-680130 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT               #No.FUN-680130 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680130 VARCHAR(40)    
          l_i       LIKE type_file.num10,         #No.FUN-680130 INTEGER
          l_str     LIKE sgb_file.sgb05,
          l_srf     RECORD LIKE srf_file.*,
          l_srg     RECORD LIKE srg_file.*,
          l_srh     RECORD LIKE srh_file.*,
          l_line    LIKE srf_file.srf03,
          l_res     LIKE srh_file.srh04,
          l_qty     LIKE srh_file.srh05,
          l_eci06   LIKE eci_file.eci06,          #FUN-770070 Add
          sr        RECORD
                    page    LIKE type_file.num10,    ## 頁面頁次     #No.FUN-680130 INTEGER
                    line    LIKE srf_file.srf03,     ## 機台編號
                    resno   LIKE type_file.num10,    ## 異常&除外原因頁面編號(1-10)    #No.FUN-680130 INTEGER
                    qty     LIKE srh_file.srh05      ## 不良數量
                    END RECORD
 
   #str FUN-770070  add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770070 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-770070  add
 
     CALL g_zaa_dyn.clear()           
 
     # No.FUN-B80063----start mark------------------------------------
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-6B0014
     # No.FUN-B80063----end mark--------------------------------------

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770070 add ###
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND qcsuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND qcsgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
     #     IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND qcsgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('qcsuser', 'qcsgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT * FROM srf_file,srg_file,srh_file ",
                 " WHERE srf01=srg01 ",
                 "   AND srh01=srg01 ",
                 "   AND srh03=srg02 ",
                 "   AND srfconf = 'Y'",
                 "   AND srf02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND ", tm.wc CLIPPED
 
     PREPARE r270_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      # FUN-B80063--add--
        EXIT PROGRAM
     END IF
     DECLARE r270_curs1 CURSOR FOR r270_prepare1
 
     LET g_pageno = 0
     LET g_line_ac = 0
     LET g_res_ac = 0
     ## 清除動態陣列----------------------------
     CALL g_line_1.clear()
     CALL g_res.clear()
 
     DELETE FROM asrr270_tmp
 
     FOREACH r270_curs1 INTO l_srf.*,l_srg.*,l_srh.*
        IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
        END IF
        INSERT INTO asrr270_tmp VALUES (l_srf.srf03,l_srh.srh04,l_srh.srh05)
     END FOREACH
 
     #---計算選擇範圍內異常&除外工時總數(g_tqty)------------
     SELECT SUM(srh05) INTO g_tqty FROM asrr270_tmp
 
     #---計算選擇範圍內機台(生產線)項次數(g_line_ac)並逐一填入陣列(g_line)---
     SELECT COUNT(DISTINCT srf03) INTO g_line_ac FROM asrr270_tmp
     LET l_i = 1
     DECLARE r270_l CURSOR FOR
      SELECT srf03,SUM(srh05) FROM asrr270_tmp
      GROUP BY srf03
     FOREACH r270_l INTO g_line_1[l_i].*
        IF STATUS THEN 
          CALL cl_err('foreach line',STATUS,0)    
           EXIT FOREACH 
        END IF
        IF l_i >= g_line_ac THEN  
           EXIT FOREACH 
        END IF
        LET l_i = l_i + 1
     END FOREACH
 
     #--計算選擇範圍內異常&除外原因項次數(g_res_ac)並逐一填入陣列(g_res)--
     SELECT COUNT(DISTINCT srh04) INTO g_res_ac FROM asrr270_tmp
     LET l_i = 1
     DECLARE r270_res CURSOR FOR 
      SELECT srh04,SUM(srh05) FROM asrr270_tmp
      GROUP BY srh04
     FOREACH r270_res INTO g_res[l_i].*
        IF STATUS THEN 
           CALL cl_err('foreach res',STATUS,0)   
           EXIT FOREACH 
        END IF
        IF l_i >= g_res_ac THEN
           EXIT FOREACH
        END IF
        LET l_i = l_i + 1
     END FOREACH
 
     ------單身資料-----------------
     DECLARE r270_body CURSOR FOR
      SELECT srf03,srh04,SUM(srh05) FROM asrr270_tmp
      GROUP BY srf03,srh04
     FOREACH r270_body INTO l_line,l_res,l_qty
       IF STATUS THEN 
          CALL cl_err('foreach body',STATUS,0)    
          EXIT FOREACH 
       END IF
       LET l_i = 1
       WHILE g_res_ac >= l_i
          IF g_res[l_i].res = l_res THEN 
             EXIT WHILE
          END IF
          LET l_i = l_i + 1
       END WHILE   
       IF (l_i MOD 10) = 0 THEN
          LET sr.page = l_i/10
       ELSE
          LET sr.page = (l_i/10) + 1
       END IF
       LET sr.line = l_line
       LET sr.resno = (l_i MOD 10)
       IF (l_i MOD 10) = 0 THEN
          LET sr.resno = l_i
       ELSE
          LET sr.resno = (l_i MOD 10)
       END IF
       LET sr.qty = l_qty
 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770070 *** ##
         LET l_str = r270_sgb(l_res)
         SELECT eci06 INTO l_eci06 FROM eci_file WHERE eci01 = sr.line
         EXECUTE insert_prep USING 
         sr.line, l_eci06, l_res, l_str, l_qty
       #------------------------------ CR (3) ------------------------------#
 
     END FOREACH
 
   #str FUN-770070 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770070 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'cpf28,cpf29,cpf01')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET g_str = g_str
   CALL cl_prt_cs3('asrr270','asrr270',l_sql,g_str)   
   #------------------------------ CR (4) ------------------------------#
 
   #No.FUN-BB0047--mark--Begin---
   #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6B0014
   #No.FUN-BB0047--mark--End-----
END FUNCTION
 
FUNCTION r270_sgb(p_srh04)
   DEFINE p_srh04   LIKE srh_file.srh04,
          l_str     LIKE sgb_file.sgb05
 
   SELECT sgb05 INTO l_str
     FROM sgb_file
    WHERE sgb01 = p_srh04
 
   RETURN l_str
END FUNCTION
 
FUNCTION r270_cre_tmp()
  CREATE TEMP TABLE asrr270_tmp
  (srf03     LIKE srf_file.srf03,   
   srh04     LIKE srh_file.srh04,
   srh05     LIKE srh_file.srh05)     
END FUNCTION
 
FUNCTION r270_chk_print(p_value,p_form,p_n)
   DEFINE p_value   LIKE srh_file.srh05,      # 傳入判斷數 #No.FUN-680130 DEC(15,3)
          p_form    LIKE type_file.num5,      # 顯示格式 qty-->15  %-->14+%      #No.FUN-680130 SMALLINT
          p_n       LIKE type_file.num5,       # 顯示小數位數       #No.FUN-680130 SMALLINT
          p_str     LIKE type_file.chr20       #No.FUN-680130 VARCHAR(20)
 
   IF (NOT cl_null(p_value)) AND (p_value <> 0) THEN 
      IF p_form = 2 THEN          # %型式
         LET p_str = cl_numfor(p_value,14,p_n) CLIPPED,'%'
      ELSE
         LET p_str = cl_numfor(p_value,15,p_n)
      END IF
   ELSE
      LET p_str = ''
   END IF
   RETURN p_str 
END FUNCTION
