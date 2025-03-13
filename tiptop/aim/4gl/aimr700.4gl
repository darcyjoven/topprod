# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimr700.4gl
# Descriptions...: 工廠間調撥數量稽核表
# Input parameter:
# Return code....:
# Date & Author..:  93/07/15 By Apple
# Modify ........: No.MOD-480173 04/08/12 By Nicola 輸入順序錯誤
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-580014 05/08/16 By wujie  雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-5C0002 05/12/02 By Sarah 補印ima021
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 無列印順序,
# Modify.........: No.FUN-750112 07/06/04 By Jackho CR報表修改
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-DB0030 13/11/25 By wangrr "調撥單號""申請人""撥出倉別"欄位增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           wc      STRING,                 # Where Condition  #TQC-630166
           imn041  LIKE imn_file.imn041,
           imn151  LIKE imn_file.imn151,
           a       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           b       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           c       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           s       LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           t       LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_sma115    LIKE sma_file.sma115,    #No.FUN-580014
       l_orderA    ARRAY[3] OF LIKE imm_file.imm13   #No.TQC-6A0088
DEFINE l_table     STRING                 ### FUN-750112 ###
DEFINE g_str       STRING                 ### FUN-750112 ###
DEFINE g_sql       STRING                 ### FUN-750112 ###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
#--------------------No.FUN-750112--begin----CR(1)----------------#
    LET g_sql = "imn01.imn_file.imn01,",
                "azp02.azp_file.azp02,",     #l_azp02_1
                "imn02.imn_file.imn02,",
                "imn04.imn_file.imn04,",
                "imn05.imn_file.imn05,",
                "imn03.imn_file.imn03,",
                "ima05.ima_file.ima05,",
                "ima08.ima_file.ima08,",
                "chr1000.type_file.chr1000,", 	        #str1
                "imn09.imn_file.imn09,",
                "imn10.imn_file.imn10,", 
                "imn11.imn_file.imn11,", 
                "imn27.imn_file.imn27,",
                "ima25.ima_file.ima25,",
                "ims01.ims_file.ims01,",
                "ims02.ims_file.ims02,",
                "imy01.imy_file.imy01,",
                "imy07.imy_file.imy07,",
                "imy08.imy_file.imy08,",
                "imy06.imy_file.imy06,",
                "chr1.type_file.chr1,",                  #l_flag1
                "imn40.imn_file.imn40,",
                "imy16.imy_file.imy16,",
                "aaaacti.aaa_file.aaaacti,",             #l_flag2
                "imy17.imy_file.imy17,",
                "imy25.imy_file.imy25,",                 #l_invqty
                "imy28.imy_file.imy28,",                 #l_diff
                "azp03.azp_file.azp03,",                 #l_azp02_2
                "imn06.imn_file.imn06,",
                "ima02.ima_file.ima02,",
                "azp051.azp_file.azp051,",               # l_str2
                "ima021.ima_file.ima021,",
                "imm02.imm_file.imm02,",
                "imm09.imm_file.imm09"
 
    LET l_table = cl_prt_temptable('aimr700',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF               
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
                "        ?, ?, ?, ? ,?, ?, ?, ?, ?, ?,",
                "        ? ,?, ? ,?, ?, ?, ?, ?, ?, ?,",
                "        ?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
#--------------------No.FUN-750112--end------CR (1) ------------#
 
   LET g_pdate   = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom  = ARG_VAL(2)
   LET g_rlang   = ARG_VAL(3)
   LET g_bgjob   = ARG_VAL(4)
   LET g_prtway  = ARG_VAL(5)
   LET g_copies  = ARG_VAL(6)
   LET tm.wc     = ARG_VAL(7)
   LET tm.imn041 = ARG_VAL(8)
   LET tm.imn151 = ARG_VAL(9)
   LET tm.a      = ARG_VAL(10)
   LET tm.b      = ARG_VAL(11)
   LET tm.c      = ARG_VAL(12)
   LET tm.s      = ARG_VAL(13)
   LET tm.t      = ARG_VAL(14)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aimr700_tm(0,0)        # Input print condition
      ELSE CALL aimr700()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr700_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
DEFINE li_result      LIKE type_file.num5     #No.FUN-940102
 
   LET p_row = 4 LET p_col = 10
 
   OPEN WINDOW aimr700_w AT p_row,p_col WITH FORM "aim/42f/aimr700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.imn041 = g_plant
   LET tm.a    = 'N'
   LET tm.b    = 'Y'
   LET tm.c    = 'N'
   LET tm.s    = '123'
   LET tm.more = 'N'
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
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON imm01,imm02,imm09,
                              imn03,imn04
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
            IF INFIELD(imn03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imn03
               NEXT FIELD imn03
            END IF
            #TQC-DB0030--add--str--
            IF INFIELD(imm01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imm107"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = g_plant
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imm01
               NEXT FIELD imm01
            END IF
            IF INFIELD(imm09) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imm09
               NEXT FIELD imm09
            END IF
            IF INFIELD(imn04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imd"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1= 'SW'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imn04
               NEXT FIELD imn04
            END IF
            #TQC-DB0030--add--end
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aimr700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
    INPUT BY NAME tm.imn041,tm.imn151,tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm.a,tm.b,tm.c,tm.more  #No.MOD-480173
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD imn041   #撥出工廠
         IF tm.imn041 IS NOT NULL AND tm.imn041 != ' '
          THEN SELECT azp02 FROM azp_file
         	           	   WHERE azp01 = tm.imn041
               IF SQLCA.SQLCODE
               THEN # CALL cl_err(tm.imn041,'mfg9142',0) #No.FUN-660156
                      CALL cl_err3("sel","azp_file",tm.imn041,"","mfg9142",
                                   "","",0)  #No.FUN-660156
                    NEXT FIELD imn041
               END IF
#No.FUN-940102 --begin--
               CALL s_chk_demo(g_user,tm.imn041) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD imn041
                END IF 
#No.FUN-940102 --end--
         END IF
      AFTER FIELD imn151   #撥入工廠
         IF tm.imn151 IS NOT NULL AND tm.imn151 != ' '
          THEN SELECT azp02 FROM azp_file
         	           	   WHERE azp01 = tm.imn151
               IF SQLCA.SQLCODE
               THEN #CALL cl_err(tm.imn151,'mfg9142',0) #No.FUN-660156 
                     CALL cl_err3("sel","azp_file",tm.imn151,"","mfg9142",
                                  "","",0)  #No.FUN-660156
                    NEXT FIELD imn151
               END IF
#No.FUN-940102 --begin--
               CALL s_chk_demo(g_user,tm.imn151) RETURNING li_result
                IF not li_result THEN 
                 NEXT FIELD imn151
                END IF 
#No.FUN-940102 --end-- 
         END IF
      AFTER FIELD a
         IF tm.a NOT MATCHES "[YN]" OR tm.a IS NULL
            THEN NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL
            THEN NEXT FIELD b
         END IF
      AFTER FIELD c
         IF tm.c NOT MATCHES "[YN]" OR tm.c IS NULL
            THEN NEXT FIELD c
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imn041) #工廠別
#                 CALL q_azr(8,45,tm.imn041) RETURNING tm.imn041
#                 CALL FGL_DIALOG_SETBUFFER( tm.imn041 )
                  CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_azr"    #No.FUN-940102
                  LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                  LET g_qryparam.arg1 = g_user    #No.FUN-940102
                  LET g_qryparam.default1 = tm.imn041
                  CALL cl_create_qry() RETURNING tm.imn041
#                  CALL FGL_DIALOG_SETBUFFER( tm.imn041 )
                  DISPLAY BY NAME tm.imn041
                  NEXT FIELD imn041
 
               WHEN INFIELD(imn151) #工廠別
#                 CALL q_azr(8,45,tm.imn151) RETURNING tm.imn151
#                 CALL FGL_DIALOG_SETBUFFER( tm.imn151 )
                  CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_azr"    #No.FUN-940102
                  LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                  LET g_qryparam.arg1 = g_user    #No.FUN-940102
                  LET g_qryparam.default1 = tm.imn151
                  CALL cl_create_qry() RETURNING tm.imn151
#                  CALL FGL_DIALOG_SETBUFFER( tm.imn151 )
                  DISPLAY BY NAME tm.imn151
                  NEXT FIELD imn151
 
               OTHERWISE
                  EXIT CASE
 
            END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1[1,1],tm2.t2[1,1],tm2.t3[1,1]
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr700_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr700'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr700','9031',1)
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
                         " '",tm.imn041 CLIPPED,"'",
                         " '",tm.imn151 CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.c CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr700',g_time,l_cmd)
      END IF
      CLOSE WINDOW aimr700_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr700()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr700_w
END FUNCTION
 
FUNCTION aimr700()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                       # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           imm02  LIKE imm_file.imm02,   #調撥日期
                           imm09  LIKE imm_file.imm09,   #確認人
                           imn01  LIKE imn_file.imn01,   #調撥單號
                           imn02  LIKE imn_file.imn02,   #項次
                           imn03  LIKE imn_file.imn03,   #料件
                           imn041 LIKE imn_file.imn041,  #撥出工廠
                           imn04  LIKE imn_file.imn04,   #倉庫
                           imn05  LIKE imn_file.imn05,   #儲位
                           imn06  LIKE imn_file.imn06,   #批號
                           imn09  LIKE imn_file.imn09,   #單位
                           imn10  LIKE imn_file.imn10,   #預撥出量
                           imn11  LIKE imn_file.imn11,   #實撥出量
                           imn151 LIKE imn_file.imn151,  #撥入工廠
                           imn27  LIKE imn_file.imn27,   #結案否
                           imn30  LIKE imn_file.imn30,   #No.FUN-580014
                           imn32  LIKE imn_file.imn32,   #No.FUN-580014
                           imn33  LIKE imn_file.imn33,   #No.FUN-580014
                           imn35  LIKE imn_file.imn35,   #No.FUN-580014
                           imn40  LIKE imn_file.imn40,   #No.FUN-580014
                           imn42  LIKE imn_file.imn42,   #No.FUN-580014
                           imn43  LIKE imn_file.imn43,   #No.FUN-580014
                           imn45  LIKE imn_file.imn45,   #No.FUN-580014
                           ims01  LIKE ims_file.ims01,   #撥出單號
                           ims02  LIKE ims_file.ims02,   #撥出項次
                           ims06  LIKE ims_file.ims06,   #撥出數量
                           imy01  LIKE imy_file.imy01,   #撥入單號
                           imy07  LIKE imy_file.imy07,   #倉庫
                           imy08  LIKE imy_file.imy08,   #儲位
                           imy09  LIKE imy_file.imy09,   #批號
                           imy16  LIKE imy_file.imy16,   #撥出數量
                           imy17  LIKE imy_file.imy17,   #撥出單位
                           imy18  LIKE imy_file.imy18,   #FACTOR
                           ima02  LIKE ima_file.ima02,   #品名
                           ima021 LIKE ima_file.ima021,  #規格   #FUN-5C0002
                           ima05  LIKE ima_file.ima05,   #版本
                           ima08  LIKE ima_file.ima08,   #來源碼
                           ima25  LIKE ima_file.ima25    #庫存單位
                    END RECORD
DEFINE   l_azp02_1        LIKE azp_file.azp02      #No.FUN-750112
DEFINE   l_azp02_2        LIKE azp_file.azp02      #No.FUN-750112
DEFINE   l_ima906         LIKE ima_file.ima906     #No.FUN-750112
DEFINE   l_str1           LIKE type_file.chr1000   #No.FUN-750112
DEFINE   l_str2           LIKE type_file.chr1000   #No.FUN-750112
DEFINE   l_imn45          STRING                   #No.FUN-750112
DEFINE   l_imn42          STRING                   #No.FUN-750112
DEFINE   l_imn35          STRING                   #No.FUN-750112
DEFINE   l_imn32          STRING                   #No.FUN-750112
DEFINE   l_factor         LIKE imy_file.imy18      #No.FUN-750112
DEFINE   l_diff           LIKE imy_file.imy16      #No.FUN-750112
DEFINE   l_diffqty        LIKE imy_file.imy16      #No.FUN-750112
DEFINE   l_invqty         LIKE imy_file.imy16      #No.FUN-750112  
DEFINE   l_flag1          LIKE type_file.chr1      #No.FUN-750112
DEFINE   l_flag2          LIKE type_file.chr1      #No.FUN-750112
DEFINE   l_status         LIKE type_file.num5      #No.FUN-750112
 
#--------------------No.FUN-750112--begin----CR(2)----------------#
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
#--------------------No.FUN-750112--end------CR(2)----------------#
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aimr700'         #No.FUN-580014
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND immuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND immgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND immgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',imm02,imm09,",
                 "imn01, imn02, imn03, imn041, imn04, imn05,",
                 "imn06, imn09, imn10, imn11,  imn151,imn27,",
                 "imn30, imn32, imn33, imn35,  imn40, imn42,imn43,imn45,",     #No.FUN-580014
                 "ims01, ims02, ims06,",
                 "imy01, imy07, imy08, imy09, imy16, imy17, imy18,",
                #"ima02, ima05, ima08, ima25",          #FUN-5C0002 mark
                 "ima02, ima021,ima05, ima08, ima25",   #FUN-5C0002
                 "  FROM imm_file,imn_file,",
                 "       OUTER (ims_file, OUTER imy_file), ",
                 "       OUTER ima_file ",
                 " WHERE imm01 =imn01 ",
                 "   AND imn_file.imn01 = ims_file.ims03  AND imn_file.imn02= ims_file.ims04",
                 "   AND ims_file.ims01 = imy_file.imy03  AND ims_file.ims02= imy_file.imy04 ",
                 "   AND imn_file.imn03 = ima_file.ima01",
                 "   AND imm10 = '4' ", #01/08/03mandy資料來源:'4'二階段工廠調撥
                 "   AND immacti = 'Y'",#01/08/03mandy調撥單要有效
                 "   AND ",tm.wc
 
     DISPLAY "l_sql:",l_sql
     IF tm.imn041 IS NOT NULL
     THEN LET l_sql = l_sql clipped," AND imn041 ='",tm.imn041,"'"
     END IF
     IF tm.imn151 IS NOT NULL
     THEN LET l_sql = l_sql clipped," AND imn151 ='",tm.imn151,"'"
     END IF
     IF tm.a = 'N'
     THEN LET l_sql = l_sql clipped," AND imn27 = 'N' "
     END IF
     IF tm.b = 'N'
     THEN LET l_sql = l_sql clipped," AND imn11 > 0 "
     END IF
     IF tm.c = 'N'
     THEN LET l_sql = l_sql clipped," AND ( imn11 != imn23)"
     END IF
     PREPARE aimr700_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE aimr700_curs1 CURSOR FOR aimr700_prepare1
 
#--------------------No.FUN-750112--begin---------mark------#
#     CALL cl_outnam('aimr700') RETURNING l_name
      SELECT sma115 INTO g_sma115 FROM sma_file 
#No.FUN-580014--begin
#     IF g_sma115 ="Y" THEN
#        LET g_zaa[39].zaa06 = "N"
#        LET g_zaa[62].zaa06 = "N"
#     ELSE
#        LET g_zaa[39].zaa06 = "Y"
#        LET g_zaa[62].zaa06 = "Y"
#     CALL cl_prt_pos_len()
#     END IF
#No.FUN-580014--end
#No.FUN-550029-begin
#    LET g_len = 144
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-550029-end
#     START REPORT aimr700_rep TO l_name
#     LET g_pageno = 0
#--------------------No.FUN-750112--end------------mark-----#
     FOREACH aimr700_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#--------------------No.FUN-750112--begin----CR(3)----------------#
#       FOR g_i = 1 TO 3
#          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.imn01
#                                        LET l_orderA[g_i]=g_x[22]  #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.imm02 USING 'yyyymmdd'
#                                        LET l_orderA[g_i]=g_x[23]  #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.imm09
#                                        LET l_orderA[g_i]=g_x[24]  #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.imn03
#                                        LET l_orderA[g_i]=g_x[25]  #TQC-6A0088
#               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.imn04
#                                        LET l_orderA[g_i]=g_x[26]  #TQC-6A0088
#               OTHERWISE LET l_order[g_i] = '-'
#                                        LET l_orderA[g_i]=''    #TQC-6A0088
#          END CASE
#       END FOR
#       LET sr.order1 = l_order[1]
#       LET sr.order2 = l_order[2]
#       LET sr.order3 = l_order[3]
#       OUTPUT TO REPORT aimr700_rep(sr.*)
      SELECT azp02 INTO l_azp02_1 FROM azp_file
       WHERE azp01 = sr.imn041
      SELECT azp02 INTO l_azp02_2 FROM azp_file
       WHERE azp01 = sr.imn151
      SELECT ima906 INTO l_ima906 FROM ima_file
       WHERE ima01=sr.imn03
      LET l_str1 = ""
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.imn45) RETURNING l_imn45
                LET l_str1 = l_imn45 , sr.imn43 CLIPPED
                IF cl_null(sr.imn45) OR sr.imn45 = 0 THEN
                    CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
                    LET l_str1 = l_imn42, sr.imn40 CLIPPED
                ELSE
                   IF NOT cl_null(sr.imn42) AND sr.imn42 > 0 THEN
                      CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
                      LET l_str1 = l_str1 CLIPPED,',',l_imn42,sr.imn40 CLIPPED
                   END IF
                END IF
                CALL cl_remove_zero(sr.imn35) RETURNING l_imn35
                LET l_str2 = l_imn35 , sr.imn33 CLIPPED
                IF cl_null(sr.imn35) OR sr.imn35 = 0 THEN
                    CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
                    LET l_str2 = l_imn32, sr.imn30 CLIPPED
                ELSE
                   IF NOT cl_null(sr.imn32) AND sr.imn32 > 0 THEN
                      CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
                      LET l_str2 = l_str2 CLIPPED,',',l_imn32, sr.imn30 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.imn45) AND sr.imn45 > 0 THEN
                    CALL cl_remove_zero(sr.imn45) RETURNING l_imn45
                    LET l_str1 = l_imn45,sr.imn43 CLIPPED
                END IF
                IF NOT cl_null(sr.imn35) AND sr.imn35 > 0 THEN
                    CALL cl_remove_zero(sr.imn35) RETURNING l_imn35
                    LET l_str2 = l_imn35 , sr.imn33 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
      LET l_flag1 = ' '  LET l_flag2 = ' '
      LET l_diff  = 0    LET l_factor= ' '
      IF sr.imn11 > 0 THEN
         IF sr.ims06 >=0 THEN LET l_flag1 ='/' END IF
         IF sr.imy16 >=0 THEN LET l_flag2 ='/' END IF
           CALL s_umfchk(sr.imn03,sr.imy17,sr.ima25)
                RETURNING l_status,l_factor
           IF l_status  THEN
              #  CALL cl_err('','abm-731',1)
                LET l_factor = 1
           END IF
           LET l_invqty = sr.imy16 * l_factor
           LET l_diff   = (sr.ims06  * sr.imy18) - sr.imy16
           LET l_diffqty= l_diff * l_factor
      END IF
      EXECUTE insert_prep USING 
                  sr.imn01,l_azp02_1,sr.imn02,sr.imn04,sr.imn05,
                  sr.imn03,sr.ima05,sr.ima08,l_str1,
                  sr.imn09,sr.imn10,sr.imn11,sr.imn27,sr.ima25,
                  sr.ims01,sr.ims02,sr.imy01,sr.imy07,sr.imy08,
                  sr.ims06,l_flag1,sr.imn09,sr.imy16,l_flag2,
                  sr.imy17,l_invqty,l_diff,l_azp02_2,sr.imn06,
                  sr.ima02,l_str2,sr.ima021,sr.imm02,sr.imm09
#--------------------No.FUN-750112--end------CR(3)----------------#
     END FOREACH
 
#--------------------No.FUN-750112--begin----CR(4)----------------#
#     FINISH REPORT aimr700_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
    LET g_str = ''
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'imm01,imm02,imm09,imn03,imn04')
            RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",tm.t[2,2],";",
                g_zz05
    IF g_sma115 ="Y" THEN
       CALL cl_prt_cs3('aimr700','aimr700',l_sql,g_str)     
    ELSE
       CALL cl_prt_cs3('aimr700','aimr700_1',l_sql,g_str)     
    END IF
#--------------------No.FUN-750112--end------CR(4)----------------#
END FUNCTION
 
#--------------------No.FUN-750112--begin----------------------#
#REPORT aimr700_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          sr           RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                              order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                              order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
#                              imm02  LIKE imm_file.imm02,   #調撥日期
#                              imm09  LIKE imm_file.imm09,   #確認人
#                              imn01  LIKE imn_file.imn01,   #調撥單號
#                              imn02  LIKE imn_file.imn02,   #項次
#                              imn03  LIKE imn_file.imn03,   #料件
#                              imn041 LIKE imn_file.imn041,  #撥出工廠
#                              imn04  LIKE imn_file.imn04,   #倉庫
#                              imn05  LIKE imn_file.imn05,   #儲位
#                              imn06  LIKE imn_file.imn06,   #批號
#                              imn09  LIKE imn_file.imn09,   #單位
#                              imn10  LIKE imn_file.imn10,   #預撥出量
#                              imn11  LIKE imn_file.imn11,   #實撥出量
#                              imn151 LIKE imn_file.imn151,  #撥入工廠
#                              imn27  LIKE imn_file.imn27,   #結案否
#                              imn30  LIKE imn_file.imn30,   #No.FUN-580014
#                              imn32  LIKE imn_file.imn32,   #No.FUN-580014
#                              imn33  LIKE imn_file.imn33,   #No.FUN-580014
#                              imn35  LIKE imn_file.imn35,   #No.FUN-580014
#                              imn40  LIKE imn_file.imn40,   #No.FUN-580014
#                              imn42  LIKE imn_file.imn42,   #No.FUN-580014
#                              imn43  LIKE imn_file.imn43,   #No.FUN-580014
#                              imn45  LIKE imn_file.imn45,   #No.FUN-580014
#                              ims01  LIKE ims_file.ims01,   #撥出單號
#                              ims02  LIKE ims_file.ims02,   #批次
#                              ims06  LIKE ims_file.ims06,   #撥出數量
#                              imy01  LIKE imy_file.imy01,   #撥入單號
#                              imy07  LIKE imy_file.imy07,   #倉庫
#                              imy08  LIKE imy_file.imy08,   #儲位
#                              imy09  LIKE imy_file.imy09,   #批號
#                              imy16  LIKE imy_file.imy16,   #撥出數量
#                              imy17  LIKE imy_file.imy17,   #撥出單位
#                              imy18  LIKE imy_file.imy18,   #FACTOR
#                              ima02  LIKE ima_file.ima02,   #品名
#                              ima021 LIKE ima_file.ima021,  #規格   #FUN-5C0002
#                              ima05  LIKE ima_file.ima05,   #版本
#                              ima08  LIKE ima_file.ima08,   #來源碼
#                              ima25  LIKE ima_file.ima25    #庫存單位
#                       END RECORD,
#      l_azp02_1        LIKE azp_file.azp02,
#      l_azp02_2        LIKE azp_file.azp02,
#      l_factor         LIKE imy_file.imy18,
#      l_diff,l_diffqty LIKE imy_file.imy16,
#      l_invqty         LIKE imy_file.imy16,
#      l_flag1,l_flag2  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#      l_status         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#      l_chr            LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
##No.FUN-580014--begin
#DEFINE   l_imn45          STRING
#DEFINE   l_imn42          STRING
#DEFINE   l_imn35          STRING
#DEFINE   l_imn32          STRING
#DEFINE   l_str1           STRING
#DEFINE   l_str2           STRING
#DEFINE   l_ima906         LIKE ima_file.ima906
#DEFINE   g_cnt            LIKE type_file.num5    #No.FUN-690026 SMALLINT
##No.FUN-580014--end
#OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.imn01,sr.imn02
#  FORMAT
#   PAGE HEADER
##No.FUN-580014--begin
#      IF sr.imn11 > 0 THEN
#         LET g_zaa[45].zaa06 = 'N'
#         LET g_zaa[46].zaa06 = 'N'
#         LET g_zaa[47].zaa06 = 'N'
#         LET g_zaa[48].zaa06 = 'N'
#         LET g_zaa[49].zaa06 = 'N'
#         LET g_zaa[50].zaa06 = 'N'
#         LET g_zaa[51].zaa06 = 'N'
#         LET g_zaa[52].zaa06 = 'N'
#         LET g_zaa[53].zaa06 = 'N'
#         LET g_zaa[68].zaa06 = 'N'
#         LET g_zaa[69].zaa06 = 'N'
#         LET g_zaa[70].zaa06 = 'N'
#         LET g_zaa[71].zaa06 = 'N'
#         LET g_zaa[72].zaa06 = 'N'
#         LET g_zaa[73].zaa06 = 'N'
#         LET g_zaa[74].zaa06 = 'N'
#        #LET g_zaa[75].zaa06 = 'N'   #FUN-5C0002 mark
#        #LET g_zaa[76].zaa06 = 'N'   #FUN-5C0002 mark
#      ELSE
#         LET g_zaa[45].zaa06 = 'Y'
#         LET g_zaa[46].zaa06 = 'Y'
#         LET g_zaa[47].zaa06 = 'Y'
#         LET g_zaa[48].zaa06 = 'Y'
#         LET g_zaa[49].zaa06 = 'Y'
#         LET g_zaa[50].zaa06 = 'Y'
#         LET g_zaa[51].zaa06 = 'Y'
#         LET g_zaa[52].zaa06 = 'Y'
#         LET g_zaa[53].zaa06 = 'Y'
#         LET g_zaa[68].zaa06 = 'Y'
#         LET g_zaa[69].zaa06 = 'Y'
#         LET g_zaa[70].zaa06 = 'Y'
#         LET g_zaa[71].zaa06 = 'Y'
#         LET g_zaa[72].zaa06 = 'Y'
#         LET g_zaa[73].zaa06 = 'Y'
#         LET g_zaa[74].zaa06 = 'Y'
#        #LET g_zaa[75].zaa06 = 'Y'   #FUN-5C0002 mark
#        #LET g_zaa[76].zaa06 = 'Y'   #FUN-5C0002 mark
#      END IF
#      CALL cl_prt_pos_len()
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_x[9] CLIPPED,l_orderA[1] CLIPPED,                      #TQC-6A0088                                                    
#                       '-',l_orderA[2] CLIPPED
#      PRINT g_dash[1,g_len]
##No.FUN-550029-begin
#      PRINTX name = H1  g_x[31], g_x[32], g_x[33], g_x[34],
#                        g_x[35], g_x[36], g_x[37], g_x[38],
#                        g_x[39], g_x[40], g_x[41], g_x[42],
#                        g_x[43], g_x[44], g_x[45], g_x[46],
#                        g_x[47], g_x[48], g_x[49], g_x[50],
#                        g_x[51], g_x[52], g_x[53]
#      PRINTX name = H2  g_x[54], g_x[55], g_x[56], g_x[57],
#                        g_x[58], g_x[59], g_x[60], g_x[61],
#                        g_x[62], g_x[63], g_x[64], g_x[65],
#                        g_x[66], g_x[67], g_x[68], g_x[69],
#                        g_x[70], g_x[71], g_x[72], g_x[73],
#                       #g_x[74], g_x[75], g_x[76]   #FUN-5C0002 mark
#                        g_x[74]                     #FUN-5C0002
#      PRINT g_dash1
##     PRINT COLUMN  2, g_x[11] clipped,
##           COLUMN 46, g_x[12] clipped,
##           COLUMN 87, g_x[13] clipped,
##           COLUMN 127,g_x[14] clipped
##     PRINT COLUMN 28, g_x[15] clipped,
##           COLUMN 71, g_x[16] clipped,
##           COLUMN 127,g_x[21] clipped
##     PRINT '---------------- ---- -------------------- ---------- ',
##           '---------- -------------------- -- -- ---- ',
##           '------------- -------------  ---- ----'
##No.FUN-580014--end
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.imn01     #調撥單號
##No.FUN-580014--begin
#      PRINTX name = D1
#             COLUMN g_c[31], sr.imn01 CLIPPED;
##No.FUN-580014--end
#
#   BEFORE GROUP OF sr.imn02     #調撥項次
#      LET g_cnt = 1
#      SELECT azp02 INTO l_azp02_1 FROM azp_file
#       WHERE azp01 = sr.imn041
#      SELECT azp02 INTO l_azp02_2 FROM azp_file
#       WHERE azp01 = sr.imn151
#
##No.FUN-580014--begin
#
#      SELECT ima906 INTO l_ima906 FROM ima_file
#       WHERE ima01=sr.imn03
#      LET l_str1 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.imn45) RETURNING l_imn45
#                LET l_str1 = l_imn45 , sr.imn43 CLIPPED
#                IF cl_null(sr.imn45) OR sr.imn45 = 0 THEN
#                    CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
#                    LET l_str1 = l_imn42, sr.imn40 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.imn42) AND sr.imn42 > 0 THEN
#                      CALL cl_remove_zero(sr.imn42) RETURNING l_imn42
#                      LET l_str1 = l_str1 CLIPPED,',',l_imn42, sr.imn40 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.imn45) AND sr.imn45 > 0 THEN
#                    CALL cl_remove_zero(sr.imn45) RETURNING l_imn45
#                    LET l_str1 = l_imn45 , sr.imn43 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      PRINTX name = D1
#             COLUMN g_c[32],sr.imn02 using '###&',
#             COLUMN g_c[33],l_azp02_1 CLIPPED,
#             COLUMN g_c[34],sr.imn04 CLIPPED,
#             COLUMN g_c[35],sr.imn05 CLIPPED,
#             COLUMN g_c[36],sr.imn03 CLIPPED, #FUN-5B0014 [1,20] CLIPPED,
#             COLUMN g_c[37],sr.ima05 CLIPPED,
#             COLUMN g_c[38],sr.ima08 CLIPPED,
#             COLUMN g_c[39],l_str1 CLIPPED,
#             COLUMN g_c[40],sr.imn09 CLIPPED,
#             COLUMN g_c[41],sr.imn10 using '----------&.&&&',
#             COLUMN g_c[42],sr.imn11 using '----------&.&&&',
#             COLUMN g_c[43],sr.imn27 CLIPPED,
#             COLUMN g_c[44],sr.ima25;
#
##     IF sr.imn11 > 0 THEN
##        PRINT COLUMN 18,g_x[17] clipped,COLUMN 69,g_x[18] clipped,
##              COLUMN 107,g_x[19] clipped
##        PRINT COLUMN 69,g_x[20] clipped
##        PRINT COLUMN 17,
##              '---------------- ---- ---------------- ---------- ',
##              '----------  ------------------ ------------------ ',
##              '------------- -------------'
##     END IF
#
#   ON EVERY ROW
#      LET l_flag1 = ' '  LET l_flag2 = ' '
#      LET l_diff  = 0    LET l_factor= ' '
#      IF sr.imn11 > 0 THEN
#         IF sr.ims06 >=0 THEN LET l_flag1 ='/' END IF
#         IF sr.imy16 >=0 THEN LET l_flag2 ='/' END IF
#          #入庫數量(以料件庫存為單位)
#           CALL s_umfchk(sr.imn03,sr.imy17,sr.ima25)
#                RETURNING l_status,l_factor
#           IF l_status  THEN
#              #  CALL cl_err('','abm-731',1)
#                LET l_factor = 1
#           END IF
#           LET l_invqty = sr.imy16 * l_factor
#
#          #以撥入為單位的差量
#           LET l_diff   = (sr.ims06  * sr.imy18) - sr.imy16
#           LET l_diffqty= l_diff * l_factor
#
#           PRINTX name = D1
#                  COLUMN g_c[45],sr.ims01 CLIPPED,
#                  COLUMN g_c[46],sr.ims02 using'###&',
#                  COLUMN g_c[47],sr.imy01 CLIPPED,
#                  COLUMN g_c[48],sr.imy07 CLIPPED,
#                  COLUMN g_c[49],sr.imy08 CLIPPED,
#                  COLUMN g_c[50],sr.ims06 using '----------&.&&&',l_flag1,sr.imn09,
#                  COLUMN g_c[51],sr.imy16 using '----------&.&&&',l_flag2,sr.imy17,
#                  COLUMN g_c[52],l_invqty using '----------&.&&&',
#                  COLUMN g_c[53],l_diff   using '----------&.&&&'
#      END IF
#   IF g_cnt = 1 THEN
#      LET g_cnt = g_cnt + 1
#      SELECT ima906 INTO l_ima906 FROM ima_file
#                         WHERE ima01=sr.imn03
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         CASE l_ima906
#            WHEN "2"
#                CALL cl_remove_zero(sr.imn35) RETURNING l_imn35
#                LET l_str2 = l_imn35 , sr.imn33 CLIPPED
#                IF cl_null(sr.imn35) OR sr.imn35 = 0 THEN
#                    CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
#                    LET l_str2 = l_imn32, sr.imn30 CLIPPED
#                ELSE
#                   IF NOT cl_null(sr.imn32) AND sr.imn32 > 0 THEN
#                      CALL cl_remove_zero(sr.imn32) RETURNING l_imn32
#                      LET l_str2 = l_str2 CLIPPED,',',l_imn32, sr.imn30 CLIPPED
#                   END IF
#                END IF
#            WHEN "3"
#                IF NOT cl_null(sr.imn35) AND sr.imn35 > 0 THEN
#                    CALL cl_remove_zero(sr.imn35) RETURNING l_imn35
#                    LET l_str2 = l_imn35 , sr.imn33 CLIPPED
#                END IF
#         END CASE
#      ELSE
#      END IF
#      PRINTX name = D2
#             COLUMN g_c[56],l_azp02_2 CLIPPED,
#             COLUMN g_c[57],sr.imn06 CLIPPED,
#             COLUMN g_c[59],sr.ima02,
#             COLUMN g_c[62],l_str2 CLIPPED
#            ,COLUMN g_c[63],sr.ima021   #FUN-5C0002
#   END IF
##No.FUN-580014--end
##No.FUN-550029-end
#
#   AFTER GROUP OF sr.imn02
#      PRINT ' '
#
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'imm01,imm02,imm09,imn03,imn04')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
##TQC-630166
##             IF tm.wc[001,120] > ' ' THEN            # for 132
##         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
##             IF tm.wc[121,240] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
##             IF tm.wc[241,300] > ' ' THEN
##         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#Patch....NO.TQC-610036 <> #
#--------------------No.FUN-750112--end----------------------#
