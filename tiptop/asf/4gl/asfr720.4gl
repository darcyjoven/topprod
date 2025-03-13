# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: asfr720.4gl
# Descriptions...: 品質異常報告表
# Date & Author..: 99/06/25 By Kammy
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modify.........: No.MOD-530461 05/05/03 By pengu 加列印功能，直接與 asfr720 串接列印。
# Modify.........: NO.TQC-5A0038 05/10/14 By Rosayu 1.料號放大 2.調整報表
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-710080 07/01/31 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.TQC-770004 07/07/03 By mike 幫助按鈕灰色 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C10039 12/01/16 By wangrr 整合單據列印EF簽核
# Modify.........: No.TQC-C20203 12/02/15 By dongsz 套表不需添加簽核內容
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                             # Print condition RECORD
#              wc      VARCHAR(600),             # Where condition #NO.TQC-630166 MARK
              wc      STRING,                 #NO.TQC-630166 
              more    LIKE type_file.chr1     #No.FUN-680121 CAHR(1)# 是否輸入其它特殊列印條件?
           END RECORD,
       g_dash1_1      LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(200) 
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_shh01        LIKE shh_file.shh01     #No.MOD-530461
DEFINE l_table        STRING                  #FUN-710080 add
DEFINE g_sql          STRING                  #FUN-710080 add
DEFINE g_str          STRING                  #FUN-710080 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "shh01.shh_file.shh01,",
               "shh02.shh_file.shh02,",
               "shh021.shh_file.shh021,",
               "shh022.shh_file.shh022,",
               "shh03.shh_file.shh03,",
               "shh04.shh_file.shh04,",
               "sfb05.sfb_file.sfb05,",
               "shh05.shh_file.shh05,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "shh06.shh_file.shh06,",
               "shh07.shh_file.shh07,",
               "shh111.shh_file.shh111,",
               "shh112.shh_file.shh112,",
               "shh113.shh_file.shh113,",
               "shh131.shh_file.shh131,",
               "shh132.shh_file.shh132,",
               "shh142.shh_file.shh142,",
               "shh143.shh_file.shh143,",
               "shh151.shh_file.shh151,",
               "shh152.shh_file.shh152,",
               "shh161.shh_file.shh161,",
               "shh162.shh_file.shh162,",
               "shh163.shh_file.shh163,",
               "shh164.shh_file.shh164,",
               "shh165.shh_file.shh165,",
               "shh171.shh_file.shh171,",
               "shh172.shh_file.shh172,",
               "shh173.shh_file.shh173,",
               "shh174.shh_file.shh174,",
               "shh175.shh_file.shh175,",
               "shh101.shh_file.shh101,",
               "shh10.shh_file.shh10,",
               "shh121.shh_file.shh121,",
               "shh12.shh_file.shh12,",
               "shh141.shh_file.shh141,",
               "shh14.shh_file.shh14,",
               "shh08.shh_file.shh08,",
               "ecd02.ecd_file.ecd02,",
               "gen02_1.gen_file.gen02,",
               "gem02_1.gem_file.gem02,",
               "gen02_2.gen_file.gen02,",
               "gem02_2.gem_file.gem02,",
               "gen02_3.gen_file.gen02"
#               "sign_type.type_file.chr1,",  #TQC-C10039 簽核方式    #No.TQC-C20203 mark
#               "sign_img.type_file.blob,",   #TQC-C10039 簽核圖檔    #No.TQC-C20203 mark
#               "sign_show.type_file.chr1,",  #TQC-C10039 是否顯示簽核資料(Y/N)  #No.TQC-C20203 mark
#               "sign_str.type_file.chr1000"  #TQC-C10039 sign_str    #No.TQC-C20203 mark
 
   LET l_table = cl_prt_temptable('asfr720',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,? )"   #TQC-C10039 add 4?  #No.TQC-C20203 del 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-710080 add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610080-begin
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   ##LET tm.more  = ARG_VAL(8) 
   # #-----------------------------No.MOD-530461---------------------------
   ##LET g_shh01  = ARG_VAL(9)  
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(10)
   #LET g_rep_clas = ARG_VAL(11)
   #LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #IF cl_null(g_shh01) THEN
   #TQC-610080-end
      IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
         THEN CALL asfr720_tm(0,0)        # Input print condition
         ELSE CALL asfr720()              # Read data and create out-file
      END IF
   #TQC-610080-begin
   #ELSE
   #   LET tm.wc="shh01= '",g_shh01 CLIPPED,"'"
   #   LET g_rlang = g_lang
   #   CALL asfr720()                    # Read data and create out-file
   #END IF
   #TQC-610080-end
   #----------------------------------No.MOD-530461--------------------
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr720_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680121 CAHR(400)
 
   IF p_row = 0 THEN
      LET p_row = 5 LET p_col = 12
   END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 12
   END IF
   OPEN WINDOW asfr720_w AT p_row,p_col WITH FORM "asf/42f/asfr720"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more    = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON shh01,shh02,shh03
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION locale
        #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
      ON ACTION help                                          #No;TQC-770004                                                                       
        #CALL cl_dynamic_locale()                          #No;TQC-770004                                                                            
         CALL cl_show_help()                   #No.FUN-550037 hmf  #No;TQC-770004                                                                 
         LET g_action_choice = "help"                        #No;TQC-770004                                                                        
         CONTINUE CONSTRUCT                   #No;TQC-770004
    #-------------------------- No.MOD-530485--------------------------
      ON ACTION CONTROLP
         IF INFIELD(shh01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state= "c"
            LET g_qryparam.form = "q_shh"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO shh01
            NEXT FIELD shh01
         END IF
         IF INFIELD(shh03) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state= "c"
            LET g_qryparam.form = "q_shh1"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO shh03
            NEXT FIELD shh03
         END IF
 #-------------------------- No.MOD-530485--------------------------
 
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
      CLOSE WINDOW asfr720_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.more      # Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = "Y" THEN
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
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
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
        ON ACTION help                                          #No;TQC-770004                                                        
        #CALL cl_dynamic_locale()                          #No;TQC-770004                                                           
         CALL cl_show_help()                   #No.FUN-550037 hmf  #No;TQC-770004                                                   
         LET g_action_choice = "help"                        #No;TQC-770004                                                         
         CONTINUE INPUT                   #No;TQC-770004       
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfr720_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr720'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr720','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #" '",tm.more CLIPPED,"'",             #TQC-610080 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('asfr720',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW asfr720_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr720()
   ERROR ""
END WHILE
CLOSE WINDOW asfr720_w
END FUNCTION
 
FUNCTION asfr720()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#          l_time    LIKE type_file.chr8           #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1200)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
#         l_order   ARRAY[5] OF LIKE apm_file.apm08,        #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr        RECORD
                       shh01  LIKE shh_file.shh01,
                       shh02  LIKE shh_file.shh02,
                       shh021 LIKE shh_file.shh021,
                       shh022 LIKE shh_file.shh022,
                       shh03  LIKE shh_file.shh03,
                       shh04  LIKE shh_file.shh04,
                       sfb05  LIKE sfb_file.sfb05,
                       shh05  LIKE shh_file.shh05,
                       ima02  LIKE ima_file.ima02,
                       ima021 LIKE ima_file.ima021,
                       shh06  LIKE shh_file.shh06,
                       shh07  LIKE shh_file.shh07,
                       shh111 LIKE shh_file.shh111,
                       shh112 LIKE shh_file.shh112,
                       shh113 LIKE shh_file.shh113,
                       shh131 LIKE shh_file.shh131,
                       shh132 LIKE shh_file.shh132,
                       shh142 LIKE shh_file.shh142,
                       shh143 LIKE shh_file.shh143,
                       shh151 LIKE shh_file.shh151,
                       shh152 LIKE shh_file.shh152,
                       shh161 LIKE shh_file.shh161,
                       shh162 LIKE shh_file.shh162,
                       shh163 LIKE shh_file.shh163,
                       shh164 LIKE shh_file.shh164,
                       shh165 LIKE shh_file.shh165,
                       shh171 LIKE shh_file.shh171,
                       shh172 LIKE shh_file.shh172,
                       shh173 LIKE shh_file.shh173,
                       shh174 LIKE shh_file.shh174,
                       shh175 LIKE shh_file.shh175,
                       shh101 LIKE shh_file.shh101,
                       shh10  LIKE shh_file.shh10 ,
                       shh121 LIKE shh_file.shh121,
                       shh12  LIKE shh_file.shh12,
                       shh141 LIKE shh_file.shh141,
                       shh14  LIKE shh_file.shh14,
                       shh08  LIKE shh_file.shh08
                    END RECORD
   DEFINE l_ecd02   LIKE ecd_file.ecd02   #FUN-710080 add
   DEFINE l_gen02_1 LIKE gen_file.gen02   #FUN-710080 add
   DEFINE l_gen02_2 LIKE gen_file.gen02   #FUN-710080 add
   DEFINE l_gen02_3 LIKE gen_file.gen02   #FUN-710080 add
   DEFINE l_gem02_1 LIKE gem_file.gem02   #FUN-710080 add
   DEFINE l_gem02_2 LIKE gem_file.gem02   #FUN-710080 add
#TQC-C10039--add--start---
#   DEFINE l_img_blob     LIKE type_file.blob   #No.TQC-C20203 mark
#   LOCATE l_img_blob IN MEMORY                 #No.TQC-C20203 mark
#TQC-C10039--add--end---   

   #str FUN-710080 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-710080 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr720'
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND shhuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND shhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND shhgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shhuser', 'shhgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT shh01, shh02, shh021,shh022,shh03, shh04, sfb05, ",
               "       shh05, ima02, ima021,shh06 ,shh07 ,shh111,shh112,",
               "       shh113,shh131,shh132,shh142,shh143,shh151,shh152,",
               "       shh161,shh162,shh163,shh164,shh165,shh171,shh172,",
               "       shh173,shh174,shh175,shh101,shh10 ,shh121,shh12 ,",
               "       shh141,shh14, shh08 ",
               "  FROM shh_file,sfb_file LEFT OUTER JOIN ima_file ON sfb05=ima01",
               " WHERE shh01 = shh01",
               "   AND sfb01 = shh03",
               "   AND shh14!= 'X' ",
               "   AND ",tm.wc CLIPPED," ORDER BY shh01"
   PREPARE asfr720_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
   END IF
   DECLARE asfr720_curs1 CURSOR FOR asfr720_prepare1
 
   FOREACH asfr720_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0  THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
 
      #str FUN-710080 add
      #作業說明
      SELECT ecd02 INTO l_ecd02 FROM ecd_file WHERE ecd01=sr.shh05
      IF SQLCA.SQLCODE THEN LET l_ecd02='' END IF 
      #提出人員姓名
      SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01=sr.shh101
      IF SQLCA.SQLCODE THEN LET l_gen02_1='' END IF 
      #責任判定人員姓名
      SELECT gen02 INTO l_gen02_2 FROM gen_file WHERE gen01=sr.shh121
      IF SQLCA.SQLCODE THEN LET l_gen02_2='' END IF 
      #確認人員姓名
      SELECT gen02 INTO l_gen02_3 FROM gen_file WHERE gen01=sr.shh141
      IF SQLCA.SQLCODE THEN LET l_gen02_3='' END IF 
      #提出部門名稱
      SELECT gem02 INTO l_gem02_1 FROM gem_file WHERE gem01=sr.shh10
      IF SQLCA.SQLCODE THEN LET l_gem02_1='' END IF 
      #初步責任判定部門名稱
      SELECT gem02 INTO l_gem02_2 FROM gem_file WHERE gem01=sr.shh12
      IF SQLCA.SQLCODE THEN LET l_gem02_2='' END IF 
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
         sr.shh01,sr.shh02,sr.shh021,sr.shh022,sr.shh03,
         sr.shh04,sr.sfb05,sr.shh05,sr.ima02,sr.ima021,
         sr.shh06,sr.shh07,sr.shh111,sr.shh112,sr.shh113,
         sr.shh131,sr.shh132,sr.shh142,sr.shh143,sr.shh151,
         sr.shh152,sr.shh161,sr.shh162,sr.shh163,sr.shh164,
         sr.shh165,sr.shh171,sr.shh172,sr.shh173,sr.shh174,
         sr.shh175,sr.shh101,sr.shh10,sr.shh121,sr.shh12,
         sr.shh141,sr.shh14,sr.shh08,l_ecd02,l_gen02_1,
         l_gem02_1,l_gen02_2,l_gem02_2,l_gen02_3
                       #TQC-C10039 ADD "",l_img_blob,"N",""   #No.TQC-C20203 del "",l_img_blob,"N",""
      #------------------------------ CR (3) ------------------------------#
      #end FUN-710080 add
   END FOREACH
 
   #str FUN-710080 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'shh01,shh02,shh03')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
#TQC-C10039--add--start---
#     LET g_cr_table = l_table      #主報表的temp table名稱       #No.TQC-C20203 mark
#     LET g_cr_apr_key_f = "shh01"  #報表主鍵欄位名稱，用"|"隔開  #No.TQC-C20203 mark
#TQC-C10039--add--end---
   CALL cl_prt_cs3('asfr720','asfr720',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
   #end FUN-710080 add
 
END FUNCTION
