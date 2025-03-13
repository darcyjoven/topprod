# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aglr909.4gl
# Desc/riptions...: 科目別異動碼清單
# Input parameter:
# Return code....:
# Date & Author..: 92/04/21 BY MAY
# Modify.........: No.MOD-4C0171 05/01/06 By Nicola 修改參數第一個保留給帳別
# Modify.........: No.FUN-510007 05/02/15 By Nicola 報表架構修改
# Modify.........: No.FUN-5C0015 06/01/03 By miki 原列印aag15~18,改抓ahe02(ahe01=aag15~18,aag31~37)
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 新增打印額外名稱功能
# Modify.........: No.FUN-740020 07/04/12 By bnlent 會計科目加帳套
# Modify.........: No.FUN-790008 08/03/13 By dxfwo CR報表的制作
# Modify.........: No.MOD-8C0083 08/12/12 By Sarah 寫入CR Temptable前,判斷若tm.a='N',應排除掉異動碼完全沒設定的資料
# Modify.........: No.FUN-8A0068 09/01/16 By shiwuying ADD select g_zz05
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 11/02/24 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                 wc           STRING,                  #TQC-630166
                 bookno       LIKE aaa_file.aaa01,     #No.FUN-740020
                 a            LIKE type_file.chr1,     #No.FUN-680098 VARCHAR(1)
                 b            LIKE type_file.chr1,     #FUN-6C0012
                 more         LIKE type_file.chr1      #No.FUN-680098 VARCHAR(1) 
              END RECORD,
          g_bookno  LIKE aah_file.aah00 #帳別
   DEFINE g_aaa03   LIKE aaa_file.aaa03
   DEFINE g_i       LIKE type_file.num5     #count/index for any purpose        #No.FUN-680098  smallint
   DEFINE l_table             STRING                   #No.FUN-790008                                                                    
   DEFINE g_sql               STRING                   #No.FUN-790008                                                                    
   DEFINE g_str               STRING                   #No.FUN-790008  
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                       # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-790008---Begin                                                                                                              
   LET g_sql = "aag01.aag_file.aag01,aag02.aag_file.aag02,",
               "aag13.aag_file.aag13,aag15.aag_file.aag15,",
               "aag16.aag_file.aag16,aag17.aag_file.aag17,",
               "aag18.aag_file.aag18,aag31.aag_file.aag31,", #MOD-8C0083 add aag18
               "aag32.aag_file.aag32,aag33.aag_file.aag33,",
               "aag34.aag_file.aag34,aag35.aag_file.aag35,",
               "aag36.aag_file.aag36,aag37.aag_file.aag37,",
               "ahe15.ahe_file.ahe02,ahe16.ahe_file.ahe02,",
               "ahe17.ahe_file.ahe02,ahe18.ahe_file.ahe02,",
               "ahe31.ahe_file.ahe02,ahe32.ahe_file.ahe02,",
               "ahe33.ahe_file.ahe02,ahe34.ahe_file.ahe02,",
               "ahe35.ahe_file.ahe02,ahe36.ahe_file.ahe02,",
               "ahe37.ahe_file.ahe02"
   LET l_table = cl_prt_temptable('aglr909',g_sql) CLIPPED                                                                  
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                 
   LET g_sql = "INSERT INTO ", g_cr_db_str,l_table CLIPPED,                                                                    
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"  #MOD-8C0083 add ?
   PREPARE insert_prep FROM g_sql                                                                                           
   IF STATUS THEN                                                                                                           
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                     
   END IF                                                                                                                   
   #No.FUN-790008---End     
   WHENEVER ERROR CALL cl_err_msg_log
 
    #-----No.MOD-4C0171-----
   LET tm.bookno = ARG_VAL(1)   #TQC-610056    #No.FUN-740020
   LET g_pdate   = ARG_VAL(2)                   # Get arguments from command line
   LET g_towhom  = ARG_VAL(3)
   LET g_rlang   = ARG_VAL(4)
   LET g_bgjob   = ARG_VAL(5)
   LET g_prtway  = ARG_VAL(6)
   LET g_copies  = ARG_VAL(7)
   LET tm.wc     = ARG_VAL(8)
   LET tm.a      = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
    #-----No.MOD-4C0171 END-----
   LET tm.b     = ARG_VAL(13)  #FUN-6C0012
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
 
   #No.FUN-740020  --Begin
   #IF g_bookno = ' ' OR g_bookno IS NULL THEN
   #   LET g_bookno = g_aaz.aaz64
   #END IF
   IF cl_null(tm.bookno) THEN LET tm.bookno = g_aza.aza81 END IF
   #No.FUN-740020  --End
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'      # If background job sw is off
      THEN CALL aglr909_tm(0,0)            # Input print condition
      ELSE CALL aglr909()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr909_tm(p_row,p_col)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01,          #No.FUN-580031
          p_row,p_col   LIKE type_file.num5,          #No.FUN-680098 SMALLINT
          l_flag        LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1) 
          l_cmd         LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5             #No.FUN-B20054

 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE
      LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW aglr909_w AT p_row,p_col WITH FORM "agl/42f/aglr909"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.bookno   #No.FUN-740020
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('',SQLCA.sqlcode,0) # NO.FUN-660123
      CALL cl_err3("sel","aaa_file",tm.bookno,"",SQLCA.sqlcode,"","",0)  # NO.FUN-660123      #No.FUN-740020
   END IF
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01=g_aaa03  #No.CHI-6A0004 g_azi-->t_azi
 
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.a    = 'N'
   LET tm.b    = 'N'  #FUN-6C0012
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.bookno = g_aza.aza81  #No.FUN-740020
   DISPLAY BY NAME tm.bookno,tm.a,tm.b,tm.more     #No.FUN-B20054 
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
#         ON ACTION locale
#           #CALL cl_dynamic_locale()
#            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#            LET g_action_choice = "locale"
#            EXIT CONSTRUCT
# 
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE CONSTRUCT
# 
#         ON ACTION about         #MOD-4C0121
#            CALL cl_about()      #MOD-4C0121
# 
#         ON ACTION help          #MOD-4C0121
#            CALL cl_show_help()  #MOD-4C0121
# 
#         ON ACTION controlg      #MOD-4C0121
#            CALL cl_cmdask()     #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT CONSTRUCT
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
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0 CLOSE WINDOW aglr909_w 
#         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#         EXIT PROGRAM
#      END IF
# 
#      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
# 
#      DISPLAY BY NAME tm.bookno,tm.a,tm.b,tm.more  # Condition  #FUN-6C0012   #No.FUN-740020
#      INPUT BY NAME tm.bookno,tm.a,tm.b,tm.more WITHOUT DEFAULTS #FUN-6C0012   #No.FUN-740020
#No.FUN-B20054--mark--end--        
       INPUT BY NAME tm.a,tm.b,tm.more  ATTRIBUTE(WITHOUT DEFAULTS)    #No.FUN-B20054
       #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
#No.FUN-B20054--mark-start-- 
#         #No.FUN-740020  --Begin
#         AFTER FIELD bookno
#            IF cl_null(tm.bookno) THEN
#               NEXT FIELD bookno
#            END IF
#         #No.FUN-740020  -End
#No.FUN-B20054--mark--end-- 
         AFTER FIELD a
            IF tm.a NOT MATCHES "[YN]" OR tm.a IS NULL THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
#No.FUN-B20054--mark--start-- 
#         #No.FUN-740020  --Begin
#         ON ACTION CONTROLP
#            CASE
#               WHEN INFIELD(bookno)                                                                                                       
#                  CALL cl_init_qry_var()                                                                                                 
#                  LET g_qryparam.form = 'q_aaa'                                                                                          
#                  LET g_qryparam.default1 = tm.bookno                                                                                     
#                  CALL cl_create_qry() RETURNING tm.bookno                                                                                
#                  DISPLAY BY NAME tm.bookno                                                                                               
#                  NEXT FIELD bookno 
#            END CASE
#         #No.FUN-740020  --End
# 
#         ON ACTION CONTROLR
#            CALL cl_show_req_fields()
# 
#         ON ACTION CONTROLG
#            CALL cl_cmdask()      # Command execution
#    
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
#            CONTINUE INPUT
#    
#         ON ACTION about         #MOD-4C0121
#            CALL cl_about()      #MOD-4C0121
#    
#         ON ACTION help          #MOD-4C0121
#            CALL cl_show_help()  #MOD-4C0121
# 
#         ON ACTION exit
#            LET INT_FLAG = 1
#            EXIT INPUT
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
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

#No.FUN-B20054--add-end--
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW aglr909_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF     #No.FUN-B20054
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
          WHERE zz01='aglr909'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglr909','9031',1)  
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                        " '",tm.bookno CLIPPED,"'",   #TQC-610056  #No.FUN-740020
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'"  ,
                        " '",tm.a CLIPPED,"'"  ,
                        " '",tm.b CLIPPED,"'"  ,  #FUN-6C0012
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglr909',g_time,l_cmd)      # Execute cmd at later time
         END IF
         CLOSE WINDOW aglr909_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL aglr909()
      ERROR ""
   END WHILE
   CLOSE WINDOW aglr909_w
END FUNCTION
 
FUNCTION aglr909()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680098 VARCHAR(21)
#         l_time    LIKE type_file.chr8           #No.FUN-6A0073
          l_sql     STRING,                       #TQC-630166     
          l_chr     LIKE type_file.chr1,          #No.FUN-680098 VARCHAR(1)
          sr        RECORD
                     aag01    LIKE aag_file.aag01,
                     aag02    LIKE aag_file.aag02,
                     aag13    LIKE aag_file.aag13, #FUN-6C0012
                     aag15    LIKE aag_file.aag15,
                     aag16    LIKE aag_file.aag16,
                     aag17    LIKE aag_file.aag17,
                     aag18    LIKE aag_file.aag18,
                     aag31    LIKE aag_file.aag31,  #FUN-5C0015---(S)
                     aag32    LIKE aag_file.aag32,
                     aag33    LIKE aag_file.aag33,
                     aag34    LIKE aag_file.aag34,
                     aag35    LIKE aag_file.aag35,
                     aag36    LIKE aag_file.aag36,
                     aag37    LIKE aag_file.aag37,
                     ahe15    LIKE ahe_file.ahe02,
                     ahe16    LIKE ahe_file.ahe02,
                     ahe17    LIKE ahe_file.ahe02,
                     ahe18    LIKE ahe_file.ahe02,
                     ahe31    LIKE ahe_file.ahe02,
                     ahe32    LIKE ahe_file.ahe02,
                     ahe33    LIKE ahe_file.ahe02,
                     ahe34    LIKE ahe_file.ahe02,
                     ahe35    LIKE ahe_file.ahe02,
                     ahe36    LIKE ahe_file.ahe02,
                     ahe37    LIKE ahe_file.ahe02   #FUN-5C0015---(E)
                    END RECORD
 
   CALL cl_del_data(l_table)              #No.FUN-790008
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND aaguser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND aaggrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
   #End:FUN-980030
 
  #FUN-5C0015----------------------------------------------------------(S)
  #LET l_sql = "SELECT aag01,aag02,aag15,aag16,aag17,aag18 ",
  #            " FROM aag_file",
  #            " WHERE ",tm.wc CLIPPED
   LET l_sql = "SELECT aag01,aag02,aag13,aag15,aag16,aag17,aag18,",  #FUN-6C0012
               "       aag31,aag32,aag33,aag34,aag35,aag36,aag37,",
               "       '','','','','','','','','','','' ",
               "  FROM aag_file",
               " WHERE aag00 = '",tm.bookno,"'",    #No.FUN-740020
               " AND ",tm.wc CLIPPED                #No.FUN-740020
  #FUN-5C0015----------------------------------------------------------(E)
   PREPARE aglr909_pre1 FROM l_sql
   DECLARE aglr909_cs1 CURSOR FOR aglr909_pre1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
 
  #str MOD-8C0083 mark
  #  CALL cl_outnam('aglr909') RETURNING l_name
  #  #FUN-5C0015-------------------------------------------------------(S)
  #  IF NOT(g_aaz.aaz88 >= 1) THEN LET g_zaa[33].zaa06='Y' END IF #異1
  #  IF NOT(g_aaz.aaz88 >= 2) THEN LET g_zaa[34].zaa06='Y' END IF #異2
  #  IF NOT(g_aaz.aaz88 >= 3) THEN LET g_zaa[35].zaa06='Y' END IF #異3
  #  IF NOT(g_aaz.aaz88 >= 4) THEN LET g_zaa[36].zaa06='Y' END IF #異4
  #  IF NOT(g_aaz.aaz88 >= 5) THEN LET g_zaa[37].zaa06='Y' END IF #異5
  #  IF NOT(g_aaz.aaz88 >= 6) THEN LET g_zaa[38].zaa06='Y' END IF #異6
  #  IF NOT(g_aaz.aaz88 >= 7) THEN LET g_zaa[39].zaa06='Y' END IF #異7
  #  IF NOT(g_aaz.aaz88 >= 8) THEN LET g_zaa[40].zaa06='Y' END IF #異8
  #  IF NOT(g_aaz.aaz88 >= 9) THEN LET g_zaa[41].zaa06='Y' END IF #異9
  #  IF NOT(g_aaz.aaz88 >=10) THEN LET g_zaa[42].zaa06='Y' END IF #異10
  #  CALL cl_prt_pos_len()
  # #FUN-5C0015-------------------------------------------------------(E)
  #end MOD-8C0083 mark
#    START REPORT aglr909_rep TO l_name     #No.FUN-790008
#    #FUN-6C0012.....begin                  #No.FUN-790008
#    IF tm.b = 'N' THEN                     #No.FUN-790008
#       LET g_zaa[32].zaa06 = 'N'           #No.FUN-790008                                     
#       LET g_zaa[44].zaa06 = 'Y'           #No.FUN-790008                                      
#    ELSE                                   #No.FUN-790008                                    
#       LET g_zaa[32].zaa06 = 'Y'           #No.FUN-790008                                    
#       LET g_zaa[44].zaa06 = 'N'           #No.FUN-790008                                    
#    END IF                                 #No.FUN-790008                                     
#    CALL cl_prt_pos_len()                  #No.FUN-790008
#    #FUN-6C0012.....end                    #No.FUN-790008
 
   FOREACH aglr909_cs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
     #str MOD-8C0083 add
      IF (sr.aag15 IS NULL OR sr.aag15 =' ') AND
         (sr.aag16 IS NULL OR sr.aag16 =' ') AND
         (sr.aag17 IS NULL OR sr.aag17 =' ') AND
         (sr.aag18 IS NULL OR sr.aag18 =' ') AND
         (sr.aag31 IS NULL OR sr.aag31 =' ') AND
         (sr.aag32 IS NULL OR sr.aag32 =' ') AND
         (sr.aag33 IS NULL OR sr.aag33 =' ') AND
         (sr.aag34 IS NULL OR sr.aag34 =' ') AND
         (sr.aag35 IS NULL OR sr.aag35 =' ') AND
         (sr.aag36 IS NULL OR sr.aag36 =' ') AND
         (sr.aag37 IS NULL OR sr.aag37 =' ') AND
         tm.a MATCHES '[nN]' THEN      #列印無異動碼
         CONTINUE FOREACH
      ELSE
     #end MOD-8C0083 add
        #->FUN-5C0015--------------------------------------------------------(S)
         SELECT ahe02 INTO sr.ahe15 FROM ahe_file WHERE ahe01=sr.aag15
         SELECT ahe02 INTO sr.ahe16 FROM ahe_file WHERE ahe01=sr.aag16
         SELECT ahe02 INTO sr.ahe17 FROM ahe_file WHERE ahe01=sr.aag17
         SELECT ahe02 INTO sr.ahe18 FROM ahe_file WHERE ahe01=sr.aag18
         SELECT ahe02 INTO sr.ahe31 FROM ahe_file WHERE ahe01=sr.aag31
         SELECT ahe02 INTO sr.ahe32 FROM ahe_file WHERE ahe01=sr.aag32
         SELECT ahe02 INTO sr.ahe33 FROM ahe_file WHERE ahe01=sr.aag33
         SELECT ahe02 INTO sr.ahe34 FROM ahe_file WHERE ahe01=sr.aag34
         SELECT ahe02 INTO sr.ahe35 FROM ahe_file WHERE ahe01=sr.aag35
         SELECT ahe02 INTO sr.ahe36 FROM ahe_file WHERE ahe01=sr.aag36
         SELECT ahe02 INTO sr.ahe37 FROM ahe_file WHERE ahe01=sr.aag37
        #->FUN-5C0015--------------------------------------------------------(E)
#No.FUN-790008---Begin
#        OUTPUT TO REPORT aglr909_rep(sr.*)
         EXECUTE insert_prep USING
            sr.aag01,sr.aag02,sr.aag13,sr.aag15,sr.aag16,sr.aag17,
            sr.aag18,sr.aag31,sr.aag32,sr.aag33,sr.aag34,sr.aag35,   #MOD-8C0083 add aag18
            sr.aag36,sr.aag37,sr.ahe15,sr.ahe16,sr.ahe17,sr.ahe18,
            sr.ahe31,sr.ahe32,sr.ahe33,sr.ahe34,sr.ahe35,sr.ahe36,
            sr.ahe37
      END IF   #MOD-8C0083 add
   END FOREACH
#  FINISH REPORT aglr909_rep
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-8A0068 add
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
   ELSE
      LET tm.wc=""
   END IF                                                                                                                          
   LET g_str = tm.wc,";",tm.a,";",tm.b 
   CALL cl_prt_cs3('aglr909','aglr909',l_sql,g_str)     
#No.FUN-790008---End 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
{                                #No.FUN-790008
REPORT aglr909_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
          l_trailer_sw  LIKE type_file.chr1,      #No.FUN-680098  VARCHAR(1)
          sr            RECORD
                           aag01    LIKE aag_file.aag01,
                           aag02    LIKE aag_file.aag02,
                           aag13    LIKE aag_file.aag13,  #FUN-6C0012
                           aag15    LIKE aag_file.aag15,
                           aag16    LIKE aag_file.aag16,
                           aag17    LIKE aag_file.aag17,
                           aag18    LIKE aag_file.aag18,
                           aag31    LIKE aag_file.aag31,  #FUN-5C0015---(S)
                           aag32    LIKE aag_file.aag32,
                           aag33    LIKE aag_file.aag33,
                           aag34    LIKE aag_file.aag34,
                           aag35    LIKE aag_file.aag35,
                           aag36    LIKE aag_file.aag36,
                           aag37    LIKE aag_file.aag37,
                           ahe15    LIKE ahe_file.ahe02,
                           ahe16    LIKE ahe_file.ahe02,
                           ahe17    LIKE ahe_file.ahe02,
                           ahe18    LIKE ahe_file.ahe02,
                           ahe31    LIKE ahe_file.ahe02,
                           ahe32    LIKE ahe_file.ahe02,
                           ahe33    LIKE ahe_file.ahe02,
                           ahe34    LIKE ahe_file.ahe02,
                           ahe35    LIKE ahe_file.ahe02,
                           ahe36    LIKE ahe_file.ahe02,
                           ahe37    LIKE ahe_file.ahe02   #FUN-5C0015---(E)
                        END RECORD
 
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
         PRINT ' '
         PRINT g_dash[1,g_len]
        #FUN-5C0015--------------------------------------------(S)
        #PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],        #FUN-6C0012
         PRINT g_x[31],g_x[32],g_x[44],g_x[33],g_x[34],g_x[35],g_x[36],#FUN-6C0012 
               g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
        #FUN-5C0015--------------------------------------------(E)
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      ON EVERY ROW
         IF (sr.aag15 IS NULL OR sr.aag15 =' ') AND
            (sr.aag16 IS NULL OR sr.aag16 =' ') AND
            (sr.aag17 IS NULL OR sr.aag17 =' ') AND
           #FUN-5C0015---------------------------------(S)
           #(sr.aag18 IS NULL OR sr.aag18 =' ') THEN
            (sr.aag31 IS NULL OR sr.aag31 =' ') AND
            (sr.aag32 IS NULL OR sr.aag32 =' ') AND
            (sr.aag33 IS NULL OR sr.aag33 =' ') AND
            (sr.aag34 IS NULL OR sr.aag34 =' ') AND
            (sr.aag35 IS NULL OR sr.aag35 =' ') AND
            (sr.aag36 IS NULL OR sr.aag36 =' ') AND
            (sr.aag37 IS NULL OR sr.aag37 =' ') THEN
           #FUN-5C0015---------------------------------(E)
            IF tm.a NOT MATCHES '[nN]' THEN
               PRINT COLUMN g_c[31],sr.aag01,
                     COLUMN g_c[32],sr.aag02,
                     COLUMN g_c[44],sr.aag13,   #FUN-6C0012
                    #COLUMN g_c[33],sr.aag15,          #FUN-5C0015---(S)
                    #COLUMN g_c[34],sr.aag16,
                    #COLUMN g_c[35],sr.aag17,
                    #COLUMN g_c[36],sr.aag18 CLIPPED,
                     COLUMN g_c[33],sr.ahe15 CLIPPED,
                     COLUMN g_c[34],sr.ahe16 CLIPPED,
                     COLUMN g_c[35],sr.ahe17 CLIPPED,
                     COLUMN g_c[36],sr.ahe18 CLIPPED,
                     COLUMN g_c[37],sr.ahe31 CLIPPED,
                     COLUMN g_c[38],sr.ahe32 CLIPPED,
                     COLUMN g_c[39],sr.ahe33 CLIPPED,
                     COLUMN g_c[40],sr.ahe34 CLIPPED,
                     COLUMN g_c[41],sr.ahe35 CLIPPED,
                     COLUMN g_c[42],sr.ahe36 CLIPPED,
                     COLUMN g_c[43],sr.ahe37 CLIPPED   #FUN-5C0015---(E)
            END IF
         ELSE
            PRINT COLUMN g_c[31],sr.aag01,
                  COLUMN g_c[32],sr.aag02,
                  COLUMN g_c[44],sr.aag13,    #FUN-6C0012
                 #COLUMN g_c[33],sr.aag15,             #FUN-5C0015---(S)
                 #COLUMN g_c[34],sr.aag16,
                 #COLUMN g_c[35],sr.aag17,
                 #COLUMN g_c[36],sr.aag18 CLIPPED,
                  COLUMN g_c[33],sr.ahe15 CLIPPED,
                  COLUMN g_c[34],sr.ahe16 CLIPPED,
                  COLUMN g_c[35],sr.ahe17 CLIPPED,
                  COLUMN g_c[36],sr.ahe18 CLIPPED,
                  COLUMN g_c[37],sr.ahe31 CLIPPED,
                  COLUMN g_c[38],sr.ahe32 CLIPPED,
                  COLUMN g_c[39],sr.ahe33 CLIPPED,
                  COLUMN g_c[40],sr.ahe34 CLIPPED,
                  COLUMN g_c[41],sr.ahe35 CLIPPED,
                  COLUMN g_c[42],sr.ahe36 CLIPPED,
                  COLUMN g_c[43],sr.ahe37 CLIPPED      #FUN-5C0015---(E)
         END IF
 
      ON LAST ROW
         #PRINT g_dash[1,g_len]  #FUN-6C0012
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            CALL cl_wcchp(tm.wc,'aag01') RETURNING tm.wc
            PRINT g_dash[1,g_len]
        #TQC-630166
        #    IF tm.wc[001,080] > ' ' THEN
        #       PRINT COLUMN g_c[31],g_x[8] CLIPPED,
        #             COLUMN g_c[32],tm.wc[001,070] CLIPPED
        #    END IF
        #    IF tm.wc[071,140] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
        #    END IF
        #    IF tm.wc[141,210] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
        #    END IF
         CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
 
         END IF
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
         LET l_trailer_sw = 'n'
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
#Patch....NO.TQC-610035 <001> #   }          #No.FUN-790008
