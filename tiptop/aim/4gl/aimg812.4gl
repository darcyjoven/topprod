# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aimg812.4gl
# Descriptions...: 空白標籤列印作業－在製工單
# Input parameter:
# Return code....:
# Date & Author..: 93/06/03 By Apple
# Modify.........: No.MOD-530085 05/02/17 By cate 報表標題標準化
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-750100 07/05/29 By pengu 表尾位置跑掉
# Modify.........: No.FUN-870060 08/07/10 By zhaijie報表轉為使用CR
# Modify.........: No.FUN-870144 08/07/29 By lutingting  報表轉CR追到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960065 09/11/10 By jan修改標簽別的開窗
# Modify.........: No.TQC-9B0038 09/11/10 By jan 修改程序BUG
# Modify.........: No.FUN-A60092 10/07/19 By lilingyu 平行工藝
# Modify.........: No.TQC-AC0207 10/12/16 By vealxu 拿掉標籤別﹧起始標籤﹧截止標籤 改成一個可QBE的"標籤編號"
# Modify.........: No.FUN-B50018 11/05/16 By xumm GR轉GRW 
# Modify.........: No.FUN-C20051 12/02/13 By yangtt GR調整
# Modify.........: No.FUN-D20064 13/02/20 By chenjing 修改全選報錯

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                         # Print condition RECORD
           #start FUN-5A0199
         # wip       LIKE pib_file.pib01, # 標籤別  #FUN-660078                          #TQC-AC0207 mark
         # wie       LIKE pib_file.pib01, # FUN-660078                                   #TQC-AC0207 mark
         # bno       LIKE pib_file.pib03, # 起始號碼 #No.FUN-690026 VARCHAR(10)          #TQC-AC0207 mark 
         # eno       LIKE pib_file.pib03, # 截止號碼 #No.FUN-690026 VARCHAR(10)          #TQC-AC0207 mark
           wc        STRING,              #TQC-AC0207   
           #end FUN-5A0199
           t         LIKE type_file.chr1,    # 是否依工作站跳頁  #No.FUN-690026 VARCHAR(1)
           cnt       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
           code      LIKE type_file.chr1,    # 是否列印條碼  #No.FUN-690026 VARCHAR(1)
           size      LIKE type_file.chr1,    # 是否套版列印  #No.FUN-690026 VARCHAR(1)
           yearstr   LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
           more      LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#NO.FUN-870060--START---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#NO.FUN-870060--END---
DEFINE  g_t1        LIKE oay_file.oayslip  #CHI-960065

###GENGRE###START
TYPE sr1_t RECORD
    pid01 LIKE pid_file.pid01,
    pid02 LIKE pid_file.pid02,
    pid012 LIKE pid_file.pid012,
    faj10  LIKE faj_file.faj10,        #FUN-B50018-ADD
    pmc03  LIKE pmc_file.pmc03,        #FUN-B50018-ADD
    ecb03 LIKE ecb_file.ecb03

END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
#NO.FUN-870060--start---
  LET g_sql = "pid01.pid_file.pid01,",
              "pid02.pid_file.pid02,",   #FUN-A60092 add ,
              "pid012.pid_file.pid012,", #FUN-A60092
              "ecb03.ecb_file.ecb03"     #FUN-A60092
  LET l_table = cl_prt_temptable('aimg812',g_sql) CLIPPED
  IF l_table = -1 THEN 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
     CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
     EXIT PROGRAM 
  END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?, ?,?)"   #FUN-A60092 add ?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF            
#NO.FUN-870060--end---
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
#TQC-AC0207 ------------------mark start--------------
#  LET tm.wip = ARG_VAL(7)
#  LET tm.wie = ARG_VAL(8)
#  LET tm.bno = ARG_VAL(9)
#  LET tm.eno = ARG_VAL(10)
#  LET tm.t   = ARG_VAL(11)
#  LET tm.cnt = ARG_VAL(12)
#  LET tm.code = ARG_VAL(13)
#  LET tm.size = ARG_VAL(14)
#  LET tm.yearstr = ARG_VAL(15)
#  #No.FUN-570264 --start--
#  LET g_rep_user = ARG_VAL(16)
#  LET g_rep_clas = ARG_VAL(17)
#  LET g_template = ARG_VAL(18)
#  #No.FUN-570264 ---end---
   LET tm.wc = ARG_VAL(7)
   LET tm.t  = ARG_VAL(8)
   LET tm.cnt = ARG_VAL(9)
   LET tm.code =ARG_VAL(10)
   LET tm.size =ARG_VAL(11)
   LET tm.yearstr = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
#TQC-AC0207 ---------------------mod end-------------------
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g812_tm(0,0)		# Input print condition
      ELSE CALL g812()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
   CALL cl_gre_drop_temptable(l_table) 
END MAIN
 
FUNCTION g812_tm(p_row,p_col)
   DEFINE p_row,p_col	   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_direct,l_flag  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_pib03          LIKE pib_file.pib03,
          l_cmd		   LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
  DEFINE stk_len           LIKE type_file.num5     #CHI-960065
  DEFINE l_len             LIKE type_file.num5     #CHI-960065
  DEFINE li_result         LIKE type_file.num5     #CHI-960065
  DEFINE l_pid01           LIKE pia_file.pia01     #CHI-960065

   LET p_row = 5 LET p_col = 30

   OPEN WINDOW g812_w AT p_row,p_col WITH FORM "aim/42f/aimg812"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.wc = '1=1'       #TQC-AC0207  
   LET tm.t    = 'N'
   LET tm.cnt  = 1
   LET tm.code = 'N'
   LET tm.size = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE

   #TQC-AC0207 --------------add start----------
   CONSTRUCT tm.wc ON pid01 FROM pid01
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

      ON ACTION CONTROLP
         IF INFIELD(pid01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pid01"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pid01
            NEXT FIELD pid01
         END IF
   END CONSTRUCT
   IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF

   IF cl_null(tm.wc) THEN
      LET tm.wc = '1=1'
   END IF
   #TQC-AC0207 -------------add end-------------

  #TQC-AC0207 ------------mod start-------------------------- 
  #INPUT BY NAME tm.wip,tm.wie,tm.bno,tm.eno,tm.cnt,tm.yearstr,tm.t,
  #              tm.code,tm.size,tm.more
  #             WITHOUT DEFAULTS
   INPUT BY NAME tm.cnt,tm.yearstr,tm.t,tm.code,tm.size,tm.more
              WITHOUT DEFAULTS
  #TQC-AC0207 -------------mod end----------------------
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT

#TQC-AC0207 --------------------mark start-----------------------
#     AFTER FIELD wip
#        IF tm.wip IS NULL OR tm.wip =' ' THEN
#           NEXT FIELD wip
#        ELSE 
##CHI-960065--begin--mod--------------------------------------------                                                                 
#           CALL s_check_no("aim",tm.wip,"","I","pid_file","pid01","")
#           RETURNING li_result,tm.wip
#           LET tm.wip = s_get_doc_no(tm.wip)
#           DISPLAY BY NAME tm.wip
#           IF (NOT li_result) THEN
#                NEXT FIELD wip
#             END IF
#           LET stk_len=LENGTH(tm.wip)
#           LET l_pid01= '' #TQC-9B0038
#           SELECT MAX(pid01) INTO l_pid01 FROM pid_file
#            WHERE Substr(pid01,1,stk_len) LIKE tm.wip
#           #TQC-9B0038--begin--add--------                                                                                         
#           IF cl_null(l_pid01) THEN                                                                                                
#              CALL cl_err3("sel","pid_file",tm.wip,"","mfg0107",                                                                   
#                           "","",1)                                                                                                
#              NEXT FIELD wip                                                                                                       
#           END IF                                                                                                                  
#           #TQC-9B0038--end--add------
#           LET l_len=length(l_pid01)
#           LET l_pib03 = l_pid01[stk_len+2,l_len]
##          SELECT pib03 INTO l_pib03 FROM pib_file
##                         WHERE pib01 = tm.wip
##            IF SQLCA.sqlcode THEN
###              CALL cl_err(tm.wip,'mfg0107',0)
##               CALL cl_err3("sel","pib_file",tm.wip,"","mfg0107",
##                            "","",0)  #No.FUN-660156
##               NEXT FIELD wip
##            END IF
#             LET tm.eno = l_pib03
#             DISPLAY BY NAME tm.eno
##CHI-960065--end--mod-----------------------------------------
#        END IF
#        LET tm.wie = tm.wip
#        DISPLAY BY NAME tm.wie
#
#     AFTER FIELD eno
#       	 IF tm.eno IS NOT NULL AND tm.eno < tm.bno  THEN
#       		CALL cl_err('','mfg1323',0)
#       		NEXT FIELD eno
#        END IF
#TQC-AC0207 ---------------------mark end----------------------------

      AFTER FIELD t
         IF tm.t IS NULL OR tm.t NOT MATCHES'[YNyn]' THEN
            NEXT FIELD t
         END IF

      AFTER FIELD cnt
         IF tm.cnt IS NULL OR tm.cnt = ' ' THEN
            LET tm.cnt = 1
            DISPLAY BY NAME tm.cnt
         END IF
         LET l_direct = 'D'

      BEFORE FIELD code    #列印條碼
        IF g_sma.sma07 MATCHES '[Nn]' THEN  #系統參數設定未與條碼系統連線
           IF l_direct='D' THEN
	      NEXT FIELD size
           ELSE
	    # NEXT FIELD eno    #TQC-AC0207 mark
              NEXT FIELD cnt   #TQC-AC0207
            END IF
         END IF
 
      AFTER FIELD code
         IF tm.code NOT MATCHES "[YN]" OR tm.code IS NULL
            THEN NEXT FIELD code
         END IF
 
      AFTER FIELD size
         IF tm.size IS NULL OR tm.size NOT MATCHES "[YNyn]"
            THEN NEXT FIELD size
         END IF
         LET l_direct ='U'

      AFTER FIELD more
         IF tm.more IS NULL OR tm.more NOT MATCHES "[YNyn]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
        AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF

#TQC-AC0207 ---------------mark start--------------------
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(wip)
##             CALL q_pib(8,3,tm.wip) RETURNING tm.wip
##             CALL FGL_DIALOG_SETBUFFER( tm.wip )
#CHI-960065--begin--mod----------------------------
##             CALL cl_init_qry_var()
##             LET g_qryparam.form = 'q_pib'
##             LET g_qryparam.default1 = tm.wip
##             CALL cl_create_qry() RETURNING tm.wip
###            CALL FGL_DIALOG_SETBUFFER( tm.wip )
#              LET g_t1 = s_get_doc_no(tm.wip)
#              CALL q_smy( FALSE,TRUE,g_t1,'AIM','I') RETURNING g_t1
#              LET tm.wip=g_t1
#CHI-960065--end--mod-----------------------------
#              DISPLAY BY NAME tm.wip
#              NEXT FIELD wip
#
#           OTHERWISE
#              EXIT CASE
#
#           END CASE
#TQC-AC0207 ------------------mark end--------------------

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution

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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---

         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---

   END INPUT

   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF

   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g812_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimg812'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimg812','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                        #" '",tm.wip CLIPPED,"'",            #TQC-AC0207 mark
                        #" '",tm.wie CLIPPED,"'",            #TQC-AC0207 mark
                        #" '",tm.bno CLIPPED,"'",            #TQC-AC0207 mark
                        #" '",tm.eno CLIPPED,"'",            #TQC-AC0207 mark
                         " '",tm.wc  CLIPPED,"'",            #TQC-AC0207 
                         " '",tm.t   CLIPPED,"'",
                         " '",tm.cnt CLIPPED,"'" ,              #TQC-610072
                         " '",tm.code CLIPPED,"'",
                         " '",tm.size CLIPPED,"'" ,
                         " '",tm.yearstr CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aimg812',g_time,l_cmd)
      END IF
      CLOSE WINDOW g812_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g812()
   ERROR ""
END WHILE
   CLOSE WINDOW g812_w
END FUNCTION

FUNCTION g812()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
   #      l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000) #FUN-D20064
          l_sql     STRING,                 #FUN-D20064
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          l_wipbno  LIKE pid_file.pid01,
          l_wipeno  LIKE pid_file.pid01,
          l_begin   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_end     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_i       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          sr        RECORD
                    pid01  LIKE pid_file.pid01,
                    pid02  LIKE pid_file.pid02
                   ,pid012 LIKE pid_file.pid012 #FUN-A60092
                   ,ecb03  LIKE ecb_file.ecb03  #FUN-A60092 
                    END RECORD
                    
     CALL cl_del_data(l_table)                          #NO.FUN-870060
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimg812'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR

     LET l_sql = " SELECT pid01,pid02,pid012,pid021 ",  #FUN-A60092 add pid012,pid021
                 " FROM pid_file ",
                 " WHERE (pid02 IS NULL OR pid02 = ' ') "

#TQC-AC0207 -------------------mark start--------------------------------
#    IF tm.wip IS NOT NULL AND tm.bno IS NOT NULL THEN
#      #LET l_wipbno = tm.wip,'-',tm.bno           #FUN-5A0199 mark
#       LET l_wipbno = tm.wip CLIPPED,'-',tm.bno   #FUN-5A0199
#       LET l_sql = l_sql clipped," AND pid01 >='",l_wipbno,"'"
#    END IF
#
#    IF tm.wip IS NOT NULL AND tm.eno IS NOT NULL THEN
#      #LET l_wipeno = tm.wip,'-',tm.eno           #FUN-5A0199 mark
#       LET l_wipeno = tm.wip CLIPPED,'-',tm.eno   #FUN-5A0199
#       LET l_sql = l_sql clipped," AND pid01 <='",l_wipeno,"'"
#    END IF
#
#    IF tm.wip IS NOT NULL AND tm.wip != ' '
#       AND (tm.bno IS NULL OR tm.bno = ' ' ) THEN
#      #LET l_sql = l_sql clipped," AND pid01[1,3] matches'",tm.wip,"'"                       #FUN-5A0199 mark
#       LET l_sql = l_sql clipped," AND SUBSTRING(pid01,1,",g_doc_len,") LIKE '",tm.wip CLIPPED,"%'"     #FUN-5A0199
#    END IF
#TQC-AC0207 -----------------------mark end-------------------------------------

     LET l_sql = l_sql CLIPPED," AND ",tm.wc CLIPPED      #TQC-AC0207 
     PREPARE g812_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
        CALL cl_gre_drop_temptable(l_table) 
        EXIT PROGRAM
     END IF

     DECLARE g812_cs CURSOR FOR g812_prepare
#     CALL cl_outnam('aimg812') RETURNING l_name           #NO.FUN-870060
 
     LET l_sql = " UPDATE pid_file ",
                 " SET pid12=pid12+1,",
                 "     pid11='",g_today,"' " ,
                 " WHERE pid01=? "

     PREPARE g812_up FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
           
     END IF
 
     IF g_sma.sma54='N' THEN
#        START REPORT g812_rep3 TO l_name                   #NO.FUN-870060
         LET l_name = 'aimg812_2'                           #NO.FUN-870060
     ELSE IF tm.t = 'Y' THEN
#               START REPORT g812_rep2 TO l_name            #NO.FUN-870060
                LET l_name = 'aimg812_1'                    #NO.FUN-870060
          ELSE 
#               START REPORT g812_rep1 TO l_name            #NO.FUN-870060
                LET l_name = 'aimg812'                      #NO.FUN-870060
          END IF
     END IF
#     LET g_pageno = 0                                      #NO.FUN-870060
     FOREACH g812_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
       #更新列印次數及列印日期
       EXECUTE g812_up  USING sr.pid01
 
       #無使用製程
       FOR l_i = 1 TO tm.cnt
#NO.FUN-870060---------start---
#           IF g_sma.sma54='N' THEN
#                OUTPUT TO REPORT g812_rep3(sr.*) 
#           ELSE IF tm.t = 'Y' THEN
#                   OUTPUT TO REPORT g812_rep2(sr.*)  
#                ELSE
#                   OUTPUT TO REPORT g812_rep1(sr.*)
#                END IF
#           END IF
         EXECUTE insert_prep USING sr.pid01,sr.pid02
                                  ,sr.pid012,sr.ecb03   #FUN-A60092
          
#NO.FUN-870060-----end-----------
       END FOR
     END FOREACH
#NO.FUN-870060---start----mark-----
#    IF g_sma.sma54='N' THEN
#          FINISH REPORT g812_rep3
#     ELSE IF tm.t = 'Y' THEN
#             FINISH REPORT g812_rep2 
#          ELSE
#             FINISH REPORT g812_rep1 
#          END IF
#     END IF
#NO.FUN-870060---end----mark--------
#NO.FUN-870060----start----
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   # LET g_str = tm.t,";",tm.size,";",tm.yearstr,";",tm.code       #TQC-AC0207 mark
###GENGRE###     LET g_str = tm.wc,";",tm.t,";",tm.size,";",tm.yearstr,";",tm.code #TQC-AC0207
###GENGRE###                ,";",g_sma.sma541     #FUN-A60092 add
###GENGRE###     CALL cl_prt_cs3('aimg812',l_name,g_sql,g_str)
    #FUN-B50018----add----str----------
    IF g_sma.sma54='N' THEN
       LET g_template = 'aimg812_2'
       CALL aimg812_grdata()    ###GENGRE###
    ELSE IF tm.t = 'Y' THEN
            LET g_template = 'aimg812_1'
            CALL aimg812_grdata()    ###GENGRE###
         ELSE
            LET g_template = 'aimg812'
            CALL aimg812_grdata()    ###GENGRE###
         END IF
    END IF
    #FUN-B50018----add----end---------- 
#NO.FUN-870060--end---
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)           #NO.FUN-870060
END FUNCTION

#NO.FUN-870060---start----mark-----
#REPORT g812_rep1(sr)
#DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       sr            RECORD
#                     pid01  LIKE pid_file.pid01,
#                     pid02  LIKE pid_file.pid02
#                     END RECORD,
#       l_old         LIKE pid_file.pid01,
#       l_barcode     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
#       l_i,l_j,l_len LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       l_line        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       l_control     LIKE type_file.chr5,    #No.FUN-690026 VARCHAR(5)
#       l_advance     LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#       l_ff          LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
#       l_c           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_01          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
#	
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pid01
#  FORMAT
#
#   PAGE HEADER
#		#下列資料為條碼的控制碼資料
#		LET l_control[1]=ascii 27	#ESC
#		LET l_control[2]='*'		#*
#		LET l_control[3]=ascii 33	#33 120 dots/inch
#									#32  60 dots/inch
#									#38  90 dots/inch
#									#39 180 dots/inch
#									#40 360 dots/inch
#		LET l_ff[1]=ascii 255		#0xFF
#		LET l_ff[2]=ascii 255		#0xFF
#		LET l_ff[3]=ascii 255		#0xFF
#		LET l_advance[1]=ascii 27	#ESC
#		LET l_advance[2]='J'		#J
#		LET l_advance[3]=ascii 21	#
#
#   ON EVERY ROW
#       IF sr.pid01 !=l_old THEN
#            LET g_pageno = 1
#       ELSE LET g_pageno = g_pageno + 1
#       END IF
#       #抬頭(在製工單盤點標籤列印)
#       IF tm.size='N' THEN
#          PRINT g_x[31],g_x[32] clipped
#          PRINT g_x[33] clipped,COLUMN 30,g_x[20] CLIPPED,
#                column 68, g_x[22] clipped,g_pageno using'<<<<',
#                column 77,g_x[33] clipped
#       ELSE
#          PRINT ' '
#          PRINT ' '
#       END IF
#       PRINT g_x[34],g_x[35] clipped
#       IF tm.size='N' THEN
#            PRINT g_x[33] clipped,g_x[11] CLIPPED,
#                  column 12,sr.pid01,
#                  column 58,g_x[23] clipped,tm.yearstr,
#                  column 77,g_x[33] clipped
#       ELSE PRINT column 12,sr.pid01,
#                  column 63,tm.yearstr
#       END IF
#       IF tm.code='N' THEN
#         #	#不使用條碼時, 則往前跳躍90/180"
#         #	LET l_advance[3]=ascii 90
#         #	PRINT l_advance,column 77,'│'
#         PRINT g_x[36],COLUMN 77,g_x[33] clipped
#         PRINT g_x[36],COLUMN 77,g_x[33] clipped
#         PRINT g_x[36],COLUMN 77,g_x[33] clipped
#       ELSE
#    	 #使用條碼(三九碼), 則以下列方式來列印
#    	 #1.在單號前後各加上一個星號
#            LET l_barcode='*',sr.pid01,'*'
#         #2.將之轉換成01對應的碼
#    		CALL to01(l_barcode) RETURNING l_01
#    		#3.轉換成印表機的控制碼
#    		LET l_len=LENGTH(l_01) - 2		#總長度要減掉最後兩個多餘的00
#    		LET l_i=l_len / 256				#計算傳給印表機的資料個數
#    		LET l_j=l_len-(256*l_i)			#算法:n=n2+n1*256 (n=length)
#    		LET l_control[4]=ascii l_j		#n2
#    		LET l_control[5]=ascii l_i		#n1
#    		FOR l_j=1 TO 3					#為方便條碼機閱讀, 列印三次
#    			PRINT COLUMN 11,l_control CLIPPED;
#    			FOR l_i=1 TO l_len			#將1轉換成FF
#    				LET l_c=l_01[l_i,l_i]	#將0轉換成00
#    				IF l_c='1' THEN PRINT l_ff;
#    				ELSE PRINT FILE '/nulls' END IF
#    			END FOR
#    			PRINT l_advance CLIPPED;PRINT '          ';
#    		END FOR
#    		LET l_advance[3]=ascii 27
#    		PRINT l_advance
#    	END IF
#
#        #不使用套版
#        IF tm.size='N' THEN
#           PRINT g_x[33] clipped,     g_x[12] clipped,
#                 column 77,g_x[33] clipped
#           PRINT g_x[33] clipped,g_x[13] clipped,
#                 column 77,g_x[33] clipped
#           PRINT g_x[33] clipped,g_x[14] clipped,
#                 column 77,g_x[33] clipped
#
#           PRINT g_x[38],g_x[39] clipped
#
#           PRINT g_x[24] clipped,g_x[25] clipped,
#                 g_x[26] clipped,
#                 g_x[27] clipped,g_x[28] clipped,
#                  g_x[29] clipped
#           PRINT g_x[40],g_x[41] clipped
#        ELSE
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#        END IF
#        FOR l_i = 1 TO 42
#           PRINT g_x[40],g_x[41] clipped
#
#        END FOR
#        LET l_old = sr.pid01
#
#  PAGE TRAILER
#    PRINT g_x[42],g_x[43] clipped
#    PRINT g_x[33] clipped,g_x[18] clipped,column 22,g_x[21] clipped,
#           column 42,g_x[19] clipped,column 60,g_x[21] clipped,
#           column 77,g_x[33] clipped
#    PRINT g_x[44],g_x[45] clipped
#END REPORT
#
#REPORT g812_rep2(sr)
#DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       sr            RECORD
#                     pid01  LIKE pid_file.pid01,
#                     pid02  LIKE pid_file.pid02
#                     END RECORD,
#       l_old         LIKE pid_file.pid01,
#       l_barcode     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
#       l_i,l_j,l_len LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       l_line        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       l_control     LIKE type_file.chr5,    #No.FUN-690026 VARCHAR(5)
#       l_advance     LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#       l_ff          LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
#       l_c           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_01          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
#     
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pid01
#  FORMAT
#
#   PAGE HEADER
#		#下列資料為條碼的控制碼資料
#		LET l_control[1]=ascii 27	#ESC
#		LET l_control[2]='*'		#*
#		LET l_control[3]=ascii 33	#33 120 dots/inch
#									#32  60 dots/inch
#									#38  90 dots/inch
#									#39 180 dots/inch
#									#40 360 dots/inch
#		LET l_ff[1]=ascii 255		#0xFF
#		LET l_ff[2]=ascii 255		#0xFF
#		LET l_ff[3]=ascii 255		#0xFF
#		LET l_advance[1]=ascii 27	#ESC
#		LET l_advance[2]='J'		#J
#		LET l_advance[3]=ascii 21	#
#
#   ON EVERY ROW
#      IF sr.pid01 != l_old THEN
#           LET g_pageno = 1
#      ELSE LET g_pageno = g_pageno + 1
#      END IF
#      #抬頭(在製工單盤點標籤列印)
#      IF tm.size='N' THEN
#         PRINT g_x[31],g_x[32] clipped
#         PRINT g_x[33] clipped,COLUMN 30,g_x[20] CLIPPED,
#               column 68, g_x[22] clipped,g_pageno using'<<<<',
#               column 77,g_x[33] clipped
#      ELSE
#         PRINT ' '
#         PRINT ' '
#      END IF
#      PRINT g_x[34],g_x[35] clipped
#      IF tm.size='N' THEN
#         PRINT g_x[33] clipped,g_x[11] CLIPPED,
#               column 12,sr.pid01,
#               column 58,g_x[23] clipped,tm.yearstr,
#               column 77,g_x[33] clipped
#      ELSE PRINT column 12,sr.pid01,
#                 column 63,tm.yearstr
#      END IF
#      IF tm.code='N' THEN
#         #	#不使用條碼時, 則往前跳躍90/180"
#         #	LET l_advance[3]=ascii 90
#         #	PRINT l_advance,column 77,'│'
#           PRINT g_x[33],COLUMN 77,g_x[33] clipped
#           PRINT g_x[33],COLUMN 77,g_x[33] clipped
#           PRINT g_x[33],COLUMN 77,g_x[33] clipped
#     	 ELSE
#    	 	#使用條碼(三九碼), 則以下列方式來列印
#    		#1.在單號前後各加上一個星號
#    		LET l_barcode='*',sr.pid01,'*'
#    		#2.將之轉換成01對應的碼
#    		CALL to01(l_barcode) RETURNING l_01
#    		#3.轉換成印表機的控制碼
#    		LET l_len=LENGTH(l_01) - 2		#總長度要減掉最後兩個多餘的00
#    		LET l_i=l_len / 256				#計算傳給印表機的資料個數
#    		LET l_j=l_len-(256*l_i)			#算法:n=n2+n1*256 (n=length)
#    		LET l_control[4]=ascii l_j		#n2
#    		LET l_control[5]=ascii l_i		#n1
#    		FOR l_j=1 TO 3					#為方便條碼機閱讀, 列印三次
#    			PRINT COLUMN 11,l_control CLIPPED;
#    			FOR l_i=1 TO l_len			#將1轉換成FF
#    				LET l_c=l_01[l_i,l_i]	#將0轉換成00
#    				IF l_c='1' THEN PRINT l_ff;
#    				ELSE PRINT FILE '/nulls' END IF
#    			END FOR
#    			PRINT l_advance CLIPPED;PRINT '          ';
#    		END FOR
#    		LET l_advance[3]=ascii 27
#    		PRINT l_advance
#       END IF
#
#        #不使用套版
#        IF tm.size='N' THEN
#           PRINT g_x[33] clipped,     g_x[12] clipped,              #工單編號
#                 column 77,g_x[33] clipped
#           PRINT g_x[33] clipped,g_x[13] clipped,                   #生產料件
#                 column 77,g_x[33] clipped
#           PRINT g_x[33] clipped,g_x[14] clipped,                   #品名規格
#                 column 77,g_x[33] clipped
#           PRINT g_x[33] clipped,g_x[15] clipped,                   #工作站
#                 column 77,g_x[33] clipped
#           PRINT g_x[46],g_x[47] clipped
#           PRINT g_x[30] clipped,g_x[26] clipped,
#                 g_x[27] clipped,g_x[28] clipped,
#                 g_x[60] clipped
#           PRINT g_x[48],g_x[49] clipped
#        ELSE
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#        END IF
#   #-------------No.TQC-750100 modify
#   #FOR l_i = 1 TO 42
#    FOR l_i = 1 TO 41
#   #-------------No.TQC-750100 end
#       PRINT g_x[48],g_x[49] clipped
#
#    END FOR
#    LET l_old = sr.pid01
#
#  PAGE TRAILER
#    PRINT g_x[50],g_x[51] clipped
#    PRINT g_x[33] clipped,g_x[18] clipped,column 22,g_x[21] clipped,
#           column 42,g_x[19] clipped,column 60,g_x[21] clipped,
#           column 77,g_x[33] clipped
#    PRINT g_x[44],g_x[45] clipped
#END REPORT
#
#REPORT g812_rep3(sr)
#DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       sr            RECORD
#                     pid01  LIKE pid_file.pid01,
#                     pid02  LIKE pid_file.pid02
#                     END RECORD,
#       l_old         LIKE pid_file.pid01,
#       l_barcode     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
#       l_i,l_j,l_len LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       l_line        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#       l_control     LIKE type_file.chr5,    #No.FUN-690026 VARCHAR(5)
#       l_advance     LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#       l_ff          LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
#       l_c           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#       l_01          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
#     
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.pid01
#  FORMAT
#
#   PAGE HEADER
#		#下列資料為條碼的控制碼資料
#		LET l_control[1]=ascii 27	#ESC
#		LET l_control[2]='*'		#*
#		LET l_control[3]=ascii 33	#33 120 dots/inch
#									#32  60 dots/inch
#									#38  90 dots/inch
#									#39 180 dots/inch
#									#40 360 dots/inch
#		LET l_ff[1]=ascii 255		#0xFF
#		LET l_ff[2]=ascii 255		#0xFF
#		LET l_ff[3]=ascii 255		#0xFF
#		LET l_advance[1]=ascii 27	#ESC
#		LET l_advance[2]='J'		#J
#		LET l_advance[3]=ascii 21	#
#
#   ON EVERY ROW
#      IF sr.pid01 != l_old THEN
#           LET g_pageno = 1
#      ELSE LET g_pageno = g_pageno + 1
#      END IF
#         #抬頭(在製工單盤點標籤列印)
#         IF tm.size='N' THEN
#             PRINT g_x[31],g_x[32] clipped
#             PRINT g_x[33] clipped,COLUMN 30,g_x[20] CLIPPED,
#                   column 68, g_x[22] clipped,g_pageno using'<<<<',
#                   column 77,g_x[33] clipped
#         ELSE
#             PRINT ' '
#             PRINT ' '
#         END IF
#         PRINT g_x[34],g_x[35] clipped
#         IF tm.size='N' THEN
#              PRINT g_x[33] clipped,g_x[11] CLIPPED,
#                    column 12,sr.pid01,
#                    column 58,g_x[23] clipped,tm.yearstr,
#                    column 77,g_x[33] clipped
#         ELSE PRINT column 12,sr.pid01,
#                    column 63,tm.yearstr
#         END IF
#      	 IF tm.code='N' THEN
#         #	#不使用條碼時, 則往前跳躍90/180"
#         #	LET l_advance[3]=ascii 90
#         #	PRINT l_advance,column 77,'│'
#
#           PRINT g_x[33],COLUMN 77,g_x[33] clipped
#           PRINT g_x[33],COLUMN 77,g_x[33] clipped
#           PRINT g_x[33],COLUMN 77,g_x[33] clipped
#     	 ELSE
#    	 	#使用條碼(三九碼), 則以下列方式來列印
#    		#1.在單號前後各加上一個星號
#    		LET l_barcode='*',sr.pid01,'*'
#    		#2.將之轉換成01對應的碼
#    		CALL to01(l_barcode) RETURNING l_01
#    		#3.轉換成印表機的控制碼
#    		LET l_len=LENGTH(l_01) - 2		#總長度要減掉最後兩個多餘的00
#    		LET l_i=l_len / 256				#計算傳給印表機的資料個數
#    		LET l_j=l_len-(256*l_i)			#算法:n=n2+n1*256 (n=length)
#    		LET l_control[4]=ascii l_j		#n2
#    		LET l_control[5]=ascii l_i		#n1
#    		FOR l_j=1 TO 3					#為方便條碼機閱讀, 列印三次
#    			PRINT COLUMN 11,l_control CLIPPED;
#    			FOR l_i=1 TO l_len			#將1轉換成FF
#    				LET l_c=l_01[l_i,l_i]	#將0轉換成00
#    				IF l_c='1' THEN PRINT l_ff;
#    				ELSE PRINT FILE '/nulls' END IF
#    			END FOR
#    			PRINT l_advance CLIPPED;PRINT '          ';
#    		END FOR
#    		LET l_advance[3]=ascii 27
#    		PRINT l_advance
#    	END IF
#
#        #不使用套版
#        IF tm.size='N' THEN
#           PRINT g_x[33] clipped,     g_x[12] clipped,
#                 column 77,g_x[33] clipped
#           PRINT g_x[33] clipped,g_x[13] clipped,
#                 column 77,g_x[33] clipped
#           PRINT g_x[33] clipped,g_x[14] clipped,
#                 column 77,g_x[33] clipped
#           PRINT g_x[52],g_x[53] clipped
#           PRINT g_x[61] clipped,
#                 g_x[27] clipped,
#                 g_x[62] clipped
#           PRINT g_x[54],g_x[55] clipped
#        ELSE
#           PRINT COLUMN 14,sr.pid01
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#           PRINT ' '
#        END IF
#
#   FOR l_i = 1 TO 21
#     PRINT g_x[56] clipped,column 45,g_x[57] clipped
#     PRINT g_x[54] clipped,g_x[55] clipped
# 
#   END FOR
#    LET l_old = sr.pid01
#
#  PAGE TRAILER
#    PRINT g_x[58],g_x[59] clipped
#    PRINT g_x[33] clipped,g_x[18] clipped,column 22,g_x[21] clipped,
#           column 42,g_x[19] clipped,column 60,g_x[21] clipped,
#           column 77,g_x[33] clipped
#    PRINT g_x[44],g_x[45] clipped
#END REPORT
#
##將所要印的單號, 轉換成條碼
#FUNCTION to01(p_code)
#DEFINE
#	p_code       LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
#	l_c          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#	l_01         LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
#	l_01c        LIKE type_file.chr21,   #No.FUN-690026 VARCHAR(21)
#	l_length,l_i LIKE type_file.num5     #No.FUN-690026 SMALLINT
#
#	#決定要loop的次數
#	LET l_length=LENGTH(p_code)
#	LET l_01=' '
#	FOR l_i=1 TO l_length
#		LET l_c=UPSHIFT(p_code[l_i,l_i])
#		#三九碼所允許的字及其對應的碼別
#		CASE l_c
#			WHEN '0' LET l_01c='100100001111001111001'
#			WHEN '1' LET l_01c='111100100001001001111'
#			WHEN '2' LET l_01c='100111100001001001111'
#			WHEN '3' LET l_01c='111100111100001001001'
#			WHEN '4' LET l_01c='100100001111001001111'
#			WHEN '5' LET l_01c='111100100001111001001'
#			WHEN '6' LET l_01c='100111100001111001001'
#			WHEN '7' LET l_01c='100100001001111001111'
#			WHEN '8' LET l_01c='111100100001001111001'
#			WHEN '9' LET l_01c='100111100001001111001'
#			WHEN 'A' LET l_01c='111100100100001001111'
#			WHEN 'B' LET l_01c='100111100100001001111'
#			WHEN 'C' LET l_01c='111100111100100001001'
#			WHEN 'D' LET l_01c='100100111100001001111'
#			WHEN 'E' LET l_01c='111100100111100001001'
#			WHEN 'F' LET l_01c='100111100111100001001'
#			WHEN 'G' LET l_01c='100100100001111001111'
#			WHEN 'H' LET l_01c='111100100100001111001'
#			WHEN 'I' LET l_01c='100111100100001111001'
#			WHEN 'J' LET l_01c='100100111100001111001'
#			WHEN 'K' LET l_01c='111100100100100001111'
#			WHEN 'L' LET l_01c='100111100100100001111'
#			WHEN 'M' LET l_01c='111100111100100100001'
#			WHEN 'N' LET l_01c='100100111100100001111'
#			WHEN 'O' LET l_01c='111100100111100100001'
#			WHEN 'P' LET l_01c='100111100111100100001'
#			WHEN 'Q' LET l_01c='100100100111100001111'
#			WHEN 'R' LET l_01c='111100100100111100001'
#			WHEN 'S' LET l_01c='100111100100111100001'
#			WHEN 'T' LET l_01c='100100111100111100001'
#			WHEN 'U' LET l_01c='111100001001001001111'
#			WHEN 'V' LET l_01c='100001111001001001111'
#			WHEN 'W' LET l_01c='111100001111001001001'
#			WHEN 'X' LET l_01c='100001001111001001111'
#			WHEN 'Y' LET l_01c='111100001001111001001'
#			WHEN 'Z' LET l_01c='100001111001111001001'
#			WHEN '-' LET l_01c='100001001001111001111'
#			WHEN '.' LET l_01c='111100001001001111001'
#			WHEN ' ' LET l_01c='100001111001001111001'
#			WHEN '*' LET l_01c='100010011110011110001'
#			WHEN '$' LET l_01c='1000010000100001001'
#			WHEN '/' LET l_01c='1000010000100100001'
#			WHEN '+' LET l_01c='1000010010000100001'
#			WHEN '%' LET l_01c='1001000010000100001'
#			OTHERWISE EXIT CASE
#		END CASE
#		#將之組合起來, 並在每字後面加上'00', 以方便條碼機閱讀
#		LET l_01=l_01 CLIPPED,l_01c CLIPPED,'00'
#	END FOR
#	RETURN l_01
#END FUNCTION
##Patch....NO.TQC-610036 <001> #
#NO.FUN-870060---end----mark-----
#FUN-870144

###GENGRE###START
FUNCTION aimg812_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aimg812")
        IF handler IS NOT NULL THEN
            START REPORT aimg812_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE aimg812_datacur1 CURSOR FROM l_sql
            FOREACH aimg812_datacur1 INTO sr1.*
                OUTPUT TO REPORT aimg812_rep(sr1.*)
            END FOREACH
            FINISH REPORT aimg812_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aimg812_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE  l_barcode   LIKE pid_file.pid01              #FUN-B50018-ADD
    
    ORDER EXTERNAL BY sr1.pid01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_sma.sma541                       #FUN-C20051 add
              
        BEFORE GROUP OF sr1.pid01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET   l_barcode = sr1.faj10,' ',sr1.pmc03  #FUN-B50018-ADD
            PRINTX  l_barcode                          #FUN-B50018-ADD
            PRINTX sr1.*

        AFTER GROUP OF sr1.pid01

        
        ON LAST ROW

END REPORT
###GENGRE###END
