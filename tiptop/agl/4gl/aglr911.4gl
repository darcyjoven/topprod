# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr911.4gl
# Descriptions...: 傳票明細表
# Modify.........: No.FUN-510007 05/02/15 By Nicola 報表架構修改
#                                                   增加列印部門名稱gem02
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/01 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Czl g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/13 By cheunl   修改報表格式
# Modify.........: No.FUN-6C0012 06/12/28 By Judy 新增打印額外科目名稱的功能
# Modify.........: No.FUN-740020 07/04/13 By Lynn 會計科目加帳套
# Modify.........: No.FUN-830100 08/04/02 By mike 報表輸出方式轉為Crystal Reports 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B20054 11/02/24 By xianghui 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.CHI-B70049 11/09/02 By laura 新增QBE開窗aba01,abb03,abb05，abb06(借/貸)增加下拉選項
# Modify.........: No.MOD-B90052 11/09/07 By Polly 修正未給tm.k初始值造成l_name為null
# Modify.........: No.MOD-BB0227 11/11/23 By Dido 順序調整後沒有寫入變數中 
# Modify.........: No.FUN-C10024  12/05/23 By jinjj 帳套取畫面帳套
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
                 wc  STRING,                    #Where Condiction  #TQC-630166 
                 s   LIKE abh_file.abh01,       #排列順序#No.FUN-680098  VARCHAR(3)   
                 t   LIKE abh_file.abh01,       #排列順序#No.FUN-680098  VARCHAR(3)   
                 u   LIKE abh_file.abh01,       #排列順序#No.FUN-680098  VARCHAR(3)   
                 d   LIKE type_file.chr1,       #過帳別 (1)未過帳(2)已過帳(3)全部  #No.FUN-680098 VARCHAR(1)
                 e   LIKE type_file.chr1,       #是否列印科目名稱及摘要    #No.FUN-680098 VARCHAR(1) 
                 k   LIKE type_file.chr1,       #是否列印額外名稱 #FUN-6C0012
                 m   LIKE type_file.chr1        #是否輸入其它特殊列印條件  #No.FUN-680098 VARCHAR(1)
              END RECORD,
          g_bookno  LIKE aba_file.aba00,#帳別編號
          g_orderA  ARRAY[3] OF LIKE aba_file.aba01  #排序名稱                  #No.FUN-680098 VARCHAR(10)
   DEFINE g_aaa03   LIKE aaa_file.aaa03 
   DEFINE g_i       LIKE type_file.num5          #count/index for any purpose        #No.FUN-680098 SMALLINT
   DEFINE g_msg     LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
   DEFINE l_table   STRING                       #No.FUN-830100                                                                     
   DEFINE g_sql     STRING                       #No.FUN-830100                                                                     
   DEFINE g_str     STRING                       #No.FUN-830100    
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
   #No.FUN-830100  --BEGIN                                                                                                             
   LET g_sql = "aba00.aba_file.aba00,",   #帳別                                                                                     
               "aba01.aba_file.aba01,",   #傳票編號                                                                                 
               "aba02.aba_file.aba02,",   #傳票日期                                                                                 
               "abb02.abb_file.abb02,",   #Seq                                                                                      
               "abb03.abb_file.abb03,",   #科目                                                                                     
               "aag02.aag_file.aag02,",   #科目名稱                                                                                 
               "aag13.aag_file.aag13,",   #額外名稱                                                                                 
               "abb04.abb_file.abb04,",   #摘要                                                                                     
               "abb05.abb_file.abb05,",   #部門                                                                                     
               "abb06.abb_file.abb06,",   #借貸別                                                                                   
               "abb07.abb_file.abb07,",   #異動金額                                                                                 
               "abb11.abb_file.abb11,",   #異動碼-1                                                                                 
               "amt_d.abb_file.abb07,",                                                                                             
               "amt_c.abb_file.abb07,",                                                                                             
               "gem02.gem_file.gem02,",                                                                                             
               "azi04.azi_file.azi04,",                                                                                             
               "azi05.azi_file.azi05"                                                                                               
   LET l_table = cl_prt_temptable("aglr911",g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"                                                                      
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                              
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-830100  --END          
   LET  g_bookno = ARG_VAL(1)   
   LET g_pdate = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc  = ARG_VAL(8)
   LET tm.s  = ARG_VAL(9)
   LET tm.t  = ARG_VAL(10)
   LET tm.u  = ARG_VAL(11)
   LET tm.d  = ARG_VAL(12)
   LET tm.e  = ARG_VAL(13)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
   IF g_bookno = ' ' OR g_bookno IS NULL THEN
      LET g_bookno = g_aaz.aaz64   #帳別若為空白則使用預設帳別
   END IF
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL aglr911_tm()               # Input print condition
      ELSE CALL aglr911()                  # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION aglr911_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01           #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680098  SMALLINT
          l_cmd       LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(400)
DEFINE li_chk_bookno  LIKE type_file.num5             #No.FUN-B20054
 
   CALL s_dsmark(g_bookno)
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 16
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW aglr911_w AT p_row,p_col
        WITH FORM "agl/42f/aglr911"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL s_shwact(3,2,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   LET tm.s = '17'
   LET tm.u = 'Y'
   LET tm.d = '3'
   LET tm.e = 'N'
   LET tm.m = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[2,2]
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   LET tm2.u3   = tm.u[2,2]
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
#No.FUN-B20054--add-start--
      DIALOG ATTRIBUTE(unbuffered)
         INPUT g_bookno FROM aba00 ATTRIBUTE(WITHOUT DEFAULTS)
            AFTER FIELD aba00
              IF NOT cl_null(g_bookno) THEN
                   CALL s_check_bookno(g_bookno,g_user,g_plant)
                    RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                    NEXT FIELD aba00
                END IF
                SELECT aaa02 FROM aaa_file WHERE aaa01 = g_bookno
                IF STATUS THEN
                   CALL cl_err3("sel","aaa_file",g_bookno,"","agl-043","","",0)
                   NEXT FIELD  aba00
                END IF
             END IF
         END INPUT

#No.FUN-B20054--add-end--

 #  CONSTRUCT BY NAME tm.wc ON aba01,aba02,abb03,abb05,abb11,aba00,abb02,abb06    #No.FUN-B20054
    CONSTRUCT BY NAME tm.wc ON aba01,aba02,abb03,abb05,abb11,abb02,abb06    #No.FUN-B20054
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
         
         #No.CHI-B70049--add--start-- 
    
        #ON ACTION CONTROLP
        #   CASE

        #      WHEN INFIELD(abb03)               #科目編號
        #         CALL cl_init_qry_var()
        #         LET g_qryparam.state    = "c"
        #         LET g_qryparam.form = "q_aag5"
        #         LET g_qryparam.where = " aag00 = '",g_bookno CLIPPED,"'"
        #         CALL cl_create_qry() RETURNING g_qryparam.multiret
        #         DISPLAY g_qryparam.multiret TO abb03
        #         NEXT FIELD abb03
    
        #      WHEN INFIELD(aba01)                #傳票編號
        #         CALL cl_init_qry_var()
        #         LET g_qryparam.form ="q_aba02"
        #         LET g_qryparam.state = "c"
        #         CALL cl_create_qry() RETURNING g_qryparam.multiret
        #         DISPLAY g_qryparam.multiret TO aba01
        #         NEXT FIELD aba01
        #         
        #      WHEN INFIELD(abb05)               #部門編號
        #         CALL cl_init_qry_var()
        #         LET g_qryparam.form = 'q_gem'
        #         LET g_qryparam.state= 'c'
        #         CALL cl_create_qry() RETURNING g_qryparam.multiret
        #         DISPLAY g_qryparam.multiret TO abb05
        #         NEXT FIELD abb05
        #         
        #      OTHERWISE EXIT CASE
        #   END CASE            

        #No.CHI-B70049--add--end-- 
         
#No.FUN-B20054--mark--start-- 
#       ON ACTION locale
#           #CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
# 
#           ON ACTION exit
#           LET INT_FLAG = 1
#           EXIT CONSTRUCT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
  END CONSTRUCT
#No.FUN-B20054--mark--start--
#       IF g_action_choice = "locale" THEN
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
# 
# 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW aglr911_w 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#      EXIT PROGRAM
#         
#   END IF
#No.FUN-B20054--mark--end--
     INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm2.u1,tm2.u2,tm2.u3,
                   tm.d,tm.e,tm.k,tm.m   #FUN-6C0012
                 #  WITHOUT DEFAULTS              #No.FUN-B20054
                    ATTRIBUTE(WITHOUT DEFAULTS)   #No.FUN-B20054
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
      #No.FUN-6C0012  --begin                                                   
      AFTER FIELD e                                                             
         IF tm.e ='Y' THEN                                                      
            LET tm.k = '1'                                                      
            CALL cl_set_comp_entry('k',TRUE)                                    
         ELSE                                                                   
            LET tm.k=NULL                                                       
            DISPLAY BY NAME tm.k                                                
            CALL cl_set_comp_entry('k',FALSE)                                   
         END IF                                                                 
      #No.FUn-6C0012  --end
 
      AFTER FIELD d
         IF tm.d NOT MATCHES "[123]" THEN NEXT FIELD d END IF
      AFTER FIELD m
         IF tm.m NOT MATCHES "[YN]" THEN NEXT FIELD m END IF
         IF tm.m = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
#No.FUN-B20054--mark--start-- 
#################################################################################
## START genero shell script ADD
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()
## END genero shell script ADD
#################################################################################
#      ON ACTION CONTROLG CALL cl_cmdask()      # Command execution
#No.FUN-B20054--mark--end--
   AFTER INPUT
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
      LET tm.t = tm2.t1,tm2.t2,tm2.t3
      LET tm.u = tm2.u1,tm2.u2,tm2.u3
#No.FUN-B20054--mark--sttart--
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
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#No.FUN-B20054--mark--end-- 
   END INPUT
#No.FUN-B20054--add--start--
         ON ACTION CONTROLP
            CASE
   #No.CHI-B70049--mark   此段mark，abb03為CONSTRUCT段新增 
   #           WHEN INFIELD(abb03)               
   #               CALL cl_init_qry_var()               
   #               LET g_qryparam.state    = "c"
   #               LET g_qryparam.form = "q_aag"
   #               LET g_qryparam.where = " aag00 = '",g_bookno CLIPPED,"'"
   #               CALL cl_create_qry() RETURNING g_qryparam.multiret
   #               DISPLAY g_qryparam.multiret TO abb03
   #               NEXT FIELD abb03    

               WHEN INFIELD(aba00)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_aaa'
                  LET g_qryparam.default1 = g_bookno
                  CALL cl_create_qry() RETURNING g_bookno
                  DISPLAY BY NAME g_bookno
                  NEXT FIELD aba00


        #No.CHI-B70049--add--start-- 
       
                WHEN INFIELD(abb03)               #科目編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag5"
                   LET g_qryparam.where = " aag00 = '",g_bookno CLIPPED,"'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO abb03
                   NEXT FIELD abb03
       
                WHEN INFIELD(aba01)                #傳票編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aba02"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO aba01
                   NEXT FIELD aba01
                   
                WHEN INFIELD(abb05)               #部門編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_gem'
                   LET g_qryparam.state= 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO abb05
                   NEXT FIELD abb05

        #No.CHI-B70049--add--end-- 
            
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
   IF tm.e = 'Y' AND cl_null(tm.k) THEN   #No.MOD-B90052 add
      LET tm.k = '1'                      #No.MOD-B90052 add
   END IF                                 #No.MOD-B90052 add
  #-MOD-BB0227-add-
   LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
   LET tm.t = tm2.t1,tm2.t2,tm2.t3
   LET tm.u = tm2.u1,tm2.u2,tm2.u3
  #-MOD-BB0227-end-
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
#No.FUN-B20054--add--end--
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aglr911_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file      #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr911'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr911','9031',1)  
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,            #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.d CLIPPED,"'",
                         " '",tm.e CLIPPED,"'",
                         " '",tm.k CLIPPED,"'",   #FUN-6C0012
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aglr911',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW aglr911_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglr911()
   ERROR ""
END WHILE
   CLOSE WINDOW aglr911_w
END FUNCTION
 
FUNCTION aglr911()
   DEFINE l_name      LIKE type_file.chr20,             # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0073
          l_sql       STRING,                # RDSQL STATEMENT  #TQC-630166 
          l_chr       LIKE type_file.chr1,          #No.FUN-680098  VARCHAR(1)
          l_order     ARRAY[5] OF LIKE abb_file.abb11,   #排列順序     #No.FUN-680098 VARCHAR(20)
          l_i         LIKE type_file.num5,          #No.FUN-680098 smallint
          sr          RECORD
                         order1    LIKE abb_file.abb11,  #排列順序-1   #No.FUN-680098 VARCHAR(20) 
                         order2    LIKE abb_file.abb11,  #排列順序-2   #No.FUN-680098 VARCHAR(20)
                         order3    LIKE abb_file.abb11,  #排列順序-3   #No.FUN-680098 VARCHAR(20)
                         aba00     LIKE aba_file.aba00,#帳別
                         aba01     LIKE aba_file.aba01,#傳票編號
                         aba02     LIKE aba_file.aba02,#傳票日期
                         abb02     LIKE abb_file.abb02,#Seq
                         abb03     LIKE abb_file.abb03,#科目
                         aag02     LIKE aag_file.aag02,#科目名稱
                         aag13     LIKE aag_file.aag13,#額外名稱#FUN-6C0012
                         abb04     LIKE abb_file.abb04,#摘要
                         abb05     LIKE abb_file.abb05,#部門
                         abb06     LIKE abb_file.abb06,#借貸別
                         abb07     LIKE abb_file.abb07,#異動金額
                         abb11     LIKE abb_file.abb11,#異動碼-1
                         amt_d     LIKE abb_file.abb07,
                         amt_c     LIKE abb_file.abb07,
                         gem02     LIKE gem_file.gem02
                      END RECORD
   CALL cl_del_data(l_table)                       #No.FUN-830100  
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = g_bookno
      AND aaf02 = g_rlang
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN
#     CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660123
      CALL cl_err3("sel","aaa_file",g_bookno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660123
   END IF
 
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file           #No.CHI-6A0004 g_azi-->t_azi 
    WHERE azi01 = g_aaa03
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND abauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND abagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND abagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT '','','', aba00,aba01,aba02,",
               " abb02,abb03,aag02,aag13,abb04,abb05,abb06,abb07,abb11,0,0,''",  #FUN-6C0012
               " FROM aba_file, abb_file, OUTER aag_file",
               " WHERE aba00 = abb00",
               "   AND aba00 = aag00",         #No.FUN-740020
               "   AND aba00 = '",g_bookno,"'",   #FUN-C10024 add
               "   AND aba01 = abb01",
               "   AND abb_file.abb03 = aag_file.aag01",
               "   AND abaacti='Y'",
               "   ANd aba19 <> 'X' ",  #CHI-C80041
               "   AND ",tm.wc
   CASE WHEN tm.d = '1' LET l_sql = l_sql CLIPPED," AND abapost = 'N' "
        WHEN tm.d = '2' LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
   END CASE
 
   PREPARE aglr911_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE aglr911_curs1 CURSOR FOR aglr911_prepare1
   #CALL cl_outnam('aglr911') RETURNING l_name          #No.FUN-830100 
 
#   IF tm.e != 'Y' THEN LET g_len = g_len - 62 END IF   #TQC-6A0080  #FUN-6C0012
   #No.FUN-830100  --BEGIN                                                                                                             
{         
   #No.FUN-6C0012  --begin                                                      
   IF tm.e = 'Y' AND tm.k = '1' THEN                                            
      LET g_zaa[39].zaa06 ='N'                                                  
      LET g_zaa[40].zaa06 ='N'                                                  
      LET g_zaa[41].zaa06 ='Y'                                                  
   END IF                                                                       
   IF tm.e = 'Y' AND tm.k = '2' THEN                                            
      LET g_zaa[39].zaa06 ='Y'                                                  
      LET g_zaa[40].zaa06 ='N'                                                  
      LET g_zaa[41].zaa06 ='N'                                                  
   END IF                                                                       
   IF tm.e = 'N' THEN                                                           
      LET g_zaa[39].zaa06 ='Y'                                                  
      LET g_zaa[40].zaa06 ='Y'                                                  
      LET g_zaa[41].zaa06 ='Y'                                                  
   END IF                                                                       
   CALL cl_prt_pos_len()                                                        
   #No.FUN-6C0012  --end
 
 
   START REPORT aglr911_rep TO l_name
}                                                                                                                                   
   IF tm.e = 'Y' AND tm.k = '1' THEN                                                                                                
      LET l_name = 'aglr911'                                                                                                        
   END IF                                                                                                                           
   IF tm.e = 'Y' AND tm.k = '2' THEN                                                                                                
      LET l_name = 'aglr911'                                                                                                        
   END IF                                                                                                                           
   IF tm.e = 'N' THEN                                                                                                               
      LET l_name = 'aglr911_1'                                                                                                      
   END IF                                                                                                                           
#No.FUN-830100  --END                
   FOREACH aglr911_curs1 INTO sr.*
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM 
     END IF
 
     SELECT gem02 INTO sr.gem02 FROM gem_file
      WHERE gem01 = sr.abb05
    #No.FUN-830100  --begin                                                                                                             
{                
     FOR l_i = 1 TO 3
         CASE WHEN tm.s[l_i,l_i]='1' LET l_order[l_i] =sr.aba01
                                     LET g_orderA[l_i]=g_x[10]
             WHEN tm.s[l_i,l_i]='2' LET l_order[l_i] =sr.aba02 USING 'yyyymmdd'
                                     LET g_orderA[l_i]=g_x[11]
              WHEN tm.s[l_i,l_i]='3' LET l_order[l_i] =sr.abb03
                                     LET g_orderA[l_i]=g_x[12]
              WHEN tm.s[l_i,l_i]='4' LET l_order[l_i] =sr.abb05
                                     LET g_orderA[l_i]=g_x[13]
              WHEN tm.s[l_i,l_i]='5' LET l_order[l_i] =sr.abb11
                                     LET g_orderA[l_i]=g_x[14]
              WHEN tm.s[l_i,l_i]='6' LET l_order[l_i] =sr.aba00
                                     LET g_orderA[l_i]=g_x[15]
              WHEN tm.s[l_i,l_i]='7' LET l_order[l_i] =sr.abb02 USING'&&&'
                                     LET g_orderA[l_i]=g_x[16]
              WHEN tm.s[l_i,l_i]='8' LET l_order[l_i] =sr.abb06
                                     LET g_orderA[l_i]=g_x[17]
              OTHERWISE LET l_order[l_i] = '-' LET g_orderA[l_i]=' '
         END CASE
     END FOR
     LET sr.order1 = l_order[1]
     LET sr.order2 = l_order[2]
     LET sr.order3 = l_order[3]
}                                                                                                                                   
#No.FUN-830100  --end  
     IF sr.abb06='1'
        THEN LET sr.amt_d=sr.abb07 LET sr.amt_c=0
        #ELSE LET sr.amt_c=0        LET sr.amt_c=sr.abb07    #No.FUN-830100 BUG 
        ELSE LET sr.amt_d=0 LET sr.amt_c=sr.abb07           #No.FUN-830100   
     END IF
     #No.FUN-830100  --begin                                                                                                             
     EXECUTE insert_prep USING sr.aba00, sr.aba01,                                                                                  
                               sr.aba02, sr.abb02, sr.abb03, sr.aag02,sr.aag13,                                                     
                               sr.abb04, sr.abb05, sr.abb06, sr.abb07,sr.abb11,                                                     
                               sr.amt_d, sr.amt_c, sr.gem02, t_azi04, t_azi05                                                       
     #OUTPUT TO REPORT aglr911_rep(sr.*)
     #No.FUN-830100  --END   
   END FOREACH
   #No.FUN-830100  --begin   
   #FINISH REPORT aglr911_rep
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   LET g_str=''                                                                                                                     
   IF g_zz05='Y' THEN                                                                                                               
      CALL cl_wcchp(tm.wc,'aba02,aba01,abb03,abb05')                                                                                
      RETURNING tm.wc                                                                                                               
      LET g_str=tm.wc                                                                                                               
   END IF                                                                                                                           
   LET g_str=g_str CLIPPED,';',tm.s[1,1],';',tm.s[2,2],';',tm.s[3,3],';',                                                           
                               tm.t[1,1],';',tm.t[2,2],';',tm.e,';',tm.k,';',                                                       
                               tm.u[1,1],';',tm.u[2,2],';',tm.u[3,3]                                                                
   LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED                                                                  
   CALL cl_prt_cs3('aglr911',l_name,g_sql,g_str)                                                                                    
   #No.FUN-830100  --end                              
END FUNCTION
#No.FUN-830100  --begin                                                                                                             
{                 
REPORT aglr911_rep(sr)
  DEFINE l_last_sw      LIKE type_file.chr1,     #No.FUN-680098  VARCHAR(1)
          sr            RECORD
                           order1     LIKE abb_file.abb11,  #排列順序-1#No.FUN-680098 VARCHAR(20)
                           order2     LIKE abb_file.abb11,  #排列順序-2#No.FUN-680098 VARCHAR(20)
                           order3     LIKE abb_file.abb11,  #排列順序-3#No.FUN-680098 VARCHAR(20)
                           aba00     LIKE aba_file.aba00,#帳別
                           aba01     LIKE aba_file.aba01,#傳票編號
                           aba02     LIKE aba_file.aba02,#傳票日期
                           abb02     LIKE abb_file.abb02,#Seq
                           abb03     LIKE abb_file.abb03,#科目
                           aag02     LIKE aag_file.aag02,#科目名稱
                           aag13     LIKE aag_file.aag13,#額外名稱 #FUN-6C0012
                           abb04     LIKE abb_file.abb04,#摘要
                           abb05     LIKE abb_file.abb05,#部門
                           abb06     LIKE abb_file.abb06,#借貸別
                           abb07     LIKE abb_file.abb07,#異動金額
                           abb11     LIKE abb_file.abb11,#異動碼-1
                           amt_d     LIKE abb_file.abb07,
                           amt_c     LIKE abb_file.abb07,
                           gem02     LIKE gem_file.gem02
                        END RECORD
   DEFINE g_head1       STRING 
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.order1,sr.order2,sr.order3,sr.aba01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         LET g_head1 = g_x[9] CLIPPED,g_orderA[1] CLIPPED,
                       '-',g_orderA[2] CLIPPED,'-',g_orderA[3] CLIPPED
         PRINT g_head1
         PRINT g_dash[1,g_len]
#         IF tm.e = 'Y' THEN  #FUN-6C0012 mark
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#               g_x[38],g_x[39],g_x[40]   #FUN-6C0012 mark
               g_x[38],g_x[39],g_x[41],g_x[40]  #FUN-6C0012
         #FUN-6C0012.....begin mark
#         ELSE
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#                  g_x[38]
#         END IF
         #FUN-6C0012.....end
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.aba01,
               COLUMN g_c[32],sr.aba02,
               COLUMN g_c[33],sr.abb03,
               COLUMN g_c[34],sr.abb05,
               COLUMN g_c[35],sr.gem02,
               COLUMN g_c[36],cl_numfor(sr.amt_d,36,t_azi04),            #No.CHI-6A0004 g_azi-->t_azi 
               COLUMN g_c[37],cl_numfor(sr.amt_c,37,t_azi04),            #No.CHI-6A0004 g_azi-->t_azi 
               COLUMN g_c[38],sr.abb11 CLIPPED;
#         IF tm.e = 'Y' THEN   #FUN-6C0012 mark
         IF tm.e = 'Y' AND tm.k ='1' THEN   #FUN-6C0012
            PRINT COLUMN g_c[39],sr.aag02 CLIPPED,
                  COLUMN g_c[40],sr.abb04 CLIPPED
         ELSE
#            PRINT  #FUN-6C0012 mark
            #FUN-6C0012.....begin
            IF tm.e ='Y' AND tm.k = '2' THEN                                    
               PRINT COLUMN g_c[41],sr.aag13 CLIPPED,                           
                     COLUMN g_c[40],sr.abb04 CLIPPED                            
            END IF
            #FUN-6C0012.....end
         END IF
 
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],
                  COLUMN g_c[37],g_dash2[1,g_w[37]],
                  COLUMN g_c[38],g_dash2[1,g_w[38]]
            PRINT COLUMN g_c[34],g_orderA[1] CLIPPED,
                  COLUMN g_c[35],g_x[18] CLIPPED,
                  COLUMN g_c[36],cl_numfor(GROUP SUM(sr.amt_d),36,t_azi04),        #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[37],cl_numfor(GROUP SUM(sr.amt_c),37,t_azi04),         #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[38],cl_numfor(GROUP SUM(sr.amt_d)-GROUP SUM(sr.amt_c),38,t_azi04)   #No.CHI-6A0004 g_azi-->t_azi 
            PRINT
         END IF
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],
                  COLUMN g_c[37],g_dash2[1,g_w[37]],
                  COLUMN g_c[38],g_dash2[1,g_w[38]]
            PRINT COLUMN g_c[34],g_orderA[1] CLIPPED,
                  COLUMN g_c[35],g_x[18] CLIPPED,
                  COLUMN g_c[36],cl_numfor(GROUP SUM(sr.amt_d),36,t_azi04),    #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[37],cl_numfor(GROUP SUM(sr.amt_c),37,t_azi04),     #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[38],cl_numfor(GROUP SUM(sr.amt_d)-GROUP SUM(sr.amt_c),38,t_azi04)     #No.CHI-6A0004 g_azi-->t_azi 
            PRINT
         END IF
 
      AFTER GROUP OF sr.order3
         IF tm.u[3,3] = 'Y' THEN
            PRINT COLUMN g_c[36],g_dash2[1,g_w[36]],
                  COLUMN g_c[37],g_dash2[1,g_w[37]],
                  COLUMN g_c[38],g_dash2[1,g_w[38]]
            PRINT COLUMN g_c[34],g_orderA[1] CLIPPED,
                  COLUMN g_c[35],g_x[18] CLIPPED,
                  COLUMN g_c[36],cl_numfor(GROUP SUM(sr.amt_d),36,t_azi04),   #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[37],cl_numfor(GROUP SUM(sr.amt_c),37,t_azi04),    #No.CHI-6A0004 g_azi-->t_azi 
                  COLUMN g_c[38],cl_numfor(GROUP SUM(sr.amt_d)-GROUP SUM(sr.amt_c),38,t_azi04)    #No.CHI-6A0004 g_azi-->t_azi 
            PRINT
         END IF
 
      ON LAST ROW
         PRINT COLUMN g_c[36],g_dash[1,g_w[36]],
               COLUMN g_c[37],g_dash[1,g_w[37]],
               COLUMN g_c[38],g_dash[1,g_w[38]]
         PRINT COLUMN g_c[35],g_x[19] CLIPPED,
               COLUMN g_c[36],cl_numfor(SUM(sr.amt_d),36,t_azi04),           #No.CHI-6A0004 g_azi-->t_azi 
               COLUMN g_c[37],cl_numfor(SUM(sr.amt_c),37,t_azi04),           #No.CHI-6A0004 g_azi-->t_azi 
               COLUMN g_c[38],cl_numfor(SUM(sr.amt_d)-SUM(sr.amt_c),38,t_azi04)        #No.CHI-6A0004 g_azi-->t_azi 
 
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'aba02,aba01,abb03,abb05') RETURNING tm.wc
            PRINT g_dash[1,g_len]
        #TQC-630166
        #    IF tm.wc[001,070] > ' ' THEN                  # for 80
        #       PRINT COLUMN g_c[31],g_x[8] CLIPPED,
        #             COLUMN g_c[32],tm.wc[001,070] CLIPPED
        #    END IF
        #    IF tm.wc[071,140] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[071,140] CLIPPED
        #    END IF
        #    IF tm.wc[141,210] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[141,210] CLIPPED
        #    END IF
        #    IF tm.wc[211,280] > ' ' THEN
        #       PRINT COLUMN g_c[32],tm.wc[211,280] CLIPPED
        #    END IF
         CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
 
         END IF
         PRINT g_dash[1,g_len]
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
END REPORT
}
#No.FUN-830100  --end   
#Patch....NO.TQC-610035 <001> #
