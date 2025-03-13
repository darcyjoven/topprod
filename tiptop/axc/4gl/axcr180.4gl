# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axcr180.4gl
# Descriptions...: 呆料分析表
# Input parameter: 
# Return code....: 
# Date & Author..: 98/05/11 By Star
# Modify.........: No.MOD-530181 05/03/21 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.MOD-590453 05/09/28 By Sarah 將total1,2,3,4改為DEFINE DECIMAL(20,6),調整報表出表位置
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-640527 06/04/21 By Claire MIN()->MAX()
# Modify.........: No.MOD-650107 06/05/26 By Claire 只考慮sr.imk09=0不考慮期末金額sr.ccc92
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660126 06/07/24 By rainy remove s_chknplt
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤;修正FUN-680122改錯部分
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: NO.MOD-720042 07/02/14 By TSD.Sideny 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/04/02 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.FUN-7B0012 07/11/07 By Carrier db分隔符,call s_dbstring()處理
# Modify.........: No.FUN-7C0101 08/01/29 By Cockroach 增加tm.type和報表條件打印ccc08字段
# Modify.........: No.CHI-830025 08/03/24 By kim 修正s_dbstring用法
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850132 08/05/23 By lutingting建臨時表索引更改和打印報表sql更改
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.MOD-880078 08/08/12 By Pengu 呆滯天數只設定一組時報表列印會出現公式錯誤訊息
# Modify.........: No.MOD-8B0229 08/12/04 By Pengu 抓取ima021欄位時並未考慮營運中心
# Modify.........: No.CHI-8B0021 08/12/18 By jan 調整呆滯日其計算的基準日
# Modify.........: No.MOD-940185 09/04/14 By lutingting調整axcr180_temp中字段ima02,ima021得寬度,比照p_zta中得長度
# Modify.........: No.FUN-940102 09/04/24 BY destiny 檢查使用者的資料庫使用權限
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/20 By chenls r180_foreach(l_dbs_new)  改成 傳入l_azp01
#                                                   r180_foreach()中 的跨DB語法改成 cl_get_target_table( plant,table )
#                                                   , 且 prepare 前 CALL cl_parse_qry_sql
# Modify.........: No.FUN-9C0073 10/01/26 By chenls 程序精簡
# Modify.........: No:MOD-A30176 10/03/30 By Summer 應將cca_c1抓到的值先導到另外的變數去,確定有抓到值時,才將資料再給到sr1.*
# Modify.........: No:TQC-A40139 10/05/06 By Carrier MOD-9A0092 追单
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模组table重新分类
# Modify.........: No.FUN-A70084 10/07/26 By lutingting GP5.2報表修改 AXC營運中心欄位統一為兩排,各四個,共計8個,本作業拿掉PLANT_9
# Modify.........: No:MOD-B30726 11/03/31 By sabrina 在FETCH cca_c1前清空sr2的record資料
# Modify.........: No:MOD-B40065 11/04/11 By sabrina 變更r180_foreach()變數定義
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:MOD-BC0040 11/12/19 By ck2yuan 調整呆滯天數起迄的判斷
# Modify.........: No.TQC-BB0182 12/01/11 By pauline 取消過濾plant條件
# Modify.........: No:MOD-C20183 12/02/24 By ck2yuan 若sr.delay<0 應視為0天
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26
# Modify.........: No:MOD-D40147 13/04/19 By bart 原抓ima902改抓ima9021

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
              wc            STRING,             # Where Condition #TQC-630166
              p1            LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)      # 工廠別編號
              p2            LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)       # 工廠別編號
              p3            LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)         # 工廠別編號
              p4            LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)      # 工廠別編號
              p5            LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)           # 工廠別編號
              p6            LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)          # 工廠別編號
              p7            LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)          # 工廠別編號
              p8            LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)           # 工廠別編號
             #p9            LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)           # 工廠別編號    #FUN-A70084
              s_date        LIKE type_file.dat,            #No.FUN-680122DATE             # 比較基準日
              a             LIKE type_file.chr1,           #No.FUN-680122CHAR(01)           # 排列順序
              b             LIKE type_file.chr1,           #No.FUN-680122CHAR(01)           # 是否產生呆滯料檔(N/Y)
              e             LIKE type_file.num10,          #No.FUN-680122INTEGER           # 呆滯天數起始天數
              i             LIKE type_file.num10,          #No.FUN-680122INTEGER           # 呆滯天數截止天數
              x1            LIKE gec_file.gec04,           #No.FUN-680122DECIMAL(5,2)       # 提列比率
              k             LIKE type_file.num10,          #No.FUN-680122INTEGER          # 呆滯天數起始天數
              l             LIKE type_file.num10,          #No.FUN-680122INTEGER            # 呆滯天數截止天數
              x2            LIKE gec_file.gec04,           #No.FUN-680122DECIMAL(5,2)       # 提列比率
              o             LIKE type_file.num10,          #No.FUN-680122INTEGER            # 呆滯天數起始天數
              p             LIKE type_file.num10,          #No.FUN-680122INTEGER           # 呆滯天數截止天數
              x3            LIKE gec_file.gec04,           #No.FUN-680122DECIMAL(5,2)       # 提列比率
              q             LIKE type_file.num10,          #No.FUN-680122INTEGER            # 呆滯天數起始天數
              r             LIKE type_file.num10,          #No.FUN-680122INTEGER            # 呆滯天數截止天數
              x4            LIKE gec_file.gec04,           #No.FUN-680122DECIMAL(5,2)       # 提列比率 #TQC-840066
              more  LIKE type_file.chr1,           #No.FUN-680122CHAR(01)                    # 特殊列印條件
              type  LIKE type_file.chr1            #No.FUN-7C0101 #特殊列印條件 
	      END RECORD,
          m_ccc92            LIKE ccc_file.ccc92,
          l_name     LIKE type_file.chr20,         #No.FUN-680122CHAR(20)		# External(Disk) file name
          tab_name     LIKE type_file.chr20,         #No.FUN-680122CHAR(20)		# External(Disk) file name
          l_plant array[10] of LIKE cre_file.cre08,           #No.FUN-680122char(10)
          m_dash   LIKE type_file.chr1000,       #No.FUN-680122CHAR(400)
          m_dash1  LIKE type_file.chr1000,       #No.FUN-680122CHAR(400)
          m_ctj27  LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6)
          a1 LIKE nma_file.nma01,           #No.FUN-680122char(11)
          a2 LIKE oea_file.oea01,           #No.FUN-680122char(14)
          a3,a4,a5,a6,a7 LIKE cre_file.cre08            #No.FUN-680122char(8) #TQC-840066
         #g_x ARRAY[30] OF LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(40)		# Report Heading & prompt   #MOD-590453 mark
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
#DEFINE   g_len           LIKE type_file.num5           #No.FUN-680122 SMALLINT  #Report width(79/132/136)   #MOD-590453 mark
#DEFINE   g_pageno        LIKE type_file.num5           #No.FUN-680122 SMALLINT  #Report page no             #MOD-590453 mark
#DEFINE   g_zz05          LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)   #Print tm.wc ?(Y/N)         #MOD-590453 mark
DEFINE l_table    STRING #NO.MOD-720042 07/02/14 By TSD.Sideny
DEFINE g_sql      STRING #NO.MOD-720042 07/02/14 By TSD.Sideny
DEFINE g_str      STRING #NO.MOD-720042 07/02/14 By TSD.Sideny
DEFINE m_legal           ARRAY[10] OF LIKE azw_file.azw02   #FUN-A70084 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
  ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "ima01.ima_file.ima01,", 
               "imk09.imk_file.imk09,",
               "ccc92.ccc_file.ccc92,",
               "d_date.type_file.dat,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ccc08.ccc_file.ccc08,",       #FUN-7C0101 ADD 
               "unt_price.ccc_file.ccc23,",
               #"delay.cqg_file.cqg06,",   #TQC-B90211
               "delay.type_file.num15_3,",   #TQC-B90211
               "total1.ccc_file.ccc92,",
               "total2.ccc_file.ccc92,",
               "total3.ccc_file.ccc92,",
               "total4.ccc_file.ccc92,",
               "unt.cck_file.cck06,",
               "ccz27.ccz_file.ccz27,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05"
 
   LET l_table = cl_prt_temptable('axcr180',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.p1 = ARG_VAL(8)
   LET tm.p2 = ARG_VAL(9)
   LET tm.p3 = ARG_VAL(10)
   LET tm.p4 = ARG_VAL(11)
   LET tm.p5 = ARG_VAL(12)
   LET tm.p6 = ARG_VAL(13)
   LET tm.p7 = ARG_VAL(14)
   LET tm.p8 = ARG_VAL(15)
#FUN-A70084--mod--str--拿掉tm.p9
#  LET tm.p9 = ARG_VAL(16)
#  LET tm.s_date  = ARG_VAL(17)
#  LET tm.a     = ARG_VAL(18)
#  LET tm.b     = ARG_VAL(19)
#  LET tm.e     = ARG_VAL(20)
#  LET tm.i     = ARG_VAL(21)
#  LET tm.k     = ARG_VAL(22)
#  LET tm.l     = ARG_VAL(23)
#  LET tm.o     = ARG_VAL(24)
#  LET tm.p     = ARG_VAL(25)
#  LET tm.q     = ARG_VAL(26)
#  LET tm.r     = ARG_VAL(27)
#  LET tm.x1    = ARG_VAL(28)
#  LET tm.x2    = ARG_VAL(29)
#  LET tm.x3    = ARG_VAL(30)
#  LET tm.x4    = ARG_VAL(31)
#  LET tm.type  = ARG_VAL(35)   #FUN-7C0101 ADD 
#  LET g_rep_user = ARG_VAL(32)
#  LET g_rep_clas = ARG_VAL(33)
#  LET g_template = ARG_VAL(34)
#  LET g_rpt_name = ARG_VAL(35)  #No.FUN-7C0078
   LET tm.s_date  = ARG_VAL(16)
   LET tm.a     = ARG_VAL(17)
   LET tm.b     = ARG_VAL(18)
   LET tm.e     = ARG_VAL(19)
   LET tm.i     = ARG_VAL(20)
   LET tm.k     = ARG_VAL(21)
   LET tm.l     = ARG_VAL(22)
   LET tm.o     = ARG_VAL(23)
   LET tm.p     = ARG_VAL(24)
   LET tm.q     = ARG_VAL(25)
   LET tm.r     = ARG_VAL(26)
   LET tm.x1    = ARG_VAL(27)
   LET tm.x2    = ARG_VAL(28)
   LET tm.x3    = ARG_VAL(29)
   LET tm.x4    = ARG_VAL(30)
   LET g_rep_user = ARG_VAL(31)
   LET g_rep_clas = ARG_VAL(32)
   LET g_template = ARG_VAL(33)
   LET g_rpt_name = ARG_VAL(34) 
   LET tm.type  = ARG_VAL(35)  
#FUN-A70084--mod--end
   DROP TABLE axcr180_temp
#No.FUN-A10098 ----mark start
#    CREATE TEMP TABLE axcr180_temp
#    (
#    ima01   VARCHAR(40),           {料號  #FUN-560011}
#    imk09   DEC(15,3),          {庫存數量}  
#    d_date  DATE,               {last date                           }
#    ccc92   dec(20,6) not null, {本月投入金額                        }
#    ccc91   dec(15,3) not null, {本月投入數量                        }
#   #----------No.MOD-8B0229 modify
#    #MOD-940185---begin--                                                                                                           
#    #ima02   VARCHAR(60),          {品名      #FUN-560011    }                                                                         
#    #ima021  VARCHAR(60),          {規格                     }                                                                         
#    ima02   VARCHAR(120),          {品名                     }                                                                         
#    ima021  VARCHAR(120),          {規格                     }                                                                         
#    #MOD-940185---end 
#   #----------No.MOD-8B0229 end
#    ccc08   VARCHAR(40)          );{類別編號  #FUN-7C0101 ADD           }
#No.FUN-A10098 ----mark end

#No.FUN-A10098 ----add start
    CREATE TEMP TABLE axcr180_temp(
    ima01   LIKE type_file.chr50,           {料號  #FUN-560011}
    imk09   LIKE type_file.num20_6,          {庫存數量}
    d_date  LIKE type_file.dat,               {last date                           }
    ccc92   LIKE type_file.num20_6 not null, {本月投入金額                        }
    ccc91   LIKE type_file.num20_6 not null, {本月投入數量                        }
    ima02   LIKE type_file.chr200,          {品名                     }
    ima021  LIKE type_file.chr200,          {規格                     }
    ccc08   LIKE type_file.chr50);{類別編號  #FUN-7C0101 ADD           }
#No.FUN-A10098 ----add end
 
   #create unique index axcr180_01 on axcr180temp (ima01);   #No.FUN-850132
   create unique index axcr180_01 on axcr180_temp (ima01);    #No.FUN-850132
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r180_tm(0,0)        		# Input print condition
      ELSE CALL r180()             
   END IF
   DROP TABLE axcr180_temp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r180_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_flag    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_count   LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_cmd		LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
   DEFINE l_cnt         LIKE type_file.num5          #No.FUN-A70084 

   IF p_row = 0 THEN LET p_row = 3 LET p_col = 9 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 9 
   END IF
   OPEN WINDOW r180_w AT p_row,p_col
        WITH FORM "axc/42f/axcr180" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   CALL r180_set_visible() RETURNING l_cnt    #FUN-A70084
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.s_date   = g_today
   LET tm.a      = '1'
   LET tm.b      = 'N'
   LET tm.type   = g_ccz.ccz28                  #FUN-7C0101 ADD  
   LET tm.more   = 'N'
   LET tm.x1     = 0
   LET tm.x2     = 0
   LET tm.x3     = 0
   LET tm.x4     = 0
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON ima12,ima01
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
     ON ACTION CONTROLP                                                      
        IF INFIELD(ima01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ima01                             
           NEXT FIELD ima01                                                 
        END IF                                                              
 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      
   LET tm.e=90  LET tm.i=179
   LET tm.k=180 LET tm.l=365
   LET tm.o=366 LET tm.p=999
   LET tm.x1=20 LET tm.x2=40 LET tm.x3=80
   DISPLAY BY NAME
        #tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.p9,   #FUN-A70084
         tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,         #FUN-A70084
         tm.s_date,tm.a,tm.type,tm.b,tm.e,tm.i,tm.x1,  #FUN-7C0101 ADD tm.type
         tm.k,tm.l,tm.x2,
         tm.o,tm.p,tm.x3,
         tm.q,tm.r,tm.x4,tm.more 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r180_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   IF tm.wc =  " 1=1" THEN
      CALL cl_err('','9046',0)
      CONTINUE WHILE
   END IF
   
 
  #INPUT tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,tm.p9,    #FUN-A70084
   INPUT tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,          #FUN-A70084
         tm.s_date,tm.a,tm.type,tm.b,tm.e,tm.i,tm.x1,     #FUN-7C0101 ADD tm.type      
         tm.k,tm.l,tm.x2,
         tm.o,tm.p,tm.x3,
         tm.q,tm.r,tm.x4,tm.more WITHOUT DEFAULTS FROM
        #p1,p2,p3,p4,p5,p6,p7,p8,p9,s_date,a,type,b,e,i,x1,  #FUN-7C0101 ADD type  #FUN-A70084
         p1,p2,p3,p4,p5,p6,p7,p8,s_date,a,type,b,e,i,x1,  #FUN-A70084
         k,l,x2,o,p,x3,q,r,x4,more 
 
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
      BEFORE FIELD p1
          LET tm.p1 = g_plant
          DISPLAY tm.p1 TO FORMONLY.p1 
          IF g_multpl= 'N' THEN             # 不為多工廠環境
             LET tm.p1 = g_plant
             LET g_plant_new = NULL
             LET g_dbs_new   = NULL
             CALL r180_chk() returning l_count  #bug no.2777
             DISPLAY tm.p1 TO FORMONLY.p1 
             NEXT FIELD s_date              #不可輸入工廠欄位
          END IF
 
      AFTER FIELD p1
         IF NOT cl_null(tm.p1) THEN
            IF NOT r180_chkplant(tm.p1) THEN
               CALL cl_err(tm.p1,g_errno,0)
               NEXT FIELD p1
            END IF
            IF NOT s_chk_demo(g_user,tm.p1) THEN              
               NEXT FIELD p1          
            END IF            
            SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.p1   #FUN-A70084
         END IF
 
        
      AFTER FIELD p2
         IF NOT cl_null(tm.p2) THEN
            IF NOT r180_chkplant(tm.p2) THEN
               CALL cl_err(tm.p2,g_errno,0)
               NEXT FIELD p2
            END IF
            IF NOT s_chk_demo(g_user,tm.p2) THEN              
               NEXT FIELD p2          
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.p2   #FUN-A70084
            IF NOT r180_chklegal(m_legal[2],1) THEN
               CALL cl_err(tm.p2,g_errno,0)
               NEXT FIELD p2
            END IF
            #FUN-A70084--add--end
         END IF
         CALL r180_chk() returning l_count
         IF l_count>0 THEN NEXT FIELD  p2 END IF
 
      AFTER FIELD p3
         IF NOT cl_null(tm.p3) THEN
            IF NOT r180_chkplant(tm.p3) THEN
               CALL cl_err(tm.p3,g_errno,0)
               NEXT FIELD p3
            END IF
            IF NOT s_chk_demo(g_user,tm.p3) THEN              
               NEXT FIELD p3          
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.p3   #FUN-A70084
            IF NOT r180_chklegal(m_legal[3],2) THEN
               CALL cl_err(tm.p3,g_errno,0)
               NEXT FIELD p3
            END IF
            #FUN-A70084--add--end
         END IF
         CALL r180_chk() returning l_count
         IF l_count>0 THEN NEXT FIELD  p3 END IF
 
      AFTER FIELD p4
         IF NOT cl_null(tm.p4) THEN
            IF NOT r180_chkplant(tm.p4) THEN
               CALL cl_err(tm.p4,g_errno,0)
               NEXT FIELD p4
            END IF
            IF NOT s_chk_demo(g_user,tm.p4) THEN              
               NEXT FIELD p4          
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.p4   #FUN-A70084
            IF NOT r180_chklegal(m_legal[4],3) THEN
               CALL cl_err(tm.p4,g_errno,0)
               NEXT FIELD p4
            END IF
            #FUN-A70084--add--end
         END IF
         CALL r180_chk() returning l_count
         IF l_count>0 THEN NEXT FIELD  p4 END IF 
 
     AFTER FIELD p5
         IF NOT cl_null(tm.p5) THEN
            IF NOT r180_chkplant(tm.p5) THEN
               CALL cl_err(tm.p5,g_errno,0)
               NEXT FIELD p5
            END IF
            IF NOT s_chk_demo(g_user,tm.p5) THEN              
               NEXT FIELD p5          
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.p5   #FUN-A70084
            IF NOT r180_chklegal(m_legal[5],4) THEN
               CALL cl_err(tm.p5,g_errno,0)
               NEXT FIELD p5
            END IF
            #FUN-A70084--add--end
         END IF
         CALL r180_chk() returning l_count
         IF l_count>0 THEN NEXT FIELD  p5 END IF 
 
      AFTER FIELD p6
         IF NOT cl_null(tm.p6) THEN
            IF NOT r180_chkplant(tm.p6) THEN
               CALL cl_err(tm.p6,g_errno,0)
               NEXT FIELD p6
            END IF
            IF NOT s_chk_demo(g_user,tm.p6) THEN              
               NEXT FIELD p6          
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.p6   #FUN-A70084
            IF NOT r180_chklegal(m_legal[6],5) THEN
               CALL cl_err(tm.p6,g_errno,0)
               NEXT FIELD p6
            END IF
            #FUN-A70084--add--end
         END IF
 
         CALL r180_chk() returning l_count
         IF l_count>0 THEN NEXT FIELD  p6 END IF 
 
      AFTER FIELD p7
         IF NOT cl_null(tm.p7) THEN
            IF NOT r180_chkplant(tm.p7) THEN
               CALL cl_err(tm.p7,g_errno,0)
               NEXT FIELD p7
            END IF
            IF NOT s_chk_demo(g_user,tm.p7) THEN              
               NEXT FIELD p7          
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.p7   #FUN-A70084
            IF NOT r180_chklegal(m_legal[7],6) THEN
               CALL cl_err(tm.p7,g_errno,0)
               NEXT FIELD p7
            END IF
            #FUN-A70084--add--end
         END IF
 
         CALL r180_chk() returning l_count
         IF l_count>0 THEN NEXT FIELD  p7 END IF 
 
      AFTER FIELD p8
         IF NOT cl_null(tm.p8) THEN
            IF NOT r180_chkplant(tm.p8) THEN
               CALL cl_err(tm.p8,g_errno,0)
               NEXT FIELD p8
            END IF
            IF NOT s_chk_demo(g_user,tm.p8) THEN              
               NEXT FIELD p8          
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.p8   #FUN-A70084
            IF NOT r180_chklegal(m_legal[8],7) THEN
               CALL cl_err(tm.p8,g_errno,0)
               NEXT FIELD p8
            END IF
            #FUN-A70084--add--end
         END IF
            
         CALL r180_chk() returning l_count
         IF l_count>0 THEN NEXT FIELD  p8 END IF 
 
     #FUN-A70084--mark--str--
     #AFTER FIELD p9
     #   IF NOT cl_null(tm.p9) THEN
     #      IF NOT r180_chkplant(tm.p9) THEN
     #         CALL cl_err(tm.p9,g_errno,0)
     #         NEXT FIELD p9
     #      END IF
     #      IF NOT s_chk_demo(g_user,tm.p9) THEN              
     #         NEXT FIELD p9          
     #      END IF            
     #   END IF
     #   CALL r180_chk() returning l_count
     #   IF l_count>0 THEN NEXT FIELD  p9 END IF 
     #FUN-A70084--mark--end
 
      AFTER FIELD s_date
# genero  script marked          IF cl_ku() AND g_multpl='N' THEN NEXT FIELD s_date END IF
         IF cl_null(tm.s_date) THEN NEXT FIELD s_date END IF
 
      AFTER FIELD a    #排列順序
         IF tm.a IS NULL  OR tm.a NOT MATCHES  '[12]' THEN
            NEXT FIELD a
         END IF
 
      AFTER FIELD type
         IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type
         END IF
   
      AFTER FIELD b    #排列順序
         IF tm.b IS NULL  OR tm.b NOT MATCHES  '[YN]' THEN
            NEXT FIELD b
         END IF
 
 
      AFTER FIELD e    #起始呆滯天數
         IF tm.e IS NULL THEN
            NEXT FIELD e
         END IF
 
      AFTER FIELD i    #截止呆滯天數
         IF NOT cl_null(tm.e)  AND cl_null(tm.i) THEN 
            NEXT FIELD i
         END IF
         IF tm.i < tm.e THEN NEXT FIELD i END IF
 
      AFTER FIELD x1     #提列比率
         IF NOT cl_null(tm.e) AND NOT cl_null(tm.i) THEN
            IF cl_null(tm.x1) OR tm.x1 <= 0 OR tm.x1 > 100 THEN
               NEXT FIELD x1
            END IF
         END IF
 
      BEFORE FIELD k
         LET tm.k=tm.i+1
         DISPLAY tm.k TO k
 
 
      AFTER FIELD l    #截止呆滯天數
         IF NOT cl_null(tm.k)  AND  cl_null(tm.l) THEN 
            NEXT FIELD l
         END IF
         IF tm.l < tm.k THEN NEXT FIELD k END IF
 
 
      AFTER FIELD x2      #提列比率
         IF NOT cl_null(tm.k) AND NOT cl_null(tm.l) THEN
            IF cl_null(tm.x2) OR tm.x2 <= 0 OR tm.x2 > 100 THEN 
               NEXT FIELD x2
            END IF
         END IF
 
      BEFORE FIELD o
         LET tm.o=tm.l+1
         DISPLAY tm.o TO o
 
 
      AFTER FIELD p    #截止呆滯天數
         IF NOT cl_null(tm.o)  AND  cl_null(tm.p) THEN 
            NEXT FIELD p
         END IF
         IF tm.p < tm.o THEN NEXT FIELD p END IF
 
      AFTER FIELD x3     #提列比率
         IF NOT cl_null(tm.o) AND NOT cl_null(tm.p) THEN
            IF cl_null(tm.x3) OR tm.x3 <= 0 OR tm.x3 > 100 THEN
               NEXT FIELD x3
            END IF
         END IF
 
      BEFORE FIELD q
         LET tm.q=tm.p+1
         DISPLAY tm.q TO q
 
 
      AFTER FIELD r    #截止呆滯天數
         IF NOT cl_null(tm.q)  AND  cl_null(tm.r) THEN 
            NEXT FIELD r
         END IF
         IF tm.r < tm.q THEN NEXT FIELD r END IF
 
      AFTER FIELD x4     #提列比率
         IF NOT cl_null(tm.q) AND NOT cl_null(tm.r) THEN
            IF cl_null(tm.x4) OR tm.x4 <= 0 OR tm.x4 > 100 THEN
               NEXT FIELD x4
            END IF
         END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
     #------------------------No:TQC-A40139 add
      AFTER INPUT
         IF l_plant[1] IS NULL THEN  
            CALL r180_chk() returning l_count
            IF l_count>0 THEN NEXT FIELD p1 END IF
         END IF
     #------------------------No:TQC-A40139 end
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         ON ACTION qbe_save
            CALL cl_qbe_save()
       ON ACTION CONTROLP
          CASE
            WHEN INFIELD(p1)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
              LET g_qryparam.arg1 = g_user                #No.FUN-940102
              LET g_qryparam.default1 = tm.p1
              CALL cl_create_qry() RETURNING tm.p1
              DISPLAY BY NAME tm.p1
              NEXT FIELD p1
 
            WHEN INFIELD(p2)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
              LET g_qryparam.arg1 = g_user                #No.FUN-940102
              LET g_qryparam.default1 = tm.p2
              CALL cl_create_qry() RETURNING tm.p2
              DISPLAY BY NAME tm.p2
              NEXT FIELD p2
 
            WHEN INFIELD(p3)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
              LET g_qryparam.arg1 = g_user                #No.FUN-940102
              LET g_qryparam.default1 = tm.p3
              CALL cl_create_qry() RETURNING tm.p3
              DISPLAY BY NAME tm.p3
              NEXT FIELD p3
 
            WHEN INFIELD(p4)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
              LET g_qryparam.arg1 = g_user                #No.FUN-940102
              LET g_qryparam.default1 = tm.p4
              CALL cl_create_qry() RETURNING tm.p4
              DISPLAY BY NAME tm.p4
              NEXT FIELD p4
 
            WHEN INFIELD(p5)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
              LET g_qryparam.arg1 = g_user                #No.FUN-940102
              LET g_qryparam.default1 = tm.p5
              CALL cl_create_qry() RETURNING tm.p5
              DISPLAY BY NAME tm.p5
              NEXT FIELD p5
 
            WHEN INFIELD(p6)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
              LET g_qryparam.arg1 = g_user                #No.FUN-940102
              LET g_qryparam.default1 = tm.p6
              CALL cl_create_qry() RETURNING tm.p6
              DISPLAY BY NAME tm.p6
              NEXT FIELD p6
 
            WHEN INFIELD(p7)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
              LET g_qryparam.arg1 = g_user                #No.FUN-940102
              LET g_qryparam.default1 = tm.p7
              CALL cl_create_qry() RETURNING tm.p7
              DISPLAY BY NAME tm.p7
              NEXT FIELD p7
 
            WHEN INFIELD(p8)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_zxy"               #No.FUN-940102
              LET g_qryparam.arg1 = g_user                #No.FUN-940102
              LET g_qryparam.default1 = tm.p8
              CALL cl_create_qry() RETURNING tm.p8
              DISPLAY BY NAME tm.p8
              NEXT FIELD p8
 
           #FUN-A70084--mark--str--
           #WHEN INFIELD(p9)
           #  CALL cl_init_qry_var()
           #  LET g_qryparam.form = "q_zxy"               #No.FUN-940102
           #  LET g_qryparam.arg1 = g_user                #No.FUN-940102
           #  LET g_qryparam.default1 = tm.p9
           #  CALL cl_create_qry() RETURNING tm.p9
           #  DISPLAY BY NAME tm.p9
           #  NEXT FIELD p9
           #FUN-A70084--mark--end
 
          OTHERWISE EXIT CASE
          END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
     
     ON ACTION about         
        CALL cl_about()      
     
     ON ACTION help          
        CALL cl_show_help()  
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r180_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='axcr180'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr180','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '", tm.p1 CLIPPED,"'" ,
                         " '", tm.p2 CLIPPED,"'" ,
                         " '", tm.p3 CLIPPED,"'" ,
                         " '", tm.p4 CLIPPED,"'" ,
                         " '", tm.p5 CLIPPED,"'" ,
                         " '", tm.p6 CLIPPED,"'" ,
                         " '", tm.p7 CLIPPED,"'" ,
                         " '", tm.p8 CLIPPED,"'" ,
                        #" '", tm.p9 CLIPPED,"'" ,     #FUN-A70084
                         " '", tm.s_date CLIPPED,"'" ,
                         " '", tm.a  CLIPPED,"'" ,
                        #" '", tm.type CLIPPED,"'" ,   #FUN-7C0101 ADD   #FUN-A70084
                         " '", tm.b  CLIPPED,"'" ,
                         " '", tm.e  CLIPPED,"'" ,
                         " '", tm.i  CLIPPED,"'" ,
                         " '", tm.k  CLIPPED,"'" ,
                         " '", tm.l  CLIPPED,"'" ,
                         " '", tm.o  CLIPPED,"'" ,
                         " '", tm.p  CLIPPED,"'" ,
                         " '", tm.q  CLIPPED,"'" ,
                         " '", tm.r  CLIPPED,"'" ,
                         " '", tm.x1 CLIPPED,"'" ,
                         " '", tm.x2 CLIPPED,"'" ,
                         " '", tm.x3 CLIPPED,"'" ,
                         " '", tm.x4 CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '", tm.type CLIPPED,"'"    #FUN-A70084
         CALL cl_cmdat('axcr180',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r180_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r180()
   ERROR ""
END WHILE
CLOSE WINDOW r180_w
END FUNCTION
 
FUNCTION r180_chk()
DEFINE i,j,l_count LIKE type_file.num5           #No.FUN-680122 SMALLINT
 LET  l_plant[1]=tm.p1
 LET  l_plant[2]=tm.p2
 LET  l_plant[3]=tm.p3
 LET  l_plant[4]=tm.p4
 LET  l_plant[5]=tm.p5
 LET  l_plant[6]=tm.p6
 LET  l_plant[7]=tm.p7
 LET  l_plant[8]=tm.p8
#LET  l_plant[9]=tm.p9   #FUN-A70084
      #FOR i=1 to 9    #FUN-A70084
       FOR i=1 to 8    #FUN-A70084
           let l_count=0
          #FOR j=1 to 9   #FUN-A70084 
           FOR j=1 to 8   #FUN-A70084
              IF  l_plant[i]=l_plant[j]  THEN LET l_count=l_count+1 END IF
           END FOR
           IF l_count>1 THEN
              CALL cl_err(l_plant[i],'aom-492',0)
                    EXIT FOR
           END IF
       END FOR
       IF l_count>1 THEN RETURN l_count END IF
 
       LET l_count=0
      #FOR i=1 to 9   #FUN-A70084
       FOR i=1 to 8   #FUN-A70084
       IF cl_null(l_plant[i]) then let l_count=l_count+1 END IF
       END FOR
      #IF l_count=9 THEN CALL cl_err('plant','aom-423',0)   #FUN-A70084
       IF l_count=8 THEN CALL cl_err('plant','aom-423',0)   #FUN-A70084
          RETURN l_count
       END IF
  RETURN 0
END FUNCTION 
 
FUNCTION r180()
   DEFINE 
          l_sql      LIKE type_file.chr1000,		# RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
	  l_date     LIKE type_file.dat,           #No.FUN-680122DATE
          sr         RECORD
                     ima01    LIKE  ima_file.ima01, #料件編號
                     imk09    LIKE  imk_file.imk09, #庫存數量
                     ccc92    LIKE  ccc_file.ccc92, #期未成本 
                     d_date   LIKE type_file.dat,           #No.FUN-680122 DATE            #最後異動日期
                     ima02    LIKE  ima_file.ima02, #品名
                     ima021   LIKE  ima_file.ima021,#規格   #No.MOD-8B0229 add
                     ccc08    LIKE  ccc_file.ccc08,  #類別編號 #FUN-7C0101 ADD  
                     unt_price LIKE ccc_file.ccc23, #單位成本
                     delay    LIKE type_file.num15_3,   #LIKE cqg_file.cqg06,     #No.FUN-680122 DECIMAL(8,0)        #呆滯天數   #TQC-B90211
                     total1   LIKE ccc_file.ccc92,     #No.FUN-680122DECIMAL(20,6)
                     total2   LIKE ccc_file.ccc92,     #No.FUN-680122DECIMAL(20,6)
                     total3   LIKE ccc_file.ccc92,     #No.FUN-680122DECIMAL(20,6)
                     total4   LIKE ccc_file.ccc92      #No.FUN-680122DECIMAL(20,6)
                     END RECORD,
           l_ccc91   LIKE ccc_file.ccc91,
           l_ccc92   LIKE ccc_file.ccc92,
           l_azp03   LIKE type_file.chr21,       #No.FUN-680122 VARCHAR(21)   #No.TQC-6A0078
           i         LIKE type_file.num5,          #No.FUN-680122 SMALLINT
           l_flag    LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
DEFINE l_ima021  LIKE ima_file.ima021  #NO.MOD-720042 07/02/14 By TSD.Sideny
DEFINE l_unt     LIKE cck_file.cck06   #NO.MOD-720042 07/02/14 By TSD.Sideny
 
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720042 add
 
     LET m_ccc92 = 0
     DELETE FROM axcr180_temp
    #FOR i=1 TO 9    #FUN-A70084
     FOR i=1 TO 8    #FUN-A70084
        IF NOT cl_null(l_plant[i]) THEN 
          #FUN-A70084--mark--str--
          #SELECT azp03 INTO l_azp03 FROM azp_file 
          #                          WHERE  azp01=l_plant[i]
          #IF SQLCA.SQLCODE THEN CONTINUE FOR END IF
          #LET l_azp03=s_dbstring(l_azp03) #CHI-830025
          #FUN-A70084--mark--end
           CALL r180_foreach(l_plant[i])                 #No.FUN-A10098 ----add
        END IF
     END FOR
 
     # 假設 同一料件的單位相同
     LET l_sql="SELECT ima01,sum(imk09),sum(ccc92), ",
               "       max(d_date),max(ima02),max(ima021),ccc08, ",
               "       0,0,0,0,0,0  ",
               "  FROM axcr180_temp",
               " GROUP BY ima01,ccc08 "   #No.FUN-850132
 
     #排列順序: (1).依料件編號 (2).依庫存金額
     IF tm.a='1' THEN 
        LET l_sql=l_sql CLIPPED," ORDER BY 1 "
     ELSE
        LET l_sql=l_sql CLIPPED," ORDER BY 3 DESC "
     END IF
 
     PREPARE tmp_pre FROM l_sql
     DECLARE tmp_cl CURSOR FOR tmp_pre
 
 
     #是否產生呆滯料檔(N/Y):[b]
     IF tm.b matches '[Yy]' THEN DELETE FROM ccq_file END IF
 
     LET g_pageno = 0
     FOREACH tmp_cl INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       IF sr.imk09 != 0 THEN
          LET sr.unt_price=sr.ccc92/sr.imk09
       END IF
       IF sr.imk09 =0 THEN CONTINUE FOREACH END IF         #MOD-650107
       IF cl_null(sr.unt_price) THEN LET sr.unt_price=0 END IF
       IF cl_null(sr.d_date) THEN LET sr.d_date='01/01/01' END IF
       LET sr.delay=(tm.s_date-sr.d_date)
       #MOD-C20183 add----
       #基準日之後異動的庫存
       IF sr.delay < 0 THEN
          LET sr.delay = 0
       END IF
       #MOD-C20183 add----
       IF sr.delay >= tm.e AND sr.delay <= tm.i  THEN
          LET sr.total1=sr.ccc92
       END IF
       IF sr.delay >= tm.k AND sr.delay <= tm.l  THEN
          LET sr.total2=sr.ccc92
       END IF
       IF sr.delay >= tm.o AND sr.delay <= tm.p  THEN
          LET sr.total3=sr.ccc92
       END IF
       IF sr.delay >= tm.q AND sr.delay <= tm.r  THEN
          LET sr.total4=sr.ccc92
       END IF
       IF cl_null(sr.total1) THEN LET sr.total1=0 END IF
       IF cl_null(sr.total2) THEN LET sr.total2=0 END IF
       IF cl_null(sr.total3) THEN LET sr.total3=0 END IF
       IF cl_null(sr.total4) THEN LET sr.total4=0 END IF
 
      #IF sr.delay >= tm.e AND sr.delay <= tm.i  OR      #介於天數區間   #MOD-BC0040 mark
      #   sr.delay >= tm.k AND sr.delay <= tm.l  OR                      #MOD-BC0040 mark
      #   sr.delay >= tm.o AND sr.delay <= tm.p  OR                      #MOD-BC0040 mark
      #   sr.delay >= tm.q and sr.delay <= tm.r                          #MOD-BC0040 mark
       IF (sr.delay >= tm.e AND sr.delay <= tm.i) OR                     #MOD-BC0040 add
          (sr.delay >= tm.k AND sr.delay <= tm.l) OR                     #MOD-BC0040 add
          (sr.delay >= tm.o AND sr.delay <= tm.p) OR                     #MOD-BC0040 add
          (sr.delay >= tm.q and sr.delay <= tm.r)                        #MOD-BC0040 add
         THEN  
           IF tm.b MATCHES '[Yy]' THEN 
             INSERT INTO ccq_file(ccq01,ccq02,ccq03,ccq04,ccq05,
                                  ccq06,ccq07,ccq08,ccq09,ccqlegal)   #FUN-A50075 add legal
                        VALUES(sr.ima01,sr.ima02,sr.imk09,sr.ccc92,sr.d_date,
                               'Y',g_today,g_user,sr.delay,g_legal)   #FUN-A50075 add legal
         
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                CALL cl_err3("ins","ccq_file",sr.ima01,"",SQLCA.SQLCODE,"","INSERT ccq_file",1)   #No.FUN-660127
          END IF
         END IF
         MESSAGE 'part+amt-->',sr.ima01,'|',sr.ccc92
         CALL ui.Interface.refresh()
 
         IF sr.imk09 !=0 THEN
            LET l_unt = sr.ccc92 / sr.imk09
         ELSE
            LET l_unt=0 
         END IF
 
         EXECUTE insert_prep USING sr.ima01,sr.imk09,m_ccc92,sr.d_date,
                                   sr.ima02,sr.ima021,sr.ccc08,sr.unt_price,sr.delay,
                                   sr.total1,sr.total2,sr.total3,sr.total4,
                                   #l_unt,g_ccz.ccz27,g_azi03,g_azi04,g_azi05  #CHI-C30012
                                   l_unt,g_ccz.ccz27,g_ccz.ccz26,g_ccz.ccz26,g_ccz.ccz26  #CHI-C30012
 
       END IF
     END FOREACH
 
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ima12,ima01')
             RETURNING tm.wc
        LET g_str = tm.wc
     ELSE
        LET g_str = " "
     END IF
     IF cl_null(tm.x1) THEN LET tm.x1 = 0 END IF
     IF cl_null(tm.x2) THEN LET tm.x2 = 0 END IF
     IF cl_null(tm.x3) THEN LET tm.x3 = 0 END IF
     IF cl_null(tm.x4) THEN LET tm.x4 = 0 END IF
     LET g_str = g_str,";",tm.s_date,";",tm.e,";",tm.i,";",tm.k,";",tm.l,";",
                 tm.o,";", tm.p,";", tm.q,";",tm.r,";",tm.x1,";",tm.x2,";",
                 tm.x3,";",tm.x4
     IF  tm.type MATCHES '[12]' THEN
          CALL cl_prt_cs3('axcr180','axcr180',l_sql,g_str)   #FUN-710080 modify
     ELSE
          CALL cl_prt_cs3('axcr180','axcr180_1',l_sql,g_str)
     END IF 
 
END FUNCTION
 
#FUNCTION r180_foreach(l_dbs_new)   #FUN-A70084
FUNCTION r180_foreach(l_plant_new)  #FUN-A70084 
     DEFINE
           l_datex   LIKE type_file.dat,           #No.FUN-680122 DATE
           sr1       RECORD 

                    #ima01   LIKE type_file.chr20,       #No.FUN-680122 VARCHAR(20),  {料號     }  #MOD-B40065 mark
                     ima01   LIKE ima_file.ima01,        #MOD-B40065 add
                     imk09   LIKE imk_file.imk09,        #No.FUN-680122 DEC(15,3)         {庫存數量 }   #TQC-840066
                     d_date  LIKE type_file.dat,         #No.FUN-680122 DATE              {last date}
                     ccc92   LIKE ccc_file.ccc92,        #No.FUN-680122 dec(20,6)         {期末金額 }
                     ccc91   LIKE ccc_file.ccc91,        #No.FUN-680122 DEC(15,3)         {期末數量 }
                     ima02   LIKE ima_file.ima02,        #No.FUN-680122 VARCHAR(30)          {品名     }
                     ima021  LIKE ima_file.ima021,       #No.MOD-8B0229 add 
                     ccc08   LIKE ccc_file.ccc08         #No.FUN-7C0101 VARCHAR(40)          {類別編號 } 
                     END RECORD,
           sr2       RECORD                          #MOD-A30176 add
                      imk09   LIKE imk_file.imk09,   #{庫存數量 }
                      ccc92   LIKE ccc_file.ccc92,   #{期末金額 }
                      ccc91   LIKE ccc_file.ccc91,   #{期末數量 }
                      ccc08   LIKE ccc_file.ccc08    #{類別編號 }
                     END RECORD,
           l_ima901  LIKE ima_file.ima901,
           l_flag             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
           #l_dbs_new          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(21)   #FUN-A70084
           l_plant_new        LIKE type_file.chr1000,       #FUN-A70084 
           l_year,l_lasty     LIKE type_file.num10,         #No.FUN-680122 INTEGER
           l_mon,l_lastm      LIKE type_file.num5,          #No.FUN-680122 SMALLINT
           l_tlf06            LIKE tlf_file.tlf06,
           l_tlf10            LIKE tlf_file.tlf10,
           l_tlf21            LIKE tlf_file.tlf21,
           l_sql              LIKE type_file.chr1000       #No.FUN-680122CHAR(800)
 
      CALL s_yp(tm.s_date) RETURNING l_year,l_mon
      LET l_lasty = l_year 
      LET l_lastm = l_mon
      LET l_lastm = l_lastm - 1 
      IF l_lastm = 0 THEN LET l_lastm = 12 LET l_lasty = l_lasty - 1 END IF 
      #求庫存量
      #LET l_sql = " SELECT ima01,ccc91,ima902,ccc92,ccc91,ima02,ima021,ccc08,ima901 ", #MOD-D40147
      LET l_sql = " SELECT ima01,ccc91,ima9021,ccc92,ccc91,ima02,ima021,ccc08,ima901 ", #MOD-D40147
#No.FUN-A10098 ---------mark start
#                  " FROM ",l_dbs_new clipped," ima_file,OUTER " 
#                  ,l_dbs_new clipped," ccc_file ",
#                  " WHERE ccc_file.ccc01 = ima_file.ima01 AND ",tm.wc CLIPPED,
#                  " AND   ccc_file.ccc07 = '",tm.type,"'"  #FUN-7C0101
#No.FUN-A10098 ---------mark end
#No.FUN-A10098 ---------add start
                  " FROM ",cl_get_target_table(l_plant_new,'ima_file')," LEFT OUTER JOIN ",   #FUN-A70084 l_dbs_new-->l_plant_new
                  cl_get_target_table(l_plant_new,'ccc_file')," ON ccc01=ima01 ",             #FUN-A70084 l_dbs_new-->l_plant_new
                  " WHERE ",tm.wc CLIPPED,
                  " AND   ccc_file.ccc07 = '",tm.type,"'"  #FUN-7C0101
#No.FUN-A10098 ---------add end 
 
      ### 若基準日期已是月底, 則不須再取異動資料
      IF DAY(tm.s_date + 1) = 1 THEN 
         LET l_sql = l_sql CLIPPED,"   AND ccc_file.ccc02 = ",l_year,
                     "   AND ccc_file.ccc03 = ",l_mon
      ELSE
         LET l_sql = l_sql CLIPPED,"   AND ccc_file.ccc02 = ",l_lasty,
                     "   AND ccc_file.ccc03 = ",l_lastm
      END IF 
       LET l_sql = l_sql CLIPPED," ORDER BY 1 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      #CALL cl_parse_qry_sql(l_sql,l_dbs_new) RETURNING l_sql     #No.FUN-A10098 ---------add   #FUN-A70084 
      #CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql   #FUN-A70084  #TQC-BB0182 mark
       PREPARE ima_pre FROM l_sql
       IF SQLCA.SQLCODE THEN 
          CALL  cl_err('ima_pre',SQLCA.SQLCODE,1)
       END IF
       DECLARE ima_cl CURSOR FOR ima_pre
 
       # 取期初開帳轉本月期初(讀不到沒影響)
       LET l_sql = " SELECT cca11,cca11,cca12,cca07  FROM cca_file ", #FUN-7C0101 ADD cca07
                   "  WHERE cca01= ? ",
                   "  AND cca06 ='",tm.type,"'",   #FUN-7C0101 ADD
                   "  AND cca07= ? "               #MOD-A30176 add 
      IF DAY(tm.s_date + 1) = 1 THEN 
         LET l_sql = l_sql CLIPPED,"   AND cca02 = ",l_year,
                     "   AND cca03 = ",l_mon
      ELSE
         LET l_sql = l_sql CLIPPED,"   AND cca02 = ",l_lasty,
                     "   AND cca03 = ",l_lastm
      END IF 
       PREPARE r180_cca_p1 FROM l_sql
       IF SQLCA.SQLCODE THEN CALL cl_err('r180_cca_p1',SQLCA.SQLCODE,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
          EXIT PROGRAM
       END IF
       DECLARE cca_c1 SCROLL CURSOR FOR r180_cca_p1
 
 
       LET l_sql= "INSERT INTO ",
                  "axcr180_temp(ima01,imk09,d_date,ccc92,ccc91,ima02,ima021,ccc08 )", #FUN-7C0101 ADD ccc08   #No.MOD-8B0229 add ima021
                       "VALUES ( ?    ,?    ,?    ,?    ,?    ,?   ,?   ,?)"       #FUN-7C0101    #No.MOD-8B0229 add ?
       PREPARE r180_ins_p1 FROM l_sql
       IF SQLCA.SQLCODE THEN CALL cl_err('r180_ins_p1',SQLCA.SQLCODE,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
          EXIT PROGRAM
       END IF
 
       LET l_sql = " SELECT MAX(tlf06) ",  #求最後一次出庫日
#No.FUN-A10098 ----mark start
#                   " FROM ",l_dbs_new clipped,"tlf_file, ",
#                            l_dbs_new clipped,"smy_file  ",
#No.FUN-A10098 ----mark end
#No.FUN-A10098 ----add start
                   " FROM ",cl_get_target_table(l_plant_new,'tlf_file'),",", #FUN-A70084 l_dbs_new-->l_plant_new
                   cl_get_target_table(l_plant_new,'smy_file'),              #FUN-A70084 l_dbs_new-->l_plant_new 
#No.FUN-A10098 ----add end
                   " WHERE tlf01 = ? ", 
                   "   AND tlf61 = smyslip",
                   "   AND tlf06 <= '",tm.s_date,"'",
                   "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                   "   AND smy56 = 'Y' ", # 影嚮呆滯日期否 
                   "   AND tlf907= -1  "  # 出/入庫(-1/1)
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      #CALL cl_parse_qry_sql(l_sql,l_dbs_new) RETURNING l_sql                   #FUN-A10098   #FUN-A70084
      #CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql    #FUN-A70084  #TQC-BB0182 mark
       PREPARE r180_tlf_p1 FROM l_sql
       IF SQLCA.SQLCODE THEN CALL cl_err('r180_tlf_p1',SQLCA.SQLCODE,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
          EXIT PROGRAM
       END IF
       DECLARE tlf_c1 SCROLL CURSOR FOR r180_tlf_p1
 
       LET l_sql = " SELECT MAX(tlf06) ",  #求最後一次入庫日
#No.FUN-A10098 ----mark start
#                   " FROM ",l_dbs_new clipped,"tlf_file, ",
#                            l_dbs_new clipped,"smy_file  ",
#No.FUN-A10098 ----mark end
#No.FUN-A10098 ----add start
                   " FROM ",cl_get_target_table(l_plant_new,'tlf_file'),",", #FUN-A70084 l_dbs_new-->l_plant_new
                   cl_get_target_table(l_plant_new,'smy_file'),              #FUN-A70084 l_dbs_new-->l_plant_new
#No.FUN-A10098 ----add end   
                   " WHERE tlf01 = ? ", 
                   "   AND tlf61 = smyslip",
                   "   AND tlf06 <= '",tm.s_date,"'",
                   "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                   "   AND smy56 = 'Y' ", # 影嚮呆滯日期否 
                   "   AND tlf907= 1  "    #出/入庫(-1/1)
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      #CALL cl_parse_qry_sql(l_sql,l_dbs_new) RETURNING l_sql                   #FUN-A10098   #FUN-A70084
      #CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql                 #FUN-A70084  #TQC-BB0182 mark
       PREPARE r180_tlf_p2 FROM l_sql
       IF SQLCA.SQLCODE THEN CALL cl_err('r180_tlf_p2',SQLCA.SQLCODE,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
          EXIT PROGRAM
       END IF
       DECLARE tlf_c2 SCROLL CURSOR FOR r180_tlf_p2
 
       #求異動量
       LET l_datex = MDY(MONTH(tm.s_date),1,YEAR(tm.s_date))
       LET l_sql="SELECT SUM(tlf907*tlf10*tlf60) ",
#No.FUN-A10098 ----mark start
#                 "  FROM ",l_dbs_new clipped,"tlf_file, ",
#                           l_dbs_new clipped,"smy_file ",
#No.FUN-A10098 ----mark end
#No.FUN-A10098 ----add start
                   " FROM ",cl_get_target_table(l_plant_new,'tlf_file'),",",  #FUN-A70084 l_dbs_new-->l_plant_new
                   cl_get_target_table(l_plant_new,'smy_file'), #FUN-A70084 l_dbs_new-->l_plant_new
#No.FUN-A10098 ----add end
                   " WHERE tlf01 = ? ",
                   "   AND tlf61 = smyslip",
                   "   AND smydmy1 = 'Y' ", # 成本計算否 
                   "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
                   "   AND tlf06 BETWEEN '",l_datex, "' AND '", tm.s_date,"' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      #CALL cl_parse_qry_sql(l_sql,l_dbs_new) RETURNING l_sql                   #FUN-A10098   #FUN-A70084
      #CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql                 #FUN-A70084   #TQC-BB0182 mark
       PREPARE r180_tlf_p3 FROM l_sql
       IF SQLCA.SQLCODE THEN CALL cl_err('r180_tlf_p3',SQLCA.SQLCODE,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
          EXIT PROGRAM
       END IF
       DECLARE tlf_c3 SCROLL CURSOR FOR r180_tlf_p3
       #求異動金額
       LET l_sql="SELECT ccc23 ",
#                 "  FROM ",l_dbs_new clipped,"ccc_file ",              #FUN-A10098 ---mark
                   "  FROM ",cl_get_target_table(l_plant_new,'ccc_file'),   #FUN-A10098 ---add   #FUN-A70084 l_dbs_new-->l_plant_new
                   " WHERE ccc01 = ? ",
                   "   AND ccc02 = ",YEAR(tm.s_date),
                   "   AND ccc03= ",MONTH(tm.s_date),
                   "   AND ccc07='",tm.type,"'",      #FUN-7C0101 ADD
                   "   AND ccc08= ? "                 #FUN-7C0101 ADD    
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
        #CALL cl_parse_qry_sql(l_sql,l_dbs_new) RETURNING l_sql                   #FUN-A10098  #FUN-A70084
        #CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql                 #FUN-A70084  #TQC-BB0182 mark
       PREPARE r180_tlf_p4 FROM l_sql
       IF SQLCA.SQLCODE THEN CALL cl_err('r180_tlf_p4',SQLCA.SQLCODE,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
          EXIT PROGRAM
       END IF
       DECLARE tlf_c4 SCROLL CURSOR FOR r180_tlf_p4
 
     # 將各廠的資料彙總至暫存檔 
     FOREACH ima_cl INTO sr1.*,l_ima901
        IF SQLCA.SQLCODE THEN
           CALL cl_err('FOREACH',SQLCA.SQLCODE,0)
           EXIT FOREACH
        END IF
        LET l_tlf06 = '' LET l_tlf10 = 0
        IF sr1.ima01  IS NULL THEN LET sr1.ima01 = ' ' END IF 
        IF sr1.ima02  IS NULL THEN LET sr1.ima02 = ' ' END IF 
        IF sr1.imk09  IS NULL THEN LET sr1.imk09 = 0   END IF 
        IF sr1.ccc91  IS NULL THEN LET sr1.ccc91 = 0   END IF 
        IF sr1.ccc92  IS NULL THEN LET sr1.ccc92 = 0   END IF 
             
        # 取期初開帳轉本月期初(讀不到沒影響)
       #str MOD-A30176 mod
       #當期初開帳有抓到資料時,才以開帳檔的值來取代,否則就維持當月成本抓到的資料
       #OPEN cca_c1 USING sr1.ima01 
       #FETCH cca_c1 INTO sr1.imk09,sr1.ccc91,sr1.ccc92
       #IF sr1.imk09 IS NULL THEN LET sr1.imk09 = 0 END IF 
       #IF sr1.ccc91 IS NULL THEN LET sr1.ccc91 = 0 END IF 
       #IF sr1.ccc92 IS NULL THEN LET sr1.ccc92 = 0 END IF 
        INITIALIZE sr2.* TO NULL       #MOD-B30726 add
        OPEN cca_c1 USING sr1.ima01,sr1.ccc08
        FETCH cca_c1 INTO sr2.imk09,sr2.ccc91,sr2.ccc92,sr2.ccc08
        IF sr2.imk09 IS NULL THEN LET sr2.imk09 = 0 END IF
        IF sr2.ccc91 IS NULL THEN LET sr2.ccc91 = 0 END IF
        IF sr2.ccc92 IS NULL THEN LET sr2.ccc92 = 0 END IF
        IF sr2.imk09 != 0 OR sr2.ccc91 != 0 OR sr2.ccc92 != 0 THEN
           LET sr1.imk09 = sr2.imk09
           LET sr1.ccc91 = sr2.ccc91
           LET sr1.ccc92 = sr2.ccc92
        END IF
       #end MOD-A30176 mod

 
        # 取基準日期前最後一次出庫日期 
        OPEN tlf_c1 USING sr1.ima01 
        FETCH tlf_c1 INTO l_tlf06
        IF cl_null(l_tlf06) THEN # 若,無出庫日期,取基準日期前最後一次入庫日期 
           OPEN tlf_c2 USING sr1.ima01 
           FETCH tlf_c2 INTO l_tlf06
        END IF 
        IF NOT cl_null(l_tlf06) THEN LET sr1.d_date = l_tlf06 END IF   #No.CHI-8B0021 del mark
        ### 若基準日期不是月底, 則須再取異動資料
        IF DAY(tm.s_date + 1) != 1 THEN 
           LET l_tlf10 = 0 LET l_tlf21 = 0 
           OPEN tlf_c3 USING sr1.ima01 
           FETCH tlf_c3 INTO l_tlf10
           OPEN tlf_c4 USING sr1.ima01 , sr1.ccc08    #FUN-7C0101 ADD sr1.ccc08
           FETCH tlf_c4 INTO l_tlf21
           IF l_tlf10 IS NULL THEN LET l_tlf10 = 0 END IF 
           IF l_tlf21 IS NULL THEN LET l_tlf21 = 0 END IF 
           LET l_tlf21 = l_tlf21 * l_tlf10
           LET sr1.imk09 = sr1.imk09 + l_tlf10
           LET sr1.ccc91 = sr1.ccc91 + l_tlf10
           LET sr1.ccc92 = sr1.ccc92 + l_tlf21
        END IF 
#        MESSAGE 'l_dbs_new+part-->',l_dbs_new clipped,'|',sr1.ima01 clipped,      #No.FUN-A10098 ---mark
#                   '|',sr1.ccc92                                                  #No.FUN-A10098 ---mark
        CALL ui.Interface.refresh()
        IF sr1.ccc92 = 0 THEN CONTINUE FOREACH END IF 
       #IF cl_null(sr1.d_date) THEN LET sr1.d_date = l_ima901 END IF 
        UPDATE axcr180_temp SET ccc92 = ccc92 + sr1.ccc92,
                                ccc91 = ccc91 + sr1.ccc91,
                                imk09 = imk09 + sr1.imk09
         WHERE ima01 = sr1.ima01
        IF SQLCA.SQLERRD[3]=0 THEN
           EXECUTE r180_ins_p1 USING sr1.*
           IF SQLCA.SQLCODE THEN 
              CALL cl_err('r180_ins_p1',SQLCA.SQLCODE,1)   
           END IF
        END IF 
        LET m_ccc92=m_ccc92+sr1.ccc92
    END FOREACH
END FUNCTION 
 
 
FUNCTION r180_chkplant(l_plant)
  DEFINE l_plant     LIKE azp_file.azp01
 
  SELECT azp01 FROM azp_file
   WHERE azp01 = l_plant
  IF SQLCA.SQLCODE THEN
     LET g_errno='aom-300'
     RETURN 0
  ELSE
     RETURN 1
  END IF
END FUNCTION
#No.FUN-9C0073 -----By chenls 10/01/26
#FUN-A70084--add--str--
FUNCTION r180_set_visible()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN
     CALL cl_set_comp_visible("group05",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION

FUNCTION r180_chklegal(l_legal,n)
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
