# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr620.4gl
# Descriptions...: 庫存週轉率分析表
# Date & Author..: 95/02/08 By Jackson
#                  By Melody    若週轉次數>=sma68 則 show '快速'
#                               若週轉次數<sma69 則 show '慢速' else '平速'
# Modify ........: No.MOD-480140 04/08/12 By Nicola 輸入順序錯誤
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-5A0328 05/10/21 By Sarah 將MARK還原(原本mandy test mark)
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序
# Modify.........: NO.MOD-720046 07/03/14 By TSD.miki 報表改寫由Crystal Report
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-760140 07/06/15 By Sarah 執行報表後出現"A report output file cannot be opened."錯誤訊息
# Modify.........: No.TQC-740065 07/07/20 By jamie 程式已轉成用Crystal Report方式出報表，程式裡面不應取zaa的資料(以後zaa將不再用)，應將其修正
# Modify.........: No.FUN-710073 07/11/30 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-850132 08/05/22 By Baofei CR BUG 處理
# Modify.........: No.FUN-840194 08/06/23 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.MOD-8A0228 08/10/24 By sherry 程序使用l_imk09之前沒有賦初值，導致在foreach里面執行的時候會保留上次的值
# Modify.........: No.MOD-940043 09/05/25 By Pengu 在取工單領料及銷貨數量時應乘上負號，不然週轉次數為負
# Modify.........: No.MOD-970243 09/07/27 By lilingyu 平均庫存不需要除以周期
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No:MOD-A80078 10/08/31 By sabrina imk083，imk082應乘上(-1)，不然報表印出會有問題
# Modify.........: No:CHI-AB0014 10/12/22 By Summer 報表改寫,將那些要隱藏的資料,直接就不寫入CR Temptable裡
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.TQC-C30291 12/03/23 By destiny 判断是否为快速移动料件的条件改为sma68
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,                 # Where Condition  #TQC-630166
           wc1     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
           yy1     LIKE type_file.num10,   #No.FUN-690026 INTEGER
           yy2     LIKE type_file.num10,   #No.FUN-690026 INTEGER
           m1      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           m2      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           d       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           e       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           f       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           s       LIKE type_file.chr2,    #No.FUN-690026 VARCHAR(02)
           t       LIKE type_file.chr2,    #No.FUN-690026 VARCHAR(02)
           u       LIKE type_file.chr2,    #No.FUN-690026 VARCHAR(02)
           choice  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           more    LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
           END RECORD,
       g_during    LIKE type_file.num5,                #共幾期  #No.FUN-690026 SMALLINT
       g_durday    LIKE type_file.num5,                #共幾天(工作天)  #No.FUN-690026 SMALLINT
       g_order1    LIKE ima_file.ima01,  #No.FUN-690026 VARCHAR(40)
       g_order2    LIKE ima_file.ima01   #No.FUN-690026 VARCHAR(40)
 
DEFINE g_i         LIKE type_file.num5,     #count/index for any purpose  #No.FUN-690026 SMALLINT
       l_orderA    ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088  
DEFINE l_table     STRING
DEFINE l_table_tmp STRING #CHI-AB0014 add
DEFINE g_sql       STRING
DEFINE g_str       STRING
DEFINE g_tot       ARRAY[13] OF LIKE cae_file.cae07
DEFINE g_zaa04_value  LIKE zaa_file.zaa04   #FUN-710080 add
DEFINE g_zaa10_value  LIKE zaa_file.zaa10   #FUN-710080 add
DEFINE g_zaa11_value  LIKE zaa_file.zaa11   #FUN-710080 add
DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-710080 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
#CHI-AB0014 mark --start--
#  LET g_sql = "order1.ima_file.ima01,",
#             "order2.ima_file.ima01,",
#             "ima01.ima_file.ima01,", 
#             "ima02.ima_file.ima02,", 
#             "ima08.ima_file.ima08,",
#             "ima07.ima_file.ima07,", 
#             "ima06.ima_file.ima06,", 
#             "ima25.ima_file.ima25,",
#             "ima27.ima_file.ima27,", 
#             "imk082.imk_file.imk082,", 
#             "imk083.imk_file.imk083,",      
#             "imk09.imk_file.imk09,", 
#             "act.imb_file.imb118,",
#             "sumima1.ima_file.ima59,",
#             "sumima2.ima_file.ima59,",
#             "ima60.ima_file.ima60,",
#             "ima021.ima_file.ima021"
#CHI-AB0014 mark --end--
#CHI-AB0014 add --start--
   LET g_sql = "order1.ima_file.ima01,",
               "order2.ima_file.ima01,",
               "ima01.ima_file.ima01,", 
               "ima02.ima_file.ima02,", 
               "ima021.ima_file.ima021,",
               "ima08.ima_file.ima08,",
               "ima07.ima_file.ima07,", 
               "ima06.ima_file.ima06,", 
               "ima25.ima_file.ima25,",
               "ima27.ima_file.ima27,", 
               "l_2.imk_file.imk083,",
               "l_3.imk_file.imk083,",
               "l_4.imk_file.imk083,",
               "l_5.imk_file.imk083,",
               "l_6.imk_file.imk083,",
               "l_7.imk_file.imk083,",
               "l_8.imk_file.imk083,",
               "l_9.imk_file.imk083,",
               "l_10.imk_file.imk083,",
               "l_11.imk_file.imk083"
#CHI-AB0014 add --end--
   LET l_table = cl_prt_temptable('axmr620',g_sql) CLIPPED   # 產生Temp Table
   IF l_table  = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生
#CHI-AB0014 mark --start--
#  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
#              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                     
#              "        ?,?)"
#  PREPARE insert_prep FROM g_sql
#  IF STATUS THEN
#     CALL cl_err('insert_prep:',status,1)
#     EXIT PROGRAM
#  END IF
#CHI-AB0014 mark --end--

#CHI-AB0014 add --start--
   LET g_sql = "ima01.ima_file.ima01,", #料
               "ima02.ima_file.ima02,", 
               "ima021.ima_file.ima021,",
               "ima08.ima_file.ima08,", #來源
               "ima07.ima_file.ima07,", #ABC
               "ima06.ima_file.ima06,", #分群
               "ima25.ima_file.ima25,", #單位
               "ima27.ima_file.ima27,", #發料安全存量
               "ima09.ima_file.ima09,", 
               "ima10.ima_file.ima10,",
               "ima11.ima_file.ima11,",
               "ima12.ima_file.ima12,",
               "imk02.imk_file.imk02,",
               "imk05.imk_file.imk05,",
               "imk06.imk_file.imk06,",
               "imk082.imk_file.imk082,",
               "imk083.imk_file.imk083,",
               "imk09.imk_file.imk09,", 
               "imk03.imk_file.imk03,",
               "imk04.imk_file.imk04,",
               "ima48.ima_file.ima48,",
               "ima59.ima_file.ima59,",
               "ima60.ima_file.ima60,",
               "ima601.ima_file.ima601,",
               "img09.img_file.img09"
   LET l_table_tmp = cl_prt_temptable('axmr620_tmp',g_sql) CLIPPED   # 產生Temp Table
   IF l_table_tmp  = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生
#CHI-AB0014 add --end--
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.wc1 = ARG_VAL(8)
   LET tm.yy1 = ARG_VAL(9)
   LET tm.yy2 = ARG_VAL(10)
   LET tm.m1  = ARG_VAL(11)
   LET tm.m2  = ARG_VAL(12)
   LET tm.d  = ARG_VAL(13)
   LET tm.e  = ARG_VAL(14)
   LET tm.f  = ARG_VAL(15)
   LET tm.s  = ARG_VAL(16)
   LET tm.t  = ARG_VAL(17)
   LET tm.u  = ARG_VAL(18)
   LET tm.choice  = ARG_VAL(19)
   LET g_rep_user = ARG_VAL(20)
   LET g_rep_clas = ARG_VAL(21)
   LET g_template = ARG_VAL(22)
   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r620_tm(0,0)
      ELSE CALL r620()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION r620_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 1 LET p_col = 13
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW r620_w AT p_row,p_col
        WITH FORM "aim/42f/aimr620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy1= YEAR(g_today)
   LET tm.yy2= YEAR(g_today)
   LET tm.m1 = MONTH(g_today)
   LET tm.m2 = MONTH(g_today)
   LET tm.d='1'
   LET tm.e='N'
   LET tm.f=3
   LET tm.s= '23'
   LET tm.t= 'YY'
   LET tm.u= 'YY'
   LET tm.choice = 0
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON imk01,ima06,ima09,ima10,ima11,ima12,ima08
 
      ON ACTION controlp
            IF INFIELD(imk01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imk01
               NEXT FIELD imk01
            END IF
 
      ON ACTION locale
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
 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
      IF INT_FLAG THEN LET INT_FLAG = 0
         CLOSE WINDOW r620_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
         EXIT PROGRAM
            
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   CONSTRUCT BY NAME tm.wc1 ON imk02
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
   END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 END IF

   INPUT BY NAME tm.yy1,tm.m1,tm.yy2,tm.m2,
                 tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm2.u1,tm2.u2,
                  tm.d,tm.choice,tm.e,tm.f,tm.more WITHOUT DEFAULTS   #No.MOD-480140
      AFTER FIELD yy1
         IF cl_null(tm.yy1) THEN NEXT FIELD yy1 END IF
         IF tm.yy1 <1900 THEN
            NEXT FIELD yy1
         END IF
      AFTER FIELD m1
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy1
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
         IF cl_null(tm.m1) THEN NEXT FIELD m1 END IF
      AFTER FIELD yy2
         IF cl_null(tm.yy2) THEN NEXT FIELD yy2 END IF
         IF tm.yy2 < tm.yy1 THEN
            NEXT FIELD yy2
         END IF
      AFTER FIELD m2
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy2
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
         IF cl_null(tm.m2) THEN NEXT FIELD m2 END IF
         IF tm.yy1=tm.yy2 AND tm.m2<tm.m1 THEN NEXT FIELD m2 END IF
      AFTER FIELD d
         IF cl_null(tm.d) THEN NEXT FIELD d END IF
         IF tm.d NOT MATCHES "[1-3]" THEN NEXT FIELD d END IF
      AFTER FIELD e
         IF cl_null(tm.e) THEN NEXT FIELD e END IF
         IF tm.e NOT MATCHES "[YyNn]" THEN NEXT FIELD e END IF
      AFTER FIELD f
         IF cl_null(tm.f) THEN LET tm.f=0 END IF
      AFTER FIELD choice
         IF cl_null(tm.choice) THEN NEXT FIELD choice END IF
         IF tm.choice NOT MATCHES "[0-4]" THEN
            NEXT FIELD choice
         END IF
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
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
         LET tm.u = tm2.u1,tm2.u2
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aimr620'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr620','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.wc1 CLIPPED,"'",
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.yy2 CLIPPED,"'",
                         " '",tm.m1 CLIPPED,"'",
                         " '",tm.m2 CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.f CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.choice CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr620',g_time,l_cmd)
      END IF
      CLOSE WINDOW r620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r620()
   ERROR ""
END WHILE
   CLOSE WINDOW r620_w
END FUNCTION
 
#CHI-AB0014 add --start--
FUNCTION r620()
   DEFINE l_name    LIKE type_file.chr20,            # External(Disk) file name  
          l_sql     STRING,                          # RDSQL STATEMENT  
          l_cmd     STRING,                        
          l_i       LIKE type_file.num5,         
          l_order   ARRAY[3] OF LIKE ima_file.ima01, 
          l_imk05   LIKE imk_file.imk05,    #年 (上期)
          l_imk06   LIKE imk_file.imk06,    #期 (上期)
          l_imk09   LIKE imk_file.imk09,    #   (上期)
          l_bdate1  LIKE type_file.dat,     
          l_edate1  LIKE type_file.dat,    
          l_bdate2  LIKE type_file.dat,   
          l_edate2  LIKE type_file.dat,  
          sr        RECORD ima01   LIKE ima_file.ima01, #料
                           ima02   LIKE ima_file.ima02, 
                           ima021  LIKE ima_file.ima021,
                           ima08   LIKE ima_file.ima08, #來源
                           ima07   LIKE ima_file.ima07, #ABC
                           ima06   LIKE ima_file.ima06, #分群
                           ima25   LIKE ima_file.ima25, #單位
                           ima27   LIKE ima_file.ima27, #發料安全存量
                           ima09   LIKE ima_file.ima09, 
                           ima10   LIKE ima_file.ima10,
                           ima11   LIKE ima_file.ima11,
                           ima12   LIKE ima_file.ima12,
                           imk02   LIKE imk_file.imk02,
                           imk05   LIKE imk_file.imk05,
                           imk06   LIKE imk_file.imk06,
                           imk082  LIKE imk_file.imk082,
                           imk083  LIKE imk_file.imk083,
                           imk09   LIKE imk_file.imk09,
                           imk03   LIKE imk_file.imk03,
                           imk04   LIKE imk_file.imk04,
                           ima48   LIKE ima_file.ima48,
                           ima59   LIKE ima_file.ima59,
                           ima60   LIKE ima_file.ima60,
                           ima601  LIKE ima_file.ima601,
                           img09   LIKE img_file.img09
                    END RECORD,
          sr2       RECORD ima01   LIKE ima_file.ima01, #料
                           ima02   LIKE ima_file.ima02, 
                           ima021  LIKE ima_file.ima021,
                           ima08   LIKE ima_file.ima08, #來源
                           ima07   LIKE ima_file.ima07, #ABC
                           ima06   LIKE ima_file.ima06, #分群
                           ima25   LIKE ima_file.ima25, #單位
                           ima27   LIKE ima_file.ima27, #發料安全存量
                           ima09   LIKE ima_file.ima09, 
                           ima10   LIKE ima_file.ima10,
                           ima11   LIKE ima_file.ima11,
                           ima12   LIKE ima_file.ima12,
                           ima48   LIKE ima_file.ima48,
                           ima59   LIKE ima_file.ima59,
                           ima60   LIKE ima_file.ima60 
                    END RECORD,
          l_img2ima_fac  LIKE ima_file.ima31_fac, 
          l_ima01_o      LIKE ima_file.ima01,
          l_sql_tmp      STRING,            
          l_ym           STRING,            
          l_2,l_3,l_4,l_5,l_11 LIKE imk_file.imk083,
          l_6                  LIKE imk_file.imk083,
          l_7,l_8,l_9,l_10     LIKE imk_file.imk083, 
          l_act                LIKE imb_file.imb118,#成本 
          l_sumima1            LIKE ima_file.ima59, 
          l_sumima2            LIKE ima_file.ima59  

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table_tmp) 

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",                     
                 "        ?,?,?,?,?)"
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
        EXIT PROGRAM
     END IF

     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

     ###計算幾期
     IF tm.yy1=tm.yy2 THEN   ###同年
        LET g_during=(tm.m2-tm.m1)+1
     ELSE                    ###跨 ? 年
        LET g_during=tm.m2+(12-tm.m1)+1+(tm.yy2-tm.yy1-1)*12
     END IF
     IF cl_null(g_during) THEN LET g_during=1 END IF
     ###計算天數
     CALL s_azn01(tm.yy1,tm.m1) RETURNING l_bdate1,l_edate1
     CALL s_azn01(tm.yy2,tm.m2) RETURNING l_bdate2,l_edate2
     SELECT COUNT(*) INTO g_durday FROM sme_file
      WHERE sme01 BETWEEN l_bdate1 AND l_edate2
        AND sme02='Y'
     IF cl_null(g_durday) THEN LET g_durday=1 END IF

     LET l_sql_tmp = "INSERT INTO ",g_cr_db_str CLIPPED,l_table_tmp CLIPPED,
                     " SELECT ima01,ima02,ima021,ima08,ima07,ima06,ima25, ", 
                     "        ima27,ima09,ima10,ima11,ima12, ",
                     "        imk02,imk05,imk06,imk082,imk083,imk09, ",
                     "        imk03,imk04,(ima48+ima49+ima491+ima50) , ",
                     "        (ima59+ima61) ,ima60,ima601 ,img09 ",
                     "   FROM ima_file,imk_file,img_file ",
                     "  WHERE ima01=imk01 ", 
                     "    AND img01=imk01 ",
                     "    AND img02=imk02 ",
                     "    AND img03=imk03 ",
                     "    AND img04=imk04 ", 
                     "    AND ((imk05 = ",tm.yy1," AND imk06>= ",tm.m1,")",
                     "     OR imk05 > ",tm.yy1,")",
                     "    AND ((imk05 = ",tm.yy2," AND imk06<= ",tm.m2,")",
                     "     OR imk05 < ",tm.yy2,")",
                     "    AND ima08 IN ('P','V','Z','M','S','U','T') ",
                     "    AND ",tm.wc CLIPPED,
                     "    AND ",tm.wc1 CLIPPED 
     PREPARE r620_temp FROM l_sql_tmp 
     EXECUTE r620_temp

     LET l_sql = "SELECT * ",
                 "  FROM ",g_cr_db_str CLIPPED,l_table_tmp CLIPPED 
     PREPARE r620_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE r620_cs1 CURSOR FOR r620_pr1

     LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table_tmp CLIPPED,
                 "   SET imk082=?, imk083=?, imk09=?, ima60=? ",
                 " WHERE ima01=? ",
                 "   AND imk02=? ",
                 "   AND imk03=? ",
                 "   AND imk04=? ",
                 "   AND imk05=? ",
                 "   AND imk06=? "
     PREPARE update_prep FROM l_sql
     IF STATUS THEN
        CALL cl_err('update_prep:',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
        EXIT PROGRAM
     END IF

     LET l_sql = "SELECT DISTINCT ima01,ima02,ima021,ima08,ima07,ima06,ima25, ", 
                 "       ima27,ima09,ima10,ima11,ima12,ima48,ima59,ima60 ",
                 "  FROM ",g_cr_db_str CLIPPED,l_table_tmp CLIPPED 
     PREPARE r620_pr2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE r620_cs2 CURSOR FOR r620_pr2

   LET l_sql = " SELECT SUM(imk082+imk083) ", 
               "   FROM ",g_cr_db_str CLIPPED,l_table_tmp CLIPPED,
               "  WHERE ima01 =? "
   PREPARE r620_pr3 FROM l_sql
   DECLARE r620_cs3 CURSOR FROM l_sql

   LET l_sql = " SELECT SUM(imk09) ", 
               "   FROM ",g_cr_db_str CLIPPED,l_table_tmp CLIPPED,
               "  WHERE ima01 =? "
   PREPARE r620_pr4 FROM l_sql
   DECLARE r620_cs4 CURSOR FROM l_sql

     LET l_name='aimr620.01r'                     #TQC-740065 add
     LET g_pageno = 0

     LET g_success = 'Y'
     FOREACH r620_cs1 INTO sr.* 
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
        END IF

        IF sr.img09<>sr.ima25 THEN
           CALL s_umfchk(sr.ima01,sr.img09,sr.ima25)
                RETURNING g_i,l_img2ima_fac
           IF g_i = 1 THEN
              IF l_ima01_o <> sr.ima01 THEN
                 CALL cl_err(sr.ima01,'mfg3075',1)
                 LET l_ima01_o = sr.ima01
              END IF
              CONTINUE FOREACH
           END IF
           LET sr.imk082=sr.imk082 * l_img2ima_fac        #MOD-A80078 add
           LET sr.imk083=sr.imk083 * l_img2ima_fac        #MOD-A80078 add
           LET sr.imk09 =sr.imk09  * l_img2ima_fac
        END IF
        IF cl_null(sr.imk082) THEN LET sr.imk082 = 0 END IF
        IF cl_null(sr.imk083) THEN LET sr.imk083 = 0 END IF
        LET sr.imk082=sr.imk082 * -1                   #MOD-A80078 add 
        LET sr.imk083=sr.imk083 * -1                   #MOD-A80078 add  
        IF cl_null(sr.imk09) THEN LET sr.imk09 = 0 END IF
        IF NOT(cl_null(sr.imk05) AND cl_null(sr.imk06)) THEN
           IF sr.imk06=1 THEN LET l_imk05=sr.imk05-1 LET l_imk06=12
           ELSE LET l_imk05=sr.imk05 LET l_imk06=sr.imk06-1 END IF
           LET l_imk09 = ''   #No:MOD-8A0228 add 
           SELECT imk09 INTO l_imk09 FROM imk_file
            WHERE imk01=sr.ima01 AND imk02=sr.imk02 AND imk03=sr.imk03
              AND imk04=sr.imk04 AND imk05=l_imk05 AND imk06=l_imk06
           IF NOT cl_null(l_imk09) THEN
              LET sr.imk09=(sr.imk09+l_imk09)/2
           END IF
        END IF

        IF sr.ima601 != 0 THEN
           LET sr.ima60 = sr.ima60/sr.ima601
        END IF

        EXECUTE update_prep USING sr.imk082, sr.imk083, sr.imk09, sr.ima60,
                                  sr.ima01,  sr.imk02,  sr.imk03,
                                  sr.imk04,  sr.imk05,  sr.imk06
     END FOREACH 

     IF g_success = 'Y' THEN
        FOREACH r620_cs2 INTO sr2.* 
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF

           LET l_act = 0
           LET l_sumima1 = sr2.ima48
           LET l_sumima2 = sr2.ima59 

           OPEN r620_cs3 USING sr2.ima01
           FETCH r620_cs3 INTO l_2
           IF cl_null(l_2) THEN LET l_2=0 END IF

           OPEN r620_cs4 USING sr2.ima01
           FETCH r620_cs4 INTO l_3
           IF cl_null(l_3) THEN LET l_3=0 END IF

           #成本
           CALL s_untcst(tm.d,sr2.ima01,'N') RETURNING l_i,l_act

           LET l_4=l_2*l_act
           IF cl_null(l_4) THEN LET l_4=0 END IF

           LET l_5=l_3*l_act
           IF cl_null(l_5) THEN LET l_5=0 END IF

           IF l_5=0 THEN LET l_6=l_4 ELSE LET l_6=l_4/l_5 END IF
           IF l_4=0 THEN 
              LET l_7=l_5/g_durday
           ELSE 
              LET l_7=(l_5/l_4)/g_durday 
           END IF
           IF l_2=0 THEN 
              LET l_8=sr2.ima27/g_durday
           ELSE 
              LET l_8=(sr2.ima27/l_2)/g_durday 
           END IF
           IF sr2.ima08 MATCHES '[PVZ]' THEN 
              LET l_9=l_sumima1
           ELSE 
              LET l_9=l_sumima2+sr2.ima60*l_3 
           END IF   
           IF cl_null(l_6) THEN LET l_6=0 END IF
           IF cl_null(l_7) THEN LET l_7=0 END IF
           IF cl_null(l_8) THEN LET l_8=0 END IF
           IF cl_null(l_9) THEN LET l_9=0 END IF

           LET l_10=l_7-(l_8+l_9)
           LET l_11=l_10*(l_2/g_durday)*l_act
           IF cl_null(l_10) THEN LET l_10=0 END IF
           IF cl_null(l_11) THEN LET l_11=0 END IF

           IF l_7 >= tm.f THEN
                 ###排序
                 FOR g_i = 1 TO 2
                     CASE WHEN tm.s[g_i,g_i] = '1'  LET l_order[g_i] = sr2.ima01
                          WHEN tm.s[g_i,g_i] = '2' 
                               CASE
                                   WHEN tm.choice ='0' LET l_order[g_i] = sr2.ima06
   	          	              WHEN tm.choice ='1' LET l_order[g_i] = sr2.ima09
       	                  	      WHEN tm.choice ='2' LET l_order[g_i] = sr2.ima10
   	        	              WHEN tm.choice ='3' LET l_order[g_i] = sr2.ima11
   	                	      WHEN tm.choice ='4' LET l_order[g_i] = sr2.ima12
                               END CASE
                          WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr2.ima08
                          OTHERWISE LET l_order[g_i]  = '-'
                     END CASE
                 END FOR
                 EXECUTE insert_prep USING l_order[1],l_order[2],sr2.ima01,sr2.ima02,sr2.ima021,
                                           sr2.ima08,sr2.ima07,sr2.ima06,sr2.ima25,sr2.ima27,
                                           l_2,l_3,l_4,l_5,l_6,
                                           l_7,l_8,l_9,l_10,l_11
           END IF 
        END FOREACH
     END IF

     LET l_cmd = 'rm -f ',l_name CLIPPED,'*'   #TQC-760140 add
     RUN l_cmd                                 #TQC-760140 add

    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)

     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_str = NULL
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'imk01,ima06,ima09,ima10,ima11,ima12,ima08,imk02')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF

     LET l_ym = tm.yy1 CLIPPED,'/',tm.m1 CLIPPED,'-',tm.yy2 CLIPPED,'/',tm.m2 CLIPPED
     LET l_ym =cl_replace_str(l_ym, " ", "")
     LET g_str = tm.wc,";",l_ym,";",tm.wc1,";",
                 tm.s[1,1],";",tm.s[2,2],";",   #排序
                 tm.t[1,1],";",tm.t[2,2],";",   #跳頁
                 tm.u[1,1],";",tm.u[2,2],";",   #小計
                 #g_durday,";",tm.e                     #TQC-C30291 
                 g_sma.sma68,";",tm.e,";",g_sma.sma69   #TQC-C30291   
     CALL cl_prt_cs3('aimr620','aimr620',l_sql,g_str)   #FUN-710080 modify
END FUNCTION
#CHI-AB0014 add --end--

#CHI-AB0014 mark --start--
#FUNCTION r620()
#   DEFINE l_name    LIKE type_file.chr20,            # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#          l_sql     STRING,                          # RDSQL STATEMENT     #TQC-630166
#          l_cmd     STRING,                          #TQC-760140 add
#          l_chr     LIKE type_file.chr1,             #No.FUN-690026 VARCHAR(1)
#          l_za05    LIKE za_file.za05,               #No.FUN-690026 VARCHAR(40)
#          l_i       LIKE type_file.num5,             #No.FUN-690026 SMALLINT
#          l_order   ARRAY[3] OF LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#          l_imk05   LIKE imk_file.imk05,    #年 (上期)
#          l_imk06   LIKE imk_file.imk06,    #期 (上期)
#          l_imk09   LIKE imk_file.imk09,    #   (上期)
#          l_bdate1  LIKE type_file.dat,     #No.FUN-690026 DATE
#          l_edate1  LIKE type_file.dat,     #No.FUN-690026 DATE
#          l_bdate2  LIKE type_file.dat,     #No.FUN-690026 DATE
#          l_edate2  LIKE type_file.dat,     #No.FUN-690026 DATE
#          sr        RECORD order1  LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                           order2  LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                           ima01   LIKE ima_file.ima01, #料
#                           ima02   LIKE ima_file.ima02, #FUN-510017
#                           ima021  LIKE ima_file.ima021,#FUN-510017
#                           ima08   LIKE ima_file.ima08, #來源
#                           ima06   LIKE ima_file.ima06, #分群
#                           ima07   LIKE ima_file.ima07, #ABC
#                           ima25   LIKE ima_file.ima25, #單位
#                           ima27   LIKE ima_file.ima27, #發料安全存量
#                           ima09   LIKE ima_file.ima09, #分群(一)
#                           ima10   LIKE ima_file.ima10, #分群(二)
#                           ima11   LIKE ima_file.ima11, #分群(三)
#                           ima12   LIKE ima_file.ima12, #分群(四)
#                           imk02   LIKE imk_file.imk02, #倉
#                           imk05   LIKE imk_file.imk05, #年
#                           imk06   LIKE imk_file.imk06, #期
#                           imk082  LIKE imk_file.imk082,#出庫
#                           imk083  LIKE imk_file.imk083,#銷售
#                           imk09   LIKE imk_file.imk09, #期末
#                           imk03   LIKE imk_file.imk03, #儲
#                           imk04   LIKE imk_file.imk04, #批
#                           act     LIKE imb_file.imb118,#成本 #MOD-530179
#                           sumima1 LIKE ima_file.ima59, #No.FUN-690026 DECIMAL(8,2)
#                           sumima2 LIKE ima_file.ima59, #No.FUN-690026 DECIMAL(8,2)
#                           ima60   LIKE ima_file.ima60
#                    END RECORD,
#          l_img09        LIKE img_file.img09,
#          l_img2ima_fac  LIKE ima_file.ima31_fac #MOD-530179
# 
#     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
# 
#     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>
#     CALL cl_del_data(l_table)
#     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
# 
#     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
# 
#     ###計算幾期
#     IF tm.yy1=tm.yy2 THEN   ###同年
#        LET g_during=(tm.m2-tm.m1)+1
#     ELSE                    ###跨 ? 年
#        LET g_during=tm.m2+(12-tm.m1)+1+(tm.yy2-tm.yy1-1)*12
#     END IF
#     IF cl_null(g_during) THEN LET g_during=1 END IF
#     ###計算天數
#     CALL s_azn01(tm.yy1,tm.m1) RETURNING l_bdate1,l_edate1
#     CALL s_azn01(tm.yy2,tm.m2) RETURNING l_bdate2,l_edate2
#     SELECT COUNT(*) INTO g_durday FROM sme_file
#      WHERE sme01 BETWEEN l_bdate1 AND l_edate2
#        AND sme02='Y'
#     IF cl_null(g_durday) THEN LET g_durday=1 END IF
# 
#     LET l_sql = " SELECT ' ',' ',ima01,ima02,ima021,ima08,ima06,ima07,ima25, ", #FUN-510017 add ima02,ima021
#                 "        ima27,ima09,ima10,ima11,ima12, ",
#                 "        imk02,imk05,imk06,imk082,imk083,imk09, ",
#                 "        imk03,imk04,0,(ima48+ima49+ima491+ima50), ",
#                 "        (ima59+ima61),(ima60/ima601),img09 ",#No.FUN-840194 #CHI-810015 mod  #FUN-710073 add ima56
#                 "   FROM ima_file,imk_file,img_file ",
#                 "  WHERE ima01=imk01 AND ",tm.wc CLIPPED,
#                 "    AND ",tm.wc1 CLIPPED,
#                 "    AND ((imk05 = ",tm.yy1," AND imk06>= ",tm.m1,")",
#                 "     OR imk05 > ",tm.yy1,")",
#                 "    AND ((imk05 = ",tm.yy2," AND imk06<= ",tm.m2,")",
#                 "     OR imk05 < ",tm.yy2,")",
#                 "    AND ima08 IN ('P','V','Z','M','S','U','T') ",
#                 "    AND img01=imk01 ",
#                 "    AND img02=imk02 ",
#                 "    AND img03=imk03 ",
#                 "    AND img04=imk04 "
# 
#     PREPARE r620_pr1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('prepare:',SQLCA.sqlcode,1)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
#        EXIT PROGRAM
#     END IF
#     DECLARE r620_cs1 CURSOR FOR r620_pr1
#     LET l_name='aimr620.01r'                     #TQC-740065 add
#     LET g_pageno = 0
#     FOREACH r620_cs1 INTO sr.*,l_img09
#          IF SQLCA.sqlcode != 0 THEN
#             CALL cl_err('foreach:',SQLCA.sqlcode,1)
#             EXIT FOREACH
#          END IF
#       IF l_img09<>sr.ima25
#          THEN
#          CALL s_umfchk(sr.ima01,l_img09,sr.ima25)
#               RETURNING g_i,l_img2ima_fac
#          IF g_i = 1 THEN
#             CALL cl_err(sr.ima01,'mfg3075',1)
#             EXIT FOREACH
#          END IF
#         #LET sr.imk082=sr.imk082 * l_img2ima_fac * -1    #No.MOD-940043 add * -1    #MOD-A80078 mark  
#         #LET sr.imk083=sr.imk083 * l_img2ima_fac * -1    #No.MOD-940043 add * -1    #MOD-A80078 mark  
#          LET sr.imk082=sr.imk082 * l_img2ima_fac         #MOD-A80078 add
#          LET sr.imk083=sr.imk083 * l_img2ima_fac         #MOD-A80078 add
#          LET sr.imk09 =sr.imk09  * l_img2ima_fac
#       END IF
#          IF cl_null(sr.imk082) THEN LET sr.imk082 = 0 END IF
#          IF cl_null(sr.imk083) THEN LET sr.imk083 = 0 END IF
#          LET sr.imk082=sr.imk082 * -1                   #MOD-A80078 add 
#          LET sr.imk083=sr.imk083 * -1                   #MOD-A80078 add  
#          IF cl_null(sr.imk09) THEN LET sr.imk09 = 0 END IF
#          IF NOT(cl_null(sr.imk05) AND cl_null(sr.imk06)) THEN
#             IF sr.imk06=1 THEN LET l_imk05=sr.imk05-1 LET l_imk06=12
#             ELSE LET l_imk05=sr.imk05 LET l_imk06=sr.imk06-1 END IF
#             LET l_imk09 = ''   #No.MOD-8A0228 add 
#             SELECT imk09 INTO l_imk09 FROM imk_file
#              WHERE imk01=sr.ima01 AND imk02=sr.imk02 AND imk03=sr.imk03
#                AND imk04=sr.imk04 AND imk05=l_imk05 AND imk06=l_imk06
#             IF NOT cl_null(l_imk09) THEN
#                LET sr.imk09=(sr.imk09+l_imk09)/2
#             END IF
#          END IF
#          ###成本
#          CALL s_untcst(tm.d,sr.ima01,'N') RETURNING l_i,sr.act
#          ###排序
#          FOR g_i = 1 TO 2
#              CASE WHEN tm.s[g_i,g_i] = '1'  LET l_order[g_i] = sr.ima01
#                   WHEN tm.s[g_i,g_i] = '2' #LET g_order1=g_x[23]        #TQC-740065 mark
#                        CASE
#      	        	 WHEN tm.choice ='0' LET l_order[g_i] = sr.ima06
#	      	    	 WHEN tm.choice ='1' LET l_order[g_i] = sr.ima09
#    	          	 WHEN tm.choice ='2' LET l_order[g_i] = sr.ima10
#	    	      	 WHEN tm.choice ='3' LET l_order[g_i] = sr.ima11
#	        	 WHEN tm.choice ='4' LET l_order[g_i] = sr.ima12
#                        END CASE
#                   WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ima08
#                   OTHERWISE LET l_order[g_i]  = '-'
#              END CASE
#          END FOR
#          LET sr.order1 = l_order[1]
#          LET sr.order2 = l_order[2]
#          EXECUTE insert_prep USING sr.order1,sr.order2,sr.ima01,sr.ima02,
#                                    sr.ima08,sr.ima07,sr.ima06,sr.ima25,
#                                    sr.ima27,sr.imk082,sr.imk083,sr.imk09,
#                                    sr.act,sr.sumima1,sr.sumima2,sr.ima60,
#                                    sr.ima021
#     END FOREACH
# 
#     LET l_cmd = 'rm -f ',l_name CLIPPED,'*'   #TQC-760140 add
#     RUN l_cmd                                 #TQC-760140 add
# 
# 
#     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
#     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
#     LET g_str = NULL
#     #是否列印選擇條件
#     IF g_zz05 = 'Y' THEN
#        CALL cl_wcchp(tm.wc,'imk01,ima06,ima09,ima10,ima11,ima12,ima08,imk02')
#             RETURNING tm.wc
#        LET g_str = tm.wc
#     END IF
#     LET g_str = tm.wc,";",tm.yy1,";",tm.m1,";",tm.yy2,";",tm.m2,";",
#                 tm.wc1,";",tm.s[1,1],";",tm.s[2,2],";",g_during,";",
#                 g_durday,";",g_sma.sma68,";",tm.f,";",tm.e,";",tm.u[1,1],";",
#                 tm.u[2,2],";",tm.t[1,1],";",tm.t[2,2]
#     CALL cl_prt_cs3('aimr620','aimr620',l_sql,g_str)   #FUN-710080 modify
#END FUNCTION
#CHI-AB0014 mark --end--
 
#====================================
# 將資料處理後塞入insert_prep
#====================================
REPORT r620_rep1(sr)
   DEFINE l_last_sw            LIKE type_file.chr1,
          l_i,l_j              LIKE type_file.num10,
          l_str                LIKE type_file.chr20,
          l_2,l_3,l_4,l_5,l_11 LIKE imk_file.imk083,
          l_6                  LIKE imk_file.imk083,
          l_7,l_8,l_9,l_10     LIKE imk_file.imk083,
 
          l1_4,l1_5,l1_11      LIKE imk_file.imk083,
          l1_6                 LIKE imk_file.imk083,
          l1_7                 LIKE imk_file.imk083,
 
          l2_4,l2_5,l2_11      LIKE imk_file.imk083,
          l2_6                 LIKE imk_file.imk083,
          l2_7                 LIKE imk_file.imk083,
          m_sma                LIKE zaa_file.zaa08,
          sr                   RECORD order1  LIKE ima_file.ima01,
                                      order2  LIKE ima_file.ima01,
                                      ima01   LIKE ima_file.ima01, #料
                                      ima02   LIKE ima_file.ima02,
                                      ima021  LIKE ima_file.ima021,
                                      ima08   LIKE ima_file.ima08, #來源
                                      ima06   LIKE ima_file.ima06, #分群
                                      ima07   LIKE ima_file.ima07, #ABC
                                      ima25   LIKE ima_file.ima25, #單位
                                      ima27   LIKE ima_file.ima27, #發料安全存量
                                      ima09   LIKE ima_file.ima09, #分群(一)
                                      ima10   LIKE ima_file.ima10, #分群(二)
                                      ima11   LIKE ima_file.ima11, #分群(三)
                                      ima12   LIKE ima_file.ima12, #分群(四)
                                      imk02   LIKE imk_file.imk02, #倉
                                      imk05   LIKE imk_file.imk05, #年
                                      imk06   LIKE imk_file.imk06, #期
                                      imk082  LIKE imk_file.imk082,#出庫
                                      imk083  LIKE imk_file.imk083,#銷售
                                      imk09   LIKE imk_file.imk09, #期末
                                      imk03   LIKE imk_file.imk03, #儲
                                      imk04   LIKE imk_file.imk04, #批
                                      act     LIKE imb_file.imb118,#成本
                                      sumima1 LIKE ima_file.ima59, 
                                      sumima2 LIKE ima_file.ima59, 
                                      ima60   LIKE ima_file.ima60
                               END RECORD
 
  OUTPUT TOP MARGIN 0
        LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
        PAGE LENGTH g_page_line
 
  ORDER BY sr.order1,sr.order2,sr.ima01
 
  FORMAT
   PAGE HEADER
      LET l_last_sw = 'n'
      IF PAGENO = 1 THEN LET l_i = 0 END IF
 
   BEFORE GROUP OF sr.order1
      LET l_i = l_i + 1
      LET l1_4=0
      LET l1_5=0
      LET l1_11=0
 
   BEFORE GROUP OF sr.order2
      LET l2_4=0
      LET l2_5=0
      LET l2_11=0
 
   AFTER GROUP OF sr.ima01
      LET l_2=GROUP SUM(sr.imk082+sr.imk083)
      LET l_3= GROUP SUM(sr.imk09)            #MOD-970243
      IF cl_null(l_2) THEN LET l_2=0 END IF
      IF cl_null(l_3) THEN LET l_3=0 END IF
 
      LET l_4=l_2*sr.act
      LET l_5=GROUP SUM(sr.imk09)*sr.act
      IF cl_null(l_4) THEN LET l_4=0 END IF
      IF cl_null(l_5) THEN LET l_5=0 END IF
 
      IF l_5=0 THEN LET l_6=l_4 ELSE LET l_6=l_4/l_5 END IF
      IF l_4=0 THEN LET l_7=l_5/g_durday
      ELSE LET l_7=(l_5/l_4)/g_durday END IF
      IF l_2=0 THEN LET l_8=sr.ima27/g_durday
      ELSE LET l_8=(sr.ima27/l_2)/g_durday END IF
      IF sr.ima08 MATCHES '[PVZ]' THEN LET l_9=sr.sumima1
      ELSE LET l_9=sr.sumima2+sr.ima60*l_3 END IF                        #CHI-810015 mark還原 #FUN-710073 mark
      IF cl_null(l_6) THEN LET l_6=0 END IF
      IF cl_null(l_7) THEN LET l_7=0 END IF
      IF cl_null(l_8) THEN LET l_8=0 END IF
      IF cl_null(l_9) THEN LET l_9=0 END IF
 
      LET l_10=l_7-(l_8+l_9)
      LET l_11=l_10*(l_2/g_durday)*sr.act
      IF cl_null(l_10) THEN LET l_10=0 END IF
      IF cl_null(l_11) THEN LET l_11=0 END IF
 
      LET l1_4 =l1_4+l_4 LET l1_5 =l1_5+l_5 LET l1_11=l1_11+l_11
      LET l2_4 =l2_4+l_4 LET l2_5 =l2_5+l_5 LET l2_11=l2_11+l_11
      IF tm.e='Y'  THEN
         IF l_7 >= tm.f THEN
            LET l_j = 0
            LET l_str = NULL
            EXECUTE insert_prep USING
                    l_i,l_j,sr.order1,sr.order2,sr.ima01,
                    sr.ima02,sr.ima021,sr.ima08,sr.ima06,sr.ima07,
                    sr.ima25,sr.ima27,l_2,l_3,l_4,
                    l_5,l_6,l_7,l_8,l_9,
                    l_10,l_11,m_sma,g_azi03,g_azi04,
                    g_azi05
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err(l_i,'9052',1)
            END IF
         END IF
      END IF
END REPORT
#No.FUN-9C0072 精簡程式碼 
 
