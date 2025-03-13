# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: apmx001.4gl
# Descriptions...: 已發出彩購單未全部交貨明細表
# Date & Author..: 01/03/15 By Wiky
# Modify.........: No.FUN-4B0022 04/11/04 By Yuna 新增採購單號,採購人員開窗
# Modify.........: No.FUN-4C0095 04/12/21 By Mandy 報表轉XML
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-690108 06/11/16 By pengu 取消"結案"功能
# Modify.........: No.FUN-750093 07/06/06 By zhoufeng 報表打印改為Crystal Reports輸出
# Modify.........: No.MOD-7A0119 07/10/22 By claire 未交量若<0 LET 未交量=0
# Modify.........: No.FUN-7B0022 07/11/09 By claire 條件勾選default 'Y' 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990062 09/09/22 By mike 請於料號(pmn04)之后增加品名(pmn041)  
# Modify.........: No:MOD-9C0319 09/12/22 By sabrina 將l_sql型態改為STRING
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No.FUN-A10007 11/04/20 By suncx 報表增加顯示規格欄位
# Modify.........: No.FUN-9C0153 11/05/04 By lixiang 报表加入预计交期
# Modify.........: No.FUN-CB0001 12/11/01 By yangtt CR轉XtraGrid
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                    # Print condition RECORD
              wc      STRING,    #TQC-630166       # Where condition
              bdate   LIKE type_file.dat,          #No.FUN-680136 DATE
              edate   LIKE type_file.dat,          #No.FUN-680136 DATE 
              upd     LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1) 
             #b       VARCHAR(1),          #結案否          #No.TQC-690108 mark
              more    LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
              END RECORD,
       g_pmn  DYNAMIC ARRAY OF RECORD        #存pmn陣列
              pmn02  LIKE pmn_file.pmn02,    #項次
              pmn04  LIKE pmn_file.pmn04,    #料號
              pmn33  LIKE pmn_file.pmn33,    #预计交期 #No.FUN-9C0153
              pmn20  LIKE pmn_file.pmn20,    #訂購數量
              pmn50  LIKE pmn_file.pmn50,    #已交數量
              pmn55  LIKE pmn_file.pmn55,    #退驗量
              amount LIKE pmn_file.pmn55     #未交量
              END RECORD,
       l_cd   LIKE aaf_file.aaf03,          #No.FUN-680136 VARCHAR(40)
       l_i    LIKE type_file.num5,          #No.FUN-680136 SMALLINT
       l_cnt  LIKE type_file.num5,          #No.FUN-680136 SMALLINT
       l_cnt1 LIKE type_file.num5,          #No.FUN-680136 SMALLINT
       g_tot_bal LIKE tlf_file.tlf18        #No.FUN-680136 DECIMAL(13,3) # User defined variable
 
DEFINE g_i    LIKE type_file.num5           #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE g_sql   STRING                       #No.FUN-750093
DEFINE l_table STRING                       #No.FUN-750093
DEFINE g_str   STRING                       #No.FUN-750093
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
 
#No.FUN-750093 --start--
   LET g_sql="pmm01.pmm_file.pmm01,pmm04.pmm_file.pmm04,pmn02.pmn_file.pmn02,",
             "pmn04.pmn_file.pmn04,pmn041.pmn_file.pmn041,pmn33.pmn_file.pmn33,pmn20.pmn_file.pmn20,pmn50.pmn_file.pmn50,", #FUN-990062 add pmn041   #No.FUN-9C0153 add pmn33 
             "pmn55.pmn_file.pmn55,pmn82.pmn_file.pmn82,ima021.ima_file.ima021"  #FUN-A10007 add ima021
 
   LET l_table = cl_prt_temptable('apmx001',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   #LET g_sql = "INSERT INTO ds_report.", l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
               " VALUES(?,?,?,?,?,?,?,?,?,?,?)" #FUN-990062 add ?      #FUN-A10007 add ?  #No.FUN-9C0153 add ? 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-750093 --end--
 
   LET g_pdate = ARG_VAL(1)               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate=ARG_VAL(8)
   LET tm.edate=ARG_VAL(9)
   LET tm.upd  = ARG_VAL(10)
#----------No.TQC-690108 modify
  #LET tm.b  = ARG_VAL(11)
#-----------No.TQC-610085 modify
  #LET tm.more = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-----------No.TQC-610085 end
#----------No.TQC-690108 end
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'     # If background job sw is off
      THEN CALL apmx001_tm(0,0)             # Input print condition
      ELSE CALL apmx001()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION apmx001_tm(p_row,p_col)
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01        #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,       #No.FUN-680136 SMALLINT
          l_cmd        LIKE type_file.chr1000     #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 16
 
   OPEN WINDOW apmx001_w AT p_row,p_col WITH FORM "apm/42f/apmx001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
  #LET tm.b  = 'N'      #No.TQC-690108 mark
   LET tm.upd  = 'Y'    #FUN-7B0022 modify 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pmm01,pmm12
   #--No.FUN-4B0022-------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
   ON ACTION CONTROLP
     CASE WHEN INFIELD(pmm01)      #採購單號
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_pmm13"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmm01
               NEXT FIELD pmm01
           WHEN INFIELD(pmm12)      #採購人員
               CALL cl_init_qry_var()
               LET g_qryparam.state= "c"
               LET g_qryparam.form = "q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pmm12
               NEXT FIELD pmm12
 
     OTHERWISE EXIT CASE
     END CASE
   #--END---------------
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW apmx001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF tm.wc = '1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #--------No.TQC-690108 modify
  #DISPLAY BY NAME tm.upd,tm.b,tm.more         # Condition
 
  #INPUT BY NAME tm.bdate,tm.edate,tm.upd,tm.b,tm.more
   DISPLAY BY NAME tm.upd,tm.more         # Condition
 
   INPUT BY NAME tm.bdate,tm.edate,tm.upd,tm.more
  #--------No.TQC-690108 end
 
         WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
        IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN NEXT FIELD edate
        END IF
      AFTER FIELD upd
        IF tm.upd NOT MATCHES '[YN]' THEN NEXT FIELD upd END IF
     #-------------No.TQC-690108 mark
     #AFTER FIELD b
     #  IF tm.b NOT MATCHES '[YN]' THEN NEXT FIELD b END IF 
     #-------------No.TQC-690108 end
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW apmx001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='apmx001'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmx001','9031',1)
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
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.upd CLIPPED,"'",
                        #" '",tm.b CLIPPED,"'",                 #No.TQC-690108 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmx001',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW apmx001_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmx001()
   ERROR ""
END WHILE
   CLOSE WINDOW apmx001_w
END FUNCTION
 
FUNCTION apmx001()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680136 VARCHAR(20)
          l_time    LIKE type_file.chr8,          # Used time for running the job   #No.FUN-680136 VARCHAR(8)
          l_sql     STRING,                       #No.MOD-9C0319 chr1000 modify STRING 
          l_chr     LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-680136 VARCHAR(40)
          sr        RECORD 
                     pmm01  LIKE pmm_file.pmm01,    #採購單號
                     pmm04  LIKE pmm_file.pmm04,    #採購日期
                     pmn02  LIKE pmn_file.pmn02,    #項次
                     pmn04  LIKE pmn_file.pmn04,    #料號
                     pmn041 LIKE pmn_file.pmn041,   #品名 #FUN-990062      
                     pmn33  LIKE pmn_file.pmn33,    #预计交期 #No.FUN-9C0153
                     pmn20  LIKE pmn_file.pmn20,    #訂購數量
                     pmn50  LIKE pmn_file.pmn50,    #已交數量
                     pmn55  LIKE pmn_file.pmn55,    #退驗量
                     amount LIKE pmn_file.pmn55,    #未交量
                     pmn16  LIKE pmn_file.pmn16,    #狀況碼
                     pmm25  LIKE pmm_file.pmm25,    #狀況碼
                     ima021 LIKE ima_file.ima021    #規格   #FUN-A10007 add
                    END RECORD
     DEFINE l_count1    LIKE type_file.num5   #FUN-CB0001 add
     DEFINE l_count2    LIKE type_file.num5   #FUN-CB0001 add
     DEFINE sr_o   RECORD pmm01 LIKE pmm_file.pmm01 END RECORD #FUN-CB0001 add
 
     CALL cl_del_data(l_table)                      #No.FUN-750093 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
     #End:FUN-980030
 
     LET l_sql=" SELECT pmm01,pmm04,pmn02,pmn04,pmn041,pmn33,pmn20,pmn50,pmn55,", #FUN-990062 add pmn041  #No.FUN-9C0153 add pmn33
              #"       '',pmn16,pmm25",
               "       '',pmn16,pmm25,ima021",   #FUN-A10007 add
              #" FROM pmm_file,pmn_file",
               " FROM pmm_file,pmn_file LEFT JOIN ima_file ON pmn04 = ima01",   #FUN-A10007 add
               " WHERE pmm01 = pmn01",
               "   AND pmn16 = '2' ",    #已發出
               "   AND pmm04 between '",tm.bdate,"' AND '",tm.edate,"'",
               "   AND ",tm.wc CLIPPED,
               "   ORDER BY pmm01"   #FUN-CB0001
     PREPARE apmx001_p1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM 
     END IF
     DECLARE apmx001_c1 CURSOR FOR apmx001_p1
 
#     CALL cl_outnam('apmx001') RETURNING l_name       #No.FUN-750093
#     START REPORT apmx001_rep TO l_name
#     LET g_pageno = 0
#     LET l_cnt=0
#     LET l_i=0                                        #No.FUN-750093
     LET g_success='Y'
     LET l_count1 = 1   #FUN-CB0001 add
     LET l_count2 = 0   #FUN-CB0001 add
     LET sr_o.pmm01 = NULL #FUN-CB0001 add
     
     BEGIN WORK
     FOREACH apmx001_c1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach1:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
          EXIT PROGRAM 
       END IF
           LET sr.amount =sr.pmn20-(sr.pmn50-sr.pmn55)
           IF sr.amount < 0 THEN LET sr.amount = 0  END IF   #MOD-7A0119
           IF tm.upd='N' THEN
#              OUTPUT TO REPORT apmx001_rep(sr.*)       #No.FUN-750093
               #FUN-CB0001-----add---str--
               IF NOT cl_null(sr_o.pmm01) AND sr_o.pmm01 != sr.pmm01 THEN
                  LET l_count1 = l_count1 + 1
               END IF
               IF NOT cl_null(sr.pmn02) THEN
                  LET l_count2 = l_count2 + 1
               END IF
               LET sr_o.pmm01 = sr.pmm01
               #FUN-CB0001-----add---end--
#No.FUN-750093 --add--
              EXECUTE insert_prep USING sr.pmm01,sr.pmm04,sr.pmn02,sr.pmn04,
                                        sr.pmn041, #FUN-990062   
                                        sr.pmn33,  #No.FUN-9C0153 add
                                        sr.pmn20,sr.pmn50,sr.pmn55,sr.amount,
                                        sr.ima021  ##FUN-A10007 add
           ELSE
               IF tm.upd='Y' AND sr.amount>0 THEN
#                    OUTPUT TO REPORT apmx001_rep(sr.*) #No.FUN-750093
                  #FUN-CB0001-----add---str--
                  IF NOT cl_null(sr_o.pmm01) AND sr_o.pmm01 != sr.pmm01 THEN
                     LET l_count1 = l_count1 + 1
                  END IF
                  IF NOT cl_null(sr.pmn02) THEN
                     LET l_count2 = l_count2 + 1
                  END IF
                  LET sr_o.pmm01 = sr.pmm01
                  #FUN-CB0001-----add---end--
#No.FUN-750093 --add--                                                          
              EXECUTE insert_prep USING sr.pmm01,sr.pmm04,sr.pmn02,sr.pmn04, 
                                        sr.pmn041, #FUN-990062       
                                        sr.pmn33,  #No.FUN-9C0153  
                                        sr.pmn20,sr.pmn50,sr.pmn55,sr.amount,
                                        sr.ima021  ##FUN-A10007 add  
               ELSE
                    CONTINUE FOREACH
               END IF
           END IF
     END FOREACH
#     FINISH REPORT apmx001_rep                         #No.FUN-750093 
     IF g_success = 'Y' THEN
        COMMIT WORK
       # Prog. Version..: '5.30.07-13.05.16(0) END IF     #No.TQC-690108 mark
     ELSE
        ROLLBACK WORK 
       # Prog. Version..: '5.30.07-13.05.16(0) END IF     #No.TQC-690108 mark
     END IF
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-750093
#No.FUN-750093 --start--
    LET g_xgrid.table = l_table    ###XtraGrid###
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'pmm01,pmm12')
          RETURNING tm.wc
###XtraGrid###     LET g_str = tm.wc,";",tm.bdate,";",tm.edate
###XtraGrid###     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
###XtraGrid###     CALL cl_prt_cs3('apmx001','apmx001',l_sql,g_str)
    LET g_xgrid.grup_field = 'pmm01'  #FUN-CB0001 add
    LET g_xgrid.order_field = "pmm01,pmm04,pmn02"  #FUN-CB0001 add
    LET g_xgrid.headerinfo1 = cl_getmsg('apmx01',g_lang),':',tm.bdate,'-',tm.edate  #FUN-CB0001 add
    LET g_xgrid.footerinfo1 = cl_getmsg('apmx02',g_lang),':',l_count1,cl_getmsg('apmx03',g_lang),l_count2,
                              cl_getmsg('aap-417',g_lang)  #FUN-CB0001 add
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc   #FUN-CB0001 add
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-750093 --end--
END FUNCTION
#No.FUN-750093 --start-- --mark--
{REPORT apmx001_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
          sr        RECORD
                     pmm01  LIKE pmm_file.pmm01,    #採購單號
                     pmm04  LIKE pmm_file.pmm04,    #採購日期
                     pmn02  LIKE pmn_file.pmn02,    #項次
                     pmn04  LIKE pmn_file.pmn04,    #料號
                     pmn20  LIKE pmn_file.pmn20,    #訂購數量
                     pmn50  LIKE pmn_file.pmn50,    #已交數量
                     pmn55  LIKE pmn_file.pmn55,    #退驗量
                     amount LIKE pmn_file.pmn55,    #未交量
                     pmn16  LIKE pmn_file.pmn16,    #狀況碼
                     pmm25  LIKE pmm_file.pmm25     #狀況碼
                    END RECORD,
      l_n           LIKE ogd_file.ogd15,          #No.FUN-680136 DECIMAL(8,2)
      l_chr         LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
      i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
      l_k           LIKE type_file.num5,          #No.FUN-680136 SMALLINT
      l_count       LIKE type_file.num5           #No.FUN-680136 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.pmm01,sr.pmm04,sr.pmn02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET l_cd=g_x[11] CLIPPED,tm.bdate,"-",tm.edate
      PRINT l_cd
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38] #FUN-4C0095
      PRINT g_dash1 #FUN-4C0095
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.pmm01
       LET  l_cnt=l_cnt+1
       #FUN-4C0095
       PRINT COLUMN g_c[31],sr.pmm01 CLIPPED,         #列印單號,採購日期
             COLUMN g_c[32],sr.pmm04 CLIPPED;
       #FUN-4C0095(end)
       LET l_k=0
 
   ON EVERY ROW
      #----------No.TQC-690108 mark
      #IF tm.b='Y' AND sr.pmn16 !='6'THEN        #若結案否='Y'則更新pmm16='6'  
      #    UPDATE pmn_file SET pmn16='6'
      #    WHERE pmn01=sr.pmm01
      #    IF STATUS THEN LET g_success ='N' END IF
      #END IF
      #----------No.TQC-690108 end
       LET l_k=l_k+1
       LET l_i=l_i+1
       #FUN-4C0095
       PRINT  COLUMN g_c[33],sr.pmn02 USING '###&'  CLIPPED,
              COLUMN g_c[34],sr.pmn04 CLIPPED,
              COLUMN g_c[35],sr.pmn20 USING '#######.##' CLIPPED,
              COLUMN g_c[36],sr.pmn50 USING '#######.##' CLIPPED,
              COLUMN g_c[37],sr.pmn55 USING '#######.##' CLIPPED,
              COLUMN g_c[38],sr.amount USING '#######.##' CLIPPED
       #FUN-4C0095(end)
 
    AFTER GROUP OF sr.pmm01
      SELECT COUNT(*) INTO l_n FROM pmn_file         #單身筆數
       WHERE pmn01 = sr.pmm01
      SELECT COUNT(*) INTO l_count FROM pmn_file     #若單身全部結案,則pmm25='6'
       WHERE pmn01=sr.pmm01
         AND pmn16='6'
        #---------No.TQC-690108 mark
        #IF tm.b='Y' THEN
        #   IF l_count=l_n AND sr.pmm25 !='6'THEN
        #       UPDATE pmm_file SET pmm25='6'
        #        WHERE pmm01=sr.pmm01
        #       IF STATUS THEN LET g_success ='N' END IF
        #   END IF
        #END IF 
        #---------No.TQC-690108 end
 
   ON LAST ROW
      #FUN-4C0095
      PRINT g_dash1
      PRINT COLUMN g_c[32],g_x[19] CLIPPED,
            COLUMN g_c[33],l_cnt CLIPPED,
            COLUMN g_c[34],g_x[20] CLIPPED,
            COLUMN g_c[35],l_i CLIPPED,
            COLUMN g_c[36],g_x[21] CLIPPED
      PRINT g_dash
      #FUN-4C0095
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
        #CALL cl_wcchp(tm.wc,'pmm01')
        #     RETURNING tm.wc
        #    IF tm.wc[001,070] > ' ' THEN            # for 80
        #       PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
        #    IF tm.wc[071,140] > ' ' THEN
        #       PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
        #    IF tm.wc[141,210] > ' ' THEN
        #       PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
        #    IF tm.wc[211,280] > ' ' THEN
        #       PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
	#TQC-630166
	CALL cl_prt_pos_wc(tm.wc)
      END IF
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED #FUN-4C0095
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash #FUN-4C0095
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED #FUN-4C0095
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750093 --end--


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
