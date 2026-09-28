# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr622.4gl
# Descriptions...: 客戶應收帳齡分析表
# Date & Author..: 95/03/04 by Nick
# Modify.........: 99/08/16 by Carol:報表欄位調整
# Modify.........: No.FUN-4C0100 05/03/02 By Smapmin 放寬金額欄位
 # Modify.........: No.MOD-530866 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-570005 05/07/08 By Nicola 此表末包括折讓，末包括負數
# Modify.........: No.FUN-580010 05/08/11 By yoyo 憑証類報表原則修改
# Modify.........: No.MOD-5C0069 05/12/14 By Carrier ooz07='N'-->oma56t-oma57
#                                                    ooz07='Y'-->oma61
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng 修改報表格式       
# Modify.........: No.FUN-710066 07/02/09 By rainy 將axri030設定納入計算     
# Modify.........: No.MOD-720047 07/03/11 by TSD.pinky 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/31 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-760039 07/06/13 By Smapmin 增加帳款類別開窗
# Modify.........: No.MOD-780184 07/08/20 By Smapmin 抓取欄位有誤
# Modify.........: No.TQC-790101 07/09/17 By Judy "帳齡分段"為控管
# Modify.........: No.CHI-860041 08/07/09 By Sarah oma00='23'的帳單抓取對應到oma00='12'的oma19>截止日期,已沖金額需加回這些超出截止日期單據的oma52,oma53
# Modify.........: No.MOD-8A0189 08/10/29 By Sarah 抓取小數位數應該用g_aza.aza17
# Modify.........: No.FUN-8A0065 08/11/06 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-8B0118 08/12/01 By xiaofeizhu 報表小數位調整
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No:TQC-A50082 10/05/24 By Carrier CHI-950032追单
# Modify.........: No.FUN-A50102 10/06/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 
# Modify.........: No.FUN-B20014 11/02/12 By lilingyu SQL增加ooa37='1'的條件
# Modify.........: No.FUN-C40001 12/04/12 By yinhy 增加開窗功能
# Modify.........: No.FUN-C40021 12/05/31 By jinjj QBE增加會計科目oma18
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
                 wc      LIKE type_file.chr1000,         #No.FUN-680123 VARCHAR(1000)  # Where condition
                 omi01   LIKE omi_file.omi01,
                 a1      LIKE type_file.num5,            #No.FUN-680123 SMALLINT
                 a2      LIKE type_file.num5,            #No.FUN-680123 SMALLINT
                 a3      LIKE type_file.num5,            #No.FUN-680123 SMALLINT
                 a4      LIKE type_file.num5,            #No.FUN-680123 SMALLINT
                 a5      LIKE type_file.num5,            #No.FUN-680123 SMALLINT
                 a6      LIKE type_file.num5,            #No.FUN-680123 SMALLINT
                 x       LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(1)
                 n       LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(1)
                 detail  LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(1)
                 edate   LIKE type_file.dat,             #No.FUN-680123 DATE 
                 e       LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(1) #No.FUN-570005
  ##NO.FUN-A10098  mark--begin
#                 b       LIKE type_file.chr1,            #No.FUN-8A0065 VARCHAR(1)
#                 p1      LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#                 p2      LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#                 p3      LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#                 p4      LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10) 
#                 p5      LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#                 p6      LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#                 p7      LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
#                 p8      LIKE azp_file.azp01,            #No.FUN-8A0065 VARCHAR(10)
  ##NO.FUN-A10098  mark--end
                 type    LIKE type_file.chr1,            #No.FUN-8A0065 VARCHAR(1)
                 s       LIKE type_file.chr3,            #No.FUN-8A0065 VARCHAR(3)
                 t       LIKE type_file.chr3,            #No.FUN-8A0065 VARCHAR(3)
                 u       LIKE type_file.chr3,            #No.FUN-8A0065 VARCHAR(3)                 
                 more    LIKE type_file.chr1             #No.FUN-680123 VARCHAR(1)             # Input more condition(Y/N)
              END RECORD,
                    l_omi21        LIKE omi_file.omi21,
                    l_omi22        LIKE omi_file.omi22,
                    l_omi23        LIKE omi_file.omi23,
                    l_omi24        LIKE omi_file.omi24,
                    l_omi25        LIKE omi_file.omi25,
                    l_omi26        LIKE omi_file.omi26,
                     #l_tot            DEC(12,3)
                      l_tot            LIKE pmc_file.pmc45           #No.FUN-680123  DEC(12,3)   
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680123 SMALLINT
DEFINE l_table     STRING                        #FUN-710080 add
DEFINE g_sql       STRING                        #FUN-710080 add
DEFINE g_str       STRING                        #FUN-710080 add
  ##NO.FUN-A10098  mark--begin
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8A0065 ARRAY[10] OF VARCHAR(20)
  ##NO.FUN-A10098  mark--end 
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
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oma14.oma_file.oma14," ,     
               "gen02.gen_file.gen02," ,    
               "oma15.oma_file.oma15," ,     
               "occ03.occ_file.occ03," ,     
               "oca02.oca_file.oca02," ,     
               "oma03.oma_file.oma03," ,     
               "oma032.oma_file.oma032,",    
               "oma02.oma_file.oma02,"  ,    
               "oma01.oma_file.oma01,",
               "num1.type_file.num20_6,",     
               "num2.type_file.num20_6," ,   
               "num3.type_file.num20_6," ,  
               "num4.type_file.num20_6," , 
               "num5.type_file.num20_6,", 
               "num6.type_file.num20_6,",
               "num7.type_file.num20_6,",
               "tot.type_file.num20_6,  ",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "plant.azp_file.azp01"                                           #FUN-8A0065               
 
   LET l_table = cl_prt_temptable('axrr622',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
            " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,? )"            #FUN-8A0065 Add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #MOD-720047 - END
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.omi01 = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9) 
   LET tm.a1 = ARG_VAL(10)
   LET tm.a2 = ARG_VAL(11)
   LET tm.a3 = ARG_VAL(12)
   LET tm.a4 = ARG_VAL(13)
   LET tm.a5 = ARG_VAL(14)
   LET tm.a6 = ARG_VAL(15)
   LET tm.detail = ARG_VAL(16)
   LET tm.e = ARG_VAL(17)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(18)
   LET g_rep_clas = ARG_VAL(19)
   LET g_template = ARG_VAL(20)
   LET g_rpt_name = ARG_VAL(21)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #No.FUN-8A0065 --start--
  ##NO.FUN-A10098  mark--begin
#   LET tm.b     = ARG_VAL(22)
#   LET tm.p1    = ARG_VAL(23)
#   LET tm.p2    = ARG_VAL(24)
#   LET tm.p3    = ARG_VAL(25)
#   LET tm.p4    = ARG_VAL(26)
#   LET tm.p5    = ARG_VAL(27)
#   LET tm.p6    = ARG_VAL(28)
#   LET tm.p7    = ARG_VAL(29)
#   LET tm.p8    = ARG_VAL(30)
  ##NO.FUN-A10098  mark--end
   LET tm.type  = ARG_VAL(22)   
   LET tm.s     = ARG_VAL(23)
   LET tm.t     = ARG_VAL(24)
   LET tm.u     = ARG_VAL(25)   
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
   #No.FUN-8A0065 ---end---   
   IF cl_null(tm.wc)
      THEN CALL r622_tm(0,0)             # Input print condition
   ELSE 
      CALL r622()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION r622_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 17
   ELSE LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW r622_w AT p_row,p_col
        WITH FORM "axr/42f/axrr622"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n='N'
   LET tm.detail='N'
   LET tm.edate=g_today
   LET tm.e='Y'      #No.FUN-570005
   #FUN-8A0065-Begin--#
   LET tm.s ='12 '
   LET tm.t ='Y  '
   LET tm.u ='Y  '
   LET tm.type  = '3'
  ##NO.FUN-A10098  mark--begin
#   LET tm.b ='N'
#   LET tm.p1=g_plant
#   CALL r622_set_entry_1()               
#   CALL r622_set_no_entry_1()
#   CALL r622_set_comb()           
#   #FUN-8A0065-End--#   
  ##NO.FUN-A10098  mark--end
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma15,oma14,occ03,oma03,oma18    #FUN-C40021 add 'oma18'
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
      #No.FUN-C40001  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oma15)
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem1"   #No.MOD-530272
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma15
                 NEXT FIELD oma15
            WHEN INFIELD(oma14)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma14
                 NEXT FIELD oma14
            WHEN INFIELD(occ03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oca"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO occ03
                 NEXT FIELD occ03
            WHEN INFIELD(oma03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma03
                 NEXT FIELD oma03
          #No.FUN-C40021 --start--
            WHEN INFIELD(oma18) #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma18
                 NEXT FIELD oma18
          #No.FUN-C40021 ---end---
            END CASE
      #No.FUN-C40001  --End

  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r622_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
 
   INPUT BY NAME tm.omi01,tm.edate,tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6,
                 tm.detail,tm.e,
  ##NO.FUN-A10098  mark--begin
#                 tm.b,tm.p1,tm.p2,tm.p3,                                                    #FUN-8A0065
#                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,
  ##NO.FUN-A10098  mark--end
                 tm.type,                                                                   #FUN-8A0065 
                 tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,                                 #FUN-8A0065
                 tm2.u1,tm2.u2,tm2.u3,                                                      #FUN-8A0065                 
                 tm.more WITHOUT DEFAULTS   #No.FUN-570005
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      BEFORE FIELD omi01
         IF cl_null(tm.omi01) THEN
            SELECT MIN(omi01) INTO tm.omi01 FROM omi_file
         END IF
 
      AFTER FIELD omi01
            SELECT omi11,omi12,omi13,omi14,omi15,omi16,
                       omi21,omi22,omi23,omi24,omi25,omi26
              INTO tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6,
                   l_omi21,l_omi22,l_omi23,l_omi24,l_omi25,l_omi26
                  FROM omi_file
             WHERE omi01=tm.omi01
            IF status THEN
#              CALL cl_err('omi01','axr-256',1)    #No.FUN-660116
               CALL cl_err3("sel","omi_file",tm.omi01,"","axr-256","","omi01",1)   #No.FUN-660116
               NEXT FIELD omi01
            END IF
             DISPLAY BY NAME tm.a1,tm.a2,tm.a3,tm.a4,tm.a5,tm.a6
#TQC-790101.....begin
      AFTER FIELD a1
         IF NOT cl_null(tm.a1) THEN 
            IF tm.a1 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a1
            END IF
         END IF
 
      AFTER FIELD a2
         IF NOT cl_null(tm.a2) THEN 
            IF tm.a2 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a2
            END IF
            IF NOT cl_null(tm.a1) THEN
               IF tm.a2 <= tm.a1 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a2
               END IF
            END IF
         END IF
 
      AFTER FIELD a3
         IF NOT cl_null(tm.a3) THEN 
            IF tm.a3 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a3
            END IF
            IF NOT cl_null(tm.a2) THEN
               IF tm.a3 <= tm.a2 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a3
               END IF
            END IF
         END IF
 
      AFTER FIELD a4
         IF NOT cl_null(tm.a4) THEN 
            IF tm.a4 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a4
            END IF
            IF NOT cl_null(tm.a3) THEN
               IF tm.a4 <= tm.a3 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a4
               END IF
            END IF
         END IF
 
      AFTER FIELD a5
         IF NOT cl_null(tm.a5) THEN 
            IF tm.a5 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a5
            END IF
            IF NOT cl_null(tm.a4) THEN
               IF tm.a5 <= tm.a4 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a5
               END IF
            END IF
         END IF
 
      AFTER FIELD a6
         IF NOT cl_null(tm.a6) THEN 
            IF tm.a6 <= 0 THEN
               CALL cl_err('','axr-958',0)
               NEXT FIELD a6
            END IF
            IF NOT cl_null(tm.a5) THEN
               IF tm.a6 <= tm.a5 THEN
                  CALL cl_err('','axr-959',0)
                  NEXT FIELD a6
               END IF
            END IF
         END IF
#TQC-790101.....end
      AFTER FIELD edate
         IF tm.edate IS NULL THEN NEXT FIELD edate END IF
       # IF MONTH(tm.edate)=MONTH(tm.edate+1) THEN
       #    ERROR "請輸入月底日期!" NEXT FIELD edate
       # END IF
       
       #FUN-8A0065--Begin--#
  ##NO.FUN-A10098  mark--begin
#      AFTER FIELD b
#          IF NOT cl_null(tm.b)  THEN
#             IF tm.b NOT MATCHES "[YN]" THEN
#                NEXT FIELD b       
#             END IF
#          END IF
#                    
#       ON CHANGE  b
#          LET tm.p1=g_plant
#          LET tm.p2=NULL
#          LET tm.p3=NULL
#          LET tm.p4=NULL
#          LET tm.p5=NULL
#          LET tm.p6=NULL
#          LET tm.p7=NULL
#          LET tm.p8=NULL
#          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#          CALL r622_set_entry_1()      
#          CALL r622_set_no_entry_1()
#          CALL r622_set_comb()       
       
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
            NEXT FIELD type
         END IF                   
       
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN 
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
#            NEXT FIELD p1 
#         END IF
#         #No.FUN-940102--begin    
#         IF NOT cl_null(tm.p1) THEN 
#            IF NOT s_chk_demo(g_user,tm.p1) THEN              
#               NEXT FIELD p1          
#            END IF  
#         END IF              
#         #No.FUN-940102--end
# 
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p2 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p2) THEN
#               NEXT FIELD p2
#            END IF            
#            #No.FUN-940102--end
#         END IF
# 
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p3 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p3) THEN
#               NEXT FIELD p3
#            END IF            
#            #No.FUN-940102--end
#         END IF
# 
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p4 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p4) THEN
#               NEXT FIELD p4
#            END IF            
#            #No.FUN-940102--end
#         END IF
# 
#      AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
#               NEXT FIELD p5 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p5) THEN
#               NEXT FIELD p5
#            END IF            
#            #No.FUN-940102--end
#         END IF
# 
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p6 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p6) THEN
#               NEXT FIELD p6
#            END IF            
#            #No.FUN-940102--end
#         END IF
# 
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
#               NEXT FIELD p7 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p7) THEN
#               NEXT FIELD p7
#            END IF            
#            #No.FUN-940102--end
#         END IF
# 
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p8 
#            END IF
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,tm.p8) THEN
#               NEXT FIELD p8
#            END IF            
#            #No.FUN-940102--end
#         END IF       
  ##NO.FUN-A10098  mark--end
       #FUN-8A0065--End--#       
       
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      #-----FUN-760039---------
      ON ACTION CONTROLP
#        IF INFIELD (omi01) THEN                                     #FUN-8A0065 Mark
  ##NO.FUN-A10098  mark--begin
        CASE                                                        #FUN-8A0065 Add
            WHEN INFIELD(omi01)                                      #FUN-8A0065 Add         
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_omi01"
            CALL cl_create_qry() RETURNING tm.omi01
            DISPLAY tm.omi01 TO omi01
            NEXT FIELD omi01 
#        END IF                                                      #FUN-8A0065 Mark
         #FUN-8A0065--Begin--#         
#            WHEN INFIELD(p1)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p1
#               CALL cl_create_qry() RETURNING tm.p1
#               DISPLAY BY NAME tm.p1
#               NEXT FIELD p1
#            WHEN INFIELD(p2)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p2
#               CALL cl_create_qry() RETURNING tm.p2
#               DISPLAY BY NAME tm.p2
#               NEXT FIELD p2
#            WHEN INFIELD(p3)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p3
#               CALL cl_create_qry() RETURNING tm.p3
#               DISPLAY BY NAME tm.p3
#               NEXT FIELD p3
#            WHEN INFIELD(p4)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p4
#               CALL cl_create_qry() RETURNING tm.p4
#               DISPLAY BY NAME tm.p4
#               NEXT FIELD p4
#            WHEN INFIELD(p5)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p5
#               CALL cl_create_qry() RETURNING tm.p5
#               DISPLAY BY NAME tm.p5
#               NEXT FIELD p5
#            WHEN INFIELD(p6)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p6
#               CALL cl_create_qry() RETURNING tm.p6
#               DISPLAY BY NAME tm.p6
#               NEXT FIELD p6
#            WHEN INFIELD(p7)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p7
#               CALL cl_create_qry() RETURNING tm.p7
#               DISPLAY BY NAME tm.p7
#               NEXT FIELD p7
#            WHEN INFIELD(p8)
#               CALL cl_init_qry_var()
#              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#               LET g_qryparam.arg1 = g_user                #No.FUN-940102
#               LET g_qryparam.default1 = tm.p8
#               CALL cl_create_qry() RETURNING tm.p8
#               DISPLAY BY NAME tm.p8
#               NEXT FIELD p8
         END CASE                        
  ##NO.FUN-A10098  mark--end
         #FUN-8A0065--End--#         
      #-----END FUN-760039-----
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      
      #FUN-8A0065--Begin--#
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3      
      #FUN-8A0065--End--#      
      
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
      LET INT_FLAG = 0 CLOSE WINDOW r622_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr622'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr622','9031',1)
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
                         " '",tm.omi01 CLIPPED,"'" ,   #TQC-610059
                         " '",tm.edate CLIPPED,"'" ,
                         " '",tm.a1 CLIPPED,"'" ,
                         " '",tm.a2 CLIPPED,"'" ,
                         " '",tm.a3 CLIPPED,"'" ,
                         " '",tm.a4 CLIPPED,"'" ,
                         " '",tm.a5 CLIPPED,"'" ,   #TQC-610059
                         " '",tm.a6 CLIPPED,"'" ,   #TQC-610059
                         " '",tm.detail CLIPPED,"'" ,   #TQC-610059
                         " '",tm.e CLIPPED,"'" ,    #No.FUN-570005                         
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
  ##NO.FUN-A10098  mark--begin
#                        " '",tm.b CLIPPED,"'" ,    #FUN-8A0065
#                        " '",tm.p1 CLIPPED,"'" ,   #FUN-8A0065
#                        " '",tm.p2 CLIPPED,"'" ,   #FUN-8A0065
#                        " '",tm.p3 CLIPPED,"'" ,   #FUN-8A0065
#                        " '",tm.p4 CLIPPED,"'" ,   #FUN-8A0065
#                        " '",tm.p5 CLIPPED,"'" ,   #FUN-8A0065
#                        " '",tm.p6 CLIPPED,"'" ,   #FUN-8A0065
#                        " '",tm.p7 CLIPPED,"'" ,   #FUN-8A0065
#                        " '",tm.p8 CLIPPED,"'" ,   #FUN-8A0065
  ##NO.FUN-A10098  mark--end
                         " '",tm.type CLIPPED,"'" , #FUN-8A0065           
                         " '",tm.s CLIPPED,"'" ,    #FUN-8A0065
                         " '",tm.t CLIPPED,"'" ,    #FUN-8A0065
                         " '",tm.u CLIPPED,"'"      #FUN-8A0065                         
                         
         CALL cl_cmdat('axrr622',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r622_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r622()
   ERROR ""
END WHILE
   CLOSE WINDOW r622_w
END FUNCTION
 
FUNCTION r622()
   DEFINE l_name     LIKE type_file.chr20,            #No.FUN-680123 VARCHAR(200       # External(Disk) file name
#         l_time     LIKE type_file.chr8              #No.FUN-6A0095
          l_sql      STRING,                          #No.FUN-680123 VARCHAR(1000)
          amt1,amt2  LIKE type_file.num20_6,          #No.FUN-680123 DEC(20,6)
          l_za05     LIKE type_file.chr1000,          #No.FUN-680123,CHAR(10)
          l_oma00    LIKE oma_file.oma00,             #No.FUN-570005
          l_omavoid  LIKE oma_file.omavoid,
          l_omaconf  LIKE oma_file.omaconf,
          l_oma52    LIKE oma_file.oma52,             #CHI-860041 add
          l_oma53    LIKE oma_file.oma53,             #CHI-860041 add
          l_oma54t   LIKE oma_file.oma54t,            #CHI-860041 add
          l_oma55    LIKE oma_file.oma55,             #CHI-860041 add
          l_oma56t   LIKE oma_file.oma56t,            #CHI-860041 add
          l_oma57    LIKE oma_file.oma57,             #CHI-860041 add
          l_oma_osum LIKE oma_file.oma57,             #CHI-860041 add
          l_oma_lsum LIKE oma_file.oma57,             #CHI-860041 add
          l_bucket   LIKE type_file.num5,             #No.FUN-680123 SMALLINT
          l_order    ARRAY[5] OF LIKE ooo_file.ooo01, #No.FUN-680123 VARCHAR(10)
          sr         RECORD
                      oma14     LIKE oma_file.oma14,      #業務員編號
                      gen02     LIKE gen_file.gen02,      #業務員name
                      oma15     LIKE oma_file.oma15,      #部門
                      occ03     LIKE occ_file.occ03,      #客戶分類
                      oca02     LIKE oca_file.oca02,      #客戶分類name
                      oma03     LIKE oma_file.oma03,      #客戶
                      oma032    LIKE oma_file.oma032,     #簡稱
                      oma02     LIKE oma_file.oma02,      #Date
                      oma01     LIKE oma_file.oma01,
                      num1      LIKE type_file.num20_6,   #No.FUN-680123 DEC(20,6) 
                      num2      LIKE type_file.num20_6,   #No.FUN-680123 DEC(20,6)
                      num3      LIKE type_file.num20_6,   #No.FUN-680123 DEC(20,6)
                      num4      LIKE type_file.num20_6,   #No.FUN-680123 DEC(20,6)
                      num5      LIKE type_file.num20_6,   #No.FUN-680123 DEC(20,6)
                      num6      LIKE type_file.num20_6,   #No.FUN-680123 DEC(20,6)
                      num7      LIKE type_file.num20_6,   #No.FUN-680123 DEC(20,6)
                      tot       LIKE type_file.num20_6,   #No.FUN-680123 DEC(20,6)
                      azi03     LIKE azi_file.azi03,
                      azi04     LIKE azi_file.azi04,
                      azi05     LIKE azi_file.azi05
                     END RECORD
DEFINE     l_i        LIKE type_file.num5                 #No.FUN-8A0065 SMALLINT
DEFINE     l_dbs      LIKE azp_file.azp03                 #No.FUN-8A0065
DEFINE     l_azp03    LIKE azp_file.azp03                 #No.FUN-8A0065
DEFINE     l_occ37    LIKE occ_file.occ37                 #No.FUN-8A0065
DEFINE     i          LIKE type_file.num5                 #No.FUN-8A0065                     
DEFINE     l_oma16    LIKE oma_file.oma16    #No:FUN-A50103
 
   #MOD-720047 - START
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #MOD-720047 - END
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720047 add
 
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
   #End:FUN-980030
  ##NO.FUN-A10098  mark--begin   
   #FUN-8A0065--Begin--#
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
#   #FUN-8A0065--End--#   
 
#   FOR l_i = 1 to 8                                                          #FUN-8A0065
#       IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8A0065
#       SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8A0065
#       LET l_azp03 = l_dbs CLIPPED                                           #FUN-8A0065
#       LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8A0065
   #No.MOD-5C0069  --Begin
   IF g_ooz.ooz07 = 'N' THEN
      LET l_sql="SELECT oma14, gen02, oma15, occ03, oca02,",
                "       oma03, oma032,oma02, oma01,",
                #"       oma56t-oma57,0,0,0,0,0,0,0,oma00",  #No.FUN-570005   #MOD-780184
                "       oma56t-oma57,0,0,0,0,0,0,0,0,0,0,oma00,",  #No.FUN-570005   #MOD-780184
                "       occ37,oma16",     #No:FUN-A50103                             #NO.FUN-8A0065 
#               " FROM oma_file,occ_file,gen_file,oca_file",                  #FUN-8A0065 Mark               
#" FROM ",l_dbs CLIPPED,"oma_file LEFT OUTER JOIN ",l_dbs CLIPPED,"gen_file ON oma_file.oma14=gen_file.gen01,",l_dbs CLIPPED,"occ_file LEFT OUTER JOIN ",l_dbs CLIPPED,"oca_file ON occ_file.occ03=oca_file.oca01",
#               " WHERE oma14=gen_file.gen01 AND oma03=occ01 AND occ03=oca_file.oca01",   #FUN-8A0065 Mark
                " FROM  oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01 , occ_file LEFT OUTER JOIN oca_file ON occ_file.occ03=oca_file.oca01 ",
                " WHERE  oma03=occ01 ",                     #FUN-8A0065                
                "   AND ",tm.wc CLIPPED,
                "   AND oma00 MATCHES '1*' AND omaconf='Y' AND omavoid='N'",
                "   AND oma02 <= '",tm.edate,"'",
                "   AND (oma56t>oma57 OR",
                #"        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,"ooa_file,",l_dbs CLIPPED,"oob_file",    #FUN-8A0065 Add ",l_dbs CLIPPED,"
                #"        oma01 IN (SELECT oob06 FROM ",cl_get_target_table(g_plant,'ooa_file'),",",cl_get_target_table(g_plant,'oob_file'),#FUN-A50102
                "        oma01 IN (SELECT oob06 FROM ooa_file ,oob_file ",#FUN-A50102
                "              WHERE ooa01=oob01  AND ooaconf !='X' ",#010804增
                "                AND ooa37 = '1'",            #FUN-B20014                
                "                AND ooa02 > '",tm.edate,"' ) OR ",      #CHI-860041 mod
                #"        oma01 IN (SELECT oma19 FROM ",l_dbs CLIPPED,"oma_file ",         #CHI-860041 add
               #"        oma01 IN (SELECT oma19 FROM ",cl_get_target_table(g_plant,'oma_file'),#FUN-A50102
                #"        oma16 IN (SELECT oma19 FROM ",cl_get_target_table(g_plant,'oma_file'),#FUN-A50102    #No:FUN-A50103
                "        oma16 IN (SELECT oma19 FROM oma_file ",#FUN-A50102
                "                   WHERE omaconf='Y' AND omavoid='N'",  #CHI-860041 add
                "                     AND (oma00='12' OR oma00='13')",   #CHI-860041 add
                "                     AND oma02 >'",tm.edate,"' )",      #CHI-860041 add
                "     ) "
      #-----No.FUN-570005-----
      IF tm.e = "Y" THEN
         LET l_sql = l_sql CLIPPED," UNION ",
                     "SELECT oma14, gen02, oma15, occ03, oca02,",
                     "       oma03, oma032,oma02, oma01,",
                     #"       oma56t-oma57,0,0,0,0,0,0,0,oma00",   #MOD-780184
                     "       oma56t-oma57,0,0,0,0,0,0,0,0,0,0,oma00,",   #MOD-780184
                     "       occ37,oma16",     #No:FUN-A50103                              #NO.FUN-8A0065
#                    " FROM oma_file,occ_file,gen_file,oca_file",                  #FUN-8A0065 Mark               
#" FROM ",l_dbs CLIPPED,"oma_file LEFT OUTER JOIN ",l_dbs CLIPPED,"gen_file ON oma_file.oma14=gen_file.gen01,",l_dbs CLIPPED,"occ_file LEFT OUTER JOIN ",l_dbs CLIPPED,"oca_file ON occ_file.occ03=oca_file.oca01",
#                    " WHERE oma14=gen_file.gen01 AND oma03=occ01 AND occ03=oca_file.oca01",   #FUN-8A0065 Mark
                     " FROM oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01,occ_file LEFT OUTER JOIN oca_file ON occ_file.occ03=oca_file.oca01 ",
                     " WHERE  oma03=occ01 ",                     #FUN-8A0065                     
                     "   AND ",tm.wc CLIPPED,
                     "   AND oma00 MATCHES '2*' AND omaconf='Y' AND omavoid='N'",
                     "   AND oma02 <= '",tm.edate,"'",
                     "   AND (oma56t-oma57 >0     OR",
                     #"        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,"ooa_file,",l_dbs CLIPPED,"oob_file",
                     #"        oma01 IN (SELECT oob06 FROM ",cl_get_target_table(g_plant,'ooa_file'),",",cl_get_target_table(g_plant,'oob_file'),#FUN-A50102
                     "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file ",#FUN-A50102
                     "              WHERE ooa01=oob01  AND ooaconf !='X' ",
                     "                AND ooa37 = '1'",            #FUN-B20014                     
                     "                AND ooa02 > '",tm.edate,"' ) OR ",      #CHI-860041 mod
                     #"        oma01 IN (SELECT oma19 FROM ",l_dbs CLIPPED,"oma_file ",         #CHI-860041 add
                    #"        oma01 IN (SELECT oma19 FROM ",cl_get_target_table(g_plant,'oma_file'), #FUN-A50102
                     #"        oma16 IN (SELECT oma19 FROM ",cl_get_target_table(g_plant,'oma_file'), #FUN-A50102    #No:FUN-A50103
                     "        oma16 IN (SELECT oma19 FROM oma_file ", #FUN-A50102
                     "                   WHERE omaconf='Y' AND omavoid='N'",  #CHI-860041 add
                     "                     AND (oma00='12' OR oma00='13')",   #CHI-860041 add
                     "                     AND oma02 >'",tm.edate,"' )",      #CHI-860041 add
                     "     ) "
      END IF
      #-----No.FUN-570005 END-----
   ELSE
      LET l_sql="SELECT oma14, gen02, oma15, occ03, oca02,",
              "       oma03, oma032,oma02, oma01,",
                #"       oma61,0,0,0,0,0,0,0,oma00",          #No.A057   #No.FUN-570005   #MOD-780184
                "       oma61,0,0,0,0,0,0,0,0,0,0,oma00,",          #No.A057   #No.FUN-570005   #MOD-780184
                "       occ37,oma16",    #No:FUN-A50103                               #NO.FUN-8A0065
#               " FROM oma_file,occ_file,gen_file,oca_file",                  #FUN-8A0065 Mark               
#" FROM ",l_dbs CLIPPED,"oma_file LEFT OUTER JOIN ",l_dbs CLIPPED,"gen_file ON oma_file.oma14=gen_file.gen01,",l_dbs CLIPPED,"occ_file LEFT OUTER JOIN ",l_dbs CLIPPED,"oca_file ON occ_file.occ03=oca_file.oca01",
#               " WHERE oma14=gen_file.gen01 AND oma03=occ01 AND occ03=oca_file.oca01",   #FUN-8A0065 Mark
                " FROM oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01, occ_file LEFT OUTER JOIN oca_file ON occ_file.occ03=oca_file.oca01",
                " WHERE  oma03=occ01 ",                     #FUN-8A0065                
                "   AND ",tm.wc CLIPPED,
                "   AND oma00 MATCHES '1*' AND omaconf='Y' AND omavoid='N'",
                "   AND oma02 <= '",tm.edate,"'",
                "   AND (oma61 >0     OR",
                #"        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,"ooa_file,",l_dbs CLIPPED,"oob_file",
                #"        oma01 IN (SELECT oob06 FROM ",cl_get_target_table(g_plant,'ooa_file'),",",cl_get_target_table(g_plant,'oob_file'),#FUN-A50102
                "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file ",#FUN-A50102
                "                   WHERE ooa01=oob01  AND ooaconf !='X' ",#010804增
                "                     AND ooa37 = '1'",            #FUN-B20014                
                "                     AND ooa02 > '",tm.edate,"' ) OR ", #CHI-860041 mod
                #"        oma01 IN (SELECT oma19 FROM ",l_dbs CLIPPED,"oma_file ",         #CHI-860041 add
               #"        oma01 IN (SELECT oma19 FROM ",cl_get_target_table(g_plant,'oma_file'), #FUN-A50102
                #"        oma16 IN (SELECT oma19 FROM ",cl_get_target_table(g_plant,'oma_file'), #FUN-A50102    #No:FUN-A50103
                "        oma16 IN (SELECT oma19 FROM oma_file ", #FUN-A50102
                "                   WHERE omaconf='Y' AND omavoid='N'",  #CHI-860041 add
                "                     AND (oma00='12' OR oma00='13')",   #CHI-860041 add
                "                     AND oma02 >'",tm.edate,"' )",      #CHI-860041 add
                "     ) "
      #-----No.FUN-570005-----
      IF tm.e = "Y" THEN
         LET l_sql = l_sql CLIPPED," UNION ",
                     "SELECT oma14, gen02, oma15, occ03, oca02,",
                     "       oma03, oma032,oma02, oma01,",
                     #"       oma61,0,0,0,0,0,0,0,oma00",   #MOD-780184
                     "       oma61,0,0,0,0,0,0,0,0,0,0,oma00,",   #MOD-780184
                     "       occ37,oma16",     #No:FUN-A50103                       #NO.FUN-8A0065
#                    " FROM oma_file,occ_file,gen_file,oca_file",                  #FUN-8A0065 Mark               
#" FROM ",l_dbs CLIPPED,"oma_file LEFT OUTER JOIN ",l_dbs CLIPPED,"gen_file ON oma_file.oma14=gen_file.gen01,",l_dbs CLIPPED,"occ_file LEFT OUTER JOIN ",l_dbs CLIPPED,"oca_file ON occ_file.occ03=oca_file.oca01",
#                    " WHERE oma14=gen_file.gen01 AND oma03=occ01 AND occ03=oca_file.oca01",   #FUN-8A0065 Mark
                     " FROM oma_file LEFT OUTER JOIN gen_file ON oma_file.oma14=gen_file.gen01,occ_file LEFT OUTER JOIN oca_file ON occ_file.occ03=oca_file.oca01",
                     " WHERE  oma03=occ01 ",                     #FUN-8A0065
                     "   AND ",tm.wc CLIPPED,
                     "   AND oma00 MATCHES '2*' AND omaconf='Y' AND omavoid='N'",
                     "   AND oma02 <= '",tm.edate,"'",
                     "   AND (oma61 >0     OR",
                     #"        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,"ooa_file,",l_dbs CLIPPED,"oob_file",
                     #"        oma01 IN (SELECT oob06 FROM ",cl_get_target_table(g_plant,'ooa_file'),",",cl_get_target_table(g_plant,'oob_file'),#FUN-A50102
                     "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file ",#FUN-A50102
                     "                   WHERE ooa01=oob01  AND ooaconf !='X' ",
                     "                     AND ooa37 = '1'",            #FUN-B20014
                     "                     AND ooa02 > '",tm.edate,"' ) OR ", #CHI-860041 mod
                     #"        oma01 IN (SELECT oma19 FROM ",l_dbs CLIPPED,"oma_file ",         #CHI-860041 add
                    #"        oma01 IN (SELECT oma19 FROM ",cl_get_target_table(g_plant,'oma_file'),   #FUN-A50102
                     #"        oma16 IN (SELECT oma19 FROM ",cl_get_target_table(g_plant,'oma_file'),   #FUN-A50102    #No:FUN-A50103
                     "        oma16 IN (SELECT oma19 FROM oma_file ",#FUN-A50102
                     "                   WHERE omaconf='Y' AND omavoid='N'",  #CHI-860041 add
                     "                     AND (oma00='12' OR oma00='13')",   #CHI-860041 add
                     "                     AND oma02 >'",tm.edate,"' )",      #CHI-860041 add
                     "     ) "
      END IF
      #-----No.FUN-570005 END-----
   END IF
   #No.MOD-5C0069  --End
 
 	 #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     #CALL cl_parse_qry_sql(l_sql,g_plant) RETURNING l_sql #FUN-A50102
   PREPARE r622_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM 
   END IF
   DECLARE r622_curs1 CURSOR FOR r622_prepare1
#   CALL cl_outnam('axrr622') RETURNING l_name
#   START REPORT r622_rep TO l_name
 
   LET g_pageno = 0
   LET l_tot=0
   FOREACH r622_curs1 INTO sr.*,l_oma00,l_occ37,l_oma16    #No.FUN-570005    #FUN-8A0065 Add l_occ37    #No:FUN-A50103
      IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM 
      END IF
      #FUN-8A0065--Begin--#
      IF cl_null(l_occ37) THEN LET l_occ37 = 'N' END IF
      IF tm.type = '1' THEN
         IF l_occ37  = 'N' THEN  CONTINUE FOREACH END IF
      END IF
      IF tm.type = '2' THEN   #非關係人
         IF l_occ37  = 'Y' THEN  CONTINUE FOREACH END IF
      END IF
      #FUN-8A0065--End--#      
      IF l_oma00 MATCHES '1*' THEN   #No.FUN-570005
         LET amt1=0 LET amt2=0
      #FUN-8A0065--Begin--#   
#        SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2
#          FROM oob_file, ooa_file
#         WHERE oob06=sr.oma01 AND oob03='2' AND oob04='1' AND ooaconf='Y'
#           AND ooa01=oob01 AND ooa02 > tm.edate         
          LET l_sql = "SELECT SUM(oob09),SUM(oob10) ",                                                                              
#                     "  FROM ",l_dbs CLIPPED,"oob_file,",                                                                          
#                               l_dbs CLIPPED,"ooa_file ",
                      "  FROM oob_file,ooa_file",
                      " WHERE oob06='",sr.oma01,"'",
                      "   AND oob03='2' AND oob04='1' AND ooaconf='Y'",
                      "   AND ooa37 = '1'",            #FUN-B20014
                      "   AND ooa01=oob01 AND ooa02 > '",tm.edate,"'"                                                                                                                                                                                   
 	 #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE oob_prepare3 FROM l_sql                                                                                          
          DECLARE oob_c3  CURSOR FOR oob_prepare3                                                                                 
          OPEN oob_c3                                                                                    
          FETCH oob_c3 INTO amt1,amt2
     #FUN-8A0065--END--#                  
         IF amt1 IS NULL THEN LET amt1=0 END IF
         IF amt2 IS NULL THEN LET amt2=0 END IF
      #-----No.FUN-570005-----
      ELSE
         LET amt1=0 LET amt2=0
      #FUN-8A0065--Begin--#   
#        SELECT SUM(oob09),SUM(oob10) INTO amt1,amt2
#          FROM oob_file, ooa_file
#         WHERE oob06=sr.oma01 AND oob03='1' AND oob04='3' AND ooaconf='Y'
#           AND ooa01=oob01 AND ooa02 > tm.edate         
          LET l_sql = "SELECT SUM(oob09),SUM(oob10) ",                                                                              
#                     "  FROM ",l_dbs CLIPPED,"oob_file,",                                                                          
#                               l_dbs CLIPPED,"ooa_file ",
                      "  FROM oob_file,ooa_file",
                      " WHERE oob06='",sr.oma01,"'",
                      "   AND oob03='1' AND oob04='3' AND ooaconf='Y'",
                      "   AND ooa37 = '1'",            #FUN-B20014
                      "   AND ooa01=oob01 AND ooa02 > '",tm.edate,"'"                                                                                                                                                                                   
 	 #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE oob_prepare1 FROM l_sql                                                                                          
          DECLARE oob_c1  CURSOR FOR oob_prepare1                                                                                 
          OPEN oob_c1                                                                                    
          FETCH oob_c1 INTO amt1,amt2
     #FUN-8A0065--END--#               
         IF amt1 IS NULL THEN LET amt1=0 END IF
         IF amt2 IS NULL THEN LET amt2=0 END IF
        #str CHI-860041 add
        #當oma00='23'的帳單號碼抓取對應到oma00='12'的oma19其單據日期>截止日期,
        #已沖金額需加回這些超出截止日期單據的oma53
         IF l_oma00 = '23' THEN
            LET sr.num1 = 0
     #FUN-8A0065--Begin--#
#           SELECT oma54t,oma55,oma56t,oma57
#             INTO l_oma54t,l_oma55,l_oma56t,l_oma57
#             FROM oma_file
#            WHERE oma01 = sr.oma01
          LET l_sql = "SELECT oma54t,oma55,oma56t,oma57 ",                                                                              
#                     "  FROM ",l_dbs CLIPPED,"oma_file", 
                      "  FROM oma_file",
                      " WHERE oma01='",sr.oma01,"'"                                                                                                                                                                              
 	 #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE oma_prepare1 FROM l_sql                                                                                          
          DECLARE oma_c1  CURSOR FOR oma_prepare1                                                                                 
          OPEN oma_c1                                                                                    
          FETCH oma_c1 INTO l_oma54t,l_oma55,l_oma56t,l_oma57
     #FUN-8A0065--END--#             
             
            IF cl_null(l_oma54t) THEN LET l_oma54t=0 END IF
            IF cl_null(l_oma55)  THEN LET l_oma55 =0 END IF
            IF cl_null(l_oma56t) THEN LET l_oma56t=0 END IF
            IF cl_null(l_oma57)  THEN LET l_oma57 =0 END IF
            #原幣、本幣
         #FUN-8A0065--Begin--#   
#           SELECT SUM(oma52)+SUM(oma54)+SUM(oma54x),
#                  SUM(oma53)+SUM(oma56)+SUM(oma56x)
#             INTO l_oma_osum,l_oma_lsum
#             FROM oma_file
#            WHERE oma19 = sr.oma01
#              AND (oma00='12' OR oma00='13') AND omaconf='Y' AND omavoid='N'
#              AND oma02<=tm.edate
          LET l_sql = "SELECT SUM(oma52)+SUM(oma54)+SUM(oma54x),SUM(oma53)+SUM(oma56)+SUM(oma56x) ",                                                                              
#                     "  FROM ",l_dbs CLIPPED,"oma_file",
                      "  FROM oma_file",
                     #" WHERE oma19='",sr.oma01,"'",
                      " WHERE oma19='",l_oma16,"'",    #No:FUN-A50103
                      "   AND (oma00='12' OR oma00='13') AND omaconf='Y' AND omavoid='N'",
                      "   AND oma02<='",tm.edate,"'"                                                                                                                                                                                   
 	 #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE oma_prepare2 FROM l_sql                                                                                          
          DECLARE oma_c2  CURSOR FOR oma_prepare2                                                                                 
          OPEN oma_c2                                                                                    
          FETCH oma_c2 INTO l_oma_osum,l_oma_lsum
          #FUN-8A0065--End--#               
            IF cl_null(l_oma_osum) THEN LET l_oma_osum=0 END IF
            IF cl_null(l_oma_lsum) THEN LET l_oma_lsum=0 END IF
            #當原幣合計金額等於原幣已沖合計金額,就讓本幣合計金額等於本幣已沖金額
            IF l_oma_osum=l_oma55 THEN LET l_oma_lsum=l_oma57 END IF
 
            #未沖金額 = 應收 - 已收
            LET l_oma52 = l_oma54t - l_oma_osum
            LET l_oma53 = l_oma56t - l_oma_lsum
            IF l_oma54t=l_oma55 THEN
               LET l_oma53=l_oma57-l_oma_lsum
            END IF
            IF cl_null(l_oma52) THEN LET l_oma52=0 END IF
            IF cl_null(l_oma53) THEN LET l_oma53=0 END IF
 
            LET amt2=amt2+l_oma53
         END IF
        #end CHI-860041 add
         LET amt2=sr.num1+amt2 LET sr.num1=0
         LET amt2=amt2*-1
      END IF
 
      LET amt2=sr.num1+amt2 LET sr.num1=0
      LET l_bucket=tm.edate - sr.oma02
      CASE WHEN l_bucket<=tm.a1 LET sr.num1=amt2 * l_omi21/100
           WHEN l_bucket<=tm.a2 LET sr.num2=amt2 * l_omi22/100
           WHEN l_bucket<=tm.a3 LET sr.num3=amt2 * l_omi23/100
           WHEN l_bucket<=tm.a4 LET sr.num4=amt2 * l_omi24/100
           WHEN l_bucket<=tm.a5 LET sr.num5=amt2 * l_omi25/100
           WHEN l_bucket<=tm.a6 LET sr.num6=amt2 * l_omi26/100
           OTHERWISE            LET sr.num7=amt2
      END CASE
      #FUN-710066--end
 
      #MOD-720047 - START
        
      #FUN-8A0065--Begin--#
#     SELECT azi03,azi04,azi05 INTO sr.azi03,sr.azi04,sr.azi05
#    #  FROM azi_file WHERE azi01=sr.oma23       #MOD-8A0189 mark
#       FROM azi_file WHERE azi01=g_aza.aza17    #MOD-8A0189            
 
      LET l_sql = "SELECT azi03,azi04 ",                                                                              
#                 "  FROM ",l_dbs CLIPPED,"azi_file",
                  "  FROM azi_file", 
                  " WHERE azi01='",g_aza.aza17,"'"                                                                                                                                                                                  
 	 #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          PREPARE azi_prepare2 FROM l_sql                                                                                          
          DECLARE azi_c2  CURSOR FOR azi_prepare2                                                                                 
          OPEN azi_c2                                                                                    
          FETCH azi_c2 INTO sr.azi03,sr.azi04
      SELECT azi05 INTO sr.azi05
        FROM azi_file WHERE azi01=g_aza.aza17         
      #FUN-8A0065--End--#        
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
#     EXECUTE insert_prep USING sr.*,m_dbs[l_i]                                    #FUN-8B0118 Add m_dbs[l_i]
      EXECUTE insert_prep USING sr.*,''
      #MOD-720047 - END
   END FOREACH
#  END FOR                                                                      #FUN-8A0065
   
   #MOD-720047 - START
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'oma03,oma14,oma15,occ03,oma18')   #FUN-C40021 add 'oma18'
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   IF cl_null(tm.s[1,1]) THEN LET tm.s[1,1] = '0' END IF                #FUN-8A0065
   IF cl_null(tm.s[2,2]) THEN LET tm.s[2,2] = '0' END IF                #FUN-8A0065
   IF cl_null(tm.s[3,3]) THEN LET tm.s[3,3] = '0' END IF                #FUN-8A0065
   #No.TQC-A50082  --Begin
#  IF tm.b = 'Y' THEN                                                   #FUN-8A0065
#     LET l_name = 'axrr622_1'                                          #FUN-8A0065
#  ELSE                                                                 #FUN-8A0065
#  	  LET l_name = 'axrr622'                                            #FUN-8A0065
#  END IF	                                                              #FUN-8A0065   
   IF cl_null(tm.a6) THEN LET l_name = 'axrr622_11' END IF                   
   IF cl_null(tm.a5) THEN LET l_name = 'axrr622_10' END IF                   
   IF cl_null(tm.a4) THEN LET l_name = 'axrr622_9' END IF                    
   IF cl_null(tm.a3) THEN LET l_name = 'axrr622_8' END IF                    
   IF cl_null(tm.a2) THEN LET l_name = 'axrr622_7' END IF                    
   IF NOT cl_null(tm.a1) AND NOT cl_null(tm.a2) AND NOT cl_null(tm.a3) AND   
      NOT cl_null(tm.a4) AND NOT cl_null(tm.a5) AND NOT cl_null(tm.a6) THEN  
      LET l_name = 'axrr622'                                                 
   END IF                                                                    
   #No.TQC-A50082  --End  
   LET g_str = g_str CLIPPED,";",
               tm.a1,";",tm.a2,";",tm.a3,";",tm.a4,";",
               tm.a5,";",tm.a6,";",
               tm.detail,";",tm.edate,";",
               tm.type,";",tm.s[1,1],";",tm.s[2,2],";",                 #FUN-8A0065
#              tm.s[3,3],";",tm.t,";",tm.u,";",tm.b                     #FUN-8A0065
               tm.s[3,3],";",tm.t,";",tm.u,";",'N'
   CALL cl_prt_cs3('axrr622',l_name,l_sql,g_str)   #FUN-710080 modify   #FUN-8A0065 Add l_name
   #------------------------------ CR (4) ------------------------------#
   #MOD-720047 - END
  ##NO.FUN-A10098  mark--end 
END FUNCTION
  ##NO.FUN-A10098  mark--begin 
#FUN-8A0065--Begin--#
#FUNCTION r622_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
#FUNCTION r622_set_no_entry_1()
#    IF tm.b = 'N' THEN
#       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#       IF tm2.s1 = '5' THEN
#          LET tm2.s1 = ' '
#       END IF
#       IF tm2.s2 = '5' THEN
#          LET tm2.s2 = ' '
#       END IF
#       IF tm2.s3 = '5' THEN
#          LET tm2.s3= ' '
#       END IF
#    END IF
#END FUNCTION
#FUNCTION r622_set_comb()                                                                                                            
#  DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                    
#    IF tm.b ='N' THEN                                                                                                         
#       LET comb_value = '1,2,3,4'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-988' AND ze02=g_lang                                                                                      
#    ELSE                                                                                                                            
#       LET comb_value = '1,2,3,4,5'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axr-989' AND ze02=g_lang                                                                                       
#    END IF                                                                                                                          
#    CALL cl_set_combo_items('s1',comb_value,comb_item)
#    CALL cl_set_combo_items('s2',comb_value,comb_item)
#    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
#FUN-8A0065--End--#
  ##NO.FUN-A10098  mark--end  
REPORT r622_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,                            #No.FUN-680123 VARCHAR(1)
          l_amt1,l_amt2,l_amt3,l_amt4  LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
          l_amt5,l_amt6,l_amt7,l_amt8  LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
          sr        RECORD
                  oma14        LIKE oma_file.oma14,      #業務員編號
                  gen02        LIKE gen_file.gen02,      #業務員name
                  oma15        LIKE oma_file.oma15,      #部門
                  occ03        LIKE occ_file.occ03,      #客戶分類
                  oca02        LIKE oca_file.oca02,      #客戶分類name
                  oma03        LIKE oma_file.oma03,      #客戶
                  oma032       LIKE oma_file.oma032,     #簡稱
                  oma02        LIKE oma_file.oma02,      #Date
                  oma01        LIKE oma_file.oma01,
                  num1      LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
                  num2      LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
                  num3      LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
                  num4      LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
                  num5      LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
                  num6      LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
                  num7      LIKE type_file.num20_6,         #No.FUN-680123 DEC(20,6)
                  tot       LIKE type_file.num20_6          #No.FUN-680123 DEC(20,6)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.occ03, sr.oma03, sr.oma032
  FORMAT
   PAGE HEADER
#No.FUN-580010--start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT COLUMN 105,g_x[25] CLIPPED,tm.edate
      PRINT g_dash[1,g_len]
     LET g_zaa[46].zaa08='0-',tm.a1 USING '###'
     LET g_zaa[47].zaa08=tm.a1+1 USING '###','-',tm.a2 USING '###'
     LET g_zaa[48].zaa08=tm.a2+1 USING '###','-',tm.a3 USING '###'
     LET g_zaa[49].zaa08=tm.a3+1 USING '###','-',tm.a4 USING '###'
     LET g_zaa[50].zaa08=tm.a4+1 USING '###','-',tm.a5 USING '###'
     LET g_zaa[51].zaa08=tm.a5+1 USING '###','-',tm.a6 USING '###'
     LET g_zaa[52].zaa08=tm.a6+1 USING '###',g_x[39]
     PRINT g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53]
     PRINT g_dash1
     LET l_last_sw ='n'  #No.TQC-6B0051
#No.FUN-580010--end
   ON EVERY ROW
      IF tm.detail='Y' THEN
#No.FUN-580010--start
         PRINT COLUMN g_c[43],sr.occ03,
               COLUMN g_c[44],sr.oma01,
               COLUMN g_c[45],sr.oma02,
               COLUMN g_c[46],cl_numfor(sr.num1,46,t_azi05),
               COLUMN g_c[47],cl_numfor(sr.num2,47,t_azi05),
               COLUMN g_c[48],cl_numfor(sr.num3,48,t_azi05),
               COLUMN g_c[49],cl_numfor(sr.num4,49,t_azi05),
               COLUMN g_c[50],cl_numfor(sr.num5,50,t_azi05),
               COLUMN g_c[51],cl_numfor(sr.num6,51,t_azi05),
               COLUMN g_c[52],cl_numfor(sr.num7,52,t_azi05)
      END IF
   AFTER GROUP OF sr.oma032
         LET l_amt1= GROUP SUM(sr.num1)
         LET l_amt2= GROUP SUM(sr.num2)
         LET l_amt3= GROUP SUM(sr.num3)
         LET l_amt4= GROUP SUM(sr.num4)
         LET l_amt5= GROUP SUM(sr.num5)
         LET l_amt6= GROUP SUM(sr.num6)
         LET l_amt7= GROUP SUM(sr.num7)
       LET l_amt8=l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6+l_amt7
#No.FUN-580010--start
         PRINT COLUMN g_c[43],sr.occ03,
               COLUMN g_c[44],sr.oma03,    #NO:7458
               COLUMN g_c[45],sr.oma032,   #NO:7458
               COLUMN g_c[46],cl_numfor(l_amt1,46,t_azi05),
               COLUMN g_c[47],cl_numfor(l_amt2,47,t_azi05),
               COLUMN g_c[48],cl_numfor(l_amt3,48,t_azi05),
               COLUMN g_c[49],cl_numfor(l_amt4,49,t_azi05),
               COLUMN g_c[50],cl_numfor(l_amt5,50,t_azi05),
               COLUMN g_c[51],cl_numfor(l_amt6,51,t_azi05),
               COLUMN g_c[52],cl_numfor(l_amt7,52,t_azi05),
               COLUMN g_c[53],cl_numfor(l_amt8,53,t_azi05)
#No.FUN-580010--end
      IF tm.detail='Y' THEN PRINT END IF
 
   AFTER GROUP OF sr.occ03
         LET l_amt1= GROUP SUM(sr.num1)
         LET l_amt2= GROUP SUM(sr.num2)
         LET l_amt3= GROUP SUM(sr.num3)
         LET l_amt4= GROUP SUM(sr.num4)
         LET l_amt5= GROUP SUM(sr.num5)
         LET l_amt6= GROUP SUM(sr.num6)
         LET l_amt7= GROUP SUM(sr.num7)
       LET l_amt8=l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6+l_amt7
#No.FUN-580010--start
         PRINT
         PRINTX name=S1
               COLUMN g_c[43],sr.occ03,
               COLUMN g_c[44],g_x[41] CLIPPED,
               COLUMN g_c[46],cl_numfor(l_amt1,46,t_azi05),
               COLUMN g_c[47],cl_numfor(l_amt2,47,t_azi05),
               COLUMN g_c[48],cl_numfor(l_amt3,48,t_azi05),
               COLUMN g_c[49],cl_numfor(l_amt4,49,t_azi05),
               COLUMN g_c[50],cl_numfor(l_amt5,50,t_azi05),
               COLUMN g_c[51],cl_numfor(l_amt6,51,t_azi05),
               COLUMN g_c[52],cl_numfor(l_amt7,52,t_azi05),
               COLUMN g_c[53],cl_numfor(l_amt8,53,t_azi05)
#No.FUN-580010--end
         PRINT
 
   ON LAST ROW
         LET l_amt1= SUM(sr.num1)
         LET l_amt2= SUM(sr.num2)
         LET l_amt3= SUM(sr.num3)
         LET l_amt4= SUM(sr.num4)
         LET l_amt5= SUM(sr.num5)
         LET l_amt6= SUM(sr.num6)
         LET l_amt7= SUM(sr.num7)
       LET l_amt8=l_amt1+l_amt2+l_amt3+l_amt4+l_amt5+l_amt6+l_amt7
         PRINT
#No.FUN-580010--start
         PRINTX name=S1
               COLUMN g_c[44],g_x[42] CLIPPED,
               COLUMN g_c[46],cl_numfor(l_amt1,46,t_azi05),
               COLUMN g_c[47],cl_numfor(l_amt2,47,t_azi05),
               COLUMN g_c[48],cl_numfor(l_amt3,48,t_azi05),
               COLUMN g_c[49],cl_numfor(l_amt4,49,t_azi05),
               COLUMN g_c[50],cl_numfor(l_amt5,50,t_azi05),
               COLUMN g_c[51],cl_numfor(l_amt6,51,t_azi05),
               COLUMN g_c[52],cl_numfor(l_amt7,52,t_azi05),
               COLUMN g_c[53],cl_numfor(l_amt8,53,t_azi05)
#No.FUN-580010--end
#No.TQC-6B0051  --begin --mark--
#              PRINT '(axrr622)'
#         PRINT g_dash[1,g_len]
#         PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
#No.TQC-6B0051  --end  --mark--
         LET l_last_sw ='y'   #No.TQC-6B0051
 
#No.TQC-6B0051  --begin
      PAGE TRAILER
           PRINT g_dash[1,g_len]
           IF l_last_sw ='y' THEN
              PRINT g_x[18] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED
              PRINT
           ELSE
              PRINT g_x[18] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED
              PRINT
           END IF
           PRINT g_x[4] CLIPPED,COLUMN 41,g_x[5] CLIPPED
#No.TQC-6B0051 --end
         
END REPORT
#Patch....NO.TQC-610037 <> #
