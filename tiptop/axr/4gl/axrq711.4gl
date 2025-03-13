# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axrq711.4gl
# Descriptions...: 客戶業務彙總帳列印
# Date & Author..: No.FUN-850030 08/05/28 By Carrier 報表查詢化 copy from axrr711
# Modify.........: No.FUN-850030 08/07/28 By dxfwo   新增程序從21區移植到31區
# Modify.........: No.TQC-8B0035 08/11/18 By wujie   sql里加上npr08是null或者空格的條件 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-920186 09/02/13 By liuxqa 匯率計算邏輯錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A40009 10/04/07 By wujie 查询界面点退出回到主画面，而不是关闭程序
#                                                  点击单据联查按钮后，光标保持在原来所在的行，而不是回到第一行
# Modify.........: No.FUN-B20054 10/02/22 By yangtingting 先錄入帳套,科目根據帳套過濾;結構改為DIALOG 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B50172 11/05/19 By wujie  调用axrq710参数有缺少

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD                                # Print condition RECORD
		 wc      LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000) # Where condition
                 yy      LIKE type_file.num5,          #No.FUN-680123 SMALLINT
                 m1      LIKE type_file.num5,          #No.FUN-680123 SMALLINT
                 m2      LIKE type_file.num5,          #No.FUN-680123 SMALLINT
                 o       LIKE aaa_file.aaa01,
                 b       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
                 d       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
 		 more    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01) # Input more condition(Y/N)
                 END RECORD,
       g_d       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
       g_null    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
       g_print   LIKE type_file.chr1,          #No.FUN-680123 SMALLINT
       g_aza17   LIKE aza_file.aza17,
       l_aza17   LIKE aza_file.aza17,
       l_aag02   LIKE aag_file.aag02,
       g_qcyef   LIKE npr_file.npr06f,
       g_qcye    LIKE npr_file.npr06f,
       t_qcyef   LIKE npr_file.npr06f,
       t_qcye    LIKE npr_file.npr06f
 
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose    #No.FUN-680123 SMALLINT
#No.FUN-7B0026---Begin                                                                                                              
DEFINE l_table        STRING,                                                                                                       
       g_str          STRING,
       g_sql          STRING                                                                                                       
 
#No.FUN-7B0026---End 
 
#No.FUN-850030  --Begin
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_npr00    LIKE npr_file.npr00
DEFINE   g_aag02    LIKE aag_file.aag02
DEFINE   g_npr05    LIKE npr_file.npr05
DEFINE   g_cnt      LIKE type_file.num10
DEFINE   g_npr      DYNAMIC ARRAY OF RECORD
                    npr01      LIKE type_file.chr50,
                    npr02      LIKE npr_file.npr02,
                    npr11      LIKE npr_file.npr11,
                    pb_dc      LIKE type_file.chr10,
                    pb_balf    LIKE npr_file.npr06f,
                    npr11_pb   LIKE npq_file.npq25,
                    pb_bal     LIKE npr_file.npr06f,
                    df         LIKE npr_file.npr06f,
                    npr11_d    LIKE npq_file.npq25,
                    d          LIKE npr_file.npr06f,
                    cf         LIKE npr_file.npr06f,
                    npr11_c    LIKE npq_file.npq25,
                    c          LIKE npr_file.npr06f,
                    dc         LIKE type_file.chr10,
                    balf       LIKE npr_file.npr06f,
                    npr11_bal  LIKE npq_file.npq25,
                    bal        LIKE npr_file.npr06f
                    END RECORD
DEFINE   g_pr       RECORD
                    npr00      LIKE npr_file.npr00,
                    aag02      LIKE aag_file.aag02,
                    npr05      LIKE npr_file.npr05,
                    npr01      LIKE type_file.chr50,
                    npr02      LIKE npr_file.npr02,
                    npr11      LIKE npr_file.npr11,
                    type       LIKE type_file.chr10,
                    pb_dc      LIKE type_file.chr10,
                    pb_balf    LIKE npr_file.npr06f,
                    npr11_pb   LIKE npq_file.npq25,
                    pb_bal     LIKE npr_file.npr06f,
                    memo       LIKE abb_file.abb04,
                    df         LIKE npr_file.npr06f,
                    npr11_d    LIKE npq_file.npq25,
                    d          LIKE npr_file.npr06f,
                    cf         LIKE npr_file.npr06f,
                    npr11_c    LIKE npq_file.npq25,
                    c          LIKE npr_file.npr06f,
                    dc         LIKE type_file.chr10,
                    balf       LIKE npr_file.npr06f,
                    npr11_bal  LIKE npq_file.npq25,
                    bal        LIKE npr_file.npr06f,
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
#No.FUN-850030   --End
 
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
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.m1 = ARG_VAL(9)
   LET tm.m2 = ARG_VAL(10)
   LET tm.o = ARG_VAL(11)
   LET tm.b = ARG_VAL(12)
   LET tm.d = ARG_VAL(13)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   #No.FUN-850030  --Begin
   CALL q711_out_1()
 
   OPEN WINDOW q711_w AT 5,10
        WITH FORM "axr/42f/axrq711_1" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   IF cl_null(tm.wc) THEN
       CALL axrq711_tm(0,0)             # Input print condition
   ELSE 
       CALL axrq711()
   END IF
 
   CALL q711_menu()
   DROP TABLE axrq711_tmp;
   CLOSE WINDOW q711_w
   #No.FUN-850030  --End  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION q711_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680126 VARCHAR(500)
 
   WHILE TRUE
      CALL q711_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL axrq711_tm(0,0)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q711_out_2()
            END IF
         WHEN "drill_detail"
            IF cl_chk_act_auth() THEN
               CALL q711_drill_detail()
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
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_npr),'','')
            END IF
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_npr00 IS NOT NULL THEN
                  LET g_doc.column1 = "npr00"
                  LET g_doc.value1 = g_npr00
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION axrq711_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_n            LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_flag         LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(1000)
   DEFINE li_chk_bookno  LIKE type_file.num5           #No.FUN-680123 SMALLINT  #No.FUN-670006 
   LET p_row = 4 LET p_col =25
 
   OPEN WINDOW axrq711_w AT p_row,p_col WITH FORM "axr/42f/axrq711"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axrq711")
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yy = YEAR(g_today)
   LET tm.m1 = MONTH(g_today)
   LET tm.m2 = MONTH(g_today)
   LET tm.o  = g_ooz.ooz02b
   LET tm.b = 'N'
   LET tm.d = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
WHILE TRUE
   #FUN-B20054--add--str--
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
     #FUN-B20054--add--end
   CONSTRUCT BY NAME tm.wc ON npr01,npr00
       #No.FUN-580031 --start--
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
       #No.FUN-580031 ---end---
       
#FUN-B20054--mark--str--  
#       ON ACTION CONTROLP
#          CASE
#             WHEN INFIELD(npr00)     #科目代號
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = 'q_aag'
#                LET g_qryparam.state= 'c'
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO npr00
#                NEXT FIELD npr00
#          END CASE
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
# 
#       #No.FUN-580031 --start--
#       ON ACTION qbe_select
#          CALL cl_qbe_select()
       #No.FUN-580031 ---end---
#FUN-B20054--mark--end-- 
    END CONSTRUCT

#    #FUN-980030   #FUN-B20054
#FUN-B20054--mark--str--
#    IF g_action_choice = "locale" THEN
#       LET g_action_choice = ""
#       CALL cl_dynamic_locale()
#       CONTINUE WHILE
#    END IF
# 
#    IF INT_FLAG THEN
#No.FUN-A40009 --begin
#      LET INT_FLAG = 0 CLOSE WINDOW axrq711_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
#      EXIT PROGRAM
#   END IF
#    ELSE
#No.FUN-A40009 --end
##   IF tm.wc = ' 1=1' THEN
#       CALL cl_err('','9046',0) CONTINUE WHILE
#    END IF
#FUN-B20054--mark--end--
    INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.b,tm.d,tm.more  #No.FUN-B20054 del tm.o
          #WITHOUT DEFAULTS   #FUN-B20054
          ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
        #No.FUN-580031 --start--
        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        #No.FUN-580031 ---end---
 
        AFTER FIELD yy
           IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
 
        AFTER FIELD m1
           IF cl_null(tm.m1) OR tm.m1 > 13 OR tm.m1 < 1 THEN
              NEXT FIELD m1
           END IF
 
        AFTER FIELD m2
           IF cl_null(tm.m2) OR tm.m2 > 13 OR tm.m2 < 1 OR tm.m2 < tm.m1 THEN
              NEXT FIELD m2
           END IF
 
#        AFTER FIELD o
#           IF cl_null(tm.o) THEN NEXT FIELD o END IF
#           #No.FUN-670006--begin
#           CALL s_check_bookno(tm.o,g_user,g_plant) 
#                RETURNING li_chk_bookno
#           IF (NOT li_chk_bookno) THEN
#                NEXT FIELD o
#           END IF 
#           #No.FUN-670006--end
#           SELECT * FROM aaa_file WHERE aaa01 = tm.o
#           IF SQLCA.sqlcode THEN
#              CALL cl_err3("sel","aaa_file",tm.o,"","aap-229","","",0)   #No.FUN-660116
#              NEXT FIELD o 
#           END IF
#           SELECT aaa03 INTO l_aza17 FROM aaa_file WHERE aaa01 = tm.o
#           IF SQLCA.sqlcode THEN LET l_aza17 = g_aza.aza17 END IF   #使用本國幣別
 
        AFTER FIELD more
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF

#FUN-B20054--mark--str--   
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
# 
#        ON ACTION CONTROLG
#           CALL cl_cmdask()    # Command execution
# 
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
# 
#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121
# 
#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121
# 
#        ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT INPUT
# 
#        #No.FUN-580031 --start--
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#        #No.FUN-580031 ---end---
 
    END INPUT
    
    #FUN-B20054--add--str--
      ON ACTION CONTROLP
          CASE
             WHEN INFIELD(o)
                CALL cl_init_qry_var()
                LET g_qryparam.form = 'q_aaa3'
                LET g_qryparam.default1 = tm.o
                CALL cl_create_qry() RETURNING tm.o
                DISPLAY tm.o TO FORMONLY.o
                NEXT FIELD o
             WHEN INFIELD(npr00)   
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_aag"
                LET g_qryparam.state = "c"
                LET g_qryparam.where = " aag00 = '",tm.o CLIPPED,"'"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO FORMONLY.npr00
                NEXT FIELD npr00
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
    #FUN-B20054--add--end 
       
# FUN-A40009 --begin                                     
#    IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW axrq711_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
#      EXIT PROGRAM
#   END IF
#No.FUN-A40009 --end
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
              WHERE zz01='axrq711'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axrq711','9031',1)
       ELSE
          LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                          " '",g_pdate  CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                          " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                          " '",g_bgjob  CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.wc    CLIPPED,"'" ,
                          " '",tm.yy    CLIPPED,"'" ,
                          " '",tm.m1    CLIPPED,"'" ,
                          " '",tm.m2    CLIPPED,"'" ,
                          " '",tm.o     CLIPPED,"'",
                          " '",tm.b     CLIPPED,"'",
                          " '",tm.d     CLIPPED,"'",
                          " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                          " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                          " '",g_template CLIPPED,"'",           #No.FUN-570264
                          " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
          CALL cl_cmdat('axrq711',g_time,l_cmd)    # Execute cmd at later time
       END IF
       CLOSE WINDOW axrq711_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
       EXIT PROGRAM
#    END IF
    END IF             #No.FUN-A40009
    CALL cl_wait()
    CALL axrq711()
    ERROR ""
    EXIT WHILE
END WHILE
   CLOSE WINDOW axrq711_w
#No.FUN-A40009 --begin  
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF           
#No.FUN-A40009 --end 
   #No.FUN-850030  --Begin
   IF tm.b = 'Y' THEN
      CALL cl_set_comp_visible("pb_balf,pb_bal,npr11_pb",TRUE)
      CALL cl_set_comp_visible("npr11,df,d,cf,c,balf,bal",TRUE)
      CALL cl_set_comp_visible("npr11_d,npr11_c,npr11_bal",TRUE)
      CALL cl_getmsg("ggl-216",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pb_balf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-217",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pb_bal",g_msg CLIPPED)
      CALL cl_getmsg("ggl-201",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("df",g_msg CLIPPED)
      CALL cl_getmsg("ggl-202",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-203",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("cf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-204",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-218",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("balf",g_msg CLIPPED)
      CALL cl_getmsg("ggl-219",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   ELSE
      CALL cl_set_comp_visible("pb_balf,npr11_pb",FALSE)
      CALL cl_set_comp_visible("npr11,df,cf,balf",FALSE)
      CALL cl_set_comp_visible("npr11_d,npr11_c,npr11_bal",FALSE)
      CALL cl_getmsg("ggl-220",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pb_bal",g_msg CLIPPED)
      CALL cl_getmsg("ggl-207",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("d",g_msg CLIPPED)
      CALL cl_getmsg("ggl-208",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("c",g_msg CLIPPED)
      CALL cl_getmsg("ggl-221",g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("bal",g_msg CLIPPED)
   END IF
   LET g_npr00 = NULL
   LET g_aag02 = NULL
   LET g_npr05 = NULL
   CLEAR FORM
   CALL g_npr.clear()
   CALL axrq711_cs()
   #No.FUN-850030  --End  
END FUNCTION
 
FUNCTION axrq711()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
          l_i       LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_str     STRING,                       #No.FUN-7B0026
          l_qcyef   LIKE npr_file.npr06f,
          l_qcye    LIKE npr_file.npr06f,
          m_npr06f  LIKE npr_file.npr06f,
          m_npr07f  LIKE npr_file.npr07f,
          m_npr06  LIKE npr_file.npr06f,
          m_npr07  LIKE npr_file.npr07f,
          #No.FUN-850030  --Begin
          l_npr06f  LIKE npr_file.npr06f,
          l_npr07f  LIKE npr_file.npr07f,
          l_npr06  LIKE npr_file.npr06f,
          l_npr07  LIKE npr_file.npr07f,
          sr1       RECORD
                    npr00    LIKE npr_file.npr00,
                    npr01    LIKE npr_file.npr01,
                    npr02    LIKE npr_file.npr02,
                    npr11    LIKE npr_file.npr11 
                    END RECORD,
          sr        RECORD
                    npr00    LIKE npr_file.npr00,  #科目
                    npr05    LIKE npr_file.npr05,  #期
                    npr01    LIKE npr_file.npr01,  #客戶
                    npr02    LIKE npr_file.npr02,  #簡稱
                    npr11    LIKE npr_file.npr11,  #幣種
                    npr06f   LIKE npr_file.npr06f,
                    npr06   LIKE npr_file.npr06,
                    npr07f   LIKE npr_file.npr07f,
                    npr07   LIKE npr_file.npr07,
                    qcyef    LIKE npr_file.npr06f,
                    qcye     LIKE npr_file.npr06f,
                    df_y     LIKE npr_file.npr06f,
                    d_y      LIKE npr_file.npr06f,
                    cf_y     LIKE npr_file.npr06f,
                    c_y      LIKE npr_file.npr06f
                    END RECORD
          #No.FUN-850030  --End  
 
     #No.FUN-850030  --Begin
     LET g_prog = 'axrr711'
     CALL axrq711_table()
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
     #No.FUN-850030  --End  
 
     IF tm.b = 'N' THEN                                                                                                              
        LET l_name = 'axrq711'
     ELSE                                                                                                                            
        LET l_name = 'axrq711_1'
     END IF                 
     LET l_sql = " SELECT UNIQUE npr00,npr01,npr02,npr11 FROM npr_file ",
#                "  WHERE npr08 = '",g_ooz.ooz02p,"'", #TQC-670076  
                 "  WHERE (npr08 = '",g_ooz.ooz02p,"' OR npr08 IS NULL OR npr08 =' ')", #No.TQC-8B0035
                 "    AND npr09 = '",tm.o,"'",
                 "    AND ",tm.wc CLIPPED
 
     PREPARE axrq711_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrq711_curs1 CURSOR FOR axrq711_pr1
 
     LET l_sql1="SELECT npr00,npr05,npr01,npr02,npr11,SUM(npr06f),",
                "       SUM(npr06),SUM(npr07f),SUM(npr07),0,0,0,0,0,0 ",
                "  FROM npr_file ",
                " WHERE npr00 = ?   AND npr01 = ? ",
                "   AND npr02 = ?   AND npr11 = ? ",
                "   AND npr05 = ? ",
#               "   AND npr08 = '",g_ooz.ooz02p,"'",  #TQC-670076 
                "   AND (npr08 = '",g_ooz.ooz02p,"' OR npr08 IS NULL OR npr08 =' ')", #No.TQC-8B0035
                "   AND npr09 = '",tm.o,"'",
                "   AND npr04 = ",tm.yy,
                "   AND ",tm.wc CLIPPED,
                " GROUP BY npr00,npr05,npr01,npr02,npr11 ",
                " ORDER BY npr00,npr05,npr01,npr02,npr11 "
     PREPARE axrq711_prepare1 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrq711_cursd CURSOR FOR axrq711_prepare1
 
     LET g_pageno  = 0
     LET t_qcyef   = 0
     LET t_qcye    = 0
 
     CALL cl_outnam('axrr711') RETURNING l_name     #TQC-640197  #FUN-7B0026
     START REPORT axrq711_rep TO l_name
 
     FOREACH axrq711_curs1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH
       END IF
 
       #計算期初余額及期間異動
       LET g_null=''
       CALL q711_qcye_qjyd(sr1.npr01,sr1.npr02,sr1.npr00,sr1.npr11,tm.m1,tm.m2)
            RETURNING g_null
 
       IF tm.d = 'N' THEN   #期初為零且無異動不打印
          IF g_null = 'N' THEN
             CONTINUE FOREACH
          END IF
       END IF
 
       FOR l_i = tm.m1 TO tm.m2
           LET g_print = 'N'
           FOREACH axrq711_cursd USING sr1.npr00,sr1.npr01,sr1.npr02,
                                       sr1.npr11,l_i INTO sr.*
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,0)
                 EXIT FOREACH
              END IF
              LET g_print = 'Y'
              OUTPUT TO REPORT axrq711_rep(sr.*)
           END FOREACH
           IF g_print = 'N' THEN
              CALL q711_qcye_qjyd(sr1.npr01,sr1.npr02,sr1.npr00,
                                  sr1.npr11,l_i,l_i)
                   RETURNING g_null
              IF tm.d = 'N' THEN   #期初為零且無異動不打印
                 IF g_null = 'N' THEN
                    CONTINUE FOR
                 END IF
              END IF
              INITIALIZE sr.* TO NULL
              LET sr.npr00  = sr1.npr00
              LET sr.npr05  = l_i
              LET sr.npr01  = sr1.npr01
              LET sr.npr02  = sr1.npr02
              LET sr.npr11  = sr1.npr11
              LET sr.npr06f = 0
              LET sr.npr07f = 0
              LET sr.npr06 = 0
              LET sr.npr07 = 0
              OUTPUT TO REPORT axrq711_rep(sr.*)
           END IF
        END FOR
     END FOREACH
     FINISH REPORT axrq711_rep
END FUNCTION
 
REPORT axrq711_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(1)
          sr        RECORD
                    npr00    LIKE npr_file.npr00,  #科目
                    npr05    LIKE npr_file.npr05,  #期
                    npr01    LIKE npr_file.npr01,  #客戶
                    npr02    LIKE npr_file.npr02,  #簡稱
                    npr11    LIKE npr_file.npr11,  #幣種
                    npr06f   LIKE npr_file.npr06f,
                    npr06   LIKE npr_file.npr06,
                    npr07f   LIKE npr_file.npr07f,
                    npr07   LIKE npr_file.npr07,
                    qcyef    LIKE npr_file.npr06f,
                    qcye     LIKE npr_file.npr06f,
                    df_y     LIKE npr_file.npr06f,
                    d_y      LIKE npr_file.npr06f,
                    cf_y     LIKE npr_file.npr06f,
                    c_y      LIKE npr_file.npr06f
                    END RECORD,
          l_cnt                        LIKE type_file.num5,
          l_npr06f                     LIKE npr_file.npr06f,
          l_npr07f                     LIKE npr_file.npr07f,
          l_npr06                     LIKE npr_file.npr06f,
          l_npr07                     LIKE npr_file.npr07f,
          t_bal,t_balf                 LIKE npr_file.npr06f,#期末
	  n_bal,n_balf                 LIKE npr_file.npr06f,
          n_pb_bal,n_pb_balf           LIKE npr_file.npr06f,
          l_pb_dc                      LIKE type_file.chr10,
          pb_bal,pb_balf               LIKE npr_file.npr06f,#期初
          tt_pb_bal,tt_pb_balf         LIKE npr_file.npr06f,
          tt_bal                       LIKE npr_file.npr06f,
          l_d,l_df,l_c,l_cf            LIKE npr_file.npr06f,
          y_d,y_df,y_c,y_cf            LIKE npr_file.npr06f,  #合計
          y_pb_bal,y_bal               LIKE npr_file.npr06f,  #合計
          l_npr11_c,l_npr11_d          LIKE npq_file.npq25,
          l_npr11_pb,l_npr11_bal       LIKE npq_file.npq25,
          l_dc                         LIKE type_file.chr10,
          pb_dc                        LIKE type_file.chr10
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.npr00,sr.npr05,sr.npr01,sr.npr02,sr.npr11
  FORMAT
   PAGE HEADER
        LET g_pageno = g_pageno + 1
 
   BEFORE GROUP OF sr.npr00     
      SELECT aag02 INTO l_aag02 FROM aag_file
       WHERE aag00 = tm.o
         AND aag01 = sr.npr00
 
   BEFORE GROUP OF sr.npr05
      LET y_pb_bal = 0
      LET y_bal = 0
 
   BEFORE GROUP OF sr.npr02
      LET tt_pb_bal  = 0   #期初BY客戶匯總 tm.b = 'Y'
      LET tt_bal     = 0   #期末BY客戶匯總 tm.b = 'Y'
 
      IF tm.b = 'N' THEN  #不打印外幣
         #期初余額 pb_dc,pb_bal
         LET l_npr06f = 0  LET l_npr07f = 0
         LET l_npr06 = 0  LET l_npr07 = 0
         SELECT SUM(npr06),SUM(npr07)  #期初余額
           INTO l_npr06,l_npr07
           FROM npr_file
          WHERE npr00 = sr.npr00 
            AND npr01 = sr.npr01 AND npr02 = sr.npr02
            AND npr04 = tm.yy         AND npr05 < sr.npr05
#           AND npr08 = g_ooz.ooz02p  AND npr09 = tm.o
            AND (npr08 = g_ooz.ooz02p OR npr08 IS NULL OR npr08 =' ')  AND npr09 = tm.o       #No.TQC-8B0035
         IF cl_null(l_npr06) THEN LET l_npr06 = 0 END IF
         IF cl_null(l_npr07) THEN LET l_npr07 = 0 END IF
         LET pb_bal  = l_npr06 - l_npr07
      END IF
 
   ON EVERY ROW
      IF tm.b = 'Y' THEN
         #期初余額 pb_dc,pb_balf,pb_bal
         LET l_npr06f = 0  LET l_npr07f = 0
         LET l_npr06 = 0  LET l_npr07 = 0
         SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07)  #期初余額
           INTO l_npr06f,l_npr07f,l_npr06,l_npr07
           FROM npr_file
          WHERE npr00 = sr.npr00 
            AND npr01 = sr.npr01 AND npr02 = sr.npr02
            AND npr11 = sr.npr11
            AND npr04 = tm.yy         AND npr05 < sr.npr05
#           AND npr08 = g_ooz.ooz02p  AND npr09 = tm.o
            AND (npr08 = g_ooz.ooz02p OR npr08 IS NULL OR npr08 =' ')  AND npr09 = tm.o       #No.TQC-8B0035
         IF cl_null(l_npr06f) THEN LET l_npr06f = 0 END IF
         IF cl_null(l_npr07f) THEN LET l_npr07f = 0 END IF
         IF cl_null(l_npr06) THEN LET l_npr06 = 0 END IF
         IF cl_null(l_npr07) THEN LET l_npr07 = 0 END IF
         LET pb_balf = l_npr06f - l_npr07f
         LET pb_bal  = l_npr06 - l_npr07
         IF pb_bal > 0 THEN
            LET n_pb_bal = pb_bal
            LET n_pb_balf= pb_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
         ELSE
            IF pb_bal = 0 THEN
               LET n_pb_bal = pb_bal
               LET n_pb_balf= pb_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
            ELSE
               LET n_pb_bal = pb_bal * -1
               LET n_pb_balf= pb_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
            END IF
         END IF
 
         LET tt_pb_balf = tt_pb_balf + pb_balf
         LET tt_pb_bal  = tt_pb_bal  + pb_bal 
         LET y_pb_bal = y_pb_bal + pb_bal
 
         #期間
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file    
          WHERE azi01 = sr.npr11
         IF cl_null(sr.npr06f) THEN LET sr.npr06f = 0 END IF
         IF cl_null(sr.npr07f) THEN LET sr.npr07f = 0 END IF
         IF cl_null(sr.npr06) THEN LET sr.npr06 = 0 END IF
         IF cl_null(sr.npr07) THEN LET sr.npr07 = 0 END IF
 
         #期末
         LET t_bal   = sr.npr06 - sr.npr07 + pb_bal
         LET t_balf  = sr.npr06f - sr.npr07f + pb_balf
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            LET n_balf= t_balf
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               LET n_balf= t_balf
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               LET n_balf= t_balf* -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
 
         LET tt_bal  = tt_bal  + t_bal
         #type = '2' #本期
#No.MOD-920186 add by liuxqa --begin--
         LET l_npr11_d = sr.npr06 / sr.npr06f
         LET l_npr11_c = sr.npr07 / sr.npr07f
         LET l_npr11_bal = n_bal / n_balf
         LET l_npr11_pb  = n_pb_bal / n_pb_balf
#         LET l_npr11_d = sr.npr06f / sr.npr06
#         LET l_npr11_c = sr.npr07f / sr.npr07
#         LET l_npr11_bal = n_balf / n_bal
#         LET l_npr11_pb  = n_pb_balf / n_pb_bal
#No.MOD-920186 add by liuxqa --end--
         IF cl_null(l_npr11_pb)  THEN LET l_npr11_pb  = 0 END IF
         IF cl_null(l_npr11_bal) THEN LET l_npr11_bal = 0 END IF
         IF cl_null(l_npr11_d) THEN LET l_npr11_d = 0 END IF
         IF cl_null(l_npr11_c) THEN LET l_npr11_c = 0 END IF
         INSERT INTO axrq711_tmp
         VALUES(sr.npr00,l_aag02,sr.npr05,sr.npr01,sr.npr02,sr.npr11,'2',
                l_pb_dc,n_pb_balf,l_npr11_pb,n_pb_bal,
                '',sr.npr06f,l_npr11_d,sr.npr06,sr.npr07f,l_npr11_c,sr.npr07,
                l_dc,n_balf,l_npr11_bal,n_bal,
                t_azi04,t_azi05,t_azi07)
         PRINT
      END IF
 
   AFTER GROUP OF sr.npr02
      IF tm.b = 'N' THEN
         #期初
         IF pb_bal > 0 THEN
            LET n_pb_bal = pb_bal
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
         ELSE
            IF pb_bal = 0 THEN
               LET n_pb_bal = pb_bal
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
            ELSE
               LET n_pb_bal = pb_bal * -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
            END IF
         END IF
 
         LET y_pb_bal = y_pb_bal + pb_bal
 
         #期間
         LET l_d = GROUP SUM(sr.npr06) 
         LET l_c = GROUP SUM(sr.npr07) 
         IF cl_null(l_d)  THEN LET l_d  = 0 END IF
         IF cl_null(l_c)  THEN LET l_c  = 0 END IF
 
         #期末
         LET t_bal   = l_d  - l_c  + pb_bal
 
         IF t_bal > 0 THEN
            LET n_bal = t_bal
            CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
         ELSE
            IF t_bal = 0 THEN
               LET n_bal = t_bal
               CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
            ELSE
               LET n_bal = t_bal * -1
               CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
            END IF
         END IF
 
         #type = '2' #本期
         INSERT INTO axrq711_tmp
         VALUES(sr.npr00,l_aag02,sr.npr05,sr.npr01,sr.npr02,'','2',
                l_pb_dc,0,0,n_pb_bal,
                '',0,0,l_d,0,0,l_c,
                l_dc,0,0,n_bal,
                t_azi04,t_azi05,t_azi07)
         PRINT
      ELSE
         LET l_cnt = GROUP COUNT(*)
         IF l_cnt > 1 THEN
            #打印客戶小計
            #期初
            IF tt_pb_bal > 0 THEN
               LET n_pb_bal = tt_pb_bal
               CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
            ELSE
               IF tt_pb_bal = 0 THEN
                  LET n_pb_bal = tt_pb_bal
                  CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
               ELSE
                  LET n_pb_bal = tt_pb_bal * -1
                  CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
               END IF
            END IF
 
            #期間
            LET l_d = GROUP SUM(sr.npr06) 
            LET l_c = GROUP SUM(sr.npr07) 
            IF cl_null(l_d)  THEN LET l_d  = 0 END IF
            IF cl_null(l_c)  THEN LET l_c  = 0 END IF
 
            #期末
            LET t_bal   = l_d  - l_c  + tt_pb_bal
 
            IF t_bal > 0 THEN
               LET n_bal = t_bal
               CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
            ELSE
               IF t_bal = 0 THEN
                  LET n_bal = t_bal
                  CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
               ELSE
                  LET n_bal = t_bal * -1
                  CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
               END IF
            END IF
 
            #type = '3' #客戶合計
            CALL cl_getmsg('ggl-222',g_lang) RETURNING g_msg
            INSERT INTO axrq711_tmp
            VALUES(sr.npr00,l_aag02,sr.npr05,sr.npr01,sr.npr02,'','3',
                   l_pb_dc,0,0,n_pb_bal,
                   g_msg,0,0,l_d,0,0,l_c,
                   l_dc,0,0,n_bal,
                   t_azi04,t_azi05,t_azi07)
         END IF
      END IF
 
   AFTER GROUP OF sr.npr05
      #期初
      IF y_pb_bal > 0 THEN
         LET n_pb_bal = y_pb_bal
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_pb_dc
      ELSE
         IF y_pb_bal = 0 THEN
            LET n_pb_bal = y_pb_bal
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_pb_dc
         ELSE
            LET n_pb_bal = y_pb_bal * -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_pb_dc
         END IF
      END IF
 
      LET y_d = GROUP SUM(sr.npr06) 
      LET y_c = GROUP SUM(sr.npr07) 
      IF cl_null(y_d)  THEN LET y_d  = 0 END IF
      IF cl_null(y_c)  THEN LET y_c  = 0 END IF
 
      #期末
      LET t_bal   = y_d  - y_c  + y_pb_bal
      IF t_bal > 0 THEN
         LET n_bal = t_bal
         CALL cl_getmsg('ggl-211',g_lang) RETURNING l_dc
      ELSE
         IF t_bal = 0 THEN
            LET n_bal = t_bal
            CALL cl_getmsg('ggl-210',g_lang) RETURNING l_dc
         ELSE
            LET n_bal = t_bal * -1
            CALL cl_getmsg('ggl-212',g_lang) RETURNING l_dc
         END IF
      END IF
      CALL cl_getmsg('ggl-223',g_lang) RETURNING g_msg
      INSERT INTO axrq711_tmp
      VALUES(sr.npr00,l_aag02,sr.npr05,sr.npr01,sr.npr02,'','4',
             l_pb_dc,0,0,n_pb_bal,
             g_msg,0,0,y_d,0,0,y_c,
             l_dc,0,0,n_bal,
             t_azi04,t_azi05,t_azi07)
 
END REPORT
 
FUNCTION axrq711_table()
     DROP TABLE axrq711_tmp;
     CREATE TEMP TABLE axrq711_tmp(
                    npr00       LIKE npr_file.npr00,
                    aag02       LIKE aag_file.aag02,
                    npr05       LIKE npr_file.npr05,
                    npr01       LIKE npr_file.npr01,
                    npr02       LIKE npr_file.npr02,
                    npr11       LIKE npr_file.npr11,
                    type        LIKE type_file.chr1,
                    pb_dc       LIKE type_file.chr10,
                    pb_balf     LIKE npr_file.npr06,
                    npr11_pb    LIKE npq_file.npq25,
                    pb_bal      LIKE npr_file.npr06,
                    memo        LIKE type_file.chr50,
                    df          LIKE npr_file.npr06,
                    npr11_d     LIKE npq_file.npq25,
                    d           LIKE npr_file.npr06,
                    cf          LIKE npr_file.npr06,
                    npr11_c     LIKE npq_file.npq25,
                    c           LIKE npr_file.npr06,
                    dc          LIKE type_file.chr10,
                    balf        LIKE npr_file.npr06,
                    npr11_bal   LIKE npq_file.npq25,
                    bal         LIKE npr_file.npr06,
                    azi04       LIKE azi_file.azi04,
                    azi05       LIKE azi_file.azi05,
                    azi07       LIKE azi_file.azi07);
END FUNCTION
 
FUNCTION q711_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680126 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npr TO s_npr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION drill_detail
         LET g_action_choice="drill_detail"
         EXIT DISPLAY
 
      ON ACTION first
         CALL axrq711_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION previous
         CALL axrq711_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION jump
         CALL axrq711_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION next
         CALL axrq711_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY  
 
      ON ACTION last
         CALL axrq711_fetch('L')
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
 
#No.FUN-850030  --End  
 
FUNCTION axrq711_cs()
     LET g_sql = "SELECT UNIQUE npr00,aag02,npr05 FROM axrq711_tmp ",
                 " ORDER BY npr00,aag02,npr05"
     PREPARE axrq711_ps FROM g_sql
     DECLARE axrq711_curs SCROLL CURSOR WITH HOLD FOR axrq711_ps
 
     LET g_sql = "SELECT UNIQUE npr00,aag02,npr05 FROM axrq711_tmp ",
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE axrq711_ps1 FROM g_sql
     EXECUTE axrq711_ps1
 
     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE axrq711_ps2 FROM g_sql
     DECLARE axrq711_cnt CURSOR FOR axrq711_ps2
 
     OPEN axrq711_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN axrq711_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     ELSE
        OPEN axrq711_cnt 
        FETCH axrq711_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL axrq711_fetch('F')
     END IF
END FUNCTION
 
FUNCTION axrq711_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680126 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680126 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     axrq711_curs INTO g_npr00,g_aag02,g_npr05
      WHEN 'P' FETCH PREVIOUS axrq711_curs INTO g_npr00,g_aag02,g_npr05
      WHEN 'F' FETCH FIRST    axrq711_curs INTO g_npr00,g_aag02,g_npr05
      WHEN 'L' FETCH LAST     axrq711_curs INTO g_npr00,g_aag02,g_npr05
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
         #CKP3
         END IF
         FETCH ABSOLUTE g_jump axrq711_curs INTO g_npr00,g_aag02,g_npr05
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_npr00,SQLCA.sqlcode,0)
      INITIALIZE g_npr00 TO NULL
      INITIALIZE g_aag02 TO NULL
      INITIALIZE g_npr05 TO NULL
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
 
   CALL axrq711_show()
END FUNCTION
 
FUNCTION axrq711_show()
 
   DISPLAY g_npr00 TO npr00
   DISPLAY g_aag02 TO aag02
   DISPLAY tm.yy   TO yy
   DISPLAY g_npr05 TO mm
 
   CALL axrq711_b_fill()
 
   CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION axrq711_b_fill()                     #BODY FILL UP
  DEFINE  l_npq06    LIKE npq_file.npq06
  DEFINE  l_type     LIKE type_file.chr1
  DEFINE  l_memo     LIKE abb_file.abb04 
 
   LET g_sql = "SELECT npr01,npr02,npr11,",
               "       pb_dc,pb_balf,npr11_pb,pb_bal,",
               "       df,npr11_d,d,cf,npr11_c,c,",
               "       dc,balf,npr11_bal,bal,",
               "       azi04,azi05,azi07,type,memo ",
               " FROM axrq711_tmp",
               " WHERE npr00 ='",g_npr00,"'",
               "   AND npr05 ='",g_npr05,"'",
               " ORDER BY npr01,npr02,npr11,type "
 
   PREPARE axrq711_pb FROM g_sql
   DECLARE npr_curs  CURSOR FOR axrq711_pb        #CURSOR
 
   CALL g_npr.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH npr_curs INTO g_npr[g_cnt].*,t_azi04,t_azi05,t_azi07,l_type,l_memo
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_npr[g_cnt].d      = cl_numfor(g_npr[g_cnt].d,20,g_azi04)
      LET g_npr[g_cnt].c      = cl_numfor(g_npr[g_cnt].c,20,g_azi04)
      LET g_npr[g_cnt].bal    = cl_numfor(g_npr[g_cnt].bal,20,g_azi04)
      LET g_npr[g_cnt].pb_bal = cl_numfor(g_npr[g_cnt].pb_bal,20,g_azi04)
 
      LET g_npr[g_cnt].df     = cl_numfor(g_npr[g_cnt].df,20,t_azi04)
      LET g_npr[g_cnt].cf     = cl_numfor(g_npr[g_cnt].cf,20,t_azi04)
      LET g_npr[g_cnt].balf   = cl_numfor(g_npr[g_cnt].balf,20,t_azi04)
      LET g_npr[g_cnt].pb_balf= cl_numfor(g_npr[g_cnt].pb_balf,20,t_azi04)
 
      LET g_npr[g_cnt].npr11_d= cl_numfor(g_npr[g_cnt].npr11_d,20,t_azi07)
      LET g_npr[g_cnt].npr11_c= cl_numfor(g_npr[g_cnt].npr11_c,20,t_azi07)
      LET g_npr[g_cnt].npr11_bal= cl_numfor(g_npr[g_cnt].npr11_bal,20,t_azi07)
      LET g_npr[g_cnt].npr11_pb = cl_numfor(g_npr[g_cnt].npr11_pb,20,t_azi07)
      ##外幣時,外幣匯總沒有意義
      #IF l_type = '1' THEN
      #   LET g_npr[g_cnt].d = NULL
      #   LET g_npr[g_cnt].df= NULL
      #   LET g_npr[g_cnt].npr11_d= NULL
      #   LET g_npr[g_cnt].c = NULL
      #   LET g_npr[g_cnt].cf = NULL
      #   LET g_npr[g_cnt].npr11_c= NULL
      #   LET g_npr[g_cnt].balf= NULL
      #   LET g_npr[g_cnt].npr11_bal = NULL
      #   LET g_npr[g_cnt].npr01 = NULL
      #   LET g_npr[g_cnt].npr02 = l_memo
      #END IF
      IF l_type = '3' OR l_type = '4' THEN
         LET g_npr[g_cnt].df = NULL
         LET g_npr[g_cnt].npr11_d= NULL
         LET g_npr[g_cnt].cf = NULL
         LET g_npr[g_cnt].npr11_c= NULL
         LET g_npr[g_cnt].balf = NULL
         LET g_npr[g_cnt].npr11_bal = NULL
         LET g_npr[g_cnt].pb_balf = NULL
         LET g_npr[g_cnt].npr11_pb  = NULL
         IF l_type = '3' THEN
            #客戶小計
            LET g_npr[g_cnt].npr01 = g_npr[g_cnt].npr01 CLIPPED,"(",g_npr[g_cnt].npr02 CLIPPED,")"
         ELSE
            #單身合計
            LET g_npr[g_cnt].npr01 = NULL
         END IF
         LET g_npr[g_cnt].npr02 = l_memo
      END IF
      IF l_type = '2' THEN
         IF tm.b = 'N' THEN
            LET g_npr[g_cnt].balf= NULL
            LET g_npr[g_cnt].npr11_bal = NULL
            LET g_npr[g_cnt].pb_balf= NULL
            LET g_npr[g_cnt].npr11_pb  = NULL
         END IF
      END IF
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_npr.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
 
END FUNCTION
 
FUNCTION q711_qcye_qjyd(p_npr01,p_npr02,p_npr00,p_npr11,p_m1,p_m2)
  DEFINE p_npr01       LIKE npr_file.npr01
  DEFINE p_npr02       LIKE npr_file.npr02
  DEFINE p_npr00       LIKE npr_file.npr00
  DEFINE p_npr11       LIKE npr_file.npr11
  DEFINE p_m1          LIKE npr_file.npr05
  DEFINE p_m2          LIKE npr_file.npr05
  DEFINE l_qcye        LIKE npr_file.npr06f
  DEFINE l_qcyef       LIKE npr_file.npr06f
  DEFINE m_npr06f      LIKE npr_file.npr06f
  DEFINE m_npr07f      LIKE npr_file.npr06f
  DEFINE m_npr06      LIKE npr_file.npr06f
  DEFINE m_npr07      LIKE npr_file.npr06f
  DEFINE l_flag        LIKE type_file.chr1
 
       LET l_flag = 'Y'   #有異動
       #期初余額
       SELECT SUM(npr06f-npr07f),SUM(npr06-npr07)  #期初余額
         INTO l_qcyef,l_qcye
         FROM npr_file
        WHERE npr00 = p_npr00 AND npr01 = p_npr01
          AND npr02 = p_npr02 AND npr11 = p_npr11
          AND npr04 = tm.yy         AND npr05 < p_m1 
#         AND npr08 = g_ooz.ooz02p  AND npr09 = tm.o
          AND (npr08 = g_ooz.ooz02p OR npr08 IS NULL OR npr08 =' ')  AND npr09 = tm.o       #No.TQC-8B0035
       IF cl_null(l_qcyef)  THEN LET l_qcyef = 0 END IF
       IF cl_null(l_qcye )  THEN LET l_qcye  = 0 END IF
 
       #期間異動
       SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07)  #期間余額
         INTO m_npr06f,m_npr07f,m_npr06,m_npr07
         FROM npr_file
        WHERE npr00 = p_npr00 AND npr01 = p_npr01
          AND npr02 = p_npr02 AND npr11 = p_npr11
          AND npr04 = tm.yy         AND npr05 BETWEEN p_m1 AND p_m2
#         AND npr08 = g_ooz.ooz02p  AND npr09 = tm.o  #TQC-670076
          AND (npr08 = g_ooz.ooz02p OR npr08 IS NULL OR npr08 =' ')  AND npr09 = tm.o       #No.TQC-8B0035
       IF cl_null(m_npr06f) THEN LET m_npr06f = 0 END IF
       IF cl_null(m_npr07f) THEN LET m_npr07f = 0 END IF
       IF cl_null(m_npr06) THEN LET m_npr06 = 0 END IF
       IF cl_null(m_npr07) THEN LET m_npr07 = 0 END IF
 
       IF tm.b = 'N'   AND l_qcye = 0 AND      #本幣
          m_npr06 = 0 AND m_npr07 = 0 THEN
          LET l_flag = 'N'                     #期初為零且無異動
       END IF
       IF tm.b='Y' AND l_qcyef=0 AND l_qcye=0 AND m_npr06f=0   #外幣
          AND m_npr07f=0  AND m_npr06=0 AND m_npr07=0 THEN
          LET l_flag = 'N'                     #期初為零且無異動
       END IF
 
       RETURN l_flag
 
END FUNCTION
 
FUNCTION q711_out_1()
   LET g_prog = 'axrq711'
   LET g_sql = "npr00.npr_file.npr00,",
               "aag02.aag_file.aag02,",
               "npr05.npr_file.npr05,",
               "npr01.type_file.chr50,",
               "npr02.npr_file.npr02,",
               "npr11.npr_file.npr11,",
               "type.type_file.chr10,",
               "pb_dc.type_file.chr10,",
               "pb_balf.npr_file.npr06f,",
               "npr11_pb.npq_file.npq25,",
               "pb_bal.npr_file.npr06f,",
               "memo.abb_file.abb04,",
               "df.npr_file.npr06f,",
               "npr11_d.npq_file.npq25,",
               "d.npr_file.npr06f,",
               "cf.npr_file.npr06f,",
               "npr11_c.npq_file.npq25,",
               "c.npr_file.npr06f,",
               "dc.type_file.chr10,",
               "balf.npr_file.npr06f,",
               "npr11_bal.npq_file.npq25,",
               "bal.npr_file.npr06f,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07 "
 
   LET l_table = cl_prt_temptable('axrq711',g_sql) CLIPPED
   IF  l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ? )               "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
END FUNCTION
 
FUNCTION q711_out_2()
 
   LET g_prog = 'axrq711'
   CALL cl_del_data(l_table)                       #NO.FUN-7B0026
 
   DECLARE cr_curs CURSOR FOR 
    SELECT * FROM axrq711_tmp
   FOREACH cr_curs INTO g_pr.*
       EXECUTE insert_prep USING g_pr.*
   END FOREACH
 
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
   IF g_zz05='Y' THEN 
      CALL cl_wcchp(tm.wc,'npr01,npr00')
           RETURNING g_str 
   END IF
   LET g_str=g_str CLIPPED,";",tm.yy,";",g_azi04
             
   IF tm.b = 'N' THEN 
      CALL cl_prt_cs3('axrq711','axrq711',g_sql,g_str)
   ELSE
      CALL cl_prt_cs3('axrq711','axrq711_1',g_sql,g_str)
   END IF
END FUNCTION
 
FUNCTION q711_drill_detail()
   DEFINE 
         #l_wc    LIKE type_file.chr50
          l_wc         STRING       #NO.FUN-910082
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
 
   IF cl_null(g_npr00) THEN RETURN END IF  #科目
   IF l_ac = 0 THEN RETURN END IF
   IF cl_null(g_npr[l_ac].npr01) THEN RETURN END IF
 
   LET l_wc = 'npq21 = "',g_npr[l_ac].npr01,'" AND npq03 = "',g_npr00,'"'
   CALL s_azn01(tm.yy,g_npr05) RETURNING l_bdate,l_edate
   LET l_bdate = MDY(g_npr05,1,tm.yy)
 
   LET g_msg = "axrq710 '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",tm.o,"' 'N' 'N' '1' '",tm.d,"' '' '' '' ''"   #No.MOD-B50172 add N
   CALL cl_cmdrun(g_msg)
 
END FUNCTION
