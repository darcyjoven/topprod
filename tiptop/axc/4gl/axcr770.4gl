# Prog. Version..: '5.30.06-13.03.29(00010)'     #
#
# Pattern name...: axcr770.4gl
# Descriptions...: 雜項進出月報(無工單)(axcr770)
# Input parameter: 
# Return code....: 
# Date & Author..: 98/12/06   By Billy Wang 
# Modify ........: No:9453 04/04/14 By Melody 修改tlf10 為tlf10*tlf60
# Modify ........: No:9668 04/06/14 By Carol  在列印時 add BEFORE GROUP OF sr.tl
#                                             PRINT''可讓報表比較好閱讀
# Modify ........: No:8741 moidfy 報表格式
# Modify.........: No.FUN-4C0099 05/01/04 By kim 報表轉XML功能
# Modify.........: No.FUN-510041 05/02/21 BY Carol add tm.b --> add EXP 明細列印 
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: NO.MOD-580183 05/08/22 BY yiting 雜收單價抓inb13
# Modify.........: No.FUN-590106 05/09/28 By Sarah 替換inb902-->inb908
# Modify.........: No.TQC-5B0019 05/11/08 By Sarah SELECT資料少一個欄位,導致寫不進sr,無法出表
# Modify.........: No.FUN-5B0082 05/11/16 By Sarah 報表少印"其他"欄位
# Modify.........: NO.MOD-620047 06/02/17 BY Claire 金額抓inb14
# Modify.........: NO.MOD-620045 06/02/17 BY Claire 加上check 當 sr.ccc23a = 0 時 再 select inb14 -> ccc23a
# Modify.........: No.TQC-610051 06/02/23 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0028 06/12/07 By Claire MOD-620045 加上ELSE判斷
# Modify.........: No.CHI-690007 06/12/27 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-710113 07/01/22 By jamie mark掉材料金額的計算(因為會使它歸零)
# Modify.........: No.MOD-720068 07/02/13 By pengu 成本報表金額取位錯誤,應使用 g_azi04
# Modify.........: No.MOD-770070 07/07/17 By Carol 將azi05,azi04取位改為使用ccz26
# Modify.........: No.FUN-810073 07/12/26 By zhangyajun 報表轉CR
# Modify.........: No.FUN-810080 08/01/30 By zhoufeng 錯誤訊息匯總顯示
# Modify.........: No.FUN-7C0101 08/01/30 By Cockroach 增加type(成本計算類型)和列印字段
# Modify.........: No.FUN-830002 08/03/05 By Cockroach l_sql增加tlf_file與tlfc_file關聯字段
# Modify.........: No.FUN-8A0086 08/10/17 By lutingting完善錯誤訊息匯總 
# Modify.........: No.FUN-8B0026 08/11/06 By xiaofeizhu 提供INPUT加上關系人與營運中心
# Modify.........: No.MOD-910243 09/01/21 By sherry 雜入金額與axcr430有小數尾差 
# Modify.........: No.MOD-8C0253 08/01/02 By Pengu 當不勾選列印明細時，則不允許輸入資料排序與小計等欄位
# Modify.........: No.MOD-920127 09/02/09 By chenl 調整sql語句，tlfctype放入foreach段進行比較。
# Modify.........: NO.MOD-930067 09/03/06 BY yiting MATCHES "[34]" -->IN ('3','4')                                                       
# Modify.........: No.CHI-930028 09/03/13 By shiwuying 取消程式段有做tlf021[1,4]或tlf031[1,4]的程式碼改成不做只取前4碼的限制
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.MOD-940146 09/05/25 By Pengu tlf907<0時應該是要抓取雜發資料
# Modify.........: No.MOD-950264 09/06/01 By mike 調整select 的欄位個數，在ima57前面再加上2個''                                     
# Modify.........: No.TQC-970189 09/07/21 By destiny l_sql改為string  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990086 09/09/09 By Carrier 報表資料剔除 不計算成本 的資料
# Modify.........: No:FUN-9A0050 09/11/11 By xiaofeizhu 增加會計科目，成本中心等信息
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.FUN-A10098 10/01/19 By baofei GP5.2跨DB報表--財務類
# Modify.........: No:MOD-A30220 10/03/29 By Sarah 報表增加抓取拆解單,組合單
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.FUN-A70084 10/07/19 By lutingting GP5.2報表修改 
# Modify.........: No:MOD-B10174 11/07/17 By Pengu 加上借還料aimt306/aimt309的資料
# Modify.........: No.TQC-BB0182 12/01/11 By pauline 取消過濾plant條件
# Modify.........: No:MOD-C10109 12/01/12 By ck2yuan 不抓ina inb ,tlf13過濾atmt260 atmt261
# Modify.........: No:MOD-C20194 12/02/28 By Elise 條件儲存功能只適用於CONSTRUCT
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:TQC-C80057 12/08/07 By lujh 倉庫tlf031改抓tlf902，tlf032改抓tlf903
# Modify.........: No:CHI-C20049 12/08/17 By bart 列印費用改成RadioBox(1.入庫、2.出庫、3.全部)
# Modify.........: No:TQC-D20041 13/02/21 By bart 修改CHI-C20049判斷邏輯
# Modify.........: No:MOD-C30785 13/03/07 By Elise 調撥也要視同雜項
# Modify.........: No:MOD-D30247 13/03/28 By ck2yuan 系統ina09已無使用，故抓取ina09程式Mark 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                  # Print condition RECORD
           wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(300)      # Where condition
           bdate   LIKE type_file.dat,            #No.FUN-680122DATE
           edate   LIKE type_file.dat,            #No.FUN-680122DATE
           type    LIKE type_file.chr1,           #No.FUN-7C0101 成本計算類型
           a       LIKE type_file.chr1,           #No.FUN-680122CHAR(1)        #
           #b       LIKE type_file.chr1,           #No.FUN-680122CHAR(1)        #FUN-510041 #CHI-C20049
           c       LIKE type_file.chr1,           #CHI-C20049
           b_1     LIKE type_file.chr1,           #No.FUN-8B0026 VARCHAR(1)
           p1      LIKE azp_file.azp01,           #No.FUN-8B0026 VARCHAR(10)
           p2      LIKE azp_file.azp01,           #No.FUN-8B0026 VARCHAR(10)
           p3      LIKE azp_file.azp01,           #No.FUN-8B0026 VARCHAR(10)
           p4      LIKE azp_file.azp01,           #No.FUN-8B0026 VARCHAR(10) 
           p5      LIKE azp_file.azp01,           #No.FUN-8B0026 VARCHAR(10)
           p6      LIKE azp_file.azp01,           #No.FUN-8B0026 VARCHAR(10)
           p7      LIKE azp_file.azp01,           #No.FUN-8B0026 VARCHAR(10)
           p8      LIKE azp_file.azp01,           #No.FUN-8B0026 VARCHAR(10)
           s       LIKE type_file.chr3,           #No.FUN-8B0026 VARCHAR(3)
           t       LIKE type_file.chr3,           #No.FUN-8B0026 VARCHAR(3)
           u       LIKE type_file.chr3,           #No.FUN-8B0026 VARCHAR(3)            
           more    LIKE type_file.chr1            #No.FUN-680122CHAR(1)        # Input more condition(Y/N)
           END RECORD,
       g_yy,g_mm   LIKE type_file.num5           #No.FUN-680122SMALLINT
DEFINE g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE l_table     STRING         #No.FUN-810073
DEFINE g_str       STRING         #No.FUN-810073
DEFINE g_sql       STRING         #No.FUN-810073
#DEFINE m_dbs       ARRAY[10] OF LIKE type_file.chr20   #No.FUN-8B0026 ARRAY[10] OF VARCHAR(20)   #FUN-A70084
DEFINE m_plant      ARRAY[10] OF LIKE azp_file.azp01    #FUN-A70084
DEFINE m_legal      ARRAY[10] OF LIKE azw_file.azw02    #FUN-A70084
 
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
 
   LET g_sql="chr20.type_file.chr20,",
             "tlf037.tlf_file.tlf037,",
             "tlf907.tlf_file.tlf907,",
             "tlf13.tlf_file.tlf13,",
             "tlf14.tlf_file.tlf14,",
             "tlf17.tlf_file.tlf17,",
             "tlf19.tlf_file.tlf19,",
             "tlf021.tlf_file.tlf021,",
             "tlf031.tlf_file.tlf031,",
             "tlf06.tlf_file.tlf06,",
             "tlf026.tlf_file.tlf026,",
             "tlf027.tlf_file.tlf027,",
             "tlf036.tlf_file.tlf036,",
             "tlf01.tlf_file.tlf01,",
             "tlf10.tlf_file.tlf10,",
             "ccc23a.ccc_file.ccc23a,",
             "ccc23b.ccc_file.ccc23b,",
             "ccc23c.ccc_file.ccc23c,",
             "ccc23d.ccc_file.ccc23d,",
             "ccc23e.ccc_file.ccc23e,",
             "ccc23f.ccc_file.ccc23f,",        #FUN-7C0101 ADD
             "ccc23g.ccc_file.ccc23g,",        #FUN-7C0101 ADD   
             "ccc23h.ccc_file.ccc23h,",        #FUN-7C0101 ADD   
             "ima02.ima_file.ima02,",
             "tlfccost.tlfc_file.tlfccost,",   #FUN-7C0101 ADD
             "ima021.ima_file.ima021,",
             "ima12.ima_file.ima12,",
             "ccc23a_1.ccc_file.ccc23a,",
             "ccc23b_1.ccc_file.ccc23b,",
             "ccc23c_1.ccc_file.ccc23c,",
             "ccc23d_1.ccc_file.ccc23d,",
             "ccc23e_1.ccc_file.ccc23e,",
             "ccc23f_1.ccc_file.ccc23f,",      #FUN-7C0101 ADD  
             "ccc23g_1.ccc_file.ccc23g,",      #FUN-7C0101 ADD    
             "ccc23h_1.ccc_file.ccc23h,",      #FUN-7C0101 ADD     
             "ccc23a_2.ccc_file.ccc23a,",
            #"ina09.ina_file.ina09,",          #MOD-D30247
             "gem02.gem_file.gem02,",
             "azf03.azf_file.azf03,",
             "ccz27.ccz_file.ccz27,",
             "azi03.azi_file.azi03,",
             "plant.azp_file.azp01,",                                           #FUN-8B0026
             "ima57.ima_file.ima57,",                                           #FUN-8B0026
             "ima08.ima_file.ima08,",                                           #FUN-8B0026
             "ima39.ima_file.ima39,",                                           #FUN-9A0050
             "ima391.ima_file.ima391,",                                         #FUN-9A0050
             "tlf930.tlf_file.tlf930"                                           #FUN-9A0050             
             
   LET l_table=cl_prt_temptable('axcr770',g_sql)CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,",                              #FUN-9A0050 Add ?,?,?
                      "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,", #FUN-7C0101 ADD 7 '?'
                     #"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                      #FUN-8B0026 Add ?,?,?    #MOD-D30247 mark
                      "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                        #MOD-D30247
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
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.a = ARG_VAL(10)
   #LET tm.b = ARG_VAL(11)  #CHI-C20049
   LET tm.c = ARG_VAL(11)   #CHI-C20049
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET tm.type =ARG_VAL(16)            #FUN-7C0101 ADD  
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   LET tm.b_1   = ARG_VAL(17)
   LET tm.p1    = ARG_VAL(18)
   LET tm.p2    = ARG_VAL(19)
   LET tm.p3    = ARG_VAL(20)
   LET tm.p4    = ARG_VAL(21)
   LET tm.p5    = ARG_VAL(22)
   LET tm.p6    = ARG_VAL(23)
   LET tm.p7    = ARG_VAL(24)
   LET tm.p8    = ARG_VAL(25) 
   LET tm.s     = ARG_VAL(26)
   LET tm.t     = ARG_VAL(27)
   LET tm.u     = ARG_VAL(28)   
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
   
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr770_tm(0,0)
      ELSE CALL axcr770()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr770_tm(p_row,p_col)
#DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031  #MOD-C20194 mark
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_bdate,l_edate   LIKE type_file.dat,            #No.FUN-680122DATE
          l_flag         LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
   DEFINE l_cnt        LIKE type_file.num5          #No.FUN-A70084
 
   LET p_row = 5 
   LET p_col = 12
   OPEN WINDOW axcr770_w AT p_row,p_col WITH FORM "axc/42f/axcr770" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   CALL r770_set_visible() RETURNING l_cnt    #FUN-A70084
   CALL s_azm(g_ccz.ccz01,g_ccz.ccz02) RETURNING l_flag,l_bdate,l_edate
   INITIALIZE tm.* TO NULL
   LET tm.bdate= l_bdate
   LET tm.edate= l_edate
   LET tm.type = g_ccz.ccz28    #FUN-7C0101 ADD  
   LET tm.a   = 'Y'
   #LET tm.b   = 'N'    #FUN-510041  #CHI-C20049
   LET tm.c   = '3'     #CHI-C20049
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
   LET tm.s ='56 '     #No.MOD-8C0253 modify
   LET tm.t ='NNN'     #No.MOD-8C0253 modify
   LET tm.u ='YYN'     #No.MOD-8C0253 modify
   LET tm.b_1 ='N'
   LET tm.p1=g_plant
   CALL r770_set_entry_1()               
   CALL r770_set_no_entry_1()
   CALL r770_set_comb()           
   LET tm2.s1 = tm.s[1,1]
   LET tm2.s2 = tm.s[2,2]
   LET tm2.s3 = tm.s[3,3]
   LET tm2.t1 = tm.t[1,1]
   LET tm2.t2 = tm.t[2,2]
   LET tm2.t3 = tm.t[3,3]
   LET tm2.u1 = tm.u[1,1]
   LET tm2.u2 = tm.u[2,2]
   LET tm2.u3 = tm.u[3,3]
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima12,ima57,ima08,tlf01,tlf14,tlf19 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
     ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION controlp                                                      
        IF INFIELD(tlf01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_tlf"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO tlf01                             
           NEXT FIELD tlf01                                                 
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

     #MOD-C20194----add----str----
      ON ACTION qbe_save
            CALL cl_qbe_save()
     #MOD-C20194----add----end----
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      EXIT WHILE 
   END IF
 
   IF tm.wc=' 1=1' THEN 
      CALL cl_err('','9046',0)
      CONTINUE WHILE 
   END IF
 
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.a,tm.c,  #CHI-C20049  tm.b->tm.c
                 tm.b_1,tm.p1,tm.p2,tm.p3,                                                  #FUN-8B0026
                 tm.p4,tm.p5,tm.p6,tm.p7,tm.p8,                                             #FUN-8B0026 
                 tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,                                 #FUN-8B0026
                 tm2.u1,tm2.u2,tm2.u3,                                                      #FUN-8B0026   
                 tm.more    #FUN-510041  #FUN-7C0101 ADD type
         WITHOUT DEFAULTS 
 
      AFTER FIELD edate
        IF NOT cl_null(tm.edate) THEN 
           IF tm.edate < tm.bdate THEN 
              NEXT FIELD edate 
           END IF
        END IF
 
   
      ON CHANGE a
         IF tm.a = 'N' THEN 
            LET tm2.s1 ='5'    
            LET tm2.s2 ='6'    
            LET tm2.s3 =''    
            LET tm2.t1 ='N'    
            LET tm2.t2 ='N'    
            LET tm2.t3 ='N'    
            LET tm2.u1 ='Y'    
            LET tm2.u2 ='Y'    
            LET tm2.u3 ='N'    
          END IF 
          CALL r770_set_entry()
          CALL r770_set_no_entry()
 
     AFTER FIELD type
        IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF
 
      AFTER FIELD b_1
          IF NOT cl_null(tm.b_1)  THEN
             IF tm.b_1 NOT MATCHES "[YN]" THEN
                NEXT FIELD b_1       
             END IF
          END IF
                    
       ON CHANGE  b_1
          LET tm.p1=g_plant
          LET tm.p2=NULL
          LET tm.p3=NULL
          LET tm.p4=NULL
          LET tm.p5=NULL
          LET tm.p6=NULL
          LET tm.p7=NULL
          LET tm.p8=NULL
          DISPLAY BY NAME tm.p1,tm.p2,tm.p3,tm.p4,tm.p5,tm.p6,tm.p7,tm.p8       
          CALL r770_set_entry_1()      
          CALL r770_set_no_entry_1()
          CALL r770_set_comb()                       
       
      AFTER FIELD p1
         IF cl_null(tm.p1) THEN NEXT FIELD p1 END IF
         SELECT azp01 FROM azp_file WHERE azp01 = tm.p1
         IF STATUS THEN 
            CALL cl_err3("sel","azp_file",tm.p1,"",STATUS,"","sel azp",1)   
            NEXT FIELD p1 
         END IF
         IF NOT cl_null(tm.p1) THEN 
            IF NOT s_chk_demo(g_user,tm.p1) THEN              
               NEXT FIELD p1          
            #FUN-A70084--add--str--
            ELSE
               SELECT azw02 INTO m_legal[1] FROM azw_file WHERE azw01 = tm.p1
           #FUN-A70084--add--end
            END IF  
         END IF              
 
      AFTER FIELD p2
         IF NOT cl_null(tm.p2) THEN
            SELECT azp01 FROM azp_file WHERE azp01 = tm.p2
            IF STATUS THEN 
               CALL cl_err3("sel","azp_file",tm.p2,"",STATUS,"","sel azp",1)   
               NEXT FIELD p2 
            END IF
            IF NOT s_chk_demo(g_user,tm.p2) THEN
               NEXT FIELD p2
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[2] FROM azw_file WHERE azw01 = tm.p2
            IF NOT r770_chklegal(m_legal[2],1) THEN
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
            IF NOT s_chk_demo(g_user,tm.p3) THEN
               NEXT FIELD p3
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[3] FROM azw_file WHERE azw01 = tm.p3
            IF NOT r770_chklegal(m_legal[3],2) THEN
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
            IF NOT s_chk_demo(g_user,tm.p4) THEN
               NEXT FIELD p4
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[4] FROM azw_file WHERE azw01 = tm.p4
            IF NOT r770_chklegal(m_legal[4],3) THEN
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
            IF NOT s_chk_demo(g_user,tm.p5) THEN
               NEXT FIELD p5
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[5] FROM azw_file WHERE azw01 = tm.p5
            IF NOT r770_chklegal(m_legal[5],4) THEN
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
            IF NOT s_chk_demo(g_user,tm.p6) THEN
               NEXT FIELD p6
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[6] FROM azw_file WHERE azw01 = tm.p6
            IF NOT r770_chklegal(m_legal[6],5) THEN
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
            IF NOT s_chk_demo(g_user,tm.p7) THEN
               NEXT FIELD p7
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[7] FROM azw_file WHERE azw01 = tm.p7
            IF NOT r770_chklegal(m_legal[7],6) THEN
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
            IF NOT s_chk_demo(g_user,tm.p8) THEN
               NEXT FIELD p8
            END IF            
            #FUN-A70084--add--str--檢查所錄入PLANT在同一法人下
            SELECT azw02 INTO m_legal[8] FROM azw_file WHERE azw01 = tm.p8
            IF NOT r770_chklegal(m_legal[8],7) THEN
               CALL cl_err(tm.p8,g_errno,0)
               NEXT FIELD p8
            END IF
            #FUN-A70084--add--end
         END IF       
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
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
         END CASE                        
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
 
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
         LET tm.u = tm2.u1,tm2.u2,tm2.u3      
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

         BEFORE INPUT
            #CALL cl_qbe_display_condition(lc_qbe_sn)  #MOD-C20194  mark
             CALL r770_set_entry()
             CALL r770_set_no_entry()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
   
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

        #MOD-C20194----mark----str---- 
        #ON ACTION qbe_save
        #   CALL cl_qbe_save()
        #MOD-C20194----mark----end----

   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      EXIT WHILE 
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr770'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr770','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.type  CLIPPED,"'",             #FUN-7C0101 ADD
                         " '",tm.a CLIPPED,"'",                 #TQC-610051
                         #" '",tm.b CLIPPED,"'",                 #TQC-610051 #CHI-C20049
                         " '",tm.c CLIPPED,"'",                 #CHI-C20049
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",tm.b_1 CLIPPED,"'" ,  #FUN-8B0026
                         " '",tm.p1 CLIPPED,"'" ,   #FUN-8B0026
                         " '",tm.p2 CLIPPED,"'" ,   #FUN-8B0026
                         " '",tm.p3 CLIPPED,"'" ,   #FUN-8B0026
                         " '",tm.p4 CLIPPED,"'" ,   #FUN-8B0026
                         " '",tm.p5 CLIPPED,"'" ,   #FUN-8B0026
                         " '",tm.p6 CLIPPED,"'" ,   #FUN-8B0026
                         " '",tm.p7 CLIPPED,"'" ,   #FUN-8B0026
                         " '",tm.p8 CLIPPED,"'" ,   #FUN-8B0026                      
                         " '",tm.s CLIPPED,"'" ,    #FUN-8B0026
                         " '",tm.t CLIPPED,"'" ,    #FUN-8B0026
                         " '",tm.u CLIPPED,"'"      #FUN-8B0026                         
 
         CALL cl_cmdat('axcr770',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr770_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr770()
   ERROR ""
 END WHILE
 CLOSE WINDOW axcr770_w
 
END FUNCTION
 
FUNCTION r770_set_entry()
    CALL cl_set_comp_entry("s1,s2,s3,t1,t2,t3,
                            u1,u2,u3",TRUE)
END FUNCTION
 
FUNCTION r770_set_no_entry()
   IF tm.a = 'N' THEN
      CALL cl_set_comp_entry("s1,s2,s3,t1,t2,t3,
                              u1,u2,u3",FALSE)
   END IF
END FUNCTION
 
FUNCTION axcr770()
DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
       l_sql     STRING,                        #No.TQC-970189 
       l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
       l_flag    LIKE type_file.num5,           #No.FUN-680122SMALLINT
       l_factor  LIKE oeo_file.oeo06,           #No.FUN-680122DECIMAL(20,8)
       sr     RECORD 
              order1    LIKE type_file.chr20,          #No.FUN-680122CHAR(20) #單據編號
              tlf037    LIKE    tlf_file.tlf037, #NO.MOD-580183
              tlf907    LIKE    tlf_file.tlf907, #出入庫之判斷
              tlf13     LIKE    tlf_file.tlf13,  #異動命令代號
              tlf14     LIKE    tlf_file.tlf14,  #雜項原因
              tlf17     LIKE    tlf_file.tlf17,  #雜項備註
              tlf19     LIKE    tlf_file.tlf19,  #部門
              tlf021    LIKE    tlf_file.tlf021, #倉庫代號
              tlf031    LIKE    tlf_file.tlf031, #倉庫代號
              tlf06     LIKE    tlf_file.tlf06,  #入庫日
              tlf026    LIKE    tlf_file.tlf026, #單據編號
              tlf027    LIKE    tlf_file.tlf027, #
              tlf036    LIKE    tlf_file.tlf036, #單據編號
              tlf01     LIKE    tlf_file.tlf01,  #料號
              tlf10     LIKE    tlf_file.tlf10,  #入庫數
              ccc23a    LIKE    ccc_file.ccc23a, #本月平均材料單位成本
              ccc23b    LIKE    ccc_file.ccc23b, #本月平均人工單位成本
              ccc23c    LIKE    ccc_file.ccc23c, #本月平均製費單位成本
              ccc23d    LIKE    ccc_file.ccc23d, #本月平均加工單位成本
              ccc23e    LIKE    ccc_file.ccc23e, #本月平均其他單位成本
              ccc23f    LIKE    ccc_file.ccc23f, #FUN-7C0101 ADD #本月平均單價-制費三                                                              
              ccc23g    LIKE    ccc_file.ccc23g, #FUN-7C0101 ADD #本月平均單價-制費四                                                              
              ccc23h    LIKE    ccc_file.ccc23h, #FUN-7C0101 ADD #本月平均單價-制費五  
              ima02     LIKE    ima_file.ima02,  #說明
              tlfccost  LIKE    tlfc_file.tlfccost, #FUN-7C0101 ADD 類別編號
              ima021    LIKE    ima_file.ima021, #規格   #FUN-4C0099
              ima12     LIKE    ima_file.ima12,  #原料/成品
              l_ccc23a  LIKE    ccc_file.ccc23a,
              l_ccc23b  LIKE    ccc_file.ccc23b,
              l_ccc23c  LIKE    ccc_file.ccc23c,
              l_ccc23d  LIKE    ccc_file.ccc23d,
              l_ccc23e  LIKE    ccc_file.ccc23e,
              l_ccc23f  LIKE    ccc_file.ccc23f,    #FUN-7C0101 ADD                                                                                      
              l_ccc23g  LIKE    ccc_file.ccc23g,    #FUN-7C0101 ADD                                                                                      
              l_ccc23h  LIKE    ccc_file.ccc23h,    #FUN-7C0101 ADD
              l_tot     LIKE    ccc_file.ccc23a,
             #ina09     LIKE    ina_file.ina09,     #MOD-D30247 mark
              tlf902   LIKE tlf_file.tlf902,    #TQC-C80057 add
              tlf903   LIKE tlf_file.tlf903     #TQC-C80057 add   
              END RECORD
 DEFINE l_inb13   LIKE   inb_file.inb13  #NO.MOD-580183
 DEFINE l_inb14   LIKE    inb_file.inb14  #NO.MOD-620047   
 DEFINE l_exp_tot    LIKE     cmi_file.cmi08  #No.FUN-810073
 DEFINE l_azf03      LIKE     azf_file.azf03  #No.FUN-810073
 DEFINE l_gem02      LIKE gem_file.gem02      #No.FUN-810073
 DEFINE l_i          LIKE type_file.num5                 #No.FUN-8B0026 SMALLINT
 DEFINE l_dbs        LIKE azp_file.azp03                 #No.FUN-8B0026
 DEFINE i            LIKE type_file.num5                 #No.FUN-8B0026
 DEFINE l_ima57      LIKE ima_file.ima57                 #No.FUN-8B0026
 DEFINE l_ima08      LIKE ima_file.ima08                 #No.FUN-8B0026
 DEFINE l_inb        RECORD LIKE inb_file.*              #No.FUN-8B0026 
 DEFINE l_tlfctype   LIKE tlfc_file.tlfctype  #No.MOD-920127
 DEFINE l_slip       LIKE smy_file.smyslip    #No.MOD-990086
 DEFINE l_smydmy1    LIKE smy_file.smydmy1    #No.MOD-990086
 DEFINE l_tlf032     LIKE tlf_file.tlf032                #No.FUN-9A0050
 DEFINE l_tlf930     LIKE tlf_file.tlf930                #No.FUN-9A0050 
 DEFINE l_ima39      LIKE ima_file.ima39                 #No.FUN-9A0050
 DEFINE l_ima391     LIKE ima_file.ima391                #No.FUN-9A0050
 DEFINE l_ccz07      LIKE ccz_file.ccz07                 #No.FUN-9A0050
 DEFINE l_tlf14      LIKE tlf_file.tlf14                 #No.FUN-9A0050 add by liuxqa 
 DEFINE l_tlf19      LIKE tlf_file.tlf19                 #No.FUN-9A0050 add by liuxqa  
 DEFINE l_cnt        LIKE type_file.num5                 #No.FUN-A70084

    CALL cl_del_data(l_table)             #No.FUN-810073
    
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axcr770' #No.FUN-810073
    LET g_yy = YEAR(tm.bdate) USING "&&&&"
    LET g_mm = MONTH(tm.bdate) USING "&&"
    
#FUN-A70084--mod--str--
#  FOR i = 1 TO 8 LET m_dbs[i] = NULL END FOR
#  LET m_dbs[1]=tm.p1
#  LET m_dbs[2]=tm.p2
#  LET m_dbs[3]=tm.p3
#  LET m_dbs[4]=tm.p4
#  LET m_dbs[5]=tm.p5
#  LET m_dbs[6]=tm.p6
#  LET m_dbs[7]=tm.p7
#  LET m_dbs[8]=tm.p8
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
      #IF cl_null(m_dbs[l_i]) THEN CONTINUE FOR END IF                       #FUN-8B0026  #FUN-A70084
       IF cl_null(m_plant[l_i]) THEN CONTINUE FOR END IF                       #FUN-A70084
       CALL r770_set_visible() RETURNING l_cnt    #FUN-A70084
       IF l_cnt>1 THEN LET m_plant[1] = g_plant END IF                 #FUN-A70084
      #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01=m_dbs[l_i]          #FUN-8B0026 #FUN-A70084
      #LET l_dbs = s_dbstring(l_dbs CLIPPED)                                         #FUN-8B0026   #FUN-A70084 
               
    LET l_sql = "SELECT '',tlf037,tlf907,tlf13,tlf14,tlf17,tlf19,tlf021,tlf031,",          #TQC-5B0019
                "       tlf06,tlf026,tlf027,",   #FUN-510041  # NO.MOD-580183 add tlf037
                "       tlf036,tlf01,tlf10*tlf60,tlfc221,tlfc222,tlfc2231,tlfc2232,", #No:9453  #FUN-7C0101 tlf221-tlf2232 --> tlfc221-tlfc2232
               #"       tlfc224,tlfc2241,tlfc2242,tlfc2243,ima02,tlfccost,ima021,ima12,'','','','','','','','','','',tlf902,tlf903,ima57,ima08,tlfctype,tlf032,tlf930", #MOD-950264  #FUN-9A0050 Add tlf032,tlf930    #TQC-C80057  add  tlf902,tlf903  #MOD-D30247 mark
                "       tlfc224,tlfc2241,tlfc2242,tlfc2243,ima02,tlfccost,ima021,ima12,'','','','','','','','','',tlf902,tlf903,ima57,ima08,tlfctype,tlf032,tlf930",   #MOD-D30247
#"  FROM ",l_dbs CLIPPED,"tlf_file LEFT OUTER JOIN ",l_dbs CLIPPED,"tlfc_file ON tlfc01 = tlf01  AND tlfc06 = tlf06 AND ",  #FUN-A10098
"  FROM ",cl_get_target_table(m_plant[l_i],'tlf_file')," LEFT OUTER JOIN ",cl_get_target_table(m_plant[l_i],'tlfc_file')," ON tlfc01 = tlf01  AND tlfc06 = tlf06 AND ",  #FUN-A10098   #FUN-A70084 m_dbs-->m_plant 
"                                                                               tlfc02 = tlf02  AND tlfc03 = tlf03 AND ",
"                                                                               tlfc13 = tlf13  AND ",
"                                                                               tlfc902= tlf902 AND tlfc903= tlf903 AND",
"                                                                               tlfc904= tlf904 AND tlfc907= tlf907 AND",
"                                                                               tlfc905= tlf905 AND tlfc906= tlf906 ",
#"      ,",l_dbs CLIPPED,"ima_file ",   #FUN-A10098
#"      ,",cl_get_target_table(m_dbs[l_i],'ima_file'),   #FUN-A10098   #FUN-A70084
"      ,",cl_get_target_table(m_plant[l_i],'ima_file'),   #FUN-A10098
                " WHERE tlf01=ima01 ",
                "   AND (tlf13='aimt301' or tlf13='aimt311' ", 
                "    OR  tlf13='aimt302' or tlf13='aimt312'",
                "    OR  tlf13='aimt720'",   #MOD-C30785
                "    OR  tlf13='aimt303' or tlf13='aimt313'",
                "    OR  tlf13='aimt306' or tlf13='aimt309'",   #No:MOD-B10174 add
                "    OR  tlf13='atmt260' or tlf13='atmt261')",  #MOD-A30220 add
                "   AND tlf06 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
#                "   AND tlf902 NOT IN (SELECT jce02 FROM ",l_dbs CLIPPED,"jce_file) ", #FUN-A10098 #no.5707  #FUN-8B0026 Add ",l_dbs CLIPPED,"
                "   AND tlf902 NOT IN (SELECT jce02 FROM ",cl_get_target_table(m_plant[l_i],'jce_file'),") ", #FUN-A10098    #FUN-A70084 m_dbs-->m_plant
                "   AND " ,tm.wc CLIPPED
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102            
   #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098   #FUN-A70084
   #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 markk
    PREPARE axcr770_prepare1 FROM l_sql
    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
       EXIT PROGRAM 
    END IF
    DECLARE axcr770_curs1 CURSOR FOR axcr770_prepare1
 
 
    LET g_success = 'Y'                               #No.FUN-8A0086
    CALL s_showmsg_init()                             #No.FUN-810080 
    FOREACH axcr770_curs1 INTO sr.*,l_ima57,l_ima08,l_tlfctype,l_tlf032,l_tlf930   #FUN-8B0026 Add ,l_ima57,l_ima08 #No.MOD-920127 add tlfctype #FUN-9A0050 Add l_tlf032,l_tlf930
       IF STATUS THEN
          LET g_success = 'N'              #No.FUN-8A0086
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH 
       END IF
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success='Y'                                                                                                         
       END IF                                                                                                                       
       IF NOT cl_null(l_tlfctype) AND l_tlfctype <> tm.type THEN 
          CONTINUE FOREACH
       END IF
       IF sr.tlf907>0 THEN
          LET l_slip = s_get_doc_no(sr.tlf036)
       ELSE
          LET l_slip = s_get_doc_no(sr.tlf026)
       END IF
       SELECT smydmy1 INTO l_smydmy1 FROM smy_file
        WHERE smyslip = l_slip
       IF l_smydmy1 = 'N' OR cl_null(l_smydmy1) THEN
          CONTINUE FOREACH
       END IF
       #IF tm.b = 'Y' THEN  #CHI-C20049
 
          IF sr.tlf13 != 'aimt306' AND sr.tlf13 != 'aimt309'       #No:MOD-B10174 add
             AND sr.tlf13 != 'aimt720'   #MOD-C30785
             AND sr.tlf13 != 'atmt260' AND sr.tlf13 != 'atmt261' THEN     #MOD-C10109 add
             LET l_sql = "SELECT * ",                                                                              
                     #    "  FROM ",l_dbs CLIPPED,"inb_file",  #FUN-A10098
                        #"  FROM ",cl_get_target_table(m_dbs[l_i],'inb_file'),  #FUN-A10098   #FUN-A70084
                         "  FROM ",cl_get_target_table(m_plant[l_i],'inb_file'),  #FUN-A70084
                         " WHERE inb01 = '",sr.tlf026,"'",
                         "   AND inb03 = '",sr.tlf027,"'",
                         "   AND inb908 IS NULL"  
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102             
            #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084                                                                                                                                                  
            #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
             PREPARE inb_prepare3 FROM l_sql                                                                                          
             DECLARE inb_c3  CURSOR FOR inb_prepare3                                                                                 
             OPEN inb_c3                                                                                    
             FETCH inb_c3 INTO l_inb.*
             #CHI-C20049---begin
             #END IF  #TQC-D20041
             IF tm.c = '3' THEN   
                IF NOT STATUS THEN
                   CONTINUE FOREACH
                END IF
             END IF  
             IF tm.c = '1' THEN   
                IF NOT STATUS OR sr.tlf907 = -1 THEN
                   CONTINUE FOREACH
                END IF
             END IF   
             IF tm.c = '2' THEN
             #CHI-C20049---end
                IF NOT STATUS OR sr.tlf907 = 1 THEN
                   CONTINUE FOREACH
                END IF
             END IF        #No:MOD-B10174 add
          END IF   #CHI-C20049  #TQC-D20041
          #TQC-D20041---begin
          IF tm.c = '1' THEN   
             IF sr.tlf907 = -1 THEN
                CONTINUE FOREACH
             END IF
          END IF   
          IF tm.c = '2' THEN
             IF sr.tlf907 = 1 THEN
                CONTINUE FOREACH
             END IF
          END IF  
          ##TQC-D20041---end
       IF sr.ccc23a IS NULL THEN LET sr.ccc23a=0 END IF
       IF sr.ccc23b IS NULL THEN LET sr.ccc23b=0 END IF
       IF sr.ccc23c IS NULL THEN LET sr.ccc23c=0 END IF
       IF sr.ccc23d IS NULL THEN LET sr.ccc23d=0 END IF
       IF sr.ccc23e IS NULL THEN LET sr.ccc23e=0 END IF
       IF sr.ccc23f IS NULL THEN LET sr.ccc23f=0 END IF            #FUN-7C0101 ADD                                                                   
       IF sr.ccc23g IS NULL THEN LET sr.ccc23g=0 END IF            #FUN-7C0101 ADD                                                                 
       IF sr.ccc23h IS NULL THEN LET sr.ccc23h=0 END IF            #FUN-7C0101 ADD   
       IF sr.tlf14 IS NULL THEN LET sr.tlf14=' ' END IF
       IF sr.tlf17 IS NULL THEN LET sr.tlf17=' ' END IF
       IF sr.tlf19 IS NULL THEN LET sr.tlf19=' ' END IF
       IF sr.tlf13 != 'aimt306' AND sr.tlf13 != 'aimt309'       #No:MOD-B10174 add
          AND sr.tlf13 != 'aimt720'   #MOD-C30785
          AND sr.tlf13 != 'atmt260' AND sr.tlf13 != 'atmt261' THEN     #MOD-C10109 add
          IF sr.tlf907>0 THEN
             LET sr.order1=sr.tlf036
           #MOD-D30247 str mark------
           # LET l_sql = "SELECT ina09 ",                                                                              
           #        #     "  FROM ",l_dbs CLIPPED,"ina_file",  #FUN-A10098
           #            #"  FROM ",cl_get_target_table(m_dbs[l_i],'ina_file'),  #FUN-A10098
           #             "  FROM ",cl_get_target_table(m_plant[l_i],'ina_file'),  #FUN-A10098
           #             " WHERE ina01='",sr.tlf036,"' AND ina00 IN ('3','4')",  #MOD-930067
           #             "   AND ina02='",sr.tlf06,"'"                   
           # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102 
           ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084                                                                                                                                                            
           ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
           # PREPARE ina_prepare3 FROM l_sql                                                                                          
           # DECLARE ina_c3  CURSOR FOR ina_prepare3                                                                                 
           # OPEN ina_c3                                                                                    
           # FETCH ina_c3 INTO sr.ina09
           #MOD-D30247 end mark------
          ELSE
             LET sr.order1=sr.tlf026
            #MOD-D30247 str mark------
            #LET l_sql = "SELECT ina09 ",                                                                              
            #        #    "  FROM ",l_dbs CLIPPED,"ina_file",  #FUN-A10098
            #           #"  FROM ",cl_get_target_table(m_dbs[l_i],'ina_file'),  #FUN-A10098  #FUN-A70084
            #            "  FROM ",cl_get_target_table(m_plant[l_i],'ina_file'),  #FUN-A70084
            #            " WHERE ina01='",sr.tlf026,"' AND ina00 NOT IN ('3','4')",   #MOD-930067   #No.MOD-940146 add not
            #            "   AND ina02='",sr.tlf06,"'"      
            # CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102 
            ##CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098 #FUN-A70084                                                                                                                                                                          
            ##CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
            #PREPARE ina_prepare2 FROM l_sql                                                                                          
            #DECLARE ina_c2  CURSOR FOR ina_prepare2                                                                                 
            #OPEN ina_c2                                                                                    
            #FETCH ina_c2 INTO sr.ina09
            #MOD-D30247 end mark------
          END IF
         #MOD-D30247 str mark------
         #IF STATUS THEN
         #   CALL s_errmsg('','',sr.order1,STATUS,1)     #No.FUN-810080  
         #END IF
         #MOD-D30247 end mark------
       END IF     #No:MOD-B10174 add
 
       LET sr.tlf10 = sr.tlf10 * sr.tlf907
       IF sr.tlf13='aimt302' OR sr.tlf13='aimt312' THEN #雜入
       IF sr.ccc23a = 0 THEN         #MOD-620045
         LET l_inb14 = 0 
 
          LET l_sql = "SELECT inb13*inb09 ",   #MOD-910243                                                                         
                  #    "  FROM ",l_dbs CLIPPED,"inb_file",  #FUN-A10098
                     #"  FROM ",cl_get_target_table(m_dbs[l_i],'inb_file'),  #FUN-A10098   #FUN-A70084
                      "  FROM ",cl_get_target_table(m_plant[l_i],'inb_file'),  #FUN-A70084
                      " WHERE inb01 = '",sr.tlf036,"'",
                      "   AND inb03 = '",sr.tlf037,"'"    
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102 
         #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084                                                                                                                                                                           
         #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
          PREPARE inb_prepare2 FROM l_sql                                                                                          
          DECLARE inb_c2  CURSOR FOR inb_prepare2                                                                                 
          OPEN inb_c2                                                                                    
          FETCH inb_c2 INTO l_inb14
            
         IF cl_null(l_inb14) THEN LET l_inb14 = 0 END IF
         LET sr.l_ccc23a=l_inb14
       ELSE                                       #TQC-6A0028 add
          LET sr.l_ccc23a = sr.ccc23a*sr.tlf907   #TQC-6A0028 add
       END IF                        #MOD-620045
       ELSE
           LET sr.l_ccc23a = sr.ccc23a*sr.tlf907
       END IF
       LET sr.l_ccc23b = sr.ccc23b*sr.tlf907
       LET sr.l_ccc23c = sr.ccc23c*sr.tlf907
       LET sr.l_ccc23d = sr.ccc23d*sr.tlf907
       LET sr.l_ccc23e = sr.ccc23e*sr.tlf907
       LET sr.l_ccc23f = sr.ccc23f*sr.tlf907  #FUN-7C0101  ADD
       LET sr.l_ccc23g = sr.ccc23g*sr.tlf907  #FUN-7C0101  ADD 
       LET sr.l_ccc23h = sr.ccc23h*sr.tlf907  #FUN-7C0101  ADD 
 
       LET sr.l_tot=sr.l_ccc23a+sr.l_ccc23b+sr.l_ccc23c+sr.l_ccc23d+sr.l_ccc23e
                   +sr.l_ccc23f+sr.l_ccc23g+sr.l_ccc23h        #FUN-7C0101 ADD
 
       IF NOT cl_null(sr.ima12) THEN
 
          LET l_sql = "SELECT azf03 ",                                                                              
                  #    "  FROM ",l_dbs CLIPPED,"azf_file",  #FUN-A10098
                     #"  FROM ",cl_get_target_table(m_dbs[l_i],'azf_file'),  #FUN-A10098  #FUN-A70084
                      "  FROM ",cl_get_target_table(m_plant[l_i],'azf_file'),  #FUN-A70084
                      " WHERE azf01='",sr.ima12,"' AND azf02='G'"      
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102 
         #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098    #FUN-A70084                                                                                                                                                                      
         #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
          PREPARE azf_prepare2 FROM l_sql                                                                                          
          DECLARE azf_c2  CURSOR FOR azf_prepare2                                                                                 
          OPEN azf_c2                                                                                    
          FETCH azf_c2 INTO l_azf03
            
          IF SQLCA.sqlcode THEN
             LET l_azf03 = ' '
          END IF 
               
       END IF
       IF tm.a = 'Y' THEN
 
          LET l_sql = "SELECT gem02 ",                                                                              
                  #    "  FROM ",l_dbs CLIPPED,"gem_file",  #FUN-A10098
                     #"  FROM ",cl_get_target_table(m_dbs[l_i],'gem_file'),  #FUN-A10098
                      "  FROM ",cl_get_target_table(m_plant[l_i],'gem_file'),  #FUN-A70084
                      " WHERE gem01='",sr.tlf19,"'"                           
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102 
         #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098 #FUN-A70084                                                                                                                                                     
         #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
          PREPARE gem_prepare2 FROM l_sql                                                                                          
          DECLARE gem_c2  CURSOR FOR gem_prepare2                                                                                 
          OPEN gem_c2                                                                                    
          FETCH gem_c2 INTO l_gem02
          
         IF SQLCA.sqlcode THEN 
            LET l_gem02 = NULL
         END IF
           LET l_sql = "SELECT ccz07 ",                                                                                             
                 #      " FROM ",l_dbs CLIPPED,"ccz_file ",           #FUN-A10098                                                               
                      #" FROM ",cl_get_target_table(m_dbs[l_i],'ccz_file'),           #FUN-A10098  #FUN-A70084                                                               
                       " FROM ",cl_get_target_table(m_plant[l_i],'ccz_file'),         #FUN-A70084 
                       " WHERE ccz00 = '0' "                                                                                        
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
          #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098     #FUN-A70084                                                         
          #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A70084  #TQC-BB0182 mark
           PREPARE ccz_p1 FROM l_sql                                                                                                
           IF SQLCA.SQLCODE THEN CALL cl_err('ccz_p1',SQLCA.SQLCODE,1) END IF                                                       
           DECLARE ccz_c1 CURSOR FOR ccz_p1                                                                                         
           OPEN ccz_c1                                                                                                              
           FETCH ccz_c1 INTO l_ccz07                                                                                                
           CLOSE ccz_c1
           CASE WHEN l_ccz07='1'                                                                                                    
                #     LET l_sql="SELECT ima39,ima391 FROM ",l_dbs CLIPPED,"ima_file ",      #FUN-A10098            
                    #LET l_sql="SELECT ima39,ima391 FROM ",cl_get_target_table(m_dbs[l_i],'ima_file'),      #FUN-A10098   #FUN-A70084          
                     LET l_sql="SELECT ima39,ima391 FROM ",cl_get_target_table(m_plant[l_i],'ima_file'),      #FUN-A70084
                               " WHERE ima01='",sr.tlf01,"'"                                                                     
                WHEN l_ccz07='2'                                                                                                    
                    LET l_sql="SELECT imz39,imz391 ",                                                  
                    #     " FROM ",l_dbs CLIPPED,"ima_file,",      #FUN-A10098                                                                   
                    #              l_dbs CLIPPED,"imz_file ",      #FUN-A10098           
                        #FUN-A70084--mod--str--
                        #" FROM ",cl_get_target_table(m_dbs[l_i],'ima_file'),",",      #FUN-A10098
                        #         cl_get_target_table(m_dbs[l_i],'imz_file'),      #FUN-A10098
                         " FROM ",cl_get_target_table(m_plant[l_i],'ima_file'),",",    
                                  cl_get_target_table(m_plant[l_i],'imz_file'),     
                        #FUN-A70084--mod--end
                         " WHERE ima01='",sr.tlf01,"' AND ima06=imz01 "                                                          
                WHEN l_ccz07='3'                                                                                                    
                    # LET l_sql="SELECT imd08,imd081 FROM ",l_dbs CLIPPED,"imd_file",    #FUN-A10098                      
                    #LET l_sql="SELECT imd08,imd081 FROM ",cl_get_target_table(m_dbs[l_i],'imd_file'),    #FUN-A10098    #FUN-A70084                  
                     LET l_sql="SELECT imd08,imd081 FROM ",cl_get_target_table(m_plant[l_i],'imd_file'),    #FUN-A70084
                         #" WHERE imd01='",sr.tlf031,"'"  #TQC-C80057  mark                                                                         
                         " WHERE imd01='",sr.tlf902,"'"   #TQC-C80057  add 
                WHEN l_ccz07='4'                                                                                                    
                  #   LET l_sql="SELECT ime09,ime091 FROM ",l_dbs CLIPPED,"ime_file",   #FUN-A10098        
                    #LET l_sql="SELECT ime09,ime091 FROM ",cl_get_target_table(m_dbs[l_i],'ime_file'),   #FUN-A10098    #FUN-A70084      
                     LET l_sql="SELECT ime09,ime091 FROM ",cl_get_target_table(m_plant[l_i],'ime_file'),   #FUN-A70084
                         #" WHERE ime01='",sr.tlf031,"' ", #TQC-C80057  mark                                                                        
                         #  " AND ime02='",l_tlf032,"'"    #TQC-C80057  mark     
                         " WHERE ime01='",sr.tlf902,"' ", #TQC-C80057  add
                         "   AND ime02='",sr.tlf903,"'"   #TQC-C80057  add                                                                
          END CASE
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
          #CALL cl_parse_qry_sql(l_sql,m_dbs[l_i]) RETURNING l_sql  #FUN-A10098  #FUN-A70084                                                           
          #CALL cl_parse_qry_sql(l_sql,m_plant[l_i]) RETURNING l_sql  #FUN-A10098    #TQC-BB0182 mark 
          PREPARE stock_p1 FROM l_sql                                                                                               
          IF SQLCA.SQLCODE THEN CALL cl_err('stock_p1',SQLCA.SQLCODE,1) END IF                                                      
          DECLARE stock_c1 CURSOR FOR stock_p1                                                                                      
          OPEN stock_c1                                                                                                             
          FETCH stock_c1 INTO l_ima39,l_ima391                                                                                           
          CLOSE stock_c1       
       END IF           
       LET l_tlf14 = ''
       LET l_tlf19 = ''
       LET l_tlf14 = sr.tlf14[1,4] 
       LET l_tlf19 = sr.tlf19[1,6]  
           EXECUTE insert_prep USING
              sr.order1,sr.tlf037,sr.tlf907,sr.tlf13,l_tlf14,         #FUN-9A0050 mod by liuxqa 
              sr.tlf17,l_tlf19,sr.tlf021,sr.tlf031,sr.tlf06,           #No.CHI-930028  #FUN-9A0050 mod by liuxqa 
              sr.tlf026,sr.tlf027,sr.tlf036,sr.tlf01,sr.tlf10,
              sr.ccc23a,sr.ccc23b,sr.ccc23c,sr.ccc23d,sr.ccc23e,
              sr.ccc23f,sr.ccc23g,sr.ccc23h,               #FUN-7C0101 ADD
              sr.ima02,sr.tlfccost,sr.ima021,sr.ima12,sr.l_ccc23a,sr.l_ccc23b, #FUN-7C0101 ADD sr.tlfccost
              sr.l_ccc23c,sr.l_ccc23d,sr.l_ccc23e,
              sr.l_ccc23f,sr.l_ccc23g,sr.l_ccc23h,         #FUN-7C0101 ADD
             #sr.l_tot,sr.ina09,     #MOD-D30247 mark
              sr.l_tot,              #MOD-D30247 
              #l_gem02,l_azf03,g_ccz.ccz27,g_azi03,  #CHI-C30012
              l_gem02,l_azf03,g_ccz.ccz27,g_ccz.ccz26,  #CHI-C30012
             #m_dbs[l_i],l_ima57,l_ima08                                 #FUN-8B0026 Add   #FUN-A70084
              m_plant[l_i],l_ima57,l_ima08                               #FUN-A70084 
              ,l_ima39,l_ima391,l_tlf930                                 #FUN-9A0050 Add              
     END FOREACH
   END FOR                                                                      #FUN-8B0026     
     CALL s_showmsg()                                                                                                               
     IF g_totsuccess="N" THEN                                                                                                       
        LET g_success="N"                                                                                                           
     END IF                                                                                                                         
     #IF tm.b = 'Y' THEN  #CHI-C20049
             SELECT SUM(cmi08) INTO l_exp_tot FROM cmi_file
              WHERE cmi01 = YEAR(tm.bdate) AND cmi02 = MONTH(tm.bdate)
                AND cmi05 = 'EXP'          
     #END IF  #CHI-C20049
     LET g_sql="SELECT  * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   
     CALL cl_wcchp(tm.wc,'ima12,ima57,ima08,tlf01,tlf14,tlf19')
             RETURNING tm.wc
     LET g_str=tm.wc,";",tm.a,";",tm.c,";",l_exp_tot,";",tm.bdate,";",tm.edate,";",   #CHI-C20049 tm.b->tm.c
               tm.s[1,1],";",tm.s[2,2],";",                    #FUN-8B0026
               tm.s[3,3],";",tm.t,";",tm.u,";",tm.b_1          #FUN-8B0026
 
#根據成本計算類型判定類別編號是否打印
     IF tm.type MATCHES '[12]' THEN
        IF g_aza.aza63 = 'Y' THEN
           LET l_name = 'axcr770_2'
        ELSE
        	 LET l_name = 'axcr770'
        END IF	     
         CALL cl_prt_cs3('axcr770',l_name,g_sql,g_str)             #FUN-9A0050 Add         
     ELSE 
        IF g_aza.aza63 = 'Y' THEN
           LET l_name = 'axcr770_3'
        ELSE
        	 LET l_name = 'axcr770_1'
        END IF	     
         CALL cl_prt_cs3('axcr770',l_name,g_sql,g_str)             #FUN-9A0050 Add         
     END IF 
END FUNCTION
 
FUNCTION r770_set_entry_1()
    CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",TRUE)
END FUNCTION
FUNCTION r770_set_no_entry_1()
    IF tm.b_1 = 'N' THEN
       CALL cl_set_comp_entry("p1,p2,p3,p4,p5,p6,p7,p8",FALSE)
       IF tm2.s1 = '7' THEN                                                                                                         
          LET tm2.s1 = ' '                                                                                                          
       END IF                                                                                                                       
       IF tm2.s2 = '7' THEN                                                                                                         
          LET tm2.s2 = ' '                                                                                                          
       END IF                                                                                                                       
       IF tm2.s3 = '7' THEN                                                                                                         
          LET tm2.s3 = ' '                                                                                                          
       END IF
    END IF
END FUNCTION
FUNCTION r770_set_comb()                                                                                                            
  DEFINE comb_value STRING                                                                                                          
  DEFINE comb_item  LIKE type_file.chr1000                                                                                          
                                                                                                                                    
    IF tm.b_1 ='N' THEN                                                                                                         
       LET comb_value = '1,2,3,4,5,6'                                                                                                   
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axc-982' AND ze02=g_lang                                                                                      
    ELSE                                                                                                                            
       LET comb_value = '1,2,3,4,5,6,7'                                                                                                   
       SELECT ze03 INTO comb_item FROM ze_file                                                                                      
         WHERE ze01='axc-983' AND ze02=g_lang                                                                                       
    END IF                                                                                                                          
    CALL cl_set_combo_items('s1',comb_value,comb_item)
    CALL cl_set_combo_items('s2',comb_value,comb_item)
    CALL cl_set_combo_items('s3',comb_value,comb_item)                                                                          
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18 
#FUN-A70084--add--str--
FUNCTION r770_set_visible()
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

FUNCTION r770_chklegal(l_legal,n)
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
