# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimr300.4gl
# Descriptions...: 庫存雜項發料/收料/報廢單列印
# Date & Author..: 95/03/20 By Danny
# Modify ........: No:9424 04/04/07 By Melody 當參數選擇要使用'保稅系統'時,雜項收發料的理由碼的類別會選用azf02='A',但是報表的條件卻直接指定azf02='2';造成報表無資料呈現!
# Modify ........: No:9132 04/07/08 By Mandy aimr300.4gl 第185 OUTER azf_file,where 條件azf01請改為azf_file.azf01,否則報表OUTER會有問題,實際是修正aimr300.ora
# Modify ........: No.FUN-4A0035 04/10/04 By Echo 單據編號, 部門編號,要開窗
# Modify ........: No.MOD-4A0293 04/10/21 By Nicola top99->No:9908
# Modify.........: No.FUN-550029 05/05/20 By Will 單據編號放大
# Modify.........: No.FUN-550108 05/05/25 By echo 新增報表備註
# Modfiy.........: No.FUN-560069 05/06/14 By jackie 雙單位報表格式修改
# Modify.........: No.FUN-580005 05/08/03 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modfiy.........: No.FUN-5A0138 05/10/20 By Claire 報表格式修改
# Modfiy.........: No.TQC-5B0127 05/11/14 By Mandy 異動原因說明未印出
# Modify.........: No.MOD-5C0022 05/12/06 By kim 理由碼放大至40碼
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610072 06/03/07 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-640080 06/04/09 By Sarah 增加列印"檢驗否"欄位
# Modify.........: No.FUN-660078 06/06/14 By rainy aim系統中，用char定義的變數，改為用LIKE
# Modify.........: No.FUN-660079 06/06/19 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/09 By ice 修正報表格式錯誤
# Modify.........: No.TQC-6B0068 06/11/15 By Ray 報表抬頭部分轉為template型寫法
# Modify.........: No.MOD-710138 07/01/23 By Ray 報表問題調整
# Modify.........: No.FUN-710084 07/01/30 By Elva 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 新增CR參數
# Modify.........: No.MOD-750120 07/05/24 By pengu 無法正常列印 
# Modify.........: No.MOD-840423 08/04/21 By Carol add ima021列印 
# Modify.........: No.FUN-860026 08/07/16 By baofei 增加子報表-列印批序號明細
# Modify.........: No.FUN-870163 08/08/21 By sherry 修改 數量(inb09) ,改成 申請數量(inb16),異動數量(inb09)
#                                                   多單位時印出 申請單位注解,異動單位注解
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-AC0047 10/12/06 By sabrina 修改MOD-5C0022
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No:FUN-940043 11/11/03 By xumm 整合單據列印EF簽核
# Modify.........: No.TQC-C10034 12/01/12 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No:TQC-CC0031 12/12/06 By xuxz mod tm.wc to STRING類型,l_sql STRING
# Modify.........: No.DEV-D30030 13/03/19 By TSD.JIE 與M-Barcode整合(aza131)='Y'時,列印單號條碼
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17    #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5    #No.FUN-690026 SMALLINT
END GLOBALS
#No.FUN-580005 --end--
 
DEFINE tm  RECORD                            # Print condition RECORD
          #wc      LIKE type_file.chr1000,   # Where condition  #No.FUN-690026 VARCHAR(500)#TQC-CC0031 mark
           wc      STRING,#TQC-CC0031 add
           a       LIKE type_file.chr1,      # 列印  #No.FUN-690026 VARCHAR(1)
           b       LIKE type_file.chr1,      # 過帳  #No.FUN-690026 VARCHAR(1)
           c       LIKE type_file.chr1,      #No.FUN-860026 列印明細表
           more    LIKE type_file.chr1       # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
           END RECORD,
      #g_buf       VARCHAR(40)                  #MOD-5C0022 20->40  #FUN-660078 remark
       g_buf       LIKE azf_file.azf03       #FUN-660078
DEFINE g_i         LIKE type_file.num5       #count/index for any purpose  #No.FUN-690026 SMALLINT
#No.FUN-580005 --start--
DEFINE g_sma115    LIKE sma_file.sma115
DEFINE g_sma116    LIKE sma_file.sma116
#No.FUN-580005 --end--
DEFINE    l_table     STRING,                       ### FUN-710084 ###
          g_sql       STRING                        ### FUN-710084 ###         
DEFINE    g_str       STRING                        ### FUN-710084 ### 
DEFINE    l_table1    STRING                          # No.FUN-860026 
DEFINE g_inb15_prt LIKE type_file.chr1000    #TQC-5B0127 add #FUN-5C0027 40->50 #No.FUN-690026 VARCHAR(50)
 
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
 
   ### FUN-710084 Start ### 
   LET g_sql =   "ina00.ina_file.ina00,smydesc.smy_file.smydesc,",
                 "ina01.ina_file.ina01,",
                 "ina02.ina_file.ina02,ina04.ina_file.ina04,",
                 "gem02.gem_file.gem02,ina06.ina_file.ina06,",
                 "ina07.ina_file.ina07,inb03.inb_file.inb03,",
                 "inb04.inb_file.inb04,ima02.ima_file.ima02,",
                 "ima021.ima_file.ima021,",                      #MOD-840423-add
                 "inb10.inb_file.inb10,inb12.inb_file.inb12,",
                 "inb09.inb_file.inb09,inb08.inb_file.inb08,",
                 "inb05.inb_file.inb05,inb06.inb_file.inb06,",
                 "inb07.inb_file.inb07,inb15.inb_file.inb15,",
#                 "azf03.azf_file.azf03,l_str2.type_file.chr1000"     #No.FUN-860026 
                 "azf03.azf_file.azf03,l_str2.type_file.chr1000,flag.type_file.num5,",  #No.FUN-860026
                 "inb16.inb_file.inb16,l_str3.type_file.chr1000,",    #No.FUN-870163    #No.FUN-940043 add ,,
                 "sign_type.type_file.chr1, sign_img.type_file.blob,", #簽核方式, 簽核圖檔    #No.FUN-940043 add
                 "sign_show.type_file.chr1 ,sign_str.type_file.chr1000" #是否顯示簽核資料(Y/N) #No.FUN-940043 add
                                                                        #簽核字串 #No.TQC-C10034 add sign_str.type_file.chr1000
    LET l_table = cl_prt_temptable('aimr300',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
#No.FUN-860026---begin
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                          
               "rvbs02.rvbs_file.rvbs02,",                                                                                          
               "rvbs103.rvbs_file.rvbs03,",                                                                                         
               "rvbs104.rvbs_file.rvbs04,",                                                                                         
               "rvbs106.rvbs_file.rvbs06,",                                                                                         
               "rvbs021.rvbs_file.rvbs021,",                                                                                        
               "rvbs203.rvbs_file.rvbs03,",                                                                                         
               "rvbs204.rvbs_file.rvbs04,",                                                                                         
               "rvbs206.rvbs_file.rvbs06,",                                                                                         
               "ima02.ima_file.ima02,",                                                                                           
               "ima021.ima_file.ima021,",                                                                                           
               "inb08.inb_file.inb08,",                                                                                             
               "img09.img_file.img09,",                                                                                             
               "inb09.inb_file.inb09"                                                                                               
   LET l_table1 = cl_prt_temptable('aimr3001',g_sql) CLIPPED                                                                        
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(15)        #No.FUN-860026
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
  #IF cl_null(tm.wc)
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
  #TQC-610072-end
      THEN CALL aimr300_tm(0,0)             # Input print condition
     # ELSE LET tm.wc="ina01= '",tm.wc CLIPPED,"'"     #TQC-610072
    ELSE                                               #TQC-610072
           CALL aimr300()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr300_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 18
   ELSE
       LET p_row = 3 LET p_col = 12
   END IF
 
   OPEN WINDOW aimr300_w AT p_row,p_col
        WITH FORM "aim/42f/aimr300"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
 
  #TQC-610072-begin
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '3'
   LET tm.c    = 'N'     #No.FUN-860026
   LET tm.b    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #TQC-610072-end
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ina00,ina01,ina04,ina02
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION locale
            #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
        #### No.FUN-4A0035
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ina01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_inb2"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ina01
                NEXT FIELD ina01
 
              WHEN INFIELD(ina04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gem"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ina04
                NEXT FIELD ina04
           END CASE
        ### END  No.FUN-4A0035
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.c,tm.a,tm.b,tm.more WITHOUT DEFAULTS    #No.FUN-860026 add tm.c
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
#No.FUN-860026---BEGIN
      AFTER FIELD c    #列印批序號明細                                                                                               
         IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c)                                                                                
            THEN NEXT FIELD c                                                                                                       
         END IF                
#No.FUN-860026---END
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[1-3]' THEN NEXT FIELD a END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[1-3]' THEN NEXT FIELD b END IF
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr300'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr300','9031',1)
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
                         " '",tm.c CLIPPED,"'",    #No.FUN-860026                      
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr300',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr300()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr300_w
END FUNCTION
 
FUNCTION aimr300()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)#TQC-CC0031 mark
          l_sql     STRING,#TQC-CC0031 add
#         l_sql_1   LIKE type_file.chr1000,       #No.FUN-940043 add  #No.TQC-C10034 mark
          l_chr     LIKE type_file.chr1,          #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,            #No.FUN-690026 VARCHAR(40)
          sr        RECORD
                    ina00     LIKE ina_file.ina00,    #類別
                    ina01     LIKE ina_file.ina01,    #編號
                    ina02     LIKE ina_file.ina02,    #日期
                    ina04     LIKE ina_file.ina04,    #部門
                    gem02     LIKE gem_file.gem02,    #名稱
                    ina05     LIKE ina_file.ina05,    #原因
                    azf03     LIKE azf_file.azf03,    #說明
                    ina06     LIKE ina_file.ina06,    #專案
                    ina07     LIKE ina_file.ina07,    #備註
                    inb03     LIKE inb_file.inb03,    #項次
                    inb04     LIKE inb_file.inb04,    #料件
                    ima02     LIKE ima_file.ima02,    #品名
                    ima021    LIKE ima_file.ima021,   #規格  #MOD-840423-add
                    inb05     LIKE inb_file.inb05,    #倉庫
                    inb06     LIKE inb_file.inb06,    #儲位
                    inb07     LIKE inb_file.inb07,    #批號
                    inb08     LIKE inb_file.inb08,    #單位
                    inb08_fac LIKE inb_file.inb08_fac,#轉換率
                    inb16     LIKE inb_file.inb16,    #No.FUN-870163          
                    inb09     LIKE inb_file.inb09,    #異動量
                    inb11     LIKE inb_file.inb11,    #來源單號
                    inb12     LIKE inb_file.inb12,    #參考單號
                    inb15     LIKE inb_file.inb15,
#No.FUN-560069 ---start--
                    inb902    LIKE inb_file.inb902, #單位一
                    inb903    LIKE inb_file.inb903, #單位一轉換率
                    inb904    LIKE inb_file.inb904, #單位一數量
                    inb905    LIKE inb_file.inb905, #單位二
                    inb906    LIKE inb_file.inb906, #單位二轉換率
                    inb907    LIKE inb_file.inb907, #單位二數量
#No.FUN-560069 ---end--
#No.FUN-870163 ---start--
                    inb922    LIKE inb_file.inb922, #單位一
                    inb923    LIKE inb_file.inb923, #單位一轉換率
                    inb924    LIKE inb_file.inb924, #單位一數量
                    inb925    LIKE inb_file.inb925, #單位二
                    inb926    LIKE inb_file.inb926, #單位二轉換率
                    inb927    LIKE inb_file.inb927, #單位二數量
#No.FUN-870163 ---end--
                    inaprsw   LIKE ina_file.inaprsw,  #列印
                    inapost   LIKE ina_file.inapost,  #過帳
                    inb10     LIKE inb_file.inb10     #檢驗否   #FUN-640080 add
                    END RECORD
     DEFINE l_i,l_cnt         LIKE type_file.num5     #No.FUN-580005  #No.FUN-690026 SMALLINT
     DEFINE l_zaa02           LIKE zaa_file.zaa02     #No.FUN-580005
     #FUN-710084  --begin
     DEFINE l_str2            LIKE type_file.chr1000 #No.FUN-580005  #No.FUN-690026 VARCHAR(100)
     DEFINE l_str3            LIKE type_file.chr1000 #No.FUN-870163 
     DEFINE l_x               LIKE smy_file.smyslip,  #FUN-710084  
            l_inb907          STRING,                #No.FUN-580005
            l_inb904          STRING,                #No.FUN-580005
            l_smydesc         LIKE smy_file.smydesc 
     DEFINE l_ima906  LIKE ima_file.ima906   #FUN-580005
     DEFINE l_inb927          STRING   #No.FUN-870163
     DEFINE l_inb924          STRING   #No.FUN-870163
#No.FUN-860026---begin                                                                                                              
     DEFINE       l_rvbs         RECORD                                                                                             
                                  rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                                  rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                                  rvbs06   LIKE  rvbs_file.rvbs06,                                                                  
                                  rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                                  END RECORD                                                                                        
     DEFINE        l_img09     LIKE img_file.img09                                                                                  
     DEFINE   rvbs1 DYNAMIC ARRAY OF RECORD                                                                                         
              rvbs03 LIKE rvbs_file.rvbs03,                                                                                         
              rvbs04 LIKE rvbs_file.rvbs04,                                                                                         
              rvbs06 LIKE rvbs_file.rvbs06                                                                                          
              END RECORD                                                                                                            
     DEFINE   rvbs2 DYNAMIC ARRAY OF RECORD                                                                                         
              rvbs03 LIKE rvbs_file.rvbs03,                                                                                         
              rvbs04 LIKE rvbs_file.rvbs04,                                                                                         
              rvbs06 LIKE rvbs_file.rvbs06                                                                                          
              END RECORD                                                                                                            
     DEFINE   m,i,j,k  LIKE type_file.num10             
     DEFINE   flag     LIKE type_file.num5                                                                              
     DEFINE   l_str1   LIKE type_file.chr1000
###No.FUN-940043 START###
     DEFINE   l_img_blob     LIKE type_file.blob
#No.TQC-C10034 ----- mark ----- begin
#     DEFINE   l_ii           INTEGER
#     DEFINE   l_key          RECORD                  #主鍵
#                 v1          LIKE ina_file.ina01
#                 END RECORD
#No.TQC-C10034 ----- mark ----- end
###No.FUN-940043 END###
#No.FUN-860026---end      
     CALL cl_del_data(l_table)        
     CALL cl_del_data(l_table1)  #No.FUN-860026
     LOCATE l_img_blob IN MEMORY #blob初始化  #No.FUN-940043 add
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #FUN-710084  --end
#No.FUN-860026---begin
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",   #MOD-840423-add                                                       
                "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?,?,?)"  #No.FUN-860026  #No.FUN-870163 add  #No.FUN-940043 add 3? #No.TQC-C10034 add 1?                                                                   
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
       EXIT PROGRAM                                                                            
    END IF            
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"                                                                           
     PREPARE insert_prep1 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep1:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
        EXIT PROGRAM                                                                          
     END IF                                                                                                                       
#No.FUN-860026---end  
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND inauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND inagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND inagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ina00,ina01,ina02,ina04,gem02,ina05,azf03,",
#                "       ina06,ina07,inb03,inb04,ima02,inb05,inb06,",          #MOD-840423-modify
                 "       ina06,ina07,inb03,inb04,ima02,ima021,inb05,inb06,",   #MOD-840423-modify
                 "       inb07,inb08,inb08_fac,inb16,inb09,inb11,inb12,inb15,",#No.FUN-870163 add inb16 
                 "       inb902,inb903,inb904,inb905,inb906,inb907,",   #No.FUN-560069
                 "       inb922,inb923,inb924,inb925,inb926,inb927,",   #No.FUN-870163
                 "       inaprsw,inapost,inb10",   #FUN-640080 add inb10
                 "  FROM ina_file,inb_file,OUTER gem_file,",
                 " OUTER azf_file,OUTER ima_file ",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND ina01=inb01 ",
                 "   AND ima_file.ima01=inb_file.inb04 ",
                 "   AND gem_file.gem01=ina_file.ina04 ",
                 "   AND azf_file.azf01=inb_file.inb15 ", #6818
     #No:9424
              #  "   AND azf_file.azf02='2'   ", #6818
                #"   AND inapost != 'X' " #FUN-660079
                 "   AND inaconf != 'X' " #FUN-660079
              #  " ORDER BY ina00,ina01,inb03 "
     IF g_sma.sma79='Y' THEN       #使用保稅系統
        LET l_sql=l_sql CLIPPED,
                  " AND azf_file.azf02='A' ",               #No.MOD-750120 modify
                  " ORDER BY ina00,ina01,inb03 "
     ELSE
        LET l_sql=l_sql CLIPPED,
                  " AND azf_file.azf02='2' ",
                  " ORDER BY ina00,ina01,inb03 "
     END IF
     #No:9424
 
     PREPARE aimr300_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
           
     END IF
     DECLARE aimr300_curs1 CURSOR FOR aimr300_prepare1
 
#No.TQC-C10034 ----- mark ----- begin
###No.FUN-940043 START ###

#    #單據key值
#    LET l_sql_1 = " SELECT ina01 ",
#                  "  FROM ina_file,inb_file,OUTER gem_file,",
#                  " OUTER azf_file,OUTER ima_file ",
#                  "  WHERE ina_file.ina01=inb_file.inb01 ",
#                  "    AND ima_file.ima01=inb_file.inb04 ",
#                  "    AND gem_file.gem01=ina_file.ina04 ",
#                  "    AND azf_file.azf01=inb_file.inb15 ",
#                  "    AND inaconf != 'X' ",
#                  "    AND ",tm.wc CLIPPED

#    IF g_sma.sma79='Y' THEN       #使用保稅系統
#       LET l_sql_1=l_sql_1 CLIPPED,
#                   " AND azf_file.azf02='A' ",
#                   " ORDER BY ina01 "
#    ELSE
#       LET l_sql_1=l_sql_1 CLIPPED,
#                   " AND azf_file.azf02='2' ",
#                   " ORDER BY ina01 "
#    END IF

#    PREPARE r300_pr1 FROM l_sql_1
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('prepare r300_pr1:',SQLCA.sqlcode,0)
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time
#       EXIT PROGRAM
#    END IF
#    DECLARE r300_cs1 CURSOR FOR r300_pr1
###No.FUN-940043 END###
#No.TQC-C10034 ----- mark ----- end
   #FUN-710084  --begin
   # CALL cl_outnam('aimr300') RETURNING l_name
     #No.FUN-580005 --start--
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
   # IF g_sma115 = "Y" THEN
   #    LET g_zaa[37].zaa06 = "N"
   # ELSE
   #    LET g_zaa[37].zaa06 = "Y"
   # END IF
   # CALL cl_prt_pos_len()
     #No.FUN-580005 --end--
 
   # START REPORT aimr300_rep TO l_name
   #FUN-710084  --end
 
     LET g_pageno = 0
     FOREACH aimr300_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.inaprsw) THEN LET sr.inaprsw=0 END IF
       IF tm.a='1' AND sr.inaprsw = 0 THEN CONTINUE FOREACH END IF   #已列印
       IF tm.a='2' AND sr.inaprsw > 0 THEN CONTINUE FOREACH END IF   #未列印
       IF tm.b='1' AND sr.inapost !='Y' THEN CONTINUE FOREACH END IF   #已過帳
       IF tm.b='2' AND sr.inapost !='N' THEN CONTINUE FOREACH END IF   #未過帳
       IF cl_null(sr.inb09) THEN LET sr.inb09=0 END IF
       IF cl_null(sr.inb08_fac) THEN LET sr.inb08_fac=0 END IF
        UPDATE ina_file SET inaprsw = sr.inaprsw+1    #No.MOD-4A0293
        WHERE ina01 = sr.ina01
### FUN-710084 Start ###
        CALL s_get_doc_no(sr.ina01) RETURNING l_x  #No.FUN-550029
        SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=l_x
       #MOD-AC0047---add---start---
        IF g_sma.sma79 = 'Y' THEN
           SELECT azf03 INTO sr.azf03 FROM azf_file 
            WHERE azf01=sr.inb15 AND azf02 ='A'
        ELSE
       #MOD-AC0047---add---end---                                         
           SELECT azf03 INTO sr.azf03 FROM azf_file WHERE azf01=sr.inb15
                                                   AND azf02='2' #MOD-5C0022
        END IF              #MOD-AC0047 add
   #    LET g_inb15_prt = sr.inb15 CLIPPED,' ',g_buf CLIPPED  #TQC-5B0127 add
        SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01 = sr.inb04
        LET l_str2 = ""
        LET l_str3 = ""     #No.FUN-870163
        IF g_sma115 = "Y" THEN
           IF NOT cl_null(sr.inb907) AND sr.inb907 <> 0 THEN
              CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
              LET l_str2 = l_inb907, sr.inb905 CLIPPED
           END IF
           #No.FUN-870163---Begin
           IF NOT cl_null(sr.inb927) AND sr.inb927 <> 0 THEN
              CALL cl_remove_zero(sr.inb927) RETURNING l_inb927
              LET l_str3 = l_inb927, sr.inb925 CLIPPED
           END IF
           #No.FUN-870163---End
           IF l_ima906 = "2" THEN
              IF cl_null(sr.inb907) OR sr.inb907 = 0 THEN
                 CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                 LET l_str2 = l_inb904, sr.inb902 CLIPPED
              ELSE
                 IF NOT cl_null(sr.inb904) AND sr.inb904 <> 0 THEN
                    CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                    LET l_str2 = l_str2 CLIPPED,',',l_inb904, sr.inb902 CLIPPED
                 END IF
              END IF
              #No.FUN-870163---Begin
              IF cl_null(sr.inb927) OR sr.inb927 = 0 THEN
                 CALL cl_remove_zero(sr.inb924) RETURNING l_inb924
                 LET l_str3 = l_inb924, sr.inb922 CLIPPED
              ELSE
                 IF NOT cl_null(sr.inb924) AND sr.inb924 <> 0 THEN
                    CALL cl_remove_zero(sr.inb924) RETURNING l_inb924
                    LET l_str3 = l_str3 CLIPPED,',',l_inb924, sr.inb922 CLIPPED
                 END IF
              END IF
              #No.FUN-870163---End
           END IF
        END IF
#No.FUN-860026---begin       
      LET flag= 0                                                                                                       
        SELECT img09 INTO l_img09  FROM img_file WHERE img01 = sr.inb04                                                             
               AND img02 = sr.inb05 AND img03 = sr.inb06                                                                            
               AND img04 = sr.inb07                                                                                                 
    DECLARE r920_d  CURSOR  FOR                                                                                                     
           SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
                  WHERE rvbs01 = sr.ina01 AND rvbs02 = sr.inb03                                                                     
                  ORDER BY  rvbs04                                                                                                  
    LET m = 0 LET i=0 LET j=0                                                                                                       
    FOREACH  r920_d INTO l_rvbs.*           
      LET flag = 1                                                                                        
      LET m=m+1                                                                                                                     
      IF (m mod 2) = 1  THEN                                                                                                        
         LET i=i+1                                                                                                                  
         INITIALIZE rvbs1[i].* TO NULL                                                                                              
         LET rvbs1[i].rvbs03 = l_rvbs.rvbs03                                                                                        
         LET rvbs1[i].rvbs04 = l_rvbs.rvbs04                                                                                        
         LET rvbs1[i].rvbs06 = l_rvbs.rvbs06                                                                                        
      ELSE                    
         LET j=j+1                                                                                                                  
         INITIALIZE rvbs2[j].* TO NULL                                                                                              
         LET rvbs2[j].rvbs03 = l_rvbs.rvbs03                                                                                        
         LET rvbs2[j].rvbs04 = l_rvbs.rvbs04                                                                                        
         LET rvbs2[j].rvbs06 = l_rvbs.rvbs06                                                                                        
      END IF                                                                                                                        
    END FOREACH                                                                                                                     
      IF i>j THEN LET k=i ELSE LET k=j END IF                                                                                       
      FOR i=1 TO k                                                                                                                  
         EXECUTE insert_prep1 USING  sr.ina01,sr.inb03,rvbs1[i].rvbs03,                                                             
                                     rvbs1[i].rvbs04,rvbs1[i].rvbs06,l_rvbs.rvbs021,                                                
                                     rvbs2[i].rvbs03,rvbs2[i].rvbs04,rvbs2[i].rvbs06,                                               
                                     sr.ima02,sr.ima021,sr.inb08,l_img09,sr.inb09                                                   
      END FOR                                                                                                                       
#No.FUN-860026---end     
        EXECUTE insert_prep USING sr.ina00,l_smydesc,sr.ina01,sr.ina02,sr.ina04,sr.gem02,
#                                 sr.ina06,sr.ina07,sr.inb03,sr.inb04,sr.ima02,              #MOD-840423-modify
                                  sr.ina06,sr.ina07,sr.inb03,sr.inb04,sr.ima02,sr.ima021,    #MOD-840423-modify
                                  sr.inb10,sr.inb12,sr.inb09,sr.inb08,sr.inb05,
                                  sr.inb06,sr.inb07,sr.inb15,sr.azf03,l_str2,flag, #No.FUN-860026  add flag
                                  sr.inb16,l_str3,    #No.FUN-870163  #No.FUN-940043 add ,
                                  "",l_img_blob,"N",""   #No.FUN-940043 add #No.TQC-C10034 add ""
      #OUTPUT TO REPORT aimr300_rep(sr.*)
     END FOREACH
 
    #FINISH REPORT aimr300_rep
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
   # LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED #No.FUN-820026
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED, l_table1 CLIPPED  #No.FUN-860026
     LET g_str = g_sma115
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #是否列印選擇條件                                                            
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'ina00,ina01,ina04,ina02')                            
             RETURNING tm.wc                                                      
#        LET g_str = g_str ,";",tm.wc    #No.FUN-860026 
         LET l_str1 = tm.wc                                      
     END IF
     LET g_str = g_str,";",l_str1,";",tm.c   #No.FUN-860026
                 ,";",g_aza.aza131           #DEV-D30030	

   # CALL cl_prt_cs3('aimr300',l_sql,g_str)   #TQC-730088
#No.TQC-C10034 ----- mark ----- begin
###No.FUN-940043 START###
#    LET g_cr_table = l_table                 #主報表的temp table名稱
#    LET g_cr_gcx01 = "asmi300"               #單別維護程式
#    LET g_cr_apr_key_f = "ina01"             #報表主鍵欄位名稱，用"|"隔開
#    LET l_ii = 1
#    #報表主鍵值
#    CALL g_cr_apr_key.clear()                #清空
#    FOREACH r300_cs1 INTO l_key.*
#       LET g_cr_apr_key[l_ii].v1 = l_key.v1
#       LET l_ii = l_ii + 1
#    END FOREACH
###No.FUN-940043 END###
#No.TQC-C10034 ----- mark ----- end
     LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
     LET g_cr_apr_key_f = "ina01"             #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
     CALL cl_prt_cs3('aimr300','aimr300',l_sql,g_str)
### FUN-710084 End ###
END FUNCTION
### FUN-710084 Start ###
{
REPORT aimr300_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_smydesc LIKE smy_file.smydesc,
          l_x       LIKE smy_file.smyslip,  #No.FUN-550029 #No.FUN-690026 VARCHAR(05)
          sr        RECORD
                    ina00     LIKE ina_file.ina00,    #類別
                    ina01     LIKE ina_file.ina01,    #編號
                    ina02     LIKE ina_file.ina02,    #日期
                    ina04     LIKE ina_file.ina04,    #部門
                    gem02     LIKE gem_file.gem02,    #名稱
                    ina05     LIKE ina_file.ina05,    #原因
                    azf03     LIKE azf_file.azf03,    #說明
                    ina06     LIKE ina_file.ina06,    #專案
                    ina07     LIKE ina_file.ina07,    #備註
                    inb03     LIKE inb_file.inb03,    #項次
                    inb04     LIKE inb_file.inb04,    #料件
                    ima02     LIKE ima_file.ima02,    #品名
                    inb05     LIKE inb_file.inb05,    #倉庫
                    inb05     LIKE inb_file.inb05,    #倉庫
                    inb06     LIKE inb_file.inb06,    #儲位
                    inb07     LIKE inb_file.inb07,    #批號
                    inb08     LIKE inb_file.inb08,    #單位
                    inb08_fac LIKE inb_file.inb08_fac,#轉換率
                    inb09     LIKE inb_file.inb09,    #異動量
                    inb11     LIKE inb_file.inb11,    #來源單號
                    inb12     LIKE inb_file.inb12,    #參考單號
                    inb15     LIKE inb_file.inb15,
#No.FUN-560069 ---start--
                    inb902    LIKE inb_file.inb902, #單位一
                    inb903    LIKE inb_file.inb903, #單位一轉換率
                    inb904    LIKE inb_file.inb904, #單位一數量
                    inb905    LIKE inb_file.inb905, #單位二
                    inb906    LIKE inb_file.inb906, #單位二轉換率
                    inb907    LIKE inb_file.inb907, #單位二數量
#No.FUN-560069 ---end--
                    inaprsw   LIKE ina_file.inaprsw,  #列印
                    inapost   LIKE ina_file.inapost,  #過帳
                    inb10     LIKE inb_file.inb10     #檢驗否   #FUN-640080 add
                    END RECORD
   DEFINE l_str2    LIKE type_file.chr1000,#No.FUN-580005  #No.FUN-690026 VARCHAR(100)
          l_inb907  STRING,                #No.FUN-580005
          l_inb904  STRING                 #No.FUN-580005
   DEFINE l_ima906  LIKE ima_file.ima906   #FUN-580005
 
  OUTPUT TOP MARGIN 0
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN 5
         PAGE LENGTH g_page_line
  ORDER BY sr.ina00,sr.ina01,sr.inb03
  FORMAT
   PAGE HEADER
#No.TQC-6B0068 --begin
      CASE WHEN sr.ina00='1' LET g_x[1]=g_x[19]
           WHEN sr.ina00='2' LET g_x[1]=g_x[22]
           WHEN sr.ina00='3' LET g_x[1]=g_x[20]
           WHEN sr.ina00='4' LET g_x[1]=g_x[23]
           WHEN sr.ina00='5' LET g_x[1]=g_x[21]
           WHEN sr.ina00='6' LET g_x[1]=g_x[24]
      END CASE
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      CALL s_get_doc_no(sr.ina01) RETURNING l_x  #No.FUN-550029
      SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=l_x
      IF SQLCA.SQLCODE THEN LET l_smydesc='' END IF
      PRINT COLUMN (g_len-FGL_WIDTH(l_smydesc CLIPPED))/2,l_smydesc CLIPPED
      PRINT g_head CLIPPED, pageno_total
 
 
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     CASE WHEN sr.ina00='1' LET g_x[1]=g_x[19]
#          WHEN sr.ina00='2' LET g_x[1]=g_x[22]
#          WHEN sr.ina00='3' LET g_x[1]=g_x[20]
#          WHEN sr.ina00='4' LET g_x[1]=g_x[23]
#          WHEN sr.ina00='5' LET g_x[1]=g_x[21]
#          WHEN sr.ina00='6' LET g_x[1]=g_x[24]
#     END CASE
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0078
#     PRINT
#     LET g_pageno = g_pageno + 1
#     CALL s_get_doc_no(sr.ina01) RETURNING l_x  #No.FUN-550029
#     SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=l_x
#     IF SQLCA.SQLCODE THEN LET l_smydesc='' END IF
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN (g_len-FGL_WIDTH(l_smydesc CLIPPED))/2,l_smydesc CLIPPED,   #No.TQC-6A0078
#           COLUMN g_len-7,g_x[3] CLIPPED CLIPPED,PAGENO USING '<<<'
#No.MOD-710138 --begin
      PRINT g_dash[1,g_len]
      PRINT g_x[11] CLIPPED,sr.ina01 CLIPPED,COLUMN 27,g_x[12] CLIPPED,           #No.FUN-550029
            sr.ina04 CLIPPED,' ',sr.gem02 CLIPPED
      PRINT g_x[14] CLIPPED,sr.ina02,COLUMN 27,g_x[15] CLIPPED,sr.ina06 CLIPPED,  #No.FUN-550029  #No.TQC-6A0078
            COLUMN 46,g_x[16] CLIPPED,sr.ina07 CLIPPED
#No.MOD-710138 --end
#No.TQC-6B0068 --end
      PRINT g_dash[1,g_len]
#No.FUN-560069 --start--
 #    PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]  #FUN-5A0138
 #    PRINTX name=H2 g_x[39],g_x[40]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]  #FUN-5A0138
      PRINTX name=H2 g_x[39],g_x[40],g_x[38]
      PRINTX name=H3 g_x[41],g_x[42],g_x[37],g_x[75]   #FUN-640080 add g_x[75]
#No.FUN-560069 --end--
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ina01
      SKIP TO TOP OF PAGE
 
   ON EVERY ROW
      SELECT azf03 INTO g_buf FROM azf_file WHERE azf01=sr.inb15
                                              AND azf_file.azf02='2' #MOD-5C0022
     #LET sr.inb15 = sr.inb15 CLIPPED,' ',g_buf CLIPPED     #TQC-5B0127 mark
      LET g_inb15_prt = sr.inb15 CLIPPED,' ',g_buf CLIPPED  #TQC-5B0127 add
      SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01 = sr.inb04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         IF NOT cl_null(sr.inb907) AND sr.inb907 <> 0 THEN
            CALL cl_remove_zero(sr.inb907) RETURNING l_inb907
            LET l_str2 = l_inb907, sr.inb905 CLIPPED
         END IF
         IF l_ima906 = "2" THEN
            IF cl_null(sr.inb907) OR sr.inb907 = 0 THEN
               CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
               LET l_str2 = l_inb904, sr.inb902 CLIPPED
            ELSE
               IF NOT cl_null(sr.inb904) AND sr.inb904 <> 0 THEN
                  CALL cl_remove_zero(sr.inb904) RETURNING l_inb904
                  LET l_str2 = l_str2 CLIPPED,',',l_inb904, sr.inb902 CLIPPED
               END IF
            END IF
         END IF
      END IF
#No.FUN-560069 ---start--
      PRINTX name=D1 COLUMN g_c[31], sr.inb03 USING '###&', #FUN-590118
                     COLUMN g_c[32], sr.inb04[1,30] CLIPPED,  #No.TQC-6A0078
                     COLUMN g_c[33], sr.inb05 CLIPPED,
                     COLUMN g_c[34], sr.inb06 CLIPPED,
                     COLUMN g_c[35], sr.inb08 CLIPPED,
                     COLUMN g_c[36], cl_numfor(sr.inb09,36,3)
                  #  COLUMN g_c[37], l_str2 CLIPPED,  #FUN-5A0138
                  #  COLUMN g_c[38], sr.inb12 CLIPPED #FUN-5A0138
      PRINTX name=D2 COLUMN g_c[39], ' ',
                     COLUMN g_c[40], sr.ima02[1,30] CLIPPED,   #No.TQC-6A0078
                     COLUMN g_c[38], sr.inb12[1,8] CLIPPED #FUN-5A0138  #No.TQC-6A0078
      PRINTX name=D3 COLUMN g_c[41], ' ',
                     COLUMN g_c[42], g_inb15_prt[1,30] CLIPPED, #TQC-5B0127 MOD   #No.TQC-6A0078
                     COLUMN g_c[37], l_str2 CLIPPED  #FUN-5A0138
                    ,COLUMN g_c[75], sr.inb10 CLIPPED   #FUN-640080 add
      PRINT  ' '
#No.FUN-560069 ---end--
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
## FUN-550108
   #PRINT g_x[27] CLIPPED,'                    ',
   #      g_x[28] CLIPPED,'                    ',
   #      g_x[29] CLIPPED
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT ' ' #FUN-5A0138
             PRINT g_x[27]
             PRINT g_memo
         ELSE
             PRINT ' ' #FUN-5A0138
             PRINT
             PRINT
         END IF
      ELSE
             PRINT ' ' #FUN-5A0138
             PRINT g_x[27]
             PRINT g_memo
      END IF
## END FUN-550108
 
 
END REPORT}
### FUN-710084 End ###
#Patch....NO.TQC-610036 <> #
