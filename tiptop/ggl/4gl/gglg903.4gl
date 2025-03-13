# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: gglg903.4gl
# Descriptions...: 傳票憑証
# Input parameter:
# Return code....:
# Date & Author..: 92/03/04 By DAVID
# Reference File : aba_file,abb_file,abc_file,aac_file,aag_file
# 需傳遞帳別----> MAY
# modi           :960321 by nick arg(1) must by bookno not dbs!
# Modify.........: By Danny     OUTER 作法、新增 l_sql 程式段
# Modify.........: By Melody    列印時應將異動碼二、三、四也一併列印出
# Modify.........: By Melody    修正 ARG_VAL 順序
# Modify.........: By Melody 97.07.17 sr.order1 改為 SMALLINT
# Modify.........: No.7911 03/10/23 By Sophia依幣別取位及報表格式調整
# Modify.........: No.FUN-510007 05/03/04 By Smapmin 放寬金額欄位
# Modify.........: No.FUN-550028 05/05/16 By Will 單據編號放大
# Modify.........: No.MOD-590097 05/09/08 By jackie 將報表畫線部分寫進zaa
# Modify.........: No.TQC-5B0102 05/11/15 By yoyo無法controlg
# Modify.........: No.MOD-640001 06/04/03 By Smapmin 幣別取位有誤
# Modify.........: No.FUN-660124 06/06/21 By Cheunl cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-690009 06/09/06 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-740055 07/04/12 By lora 會計科目加帳套 
# Modify.........: No.TQC-750041 07/05/15 By Lynn 打印內容:憑証的格式框沒有閉合
# Modify.........: No.FUN-770041 07/08/14 By jamie 報表改由CR產出
# Modify.........: No.MOD-860252 08/07/02 By chenl 增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40097 11/06/02 By chenying 憑證類CR報表轉成GR
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B40097 11/08/17 By chenying 程式規範修改
# Modify.........: No.FUN-C50007 12/05/11 By minpp GR程式優化 
# Modify.........: No.FUN-C10024 12/05/21 By minpp 帳套取歷年主會計帳別檔tna_file
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
                wc      LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000)  # Where condition
                wc2     LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000)  # Where condition
                aba00   LIKE aba_file.aba00,               #帳別編號         #No.FUN-740055
                t       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)     # Post
                u       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)     # Activity
                v       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)     # extra detail (Y/N)
                h       LIKE type_file.chr1,    #MOD-860252
                w       LIKE type_file.chr1,    #NO FUN-690009   VARCHAR(1)     # already print (Y/N)
                more    LIKE type_file.chr1    #NO FUN-690009   VARCHAR(1)     # Input more condition(Y/N)
          END RECORD,
          l_abc04    LIKE abc_file.abc04,    #NO FUN-690009   VARCHAR(30)       # Like file abc_file.abc04
          g_bookno   LIKE aba_file.aba00,    #帳別
          g_type     LIKE zaa_file.zaa08,  #NO FUN-690009   VARCHAR(40)
          p_dbs      LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)
          g_part     LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40)
          g_spac     LIKE aab_file.aab02,    #NO FUN-690009   VARCHAR(6)
          g_tot_bal  LIKE type_file.num20_6  #NO FUN-690009   DECIMAL(20,6)  # User defined variable
   DEFINE g_rpt_name LIKE type_file.chr20    #NO FUN-690009   VARCHAR(20)       # For TIPTOP 串 EasyFlow
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10    #NO FUN-690009   INTEGER
DEFINE   g_i             LIKE type_file.num5     #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   g_msg           LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(72)
#str FUN-770041 add
DEFINE l_table      STRING
DEFINE g_sql        STRING
DEFINE g_str        STRING
#end FUN-770041 add
 
###GENGRE###START
TYPE sr1_t RECORD
    aba01 LIKE aba_file.aba01,
    aba02 LIKE aba_file.aba02,
    aba08 LIKE aba_file.aba08,
    aba09 LIKE aba_file.aba09,
    abb02 LIKE abb_file.abb02,
    abb03 LIKE abb_file.abb03,
    abb11 LIKE abb_file.abb11,
    abb04 LIKE abb_file.abb04,
    abb05 LIKE abb_file.abb05,
    gem02 LIKE gem_file.gem02,
    abb24 LIKE abb_file.abb24,
    abb06 LIKE abb_file.abb06,
    abb07f LIKE abb_file.abb07f,
    aag02 LIKE aag_file.aag02,
    abb25 LIKE abb_file.abb25,
    abb07 LIKE abb_file.abb07,
    abb12 LIKE abb_file.abb12,
    abb13 LIKE abb_file.abb13,
    abb14 LIKE abb_file.abb14,
    g_msg LIKE type_file.chr1000,
    azi04 LIKE azi_file.azi04

END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   #str FUN-710041 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "aba01.aba_file.aba01,",
               "aba02.aba_file.aba02,",
               "aba08.aba_file.aba08,",
               "aba09.aba_file.aba09,",
               "abb02.abb_file.abb02,",
               "abb03.abb_file.abb03,",
               "abb11.abb_file.abb11,",
               "abb04.abb_file.abb04,",
               "abb05.abb_file.abb05,",
               "gem02.gem_file.gem02,",
               "abb24.abb_file.abb24,",
               "abb06.abb_file.abb06,",
               "abb07f.abb_file.abb07f,",
               "aag02.aag_file.aag02,",
               "abb25.abb_file.abb25,",
               "abb07.abb_file.abb07,",
               "abb12.abb_file.abb12,",
               "abb13.abb_file.abb13,",
               "abb14.abb_file.abb14,",
               "g_msg.type_file.chr1000,",
               "azi04.azi_file.azi04"
 
   LET l_table = cl_prt_temptable('gglg903',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
   EXIT PROGRAM 
   END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?,",
               "         ?) " 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
   EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-770041 add
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-B40092 add
   LET g_rpt_name = ''
#  LET g_bookno =  ARG_VAL(1)                #No.FUN-740055    #modi by nick 960321
  LET tm.aba00 =  ARG_VAL(1)                #No.FUN-740055    #modi by nick 960321
  LET p_dbs    =  ARG_VAL(2)
  LET g_pdate =   ARG_VAL(3)             # Get arguments from command line
  LET g_towhom =  ARG_VAL(4)
  LET g_rlang =   ARG_VAL(5)
  LET g_bgjob =   ARG_VAL(6)
  LET g_prtway =  ARG_VAL(7)
  LET g_copies =  ARG_VAL(8)
  LET tm.wc = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.u  = ARG_VAL(11)
   LET tm.v  = ARG_VAL(12)
   LET tm.w  = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)   # 外部指定報表名稱
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #-->帳別若為空白則使用預設帳別
#No.FUN-740055--begin--
   IF g_bookno = ' ' OR g_bookno IS NULL THEN
      LET g_bookno = g_aaz.aaz64
   END IF
   IF tm.aba00 = ' ' OR tm.aba00 IS NULL THEN
      LET tm.aba00 = g_aza.aza81
   END IF
#No.FUN-740055--end
   #-->使用預設帳別之幣別
   #No.FUN-740055  --Begin                                                                                                          
   IF cl_null(tm.aba00) THEN LET tm.aba00=g_aza.aza81 END IF                                                                    
   #No.FUN-740055  --End 
 # SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno   #No.FUN-740055
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.aba00 #No.FUN-740055    
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
#   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03   #No.CHI-6A0004
   IF SQLCA.sqlcode THEN 
#       CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   # No.FUN-660124 
        CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)    # No.FUN-660124
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            # If background job sw is off
      THEN CALL gglg903_tm(0,0)         # Input print condition
      ELSE CALL gglg903()                       # Read data and create out-file
   END IF
CALL cl_used(g_prog,g_time,2) RETURNING g_time
CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
END MAIN
 
FUNCTION gglg903_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,    #NO FUN-690009   SMALLINT
          l_cmd         LIKE type_file.chr1000  #NO FUN-690009   VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
#   CALL s_dsmark(g_bookno)   #No.FUN-740055
   CALL s_dsmark(tm.aba00)   #No.FUN-740055
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 12
   END IF
   OPEN WINDOW gglg903_w AT p_row,p_col
        WITH FORM "ggl/42f/gglg903"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#   CALL s_shwact(3,2,g_bookno)    #No.FUN-740055
   CALL s_shwact(3,2,tm.aba00)     #No.FUN-740055
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET tm.t    = '3'
   LET tm.u    = '3'
   LET tm.v    = 'Y'
   LET tm.h    = 'Y'    #No.MOD-860252
   LET tm.w    = '3'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#No.FUN-740055--begin--
   IF tm.aba00 = ' ' OR tm.aba00 IS NULL THEN
      LET tm.aba00 = g_aza.aza81
   END IF
#No.FUN-740055--end
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON aba01,aba05,aba02,aba06
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#No.TQC-5B0102--start
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
#No.TQC-5B0102--end
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
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
      LET INT_FLAG = 0 CLOSE WINDOW gglg903_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   DISPLAY BY NAME tm.more             # Condition
   #No.FUN-740055 --Begin
#  INPUT BY NAME tm.t,tm.u,tm.w,tm.v,tm.more WITHOUT DEFAULTS      
         #No.FUN-580031 --start--
   INPUT BY NAME tm.aba00,tm.t,tm.u,tm.w,tm.v,tm.h,tm.more WITHOUT DEFAULTS  #No.MOD-860252 add tm.h
   #No.FUN-740055 --End
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
      
      #No.FUN-740055 --Begin
      AFTER FIELD aba00                                                                                                         
          IF cl_null(tm.aba00) THEN NEXT FIELD aba00 END IF
      #No.FUN-740055 --End 
      AFTER FIELD t
         IF tm.t NOT MATCHES "[123]" OR tm.t IS NULL THEN NEXT FIELD t END IF
      AFTER FIELD u
         IF tm.u NOT MATCHES "[123]" OR tm.u IS NULL THEN NEXT FIELD u END IF
      AFTER FIELD v
         IF tm.v NOT MATCHES "[YN]" OR tm.v IS NULL THEN NEXT FIELD v END IF
      AFTER FIELD w
         IF tm.w NOT MATCHES "[123]" OR tm.w IS NULL THEN NEXT FIELD w END IF
      AFTER FIELD more
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
      #No.FUN-740055 --Begin
      ON ACTION CONTROLP                                                                                                            
         CASE                                                                                                                       
            WHEN INFIELD(book_no)                                                                                                   
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = 'q_aaa3'                                                                                       
               LET g_qryparam.default1 = tm.aba00                                                                                 
               CALL cl_create_qry() RETURNING tm.aba00                                                                            
               DISPLAY BY NAME tm.aba00                                                                                           
               NEXT FIELD b                                                                                                         
         END CASE                  
      #No.FUN-740055 --End 
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW gglg903_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='gglg903'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglg903','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
#                         " '",g_bookno CLIPPED,"'",    #No.FUN-740055
                         " '",tm.aba00 CLIPPED,"'",    #No.FUN-740055
                         " '",g_dbs CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.v CLIPPED,"'",
                         " '",tm.w CLIPPED,"'",
                         " '",g_rpt_name CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('gglg903',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW gglg903_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gglg903()
   ERROR ""
END WHILE
   CLOSE WINDOW gglg903_w
END FUNCTION
 
FUNCTION gglg903()
   DEFINE l_name        LIKE type_file.chr20,   #NO FUN-690009   VARCHAR(20)   # External(Disk) file name
         #l_time        LIKE type_file.chr8     #No.FUN-6A0097
          l_sql         LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(1000) # RDSQL STATEMENT
         #l_aac01       VARCHAR(3),
          l_aac01       LIKE type_file.chr5,    #NO FUN-690009   VARCHAR(5)    #No.FUN-550028
          l_za05        LIKE type_file.chr1000, #NO FUN-690009   VARCHAR(40),
          l_order       ARRAY[5] OF LIKE cre_file.cre08,   #NO FUN-690009   VARCHAR(10)
          sr               RECORD
                                  order1 LIKE type_file.num5,    #NO FUN-690009   SMALLINT
                                  aba  RECORD LIKE aba_file.*,
                                  abb  RECORD LIKE abb_file.*,
                                  aag02 LIKE aag_file.aag02,
                                  gem02 LIKE gem_file.gem02,
                                  azi04 LIKE azi_file.azi04   #NO:7911
                        END RECORD
    DEFINE l_aac02      LIKE aac_file.aac02     #FUN-770041 add
     #str FUN-770041 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
     #end FUN-770041 add
     #No.FUN-B80096--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 =tm.aba00    #No.FUN-740055 
                        AND aaf02 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglg903'
    #TQC-650055...............begin
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    #TQC-650055...............end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND abagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ' ',aba_file.*,abb_file.*,aag02,gem02,azi04 ",                    #FUN-C50007  add azi04
               # "  FROM aba_file,abb_file,OUTER aag_file,OUTER gem_file ",                #FUN-C50007  MARK
                 "  FROM aba_file,abb_file LEFT OUTER JOIN aag_file ON abb03=aag01 AND abb00 = aag00",      #FUN-C50007  add #FUN-C10024--AND abb00 = aag00
                 "  LEFT OUTER JOIN gem_file ON abb05=gem01 LEFT OUTER JOIN azi_file ON azi01=abb24 ",   #FUN-C50007  add
#                " WHERE aba00 = '",g_bookno,"' AND abb00 ='",g_bookno,"'",    #No.FUN-740055
                 " WHERE aba00 = '",tm.aba00,"' AND abb00 ='",tm.aba00,"'",    #No.FUN-740055
                 " AND abb02 > 0 AND aba01 = abb01 ",
               # " AND abb00 = aag00 ",   #FUN-770041 add  #FUN-C10024 MARK
               # " AND abb_file.abb03 = aag_file.aag01 ",  #FUN-C50007  MARK
               # " AND abb_file.abb05 = gem_file.gem01 ",  #FUN-C50007  MARK                                 
                 " AND aba19 <> 'X' ",  #CHI-C80041
                 " AND ",tm.wc CLIPPED
     #No.MOD-860252--begin--
     IF tm.h = 'Y' THEN 
        LET l_sql = l_sql CLIPPED," AND aag09 = 'Y' "
     END IF 
     #No.MOD-860252---end---
     CASE tm.t
          WHEN '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N'"
          WHEN '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y'"
          OTHERWISE EXIT CASE
     END CASE
     CASE tm.u
          WHEN '1' LET l_sql = l_sql CLIPPED," AND abaacti = 'Y'"
          WHEN '2' LET l_sql = l_sql CLIPPED," AND abaacti = 'N'"
          OTHERWISE EXIT CASE
     END CASE
     CASE tm.w
          WHEN '1' LET l_sql = l_sql CLIPPED," AND abaprno = 0"
          WHEN '2' LET l_sql = l_sql CLIPPED," AND abaprno > 0"
          OTHERWISE EXIT CASE
     END CASE
     LET l_sql = l_sql CLIPPED," ORDER BY aba01,abb02"   #FUN-770041 add
 
     PREPARE gglg903_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
        EXIT PROGRAM
     END IF
     DECLARE gglg903_curs1 CURSOR FOR gglg903_prepare1
 
     #-->額外摘要
      LET l_sql = " SELECT abc03,abc04 FROM abc_file",
                  "  WHERE abc00 = ? AND abc01=?  AND abc02= ? ",
                  "   ORDER BY 1 "
     PREPARE gglg903_pre2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
        EXIT PROGRAM
     END IF
     DECLARE g903_c2  CURSOR FOR gglg903_pre2
 
     IF NOT cl_null(g_rpt_name)   #已有外部指定報表名稱
        THEN
        LET l_name = g_rpt_name
    #ELSE                                             #FUN-770041 mark
    #   CALL cl_outnam('gglg903') RETURNING l_name    #FUN-770041 mark
     END IF
    #TQC-650055...............begin
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 90 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    #TQC-650055...............end
    #START REPORT gglg903_rep TO l_name    #FUN-77041 mark
 
     LET g_pageno = 0
     FOREACH gglg903_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0
            THEN CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #-->是否依借貸排序
        IF g_aaz.aaz82 = 'Y'
           THEN LET sr.order1 = sr.abb.abb06
           ELSE LET sr.order1 = sr.abb.abb02
        END IF
        #NO:7911
        #SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = sr.abb24   #MOD-640001   #No.CHI-6A0004
       # SELECT azi04 INTO sr.azi04 FROM azi_file WHERE azi01 = sr.abb.abb24   #MOD-640001   #No.CHI-6A0004  #FUN-C50007 MARK
       #OUTPUT TO REPORT gglg903_rep(sr.*) #FUN-770041 mark
 
      #str FUN-770041 add
      IF tm.v='Y' THEN
         FOREACH g903_c2 USING sr.aba.aba00,sr.aba.aba01,sr.abb.abb02
                                 INTO g_cnt,g_msg
            IF SQLCA.sqlcode THEN
               CALL cl_err('g903_c2',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
         END FOREACH
      END IF
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE insert_prep USING
         sr.aba.aba01,sr.aba.aba02,sr.aba.aba08,sr.aba.aba09,sr.abb.abb02,
         sr.abb.abb03,sr.abb.abb11,sr.abb.abb04,sr.abb.abb05,sr.gem02    ,
         sr.abb.abb24,sr.abb.abb06,
         sr.abb.abb07f,sr.aag02   ,sr.abb.abb25,
         sr.abb.abb07,sr.abb.abb12,sr.abb.abb13,
         sr.abb.abb14,g_msg,sr.azi04     #FUN-C50007 ADD-sr.azi04     
      #end FUN-770041 add
 
     END FOREACH
 
   #str FUN-770041 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###GENGRE###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #報表名稱
   CALL s_get_doc_no(sr.aba.aba01) RETURNING g_part  #No.FUN-550028
   SELECT aac02 INTO l_aac02 FROM aac_file WHERE aac01 = g_part
   IF SQLCA.sqlcode THEN 
      SELECT gaz03 INTO l_aac02 FROM gaz_file 
                               WHERE gaz01 = g_prog AND gaz02=g_rlang
   END IF
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'aba01,aba05,aba02,aba06')
           RETURNING tm.wc
   ELSE
      LET tm.wc = ' '
   END IF
###GENGRE###   LET g_str = tm.wc,";",l_aac02,";",tm.v
  #LET g_str = tm.wc,";",tm.v
###GENGRE###   CALL cl_prt_cs3('gglg903','gglg903',g_sql,g_str)
    CALL gglg903_grdata()    ###GENGRE###
   #------------------------------ CR (4) ------------------------------#
   #end FUN-770041 add
 
    #FINISH REPORT gglg903_rep                      #FUN-770041 mark
                                     
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #FUN-770041 mark
     #No.FUN-B80096--mark--Begin---
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-B80096--mark--End-----
END FUNCTION
{ 
REPORT gglg903_rep(sr)
   DEFINE l_depname     LIKE cre_file.cre08    #NO FUN-690009   VARCHAR(10)   # 部門名稱
   DEFINE l_buf         ARRAY[10] OF LIKE azo_file.azo05     #NO FUN-690009   VARCHAR(18)
   DEFINE i,l_flag                   LIKE type_file.num5     #NO FUN-690009   SMALLINT
   DEFINE l_tot,l_amt,l_d,l_c        LIKE type_file.num20_6  #NO FUN-690009   DECIMAL(20,6)
   DEFINE l_zx02           LIKE zx_file.zx02
   DEFINE sr               RECORD
                                  order1 LIKE type_file.num5,    #No.FUN-690009 SMALLINT,
                                  aba  RECORD LIKE aba_file.*,
                                  abb  RECORD LIKE abb_file.*,
                                  aag02 LIKE aag_file.aag02,
                                  gem02 LIKE gem_file.gem02,
                                  azi04 LIKE azi_file.azi04     #NO:7911
                        END RECORD
   DEFINE l_aac02     LIKE aac_file.aac02
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.aba.aba01,sr.order1,sr.abb.abb02
  FORMAT
   PAGE HEADER
#No.MOD-590097 --start--
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT ' '
#      LET g_part = sr.aba.aba01[1,3]
      CALL s_get_doc_no(sr.aba.aba01) RETURNING g_part  #No.FUN-550028
      LET g_type = g_x[1]
      SELECT aac02 INTO l_aac02 FROM aac_file WHERE aac01 = g_part
      IF SQLCA.sqlcode THEN LET g_x[1] = g_type END IF
      LET g_x[1] = l_aac02
      LET g_pageno = g_pageno + 1
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED,
            COLUMN 72,g_x[3] CLIPPED,g_pageno USING '<<<'
#      PRINT '┌─────────────────────────────',
#            '──────────────┐'
       PRINT g_x[39],g_x[40],g_x[41] CLIPPED
      PRINT g_x[38],g_x[14] CLIPPED,sr.aba.aba02,
          #NO:7911
          # COLUMN 54, g_x[16] CLIPPED, cl_numfor(sr.aba.aba08,13,g_azi04),
            COLUMN 54, g_x[16] CLIPPED, cl_numfor(sr.aba.aba08,18,sr.azi04),  #No.CHI-6A0004
            COLUMN 89, g_x[38]
      PRINT g_x[38],g_x[11] CLIPPED,sr.aba.aba01,
          #NO:7911
          # COLUMN 54, g_x[21] CLIPPED, cl_numfor(sr.aba.aba09,13,g_azi04),
            COLUMN 54, g_x[21] CLIPPED, cl_numfor(sr.aba.aba09,18,sr.azi04),  #No.CHI-6A0004
            COLUMN 89, g_x[38]
#      PRINT '├───────────────────────────────',
#            '────────────┤'
       PRINT g_x[42],g_x[40],g_x[43] CLIPPED
 
      PRINT g_x[38],COLUMN 03,g_x[22],g_x[23],
                 COLUMN 89,g_x[38]
#      PRINT '├───────────────────────────────',
#            '────────────┤'
       PRINT g_x[42],g_x[40],g_x[43] CLIPPED
 
 
   BEFORE GROUP OF sr.aba.aba01
      SKIP TO TOP OF PAGE
   ON EVERY ROW
      PRINT g_x[38];
      PRINT COLUMN 3,sr.abb.abb02 USING '##',
            COLUMN 8,sr.abb.abb03[1,15],
            COLUMN 26,sr.abb.abb11[1,10],
            COLUMN 35,sr.abb.abb05,
            COLUMN 44,sr.gem02,
            COLUMN 59,sr.abb.abb24;
            LET g_msg=null
         IF sr.abb.abb06="1"
            THEN LET g_msg=g_x[36] CLIPPED
            ELSE LET g_msg=g_x[37] CLIPPED
         END IF
      PRINT COLUMN 65,g_msg CLIPPED,
            #NO:7911
           #COLUMN 67,cl_numfor(sr.abb.abb07f,15,g_azi04),
            COLUMN 69,cl_numfor(sr.abb.abb07f,18,sr.azi04),  #No.CHI-6A0004
            COLUMN 89, g_x[38]
      PRINT g_x[38];
      PRINT COLUMN 08, sr.aag02,
            COLUMN 35,sr.abb.abb04[1,20],
            COLUMN 59,sr.abb.abb25 USING "<<.<<<",
            #NO:7911
          # COLUMN 67,cl_numfor(sr.abb.abb07,15,g_azi04),
            COLUMN 69,cl_numfor(sr.abb.abb07,18,sr.azi04),   #No.CHI-6A0004
            COLUMN 89, g_x[38]
      IF not cl_null(sr.abb.abb12) OR
         not cl_null(sr.abb.abb13) OR
         not cl_null(sr.abb.abb14) THEN
         PRINT g_x[38], COLUMN 8,sr.abb.abb12,' ',sr.abb.abb13,' ',sr.abb.abb14,
                     COLUMN 89, g_x[38]
      END IF
      IF tm.v='Y' THEN
         FOREACH g903_c2 USING sr.aba.aba00,sr.aba.aba01,sr.abb.abb02
                                 INTO g_cnt,g_msg
            IF SQLCA.sqlcode THEN
               CALL cl_err('g903_c2',SQLCA.sqlcode,0)
               EXIT FOREACH
            END IF
         END FOREACH
      END IF
 
   AFTER GROUP OF sr.aba.aba01
      LET g_pageno = 0
      IF LINENO >= 10 THEN
#        IF LINENO < 25 THEN      # No.TQC-750041
         IF LINENO < 30 THEN      # No.TQC-750041
            PRINT g_x[38], COLUMN 7,g_x[35] CLIPPED , COLUMN 89, g_x[38]
         END IF
#        FOR i = LINENO TO 25     # No.TQC-750041
         FOR i = LINENO TO 30     # No.TQC-750041
            PRINT g_x[38],COLUMN 89,g_x[38]
         END FOR
      END IF
      UPDATE aba_file SET abaprno = abaprno + 1
                      WHERE aba01 = sr.aba.aba01
              #         AND aba00 = g_bookno         #No.FUN-740055
                        AND aba00 = tm.aba00       #No.FUN-740055
      IF sqlca.sqlerrd[3]=0 THEN
#          CALL cl_err('upd abaprno',STATUS,0)    # No.FUN-660124
       #   CALL cl_err3("upd","aba_file",sr.aba.aba01,g_bookno,STATUS,"","upd abaprno",0)    # No.FUN-660124   #No.FUN-740055
           CALL cl_err3("upd","aba_file",sr.aba.aba01,tm.aba00,STATUS,"","upd abaprno",0)      #No.FUN-740055 
      END IF
   PAGE TRAILER
#      PRINT '└───────────────────────────────',
#            '────────────┘'
      PRINT g_x[44],g_x[40],g_x[45] CLIPPED
#No.MOD-590097 --end--
    #No.B525 010517 by linda mod
    # PRINT '  ', g_x[30],g_x[31]
      SELECT zx02 INTO l_zx02
        FROM zx_file
        WHERE zx01=g_user
      PRINT '  ', g_x[30],g_x[31] CLIPPED,l_zx02
    #No.B525 end---
END REPORT
#Patch....NO.TQC-610037 <001> #
}
###GENGRE###START
FUNCTION gglg903_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("gglg903")
        IF handler IS NOT NULL THEN
            START REPORT gglg903_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY aba01,abb02"
            DECLARE gglg903_datacur1 CURSOR FROM l_sql
            FOREACH gglg903_datacur1 INTO sr1.*
                OUTPUT TO REPORT gglg903_rep(sr1.*)
            END FOREACH
            FINISH REPORT gglg903_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gglg903_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_abb05_gem02 STRING  #FUN-B40097 add
    DEFINE l_abb13_abb14 STRING  #FUN-B40097 add
    DEFINE l_abb06       STRING  #FUN-B40097 add   
    DEFINE l_aba08_fmt   STRING  #FUN-B40097 add
    DEFINE l_aba09_fmt   STRING  #FUN-B40097 add
    DEFINE l_abb07_fmt   STRING  #FUN-B40097 add
    DEFINE l_abb07f_fmt  STRING  #FUN-B40097 add
    DEFINE l_p2          LIKE aac_file.aac02
     
    ORDER EXTERNAL BY sr1.aba01,sr1.abb02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            #FUN-B40097----add---str-------------
            SELECT aac02 INTO l_p2 FROM aac_file WHERE aac01 = g_part
            IF SQLCA.sqlcode THEN
            SELECT gaz03 INTO l_p2 FROM gaz_file
                               WHERE gaz01 = g_prog AND gaz02=g_rlang
            END IF
            PRINTX l_p2
            #FUN-B40097----add---end-------------
              
        BEFORE GROUP OF sr1.aba01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.abb02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B40097----add---str-------------
            LET l_aba09_fmt = cl_gr_numfmt('aba_file','aba09',sr1.azi04)
            PRINTX l_aba09_fmt 
            LET l_aba08_fmt = cl_gr_numfmt('aba_file','aba08',sr1.azi04)
            PRINTX l_aba08_fmt
            LET l_abb07_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04)
            PRINTX l_abb07_fmt
            LET l_abb07f_fmt = cl_gr_numfmt('abb_file','abb07f',sr1.azi04)
            PRINTX l_abb07f_fmt
            IF NOT cl_null(sr1.abb05) AND NOT cl_null(sr1.gem02) THEN 
               LET l_abb05_gem02 = sr1.abb05,' ',sr1.gem02
            ELSE
               IF NOT cl_null(sr1.abb05) AND cl_null(sr1.gem02) THEN 
                  LET l_abb05_gem02 = sr1.abb05
               END IF
               IF cl_null(sr1.abb05) AND NOT cl_null(sr1.gem02) THEN
                   LET l_abb05_gem02 = sr1.gem02
               END IF
            END IF       

            IF cl_null(sr1.abb13) AND cl_null(sr1.abb14) THEN 
               LET l_abb13_abb14 = sr1.abb12
            ELSE
               IF cl_null(sr1.abb13) AND NOT cl_null(sr1.abb14) THEN 
                  LET l_abb13_abb14 = sr1.abb12,' ',sr1.abb14
               ELSE
                  IF NOT cl_null(sr1.abb13) AND cl_null(sr1.abb14) THEN 
                     LET l_abb13_abb14 = sr1.abb12,' ',sr1.abb13
                  ELSE
                     LET l_abb13_abb14 = sr1.abb12,' ',sr1.abb13,' ',sr1.abb14
                  END IF
               END IF
            END IF 

            PRINTX l_abb13_abb14
            PRINTX l_abb05_gem02

            IF sr1.abb06 = '1' THEN 
               LET l_abb06 = cl_gr_getmsg("gre-086",g_lang,'1')
            ELSE
               LET l_abb06 = cl_gr_getmsg("gre-086",g_lang,'0')
            END IF  
            PRINTX l_abb06 
            #FUN-B40097----add---end-------------
             

            PRINTX sr1.*

        AFTER GROUP OF sr1.aba01
        AFTER GROUP OF sr1.abb02

        
        ON LAST ROW

END REPORT
###GENGRE###END
