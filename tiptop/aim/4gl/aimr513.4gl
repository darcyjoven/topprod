# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimr513.4gl
# Descriptions...: 直接調撥明細表
# Input parameter:
# Return code....:
# Date & Author..: 92/05/11 By Lin
# Modify.........: 93/08/02 By Apple
# Modify.........: No.FUN-4A0049 04/10/06 By Yuna 調撥單號開窗
# Modify.........: No.FUN-510017 05/01/26 By Mandy 報表轉XML
# Modify.........: No.FUN-560069 05/06/14 By jackie 雙單位報表格式修改
# Modify.........: No.FUN-580005 05/08/03 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-6C0054 06/12/11 By Claire 撥入倉及撥出倉列印位置顛倒
# Modify.........: No.FUN-7C0049 08/01/30 By lutingting報表轉為使用cr
# Modify.........: No.MOD-810120 08/03/24 By Pengu Input條件選Y確認時，會印出未確認的資料
# Modify.........: No.MOD-840553 08/04/22 By kim GP5.1顧問測試修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5    #No.FUN-690026 SMALLINT
END GLOBALS
#No.FUN-580005 --end--
 
DEFINE tm  RECORD                            # Print condition RECORD
             wc      STRING,                 # Where condition   #TQC-630166
             s       LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
             t       LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
             a       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
             b       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
             c       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
             more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
       END RECORD
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#No.FUN-580005 --start--
DEFINE g_sma115      LIKE sma_file.sma115
DEFINE g_sma116      LIKE sma_file.sma116
#No.FUN-580005 --end--
 
#No.FUN-7C0049--start--
DEFINE l_table     STRING
DEFINE g_str       STRING
DEFINE g_sql       STRING
#No.FUN-7C0049--end
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                   # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
    IF g_sma.sma12='N' THEN
       CALL cl_err('','mfg1007',0)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
       EXIT PROGRAM
    END IF
 
#No.FUN-7C0049--start--
   LET g_sql = "imm01.imm_file.imm01,",
               "imm02.imm_file.imm02,",
               "imm04.imm_file.imm04,",
               "imn03.imn_file.imn03,",
               "imn09.imn_file.imn09,",
               "imn10.imn_file.imn10,",
               "l_str1.type_file.chr1000,",
               "imn15.imn_file.imn15,",
               "imn16.imn_file.imn16,",
               "imn17.imn_file.imn17,",
               "ima02.ima_file.ima02,",
               "imn20.imn_file.imn20,",
               "imn22.imn_file.imn22,",
               "l_str2.type_file.chr1000,",
               "imn04.imn_file.imn04,",
               "imn05.imn_file.imn05,",
               "imn06.imn_file.imn06,",
               "ima021.ima_file.ima021"
   LET l_table = cl_prt_temptable('aimr513',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF            
#No.FUN-7C0049--end
 
   LET g_pdate = ARG_VAL(1)                     # Get arguments from command line
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
  #TQC-610072-begin
  #LET tm.s    = ARG_VAL(8)   
  #LET tm.t    = ARG_VAL(9) 
   LET tm.a    = ARG_VAL(8)
  #LET tm.c    = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
  #TQC-610072-end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r513_tm(0,0)            # Input print condition
      ELSE CALL r513()          # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r513_tm(p_row,p_col)
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd         LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 6 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r513_w AT p_row,p_col
        WITH FORM "aim/42f/aimr513"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.a = '2'
   LET tm.c = 'Y'
   LET tm.s = '123'
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
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON imm01,imm02
    #--No.FUN-4A0049--------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
    ON ACTION CONTROLP
      CASE WHEN INFIELD(imm01) #調撥單號
             CALL cl_init_qry_var()
             LET g_qryparam.state= "c"
    	     LET g_qryparam.form = "q_imm104"
    	     CALL cl_create_qry() RETURNING g_qryparam.multiret
    	     DISPLAY g_qryparam.multiret TO imm01
    	     NEXT FIELD imm01
       OTHERWISE EXIT CASE
       END CASE
    #--END---------------
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r513_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.more
                WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES "[123]" OR tm.a IS NULL
            THEN NEXT FIELD a
         END IF
 
{      AFTER FIELD c
         IF tm.c NOT MATCHES'[YN]' OR tm.c IS NULL
         THEN NEXT FIELD c
         END IF
}
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW r513_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr513'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr513','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                        #" '",tm.s CLIPPED,"'",                 #TQC-610072
                        #" '",tm.t CLIPPED,"'",                 #TQC-610072
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr513',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r513_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r513()
   ERROR ""
END WHILE
   CLOSE WINDOW r513_w
END FUNCTION
 
FUNCTION r513()
   DEFINE l_name        LIKE type_file.chr20,    # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0074
          l_sql         STRING,                  # RDSQL STATEMENT   #TQC-630166
          l_za05        LIKE za_file.za05,       #No.FUN-690026 VARCHAR(40)
          sr            RECORD imm01 LIKE imm_file.imm01, #調撥單號
                               imm02 LIKE imm_file.imm02, #調撥日期
                               imm04 LIKE imm_file.imm04, #撥入確認
                               imn03 LIKE imn_file.imn03, #料件編號
                               imn04 LIKE imn_file.imn04, #撥出倉庫別
                               imn05 LIKE imn_file.imn05, #    存放位置
                               imn06 LIKE imn_file.imn06, #    批號
                               imn10 LIKE imn_file.imn10, #撥出數量
                               imn15 LIKE imn_file.imn15, #撥入倉庫
                               imn16 LIKE imn_file.imn16, #    存放位置
                               imn17 LIKE imn_file.imn17, #    批號
#No.FUN-560069 --start--
                               imn09 LIKE imn_file.imn09,
                               imn20 LIKE imn_file.imn20,
                               imn22 LIKE imn_file.imn22,
                               imn30 LIKE imn_file.imn30,
                               imn31 LIKE imn_file.imn31,
                               imn32 LIKE imn_file.imn32,
                               imn33 LIKE imn_file.imn33,
                               imn34 LIKE imn_file.imn34,
                               imn35 LIKE imn_file.imn35,
                               imn40 LIKE imn_file.imn40,
                               imn41 LIKE imn_file.imn41,
                               imn42 LIKE imn_file.imn42,
                               imn43 LIKE imn_file.imn43,
                               imn44 LIKE imn_file.imn44,
                               imn45 LIKE imn_file.imn45,
#No.FUN-560069 ---end--
                               ima02 LIKE ima_file.ima02, #品名規格
                               ima021 LIKE ima_file.ima021,
                               gen02 LIKE gen_file.gen02, #申請姓名
                               gem02 LIKE gem_file.gem02  #申請部門
                        END RECORD
     DEFINE l_i,l_cnt   LIKE type_file.num5      #No.FUN-580005  #No.FUN-690026 SMALLINT
     DEFINE l_zaa02     LIKE zaa_file.zaa02      #No.FUN-580005
 
#No.FUN-7C0049--start--  rep()提上來
     DEFINE l_str1        LIKE type_file.chr1000,                                             
            l_imn45       STRING,                                                                                    
            l_imn42       STRING                                                                                      
     DEFINE l_str2        LIKE type_file.chr1000,                                             
            l_imn35       STRING,                                                                                    
            l_imn32       STRING                                                                                     
     DEFINE l_ima906      LIKE ima_file.ima906
#No.FUN-7C0049--end
     CALL cl_del_data(l_table)              #No.FUN-7C0049
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr513'   #No.FUN-7C0049
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND immuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND immgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND immgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ",
                 "imm01, imm02, immconf, imn03, imn04, imn05, imn06, ", #MOD-840553  imm04->immconf
                 "imn10, imn15, imn16, imn17, imn09, imn20, imn22, ",  #No.FUN-580005
                 "imn30,imn31,imn32,imn33,imn34,imn35, ",  #No.FUN-560069
                 "imn40,imn41,imn42,imn43,imn44,imn45, ima02, ima021, gen02, gem02 ",   #No.FUN-560069
                 "FROM imm_file,imn_file, ima_file, ",
                 "      OUTER (gen_file,OUTER gem_file) ",
                 "WHERE imm01 = imn01 AND imm10 = '1' ",
                 "  AND imn03 = ima01 ",
                 "  AND imm_file.imm09 = gen_file.gen01 ",
                 "  AND gen_file.gen03 = gem_file.gem01 ",
                 "  AND ", tm.wc CLIPPED
 
     #01/08/24 mandy
    #---------------No.MOD-810120 modify
    #IF tm.a = '1' THEN
    #   LET l_sql = l_sql clipped," AND imm03 ='N'"
    #END IF
    #IF tm.a = '2' THEN
    #   LET l_sql = l_sql clipped," AND imm03 ='Y'"
    #END IF
    #IF tm.a = '3' THEN
    #   LET l_sql = l_sql clipped," AND imm03 !='X'"
    #END IF
 
     IF tm.a = '1' THEN
        LET l_sql = l_sql clipped," AND immconf ='N'"
     END IF
     IF tm.a = '2' THEN
        LET l_sql = l_sql clipped," AND immconf ='Y'"
     END IF
     IF tm.a = '3' THEN
        LET l_sql = l_sql clipped," AND immconf !='X'"
     END IF
    #---------------No.MOD-810120 end
     PREPARE r513_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE r513_cs CURSOR FOR r513_prepare
#    CALL cl_outnam('aimr513') RETURNING l_name     #No.FUN-7C0049
     #No.FUN-580005 --start--
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
     IF g_sma115 = "Y" THEN
       #LET g_zaa[47].zaa06 = "N"     #No.FUN-7C0049
       #LET g_zaa[50].zaa06 = "N"     #No.FUN-7C0049
       LET l_name = 'aimr513'         #No.FUN-7C0049
     ELSE
       #LET g_zaa[47].zaa06 = "Y"     #No.FUN-7C0049
       #LET g_zaa[50].zaa06 = "Y"     #No.FUN-7C0049
       LET l_name = 'aimr513_1'       #No.FUN-7C0049
     END IF
     CALL cl_prt_pos_len()
     #No.FUN-580005 --end--
 
    #START REPORT r513_rep TO l_name      #No.FUN-7C0049
 
    #LET g_pageno = 0                     #No.FUN-7C0049
     FOREACH r513_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#No.FUN-7C0049--start--  on every row 提上來
       SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01 = sr.imn03
       LET l_str1 = ""
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN
          IF NOT cl_null(sr.imn45) AND sr.imn45 <> 0 THEN
             CALL cl_remove_zero(sr.imn45) RETURNING l_imn45
             LET l_str1 = l_imn45, sr.imn43 CLIPPED
          END IF
          IF NOT cl_null(sr.imn35) AND sr.imn35 <> 0 THEN
             CALL cl_remove_zero(sr.imn35) RETURNING l_imn35
             LET l_str2 = l_imn35, sr.imn33 CLIPPED
          END IF
          IF l_ima906 = "2" THEN
             IF cl_null(sr.imn45) OR sr.imn45 = 0 THEN
                CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
                LET l_str1 = l_imn42, sr.imn40 CLIPPED
             ELSE
                IF NOT cl_null(sr.imn42) AND sr.imn42 <> 0 THEN
                   CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
                   LET l_str1 = l_str1 CLIPPED,',',l_imn42, sr.imn40 CLIPPED
                END IF
             END IF
             IF cl_null(sr.imn35) OR sr.imn35 = 0 THEN
                CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
                LET l_str2 = l_imn32, sr.imn30 CLIPPED
             ELSE
                IF NOT cl_null(sr.imn32) AND sr.imn32 <> 0 THEN
                   CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
                   LET l_str2 = l_str2 CLIPPED,',',l_imn32, sr.imn30 CLIPPED
                END IF
             END IF
          END IF
       END IF
       EXECUTE insert_prep USING
          sr.imm01,sr.imm02,sr.imm04,sr.imn03,sr.imn09,sr.imn10,l_str1,sr.imn15,
          sr.imn16,sr.imn17,sr.ima02,sr.imn20,sr.imn22,l_str2,sr.imn04,sr.imn05,
          sr.imn06,sr.ima021             
       #OUTPUT TO REPORT r513_rep(sr.*)
#No.FUN-7C0049--end
     END FOREACH
 
#No.FUN-7C0049--start--
     #FINISH REPORT r513_rep
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
    IF g_zz05 = 'Y' THEN 
       CALL cl_wcchp(tm.wc,'imm01,imm02')
            RETURNING tm.wc
    ELSE 
       LET tm.wc = ""
    END IF
    LET g_str = tm.wc
    CALL cl_prt_cs3('aimr513',l_name,g_sql,g_str)
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0049--end
END FUNCTION
 
#No.FUN-7C0049--start--
#REPORT r513_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          sr            RECORD imm01 LIKE imm_file.imm01, #調撥單號
#                               imm02 LIKE imm_file.imm02, #調撥日期
#                               imm04 LIKE imm_file.imm04, #撥入確認
#                               imn03 LIKE imn_file.imn03, #料件編號
#                               imn04 LIKE imn_file.imn04, #撥出倉庫別
#                               imn05 LIKE imn_file.imn05, #    存放位置
#                               imn06 LIKE imn_file.imn06, #    批號
#                               imn10 LIKE imn_file.imn10, #撥出數量
#                               imn15 LIKE imn_file.imn15, #撥入倉庫別
#                              imn16 LIKE imn_file.imn16, #    存放位置
#                              imn17 LIKE imn_file.imn17, #    批號
##No.FUN-560069 --start--
#                              imn09 LIKE imn_file.imn09,
#                              imn20 LIKE imn_file.imn20,
#                              imn22 LIKE imn_file.imn22,
#                              imn30 LIKE imn_file.imn30,
#                              imn31 LIKE imn_file.imn31,
#                              imn32 LIKE imn_file.imn32,
#                              imn33 LIKE imn_file.imn33,
#                              imn34 LIKE imn_file.imn34,
#                              imn35 LIKE imn_file.imn35,
#                              imn40 LIKE imn_file.imn40,
#                              imn41 LIKE imn_file.imn41,
#                              imn42 LIKE imn_file.imn42,
#                              imn43 LIKE imn_file.imn43,
#                              imn44 LIKE imn_file.imn44,
#                              imn45 LIKE imn_file.imn45,
##No.FUN-560069 ---end--
#                              ima02 LIKE ima_file.ima02, #品名規格
#                              ima021 LIKE ima_file.ima021, #品名規格
#                              gen02 LIKE gen_file.gen02, #申請姓名
#                              gem02 LIKE gem_file.gem02  #申請部門
#                       END RECORD
#  DEFINE l_str1        LIKE type_file.chr1000,#No.FUN-580005  #No.FUN-690026 VARCHAR(100)
#         l_imn45       STRING,    #No.FUN-580005
#         l_imn42       STRING     #No.FUN-580005
#  DEFINE l_str2        LIKE type_file.chr1000,#No.FUN-580005  #No.FUN-690026 VARCHAR(100)
#         l_imn35       STRING,    #No.FUN-580005
#         l_imn32       STRING     #No.FUN-580005
#  DEFINE l_ima906      LIKE ima_file.ima906           #FUN-580005
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT
#     PRINT g_dash[1,g_len]
##No.FUN-560069 --start--
##No.FUN-580005--begin
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[46],g_x[35],g_x[47],g_x[36],g_x[37],g_x[38]
#      PRINTX name=H2 g_x[39],g_x[40],g_x[48],g_x[49],g_x[50],g_x[41],g_x[42],g_x[43]
##No.FUN-560069 --end--
#     PRINTX name=H3 g_x[44],g_x[45]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.imm01
#     PRINTX name=D1 COLUMN g_c[31],sr.imm01,
#                    COLUMN g_c[32],sr.imm02,
#                    COLUMN g_c[33],sr.imm04;
 
#  ON EVERY ROW
#     SELECT ima906 INTO l_ima906 FROM ima_file
#                         WHERE ima01 = sr.imn03
#     LET l_str1 = ""
#     LET l_str2 = ""
#     IF g_sma115 = "Y" THEN
#        IF NOT cl_null(sr.imn45) AND sr.imn45 <> 0 THEN
#           CALL cl_remove_zero(sr.imn45) RETURNING l_imn45
#           LET l_str1 = l_imn45, sr.imn43 CLIPPED
#        END IF
#        IF NOT cl_null(sr.imn35) AND sr.imn35 <> 0 THEN
#           CALL cl_remove_zero(sr.imn35) RETURNING l_imn35
#           LET l_str2 = l_imn35, sr.imn33 CLIPPED
#        END IF
#        IF l_ima906 = "2" THEN
#           IF cl_null(sr.imn45) OR sr.imn45 = 0 THEN
#              CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
#              LET l_str1 = l_imn42, sr.imn40 CLIPPED
#           ELSE
#              IF NOT cl_null(sr.imn42) AND sr.imn42 <> 0 THEN
#                 CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
#                 LET l_str1 = l_str1 CLIPPED,',',l_imn42, sr.imn40 CLIPPED
#              END IF
#           END IF
#           IF cl_null(sr.imn35) OR sr.imn35 = 0 THEN
#              CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
#              LET l_str2 = l_imn32, sr.imn30 CLIPPED
#           ELSE
#              IF NOT cl_null(sr.imn32) AND sr.imn32 <> 0 THEN
#                 CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
#                 LET l_str2 = l_str2 CLIPPED,',',l_imn32, sr.imn30 CLIPPED
#              END IF
#           END IF
#        END IF
#     END IF
##No.FUN-560069 --start--
#     PRINTX name=D1 COLUMN g_c[34],sr.imn03 CLIPPED, #FUN-5B0014 [1,20] CLIPPED,
#                    COLUMN g_c[46],sr.imn09 CLIPPED,
#                    COLUMN g_c[35],cl_numfor(sr.imn10,35,3),
#                    COLUMN g_c[47],l_str1 CLIPPED,
#                   #MOD-6C0054-begin
#                   #COLUMN g_c[36],sr.imn04 CLIPPED, 
#                   #COLUMN g_c[37],sr.imn05 CLIPPED,
#                   #COLUMN g_c[38],sr.imn06 CLIPPED
#                    COLUMN g_c[36],sr.imn15 CLIPPED, 
#                    COLUMN g_c[37],sr.imn16 CLIPPED,
#                    COLUMN g_c[38],sr.imn17 CLIPPED
#                   #MOD-6C0054-end
#     PRINTX name=D2 COLUMN g_c[39],' ',
#                    COLUMN g_c[40],sr.ima02 CLIPPED,
#                    COLUMN g_c[48],sr.imn20 CLIPPED,
#                    COLUMN g_c[49],cl_numfor(sr.imn22,49,3),
#                    COLUMN g_c[50],l_str2 CLIPPED,
#                   #MOD-6C0054-begin
#                   #COLUMN g_c[41],sr.imn15 CLIPPED,
#                   #COLUMN g_c[42],sr.imn16 CLIPPED,
#                   #COLUMN g_c[43],sr.imn17 CLIPPED
#                    COLUMN g_c[41],sr.imn04 CLIPPED,
#                    COLUMN g_c[42],sr.imn05 CLIPPED,
#                    COLUMN g_c[43],sr.imn06 CLIPPED
#                   #MOD-6C0054-end
##No.FUN-580005--end
##No.FUN-560069 ---end--
#     PRINTX name=D3 COLUMN g_c[44],' ',
#                    COLUMN g_c[45],sr.ima021
#     PRINT
 
#ON LAST ROW
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#     THEN
#        CALL cl_wcchp(tm.wc,'imm01,imm02,imm09,imn03,imn04,imn15')
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#      #TQC-630166
#      #       IF tm.wc[001,120] > ' ' THEN                      # for 132
#      #          PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#      #       IF tm.wc[121,240] > ' ' THEN
#      #          PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#      #       IF tm.wc[241,300] > ' ' THEN
#      #          PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#      CALL cl_prt_pos_wc(tm.wc)
#      #END TQC-630166
 
#     END IF
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#   IF l_last_sw = 'n'
#       THEN PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE SKIP 2 LINES
#    END IF
#END REPORT
#No.FUN-7C0049--end
