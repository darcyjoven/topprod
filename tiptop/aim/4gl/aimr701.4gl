# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aimr701.4gl
# Descriptions...: 工廠間調撥在途量統計表
# Input parameter:
# Return code....:
# Date & Author..:  93/07/15 By Apple
# Modify.........: No.FUN-510017 05/02/01 By Mandy 報表轉XML
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-580005 05/08/03 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: No.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-720046 07/03/15 By TSD.Sideny 報表改寫由Crystal Report
# Modify.........: No.FUN-710080 07/04/03 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B10125 11/01/18 By sabrina 調整aimr701_prepare1的sql語法
# Modify.........: No:MOD-B80288 12/01/16 By Vampire imm12 改為 imn12
# Modify.........: No:TQC-DB0031 13/11/18 By wangrr "調撥單號""撥出單號""撥出倉庫""庫位"欄位增加開窗
# Modify.........: No:TQC-DC0002 13/12/02 By wangrr 修改"撥出倉庫""庫位"開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5   #No.FUN-690026 SMALLINT
END GLOBALS
#No.FUN-580005 --end--
DEFINE tm  RECORD
           wc      STRING,                 # Where Condition  #TQC-630166
           imn041  LIKE imn_file.imn041,
           s       LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           t       LIKE type_file.chr3,    #No.FUN-690026 VARCHAR(03)
           more    LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD
 
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
#No.FUN-580005 --start--
DEFINE g_sma115    LIKE sma_file.sma115
DEFINE g_sma116    LIKE sma_file.sma116
#No.FUN-580005 --end--
DEFINE l_table    STRING #NO.MOD-720046 07/03/15 By TSD.Sideny
DEFINE g_sql      STRING #NO.MOD-720046 07/03/15 By TSD.Sideny
DEFINE g_str      STRING #NO.MOD-720046 07/03/15 By TSD.Sideny
 
 
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
 
  #NO.MOD-720046 07/03/15 By TSD.Sideny --start--
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "imn01.imn_file.imn01,",
               "azp02_1.azp_file.azp02,",
               "azp02_2.azp_file.azp02,",
               "imn02.imn_file.imn02,",
               "imn03.imn_file.imn03,",
               "imn041.imn_file.imn041,",
               "imn151.imn_file.imn151,",
               "imn04.imn_file.imn04,",
               "imn05.imn_file.imn05,",
               "imn06.imn_file.imn06,",
               "imn09.imn_file.imn09,",
               "ims01.ims_file.ims01,",
               "ims02.ims_file.ims02,",
               "ims04.ims_file.ims04,",
               "ims06.ims_file.ims06,",
               "imn40.imn_file.imn40,",
               "imn43.imn_file.imn43,",
               "ims14.ims_file.ims14,",
               "ims15.ims_file.ims15,",
               "ims07.type_file.chr20,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ima05.ima_file.ima05,",
               "ima08.ima_file.ima08,",
               "l_str2.type_file.chr1000,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05" 
 
   LET l_table = cl_prt_temptable('aimr701',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
  #NO.MOD-720046 07/03/15 By TSD.Sideny ---end---
 
   LET g_pdate   = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom  = ARG_VAL(2)
   LET g_rlang   = ARG_VAL(3)
   LET g_bgjob   = ARG_VAL(4)
   LET g_prtway  = ARG_VAL(5)
   LET g_copies  = ARG_VAL(6)
   LET tm.wc     = ARG_VAL(7)
   LET tm.imn041 = ARG_VAL(8)
   LET tm.s      = ARG_VAL(9)
   LET tm.t      = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aimr701_tm(0,0)        # Input print condition
      ELSE CALL aimr701()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr701_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
DEFINE li_result      LIKE type_file.num5     #No.FUN-940102
 
   LET p_row = 5 LET p_col = 13
 
   OPEN WINDOW aimr701_w AT p_row,p_col WITH FORM "aim/42f/aimr701"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
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
   CONSTRUCT BY NAME tm.wc ON imm01,ims01,imn03,imn04,imn05
 
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
         #TQC-DB0031--add--str--
         IF INFIELD(imm01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_imm102"
            LET g_qryparam.state = "c"
            LET g_qryparam.where=" imm10='4'"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imm01
            NEXT FIELD imm01
         END IF
         IF INFIELD(ims01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ims01"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ims01
            NEXT FIELD ims01
         END IF
         IF INFIELD(imn04) THEN
            CALL cl_init_qry_var()
           #LET g_qryparam.form = "q_imn3" #TQC-DC0002 mark
            LET g_qryparam.form = "q_imd"  #TQC-DC0002
            LET g_qryparam.state = "c"
            LET g_qryparam.arg1= 'SW'      #TQC-DC0002
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imn04
            NEXT FIELD imn04
         END IF
         IF INFIELD(imn05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_imn05"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO imn05
            NEXT FIELD imn05
         END IF
         #TQC-DB0031--add--end
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr701_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
 
   INPUT BY NAME tm.imn041,tm2.s1,tm2.s2,tm2.t1,tm2.t2,tm.more
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
               THEN #CALL cl_err(tm.imn041,'mfg9142',0) #No.FUN-660156 
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
#                  CALL q_azr(8,45,tm.imn041) RETURNING tm.imn041
#                  CALL FGL_DIALOG_SETBUFFER( tm.imn041 )
                   CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_azr"    #No.FUN-940102
                   LET g_qryparam.form ="q_zxy"    #No.FUN-940102
                   LET g_qryparam.arg1 = g_user    #No.FUN-940102
                   LET g_qryparam.default1 = tm.imn041
                   CALL cl_create_qry() RETURNING tm.imn041
#                   CALL FGL_DIALOG_SETBUFFER( tm.imn041 )
                   DISPLAY BY NAME tm.imn041
                   NEXT FIELD imn041
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr701_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr701'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr701','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr701',g_time,l_cmd)
      END IF
      CLOSE WINDOW aimr701_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr701()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr701_w
END FUNCTION
 
FUNCTION aimr701()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          l_sql     STRING,                       # RDSQL STATEMENT     #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-690026 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima01,   #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
          sr        RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                           imn01  LIKE imn_file.imn01,  #調撥單號
                           imn02  LIKE imn_file.imn02,  #項次
                           imn03  LIKE imn_file.imn03,  #料件
                           imn041 LIKE imn_file.imn041, #撥出工廠
                           imn151 LIKE imn_file.imn151, #撥入工廠
                           imn04  LIKE imn_file.imn04,  #倉庫
                           imn05  LIKE imn_file.imn05,  #儲位
                           imn06  LIKE imn_file.imn06,  #批號
                           imn09  LIKE imn_file.imn09,  #單位
                           ims01  LIKE ims_file.ims01,  #撥出單號
                           ims02  LIKE ims_file.ims02,  #批次
                           ims04  LIKE ims_file.ims04,  #項次
                           ims06  LIKE ims_file.ims06,  #撥出單號
                           #No.FUN-580005 --start--
                           imn40  LIKE imn_file.imn40,  #撥入單位一
                           imn43  LIKE imn_file.imn43,  #撥入單位二
                           ims14  LIKE ims_file.ims14,  #實撥單位一數量
                           ims15  LIKE ims_file.ims15,  #實撥單位二數量
                           ims07  LIKE type_file.chr20, #No.FUN-690026 VARCHAR(20)
                           #No.FUN-580005 --end--
                           ima02  LIKE ima_file.ima02,  #品名規格
                           ima021 LIKE ima_file.ima021, #FUN-510017
                           ima05  LIKE ima_file.ima05,  #版本
                           ima08  LIKE ima_file.ima08   #來源碼
                        END RECORD
     DEFINE i,l_i,l_cnt LIKE type_file.num5      #No.FUN-580005  #No.FUN-690026 SMALLINT
     DEFINE l_zaa02     LIKE zaa_file.zaa02      #No.FUN-580005
    #NO.MOD-720046 07/03/15 By TSD.Sideny --start--
   DEFINE l_azp02_1    LIKE azp_file.azp02,
          l_azp02_2    LIKE azp_file.azp02
   DEFINE l_str2       LIKE type_file.chr1000,
          l_ims14      STRING,
          l_ims15      STRING
   DEFINE l_ima906     LIKE ima_file.ima906
 
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #NO.MOD-720046 07/03/15 By TSD.Sideny ---end---
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
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
 
     LET l_sql = "SELECT '','','',",
                 "imn01, imn02, imn03, imn041,imn151,",
                 "imn04, imn05, imn06, imn09,",
                 "ims01, ims02, ims04, (ims06-ims07),imn40,imn43,ims14,ims15,ims07,",   #No.FUN-580005
                 "ima02,ima021, ima05, ima08", #FUN-510017 add ima021
                 "  FROM imm_file,imn_file,ims_file, ",
                 "       OUTER ima_file ",
                 " WHERE imm01 =imn01 ",
                 "   AND imn01 = ims03  AND imn02= ims04",
                 "   AND imn_file.imn03 = ima_file.ima01",
                #"   AND imm10 = '3' ", #01/08/03mandy資料來源:'3'一階段工廠調撥       #MOD-B10125 mark  
                #"   AND imm04 = 'Y'",  #01/08/03mandy調撥單要有效                     #MOD-B10125 mark   
                 "   AND imm10 = '4' ", #MOD-B10125 add
                #"   AND imm12 = 'Y'",  #MOD-B10125 add   #MOD-B80288 mark
                 "   AND imn12 = 'Y'",  #MOD-B80288 add
                 "   AND imn27 !='Y' ",
                 "   AND (ims06-ims07) > 0 ",
                 "   AND ",tm.wc
 
     IF tm.imn041 IS NOT NULL THEN
        LET l_sql = l_sql clipped," AND imn041 ='",tm.imn041,"'"
     END IF
 
DISPLAY l_sql
     PREPARE aimr701_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE aimr701_curs1 CURSOR FOR aimr701_prepare1
 
    #CALL cl_outnam('aimr701') RETURNING l_name
    #NO.MOD-720046 07/03/15 By TSD.Sideny
     #No.FUN-580005 --start--
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
     IF g_sma115 = "Y" THEN
        LET g_zaa[48].zaa06 = "N"
     ELSE
        LET g_zaa[48].zaa06 = "Y"
     END IF
     CALL cl_prt_pos_len()
     #No.FUN-580005 --end--
 
    #START REPORT aimr701_rep TO l_name #NO.MOD-720046 07/03/15 By TSD.Sideny
 
     LET g_pageno = 0
     FOREACH aimr701_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       FOR g_i = 1 TO 3
          CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.imn01
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.ims01
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.imn03
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.imn04
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.imn05
               OTHERWISE LET l_order[g_i] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]
 
      #NO.MOD-720046 07/03/15 By TSD.Sideny --start--
      #OUTPUT TO REPORT aimr701_rep(sr.*)
 
       SELECT azp02 INTO l_azp02_1 FROM azp_file
        WHERE azp01 = sr.imn151
       IF l_azp02_1 IS NULL THEN
          LET l_azp02_1 = sr.imn151
       END IF
 
       SELECT azp02 INTO l_azp02_2 FROM azp_file
        WHERE azp01 = sr.imn041
       IF l_azp02_1 IS NULL THEN
          LET l_azp02_1 = sr.imn041
       END IF
       IF sr.ims07 = 0 THEN LET sr.ims07 = NULL END IF
       IF NOT cl_null(sr.ims07) AND sr.ims07 <> 0 THEN
          LET sr.ims07 = cl_remove_zero(sr.ims07) CLIPPED,sr.imn09 CLIPPED
       END IF
       SELECT ima906 INTO l_ima906 FROM ima_file
        WHERE ima01 = sr.imn03
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN
          IF NOT cl_null(sr.ims15) AND sr.ims15 <> 0 THEN
             CALL cl_remove_zero(sr.ims15) RETURNING l_ims15
             LET l_str2 = l_ims15, sr.imn43 CLIPPED
          END IF
          IF l_ima906 = "2" THEN
             IF cl_null(sr.ims15) OR sr.ims15 = 0 THEN
                CALL cl_remove_zero(sr.ims14) RETURNING l_ims14
                LET l_str2 = l_ims14, sr.imn40 CLIPPED
             ELSE
                IF NOT cl_null(sr.ims14) AND sr.ims14 <> 0 THEN
                   CALL cl_remove_zero(sr.ims14) RETURNING l_ims14
                   LET l_str2 = l_str2 CLIPPED,',',l_ims14, sr.imn43 CLIPPED
                END IF
             END IF
          END IF
       END IF
 
      #單價、金額、小計小數位數
       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
        FROM azi_file
        WHERE azi01=g_aza.aza17
 
       EXECUTE insert_prep USING sr.imn01,l_azp02_1,l_azp02_2,sr.imn02,sr.imn03,
                                 sr.imn041,sr.imn151,sr.imn04,sr.imn05,sr.imn06,
                                 sr.imn09,sr.ims01,sr.ims02,sr.ims04,sr.ims06,
                                 sr.imn40,sr.imn43,sr.ims14,sr.ims15,sr.ims07,
                                 sr.ima02,sr.ima021,sr.ima05,sr.ima08,l_str2,
                                 t_azi03,t_azi04,t_azi05
      #NO.MOD-720046 07/03/15 By TSD.Sideny ---end---
 
     END FOREACH
 
    #NO.MOD-720046 07/03/15 By TSD.Sideny --start--
    #FINISH REPORT aimr701_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'imm01,ims01,imn03,imn04,imn05')
             RETURNING tm.wc
        LET g_str = tm.wc
     ELSE
        LET g_str = " "
     END IF
     LET g_str = g_str,";",tm2.s1,";",tm2.s2,";",tm2.t1,";",tm2.t2,";",g_sma115
 
     IF g_sma115 = "Y" THEN
        CALL cl_prt_cs3('aimr701','aimr701_1',l_sql,g_str)   #FUN-710080 modify
     ELSE
        CALL cl_prt_cs3('aimr701','aimr701_2',l_sql,g_str)   #FUN-710080 modify
     END IF
    #NO.MOD-720046 07/03/15 By TSD.Sideny ---end---
 
END FUNCTION
 
#NO.MOD-720046 07/03/15 By TSD.Sideny --start--
{
REPORT aimr701_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr           RECORD order1 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                              order2 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                              order3 LIKE ima_file.ima01, #FUN-5B0105 20->40  #No.FUN-690026 VARCHAR(40)
                              imn01  LIKE imn_file.imn01,  #調撥單號
                              imn02  LIKE imn_file.imn02,  #項次
                              imn03  LIKE imn_file.imn03,  #料件
                              imn041 LIKE imn_file.imn041, #撥出工廠
                              imn151 LIKE imn_file.imn151, #撥入工廠
                              imn04  LIKE imn_file.imn04,  #倉庫
                              imn05  LIKE imn_file.imn05,  #儲位
                              imn06  LIKE imn_file.imn06,  #批號
                              imn09  LIKE imn_file.imn09,  #單位
                              ims01  LIKE ims_file.ims01,  #撥出單號
                              ims02  LIKE ims_file.ims02,  #批次
                              ims04  LIKE ims_file.ims04,  #項次
                              ims06  LIKE ims_file.ims06,  #撥出單號
                              #No.FUN-580005 --start--
                              imn40  LIKE imn_file.imn40,  #撥入單位一
                              imn43  LIKE imn_file.imn43,  #撥入單位二
                              ims14  LIKE ims_file.ims14,  #實撥單位一數量
                              ims15  LIKE ims_file.ims15,  #實撥單位二數量
                              ims07  LIKE type_file.chr20, #No.FUN-690026 VARCHAR(20)
                              #No.FUN-580005 --end--
                              ima02  LIKE ima_file.ima02,  #品名規格
                              ima021 LIKE ima_file.ima021, #FUN-510017
                              ima05  LIKE ima_file.ima05,  #版本
                              ima08  LIKE ima_file.ima08   #來源碼
                       END RECORD,
          l_azp02_1    LIKE azp_file.azp02,
          l_azp02_2    LIKE azp_file.azp02,
          l_chr        LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_str2       LIKE type_file.chr1000,#No.FUN-580005 #No.FUN-690026 VARCHAR(100)
          l_ims14      STRING,    #No.FUN-580005
          l_ims15      STRING     #No.FUN-580005
   DEFINE l_ima906     LIKE ima_file.ima906           #FUN-580005
 
OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3,sr.imn151
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[48]  #No.FUN-580005
      PRINTX name=H2 g_x[44],g_x[45],g_x[46],g_x[47]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' AND (PAGENO > 1 OR LINENO > 10)
         THEN SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.imn151    #撥入工廠別
      SELECT azp02 INTO l_azp02_1 FROM azp_file
         	           	   WHERE azp01 = sr.imn151
      IF l_azp02_1 IS NULL THEN
         LET l_azp02_1 = sr.imn151
      END IF
      PRINTX name=D1 COLUMN g_c[31],l_azp02_1;
 
   ON EVERY ROW
      SELECT azp02 INTO l_azp02_2 FROM azp_file
         	           	   WHERE azp01 = sr.imn041
      IF l_azp02_1 IS NULL THEN
         LET l_azp02_1 = sr.imn041
      END IF
      IF sr.ims07 = 0 THEN LET sr.ims07 = NULL END IF
      IF NOT cl_null(sr.ims07) AND sr.ims07 <> 0 THEN
         LET sr.ims07 = cl_remove_zero(sr.ims07) CLIPPED,sr.imn09 CLIPPED
      END IF
      SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01 = sr.imn03
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         IF NOT cl_null(sr.ims15) AND sr.ims15 <> 0 THEN
            CALL cl_remove_zero(sr.ims15) RETURNING l_ims15
            LET l_str2 = l_ims15, sr.imn43 CLIPPED
         END IF
         IF l_ima906 = "2" THEN
            IF cl_null(sr.ims15) OR sr.ims15 = 0 THEN
               CALL cl_remove_zero(sr.ims14) RETURNING l_ims14
               LET l_str2 = l_ims14, sr.imn40 CLIPPED
            ELSE
               IF NOT cl_null(sr.ims14) AND sr.ims14 <> 0 THEN
                  CALL cl_remove_zero(sr.ims14) RETURNING l_ims14
                  LET l_str2 = l_str2 CLIPPED,',',l_ims14, sr.imn43 CLIPPED
               END IF
            END IF
         END IF
      END IF
      PRINTX name=D1 COLUMN g_c[32],sr.imn01,
                     COLUMN g_c[33],l_azp02_2,
                     COLUMN g_c[34],sr.ims02 using '#######&',
                     COLUMN g_c[35],sr.ims04 using '#######&',
                     COLUMN g_c[36],sr.imn04,
                     COLUMN g_c[37],sr.imn05,
                     COLUMN g_c[38],sr.imn03 CLIPPED, #FUN-5B0014 [1,20] CLIPPED,
                     COLUMN g_c[39],sr.ima02,
                     COLUMN g_c[40],sr.ima05,
                     COLUMN g_c[41],sr.ima08,
                     COLUMN g_c[42],cl_numfor(sr.ims06,42,3),
                     COLUMN g_c[43],sr.imn09,
                     COLUMN g_c[48],l_str2 CLIPPED
      PRINTX name=D2 COLUMN g_c[44],' ',
                     COLUMN g_c[45],sr.ims01,
                     COLUMN g_c[46],sr.imn06,
                     COLUMN g_c[47],sr.ima021
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'imm01,ims01,imn03,imn04,imn05')
              RETURNING tm.wc
         PRINT g_dash[1,g_len]
#TQC-630166
#             IF tm.wc[001,120] > ' ' THEN            # for 132
#         PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             IF tm.wc[121,240] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             IF tm.wc[241,300] > ' ' THEN
#         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
         CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#NO.MOD-720046 07/03/15 By TSD.Sideny ---end---
