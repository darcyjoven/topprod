# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asfr620.4gl
# Descriptions...: 工單完工/入庫/入庫退回單據列印
# Date & Author..: 97/07/24  By  Sophia
# Modify.........: No.FUN-4B0022 04/11/05 By Yuna 新增入庫單號,工單編號開窗
# Modify.........: No.MOD-4B0092 抓相關zz資料時應改用 g_prog
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-550012 05/05/20 By pengu FQC單號改放工單完工入庫單身
# Modify.........: No.FUN-550114 05/06/01 By echo 新增報表備註
# Modify.........: No.MOD-550173 05/05/24 By pengu  1.報表格式錯誤
           #       2.l_sql有錯，如果有asft620串asfr620時是可以執行的，但如果直接執行asfr620卻無法產生資料列印
# Modify.........: No.FUN-560069 05/06/28 By jackie 雙單位報表格式修改
# Modify.........: No.FUN-580005 05/08/05 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: No.FUN-5A0140 05/10/21 By Claire 報表格式調整
# Modify.........: No.FUN-5A0446 05/11/01 By Claire 報表格式調整
# Modify.........: NO.TQC-5A0118 05/12/13 BY yiting g_x[40]屬於單身抬頭欄位，不能直接更改g_x[40]的內容
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-650053 06/05/12 By kim asft623 列印出來的報表 報表名稱和左下角程式名稱都是 asft620
# Modify.........: No.FUN-660137 06/06/21 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0002 06/11/15 By johnray 報表修改
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-860026 08/07/22 By baofei 增加子報表-列印批序號明細
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50156 10/05/27 By Carrier MOD-A20049追单
# Modify.........: No:MOD-A60130 10/06/21 By Sarah 理由碼改顯示sfv44 
# Modify.........: No:MOD-A20049 10/07/27 By Pengu l_str2變數未給default值
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-BA0078 11/11/04 By minpp 整合單據列印EF簽核
# Modify.........: No:TQC-C10039 12/01/04 By wangrr 整合單據列印EF簽核 
# Modify.........: No.DEV-D30028 13/03/18 By TSD.JIE 與M-Barcode整合(aza131)='Y',列印單號條碼

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17          #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5          #No.FUN-680121 SMALLINT
END GLOBALS
#No.FUN-580005 --end--
 
#   DEFINE g_dash1       VARCHAR(80)
   DEFINE tm  RECORD                   # Print condition RECORD
#             wc        VARCHAR(600),       # Where condition   #TQC-630166
              wc        STRING,          # Where condition   #TQC-630166
              a         LIKE type_file.chr1,          #No.FUN-860026
              more      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD,
         g_sfu00       LIKE sfu_file.sfu00
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-580005 --start--
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580005 --end--
#No.FUN-710082--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_table1   STRING                 #No.FUN-860026 
DEFINE  l_str      STRING   
#No.FUN-710082--end  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   LET g_prog = ARG_VAL(1)             
   LET g_sfu00 = ARG_VAL(2)
   LET g_pdate = ARG_VAL(3)            # Get arguments from command line
   LET g_towhom = ARG_VAL(4)
   LET g_rlang = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)
   LET g_prtway = ARG_VAL(7)
   LET g_copies = ARG_VAL(8)
   LET tm.wc = ARG_VAL(9)
   LET tm.a  = ARG_VAL(14)  #No.FUN-860026
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
   #No.FUN-710082--begin
   LET g_sql ="sfu00.sfu_file.sfu00,sfu01.sfu_file.sfu01,",
              "sfu02.sfu_file.sfu02,sfv17.sfv_file.sfv17,",
              "sfu04.sfu_file.sfu04,gem02.gem_file.gem02,",
              "sfu05.sfu_file.sfu05,azf03.azf_file.azf03,",
              "sfu06.sfu_file.sfu06,sfu07.sfu_file.sfu07,",
              "sfv03.sfv_file.sfv03,sfv11.sfv_file.sfv11,",
              "sfv04.sfv_file.sfv04,ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,sfv14.sfv_file.sfv14,",
              "sfv15.sfv_file.sfv15,sfv08.sfv_file.sfv08,",
              "sfv05.sfv_file.sfv05,sfv06.sfv_file.sfv06,",
              "sfv07.sfv_file.sfv07,sfv09.sfv_file.sfv09,",
              "sfv13.sfv_file.sfv13,sfv12.sfv_file.sfv12,",
              "sfv30.sfv_file.sfv30,sfv31.sfv_file.sfv31,",
              "sfv32.sfv_file.sfv32,sfv33.sfv_file.sfv33,",
              "sfv34.sfv_file.sfv34,sfv35.sfv_file.sfv35,",
              "sfv44.sfv_file.sfv44,azf03_1.azf_file.azf03,",  #MOD-A60130 add
              "str.type_file.chr1000,flag.type_file.num5,",      #No:FUN-860026
              "sign_type.type_file.chr1,",#簽核方式   #No.FUN-BA0078
              "sign_img.type_file.blob,", #簽核圖檔   #No.FUN-BA0078
              "sign_show.type_file.chr1,",  #是否顯示簽核資料(Y/N) #No.FUN-BA0078
              "sign_str.type_file.chr1000"  #TQC-C10039 sign_str

   LET l_table = cl_prt_temptable('asfr620',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-860026---begin                                                                                                              
   LET g_sql = "rvbs01.rvbs_file.rvbs01,rvbs02.rvbs_file.rvbs02,",
               "rvbs03.rvbs_file.rvbs03,rvbs04.rvbs_file.rvbs04,",
               "rvbs06.rvbs_file.rvbs06,rvbs021.rvbs_file.rvbs021,",
               "ima02.ima_file.ima02,ima021.ima_file.ima021,", 
               "sfv08.sfv_file.sfv08,sfv09.sfv_file.sfv09,",
               "img09.img_file.img09"
   LET l_table1 = cl_prt_temptable('asfr6201',g_sql) CLIPPED                                                                        
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                       
#  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
#              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
#              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?) "
#  PREPARE insert_prep FROM g_sql
#  IF STATUS THEN
#     CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
#  END IF
#No.FUN-860026---end
   #No.FUN-710082--end  
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL r620_tm(0,0)        # Input print condition
      ELSE CALL r620()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r620_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000          #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW r620_w AT p_row,p_col WITH FORM "asf/42f/asfr620"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   # 2004/06/02 共用程式時呼叫
   CALL cl_set_locale_frm_name("asfr620")
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a  =  'N'   #No.FUN-860026
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_sfu00 = '1'                  #TQC-610080
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfu01,sfv11,sfu02
     #--No.FUN-4B0022-------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
       CASE WHEN INFIELD(sfu01)      #入庫單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_sfu"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfu01
                 NEXT FIELD sfu01
            WHEN INFIELD(sfv11)      #工單單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_sfv"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfv11
                 NEXT FIELD sfv11
 
       OTHERWISE EXIT CASE
       END CASE
     #--END---------------
     ON ACTION locale
#        CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS    #No.FUN-860026   add tm.a
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
#No.FUN-860026---BEGIN                                                                                                              
      AFTER FIELD a    #列印批序號明細                                                                                              
         IF tm.a NOT MATCHES "[YN]" OR cl_null(tm.a)                                                                                
            THEN NEXT FIELD a                                                                                                       
         END IF                                                                                                                     
#No.FUN-860026---END 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
     #TQC-610080-begin                             
     CASE WHEN g_prog = 'asfr621' 
            LET g_prog='asfr620'
          WHEN g_prog = 'asfr622'
            LET g_prog='asfr620'
          WHEN g_prog = 'asfr623'
            LET g_prog='asfr620'
     END CASE 
     #TQC-610080-end                             
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             #WHERE zz01='asfr620' #MOD-4B0092
              WHERE zz01=g_prog    #MOD-4B0092
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr620','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_prog  CLIPPED,"'",            #TQC-610080
                         " '",g_sfu00  CLIPPED,"'",            #TQC-610080
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",    #No.FUN-860026
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asfr620',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r620()
   ERROR ""
END WHILE
   CLOSE WINDOW r620_w
END FUNCTION
 
FUNCTION r620()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#         l_time    LIKE type_file.chr8           #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  TQC-630166          #No.FUN-680121 VARCHAR(1200)
          l_sql     STRING,                       # RDSQL STATEMENT  TQC-630166
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          sr        RECORD
                    sfu00   LIKE sfu_file.sfu00,
                    sfu01   LIKE sfu_file.sfu01,
                    sfu02   LIKE sfu_file.sfu02,
                    sfv17   LIKE sfv_file.sfv17,  #No.FUN-550012
                    sfu04   LIKE sfu_file.sfu04,
                    gem02   LIKE gem_file.gem02,
                    sfu05   LIKE sfu_file.sfu05,
                    azf03   LIKE azf_file.azf03,
                    sfu06   LIKE sfu_file.sfu06,
                    sfu07   LIKE sfu_file.sfu07,
                    sfv03   LIKE sfv_file.sfv03,
                    sfv11   LIKE sfv_file.sfv11,
                    sfv04   LIKE sfv_file.sfv04,
                    ima02   LIKE ima_file.ima02,
                    ima021  LIKE ima_file.ima021,
                    sfv14   LIKE sfv_file.sfv14,
                    sfv15   LIKE sfv_file.sfv15,
                    sfv08   LIKE sfv_file.sfv08,
                    sfv05   LIKE sfv_file.sfv05,
                    sfv06   LIKE sfv_file.sfv06,
                    sfv07   LIKE sfv_file.sfv07,
                    sfv09   LIKE sfv_file.sfv09,
                    sfv13   LIKE sfv_file.sfv13,
#No.FUN-560069 --start--
                    sfv12   LIKE sfv_file.sfv12,
                    sfv30   LIKE sfv_file.sfv30,
                    sfv31   LIKE sfv_file.sfv31,
                    sfv32   LIKE sfv_file.sfv32,
                    sfv33   LIKE sfv_file.sfv33,
                    sfv34   LIKE sfv_file.sfv34,
                    sfv35   LIKE sfv_file.sfv35,
#No.FUN-560069 --end--
                    sfv44   LIKE sfv_file.sfv44,  #MOD-A60130 add
                    azf03_1 LIKE azf_file.azf03   #MOD-A60130 add
                    END RECORD
#  DEFINE l_prog    STRING                        #No.FUN-710082
   DEFINE l_prog    LIKE type_file.chr10          #No.FUN-710082
   DEFINE l_i,l_cnt LIKE type_file.num5           #No.FUN-580005        #No.FUN-680121 SMALLINT
   DEFINE l_zaa02   LIKE zaa_file.zaa02           #No.FUN-580005
#No.FUN-710082--begin
   DEFINE l_str2    LIKE type_file.chr1000        #No.FUN-680121 #No.FUN-580005
   DEFINE l_sfv35   STRING                        #No.FUN-580005
   DEFINE l_sfv32   STRING                        #No.FUN-580005
   DEFINE l_ima906  LIKE ima_file.ima906          #FUN-580005
#No.FUN-710082--end  
#No.FUN-860026---begin                                                                                                              
   DEFINE l_rvbs    RECORD                                                                                             
                     rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                     rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                     rvbs06   LIKE  rvbs_file.rvbs06,                                                                  
                     rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                    END RECORD                                                                                        
   DEFINE l_img09   LIKE img_file.img09           
   DEFINE flag      LIKE type_file.num5                                                                       
#No.FUN-860026---end 
#FUN-BA0078--ADD-STR--  
   DEFINE            l_img_blob     LIKE type_file.blob
#TQC-C10039--start--mark---
   #DEFINE            l_ii           INTEGER
   #DEFINE            l_key          RECORD                  #主鍵
   #                     v1          LIKE sfu_file.sfu01
   #                                 END RECORD
#TQC-C10039--end--mark---  
  #FUN-BA0078--ADD-END-- 
   DEFINE l_aza131  LIKE aza_file.aza131 #DEV-D30028

 CALL cl_del_data(l_table1)   #No.FUN-860026
   LOCATE l_img_blob IN MEMORY #blob初始化 #No.FUN-BA0078
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-860026---BEGIN
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",                                                                         
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) " #No:FUN-860026 add ?  #MOD-A60130 add 2?  #FUN-BA0078 ADD 3?#TQC-C10039 add 1?
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM                                                                             
   END IF     
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                                                                                 
   PREPARE insert_prep1 FROM l_sql                                                                                                
   IF STATUS THEN                                                                                                                 
      CALL cl_err("insert_prep1:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM                                                                          
   END IF         
#No.FUN-860026---END
   #Begin:FUN-980030
   #IF g_priv2='4' THEN                           #只能使用自己的資料
   #   LET tm.wc = tm.wc clipped," AND sfuuser = '",g_user,"'"
   #END IF
   #IF g_priv3='4' THEN                           #只能使用相同群的資料
   #   LET tm.wc = tm.wc clipped," AND sfugrup MATCHES '",g_grup CLIPPED,"*'"
   #END IF
   #IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #   LET tm.wc = tm.wc clipped," AND sfugrup IN ",cl_chk_tgrup_list()
   #END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfuuser', 'sfugrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT sfu00,sfu01,sfu02,sfv17,sfu04,gem02,sfu05,azf03,",    #No.FUN-550012
               "sfu06,sfu07,sfv03,sfv11,sfv04,ima02,ima021,sfv14,sfv15,sfv08,",
               "sfv05,sfv06,sfv07,sfv09,sfv13,sfv12,", #No.FUN-560069
               "sfv30,sfv31,sfv32,sfv33,sfv34,sfv35,sfv44,'' ",   #No.FUN-560069  #MOD-A60130 add sfv44,''
               " FROM sfu_file, sfv_file, ",
               "  OUTER gem_file, OUTER ima_file, OUTER azf_file ",
               " WHERE sfu01 = sfv01 AND  sfu_file.sfu04=gem_file.gem01  AND  sfu_file.sfu05=azf_file.azf01  AND azf_file.azf02='2' ", #6818
              #"   AND sfv04=ima01 AND sfupost!='X' ", #FUN-660137
               "   AND  sfv_file.sfv04=ima_file.ima01  AND sfuconf!='X' ", #FUN-660137
               "   AND ",tm.wc clipped          #FUN-550012
               #"   AND sfu00='",g_sfu00,"' AND ",tm.wc clipped   #FUN-550012
   LET l_sql=l_sql CLIPPED," ORDER BY sfu01,sfv03"   #No.FUN-710082  
   display g_sfu00
   PREPARE r620_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   DECLARE r620_curs1 CURSOR FOR r620_prepare1
#TQC-C10039--start--mark---
   ##FUN-BA0078--ADD--STR--                               
   ##單據key值                           
   #LET l_sql= "SELECT sfu01",           
   #           " FROM sfu_file, sfv_file, ",
   #            "  OUTER gem_file, OUTER ima_file, OUTER azf_file ",
   #            " WHERE sfu_file.sfu01 = sfv_file.sfv01 AND  sfu_file.sfu04=gem_file.gem01",
   #            "  AND  sfu_file.sfu05=azf_file.azf01  AND azf_file.azf02='2' ",
   #            "  AND  sfv_file.sfv04=ima_file.ima01  AND sfuconf!='X' ",
   #            "  AND ",tm.wc clipped
   #LET l_sql=l_sql CLIPPED," ORDER BY sfu01,sfv03"
   #PREPARE r620_prep FROM l_sql
   #IF SQLCA.sqlcode != 0 THEN
   #   CALL cl_err('prepare:',SQLCA.sqlcode,1)
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
   #   EXIT PROGRAM     
   #END IF
   #DECLARE r620_curs CURSOR FOR r620_prep
   ##FUN-BA0078--ADD--END--
#TQC-C10039--end--mark---

   #No.FUN-710082--begin
   LET l_prog=""
   CASE WHEN g_prog = 'asfr621'
             LET l_prog='asfr621'
             LET g_prog='asfr620'
        WHEN g_prog = 'asfr622'
             LET l_prog='asfr622'
             LET g_prog='asfr620'
        WHEN g_prog = 'asfr623'
             LET l_prog='asfr623'
             LET g_prog='asfr620'
        #TQC-650053...............begin
        WHEN g_prog = 'asfr620'
             LET l_prog='asfr620'
             LET g_prog='asfr620'
        #TQC-650053...............end
   END CASE
    
#  CALL cl_outnam(g_prog) RETURNING l_name    #MOD-4B0092
#  LET g_x[4]="(",l_prog,")" #TQC-650053
#  #No.FUN-580005 --start--
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
# #IF g_sma115 = "Y" THEN
# #   LET g_zaa[46].zaa06 = "N"
# #ELSE
# #   LET g_zaa[46].zaa06 = "Y"
# #END IF
#  CALL cl_prt_pos_len()
#  #No.FUN-580005 --end--
 
#  START REPORT r620_rep TO l_name
#  LET g_pageno = 0
 
   CALL cl_del_data(l_table) 
 
   FOREACH r620_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

     #str MOD-A60130 add
      IF NOT cl_null(sr.sfv44) THEN
         LET sr.azf03_1=''
         SELECT azf03 INTO sr.azf03_1 FROM azf_file
          WHERE azf01=sr.sfv44 AND azf02='2'
      END IF
     #end MOD-A60130 add

      LET l_str2 = NULL   #No:TQC-A50156 add
      SELECT ima906 INTO l_ima906 FROM ima_file
       WHERE ima01 = sr.sfv04
      IF g_sma115 = "Y" THEN
         IF NOT cl_null(sr.sfv35) AND sr.sfv35 <> 0 THEN
            CALL cl_remove_zero(sr.sfv35) RETURNING l_sfv35
            LET l_str2 = l_sfv35, sr.sfv33 CLIPPED
         END IF
         IF l_ima906 = "2" THEN
            IF cl_null(sr.sfv35) OR sr.sfv35 = 0 THEN
               CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32
               LET l_str2 = l_sfv32, sr.sfv30 CLIPPED
            ELSE
               IF NOT cl_null(sr.sfv32) AND sr.sfv32 <> 0 THEN
                  CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32
                  LET l_str2 = l_str2 CLIPPED,',',l_sfv32, sr.sfv30 CLIPPED
               END IF
            END IF
         END IF
      END IF
 
#No.FUN-860026---begin                         
      LET flag = 0                                                                                     
      SELECT img09 INTO l_img09  FROM img_file
       WHERE img01 = sr.sfv04                                                                 
         AND img02 = sr.sfv05 AND img03 = sr.sfv06                                                                            
         AND img04 = sr.sfv07                                                                                                 
      DECLARE r920_c  CURSOR  FOR                                                                                                     
         SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
          WHERE rvbs01 = sr.sfu01 AND rvbs02 = sr.sfv03                                                                  
          ORDER BY  rvbs04                                                                                                  
      FOREACH  r920_c INTO l_rvbs.*    
         LET flag = 1                                                                                               
         EXECUTE insert_prep1 USING
            sr.sfu01,sr.sfv03,l_rvbs.rvbs03,                                                            
            l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs021,                                                    
            sr.ima02,sr.ima021,sr.sfv08,sr.sfv09,                                                          
            l_img09                                                                                        
      END FOREACH                                                               
      EXECUTE insert_prep USING sr.*,l_str2,flag,"",l_img_blob,"N",""   #No.FUN-BA0078 ADD "",l_img_blob,"N" #TQC-C10039 add ""                                                       
#     EXECUTE insert_prep USING sr.*,l_str2 
#No.FUN-860026---end     
#     OUTPUT TO REPORT r620_rep(sr.*)
   END FOREACH
 
#  FINISH REPORT r620_rep
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
#  CASE WHEN g_prog = 'asfr621'
#            LET g_prog='asfr621'
#       WHEN g_prog = 'asfr622'
#            LET g_prog='asfr622'
#       WHEN g_prog = 'asfr623'
#            LET g_prog='asfr623'
#  END CASE
  
   LET l_sql = "SELECT * FROM ",l_table CLIPPED                                 
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = l_prog
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'sfu01,sfv11,sfu02')  
      RETURNING tm.wc                                                           
   END IF                      

   #DEV-D30028--add begin
   IF g_sfu00 = '1' THEN
      LET l_aza131 = g_aza.aza131
   ELSE
      LET l_aza131 = 'N'
   END IF
   #DEV-D30028--add end

   LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",g_sma115 CLIPPED,";",l_prog CLIPPED,";",tm.a  #No.FUN-860026 add tm.a
              ,";",l_aza131         #DEV-D30028
 
  #LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088 
  #CALL cl_prt_cs3(g_prog,l_sql,l_str) 
#  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    #No.FUN-860026
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",  
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED      #No.FUN-860026 
   #FUN-BA0078--ADD-STR--
    LET g_cr_table = l_table                 #主報表的temp table名稱
     #LET g_cr_gcx01 = "asmi300"               #單別維護程式  #TQC-C10039 mark--
     LET g_cr_apr_key_f = "sfu01"             #報表主鍵欄位名稱，用"|"隔開
#TQC-C10039--start-- mark---     
     #LET l_ii = 1
     ##報表主鍵值
     #CALL g_cr_apr_key.clear()                #清空
     #FOREACH r620_curs INTO l_key.*
     #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
     #   LET l_ii = l_ii + 1
     #END FOREACH
#TQC-C10039--end-- mark---
#FUN-BA0078--ADD-END--

   CALL cl_prt_cs3(g_prog,'asfr620',l_sql,l_str) 
   #No.FUN-710082--end  

END FUNCTION
 
#No.FUN-710082--begin
#REPORT r620_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         sr        RECORD
#                   sfu00   LIKE sfu_file.sfu00,
#                   sfu01   LIKE sfu_file.sfu01,
#                   sfu02   LIKE sfu_file.sfu02,
#                   sfv17   LIKE sfv_file.sfv17,    #No.FUN-550012
#                   sfu04   LIKE sfu_file.sfu04,
#                   gem02   LIKE gem_file.gem02,
#                   sfu05   LIKE sfu_file.sfu05,
#                   azf03   LIKE azf_file.azf03,
#                   sfu06   LIKE sfu_file.sfu06,
#                   sfu07   LIKE sfu_file.sfu07,
#                   sfv03   LIKE sfv_file.sfv03,
#                   sfv11   LIKE sfv_file.sfv11,
#                   sfv04   LIKE sfv_file.sfv04,
#                   ima02   LIKE ima_file.ima02,
#                   ima021  LIKE ima_file.ima021,
#                   sfv14   LIKE sfv_file.sfv14,
#                   sfv15   LIKE sfv_file.sfv15,
#                   sfv08   LIKE sfv_file.sfv08,
#                   sfv05   LIKE sfv_file.sfv05,
#                   sfv06   LIKE sfv_file.sfv06,
#                   sfv07   LIKE sfv_file.sfv07,
#                   sfv09   LIKE sfv_file.sfv09,
#                   sfv13   LIKE sfv_file.sfv13,
#No.FUN-560069 --start--
#                   sfv12   LIKE sfv_file.sfv12,
#                   sfv30   LIKE sfv_file.sfv30,
#                   sfv31   LIKE sfv_file.sfv31,
#                   sfv32   LIKE sfv_file.sfv32,
#                   sfv33   LIKE sfv_file.sfv33,
#                   sfv34   LIKE sfv_file.sfv34,
#                   sfv35   LIKE sfv_file.sfv35
#No.FUN-560069 --end--
#                   END RECORD,
#            l_str         LIKE type_file.chr1000,      #No.FUN-680121 VARCHAR(40)
#            l_cnt         LIKE type_file.num5          #No.FUN-680121 SMALLINT
#  DEFINE l_str2        LIKE type_file.chr1000,         #No.FUN-680121 #No.FUN-580005
#         l_sfv35       STRING,    #No.FUN-580005
#         l_sfv32       STRING     #No.FUN-580005
#  DEFINE l_ima906      LIKE ima_file.ima906           #FUN-580005
 
# OUTPUT TOP MARGIN 0
#        LEFT MARGIN g_left_margin
#        PAGE LENGTH g_page_line
 
# ORDER BY sr.sfu01, sr.sfv03
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     LET l_str = g_x[1] CLIPPED              #No.TQC-6B0002
#     IF sr.sfu00='0' THEN LET l_str=g_x[16] END IF
#     IF sr.sfu00='1' THEN LET l_str=g_x[17] END IF
#     IF sr.sfu00='2' THEN LET l_str=g_x[18] END IF
#     LET g_x[1] = l_str CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6B0002
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6B0002
#     PRINT ''
 
#     #------------------------------FUN-550012----------------------------------------
#     PRINT g_x[09] CLIPPED,sr.sfu01,
#           COLUMN 41,g_x[13] CLIPPED,sr.sfu05,'  ',sr.azf03
#     PRINT g_x[10] CLIPPED,sr.sfu02,COLUMN 41,g_x[14] CLIPPED,sr.sfu06
#     #PRINT g_x[11] CLIPPED,sr.sfu03,COLUMN 41,g_x[15] CLIPPED,sr.sfu07
#     PRINT g_x[12] CLIPPED,sr.sfu04,'  ',sr.gem02,COLUMN 41,g_x[15] CLIPPED,sr.sfu07
#     #------------------------------FUN-550012----------------------------------------
 
#     PRINT g_dash[1,g_len]
#     #NO.TQC-5A0118 START---
#     #IF sr.sfu00 = '0' THEN LET l_str = g_x[19] CLIPPED  END IF
#     #IF sr.sfu00 = '1' THEN LET l_str = g_x[40] CLIPPED  END IF
#     #IF sr.sfu00 = '2' THEN LET l_str = g_x[20] CLIPPED  END IF
#     IF sr.sfu00 = '0' THEN LET l_str = g_zaa[19].zaa08 CLIPPED  END IF
#     IF sr.sfu00 = '1' THEN LET l_str = g_zaa[40].zaa08 CLIPPED  END IF
#     IF sr.sfu00 = '2' THEN LET l_str = g_zaa[20].zaa08 CLIPPED  END IF
#     LET g_zaa[40].zaa08 = l_str
#     CALL cl_prt_pos_dyn()
#     #NO.TQC-5A0118 END----
 
#     #FUN-5A0140-begin
#     #PRINT g_x[31],
#     #      g_x[45], # No.FUN-550012
#     #      g_x[32],
#     #      g_x[33],
#     #      g_x[34],
#     #      g_x[35],
#     #      g_x[36],
#     #      g_x[37],
#     #      g_x[39],
#     #      g_x[40],
#     #      g_x[41],
#     #      g_x[38],
#     #      g_x[42],
#     #      g_x[46],
#     #      g_x[43],
#     #      g_x[44]
#     PRINTX name=H1 g_x[31],g_x[32],g_x[36],g_x[37],g_x[38],g_x[42],
#                    g_x[43],g_x[45]
#     PRINTX name=H2 g_x[48],g_x[33],g_x[49],g_x[39],g_x[40]
#     PRINTX name=H3 g_x[47],g_x[34],g_x[41]
#     PRINTX name=H4 g_x[46],g_x[35],g_x[44]
#    #PRINTX name=H5 g_x[50],g_x[46]
#     #FUN-5A0140-end
 
##No.FUN-560069 --end--
#      PRINT g_dash1
#
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.sfu01   #單號
#     SKIP TO TOP OF PAGE
 
#  ON EVERY ROW
##No.FUN-560069 ---start--
#     SELECT ima906 INTO l_ima906 FROM ima_file
#      WHERE ima01 = sr.sfv04
#     IF g_sma115 = "Y" THEN
#        IF NOT cl_null(sr.sfv35) AND sr.sfv35 <> 0 THEN
#           CALL cl_remove_zero(sr.sfv35) RETURNING l_sfv35
#           LET l_str2 = l_sfv35, sr.sfv33 CLIPPED
#        END IF
#        IF l_ima906 = "2" THEN
#           IF cl_null(sr.sfv35) OR sr.sfv35 = 0 THEN
#              CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32
#              LET l_str2 = l_sfv32, sr.sfv30 CLIPPED
#           ELSE
#              IF NOT cl_null(sr.sfv32) AND sr.sfv32 <> 0 THEN
#                 CALL cl_remove_zero(sr.sfv32) RETURNING l_sfv32
#                 LET l_str2 = l_str2 CLIPPED,',',l_sfv32, sr.sfv30 CLIPPED
#              END IF
#           END IF
#        END IF
#     END IF
##No.FUN-560069 ---end--
#     #FUN-5A0140-begin
#     # PRINT COLUMN g_c[31],sr.sfv03 USING '####&',
#     #       COLUMN g_c[45],sr.sfv17,  # No.FUN-550012
#     #       COLUMN g_c[32],sr.sfv11 CLIPPED,
#     #       COLUMN g_c[33],sr.sfv04[1,20],
#     #       COLUMN g_c[34],sr.ima02[1,30] CLIPPED,
#     #       COLUMN g_c[35],sr.ima021[1,30] CLIPPED,
#     #       COLUMN g_c[36],sr.sfv14 USING '###&',
#     #       COLUMN g_c[37],sr.sfv15 USING '#####&',
#     #       COLUMN g_c[39],sr.sfv05 CLIPPED,
#     #       COLUMN g_c[40],sr.sfv06 CLIPPED,
#     #       COLUMN g_c[41],sr.sfv07, #No.FUN-560069
#     #       COLUMN g_c[38],sr.sfv08 CLIPPED,
#     #       COLUMN g_c[42],cl_numfor(sr.sfv09,42,3),
#     #       COLUMN g_c[46],l_str2 CLIPPED,
#     #       COLUMN g_c[43],cl_numfor(sr.sfv13,43,3),
#     #       COLUMN g_c[44],sr.sfv12 CLIPPED
#      PRINTX name=D1 COLUMN g_c[31],sr.sfv03 USING '###&', #FUN-590118
#                     COLUMN g_c[32],sr.sfv11 CLIPPED,
#                     COLUMN g_c[36],sr.sfv14 USING '###&',
#                     COLUMN g_c[37],sr.sfv15 USING '#####&',
#                     COLUMN g_c[38],sr.sfv08 CLIPPED,
#                     COLUMN g_c[42],cl_numfor(sr.sfv09,42,3),
#                     COLUMN g_c[43],cl_numfor(sr.sfv13,43,3),
#                     COLUMN g_c[45],sr.sfv17   # No.FUN-550012
#      PRINTX name=D2 COLUMN g_c[33],sr.sfv04,    #MOD-5A0446 [1,20],
#                     COLUMN g_c[39],sr.sfv05 CLIPPED,
#                     COLUMN g_c[40],sr.sfv06 CLIPPED
#      PRINTX name=D3 COLUMN g_c[34],sr.ima02 CLIPPED,  #MOD-5A0446 [1,30] CLIPPED,
#                     COLUMN g_c[41],sr.sfv07  #No.FUN-560069
#      PRINTX name=D4 COLUMN g_c[35],sr.ima021 CLIPPED, #MOD-5A0446 [1,30] CLIPPED,
#                     COLUMN g_c[44],sr.sfv12 CLIPPED
#     #PRINTX name=D5 COLUMN g_c[46],l_str2 CLIPPED
#      IF NOT cl_null(l_str2) THEN
#      PRINTX name=D4 COLUMN g_c[32],g_x[46] CLIPPED,l_str2
#      END IF
#      PRINT ' '
#     #FUN-5A0140-end
 
# ON LAST ROW 
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'sfu01,sfv11,sfu02')  
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#        CALL cl_prt_pos_wc(tm.wc)
#     END IF
##No.TQC-6B0002 -- begin --
##      PRINT g_dash[1,g_len]
##      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.FUN-580005
##No.TQC-6B0002 --end --
#     LET l_last_sw = 'y'
#  PAGE TRAILER
#     PRINT g_dash[1,g_len]  #No.TQC-6B0002
#     IF l_last_sw = 'n'
#        THEN   # PRINT g_dash[1,g_len]  #No.TQC-6B0002
#             PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED #No.FUN-580005
#         ELSE SKIP 2 LINE   #No.TQC-6B0002
#     ELSE PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.TQC-6B0002
#     END IF
#     PRINT
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[21]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#         PRINT g_x[21]
#         PRINT g_memo
#     END IF
 
#END REPORT
#No.FUN-710082--end  
