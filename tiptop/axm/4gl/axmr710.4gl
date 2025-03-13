# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr710.4gl
# Descriptions...: 銷退清單
# Date & Author..: 95/01/26 By Danny
# Modify.........: 95/11/10 By LYNN
#                : 將出貨通知單範圍(oga011)拿掉,1,3項出貨改退貨
#                  CONSTRUCT oga01,oga02 改為 oha01,oha02
# Modify.........: No:6887 03/07/18 By Wiky ohb51放大
# Modify.........: No:8272 03/09/22 By Carol oga_file應用OUTER, 因為有些銷退沒有對應到出貨單
# Modify.........: No.FUN-4B0045 04/11/15 By Smapmin 帳款客戶,送貨客戶,人員編號,部門編號開窗
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-580004 05/08/09 By wujie 雙單位報表結構修改
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710058 07/02/08 By jamie 放寬項次位數
# Modify.........: No.TQC-790072 07/09/11 By lumxa 打印報表中，表頭在制表日期下方；最后一頁無橫向滾動條
# Modify.........: No.FUN-850018 08/05/05 By ChenMoyan 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-8B0025 08/12/23 By xiaofeizhu 新增多營運中心INPUT
# Modify.........: No.MOD-8C0262 08/12/26 By Smapmin 原出貨發票號碼應抓取ohb30,而不是oga10
# Modify.........: No.MOD-910145 09/01/13 By Smapmin 理由碼應抓取azf03
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.TQC-940180 09/04/29 BY sabrina 報表無法使用背景作業，少寫〝g_rep_name〞這個參數
# Modify.........: No.MOD-990004 09/09/01 By Dido 過濾借貨還量的資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10056 10/01/12 by dxfwo  跨DB處理
# Modify.........: No:FUN-9C0071 10/01/15 By huangrh 精簡程式
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No.TQC-A50044 10/05/17 By Carrier TQC-940180/TQC-950090 追单
# Modify.........: No.FUN-A70084 10/07/19 By lutingting GP5.2報表修改 INPUT營運中心改為QBE 
# Modify.........: No:CHI-B20002 11/02/08 By Smapmin 報表多呈現單價與金額
# Modify.........: No:TQC-B60202 11/06/21 By lixiang 將接受畫面上的條件的變量由chr1000->STRING

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
END GLOBALS
DEFINE tm  RECORD
         # wc      LIKE type_file.chr1000,     # No.FUN-680137 STRING  # No:TQC-B60202 mark
           wc      STRING,                     # No:TQC-B60202  
          #FUN-A70084--mark--str--
          #b       LIKE type_file.chr1,        # No.FUN-8B0025 VARCHAR(1)
          #p1      LIKE azp_file.azp01,        # No.FUN-8B0025 VARCHAR(10)
          #p2      LIKE azp_file.azp01,        # No.FUN-8B0025 VARCHAR(10)
          #p3      LIKE azp_file.azp01,        # No.FUN-8B0025 VARCHAR(10)
          #p4      LIKE azp_file.azp01,        # No.FUN-8B0025 VARCHAR(10) 
          #p5      LIKE azp_file.azp01,        # No.FUN-8B0025 VARCHAR(10)
          #p6      LIKE azp_file.azp01,        # No.FUN-8B0025 VARCHAR(10)
          #p7      LIKE azp_file.azp01,        # No.FUN-8B0025 VARCHAR(10)
          #p8      LIKE azp_file.azp01,        # No.FUN-8B0025 VARCHAR(10)
          #FUN-A70084--mark--end
           type    LIKE type_file.chr1,        # No.FUN-8B0025 VARCHAR(1)            
           s       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)
           t       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)
           u       LIKE type_file.chr3,        # No.FUN-680137 VARCHAR(03)
           more    LIKE type_file.chr1         # No.FUN-680137 VARCHAR(01)
           END RECORD,
         g_orderA ARRAY[3] OF LIKE faj_file.faj02      # No.FUN-680137 VARCHAR(10)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_head1         LIKE type_file.chr1000     # No.FUN-680137 STRING
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE i                LIKE type_file.num10       # No.FUN-680137 INTEGER
#DEFINE g_sql            LIKE type_file.chr1000     #No.FUN-850018    #No.TQC-B60202 mark
DEFINE g_sql            STRING                     #No.TQC-B60202
#DEFINE g_str            LIKE type_file.chr1000     #No.FUN-850018    #No.TQC-B60202 mark
DEFINE g_str            STRING                      #No.TQC-B60202
DEFINE l_table          STRING    #No.FUN-850018   #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8B0025 ARRAY[10] OF VARCHAR(20)   #FUN-A70084
DEFINE m_plant      LIKE azw_file.azw01                 #FUN-A70084 
#DEFINE g_wc         LIKE type_file.chr1000              #FUN-A70084   #No.TQC-B60202 mark
DEFINE g_wc          STRING                        #No.TQC-B60202 

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
   LET g_sql="oha01.oha_file.oha01,",
             "oha02.oha_file.oha02,",
             "oha03.oha_file.oha03,",
             "oha032.oha_file.oha032,",
             "oha04.oha_file.oha04,",
             "occ02.occ_file.occ02,",
             "azf03.azf_file.azf03,",   #MOD-910145
             "gen02.gen_file.gen02,",
             "gem02.gem_file.gem02,",
             "oha14.oha_file.oha14,",
             "oha15.oha_file.oha15,",
             "ohb03.ohb_file.ohb03,",
             "ohb04.ohb_file.ohb04,",
             "ohb05.ohb_file.ohb05,",
             "ohb06.ohb_file.ohb06,",
             "ohb08.ohb_file.ohb08,",                                                                                               
             "ohb09.ohb_file.ohb09,",                                                                                               
             "ohb091.ohb_file.ohb091,",
             "ohb092.ohb_file.ohb092,",
             "ohb12.ohb_file.ohb12,",                                                                                               
             "ohb13.ohb_file.ohb13,",    #CHI-B20002
             "ohb14.ohb_file.ohb14,",    #CHI-B20002
             "ohb31.ohb_file.ohb31,",                                                                                               
             "ohb32.ohb_file.ohb32,",                                                                                               
             "ohb33.ohb_file.ohb33,",                                                                                               
             "ohb34.ohb_file.ohb34,",                                                                                               
             "ohb51.ohb_file.ohb51,",                                                                                               
             "ohb910.ohb_file.ohb910,",
             "ohb912.ohb_file.ohb912,",
             "ohb913.ohb_file.ohb913,",                                                                                             
             "ohb915.ohb_file.ohb915,",
             "ohb30.ohb_file.ohb30,",   #MOD-8C0262
             "oga01.oga_file.oga01,",
             "oga02.oga_file.oga02,",
             "l_ima021.ima_file.ima021,",
             "l_ima906.ima_file.ima906,",
             "plant.azp_file.azp01"                           #FUN-8B0025 add
             
  LET l_table=cl_prt_temptable('axmr710',g_sql) CLIPPED
  IF l_table=-1 THEN EXIT PROGRAM END IF
  LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
            " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
            "       ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
            "       ?,?,?,?,?, ?,?)"                               #FUN-8B0025 add ?   #CHI-B20002 add ?,?
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  END IF
             
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.u  = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
#FUN-A70084--mod--str--
#  LET tm.b     = ARG_VAL(14)
#  LET tm.p1    = ARG_VAL(15)
#  LET tm.p2    = ARG_VAL(16)
#  LET tm.p3    = ARG_VAL(17)
#  LET tm.p4    = ARG_VAL(18)
#  LET tm.p5    = ARG_VAL(19)
#  LET tm.p6    = ARG_VAL(20)
#  LET tm.p7    = ARG_VAL(21)
#  LET tm.p8    = ARG_VAL(22)
#  LET tm.type  = ARG_VAL(23)
#  LET g_rpt_name = ARG_VAL(24)   #No.TQC-A50044
   LET tm.type  = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)
   LET g_wc = ARG_VAL(16)
#FUN-A70084--mod--end
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r710_tm(0,0)
      ELSE CALL r710()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION r710_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000) 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW r710_w AT p_row,p_col WITH FORM "axm/42f/axmr710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm2.s1  = '1'
   LET tm2.s2  = '2'
   LET tm2.s2  = '3'
   LET tm2.u1  = 'N'
   LET tm2.u2  = 'N'
   LET tm2.u3  = 'N'
   LET tm2.t1  = 'N'
   LET tm2.t2  = 'N'
   LET tm2.t3  = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #LET tm.b ='N'        #FUN-A70084
  #LET tm.p1=g_plant    #FUN-A70084
   LET tm.type  = '3'
  #CALL r710_set_entry_1()      #FUN-A70084         
  #CALL r710_set_no_entry_1()   #FUN-A70084
  #CALL r710_set_comb()         #FUN-A70084  
WHILE TRUE
#FUN-A70084--add--str--
   CONSTRUCT BY NAME g_wc ON azw01

      BEFORE CONSTRUCT
          CALL cl_qbe_init()

      ON ACTION controlp
            IF INFIELD(azw01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "azw02 = '",g_legal,"' ",
                                      " AND azw01 IN(SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' )"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azw01
               NEXT FIELD azw01
            END IF

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
      ON ACTION qbe_select
         CALL cl_qbe_select()

  END CONSTRUCT
  IF g_action_choice = "locale" THEN
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CONTINUE WHILE
  END IF

  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW r710_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
  END IF
#FUN-A70084--add--end

   CONSTRUCT BY NAME tm.wc ON oha01,oha02,oha03,
                              oha04,oha14,oha15
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION CONTROLP
             CASE
             WHEN INFIELD(oha03) #帳款客戶    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oha03
                  NEXT FIELD oha03
             WHEN INFIELD(oha04) #送貨客戶    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form="q_occ"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oha04
                  NEXT FIELD oha04
             WHEN INFIELD(oha14) #人員    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form="q_gen"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oha14
                  NEXT FIELD oha14
             WHEN INFIELD(oha15) #部門    #FUN-4B0045
                  CALL cl_init_qry_var()
                  LET g_qryparam.form="q_gem"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oha15
                  NEXT FIELD oha15
             END CASE
     ON ACTION locale
        LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
                 
  #FUN-A70084--mod--str--
  #INPUT BY NAME tm.b,tm.p1,tm.p2,tm.p3,                                            #FUN-8B0025
  #              tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.type,                             #FUN-8B0025 
   INPUT BY NAME tm.type,
  #FUN-A70084--mod--end
                 tm2.s1,tm2.s2,tm2.s3,
                 tm2.t1,tm2.t2,tm2.t3,
                 tm2.u1,tm2.u2,tm2.u3,
                 tm.more WITHOUT DEFAULTS    #No.FUn-5C0075
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()
      #UI
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3
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
         ON ACTION qbe_save
            CALL cl_qbe_save()
         
#FUN-A70084--mark--str--
#      AFTER FIELD b
#          IF NOT cl_null(tm.b)  THEN
#             IF tm.b NOT MATCHES "[YN]" THEN
#                NEXT FIELD b       
#             END IF
#          END IF
#                   
#      ON CHANGE  b
#         LET tm.p1=g_plant
#         LET tm.p2=NULL
#         LET tm.p3=NULL
#         LET tm.p4=NULL
#         LET tm.p5=NULL
#         LET tm.p6=NULL
#         LET tm.p7=NULL
#         LET tm.p8=NULL
#         DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
#         CALL r710_set_entry_1()      
#         CALL r710_set_no_entry_1()
#         CALL r710_set_comb()
#FUN-A70084--mark--end
          
       AFTER FIELD type
          IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
             NEXT FIELD type
          END IF                 
       
#FUN-A70084--mark--str--
#      AFTER FIELD p1
#         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
#         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
#         IF STATUS THEN 
#            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
#            NEXT FIELD p1 
#         END IF
#         IF NOT cl_null(tm.p1) THEN 
#            IF NOT s_chk_demo(g_user,tm.p1) THEN              
#               NEXT FIELD p1          
#            END IF  
#         END IF              
#      
#      AFTER FIELD p2
#         IF NOT cl_null(tm.p2) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p2 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p2) THEN
#               NEXT FIELD p2
#            END IF            
#         END IF
#      
#      AFTER FIELD p3
#         IF NOT cl_null(tm.p3) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p3 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p3) THEN
#               NEXT FIELD p3
#            END IF            
#         END IF
#      
#      AFTER FIELD p4
#         IF NOT cl_null(tm.p4) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p4 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p4) THEN
#               NEXT FIELD p4
#            END IF            
#         END IF
#      
#      AFTER FIELD p5
#         IF NOT cl_null(tm.p5) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
#               NEXT FIELD p5 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p5) THEN
#               NEXT FIELD p5
#            END IF            
#         END IF
#      
#      AFTER FIELD p6
#         IF NOT cl_null(tm.p6) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
#               NEXT FIELD p6 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p6) THEN
#               NEXT FIELD p6
#            END IF            
#         END IF
#      
#      AFTER FIELD p7
#         IF NOT cl_null(tm.p7) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
#               NEXT FIELD p7 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p7) THEN
#               NEXT FIELD p7
#            END IF            
#         END IF
#      
#      AFTER FIELD p8
#         IF NOT cl_null(tm.p8) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
#            IF STATUS THEN 
#               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
#               NEXT FIELD p8 
#            END IF
#            IF NOT s_chk_demo(g_user,tm.p8) THEN
#               NEXT FIELD p8
#            END IF            
#         END IF       
 
#     ON ACTION CONTROLP
#        CASE
#           WHEN INFIELD(p1)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p1
#              CALL cl_create_qry() RETURNING tm.p1
#              DISPLAY BY NAME tm.p1
#              NEXT FIELD p1
#           WHEN INFIELD(p2)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p2
#              CALL cl_create_qry() RETURNING tm.p2
#              DISPLAY BY NAME tm.p2
#              NEXT FIELD p2
#           WHEN INFIELD(p3)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p3
#              CALL cl_create_qry() RETURNING tm.p3
#              DISPLAY BY NAME tm.p3
#              NEXT FIELD p3
#           WHEN INFIELD(p4)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p4
#              CALL cl_create_qry() RETURNING tm.p4
#              DISPLAY BY NAME tm.p4
#              NEXT FIELD p4
#           WHEN INFIELD(p5)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p5
#              CALL cl_create_qry() RETURNING tm.p5
#              DISPLAY BY NAME tm.p5
#              NEXT FIELD p5
#           WHEN INFIELD(p6)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p6
#              CALL cl_create_qry() RETURNING tm.p6
#              DISPLAY BY NAME tm.p6
#              NEXT FIELD p6
#           WHEN INFIELD(p7)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p7
#              CALL cl_create_qry() RETURNING tm.p7
#              DISPLAY BY NAME tm.p7
#              NEXT FIELD p7
#           WHEN INFIELD(p8)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#              LET g_qryparam.arg1 = g_user                #No.FUN-940102
#              LET g_qryparam.default1 = tm.p8
#              CALL cl_create_qry() RETURNING tm.p8
#              DISPLAY BY NAME tm.p8
#              NEXT FIELD p8
#        END CASE                        
#FUN-A70084--mark--end
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW r710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='axmr710'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axmr710','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                        #FUN-A70084--mark--str--
                        #" '",tm.b CLIPPED,"'" ,                #FUN-8B0025
                        #" '",tm.p1 CLIPPED,"'" ,               #FUN-8B0025
                        #" '",tm.p2 CLIPPED,"'" ,               #FUN-8B0025
                        #" '",tm.p3 CLIPPED,"'" ,               #FUN-8B0025
                        #" '",tm.p4 CLIPPED,"'" ,               #FUN-8B0025
                        #" '",tm.p5 CLIPPED,"'" ,               #FUN-8B0025
                        #" '",tm.p6 CLIPPED,"'" ,               #FUN-8B0025
                        #" '",tm.p7 CLIPPED,"'" ,               #FUN-8B0025
                        #" '",tm.p8 CLIPPED,"'" ,               #FUN-8B0025
                        #FUN-A70084--mark--end
                         " '",tm.type CLIPPED,"'",              #FUN-8B0025                         
                         " '",g_rpt_name CLIPPED,"'",           #No.TQC-A50044
                         " '",g_wc CLIPPED,"'"            #No.FUN-A70084
         CALL cl_cmdat('axmr710',g_time,l_cmd)
      END IF
      CLOSE WINDOW r710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r710()
   ERROR ""
END WHILE
   CLOSE WINDOW r710_w
END FUNCTION
 
FUNCTION r710()
DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680137 VARCHAR(20)
     # l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680137 VARCHAR(1000)  #No.TQC-B60202 mark 
       l_sql     STRING,                       #No.TQC-B60202        
       l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
       sr        RECORD oha01     LIKE oha_file.oha01,        #No.FUN-850018
                        oha02     LIKE oha_file.oha02,
                        oha03     LIKE oha_file.oha03,
                        oha032    LIKE oha_file.oha032,
                        oha04     LIKE oha_file.oha04,
                        occ02     LIKE occ_file.occ02,
                        azf03     LIKE azf_file.azf03,   #MOD-910145
                        gen02     LIKE gen_file.gen02,
                        gem02     LIKE gem_file.gem02,
                        oha14     LIKE oha_file.oha14,
                        oha15     LIKE oha_file.oha15,
                        ohb03     LIKE ohb_file.ohb03,
                        ohb04     LIKE ohb_file.ohb04,
                        ohb05     LIKE ohb_file.ohb05,
                        ohb06     LIKE ohb_file.ohb06,
                        ohb08     LIKE ohb_file.ohb08,
                        ohb09     LIKE ohb_file.ohb09,
                        ohb091    LIKE ohb_file.ohb091,
                        ohb092    LIKE ohb_file.ohb092,
                        ohb12     LIKE ohb_file.ohb12,
                        ohb13     LIKE ohb_file.ohb13,   #CHI-B20002
                        ohb14     LIKE ohb_file.ohb14,   #CHI-B20002
                        ohb31     LIKE ohb_file.ohb31,
                        ohb32     LIKE ohb_file.ohb32,
                        ohb33     LIKE ohb_file.ohb33,
                        ohb34     LIKE ohb_file.ohb34,
                        ohb51     LIKE ohb_file.ohb51,
                        ohb910    LIKE ohb_file.ohb910,                #No.FUN-580004
                        ohb912    LIKE ohb_file.ohb912,                #No.FUN-580004
                        ohb913    LIKE ohb_file.ohb913,                #No.FUN-580004
                        ohb915    LIKE ohb_file.ohb915,                #No.FUN-580004
                        ohb30     LIKE ohb_file.ohb30,   #MOD-8C0262
                        oga01     LIKE oga_file.oga01,
                        oga02     LIKE oga_file.oga02
                        END RECORD
DEFINE l_i         LIKE type_file.num5,      #No.FUN-680137 SMALLINT                                                               
       l_ima021    LIKE ima_file.ima021,          
       l_ima906    LIKE ima_file.ima906                                                                                 
 
     DEFINE     l_dbs      LIKE azp_file.azp03                               
     DEFINE     l_azp03    LIKE azp_file.azp03                               
     DEFINE     l_occ37    LIKE occ_file.occ37                               
 
     CALL cl_del_data(l_table)                                         #No.FUN-850018
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axmr710'         #No.FUN-850018
 
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ohauser', 'ohagrup')
     
#FUN-A70084--mark--str--
#   FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#   LET m_dbs[1]=tm.p1
#   LET m_dbs[2]=tm.p2
#   LET m_dbs[3]=tm.p3
#   LET m_dbs[4]=tm.p4
#   LET m_dbs[5]=tm.p5
#   LET m_dbs[6]=tm.p6
#   LET m_dbs[7]=tm.p7
#   LET m_dbs[8]=tm.p8
#FUN-A70084--mark--end

#FUN-A70084--mod--str--
#  FOR l_i = 1 to 8                                                          #FUN-8B0025
#      IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8B0025 
#      SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8B0025
#      LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8B0025     
   LET g_sql = "SELECT azw01 FROM azw_file,azp_file ",
               " WHERE azp01 = azw01 AND azwacti = 'Y'",
               "   AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"')",
               "   AND ",g_wc CLIPPED
   PREPARE sel_azw01_pre FROM g_sql
   DECLARE sel_azw01_cur CURSOR FOR sel_azw01_pre
   FOREACH sel_azw01_cur INTO m_plant
     IF cl_null(m_plant) THEN CONTINUE FOREACH END IF 
#FUN-A70084--mod--end 
     LET l_sql = "SELECT oha01,oha02,oha03,oha032,oha04,occ02,azf03,",    #No.FUN-850018    #MOD-910145                          
                 "       gen02,gem02,oha14,oha15,ohb03,ohb04,ohb05,ohb06,ohb08,",
                 #"       ohb09,ohb091,ohb092,ohb12,ohb31,ohb32,",   #CHI-B20002
                 "       ohb09,ohb091,ohb092,ohb12,ohb13,ohb14,ohb31,ohb32,",   #CHI-B20002
                 "       ohb33,ohb34,ohb51,ohb910,ohb912,ohb913,ohb915,ohb30,oga01,oga02,",           #No.FUN-580004   #MOD-8C0262
                 "       occ37",                                                        #NO.FUN-8B0025 
                 "  FROM ",cl_get_target_table(m_plant, 'oha_file'),                 #NO.FUN-A10056  #FUN-A70084 m_dbs-->m_plant
                 " LEFT OUTER  join ",cl_get_target_table(m_plant, 'occ_file'),      #NO.FUN-A10056  #FUN-A70084 m_dbs-->m_plant
                 " ON oha04=occ01",
                 " LEFT OUTER join ",cl_get_target_table(m_plant, 'gem_file'),       #NO.FUN-A10056  #FUN-A70084 m_dbs-->m_plant              
                 " ON gem01=oha15 ",
                 " LEFT OUTER join ",cl_get_target_table(m_plant, 'gen_file'),       #NO.FUN-A10056  #FUN-A70084 m_dbs-->m_plant
                 " ON gen01=oha14 ",",",            
                 cl_get_target_table(m_plant, 'ohb_file'),                           #NO.FUN-A10056  #FUN-A70084 m_dbs-->m_plant
                 " LEFT OUTER join ",cl_get_target_table(m_plant, 'oga_file'),       #NO.FUN-A10056  #FUN-A70084 m_dbs-->m_plant
                 " ON  oga01=ohb31 ",
                 " LEFT OUTER join ",cl_get_target_table(m_plant, 'azf_file'),       #NO.FUN-A10056  #FUN-A70084 m_dbs-->m_plant
                 " ON azf01=ohb50 ",
                 " WHERE oha01=ohb01 ",
                 "   AND ohaconf != 'X' ", #01/08/17 mandy<b></b>
#                "   AND oga_file.oga01=ohb_file.ohb31 ",
#                "   AND azf01=ohb50 ",   #MOD-910145
                 "   AND azf02='2' ",   #MOD-910145
#                "   AND oha_file.oha04=occ_file.occ01 ",
#                "   AND gen_file.gen01=oha_file.oha14 ",
#                "   AND gem_file.gem01=oha_file.oha15 ",
                 "   AND oha09 != '6' ", 				#MOD-990004
                 "   AND ", tm.wc CLIPPED,
                 " ORDER BY oha01,ohb03"
    #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056   #FUN-A70084
     CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #NO.FUN-A70084
     PREPARE r710_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM
     END IF
     DECLARE r710_curs1 CURSOR FOR r710_prepare1
#    CALL cl_outnam('axmr710') RETURNING l_name     #TQC-940180 mark  #No.TQC-A50044
 
     SELECT sma115 INTO g_sma115 FROM sma_file
     IF g_sma115 = "Y"  THEN
            LET g_zaa[56].zaa06 = "N"
     ELSE
            LET g_zaa[56].zaa06 = "Y"
     END IF
      CALL cl_prt_pos_len()
     FOREACH r710_curs1 INTO sr.*,l_occ37                      #FUN-8B0025 Add l_occ37
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        IF cl_null(l_occ37) THEN LET l_occ37 = 'N' END IF
        IF tm.type = '1' THEN
           IF l_occ37  = 'N' THEN  CONTINUE FOREACH END IF
        END IF
        IF tm.type = '2' THEN   #非關係人
           IF l_occ37  = 'Y' THEN  CONTINUE FOREACH END IF
        END IF
          LET l_sql = "SELECT ima021,ima906 ",                                                                              
                     #"  FROM ",cl_get_target_table(m_dbs[l_i], 'ima_file'),     #NO.FUN-A10056   #FUN-A70084
                      "  FROM ",cl_get_target_table(m_plant, 'ima_file'),     #NO.FUN-A70084
                      " WHERE ima01='",sr.ohb04,"'"                                                                                                                                                                                  
             #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql   #NO.FUN-A10056    #FUN-A70084
              CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql #FUN-A70084
              PREPARE r710_prepare FROM l_sql                                                                                          
              DECLARE r710_c  CURSOR FOR r710_prepare                                                                                 
              OPEN r710_c                                                                                    
              FETCH r710_c INTO l_ima021,l_ima906
       #EXECUTE insert_prep USING sr.*,l_ima021,l_ima906,m_dbs[l_i]                        #FUN-8B0025 Add ,m_dbs[l_i]  #FUN-A70084 
        EXECUTE insert_prep USING sr.*,l_ima021,l_ima906,m_plant                        #FUN-A70084
     END FOREACH
 #END FOR                                                   #FUN-8B0025   #FUN-A70084 
  END FOREACH      #FUN-A70084      
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oha01,oha02,oha03,oha04,oha14,pha15')
             RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str=tm.wc,';',tm.u[1,1],';',tm.u[2,2],';',tm.u[3,3],';',tm.t[1,1],';',
               tm.t[2,2],';',tm.t[3,3],';',tm.s[1,1],';',tm.s[2,2],';',tm.s[3,3],';',
               g_sma115
    #IF tm.b='Y' THEN    #FUN-A70084 
        CALL cl_prt_cs3('axmr710','axmr710_1',g_sql,g_str)
   #FUN-A70084--mark--str--
   # ELSE 
   #    CALL cl_prt_cs3('axmr710','axmr710',g_sql,g_str)
   # END IF 
   #FUN-A70084--mark--end
END FUNCTION
 
#FUN-A70084--mark--str--
#FUNCTION r710_set_entry_1()
#    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
#END FUNCTION
 
#FUNCTION r710_set_no_entry_1()
#   IF tm.b = 'N' THEN
#      CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
#      IF tm2.s1 = '5' THEN                                                                                                         
#         LET tm2.s1 = ' '                                                                                                          
#      END IF                                                                                                                       
#      IF tm2.s2 = '5' THEN                                                                                                         
#         LET tm2.s2 = ' '                                                                                                          
#      END IF                                                                                                                       
#      IF tm2.s3 = '5' THEN                                                                                                         
#         LET tm2.s2 = ' '                                                                                                          
#      END IF
#   END IF
#END FUNCTION
 
#FUNCTION r710_set_comb()                                                                                                            
# DEFINE comb_value STRING                                                                                                          
# DEFINE comb_item  LIKE type_file.chr1000                                                                                          
                                                                                                                                    
#   IF tm.b ='N' THEN                                                                                                         
#      LET comb_value = '1,2,3,4,5,6'                                                                                                   
#      SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#        WHERE ze01='axm-835' AND ze02=g_lang                                                                                      
#   ELSE                                                                                                                            
#      LET comb_value = '1,2,3,4,5,6,7'                                                                                                   
#      SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#        WHERE ze01='axm-836' AND ze02=g_lang                                                                                       
#   END IF                                                                                                                          
#   CALL cl_set_combo_items('s1',comb_value,comb_item)
#   CALL cl_set_combo_items('s2',comb_value,comb_item)
#   CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
#FUN-A70084--mark--end
#No:FUN-9C0071--------精簡程式-----
