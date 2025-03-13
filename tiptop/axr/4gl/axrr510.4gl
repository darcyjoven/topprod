# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr510.4gl
# Descriptions...: 客戶應收期報表
# Date & Author..: 95/02/17 by Nick
# Modify.........: 97/08/28 By Sophia 新增帳別(ooo11)
# Modify.........: No.FUN-4C0100 04/12/29 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-6A0102 06/11/21 By johnray 報表修改
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng  修改報表格式
# Modify.......... No.MOD-720047 07/03/15 By TSD.Ken 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740009 07/04/03 By Judy 會計科目加帳套
# Modify.........: No.TQC-750226 07/05/30 By rainy CR未列印年度期別
# Modify.........: No.TQC-780056 07/08/17 By Carrier oracle語法轉至ora文檔
# Modify.........: No.FUN-830014 08/03/04 By Smapmin 增加"列印餘額為零"的選項
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 10/02/24 By yangtingting 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-C40001 12/04/16 By yinhy 增加開窗功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc       LIKE type_file.chr1000,                #No.FUN-680123 VARCHAR(1000)    # Where condition
              s        LIKE type_file.chr4,                   #No.FUN-680123 VARCHAR(4)       # Order by sequence
              t        LIKE type_file.chr4,                   #No.FUN-680123 VARCHAR(4)       # Eject sw
              u        LIKE type_file.chr4,                   #No.FUN-680123 VARCHAR(4)       # Group total sw
              ooo11    like ooo_file.ooo11,	                  #FUN-B20054
			  y	LIKE type_file.num5,          #No.FUN-680123 SMALLINT
			  b1	LIKE type_file.num5,          #No.FUN-680123 SMALLINT
			  b2    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
			  n	LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
                          c     LIKE type_file.chr1,          #FUN-830014
              more     LIKE type_file.chr1                    #No.FUN-680123 VARCHAR(1)       # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose         #No.FUN-680123 SMALLINT
DEFINE   i               LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE l_table        STRING,                 ### CR11 ###
       g_str          STRING,                 ### CR11 ###
       g_sql          STRING                  ### CR11 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #MOD-720047 - START
   ## *** CR11 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
   LET g_sql = "ooo01.ooo_file.ooo01,",		#客戶編號
               "ooo02.ooo_file.ooo02,",		#客戶簡稱
               "ooo03.ooo_file.ooo03,",		#科目編號
               "aag02.aag_file.aag02,",		#科目名稱
	       "ooo04.ooo_file.ooo04,",		#部門
	       "gem02.gem_file.gem02,",		#部門名稱
               "ooo05.ooo_file.ooo05,",		#幣別
               "amt1.ooo_file.ooo08d,",		#前期
               "amt2.ooo_file.ooo08c,",		#本期借(D)
	       "amt3.ooo_file.ooo09d,",		#本期貸(D)
               "amt4.ooo_file.ooo09d,",		#期末
               "azi03.azi_file.azi03,",		#
               "azi04.azi_file.azi04,",		#
               "azi05.azi_file.azi05,",		#
               "byear.type_file.chr4,",         #年度 #TQC-750226
               "bb.type_file.chr5"              #期別 #TQC-750226 00-12
 
   LET l_table = cl_prt_temptable('axrr510',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ? , ?, ? , ?, ",
               "        ?, ?, ?, ?, ?, ? )"     #TQC-750226 add 2 fields
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #MOD-720047 - END
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)
   LET tm.t = ARG_VAL(9)
   LET tm.u = ARG_VAL(10)
   LET tm.y = ARG_VAL(11)
   LET tm.b1 = ARG_VAL(12)
   LET tm.b2 = ARG_VAL(13)
   LET tm.n = ARG_VAL(14)
   LET tm.c = ARG_VAL(15)   #FUN-830014
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
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
#   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
#   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
#   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.s1) THEN LET tm2.s1 = "1"  END IF  #No.TQC-6A0087
   IF cl_null(tm2.s2) THEN LET tm2.s2 = "2"  END IF  #No.TQC-6A0087
   IF cl_null(tm2.s3) THEN LET tm2.s3 = "4"  END IF  #No.TQC-6A0087 
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
   #no.5196     #No.FUN-680123 
   DROP TABLE curr_tmp
   CREATE TEMP TABLE curr_tmp
    (curr LIKE azi_file.azi01,
     amt1 LIKE type_file.num20_6,
     amt2 LIKE type_file.num20_6,
     amt3 LIKE type_file.num20_6,
     amt4 LIKE type_file.num20_6,
     order1 LIKE ooo_file.ooo01,
     order2 LIKE ooo_file.ooo01,
     order3 LIKE ooo_file.ooo01,
     order4 LIKE ooo_file.ooo01)
   #no.5196(end)   #No.FUN-680123 end
 
   IF cl_null(tm.wc)
      THEN CALL axrr510_tm(0,0)             # Input print condition
   ELSE 
      CALL axrr510()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr510_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680123 SMALLINT
       l_cmd          LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20054
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 3 LET p_col =17
   ELSE LET p_row = 5 LET p_col =15
   END IF
 
   OPEN WINDOW axrr510_w AT p_row,p_col
        WITH FORM "axr/42f/axrr510" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.s='   '
   LET tm.t='   '
   LET tm.u='   '
   LET tm.y=YEAR(TODAY)
   LET tm.b1=1
   LET tm.b2=2
   LET tm.n='1'
   LET tm.ooo11 = g_aza.aza81      #FUN-B20054
   LET tm.c='N'   #FUN-830014
WHILE TRUE
#FUN-B20054--add--str--
   DIALOG ATTRIBUTE(unbuffered)
      INPUT BY NAME tm.ooo11 ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD ooo11 
            IF NOT cl_null(tm.ooo11) THEN
                   CALL s_check_bookno(tm.ooo11,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD ooo11
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.ooo11
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.ooo11,"","agl-043","","",0)
                   NEXT FIELD ooo11
                END IF
            END IF
       END INPUT
#FUN-B20054--add--end--
   CONSTRUCT BY NAME tm.wc ON ooo01,ooo03,ooo04,ooo05
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
#FUN-B20054--mark--str--
#      ON ACTION locale
#         #CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
#  
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#FUN-B20054--mark--end--
 
  END CONSTRUCT
  #FUN-B20054--mark--str--
  #LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030  
  #FUN-B20054--mark--str-- 
#FUN-B20054--mark--str--
       #IF g_action_choice = "locale" THEN
       #   LET g_action_choice = ""
       #   CALL cl_dynamic_locale()
       #   CONTINUE WHILE
       #END IF
#       
# 
#					 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW axrr510_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
#      EXIT PROGRAM
#         
#   END IF 
#FUN-B20054--mark--end--
#FUN-B20054--mark--str--
#   IF tm.wc=" 1=1" THEN 
#      CALL cl_err('','9046',0) CONTINUE WHILE
#   END IF 
#FUN-B20054--mark--end--
   INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 #tm2.u1,tm2.u2,tm2.u3,tm.y,tm.b1,tm.b2,tm.n,tm.more   #FUN-830014
                 tm2.u1,tm2.u2,tm2.u3,tm.y,tm.b1,tm.b2,tm.n,tm.c,tm.more   #FUN-830014
                 #WITHOUT DEFAULTS                                      #FUN-B20054
                 ATTRIBUTE(WITHOUT DEFAULTS)                             #FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD y
         IF cl_null(tm.y) THEN
            NEXT FIELD y
         END IF
      AFTER FIELD b1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.b1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y
            IF g_azm.azm02 = 1 THEN
               IF tm.b1 > 12 OR tm.b1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b1
               END IF
            ELSE
               IF tm.b1 > 13 OR tm.b1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b1
               END IF
            END IF
         END IF
#         IF cl_null(tm.b1) OR tm.b1<1 OR tm.b1>13 THEN
#            NEXT FIELD b1
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD b2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.b2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.y
            IF g_azm.azm02 = 1 THEN
               IF tm.b2 > 12 OR tm.b2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b2
               END IF
            ELSE
               IF tm.b2 > 13 OR tm.b2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD b2
               END IF
            END IF
         END IF
#         IF cl_null(tm.b2) OR tm.b2<tm.b1 OR tm.b2 >13 THEN
#            NEXT FIELD b2
#         END IF
#No.TQC-720032 -- end --
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[12]' THEN
            NEXT FIELD n
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 #FUN-B20054--mark--str--
#################################################################################
## START genero shell script ADD
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
## END genero shell script ADD
#################################################################################
#      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution   
 #FUN-B20054--mark--end--
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
      #FUN-B20054--mark--str--
      #ON IDLE g_idle_seconds
      #   CALL cl_on_idle()
      #   CONTINUE INPUT
      #
      #ON ACTION about         #MOD-4C0121
      #   CALL cl_about()      #MOD-4C0121
      #
      #ON ACTION help          #MOD-4C0121
      #   CALL cl_show_help()  #MOD-4C0121
      #
      #
      #    ON ACTION exit
      #    LET INT_FLAG = 1
      #    EXIT INPUT
      #   #No.FUN-580031 --start--
      #   ON ACTION qbe_save
      #      CALL cl_qbe_save()
      #   #No.FUN-580031 ---end---    
       #FUN-B20054--mark--end--
 
   END INPUT
   #FUN-B20054--add--str--
      ON ACTION CONTROLP
          CASE  
             WHEN INFIELD(ooo11)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa3'
                LET g_qryparam.default1 = tm.ooo11
                CALL cl_create_qry() RETURNING tm.ooo11
                DISPLAY tm.ooo11 TO FORMONLY.ooo11
                NEXT FIELD ooo11
             WHEN INFIELD(ooo03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag02"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.ooo11 CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ooo03
                NEXT FIELD ooo03
             #No.FUN-C40001  --Begin
              WHEN INFIELD(ooo01) #客戶編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo01
                 NEXT FIELD ooo01
              WHEN INFIELD(ooo04) #部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo04
                 NEXT FIELD ooo04
              WHEN INFIELD(ooo05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooo05
                 NEXT FIELD ooo05
             #No.FUN-C40001  --End
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
    #FUN-B20054--add--end

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr510_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
  
   IF g_bgjob = 'Y' THEN 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null)              #FUN-B20054
   IF tm.wc=" 1=1" THEN                                                 #FUN-B20054
         CALL cl_err('','9046',0) CONTINUE WHILE   #FUN-B20054
   END IF                                                               #FUN-B20054
                                       
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr510'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr510','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'"  ,   #TQC-610059
                         " '",tm.t CLIPPED,"'"  ,   #TQC-610059
                         " '",tm.u CLIPPED,"'"  ,   #TQC-610059
                         " '",tm.y CLIPPED,"'" ,
                         " '",tm.b1 CLIPPED,"'" ,
                         " '",tm.b2 CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,   #FUN-830014
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr510',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr510()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr510_w
END FUNCTION
 
FUNCTION axrr510()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680123  VARCHAR(20)     # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ooo_file.ooo02,  #No.FUN-680123 VARCHAR(20)
          sr        RECORD        
		order1	  LIKE ooo_file.ooo01,        #No.FUN-680123 VARCHAR(10)
		order2	  LIKE ooo_file.ooo01,        #No.FUN-680123 VARCHAR(10)
	        order3	  LIKE ooo_file.ooo01,        #No.FUN-680123 VARCHAR(10)
		order4	  LIKE ooo_file.ooo01,        #No.FUN-680123 VARCHAR(10)
		ooo01     LIKE ooo_file.ooo01,			#客戶編號
		ooo02     LIKE ooo_file.ooo02,			#客戶簡稱
                ooo03     LIKE ooo_file.ooo03,			#科目編號
                aag02     LIKE aag_file.aag02,			#科目名稱
		ooo04	  LIKE ooo_file.ooo04,			#部門
	        gem02	  LIKE gem_file.gem02,			#部門名稱
                ooo05	  LIKE ooo_file.ooo05,			#幣別
                amt1      LIKE ooo_file.ooo08d,			#前期
                amt2      LIKE ooo_file.ooo08c,			#本期借(D)
	        amt3      LIKE ooo_file.ooo09d,			#本期貸(D)
		amt4      LIKE ooo_file.ooo09d,			#期末
		azi03	  LIKE azi_file.azi03,			#
		azi04	  LIKE azi_file.azi04,			#
		azi05	  LIKE azi_file.azi05			#
                    END RECORD,
		a1		LIKE ooo_file.ooo08c,
		a2		LIKE ooo_file.ooo08d,
		a3		LIKE ooo_file.ooo09c 
  DEFINE l_bb   LIKE type_file.chr5    #TQC-750226 起迄期別
 
     #MOD-720047 - START 
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #MOD-720047 - END
  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720047 add
 
     #no.5196
     DELETE FROM curr_tmp;
 
     LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
               "   FROM curr_tmp ",
               "  WHERE order1=? ",
               "  GROUP BY curr  "
     PREPARE r510_prepare_1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare_1:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE curr_temp1 CURSOR FOR r510_prepare_1
 
     LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
               "   FROM curr_tmp ",
               "  WHERE order1=? ",
               "    AND order2=? ",
               "  GROUP BY curr  "
     PREPARE r510_prepare_2 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare_2:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE curr_temp2 CURSOR FOR r510_prepare_2
    
     LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
               "   FROM curr_tmp ",
               "  WHERE order1=? ",
               "    AND order2=? ",
               "    AND order3=? ",
               "  GROUP BY curr  "
     PREPARE r510_prepare_3 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare_3:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE curr_temp3 CURSOR FOR r510_prepare_3
 
     LET l_sql=" SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) ",
               "   FROM curr_tmp ",
               "  WHERE order1=? ",
               "    AND order2=? ",
               "    AND order3=? ",
               "    AND order4=? ",
               "  GROUP BY curr  "
     PREPARE r510_prepare_4 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare_4:',SQLCA.sqlcode,1) RETURN
     END IF
     DECLARE curr_temp4 CURSOR FOR r510_prepare_4
 
 
     #no.5196
     LET l_sql="SELECT DISTINCT '','','','',ooo01,ooo02,ooo03,aag02, ",
			   " ooo04,gem02,ooo05,0,0,0,0,",
			   "azi03,azi04,azi05 ",
               " FROM ooo_file,OUTER gem_file,OUTER aag_file,OUTER azi_file",  #No.TQC-780056
               " WHERE ooo_file.ooo04=gem_file.gem01 AND ooo_file.ooo03=aag_file.aag01 ",  #No.TQC-780056
                           " AND aag00=ooo11 ",       #FUN-740009
			   " AND ooo_file.ooo05=azi_file.azi01 AND ",tm.wc CLIPPED,  #No.TQC-780056
			   " AND ooo06 =",tm.y," AND ooo07 <= ",tm.b2
	 LET l_sql= l_sql CLIPPED 
     PREPARE axrr510_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM 
     END IF
     DECLARE axrr510_curs1 CURSOR FOR axrr510_prepare1
 
     LET g_pageno = 0
     FOREACH axrr510_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          EXIT FOREACH 
       END IF
       SELECT SUM(ooo08d-ooo08c),SUM(ooo09d-ooo09c) INTO sr.amt1, a1
               FROM ooo_file
              WHERE ooo01=sr.ooo01 AND ooo02=sr.ooo02
                AND ooo03=sr.ooo03 AND ooo04=sr.ooo04
                AND ooo05=sr.ooo05
                AND ooo06=tm.y AND ooo07<tm.b1
       SELECT SUM(ooo08d),SUM(ooo08c),SUM(ooo09d),SUM(ooo09c)
               INTO sr.amt2,sr.amt3, a2,a3
               FROM ooo_file
              WHERE ooo01=sr.ooo01 AND ooo02=sr.ooo02
                AND ooo03=sr.ooo03 AND ooo04=sr.ooo04
                AND ooo05=sr.ooo05
                AND ooo06=tm.y AND ooo07 BETWEEN tm.b1 AND tm.b2
       IF tm.n = '2' THEN
          LET sr.amt1=a1 LET sr.amt2=a2 LET sr.amt3=a3
          LET sr.ooo05=g_aza.aza17
          LET t_azi03=g_azi03
          LET t_azi04=g_azi04
          LET t_azi05=g_azi05
       END IF
       IF sr.amt1 IS NULL THEN LET sr.amt1=0 END IF
       IF sr.amt2 IS NULL THEN LET sr.amt2=0 END IF
       IF sr.amt3 IS NULL THEN LET sr.amt3=0 END IF
       LET sr.amt4 = sr.amt1 + sr.amt2 - sr.amt3
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.ooo01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ooo03
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.ooo04
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
        
       #no.5196
       INSERT INTO curr_tmp VALUES(sr.ooo05,sr.amt1,sr.amt2,sr.amt3,sr.amt4,sr.order1,sr.order2,sr.order3,sr.order4)
       #no.5196(end)
       IF cl_null(sr.order1) THEN LET sr.order1 = ' ' END IF
       IF cl_null(sr.order2) THEN LET sr.order2 = ' ' END IF
       IF cl_null(sr.order3) THEN LET sr.order3 = ' ' END IF
 
       LET l_bb = tm.b1 USING "&&","-",tm.b2 USING "&&"   #TQC-750226
       #MOD-720047 - START 
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       #-----FUN-830014---------
       IF tm.c = 'N' THEN
          IF (sr.amt1=0 OR cl_null(sr.amt1)) AND 
             (sr.amt2=0 OR cl_null(sr.amt2)) AND 
             (sr.amt3=0 OR cl_null(sr.amt3)) AND 
             (sr.amt4=0 OR cl_null(sr.amt4)) THEN
             CONTINUE FOREACH
          END IF 
       END IF
       #-----END FUN-830014-----
       EXECUTE insert_prep USING sr.ooo01, sr.ooo02, sr.ooo03,
                                 sr.aag02, sr.ooo04, sr.gem02,sr.ooo05,
                                 sr.amt1 , sr.amt2 , sr.amt3 ,sr.amt4,
                                 sr.azi03, sr.azi04, sr.azi05,tm.y,l_bb  #TQC-750226 add 年度 & 期別
       IF STATUS THEN DISPLAY "Error" END IF
       #------------------------------ CR (3) ------------------------------#
       #MOD-720047 - END 
    END FOREACH
 
    #MOD-720047 - START 
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    LET g_str = ''
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'ooo01,ooo03,ooo04,ooo05,ooo11')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
                          tm.t,";",tm.u
    CALL cl_prt_cs3('axrr510','axrr510',l_sql,g_str)   #FUN-710080 modify
    #------------------------------ CR (4) ------------------------------#
    #MOD-720047 - END 
END FUNCTION
