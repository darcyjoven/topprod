# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axrq710.4gl
# Descriptions...: 客戶業務明細帳列印
# Date & Author..: No.FUN-850030 08/05/27 By Carrier 報表查詢化 copy from axrr711
# Modify.........: No.FUN-850030 08/07/28 By dxfwo   新增程序從21區移植到31區
# Modify.........: No.TQC-8B0035 08/11/18 By wujie   sql里加上npr08是null或者空格的條件 
# Modify.........: No.MOD-910048 09/01/13 By wujie 匯率計算反了
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-8C0010 09/05/31 By Cockroach CR_PRINT  GP5.1-->GP5.2
# Modify.........: No.TQC-980115 09/08/18 By liuxqa 修正余額為空的錯誤。
# Modify.........: No.TQC-980134 09/08/19 By liuxqa 修正余額值不正確的問題。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980119 09/09/01 By xiaofeizhu	增加“按幣別分頁”
# Modify.........: No.FUN-9C0072 10/01/06 By vealxu 精簡程式碼
# Modify.........: No:FUN-A40009 10/04/07 By wujie 查询界面点退出回到主画面，而不是关闭程序
#                                                  点击单据联查按钮后，光标保持在原来所在的行，而不是回到第一行
# Modify.........: No:MOD-A30002 10/04/08 By wujie  增加抓取NM的资料
# Modify.........: No.FUN-B20054 10/02/24 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B60247 11/06/29 By wujie q710_oma()增加NM的处理
# Modify.........: No:MOD-BC0252 11/12/26 By Carrier 加入 'FA'
# Modify.........: No:MOD-C10034 12/01/05 By Carrier 调整'FA'的类型为npp00='4',仅限出售类型
# Modify.........: No:MOD-C30003 12/03/01 By yinhy 點擊“查詢賬款”出現axrt400畫面，無法串查到axrt410退款衝賬單作業
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD                                # Print condition RECORD
	   	  wc      LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000) # Where condition
		  bdate   LIKE type_file.dat,           #No.FUN-680123 DATE
		  edate   LIKE type_file.dat,           #No.FUN-680123 DATE
                  o       LIKE aaa_file.aaa01,          #No.FUN-670039
                  b       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
                  c       LIKE type_file.chr1,          #FUN-980119 
                  d       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
                  e       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
	  	  more    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01) # Input more condition(Y/N)
                  END RECORD,
       g_d                LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
       g_print            LIKE type_file.num5,          #No.FUN-680123 SMALLINT
       g_aaa03            LIKE aaa_file.aaa03,
       g_aza17            LIKE aza_file.aza17,
       g_azi01            LIKE aza_file.aza17,
       g_qcyef            LIKE npq_file.npq07,
       g_qcye             LIKE npq_file.npq07,
       g_npq07f_l         LIKE npq_file.npq07,
       g_npq07f_r         LIKE npq_file.npq07,
       g_npq07_l          LIKE npq_file.npq07,
       g_npq07_r          LIKE npq_file.npq07
 
DEFINE   g_i              LIKE type_file.num5           #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   g_sql            STRING                        #NO.FUN-7B0026
DEFINE   g_str            STRING                        #NO.FUN-7B0026
DEFINE   l_table          STRING                        #NO.FUN-7B0026
 
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_npq03    LIKE npq_file.npq03
DEFINE   g_aag02    LIKE aag_file.aag02
DEFINE   g_npq21    LIKE npq_file.npq21
DEFINE   g_npq22    LIKE npq_file.npq22
DEFINE   g_npq24    LIKE npq_file.npq24                 #FUN-980119
DEFINE   g_mm       LIKE type_file.num5
DEFINE   mm1,nn1    LIKE type_file.num10
DEFINE   yy         LIKE type_file.num10
DEFINE   g_cnt      LIKE type_file.num10
DEFINE   g_npq      DYNAMIC ARRAY OF RECORD
                    npp02      LIKE npp_file.npp02,
                    npp01      LIKE npp_file.npp01,
                    npp00      LIKE npp_file.npp00,
                    nppsys     LIKE npp_file.nppsys,
                    nppglno    LIKE npp_file.nppglno,
                    npq24      LIKE npq_file.npq24,
                    df         LIKE npq_file.npq07,
                    npq25_d    LIKE npq_file.npq25,
                    d          LIKE npq_file.npq07,
                    cf         LIKE npq_file.npq07,
                    npq25_c    LIKE npq_file.npq25,
                    c          LIKE npq_file.npq07,
                    dc         LIKE type_file.chr10,
                    balf       LIKE npq_file.npq07,
                    npq25_bal  LIKE npq_file.npq25,
                    bal        LIKE npq_file.npq07
                    END RECORD
DEFINE   g_pr       RECORD
                    npq21      LIKE npq_file.npq21,
                    npq22      LIKE npq_file.npq22,
                    npq03      LIKE npq_file.npq03,
                    aag02      LIKE aag_file.aag02,
                    mm         LIKE type_file.num5,
                    type       LIKE type_file.chr1,
                    npp02      LIKE npp_file.npp02,
                    npp01      LIKE npp_file.npp01,
                    nppglno    LIKE npp_file.nppglno,
                    npq24      LIKE npq_file.npq24,
                    npq06      LIKE npq_file.npq06,
                    npq07      LIKE npq_file.npq07,
                    npq07f     LIKE npq_file.npq07f,
                    df         LIKE npq_file.npq07,
                    npq25_d    LIKE npq_file.npq25,
                    d          LIKE npq_file.npq07,
                    cf         LIKE npq_file.npq07,
                    npq25_c    LIKE npq_file.npq25,
                    c          LIKE npq_file.npq07,
                    dc         LIKE type_file.chr10,
                    balf       LIKE npq_file.npq07,
                    npq25_bal  LIKE npq_file.npq25,
                    bal        LIKE npq_file.npq07,
                    pagenum    LIKE type_file.num5,
                    azi04      LIKE azi_file.azi04,
                    azi05      LIKE azi_file.azi05,
                    azi07      LIKE azi_file.azi07
                    END RECORD
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   l_ac           LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680126  SMALLINT
 
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
   INITIALIZE tm.* TO NULL            # Default condition
 
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_azi01 FROM aaa_file WHERE aaa01 = g_ooz.ooz02b
   IF SQLCA.sqlcode THEN LET g_azi01 = g_aza.aza17 END IF     #使用本國幣別
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.o = ARG_VAL(10)
   LET tm.b = ARG_VAL(11)
   LET tm.c = ARG_VAL(12)         #FUN-980119
   LET tm.d = ARG_VAL(13)
   LET tm.e = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
 
   CALL q710_out_1()
 
   OPEN WINDOW q710_w AT 5,10
        WITH FORM "axr/42f/axrq710_1" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   IF cl_null(tm.wc) THEN
       CALL axrq710_tm(0,0)             # Input print condition
   ELSE
       IF tm.c = 'N' THEN
          CALL axrq710()
       ELSE
          CALL axrq710_1()
       END IF
       CALL axrq710_t()
   END IF
 
   CALL q710_menu()
   DROP TABLE axrq710_tmp;
   CLOSE WINDOW q710_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION q710_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(500)
 
   WHILE TRUE
      CALL q710_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL axrq710_tm(0,0)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q710_out_2()
            END IF
         WHEN "query_account"
            IF cl_chk_act_auth() THEN
               CALL q710_q_a()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_npq),'','')
            END IF
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_npq21 IS NOT NULL THEN
                  LET g_doc.column1 = "npq21"
                  LET g_doc.value1 = g_npq21
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION axrq710_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          l_n            LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          l_flag         LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
   DEFINE li_chk_bookno  LIKE type_file.num5          #No.FUN-680123 SMALLINT  #No.FUN-670006
 
   LET p_row = 4 LET p_col = 13
 
   OPEN WINDOW axrq710_w1 AT p_row,p_col WITH FORM "axr/42f/axrq710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axrq710")
 
   CALL cl_opmsg('p')
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.o = g_ooz.ooz02b
   LET tm.b = 'N'
   LET tm.c = 'N'                     #FUN-980119
   LET tm.d = '1'
   LET tm.e = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   DISPLAY BY NAME tm.bdate,tm.edate,tm.o,tm.b,tm.c,tm.d,tm.e,tm.more     #FUN-980119 Add tm.c
WHILE TRUE
   #FUN-B20054--add--start--
    DIALOG ATTRIBUTE(unbuffered)
       INPUT BY NAME tm.o ATTRIBUTE(WITHOUT DEFAULTS)
          AFTER FIELD o
            IF NOT cl_null(tm.o) THEN
                   CALL s_check_bookno(tm.o,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD o
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.o
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",tm.o,"","agl-043","","",0)
                   NEXT FIELD o
                END IF
            END IF
       END INPUT
     #FUN-B20054--add--end--

   CONSTRUCT BY NAME tm.wc ON npq21,npp01,npq03
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
#No.FUN-B20054--mark--start-- 
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(npq03)     #科目代號
#               CALL cl_init_qry_var()
#	       LET g_qryparam.state = 'c'
#               LET g_qryparam.form = 'q_aag'
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO npq03
#               NEXT FIELD npq03
#         END CASE
# 
#      ON ACTION locale
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"
#         EXIT CONSTRUCT
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE CONSTRUCT
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
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT CONSTRUCT
# 
#      ON ACTION qbe_select
#         CALL cl_qbe_select()
#No.FUN-B20054--mark--end-- 
   END CONSTRUCT
#No.FUN-B20054--mark--start--
#   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
# 
#   IF g_action_choice = "locale" THEN
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE
#   END IF
# 
#   IF INT_FLAG THEN
##No.FUN-A40009 --begin
##     LET INT_FLAG = 0 CLOSE WINDOW axrq710_w1
##     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
##     EXIT PROGRAM
##  END IF
#   ELSE
##No.FUN-A40009 --end
#   IF tm.wc = ' 1=1' THEN
#      CALL cl_err('','9046',0) CONTINUE WHILE
#   END IF
# 
#   INPUT BY NAME tm.bdate,tm.edate,tm.o,tm.b,tm.c,tm.d,tm.e,tm.more                  #FUN-980119 Add tm.c
#                 WITHOUT DEFAULTS
#No.FUN-B20054--mark--end--
    INPUT BY NAME tm.bdate,tm.edate,tm.b,tm.c,tm.d,tm.e,tm.more   ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN
           CALL cl_err('','mfg0037',0) NEXT FIELD bdate
        END IF
 
      AFTER FIELD edate
        IF cl_null(tm.edate) THEN
           CALL cl_err('','mfg0037',0) NEXT FIELD edate
        END IF
        IF YEAR(tm.bdate) <> YEAR(tm.edate) THEN
           CALL cl_err('','gxr-001',0) NEXT FIELD bdate
        END IF
        IF tm.bdate > tm.edate THEN
           CALL cl_err(tm.edate,'aap-100',0) NEXT FIELD bdate
        END IF
#No.FUN-B20054--mark--start-- 
#      AFTER FIELD o
#        LET l_flag = 1
#        IF cl_null(tm.o) THEN
#           CALL cl_err('','mfg0037',0) NEXT FIELD o
#        END IF
#        CALL s_check_bookno(tm.o,g_user,g_plant)
#             RETURNING li_chk_bookno
#        IF (NOT li_chk_bookno) THEN
#           NEXT FIELD o
#        END IF
#        SELECT * FROM aaa_file WHERE aaa01 = tm.o
#        IF SQLCA.sqlcode THEN
#           CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116
#           NEXT FIELD o
#        END IF
#        SELECT aaa03 INTO g_azi01 FROM aaa_file WHERE aaa01 = tm.o
#        IF SQLCA.sqlcode THEN LET g_azi01 = g_aza.aza17 END IF   #使用本國幣別
#No.FUN-B20054--mark--end--        
        ON CHANGE b
           IF tm.b = 'N' THEN 
              LET tm.c = 'N' 
              DISPLAY tm.c TO c
           END IF
 
        ON CHANGE c
           IF tm.c = 'Y' THEN 
              LET tm.b = 'Y' 
              DISPLAY tm.b TO b
           END IF
 
      AFTER FIELD d
        IF cl_null(tm.d) OR tm.d NOT MATCHES '[123]' THEN NEXT FIELD d END IF
 
      AFTER FIELD e
        IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN NEXT FIELD e END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
#No.FUN-B20054--mark--start-- 
#      ON ACTION CONTROLZ
#         CALL cl_show_req_fields()
# 
#      ON ACTION CONTROLG
#         CALL cl_cmdask()    # Command execution
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
# 
#      ON ACTION qbe_save
#         CALL cl_qbe_save()
#No.FUN-B20054--mark--end-- 
   END INPUT
#No.FUN-B20054--add--start--

      ON ACTION CONTROLP
          CASE
             WHEN INFIELD(o)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa3'
                LET g_qryparam.default1 = tm.o
                CALL cl_create_qry() RETURNING tm.o
                DISPLAY tm.o TO FORMONLY.o
                NEXT FIELD o
            WHEN INFIELD(npq03)     #科目代號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = 'q_aag'
               LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO npq03
               NEXT FIELD npq03
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
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null)
    IF INT_FLAG THEN
    ELSE
       IF tm.wc = ' 1=1' THEN
          CALL cl_err('','9046',0)
          CONTINUE WHILE
       END IF
    END IF
#No.FUN-B20054--add--end--

#No.FUN-A40009 --begin
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0 CLOSE WINDOW axrq710_w1
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
#     EXIT PROGRAM
#  END IF
#No.FUN-A40009 --end
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrq710'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrq710','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.o     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",tm.c     CLIPPED,"'",             #FUN-980119
                         " '",tm.d     CLIPPED,"'",
                         " '",tm.e     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrq710',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrq710_w1
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF                 #No.FUN-A40009
   CALL cl_wait()
   IF tm.c = 'N' THEN
      CALL axrq710()
   ELSE
      CALL axrq710_1()
   END IF
   ERROR ""
   EXIT WHILE
END WHILE
   CLOSE WINDOW axrq710_w1
#No.FUN-A40009 --begin  
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF           
#No.FUN-A40009 --end 
 
   CALL axrq710_t()
END FUNCTION
 
 
FUNCTION axrq710()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20) # External(Disk) file name
          l_term    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(300)
          l_sql     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          l_npp01   LIKE npp_file.npp01,
          l_oma09   LIKE oma_file.oma09,
          l_oma10   LIKE oma_file.oma10,
          l_dcf     LIKE npr_file.npr06f,
          l_dc      LIKE npr_file.npr06,
          l_npr06f  LIKE npr_file.npr06f,
          l_npr06  LIKE npr_file.npr06,
          l_npr07f  LIKE npr_file.npr06f,
          l_npr07  LIKE npr_file.npr06,
          d_npq07f  LIKE npq_file.npq07f,
          d_npq07   LIKE npq_file.npq07f,
          c_npq07f  LIKE npq_file.npq07f,
          c_npq07   LIKE npq_file.npq07f,
          m_npq07   LIKE npq_file.npq07f,
          m_npq07f  LIKE npq_file.npq07f,
          l_npq07   LIKE npq_file.npq07f,
          l_npq07f  LIKE npq_file.npq07f,
          l_qcye    LIKE npq_file.npq07,
          l_qcyef   LIKE npq_file.npq07,
          t_qcye    LIKE npq_file.npq07,
          t_qcyef   LIKE npq_file.npq07,
          l_flag    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
          l_flag1   LIKE type_file.chr1,          #No.TQC-980134 add
          l_flag4   LIKE type_file.chr1,          #No.TQC-980134 add
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
          l_i       LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          t_bal,t_balf                 LIKE npq_file.npq07,
          y_debit,y_debitf             LIKE npq_file.npq07,
          y_credit,y_creditf           LIKE npq_file.npq07,
          p_debit,p_debitf             LIKE npq_file.npq07,
          p_credit,p_creditf           LIKE npq_file.npq07,
          l_d,l_df,l_c,l_cf            LIKE npq_file.npq07,
          y_d,y_df,y_c,y_cf            LIKE npq_file.npq07,
	  n_bal,n_balf                 LIKE type_file.num20_6,
          l_npq25_c,l_npq25_d,l_npq25_bal LIKE npq_file.npq25,
          l_date                       LIKE type_file.dat,
          l_date1                      LIKE type_file.dat,
          l_date2                      LIKE type_file.dat,
          t_dc                         LIKE type_file.chr10,
          l_year                       LIKE type_file.num10,
          l_month                      LIKE type_file.num10,          
          sr1       RECORD
                    npq21    LIKE npq_file.npq21,
                    npq22    LIKE npq_file.npq22,
                    npq03    LIKE npq_file.npq03
                    END RECORD,
          sr        RECORD
                    npp01    LIKE npp_file.npp01,
                    npp00    LIKE npp_file.npp00,
                    nppsys   LIKE npp_file.nppsys,
                    npp02    LIKE npp_file.npp02,
                    nppglno  LIKE npp_file.nppglno,
                    npq03    LIKE npq_file.npq03,
                    aag02    LIKE aag_file.aag02,
                    mm       LIKE type_file.num5,
                    npq06    LIKE npq_file.npq06,
                    npq07f   LIKE npq_file.npq07f,
                    npq07    LIKE npq_file.npq07,
                    npq21    LIKE npq_file.npq21,
                    npq22    LIKE occ_file.occ18,
                    npq24    LIKE npq_file.npq24,
                    oma09    LIKE oma_file.oma09,
                    oma10    LIKE oma_file.oma10,
                    qcyef    LIKE npq_file.npq07,  #qcye
                    qcye     LIKE npq_file.npq07,
                    df_p     LIKE npq_file.npq07,  #debit of current period(day1 ~ bdate-1)
                    d_p      LIKE npq_file.npq07,
                    cf_p     LIKE npq_file.npq07,
                    c_p      LIKE npq_file.npq07,
                    df_y     LIKE npq_file.npq07,  #debit of current year(1~bdate-1)
                    d_y      LIKE npq_file.npq07,
                    cf_y     LIKE npq_file.npq07,
                    c_y      LIKE npq_file.npq07
                    END RECORD
 
    LET g_prog = 'axrr710'
    CALL axrq710_table()
    LET l_flag1 = 'N'              #No.TQC-980134 add
    SELECT zo02 INTO g_company FROM zo_file
     WHERE zo01 = g_rlang
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axrq710'    #FUN-7B0026
 
    IF tm.d = '1' THEN
        LET g_d = 'Y'
     ELSE
        LET g_d = 'N'
     END IF
     LET mm1 = MONTH(tm.bdate)
     LET nn1 = MONTH(tm.edate)
     LET yy  = YEAR(tm.bdate)
     LET l_term= "  WHERE nppsys = npqsys AND npp00 = npq00 ",
                 "    AND npp01 = npq01 AND npp011 = npq011 ",
                 "    AND npptype = npqtype ",
#                "    AND nppsys = 'AR' AND npp011 = 1 ",
                 #No.MOD-C10034  --Begin
                #"    AND nppsys IN ('AR','NM','FA') AND npp011 = 1 ",   #No.MOD-A30002  #No.MOD-BC0252 add 'FA'
                 "    AND (nppsys IN ('AR','NM') AND npp011 = 1 OR nppsys = 'FA' AND npp00 = '4' ) ",  
                 #No.MOD-C10034  --End  
                 "    AND ",tm.wc CLIPPED
     LET l_sql = " SELECT UNIQUE npq21,npq22,npq03 ",
                 "   FROM npq_file,npp_file ",l_term CLIPPED
     PREPARE axrq710_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('axrq710_pr1',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrq710_curs1 CURSOR FOR axrq710_pr1
 
     LET l_sql1="SELECT npp01,npp00,nppsys,npp02,nppglno,npq03,aag02,0,npq06,SUM(npq07f),",
                "       SUM(npq07),npq21,npq22,npq24,'','',0,0,0,0,0,0,0,0,0,0 ",
                "  FROM npp_file,npq_file,aag_file ", l_term CLIPPED,
                "   AND npq03 = aag01 ",
                "   AND aag00 ='",tm.o,"'",   #No.FUN-730073
                "   AND npq21 = ? AND npq22 = ? ",
                "   AND npq03 = ? ",
                "   AND MONTH(npp02) = ? ",
                "   AND npp02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                " GROUP BY npp01,npp00,nppsys,npp02,nppglno,npq03,aag02,npq06,npq21,npq22,npq24 ",
                " ORDER BY npq21,npq22,npq03,npp02,npp01,npq06 "    #No.TQC-980134 mod
             
     PREPARE axrq710_prepare1 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrq710_bcurs CURSOR FOR axrq710_prepare1
 
     LET l_sql1=" SELECT npp01,SUM(npq07f),SUM(npq07) ",
                "   FROM npq_file,npp_file ",l_term CLIPPED,
                "    AND npq21 = ? AND npq22 = ? ",
                "    AND npq03 = ? AND npq06 = ?",
                "    AND YEAR(npp02) = ",YEAR(tm.bdate),
                "    AND MONTH(npp02)= ",MONTH(tm.bdate),
                "    AND npp02 < '",tm.bdate,"'",
                "  GROUP BY npp01 "
     PREPARE axrq710_prepare3 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare3:',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
 
     END IF
     DECLARE axrq710_curd CURSOR FOR axrq710_prepare3
 
      LET g_pageno = 0                                #No.FUN-8C0010 add
      
     FOREACH axrq710_curs1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH
       END IF
 
       SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07)  #前幾期的余額
         INTO l_npr06f,l_npr07f,l_npr06,l_npr07 FROM npr_file
        WHERE npr01 = sr1.npq21
          AND npr02 = sr1.npq22
          AND npr00 = sr1.npq03
          AND npr04 = YEAR(tm.bdate)
          AND npr05 < MONTH(tm.bdate)
          AND (npr08 = g_ooz.ooz02p OR npr08 IS NULL OR npr08 =' ')      #No.TQC-8B0035
          AND npr09 = tm.o
       IF cl_null(l_npr06f) THEN LET l_npr06f = 0 END IF
       IF cl_null(l_npr07f) THEN LET l_npr07f = 0 END IF
       IF cl_null(l_npr06) THEN LET l_npr06 = 0 END IF
       IF cl_null(l_npr07) THEN LET l_npr07 = 0 END IF
       LET l_dcf   = l_npr06f - l_npr07f
       LET l_dc    = l_npr06 - l_npr07
 
       LET d_npq07f = 0     LET d_npq07 = 0
       FOREACH axrq710_curd USING sr1.npq21,sr1.npq22,sr1.npq03,'1'
                             INTO l_npp01,l_npq07f,l_npq07
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH
          END IF
          CALL q710_oma(0,l_npp01) RETURNING l_flag,l_oma09,l_oma10
          IF l_flag = 'N' THEN CONTINUE FOREACH END IF
          LET d_npq07  = d_npq07  + l_npq07
          LET d_npq07f = d_npq07f + l_npq07f
       END FOREACH
       IF cl_null(d_npq07f) THEN LET d_npq07f = 0 END IF
       IF cl_null(d_npq07)  THEN LET d_npq07  = 0 END IF
 
       LET c_npq07f = 0     LET c_npq07 = 0
       FOREACH axrq710_curd USING sr1.npq21,sr1.npq22,sr1.npq03,'2'
                             INTO l_npp01,l_npq07f,l_npq07
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          CALL q710_oma(0,l_npp01) RETURNING l_flag,l_oma09,l_oma10
          IF l_flag = 'N' THEN CONTINUE FOREACH END IF
          LET c_npq07  = c_npq07  + l_npq07
          LET c_npq07f = c_npq07f + l_npq07f
       END FOREACH
       IF cl_null(c_npq07f) THEN LET c_npq07f = 0 END IF
       IF cl_null(c_npq07)  THEN LET c_npq07  = 0 END IF
 
       LET l_qcyef = l_dcf   + d_npq07f - c_npq07f
       LET l_qcye  = l_dc    + d_npq07  - c_npq07   #本幣期初余額
       LET t_qcye  = l_qcye
 
       SELECT SUM(npq07f),SUM(npq07) INTO m_npq07f,m_npq07  #當期異動
         FROM npp_file,npq_file,aag_file
        WHERE nppsys=npqsys and npp00=npq00
          AND npp01=npq01   AND npp011 = npq011
          AND npptype = npqtype
#         AND nppsys = 'AR' AND npp011 = 1
          #No.MOD-C10034  --Begin
         #AND nppsys IN ('AR','NM','FA') AND npp011 = 1    #No.MOD-A30002  #No.MOD-BC0252 add 'FA'
          AND (nppsys IN ('AR','NM') AND npp011 = 1 OR nppsys = 'FA' AND npp00 = '4')     #No.MOD-A30002  #No.MOD-BC0252 add 'FA'
          #No.MOD-C10034  --End  
          AND npq21 = sr1.npq21 AND npq22 = sr1.npq22
          AND npq03 = sr1.npq03
          AND npp02 BETWEEN tm.bdate AND tm.edate
          AND aag00 = tm.o
          AND aag01 = npq03
 
        IF cl_null(m_npq07f) THEN LET m_npq07f = 0 END IF
        IF cl_null(m_npq07)  THEN LET m_npq07  = 0 END IF
 
        IF tm.e = 'N' THEN  #期初為零且無異動不打印
           IF tm.b = 'N' AND l_qcye = 0 AND m_npq07 = 0 THEN  #本幣
              CONTINUE FOREACH
           END IF
           IF tm.b = 'Y' AND l_qcyef = 0 AND l_qcye = 0   #外幣
              AND m_npq07f = 0 AND m_npq07 = 0 THEN
                  CONTINUE FOREACH
           END IF
        END IF
 
        LET l_flag4 ='N'       #No.TQC-980134 add
        FOR l_i = mm1 TO nn1
            LET g_print = 0
            FOREACH axrq710_bcurs USING sr1.npq21,sr1.npq22,sr1.npq03,l_i INTO sr.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,0)
                 EXIT FOREACH
              END IF
              CALL q710_oma(1,sr.npp01) RETURNING l_flag,l_oma09,l_oma10
              IF l_flag = 'N' THEN CONTINUE FOREACH END IF
              LET sr.oma09 = l_oma09
              LET sr.oma10 = l_oma10
              LET sr.qcyef = l_qcyef
              LET sr.qcye  = l_qcye
              IF sr.npq06 = '1' THEN
                  LET t_qcye = t_qcye + sr.npq07
              ELSE
                  LET t_qcye = t_qcye - sr.npq07
              END IF
              LET sr.mm   = l_i
              LET sr.df_p = d_npq07f
              LET sr.d_p  = d_npq07
              LET sr.cf_p = c_npq07f
              LET sr.c_p  = c_npq07
              LET sr.df_y = l_npr06f + d_npq07f
              LET sr.d_y  = l_npr06 + d_npq07
              LET sr.cf_y = l_npr07f + c_npq07f
              LET sr.c_y  = l_npr07 + c_npq07
              SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file
               WHERE azi01=sr.npq24
    IF l_flag1 = 'N' THEN
       IF l_flag4 = 'N' THEN
         LET t_bal  = sr.qcye      #期初余額
         LET t_balf = sr.qcyef
         LET y_df   = sr.df_y + sr.df_p
         LET y_d    = sr.d_y  + sr.d_p
         LET y_cf   = sr.cf_y + sr.cf_p
         LET y_c    = sr.c_y  + sr.c_p
         LET l_flag4 = 'Y' 
       END IF
      
     IF sr.mm = MONTH(tm.bdate) THEN
        LET l_date2 = tm.bdate
     ELSE
        LET l_date2 = MDY(sr.mm,1,yy)
     END IF
 
     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
      WHERE azi01 = sr.npq24
 
     IF t_bal > 0 THEN
        LET n_bal = t_bal
        LET n_balf= t_balf
        CALL cl_getmsg('ggl-211',g_lang) RETURNING t_dc           #FUN-980119 Add
     ELSE
        IF t_bal = 0 THEN
           LET n_bal = t_bal
           LET n_balf= t_balf
           CALL cl_getmsg('ggl-210',g_lang) RETURNING t_dc        #FUN-980119 Add           
        ELSE
           LET n_bal = t_bal * -1
           LET n_balf= t_balf* -1
           CALL cl_getmsg('ggl-212',g_lang) RETURNING t_dc        #FUN-980119 Add           
        END IF
     END IF
 
     CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
     LET l_npq25_bal = n_balf / n_bal
     IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
     INSERT INTO axrq710_tmp
     VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'1',l_date2,
            '','','',g_msg,'','',0,0,0,0,0,0,0,0,t_dc,0,0,n_bal,   #FUN-980119 Add
            g_pageno,t_azi04,t_azi05,t_azi07)
     LET l_flag1 = 'Y'
    END IF
IF sr.npq07 <> 0 OR sr.npq07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.npq24
         IF cl_null(sr.npq07) THEN LET sr.npq07 = 0 END IF
         IF cl_null(sr.npq07f) THEN LET sr.npq07f = 0 END IF
         IF sr.npq06 = 1 THEN
            LET t_bal  = t_bal  + sr.npq07
            LET t_balf = t_balf + sr.npq07f
            LET y_df   = y_df   + sr.npq07f
            LET y_d    = y_d    + sr.npq07
         ELSE
            LET t_bal  = t_bal  - sr.npq07
            LET t_balf = t_balf - sr.npq07f
            LET y_cf   = y_cf   + sr.npq07f
            LET y_c    = y_c    + sr.npq07
         END IF
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING t_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING t_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING t_dc
            END IF
         END IF
         IF sr.npq06 = '1' THEN
            LET l_d  = sr.npq07
            LET l_df = sr.npq07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.npq07
            LET l_cf = sr.npq07f
         END IF
 
         #type = '1' 期初結余打印
         LET l_npq25_d = l_d / l_df
         LET l_npq25_c = l_c / l_cf
         LET l_npq25_bal = n_bal / n_balf
         IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
         IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
         IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
         INSERT INTO axrq710_tmp
         VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'2',
                sr.npp02,sr.npp01,sr.npp00,sr.nppsys,sr.nppglno,
                sr.npq24,sr.npq06,sr.npq07,sr.npq07f,
                l_df,l_npq25_d,l_d,l_cf,l_npq25_c,l_c,
                t_dc,0,0,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF
              LET g_print = g_print + 1
            END FOREACH
            IF g_print = 0 THEN   #沒有打印過
               IF t_qcye = 0 THEN CONTINUE FOR END IF
               LET sr.npp01 = ''
               LET sr.npp00 = ''
               LET sr.nppsys= ''
               LET sr.npp02 =''
               LET sr.nppglno = ''
               LET sr.npq03 = sr1.npq03
               SELECT aag02 INTO sr.aag02 FROM aag_file
                WHERE aag01 = sr1.npq03
                  AND aag00 = tm.o        #No.FUN-730073
               LET sr.npq06 = ''
               LET sr.npq07f =0
               LET sr.npq07 = 0
               LET sr.npq21 = sr1.npq21
               LET sr.npq22 = sr1.npq22
               LET sr.npq24 = ''
               LET sr.oma09 =''
               LET sr.oma10 =''
               LET sr.qcye = l_qcye
               LET sr.qcyef = l_qcyef
               LET sr.mm   = l_i
               LET sr.df_p = d_npq07f
               LET sr.d_p  = d_npq07
               LET sr.cf_p = c_npq07f
               LET sr.c_p  = c_npq07
               LET sr.df_y = l_npr06f + d_npq07f
               LET sr.d_y  = l_npr06 + d_npq07
               LET sr.cf_y = l_npr07f + c_npq07f
               LET sr.c_y  = l_npr07 + c_npq07
 
    IF l_flag1 = 'N' THEN
       IF l_flag4 = 'N' THEN
         LET t_bal  = sr.qcye      #期初余額
         LET t_balf = sr.qcyef
         LET y_df   = sr.df_y + sr.df_p
         LET y_d    = sr.d_y  + sr.d_p
         LET y_cf   = sr.cf_y + sr.cf_p
         LET y_c    = sr.c_y  + sr.c_p
         LET l_flag4 = 'Y'  
       END IF
      
     IF sr.mm = MONTH(tm.bdate) THEN
        LET l_date2 = tm.bdate
     ELSE
        LET l_date2 = MDY(sr.mm,1,yy)
     END IF
 
     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
      WHERE azi01 = sr.npq24
 
     IF t_bal > 0 THEN
        LET n_bal = t_bal
        LET n_balf= t_balf
        CALL cl_getmsg('ggl-211',g_lang) RETURNING t_dc           #FUN-980119 Add        
     ELSE
        IF t_bal = 0 THEN
           LET n_bal = t_bal
           LET n_balf= t_balf
           CALL cl_getmsg('ggl-210',g_lang) RETURNING t_dc        #FUN-980119 Add           
        ELSE
           LET n_bal = t_bal * -1
           LET n_balf= t_balf* -1
           CALL cl_getmsg('ggl-212',g_lang) RETURNING t_dc        #FUN-980119 Add           
        END IF
     END IF
 
     CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
     LET l_npq25_bal = n_balf / n_bal
     IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
     INSERT INTO axrq710_tmp
     VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'1',l_date2,
            '','','',g_msg,'','',0,0,0,0,0,0,0,0,t_dc,0,0,n_bal,   #FUN-980119 Add
            g_pageno,t_azi04,t_azi05,t_azi07)
     LET l_flag1 = 'Y'
    END IF
      IF sr.npq07 <> 0 OR sr.npq07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.npq24
         IF cl_null(sr.npq07) THEN LET sr.npq07 = 0 END IF
         IF cl_null(sr.npq07f) THEN LET sr.npq07f = 0 END IF
         IF sr.npq06 = 1 THEN
            LET t_bal  = t_bal  + sr.npq07
            LET t_balf = t_balf + sr.npq07f
            LET y_df   = y_df   + sr.npq07f
            LET y_d    = y_d    + sr.npq07
         ELSE
            LET t_bal  = t_bal  - sr.npq07
            LET t_balf = t_balf - sr.npq07f
            LET y_cf   = y_cf   + sr.npq07f
            LET y_c    = y_c    + sr.npq07
         END IF
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING t_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING t_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING t_dc
            END IF
         END IF
         IF sr.npq06 = '1' THEN
            LET l_d  = sr.npq07
            LET l_df = sr.npq07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.npq07
            LET l_cf = sr.npq07f
         END IF
 
         LET l_npq25_d = l_d / l_df
         LET l_npq25_c = l_c / l_cf
         LET l_npq25_bal = n_bal / n_balf
         IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
         IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
         IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
         INSERT INTO axrq710_tmp
         VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'2',
                sr.npp02,sr.npp01,sr.npp00,sr.nppsys,sr.nppglno,
                sr.npq24,sr.npq06,sr.npq07,sr.npq07f,
                l_df,l_npq25_d,l_d,l_cf,l_npq25_c,l_c,
                t_dc,0,0,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)
      END IF
            END IF
 
      LET sr.mm = l_i                       #No.TQC-980134 add             
      CALL s_yp(tm.edate) RETURNING l_year,l_month
      IF sr.mm = l_month THEN
         LET sr.npp02 = tm.edate
      ELSE
         CALL s_azn01(yy,sr.mm) RETURNING l_date,l_date1
         LET sr.npp02 = l_date1
      END IF
 
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.npq24
 
      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING t_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING t_dc
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING t_dc
         END IF
      END IF
 
      SELECT SUM(npq07) INTO l_d
        FROM axrq710_tmp 
       WHERE npq06 = '1'  AND npq07 IS NOT NULL 
         AND mm = sr.mm   AND npq22 = sr.npq22           #No.TQC-980134 mod 
         AND npq21 = sr.npq21 AND npq03 = sr.npq03       #No.TQC-980134 add
      SELECT SUM(npq07f) INTO l_df
        FROM axrq710_tmp 
       WHERE npq06 = '1'  AND npq07 IS NOT NULL 
         AND mm = sr.mm   AND npq22 = sr.npq22           #No.TQC-980134 add    
         AND npq21 = sr.npq21 AND npq03 = sr.npq03       #No.TQC-980134 add
      SELECT SUM(npq07) INTO l_c
        FROM axrq710_tmp 
       WHERE npq06 = '2'  AND npq07 IS NOT NULL 
         AND mm = sr.mm   AND npq22 = sr.npq22           #No.TQC-980134 add
         AND npq21 = sr.npq21 AND npq03 = sr.npq03       #No.TQC-980134 add
      SELECT SUM(npq07f) INTO l_cf
        FROM axrq710_tmp 
       WHERE npq06 = '2'  AND npq07 IS NOT NULL 
         AND mm = sr.mm   AND npq22 = sr.npq22           #No.TQC-980134 add  
         AND npq21 = sr.npq21 AND npq03 = sr.npq03       #No.TQC-980134 add
      IF cl_null(l_d)  THEN LET l_d  = 0 END IF
      IF cl_null(l_df) THEN LET l_df = 0 END IF
      IF cl_null(l_c)  THEN LET l_c  = 0 END IF
      IF cl_null(l_cf) THEN LET l_cf = 0 END IF
      IF sr.mm = mm1 THEN
         LET l_d  = l_d  + sr.d_p
         LET l_df = l_df + sr.df_p
         LET l_c  = l_c  + sr.c_p
         LET l_cf = l_cf + sr.cf_p
      END IF
      CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg
      LET l_npq25_d = l_d / l_df
      LET l_npq25_c = l_c / l_cf
      LET l_npq25_bal = n_bal / n_balf
      IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
      IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
      IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
      INSERT INTO axrq710_tmp
      VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'3',
             sr.npp02,'','','',g_msg,'',
             '',0,0,0,0,l_d,0,0,l_c,
             t_dc,0,0,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)
 
      #type = '4' 期末后的本年結余打印
      IF cl_null(y_d)  THEN LET y_d  = 0 END IF
      IF cl_null(y_df) THEN LET y_df = 0 END IF
      IF cl_null(y_c)  THEN LET y_c  = 0 END IF
      IF cl_null(y_cf) THEN LET y_cf = 0 END IF
      CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
      LET l_npq25_d = y_d / y_df
      LET l_npq25_c = y_c / y_cf
      LET l_npq25_bal = n_bal / n_balf
      IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
      IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
      IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
      INSERT INTO axrq710_tmp
      VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'4',
              sr.npp02,'','','',g_msg,'',
             '',0,0,0,0,y_d,0,0,y_c,
             t_dc,0,0,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)             
        LET l_flag1 = 'N'   #No.TQC-980134 add
        END FOR
     END FOREACH
END FUNCTION
 
FUNCTION axrq710_1()
   DEFINE l_name    LIKE type_file.chr20,       
          l_term    LIKE type_file.chr1000,       
          l_sql     LIKE type_file.chr1000,       
          l_sql1    LIKE type_file.chr1000,      
          l_npp01   LIKE npp_file.npp01,
          l_oma09   LIKE oma_file.oma09,
          l_oma10   LIKE oma_file.oma10,
          l_dcf     LIKE npr_file.npr06f,
          l_dc      LIKE npr_file.npr06,
          l_npr06f  LIKE npr_file.npr06f,
          l_npr06  LIKE npr_file.npr06,
          l_npr07f  LIKE npr_file.npr06f,
          l_npr07  LIKE npr_file.npr06,
          d_npq07f  LIKE npq_file.npq07f,
          d_npq07   LIKE npq_file.npq07f,
          c_npq07f  LIKE npq_file.npq07f,
          c_npq07   LIKE npq_file.npq07f,
          m_npq07   LIKE npq_file.npq07f,
          m_npq07f  LIKE npq_file.npq07f,
          l_npq07   LIKE npq_file.npq07f,
          l_npq07f  LIKE npq_file.npq07f,
          l_qcye    LIKE npq_file.npq07,
          l_qcyef   LIKE npq_file.npq07,
          t_qcye    LIKE npq_file.npq07,
          t_qcyef   LIKE npq_file.npq07,
          l_flag    LIKE type_file.chr1,         
          l_flag1   LIKE type_file.chr1,         
          l_flag4   LIKE type_file.chr1,         
          l_za05    LIKE type_file.chr1000,      
          l_i       LIKE type_file.num5,                 
          t_bal,t_balf                 LIKE npq_file.npq07,
          y_debit,y_debitf             LIKE npq_file.npq07,
          y_credit,y_creditf           LIKE npq_file.npq07,
          p_debit,p_debitf             LIKE npq_file.npq07,
          p_credit,p_creditf           LIKE npq_file.npq07,
          l_d,l_df,l_c,l_cf            LIKE npq_file.npq07,
          y_d,y_df,y_c,y_cf            LIKE npq_file.npq07,
	        n_bal,n_balf                 LIKE type_file.num20_6,
          l_npq25_c,l_npq25_d,l_npq25_bal LIKE npq_file.npq25,
          l_date                       LIKE type_file.dat,
          l_date1                      LIKE type_file.dat,
          l_date2                      LIKE type_file.dat,
          t_dc                         LIKE type_file.chr10,
          l_year                       LIKE type_file.num10,
          l_month                      LIKE type_file.num10,                  
          sr1       RECORD
                    npq21    LIKE npq_file.npq21,
                    npq22    LIKE npq_file.npq22,
                    npq03    LIKE npq_file.npq03,
                    npq24    LIKE npq_file.npq24                 #FUN-980119 Add
                    END RECORD,
          sr        RECORD
                    npp01    LIKE npp_file.npp01,
                    npp00    LIKE npp_file.npp00,
                    nppsys   LIKE npp_file.nppsys,
                    npp02    LIKE npp_file.npp02,
                    nppglno  LIKE npp_file.nppglno,
                    npq03    LIKE npq_file.npq03,
                    aag02    LIKE aag_file.aag02,
                    mm       LIKE type_file.num5,
                    npq06    LIKE npq_file.npq06,
                    npq07f   LIKE npq_file.npq07f,
                    npq07    LIKE npq_file.npq07,
                    npq21    LIKE npq_file.npq21,
                    npq22    LIKE occ_file.occ18,
                    npq24    LIKE npq_file.npq24,
                    oma09    LIKE oma_file.oma09,
                    oma10    LIKE oma_file.oma10,
                    qcyef    LIKE npq_file.npq07,  #qcye
                    qcye     LIKE npq_file.npq07,
                    df_p     LIKE npq_file.npq07,  #debit of current period(day1 ~ bdate-1)
                    d_p      LIKE npq_file.npq07,
                    cf_p     LIKE npq_file.npq07,
                    c_p      LIKE npq_file.npq07,
                    df_y     LIKE npq_file.npq07,  #debit of current year(1~bdate-1)
                    d_y      LIKE npq_file.npq07,
                    cf_y     LIKE npq_file.npq07,
                    c_y      LIKE npq_file.npq07
                    END RECORD
 
    LET g_prog = 'axrr710'
    CALL axrq710_table()
    LET l_flag1 = 'N'             
 
    SELECT zo02 INTO g_company FROM zo_file
     WHERE zo01 = g_rlang
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axrq710'   
 
    IF tm.d = '1' THEN
        LET g_d = 'Y'
     ELSE
        LET g_d = 'N'
     END IF
     LET mm1 = MONTH(tm.bdate)
     LET nn1 = MONTH(tm.edate)
     LET yy  = YEAR(tm.bdate)
     LET l_term= "  WHERE nppsys = npqsys AND npp00 = npq00 ",
                 "    AND npp01 = npq01 AND npp011 = npq011 ",
                 "    AND npptype = npqtype ",
#                "    AND nppsys = 'AR' AND npp011 = 1 ",
                 #No.MOD-C10034  --Begin
                #"    AND nppsys IN ('AR','NM','FA') AND npp011 = 1 ",    #No.MOD-A30002  #No.MOD-BC0252 add 'FA'
                 "    AND (nppsys IN ('AR','NM') AND npp011 = 1 OR nppsys = 'FA' AND npp00 = '4' ) ",    #No.MOD-A30002  #No.MOD-BC0252 add 'FA'
                 #No.MOD-C10034  --End  
                 "    AND ",tm.wc CLIPPED
     LET l_sql = " SELECT UNIQUE npq21,npq22,npq03,npq24 ",         #FUN-980119 Add npq24
                 "   FROM npq_file,npp_file ",l_term CLIPPED
     PREPARE axrq710_pr12 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('axrq710_pr12',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE axrq710_curs12 CURSOR FOR axrq710_pr12
 
     LET l_sql1="SELECT npp01,npp00,nppsys,npp02,nppglno,npq03,aag02,0,npq06,SUM(npq07f),",
                "       SUM(npq07),npq21,npq22,npq24,'','',0,0,0,0,0,0,0,0,0,0 ",
                "  FROM npp_file,npq_file,aag_file ", l_term CLIPPED,
                "   AND npq03 = aag01 ",
                "   AND aag00 ='",tm.o,"'",   
                "   AND npq21 = ? AND npq22 = ? ",
                "   AND npq03 = ? ",
                "   AND MONTH(npp02) = ? ",
                "   AND npq24 = ? ",                                        #FUN-980119 Add   
                "   AND npp02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                " GROUP BY npp01,npp00,nppsys,nppglno,npq03,aag02,npq06,npq21,npq22,npq24,npp02 ",  #FUN-980119 Add
                " ORDER BY npq21,npq22,npq03,npp02,npp01,npq06 "
             
     PREPARE axrq710_prepare12 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     END IF
     DECLARE axrq710_bcurs2 CURSOR FOR axrq710_prepare12
 
     LET l_sql1=" SELECT npp01,SUM(npq07f),SUM(npq07) ",
                "   FROM npq_file,npp_file ",l_term CLIPPED,
                "    AND npq21 = ? AND npq22 = ? ",
                "    AND npq03 = ? AND npq06 = ?",
                "    AND npq24 = ? ",                                        #FUN-980119 Add
                "    AND YEAR(npp02) = ",YEAR(tm.bdate),
                "    AND MONTH(npp02)= ",MONTH(tm.bdate),
                "    AND npp02 < '",tm.bdate,"'",
                "  GROUP BY npp01 "
     PREPARE axrq710_prepare32 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare3:',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
 
     END IF
     DECLARE axrq710_curd2 CURSOR FOR axrq710_prepare32
      
     FOREACH axrq710_curs12 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH
       END IF
 
       SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07)  #前幾期的余額
         INTO l_npr06f,l_npr07f,l_npr06,l_npr07 FROM npr_file
        WHERE npr01 = sr1.npq21
          AND npr02 = sr1.npq22
          AND npr00 = sr1.npq03
          AND npr04 = YEAR(tm.bdate)
          AND npr05 < MONTH(tm.bdate)
          AND npr11 = sr1.npq24                                           #FUN-980119 Add
          AND (npr08 = g_ooz.ooz02p OR npr08 IS NULL OR npr08 =' ')     
          AND npr09 = tm.o
       IF cl_null(l_npr06f) THEN LET l_npr06f = 0 END IF
       IF cl_null(l_npr07f) THEN LET l_npr07f = 0 END IF
       IF cl_null(l_npr06) THEN LET l_npr06 = 0 END IF
       IF cl_null(l_npr07) THEN LET l_npr07 = 0 END IF
       LET l_dcf   = l_npr06f - l_npr07f
       LET l_dc    = l_npr06 - l_npr07
 
       LET d_npq07f = 0     LET d_npq07 = 0
       FOREACH axrq710_curd2 USING sr1.npq21,sr1.npq22,sr1.npq03,'1',sr1.npq24     #FUN-980119 Add npq24
                             INTO l_npp01,l_npq07f,l_npq07
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH
          END IF
          CALL q710_oma(0,l_npp01) RETURNING l_flag,l_oma09,l_oma10
          IF l_flag = 'N' THEN CONTINUE FOREACH END IF
          LET d_npq07  = d_npq07  + l_npq07
          LET d_npq07f = d_npq07f + l_npq07f
       END FOREACH
       IF cl_null(d_npq07f) THEN LET d_npq07f = 0 END IF
       IF cl_null(d_npq07)  THEN LET d_npq07  = 0 END IF
 
       LET c_npq07f = 0     LET c_npq07 = 0
       FOREACH axrq710_curd2 USING sr1.npq21,sr1.npq22,sr1.npq03,'2',sr1.npq24     #FUN-980119 Add npq24
                             INTO l_npp01,l_npq07f,l_npq07
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          CALL q710_oma(0,l_npp01) RETURNING l_flag,l_oma09,l_oma10
          IF l_flag = 'N' THEN CONTINUE FOREACH END IF
          LET c_npq07  = c_npq07  + l_npq07
          LET c_npq07f = c_npq07f + l_npq07f
       END FOREACH
       IF cl_null(c_npq07f) THEN LET c_npq07f = 0 END IF
       IF cl_null(c_npq07)  THEN LET c_npq07  = 0 END IF
 
       LET l_qcyef = l_dcf   + d_npq07f - c_npq07f
       LET l_qcye  = l_dc    + d_npq07  - c_npq07   #本幣期初余額
       LET t_qcye  = l_qcye
 
       SELECT SUM(npq07f),SUM(npq07) INTO m_npq07f,m_npq07  #當期異動
         FROM npp_file,npq_file,aag_file
        WHERE nppsys=npqsys and npp00=npq00
          AND npp01=npq01   AND npp011 = npq011
          AND npptype = npqtype
#         AND nppsys = 'AR' AND npp011 = 1
          #No.C10034  --Begin
         #AND nppsys IN ('AR','NM','FA') AND npp011 = 1    #No.MOD-A30002  #No.MOD-BC0252 add 'FA'
          AND (nppsys IN ('AR','NM') AND npp011 = 1 OR nppsys = 'FA' AND npp00 = '4')    #No.MOD-A30002  #No.MOD-BC0252 add 'FA'
          #No.C10034  --End  
          AND npq21 = sr1.npq21 AND npq22 = sr1.npq22
          AND npq03 = sr1.npq03
          AND npq24 = sr1.npq24                                  #FUN-980119 Add
          AND npp02 BETWEEN tm.bdate AND tm.edate
          AND aag00 = tm.o
          AND aag01 = npq03
 
        IF cl_null(m_npq07f) THEN LET m_npq07f = 0 END IF
        IF cl_null(m_npq07)  THEN LET m_npq07  = 0 END IF
 
        IF tm.e = 'N' THEN  #期初為零且無異動不打印
           IF tm.b = 'N' AND l_qcye = 0 AND m_npq07 = 0 THEN  #本幣
              CONTINUE FOREACH
           END IF
           IF tm.b = 'Y' AND l_qcyef = 0 AND l_qcye = 0   #外幣
              AND m_npq07f = 0 AND m_npq07 = 0 THEN
                  CONTINUE FOREACH
           END IF
        END IF
 
        LET l_flag4 ='N'      
        FOR l_i = mm1 TO nn1
            LET g_print = 0
            FOREACH axrq710_bcurs2 USING sr1.npq21,sr1.npq22,sr1.npq03,l_i,sr1.npq24 INTO sr.*   #FUN-980119 Add npq24
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,0)
                 EXIT FOREACH
              END IF
              CALL q710_oma(1,sr.npp01) RETURNING l_flag,l_oma09,l_oma10
              IF l_flag = 'N' THEN CONTINUE FOREACH END IF
              LET sr.oma09 = l_oma09
              LET sr.oma10 = l_oma10
              LET sr.qcyef = l_qcyef
              LET sr.qcye  = l_qcye
              IF sr.npq06 = '1' THEN
                  LET t_qcye = t_qcye + sr.npq07
              ELSE
                  LET t_qcye = t_qcye - sr.npq07
              END IF
              LET sr.mm   = l_i
              LET sr.df_p = d_npq07f
              LET sr.d_p  = d_npq07
              LET sr.cf_p = c_npq07f
              LET sr.c_p  = c_npq07
              LET sr.df_y = l_npr06f + d_npq07f
              LET sr.d_y  = l_npr06 + d_npq07
              LET sr.cf_y = l_npr07f + c_npq07f
              LET sr.c_y  = l_npr07 + c_npq07
              SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file
               WHERE azi01=sr.npq24
 
    IF l_flag1 = 'N' THEN
       IF l_flag4 = 'N' THEN
         LET t_bal  = sr.qcye      #期初余額
         LET t_balf = sr.qcyef
         LET y_df   = sr.df_y + sr.df_p
         LET y_d    = sr.d_y  + sr.d_p
         LET y_cf   = sr.cf_y + sr.cf_p
         LET y_c    = sr.c_y  + sr.c_p
         LET l_flag4 = 'Y' 
       END IF
      
     IF sr.mm = MONTH(tm.bdate) THEN
        LET l_date2 = tm.bdate
     ELSE
        LET l_date2 = MDY(sr.mm,1,yy)
     END IF
 
     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
      WHERE azi01 = sr.npq24
 
     IF t_bal > 0 THEN
        LET n_bal = t_bal
        LET n_balf= t_balf
        CALL cl_getmsg('ggl-211',g_lang) RETURNING t_dc           
     ELSE
        IF t_bal = 0 THEN
           LET n_bal = t_bal
           LET n_balf= t_balf
           CALL cl_getmsg('ggl-210',g_lang) RETURNING t_dc                
        ELSE
           LET n_bal = t_bal * -1
           LET n_balf= t_balf* -1
           CALL cl_getmsg('ggl-212',g_lang) RETURNING t_dc                 
        END IF
     END IF
 
     CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
     LET l_npq25_bal = n_bal / n_balf                                                     #FUN-980119
     IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
     INSERT INTO axrq710_tmp
     VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'1',l_date2,
            '','','',g_msg,sr.npq24,'',0,0,0,0,0,0,0,0,t_dc,n_balf,l_npq25_bal,n_bal,     #FUN-980119  
            g_pageno,t_azi04,t_azi05,t_azi07)
     LET l_flag1 = 'Y'
    END IF
 
    IF sr.npq07 <> 0 OR sr.npq07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.npq24
         IF cl_null(sr.npq07) THEN LET sr.npq07 = 0 END IF
         IF cl_null(sr.npq07f) THEN LET sr.npq07f = 0 END IF
         IF sr.npq06 = 1 THEN
            LET t_bal  = t_bal  + sr.npq07
            LET t_balf = t_balf + sr.npq07f
            LET y_df   = y_df   + sr.npq07f
            LET y_d    = y_d    + sr.npq07
         ELSE
            LET t_bal  = t_bal  - sr.npq07
            LET t_balf = t_balf - sr.npq07f
            LET y_cf   = y_cf   + sr.npq07f
            LET y_c    = y_c    + sr.npq07
         END IF
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING t_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING t_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING t_dc
            END IF
         END IF
         IF sr.npq06 = '1' THEN
            LET l_d  = sr.npq07
            LET l_df = sr.npq07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.npq07
            LET l_cf = sr.npq07f
         END IF
 
         #type = '1' 期初結余打印
         LET l_npq25_d = l_d / l_df
         LET l_npq25_c = l_c / l_cf
         LET l_npq25_bal = n_bal / n_balf
 
         IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
         IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
         IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
         INSERT INTO axrq710_tmp
         VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'2',
                sr.npp02,sr.npp01,sr.npp00,sr.nppsys,sr.nppglno,
                sr.npq24,sr.npq06,sr.npq07,sr.npq07f,
                l_df,l_npq25_d,l_d,l_cf,l_npq25_c,l_c,
                t_dc,n_balf,l_npq25_bal,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)          #FUN-980119
      END IF
            LET g_print = g_print + 1
            END FOREACH
            IF g_print = 0 THEN   #沒有打印過
               IF t_qcye = 0 THEN CONTINUE FOR END IF
               LET sr.npp01 = ''
               LET sr.npp00 = ''
               LET sr.nppsys= ''
               LET sr.npp02 =''
               LET sr.nppglno = ''
               LET sr.npq03 = sr1.npq03
               SELECT aag02 INTO sr.aag02 FROM aag_file
                WHERE aag01 = sr1.npq03
                  AND aag00 = tm.o        
               LET sr.npq06 = ''
               LET sr.npq07f =0
               LET sr.npq07 = 0
               LET sr.npq21 = sr1.npq21
               LET sr.npq22 = sr1.npq22
               IF tm.c = 'Y' THEN
                  LET sr.npq24 = sr1.npq24
               ELSE
                  LET sr.npq24 = '' 
               END IF
               LET sr.oma09 =''
               LET sr.oma10 =''
               LET sr.qcye = l_qcye
               LET sr.qcyef = l_qcyef
               LET sr.mm   = l_i
               LET sr.df_p = d_npq07f
               LET sr.d_p  = d_npq07
               LET sr.cf_p = c_npq07f
               LET sr.c_p  = c_npq07
               LET sr.df_y = l_npr06f + d_npq07f
               LET sr.d_y  = l_npr06 + d_npq07
               LET sr.cf_y = l_npr07f + c_npq07f
               LET sr.c_y  = l_npr07 + c_npq07
 
    IF l_flag1 = 'N' THEN
       IF l_flag4 = 'N' THEN
         LET t_bal  = sr.qcye      #期初余額
         LET t_balf = sr.qcyef
         LET y_df   = sr.df_y + sr.df_p
         LET y_d    = sr.d_y  + sr.d_p
         LET y_cf   = sr.cf_y + sr.cf_p
         LET y_c    = sr.c_y  + sr.c_p
         LET l_flag4 = 'Y'  
       END IF
      
     IF sr.mm = MONTH(tm.bdate) THEN
        LET l_date2 = tm.bdate
     ELSE
        LET l_date2 = MDY(sr.mm,1,yy)
     END IF
 
     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
      WHERE azi01 = sr.npq24
 
     IF t_bal > 0 THEN
        LET n_bal = t_bal
        LET n_balf= t_balf
        CALL cl_getmsg('ggl-211',g_lang) RETURNING t_dc                
     ELSE
        IF t_bal = 0 THEN
           LET n_bal = t_bal
           LET n_balf= t_balf
           CALL cl_getmsg('ggl-210',g_lang) RETURNING t_dc                  
        ELSE
           LET n_bal = t_bal * -1
           LET n_balf= t_balf* -1
           CALL cl_getmsg('ggl-212',g_lang) RETURNING t_dc                 
        END IF
     END IF
 
     CALL cl_getmsg('ggl-213',g_lang) RETURNING g_msg
     LET l_npq25_bal = n_bal / n_balf                                                     #FUN-980119     
     IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
     INSERT INTO axrq710_tmp
     VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'1',l_date2,
            '','','',g_msg,sr.npq24,'',0,0,0,0,0,0,0,0,t_dc,n_balf,l_npq25_bal,n_bal,     #FUN-980119
            g_pageno,t_azi04,t_azi05,t_azi07)
     LET l_flag1 = 'Y'
    END IF
 
      IF sr.npq07 <> 0 OR sr.npq07f <> 0 THEN
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
          WHERE azi01 = sr.npq24
         IF cl_null(sr.npq07) THEN LET sr.npq07 = 0 END IF
         IF cl_null(sr.npq07f) THEN LET sr.npq07f = 0 END IF
         IF sr.npq06 = 1 THEN
            LET t_bal  = t_bal  + sr.npq07
            LET t_balf = t_balf + sr.npq07f
            LET y_df   = y_df   + sr.npq07f
            LET y_d    = y_d    + sr.npq07
         ELSE
            LET t_bal  = t_bal  - sr.npq07
            LET t_balf = t_balf - sr.npq07f
            LET y_cf   = y_cf   + sr.npq07f
            LET y_c    = y_c    + sr.npq07
         END IF
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING t_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING t_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING t_dc
            END IF
         END IF
         IF sr.npq06 = '1' THEN
            LET l_d  = sr.npq07
            LET l_df = sr.npq07f
            LET l_c  = 0
            LET l_cf = 0
         ELSE
            LET l_d  = 0
            LET l_df = 0
            LET l_c  = sr.npq07
            LET l_cf = sr.npq07f
         END IF
 
         #type = '1' 期初結余打印
 
         LET l_npq25_d = l_d / l_df
         LET l_npq25_c = l_c / l_cf
         LET l_npq25_bal = n_bal / n_balf
 
         IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
         IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
         IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
         INSERT INTO axrq710_tmp
         VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'2',
                sr.npp02,sr.npp01,sr.npp00,sr.nppsys,sr.nppglno,
                sr.npq24,sr.npq06,sr.npq07,sr.npq07f,
                l_df,l_npq25_d,l_d,l_cf,l_npq25_c,l_c,
                t_dc,n_balf,l_npq25_bal,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)       #FUN-980119
      END IF
    END IF
 
      LET sr.mm = l_i                                  
      CALL s_yp(tm.edate) RETURNING l_year,l_month
      IF sr.mm = l_month THEN
         LET sr.npp02 = tm.edate
      ELSE
         CALL s_azn01(yy,sr.mm) RETURNING l_date,l_date1
         LET sr.npp02 = l_date1
      END IF
 
      SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
       WHERE azi01 = sr.npq24
 
      IF t_bal > 0 THEN
         LET n_bal = t_bal
         LET n_balf= t_balf
         CALL cl_getmsg('ggl-211',g_lang) RETURNING t_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-210',g_lang) RETURNING t_dc
         ELSE
            LET n_bal = t_bal * -1
            LET n_balf= t_balf* -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING t_dc
         END IF
      END IF
 
      SELECT SUM(npq07) INTO l_d
        FROM axrq710_tmp 
       WHERE npq06 = '1'  AND npq07 IS NOT NULL 
         AND mm = sr.mm   AND npq22 = sr.npq22            
         AND npq21 = sr.npq21 AND npq03 = sr.npq03
         AND npq24 = sr.npq24                                      #FUN-980119 Add
      SELECT SUM(npq07f) INTO l_df
        FROM axrq710_tmp 
       WHERE npq06 = '1'  AND npq07 IS NOT NULL 
         AND mm = sr.mm   AND npq22 = sr.npq22              
         AND npq21 = sr.npq21 AND npq03 = sr.npq03
         AND npq24 = sr.npq24                                      #FUN-980119 Add       
      SELECT SUM(npq07) INTO l_c
        FROM axrq710_tmp 
       WHERE npq06 = '2'  AND npq07 IS NOT NULL 
         AND mm = sr.mm   AND npq22 = sr.npq22           
         AND npq21 = sr.npq21 AND npq03 = sr.npq03
         AND npq24 = sr.npq24                                      #FUN-980119 Add       
      SELECT SUM(npq07f) INTO l_cf
        FROM axrq710_tmp 
       WHERE npq06 = '2'  AND npq07 IS NOT NULL 
         AND mm = sr.mm   AND npq22 = sr.npq22           
         AND npq21 = sr.npq21 AND npq03 = sr.npq03
         AND npq24 = sr.npq24                                      #FUN-980119 Add
                
      IF cl_null(l_d)  THEN LET l_d  = 0 END IF
      IF cl_null(l_df) THEN LET l_df = 0 END IF
      IF cl_null(l_c)  THEN LET l_c  = 0 END IF
      IF cl_null(l_cf) THEN LET l_cf = 0 END IF
      IF sr.mm = mm1 THEN
         LET l_d  = l_d  + sr.d_p
         LET l_df = l_df + sr.df_p
         LET l_c  = l_c  + sr.c_p
         LET l_cf = l_cf + sr.cf_p
      END IF
      CALL cl_getmsg('ggl-214',g_lang) RETURNING g_msg
 
      LET l_npq25_d = l_d / l_df
      LET l_npq25_c = l_c / l_cf
      LET l_npq25_bal = n_bal / n_balf
 
      IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
      IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
      IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
      INSERT INTO axrq710_tmp
      VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'3',
             sr.npp02,'','','',g_msg,sr.npq24,
             '',0,0,0,0,l_d,0,0,l_c,
             t_dc,n_balf,l_npq25_bal,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)       #FUN-980119
 
      #type = '4' 期末后的本年結余打印
      IF cl_null(y_d)  THEN LET y_d  = 0 END IF
      IF cl_null(y_df) THEN LET y_df = 0 END IF
      IF cl_null(y_c)  THEN LET y_c  = 0 END IF
      IF cl_null(y_cf) THEN LET y_cf = 0 END IF
      CALL cl_getmsg('ggl-215',g_lang) RETURNING g_msg
 
      LET l_npq25_d = y_d / y_df
      LET l_npq25_c = y_c / y_cf
      LET l_npq25_bal = n_bal / n_balf
 
      IF cl_null(l_npq25_bal) THEN LET l_npq25_bal = 0 END IF
      IF cl_null(l_npq25_d) THEN LET l_npq25_d = 0 END IF
      IF cl_null(l_npq25_c) THEN LET l_npq25_c = 0 END IF
      INSERT INTO axrq710_tmp
      VALUES(sr.npq21,sr.npq22,sr.npq03,sr.aag02,sr.mm,'4',
              sr.npp02,'','','',g_msg,sr.npq24,
             '',0,0,0,0,y_d,0,0,y_c,
             t_dc,n_balf,l_npq25_bal,n_bal,g_pageno,t_azi04,t_azi05,t_azi07)       #FUN-980119                          
        LET l_flag1 = 'N'   
        END FOR
     END FOREACH
END FUNCTION
 
#No.MOD-BC0252  --Begin
#FUNCTION q710_oma(p_i,p_oma01)
#  DEFINE  l_oma09   LIKE oma_file.oma09,
#          l_oma10   LIKE oma_file.oma10,
#          l_omaconf LIKE oma_file.omaconf,
#          l_ooaconf LIKE ooa_file.ooaconf,
#          p_oma01   LIKE oma_file.oma01,
#          p_i       LIKE type_file.num5,        #No.FUN-680123 SMALLINT
#          l_oox00   LIKE oox_file.oox00,
#          l_oox01   LIKE oox_file.oox01,        #No.FUN-680123 SMALLINT
#          l_oox02   LIKE oox_file.oox02,        #No.FUN-680123 SMALLINT
#          l_i       LIKE type_file.num5,        #No.FUN-680123 SMALLINT
#          l_flag    LIKE type_file.chr1         #No.FUN-680123 VARCHAR(01)
#  DEFINE  l_conf    LIKE oma_file.omaconf       #No.MOD-BC0252
# 
#   LET l_flag = 'Y'   #it is valid
#   SELECT oma09,oma10,omaconf INTO l_oma09,l_oma10,l_omaconf
#     FROM oma_file
#    WHERE oma01 = p_oma01
#   IF SQLCA.sqlcode THEN
#      SELECT ooaconf INTO l_ooaconf FROM ooa_file
#       WHERE ooa01 = p_oma01
#      IF SQLCA.sqlcode THEN
#         LET l_oox00 = p_oma01[1,2]
#         LET l_oox01 = p_oma01[3,6] USING "&&&&"
#         LET l_oox02 = p_oma01[7,8] USING "&&"
#         SELECT COUNT(*) INTO l_i FROM oox_file
#          WHERE oox00 = l_oox00
#            AND oox01 = l_oox01
#            AND oox02 = l_oox02
#         IF l_i = 0 OR tm.d = '2' THEN
##No.MOD-B60247 --begin                                                          
#            SELECT COUNT(*) INTO l_i FROM nmg_file                              
#             WHERE nmg00 = p_oma01                                              
#            IF l_i = 0 THEN                                                     
#               LET l_flag = 'N'                                                 
#            END IF                                                              
##           LET l_flag = 'N'                                                    
##No.MOD-B60247 --end 
#         END IF
#      ELSE
#         IF p_i = 0 THEN           #before period
#            IF l_ooaconf <> 'Y' THEN
#               LET l_flag = 'N'
#            END IF
#         ELSE                      #middle period
#            IF tm.d <> '3' THEN
#               IF l_ooaconf <> g_d THEN
#                  LET l_flag = 'N' #it is unvalid
#               END IF
#            END IF
#         END IF
#      END IF
#   ELSE
#      IF p_i = 0 THEN
#         IF l_omaconf <> 'Y' THEN
#            LET l_flag = 'N'
#         END IF
#       ELSE
#         IF tm.d <> '3' THEN
#            IF l_omaconf <> g_d THEN
#               LET l_flag = 'N'
#            END IF
#         END IF
#      END IF
#   END IF
#   RETURN l_flag,l_oma09,l_oma10
#END FUNCTION
#No.MOD-BC0252  --End  
 
FUNCTION q710_out_1()
   LET g_prog = 'axrq710'
   LET g_sql = "npq21.npq_file.npq21,",
               "npq22.npq_file.npq22,",
               "npq03.npq_file.npq03,",
               "aag02.aag_file.aag02,",
               "mm.type_file.num5,",
               "type.type_file.chr1,",
               "npp02.npp_file.npp02,",
               "npp01.npp_file.npp01,",
               "nppglno.npp_file.nppglno,",
               "npq24.npq_file.npq24,",
               "npq06.npq_file.npq06,",
               "npq07.npq_file.npq07,",
               "npq07f.npq_file.npq07f,",
               "df.npq_file.npq07,",
               "npq25_d.npq_file.npq25,",
               "d.npq_file.npq07,",
               "cf.npq_file.npq07,",
               "npq25_c.npq_file.npq25,",
               "c.npq_file.npq07,",
               "dc.type_file.chr10,",
               "balf.npq_file.npq07,",
               "npq25_bal.npq_file.npq25,",
               "bal.npq_file.npq07,",
               "pagenum.type_file.num5,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07 "
 
   LET l_table = cl_prt_temptable('axrq710',g_sql) CLIPPED
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ? )         "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION q710_out_2()
   DEFINE l_name             LIKE type_file.chr20  #FUN-980119
   
   LET g_prog = 'axrq710'
   CALL cl_del_data(l_table)                       #NO.FUN-7B0026
 
   DECLARE cr_curs CURSOR FOR
    SELECT npq21, npq22, npq03, aag02, mm, type, npp02,
           npp01, nppglno, npq24, npq06, npq07, npq07f,
           df, npq25_d, d, cf, npq25_c, c, dc, balf,
           npq25_bal, bal, pagenum, azi04, azi05, azi07
   FROM axrq710_tmp
   FOREACH cr_curs INTO g_pr.*
       EXECUTE insert_prep USING g_pr.*
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'npq21,npp01,npq03')
           RETURNING g_str
   END IF
   LET g_str=g_str CLIPPED,";",yy,";",g_azi04
 
   #FUN-980119--Mark--Begin--#
#  IF tm.b = 'N' THEN
#     CALL cl_prt_cs3('axrq710','axrq710',g_sql,g_str)
#  ELSE
#     CALL cl_prt_cs3('axrq710','axrq710_1',g_sql,g_str)
#  END IF
   #FUN-980119--Mark--End--#
   
   #FUN-980119--Add--Begin--#
   IF tm.b = 'N' THEN
       LET l_name = 'axrq710'
   ELSE
       IF tm.c = 'Y' THEN           
          LET l_name = 'axrq710_2'  
       ELSE                               
          LET l_name = 'axrq710_1'
       END IF    
   END IF
   CALL cl_prt_cs3('axrq710',l_name,g_sql,g_str)   
   #FUN-980119--Add--End--#
      
END FUNCTION
 
FUNCTION q710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
#No.FUN-A40009 --begin
         IF g_rec_b != 0 AND l_ac != 0 THEN  
            CALL fgl_set_arr_curr(l_ac)     
         END IF                            
#No.FUN-A40009 --end
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION query_account
         LET g_action_choice="query_account"
         EXIT DISPLAY
 
      ON ACTION first
         CALL axrq710_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL axrq710_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL axrq710_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL axrq710_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL axrq710_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION axrq710_cs()
     IF tm.c = 'Y' THEN                                                                    #FUN-980119
         LET g_sql = "SELECT UNIQUE npq21,npq22,npq03,aag02,mm,npq24 FROM axrq710_tmp ",   #FUN-980119
                     " ORDER BY npq21,npq22,npq03,npq24,mm"                                #FUN-980119    
     ELSE                                                                                  #FUN-980119    	    
         LET g_sql = "SELECT UNIQUE npq21,npq22,npq03,aag02,mm FROM axrq710_tmp ",
                     " ORDER BY npq21,npq22,npq03,mm"
     END IF                                                                                #FUN-980119                
     PREPARE axrq710_ps FROM g_sql
     DECLARE axrq710_curs SCROLL CURSOR WITH HOLD FOR axrq710_ps
     
     IF tm.c = 'Y' THEN                                                                    #FUN-980119
         LET g_sql = "SELECT UNIQUE npq21,npq22,npq03,aag02,mm,npq24 FROM axrq710_tmp ",   #FUN-980119
                     "  INTO TEMP x "                                                      #FUN-980119    
     ELSE                                                                                  #FUN-980119    	    
         LET g_sql = "SELECT UNIQUE npq21,npq22,npq03,aag02,mm FROM axrq710_tmp ",
                     "  INTO TEMP x "
     END IF                                                                                #FUN-980119     
 
     DROP TABLE x
     PREPARE axrq710_ps1 FROM g_sql
     EXECUTE axrq710_ps1
 
     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE axrq710_ps2 FROM g_sql
     DECLARE axrq710_cnt CURSOR FOR axrq710_ps2
 
     OPEN axrq710_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN axrq710_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN axrq710_cnt
        FETCH axrq710_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL axrq710_fetch('F')
     END IF
END FUNCTION
 
FUNCTION axrq710_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680126 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680126 INTEGER
   
   IF tm.c = 'Y' THEN
   CASE p_flag
      WHEN 'N' FETCH NEXT     axrq710_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm,g_npq24    #FUN-980119 add npq24
      WHEN 'P' FETCH PREVIOUS axrq710_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm,g_npq24    #FUN-980119 add npq24
      WHEN 'F' FETCH FIRST    axrq710_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm,g_npq24    #FUN-980119 add npq24
      WHEN 'L' FETCH LAST     axrq710_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm,g_npq24    #FUN-980119 add npq24
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about         #MOD-4C0121
                   CALL cl_about()      #MOD-4C0121
 
                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
 
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump axrq710_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm,g_npq24    #FUN-980119 add npq24
         LET mi_no_ask = FALSE
   END CASE
   ELSE
   CASE p_flag
      WHEN 'N' FETCH NEXT     axrq710_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm
      WHEN 'P' FETCH PREVIOUS axrq710_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm
      WHEN 'F' FETCH FIRST    axrq710_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm
      WHEN 'L' FETCH LAST     axrq710_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about         #MOD-4C0121
                   CALL cl_about()      #MOD-4C0121
 
                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
 
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
         END IF
         FETCH ABSOLUTE g_jump axrq710_curs INTO g_npq21,g_npq22,g_npq03,g_aag02,g_mm
         LET mi_no_ask = FALSE
   END CASE
   END IF   	                                                             #FUN-980119               
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npq21,SQLCA.sqlcode,0)
      INITIALIZE g_npq21 TO NULL
      INITIALIZE g_npq22 TO NULL
      INITIALIZE g_npq03 TO NULL
      INITIALIZE g_aag02 TO NULL      
      INITIALIZE g_mm    TO NULL
      IF tm.c = 'Y' THEN                                                   #FUN-980119
         INITIALIZE g_npq24 TO NULL                                        #FUN-980119
      END IF                                                               #FUN-980119
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump #CKP3
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   CALL axrq710_show()
END FUNCTION
 
FUNCTION axrq710_show()
 
   DISPLAY g_npq21 TO npq21
   DISPLAY g_npq22 TO npq22
   DISPLAY g_npq03 TO npq03
   DISPLAY g_aag02 TO aag02
   DISPLAY yy   TO yy
   DISPLAY g_mm TO mm
   DISPLAY g_npq24 TO npq241                             #FUN-980119 Add
 
   CALL axrq710_b_fill()
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION axrq710_b_fill()                     #BODY FILL UP
  DEFINE  l_npq06    LIKE npq_file.npq06
  DEFINE  l_type     LIKE type_file.chr1
 
   IF tm.c = 'Y' THEN
      LET g_sql = "SELECT npp02,npp01,npp00,nppsys,nppglno,npq24,df,npq25_d,d,",
                   "       cf,npq25_c,c,dc,balf,npq25_bal,bal,",
                   "       azi04,azi05,azi07,npq06,type ",
                   " FROM axrq710_tmp",
                   " WHERE npq21 ='",g_npq21,"'",
                   "   AND npq22 ='",g_npq22,"'",
                   "   AND npq03 ='",g_npq03,"'",
                   "   AND npq24 ='",g_npq24,"'",                   #FUN-980119 Add
                   "   AND mm    = ",g_mm,
                   " ORDER BY type,npp02,npp01,npq06 "
   ELSE
      LET g_sql = "SELECT npp02,npp01,npp00,nppsys,nppglno,npq24,df,npq25_d,d,",
                   "       cf,npq25_c,c,dc,balf,npq25_bal,bal,",
                   "       azi04,azi05,azi07,npq06,type ",
                   " FROM axrq710_tmp",
                   " WHERE npq21 ='",g_npq21,"'",
                   "   AND npq22 ='",g_npq22,"'",
                   "   AND npq03 ='",g_npq03,"'",
                   "   AND mm    = ",g_mm,
                   " ORDER BY type,npp02,npp01,npq06 "
   END IF                                                            #FUN-980119 Add      	                
 
   PREPARE axrq710_pb FROM g_sql
   DECLARE npq_curs  CURSOR FOR axrq710_pb        #CURSOR
 
   CALL g_npq.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH npq_curs INTO g_npq[g_cnt].*,t_azi04,t_azi05,t_azi07,l_npq06,l_type
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_npq[g_cnt].d   = cl_numfor(g_npq[g_cnt].d,20,g_azi04)
      LET g_npq[g_cnt].c   = cl_numfor(g_npq[g_cnt].c,20,g_azi04)
      LET g_npq[g_cnt].bal = cl_numfor(g_npq[g_cnt].bal,20,g_azi04)
      LET g_npq[g_cnt].df  = cl_numfor(g_npq[g_cnt].df,20,t_azi04)
      LET g_npq[g_cnt].cf  = cl_numfor(g_npq[g_cnt].cf,20,t_azi04)
      LET g_npq[g_cnt].balf= cl_numfor(g_npq[g_cnt].balf,20,t_azi04)
      LET g_npq[g_cnt].npq25_d= cl_numfor(g_npq[g_cnt].npq25_d,20,t_azi07)
      LET g_npq[g_cnt].npq25_c= cl_numfor(g_npq[g_cnt].npq25_c,20,t_azi07)
      LET g_npq[g_cnt].npq25_bal= cl_numfor(g_npq[g_cnt].npq25_bal,20,t_azi07)
       
      IF tm.c = 'N' THEN                                     #FUN-980119 Add                 
      #外幣時,外幣匯總沒有意義
      IF l_type = '1' THEN
         LET g_npq[g_cnt].d = NULL
         LET g_npq[g_cnt].df= NULL
         LET g_npq[g_cnt].npq25_d= NULL
         LET g_npq[g_cnt].c = NULL
         LET g_npq[g_cnt].cf = NULL
         LET g_npq[g_cnt].npq25_c= NULL
         LET g_npq[g_cnt].balf= NULL
         LET g_npq[g_cnt].npq25_bal = NULL
      END IF
      IF l_type = '3' OR l_type = '4' THEN
         LET g_npq[g_cnt].df = NULL
         LET g_npq[g_cnt].npq25_d= NULL
         LET g_npq[g_cnt].cf = NULL
         LET g_npq[g_cnt].npq25_c= NULL
         LET g_npq[g_cnt].balf = NULL
         LET g_npq[g_cnt].npq25_bal = NULL
      END IF
      IF l_type = '2' THEN
         LET g_npq[g_cnt].balf= NULL
         LET g_npq[g_cnt].npq25_bal = NULL
      END IF
      ELSE
      IF l_type = '1' THEN
         LET g_npq[g_cnt].d = NULL
         LET g_npq[g_cnt].df= NULL
         LET g_npq[g_cnt].npq25_d= NULL
         LET g_npq[g_cnt].c = NULL
         LET g_npq[g_cnt].cf = NULL
         LET g_npq[g_cnt].npq25_c= NULL
         LET g_npq[g_cnt].npq25_bal = NULL         
      END IF
      IF l_type = '3' OR l_type = '4' THEN
         LET g_npq[g_cnt].df = NULL
         LET g_npq[g_cnt].npq25_d= NULL
         LET g_npq[g_cnt].cf = NULL
         LET g_npq[g_cnt].npq25_c= NULL
         LET g_npq[g_cnt].npq25_bal = NULL         
      END IF      	
      END IF                                                    
      
      IF l_npq06 = '1' THEN
         LET g_npq[g_cnt].c = NULL
         LET g_npq[g_cnt].cf = NULL
         LET g_npq[g_cnt].npq25_c= NULL
      END IF
      IF l_npq06 = '2' THEN
         LET g_npq[g_cnt].d = NULL
         LET g_npq[g_cnt].df= NULL
         LET g_npq[g_cnt].npq25_d= NULL
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_npq.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
FUNCTION axrq710_table()
     DROP TABLE axrq710_tmp;
     CREATE TEMP TABLE axrq710_tmp(
                    npq21       LIKE npq_file.npq21,
                    npq22       LIKE npq_file.npq22,
                    npq03       LIKE npq_file.npq03,
                    aag02       LIKE aag_file.aag02,
                    mm          LIKE type_file.num5,
                    type        LIKE type_file.chr1,
                    npp02       LIKE npp_file.npp02,
                    npp01       LIKE npp_file.npp01,
                    npp00       LIKE npp_file.npp00,
                    nppsys      LIKE npp_file.nppsys,
                    nppglno     LIKE npp_file.nppglno,
                    npq24       LIKE npq_file.npq24,
                    npq06       LIKE npq_file.npq06,
                    npq07       LIKE npq_file.npq07,
                    npq07f      LIKE npq_file.npq07f,
                    df          LIKE npq_file.npq07,
                    npq25_d     LIKE npq_file.npq25,
                    d           LIKE npq_file.npq07,
                    cf          LIKE npq_file.npq07,
                    npq25_c     LIKE npq_file.npq25,
                    c           LIKE npq_file.npq07,
                    dc          LIKE type_file.chr10,
                    balf        LIKE npq_file.npq07,
                    npq25_bal   LIKE npq_file.npq25,
                    bal         LIKE npq_file.npq07,
                    pagenum     LIKE type_file.num5,
                    azi04       LIKE azi_file.azi04,
                    azi05       LIKE azi_file.azi04,
                    azi07       LIKE azi_file.azi07);
END FUNCTION
 
FUNCTION axrq710_t()
   #npp00/nppsys 僅for串查
   CALL cl_set_comp_visible("npp00,nppsys",FALSE)
   IF tm.b = 'Y' THEN
      CALL cl_set_comp_visible("npq24,df,d,cf,c,balf,bal",TRUE)
      CALL cl_set_comp_visible("npq25_d,npq25_c,npq25_bal",TRUE)
      CALL cl_getmsg("ggl-201",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("df",g_msg CLIPPED)
      CALL cl_getmsg("ggl-202",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-203",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("cf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-204",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-205",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("balf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-206",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   ELSE
      CALL cl_set_comp_visible("npq24,npq25,df,cf,balf",FALSE)
      CALL cl_set_comp_visible("npq25_d,npq25_c,npq25_bal",FALSE)
      CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-209",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   END IF
   IF tm.c = 'Y' THEN
      CALL cl_set_comp_visible("npq241",TRUE)                                                                                       
   ELSE
      CALL cl_set_comp_visible("npq241",FALSE)
   END IF
   LET g_npq03 = NULL
 
   LET g_aag02 = NULL
   LET g_npq21 = NULL
   LET g_npq22 = NULL
   IF tm.c = 'Y' THEN                                                   #FUN-980119
      INITIALIZE g_npq24 TO NULL                                        #FUN-980119
   END IF                                                               #FUN-980119   
   CLEAR FORM
   CALL g_npq.clear()
   CALL axrq710_cs()
END FUNCTION
 
FUNCTION q710_q_a()
   DEFINE #l_wc    LIKE type_file.chr1000
          l_wc     STRING     #NO.FUN-910082
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
   DEFINE l_slip  LIKE ooy_file.ooyslip   #MOD-C30003
   DEFINE l_type  LIKE ooy_file.ooytype   #MOD-C30003
 
   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_npq[l_ac].npp01) THEN RETURN END IF
   LET g_msg = NULL
   IF g_npq[l_ac].nppsys = 'AR' AND g_npq[l_ac].npp00 MATCHES '[12]' THEN
      LET g_msg = "axrt300 '",g_npq[l_ac].npp01,"'"
   END IF
   IF g_npq[l_ac].nppsys = 'AR' AND g_npq[l_ac].npp00 = '3' THEN
      #No.MOD-C30003  --Begin
      #LET g_msg = "axrt400 '",g_npq[l_ac].npp01,"' 'query'"
      LET l_slip = s_get_doc_no(g_npq[l_ac].npp01)
      SELECT ooytype INTO l_type FROM ooy_file WHERE ooyslip=l_slip
      IF l_type = '30' THEN
         LET g_msg = "axrt400 '",g_npq[l_ac].npp01,"' 'query'"
      ELSE
         LET g_msg = "axrt410 '",g_npq[l_ac].npp01,"' 'query'"
      END IF
      #No.MOD-C30003  --End
   END IF
   IF g_npq[l_ac].nppsys = 'AR' AND g_npq[l_ac].npp00 = '4' THEN
      LET l_wc = 'oox00 = "AR" AND oox01 = ',yy,' AND oox02 = ',g_mm,' AND oox03 = "',g_npq[l_ac].npp01,'"'
      LET g_msg = "gxrq600 '",l_wc CLIPPED,"'"
   END IF
#No.MOD-A30002 --begin                                                          
   IF g_npq[l_ac].nppsys = 'NM' THEN                                            
      LET g_msg = "anmt302 '",g_npq[l_ac].npp01 CLIPPED,"'"                     
   END IF                                                                       
#No.MOD-A30002 --end  
   #No.C10034  --Begin
   IF g_npq[l_ac].nppsys = 'FA' AND g_npq[l_ac].npp00 = '4' THEN                                            
      LET g_msg = "afat110 '",g_npq[l_ac].npp01 CLIPPED,"'"                     
   END IF                                                                       
   #No.C10034  --End  
   IF NOT cl_null(g_msg) THEN
      CALL cl_cmdrun(g_msg)
   END IF
   
END FUNCTION   
#No.FUN-9C0072 精簡程式碼

#No.MOD-BC0252  --Begin
FUNCTION q710_oma(p_i,p_oma01)
  DEFINE  l_oma09   LIKE oma_file.oma09
  DEFINE  l_oma10   LIKE oma_file.oma10
  DEFINE  p_oma01   LIKE oma_file.oma01
  DEFINE  p_i       LIKE type_file.num5
  DEFINE  l_oox00   LIKE oox_file.oox00
  DEFINE  l_oox01   LIKE oox_file.oox01
  DEFINE  l_oox02   LIKE oox_file.oox02
  DEFINE  l_i       LIKE type_file.num5
  DEFINE  l_flag    LIKE type_file.chr1
  DEFINE  l_conf    LIKE oma_file.omaconf
 
   LET l_oma09 = NULL 
   LET l_oma10 = NULL
   LET l_conf = NULL
   SELECT oma09,oma10,omaconf INTO l_oma09,l_oma10,l_conf
     FROM oma_file
    WHERE oma01 = p_oma01
   IF l_conf MATCHES '[YNyn]' THEN 
      CALL q710_status(p_i,l_conf) RETURNING l_flag
      RETURN l_flag,l_oma09,l_oma10
   END IF

   LET l_conf = NULL
   SELECT ooaconf INTO l_conf FROM ooa_file
    WHERE ooa01 = p_oma01
   IF l_conf MATCHES '[YNyn]' THEN 
      CALL q710_status(p_i,l_conf) RETURNING l_flag
      RETURN l_flag,NULL,NULL
   END IF

   LET l_conf = NULL
   SELECT nmgconf INTO l_conf FROM nmg_file
    WHERE nmg00 = p_oma01
   IF l_conf MATCHES '[YNyn]' THEN 
      CALL q710_status(p_i,l_conf) RETURNING l_flag
      RETURN l_flag,NULL,NULL
   END IF

   LET l_conf = NULL
   SELECT fbeconf INTO l_conf FROM fbe_file
    WHERE fbe01 = p_oma01
   IF l_conf MATCHES '[YNyn]' THEN 
      CALL q710_status(p_i,l_conf) RETURNING l_flag
      RETURN l_flag,NULL,NULL
   END IF

   LET l_oox00 = p_oma01[1,2]
   LET l_oox01 = p_oma01[3,6] USING "&&&&"
   LET l_oox02 = p_oma01[7,8] USING "&&"
   SELECT COUNT(*) INTO l_i FROM oox_file
    WHERE oox00 = l_oox00
      AND oox01 = l_oox01
      AND oox02 = l_oox02
   IF l_i > 0  THEN
      IF tm.d = '2' THEN
         LET l_flag = 'N'
      ELSE
         LET l_flag = 'Y'
      END IF
   ELSE
      LET l_flag = 'N'
   END IF
   RETURN l_flag,NULL,NULL
END FUNCTION

FUNCTION q710_status(p_i,p_conf)
   DEFINE p_i       LIKE type_file.num5
   DEFINE p_conf    LIKE oma_file.omaconf
   DEFINE l_flag    LIKE type_file.chr1

   LET l_flag = 'N'
   IF p_i = 0 THEN
      IF p_conf = 'Y' THEN
         LET l_flag = 'Y'
      END IF
    ELSE
      IF tm.d = '3' OR p_conf = g_d THEN
         LET l_flag = 'Y'
      END IF
   END IF

   RETURN l_flag

END FUNCTION
#No.MOD-BC0252  --End  
