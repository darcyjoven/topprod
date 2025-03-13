# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aimg801.4gl
# Descriptions...: 盤點標籤列印作業－在製工單
# Input parameter:
# Return code....:
# Date & Author..: 93/05/28 By Apple
# Modify.........: No.MOD-530086 05/03/14 By cate 報表標題標準化
# Modify.........: No.FUN-550108 05/05/26 By echo 新增報表備註
# Modify.........: No.MOD-590022 05/09/12 By vivien 報表格式調整
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-750100 07/05/29 By pengu 表尾位置跑掉
# Modify.........: No.MOD-860320 08/06/27 By claire 標籤別判斷方式
# Modify.........: No.FUN-850127 08/07/02 By sherry 增加選項是否列印應盤數量(pie153)
# Modify.........: No.FUN-870060 08/07/10 By zhaijie 報表轉CR
# Modify.........: No.MOD-880247 08/08/28 By claire 起始標籤號碼default錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960065 09/11/10 By jan 修改標簽別開窗
# Modify.........: No.TQC-9B0038 09/11/10 By jan 修改程序BUG
# Modify.........: No.FUN-A60092 10/07/16 By lilingyu 平行工藝
# Modify.........: No.TQC-AC0207 10/12/17 By vealxu 拿掉標籤別﹧起始標籤﹧截止標籤 改成一個可QBE的"標籤編號"
# Modify.........: No.TQC-B30193 11/03/31 By destiny 选资料时pid_file和pie_file没有管理导致资料会多出很多
# Modify.........: No.FUN-B50018 11/06/09 By xumm CR轉GRW
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No.FUN-C20052 12/02013 By chenying GR調整
# Modify.........: No.TQC-CB0058 12/11/19 By yuhuabao 調整畫面檔欄位寬度，及增加工作站、工單編號的開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                          # Print condition RECORD
           wc      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
           #start FUN-5A0199
         # wip     LIKE pib_file.pib01,    # 標籤別 #FUN-660078      #TQC-AC0207 mark
         # wie     LIKE pib_file.pib01,    #FUN-660078               #TQC-AC0207 mark
         # bno     LIKE pib_file.pib03,    # 起始號碼 #No.FUN-690026 VARCHAR(10)#TQC-AC0207 mark
         # eno     LIKE pib_file.pib03,    # 截止號碼 #No.FUN-690026 VARCHAR(10)#TQC-AC0207 mark
           #end FUN-5A0199
           a       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           b       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           s       LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           t       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           e       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           f       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	   code    LIKE type_file.chr1,    # 是否列印條碼  #No.FUN-690026 VARCHAR(1)
	   size    LIKE type_file.chr1,    # 是否套版列印  #No.FUN-690026 VARCHAR(1)
	   c       LIKE type_file.chr1,    # 是否列印應盤數量  #No.FUN-850127
           yearstr LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
    	   more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#NO.FUN-870060--START---
DEFINE g_sql        STRING
DEFINE g_str        STRING
DEFINE l_table      STRING
#NO.FUN-870060--END---
DEFINE g_t1        LIKE oay_file.oayslip  #CHI-960065

###GENGRE###START
TYPE sr1_t RECORD
    order1 LIKE type_file.chr100,        #FUN-B50018
    order2 LIKE type_file.chr100,        #FUN-B50018
    order3 LIKE type_file.chr100,        #FUN-B50018
    pid01 LIKE pid_file.pid01,
    pid02 LIKE pid_file.pid02,
    pid03 LIKE pid_file.pid03,
    ima02_d LIKE ima_file.ima02,
    pie02 LIKE pie_file.pie02,
    pie03 LIKE pie_file.pie03,
    pie04 LIKE pie_file.pie04,
    pie05 LIKE pie_file.pie05,
    pie07 LIKE pie_file.pie07,
    pie153 LIKE pie_file.pie153,
    ima02 LIKE ima_file.ima02,
    pid012 LIKE pid_file.pid012,
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
#NO.FUN-870060--START---
   LET g_sql = "order1.type_file.chr100,",   #FUN-B50018
               "order2.type_file.chr100,",   #FUN-B50018
               "order3.type_file.chr100,",   #FUN-B50018
               "pid01.pid_file.pid01,",
               "pid02.pid_file.pid02,",
               "pid03.pid_file.pid03,",
               "ima02_d.ima_file.ima02,",
               "pie02.pie_file.pie02,",
               "pie03.pie_file.pie03,",
               "pie04.pie_file.pie04,",
               "pie05.pie_file.pie05,",
               "pie07.pie_file.pie07,",
               "pie153.pie_file.pie153,",
               "ima02.ima_file.ima02,",    #FUN-A60092 add , ,
               "pid012.pid_file.pid012,",  #FUN-A60092 
               "ecb03.ecb_file.ecb03"      #FUN-A60092
  LET l_table = cl_prt_temptable('aimg801',g_sql) CLIPPED
  IF l_table = -1 THEN 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add 
     CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
     EXIT PROGRAM
  END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,? ,?,?,?,?,?)"  #FUN-A60092 add ?,?    #FUN-B50018 add ?,?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF                        
#NO.FUN-870060--END---
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  #TQC-610072-begin
   LET tm.wc = ARG_VAL(7)
#TQC-AC0207 -----------mod start-----------
#  LET tm.wip = ARG_VAL(8)
#  LET tm.wie = ARG_VAL(9)
#  LET tm.bno = ARG_VAL(10)
#  LET tm.eno = ARG_VAL(11)
#  LET tm.a   = ARG_VAL(12)
#  LET tm.b   = ARG_VAL(13)
#  LET tm.s   = ARG_VAL(14)
#  LET tm.t   = ARG_VAL(15)
#  LET tm.code = ARG_VAL(16)
#  LET tm.size = ARG_VAL(17)
#  LET tm.yearstr = ARG_VAL(18)
#  LET tm.f = ARG_VAL(19)
#  LET tm.e = ARG_VAL(20)
#  #No.FUN-570264 --start--
#  LET g_rep_user = ARG_VAL(21)
#  LET g_rep_clas = ARG_VAL(22)
#  LET g_template = ARG_VAL(23)
#  #No.FUN-570264 ---end---
#  LET tm.c = ARG_VAL(24)       #No.FUN-850127
   LET tm.a   = ARG_VAL(8)
   LET tm.b   = ARG_VAL(9)
   LET tm.s   = ARG_VAL(10)
   LET tm.t   = ARG_VAL(11)
   LET tm.code = ARG_VAL(12)
   LET tm.size = ARG_VAL(13)
   LET tm.yearstr = ARG_VAL(14)
   LET tm.f = ARG_VAL(15)
   LET tm.e = ARG_VAL(16)
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   LET tm.c = ARG_VAL(20)
#TQC-AC0207 ------------mod end----------------
  #TQC-610072-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g801_tm(0,0)		# Input print condition
      ELSE CALL g801()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g801_tm(p_row,p_col)
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_direct,l_flag LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       l_pib03         LIKE pib_file.pib03,
       l_cnt           LIKE type_file.num10,   #No.FUN-690026 INTEGER
       stk_len         LIKE type_file.num5,    #MOD-860320 add
       l_cmd	       LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
DEFINE l_sql           STRING   #FUN-5A0199
DEFINE l_pid01         LIKE pid_file.pid01     #No.MOD-880247 add
DEFINE l_pid01_a       LIKE pid_file.pid01     #CHI-960065
DEFINE l_len           LIKE type_file.num5     #No.MOD-880247 add
DEFINE li_result       LIKE type_file.num5     #CHI-960065
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW g801_w AT p_row,p_col WITH FORM "aim/42f/aimg801"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
  #LET tm.wip='WIP'   #CHI-96006   #CHI-9600655
  #LET tm.wie='WIP'   #CHI-960065
  #LET tm.bno='000001'                          #No.MOD-880247 mark
   LET tm.a  = 'Y'
   LET tm.b  = 'Y'
   LET tm.e  = 'Y'
   LET tm.f  = 'Y'
   LET tm.t  = 'Y'
   LET tm.code = 'N'
   LET tm.size = 'N'
   LET tm.c = 'N'              #No.FUN-850127   
   LET tm.s  = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1 = '1'
   LET tm2.s2 = '2'
   LET tm2.s3 = '3'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON pie05,pid02,pid01       #TQC-AC0207 add pid01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
     #TQC-AC0207 -----------add start------------------
      ON ACTION CONTROLP
         IF INFIELD(pid01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_pid01"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO pid01
            NEXT FIELD pid01
         END IF
#TQC-CB0058 -------------- add --------------- begin
         CASE 
            WHEN INFIELD(pid02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pid02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pid02
               NEXT FIELD pid02
           WHEN INFIELD(pie05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pie05"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pie05
               NEXT FIELD pie05
           OTHERWISE EXIT CASE
        END CASE
#TQC-CB0058 -------------- add --------------- end
     #TQC-AC0207 ----------add end---------------------- 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g801_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
      CALL cl_gre_drop_temptable(l_table) 
      EXIT PROGRAM
         
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
#TQC-AC0207 ------------mark start---------------
#  INPUT BY NAME tm.wip,tm.wie,tm.bno,tm.eno,tm.yearstr,tm2.s1,tm2.s2,tm2.s3,
#                tm.a,tm.b,tm.t,tm.e,tm.f,tm.code,tm.size,tm.c,tm.more WITHOUT DEFAULTS  #No.FUN-850127 add tm.c
   INPUT BY NAME tm.yearstr,tm2.s1,tm2.s2,tm2.s3,tm.a,tm.b,tm.t,tm.e,tm.f,tm.code,tm.size,tm.c,tm.more WITHOUT DEFAULTS 
#TQC-AC0207 -----------mod end----------------
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
#TQC-AC0207 --------------mark start-------------------------
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
#               NEXT FIELD wip
#           END IF 
#           LET stk_len = 0
#           LET stk_len=LENGTH(tm.wip)    
#           LET l_pid01 = '' #TQC-9B0038
#           SELECT MAX(pid01) INTO l_pid01 FROM pid_file
#            WHERE Substr(pid01,1,stk_len) LIKE tm.wip 
#           #TQC-9B0038--begin--add--------                                                                                         
#           IF cl_null(l_pid01) THEN                                                                                                
#              CALL cl_err3("sel","pid_file",tm.wip,"","mfg0107",                                                                   
#                           "","",1)                                                                                                
#              NEXT FIELD wip                                                                                                       
#           END IF                                                                                                                  
#           #TQC-9B0038--end--add------
#           LET l_len = 0
#           LET l_len=length(l_pid01)
#           LET l_pib03 = l_pid01[stk_len+2,l_len]
##          SELECT pib03 INTO l_pib03 FROM pib_file
##                         WHERE pib01 = tm.wip
##            IF SQLCA.sqlcode THEN
##      	 CALL cl_err(tm.wip,'mfg0107',0) #No.FUN-660156 
##               CALL cl_err3("sel","pib_file",tm.wip,"","mfg0107",
##                            "","",0)  #No.FUN-660156
##               NEXT FIELD wip
##            END IF
##           #start FUN-5A0199
##           #SELECT COUNT(*) INTO l_cnt FROM pid_file
##           # WHERE pid01[1,3] = tm.wip
##            LET stk_len=0                 #MOD-860320
##            LET stk_len=length(tm.wip)    #MOD-860320
##            LET l_sql = "SELECT COUNT(*) FROM pid_file ",
##                       #" WHERE pid01[1,",g_doc_len,"] matches '",tm.wip,"'"  #MOD-860320 mark
##                        " WHERE Substr(pid01,1,",stk_len,") matches '",tm.wip,"'"  #MOD-860320 
##            PREPARE g801_pre FROM l_sql
##            DECLARE g801_cur1 CURSOR FOR g801_pre
##            OPEN g801_cur1
##            FETCH g801_cur1 INTO l_cnt
##           #end FUN-5A0199
##            IF l_cnt = 0 THEN
##	         CALL cl_err(tm.wip,'mfg1113',0)
##               NEXT FIELD wip
##            END IF
##CHI-960065--end--mod---------------------------------
#             LET tm.eno = l_pib03
#             DISPLAY BY NAME tm.eno
#        END IF
#        LET tm.wie = tm.wip
#        DISPLAY BY NAME tm.wie
#
#    #--------------No.MOD-880247 add
#     BEFORE FIELD bno
#        IF NOT cl_null(tm.wip) THEN
#           LET stk_len=0                 
#           LET stk_len=LENGTH(tm.wip)    
#           SELECT MIN(pid01) INTO l_pid01_a FROM pid_file  #CHI-960065
#                            WHERE Substr(pid01,1,stk_len) LIKE tm.wip 
#      
#           LET l_len = 0
#           LET l_len = LENGTH(l_pid01_a)   #CHI-960065
#           LET tm.bno = l_pid01_a[(stk_len+2),l_len] #CHI-960065
#           DISPLAY BY NAME tm.bno
#        END IF
#    #--------------No.MOD-880247 end
#
#     AFTER FIELD bno
#       	 IF tm.bno IS NULL OR tm.bno =' ' THEN
#       		NEXT FIELD bno
#        END IF
#
#     AFTER FIELD eno
#       	 IF tm.eno IS NOT NULL AND tm.eno < tm.bno  THEN
#       		CALL cl_err('','mfg1323',0)
#       		NEXT FIELD eno
#        END IF
#TQC-AC0207 ----------------------mark end-----------------------------
 
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
           #TQC-AC0207 ----------mark start------------
           #LET l_flag = 'N'
           #IF tm.wip IS NULL OR tm.wip =' ' THEN
           #   LET l_flag = 'Y'
           #   DISPLAY BY NAME tm.wip
           #END IF
           #IF tm.eno IS NULL OR tm.eno = ' ' THEN
           #   LET tm.eno = '999999'
           #END IF
           #IF l_flag='Y' THEN
           #   CALL cl_err('','9033',0)
           #   NEXT FIELD wip
           #END IF
           #TQC-AC0207 -----------mark end----------------
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
 
#TQC-AC0207 ---------------------mark start------------------
#     ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(wip)
##                CALL q_pib(8,3,tm.wip) RETURNING tm.wip
##                CALL FGL_DIALOG_SETBUFFER( tm.wip )
##CHI-960065--begin--mod----------------------
##                CALL cl_init_qry_var()
##                LET g_qryparam.form = 'q_pib'
##                LET g_qryparam.default1 = tm.wip
##                CALL cl_create_qry() RETURNING tm.wip
###               CALL FGL_DIALOG_SETBUFFER( tm.wip )
#                 LET g_t1 = s_get_doc_no(tm.wip)
#                 CALL q_smy( FALSE,TRUE,g_t1,'AIM','I') RETURNING g_t1
#                 LET tm.wip=g_t1
##CHI-960065--end--mod-------------------------
#                 DISPLAY BY NAME tm.wip
#                 NEXT FIELD wip
#
#              OTHERWISE
#                 EXIT CASE
#
#           END CASE
#TQC-AC0207 -------------------mark end-------------------------
 
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g801_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
      CALL cl_gre_drop_temptable(l_table) 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aimg801'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimg801','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",                #TQC-610072
                       # " '",tm.wip CLIPPED,"'",               #TQC-AC0207 mark
                       # " '",tm.wie CLIPPED,"'",               #TQC-AC0207 mark
                       # " '",tm.bno CLIPPED,"'",               #TQC-AC0207 mark   
                       # " '",tm.eno CLIPPED,"'",               #TQC-AC0207 mark 
                         " '",tm.a   CLIPPED,"'",
                         " '",tm.b   CLIPPED,"'",
                         " '",tm.s   CLIPPED,"'",
                         " '",tm.t   CLIPPED,"'",
                         " '",tm.code CLIPPED,"'",
                         " '",tm.size CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,                #No.FUN-850127
                         " '",tm.yearstr CLIPPED,"'" ,
                         " '",tm.f   CLIPPED,"'",               #TQC-610072
                         " '",tm.e   CLIPPED,"'",               #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aimg801',g_time,l_cmd)
      END IF
      CLOSE WINDOW g801_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
      CALL cl_gre_drop_temptable(l_table) 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g801()
   ERROR ""
END WHILE
   CLOSE WINDOW g801_w
END FUNCTION
 
FUNCTION g801()
   DEFINE l_name	LIKE type_file.chr20, 	# External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0074
          l_sql 	LIKE type_file.chr1000,	# RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_za05	LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
#          l_order       ARRAY[5] OF LIKE pid_file.pid01, #No.FUN-690026 VARCHAR(20)     #FUN-B50018---mark
          l_wipbno      LIKE pid_file.pid01,
          l_wipeno      LIKE pid_file.pid01,
          sr            RECORD
                        order1  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
                        order2  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
                        order3  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
                        pid01   LIKE pid_file.pid01,
                        pid02   LIKE pid_file.pid02,
                        pid03   LIKE pid_file.pid03,
                        ima02_d LIKE ima_file.ima02,
                        pie02   LIKE pie_file.pie02,
                        pie03   LIKE pie_file.pie03,
                        pie04   LIKE pie_file.pie04,
                        pie05   LIKE pie_file.pie05,
                        pie07   LIKE pie_file.pie07,
                        pie153  LIKE pie_file.pie153,  #No.FUN-850127
                        ima02   LIKE ima_file.ima02
                       ,pid012  LIKE pid_file.pid012   #FUN-A60092
                       ,ecb03   LIKE ecb_file.ecb03    #FUN-A60092 
                        END RECORD

     DEFINE l_order   ARRAY[3] OF LIKE type_file.chr100    #FUN-B50018
                        
     CALL cl_del_data(l_table)                          #NO.FUN-870060
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimg801'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    #start FUN-5A0199
    #LET l_wipbno = tm.wip,'-',tm.bno
    #LET l_wipeno = tm.wip,'-',tm.eno
    #LET l_wipbno = tm.wip CLIPPED,'-',tm.bno CLIPPED    #TQC-AC0207 mark
    #LET l_wipeno = tm.wip CLIPPED,'-',tm.eno CLIPPED    #TQC-AC0207 mark
    #end FUN-5A0199
 
     LET l_sql = " SELECT '','','',pid01,pid02,pid03,A.ima02,",
                 "        pie02,pie03,pie04,pie05,pie07,pie153,B.ima02,pid012,pid021 ",  #No.FUN-850127 add pie153
                                        #FUN-A60092 add pid012,pid021
                #TQC-AC0207 -----------mod start------------------ 
                #" FROM pid_file ,OUTER ima_file A, ",
                #"      pie_file ,OUTER ima_file B  ",
                #" WHERE  pid01 = pie01   AND ",
                #"        pid_file.pid03 = A.ima01 AND ",
                #"        pie_file.pie02 = B.ima01 AND ",
                #"  pid01 BETWEEN '", l_wipbno,"' AND '",l_wipeno,"'",
                #" AND ",tm.wc clipped
                 " FROM pid_file LEFT OUTER JOIN ima_file A ON pid_file.pid03 = A.ima01 ,",
                 "      pie_file LEFT OUTER JOIN ima_file B ON pie_file.pie02 = B.ima01 ",
                #" WHERE ",tm.wc CLIPPED                        #TQC-B30193
                 " WHERE pid01=pie01 AND ",tm.wc CLIPPED        #TQC-B30193
                #TQC-AC0207 -------------mod end-------------------
     #不列印消耗性料件
     IF tm.e ='N' THEN
        LET l_sql = l_sql clipped,"AND pie06 != 'E'"
     END IF
     #不列印大宗性料件
     IF tm.f ='N' THEN
        LET l_sql = l_sql clipped,"AND pie06 not IN ('U','V')"
     END IF
     PREPARE g801_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
        CALL cl_gre_drop_temptable(l_table) 
        EXIT PROGRAM
           
     END IF
     DECLARE g801_cs CURSOR FOR g801_prepare
#     CALL cl_outnam('aimg801') RETURNING l_name            #NO.FUN-870060
     LET l_sql = " UPDATE pid_file ",
                 " SET pid12=pid12+1,",
                 "     pid11='",g_today,"' " ,
                 " WHERE pid01=? "
     PREPARE g801_up FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo
        CALL cl_gre_drop_temptable(l_table) 
        EXIT PROGRAM
           
     END IF
 
     IF g_sma.sma54='N' THEN
#        START REPORT g801_rep3 TO l_name                   #NO.FUN-870060
         LET l_name = 'aimg801_2'                           #NO.FUN-870060
     ELSE
         IF tm.t = 'Y' THEN
#            START REPORT g801_rep2 TO l_name                #NO.FUN-870060
             LET l_name = 'aimg801_1'                        #NO.FUN-870060
         ELSE
#            START REPORT g801_rep1 TO l_name                #NO.FUN-870060
             LET l_name = 'aimg801'                          #NO.FUN-870060
         END IF
     END IF
#     LET g_pageno = 0                                      #NO.FUN-870060
 
     FOREACH g801_cs INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       #更新列印次數及列印日期
       EXECUTE g801_up  USING sr.pid01
#NO.FUN-870060---start--mark---
#       FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pid01
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pid02
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pie05
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       #無使用製程
#      IF g_sma.sma54='N' THEN
#           OUTPUT TO REPORT g801_rep3(sr.*)
#      ELSE IF tm.t = 'Y' THEN
#              OUTPUT TO REPORT g801_rep2(sr.*)
#           ELSE
#              OUTPUT TO REPORT g801_rep1(sr.*)
#           END IF
#      END IF
#NO.FUN-870060--end---mark----

      #FUN-B50018-------add------str--------------
      FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.pid01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.pid02
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.pie05
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
      END FOR
      IF l_order[1] IS NULL THEN LET l_order[1] = ' ' END IF
      IF l_order[2] IS NULL THEN LET l_order[2] = ' ' END IF
      IF l_order[3] IS NULL THEN LET l_order[3] = ' ' END IF
      #FUN-B50018-------add------end--------------
        EXECUTE insert_prep USING
          l_order[1],l_order[2],l_order[3],sr.pid01,sr.pid02,sr.pid03,sr.ima02_d,sr.pie02,sr.pie03,
          sr.pie04,sr.pie05,sr.pie07,sr.pie153,sr.ima02
         ,sr.pid012,sr.ecb03             #FUN-A60092               #FUN-B50018 add sr.oder1,sr.order2,sr.order3 
    END FOREACH
#NO.FUN-870060--start---mark----
#    IF g_sma.sma54='N' THEN
#         FINISH REPORT g801_rep3
#    ELSE IF tm.t = 'Y' THEN
#            FINISH REPORT g801_rep2
#         ELSE
#            FINISH REPORT g801_rep1
#         END IF
#    END IF
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#NO.FUN-870060--end---mark----
#NO.FUN-870060----start----
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     LET g_str = tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.size,";",
###GENGRE###                 tm.code,";",tm.yearstr,";",tm.a,";",tm.b,";",tm.c
###GENGRE###                ,";",g_sma.sma541        #FUN-A60092 add 
###GENGRE###     CALL cl_prt_cs3('aimg801',l_name,g_sql,g_str) 
    CALL aimg801_grdata()    ###GENGRE###
#NO.FUN-870060--end---
END FUNCTION


#NO.FUN-870060--START---MARK---
#REPORT g801_rep1(sr)
#DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#      sr               RECORD
#                       order1  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
#                       order2  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
#                       order3  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
#                       pid01   LIKE pid_file.pid01,
#                       pid02   LIKE pid_file.pid02,
#                       pid03   LIKE pid_file.pid03,
#                       ima02_d LIKE ima_file.ima02,
#                       pie02   LIKE pie_file.pie02,
#                       pie03   LIKE pie_file.pie03,
#                       pie04   LIKE pie_file.pie04,
#                       pie05   LIKE pie_file.pie05,
#                       pie07   LIKE pie_file.pie07,
#                       pie153  LIKE pie_file.pie153,  #No.FUN-850127
#                       ima02   LIKE ima_file.ima02
#                   END RECORD,
#      l_ima02       LIKE ima_file.ima02,
#      l_barcode     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
#      l_i,l_j,l_len LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#      l_line        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#      l_control     LIKE type_file.chr5,    #No.FUN-690026 VARCHAR(5)
#      l_advance     LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#      l_ff          LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#      l_c           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#      l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#      l_01          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
#       
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.pid01,sr.order1,sr.order2,sr.order3,sr.pie07
# FORMAT
#  PAGE HEADER
#       LET l_line = 0
#       LET l_last_sw = 'y'     #FUN-550108
 
#  BEFORE GROUP OF sr.pid01
#       	#下列資料為條碼的控制碼資料
#       	LET l_control[1]=ascii 27	#ESC
#       	LET l_control[2]='*'		#*
#       	LET l_control[3]=ascii 33	#33 120 dots/inch
#       					#32  60 dots/inch
#       					#38  90 dots/inch
#       					#39 180 dots/inch
#       					#40 360 dots/inch
#       	LET l_ff[1]=ascii 255		#0xFF
#       	LET l_ff[2]=ascii 255		#0xFF
#       	LET l_ff[3]=ascii 255		#0xFF
#       	LET l_advance[1]=ascii 27	#ESC
#       	LET l_advance[2]='J'		#J
#       	LET l_advance[3]=ascii 21	#
#       LET g_pageno = 0
#       LET l_sw = 'Y'
 
#  ON EVERY ROW
#     IF l_sw = 'Y' THEN
#        LET g_pageno = g_pageno + 1
#        #抬頭(在製工單盤點標籤列印)
#        IF tm.size='N' THEN
#            PRINT g_x[31],g_x[32] CLIPPED
#
#            PRINT g_x[33] CLIPPED,COLUMN 30,g_x[20] CLIPPED,
#                  column 68, g_x[22] clipped,g_pageno using'<<<<',
#                  column 77,g_x[33] CLIPPED
#            PRINT g_x[33],COLUMN 77,g_x[34] CLIPPED
#           # PRINT COLUMN 36, g_x[34],COLUMN 40,g_x[35]
#        ELSE
#            PRINT ' '
#            PRINT ' '
#            PRINT ' '
#        END IF
#     	 IF tm.code='N' THEN
#              #	#不使用條碼時, 則往前跳躍90/180"
#              #	LET l_advance[3]=ascii 90
#              #	PRINT l_advance,column 77,g_x[33] CLIPPED
#           IF tm.size='N' THEN
#              PRINT g_x[33] CLIPPED,g_x[11] CLIPPED,
#                    column 12,sr.pid01 CLIPPED,
#                    column 58,g_x[23] clipped,tm.yearstr CLIPPED,
#                    column 77,g_x[33] CLIPPED
#              PRINT g_x[33],COLUMN 77,g_x[34]
#
#              PRINT g_x[33],COLUMN 77,g_x[34]
#
#              PRINT g_x[33],COLUMN 77,g_x[34]
#
#           ELSE PRINT column 12,sr.pid01 CLIPPED,
#                      column 63,tm.yearstr
#                SKIP 3 LINES
#           END IF
#    	ELSE
#         	#使用條碼(三九碼), 則以下列方式來列印
#      		#1.在單號前後各加上一個星號
#      		LET l_barcode='*',sr.pid01,'*'
#        	#2.將之轉換成01對應的碼
#      		CALL to01(l_barcode) RETURNING l_01
#      		#3.轉換成印表機的控制碼
#      		LET l_len=LENGTH(l_01) - 2   #總長度要減掉最後兩個多餘的00
#   		LET l_i=l_len / 256          #計算傳給印表機的資料個數
#   		LET l_j=l_len-(256*l_i)	     #算法:n=n2+n1*256 (n=length)
#   		LET l_control[4]=ascii l_j   #n2
#   		LET l_control[5]=ascii l_i   #n1
#   		FOR l_j=1 TO 3               #為方便條碼機閱讀, 列印三次
#   			PRINT COLUMN 12,l_control CLIPPED;
#   			FOR l_i=1 TO l_len   #將1轉換成FF
#                           LET l_c=l_01[l_i,l_i]       #將0轉換成00
#                           IF l_c='1' THEN PRINT l_ff CLIPPED;
#                           ELSE PRINT FILE '/nulls' END IF
#   			END FOR
#   			PRINT l_advance CLIPPED;PRINT '          ';
#   		END FOR
#   		LET l_advance[3]=ascii 27
#   		PRINT l_advance
#   	END IF
#       #不使用套版
#       IF tm.size='N' THEN
#          PRINT g_x[33] CLIPPED,g_x[12] clipped,' ',sr.pid02 CLIPPED,     #標籤編號
#                column 77,g_x[33] CLIPPED
#          PRINT g_x[33] CLIPPED,g_x[13] clipped,' ',sr.pid03 CLIPPED,     #生產料件
#                column 77,g_x[33] CLIPPED
#          PRINT g_x[33] CLIPPED,g_x[14] clipped,' ',sr.ima02_d CLIPPED,   #品名規格
#                column 77,g_x[33] CLIPPED
 
#          PRINT g_x[35],g_x[36]
 
#          PRINT g_x[24] clipped,g_x[25] clipped,
#                g_x[67] clipped,
#                g_x[27] clipped,
#                g_x[28] clipped
#          PRINT g_x[38],g_x[39] CLIPPED
#
#       ELSE
#          PRINT COLUMN 12,sr.pid02 CLIPPED     #工單編號
#          PRINT COLUMN 12,sr.pid03 CLIPPED     #生產料件
#          PRINT COLUMN 12,sr.ima02_d CLIPPED   #品名規格
#          PRINT ' '
#          PRINT ' '
#          PRINT ' '
#       END IF
#       LET l_sw = 'N'
#   END IF
 
#   IF tm.size = 'N' THEN
#       PRINT  g_x[33] CLIPPED,sr.pie05 CLIPPED, COLUMN 13,g_x[33] CLIPPED,sr.pie03 using '####', g_x[33] CLIPPED,
#                sr.pie02 CLIPPED,column 51,g_x[33] CLIPPED, sr.pie04 CLIPPED,COLUMN 57, g_x[33] CLIPPED,
#                         column 67, g_x[33] CLIPPED,column 77, g_x[33] CLIPPED
#   ELSE PRINT column 3,sr.pie05 CLIPPED,column 15,sr.pie03 CLIPPED,
#              column 21,sr.pie02 CLIPPED,column 53,sr.pie04[1,4]
#   END IF
 
#   LET l_line = l_line + 1
#   #列印品名規格
#   IF tm.a = 'Y' THEN
#      IF tm.size = 'N' THEN
#           PRINT  g_x[33] CLIPPED,column 13, g_x[33] CLIPPED,column 19, g_x[33] CLIPPED,
#                  sr.ima02 CLIPPED,
#                  column 51, g_x[33] CLIPPED,column 57, g_x[33] CLIPPED,
#                  column 67, g_x[33] CLIPPED,column 77, g_x[33] CLIPPED
#      ELSE PRINT column 21,sr.ima02 CLIPPED
#      END IF
#         LET l_line = l_line + 1
#   END IF
#   #No.FUN-850127---Begin                                                  
#   IF tm.c = 'Y' THEN 
#      IF tm.size = 'N' THEN                                                      
#         PRINT g_x[33] CLIPPED,COLUMN 13, g_x[33] CLIPPED,
#               COLUMN 15,g_x[69] CLIPPED,sr.pie153 USING "########",
#               COLUMN 47, g_x[33] CLIPPED,COLUMN 53, g_x[33] CLIPPED,       
#               COLUMN 65, g_x[33] CLIPPED,COLUMN 77, g_x[33] CLIPPED          
#      ELSE 
#         PRINT COLUMN 15,g_x[69] CLIPPED,sr.pie153         
#      END IF         
#      LET l_line = l_line + 1
#   END IF                                                                  
#   #No.FUN-850127---End 
#   #跳頁
#   IF tm.b = 'Y' THEN
#      IF tm.size = 'N' THEN
#           PRINT g_x[38],g_x[39] CLIPPED
#
#      ELSE PRINT ' '
#      END IF
#      LET l_line = l_line + 1
#   END IF
#
# AFTER GROUP OF sr.pid01
#     LET l_last_sw = 'y' ## FUN-550108
#   FOR l_i = l_line TO 41
#       IF tm.size = 'N' THEN
#          PRINT g_x[40],g_x[41] CLIPPED
#
#       ELSE PRINT ' '
#       END IF
#   END FOR
#   LET l_line = 0
 
## FUN-550108
# PAGE TRAILER
#   IF tm.size = 'N' THEN
#      PRINT g_x[42],g_x[43] CLIPPED
#    #  PRINT g_x[33] CLIPPED,g_x[18] clipped,column 22,g_x[21] clipped,
#    #        column 42,g_x[19] clipped,column 60,g_x[21] clipped,
#    #        column 77,g_x[33] CLIPPED
#    #  PRINT g_x[44],g_x[45] CLIPPED
#   ELSE SKIP 1 LINES
#   END IF
#   LET l_sw ='Y'
 
#   IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[18]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[18]
#            PRINT g_memo
#     END IF
## END FUN-550108
#END REPORT
 
#REPORT g801_rep2(sr)
#DEFINE l_last_sw	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#      sr               RECORD
#                       order1  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
#                       order2  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
#                       order3  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
#                       pid01   LIKE pid_file.pid01,
#                       pid02   LIKE pid_file.pid02,
#                       pid03   LIKE pid_file.pid03,
#                       ima02_d LIKE ima_file.ima02,
#                       pie02   LIKE pie_file.pie02,
#                       pie03   LIKE pie_file.pie03,
#                       pie04   LIKE pie_file.pie04,
#                       pie05   LIKE pie_file.pie05,
#                       pie07   LIKE pie_file.pie07,
#                       pie153  LIKE pie_file.pie153,  #No.FUN-850127
#                       ima02   LIKE ima_file.ima02
#                       END RECORD,
#      l_ima02          LIKE ima_file.ima02,
#      l_barcode        LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12),
#      l_i,l_j,l_len    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#      l_line           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#      l_control        LIKE type_file.chr5,    #No.FUN-690026 VARCHAR(5)
#      l_advance        LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#      l_ff             LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#      l_c              LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#      l_sw             LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#      l_01             LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
#       
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.pid01,sr.order1,sr.order2,sr.order3,sr.pie07
# FORMAT
 
#  PAGE HEADER
#       LET l_line = 0
#       LET l_last_sw = 'n'     #FUN-550108
#  BEFORE GROUP OF sr.pid01
#       	#下列資料為條碼的控制碼資料
#       	LET l_control[1]=ascii 27	#ESC
#       	LET l_control[2]='*'		#*
#       	LET l_control[3]=ascii 33	#33 120 dots/inch
#       					#32  60 dots/inch
#       					#38  90 dots/inch
#       					#39 180 dots/inch
#       					#40 360 dots/inch
#       	LET l_ff[1]=ascii 255		#0xFF
#       	LET l_ff[2]=ascii 255		#0xFF
#       	LET l_ff[3]=ascii 255		#0xFF
#       	LET l_advance[1]=ascii 27	#ESC
#       	LET l_advance[2]='J'		#J
#       	LET l_advance[3]=ascii 21	#
#       LET l_sw = 'Y'
#       LET g_pageno = 0
 
#  ON EVERY ROW
#     IF l_sw = 'Y' THEN
#        LET g_pageno = g_pageno + 1
#        #抬頭(在製工單盤點標籤列印)
#        IF tm.size='N' THEN
#            PRINT g_x[31],g_x[32] CLIPPED
#
#            PRINT g_x[33] CLIPPED,COLUMN 30,g_x[20] CLIPPED,
#                  column 68,g_x[22] clipped,g_pageno using'<<<<',
#                  column 77,g_x[33] CLIPPED
#            PRINT g_x[33],COLUMN 77,g_x[34] CLIPPED
#        ELSE
#            PRINT ' '
#            PRINT ' '
#            PRINT ' '
#        END IF
 
#     	 IF tm.code='N' THEN
#        #	#不使用條碼時, 則往前跳躍90/180"
#        #	LET l_advance[3]=ascii 90
#        #	PRINT l_advance,column 77,'│'
#          IF tm.size='N' THEN
#               PRINT g_x[33] CLIPPED,g_x[11] CLIPPED,
#                     column 12,sr.pid01 CLIPPED,
#                     column 58,g_x[23] clipped,tm.yearstr clipped,
#                     column 77,g_x[33] CLIPPED
#               PRINT g_x[33],COLUMN 77,g_x[34] CLIPPED
#               PRINT g_x[33],COLUMN 77,g_x[34] CLIPPED
#               PRINT g_x[33],COLUMN 77,g_x[34] CLIPPED
#          ELSE PRINT column 12,sr.pid01 CLIPPED,
#                     column 63,tm.yearstr
#               SKIP 3 LINES
#          END IF
#    	 ELSE
#   	 	#使用條碼(三九碼), 則以下列方式來列印
#   		#1.在單號前後各加上一個星號
#   		LET l_barcode='*',sr.pid01,'*'
#   		#2.將之轉換成01對應的碼
#   		CALL to01(l_barcode) RETURNING l_01
#   		#3.轉換成印表機的控制碼
#   		LET l_len=LENGTH(l_01) - 2	#總長度要減掉最後兩個多餘的00
#   		LET l_i=l_len / 256		#計算傳給印表機的資料個數
#   		LET l_j=l_len-(256*l_i)		#算法:n=n2+n1*256 (n=length)
#   		LET l_control[4]=ascii l_j	#n2
#   		LET l_control[5]=ascii l_i	#n1
#   		FOR l_j=1 TO 3			#為方便條碼機閱讀, 列印三次
#   			PRINT COLUMN 11,l_control CLIPPED;
#   			FOR l_i=1 TO l_len	#將1轉換成FF
#   				LET l_c=l_01[l_i,l_i]	#將0轉換成00
#   				IF l_c='1' THEN PRINT l_ff CLIPPED;
#   				ELSE PRINT FILE '/nulls' END IF
#   			END FOR
#   			PRINT l_advance CLIPPED;PRINT '          ';
#   		END FOR
#   		LET l_advance[3]=ascii 27
#   		PRINT l_advance CLIPPED
#   	END IF
 
#       #不使用套版
#       IF tm.size='N' THEN
#          PRINT g_x[33] CLIPPED,     g_x[12] clipped,sr.pid02 CLIPPED,     #工單編號
#                column 77,g_x[33] CLIPPED
#          PRINT g_x[33] CLIPPED,g_x[13] clipped,sr.pid03 CLIPPED,          #生產料件
#                column 77,g_x[33] CLIPPED
#          PRINT g_x[33] CLIPPED,g_x[14] clipped,sr.ima02_d CLIPPED,        #品名規格
#                column 77,g_x[33] CLIPPED
#          PRINT g_x[33] CLIPPED,g_x[15] clipped,sr.pie05 CLIPPED,          #工作站
#                column 77,g_x[33] CLIPPED
#          PRINT g_x[46],g_x[47] CLIPPED
#          PRINT g_x[30] clipped,g_x[26] clipped,
#                g_x[27] clipped,g_x[66] clipped,
#                g_x[29] clipped
#          PRINT g_x[49],g_x[50] CLIPPED
#       ELSE
#          PRINT COLUMN 12,sr.pid02 CLIPPED
#          PRINT COLUMN 12,sr.pid03 CLIPPED
#          PRINT COLUMN 12,sr.ima02_d CLIPPED
#          PRINT COLUMN 12,sr.pie05   CLIPPED
#          PRINT ' '
#          PRINT ' '
#          PRINT ' '
#       END IF
#       LET l_sw = 'N'
#   END IF
#   IF tm.size = 'N' THEN
#        PRINT  g_x[33] CLIPPED,sr.pie03 CLIPPED,column 13, g_x[33] CLIPPED,
#               sr.pie02,column 47, g_x[33] CLIPPED, sr.pie04 CLIPPED,column 53, g_x[33] CLIPPED,
#                        column 65, g_x[33] CLIPPED,column 77, g_x[33] CLIPPED
#   ELSE PRINT column 3,sr.pie03 CLIPPED,column 15,sr.pie02 CLIPPED,
#              column 49,sr.pie04[1,4] CLIPPED
#   END IF
 
#   LET l_line = l_line + 1
#   #列印品名規格
#   IF tm.a = 'Y' THEN
#      IF tm.size ='N' THEN
#           PRINT g_x[33] CLIPPED,column 13,g_x[33] CLIPPED,sr.ima02 CLIPPED,
#                 column 47,g_x[33] CLIPPED,column 53,g_x[33] CLIPPED,
#                 column 65,g_x[33] CLIPPED,column 77,g_x[33] CLIPPED
#      ELSE PRINT column 15,sr.ima02 CLIPPED
#      END IF
#      LET l_line = l_line + 1
#   END IF
 
#   #No.FUN-850127---Begin                                                      
#   IF tm.c = 'Y' THEN                                                          
#      IF tm.size = 'N' THEN                                                    
#         PRINT g_x[33] CLIPPED,COLUMN 13, g_x[33] CLIPPED,
#               COLUMN 15,g_x[69] CLIPPED,sr.pie153 USING "########", 
#               COLUMN 47, g_x[33] CLIPPED,COLUMN 53, g_x[33] CLIPPED,          
#               COLUMN 65, g_x[33] CLIPPED,COLUMN 77, g_x[33] CLIPPED           
#      ELSE                                                                     
#         PRINT COLUMN 15,g_x[69] CLIPPED,sr.pie153           
#      END IF                  
#      LET l_line = l_line + 1
#   END IF                                                                      
#   #No.FUN-850127---End   
 
#   #跳行
#   IF tm.b = 'Y' THEN
#      IF tm.size = 'N' THEN
#          PRINT g_x[49],g_x[50] CLIPPED
#      END IF
#      LET l_line = l_line + 1
#   END IF
#
# AFTER GROUP OF sr.pid01
#     LET l_last_sw = 'y' ## FUN-550108
#  #----------No.TQC-750100 modify
#  #FOR l_i = l_line TO 41
#   FOR l_i = l_line TO 40
#  #----------No.TQC-750100 end
#      IF tm.size = 'N' THEN
#         PRINT g_x[51],COLUMN 40,g_x[52] CLIPPED
#      ELSE PRINT ' '
#      END IF
#   END FOR
#   LET l_line = 0
 
## FUN-550108
# PAGE TRAILER
#   IF tm.size = 'N' THEN
#      PRINT g_x[53],g_x[54] CLIPPED
#    #  PRINT g_x[33] CLIPPED,g_x[18] clipped,column 22,g_x[21] clipped,
#    #        column 42,g_x[19] clipped,column 60,g_x[21] clipped,
#    #        column 77,g_x[33] CLIPPED
#    #  PRINT g_x[44],g_x[45] CLIPPED
#   ELSE SKIP 1 LINES
#   END IF
#   LET l_sw ='Y'
 
#   IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[18]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[18]
#            PRINT g_memo
#     END IF
## END FUN-550108
 
#END REPORT
 
#REPORT g801_rep3(sr)
#DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#      sr            RECORD
#                    order1  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
#                    order2  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
#                    order3  LIKE pid_file.pid01,  #No.FUN-690026 VARCHAR(20)
#                    pid01   LIKE pid_file.pid01,
#                    pid02   LIKE pid_file.pid02,
#                    pid03   LIKE pid_file.pid03,
#                    ima02_d LIKE ima_file.ima02,
#                    pie02   LIKE pie_file.pie02,
#                    pie03   LIKE pie_file.pie03,
#                    pie04   LIKE pie_file.pie04,
#                    pie05   LIKE pie_file.pie05,
#                    pie07   LIKE pie_file.pie07,
#                    pie153  LIKE pie_file.pie153,  #No.FUN-850127
#                    ima02   LIKE ima_file.ima02
#                    END RECORD,
#      l_ima02       LIKE ima_file.ima02,
#      l_barcode     LIKE type_file.chr20,   #No.FUN-690026 VARCHAR(12)
#      l_i,l_j,l_len LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#      l_line        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#      l_control     LIKE type_file.chr5,    #No.FUN-690026 VARCHAR(5)
#      l_advance     LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#      l_ff          LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(3)
#      l_c           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#      l_sw          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#      l_01          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(300)
#       
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.pid01,sr.pie07,sr.order1,sr.order2,sr.order3
# FORMAT
#  PAGE HEADER
#       LET l_line = 0
#       LET l_last_sw = 'n'     #FUN-550108
#  BEFORE GROUP OF sr.pid01
#       	#下列資料為條碼的控制碼資料
#       	LET l_control[1]=ascii 27	#ESC
#       	LET l_control[2]='*'		#*
#       	LET l_control[3]=ascii 33	#33 120 dots/inch
#       					#32  60 dots/inch
#       					#38  90 dots/inch
#       					#39 180 dots/inch
#       					#40 360 dots/inch
#       	LET l_ff[1]=ascii 255		#0xFF
#       	LET l_ff[2]=ascii 255		#0xFF
#       	LET l_ff[3]=ascii 255		#0xFF
#       	LET l_advance[1]=ascii 27	#ESC
#       	LET l_advance[2]='J'		#J
#       	LET l_advance[3]=ascii 21	#
#       LET l_sw = 'Y'
#       LET g_pageno = 0
 
#  ON EVERY ROW
#     IF l_sw = 'Y' THEN
#        LET g_pageno = g_pageno + 1
#        #抬頭(在製工單盤點標籤列印)
#        IF tm.size='N' THEN
#            PRINT g_x[31],g_x[32] CLIPPED
#
#            PRINT g_x[33] CLIPPED,COLUMN 30,g_x[20] CLIPPED,
#                  column 68,g_x[22] clipped,g_pageno using'<<<<',
#                  column 77,g_x[33] CLIPPED
#            PRINT g_x[33],COLUMN 77,g_x[34] CLIPPED
#        ELSE
#            PRINT ' '
#            PRINT ' '
#            PRINT ' '
#        END IF
 
 
#     	 IF tm.code='N' THEN
#        #	#不使用條碼時, 則往前跳躍90/180"
#        #	LET l_advance[3]=ascii 90
#        #	PRINT l_advance,column 77,'│'
#           IF tm.size='N' THEN
#                PRINT g_x[33] CLIPPED,g_x[11] CLIPPED,
#                      column 12,sr.pid01 CLIPPED,
#                      column 58,g_x[23] clipped,tm.yearstr clipped,
#                      column 77,g_x[33] CLIPPED
#                PRINT g_x[33],COLUMN 77,g_x[34] CLIPPED
#
#                PRINT g_x[33],COLUMN 77,g_x[34] CLIPPED
#
#                PRINT g_x[33],COLUMN 77,g_x[34] CLIPPED
#
#           ELSE PRINT column 12,sr.pid01 CLIPPED,
#                      column 63,tm.yearstr CLIPPED
#                PRINT ' '
#                PRINT ' '
#                PRINT ' '
#           END IF
#    	 ELSE
#   	 	#使用條碼(三九碼), 則以下列方式來列印
#   		#1.在單號前後各加上一個星號
#   		LET l_barcode='*',sr.pid01,'*'
#   		#2.將之轉換成01對應的碼
#   		CALL to01(l_barcode) RETURNING l_01
#   		#3.轉換成印表機的控制碼
#   		LET l_len=LENGTH(l_01) - 2	#總長度要減掉最後兩個多餘的00
#   		LET l_i=l_len / 256		#計算傳給印表機的資料個數
#   		LET l_j=l_len-(256*l_i)		#算法:n=n2+n1*256 (n=length)
#   		LET l_control[4]=ascii l_j	#n2
#   		LET l_control[5]=ascii l_i	#n1
#   		FOR l_j=1 TO 3			#為方便條碼機閱讀, 列印三次
#   			PRINT COLUMN 12,l_control CLIPPED;
#   			FOR l_i=1 TO l_len	#將1轉換成FF
#   				LET l_c=l_01[l_i,l_i]	#將0轉換成00
#   				IF l_c='1' THEN PRINT l_ff CLIPPED;
#   				ELSE PRINT FILE '/nulls' END IF
#   			END FOR
#   			PRINT l_advance CLIPPED;PRINT '          ';
#   		END FOR
#   		LET l_advance[3]=ascii 27
#   		PRINT l_advance
#   	END IF
 
#       #不使用套版
#       IF tm.size='N' THEN
#          PRINT g_x[33] CLIPPED,g_x[12] clipped,sr.pid02 CLIPPED,     #工單編號
#                column 77,g_x[33] CLIPPED
#          PRINT g_x[33] CLIPPED,g_x[13] clipped,sr.pid03 CLIPPED,          #生產料件
#                column 77,g_x[33] CLIPPED
#          PRINT g_x[33] CLIPPED,g_x[14] clipped,sr.ima02_d CLIPPED,        #品名規格
#                column 77,g_x[33] CLIPPED
#          PRINT g_x[55],g_x[56] CLIPPED
#
#          PRINT g_x[68] clipped,                                           #MOD-590022
#                g_x[27] clipped,
#                g_x[37] clipped
#          PRINT g_x[60],g_x[61] CLIPPED
#       ELSE
#          PRINT COLUMN 12,sr.pid02 CLIPPED
#          PRINT COLUMN 12,sr.pid03 CLIPPED     #工單編號
#          PRINT COLUMN 12,sr.ima02_d CLIPPED   #生產料件
#          PRINT ' '
#          PRINT ' '
#          PRINT ' '
#       END IF
#       LET l_sw = 'N'
#   END IF
#   IF tm.size = 'N' THEN
#        PRINT g_x[33] CLIPPED,sr.pie02 CLIPPED, column 39,g_x[33] CLIPPED,
#              sr.pie04[1,4],column 45,g_x[33] CLIPPED,column 61,
#              g_x[33] CLIPPED,column 77,g_x[33] CLIPPED
#   ELSE PRINT column 5,sr.pie02 CLIPPED,column 41,sr.pie04[1,4] CLIPPED
#   END IF
#   LET l_line = l_line + 1
#   #列印品名規格
#   IF tm.a = 'Y' THEN
#      IF tm.size ='N' THEN
#         PRINT g_x[33] CLIPPED,sr.ima02 CLIPPED,column 39,g_x[33] CLIPPED,
#                   column 45,g_x[33] CLIPPED,column 61,
#                   g_x[33] CLIPPED,column 77,g_x[33] CLIPPED
#      ELSE PRINT column 7,sr.ima02
#      END IF
#      LET l_line = l_line + 1
#   END IF
 
#   #No.FUN-850127---Begin                                                      
#   IF tm.c = 'Y' THEN                                                          
#      IF tm.size = 'N' THEN                                                    
#         PRINT g_x[33] CLIPPED,COLUMN 13, g_x[33] CLIPPED,
#               COLUMN 15,g_x[69] CLIPPED,sr.pie153 USING "########", 
#               COLUMN 47, g_x[33] CLIPPED,COLUMN 53, g_x[33] CLIPPED,          
#               COLUMN 65, g_x[33] CLIPPED,COLUMN 77, g_x[33] CLIPPED           
#      ELSE                                                                     
#         PRINT COLUMN 15,g_x[69] CLIPPED,sr.pie153        
#      END IF                     
#      LET l_line = l_line + 1 
#   END IF                                                                      
#   #No.FUN-850127---End   
 
#   #每料件是否要空行
#   IF tm.b = 'Y' THEN
#      IF tm.size ='N' THEN
#           PRINT g_x[60],g_x[61] CLIPPED
#
#      ELSE PRINT ' '
#      END IF
#      LET l_line = l_line + 1
#   END IF
#
# AFTER GROUP OF sr.pid01
#     LET l_last_sw = 'y' ## FUN-550108
#   FOR l_i = l_line TO 41
#     IF tm.size = 'N' THEN
#        PRINT g_x[62],g_x[63] CLIPPED
#     ELSE PRINT ' '
#     END IF
#   END FOR
#   LET l_line = 0
 
## FUN-550108
# PAGE TRAILER
#   IF tm.size = 'N' THEN
#      PRINT g_x[64],g_x[65] CLIPPED
#    #  PRINT g_x[33] CLIPPED,g_x[18] clipped,column 22,g_x[21] clipped,
#    #        column 42,g_x[19] clipped,column 60,g_x[21] clipped,
#    #        column 77,g_x[33] CLIPPED
#    # PRINT g_x[44],g_x[45] CLIPPED
#   ELSE SKIP 1 LINES
#   END IF
#   LET l_sw ='Y'
 
#   IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[18]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[18]
#            PRINT g_memo
#     END IF
## END FUN-550108
 
#END REPORT
 
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
#NO.FUN-870060--END---MARK---


###GENGRE###START
FUNCTION aimg801_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aimg801")
        IF handler IS NOT NULL THEN
            START REPORT aimg801_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY order1,order2,order3"         #FUN-B50018----add         
 
            DECLARE aimg801_datacur1 CURSOR FROM l_sql
            FOREACH aimg801_datacur1 INTO sr1.*
                OUTPUT TO REPORT aimg801_rep(sr1.*)
            END FOREACH
            FINISH REPORT aimg801_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aimg801_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_display STRING         #FUN-B50018----add

    
    ORDER EXTERNAL BY sr1.order1,sr1.order2,sr1.order3   #FUN-B50018----add

    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_sma.sma541   #FUN-C20052 add
              
#        BEFORE GROUP OF sr1.pid01              #FUN-B50018----mark
#            LET l_lineno = 0                   #FUN-B50018----mark

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            IF tm.c = "Y" AND tm.size = "N" THEN
               LET l_display = "Y"
            ELSE 
               LET l_display = "N"
            END IF
            PRINTX l_display

            PRINTX sr1.*

            PRINTX g_sma.sma54                  #FUN-B50018----add

#        AFTER GROUP OF sr1.pid01               #FUN-B50018----mark

        
#        ON LAST ROW                            #FUN-B50018----mark

END REPORT
###GENGRE###END
