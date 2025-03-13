# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: gglx001.4gl        #
# Descriptions...: 科目結構表         #
# Date & Author..: 02/08/19 By Winny
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.TQC-5B0097 05/11/14 By day 1. per轉GP/可由agli102.agli100傳入參數打印
#                                                2. 改寫報表結構
# Modify.........: NO.TQC-650054 06/05/12 BY yiting 報表錯誤
# Modify.........: No.TQC-650071 06/05/16 By wujie   1：增加是否按照科目編號來跳                                                                                                        2：打印時在各科目編號后打印
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-690009 06/09/05 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0094 06/11/10 By johnray 報表修改
# Modify.........: No.FUN-740032 07/04/12 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-740332 07/04/30 By bnlent 報表表頭格式調整
# Modify.........: No.TQC-7B0102 07/11/16 By Rayven 參數調整有誤，重新調整
#                                                   為一級統制科目時才打印
# Modify.........: No.FUN-830053 08/08/04 By baofei 報表打印改為CR輸出
# Modify.........: No.MOD-890101 08/09/17 By Sarah x001_bom()段組SQL時不需過濾aag01!=p_key,這樣會將獨立帳戶科目都排除掉
# Modify.........: No.MOD-860252 08/06/23 By chenl  增加打印時可選擇貨幣性質或非貨幣性質科目的選擇功能。
# Modify.........: No.TQC-940042 09/05/07 By mike 刪除冗余代碼 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60203 10/06/30 By Dido 原判斷 aag24 != 1 改用 aag07 != '2'  
# Modify.........: No.FUN-B20010 11/02/10 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.TQC-B30147 11/03/17 By yinhy 查詢條件為空，跳到科目編號欄位
# Modify.........: No.TQC-B40019 11/04/06 By Dido 調整明細科目無法印出問題
# Modify.........: No.FUN-B40024 11/04/15 By jason 修改科目結構表
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.MOD-BC0026 11/12/05 By Dido 調整 l_sql/tm.wc 為 STRING 
# Modify.........: No.FUN-CA0132 12/11/05 By zhangweib CR轉XtraGrid
# Modify.........: No.FUN-D40129 13/05/22 By yangtt 去除畫面當上【依科目編號跳頁】
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          wc        STRING,    #NO FUN-690009   VARCHAR(300)  #MOD-BC0026 mod 1000 -> STRING     #No.FUN-CA0132
          bookno    LIKE aaa_file.aaa01,       #No.FUN-740032
         #t     LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(01)       #No.TQC-650071   #FUN-D40129 mark 
          h     LIKE type_file.chr1,   #No.MOD-860252  
          more  LIKE type_file.chr1        #NO FUN-690009   VARCHAR(01)
          END RECORD,
          g_bookno   LIKE aah_file.aah00   #帳別   #TQC-610056
 
DEFINE   g_aag01         LIKE aag_file.aag01  #No.TQC-5B0097
DEFINE   g_aag02         LIKE aag_file.aag02  #No.TQC-5B0097
DEFINE   g_i             LIKE type_file.num5        #NO FUN-690009   SMALLINT   #count/index for any purpose
DEFINE   g_end           LIKE type_file.num5        #NO FUN-690009   SMALLINT   #No.TQC-5B0097
DEFINE   g_level_end ARRAY[20] OF LIKE type_file.num5        #NO FUN-690009   SMALLINT    #No.TQC-5B0097
#No.FUN-830053---Begin                                                                                                              
DEFINE   g_p  DYNAMIC ARRAY OF RECORD                                                                                               
         aag01  LIKE aag_file.aag01                                                                                                 
         END RECORD                                                                                                                 
 DEFINE l_table        STRING,                                                                                                      
        g_str          STRING,                                                                                                      
        g_sql          STRING                                                                                                       
#No.FUN-830053---End 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

#No.FUN-830053---Begin
   #NO.FUN-B40024 --Begin                                                                                                              
   #LET g_sql = "g_aag01.aag_file.aag01,",                                                                                            
   #            "g_aag02.aag_file.aag02,",                                                                                           
   #            "aag01.aag_file.aag01,",                                                                                             
   #            "aag02.aag_file.aag02,",                                                                                             
   #            "aag24.aag_file.aag24,",                                                                                             
   #            "aag08.aag_file.aag08,",                                                                                             
   #            "p_level.type_file.num5"
   LET g_sql = "aag01.aag_file.aag01,",
               "aag02.aag_file.aag02,",
               "aag08.aag_file.aag08,"
   #NO.FUN-B40024 --End   
   LET l_table = cl_prt_temptable('gglx001',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?) " #NO.FUN-B40024               

   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-830053---End   
 
#No.TQC-5B0097-begin
    #-----No.MOD-4C0171-----
#   LET g_bookno = ARG_VAL(1)   #TQC-610056  #No.TQC-7B0102 mark
    LET tm.bookno= ARG_VAL(1)                #No.TQC-7B0102
    LET g_pdate         = ARG_VAL(2)
    LET g_towhom = ARG_VAL(3)
    LET g_rlang  = ARG_VAL(4)
    LET g_bgjob  = ARG_VAL(5)
    LET g_prtway = ARG_VAL(6)
    LET g_copies = ARG_VAL(7)
    LET tm.wc    = ARG_VAL(8)
    #No.FUN-740032  --Begin
#   LET tm.bookno= ARG_VAL(9)   #No.TQC-7B0102 mark
 #  LET tm.t     = ARG_VAL(9)   #TQC-610056  #No.TQC-7B0102 10->9   #FUN-D40129 mark
    #No.FUN-740032  --End  
  #FUN-D40129---mod---str--
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(10)
  #LET g_rep_clas = ARG_VAL(11)
  #LET g_template = ARG_VAL(12)
  ##No.FUN-570264 ---end---
   LET g_rep_user = ARG_VAL(09)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
  #FUN-D40129---mod---end--
    #-----No.MOD-4C0171 END-----
#No.TQC-5B0097-end
 
#No.TQC-5B0097-begin

  CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
  IF NOT cl_null(tm.wc) THEN
      CALL x001()
  ELSE
    IF cl_null(g_bgjob) OR g_bgjob = 'N'      # If background job sw is off
       THEN CALL x001_tm(0,0)                 # Input print condition
       ELSE CALL x001()                       # Read data and create out-file
    END IF
  END IF
  CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
#No.TQC-5B0097-end
 
END MAIN
 
 
FUNCTION x001_tm(p_row, p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row, p_col        LIKE type_file.num5        #NO FUN-690009   SMALLINT
   DEFINE l_cmd        LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(400)
 
   LET p_row = 5 LET p_col = 11
   OPEN WINDOW x001_w AT p_row, p_col
        WITH FORM "ggl/42f/gglx001"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL
   LET tm.bookno= g_aza.aza81  #No.FUN-740032
 # LET tm.t     = 'Y'      #No.TQC-650071 #FUN-D40129 mark 
   LET tm.h     = 'Y'      #No.MOD-860252
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      #No.FUN-B20010  --Begin
      DIALOG ATTRIBUTE(unbuffered)
      INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS) 
         
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         
         AFTER FIELD bookno
            IF NOT cl_null(tm.bookno) THEN
               CALL x001_bookno(tm.bookno)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.bookno,g_errno,0)
                  LET tm.bookno = g_aza.aza81
                  DISPLAY BY NAME tm.bookno
                  NEXT FIELD bookno
               END IF
            END IF
 
    END INPUT
    #No.FUN-B20010  --End
    
      CONSTRUCT BY NAME tm.wc ON aag01
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---        
#No.FUN-B20010  --Mark Begin         
#         ON ACTION locale
#        #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          LET g_action_choice = "locale"
#          EXIT CONSTRUCT
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
# 
#       ON ACTION about         #MOD-4C0121
#          CALL cl_about()      #MOD-4C0121
# 
#       ON ACTION help          #MOD-4C0121
#          CALL cl_show_help()  #MOD-4C0121
# 
#       ON ACTION controlg      #MOD-4C0121
#          CALL cl_cmdask()     #MOD-4C0121
# 
#       ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#       ON ACTION qbe_select
#          CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
  END CONSTRUCT
#No.FUN-B20010  --Mark Begin
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
#    IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW x001_w
#        EXIT PROGRAM
#    END IF
#    IF tm.wc = ' 1=1' THEN
#        CALL cl_err('', '9046', 0) CONTINUE WHILE
#        #科目編號不允空白
#    END IF
# 
#    INPUT BY NAME tm.bookno,tm.t,tm.h,tm.more WITHOUT DEFAULTS        #No.TQC-650071  #No.FUN-740032 #No.MOD-860252 add h #FUN-B20010 mark
#No.FUN-B20010  --Mark End
   #INPUT BY NAME tm.t,tm.h,tm.more ATTRIBUTE(WITHOUT DEFAULTS)     #FUN-B20010  #FUN-D40129 mark
    INPUT BY NAME tm.h,tm.more ATTRIBUTE(WITHOUT DEFAULTS)     #FUN-B20010   #FUN-D40129 add
          #輸入2.其他列印條件                                                                                                       
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         #No.FUN-B20010  --Mark Begin
         #No.FUN-740032  --Begin
         #AFTER FIELD bookno
         #   IF NOT cl_null(tm.bookno) THEN
         #      CALL x001_bookno(tm.bookno)
         #      IF NOT cl_null(g_errno) THEN
         #         CALL cl_err(tm.bookno,g_errno,0)
         #         LET tm.bookno = g_aza.aza81
         #         DISPLAY BY NAME tm.bookno
         #         NEXT FIELD bookno
         #      END IF
         #   END IF
         #No.FUN-740032  --End   
         #No.FUN-B20010  --Mark End 
 
#No.TQC-650071--begin                                                                                                               
      # AFTER FIELD t         #FUN-D40129 mark                                                                                                       
      #   IF tm.t NOT MATCHES '[YN]' OR cl_null(tm.t) THEN NEXT FIELD t END IF      #FUN-D40129 mark                                                 
#No.TQC-650071--end  
 
        AFTER FIELD more
          IF tm.more = 'Y' THEN
                CALL cl_repcon(0, 0, g_pdate, g_towhom, g_rlang,
                	       g_bgjob, g_time, g_prtway, g_copies)
                RETURNING g_pdate, g_towhom, g_rlang,
                       g_bgjob, g_time, g_prtway, g_copies
          END IF
#No.FUN-B20010  --Mark Begin      
       #No.FUN-740032  --Begin
#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(bookno) 
#                CALL cl_init_qry_var()
#                LET g_qryparam.form ="q_aaa"
#                LET g_qryparam.default1 = tm.bookno
#                CALL cl_create_qry() RETURNING tm.bookno
#                DISPLAY BY NAME tm.bookno
#                NEXT FIELD bookno
#          END CASE
#       #No.FUN-740032  --End  
#
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
# 
#       ON ACTION CONTROLG
#          CALL cl_cmdask()
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
# 
#       ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
#No.FUN-B20010  --Mark End
    END INPUT
    #No.FUN-B20010  --Begin
    ON ACTION CONTROLP
          CASE
             WHEN INFIELD(bookno) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                LET g_qryparam.default1 = tm.bookno
                CALL cl_create_qry() RETURNING tm.bookno
                DISPLAY BY NAME tm.bookno
                NEXT FIELD bookno
             WHEN INFIELD(aag01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aag'
                LET g_qryparam.state= 'c'
                LET g_qryparam.where = " aag00 = '",tm.bookno CLIPPED,"'" 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aag01
                NEXT FIELD aag01
             OTHERWISE EXIT CASE
          END CASE
     ON ACTION locale
        CALL cl_show_fld_cont() 
        LET g_action_choice = "locale"
        EXIT DIALOG
     ON ACTION CONTROLR
        CALL cl_show_req_fields()

     ON ACTION CONTROLG
        CALL cl_cmdask()

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG

     ON ACTION about    
        CALL cl_about()

     ON ACTION help   
        CALL cl_show_help()

     ON ACTION exit
        LET INT_FLAG = 1
        EXIT DIALOG
        
     ON ACTION accept
        #No.TQC-B30147 --Begin
        IF cl_null(tm.wc) OR tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         NEXT FIELD aag01
        END IF
        #No.TQC-B30147 --End
        EXIT DIALOG
       
     ON ACTION cancel
        LET INT_FLAG=1
        EXIT DIALOG   
   END DIALOG
   IF g_action_choice = "locale" THEN
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CONTINUE WHILE
   END IF     
     
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW x001_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
    END IF
    IF tm.wc = ' 1=1' THEN
        CALL cl_err('', '9046', 0) CONTINUE WHILE        #科目編號不允空白
    END IF
    #No.FUN-B20010  --End
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='gglx001'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglx001','9031',1)   
       ELSE
       LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
#                         " '",g_bookno CLIPPED,"'",   #TQC-610056 #No.TQC-7B0102 mark
                          " '",tm.bookno CLIPPED,"'" , #No.TQC-7B0102 
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          " '",g_lang CLIPPED,"'",
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.wc CLIPPED,"'" ,
#                         " '",tm.bookno CLIPPED,"'" ,          #No.FUN-740032 #No.TQC-7B0102 mark
                        #" '",tm.t CLIPPED,"'" ,   #TQC-610056  #FUN-D40129 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
          CALL cl_cmdat('gglx001',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW gglx001_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       EXIT PROGRAM
    END IF
 
    CALL cl_wait()
    CALL x001()
    ERROR ""
 
END WHILE
    CLOSE WINDOW x001_w
END FUNCTION
 
#No.FUN-740032  --Begin
FUNCTION x001_bookno(p_bookno)
  DEFINE p_bookno   LIKE aaa_file.aaa01,
         l_aaaacti  LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-740032  --End  

#NO.FUN-B40024 --Begin
{
FUNCTION x001()
    DEFINE l_name        LIKE type_file.chr20       #NO FUN-690009   VARCHAR(20)
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0097
    DEFINE l_sql         STRING     #NO FUN-690009   VARCHAR(600) #MOD-BC0026 mod 1000 -> STRING
    DEFINE l_za05        LIKE type_file.chr1000     #NO FUN-690009   VARCHAR(40)
#No.TQC-5B0097-begin
    DEFINE p_level      LIKE type_file.num5        #NO FUN-690009   SMALLINT
    DEFINE sr           RECORD
                          aag01 LIKE aag_file.aag01,    #科目代號
                          aag02 LIKE aag_file.aag02,    #科目名稱
                          aag07 LIKE aag_file.aag07,    #統制科目
                          aag08 LIKE aag_file.aag08,    #所屬統制科目
                          aag24 LIKE aag_file.aag24,    #科目層級
                          aagacti LIKE aag_file.aagacti
                        END RECORD
    DEFINE sr_null      RECORD
                          aag01 LIKE aag_file.aag01,    #科目代號
                          aag02 LIKE aag_file.aag02,    #科目名稱
                          aag07 LIKE aag_file.aag07,    #統制科目
                          aag08 LIKE aag_file.aag08,    #所屬統制科目
                          aag24 LIKE aag_file.aag24,    #科目層級
                          aagacti LIKE aag_file.aagacti
                        END RECORD
#No.TQC-5B0097-end
    CALL cl_del_data(l_table)    #No.FUN-830053  
     #No.FUN-B80096--mark--Begin---
     #CALL cl_used(g_prog, g_time, 1) RETURNING g_time #No.MOD-580088  HCN 20050818  FUN-6A0097
     #No.FUN-B80096--mark--End-----
#    CALL cl_outnam('gglx001') RETURNING l_name  #NO.TQC-650054 #FUN-830053 MARK BY COCKROACH
 
    SELECT zo02 INTO g_company FROM zo_file
      WHERE  zo01 = g_rlang
#TQC-940042  ---start                                                                                                               
   #SELECT zz17, zz05 INTO g_len, g_zz05                                                                                            
   #  FROM zz_file WHERE zz01= 'gglx001'                                                                                            
   #IF g_len = 0 OR g_len IS NULL THEN                                                                                              
   #    LET g_len = 80                                                                                                              
   #END IF                                                                                                                          
   #FOR g_i = 1 TO g_len                                                                                                            
   #    LET g_dash[g_i, g_i] = '='                                                                                                  
   #END FOR                                                                                                                         
#TQC-940042  ---end       
    #Begin:FUN-980030
    #    IF g_priv2 = '4' THEN
    #        LET tm.wc = tm.wc clipped,
    #                    "AND occuser = '", g_user, "'"
    #    END IF
    #    IF g_priv3='4' THEN
    #        LET tm.wc = tm.wc CLIPPED,
    #                    "AND occgrup MATCHES '", g_grup CLIPPED, "*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc CLIPPED,
    #                    "AND occgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
    #End:FUN-980030
 
#No.TQC-5B0097-begin
    LET l_sql = "SELECT UNIQUE aag01,aag02,aag07,aag08,aag24,aagacti",
                "  FROM aag_file ",
                "  WHERE ", tm.wc CLIPPED,
                "    AND aag24 IS NOT NULL ",   #層級不可為空
                "    AND aag08 IS NOT NULL ",   #所屬統治科目不可為空
                "    AND aag01 = aag08 ",       #No.TQC-7B0102
                "    AND aag07  != '2' ",       #明細科目不單獨單印
                "    AND aagacti = 'Y' ",
                "    AND aag00 = '",tm.bookno,"'",  #No.FUN-740032
                " "  #No.MOD-860252
     IF tm.h ='Y' THEN                         #No.MOD-860252 
        LET l_sql = l_sql," AND aag09='Y' "    #No.MOD-860252
     END IF                                    #No.MOD-860252
     LET l_sql = l_sql,                        #No.MOD-860252
                "  GROUP BY aag01,aag02,aag07,aag08,aag24,aagacti",
                "  ORDER BY aag01,aag08,aag24"
#No.TQC-5B0097-end
 
    PREPARE x001_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:', SQLCA.sqlcode, 1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        EXIT PROGRAM
    END IF
 
    DECLARE x001_curs1 CURSOR FOR x001_prepare1
    INITIALIZE sr_null.* TO NULL  #No.TQC-5B0097
#    CALL cl_outnam('gglx001') RETURNING l_name  #NO.TQC-650054
 
#    START REPORT x001_rep TO l_name    #No.FUN-830053  
 
     LET g_pageno = 1        #No.TQC-5B0097
     LET p_level = 0         #No.TQC-5B0097
    FOREACH x001_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:', SQLCA.sqlcode, 1) EXIT FOREACH
        END IF
#No.TQC-5B0097-begin
       LET g_aag01=sr.aag01
       LET g_aag02=sr.aag02
       LET g_pageno = 0
#       OUTPUT TO REPORT x001_rep(p_level,sr.*)     #No.FUN-830053 
#       OUTPUT TO REPORT x001_rep(p_level+1,sr_null.*)  #No.FUN-830053 
       LET g_end = 0
       CALL x001_bom(0,sr.aag01)
       LET g_end = 1
#No.TQC-5B0097-end
    END FOREACH
#No.FUN-830053---Begin                                                                                                              
#    FINISH REPORT x001_rep                                                                                                         
###XtraGrid###      LET g_str=tm.t,";",g_towhom                                                                                                   
                                                                                                                                    
###XtraGrid###   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                               
###XtraGrid###   CALL cl_prt_cs3('gglx001','gglx001',l_sql,g_str)                                                                                 
    LET g_xgrid.table = 'l_table'    ###XtraGrid###
    CALL cl_xg_view    ###XtraGrid###
#    CALL cl_prt(l_name, g_prtway, g_copies, g_len)                                                                                 
#No.FUN-830053---End  
 
      #No.FUN-BB0047--mark--Begin---
      #CALL cl_used(g_prog, g_time, 2) RETURNING g_time #No.MOD-580088  HCN 20050818 FUN-6A0097
      #No.FUN-BB0047--mark--End-----
END FUNCTION
}
FUNCTION x001()
    DEFINE sr DYNAMIC ARRAY OF RECORD           
           aag01   LIKE aag_file.aag01,
           aag02   LIKE aag_file.aag02,
           aag08   LIKE aag_file.aag08
          END RECORD
   DEFINE l_n LIKE type_file.num5
   
    CALL cl_del_data(l_table)     
    #No.FUN-B80096--mark--Begin--- 
    #CALL cl_used(g_prog, g_time, 1) RETURNING g_time    
    #No.FUN-B80096--mark--End-----
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
    
    IF tm.wc IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF

   LET g_sql="SELECT aag01,aag02,aag08 FROM aag_file ",
              " WHERE ",tm.wc CLIPPED, 
              " and aagacti = 'Y' ",
              " and aag00 = '", tm.bookno ,"' "
              
   IF tm.h ='Y' THEN
      LET g_sql = g_sql," AND aag09='Y' "
   END IF
   
   LET g_sql = g_sql, " order by aag01"
   
   PREPARE x001_prepare1 FROM g_sql                
   DECLARE x001_curs1 CURSOR FOR x001_prepare1
    
   LET l_n = 1
   CALL sr.clear()
   FOREACH x001_curs1 INTO sr[l_n].*
       IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       EXECUTE insert_prep USING sr[l_n].aag01,sr[l_n].aag02,sr[l_n].aag08
       LET l_n = l_n + 1
    END FOREACH
    CALL sr.deleteElement(l_n)
    LET l_n = l_n - 1
    #LET g_str=tm.wc

    #第一層 --start--
    WHILE TRUE
        LET l_n = 1                
        CALL sr.clear()
        
        LET g_sql = "SELECT aag01,aag02,aag08 FROM aag_file ",
                    " where azt01 in (select aag08 from ", g_cr_db_str CLIPPED, l_table CLIPPED ,
                                     " WHERE  aag01 <> aag08) ",
                    " and not aag01 in (select aag01 from ", g_cr_db_str CLIPPED, l_table CLIPPED ," ) ",
                    " and aagacti = 'Y' ",
                    " and aag00 = '", tm.bookno ,"' ",
                    " order by aag01"

        PREPARE i102_p3 FROM g_sql
        DECLARE i102_co3 CURSOR FOR i102_p3

        FOREACH i102_co3 INTO sr[l_n].*
           IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,1)
               EXIT WHILE
           END IF
           EXECUTE insert_prep USING sr[l_n].aag01,sr[l_n].aag02,sr[l_n].aag08
           LET l_n = l_n + 1
        END FOREACH
        LET l_n = l_n - 1
        IF l_n < 1 THEN EXIT WHILE END IF
    END WHILE
    #第一層 --end--
    
    #其它層 --start--
    WHILE TRUE
        LET l_n = 1                
        CALL sr.clear()
        LET g_sql = "SELECT aag01,aag02,aag08 FROM aag_file ",
                    " where aag08 in (select aag01 from ", g_cr_db_str CLIPPED, l_table CLIPPED ," ) ",                                     
                    " and not aag01 in (select aag01 from ", g_cr_db_str CLIPPED, l_table CLIPPED ," ) ",
                    " and aagacti = 'Y' ",
                    " and aag00 = '", tm.bookno ,"' ",
                    " order by aag01"
        PREPARE i102_p4 FROM g_sql
        DECLARE i102_co4 CURSOR FOR i102_p4
        FOREACH i102_co4 INTO sr[l_n].*
           IF SQLCA.sqlcode THEN
               CALL cl_err('Foreach:',SQLCA.sqlcode,1)
               EXIT WHILE
           END IF
           EXECUTE insert_prep USING sr[l_n].aag01,sr[l_n].aag02,sr[l_n].aag08
           LET l_n = l_n + 1
        END FOREACH
        LET l_n = l_n - 1
        IF l_n < 1 THEN EXIT WHILE END IF
    END WHILE 
    #其它層 --end--

 # LET g_str=tm.t,";",g_towhom  #FUN-D40129 mark                                                                                                 
   LET g_str=g_towhom           #FUN-D40129 add                                                                                        
                                                                                                                                    
   LET g_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
###XtraGrid###   CALL cl_prt_cs3('gglx001','gglx001',g_sql,g_str)   
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.order_field = cl_get_order_field('3',"aag01,aag02,aag08")
    CALL cl_xg_view()    ###XtraGrid###

   #No.FUN-B80096--mark--Begin---
   #CALL cl_used(g_prog, g_time, 2) RETURNING g_time #No.MOD-580088  HCN 20050818 FUN-6A0097
   #No.FUN-B80096--mark--End-----

END FUNCTION
#NO.FUN-B40024 --End
 
#No.TQC-5B0097-begin
FUNCTION x001_bom(p_level,p_key)
        DEFINE  p_level LIKE type_file.num5,       #NO FUN-690009   SMALLINT
                p_key   LIKE aag_file.aag08,
                i,j         LIKE type_file.num5,       #NO FUN-690009   SMALLINT
                l_time      LIKE type_file.num5,       #NO FUN-690009   SMALLINT
                l_count     LIKE type_file.num5,       #NO FUN-690009   SMALLINT
                l_sql       STRING,    #NO FUN-690009   VARCHAR(1000) #MOD-BC0026 mod 1000 -> STRING
                sr DYNAMIC ARRAY OF RECORD
                          aag01 LIKE aag_file.aag01,    #科目代號
                          aag02 LIKE aag_file.aag02,    #科目名稱
                          aag07 LIKE aag_file.aag07,    #統制科目
                          aag08 LIKE aag_file.aag08,    #所屬統制科目
                          aag24 LIKE aag_file.aag24,    #科目層級
                          aagacti LIKE aag_file.aagacti
                        END RECORD
        INITIALIZE sr[600].* TO NULL
 
           LET l_sql="SELECT unique aag01,aag02,aag07,aag08,aag24,aagacti ",
                     "  FROM aag_file",
                     " WHERE aag08  = '",p_key,"' ",
                    #"   AND aag01 != '",p_key,"' ",    #MOD-890101 mark
                    #"   AND aag24 != 1 ",              #MOD-A60203 mark
                    #"   AND aag07 != '2' ",                                   #TQC-B40019 mark
                     "   AND ((aag24 != 1 and aag07 !='3') OR (aag07 = '3'))", #TQC-B40019
                     "   AND aagacti = 'Y' ",
                     "   AND aag00 = '",tm.bookno,"'",  #No.FUN-740032
                     " ORDER BY aag01,aag08,aag24"
 
        PREPARE bom_prepare FROM l_sql
        IF SQLCA.sqlcode THEN
          CALL cl_err('Prepare:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
          EXIT PROGRAM
        END IF
        DECLARE bom_cs CURSOR FOR bom_prepare
        LET p_level = p_level + 1
        IF p_level > 20 THEN RETURN END IF
        LET l_count = 1
        FOREACH bom_cs INTO sr[l_count].*
           IF SQLCA.sqlcode THEN
              CALL cl_err('bom_cs',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           LET  l_count = l_count + 1
        END FOREACH
        LET l_count = l_count - 1
        LET g_level_end[p_level] = 0
        FOR i = 1 TO l_count
          IF l_count = i THEN LET g_level_end[p_level] = 1 END IF
#          OUTPUT TO REPORT x001_rep(p_level,sr[i].*)    #No.FUN-830053 
          EXECUTE insert_prep USING g_aag01,g_aag02,sr[i].aag01,sr[i].aag02,sr[i].aag24,sr[i].aag08,p_level   #FUN-830053           
 
          SELECT aag01 FROM aag_file
                       WHERE aag08 = sr[i].aag01
                         AND aag01 != sr[i].aag01
                         AND aag00 = tm.bookno  #No.FUN-740032
                        #AND aag07 = '1'        #MOD-A60203       #TQC-B40019 mark
          IF status != NOTFOUND AND p_level < 20 THEN
#             OUTPUT TO REPORT x001_rep(p_level+1,sr[600].*)  #No.FUN-830053 
             CALL x001_bom(p_level,sr[i].aag01)
          END IF
        END FOR
END FUNCTION
#No.TQC-5B0097-end
#No.FUN-830053---Begin  
#REPORT x001_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,       #NO FUN-690009   VARCHAR(1)
#         l_rowno      LIKE type_file.num5,       #NO FUN-690009   SMALLINT
#         l_col,i      LIKE type_file.num5,       #NO FUN-690009   SMALLINT  #No.TQC-5B0097
#         l_first_sw   LIKE type_file.chr1        #NO FUN-690009   VARCHAR(1)
##No.TQC-5B0097-begin
#  DEFINE sr           RECORD
#                      p_level LIKE type_file.num5,    #NO FUN-690009 SMALLINT
#                        aag01 LIKE aag_file.aag01,    #科目代號
#                        aag02 LIKE aag_file.aag02,    #科目名稱
#                        aag07 LIKE aag_file.aag07,    #統制科目
#                        aag08 LIKE aag_file.aag08,    #所屬統制科目
#                        aag24 STRING,                 #科目層級    #No.TQC-650071
#                        aagacti LIKE aag_file.aagacti
#                      END RECORD
##No.TQC-5B0097-end
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
 
#  FORMAT
#     PAGE HEADER
#        PRINT(g_len-FGL_WIDTH(g_company CLIPPED ))/2 SPACES, g_company CLIPPED 
#        IF g_towhom IS NULL OR g_towhom = ' ' THEN
#           PRINT '';
#        ELSE
#           PRINT 'TO:', g_towhom,' ';
#        END IF
##No.TQC-6A0094 -- begin --
##         PRINT g_x[2] CLIPPED, g_pdate, ' ', TIME                              
##         PRINT COLUMN g_len-7, g_x[3] CLIPPED, PAGENO USING '<<<'
#        PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES, g_x[1]      #No.TQC-740332
#        PRINT g_x[2] CLIPPED, g_pdate,' ',TIME,
#              COLUMN (g_len-FGL_WIDTH(g_user)-15),'FROM:',g_user CLIPPED,
#              COLUMN g_len-7, g_x[3] CLIPPED, PAGENO USING '<<<'
#        #PRINT ' '         #No.TQC-740332
##No.TQC-6A0094 -- end --
#        PRINT g_dash[1, g_len]
#        LET l_last_sw = 'n'
 
##No.TQC-5B0097-begin
##No.TQC-650071--begin                                                                                                               
#        IF tm.t ='Y' THEN                                                                                                                   
#           PRINT g_aag01 CLIPPED,'  ',g_aag02                                                                                          
#        ELSE                                                                                                                                
#           PRINT ''
#        END IF                                                                                                                              
##No.TQC-650071--end                                                                                                                 
#                     
#
#     ON EVERY ROW
#         IF sr.p_level = 0 THEN
##No.TQC-650071--begin                                                                                                               
#           IF g_pageno ! ='0' THEN                                                                                                    
#              PRINT g_aag01 CLIPPED,'  ',g_aag02                                                                                      
#           END IF                                                                                                                     
#           IF tm.t ='Y' THEN                                                                                                          
#              SKIP TO TOP OF PAGE                                                                                                      
#           ELSE                                                                                                                       
#              PRINT g_aag01 CLIPPED,'  ',g_aag02                                                                                      
#           END IF                                                                                                                     
##No.TQC-650071--end 
#        ELSE
#           FOR i = 1 to (sr.p_level - 1)
#              IF g_level_end[i] THEN
#                 PRINT COLUMN (4 * i ), '  '  CLIPPED;
#              ELSE
#                 PRINT COLUMN (4 * i ),g_x[7] CLIPPED;
#              END IF
#           END FOR
#           LET i = sr.p_level
#           IF cl_null(sr.aag01) THEN
#              PRINT COLUMN ( sr.p_level * 4 ) CLIPPED,g_x[7]
#           ELSE 
#              IF g_level_end[i]  THEN
#                 PRINT COLUMN ( sr.p_level * 4) CLIPPED,g_x[8] CLIPPED;
#              ELSE
#                 PRINT COLUMN ( sr.p_level * 4) CLIPPED,g_x[6] CLIPPED;
#              END IF
#              PRINT sr.aag01 CLIPPED,'  ',
#                    sr.aag02 CLIPPED,
#                    "(",sr.aag24.trim(),")"            #No.TQC-650071  
#              IF g_level_end[i]  THEN
#                 FOR i = 1 to (sr.p_level - 1)
#                    IF NOT g_level_end[i] THEN
#                       PRINT COLUMN (4 * i ),g_x[7] CLIPPED
#                    END IF
#                 END FOR
#              END IF
#           END IF
#        END IF
##No.TQC-5B0097-end
 
## No.TQC-6A0094 -- begin --
##         ON LAST ROW
##            LET l_last_sw = 'y'
##            LET l_first_sw = null
##            PRINT g_dash[1, g_len]
##            PRINT '(gglx001)';
##            PRINT COLUMN (g_len-10), g_x[5] CLIPPED
##        
##         PAGE TRAILER
##            IF l_last_sw = 'n' THEN
##               PRINT g_dash[1, g_len]
##               PRINT '(gglx001)';
##               PRINT COLUMN (g_len-10), g_x[4] CLIPPED
##            ELSE
##               SKIP 2 LINE
##            END IF
#        ON LAST ROW
#           LET l_last_sw = 'y'
#           PRINT g_dash[1,g_len]
#           PRINT g_x[9] CLIPPED, COLUMN (g_len-9), g_x[5] CLIPPED
 
#        PAGE TRAILER
#           IF l_last_sw = 'n' THEN
#              PRINT g_dash[1,g_len]                                                                                                      
#              PRINT g_x[9] CLIPPED, COLUMN (g_len-9), g_x[4] CLIPPED
#           ELSE
#              SKIP 2 LINE
#           END IF
##No.TQC-6A0094 -- end --
#END REPORT
#No.FUN-830053---End  
#Patch....NO.TQC-610037 <001> #


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

