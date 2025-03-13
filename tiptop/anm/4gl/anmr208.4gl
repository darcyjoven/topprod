# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr208.4gl
# Descriptions...: 總帳別應收票據月餘額明細表列表
# Input parameter:
# Return code....:
# Date & Author..: 01/01/11 By Payton
# Modify.........: No.7015 03/10/16 By Kitty 250行整行錯誤修改
# Modify.........: No.FUN-4C0098 04/12/26 By pengu 報表轉XML
# Modify.........: No.MOD-580071 05/08/17 By Smapmin nmh24無 'X'的狀況,將相關判斷移除
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-5A0212 05/10/21 By Smapmin l_sql 中,應增加 nmh38='Y' 的條件
# Modify.........: NO.TQC-5B0047 05/11/08 By Niocla 報表修改
# Modify.........: NO.MOD-5B0308 05/11/24 By kim 票況未顯示中文名
# Modify.........: No.MOD-640397 06/04/11 By Smapmin 將票況碼轉換成票況
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-760061 07/06/06 By Smapmin 抓取最接近截止日期的票況
# Modify.........: No.FUN-780011 07/09/07 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.MOD-870166 08/07/17 By Sarah 增加nmh29
# Modify.........: No.FUN-8B0027 08/12/01 By jan
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960097 09/09/02 By mike 建議應該同anmr108，可以依「會計科目」小計  
# Modify.........: No:FUN-A10098 10/01/18 By shiwuying GP5.2跨DB報表--財務類
# Modify.........: No.MOD-BA0176 11/10/26 By Polly PREPARE anmr208_prepare2 增加抓取 npn02 給予 nmh25 判斷
# Modify.........: No:MOD-C10189 12/02/06 By Polly 取消 nmh24=1 的設定
# Modify.........: No:FUN-C70019 12/07/11 By bart 增加列印新舊會計科目選項
# Modify.........: No:MOD-C70306 12/08/01 By Elise FETCH FIRST anmr208_curs2前先清空變數

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				               # Print condition RECORD
              wc  LIKE type_file.chr1000,  #No.FUN-680107 VARCHAR(600) #Where Condiction
          edate   LIKE type_file.dat,      #No.FUN-680107 DATE
              b   LIKE type_file.chr1,     #No.FUN-8B0027
             p1   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
             p2   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
             p3   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
             p4   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
             p5   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
             p6   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
             p7   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
             p8   LIKE azp_file.azp01,     #No.FUN-8B0027 VARCHAR(10)
           type   LIKE type_file.chr1,     #No.FUN-8B0027
              s   LIKE type_file.chr6,     #No.FUN-680107 VARCHAR(2) #排列順序
              t   LIKE type_file.chr3,     #No.FUN-680107 VARCHAR(2) #跳頁否
              u   LIKE type_file.chr3,     #No.FUN-680107 VARCHAR(2) #合計否
#             v   LIKE type_file.chr1,     #FUN-C70019 belle mark
           more   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1) #額外摘要是否列印
              END RECORD,
        g_bookno  LIKE aba_file.aba00      #帳別編號
          #l_dash VARCHAR(132),               # Dash line "-"
 
DEFINE   g_cnt    LIKE type_file.num10     #No.FUN-680107 INTEGER
DEFINE   g_i      LIKE type_file.num5      #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_head1  STRING
DEFINE   l_table  STRING  #No.FUN-780011
DEFINE   g_str    STRING  #No.FUN-780011
DEFINE   g_sql    STRING  #No.FUN-780011
DEFINE   m_dbs      ARRAY[10] OF LIKE type_file.chr20              #No.FUN-8B0027 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #No.FUN-780011  --Begin
   LET g_sql="nmh01.nmh_file.nmh01,nmh05.nmh_file.nmh05,",
             "nmh06.nmh_file.nmh06,nmh10.nmh_file.nmh10,",
             "nmh11.nmh_file.nmh11,nmh30.nmh_file.nmh30,",
             "occ11.occ_file.occ11,nmh31.nmh_file.nmh31,",
             "nmh32.nmh_file.nmh32,nmh33.nmh_file.nmh33,",
             "nmh34.nmh_file.nmh34,nmh35.nmh_file.nmh35,",
             "l_nmd24.ze_file.ze03,nmh29.nmh_file.nmh29,",   #MOD-870166 add nmh29
             "nmh03.nmh_file.nmh03,nmh02.nmh_file.nmh02,",   #FUN-960097    
             "nmh26.nmh_file.nmh26,",   #FUN-960097     
             " plant.azp_file.azp01,"         #FUN-8B0027 
#            "aag02_1.aag_file.aag02,aan05.aan_file.aan05,aag02_2.aag_file.aag02"  #FUN-C70019 belle mark
 
   LET l_table = cl_prt_temptable('anmr208',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              #" VALUES(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,?)"   #MOD-870166 add ?#FUN-8B0027 add ?  #FUN-960097 add ??? #FUN-C70019 add 3? #belle mark 
               " VALUES(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?,?)"   #MOD-870166 add ?#FUN-8B0027 add ?  #FUN-960097 add ???
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780011  --End
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)		# Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.s  = ARG_VAL(10)
   LET tm.t  = ARG_VAL(11)
   LET tm.u  = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
  #FUN-A10098 -BEGIN-----
  ##FUN-8B0027--BEGIN-- 
  #LET tm.b =  ARG_VAL(17)
  #LET tm.p1 = ARG_VAL(18)
  #LET tm.p2 = ARG_VAL(19)
  #LET tm.p3 = ARG_VAL(20)
  #LET tm.p4 = ARG_VAL(21)
  #LET tm.p5 = ARG_VAL(22)
  #LET tm.p6 = ARG_VAL(23)
  #LET tm.p7 = ARG_VAL(24)
  #LET tm.p8 = ARG_VAL(25)
  #LET tm.type = ARG_VAL(26)
  ##FUN-8B0027--END-- 
   LET tm.type = ARG_VAL(17)
  #LET tm.v = ARG_VAL(18)  #FUN-C70019 belle mark 
  #FUN-A10098 -END-------
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL anmr208_tm()	        	# Input print condition
      ELSE CALL anmr208()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr208_tm()
DEFINE lc_qbe_sn       LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_cmd        LIKE type_file.chr1000,       #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
          l_jmp_flag   LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
   DEFINE li_result    LIKE type_file.num5           #No.FUN-940102
 
   LET p_row = 4 LET p_col = 13
   OPEN WINDOW anmr208_w AT p_row,p_col
        WITH FORM "anm/42f/anmr208"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s = '12'
   LET tm.t = '  '
#  LET tm.v = 'N'  #FUN-C70019 belle mark
   LET tm.more = 'N'
   LET tm.edate = g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_jmp_flag = 'N'
   #FUN-8B0027-Begin--#                                                                                                             
   LET tm.b ='N'
   LET tm.type = '3'
   LET tm.p1=g_plant
 #No.FUN-A10098 -BEGIN-------
 # CALL r208_set_entry_1()
 # CALL r208_set_no_entry_1()
   CALL r208_set_comb()
 #No.FUN-A10098 -END-------
   #FUN-8B0027-End--#
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmh11,nmh06,nmh05,nmh01,nmh31,nmh26,nmh10,nmh29 #FUN-960097 add nmh26
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
 
      #FUN-960097   ---start                                                                                                         
      ON ACTION CONTROLP                                                                                                            
         IF INFIELD(nmh26) THEN                                                                                                     
            CALL cl_init_qry_var()                                                                                                  
            LET g_qryparam.state = "c"                                                                                              
            LET g_qryparam.form ="q_aag"                                                                                            
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                      
            DISPLAY g_qryparam.multiret TO nmh26                                                                                    
         END IF                                                                                                                     
     #FUN-960097   ----end      
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
 END CONSTRUCT
 LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
		
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr208_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
  #No.FUN-A10098 -BEGIN-----
  #INPUT BY NAME tm.edate,
  #              tm.b,tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.type,   #FUN-8B0027
  #              tm2.s1,tm2.s2,
  #              tm2.t1,tm2.t2,
  #              tm2.u1,tm2.u2,
  #              tm.more
  #              WITHOUT DEFAULTS
  #INPUT BY NAME tm.edate,tm.type,tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm2.u1,tm2.u2,tm.v,tm.more   #FUN-C70019 belle mark
   INPUT BY NAME tm.edate,tm.type,tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm2.u1,tm2.u2,tm.more        #FUN-C70019
                 WITHOUT DEFAULTS
  #No.FUN-A10098 -END-------
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF tm.edate IS NULL THEN NEXT FIELD edate END IF

     #No.FUN-A10098 -BEGIN-----
     ##FUN-8B0027--Begin--#
     #AFTER FIELD b
     #    IF NOT cl_null(tm.b)  THEN
     #       IF tm.b NOT MATCHES "[YN]" THEN 
     #          NEXT FIELD b
     #       END IF
     #    END IF 
 
     # ON CHANGE  b
     #    LET tm.p1=g_plant
     #    LET tm.p2=NULL
     #    LET tm.p3=NULL
     #    LET tm.p4=NULL
     #    LET tm.p5=NULL
     #    LET tm.p6=NULL
     #    LET tm.p7=NULL
     #    LET tm.p8=NULL
     #    DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8
     #    CALL r208_set_entry_1()
     #    CALL r208_set_no_entry_1()
     #    CALL r208_set_comb()
 
     #AFTER FIELD type
     #   IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN 
     #      NEXT FIELD type
     #   END IF
 
     #AFTER FIELD p1
     #   IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
     #   SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
     #   IF STATUS THEN
     #      CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)
     #      NEXT FIELD p1
     #   END IF
     ##No.FUN-940102 --begin--
     #         CALL s_chk_demo(g_user,tm.p1) RETURNING li_result
     #          IF not li_result THEN 
     #           NEXT FIELD p1
     #          END IF 
     ##No.FUN-940102 --end-- 
 
     #AFTER FIELD p2
     #   IF NOT cl_null(tm.p2) THEN
     #      SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
     #      IF STATUS THEN
     #         CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)
     #         NEXT FIELD p2
     #      END IF 
     ##No.FUN-940102 --begin--
     #         CALL s_chk_demo(g_user,tm.p2) RETURNING li_result
     #          IF not li_result THEN 
     #           NEXT FIELD p2
     #          END IF 
     ##No.FUN-940102 --end-- 
     #   END IF
 
     #FTER FIELD p3
     #   IF NOT cl_null(tm.p3) THEN
     #      SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
     #      IF STATUS THEN
     #         CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)
     #         NEXT FIELD p3
     #      END IF 
     #No.FUN-940102 --begin--
     #         CALL s_chk_demo(g_user,tm.p3) RETURNING li_result
     #          IF not li_result THEN 
     #           NEXT FIELD p3
     #          END IF 
     #No.FUN-940102 --end-- 
     #   END IF
 
     #AFTER FIELD p4
     #   IF NOT cl_null(tm.p4) THEN
     #      SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
     #      IF STATUS THEN
     #         CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)
     #         NEXT FIELD p4
     #      END IF
     #No.FUN-940102 --begin--
     #         CALL s_chk_demo(g_user,tm.p4) RETURNING li_result
     #          IF not li_result THEN 
     #           NEXT FIELD p4
     #          END IF 
     #No.FUN-940102 --end-- 
     #   END IF
 
     #FTER FIELD p5
     #   IF NOT cl_null(tm.p5) THEN
     #      SELECT azp01 FROM azp_file WHERE azp01 = tm.p5 
     #      IF STATUS THEN
     #         CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)
     #         NEXT FIELD p5 
     #      END IF
     #No.FUN-940102 --begin--
     #         CALL s_chk_demo(g_user,tm.p5) RETURNING li_result
     #          IF not li_result THEN 
     #           NEXT FIELD p5
     #          END IF 
     #No.FUN-940102 --end-- 
     #   END IF
 
     #AFTER FIELD p6
     #   IF NOT cl_null(tm.p6) THEN
     #      SELECT azp01 FROM azp_file WHERE azp01 = tm.p6 
     #      IF STATUS THEN 
     #         CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1) 
     #         NEXT FIELD p6 
     #      END IF
     #No.FUN-940102 --begin--
     #         CALL s_chk_demo(g_user,tm.p6) RETURNING li_result
     #          IF not li_result THEN 
     #           NEXT FIELD p6
     #          END IF 
     #No.FUN-940102 --end-- 
     #   END IF
 
     #AFTER FIELD p7
     #   IF NOT cl_null(tm.p7) THEN 
     #      SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
     #      IF STATUS THEN
     #         CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
     #         NEXT FIELD p7 
     #      END IF
     #No.FUN-940102 --begin--
     #         CALL s_chk_demo(g_user,tm.p7) RETURNING li_result
     #          IF not li_result THEN 
     #           NEXT FIELD p7
     #          END IF 
     #No.FUN-940102 --end-- 
     #   END IF
 
     #AFTER FIELD p8
     #   IF NOT cl_null(tm.p8) THEN
     #      SELECT azp01 FROM azp_file WHERE azp01 = tm.p8 
     #      IF STATUS THEN
     #         CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)
     #         NEXT FIELD p8
     #      END IF
     #No.FUN-940102 --begin--
     #         CALL s_chk_demo(g_user,tm.p8) RETURNING li_result
     #          IF not li_result THEN 
     #           NEXT FIELD p8
     #          END IF 
     #No.FUN-940102 --end-- 
     #   END IF
     ##FUN-8B0027--END--   
     #No.FUN-A10098 -END-------
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
    #No.FUN-A10098 -BEGIN-----
    ##FUN-8B0027--Begin--#                                                                                                            
    # ON ACTION CONTROLP
    #    CASE
    #       WHEN INFIELD(p1)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form ="q_azp"    #No.FUN-940102
    #          LET g_qryparam.form ="q_zxy"    #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user    #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p1
    #          CALL cl_create_qry() RETURNING tm.p1
    #          DISPLAY BY NAME tm.p1 
    #          NEXT FIELD p1
    #       WHEN INFIELD(p2)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form ="q_azp"    #No.FUN-940102
    #          LET g_qryparam.form ="q_zxy"    #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user    #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p2
    #          CALL cl_create_qry() RETURNING tm.p2 
    #          DISPLAY BY NAME tm.p2
    #          NEXT FIELD p2
    #       WHEN INFIELD(p3)
    #          CALL cl_init_qry_var() 
#   #          LET g_qryparam.form ="q_azp"    #No.FUN-940102
    #          LET g_qryparam.form ="q_zxy"    #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user    #No.FUN-940102 
    #          LET g_qryparam.default1 = tm.p3
    #          CALL cl_create_qry() RETURNING tm.p3 
    #          DISPLAY BY NAME tm.p3
    #          NEXT FIELD p3
    #       WHEN INFIELD(p4)
    #          CALL cl_init_qry_var() 
#   #          LET g_qryparam.form ="q_azp"    #No.FUN-940102
    #          LET g_qryparam.form ="q_zxy"    #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user    #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p4 
    #          CALL cl_create_qry() RETURNING tm.p4
    #          DISPLAY BY NAME tm.p4 
    #          NEXT FIELD p4
    #       WHEN INFIELD(p5)
    #          CALL cl_init_qry_var() 
#   #          LET g_qryparam.form ="q_azp"    #No.FUN-940102
    #          LET g_qryparam.form ="q_zxy"    #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user    #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p5 
    #          CALL cl_create_qry() RETURNING tm.p5
    #          DISPLAY BY NAME tm.p5 
    #          NEXT FIELD p5
    #       WHEN INFIELD(p6)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form ="q_azp"    #No.FUN-940102
    #          LET g_qryparam.form ="q_zxy"    #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user    #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p6
    #          CALL cl_create_qry() RETURNING tm.p6
    #          DISPLAY BY NAME tm.p6
    #          NEXT FIELD p6
    #       WHEN INFIELD(p7)
    #          CALL cl_init_qry_var() 
#   #          LET g_qryparam.form ="q_azp"    #No.FUN-940102
    #          LET g_qryparam.form ="q_zxy"    #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user    #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p7 
    #          CALL cl_create_qry() RETURNING tm.p7
    #          DISPLAY BY NAME tm.p7
    #          NEXT FIELD p7
    #       WHEN INFIELD(p8)
    #          CALL cl_init_qry_var()
#   #          LET g_qryparam.form ="q_azp"    #No.FUN-940102
    #          LET g_qryparam.form ="q_zxy"    #No.FUN-940102
    #          LET g_qryparam.arg1 = g_user    #No.FUN-940102
    #          LET g_qryparam.default1 = tm.p8 
    #          CALL cl_create_qry() RETURNING tm.p8 
    #          DISPLAY BY NAME tm.p8
    #          NEXT FIELD p8
    #    END CASE
    #   #FUN-8B0027--END--
    #No.FUN-A10098 -END-------
    AFTER INPUT
      LET l_jmp_flag = 'N'
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.t = tm2.t1,tm2.t2
      LET tm.u = tm2.u1,tm2.u2
      IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr208_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='anmr208'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr208','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
			 " '",g_bookno CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                        #No.FUN-A10098 -BEGIN-----
                        #" '",tm.b   CLIPPED,"'",   #FUN-8B0027
                        #" '",tm.p1   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p2   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p3   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p4   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p5   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p6   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p7   CLIPPED,"'",  #FUN-8B0027
                        #" '",tm.p8   CLIPPED,"'",  #FUN-8B0027
                        #No.FUN-A10098 -END-------
                         " '",tm.type CLIPPED,"'"   #FUN-8B0027
#                        " '",tm.v    CLIPPED,"'"   #FUN-C70019 belle mark 
         CALL cl_cmdat('anmr208',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW anmr208_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr208()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr208_w
END FUNCTION
 
FUNCTION anmr208()
   DEFINE l_name       LIKE type_file.chr20, 	          # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#         l_time       LIKE type_file.chr8	          #No.FUN-6A0082
          #l_sql       LIKE type_file.chr1000,	          # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)   #TQC-760061
          l_sql,l_sql2 STRING,  		          # RDSQL STATEMENT   #TQC-760061
          l_za05       LIKE type_file.chr1000,            #標題內容 #No.FUN-680107 VARCHAR(40)
          l_order      ARRAY[2] OF LIKE nmh_file.nmh01,   #No.FUN-680107 ARRAY[2] OF VARCHAR(20) #排列順序
          l_i          LIKE type_file.num5,               #No.FUN-680107 SMALLINT
          l_nmd24      LIKE ze_file.ze03,                 #No.FUN-780011 
          sr           RECORD
                         order1   LIKE nmh_file.nmh01,    #No.FUN-680107 VARCHAR(10) #排列順序-1
                         order2   LIKE nmh_file.nmh01,    #No.FUN-680107 VARCHAR(10) #排列順序-2
                         g_nmh    RECORD LIKE nmh_file.*,
                         occ11    LIKE occ_file.occ11,    #MOD-5A0212
                         occ37    LIKE occ_file.occ37     #FUN-8B0027
#                        pmc24    LIKE pmc_file.pmc24     #MOD-5A0212
                       END RECORD
   DEFINE l_npn02    LIKE npn_file.npn02                 #MOD-BA0176 add
   DEFINE l_npn03    LIKE npn_file.npn03                 #TQC-760061
   DEFINE l_i1       LIKE type_file.num5                 #No.FUN-8B0027 SMALLINT
   DEFINE l_dbs      LIKE azp_file.azp03                 #No.FUN-8B0027
   DEFINE l_azp03    LIKE azp_file.azp03                 #No.FUN-8B0027
   DEFINE i          LIKE type_file.num5                 #No.FUN-8B0027
   DEFINE l_pmc903   LIKE pmc_file.pmc903                #No;FUN-8B0027
  #DEFINE l_aan05    LIKE aan_file.aan05  #FUN-C70019  belle mark
  #DEFINE l_aag02_1  LIKE aag_file.aag02  #FUN-C70019  belle mark
  #DEFINE l_aag02_2  LIKE aag_file.aag02  #FUN-C70019  belle mark
   
   #No.FUN-780011  --Begin
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #No.FUN-780011  --End
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang

  #No.FUN-A10098 -BEGIN----- 
  #FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
  #LET m_dbs[1]=tm.p1
  #LET m_dbs[2]=tm.p2
  #LET m_dbs[3]=tm.p3
  #LET m_dbs[4]=tm.p4
  #LET m_dbs[5]=tm.p5
  #LET m_dbs[6]=tm.p6
  #LET m_dbs[7]=tm.p7
  #LET m_dbs[8]=tm.p8
  ##FUN-8B0027--End--#
 
  #FOR l_i1 = 1 to 8
  #    IF cl_null(m_dbs[l_i1]) THEN CONTINUE FOR END IF                       #FUN-8B0027 
  #    SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i1]          #FUN-8B0027 
  #    LET l_azp03 = l_dbs CLIPPED                                            #FUN-8B0027 
  #    LET l_dbs = s_dbstring(l_dbs CLIPPED)                                          #FUN-8B0027
  #No.FUN-A10098 -END-------
#  LET l_sql = "SELECT '','',nmh_file.* ,pmc24  ",   #MOD-5A0212
   LET l_sql = "SELECT '','',nmh_file.* ,occ11,occ37  ",    #MOD-5A0212 #FUN-8B0027 add occ37
#              " FROM nmh_file, ",   #FUN-8B0027 mark
#              " OUTER pmc_file ",   #MOD-5A0212
#              " OUTER occ_file ",   #MOD-5A0212 #FUN-8B0027 mark
             #No.FUN-A10098 -BEGIN-----
             # "  FROM ",l_dbs CLIPPED,"nmh_file LEFT OUTER JOIN ",l_dbs CLIPPED,"occ_file ON nmh11=occ01",   #FUN-8B0027
               "  FROM nmh_file LEFT OUTER JOIN occ_file ON nmh11 = occ01",
             #No.FUN-A10098 -END-------
               " WHERE ",tm.wc CLIPPED,
#              "   AND nmh22=pmc_file.pmc01  ",   #MOD-5A0212
               "   AND nmh38='Y'    ",   #MOD-5A0212
               "   AND nmh04 <= '",tm.edate,"'",
               "   AND (nmh35 IS NULL OR nmh35 > '",tm.edate,"')"
 
   PREPARE anmr208_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM 
   END IF
   DECLARE anmr208_curs1 CURSOR FOR anmr208_prepare1
   #No.FUN-780011  --Begin
   #CALL cl_outnam('anmr208') RETURNING l_name
   #START REPORT anmr208_rep TO l_name
   #LET g_pageno = 0
   #No.FUN-780011  --End  
 
   LET g_cnt    = 1
   FOREACH anmr208_curs1 INTO sr.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #FUN-8B0027--BEGIN--
      IF cl_null(sr.occ37) THEN LET sr.occ37 = 'N' END IF
      IF tm.type = '1' THEN
         IF sr.occ37 = 'N' THEN  CONTINUE FOREACH END IF                                                                            
      END IF                                                                                                                        
      IF tm.type = '2' THEN                                                                                                         
         IF sr.occ37  = 'Y' THEN  CONTINUE FOREACH END IF                                                                            
      END IF
      #FUN-8B0027--END--
      #-----TQC-760061---------
      LET l_npn03 = ''
      LET l_npn02 = ''   #MOD-C70306 add
     #LET l_sql2 = "SELECT npn03 ",                   #MOD-BA0176 mark
      LET l_sql2 = "SELECT npn02,npn03 ",             #MOD-BA0176 add
                 #No.FUN-A10098 -BEGIN-----
                 # "  FROM ",l_dbs CLIPPED,"npn_file,",l_dbs CLIPPED,"npo_file",   #FUN-8B0027
                   "  FROM npn_file,npo_file",
                 #No.FUN-A10098 -END-------
                   " WHERE npn01 = npo01 AND ",
                   "       npo03 = '",sr.g_nmh.nmh01,"' AND",
                   "       npn02 <='",tm.edate,"' AND", 
                 # "       npn02 = (SELECT MAX(npn02) FROM ",l_dbs CLIPPED,"npn_file,",l_dbs CLIPPED,"npo_file ",  #FUN-8B0027 #No.FUN-A10098
                   "       npn02 = (SELECT MAX(npn02) FROM npn_file,npo_file ", #No.FUN-A10098
                   "                 WHERE npn01 = npo01 AND ",
                   "                       npo03 = '",sr.g_nmh.nmh01,"' AND", 
                   "                npn02 <= '",tm.edate,"') AND ",
                   "       npn02 = '",sr.g_nmh.nmh25,"' AND",             #MOD-BA0176 add
                   " npnconf = 'Y'",
                   " ORDER BY npn03 DESC"
      PREPARE anmr208_prepare2 FROM l_sql2
      DECLARE anmr208_curs2 SCROLL CURSOR FOR anmr208_prepare2
      OPEN anmr208_curs2
     #FETCH FIRST anmr208_curs2 INTO l_npn03              #MOD-BA0176 mark
      FETCH FIRST anmr208_curs2 INTO l_npn02,l_npn03      #MOD-BA0176 add
      IF NOT cl_null(l_npn03) THEN
         LET sr.g_nmh.nmh24 = l_npn03  
     #ELSE                                     #MOD-C10189 mark
     #   LET sr.g_nmh.nmh24 = '1'              #MOD-C10189 mark
      END IF 
      IF NOT cl_null(l_npn02) THEN             #MOD-BA0176 add
         LET sr.g_nmh.nmh25 = l_npn02          #MOD-BA0176 add
      END IF                                   #MOD-BA0176 add
      #-----END TQC-760061-----  
 #    IF sr.g_nmh.nmh24 MATCHES '[56789]' AND sr.g_nmh.nmh25 <= tm.edate THEN      #No:7015   #MOD-580071
      IF sr.g_nmh.nmh24 MATCHES '[5678]' AND sr.g_nmh.nmh25 <= tm.edate THEN      #No:7015   #MOD-580071
         CONTINUE FOREACH
      END IF
      #No.FUN-780011  --Begin
      #FOR l_i = 1 TO 2
      #    CASE WHEN tm.s[l_i,l_i] = '1' LET l_order[l_i] = sr.g_nmh.nmh11
      #         WHEN tm.s[l_i,l_i] = '2' LET l_order[l_i] = sr.g_nmh.nmh06
      #         WHEN tm.s[l_i,l_i] = '3' LET l_order[l_i] = sr.g_nmh.nmh05
      #                                                     USING 'YYYYMMDD'
      #         WHEN tm.s[l_i,l_i] = '4' LET l_order[l_i] = sr.g_nmh.nmh01
      #         WHEN tm.s[l_i,l_i] = '5' LET l_order[l_i] = sr.g_nmh.nmh31
      #         WHEN tm.s[l_i,l_i] = '6' LET l_order[l_i] = sr.g_nmh.nmh10
      #         WHEN tm.s[l_i,l_i] = '7' LET l_order[l_i] = sr.g_nmh.nmh35
      #         OTHERWISE LET l_order[l_i] = '-'
      #    END CASE
      #END FOR
      #LET sr.order1 = l_order[1]
      #LET sr.order2 = l_order[2]
      #OUTPUT TO REPORT anmr208_rep(sr.*)
      LET l_nmd24=''
      IF NOT cl_null(sr.g_nmh.nmh24) THEN
         CALL s_nmh24(sr.g_nmh.nmh24) RETURNING l_nmd24   #MOD-640397
         LET l_nmd24=sr.g_nmh.nmh24,':',l_nmd24
      END IF
     #belle mark--s--
     ##FUN-C70019---BEGIN
     #LET l_aan05 = NULL
     #LET l_aag02_1 = NULL
     #LET l_aag02_2 = NULL
     #SELECT aag02 INTO l_aag02_1
     #  FROM aag_file
     # WHERE aag01 = sr.g_nmh.nmh26
     #   AND aag00 = g_aza.aza81
     #SELECT aan05,aag02 INTO l_aan05,l_aag02_2
     #  FROM aan_file left OUTER JOIN aag_file ON (aag01 = aan05 AND aag00 = g_aza.aza81)
     # WHERE aan071 = sr.g_nmh.nmh01
     #   AND aan03 = 'nmh_file'
     ##FUN-C70019---END 
     #belle mark--e--
      EXECUTE insert_prep USING
         sr.g_nmh.nmh01,sr.g_nmh.nmh05,sr.g_nmh.nmh06,sr.g_nmh.nmh10,
         sr.g_nmh.nmh11,sr.g_nmh.nmh30,sr.occ11,      sr.g_nmh.nmh31,
         sr.g_nmh.nmh32,sr.g_nmh.nmh33,sr.g_nmh.nmh34,sr.g_nmh.nmh35,
         l_nmd24,       sr.g_nmh.nmh29,sr.g_nmh.nmh03,sr.g_nmh.nmh02, #MOD-870166 add nmh29 #FUN-960097 add nmh03,nmh02    
      #  sr.g_nmh.nmh26,m_dbs[l_i1]   #FUN-8B0027 #FUN-960097 add nmh26 #No.FUN-A10098
         sr.g_nmh.nmh26,''            #No.FUN-A10098
      #   ,l_aag02_1,l_aan05,l_aag02_2 #FUN-C70019 belle mark
      #No.FUN-780011  --End  
 
   END FOREACH
 # END FOR    #FUN-8B0027  #No.FUn-A10098
 
   #No.FUN-780011  --Begin
   #FINISH REPORT anmr208_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'nmh11,nmh06,nmh05,nmh01,nmh31,nmh26,nmh10,nmh29') #FUN-960097 add nmh26 
           RETURNING g_str
   END IF
   LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t,";",tm.u,";",
   #           g_azi04,";",g_azi05,";",tm.b     #FUN-8B0027 #No.FUN-A10098
               g_azi04,";",g_azi05,";",'N'      #No.FUN-A10098
  #belle mark--s--
  ##FUN-C70019---begin
  #IF tm.v = 'Y' THEN
  #   CALL cl_prt_cs3('anmr208','anmr208_1',g_sql,g_str)
  #ELSE 
  ##FUN-C70019---end
  #belle mark--e--
      CALL cl_prt_cs3('anmr208','anmr208',g_sql,g_str)
  #END IF #FUN-C70019 belle mark
   #No.FUN-780011  --End  
END FUNCTION

#No.FUN-A10098 -BEGIN----- 
##FUN-8B0027--Begin--#
#FUNCTION r208_set_entry_1()
#   CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION r208_set_no_entry_1()
#   IF tm.b = 'N' THEN
#      CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#      IF tm2.s1 = '9' THEN #FUN-960097 8-->9     
#         LET tm2.s1 = ' '
#      END IF
#      IF tm2.s2 = '9' THEN #FUN-960097 8-->9    
#         LET tm2.s2 = ' '
#      END IF
#   END IF
#END FUNCTION

 FUNCTION r208_set_comb()
  DEFINE comb_value STRING
  DEFINE comb_item  LIKE type_file.chr1000 
 
#   IF tm.b ='N' THEN 
       LET comb_value = '1,2,3,4,5,6,7,8' #FUN-960097 add 8        
       SELECT ze03 INTO comb_item FROM ze_file
         WHERE ze01='anm-917' AND ze02=g_lang

#   ELSE
#      LET comb_value = '1,2,3,4,5,6,7,8,9' #FUN-960097 add 9     
#      SELECT ze03 INTO comb_item FROM ze_file
#        WHERE ze01='anm-919' AND ze02=g_lang
#   END IF
    CALL cl_set_combo_items('s1',comb_value,comb_item)
    CALL cl_set_combo_items('s2',comb_value,comb_item)
 END FUNCTION
##FUN-8B0027--End--# 
#No.FUN-A10098 -END-------

#No.FUN-780011  --Begin
#REPORT anmr208_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#		      l_p_flag  LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#          l_nmd24   LIKE type_file.chr8,   #No.FUN-680107 #MOD-5B0308
#          l_flag1   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#		      l_nmh12   LIKE nmh_file.nmh12,   #No.FUN-680107 VARCHAR(4)
#		      l_nmh14   LIKE nmh_file.nmh12,   #No.FUN-680107 VARCHAR(4)
#          l_count   LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(10)
#          l_str     LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(20)
#          l_zero    LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#		      l_cnt_1   LIKE type_file.num5,   #No.FUN-680107 SMALLINT   #group 1 合計票據張數
#		      l_cnt_2   LIKE type_file.num5,   #No.FUN-680107 SMALLINT   #group 2 合計票據張數
#		      l_cnt_tot LIKE type_file.num5,   #No.FUN-680107 SMALLINT
#          l_total   LIKE nmh_file.nmh32,   #票面金額合計
#          l_orderA  ARRAY[2] OF LIKE nmh_file.nmh01,      #No.FUN-680107 ARRAY[2] OF VARCHAR(20) #排序名稱
#          sr               RECORD
#                           order1    LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10) #排列順序-1
#                           order2    LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10) #排列順序-2
#					   g_nmh     RECORD LIKE nmh_file.*,
#                           occ11     LIKE occ_file.occ11  #MOD-5A0212
##                          pmc24     LIKE pmc_file.pmc24  #MOD-5A0212
#                        END RECORD
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line   #No.MOD-580242
#
#  ORDER BY sr.order1,sr.order2
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_head CLIPPED,pageno_total
## 處理排列順序於列印時所需控制
#   FOR g_i = 1 TO 2
#      CASE WHEN tm.s[g_i,g_i] = '1' LET l_orderA[g_i] = g_x[14]
#           WHEN tm.s[g_i,g_i] = '2' LET l_orderA[g_i] = g_x[15]
#           WHEN tm.s[g_i,g_i] = '3' LET l_orderA[g_i] = g_x[16]
#           WHEN tm.s[g_i,g_i] = '4' LET l_orderA[g_i] = g_x[17]
#           WHEN tm.s[g_i,g_i] = '5' LET l_orderA[g_i] = g_x[18]
#           WHEN tm.s[g_i,g_i] = '6' LET l_orderA[g_i] = g_x[12]
#           WHEN tm.s[g_i,g_i] = '7' LET l_orderA[g_i] = g_x[13]
#           OTHERWISE LET l_orderA[g_i] = ' '
#      END CASE
#   END FOR
#      LET g_head1=g_x[11] CLIPPED, l_orderA[1] CLIPPED,'-',
#            l_orderA[2] CLIPPED
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED
#
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#      #MOD-5B0308...............begin
#      LET l_nmd24=''
#      IF NOT cl_null(sr.g_nmh.nmh24) THEN
#        #CALL s_nmd12(sr.g_nmh.nmh24) RETURNING l_nmd24   #MOD-640397
#        CALL s_nmh24(sr.g_nmh.nmh24) RETURNING l_nmd24   #MOD-640397
#        LET l_nmd24=sr.g_nmh.nmh24,':',l_nmd24
#      END IF
#      #MOD-5B0308...............end
#      PRINT  COLUMN g_c[31],sr.g_nmh.nmh11,
#             COLUMN g_c[32],sr.g_nmh.nmh30,
##             COLUMN g_c[33],sr.pmc24[1,10],   #MOD-5A0212
#             COLUMN g_c[33],sr.occ11[1,10],    #MOD-5A0212
#             COLUMN g_c[34],sr.g_nmh.nmh33,
#             COLUMN g_c[35],sr.g_nmh.nmh34,
#            #COLUMN g_c[36],sr.g_nmh.nmh24, #MOD-5B0308
#             COLUMN g_c[36],l_nmd24, #MOD-5B0308
#             COLUMN g_c[37],sr.g_nmh.nmh05,
#             COLUMN g_c[38],sr.g_nmh.nmh31,
#             COLUMN g_c[39],cl_numfor(sr.g_nmh.nmh32,39,g_azi04)
#             LET l_cnt_1 = l_cnt_1 + 1
#             LET l_cnt_2 = l_cnt_2 + 1
#	     LET l_cnt_tot = l_cnt_tot + 1
#
#   AFTER GROUP OF sr.order1
#      LET l_total = GROUP SUM(sr.g_nmh.nmh32)
#      IF tm.u[1,1] = 'Y' THEN
#         LET l_str=l_orderA[1],"  ", g_x[10] CLIPPED
#         LET l_count=l_cnt_1,' ',g_x[9]
#         PRINT COLUMN g_c[31],l_str,
#               COLUMN g_c[33],l_count,
#               COLUMN g_c[39],cl_numfor(l_total,39,g_azi05) CLIPPED
#         #PRINT l_dash[1,g_len]
#         PRINT g_dash1
#      END IF
#         LET l_cnt_1 = 0
#
#   AFTER GROUP OF sr.order2
#      LET l_total = GROUP SUM(sr.g_nmh.nmh32)
#      IF tm.u[2,2] = 'Y' THEN
#         LET l_str=l_orderA[2],"  ", g_x[10] CLIPPED
#         LET l_count=l_cnt_2,' ',g_x[9]
#         PRINT COLUMN g_c[31],l_str,
#               COLUMN g_c[33],l_count,
#               COLUMN g_c[39],cl_numfor(l_total,39,g_azi05) CLIPPED
#      END IF
#	  LET l_cnt_2 = 0
#
#   ON LAST ROW
#      LET l_total = SUM(sr.g_nmh.nmh32)
#          PRINT
#          LET l_count=l_cnt_tot,' ',g_x[9]
#          PRINT COLUMN g_c[31],g_x[10] CLIPPED,
#                COLUMN g_c[33],l_count,
#                COLUMN g_c[39],cl_numfor(l_total,39,g_azi05) CLIPPED
#          PRINT g_dash[1,g_len]
#         #PRINT g_dash1   #No.TQC-5B0047
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_cnt_1 = 0
#      LET l_cnt_2 = 0
#      LET l_cnt_tot = 0
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-780011  --End  
#Patch....NO.TQC-610036 <001> #
