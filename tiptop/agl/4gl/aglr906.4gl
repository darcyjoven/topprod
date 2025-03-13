# Prog. Version..: '5.30.06-13.04.18(00010)'     #
#
# Pattern name...: aglr906.4gl
# Descriptions...: 分類帳
# Input parameter:
# Return code....:
# Date & Author..: 92/03/10 By DAVID
# modify by nick 96/05/17
# Modify.........: 97/08/06 By Melody  l_sql 加入 aba00=abb00 段
# Modify.........: No.FUN-510007 05/02/15 By Nicola 報表架構修改
# Modify.........: No.MOD-580106 05/08/10 By Smapmin 期初餘額不正確
# Modify.........: No.TQC-5B0002 05/12/08 By Smapmin 科目名稱往下一列
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/29 By Rainy 表頭期間置於中間
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/12 By dxfwo    會計科目加帳套
# Modify.........: No.TQC-760105 07/06/12 By arman    tm.bookno 未 display or deafult!
# Modify.........: No.FUN-7C0034 07/12/24 By sherry 報表改由CR輸出 
# Modify.........: No.MOD-830048 08/03/11 By Smapmin 資料重複輸出
# Modify.........: No.MOD-830190 08/03/24 By Smapmin 修改SELECT語法
# Modify.........: No.MOD-870342 08/08/05 By Sarah 若輸入之日期區間無交易應仍可列印餘額
# Modify.........: No.MOD-880202 08/08/29 By Sarah 傳票明細若有摘要,列印時都會重複,aglr906_begin()段裡應將sr.abb04清空
# Modify.........: No.FUN-940013 09/04/21 By jan aag01 欄位增加開窗功能 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990134 09/09/14 By mike 當aaz51='Y'時,需抓出該年第一期的起始日期CALL s_azm(yy,1) RETURNING l_flag,l_begin1
#                                                 抓取每日余額時,與抓取日期介於l_begin1~bdate間的日余額加總                         
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-B20054 11/02/23 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-BA0212 11/10/31 By Polly 調整額外摘要印出問題
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:MOD-C30617 12/03/13 By Polly 查詢條件後需再重新給予 INPUT 欄位變數
# Modify.........: No.MOD-C50121 12/05/18 By Polly 調整傳遞參數按收順序
# Modify.........: No.TQC-C60059 12/06/06 By lujh  第601行 " WHERE aag03 ='2' AND aag07 IN ('2','3')", 不需要排除aag03='4'的科目性質，應拿掉aag03='2'的限制。
# Modify.........: No.MOD-C80030 12/08/06 By Polly 如背景執行需重抓年月
# Modify.........: No.MOD-CA0133 13/01/23 By apo 增加金額去做排序並調整呼叫aglr906_begin的條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 wc1         STRING ,     #TQC-630166
                 wc2         STRING,      #TQC-630166
                 t           LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
                 u           LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
                 s           LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
                 v           LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
                 x           LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
                 e           LIKE type_file.chr1,   #FUN-6C0012
                 y           LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
                 z           LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
                 more        LIKE type_file.chr1,   #No.FUN-680098   VARCHAR(1)
                 bookno      LIKE aaa_file.aaa01    #No.FUN-740020
             END RECORD,
                yy        LIKE azn_file.azn02,          #No.FUN-680098 integer
                mm        LIKE azn_file.azn04,          #No.FUN-680098 integer
          l_begin,l_end   LIKE type_file.dat,           #No.FUN-680098 date 
          bdate,edate     LIKE type_file.dat,           #No.FUN-680098 VARCHAR(1) 
          l_flag          LIKE type_file.chr1           #No.FUN-680098 VARCHAR(1) 
   DEFINE l_begin1        LIKE type_file.dat            #MOD-990134                                                                 
   DEFINE l_end1          LIKE type_file.dat            #MOD-990134   
   DEFINE g_aaa03         LIKE aaa_file.aaa03
   DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098 smallint
   DEFINE g_bookno        LIKE aaa_file.aaa01 #NO.TQC-760105
   DEFINE g_sql     STRING
   DEFINE g_str     STRING
   DEFINE l_table1  STRING
   DEFINE l_table2  STRING
 
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047 mark
 
   LET g_sql= "aea05.aea_file.aea05,   aag02.aag_file.aag02,",
              "aag13.aag_file.aag13,   l_bal.aah_file.aah04,",
              "l_bal_sr.aah_file.aah04,l_amt.aah_file.aah04,",
              "l_t_d.aah_file.aah04,   l_t_c.aah_file.aah04,",
              "l_d.aah_file.aah04,     l_c.aah_file.aah04,",
              "g_sum.aah_file.aah04,   aag223.aag_file.aag223,",
              "aag224.aag_file.aag224, aag225.aag_file.aag225,",
              "aag226.aag_file.aag226, aae02.aae_file.aae02,",
              "l_chr.type_file.chr1,   aea02.aea_file.aea02,",
              "aea03.aea_file.aea03,   aba11.aba_file.aba11,",
              "l_buf.abb_file.abb11,   abb07.abb_file.abb07,",
              "abb07_1.abb_file.abb07, abb04.abb_file.abb04,",
              "abb05.abb_file.abb05,   abb06.abb_file.abb06,",
              "aea04.aea_file.aea04"
   LET l_table1 = cl_prt_temptable('aglr9061',g_sql) CLIPPED                    
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                    
                                                                                
   LET g_sql = "abc00.abc_file.abc00,abc01.abc_file.abc01,",
               "abc02.abc_file.abc02,abc04.abc_file.abc04"
   LET l_table2 = cl_prt_temptable('aglr9062',g_sql) CLIPPED                    
   IF l_table2 = -1 THEN EXIT PROGRAM END IF   
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET tm.bookno= ARG_VAL(1)    #No.FUN-740020 
   LET g_pdate  = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc1   = ARG_VAL(8)
   LET tm.wc2   = ARG_VAL(9)
   LET tm.t     = ARG_VAL(10)
   LET tm.u     = ARG_VAL(11)
   LET tm.s     = ARG_VAL(12)   #TQC-610056
   LET tm.v     = ARG_VAL(13)
   LET tm.x     = ARG_VAL(14)
   LET tm.y     = ARG_VAL(15)
   LET tm.z     = ARG_VAL(16)
   LET tm.e     = ARG_VAL(17)   #MOD-C50121 add 
   LET bdate    = ARG_VAL(18)   #TQC-610056 #MOD-C50121 mod
   LET edate    = ARG_VAL(19)   #TQC-610056 #MOD-C50121 mod
   LET g_rep_user = ARG_VAL(20) #MOD-C50121 mod
   LET g_rep_clas = ARG_VAL(21) #MOD-C50121 mod
   LET g_template = ARG_VAL(22) #MOD-C50121 mod
  #LET tm.e  = ARG_VAL(22)        #FUN-6C0012 #MOD-C50121 mark
   LET g_rpt_name = ARG_VAL(23)  #No.FUN-7C0078
 
   IF tm.bookno IS NULL OR tm.bookno = ' ' THEN    #No.FUN-740020 
      LET tm.bookno = g_aza.aza81                  #No.FUN-740020 
   END IF                                          #No.FUN-740020
   LET g_bookno = tm.bookno     #NO.TQC-760105 
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno  #No.FUN-740020 
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03              #No.CHI-6A0004 g_azi-->t_azi
   IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123         
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            # If background job sw is off
      THEN CALL aglr906_tm()                    # Input print condition
      ELSE CALL aglr906()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr906_tm()
   DEFINE p_row,p_col      LIKE type_file.num5,         #No.FUN-680098  SMALLINT
          l_cmd            LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5             #No.FUN-B20054
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01          #MOD-C30617 add
 
   CALL s_dsmark(tm.bookno)    #No.FUN-740020 mod g_bookno->tm.bookno
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 18
   ELSE
      LET p_row = 4 LET p_col = 12
   END IF
 
   OPEN WINDOW aglr906_w AT p_row,p_col WITH FORM "agl/42f/aglr906"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.bookno)    #No.FUN-740020 mod g_bookno->tm.bookno
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                # Default condition
   LET bdate   = NULL
   LET edate   = NULL
   LET tm.t    = 'N'
   LET tm.bookno = g_bookno                 #NO.TQC-760105
   LET tm.u    = 'N'
   LET tm.s    = 'Y'
   LET tm.v    = 'N'
   LET tm.x    = 'Y'
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.z    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   DISPLAY BY NAME tm.bookno,tm.t,tm.u,tm.s,tm.v,tm.x,tm.y,tm.z,tm.e,tm.more    #No.FUN-B20054
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
    CONSTRUCT BY NAME tm.wc1 ON aag01
#No.FUN-B20054--mark--start-- 
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
# 
#       ON ACTION locale
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
#No.FUN-B20054--mark--end--
    END CONSTRUCT
#No.FUN-B20054--mark--start--
#    IF g_action_choice = "locale" THEN
#       LET g_action_choice = ""
#       CALL cl_dynamic_locale()
#       CONTINUE WHILE
#    END IF
#No.FUN-B20054--mark--end-- 
    CONSTRUCT BY NAME tm.wc2 ON aba11
#No.FUN-B20054--mark--start--
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
#No.FUN-B20054--mark--end--

    END CONSTRUCT
#No.FUN-B20054--mark--start--
#    IF g_action_choice = "locale" THEN
#       LET g_action_choice = ""
#       CALL cl_dynamic_locale()
#       CONTINUE WHILE
#    END IF
# 
#    IF INT_FLAG THEN
#        LET INT_FLAG = 0 CLOSE WINDOW aglr906_w 
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#        EXIT PROGRAM
#    END IF
# 
#    IF tm.wc1 = ' 1=1' AND tm.wc2 = ' 1=1' THEN
#       CALL cl_err('','9046',0) CONTINUE WHILE
#    END IF
# 
#    DISPLAY BY NAME tm.bookno,tm.t,tm.u,tm.s,tm.v,tm.x,tm.y,tm.z,tm.e,tm.more  #FUN-6C0012  #NO.TQC-760105
#    INPUT BY NAME tm.bookno,bdate,edate,tm.t,tm.u,tm.s,tm.v,tm.x,tm.z,tm.e,tm.y,tm.more  #FUN-6C0012
#          WITHOUT DEFAULTS
#No.FUN-B20054--mark--end-- 
    INPUT BY NAME bdate,edate,tm.t,tm.u,tm.s,tm.v,tm.x,tm.z,tm.e,tm.y,tm.more   #No.FUN-B20054
                    ATTRIBUTE(WITHOUT DEFAULTS)    #No.FUN-B20054
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
          IF tm.t NOT MATCHES "[YN]" THEN NEXT FIELD t END IF
       AFTER FIELD u
          IF tm.u NOT MATCHES "[YN]" THEN NEXT FIELD u END IF
       AFTER FIELD s
          IF tm.s NOT MATCHES "[YN]" THEN NEXT FIELD s END IF
       AFTER FIELD v
          IF tm.v NOT MATCHES "[YN]" THEN NEXT FIELD v END IF
       AFTER FIELD x
          IF tm.x NOT MATCHES "[YN]" THEN NEXT FIELD x END IF
       AFTER FIELD y
          IF tm.y NOT MATCHES "[12345]" THEN NEXT FIELD y END IF
       AFTER FIELD z
          IF tm.z NOT MATCHES "[YN]" THEN NEXT FIELD z END IF
       AFTER FIELD more
          IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                  g_bgjob,g_time,g_prtway,g_copies)
             RETURNING g_pdate,g_towhom,g_rlang,
                       g_bgjob,g_time,g_prtway,g_copies
          END IF
#No.FUN-B20054--mark--start--
#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()
#       ON ACTION CONTROLP                                                                                                         
#          CASE                                                                                                                      
#            WHEN INFIELD(bookno)                                                                                                    
#              CALL cl_init_qry_var()                                                                                                
#              LET g_qryparam.form = 'q_aaa'                                                                                         
#              LET g_qryparam.default1 = tm.bookno                                                                                      
#              CALL cl_create_qry() RETURNING tm.bookno                                                                                 
#              DISPLAY BY NAME tm.bookno                                                                                                
#              NEXT FIELD bookno                                                                                                     
#          END CASE                                                                                                                  
#       ON ACTION CONTROLG
#          CALL cl_cmdask()      # Command execution
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#       ON ACTION about         #MOD-4C0121
#          CALL cl_about()      #MOD-4C0121
# 
#       ON ACTION help          #MOD-4C0121
#          CALL cl_show_help()  #MOD-4C0121
# 
#       ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#No.FUN-B20054-mark--end--
    END INPUT
#No.FUN-B20054--add--start--
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

      #---------------------MOD-C30617-------------start
       ON ACTION qbe_select
          CALL cl_qbe_select()
          CALL cl_qbe_display_condition(lc_qbe_sn)
          LET bdate = GET_FLDBUF(bdate)
          LET edate = GET_FLDBUF(edate)
          LET tm.t = GET_FLDBUF(t)
          LET tm.u = GET_FLDBUF(u)
          LET tm.s = GET_FLDBUF(s)
          LET tm.v = GET_FLDBUF(v)
          LET tm.x = GET_FLDBUF(x)
          LET tm.z = GET_FLDBUF(z)
          LET tm.e = GET_FLDBUF(e)
          LET tm.y = GET_FLDBUF(y)
          LET tm.more = GET_FLDBUF(more)
      #---------------------MOD-C30617---------------end

       ON ACTION accept
          EXIT DIALOG

       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG
    END DIALOG
#No.FUN-B20054--add--end--

    SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
    #CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end #CHI-A70007 mark
    #CHI-A70007 add --start--
    IF g_aza.aza63 = 'Y' THEN
       CALL s_azmm(yy,mm,g_plant,tm.bookno) RETURNING l_flag,l_begin,l_end
    ELSE
       CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end
    END IF
    #CHI-A70007 add --end--
    IF l_begin=bdate THEN LET l_begin='9999/12/31' END IF
#No.FUN-B20054--add--start--
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

#No.FUN-B20054--add--end--


    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW aglr906_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
#No.FUN-B20054--add--start--
    IF tm.wc1 = ' 1=1' AND tm.wc2 = ' 1=1' THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
#No.FUN-B20054--add--end--

    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr906'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aglr906','9031',1)   
       ELSE
          LET tm.wc1=cl_wcsub(tm.wc1)
          LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                         " '",tm.bookno CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc1 CLIPPED,"'",
                         " '",tm.wc2 CLIPPED,"'",   #TQC-610056
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.v CLIPPED,"'",
                         " '",tm.x CLIPPED,"'",
                         " '",tm.y CLIPPED,"'",
                         " '",tm.z CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",    #FUN-6C0012
                         " '",bdate CLIPPED,"'",   #TQC-610056
                         " '",edate CLIPPED,"'",   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('aglr906',g_time,l_cmd)      # Execute cmd at later time
       END IF
       CLOSE WINDOW aglr906_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL aglr906()
    ERROR ""
  END WHILE
  CLOSE WINDOW aglr906_w
END FUNCTION
 
FUNCTION aglr906()
   DEFINE l_name      LIKE type_file.chr20,  # External(Disk) file name        #No.FUN-680098 VARCHAR(20) 
          l_sql       STRING,                # RDSQL STATEMENT  #TQC-630166       
          l_sql1      STRING,                # RDSQL STATEMENT  #TQC-630166       
          l_chr       LIKE type_file.chr1,   #No.FUN-680098 VARCHAR(1) 
          sr1    RECORD
                    aag223 LIKE aag_file.aag223, #No.FUN-680098  VARCHAR(5) 
                    aag224 LIKE aag_file.aag224, #No.FUN-680098  VARCHAR(5) 
                    aag225 LIKE aag_file.aag225, #No.FUN-680098  VARCHAR(5) 
                    aag226 LIKE aag_file.aag226, #No.FUN-680098  VARCHAR(5) 
                    aag01 LIKE aag_file.aag01,   # course no
                    aag02 LIKE aag_file.aag02,   # course name
                    aag13 LIKE aag_file.aag13,   #FUN-6C0012
                    aag07 LIKE aag_file.aag07    # course type
                 END RECORD,
          sr     RECORD
                    order1 LIKE aae_file.aae01,  #No.FUN-680098 VARCHAR(5) 
                    aea05 LIKE aea_file.aea05,   # acct. kinds
                    aea02 LIKE aea_file.aea02,   # trans date
                    aea03 LIKE aea_file.aea03,   # trans no
                    aea04 LIKE aea_file.aea04,   # trans seq
                    aba05 LIKE aba_file.aba05,   # input date
                    aba06 LIKE aba_file.aba06,   # Source code
                    aba11 LIKE aba_file.aba11,   # Source code
                    abb04 LIKE abb_file.abb04,   #
                    abb05 LIKE abb_file.abb05,   #
                    abb06 LIKE abb_file.abb06,   # D or  C
                    abb07 LIKE abb_file.abb07,   # amount
                    abb07_1 LIKE abb_file.abb07,   # amount
                    abb11 LIKE abb_file.abb11,   #
                    abb12 LIKE abb_file.abb12,   #
                    abb13 LIKE abb_file.abb13,   #
                    abb14 LIKE abb_file.abb14,   #
                    aag02 LIKE aag_file.aag02,   # course name
                    aag13 LIKE aag_file.aag13,   #FUN-6C0012
                    amt   LIKE abb_file.abb07,
                    l_bal LIKE aah_file.aah04,
                    l_d   LIKE aah_file.aah04,
                    l_c   LIKE aah_file.aah04
                 END RECORD
DEFINE    l_amt,l_c,l_d,l_bal     LIKE aah_file.aah04,                          
          l_t_d,l_t_c             LIKE aah_file.aah04,                          
          g_sum                   LIKE aah_file.aah04,                          
          l_last_sw               LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1
          l_abb07,l_aah04,l_aah05 LIKE aah_file.aah04,                          
          l_abb06           LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1
          l_continue              LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1
          l_sql2                  STRING,    #TQC-630166                        
          l_aae02                 LIKE aae_file.aae02,                          
          l_buf                   LIKE abb_file.abb11,        #No.FUN-680098  CH
          l_abc04                 LIKE  abc_file.abc04,
          abc00                   LIKE abc_file.abc00,
          abc01                   LIKE abc_file.abc01,
          abc02                   LIKE abc_file.abc02   
DEFINE    l_cnt                   LIKE type_file.num5        #MOD-CA0133 add
 
   CALL cl_del_data(l_table1)                                                 
   CALL cl_del_data(l_table2)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql                                             
   IF STATUS THEN                                                             
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM                       
   END IF                                                                     
                                                                              
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                     
               " VALUES(?,?,?,? )        "                       
   PREPARE insert_prep1 FROM g_sql                                            
   IF STATUS THEN                                                             
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM                      
   END IF                
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = tm.bookno   #No.FUN-740020 mod g_bookno->tm.bookno
      AND aaf02 = g_lang
 
   LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
 
   LET l_sql1= "SELECT aag223,aag224,aag225,aag226,aag01,aag02,aag13,aag07 ", #FUN-6C0012
               "  FROM aag_file ",
               #" WHERE aag03 ='2' AND aag07 IN ('2','3')",    #TQC-C60059   mark
               " WHERE aag07 IN ('2','3')",                    #TQC-C60059   add
               "   AND aag00 = '",tm.bookno,"'",   #MOD-830048
               "   AND ",tm.wc1
   PREPARE aglr906_prepare2 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr906_curs2 CURSOR FOR aglr906_prepare2
 
   LET l_sql= "SELECT '',",
              "  aea05,aea02,aea03,aea04,aba05,aba06,aba11,abb04,abb05,abb06,",
              "  abb07,0,abb11,abb12,abb13,abb14,'','',0,0,0,0",   #MOD-830190
              "  FROM aea_file,aba_file,abb_file ",
              " WHERE aea05 =  ? ",
              "   AND aea00 = '",tm.bookno,"' ",
              "   AND aea00 = aba00 ",
              "   AND aba00 = abb00 ",
              "   AND aba01 = abb01 ",
              "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
              "   AND abb01 = aea03 AND abb02 = aea04 ",
              "   AND aba01 = aea03",
              "   AND ",tm.wc2 CLIPPED,
              "   ORDER BY aea02,aea03 "   #NO:2760
   PREPARE aglr906_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr906_curs1 CURSOR FOR aglr906_prepare1

  #---------------------------MOD-CA0133------------------(S)
   LET l_sql= "SELECT COUNT(*)",
              "  FROM aea_file,aba_file,abb_file ",
              " WHERE aea05 =  ? ",
              "   AND aea00 = '",tm.bookno,"' ",
              "   AND aea00 = aba00 ",
              "   AND aba00 = abb00 ",
              "   AND aba01 = abb01 ",
              "   AND aea02 BETWEEN '",bdate,"' AND '",edate,"' ",
              "   AND abb01 = aea03 AND abb02 = aea04 ",
              "   AND aba01 = aea03",
              "   AND ",tm.wc2 CLIPPED,
              "   ORDER BY aea02,aea03 "   #NO:2760
   PREPARE aglr906_prepare3 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time             #No.FUN-690114
      EXIT PROGRAM
   END IF
   DECLARE aglr906_curs3 CURSOR FOR aglr906_prepare3
  #---------------------------MOD-CA0133------------------(E)
 
   FOREACH aglr906_curs2 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE sr.* TO NULL            #MOD-870342 add
      IF tm.x = 'N' AND sr1.aag07 = '3' THEN CONTINUE FOREACH END IF
 
      CASE WHEN tm.y = '1' LET sr.order1 = sr1.aag223
           WHEN tm.y = '2' LET sr.order1 = sr1.aag224
           WHEN tm.y = '3' LET sr.order1 = sr1.aag225
           WHEN tm.y = '4' LET sr.order1 = sr1.aag226
           OTHERWISE       LET sr.order1 = ' '
      END CASE
      OPEN aglr906_curs3 USING sr1.aag01                              #MOD-CA0133 add
      FETCH  aglr906_curs3 INTO l_cnt                                 #MOD-CA0133 add
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                     #MOD-CA0133 add 
     #IF tm.t = 'Y' THEN   #無異動科目列印                            #MOD-CA0133 mark
      IF tm.t = 'Y' OR l_cnt > 0 THEN   #無異動科目列印               #MOD-CA0133 add
         CALL aglr906_begin(sr1.*,sr.*)
      END IF
      CLOSE aglr906_curs3                                             #MOD-CA0133 add
 
      #明細資料
      LET l_flag='N'
      FOREACH aglr906_curs1 USING sr1.aag01 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         LET l_flag='Y'
         LET sr.aag02=sr1.aag02
         LET sr.aag13=sr1.aag13   #FUN-6C0012
 
         #列印額外摘要
         IF tm.v = 'Y' THEN
          #------------------------------No.MOD-BA0212-----------------------start
           #DECLARE abc_curs CURSOR FOR
           #   SELECT abc04 FROM abc_file
           #    WHERE abc00 = tm.bookno   #No.FUN-740020 mod g_bookno->tm.bookno
           #      AND abc01 = sr.aea03
           #      AND abc02 = sr.aea04
           LET l_sql = "SELECT abc04 FROM abc_file ",
                       " WHERE abc00 = '",tm.bookno,"'",
                       "   AND abc01 = '",sr.aea03,"'",
                       "   AND abc02 = '",sr.aea04,"'"
           PREPARE abc_prepare FROM l_sql
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('prepare:',SQLCA.sqlcode,1)
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
              EXIT PROGRAM
           END IF
           DECLARE abc_curs CURSOR FOR abc_prepare
          #------------------------------No.MOD-BA0212-------------------------end
            FOREACH abc_curs INTO l_abc04
               IF SQLCA.sqlcode THEN
                  CALL cl_err('abc_curs',SQLCA.sqlcode,0)
                  EXIT FOREACH
               END IF
               IF NOT cl_null(l_abc04) THEN
                 #EXECUTE insert_prep1 USING abc00,abc01,abc02,l_abc04            #MOD-BA0212 mark
                  EXECUTE insert_prep1 USING tm.bookno,sr.aea03,sr.aea04,l_abc04  #MOD-BA0212 add
               END IF
            END FOREACH
         END IF
 
         CASE WHEN tm.y = '1' LET sr.order1 = sr1.aag223
              WHEN tm.y = '2' LET sr.order1 = sr1.aag224
              WHEN tm.y = '3' LET sr.order1 = sr1.aag225
              WHEN tm.y = '4' LET sr.order1 = sr1.aag226
              OTHERWISE       LET sr.order1 = ' '
         END CASE
 
        #IF tm.t = 'N' THEN   #無異動科目列印    #MOD-CA0133 mark
        #   CALL aglr906_begin(sr1.*,sr.*)       #MOD-CA0133 mark
        #END IF                                  #MOD-CA0133 mark
 
         SELECT aae02 INTO l_aae02 FROM aae_file
          WHERE aae01 = sr.order1
         IF cl_null(l_aae02) THEN LET l_aae02= ' ' END IF
 
         IF sr.abb07 != 0 THEN
            IF sr.abb06 = '1' THEN
               LET sr.abb07_1 = 0
            ELSE
               LET sr.abb07_1 = sr.abb07
               LET sr.abb07 = 0
            END IF
            LET l_buf = ' '
            IF NOT cl_null(sr.abb11) THEN
               LET l_buf = sr.abb11
            END IF
            IF NOT cl_null(sr.abb12) THEN
               LET l_buf = sr.abb12
            END IF
            IF NOT cl_null(sr.abb13) THEN
               LET l_buf = sr.abb13
            END IF
            IF NOT cl_null(sr.abb14) THEN
               LET l_buf = sr.abb14
            END IF
 
            EXECUTE insert_prep USING
               sr.aea05,sr.aag02,  sr.aag13,  l_bal,     sr.l_bal,
               l_amt,   l_t_d,     l_t_c,     l_d,       l_c,
               g_sum,   sr1.aag223,sr1.aag224,sr1.aag225,sr1.aag226,
               l_aae02, l_chr,     sr.aea02,  sr.aea03,  sr.aba11,
               l_buf,   sr.abb07,  sr.abb07_1,sr.abb04,  sr.abb05,
               sr.abb06,sr.aea04
         END IF
      END FOREACH
   END FOREACH
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",     
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED    
                                                                           
   LET g_str = ''                                                             
   #是否列印選擇條件                                                          
   IF g_zz05 = 'Y' THEN                                                       
      CALL cl_wcchp(tm.wc1,'aag01') RETURNING tm.wc1
   ELSE
      LET tm.wc1 = ' '
   END IF                                                                     
   LET g_str = tm.wc1,";",tm.e,";",tm.y,";",tm.z,";",tm.u,";",
               tm.s,";",tm.v,";",tm.bookno,";",bdate,";",edate
   CALL cl_prt_cs3('aglr906','aglr906',g_sql,g_str)   
END FUNCTION
 
FUNCTION aglr906_begin(sr1,sr)   #期初餘額
   DEFINE sr1    RECORD
                    aag223  LIKE aag_file.aag223,  #No.FUN-680098  VARCHAR(5)
                    aag224  LIKE aag_file.aag224,  #No.FUN-680098  VARCHAR(5)
                    aag225  LIKE aag_file.aag225,  #No.FUN-680098  VARCHAR(5)
                    aag226  LIKE aag_file.aag226,  #No.FUN-680098  VARCHAR(5)
                    aag01   LIKE aag_file.aag01,   # course no
                    aag02   LIKE aag_file.aag02,   # course name
                    aag13   LIKE aag_file.aag13,   #FUN-6C0012
                    aag07   LIKE aag_file.aag07    # course type
                 END RECORD,
          sr     RECORD
                    order1  LIKE aae_file.aae01,   #No.FUN-680098 VARCHAR(5)
                    aea05   LIKE aea_file.aea05,   # acct. kinds
                    aea02   LIKE aea_file.aea02,   # trans date
                    aea03   LIKE aea_file.aea03,   # trans no
                    aea04   LIKE aea_file.aea04,   # trans seq
                    aba05   LIKE aba_file.aba05,   # input date
                    aba06   LIKE aba_file.aba06,   # Source code
                    aba11   LIKE aba_file.aba11,   # Source code
                    abb04   LIKE abb_file.abb04,   #
                    abb05   LIKE abb_file.abb05,   #
                    abb06   LIKE abb_file.abb06,   # D or  C
                    abb07   LIKE abb_file.abb07,   # amount
                    abb07_1 LIKE abb_file.abb07,   # amount
                    abb11   LIKE abb_file.abb11,   #
                    abb12   LIKE abb_file.abb12,   #
                    abb13   LIKE abb_file.abb13,   #
                    abb14   LIKE abb_file.abb14,   #
                    aag02   LIKE aag_file.aag02,   # course name
                    aag13   LIKE aag_file.aag13,   #FUN-6C0012
                    amt     LIKE abb_file.abb07,
                    l_bal   LIKE aah_file.aah04,
                    l_d     LIKE aah_file.aah04,
                    l_c     LIKE aah_file.aah04
                 END RECORD,
          g_sum             LIKE aah_file.aah04,
          l_t_d,l_t_c       LIKE aah_file.aah04,
          l_amt,l_bal       LIKE aah_file.aah04,
          l_d,l_c           LIKE aah_file.aah04,
          l_aae02           LIKE aae_file.aae02,
          l_buf             LIKE abb_file.abb11,
          l_chr             LIKE type_file.chr1
 
   LET g_sum = 0
   LET l_t_d = 0   LET l_t_c = 0
   LET l_d   = 0   LET l_c   = 0
   LET l_bal = 0   LET sr.l_bal = 0   #MOD-870342 add
   LET l_aae02 = NULL
  #-------------------------MOD-C80030----------------------(S)
   IF g_bgjob = 'Y' THEN
      SELECT azn02,azn04 INTO yy,mm
        FROM azn_file
       WHERE azn01 = bdate
   END IF
  #-------------------------MOD-C80030----------------------(E)
   IF g_aaz.aaz51 = 'Y' THEN   #傳票過帳時應產生每日餘額檔
      #CALL s_azm(yy,1) RETURNING l_flag,l_begin1,l_end1 #MOD-990134  #CHI-A70007 mark
      #CHI-A70007 add --start--
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(yy,1,g_plant,tm.bookno) RETURNING l_flag,l_begin1,l_end1
      ELSE
         CALL s_azm(yy,1) RETURNING l_flag,l_begin1,l_end1
      END IF
      #CHI-A70007 add --end--
      SELECT sum(aah04-aah05) INTO l_bal
        FROM aah_file
       WHERE aah01 = sr1.aag01
         AND aah02 = yy
         AND aah03 = 0
         AND aah00 = tm.bookno  #No.FUN-740020 mod g_bookno->tm.bookno
      SELECT SUM(aas04-aas05) INTO sr.l_bal
        FROM aas_file
       WHERE aas00 = tm.bookno   #No.FUN-740020 mod g_bookno->tm.bookno
         AND aas01 = sr1.aag01
         AND YEAR(aas02) = yy
         AND aas02 < bdate
         AND aas02>=l_begin1 #MOD-990134     
   ELSE
     #-------------------------MOD-C80030----------------------(S)
      IF g_aza.aza63 = 'Y' THEN
         CALL s_azmm(yy,mm,g_plant,tm.bookno) RETURNING l_flag,l_begin,l_end
      ELSE
         CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end
      END IF
     #-------------------------MOD-C80030----------------------(E)
      SELECT sum(aah04-aah05) INTO l_bal
        FROM aah_file
       WHERE aah01 = sr1.aag01
         AND aah02 = yy
         AND aah03 < mm
         AND aah00 = tm.bookno   #No.FUN-740020 mod g_bookno->tm.bookno
      LET l_d = 0
      SELECT sum(abb07) INTO l_d
        FROM abb_file,aba_file
       WHERE abb03 = sr1.aag01
         AND aba01 = abb01
         AND abb06 = '1'
         AND aba02 >= l_begin
         AND aba02 < bdate
         AND aba00 = tm.bookno   #No.FUN-740020 mod g_bookno->tm.bookno
         AND abapost = 'Y'
         AND aba03 = yy
         AND aba04 <= mm        #add by nick 96/05/17
      IF l_d IS NULL THEN LET l_d = 0 END IF
      SELECT sum(abb07) INTO l_c
        FROM aba_file,abb_file
       WHERE abb03 = sr1.aag01
         AND aba01 = abb01
         AND abb06 = '2'
         AND aba02 >= l_begin
         AND aba02 < bdate
         AND aba00 = tm.bookno  #No.FUN-740020 mod g_bookno->tm.bookno
         AND abapost = 'Y'
         AND aba03 = yy
         AND aba04 <= mm        #add by nick 96/05/17
      IF l_c IS NULL THEN LET l_c = 0 END IF
   END IF
   IF l_bal IS NULL THEN LET l_bal = 0 END IF
   IF sr.l_bal IS NULL THEN LET sr.l_bal = 0 END IF
 
   LET sr.abb07 = 0
   LET sr.abb07_1 = 0
   LET l_buf = ' '
   LET sr.abb04 = ' '   #MOD-880202 add
   LET sr.abb05 = ' '   #MOD-880202 add
 
   SELECT aae02 INTO l_aae02 FROM aae_file
    WHERE aae01 = sr.order1
   IF cl_null(l_aae02) THEN LET l_aae02= ' ' END IF
 
   EXECUTE insert_prep USING
      sr1.aag01,sr1.aag02, sr1.aag13, l_bal,     sr.l_bal,
      l_amt,    l_t_d,     l_t_c,     l_d,       l_c,
      g_sum,    sr1.aag223,sr1.aag224,sr1.aag225,sr1.aag226,
      l_aae02,  l_chr,     sr.aea02,  sr.aea03,  sr.aba11,
      l_buf,    sr.abb07,  sr.abb07_1,sr.abb04,  sr.abb05,
      sr.abb06, sr.aea04
 
END FUNCTION
 
#No.FUN-9C0072 精簡程式碼
