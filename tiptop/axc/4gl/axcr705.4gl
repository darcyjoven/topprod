# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: axcr705.4gl
# Descriptions...: 採購入庫金額彙總表
# Input parameter: 
# Return code....: 
# Date & Author..: 99/12/20 By Chien
# Modify.........: No.FUN-4C0099 05/01/03 By kim 報表轉XML功能
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/27 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-720042 07/02/12 By TSD.miki 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.TQC-780054 07/08/17 By zhoufeng 修改INSERT INTO temptable語法
# Modify.........: No.TQC-790019 07/09/03 By Sarah 執行程式時出現-201 create_x:發生語法錯誤
# Mofify.........: No.FUN-7C0101 08/01/25 By lala 成本改善增加成本計算類型(type)
# Modify.........: No.FUN-830002 08/03/05 By Cockroach l_sql增加tlf_file與tlfc_file關聯字段
# Modify.........: No.FUN-8B0026 08/11/06 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.TQC-970187 09/07/21 BY destiny l_sql改為string 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/19 By baofei GP5.2跨DB報表--財務類
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70084 10/07/19 By lutingting GP5.2報表修 GP5.2報表修改改 m_dbs-->m_plant 
# Modify.........: No.TQC-BB0182 12/01/11 By pauline 取消過濾plant條件
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:CHI-B30087 13/01/29 By Alberti 印出資料時，同一廠商應只出現一筆

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                    # Print condition RECORD
              wc           LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)        # Where condition
              bdate,edate  LIKE type_file.dat,           #No.FUN-680122DATE
              type         LIKE type_file.chr1,          #No.FUN-7C0101 VARCHAR(1)
              a            LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
              b            LIKE type_file.chr1,          #No.FUN-8B0026 VARCHAR(1)
              p1           LIKE azp_file.azp01,          #No.FUN-8B0026 VARCHAR(10)
              p2           LIKE azp_file.azp01,          #No.FUN-8B0026 VARCHAR(10)
              p3           LIKE azp_file.azp01,          #No.FUN-8B0026 VARCHAR(10)
              p4           LIKE azp_file.azp01,          #No.FUN-8B0026 VARCHAR(10) 
              p5           LIKE azp_file.azp01,          #No.FUN-8B0026 VARCHAR(10)
              p6           LIKE azp_file.azp01,          #No.FUN-8B0026 VARCHAR(10)
              p7           LIKE azp_file.azp01,          #No.FUN-8B0026 VARCHAR(10)
              p8           LIKE azp_file.azp01,          #No.FUN-8B0026 VARCHAR(10)
              type_1       LIKE type_file.chr1,          #No.FUN-8B0026 VARCHAR(1)
              s            LIKE type_file.chr3,          #No.FUN-8B0026 VARCHAR(3)
              t            LIKE type_file.chr3,          #No.FUN-8B0026 VARCHAR(3)
              u            LIKE type_file.chr3,          #No.FUN-8B0026 VARCHAR(3)              
              more         LIKE type_file.chr1           #No.FUN-680122CHAR(1)          # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
#MOD-720042 TSD.miki------------------------(S)
DEFINE   l_table         STRING
DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   g_tot           ARRAY[13] OF LIKE cae_file.cae07
#MOD-720042 TSD.miki------------------------(E)
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8B0026 ARRAY[10] OF VARCHAR(20)   #FUN-A70084
DEFINE m_plant       ARRAY[10] OF LIKE azp_file.azp01   #FUN-A70084
DEFINE m_legal       ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
  #MOD-720042 TSD.miki-----------------------------------------------------------(S)
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>
   LET g_sql = "tlf19.tlf_file.tlf19,",
               "pmc03.pmc_file.pmc03,",
               "tlfccost.tlfc_file.tlfccost,",    #No.FUN-7C0101 add
               "tot01.cae_file.cae07,",
               "tot02.cae_file.cae07,",
               "tot03.cae_file.cae07,",
               "tot04.cae_file.cae07,",
               "tot05.cae_file.cae07,",
               "tot06.cae_file.cae07,",
               "tot07.cae_file.cae07,",
               "tot08.cae_file.cae07,",
               "tot09.cae_file.cae07,",
               "tot10.cae_file.cae07,",
               "tot11.cae_file.cae07,",
               "tot12.cae_file.cae07,",
               "tot13.cae_file.cae07,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "plant.azp_file.azp01,"               #FUN-8B0026
              #"ima12.ima_file.ima12,",              #FUN-8B0026   #CHI-B30087 mark
              #"ima57.ima_file.ima57,",              #FUN-8B0026   #CHI-B30087 mark
              #"ima08.ima_file.ima08,",              #FUN-8B0026   #CHI-B30087 mark
              #"tlf905.tlf_file.tlf905,",            #FUN-8B0026   #CHI-B30087 mark
              #"tlf01.tlf_file.tlf01,",              #FUN-8B0026   #CHI-B30087 mark
              #"tlf65.tlf_file.tlf65 "               #FUN-8B0026   #CHI-B30087 mark              
   LET l_table = cl_prt_temptable('axcr705',g_sql) CLIPPED   # 產生Temp Table
   IF l_table  = -1 THEN EXIT PROGRAM END IF                 # Temp Table產生
#  LET g_sql = "SELECT * FROM ds_report.",l_table CLIPPED,        #No.TQC-780054
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#No.TQC-780054
              #" VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)" #FUN-8B0026 Add ?,?,?,?,?,?,?  #CHI-B30087 mark
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"                 #CHI-B30087 add 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
  #MOD-720042 TSD.miki-----------------------------------------------------------(E)
 
   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.a     = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET tm.type = ARG_VAL(14)                   #No.FUN-7C0101
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #No.FUN-8B0026 --start--
   LET tm.b     = ARG_VAL(16)
   LET tm.p1    = ARG_VAL(17)
   LET tm.p2    = ARG_VAL(18)
   LET tm.p3    = ARG_VAL(19)
   LET tm.p4    = ARG_VAL(20)
   LET tm.p5    = ARG_VAL(21)
   LET tm.p6    = ARG_VAL(22)
   LET tm.p7    = ARG_VAL(23)
   LET tm.p8    = ARG_VAL(24)
   LET tm.type_1= ARG_VAL(25)   
   LET tm.s     = ARG_VAL(26)
  #CHI-B30087---mark---start---
  #LET tm.t     = ARG_VAL(27)
  #LET tm.u     = ARG_VAL(28)   
  #LET tm2.s1   = tm.s[1,1]
  #LET tm2.s2   = tm.s[2,2]
  #LET tm2.s3   = tm.s[3,3]
  #LET tm2.t1   = tm.t[1,1]
  #LET tm2.t2   = tm.t[2,2]
  #LET tm2.t3   = tm.t[3,3]
  #LET tm2.u1   = tm.u[1,1]
  #LET tm2.u2   = tm.u[2,2]
  #LET tm2.u3   = tm.u[3,3]
  #IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
  #IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
  #IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
  #IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
  #IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
  #IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
  #IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
  #IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
  #IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF      
  ##No.FUN-8B0026 ---end---
  #CHI-B30087---mark---end---  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL axcr705_tm(0,0)         # Input print condition
      ELSE CALL axcr705()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr705_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col,l_cnt    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 11 END IF
   LET p_row = 5 LET p_col = 20
   OPEN WINDOW axcr705_w AT p_row,p_col
        WITH FORM "axc/42f/axcr705" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r705_set_visible() RETURNING l_cnt    #FUN-A70084
   INITIALIZE tm.* TO NULL            # Default condition
   CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING tm.bdate,tm.edate
   LET tm.a    = 'Y'
   LET tm.more = 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   LET tm.type = g_ccz.ccz28   #No.FUN-7C0101 add
   #FUN-8B0026-Begin--#
   #LET tm.s ='12 '            #CHI-B30087 mark 
   #LET tm.t ='Y  '            #CHI-B30087 mark
   #LET tm.u ='Y  '            #CHI-B30087 mark
   LET tm.type_1 = '3'
   LET tm.b ='N'
   LET tm.p1=g_plant
   CALL r705_set_entry_1()               
   CALL r705_set_no_entry_1()
  #CALL r705_set_comb()        #CHI-B30087 mark    
   #FUN-8B0026-End--#   
   
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima57,ima08,
                              tlf01,tlf905,tlf906,tlf19,tlf65 
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
 
#No.FUN-570240 --start                                                          
     ON ACTION controlp                                                      
        IF INFIELD(tlf01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_tlf"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO tlf01                             
           NEXT FIELD tlf01                                                 
        END IF                                                              
#No.FUN-570240 --end     
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr705_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.a,
                 tm.b,tm.p1,tm.p2,tm.p3,                       #FUN-8B0026
                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.type_1,      #FUN-8B0026 
                #tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,    #FUN-8B0026   #CHI-B30087 mark
                #tm2.u1,tm2.u2,tm2.u3,                         #FUN-8B0026   #CHI-B30087 mark
                 tm.more      #No.FUN-7C0101 add tm.type
   WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF tm.edate IS NULL OR tm.edate < tm.bdate THEN NEXT FIELD edate END IF
      
      #No.FUN-7C0101--start--
      AFTER FIELD type
         IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type 
         END IF
      #No.FUN-7C0101---end---
         
      AFTER FIELD a 
         IF cl_null(tm.a) THEN NEXT FIELD n END IF 
         IF tm.a NOT MATCHES '[YN]' THEN NEXT FIELD a END IF
         
       #FUN-8B0026--Begin--#
      AFTER FIELD b
          IF NOT cl_null(tm.b)  THEN
             IF tm.b NOT MATCHES "[YN]" THEN
                NEXT FIELD b       
             END IF
          END IF
                    
       ON CHANGE  b
          LET tm.p1=g_plant
          LET tm.p2=NULL
          LET tm.p3=NULL
          LET tm.p4=NULL
          LET tm.p5=NULL
          LET tm.p6=NULL
          LET tm.p7=NULL
          LET tm.p8=NULL
          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
          CALL r705_set_entry_1()      
          CALL r705_set_no_entry_1()
         #CALL r705_set_comb()       #CHI-B30087 mark
       
      AFTER FIELD type_1
         IF cl_null(tm.type_1) OR tm.type_1 NOT MATCHES '[123]' THEN
            NEXT FIELD type_1
         END IF                   
       
      AFTER FIELD p1
         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
         IF STATUS THEN 
            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
            NEXT FIELD p1 
         END IF
         #No.FUN-940102--begin    
         IF NOT cl_null(tm.p1) THEN 
            IF NOT s_chk_demo(g_user,tm.p1) THEN              
               NEXT FIELD p1          
            #FUN-A70084--add--str--
            ELSE
               SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.p1
           #FUN-A70084--add--end
            END IF  
         END IF              
         #No.FUN-940102--end 
 
      AFTER FIELD p2
         IF NOT cl_null(tm.p2) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
               NEXT FIELD p2 
            END IF
            #No.FUN-940102--begin    
            IF NOT s_chk_demo(g_user,tm.p2) THEN
               NEXT FIELD p2
            END IF            
            #No.FUN-940102--end 
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.p2
            IF NOT r705_chklegal(m_legal[2],1) THEN
               CALL cl_err(tm.p2,g_errno,0)
               NEXT FIELD p2
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p3
         IF NOT cl_null(tm.p3) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p3
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p3,"",STATUS,"","sel azp",1)   
               NEXT FIELD p3 
            END IF
            #No.FUN-940102--begin    
            IF NOT s_chk_demo(g_user,tm.p3) THEN
               NEXT FIELD p3
            END IF            
            #No.FUN-940102--end 
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.p3
            IF NOT r705_chklegal(m_legal[3],2) THEN
               CALL cl_err(tm.p3,g_errno,0)
               NEXT FIELD p3
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p4
         IF NOT cl_null(tm.p4) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p4
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p4,"",STATUS,"","sel azp",1)  
               NEXT FIELD p4 
            END IF
            #No.FUN-940102--begin    
            IF NOT s_chk_demo(g_user,tm.p4) THEN
               NEXT FIELD p4
            END IF            
            #No.FUN-940102--end 
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.p4
            IF NOT r705_chklegal(m_legal[4],3) THEN
               CALL cl_err(tm.p4,g_errno,0)
               NEXT FIELD p4
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p5
         IF NOT cl_null(tm.p5) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p5
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p5,"",STATUS,"","sel azp",1)    
               NEXT FIELD p5 
            END IF
            #No.FUN-940102--begin    
            IF NOT s_chk_demo(g_user,tm.p5) THEN
               NEXT FIELD p5
            END IF            
            #No.FUN-940102--end 
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.p5
            IF NOT r705_chklegal(m_legal[5],4) THEN
               CALL cl_err(tm.p5,g_errno,0)
               NEXT FIELD p5
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p6
         IF NOT cl_null(tm.p6) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p6
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p6,"",STATUS,"","sel azp",1)  
               NEXT FIELD p6 
            END IF
            #No.FUN-940102--begin    
            IF NOT s_chk_demo(g_user,tm.p6) THEN
               NEXT FIELD p6
            END IF            
            #No.FUN-940102--end 
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.p6
            IF NOT r705_chklegal(m_legal[6],5) THEN
               CALL cl_err(tm.p6,g_errno,0)
               NEXT FIELD p6
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p7
         IF NOT cl_null(tm.p7) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p7
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p7,"",STATUS,"","sel azp",1) 
               NEXT FIELD p7 
            END IF
            #No.FUN-940102--begin    
            IF NOT s_chk_demo(g_user,tm.p7) THEN
               NEXT FIELD p7
            END IF            
            #No.FUN-940102--end 
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.p7
            IF NOT r705_chklegal(m_legal[7],6) THEN
               CALL cl_err(tm.p7,g_errno,0)
               NEXT FIELD p7
            END IF
            #FUN-A70084--add--end
         END IF
 
      AFTER FIELD p8
         IF NOT cl_null(tm.p8) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p8
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p8,"",STATUS,"","sel azp",1)   
               NEXT FIELD p8 
            END IF
            #No.FUN-940102--begin    
            IF NOT s_chk_demo(g_user,tm.p8) THEN
               NEXT FIELD p8
            END IF            
            #No.FUN-940102--end 
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.p8
            IF NOT r705_chklegal(m_legal[8],7) THEN
               CALL cl_err(tm.p8,g_errno,0)
               NEXT FIELD p8
            END IF
            #FUN-A70084--add--end
         END IF       
       #FUN-8B0026--End--#         
 
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
     #FUN-8B0026--Begin--#
      ON ACTION CONTROLP
         CASE                                                               
            WHEN INFIELD(p1)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p1
               CALL cl_create_qry() RETURNING tm.p1
               DISPLAY BY NAME tm.p1
               NEXT FIELD p1
            WHEN INFIELD(p2)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p2
               CALL cl_create_qry() RETURNING tm.p2
               DISPLAY BY NAME tm.p2
               NEXT FIELD p2
            WHEN INFIELD(p3)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p3
               CALL cl_create_qry() RETURNING tm.p3
               DISPLAY BY NAME tm.p3
               NEXT FIELD p3
            WHEN INFIELD(p4)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p4
               CALL cl_create_qry() RETURNING tm.p4
               DISPLAY BY NAME tm.p4
               NEXT FIELD p4
            WHEN INFIELD(p5)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p5
               CALL cl_create_qry() RETURNING tm.p5
               DISPLAY BY NAME tm.p5
               NEXT FIELD p5
            WHEN INFIELD(p6)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p6
               CALL cl_create_qry() RETURNING tm.p6
               DISPLAY BY NAME tm.p6
               NEXT FIELD p6
            WHEN INFIELD(p7)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p7
               CALL cl_create_qry() RETURNING tm.p7
               DISPLAY BY NAME tm.p7
               NEXT FIELD p7
            WHEN INFIELD(p8)
               CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
               LET g_qryparam.form = "q_zxy"               #No.FUN-940102
               LET g_qryparam.arg1 = g_user                #No.FUN-940102
               LET g_qryparam.default1 = tm.p8
               CALL cl_create_qry() RETURNING tm.p8
               DISPLAY BY NAME tm.p8
               NEXT FIELD p8
         END CASE                        
    #FUN-8B0026--End--#
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution

     #CHI-B30087---mark---start---
     # #FUN-8B0026--Begin--#
     # AFTER INPUT
     #    LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
     #    LET tm.t = tm2.t1,tm2.t2,tm2.t3
     #    LET tm.u = tm2.u1,tm2.u2,tm2.u3      
     # #FUN-8B0026--End--#      
     #CHI-B30087---mark---end--- 
     
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr705_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr705'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr705','9031',1)   
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
                         " '",tm.bdate CLIPPED,"'" ,            #TQC-610051 
                         " '",tm.edate CLIPPED,"'" ,            #TQC-610051 
                         " '",tm.type CLIPPED,"'" ,             #No.FUN-7C0101 add
                         " '",tm.a CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.b CLIPPED,"'" ,      #FUN-8B0026
                         " '",tm.p1 CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.p2 CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.p3 CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.p4 CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.p5 CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.p6 CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.p7 CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.p8 CLIPPED,"'" ,     #FUN-8B0026
                         " '",tm.type_1 CLIPPED,"'"   #FUN-8B0026                        
                        #" '",tm.s CLIPPED,"'" ,      #FUN-8B0026    #CHI-B30087 mark
                        #" '",tm.t CLIPPED,"'" ,      #FUN-8B0026    #CHI-B30087 mark
                        #" '",tm.u CLIPPED,"'"        #FUN-8B0026    #CHI-B30087 mark                       
                          
         CALL cl_cmdat('axcr705',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr705_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr705()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr705_w
END FUNCTION
 
FUNCTION axcr705()
   DEFINE l_name         LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)         # External(Disk) file name
#       l_time          LIKE type_file.chr8             #No.FUN-6A0146
          l_za05         LIKE za_file.za05,
#         l_sql          LIKE type_file.chr1000,       # RDSQL STATEMENT         #No.TQC-970187
          l_sql          STRING,                                                 #No.TQC-970187
          bdate,edate    LIKE type_file.dat,           #No.FUN-680122DATE
          l_cnt          LIKE type_file.num5,
          sr             RECORD 
                           tlf19    LIKE tlf_file.tlf19,   #廠商
                           pmc03    LIKE pmc_file.pmc03,   #廠商簡稱
                           tlf06    LIKE tlf_file.tlf06,   #異動日期
                           tlfccost  LIKE tlfc_file.tlfccost,   #No.FUN-7C0101
                           tot      LIKE cae_file.cae07,         #No.FUN-680122DECIMAL(15,5)         #金額
                           mm       LIKE type_file.num5          #No.FUN-680122SMALLINT               #月份
                         END RECORD
DEFINE     l_i        LIKE type_file.num5                 #No.FUN-8B0026 SMALLINT
DEFINE     l_dbs      LIKE azp_file.azp03                 #No.FUN-8B0026
DEFINE     l_azp03    LIKE azp_file.azp03                 #No.FUN-8B0026
DEFINE     l_pmc903   LIKE pmc_file.pmc903                #No.FUN-8B0026
DEFINE     i          LIKE type_file.num5                 #No.FUN-8B0026
DEFINE     l_ima12    LIKE ima_file.ima12                 #No.FUN-8B0026
DEFINE     l_ima57    LIKE ima_file.ima57                 #No.FUN-8B0026
DEFINE     l_ima08    LIKE ima_file.ima08                 #No.FUN-8B0026
DEFINE     l_tlf905   LIKE tlf_file.tlf905                #No.FUN-8B0026
DEFINE     l_tlf01    LIKE tlf_file.tlf01                 #No.FUN-8B0026
DEFINE     l_tlf65    LIKE tlf_file.tlf65                 #No.FUN-8B0026                         
    #MOD-720042 TSD.miki---------------------------------------------------------(S)
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>>
     CALL cl_del_data(l_table)
#     DELETE FROM x
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #MOD-720042 TSD.miki---------------------------------------------------------(E)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
#FUN-A70084--mod--str--m_dbs-->m_plant
#  #FUN-8B0026--Begin--#
#  FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#  LET m_dbs[1]=tm.p1
#  LET m_dbs[2]=tm.p2
#  LET m_dbs[3]=tm.p3
#  LET m_dbs[4]=tm.p4
#  LET m_dbs[5]=tm.p5
#  LET m_dbs[6]=tm.p6
#  LET m_dbs[7]=tm.p7
#  LET m_dbs[8]=tm.p8
#  #FUN-8B0026--End--#
   FOR i = 1 TO 8 LET m_plant[i] = NULL END FOR
   LET m_plant[1]=tm.p1
   LET m_plant[2]=tm.p2
   LET m_plant[3]=tm.p3
   LET m_plant[4]=tm.p4
   LET m_plant[5]=tm.p5
   LET m_plant[6]=tm.p6
   LET m_plant[7]=tm.p7
   LET m_plant[8]=tm.p8   
#FUN-A70084--mod--end
      
   FOR l_i = 1 to 8                                                          #FUN-8B0026
      #IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8B0026   #FUN-A70084
       IF cl_null(m_plant[l_i]) THEN CONTINUE FOR END IF                       #FUN-A70084
       CALL r705_set_visible() RETURNING l_cnt    #FUN-A70084
       IF l_cnt>1 THEN LET m_plant[1]=g_plant END IF    #FUN-A70084
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8B0026   #FUN-A70084
      #LET l_azp03 = l_dbs CLIPPED                                           #FUN-8B0026   #FUN-A70084
      #LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8B0026      #FUN-A70084
     
     LET l_sql = " SELECT tlf19,pmc03,tlf06,tlfccost,SUM(tlfc21*tlf907),' ',pmc903,tlf905,tlf01,tlf65 ",   #No.FUN-7C0101 add tlfccost tlf21->tlfc21 #FUN-8B0026 Add pmc903,tlf905,tlf01,tlf65
#FUN-A10098---BEGIN
#"  FROM ",l_dbs CLIPPED,"tlf_file LEFT OUTER JOIN ",l_dbs CLIPPED,"pmc_file  ON pmc01 = tlf19 ",
#"                                 LEFT OUTER JOIN ",l_dbs CLIPPED,"tlfc_file ON tlfc01 = tlf01  AND tlfc06 = tlf06  AND ",
"  FROM ",cl_get_target_table(m_plant[l_i],'tlf_file')," LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'pmc_file')," ON pmc01 = tlf19 ",   #FUN-A70084 m_dbs-->m_plant
"                                 LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file')," ON tlfc01 = tlf01  AND  tlfc06 = tlf06  AND ",   #FUN-A70084 m_dbs-->m_plant
#FUN-A10098---END
"                                                                               tlfc02 = tlf02  AND tlfc03 = tlf03  AND ",
"                                                                               tlfc13 = tlf13  AND ",
"                                                                               tlfc902= tlf902 AND tlfc903= tlf903 AND ",
"                                                                               tlfc904= tlf904 AND tlfc907= tlf907 AND ",
"                                                                               tlfc905= tlf905 AND tlfc906= tlf906 AND ",
"                                                                               tlfctype = '",tm.type,"'",
#"      ,",l_dbs CLIPPED,"ima_file ",  #FUN-A10098
#"      ,",cl_get_target_table(m_dbs[l_i],'ima_file'),  #FUN-A10098   #FUN-A70084
"      ,",cl_get_target_table(m_plant[l_i],'ima_file'),  #FUN-A70084
                 " WHERE (tlf06 >= '",tm.bdate,"' ",
                 "  AND tlf06 <= '",tm.edate,"') ",
                 "  AND tlf65 IS NOT NULL ",
                 "  AND tlf65 != ' ' AND ima01 = tlf01",
                 #"  AND tlfc_file.tlfc01 = tlf01  AND tlfc_file.tlfc06 = tlf06",                   #No.FUN-7C0101
#FUN-830002                 "  AND tlfc026= tlf026 AND tlfc027= tlf027",                   #No.FUN-7C0101
#FUN-830002                 "  AND tlfc036= tlf036 AND tlfc037= tlf037",                   #No.FUN-7C0101
                 #"  AND tlfc_file.tlfc02 = tlf02  AND tlfc_file.tlfc03 = tlf03 ",                       #FUN-830002 ADD
                 #"  AND tlfc_file.tlfc13 = tlf13 ",                                        #FUN-830002 ADD
                 #"  AND tlfc_file.tlfc902= tlf902 AND tlfc_file.tlfc903= tlf903 ",                    #FUN-830002 ADD
                 #"  AND tlfc_file.tlfc904= tlf904 AND tlfc_file.tlfc907= tlf907 ",                    #FUN-830002 ADD
                 #"  AND tlfc_file.tlfc905= tlf905 AND tlfc_file.tlfc906= tlf906",                   #No.FUN-7C0101
                 #"  AND tlfc_file.tlfctype = '",tm.type,"'",                              #No.FUN-7C0101
#                 "  AND tlf902 NOT IN (SELECT jce02 FROM ",l_dbs CLIPPED,"jce_file)",#FUN-A10098 #JIT除外   #FUN-8B0026 Add ",l_dbs CLIPPED,"
                 "  AND tlf902 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_plant[l_i],'jce_file'),")",#FUN-A10098   #FUN-A70084 m_dbs-->m_plant 
                 "  AND ",tm.wc clipped
     IF tm.a = 'N' THEN
        LET l_sql = l_sql CLIPPED, " AND tlf907 != -1 "
     END IF
     LET l_sql = l_sql CLIPPED," GROUP BY tlf19,pmc03,tlf06,tlfccost,pmc903,tlf905,tlf01,tlf65 "
     LET l_sql = l_sql CLIPPED," ORDER BY tlf19,pmc03,tlf06,tlfccost "  #MOD-720042 TSD.miki
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
    #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098     
    #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084 #TQC-BB0182 mark 
     PREPARE axcr705_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
           
     END IF
     DECLARE axcr705_curs1 CURSOR FOR axcr705_prepare1
 
    #CALL cl_outnam('axcr705') RETURNING l_name
    #START REPORT axcr705_rep TO l_name   #MOD-720042 TSD.miki mark
 
     LET g_pageno = 0  
     FOREACH axcr705_curs1 INTO sr.*,l_pmc903,l_tlf905,l_tlf01,l_tlf65              #FUN-8B0026 Add l_pmc903,l_tlf905,l_tlf01,l_tlf65
        IF SQLCA.sqlcode != 0 THEN 
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH 
        END IF
        #FUN-8B0026--Begin--#
        IF cl_null(l_pmc903) THEN LET l_pmc903 = 'N' END IF
        IF tm.type_1 = '1' THEN
           IF l_pmc903  = 'N' THEN  CONTINUE FOREACH END IF
        END IF
        IF tm.type_1 = '2' THEN   #非關係人
           IF l_pmc903  = 'Y' THEN  CONTINUE FOREACH END IF
        END IF
        LET l_sql = "SELECT ima12,ima57,ima08 ",                                                                              
                #    "  FROM ",l_dbs CLIPPED,"ima_file ", #FUN-A10098 
                   #"  FROM ",cl_get_target_table(m_dbs[l_i],'ima_file'), #FUN-A10098   #FUN-A70084
                    "  FROM ",cl_get_target_table(m_plant[l_i],'ima_file'), #FUN-A70084
                    " WHERE ima01='",l_tlf01,"'"      
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102
       #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098 #FUN-A70084                                                                                                                                                                          
       #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084    #TQC-BB0182 mark 
        PREPARE ima_prepare4 FROM l_sql                                                                                          
        DECLARE ima_c4  CURSOR FOR ima_prepare4                                                                                 
        OPEN ima_c4                                                                                    
        FETCH ima_c4 INTO l_ima12,l_ima57,l_ima08        
        #FUN-8B0026--End--#        
        IF cl_null(sr.tot) THEN
           LET sr.tot = 0
        END IF
        LET sr.mm = MONTH(sr.tlf06)
       #OUTPUT TO REPORT axcr705_rep(sr.*)   #MOD-720042 TSD.miki mark
        CALL axcr705_data(sr.*,m_plant[l_i],l_ima12,l_ima57,l_ima08,l_tlf905,l_tlf01,l_tlf65)   #MOD-720042 TSD.miki #FUN-8B0026 Add m_dbs[l_i],l_ima12,l_ima57,l_ima08,l_tlf905,l_tlf65    #FUN-A70084 m_dbs-->m_plant
     END FOREACH
   END FOR                                                                      #FUN-8B0026     
    #MOD-720042 TSD.miki---------------------------------------------------------(S)
    #FINISH REPORT axcr705_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>>
    #str TQC-790019 mod
    #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET l_sql = "SELECT tlf19,pmc03,tlfccost,SUM(tot01) tot01,SUM(tot02) tot02,",     #No.FUN-7C0101
                 "       SUM(tot03) tot03,SUM(tot04) tot04,SUM(tot05) tot05,",
                 "       SUM(tot06) tot06,SUM(tot07) tot07,SUM(tot08) tot08,",
                 "       SUM(tot09) tot09,SUM(tot10) tot10,SUM(tot11) tot11,",
                 "       SUM(tot12) tot12,SUM(tot13) tot13,azi03,azi04,azi05,",
                #"       plant,ima12,ima57,ima08,tlf905,tlf01,tlf65",                  #FUN-8B0026  #CHI-B30087 mark
                 "       plant",                                         #CHI-B30087 add
                 "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                #" GROUP BY tlf19,pmc03,tlfccost,azi03,azi04,azi05,plant,ima12,ima57,ima08,tlf905,tlf01,tlf65" #No.FUN-7C0101 #FUN-8B0026 Add plant,ima12,ima57,ima08,tlf905,tlf01,tlf65 #CHI-B30087 mark
                 " GROUP BY tlf19,pmc03,tlfccost,azi03,azi04,azi05,plant"   #CHI-B30087 add
    #end TQC-790019 mod
     #是否列印選擇條件
#        EXECUTE insert_prep USING
#           sr.tlf19,sr.pmc03,sr.tlfccost,                      #No.FUN-7C0101
#           g_tot[1],g_tot[2],g_tot[3],g_tot[4],g_tot[5],
#           g_tot[6],g_tot[7],g_tot[8],g_tot[9],g_tot[10],
#           g_tot[11],g_tot[12],g_tot[13],
#           g_azi03,g_azi04,g_azi05
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima12,ima57,ima08,tlf01,tlf905,tlf906,tlf19,tlf65')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.bdate,";",tm.edate,";",
                #tm.s[1,1],";",tm.s[2,2],";",                             #FUN-8B0026  #CHI-B30087 mark
                #tm.s[3,3],";",tm.t,";",tm.u,";",tm.b                     #FUN-8B0026  #CHI-B30087 mark
                tm.b       #CHI-B30087 add
     #No.FUN-7C0101--start--
     IF tm.type MATCHES '[12]' THEN
     CALL cl_prt_cs3('axcr705','axcr705_1',l_sql,g_str)   
     END IF
     IF tm.type MATCHES '[345]' THEN
     CALL cl_prt_cs3('axcr705','axcr705',l_sql,g_str)   #FUN-710080 modify
     END IF
     #No.FUN-7C0101---end---
    #MOD-720042 TSD.miki---------------------------------------------------------(E)
END FUNCTION
 
#FUN-8B0026--Begin--#
FUNCTION r705_set_entry_1()
    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
END FUNCTION
FUNCTION r705_set_no_entry_1()
    IF tm.b = 'N' THEN
       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
       IF tm2.s1 = '8' THEN                                                                                                         
          LET tm2.s1 = ' '                                                                                                          
       END IF                                                                                                                       
       IF tm2.s2 = '8' THEN                                                                                                         
          LET tm2.s2 = ' '                                                                                                          
       END IF                                                                                                                       
       IF tm2.s3 = '8' THEN                                                                                                         
          LET tm2.s3 = ' '                                                                                                          
       END IF
    END IF
END FUNCTION
#CHI-B30087---mark---start---
#FUNCTION r705_set_comb()                                                                                                            
#  DEFINE comb_value STRING                                                                                                          
#  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
#                                                                                                                                    
#    IF tm.b ='N' THEN                                                                                                         
#       LET comb_value = '1,2,3,4,5,6,7'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axc-984' AND ze02=g_lang                                                                                      
#    ELSE                                                                                                                            
#       LET comb_value = '1,2,3,4,5,6,7,8'                                                                                                   
#       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
#         WHERE ze01='axc-985' AND ze02=g_lang                                                                                       
#    END IF                                                                                                                          
#    CALL cl_set_combo_items('s1',comb_value,comb_item)
#    CALL cl_set_combo_items('s2',comb_value,comb_item)
#    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
#END FUNCTION
#FUN-8B0026--End--#
#CHI-B30087---mark---end---
 
#MOD-720042 TSD.miki-------------------------------------------------------------(S)
FUNCTION axcr705_data(sr,l_azp01,t_ima12,t_ima57,t_ima08,t_tlf905,t_tlf01,t_tlf65)      #FUN-8B0026 Add l_azp01,t_ima12,t_ima57,t_ima08,t_tlf905,t_tlf01,t_tlf65
   DEFINE sr           RECORD 
                         tlf19  LIKE tlf_file.tlf19,   #廠商
                         pmc03  LIKE pmc_file.pmc03,   #廠商簡稱
                         tlf06  LIKE tlf_file.tlf06,   #異動日期
                         tlfccost LIKE tlfc_file.tlfccost,
                         tot    LIKE cae_file.cae07,   #金額
                         mm     LIKE type_file.num5    #月份
                       END RECORD
   DEFINE l_azp01      LIKE azp_file.azp01                                       #FUN-8B0026
   DEFINE t_ima12      LIKE ima_file.ima12                 #No.FUN-8B0026
   DEFINE t_ima57      LIKE ima_file.ima57                 #No.FUN-8B0026
   DEFINE t_ima08      LIKE ima_file.ima08                 #No.FUN-8B0026
   DEFINE t_tlf905     LIKE tlf_file.tlf905                #No.FUN-8B0026
   DEFINE t_tlf01      LIKE tlf_file.tlf01                 #No.FUN-8B0026
   DEFINE t_tlf65      LIKE tlf_file.tlf65                 #No.FUN-8B0026                       
 
   LET g_tot[1]  = 0
   LET g_tot[2]  = 0
   LET g_tot[3]  = 0
   LET g_tot[4]  = 0
   LET g_tot[5]  = 0
   LET g_tot[6]  = 0
   LET g_tot[7]  = 0
   LET g_tot[8]  = 0
   LET g_tot[9]  = 0
   LET g_tot[10] = 0
   LET g_tot[11] = 0
   LET g_tot[12] = 0
   LET g_tot[13] = 0
   LET g_tot[sr.mm] = g_tot[sr.mm] + sr.tot
   LET g_tot[13] = g_tot[13] + sr.tot
   IF cl_null(sr.tlfccost) THEN LET sr.tlfccost = ' ' END IF    #CHI-B30087 add
   EXECUTE insert_prep USING
           sr.tlf19,sr.pmc03,sr.tlfccost,                      #No.FUN-7C0101
           g_tot[1],g_tot[2],g_tot[3],g_tot[4],g_tot[5],
           g_tot[6],g_tot[7],g_tot[8],g_tot[9],g_tot[10],
           g_tot[11],g_tot[12],g_tot[13],
           #g_azi03,g_azi04,g_azi05,  #CHI-C30012
           g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26,  #CHI-C30012
          #l_azp01,t_ima12,t_ima57,t_ima08,t_tlf905,t_tlf01,t_tlf65     #CHI-B30087 mark                             #FUN-8B0026
           l_azp01                                                      #CHI-B30087 add
END FUNCTION
#MOD-720042 TSD.miki-------------------------------------------------------------(E)
 
#No.8741
#REPORT axcr705_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
#          l_tmpstr   STRING,
#          sr            RECORD 
#                         tlf19  LIKE tlf_file.tlf19,   #廠商
#                         pmc03  LIKE pmc_file.pmc03,   #廠商簡稱
#                         tlf06  LIKE tlf_file.tlf06,   #異動日期
#                         tot    LIKE cae_file.cae07,        #No.FUN-680122DECIMAL(15,5)         #金額
#                         mm     LIKE type_file.num5           #No.FUN-680122SMALLINT              #月份
#                       END RECORD,
#          r_tot        ARRAY[13] OF LIKE cae_file.cae07,        #No.FUN-680122DECIMAL(15,5)
#          i            LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
 
#  ORDER BY sr.tlf19,sr.pmc03,sr.mm
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total 
#      LET l_tmpstr=tm.bdate ,' - ' ,tm.edate
#      PRINT COLUMN ((g_len-FGL_WIDTH(l_tmpstr))/2)+1,l_tmpstr
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45] 
#      PRINT g_dash1
#      LET l_last_sw = 'n'
 
#   BEFORE GROUP OF sr.pmc03
#      LET r_tot[1]  = 0
#      LET r_tot[2]  = 0
#      LET r_tot[3]  = 0
#      LET r_tot[4]  = 0
#      LET r_tot[5]  = 0
#      LET r_tot[6]  = 0
#      LET r_tot[7]  = 0
#      LET r_tot[8]  = 0
#      LET r_tot[9]  = 0
#      LET r_tot[10] = 0
#      LET r_tot[11] = 0
#      LET r_tot[12] = 0
#      LET r_tot[13] = 0
 
#   ON EVERY ROW
#      LET i = sr.mm
#      LET r_tot[i] = r_tot[i] + sr.tot
 
#   AFTER GROUP OF sr.pmc03
#      PRINT COLUMN g_c[31],sr.tlf19,
#            COLUMN g_c[32],sr.pmc03;
#      FOR i = 1 TO 12
#          LET r_tot[13] = r_tot[13] + r_tot[i]
#      END FOR
##     FOR i = 1 TO 13
##       PRINT COLUMN 23+(i-1)*22, cl_numfor(r_tot[i],22,g_azi03),' ';    #FUN-570190
##     END FOR
#      FOR i= 1 TO 13
#        PRINT COLUMN g_c[i+32],cl_numfor(r_tot[i],i+32,g_azi03);    #FUN-570190
#      END FOR
#      PRINT
 
#   ON LAST ROW  
#      PRINT g_dash1
#      PRINT COLUMN g_c[32],g_x[8] CLIPPED,
#            COLUMN g_c[33],cl_numfor((SUM(sr.tot) WHERE sr.mm =  1),33,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[34],cl_numfor((SUM(sr.tot) WHERE sr.mm =  2),34,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[35],cl_numfor((SUM(sr.tot) WHERE sr.mm =  3),35,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[36],cl_numfor((SUM(sr.tot) WHERE sr.mm =  4),36,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[37],cl_numfor((SUM(sr.tot) WHERE sr.mm =  5),37,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[38],cl_numfor((SUM(sr.tot) WHERE sr.mm =  6),38,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[39],cl_numfor((SUM(sr.tot) WHERE sr.mm =  7),39,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[40],cl_numfor((SUM(sr.tot) WHERE sr.mm =  8),40,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[41],cl_numfor((SUM(sr.tot) WHERE sr.mm =  9),41,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[42],cl_numfor((SUM(sr.tot) WHERE sr.mm = 10),42,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[43],cl_numfor((SUM(sr.tot) WHERE sr.mm = 11),43,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[44],cl_numfor((SUM(sr.tot) WHERE sr.mm = 12),44,g_azi03),' ',    #FUN-570190
#            COLUMN g_c[45],cl_numfor(SUM(sr.tot) ,45,g_azi03)    #FUN-570190
 
#      LET l_last_sw = 'y'
#      PRINT g_dash
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #CHI-690007
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash
 
#      END IF
#No.8741(END)
#END REPORT
#FUN-A70084--add--str--
FUNCTION r705_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group07",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r705_chklegal(l_legal,n)
DEFINE l_legal  LIKE azw_file.azw02
DEFINE l_idx,n  LIKE type_file.num5

   FOR l_idx = 1 TO n
       IF m_legal[l_idx]! = l_legal THEN
          LET g_errno = 'axc-600'
          RETURN 0
       END IF
   END FOR
   RETURN 1
END FUNCTION
#FUN-A70084--add--end
