# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglg905.4gl
# Descriptions...: 總分類帳
# Input parameter:
# Return code....:
# Date & Author..: 92/03/10 By DAVID
# Modify.........: No.FUN-510007 05/01/14 By Nicola 報表架構修改
# Modify.........: No.MOD-5B0220 05/11/21 By Smapmin 頁次分母空白
# Modify.........: No.FUN-5C0015 06/01/03 By miki
#                  列印l_buf異動碼值內容，加上abb11~36，放寬欄寬至60
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.MOD-680101 06/09/06 By Smapmin 抓取異動碼資料有誤
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/10 BY cheunl 修改報表格式
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 新增打印額外名稱功能
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.FUN-740020 07/04/12 By dxfwo    會計科目加帳套
# Modify.........: No.MOD-740250 07/04/22 By Sarah 重新過單
# Modify.........: No.TQC-760105 07/06/12 By dxfwo aglg905(總分類帳) 帳別 tm.bookno 未 display or deafult!
# Modify.........: No.MOD-810019 08/01/07 By Smapmin 預設列印獨立科目
# Modify.........: No.FUN-830100 08/03/24 By mike 報表輸出方式改為Crystal Reports
# Modify.........: No.MOD-850186 08/05/26 By Sarah l_bal_1值計算錯誤,報表明細排序有誤,Temptable增加l_n排序用
# Modify.........: No.FUN-940013 09/04/21 By jan aag01 欄位增加開窗功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990134 09/09/14 By mike 當aaz51='Y'時,需抓出該年第一期的起始日期CALL s_azm(yy,1) RETURNING l_flag,l_begin1
#                                                 抓取每日余額時,與抓取日期介於l_begin1~bdate間的日余額加總                         
# Modify.........: No:MOD-A50010 10/05/10 By sabrina 將l_flag變數改為g_flag，s_azm的除外 
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No:TQC-B10163 11/01/14 By Dido 延續 CHI-A70007 處理 s_azm 應改用 s_asmm 
# Modify.........: No.FUN-B20054 11/02/23 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B80158 11/09/15 By yangtt 明細類CR轉換成GRW
# Modify.........: No.FUN-B80158 12/01/05 By qirl MOD-BA0205,FUN-BB0047追單
# Modify.........: No.FUN-C50005 12/05/15 By qirl GR程式優化
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
            wc        STRING,                   # Where condition  #TQC-630166   
               t      LIKE type_file.chr1,      # none trans print (Y/N) ?        #No.FUN-680098 VARCHAR(1)
               u      LIKE type_file.chr1,      # Eject sw                        #No.FUN-680098 VARCHAR(1)
               s      LIKE type_file.chr1,      # abb04 print or not (Y/N)        #No.FUN-680098  VARCHAR(1) 
               v      LIKE type_file.chr1,      # extra abc04 print or not (Y/N)  #No.FUN-680098  VARCHAR(1) 
               x      LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1) 
               e      LIKE type_file.chr1,      #FUN-6C0012
               y      LIKE type_file.num5,      #No.FUN-680098  SMALLINT
               more   LIKE type_file.chr1,      # Input more condition(Y/N)       #No.FUN-680098  VARCHAR(1) 
             bookno   LIKE aaa_file.aaa01  #帳別    #No.FUN-740020   #MOD-740250
             END RECORD,
          yy  LIKE azn_file.azn02,   #No.FUN-680098      INTEGER
          mm  LIKE azn_file.azn04,   #No.FUN-680098      INTEGER     
        l_begin,l_end   LIKE type_file.dat,     #No.FUN-680098  DATE
        bdate,edate     LIKE type_file.dat,     #No.FUN-680098 DATE
        g_bookno LIKE aaa_file.aaa01,  #帳別    #No.FUN-740020   #NO.TQC-760105
#       bookno   LIKE aaa_file.aaa01,  #帳別    #No.FUN-740020
        l_flag  LIKE type_file.chr1,         #No.FUN-680098 VARCHAR(1)
        g_flag  LIKE type_file.chr1          #MOD-A50010 add
DEFINE  l_begin1 LIKE type_file.dat #MOD-990134                                                                                     
DEFINE  l_end1   LIKE type_file.dat #MOD-990134  
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 SMALLINT
DEFINE   l_sql           STRING                  #No.FUN-830100                                                                     
DEFINE   g_str           STRING                  #No.FUN-830100                                                                     
DEFINE   l_table1        STRING                  #No.FUN-830100                                                                     
DEFINE   l_table2        STRING                  #No.FUN-830100  
###GENGRE###START
TYPE sr1_t RECORD
    aea01 LIKE aea_file.aea01,
    aea02 LIKE aea_file.aea02,
    aea03 LIKE aea_file.aea03,
    aea04 LIKE aea_file.aea04,
    aba05 LIKE aba_file.aba05,
    aba06 LIKE aba_file.aba06,
    abb04 LIKE abb_file.abb04,
    abb05 LIKE abb_file.abb05,
    abb06 LIKE abb_file.abb06,
    abb07 LIKE abb_file.abb07,
    abb11 LIKE abb_file.abb11,
    abb12 LIKE abb_file.abb12,
    abb13 LIKE abb_file.abb13,
    abb14 LIKE abb_file.abb14,
    abb31 LIKE abb_file.abb31,
    abb32 LIKE abb_file.abb32,
    abb33 LIKE abb_file.abb33,
    abb34 LIKE abb_file.abb34,
    abb35 LIKE abb_file.abb35,
    abb36 LIKE abb_file.abb36,
    aag02 LIKE aag_file.aag02,
    aag13 LIKE aag_file.aag13,
    l_bal LIKE aas_file.aas04,
    l_buf LIKE type_file.chr1000,
    l_flag0 LIKE type_file.chr1,
    l_bal_1 LIKE aas_file.aas04,
    l_n LIKE type_file.num5,
    #FUN-B80158--------add----str----
    abb07_1 LIKE abb_file.abb07,
    abb07_2 LIKE abb_file.abb07
    #FUN-B80158--------add----end----
END RECORD

TYPE sr2_t RECORD
    abc01 LIKE abc_file.abc01,
    abc02 LIKE abc_file.abc02,
    abc04 LIKE abc_file.abc04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 #  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114#FUN-B80158
   #No.FUN-830100  --BEGIN
   LET l_sql = "aea01.aea_file.aea01,",
               "aea02.aea_file.aea02,",
               "aea03.aea_file.aea03,",
               "aea04.aea_file.aea04,",
               "aba05.aba_file.aba05,",
               "aba06.aba_file.aba06,",
               "abb04.abb_file.abb04,",
               "abb05.abb_file.abb05,",
               "abb06.abb_file.abb06,",
               "abb07.abb_file.abb07,",
               "abb11.abb_file.abb11,",
               "abb12.abb_file.abb12,",
               "abb13.abb_file.abb13,",
               "abb14.abb_file.abb14,",
               "abb31.abb_file.abb31,",
               "abb32.abb_file.abb32,",
               "abb33.abb_file.abb33,",
               "abb34.abb_file.abb34,",
               "abb35.abb_file.abb35,",
               "abb36.abb_file.abb36,",
               "aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,",
               "l_bal.aas_file.aas04,",
               "l_buf.type_file.chr1000,",
               "l_flag0.type_file.chr1,",
               "l_bal_1.aas_file.aas04,",
               "l_n.type_file.num5,",   #MOD-850186 add
               #FUN-B80158--------add----str----
               "abb07_1.abb_file.abb07,",
               "abb07_2.abb_file.abb07"
               #FUN-B80158--------add----end----
   LET l_table1 = cl_prt_temptable('aglg9051',l_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)               #FUN-B80158 add
      EXIT PROGRAM END IF                                                                                        
                                                                                                                                    
   LET l_sql = "abc01.abc_file.abc01,",                                                                                             
               "abc02.abc_file.abc02,",                                                                                             
               "abc04.abc_file.abc04"                                                                                               
   LET l_table2 = cl_prt_temptable('aglg9052',l_sql) CLIPPED                                                                        
   IF l_table2 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80158 add
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)               #FUN-B80158 add
      EXIT PROGRAM 
   END IF                                                                                        
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-B80158
   #No.FUN-830100  --END               
#  LET g_bookno= ARG_VAL(1)   #No.FUN-740020
   LET tm.bookno= ARG_VAL(1)  #No.FUN-740020
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.s  = ARG_VAL(11)
   LET tm.v  = ARG_VAL(12)
   LET tm.x  = ARG_VAL(13)
   #add 020815  NO.A030
   LET tm.y  = ARG_VAL(14)
   LET bdate = ARG_VAL(15)   #TQC-610056
   LET edate = ARG_VAL(16)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   #No.FUN-570264 ---end---
   LET tm.e  = ARG_VAL(20)  #FUN-6C0012
 
#  IF g_bookno IS  NULL OR g_bookno = ' ' THEN          #No.FUN-740020 
#     LET g_bookno = g_aaz.aaz64                        #No.FUN-740020
#  END IF                                               #No.FUN-740020
   IF tm.bookno IS  NULL OR tm.bookno = ' ' THEN        #No.FUN-740020
      LET tm.bookno = g_aza.aza81                       #No.FUN-740020  
   END IF                                               #No.FUN-740020  
   LET g_bookno = tm.bookno    #NO.TQC-760105
   #-->使用預設帳別之幣別
#  SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno     #No.FUN-740020
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno    #No.FUN-740020
   IF SQLCA.sqlcode THEN
      LET g_aaa03 = g_aza.aza17
   END IF     #使用本國幣別
 
   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_aaa03,SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
   END IF
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aglg905_tm()
   ELSE
      CALL aglg905()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)               #FUN-B80158 add
END MAIN
 
FUNCTION aglg905_tm()
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01       #No.FUN-580031
DEFINE p_row,p_col      LIKE type_file.num5,      #No.FUN-680098 SMALLINT
          l_cmd         LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno  LIKE type_file.num5             #No.FUN-B20054
 
#  CALL s_dsmark(g_bookno)   #No.FUN-740020
   CALL s_dsmark(tm.bookno)   #No.FUN-740020
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW aglg905_w AT p_row,p_col
     WITH FORM "agl/42f/aglg905"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
#  CALL s_shwact(0,0,g_bookno)
   CALL s_shwact(0,0,tm.bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
  #--------FUN-B80158----------------start-----FUN-B80158---star---
  #LET bdate   = NULL
   LET bdate   = g_today
  #LET edate   = NULL
   LET edate   = g_today
  #--------FUN-B80158----------------start-----FUN-B80158---end---
   LET tm.bookno = g_bookno  #No.TQC-760105
   LET tm.t    = 'Y'
   LET tm.u    = 'N'
   LET tm.s    = 'Y'
   LET tm.v    = 'N'
   LET tm.x    = 'Y' #MOD-810019 
   LET tm.e    = 'N' #FUN-6C0012
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   DISPLAY BY NAME tm.t,tm.u,tm.s,tm.v,tm.x,tm.e,tm.y,tm.more   #No.FUN-B20054
   WHILE TRUE
#No.FUN-B20054--add-start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT BY NAME tm.bookno ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD bookno
              IF NOT cl_null(tm.bookno) THEN
                   CALL s_check_bookno(tm.bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD bookno
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.bookno,"","agl-043","","",0)
                   NEXT FIELD  bookno
                END IF
             END IF
         END INPUT
#No.FUN-B20054--add-end-- 

       CONSTRUCT BY NAME tm.wc ON aag01
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--start-- 
#         #FUN-940013--begin--add
#       ON ACTION controlp 
#           CASE 
#              WHEN INFIELD(aag01)
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state    = "c" 
#                   LET g_qryparam.form = "q_aag" 
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret 
#                   DISPLAY g_qryparam.multiret TO aag01
#                   NEXT FIELD aag01
#              OTHERWISE EXIT CASE
#           END CASE
#       #FUN-940013--end--add 
#          ON ACTION locale
#             LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#             EXIT CONSTRUCT
# 
#          ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
# 
#           ON ACTION about         #MOD-4C0121
#              CALL cl_about()      #MOD-4C0121
# 
#           ON ACTION help          #MOD-4C0121
#              CALL cl_show_help()  #MOD-4C0121
# 
#           ON ACTION controlg      #MOD-4C0121
#              CALL cl_cmdask()     #MOD-4C0121
# 
#          ON ACTION exit
#             LET INT_FLAG = 1
#             EXIT CONSTRUCT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
      END CONSTRUCT
#No.FUN-B20054--mark--start--
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
# 
#       IF INT_FLAG THEN
#          LET INT_FLAG = 0
#          CLOSE WINDOW aglg905_w
#          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#          EXIT PROGRAM
#       END IF
# 
#       IF tm.wc = ' 1=1' THEN
#          CALL cl_err('','9046',0)
#          CONTINUE WHILE
#       END IF
# 
#       DISPLAY BY NAME tm.t,tm.u,tm.s,tm.v,tm.x,tm.e,tm.y,tm.more  #FUN-6C0012
# 
#       INPUT BY NAME tm.bookno,bdate,edate,tm.t,tm.u,tm.s,tm.v,tm.x,tm.e,tm.y,tm.more WITHOUT DEFAULTS  #FUN-6C0012
#No.FUN-B20054--mark--end-- 
        INPUT BY NAME bdate,edate,tm.t,tm.u,tm.s,tm.v,tm.x,tm.e,tm.y,tm.more  ATTRIBUTE(WITHOUT DEFAULTS)    #No.FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
          AFTER FIELD bdate
             IF bdate IS NULL THEN
                NEXT FIELD bdate
             END IF
 
          AFTER FIELD edate
             IF edate IS NULL THEN
                LET edate =g_lastdat
             END IF
 
             IF edate < bdate THEN
                CALL cl_err(' ','agl-031',0)
                NEXT FIELD edate
             END IF
 
          AFTER FIELD t
             IF tm.t NOT MATCHES "[YN]" THEN
                NEXT FIELD t
             END IF
 
          AFTER FIELD u
             IF tm.u NOT MATCHES "[YN]" THEN
                NEXT FIELD u
             END IF
 
          AFTER FIELD s
             IF tm.s NOT MATCHES "[YN]" THEN
                NEXT FIELD s
             END IF
 
          AFTER FIELD v
             IF tm.v NOT MATCHES "[YN]" THEN
                NEXT FIELD v
             END IF
 
          AFTER FIELD x
             IF tm.x NOT MATCHES "[YN]" THEN
                NEXT FIELD x
             END IF
 
          AFTER FIELD more
             IF tm.more = 'Y' THEN
                CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                               g_bgjob,g_time,g_prtway,g_copies)
                     RETURNING g_pdate,g_towhom,g_rlang,
                               g_bgjob,g_time,g_prtway,g_copies
             END IF
#No.FUN-B20054--mark--start--
#         #No.FUN-740020  --Begin                                                                                                    
#         ON ACTION CONTROLP                                                                                                         
#          CASE                                                                                                                      
#            WHEN INFIELD(bookno)                                                                                                    
#              CALL cl_init_qry_var()                                                                                                
#              LET g_qryparam.form = 'q_aaa'                                                                                         
#              LET g_qryparam.default1 = tm.bookno                                                                                      
#              CALL cl_create_qry() RETURNING tm.bookno                                                                                 
#              DISPLAY BY NAME tm.bookno                                                                                                
#              NEXT FIELD bookno                                                                                                     
#          END CASE                                                                                                                  
#         #No.FUN-740020  --End 
#          ON ACTION CONTROLR
#             CALL cl_show_req_fields()
# 
#          ON ACTION CONTROLG
#             CALL cl_cmdask()
# 
#          ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE INPUT
# 
#           ON ACTION about         #MOD-4C0121
#              CALL cl_about()      #MOD-4C0121
# 
#           ON ACTION help          #MOD-4C0121
#              CALL cl_show_help()  #MOD-4C0121
# 
#          ON ACTION exit
#             LET INT_FLAG = 1
#             EXIT INPUT
# 
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
       END INPUT
#No.FUN-B20054--add-start--
         ON ACTION CONTROLP
          CASE
            WHEN INFIELD(bookno)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aaa'
              LET g_qryparam.default1 = tm.bookno
              CALL cl_create_qry() RETURNING tm.bookno
              DISPLAY BY NAME tm.bookno
              NEXT FIELD bookno
           WHEN INFIELD(aag01)
              CALL cl_init_qry_var()
              LET g_qryparam.state    = "c"
              LET g_qryparam.form = "q_aag"
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

       ON ACTION qbe_save
          CALL cl_qbe_save()

       ON ACTION accept
          EXIT DIALOG

       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG
   END DIALOG
#No.FUN-B20054--add-end--
 
       SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
 
       #CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end #CHI-A70007 mark
       #CHI-A70007 add --start--
       IF g_aza.aza63 = 'Y' THEN
          CALL s_azmm(yy,mm,g_plant,tm.bookno) RETURNING l_flag,l_begin,l_end
       ELSE
          CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end
       END IF
       #CHI-A70007 add --end--
 
       IF l_begin=bdate THEN
          LET l_begin = DATE(2958464)
       END IF
#No.FUN-B20054--add--start--
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

#No.FUN-B20054--add--end-- 

       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW aglg905_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
          CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)               #FUN-B80158 add
          EXIT PROGRAM
       END IF
#No.FUN-B20054--add--start--
       IF tm.wc = ' 1=1' THEN
          CALL cl_err('','9046',0)
          CONTINUE WHILE
       END IF

#No.FUN-B20054--add--end-- 

       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
           WHERE zz01='aglg905'
          IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('aglg905','9031',1)   
          ELSE
             LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
             LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
#                        " '",g_bookno CLIPPED,"' ",
                         " '",tm.bookno CLIPPED,"' ",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.v CLIPPED,"'",
                         " '",tm.x CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",   #FUN-6C0012
                         " '",tm.y CLIPPED,"'",
                         " '",bdate CLIPPED,"'",   #TQC-610056
                         " '",edate CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
             CALL cl_cmdat('aglg905',g_time,l_cmd)      # Execute cmd at later time
          END IF
 
          CLOSE WINDOW aglg905_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
          CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)               #FUN-B80158 add
          EXIT PROGRAM
       END IF
 
       CALL cl_wait()
       CALL aglg905()
 
       ERROR ""
   END WHILE
 
   CLOSE WINDOW aglg905_w
 
END FUNCTION
 
FUNCTION aglg905()
   DEFINE l_name      LIKE type_file.chr20,         #No.FUN-680098CHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       STRING,    #TQC-630166        
          l_sql1      STRING,    #TQC-630166        
          l_sql2      STRING,    # No.FUN-C50005 add
          l_chr       LIKE type_file.chr1,          #No.FUN-680098CHAR(1)
          sr1    RECORD
                    aag01 LIKE aag_file.aag01,   # course no
                    aag02 LIKE aag_file.aag02,   # course name
                    aag13 LIKE aag_file.aag13,   #FUN-6C0012
                    aag07 LIKE aag_file.aag07,   # course type
                    aag24 LIKE aag_file.aag24
                 END RECORD,
          sr     RECORD
                    aea01 LIKE aea_file.aea01,   # acct. kinds
                    aea02 LIKE aea_file.aea02,   # trans date
                    aea03 LIKE aea_file.aea03,   # trans no
                    aea04 LIKE aea_file.aea04,   # trans seq
                    aba05 LIKE aba_file.aba05,   # input date
                    aba06 LIKE aba_file.aba06,   # Source code
                    abb04 LIKE abb_file.abb04,   # remark
                    abb05 LIKE abb_file.abb05,   # Dept
                    abb06 LIKE abb_file.abb06,   # D or  C
                    abb07 LIKE abb_file.abb07,   # amount
                    abb11 LIKE abb_file.abb11,   #
                    abb12 LIKE abb_file.abb12,   #
                    abb13 LIKE abb_file.abb13,   #
                    abb14 LIKE abb_file.abb14,   #
                    abb31 LIKE abb_file.abb31,   #FUN-5C0015---(S)
                    abb32 LIKE abb_file.abb32,
                    abb33 LIKE abb_file.abb33,
                    abb34 LIKE abb_file.abb34,
                    abb35 LIKE abb_file.abb35,
                    abb36 LIKE abb_file.abb36,   #FUN-5C0015---(E)
                    aag02 LIKE aag_file.aag02,   # course name
                    aag13 LIKE aag_file.aag13,  #FUN-6C0012
                    amt   LIKE abb_file.abb07,
                    #FUN-B80158--------add----str----
                    abb07_1 LIKE abb_file.abb07,
                    abb07_2 LIKE abb_file.abb07
                    #FUN-B80158--------add----end----
                 END RECORD
   #No.FUN-830100  --BEGIN                                                                                                          
   DEFINE l_amt,l_c,l_d,l_bal,l_bal0  LIKE aas_file.aas04,                                                                          
          l_t_d,l_t_c                 LIKE aas_file.aas04,                                                                          
          l_buf                       LIKE type_file.chr1000, #FUN-5C0015     #No.FUN-680098 VARCHAR(60)                               
          l_abc04                     LIKE abc_file.abc04,    #No.FUN-680098 VARCHAR(30)                                               
          l_bal_1                     LIKE aas_file.aas04,                                                                          
          l_flag0                     LIKE type_file.chr1                                                                           
   DEFINE l_n                         LIKE type_file.num5     #MOD-850186 add
                                                                                                                                    
   CALL cl_del_data(l_table1)                                                                               
   CALL cl_del_data(l_table2)                                                                            
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?)"   #MOD-850186 add ?   #FUN-B80158 add 2?
   PREPARE insert_prep1 FROM l_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80158--add--
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)               #FUN-B80158 add
      EXIT PROGRAM                                                                            
   END IF                                                                                                                           
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                 
               " VALUES(?,?,?)"                                                                                                     
   PREPARE insert_prep2 FROM l_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80158--add--
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)               #FUN-B80158 add
      EXIT PROGRAM                                                                            
   END IF 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog                                                                           
   #No.FUN-830100  --end                                                         
   SELECT aaf03 INTO g_company FROM aaf_file
#   WHERE aaf01 = g_bookno     #No.FUN-740020
    WHERE aaf01 = tm.bookno    #No.FUN-740020
      AND aaf02 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
   LET l_sql1= "SELECT aag01,aag02,aag13,aag07,aag24 ", #FUN-6C0012
               "  FROM aag_file ",
               " WHERE aag03 ='2' AND aag07 IN ('1','3') ",
               "   AND aag00 ='",tm.bookno,"'",   #MOD-850186 add
               "   AND ",tm.wc CLIPPED
 
   PREPARE aglg905_prepare2 FROM l_sql1
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   DECLARE aglg905_curs2 CURSOR FOR aglg905_prepare2
#FUN-C50005---------------add--------star------- 
   LET l_sql2 = "SELECT abc04 FROM abc_file",	
                "WHERE abc00 =  '",tm.bookno,"' ",	
                "AND abc01 =?",					
                "AND abc02 =?"    					
   PREPARE abc_prepare FROM l_sql2	
   IF STATUS != 0 THEN 				
      CALL cl_err('prepare:',STATUS,1)				
      CALL cl_used(g_prog,g_time,2) RETURNING g_time               
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)           
      EXIT PROGRAM                                                   
   END IF                                                             
   DECLARE abc_curs CURSOR FOR abc_prepare                              
#FUN-C50005---------------add-------end----------
   LET l_sql = "SELECT aea01,aea02,aea03,aea04,aba05,aba06,abb04,abb05,",
              #FUN-5C0015-----------------------------------------------(S)
              #"       abb06,abb07,abb11,abb12,abb13,abb14,'',0",
               "       abb06,abb07,abb11,abb12,abb13,abb14,",
               "       abb31,abb32,abb33,abb34,abb35,abb36,",
               "       '',0,0,0",            #FUN-B80158   add 2 0
              #FUN-5C0015-----------------------------------------------(E)
               " FROM aea_file,aba_file,abb_file",
               " WHERE aea01 = ?  ",
#              "   AND aea00 = '",g_bookno,"' ",    #No.FUN-740020
#              "   AND aba00 = '",g_bookno,"' ",    #No.FUN-740020
               "   AND aea00 = '",tm.bookno,"' ",   #No.FUN-740020
               "   AND aba00 = '",tm.bookno,"' ",   #No.FUN-740020
               "   AND aba00 = abb00 ",
              #"   AND aba00 = abb00 ",             #FUN-B80158 mark#FUN-B80158 add
               "   AND aea00 = abb00 ",             #FUN-B80158 add#FUN-B80158 add
               "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
               "   AND aba01 = aea03 AND abb01 = aea03 AND abb02 = aea04 ",
               "   AND aba19 <> 'X' ",  #CHI-C80041
               "   ORDER BY aea01,aea02,aea03"
 
   PREPARE aglg905_prepare1 FROM l_sql
   IF STATUS != 0 THEN
      CALL cl_err('prepare:',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table1||"|"||l_table2)               #FUN-B80158 add
      EXIT PROGRAM
   END IF
   DECLARE aglg905_curs1 CURSOR FOR aglg905_prepare1
 
   #CALL cl_outnam('aglg905') RETURNING l_name       #No.FUN-830100
   #START REPORT aglg905_rep TO l_name               #No.FUN-830100 
 
   #LET g_pageno = 0                                 #No.FUN-830100  
 
   FOREACH aglg905_curs2 INTO sr1.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF tm.x = 'N' AND sr1.aag07 = '3' THEN
         CONTINUE FOREACH
      END IF
 
    # IF g_aza.aza26 = '2' AND NOT cl_null(tm.y) THEN  #CHI-710005
      IF NOT cl_null(tm.y) THEN #CHI-710005
         IF sr1.aag07 = '1' AND sr1.aag24 != tm.y THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      LET g_cnt = 0
     #LET l_flag='N'    #MOD-A50010 mark 
      LET g_flag='N'    #MOD-A50010 add 
      LET l_n = 1   #MOD-850186 add
      FOREACH aglg905_curs1 USING sr1.aag01 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
        #LET l_flag='Y'   #MOD-850186 mark   #將l_flag改變值段搬到後面
         LET sr.aag02=sr1.aag02
         LET sr.aag13=sr1.aag13  #FUN-6C0012
         #No.FUN-830100   --begin
         #OUTPUT TO REPORT aglg905_rep(sr.*)
         LET l_bal = 0                                                                                                              
         LET l_bal0=0                                                                                                               
         LET l_d=0                                                                                                                  
         LET l_c=0                                                                                                                  
                                                                                                                                    
         IF g_aaz.aaz51 = 'Y' THEN  #產生每日餘額檔                                                                                 
            #CALL s_azm(yy,1) RETURNING l_flag,l_begin1,l_end1 #MOD-990134 #CHI-A70007 mark
            #CHI-A70007 add --start--
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(yy,1,g_plant,tm.bookno) RETURNING l_flag,l_begin1,l_end1
            ELSE
               CALL s_azm(yy,1) RETURNING l_flag,l_begin1,l_end1
            END IF
            #CHI-A70007 add --end--
            SELECT sum(aah04-aah05) INTO l_bal0 FROM aah_file                                                                       
             WHERE aah01 = sr.aea01 AND aah02 = yy AND aah03 = 0                                                                    
          #    AND aah00 = g_bookno    #No.FUN-740020                                                                               
               AND aah00 = tm.bookno   #No.FUN-740020                                                                               
                                                                                                                                    
            SELECT SUM(aas04-aas05) INTO l_bal FROM aas_file                                                                        
     #       WHERE aas00 = g_bookno AND aas01 = sr.aea01    #No.FUN-740020                                                          
             WHERE aas00 = tm.bookno AND aas01 = sr.aea01   #No.FUN-740020                                                          
               AND YEAR(aas02) = yy AND aas02 < bdate                        
               AND aas02>=l_begin1  #MOD-990134                                                          
         ELSE                                                                                                                       
            SELECT sum(aah04-aah05) INTO l_bal FROM aah_file                                                                        
             WHERE aah01 = sr.aea01 AND aah02 = yy AND aah03 < mm                                                                   
         #     AND aah00 = g_bookno     #No.FUN-740020                                                                              
               AND aah00 =tm.bookno     #No.FUN-740020                                                                              
                                                                                                                                    
            SELECT sum(abb07) INTO l_d FROM aag_file,abb_file,aba_file  
             WHERE aag08 = sr.aea01 AND aag01=abb03 AND aba01 = abb01                                                              
                AND aba02 >= l_begin AND aba02 < bdate                                                                              
              # AND abb06='1'        AND abapost='Y' AND aba00=g_bookno     #No.FUN-740020                                          
                AND abb06='1'        AND abapost='Y' AND aba00=g_bookno     #No.FUN-740020                                          
                                                                                                                                    
            IF l_d IS NULL THEN                                                                                                     
               LET l_d = 0                                                                                                          
            END IF                                                                                                                  
                                                                                                                                    
            SELECT sum(abb07) INTO l_c FROM aag_file,aba_file,abb_file                                                              
              WHERE aag08 = sr.aea01 AND aag01=abb03 AND aba01 = abb01                                                              
                AND aba02 >= l_begin AND aba02 <  bdate                                                                             
           #    AND abb06='2'        AND abapost='Y' AND aba00=g_bookno     #No.FUN-740020                                          
                AND abb06='2'        AND abapost='Y' AND aba00=tm.bookno    #No.FUN-740020                                          
                                                                                                                                    
            IF l_c IS NULL THEN                                                                                                     
               LET l_c = 0                                                                                                          
            END IF                                                                                                                  
         END IF                                                                                                                     
                                                                                                                                    
         IF l_bal IS NULL THEN                                                                                                      
            LET l_bal = 0                                                                                                           
         END IF                     
          IF l_bal0 IS NULL THEN                                                                                                     
            LET l_bal0 = 0                                                                                                          
         END IF                                                                                                                     
                                                                                                                                    
         LET l_t_d =0                                                                                                               
         LET l_t_c =0                                                                                                               
                                                                                                                                    
         LET l_bal = l_bal + l_d - l_c +l_bal0  # 期初餘額                                                                          
                                                                                                                                    
         #第一次進入FOREACH,將l_bal值給l_bal_1
        #IF l_flag='N' THEN LET l_bal_1 = l_bal END IF   #MOD-850186 add  #MOD-A50010 mark
         IF g_flag='N' THEN LET l_bal_1 = l_bal END IF   #MOD-A50010 add

        #LET l_flag='Y'   #MOD-850186 mod   #將l_flag改變值段搬到後面來    #MOD-A50010 mark
         LET g_flag='Y'   #MOD-A50010 add
         LET l_buf = ''                                                                                                             
         IF sr.abb11 IS NOT NULL THEN                                                                                               
            LET l_buf = sr.abb11                                                                                                    
         END IF                                                                                                                     
         IF sr.abb12 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb12                                                                                  
         END IF                                                                                                                     
         IF sr.abb13 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb13                                                                                  
         END IF                                                                                                                     
         IF sr.abb14 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb14                                                                                  
         END IF                                                                                                                     
         IF sr.abb31 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb31     
         END IF                                                                                                                     
         IF sr.abb32 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb32                                                                                  
         END IF                                                                                                                     
         IF sr.abb33 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb33                                                                                  
         END IF                                                                                                                     
         IF sr.abb34 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb34                                                                                  
         END IF                                                                                                                     
         IF sr.abb35 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb35                                                                                  
         END IF                                                                                                                     
         IF sr.abb36 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb36                                                                                  
         END IF                                                                                                                     
         #-----END MOD-680101-----                                                                                                  
         IF sr.abb06 = '1' THEN
           #LET l_bal_1 = l_bal + sr.abb07     #MOD-850186 mark
            LET l_bal_1 = l_bal_1 + sr.abb07   #MOD-850186
         ELSE
           #LET l_bal_1 = l_bal - sr.abb07     #MOD-850186 mark
            LET l_bal_1 = l_bal_1 - sr.abb07   #MOD-850186
         END IF
         LET l_flag0 = 'N'                                                                                                          
         IF sr.abb07 != 0 THEN                                                                                                      
            IF tm.v = 'Y' THEN                                                                            
            #FUN-C50005---mark-----str--------------                          
            #  DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file                     
            #                          #    WHERE abc00 = g_bookno     #No.FUN-740020    
            #                               WHERE abc00 = tm.bookno    #No.FUN-740020   
            #                                 AND abc01 = sr.aea03                     
            #                                 AND abc02 = sr.aea04                    
                                                                                                                                    
            #   FOREACH abc_curs INTO l_abc04         
            #FUN-C50005--mark-----end----------- 
                FOREACH abc_curs USING sr.aea03,sr.aea04 INTO l_abc04  #FUN-C50005 add
                  IF l_abc04 IS NOT NULL THEN                                                                                       
                      LET l_flag0='Y'                                                                                               
                  END IF                                                                                                            
                  EXECUTE insert_prep2 USING sr.aea03,sr.aea04,l_abc04                                                              
               END FOREACH                                                                                                          
            END IF                                                                                                                  
         END IF                                     
         #FUN-B80158------add----str-----
         IF sr.abb06 = '1' THEN                                                                                                     
            LET sr.abb07_1 = sr.abb07
         END IF
         IF sr.abb06 != '1' THEN
            LET sr.abb07_2 = sr.abb07
         END IF 
         IF cl_null(sr.abb06) THEN
            LET sr.abb07_1 = 0
            LET sr.abb07_2 = 0
         END IF
         #FUN-B80158------add----end-----
         EXECUTE insert_prep1 USING
            sr.aea01,sr.aea02,sr.aea03,sr.aea04,sr.aba05,
            sr.aba06,sr.abb04,sr.abb05,sr.abb06,sr.abb07,
            sr.abb11,sr.abb12,sr.abb13,sr.abb14,sr.abb31,
            sr.abb32,sr.abb33,sr.abb34,sr.abb35,sr.abb36,
            sr.aag02,sr.aag13,l_bal,l_buf,l_flag0,l_bal_1,l_n,   #MOD-850186 add l_n
            sr.abb07_1,sr.abb07_2         #FUN-B80158  add 
      #No.FUN-830100  --END
         #報表排序用
         LET l_n = l_n + 1   #MOD-850186 add
      END FOREACH
 
     #IF tm.t='Y' AND l_flag='N' THEN    #MOD-A50010 mark 
      IF tm.t='Y' AND g_flag='N' THEN    #MOD-A50010 add 
         INITIALIZE sr.* TO NULL
         LET sr.aea01=sr1.aag01
         LET sr.aag02=sr1.aag02
         LET sr.aag13=sr1.aag13  #FUN-6C0012
         LET sr.abb07=0
         #No.FUN-830100 --begin
         #OUTPUT TO REPORT aglg905_rep(sr.*)
          LET l_bal = 0 
         LET l_bal0=0
         LET l_d=0
         LET l_c=0
         LET l_n = 1   #MOD-850186 add                                                                                                                              
         IF g_aaz.aaz51 = 'Y' THEN  #產生每日餘額檔                                                                                 
            #CALL s_azm(yy,1) RETURNING l_flag,l_begin1,l_end1 #MOD-990134 #CHI-A70007 mark
            #CHI-A70007 add --start--
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(yy,1,g_plant,tm.bookno) RETURNING l_flag,l_begin1,l_end1
            ELSE
               CALL s_azm(yy,1) RETURNING l_flag,l_begin1,l_end1
            END IF
            #CHI-A70007 add --end--
            SELECT sum(aah04-aah05) INTO l_bal0 FROM aah_file                                                                       
             WHERE aah01 = sr.aea01 AND aah02 = yy AND aah03 = 0                                                                    
          #    AND aah00 = g_bookno    #No.FUN-740020                                                                               
               AND aah00 = tm.bookno   #No.FUN-740020                                                                               
                                                                                                                                    
            SELECT SUM(aas04-aas05) INTO l_bal FROM aas_file                                                                        
     #       WHERE aas00 = g_bookno AND aas01 = sr.aea01    #No.FUN-740020                                                          
             WHERE aas00 = tm.bookno AND aas01 = sr.aea01   #No.FUN-740020                                                          
               AND YEAR(aas02) = yy AND aas02 < bdate                          
               AND aas02>=l_begin1 #MOD-990134                                                           
         ELSE                                                                                                                       
            SELECT sum(aah04-aah05) INTO l_bal FROM aah_file                                                                        
             WHERE aah01 = sr.aea01 AND aah02 = yy AND aah03 < mm                                                                   
         #     AND aah00 = g_bookno     #No.FUN-740020                                                                              
               AND aah00 =tm.bookno     #No.FUN-740020                                                                              
                                                                                                                                    
            SELECT sum(abb07) INTO l_d FROM aag_file,abb_file,aba_file  
              WHERE aag08 = sr.aea01 AND aag01=abb03 AND aba01 = abb01                                                               
                AND aba02 >= l_begin AND aba02 < bdate                                                                              
              # AND abb06='1'        AND abapost='Y' AND aba00=g_bookno     #No.FUN-740020                                          
                AND abb06='1'        AND abapost='Y' AND aba00=g_bookno     #No.FUN-740020                                          
                                                                                                                                    
            IF l_d IS NULL THEN                                                                                                     
               LET l_d = 0                                                                                                          
            END IF                                                                                                                  
                                                                                                                                    
            SELECT sum(abb07) INTO l_c FROM aag_file,aba_file,abb_file                                                              
              WHERE aag08 = sr.aea01 AND aag01=abb03 AND aba01 = abb01                                                              
                AND aba02 >= l_begin AND aba02 <  bdate                                                                             
           #    AND abb06='2'        AND abapost='Y' AND aba00=g_bookno     #No.FUN-740020                                          
                AND abb06='2'        AND abapost='Y' AND aba00=tm.bookno    #No.FUN-740020                                          
                                                                                                                                    
            IF l_c IS NULL THEN                                                                                                     
               LET l_c = 0                                                                                                          
            END IF                                                                                                                  
         END IF                                                                                                                     
                                                                                                                                    
         IF l_bal IS NULL THEN                                                                                                      
            LET l_bal = 0                                                                                                           
         END IF                                      
         IF l_bal0 IS NULL THEN                                                                                                     
            LET l_bal0 = 0                                                                                                          
         END IF                                                                                                                     
                                                                                                                                    
         LET l_t_d =0                                                                                                               
         LET l_t_c =0                                                                                                               
                                                                                                                                    
         LET l_bal = l_bal + l_d - l_c +l_bal0  # 期初餘額                                                                          
                                                                                                                                    
         LET l_buf = ''                                                                                                             
         IF sr.abb11 IS NOT NULL THEN                                                                                               
            LET l_buf = sr.abb11                                                                                                    
         END IF                                                                                                                     
         IF sr.abb12 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb12                                                                                  
         END IF                                                                                                                     
         IF sr.abb13 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb13                                                                                  
         END IF                                                                                                                     
         IF sr.abb14 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb14                                                                                  
         END IF                                                                                                                     
         IF sr.abb31 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb31  
         END IF                                                                                                                     
         IF sr.abb32 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb32                                                                                  
         END IF                                                                                                                     
         IF sr.abb33 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb33                                                                                  
         END IF                                                                                                                     
         IF sr.abb34 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb34                                                                                  
         END IF                                                                                                                     
         IF sr.abb35 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb35                                                                                  
         END IF                                                                                                                     
         IF sr.abb36 IS NOT NULL THEN                                                                                               
            LET l_buf = l_buf clipped," ",sr.abb36                                                                                  
         END IF                                                                                                                     
         #-----END MOD-680101-----                                                                                                  
         IF sr.abb06 = '1' THEN                                                                                                     
            LET l_bal_1 = l_bal + sr.abb07                                                                                          
         ELSE                                                                                                                       
            LET l_bal_1 = l_bal - sr.abb07                                                                                          
         END IF                                                                                                                     
         LET l_flag0 = 'N'                                                                                                          
         #FUN-B80158------add----str-----
         IF sr.abb06 = '1' THEN                                                                                                     
            LET sr.abb07_1 = sr.abb07
         END IF
         IF sr.abb06 != '1' THEN
            LET sr.abb07_2 = sr.abb07
         END IF 
         IF cl_null(sr.abb06) THEN
            LET sr.abb07_1 = 0
            LET sr.abb07_2 = 0
         END IF
         #FUN-B80158------add----end-----
         EXECUTE insert_prep1 USING
            sr.aea01,sr.aea02,sr.aea03,sr.aea04,sr.aba05,
            sr.aba06,sr.abb04,sr.abb05,sr.abb06,sr.abb07,
            sr.abb11,sr.abb12,sr.abb13,sr.abb14,sr.abb31,
            sr.abb32,sr.abb33,sr.abb34,sr.abb35,sr.abb36,
            sr.aag02,sr.aag13,l_bal,l_buf,l_flag0,l_bal_1,l_n,   #MOD-850186 add l_n
            sr.abb07_1,sr.abb07_2             #FUN-B80158 add 
         #No.FUN-830100  --END                                                       
      END IF
   END FOREACH
   #No.FUN-830100  --BEGIN
   #FINISH REPORT aglg905_rep
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",                                                           
###GENGRE###               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED                                                                
                                                                                                                                    
   LET g_str = ''                                                                                                                   
  #是否列印選擇條件                                                                                                                 
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(tm.wc,'aag01')                                                                                                  
      RETURNING  tm.wc                                                                                                              
   END IF                                                                                                                           
###GENGRE###   LET g_str = tm.wc,';',bdate,';',edate,';',tm.e,';',tm.u,';',tm.s,';',                                                            
###GENGRE###               g_azi04,';',tm.v,';',tm.bookno                                                                                       
###GENGRE###   CALL cl_prt_cs3('aglg905','aglg905',l_sql,g_str)                                                                                 
    CALL aglg905_grdata()    ###GENGRE###
   #No.FUN-830100  --end                             
   
END FUNCTION
#No.FUN-830100  --BEGIN 
{
REPORT aglg905_rep(sr)
   DEFINE
          sr   RECORD
                  aea01 LIKE aea_file.aea01,
                  aea02 LIKE aea_file.aea02,
                  aea03 LIKE aea_file.aea03,
                  aea04 LIKE aea_file.aea04,
                  aba05 LIKE aba_file.aba05,
                  aba06 LIKE aba_file.aba06,
                  abb04 LIKE abb_file.abb04,
                  abb05 LIKE abb_file.abb05,
                  abb06 LIKE abb_file.abb06,
                  abb07 LIKE abb_file.abb07,
                  abb11 LIKE abb_file.abb11,
                  abb12 LIKE abb_file.abb12,
                  abb13 LIKE abb_file.abb13,
                  abb14 LIKE abb_file.abb14,
                  abb31 LIKE abb_file.abb31,   #FUN-5C0015---(S)
                  abb32 LIKE abb_file.abb32,
                  abb33 LIKE abb_file.abb33,
                  abb34 LIKE abb_file.abb34,
                  abb35 LIKE abb_file.abb35,
                  abb36 LIKE abb_file.abb36,   #FUN-5C0015---(E)
                  aag02 LIKE aag_file.aag02,
                  aag13 LIKE aag_file.aag13,   #FUN-6C0012
                  amt   LIKE abb_file.abb07
               END RECORD,
      l_amt,l_c,l_d,l_bal,l_bal0  LIKE aas_file.aas04,
      l_t_d,l_t_c                 LIKE aas_file.aas04,
      l_last_sw                   LIKE type_file.chr1,         #No.FUN-680098CHAR(1) 
      l_abb07,l_aah04,l_aah05     LIKE abb_file.abb07,
      l_chr,l_abb06,l_continue    LIKE type_file.chr1,         #No.FUN-680098 VARCHAR(1)
      l_sql2                      STRING,    #TQC-630166    
     #l_buf                       VARCHAR(15), FUN-5C0015     
      l_buf                       LIKE type_file.chr1000, #FUN-5C0015     #No.FUN-680098 VARCHAR(60)
      l_abc04                     LIKE abc_file.abc04     #No.FUN-680098 VARCHAR(30)
  DEFINE g_head1 STRING
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[16] CLIPPED,bdate,'-',edate
         #PRINT g_head1                                         #FUN-660060 remark
         PRINT COLUMN ((g_len-FGL_WIDTH(g_head1))/2)-1, g_head1 #FUN-660060
         PRINT g_dash[1,g_len]
         PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]  #No.TQC-6A0080
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]             #No.TQC-6A0080
         PRINT g_dash1
         LET l_last_sw = 'n'
 
         IF l_continue = 'Y' THEN
            PRINTX name = D1 COLUMN g_c[31],g_x[9] CLIPPED,    #No.TQC-6A0080
#           PRINT COLUMN g_c[31],g_x[9] CLIPPED,    #No.TQC-6A0080
                  COLUMN g_c[32],sr.aea01 CLIPPED;
                  #FUN-6C0012.....begin
                  IF tm.e = 'Y' THEN
                     PRINT COLUMN g_c[33],sr.aag13 CLIPPED
                  ELSE
                  #FUN-6C0012.....end
                     PRINT COLUMN g_c[33],sr.aag02 CLIPPED
                  END IF  #FUN-6C0012
                  IF l_bal >=0 THEN
                     PRINTX name = D1 COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),     #No.TQC-6A0080 
#                    PRINT COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),     #No.TQC-6A0080
                           COLUMN g_c[37],'D'
                  ELSE
                     LET l_amt = l_bal * (-1)
                     PRINTX name = D1 COLUMN g_c[36],cl_numfor(l_amt,36,g_azi04),     #No.TQC-6A0080
#                    PRINT COLUMN g_c[36],cl_numfor(l_amt,36,g_azi04),     #No.TQC-6A0080
                           COLUMN g_c[37],'C'
                  END IF
         ELSE 
             PRINT ''
             PRINT ''  #FUN-6C0012
         END IF
         LET l_continue = 'N'
 
      BEFORE GROUP OF sr.aea01    #科目
         IF tm.u = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
         LET l_bal = 0
         LET l_bal0=0
         LET l_d=0
         LET l_c=0
 
         IF g_aaz.aaz51 = 'Y' THEN  #產生每日餘額檔
           #CALL s_azm(yy,1) RETURNING l_flag,l_begin1,l_end1 #MOD-990134 #TQC-B10163 mark
           #-TQC-B10163-add-
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(yy,1,g_plant,tm.bookno) RETURNING l_flag,l_begin1,l_end1
            ELSE
               CALL s_azm(yy,1) RETURNING l_flag,l_begin1,l_end1
            END IF
           #-TQC-B10163-end-
            SELECT sum(aah04-aah05) INTO l_bal0 FROM aah_file
             WHERE aah01 = sr.aea01 AND aah02 = yy AND aah03 = 0
          #    AND aah00 = g_bookno    #No.FUN-740020
               AND aah00 = tm.bookno   #No.FUN-740020
 
            SELECT SUM(aas04-aas05) INTO l_bal FROM aas_file   
     #       WHERE aas00 = g_bookno AND aas01 = sr.aea01    #No.FUN-740020
             WHERE aas00 = tm.bookno AND aas01 = sr.aea01   #No.FUN-740020 
               AND YEAR(aas02) = yy AND aas02 < bdate
               AND aas02>=l_begin1  #MOD-990134    
         ELSE
            SELECT sum(aah04-aah05) INTO l_bal FROM aah_file
             WHERE aah01 = sr.aea01 AND aah02 = yy AND aah03 < mm
         #     AND aah00 = g_bookno     #No.FUN-740020
               AND aah00 =tm.bookno     #No.FUN-740020
 
            SELECT sum(abb07) INTO l_d FROM aag_file,abb_file,aba_file
              WHERE aag08 = sr.aea01 AND aag01=abb03 AND aba01 = abb01
                AND aba02 >= l_begin AND aba02 < bdate
              # AND abb06='1'        AND abapost='Y' AND aba00=g_bookno     #No.FUN-740020
                AND abb06='1'        AND abapost='Y' AND aba00=g_bookno     #No.FUN-740020 
 
            IF l_d IS NULL THEN
               LET l_d = 0
            END IF
 
            SELECT sum(abb07) INTO l_c FROM aag_file,aba_file,abb_file
              WHERE aag08 = sr.aea01 AND aag01=abb03 AND aba01 = abb01
                AND aba02 >= l_begin AND aba02 <  bdate
           #    AND abb06='2'        AND abapost='Y' AND aba00=g_bookno     #No.FUN-740020 
                AND abb06='2'        AND abapost='Y' AND aba00=tm.bookno    #No.FUN-740020 
 
            IF l_c IS NULL THEN
               LET l_c = 0
            END IF
         END IF
 
         IF l_bal IS NULL THEN
            LET l_bal = 0
         END IF
 
         IF l_bal0 IS NULL THEN
            LET l_bal0 = 0
         END IF
 
        ##No.+281 010627 mark
        #SELECT sum(abb07) INTO l_d FROM aag_file,abb_file,aba_file
        #  WHERE aag08 = sr.aea01 AND aag01=abb03 AND aba01 = abb01
        #    AND aba02 >= l_begin AND aba02 < bdate
        #    AND abb06='1'        AND abapost='Y' AND aba00=g_bookno
        #IF l_d IS NULL THEN LET l_d =0 END IF
        # 
 
         LET l_t_d =0
         LET l_t_c =0
 
        ##No.+281 010627 mark
        #SELECT sum(abb07) INTO l_c FROM aag_file,aba_file,abb_file
        #  WHERE aag08 = sr.aea01 AND aag01=abb03 AND aba01 = abb01
        #    AND aba02 >= l_begin AND aba02 <  bdate
        #    AND abb06='2'        AND abapost='Y' AND aba00=g_bookno
        #IF l_c IS NULL THEN LET l_c =0 END IF
        #
        #LET l_bal = l_bal + l_d - l_c  # 期初餘額
 
         LET l_bal = l_bal + l_d - l_c +l_bal0  # 期初餘額
 
         IF l_bal >= 0 THEN
            PRINTX name = D1 COLUMN g_c[31],g_x[9] CLIPPED,    #No.TQC-6A0080
#           PRINT COLUMN g_c[31],g_x[9] CLIPPED,    #No.TQC-6A0080 
                  COLUMN g_c[32],sr.aea01 CLIPPED;
            #FUN-6C0012.....begin
            IF tm.e = 'Y' THEN
               PRINT COLUMN g_c[33],sr.aag13 CLIPPED;
            ELSE
            #FUN-6C0012.....end
               PRINT COLUMN g_c[33],sr.aag02 CLIPPED;
            END IF   #FUN-6C0012
            PRINT COLUMN g_c[34],l_chr CLIPPED,
                  COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),
                  COLUMN g_c[37],'D'
         ELSE
            LET l_bal =l_bal * (-1)
            PRINTX name = D1 COLUMN g_c[31],g_x[9] CLIPPED,     #No.TQC-6A0080
#           PRINT COLUMN g_c[31],g_x[9] CLIPPED,     #No.TQC-6A0080
                  COLUMN g_c[32],sr.aea01 CLIPPED;
            #FUN-6C0012.....begin
            IF tm.e = 'Y' THEN
               PRINT COLUMN g_c[33],sr.aag13 CLIPPED;
            ELSE
            #FUN-6C0012.....end
               PRINT COLUMN g_c[33],sr.aag02 CLIPPED;
            END IF   #FUN-6C0012
            PRINT COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),
                  COLUMN g_c[37],'C'
            LET l_bal =l_bal * (-1)
         END IF
         PRINT ' '
         PRINT ' '   #FUN-6C0012
 
      ON EVERY ROW
         #-----MOD-680101---------
         LET l_buf = ''
         IF sr.abb11 IS NOT NULL THEN
            LET l_buf = sr.abb11
         END IF
         IF sr.abb12 IS NOT NULL THEN
            LET l_buf = l_buf clipped," ",sr.abb12
         END IF
         IF sr.abb13 IS NOT NULL THEN
            LET l_buf = l_buf clipped," ",sr.abb13
         END IF
         IF sr.abb14 IS NOT NULL THEN
            LET l_buf = l_buf clipped," ",sr.abb14
         END IF
         IF sr.abb31 IS NOT NULL THEN
            LET l_buf = l_buf clipped," ",sr.abb31
         END IF
         IF sr.abb32 IS NOT NULL THEN
            LET l_buf = l_buf clipped," ",sr.abb32
         END IF
         IF sr.abb33 IS NOT NULL THEN
            LET l_buf = l_buf clipped," ",sr.abb33
         END IF
         IF sr.abb34 IS NOT NULL THEN
            LET l_buf = l_buf clipped," ",sr.abb34
         END IF
         IF sr.abb35 IS NOT NULL THEN
            LET l_buf = l_buf clipped," ",sr.abb35
         END IF
         IF sr.abb36 IS NOT NULL THEN
            LET l_buf = l_buf clipped," ",sr.abb36
         END IF
         #-----END MOD-680101-----
         IF sr.abb06 = '1' THEN
            PRINTX name = D1 COLUMN g_c[31],sr.aea02,    #No.TQC-6A0080
#           PRINT COLUMN g_c[31],sr.aea02,    #No.TQC-6A0080
                  COLUMN g_c[32],sr.aea03,
                  COLUMN g_c[33],l_buf,
                  COLUMN g_c[34],cl_numfor(sr.abb07,34,g_azi04);
            LET l_bal = l_bal + sr.abb07
            LET l_t_d = l_t_d + sr.abb07
         ELSE
            PRINTX name = D1 COLUMN g_c[31],sr.aea02,    #No.TQC-6A0080 
#           PRINT COLUMN g_c[31],sr.aea02,    #No.TQC-6A0080
                  COLUMN g_c[32],sr.aea03,
                  COLUMN g_c[33],l_buf,
                  COLUMN g_c[35],cl_numfor(sr.abb07,35,g_azi04);
            LET l_bal = l_bal - sr.abb07
            LET l_t_c = l_t_c + sr.abb07
         END IF
         #-----MOD-680101---------
         #LET l_buf = ''
         #
         #IF sr.abb11 IS NOT NULL THEN
         #   LET l_buf = sr.abb11
         #END IF
         #
         #IF sr.abb12 IS NOT NULL THEN
         #   LET l_buf = l_buf clipped," ",sr.abb12
         #END IF
         #
         #IF sr.abb13 IS NOT NULL THEN
         #   LET l_buf = l_buf clipped," ",sr.abb13
         #END IF
         #
         #IF sr.abb14 IS NOT NULL THEN
         #   LET l_buf = l_buf clipped," ",sr.abb14
         #END IF
         #
         ##FUN-5C0015-----------------------------------------------(S)
         #IF sr.abb31 IS NOT NULL THEN
         #   LET l_buf = l_buf clipped," ",sr.abb31
         #END IF
         #IF sr.abb32 IS NOT NULL THEN
         #   LET l_buf = l_buf clipped," ",sr.abb32
         #END IF
         #IF sr.abb33 IS NOT NULL THEN
         #   LET l_buf = l_buf clipped," ",sr.abb33
         #END IF
         #IF sr.abb34 IS NOT NULL THEN
         #   LET l_buf = l_buf clipped," ",sr.abb34
         #END IF
         #IF sr.abb35 IS NOT NULL THEN
         #   LET l_buf = l_buf clipped," ",sr.abb35
         #END IF
         #IF sr.abb36 IS NOT NULL THEN
         #   LET l_buf = l_buf clipped," ",sr.abb36
         #END IF
         ##FUN-5C0015-----------------------------------------------(E)
         #-----END MOD-680101-----
 
         IF sr.abb07 != 0 THEN
            LET l_continue = 'Y'
            IF l_bal >=0 THEN
               PRINTX name = D1 COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),     #No.TQC-6A0080   
#              PRINT COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),     #No.TQC-6A0080 
                     COLUMN g_c[37],'D'
            ELSE
               LET l_bal = l_bal * (-1)
               PRINTX name = D1 COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),      #No.TQC-6A0080   
#              PRINT COLUMN g_c[36],cl_numfor(l_bal,36,g_azi04),      #No.TQC-6A0080
                     COLUMN g_c[37],'C'
               LET l_bal = l_bal * (-1)
            END IF
 
            IF tm.s ='Y' THEN
               PRINTX name = D1 COLUMN g_c[31],sr.abb04,         #No.TQC-6A0080   
#              PRINT COLUMN g_c[31],sr.abb04,         #No.TQC-6A0080
                     COLUMN g_c[32],sr.abb05
            END IF
 
            IF tm.v = 'Y' THEN
               DECLARE abc_curs CURSOR FOR SELECT abc04 FROM abc_file
                                       #    WHERE abc00 = g_bookno     #No.FUN-740020
                                            WHERE abc00 = tm.bookno    #No.FUN-740020
                                              AND abc01 = sr.aea03
                                              AND abc02 = sr.aea04
 
               FOREACH abc_curs INTO l_abc04
                  IF l_abc04 IS NOT NULL THEN
                     PRINTX name = D1 COLUMN g_c[32],l_abc04    #No.TQC-6A0080
#                    PRINT COLUMN g_c[32],l_abc04    #No.TQC-6A0080
                  END IF
               END FOREACH
            END IF
 
            LET l_continue = 'N'
 
         END IF
 
      AFTER GROUP OF sr.aea01
#         LET g_pageno = 0   #MOD-5B0220
         PRINT '  '
         PRINTX name = D1 COLUMN g_c[33],g_x[10] CLIPPED,     #No.TQC-6A0080
#        PRINT COLUMN g_c[33],g_x[10] CLIPPED,     #No.TQC-6A0080
               COLUMN g_c[34],cl_numfor(l_t_d,34,g_azi04),
               COLUMN g_c[35],cl_numfor(l_t_c,35,g_azi04)
         IF tm.u ='N' THEN
            PRINT g_dash2
         END IF
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
            PRINT g_dash[1,g_len]
        #TQC-630166
        #    IF tm.wc[001,070] > ' ' THEN                  # for 80
        #       PRINT COLUMN g_c[31],g_x[8] CLIPPED,
        #             COLUMN g_c[32],tm.wc[001,070] CLIPPED
        #    END IF
        #    IF tm.wc[071,140] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
        #    END IF
        #    IF tm.wc[141,210] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
        #    END IF
        #    IF tm.wc[211,280] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
        #    END IF
         CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
 
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
#         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[36],g_x[7] CLIPPED   #MOD-5B0220
        PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-7,g_x[7] CLIPPED   #MOD-5B0220
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[36],g_x[6] CLIPPED   #MOD-5B0220
           PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-7,g_x[6] CLIPPED   #MOD-5B0220
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}
#No.FUN-830100  --end     
#Patch....NO.TQC-610035 <001> #

###GENGRE###START
FUNCTION aglg905_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table1)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg905")
        IF handler IS NOT NULL THEN
            START REPORT aglg905_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
                        ," ORDER BY aea01,aea02,aea03,l_n"             #FUN-B80158 add
          
            DECLARE aglg905_datacur1 CURSOR FROM l_sql
            FOREACH aglg905_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg905_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg905_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg905_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B80158------add----str---
    DEFINE l_aag13_02     LIKE aag_file.aag02
    DEFINE l_date         STRING
    DEFINE l_dc           LIKE type_file.chr1 
    DEFINE l_dc_1         LIKE type_file.chr1 
    DEFINE l_bal          LIKE aas_file.aas04     
    DEFINE l_bal_1        LIKE aas_file.aas04     
    DEFINE l_t_c          LIKE abb_file.abb07
    DEFINE l_t_d          LIKE abb_file.abb07
    DEFINE l_abb07_fmt    STRING
    #FUN-B80158------add----end---

    
    ORDER EXTERNAL BY sr1.aea01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_user_name,g_ptime  #FUN-B80158 add g_user_name,g_ptime
            PRINTX tm.*
            #FUN-B80158------add----str---
            LET l_date = cl_gr_getmsg("gre-229",g_lang,1),':',bdate,'-',edate 
            PRINTX l_date
            #FUN-B80158------add----end---
              
        BEFORE GROUP OF sr1.aea01
            #FUN-B80158------add----str---
            IF tm.e = 'Y' THEN
               LET l_aag13_02 = sr1.aag13
            ELSE
               LET l_aag13_02 = sr1.aag02
            END IF
            PRINTX l_aag13_02

            IF sr1.l_bal >= 0 THEN
               LET l_bal = sr1.l_bal
               LET l_dc = 'D'
            ELSE
               LET l_bal = sr1.l_bal * (-1)
               LET l_dc = 'C'
            END IF
            PRINTX l_bal
            PRINTX l_dc
            #FUN-B80158------add----end---

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B80158------add----str---
            LET l_abb07_fmt = cl_gr_numfmt("abb_file","abb07",g_azi04)
            PRINTX l_abb07_fmt
            IF sr1.abb07 != 0THEN
               IF sr1.l_bal_1 >= 0 THEN
                  LET l_bal_1 = sr1.l_bal_1
                  LET l_dc_1 = 'D'
               ELSE
                  LET l_bal_1 = sr1.l_bal_1 * (-1)
                  LET l_dc_1 = 'C'
               END IF
            END IF
            PRINTX l_bal_1
            PRINTX l_dc_1

            LET l_sql = "SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE abc00 = '",tm.bookno CLIPPED,"'",
                        " AND abc01 = '",sr1.aea03 CLIPPED,"'",
                        " AND abc02 = ",sr1.aea04
            START REPORT aglg905_subrep01
            DECLARE aglg905_subrep01 CURSOR FROM l_sql
            FOREACH aglg905_subrep01 INTO sr2.*
                OUTPUT TO REPORT aglg905_subrep01 (sr2.*)
            END FOREACH
            FINISH REPORT aglg905_subrep01
            #FUN-B80158------add----end---

            PRINTX sr1.*

        AFTER GROUP OF sr1.aea01
            #FUN-B80158------add----str---
            LET l_t_c = GROUP SUM(sr1.abb07_2)
            LET l_t_d = GROUP SUM(sr1.abb07_1)
            PRINTX l_t_c
            PRINTX l_t_d
            #FUN-B80158------add----end---

        
        ON LAST ROW

END REPORT

#FUN-B80158------add----str---
REPORT aglg905_subrep01(sr2)
    DEFINE sr2 sr2_t
    DEFINE l_display LIKE type_file.chr1

    FORMAT
        ON EVERY ROW
            IF NOT cl_null(sr2.abc04) THEN
               LET l_display = 'Y'
            ELSE
               LET l_display = 'N'
            END IF
            PRINTX l_display 
            PRINTX sr2.* 
END REPORT
###GENGRE###END
#FUN-B80158------add----end---
###GENGRE###END
