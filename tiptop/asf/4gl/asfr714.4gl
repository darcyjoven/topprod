# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr714.4gl
# Descriptions...: 生產效率分析表(人工)
# Date & Author..: 99/06/01 by Iceman
# Modify.........: NO.FUN-510040 05/02/17 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-720005 07/01/31 By TSD.Ken 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-770004 07/07/03 By mike 幫組按鈕灰色
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50156 10/05/28 By Carrier MOD-970098追单
# Modify.........: No.FUN-A60027 10/06/24 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.MOD-B80330 12/02/27 By Vampire ecm14抓取的值有誤
# Modify.........: No.MOD-B80331 12/06/08 By Elise 轉稼工時的where條件有誤 
# Modify.........: No.MOD-B90074 12/06/18 By Elise 抓取報工資料時應要group by

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)
              ddate   LIKE type_file.dat            #No.FUN-680121 DATE
              END RECORD
#          g_dash1  VARCHAR(140)
 
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
DEFINE l_table     STRING                       ### FUN-720005 add ###
DEFINE g_sql       STRING                       ### FUN-720005 add ###
DEFINE g_str       STRING                       ### FUN-720005 add ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
   #str FUN-720005 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-720005 *** ##
   LET g_sql = "shb05.shb_file.shb05,", #工單編號
               "sfb06.sfb_file.sfb06,", #製程編號
               "shb06.shb_file.shb06,", #製程序
               "shb081.shb_file.shb081,",#作業編號
               "shb082.shb_file.shb082,",#作業名稱
               "shb08.shb_file.shb08,", #線/班別
               "shb10.shb_file.shb10,", #料品編號
               "shb012.shb_file.shb012,",#FUN-A60027
               "ima02.ima_file.ima02,", #料件名稱
               "ima021.ima_file.ima021,",#料件規格
               "A.ste_file.ste06,",      #No.FUN-680121 DEC(10,2)
               "B.ste_file.ste06,",      #No.FUN-680121 DEC(10,2)
               "C.ste_file.ste06,",      #No.FUN-680121 DEC(10,2)
               "D.rpf_file.rpf04,",      #No.FUN-680121 DEC(11,2)
               "E.rpf_file.rpf04,",      #No.FUN-680121 DEC(11,2)
               "F.eco_file.eco05,",      #No.FUN-680121 DEC(7,2)
               "G.eco_file.eco05"        #No.FUN-680121 DEC(7,2)
 
   LET l_table = cl_prt_temptable('asfr714',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"   #FUN-A60027 add 1?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-720005 add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   IF cl_null(g_bgjob) OR g_bgjob ='N' THEN
      CALL r714_tm(0,0)
   ELSE
      CALL asfr714()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r714_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000          #No.FUN-680121 CAHR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row =5  LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW r714_w AT p_row,p_col
        WITH FORM "asf/42f/asfr714"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.ddate= g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON shb05,shb10,shb08
#No.FUN-570240 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp
            IF INFIELD(shb10) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO shb10
               NEXT FIELD shb10
            END IF
#No.FUN-570240 --end--
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
    ON ACTION help                                                #No;TQC-770004                                                               
 
 
          CALL cl_show_help()                #No;TQC-770004          
         LET g_action_choice = "help"          #No;TQC-770004                                                                                   
         CONTINUE CONSTRUCT                    #No;TQC-770004
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
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
         CLOSE WINDOW r714_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.ddate WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
       AFTER FIELD ddate
          IF cl_null(tm.ddate) THEN CALL cl_err('','aap-099',0)
             NEXT FIELD ddate END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
         ON ACTION help                                                #No;TQC-770004                                                  
                                                                                                                                    
                                                                                                                                    
          CALL cl_show_help()                #No;TQC-770004                                                                         
         LET g_action_choice = "help"          #No;TQC-770004                                                                       
         CONTINUE INPUT                    #No;TQC-770004     
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r714_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr714()
   ERROR ""
END WHILE
   CLOSE WINDOW r714_w
END FUNCTION
 
FUNCTION asfr714()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1100)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_ecm14   LIKE ecm_file.ecm14,
          l_shb05   LIKE shb_file.shb05,
          l_shb10   LIKE shb_file.shb10,
          l_tot     LIKE shb_file.shb111,            #No.FUN-680121 DEC(12,3)
          l_count,l_i   LIKE type_file.num5,         #No.FUN-680121 SMALLINT
          l_cmd,l_cmd1 LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)
          sr        RECORD
                  shb05   LIKE shb_file.shb05,   #工單編號
                  sfb06   LIKE sfb_file.sfb06,   #製程編號
                  shb06   LIKE shb_file.shb06,   #製程序
                  shb081  LIKE shb_file.shb081,  #作業編號
                  shb082  LIKE shb_file.shb082,  #作業名稱
                  shb08   LIKE shb_file.shb08,   #線/班別
                  shb10   LIKE shb_file.shb10,   #料品編號
                  shb012  LIKE shb_file.shb012,  #FUN-A60027
                  ima02   LIKE ima_file.ima02,   #料件名稱
                  ima021  LIKE ima_file.ima021,  #料件規格
                  A       LIKE ste_file.ste06,        #No.FUN-680121 DEC(10,2)
                  B       LIKE ste_file.ste06,        #No.FUN-680121 DEC(10,2)
                  C       LIKE ste_file.ste06,        #No.FUN-680121 DEC(10,2)
                  D       LIKE rpf_file.rpf04,        #No.FUN-680121 DEC(11,2)
                  E       LIKE rpf_file.rpf04,        #No.FUN-680121 DEC(11,2)
                  F       LIKE eco_file.eco05,        #No.FUN-680121 DEC(7,2)
                  G       LIKE eco_file.eco05         #No.FUN-680121 DEC(7,2)
                    END RECORD
 
   #str FUN-720005 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720005 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720005 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720005 add ###
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            # 只能使用自己的資料
   #       LET tm.wc= tm.wc clipped," AND shbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                            # 只能使用相同群的資料
   #       LET tm.wc= tm.wc clipped," AND shbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc= tm.wc clipped," AND shbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shbuser', 'shbgrup')
   #End:FUN-980030
 
   LET l_sql = " SELECT shb05,sfb06,shb06,shb081,shb082,shb08,shb10,shb012,ima02,",  #FUN-A60027 add shb012
               "        ima021,0,0,0,0,0,0,0 ",
               "   FROM shb_file,OUTER sfb_file,OUTER ima_file ",    #FUN-720005
               "  WHERE shb03 = '",tm.ddate,"'",
               "    AND shb_file.shb05 = sfb_file.sfb01 ",                #FUN-720005
               "    AND shb_file.shb10 = ima_file.ima01 ",                #FUN-720005
               "    AND shbconf = 'Y' ",     #FUN-A70095
               "    AND ",tm.wc CLIPPED,
               "  GROUP BY shb05,sfb06,shb06,shb081,shb082,shb08,shb10,shb012,ima02,ima021"    #MOD-B90074 add
 
   PREPARE r714_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE r714_curs1 CURSOR FOR r714_prepare1
   FOREACH r714_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #---------------本日工時-------------------
      SELECT SUM(shb032) INTO sr.A FROM shb_file
       WHERE shb05 = sr.shb05 AND shb03 = tm.ddate
         AND shb06 = sr.shb06 AND shb012 = sr.shb012   #FUN-A60027 add shb012 
         AND shbconf = 'Y'   #FUN-A70095
      #---------------轉稼工時-------------------
     #SELECT SUM(shg09)  INTO sr.B FROM shg_file            #MOD-B80331 mark
      SELECT SUM(shg09)  INTO sr.B FROM shg_file,sfb_file   #MOD-B80331 add
       WHERE shg01 = tm.ddate AND shg06 = sr.shb05
        #AND shg03 = sr.shb06    #MOD-B80331 mark
         AND shg06 = sfb01       #MOD-B80331 add
         AND shg07 = sfb06       #MOD-B80331 add
      IF cl_null(sr.B) THEN LET sr.B=0 END IF
      #---------------產 出 量-------------------
      SELECT SUM(shb111+shb112) INTO sr.C FROM shb_file
      WHERE shb05 = sr.shb05 AND shb03 = tm.ddate
        AND shb06 = sr.shb06 AND shb012 = sr.shb012   #FUN-A60027 add shb012
        AND shbconf = 'Y'    #FUN-A70095    
      #---------------標準工時(分)---------------
      #SELECT ecm14/60 INTO sr.D FROM ecm_file                           #MOD-B80330 mark
      SELECT ecm14/(60*sfb08) INTO sr.D FROM ecm_file,shb_file,sfb_file  #MOD-B80330 add
      WHERE ecm01 = sr.shb05 AND ecm03 = sr.shb06 
        AND ecm012 = sr.shb012                        #FUN-A60027 
        AND shb05 = sfb01     #MOD-B80330 add
        AND ecm01 = shb05 AND ecm03 = shb06  #MOD-B80330
      #---------------產出工時-------------------
      LET sr.E = sr.D * sr.C
      #---------------生 產 力-------------------
      LET sr.F = (sr.C / sr.A)         #No:TQC-A50156 modify  
      #---------------生產效率-------------------
      LET sr.G = (sr.E / sr.A) * 100   #No:TQC-A50156 modify
    
      #str FUN-720005 add 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720005 *** ##
      EXECUTE insert_prep USING 
         sr.shb05,sr.sfb06,sr.shb06,sr.shb081,sr.shb082,
         sr.shb08,sr.shb10,sr.shb012,sr.ima02,sr.ima021,sr.A,  #FUN-A60027 add shb012 
         sr.B,sr.C,sr.D,sr.E,sr.F,sr.G                         #FUN-720005
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720005 add 
   END FOREACH
    
   #str FUN-720005 add 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'shb05,shb10,shb08')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
  #CALL cl_prt_cs3('asfr714','asfr714',l_sql,g_str)   #FUN-710080 modify  #FUN-A60027 mark
  #No.FUN-A60027 -----------------------start--------------------
   IF g_sma.sma541 = 'Y' THEN
      CALL cl_prt_cs3('asfr714','asfr714_1',l_sql,g_str)
   ELSE
      CALL cl_prt_cs3('asfr714','asfr714',l_sql,g_str)
   END IF 
  #FUN-A60027 --------------------------end-----------------------  
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720005 add 
 
END FUNCTION
