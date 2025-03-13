# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimr997.4gl
# Descriptions...: 盤盈虧明細表
# Date & Author..: 99/12/24 by Snow
# Modify  .......: 00/07/12 By Ostrich 以pia08為帳上庫存
# Modify.........: No.FUN-510017 05/01/12 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.MOD-520103 05/06/09 By kim 若僅有初盤時，盤盈虧會算不到
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/13 By baogui 金額總計不對齊
# Modify.........: NO.FUN-7B0139 07/12/07 By zhaijie 報表輸出改為Crystal Report
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.FUN-8B0027 08/11/26 By jan 提供INPUT加上關系人與營運中心
# Modify.........: No.MOD-8C0149 08/12/16 By claire 調整同aimr998複盤二,複盤一,初盤二,初盤一給值
# Modify.........: No.FUN-930121 09/04/14 By zhaijie新增查詢字段pia931-底稿類型
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0011 09/11/03 By liuxqa 跨数据统一改成s_dbstring.
# Modify.........: No.FUN-9C0170 10/01/11 By jan 新增ctype欄位及相關處理
# Modify.........: No.FUN-A10056 10/01/14 By wuxj 跨DB語法改成 cl_get_target_table(plant,table) ，
#                                                 且 prepare 前 CALL cl_parse_qry_sql(l_sql,m_dbs[l_i] ) RETURNING l_sql 
# Modify.........: No.FUN-A70084 10/07/15 By lutingting GP5.2報表修改
# Modify.........: No.FUN-A80097 10/08/17 By lutingting 修正 FUN-A70084 問題
# Modify.........: No:MOD-AA0068 10/10/13 By Carrier img_file及azf_file 外连处理,原因是与aimr899对应不上
# Modify.........: No:MOD-C10048 12/01/06 By ck2yuan 若tm.yy1無輸入,在處理多ds會沿用上次的的tm.yy1,故另存變數使下次可重抓日期
# Modify.........: No:MOD-CC0207 13/01/11 By Elise 報表抓取數量順序改為複盤一,初盤一
# Modify.........: No:MOD-D70069 13/07/10 By fengmy 當tm.f ='1' OR tm.f='3'時,應從tlf表關聯,增加tlf06篩選條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc        LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
           yy1,mm1   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           b         LIKE type_file.chr1,    #No.FUN-8B0027 VARCHAR(1)
          #FUN-A70084--mark--str--
          #p1        LIKE azp_file.azp01,    #No.FUN-8B0027 VARCHAR(10)
          #p2        LIKE azp_file.azp01,    #No.FUN-8B0027 VARCHAR(10)
          #p3        LIKE azp_file.azp01,    #No.FUN-8B0027 VARCHAR(10)
          #p4        LIKE azp_file.azp01,    #No.FUN-8B0027 VARCHAR(10)
          #p5        LIKE azp_file.azp01,    #No.FUN-8B0027 VARCHAR(10)
          #p6        LIKE azp_file.azp01,    #No.FUN-8B0027 VARCHAR(10)
          #p7        LIKE azp_file.azp01,    #No.FUN-8B0027 VARCHAR(10)
          #p8        LIKE azp_file.azp01,    #No.FUN-8B0027 VARCHAR(10)
          #FUN-A70084--mark--end
	   s         LIKE type_file.chr3,    # Order by sequence  #No.FUN-690026 VARCHAR(3)
	   t         LIKE type_file.chr3,    # Eject sw  #No.FUN-690026 VARCHAR(3)
	   u         LIKE type_file.chr3,    # Group total sw  #No.FUN-690026 VARCHAR(3)
           d         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           e         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           f         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           ctype     LIKE type_file.chr1,    #FUN-9C0170
           more      LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
           END RECORD
#DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT #NO.FUN-7B0139
DEFINE g_sql      STRING                                         #NO.FUN-7B0139
DEFINE g_str      STRING                                         #NO.FUN-7B0139
DEFINE l_table    STRING                                         #NO.FUN-7B0139
#DEFINE m_dbs      ARRAY[10] OF LIKE type_file.chr20              #No.FUN-8B0027 ARRAY[10] OF VARCHAR(20)   #FUN-A70084
DEFINE m_plant    LIKE azw_file.azw01                            #FUN-A70084 
DEFINE g_azi_azi03 LIKE azi_file.azi03                           #No.FUN-8B0027
DEFINE g_azi_azi04 LIKE azi_file.azi04                           #No.FUN-8B0027
DEFINE g_azi_azi05 LIKE azi_file.azi05                           #No.FUN-8B0027
DEFINE g_wc        LIKE type_file.chr1000                        #No.FUN-A70084 
DEFINE g_yy,g_mm   LIKE type_file.num5                           #MOD-C10048 add

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
#NO.FUN-7B0139------------start---------------
   LET g_sql = "pia01.pia_file.pia01,",
               "pia02.pia_file.pia02,",
               "pia03.pia_file.pia03,",
               "pia04.pia_file.pia04,",  
               "pia05.pia_file.pia05,", 
               "pia08.pia_file.pia08,",
               "pia09.pia_file.pia09,",
               "pia30.pia_file.pia30,",
               "pia50.pia_file.pia50,",
               "ima12.ima_file.ima12,",
               "azf03.azf_file.azf03,",
               "img09.img_file.img09,",  
               "pia08_c.ccc_file.ccc23,",
               "pia30_c.ccc_file.ccc23,",
               "diff.pia_file.pia30,",
               "diff_c.ccc_file.ccc23,",
               "ccc23.ccc_file.ccc23,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               " plant.azp_file.azp01,",         #FUN-8B0027
               "azi03.azi_file.azi03,",          #FUN-8B0027
               "azi04.azi_file.azi04,",          #FUN-8B0027
               "azi05.azi_file.azi05,",          #FUN-8B0027
               "ccc08.ccc_file.ccc08"            #FUN-9C0170
   LET l_table = cl_prt_temptable('aimr997',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"  #FUN-8B0027 add ?,?,?,?  #FUN-9C0170
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-7B0139------------end-----------
   #TQC-610072-begin
   #LET g_pdate = ARG_VAL(1)
   #LET g_towhom = ARG_VAL(2)
   #LET g_rlang = ARG_VAL(3)
   #LET g_bgjob = 'N'
   #LET g_prtway = ARG_VAL(4)
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET tm.yy1  = ARG_VAL(11)
   LET tm.mm1  = ARG_VAL(12)
   LET tm.d  = ARG_VAL(13)
   LET tm.e  = ARG_VAL(14)
   LET tm.f  = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #TQC-610072-end
#FUN-A70084--mark--str--
#  #FUN-8B0027--BEGIN--
#  LET tm.b     = ARG_VAL(20)
#  LET tm.p1    = ARG_VAL(21)
#  LET tm.p2    = ARG_VAL(22)
#  LET tm.p3    = ARG_VAL(23)
#  LET tm.p4    = ARG_VAL(24)
#  LET tm.p5    = ARG_VAL(25)
#  LET tm.p6    = ARG_VAL(26)
#  LET tm.p7    = ARG_VAL(27)
#  LET tm.p8    = ARG_VAL(28)
#  #FUN-8B0027--END--
#FUN-A70084--mark--end
  #LET tm.ctype = ARG_VAL(29)    #FUN-9C0170   #FUN-A70084
   LET tm.ctype = ARG_VAL(20)    #FUN-A70084
   LET g_wc = ARG_VAL(21)        #FUN-A70084
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r997_tm(0,0)
      ELSE CALL r997()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
#-------------------------r997_tm()---------------------------
FUNCTION r997_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
DEFINE li_result      LIKE type_file.num5    #No.FUN-940102
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 13 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 13
   END IF
 
   OPEN WINDOW r997_w AT p_row,p_col
         WITH FORM "aim/42f/aimr997"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################

   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #FUN-9C0170

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.d    = 'N'
   LET tm.e    = '3'
   LET tm.f    = '1'
   LET tm.s    = '146'
   LET tm.t    = '   '
   LET tm.u    = '   '
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.ctype = g_ccz.ccz28   #FUN-9C0170
#FUN-A70084--mark--str--
#  #FUN-8B0027-Begin--# 
#  LET tm.b ='N'
#  LET tm.p1=g_plant
#  CALL r997_set_entry_1()
#  CALL r997_set_no_entry_1()
#  CALL r997_set_comb()
#  #FUN-8B0027-End--#
#FUN-A70084--mark--end
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
WHILE TRUE
#FUN-A70084--add--str--
   CONSTRUCT BY NAME g_wc ON azw01 

      BEFORE CONSTRUCT
          CALL cl_qbe_init()

      ON ACTION controlp
            IF INFIELD(azw01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "azw02 = '",g_legal,"' ",
                                      " AND azw01 IN(SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' )"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azw01
               NEXT FIELD azw01 
            END IF

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
     CLOSE WINDOW r997_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
  END IF
#FUN-A70084--add--end
   CONSTRUCT BY NAME tm.wc ON ima12,pia02,pia05,pia931,pia03,pia04,pia01  #FUN-930121 add pia931
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
            IF INFIELD(pia02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pia02
               NEXT FIELD pia02
            END IF
#No.FUN-570240 --end
 
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
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r997_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
#  IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#UI
  #INPUT BY NAME tm.b,tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,   #FUN-8B0027   #FUN-A70084
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3, tm2.t1,tm2.t2,tm2.t3, tm2.u1,tm2.u2,tm2.u3,
                 tm.yy1,tm.mm1,tm.ctype,   #FUN-9C0170
                 tm.d,tm.e,tm.f,tm.more
                WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
#FUN-A70084--mark--str--
#     #FUN-8B0027--Begin--# 
#     AFTER FIELD b
#         IF NOT cl_null(tm.b)  THEN
#            IF tm.b NOT MATCHES "[YN]" THEN 
#               NEXT FIELD b
#            END IF
#         END IF
#
#      ON CHANGE  b
#         LET tm.p1=g_plant
#         LET tm.p2=NULL
#         LET tm.p3=NULL
#         LET tm.p4=NULL
#         LET tm.p5=NULL
#         LET tm.p6=NULL
#         LET tm.p7=NULL
#         LET tm.p8=NULL
#         DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8
#         CALL r997_set_entry_1()
#         CALL r997_set_no_entry_1()
#         CALL r997_set_comb()
#
#     AFTER FIELD p1
#        IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#        SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#        IF STATUS THEN
#           CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)
#           NEXT FIELD p1
#        END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.p1) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD p1
#           END IF 
#    #No.FUN-940102 --end--
#
#     AFTER FIELD p2
#        IF NOT cl_null(tm.p2) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)
#              NEXT FIELD p2
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.p2) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD p2
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#
#     AFTER FIELD p3
#        IF NOT cl_null(tm.p3) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)
#              NEXT FIELD p3
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.p3) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD p3
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#
#     AFTER FIELD p4
#        IF NOT cl_null(tm.p4) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)
#              NEXT FIELD p4
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.p4) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD p4
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#
#     AFTER FIELD p5
#        IF NOT cl_null(tm.p5) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)
#              NEXT FIELD p5
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.p5) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD p5
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#
#     AFTER FIELD p6
#        IF NOT cl_null(tm.p6) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)
#              NEXT FIELD p6
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.p6) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD p6
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#
#     AFTER FIELD p7
#        IF NOT cl_null(tm.p7) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1)
#              NEXT FIELD p7
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.p7) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD p7
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#
#     AFTER FIELD p8
#        IF NOT cl_null(tm.p8) THEN
#           SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#           IF STATUS THEN
#              CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)
#              NEXT FIELD p8
#           END IF
#    #No.FUN-940102 --begin--
#           CALL s_chk_demo(g_user,tm.p8) RETURNING li_result
#           IF not li_result THEN 
#            NEXT FIELD p8
#           END IF 
#    #No.FUN-940102 --end--
#        END IF
#     #FUN-8B0027--END--
#FUN-A70084--mark--end 

      AFTER FIELD d
         IF tm.d NOT MATCHES '[YN]' THEN
            NEXT FIELD d
         END IF
      AFTER FIELD e
         IF tm.e NOT MATCHES '[123]' THEN
            NEXT FIELD e
         END IF
      AFTER FIELD f
         IF tm.f NOT MATCHES '[123]' THEN
            NEXT FIELD f
         END IF

      AFTER FIELD mm1
         IF tm.mm1 >12 THEN
            NEXT FIELD mm1
         END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
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
#FUN-A70084--mark--str--
#     #No.FUN-8B0027--BEGIN--
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
##              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#           WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
##              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#           WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
##              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#           WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
##              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#           WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
##              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p5
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#           WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
##              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#           WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
##              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#           WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
##              LET g_qryparam.form ="q_azp"    #No.FUN-940102
#              LET g_qryparam.form ="q_zxy"    #No.FUN-940102
#              LET g_qryparam.arg1 = g_user    #No.FUN-940102
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#        END CASE
#       #FUN-8B0027--END--
#FUN-A70084--mark--end
      ON ACTION CONTROLG CALL cl_cmdask()
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
         LET g_yy = tm.yy1        #MOD-C10048 add
         LET g_mm = tm.mm1        #MOD-C10048 add
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
      LET INT_FLAG = 0
      CLOSE WINDOW r997_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='aimr997'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr997','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                        #TQC-610072-begin
                        # " '",tm.yy1 CLIPPED,"'",
                        # " '",tm.mm1 CLIPPED,"'",
                        # " '",tm.d CLIPPED,"'",
                         " '",tm.s   CLIPPED,"'",
                         " '",tm.t   CLIPPED,"'",
                         " '",tm.u   CLIPPED,"'",
                         " '",tm.yy1 CLIPPED,"'",
                         " '",tm.mm1 CLIPPED,"'",
                         " '",tm.d   CLIPPED,"'",
                         " '",tm.e   CLIPPED,"'",
                         " '",tm.f   CLIPPED,"'",
                        #TQC-610072-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                        #FUN-A70084--mark--str--
                        #" '",tm.b   CLIPPED,"'",   #FUN-8B0027
                        #" '",tm.p1   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p2   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p3   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p4   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p5   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p6   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p7   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p8   CLIPPED,"'",  #FUN-8B0027
                        #FUN-A70084--mark--end
                         " '",tm.ctype CLIPPED,"'", #FUN-9C0170
                         " '",g_wc CLIPPED,"'"  #FUN-A70084
         CALL cl_cmdat('aimr997',g_time,l_cmd)
      END IF
      CLOSE WINDOW r997_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r997()
   ERROR ""
END WHILE
   CLOSE WINDOW r997_w
END FUNCTION
#-------------------------FUNCTION r997()------------------------
FUNCTION r997()
  DEFINE l_name    LIKE type_file.chr20            # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#  DEFINE l_time    LIKE type_file.chr8             # Used time for running the job  #No.FUN-690026 VARCHAR(8) #No.FUN-6A0074
  DEFINE l_sql     LIKE type_file.chr1000          # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
  DEFINE l_za05    LIKE za_file.za05               #No.FUN-690026 VARCHAR(40)
#  DEFINE l_order   ARRAY[3] OF LIKE ima_file.ima01 #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)  #NO.FUN-7B0139
  DEFINE sr        RECORD
	   		order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
			order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
			order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                        pia01  LIKE pia_file.pia01, #標籤編號
                        pia02  LIKE pia_file.pia02, #料號
                        pia03  LIKE pia_file.pia03, #倉庫
                        pia04  LIKE pia_file.pia04, #儲位
                        pia05  LIKE pia_file.pia05, #批號
                        pia08  LIKE pia_file.pia08, #帳上庫存
                        pia09  LIKE pia_file.pia09, #庫存單位
                        pia30  LIKE pia_file.pia30, #初盤
                       #ima02  VARCHAR(30),            #品名
                       #ima021 LIKE ima_file.ima021,#規格
                        pia50  LIKE pia_file.pia50,
                        ima12  LIKE ima_file.ima12 ,#科目代號
                        azf03  LIKE azf_file.azf03 ,#科目名稱
                        img09  LIKE img_file.img09, #單位
                        pia08_c LIKE ccc_file.ccc23,#pia08*ccc23    #MOD-530179
                        pia30_c LIKE ccc_file.ccc23,#pia30*ccc23    #MOD-530179
                        diff    LIKE pia_file.pia30,#pia30-pia08    #MOD-530179
                        diff_c  LIKE ccc_file.ccc23,#diff*ccc23     #MOD-530179
                        ccc23   LIKE ccc_file.ccc23,
                        ccc08   LIKE ccc_file.ccc08 #FUN-9C0170
                     END RECORD
  DEFINE l_ima02      LIKE ima_file.ima02      #FUN-7B0139
  DEFINE l_ima021     LIKE ima_file.ima021     #FUN-7B0139
  DEFINE l_i        LIKE type_file.num5                 #No.FUN-8B0027 SMALLINT
  DEFINE l_dbs      LIKE azp_file.azp03                 #No.FUN-8B0027
  DEFINE l_azp03    LIKE azp_file.azp03                 #No.FUN-8B0027
  DEFINE i          LIKE type_file.num5                 #No.FUN-8B0027
  DEFINE l_pia40    LIKE pia_file.pia40        #MOD-8C0149
  DEFINE l_pia60    LIKE pia_file.pia60        #MOD-8C0149
  DEFINE l_str      STRING                     #FUN-9C0170
  DEFINE l_str1     STRING                     #FUN-9C0170
  DEFINE l_str2     STRING                     #FUN-9C0170
  DEFINE l_pia50    LIKE pia_file.pia50        #MOD-CC0207 add
  DEFINE l_pia30    LIKE pia_file.pia30        #MOD-CC0207 add
  DEFINE l_bdate,l_edate  LIKE type_file.dat   #MOD-D70069  add 
  
     CALL cl_del_data(l_table)                 #FUN-7B0139
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimr997'      #FUN-7B0139
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,azi05
#       INTO g_azi03,g_azi04,g_azi05          #幣別檔小數位數讀取
#       FROM azi_file
#      WHERE azi01=g_aza.aza17
#NO.CHI-6A0004--END
     #FUN-8B0027-Begin--#
   SELECT azi05 INTO g_azi_azi05 FROM azi_file WHERE azi01=g_aza.aza17
#FUN-A70084--mark--str--
#  FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#  LET m_dbs[1]=tm.p1
#  LET m_dbs[2]=tm.p2
#  LET m_dbs[3]=tm.p3
#  LET m_dbs[4]=tm.p4
#  LET m_dbs[5]=tm.p5
#  LET m_dbs[6]=tm.p6
#  LET m_dbs[7]=tm.p7
#  LET m_dbs[8]=tm.p8
#  #FUN-8B0027--End--#
#FUN-A70084--mark--end

#FUN-A70084--mod--str--
#  FOR l_i = 1 to 8
#     #IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8B0027   #FUN-A70084
#      IF cl_null(m_plant[l_i]) THEN CONTINUE FOR END IF          #FUN-A70084
   LET g_sql = "SELECT azw01 FROM azw_file,azp_file ",
               " WHERE azp01 = azw01 AND azwacti = 'Y'",
               "   AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"')",
               "   AND ",g_wc CLIPPED
   PREPARE sel_azw01_pre FROM g_sql
   DECLARE sel_azw01_cur CURSOR FOR sel_azw01_pre
   FOREACH sel_azw01_cur INTO m_plant
   IF cl_null(m_plant) THEN CONTINUE FOREACH END IF 
#FUN-A70084--mod--end
#NO.FUN-A10056  ---START---mark
#       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8B0027
#       LET l_azp03 = l_dbs CLIPPED                                           #FUN-8B0027
#       #LET l_dbs = FGL_GETENV("MSSQLAREA") CLIPPED,'_', l_dbs CLIPPED,'.dbo.'                                          #FUN-8B0027
#       LET l_dbs = s_dbstring(l_dbs CLIPPED)      #TQC-9B0011 mod
#NO.FUN-A10056 ---END---
     #如果計價年月空白，則採現行年月(modi in 010607)
     #No.FUN-8B0027--BEGIN--
     IF cl_null(tm.yy1) THEN
#        SELECT ccz01,ccz02 INTO tm.yy1,tm.mm1 FROM ccz_file
#         WHERE ccz00 = '0'
#     END IF
        LET l_sql = "SELECT ccz01,ccz02 ", 
                   #NO.FUN-A10056 ----start---
                   #"  FROM ",l_dbs CLIPPED,"ccz_file ",
                   #"  FROM ",cl_get_target_table(m_dbs[l_i], 'ccz_file'),   #FUN-A70084
                    "  FROM ",cl_get_target_table(m_plant, 'ccz_file'),   #FUN-A70084
                   #NO.FUN-A10056 ----end---
                    " WHERE ccz00 = '0'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-A80097
        CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #FUN-A80097
        PREPARE ccz_prepare1 FROM l_sql                                                                                         
          DECLARE ccz_c1  CURSOR FOR ccz_prepare1                                                                               
          OPEN ccz_c1                                                                                                             
         #FETCH ccz_c1 INTO tm.yy1,tm.mm1   #MOD-C10048 mark
          FETCH ccz_c1 INTO g_yy,g_mm       #MOD-C10048 add 
     END IF 
     CALL s_ymtodate(g_yy,g_mm,g_yy,g_mm) RETURNING l_bdate,l_edate    #MOD-D70069    
     LET l_sql = "SELECT azi03,azi04 ",
                #NO.FUN-A10056 ---start---
                #"  FROM ",l_dbs CLIPPED,"azi_file ",
                #"  FROM ",cl_get_target_table(m_dbs[l_i], 'azi_file'),   #FUN-A70084
                 "  FROM ",cl_get_target_table(m_plant, 'azi_file'),   #FUN-A70084
                #NO.FUN-A10056 ---end--- 
                 " WHERE azi01 = '",g_aza.aza17,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-A80097
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #FUN-A80097
     PREPARE azi_prepare1 FROM l_sql                                                                                         
     DECLARE azi_c1  CURSOR FOR azi_prepare1                                                                               
     OPEN azi_c1                                                                                                             
     FETCH azi_c1 INTO g_azi_azi03,g_azi_azi04 
      #No.FUN-8B0027--END--
#--------------------------------------l_sql--------------------------------
     LET l_sql = "SELECT '','','',",
                 "pia01,pia02,pia03,pia04,pia05,pia08,pia09,pia30,pia50, ",
                #"ima02,ima021,img10, ",
                 "ima12,azf03,img09,pia08*ccc23,pia30*ccc23,pia30-pia08, ",
                 "(pia30-pia08)*ccc23,ccc23 ",
                 ",ccc08 ",  #FUN-9C0170
                 ",pia40,pia60",   #MOD-8C0149 add
#                "  FROM pia_file,ima_file,img_file,ccc_file,azf_file ",        #FUN-8B0027
                #NO.FUN-A10056----start--- 
                #"  FROM ",l_dbs CLIPPED,"pia_file,",l_dbs CLIPPED,"ima_file, ",#FUN-8B0027
                #          l_dbs CLIPPED,"img_file,",l_dbs CLIPPED,"ccc_file, ",#FUN-8B0027
                #          l_dbs CLIPPED,"azf_file "                            #FUN-8B0027
                #FUN-A70084--mod-str--
                #"  FROM ",cl_get_target_table(m_dbs[l_i], 'pia_file'),",",
                #          cl_get_target_table(m_dbs[l_i], 'ima_file'),",",
                #          cl_get_target_table(m_dbs[l_i], 'img_file'),",",
                #          cl_get_target_table(m_dbs[l_i], 'ccc_file'),",",
                #          cl_get_target_table(m_dbs[l_i], 'azf_file')
                ##NO.FUN-A10056 ----end----
                #No.MOD-AA0068  --Begin
                #"  FROM ",cl_get_target_table(m_plant, 'pia_file'),",",
                #          cl_get_target_table(m_plant, 'ima_file'),",",
                #          cl_get_target_table(m_plant, 'img_file'),",",
                #          cl_get_target_table(m_plant, 'ccc_file'),",",
                #          cl_get_target_table(m_plant, 'azf_file')
                #FUN-A70084--mod--end
                "  FROM ",cl_get_target_table(m_plant, 'pia_file')," LEFT OUTER JOIN ",cl_get_target_table(m_plant, 'img_file'),
                "                                                    ON  img01=pia02 ",
                "                                                    AND img02=pia03 ",
                "                                                    AND img03=pia04 ",
                "                                                    AND img04=pia05,",
                          cl_get_target_table(m_plant, 'ima_file')," LEFT OUTER JOIN ",cl_get_target_table(m_plant, 'azf_file'),
                "                                                    ON  azf_file.azf01=ima12 ",
                "                                                    AND azf_file.azf02='G',  ",
                          cl_get_target_table(m_plant, 'ccc_file')
                #No.MOD-AA0068  --End  

     #No.MOD-AA0068  --Begin
     LET l_str1 = " WHERE pia02=ima01 ",   #FUN-9C0170
                  "   AND pia02=ccc01 ",
                 #"   AND img01=pia02 ",
                 #"   AND img02=pia03 ",
                 #"   AND img03=pia04 ",
                 #"   AND img04=pia05 ",
                 #"   AND azf_file.azf01=ima12 ",
                 #"   AND azf_file.azf02='G'   ",   #6818
     #No.MOD-AA0068  --End  
                 #NO.FUN-A10056 ---start---
                 #"   AND pia03 NOT IN (SELECT jce02 FROM ",l_dbs CLIPPED,"jce_file )",  #JIT除外
                 #"   AND pia03 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_dbs[l_i], 'jce_file'),")",   #FUN-A70084
                  "   AND pia03 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_plant, 'jce_file'),")",   #FUN-A70084
                 #NO.FUN-A10056 ---end---
                 #"   AND ccc02= ",tm.yy1,                #MOD-C10048 mark
                  "   AND ccc02= ",g_yy,                  #MOD-C10048 add
                 #"   AND ccc07='1' ",     #No.FUN-840041 #FUN-9C0170 mark
                  "   AND ccc07='",tm.ctype,"'",          #FUN-9C0170 
                 #"   AND ccc03= ",tm.mm1                 #MOD-C10048 mark
                  "   AND ccc03= ",g_mm                   #MOD-C10048 add
#FUN-9C0170--begin--add-----------------------------
     IF tm.ctype = '5' THEN
#NO.FUN-A10056----START---
#        LET l_str  = ",", l_dbs CLIPPED,"imd_file "
#        LET l_str  = ",", cl_get_target_table(m_dbs[l_i], 'imd_file')      #FUN-A70084
         LET l_str  = ",", cl_get_target_table(m_plant, 'imd_file')    #FUN-A70084
#NO.FUN-A10056----END---  
     ELSE
        LET l_str = ''
     END IF
     #MOD-D70069--begin---
     IF tm.f = '1' OR tm.f = '3' THEN  
           LET l_str = l_str,",",cl_get_target_table(m_plant, 'tlf_file')
           LET l_str1= l_str1," AND tlf905=pia01"   
     END IF
     #MOD-D70069--end-----
     CASE tm.ctype
       WHEN '3'
          LET l_str2 = " AND img04 = ccc08 "
       WHEN '5'
          LET l_str2 = " AND img02 = imd01 AND imd09=ccc08"
       OTHERWISE
          LET l_str2 = ''
     END CASE
     LET l_sql = l_sql,l_str,l_str1,l_str2
#FUN-9C0170--end--add----------------------------------
     DISPLAY "l_sql:",l_sql
     #MOD-D70069--begin----------     
#     CASE WHEN tm.f = '1' LET l_sql = l_sql CLIPPED," AND pia19='Y' "
#          WHEN tm.f = '2' LET l_sql = l_sql CLIPPED," AND pia19<>'Y' "
#     END CASE
     CASE WHEN tm.f = '1' LET l_sql = l_sql CLIPPED," AND pia19='Y' AND tlf06 BETWEEN '",l_bdate CLIPPED,"' AND '",l_edate CLIPPED,"'"
          WHEN tm.f = '2' LET l_sql = l_sql CLIPPED," AND pia19<>'Y' "
          WHEN tm.f = '3' LET l_sql = l_sql CLIPPED," AND ((pia19='Y' AND tlf06 BETWEEN '",l_bdate CLIPPED,"' AND '",l_edate CLIPPED,"')",
                                                       " OR pia19<>'Y')"
     END CASE 
     #MOD-D70069--end------------
     LET l_sql = l_sql CLIPPED," AND ",tm.wc CLIPPED
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A80097
    #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql    #NO.FUN-A10056  add   #FUN-A70084
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql  #FUN-A70084
     
     PREPARE r997_prepare1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE r997_curs1 CURSOR FOR r997_prepare1
#     CALL cl_outnam('aimr997') RETURNING l_name           #NO.FUN-7B0139  
#NO.FUN-7B0139-------------------start------mark----------------
#     CASE WHEN tm.e = '1' LET g_x[1] = g_x[1] CLIPPED, '(盤盈'
#          WHEN tm.e = '2' LET g_x[1] = g_x[1] CLIPPED, '(盤虧'
#          WHEN tm.e = '3' LET g_x[1] = g_x[1] CLIPPED, '(全部'
#     END CASE
 
#     CASE WHEN tm.f = '1' LET g_x[1] = g_x[1] CLIPPED, '已過帳)'
#          WHEN tm.f = '2' LET g_x[1] = g_x[1] CLIPPED, '未過帳)'
#          WHEN tm.f = '3' LET g_x[1] = g_x[1] CLIPPED, ')'
#     END CASE
 
#     START REPORT r997_rep TO l_name
#     LET g_pageno = 0
#NO.FUN-7B0139-------------------end------mark----------------
     FOREACH r997_curs1 INTO sr.*,l_pia40,l_pia60  #MOD-8C0149 add pia40,pia60
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.pia30 IS NULL THEN LET sr.pia30=0 END IF
      #MOD-CC0207---mark---s    
      ##MOD-8C0149-begin-add
      ##No.B483 010510 by linda mod 順序應為複盤二,複盤一,初盤二,初盤一
      #IF not cl_null(l_pia60)  THEN
      #   LET sr.pia30 = l_pia60
      #ELSE
      #   IF NOT cl_null(sr.pia50) THEN
      #      LET sr.pia30=sr.pia50
      #   ELSE
      #      IF NOT cl_null(l_pia40) THEN
      #         LET sr.pia30 = l_pia40
      #      END IF
      #   END IF
      #END IF
      ##No.B483 end---
      #MOD-CC0207---mark---e
      #MOD-CC0207---S
      #順序改為複盤一,初盤一
       SELECT pia30,pia50 INTO l_pia30,l_pia50 FROM pia_file
        WHERE pia01=sr.pia01

       IF NOT cl_null(l_pia50) THEN
          LET sr.pia30 = l_pia50
       ELSE
          IF NOT cl_null(l_pia30) THEN
             LET sr.pia30 = l_pia30
          END IF
       END IF
      #MOD-CC0207---E

       ##------------------------------------------------------------
       ##-->複盤有值先以複盤為主
       # #MOD-520103................begin
       #IF not cl_null(sr.pia50) THEN
       #   LET sr.pia30 = sr.pia50
       #END IF
       #MOD-8C0149-end-modify
       LET sr.pia08_c = sr.pia08*sr.ccc23
       LET sr.pia30_c = sr.pia30*sr.ccc23
       LET sr.diff    = sr.pia30-sr.pia08
       LET sr.diff_c  = sr.diff*sr.ccc23
        #MOD-520103................end
       #無盤盈虧差異者..
       IF tm.d='N' AND sr.pia08=sr.pia30 THEN CONTINUE FOREACH END IF
       #------------------------------------------------------------
       #選擇只印盤盈時過濾盤虧資料
       IF tm.e='1' AND sr.pia08>sr.pia30 THEN CONTINUE FOREACH END IF
       #------------------------------------------------------------
       #選擇只印盤虧時過濾盤盈資料
       IF tm.e='2' AND sr.pia08<sr.pia30 THEN CONTINUE FOREACH END IF
       #------------------------------------------------------------
#NO.FUN-7B0139-------------------start------mark----------------
#       FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i]='1' LET l_order[g_i] = sr.ima12
#              WHEN tm.s[g_i,g_i]='2' LET l_order[g_i] = sr.pia02
#              WHEN tm.s[g_i,g_i]='3' LET l_order[g_i] = sr.pia05
#              WHEN tm.s[g_i,g_i]='4' LET l_order[g_i] = sr.pia03
#              WHEN tm.s[g_i,g_i]='5' LET l_order[g_i] = sr.pia04
#              WHEN tm.s[g_i,g_i]='6' LET l_order[g_i] = sr.pia01
#         END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#NO.FUN-7B0139------------------end------mark----------------
  if sr.pia08    is null then let sr.pia08 = 0 end if
  if sr.pia30    is null then let sr.pia30 = 0 end if
  if sr.pia08_c  is null then let sr.pia08_c = 0 end if
  if sr.pia30_c  is null then let sr.pia30_c = 0 end if
  if sr.diff     is null then let sr.diff  = 0 end if
  if sr.diff_c   is null then let sr.diff_c= 0 end if
  if sr.ccc23    is null then let sr.ccc23 = 0 end if
 
 
#       OUTPUT TO REPORT r997_rep(sr.*)                    #NO.FUN-7B0139
#NO.FUN-7B0139--------start------------
     #No.FUN-8B0027--BEGIN--
#     SELECT ima02,ima021 INTO l_ima02,l_ima021
#        FROM ima_file
#       WHERE ima01 = sr.pia02
     LET l_sql = "SELECT ima02,ima021 ",
                #NO.FUN-A10056 ----start----
                #"  FROM ",l_dbs CLIPPED,"ima_file ",
                #"  FROM ",cl_get_target_table(m_dbs[l_i], 'ima_file'),   #FUN-A70084
                 "  FROM ",cl_get_target_table(m_plant, 'ima_file'),   #FUN-A70084
                #NO.FUN-A10056 ----end---
                 " WHERE ima01 = '",sr.pia02,"'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #FUN-A80097
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #FUN-A80097
     PREPARE ima_prepare2 FROM l_sql                                                                                         
     DECLARE ima_c2  CURSOR FOR ima_prepare2                                                                               
     OPEN ima_c2                                                                                                             
     FETCH ima_c2 INTO l_ima02,l_ima021
     #FUN-8B0027--END--
      IF SQLCA.sqlcode THEN
          LET l_ima02  = NULL
          LET l_ima021 = NULL
      END IF
      EXECUTE insert_prep USING
         sr.pia01,sr.pia02,sr.pia03,sr.pia04,sr.pia05,sr.pia08,sr.pia09,
         sr.pia30,sr.pia50,sr.ima12,sr.azf03,sr.img09,sr.pia08_c,sr.pia30_c,
        #sr.diff,sr.diff_c,sr.ccc23,l_ima02,l_ima021,m_dbs[l_i],g_azi_azi03,g_azi_azi04,g_azi_azi05,       #FUN-8B0027     #FUN-A70084
         sr.diff,sr.diff_c,sr.ccc23,l_ima02,l_ima021,m_plant,g_azi_azi03,g_azi_azi04,g_azi_azi05,       #FUN-8B0027   #FUN-A70084
         sr.ccc08    #FUN-9C0170
#NO.FUN-7B0139------end--------------
     END FOREACH
   #END FOR                            #FUN-8B0027    #FUN-A70084
    END FOREACH                        #FUN-A70084 
 
#     FINISH REPORT r997_rep                               #NO.FUN-7B0139
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-7B0139
#NO.FUN-7B0139--------start------------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(tm.wc,'ima12,pia02,pia05,pia03,pia04,pia01,pia931')      #FUN-930121 add pia931
           RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
                 tm.u[1,1],";",tm.u[2,2],";",tm.u[3,3],";",
                 tm.e,";",tm.f,";",g_azi03,";",g_azi04,";",g_azi05,";",tm.b,";",tm.ctype    #FUN-8B0027 #FUN-9C0170   
     CALL cl_prt_cs3('aimr997','aimr997',g_sql,g_str)                      
#NO.FUN-7B0139--------end------------
END FUNCTION
 
#FUN-A70084--mark--str--
##FUN-8B0027--Begin--#                                                                                                               
#FUNCTION r997_set_entry_1()                                                                                                         
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)                                                                          
#END FUNCTION                                                                                                                        
#FUNCTION r997_set_no_entry_1()                                                                                                      
#   IF tm.b = 'N' THEN                                                                                                              
#      CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)                                                                      
#      IF tm2.s1 = '7' THEN                                                                                                         
#         LET tm2.s1 = ' '                                                                                                          
#      END IF                                                                                                                       
#      IF tm2.s2 = '7' THEN                                                                                                         
#         LET tm2.s2 = ' '                                                                                                          
#      END IF                                                                                                                       
#      IF tm2.s3 = '7' THEN                                                                                                         
#         LET tm2.s2 = ' '                                                                                                          
#      END IF                                                                                                                       
#   END IF                                                                                                                          
#END FUNCTION 
#FUNCTION r997_set_comb()                                                                                                            
# DEFINE comb_value STRING                                                                                                          
# DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                   
#   IF tm.b ='N' THEN                                                                                                               
#      LET comb_value = '1,2,3,4,5,6,8'   #FUN-9C0170                                                                                            
#      SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#        WHERE ze01='aim-935' AND ze02=g_lang                                                                                       
#   ELSE                                                                                                                            
#      LET comb_value = '1,2,3,4,5,6,7,8'#FUN-9C0170                                                                                           
#      SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#        WHERE ze01='aim-936' AND ze02=g_lang                                                                                       
#   END IF                                                                                                                          
#   CALL cl_set_combo_items('s1',comb_value,comb_item)                                                                              
#   CALL cl_set_combo_items('s2',comb_value,comb_item)                                                                              
#   CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                              
#END FUNCTION                                                                                                                        
##FUN-8B0027--End--#
#FUN-A70084--mark--end
 
#---------------------------FUNCTION r998()------------------------
#NO.FUN-7B0139--------start----mark--------
#REPORT r997_rep(sr)
#DEFINE l_ima02      LIKE ima_file.ima02      #FUN-510017
#DEFINE l_ima021     LIKE ima_file.ima021     #FUN-510017
#DEFINE l_last_sw    LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
#       l_azf03      LIKE azf_file.azf03,
#       l_order1     LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#       l_order2     LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#       l_order3     LIKE ima_file.ima01  #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#DEFINE sr           RECORD
#	   	           order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#		           order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#		           order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                           pia01  LIKE pia_file.pia01, #標籤編號
#                           pia02  LIKE pia_file.pia02, #料號
#                           pia03  LIKE pia_file.pia03, #倉庫
#                           pia04  LIKE pia_file.pia04, #儲位
#                           pia05  LIKE pia_file.pia05, #批號
#                           pia08  LIKE pia_file.pia08, #帳上庫存
#                           pia09  LIKE pia_file.pia09, #庫存單位
#                           pia30  LIKE pia_file.pia30, #初盤
#                          #ima02  VARCHAR(30),            #品名
#                          #ima021 LIKE ima_file.ima021,#規格
#                           pia50  LIKE pia_file.pia50,
#                           ima12  LIKE ima_file.ima12 ,#科目代號
#                           azf03  LIKE azf_file.azf03 ,#科目名稱
#                           img09  LIKE img_file.img09 ,#單位
#                           pia08_c LIKE ccc_file.ccc23,#pia08*ccc23    #MOD-530179
#                           pia30_c LIKE ccc_file.ccc23,#pia30*ccc23    #MOD-530179
#                           diff    LIKE pia_file.pia30,#pia30-pia08    #MOD-530179
#                           diff_c  LIKE ccc_file.ccc23,#diff*ccc23     #MOD-530179
#                           ccc23  LIKE ccc_file.ccc23
#                     END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
 # ORDER BY sr.ima12,sr.pia01
#  ORDER BY sr.order1,sr.order2,sr.order3
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO >10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#  BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO >10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
 
#  BEFORE GROUP OF sr.order3
#       IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO >10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#  ON EVERY ROW
#      SELECT ima02,ima021 INTO l_ima02,l_ima021
#        FROM ima_file
#       WHERE ima01 = sr.pia02
#      IF SQLCA.sqlcode THEN
#          LET l_ima02  = NULL
#          LET l_ima021 = NULL
#      END IF
#       PRINT COLUMN g_c[31],sr.pia02,
#             COLUMN g_c[32],l_ima02,
#             COLUMN g_c[33],l_ima021,
#             COLUMN g_c[34],sr.pia03,
#             COLUMN g_c[35],sr.pia04,
#             COLUMN g_c[36],sr.pia05,
#             COLUMN g_c[37],sr.img09,
#             COLUMN g_c[38],cl_numfor(sr.pia08,38,3), #帳列數量
#             COLUMN g_c[39],cl_numfor(sr.pia08_c,39,g_azi04),   #帳列金額
#             COLUMN g_c[40],sr.pia01,                           #盤點單號
#             COLUMN g_c[41],cl_numfor(sr.pia30,41,3), #實盤量
#             COLUMN g_c[42],cl_numfor(sr.pia30_c,42,g_azi04),   #實盤金額
#             COLUMN g_c[43],cl_numfor(sr.diff,43,3); #盤盈虧量
#      IF sr.diff_c>5000 OR sr.diff_c<-5000 THEN
#         PRINT COLUMN g_c[44],cl_numfor(sr.diff_c,44,g_azi04),#盤盈虧金額
#               COLUMN g_c[45],'*';
#      ELSE
#         PRINT COLUMN g_c[44],cl_numfor(sr.diff_c,44,g_azi04),#盤盈虧金額
#               COLUMN g_c[45],' ';
#      END IF
#      PRINT COLUMN g_c[46],cl_numfor(sr.ccc23,46,g_azi03) #平均單價
 
#    AFTER GROUP OF sr.order1
#       IF tm.u[1,1] = 'Y' THEN
#           PRINT g_dash2
#           LET l_order1 = sr.order1
#           IF NOT cl_null(sr.order1) THEN
#              IF tm.s[1,1] = '1' THEN LET l_order1 = sr.azf03 END IF
#           END IF
         # PRINT COLUMN 36+(20-FGL_WIDTH(l_order1)),l_order1 CLIPPED,
         #       g_x[30] CLIPPED;
 
#           PRINT COLUMN g_c[36],l_order1 CLIPPED,g_x[15] CLIPPED,
#                 COLUMN g_c[38],cl_numfor(GROUP SUM(sr.pia08),38,3),
#                 COLUMN g_c[39],cl_numfor(GROUP SUM(sr.pia08_c),39,g_azi05),
#                 COLUMN g_c[41],cl_numfor(GROUP SUM(sr.pia30),41,3),
#                 COLUMN g_c[42],cl_numfor(GROUP SUM(sr.pia30_c),42,g_azi05),
#                 COLUMN g_c[43],cl_numfor(GROUP SUM(sr.diff),43,3),
               # COLUMN g_c[44],cl_numfor(GROUP SUM(sr.diff_c),14,g_azi05)   #TQC-6A0088
#                 COLUMN g_c[44],cl_numfor(GROUP SUM(sr.diff_c),44,g_azi05)   #TQC-6A0088
#           PRINT
#       END IF
 
#    AFTER GROUP OF sr.order2
#       IF tm.u[2,2] = 'Y' THEN
#           PRINT g_dash2
#           LET l_order2 = sr.order2
#           IF NOT cl_null(sr.order2) THEN
#              IF tm.s[1,1] = '1' THEN LET l_order2 = sr.azf03 END IF
#           END IF
         # PRINT COLUMN 36+(20-FGL_WIDTH(l_order2)),l_order2 CLIPPED,
         #       g_x[30] CLIPPED;
 
#           PRINT COLUMN g_c[36],l_order2 CLIPPED,g_x[15] CLIPPED,
#                 COLUMN g_c[38],cl_numfor(GROUP SUM(sr.pia08),38,3),
#                 COLUMN g_c[39],cl_numfor(GROUP SUM(sr.pia08_c),39,g_azi05),
#                 COLUMN g_c[41],cl_numfor(GROUP SUM(sr.pia30),41,3),
#                 COLUMN g_c[42],cl_numfor(GROUP SUM(sr.pia30_c),42,g_azi05),
#                 COLUMN g_c[43],cl_numfor(GROUP SUM(sr.diff),43,3),
               # COLUMN g_c[44],cl_numfor(GROUP SUM(sr.diff_c),14,g_azi05)   #TQC-6A0088
#                 COLUMN g_c[44],cl_numfor(GROUP SUM(sr.diff_c),44,g_azi05)   #TQC-6A0088
#           PRINT
#       END IF
 
#    AFTER GROUP OF sr.order3
#       IF tm.u[3,3] = 'Y' THEN
#           PRINT g_dash2
#           LET l_order3 = sr.order3
#           IF NOT cl_null(sr.order3) THEN
#              IF tm.s[1,1] = '1' THEN LET l_order3 = sr.azf03 END IF
#           END IF
         # PRINT COLUMN 36+(20-FGL_WIDTH(l_order3)),l_order3 CLIPPED,
         #       g_x[30] CLIPPED;
 
#           PRINT COLUMN g_c[36],l_order3 CLIPPED,g_x[15] CLIPPED,
#                 COLUMN g_c[38],cl_numfor(GROUP SUM(sr.pia08),38,3),
#                 COLUMN g_c[39],cl_numfor(GROUP SUM(sr.pia08_c),39,g_azi05),
#                 COLUMN g_c[41],cl_numfor(GROUP SUM(sr.pia30),41,3),
#                 COLUMN g_c[42],cl_numfor(GROUP SUM(sr.pia30_c),42,g_azi05),
#                 COLUMN g_c[43],cl_numfor(GROUP SUM(sr.diff),43,3),
             #   COLUMN g_c[44],cl_numfor(GROUP SUM(sr.diff_c),14,g_azi05)   #TQC-6A0088
#                 COLUMN g_c[44],cl_numfor(GROUP SUM(sr.diff_c),44,g_azi05)   #TQC-6A0088
#           PRINT
#       END IF
 
#   ON LAST ROW
#      LET l_last_sw = 'y'
#           PRINT g_dash2
#           PRINT COLUMN g_c[36],g_x[16] CLIPPED,
#                 COLUMN g_c[38],cl_numfor(SUM(sr.pia08),38,3),
#                 COLUMN g_c[39],cl_numfor(SUM(sr.pia08_c),39,g_azi05),
#                 COLUMN g_c[41],cl_numfor(SUM(sr.pia30),41,3),
#                 COLUMN g_c[42],cl_numfor(SUM(sr.pia30_c),42,g_azi05),
#                 COLUMN g_c[43],cl_numfor(SUM(sr.diff),43,3),
             #   COLUMN g_c[44],cl_numfor(SUM(sr.diff_c),14,g_azi05)   #TQC-6A0088
#                 COLUMN g_c[44],cl_numfor(SUM(sr.diff_c),44,g_azi05)   #TQC-6A0088
#      PRINT g_dash
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0005
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.TQC-5C0005
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#NO.FUN-7B0139----------------------END-----MARK-------
#Patch....NO.TQC-610036 <001> #
