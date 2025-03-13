# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asfr501.4gl
# Descriptions...: 工單發/領料單列印
# Date & Author..: 94/09/15 By Jackson
# Modify.........: No:8088,8112,8242 03/09/19 Carol 現有庫存,發料量及subtotal欄位要放至小數點三位
#                                                   l_sfq.sfq04 應改為 '#&'，避免與後面一項連在一起列印出去，與料號混淆
#                                                   跳頁的控制為什麼是"TOP OF PAGE ^L" 呢??
# Modify.........: No.FUN-4A0005 04/10/02 By echo   發料單號,部門編號,要開窗
# Modify.........: No.MOD-4B0217 04/11/23 By Carol  倉管員跳頁='N' 時,倉管員須列出名字
# Modify.........: No.FUN-550067 05/06/01 By yoyo 單據編號格式放大
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-590022 05/09/07 By will l_desc聲明修改
# Modify.........: No.FUN-590110 05/09/26 By will  報表轉xml格式
# Modify.........: No.FUN-5A0140 05/10/20 By Claire 修改報表格式
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN 0改5
# Modify.........: No.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610080 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-6C0143 06/12/26 By ray 報表問題修改
# Modify.........: No.TQC-710045 07/01/15 By Echo 利用 NEED 方式控制單身抬頭顯示，並且不能重複列印單身抬頭
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.CHI-7A0044 07/11/23 By Sarah 改成子報表的寫法
# Modify.........: No.MOD-860286 08/06/24 By claire 加入INTO
# Modify.........: No.FUN-860026 08/07/17 By baofei 增加子報表-列印批序號明細
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/17 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-B30718 11/03/31 By sabrina 外部參數順序號碼錯誤
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-BA0078 11/11/07 By huangtao CR報表列印EF簽核圖檔 OR TIPTOP自訂簽核欄位 
# Modify.........: No.TQC-C10039 12/01/15 By wangrr 整合單據列印EF簽核
# Modify.........: No.TQC-BC0050 11/12/08 By destiny asfi511打印调用时报错
# Modify.........: No:FUN-C70014 12/07/05 By wangwei 新增RUN CARD發料作業
# Modify.........: No.DEV-D30028 13/03/18 By TSD.JIE 與M-Barcode整合(aza131)='Y',列印單號條碼

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		                # Print condition RECORD
            wc         LIKE type_file.chr1000,  #No.FUN-680121 VARCHAR(600)# Where Condition
            p          LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)
            q          LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)
            c       LIKE type_file.chr1,    #No.FUN-860026  
            more       LIKE type_file.chr1      #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
           END RECORD,
       g_argv1         LIKE sfp_file.sfp01,
       g_t1            LIKE type_file.chr3,     #No.FUN-680121 VARCHAR(3)
       g_no            LIKE type_file.num5      #No.FUN-680121 SMALLINT
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5      #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-710082--begin
DEFINE g_sql           STRING
DEFINE l_table         STRING
DEFINE l_table1        STRING                   #CHI-7A0044 add
DEFINE l_table2        STRING                   #CHI-7A0044 add
DEFINE l_table3        STRING                 #No.FUN-860026 
DEFINE g_str           STRING
DEFINE i,j,k,l_flag    LIKE type_file.num5
#No.FUN-710082--end  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function

   #TQC-BC0050--being
#  IF (NOT cl_user()) THEN
#     EXIT PROGRAM
#  END IF
#
#  WHENEVER ERROR CALL cl_err_msg_log
#
#  IF (NOT cl_setup("ASF")) THEN
#     EXIT PROGRAM
#  END IF
#
#  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
   #TQC-BC0050--end
 
   LET g_pdate  = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   #TQC-610080-begin
   LET g_argv1  = ARG_VAL(7)     #No.TQC-6C0143
#  LET tm.wc    = ARG_VAL(7)     #No.TQC-6C0143
   LET tm.p     = ARG_VAL(8)
   LET tm.q     = ARG_VAL(9)
   LET tm.c     = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
  #LET g_rpt_name = ARG_VAL(11)  #No:FUN-7C0078   #MOD-B30718 mark
   LET g_rpt_name = ARG_VAL(13)                   #MOD-B30718 add
   ##No.FUN-570264 ---end---
   #TQC-610080-end
   #TQC-BC0050--begin
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
  #TQC-BC0050--end 

  #str CHI-7A0044 mod
  #改用子報表的寫法,將原來的一個暫存檔拆成三個暫存檔
  ##No.FUN-710082--begin
  #LET g_sql ="sfs02.sfs_file.sfs02,sfs03.sfs_file.sfs03,",
  #           "sfs04.sfs_file.sfs04,sfs05.sfs_file.sfs05,",
  #           "sfs06.sfs_file.sfs06,sfs07.sfs_file.sfs07,",
  #           "sfs08.sfs_file.sfs08,sfs09.sfs_file.sfs09,",
  #           "sfs10.sfs_file.sfs10,sfs26.sfs_file.sfs26,",
  #           "ima02.ima_file.ima02,ima021.ima_file.ima021,",
  #           "ima23.ima_file.ima23,img10.img_file.img10,",
  #           "sfp01.sfp_file.sfp01,sfp02.sfp_file.sfp02,",
  #           "sfp06.sfp_file.sfp06,sfp03.sfp_file.sfp03,",
  #           "sfp07.sfp_file.sfp07,gem02.gem_file.gem02,",
  #           "gen02.gen_file.gen02,sfp08.sfp_file.sfp08,",
  #           "sfq02.sfq_file.sfq02,sfq04.sfq_file.sfq04,",
  #           "sfb08.sfb_file.sfb08,sfb081.sfb_file.sfb081,",
  #           "sfb09.sfb_file.sfb09,sfb05.sfb_file.sfb05,",
  #           "ima02a.ima_file.ima02,ima021a.ima_file.ima021,",
  #           "sfq03.sfq_file.sfq03,j.type_file.num5,",
  #           "i.type_file.num5,k.type_file.num5",
  #LET l_table = cl_prt_temptable('asfr501',g_sql) CLIPPED
  #IF l_table = -1 THEN EXIT PROGRAM END IF
  ##No.FUN-710082--end  
 
   LET g_sql ="sfp01.sfp_file.sfp01,sfp02.sfp_file.sfp02,",
              "sfp03.sfp_file.sfp03,sfp06.sfp_file.sfp06,",
              "sfp07.sfp_file.sfp07,sfp08.sfp_file.sfp08,",
              "ima23.ima_file.ima23,gem02.gem_file.gem02,",
#              "gen02.gen_file.gen02"   #No.FUN-860026
              "gen02.gen_file.gen02,flag.type_file.num5,",  #No.FUN-860026  
              "sign_type.type_file.chr1,", #FUN-BA0078 add
              "sign_img.type_file.blob,",  #FUN-BA0078 add
              "sign_show.type_file.chr1,", #FUN-BA0078 add
              "sign_str.type_file.chr1000" #TQC-C10039 sign_str  
   LET l_table = cl_prt_temptable('asfr501',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="sfq01.sfq_file.sfq01,  sfq02.sfq_file.sfq02,",
              "sfq03.sfq_file.sfq03,  sfq04.sfq_file.sfq04,",
              "sfb05.sfb_file.sfb05,  sfb08.sfb_file.sfb08,",
              "sfb081.sfb_file.sfb081,sfb09.sfb_file.sfb09,",
              "ima02a.ima_file.ima02, ima021a.ima_file.ima021"
   LET l_table1 = cl_prt_temptable('asfr5011',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql ="sfs01.sfs_file.sfs01,  sfs02.sfs_file.sfs02,",
              "sfs03.sfs_file.sfs03,  sfs04.sfs_file.sfs04,",
              "sfs05.sfs_file.sfs05,  sfs06.sfs_file.sfs06,",
              "sfs07.sfs_file.sfs07,  sfs08.sfs_file.sfs08,",
              "sfs09.sfs_file.sfs09,  sfs10.sfs_file.sfs10,",
              "sfs26.sfs_file.sfs26,  ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,ima23.ima_file.ima23,",
              "img10.img_file.img10,   sfs012.sfs_file.sfs012,",    #FUN-A60027 add sfs012
              "sfs013.sfs_file.sfs013"                              #FUN-A60027 
   LET l_table2 = cl_prt_temptable('asfr5012',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
  #end CHI-7A0044 mod
#No.FUN-860026---begin                                                                                                              
   LET g_sql = "rvbs01.rvbs_file.rvbs01,",                                                                                          
               "rvbs02.rvbs_file.rvbs02,",                                                                                          
               "rvbs03.rvbs_file.rvbs03,",                                                                                          
               "rvbs04.rvbs_file.rvbs04,",                                                                                          
               "rvbs06.rvbs_file.rvbs06,",                                                                                          
               "rvbs021.rvbs_file.rvbs021,",                                                                                        
               "ima02.ima_file.ima02,",                                                                                             
               "ima021.ima_file.ima021,",                                                                                           
               "sfs06.sfs_file.sfs06,",                                                                                             
               "sfs05.sfs_file.sfs05,",                                                                                             
               "img09.img_file.img09"                                                                                             
   LET l_table3 = cl_prt_temptable('asfr5013',g_sql) CLIPPED                                                                        
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF              
#No.FUN-860026---end
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       # If background job sw is off
      #TQC-610080-begin
      #IF cl_null(g_argv1) THEN
      #   CALL r501_tm()
      #ELSE
      #   LET tm.wc=" sfp01 = '",g_argv1,"'"
      #   CALL cl_wait()
      #   CALL r501_out()
      #END IF
         CALL r501_tm()
      #TQC-610080-end
   ELSE                                  	# Read data and create out-file
      LET tm.wc=" sfp01 = '",g_argv1,"'"
      CALL r501_out()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r501_tm()
DEFINE lc_qbe_sn     LIKE gbm_file.gbm01          #No.FUN-580031
DEFINE l_cmd         LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
  LET p_row = 5 LET p_col = 20
  OPEN WINDOW r501_w AT p_row,p_col WITH FORM "asf/42f/asfr501"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
  CALL cl_ui_init()
 
  CALL cl_opmsg('p')
  INITIALIZE tm.* TO NULL			# Default condition
  LET tm.more = 'N'
  LET tm.p    = 'Y'
  LET tm.q    = '1'
  LET tm.c    = 'N'  #No.FUN-860026
  LET g_rlang = g_lang
  LET g_bgjob = 'N'
  LET g_copies= '1'
  LET g_pdate = g_today  #TQC-610080
 
  WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON sfp01,sfp02,sfp03,sfp06,sfp07
        #No.FUN-580031 --start--
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No.FUN-580031 ---end---
        ON ACTION locale
           LET g_action_choice = "locale"
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT CONSTRUCT
        #### No.FUN-4A0005
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(sfp01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfp2"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfp01
                 NEXT FIELD sfp01
              WHEN INFIELD(sfp07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfp07
                 NEXT FIELD sfp07
           END CASE
        ### END  No.FUN-4A0005
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
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfpuser', 'sfpgrup') #FUN-980030
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
     IF tm.wc=" 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
     END IF
 
     DISPLAY BY NAME tm.p,tm.q,tm.c,tm.more # Condition   #No.FUN-860026  add tm.c
    #INPUT BY NAME tm.p,tm.q,tm.more WITHOUT DEFAULTS   #CHI-7A0044 mark
     INPUT BY NAME tm.q,tm.p,tm.c,tm.more WITHOUT DEFAULTS   #CHI-7A0044  #No.FUN-860026  add tm.c 
        #No.FUN-580031 --start--
        BEFORE INPUT
           CALL cl_qbe_display_condition(lc_qbe_sn)
        #No.FUN-580031 ---end---
        AFTER FIELD p
           IF cl_null(tm.p) THEN NEXT FIELD p END IF
           IF tm.p NOT MATCHES '[YN]' THEN
              NEXT FIELD p
           END IF
        AFTER FIELD q
           IF cl_null(tm.q) THEN NEXT FIELD q END IF
           IF tm.q NOT MATCHES '[12]' THEN
              NEXT FIELD q
           END IF
#No.FUN-860026---BEGIN                                                                                                              
      AFTER FIELD c    #列印批序號明細                                                                                              
         IF tm.c NOT MATCHES "[YN]" OR cl_null(tm.c)                                                                                
            THEN NEXT FIELD c                                                                                                       
         END IF                                                                                                                     
#No.FUN-860026---END  
        AFTER FIELD more
           IF tm.more NOT MATCHES '[YN]' THEN
              NEXT FIELD more
           END IF
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
           CALL cl_cmdask()	# Command execution
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
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
               WHERE zz01='asfr501'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfr501','9031',1)   
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                           " '",tm.p CLIPPED,"'",                 #TQC-610080
                           " '",tm.q CLIPPED,"'",                 #TQC-610080
                           " '",tm.c CLIPPED,"'",                 #No.FUN-860026  
                           " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                           " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
           CALL cl_cmdat('asfr501',g_time,l_cmd)	# Execute cmd at later time
        END IF
        CLOSE WINDOW r501_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL r501_out()
     ERROR ""
  END WHILE
  CLOSE WINDOW r501_w
END FUNCTION
 
FUNCTION r501_out()
#DEFINE l_time       LIKE type_file.chr8       #No.FUN-6A0090
DEFINE l_name        LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
       l_sql         LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
       l_sfp         RECORD LIKE sfp_file.*,
       sr            RECORD
           order1    LIKE sfs_file.sfs03,        #No.FUN-680121 VARCHAR(20)
           order2    LIKE sfs_file.sfs04,        #No.FUN-680121 VARCHAR(20)
           sfs02     LIKE sfs_file.sfs02,
           sfs03     LIKE sfs_file.sfs03,
           sfs04     LIKE sfs_file.sfs04,
           sfs05     LIKE sfs_file.sfs05,
           sfs06     LIKE sfs_file.sfs06,
           sfs07     LIKE sfs_file.sfs07,
           sfs08     LIKE sfs_file.sfs08,
           sfs09     LIKE sfs_file.sfs09,
           sfs10     LIKE sfs_file.sfs10,
           sfs26     LIKE sfs_file.sfs26,
           ima02     LIKE ima_file.ima02,
           ima021    LIKE ima_file.ima021,  #No.FUN-710082
           ima23     LIKE ima_file.ima23,
           img10     LIKE img_file.img10,
           sfs012    LIKE sfs_file.sfs012,   #FUN-A60027
           sfs013    LIKE sfs_file.sfs013    #FUN-A69027 
                     END RECORD
#No.FUN-710082--begin
DEFINE l_sfb         RECORD LIKE sfb_file.*
DEFINE l_sfq         RECORD LIKE sfq_file.*
DEFINE l_desc        LIKE smy_file.smydesc
DEFINE l_ima02       LIKE ima_file.ima02
DEFINE l_ima021      LIKE ima_file.ima021
DEFINE l_ima23       LIKE ima_file.ima23     #CHI-7A0044 add
DEFINE l_t1          LIKE oay_file.oayslip
DEFINE l_gen02       LIKE gen_file.gen02
DEFINE l_gem02       LIKE gem_file.gem02
#No.FUN-710082--end  
#No.FUN-860026---begin                                                                                                              
     DEFINE       l_rvbs         RECORD                                                                                             
                                  rvbs03   LIKE  rvbs_file.rvbs03,                                                                  
                                  rvbs04   LIKE  rvbs_file.rvbs04,                                                                  
                                  rvbs06   LIKE  rvbs_file.rvbs06,                                                                  
                                  rvbs021  LIKE  rvbs_file.rvbs021                                                                  
                                  END RECORD                                                                                        
     DEFINE        l_img09     LIKE img_file.img09                        
     DEFINE        flag        LIKE type_file.num5                                                        
#No.FUN-860026---end  
 
     #FUN-BA0078 START
     DEFINE l_img_blob         LIKE type_file.blob
#TQC-C10039--start--mark---     
     #DEFINE l_ii               INTEGER 
     #DEFINE l_key              RECORD 
            #v1                 LIKE sfp_file.sfp01
            #END RECORD 
#TQC-C10039--end--mark---   
     #FUN-BA0078 END

     
   CALL cl_del_data(l_table) 
   CALL cl_del_data(l_table1)   #CHI-7A0044 add
   CALL cl_del_data(l_table2)   #CHI-7A0044 add
   CALL cl_del_data(l_table3)   #No.FUN-860026

   LOCATE l_img_blob IN MEMORY      #FUN-BA0078 add
   
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
  #No.FUN-590110  --begin
  #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr501'
  #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
  #LET g_len = 114       #No.FUN-550067
  #FOR g_i = 1 TO g_len-1 LET g_dash[g_i,g_i]='=' END FOR
  #FOR g_i = 1 TO g_len-1 LET g_dash1[g_i,g_i]='-' END FOR
  #No.FUN-590110  --end
 
  #str CHI-7A0044 mod
  #改用子報表的寫法,將原來的一個暫存檔拆成三個暫存檔
  #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
  #            " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
  #            "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"
  #PREPARE insert_prep FROM g_sql
  #IF STATUS THEN
  #   CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
  #END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"   #FUN-BA0078 add 3? #TQC-C10039 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep1:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? )"    #FUN-A60027 add 2?
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
  #end CHI-7A0044 mod
#No.FUN-860026---begin
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"                                                                             
     PREPARE insert_prep3 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep3:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
#No.FUN-860026---END  
   LET l_sql = " SELECT * FROM sfp_file",
               "  WHERE ",tm.wc CLIPPED,
               "    AND sfp06 IN ('1','2','3','4','D') AND sfpconf!='X' ", #FUN-660106   #FUN-C70014 add 'D'
               "  ORDER BY sfp01   "  #No.FUN-710082
   PREPARE r501_pr1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
   DECLARE r501_cs1 CURSOR FOR r501_pr1
#TQC-C10039--start--mark---
   ##FUN-BA0078  START
   #LET l_sql = " SELECT sfp01 FROM sfp_file",
   #            "  WHERE ",tm.wc CLIPPED,
   #            "    AND sfp06 IN ('1','2','3','4','D') AND sfpconf!='X' ",      #FUN-C70014
   #            "  ORDER BY sfp01   "
   #PREPARE r501_pr4 FROM l_sql
   #IF STATUS THEN CALL cl_err('prepare4:',STATUS,1) 
   #   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
   #   EXIT PROGRAM 
   #END IF
   #DECLARE r501_cs4 CURSOR FOR r501_pr4
   ##FUN-BA0078  END
#TQC-C10039--end--mark---
   
   #No.FUN-710082--begin
   #CALL cl_outnam('asfr501') RETURNING l_name
   #LET g_pageno = 0
   #LET g_no = 0
   #START REPORT r501_rep TO l_name
 
   FOREACH r501_cs1 INTO l_sfp.*
      IF STATUS THEN CALL cl_err('for sfp:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM 
      END IF
 
     #str CHI-7A0044 add
      IF l_sfp.sfp04='N' THEN   #sfp04:扣帳碼
         LET l_sql="SELECT ima23 FROM ima_file,sfs_file",
                   " WHERE sfs01='",l_sfp.sfp01,"'",
                   "   AND sfs04=ima01"
      ELSE
         LET l_sql="SELECT ima23 FROM ima_file,sfe_file",
                   " WHERE sfe02='",l_sfp.sfp01,"'",
                   "   AND sfe07=ima01"
      END IF
      PREPARE r501_pr11 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare11:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM 
      END IF
      DECLARE r501_cs11 CURSOR FOR r501_pr11
#No.FUN-860026---BEGIN
      LET flag = 0   
#      FOREACH r501_cs11 INTO l_ima23
#         #製造部門名稱
#         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_sfp.sfp07  #MOD-860286 add INTO
#         IF STATUS THEN LET l_gem02=' ' END IF
#         #倉管員名稱
#        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=l_ima23
#        IF STATUS THEN LET l_gen02=' ' END IF
 
#         EXECUTE insert_prep USING 
#            l_sfp.sfp01,l_sfp.sfp02,l_sfp.sfp03,l_sfp.sfp06,l_sfp.sfp07,
#            l_sfp.sfp08,l_ima23,    l_gem02,    l_gen02
#      END FOREACH
     #end CHI-7A0044 add
#No.FUN-860026---END
      IF l_sfp.sfp04='N' THEN   #sfp04:扣帳碼
         LET l_sql="SELECT '','',sfs02,sfs03,sfs04,sfs05,sfs06,sfs07,",
                   "       sfs08,sfs09,sfs10,sfs26,ima02,ima021,ima23,img10,sfs012,sfs013", #No.FUN-710082 add ima021   #FUN-A60027 add sfs012,sfs013
                   "  FROM sfs_file, OUTER ima_file, OUTER img_file",
                   " WHERE sfs01='",l_sfp.sfp01,"'",
                   "   AND  sfs_file.sfs04=ima_file.ima01  AND  sfs_file.sfs04=img_file.img01 ",
                   "   AND  sfs_file.sfs07=img_file.img02  AND  sfs_file.sfs08=img_file.img03  AND  sfs_file.sfs09=img_file.img04 ",
                   " ORDER BY sfs02"
      ELSE
         LET l_sql="SELECT '','',sfe28,sfe01,sfe07,sfe16,sfe17,sfe08,",
                   "       sfe09,sfe10,sfe14,sfe26,ima02,ima021,ima23,img10,sfe012,sfe013",  #No.FUN-710082 add ima021    #FUN-A60027 add sfe012,sfe013
                   "  FROM sfe_file, OUTER ima_file, OUTER img_file",
                   " WHERE sfe02='",l_sfp.sfp01,"'",
                   "   AND  sfe_file.sfe07=ima_file.ima01  AND  sfe_file.sfe07=img_file.img01 ",
                   "   AND  sfe_file.sfe08=img_file.img02  AND sfe09=img_file.img03 AND  sfe_file.sfe10=img_file.img04 ",
                   " ORDER BY sfe28"
      END IF
      PREPARE r501_pr2 FROM l_sql
      IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM 
      END IF
      DECLARE r501_cs2 CURSOR FOR r501_pr2
      LET i=1
      FOREACH r501_cs2 INTO sr.*
        #IF tm.p='N' THEN LET sr.ima23=' ' END IF  #MOD-4B0217 mark
        #CASE tm.q WHEN '1'  LET sr.order1=sr.sfs04 LET sr.order2=sr.sfs03
        #          OTHERWISE LET sr.order1=sr.sfs03 LET sr.order2=sr.sfs04
        #END CASE
         #UPDATE列印碼
         UPDATE sfp_file SET sfp05='Y' WHERE sfp01=l_sfp.sfp01
         IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","sfp_file",l_sfp.sfp01,"",STATUS,"","upd sfp_file",1)    #No.FUN-660128
         END IF
 
        #str CHI-7A0044 mod
         EXECUTE insert_prep2 USING 
            l_sfp.sfp01,sr.sfs02,sr.sfs03, sr.sfs04,sr.sfs05,
            sr.sfs06,   sr.sfs07,sr.sfs08, sr.sfs09,sr.sfs10,
            sr.sfs26,   sr.ima02,sr.ima021,sr.ima23,sr.img10,sr.sfs012,sr.sfs013    #FUN-A60027 add sfs012,sfs013
        #end CHI-7A0044 mod
#No.FUN-860026---begin 
    SELECT img09 INTO l_img09  FROM img_file WHERE img01 = sr.sfs04                                                               
               AND img02 = sr.sfs07 AND img03 = sr.sfs08                                                                           
               AND img04 = sr.sfs09                                                                                                 
    DECLARE r920_d  CURSOR  FOR                                                                                                     
           SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
                  WHERE rvbs01 = l_sfp.sfp01 AND rvbs02 = sr.sfs02                                                                     
                  ORDER BY  rvbs04                                                                                                  
    FOREACH  r920_d INTO l_rvbs.*
         LET flag = 1                                                                                                   
         EXECUTE insert_prep3 USING  l_sfp.sfp01,sr.sfs02,l_rvbs.rvbs03,                                                               
                                     l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs021,                                                    
                                     sr.ima02,sr.ima021,sr.sfs06,sr.sfs05,                                                 
                                     l_img09                                                                            
                                                                                                                                    
    END FOREACH                                                                                                                     
#No.FUN-860026---end    
      END FOREACH
 
      DECLARE r501_cs3 CURSOR FOR
         SELECT sfq_file.*, sfb_file.*
           FROM sfq_file,OUTER sfb_file
          WHERE sfq01=l_sfp.sfp01
            AND  sfq_file.sfq02=sfb_file.sfb01 
      FOREACH r501_cs3 INTO l_sfq.*, l_sfb.*
         IF SQLCA.SQLCODE THEN CONTINUE FOREACH END IF
         LET l_ima02=''
         LET l_ima021=''
         SELECT ima02,ima021 INTO l_ima02,l_ima021 
           FROM ima_file WHERE ima01=l_sfb.sfb05
         EXECUTE insert_prep1 USING 
            l_sfq.sfq01,l_sfq.sfq02,l_sfq.sfq03,l_sfq.sfq04,
            l_sfb.sfb05,l_sfb.sfb08,l_sfb.sfb081,l_sfb.sfb09,
            l_ima02,l_ima021
        #LET i=i+1
       END FOREACH 
#No.FUN-860026---BEGIN                                                                                                              
      FOREACH r501_cs11 INTO l_ima23                                                                                               
         #制造部門名稱                                                                                                             
         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_sfp.sfp07  #MOD-860286 add INTO                                     
         IF STATUS THEN LET l_gem02=' ' END IF                                                                                     
         #倉管員名稱                                                                                                               
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=l_ima23                                                                
        IF STATUS THEN LET l_gen02=' ' END IF                                                                                      
                                                                                                                                    
         EXECUTE insert_prep USING                                                                                                 
            l_sfp.sfp01,l_sfp.sfp02,l_sfp.sfp03,l_sfp.sfp06,l_sfp.sfp07,                                                           
            l_sfp.sfp08,l_ima23,    l_gem02,    l_gen02,flag,"",l_img_blob,"N",""  #FUN-BA0078 #TQC-C10039 add ""                                                                            
      END FOREACH                                                                                                                  
 
#No.FUN-860026  
      #OUTPUT TO REPORT r501_rep(l_sfp.*, sr.*)
   END FOREACH
 
  #LET g_sql = "SELECT * FROM ",l_table CLIPPED    #TQC-730088                
  #str CHI-7A0044 mod
  #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  #CASE tm.q 
  #   WHEN '1'                                                         
  #        LET g_sql=g_sql CLIPPED," ORDER BY ima23,sfp01,sfs04,sfs03" 
  #   WHEN '2'                                                         
  #        LET g_sql=g_sql CLIPPED," ORDER BY ima23,sfp01,sfs03,sfs04" 
  #END CASE                                                  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
#               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED     #No.FUN-860026
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
               "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED      #No.FUN-860026
  #end CHI-7A0044 mod
 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN                                                         
      CALL cl_wcchp(tm.wc,'sfp01,sfp02,sfp03,sfp06,sfp07')  
      RETURNING tm.wc                                                           
   ELSE
      LET tm.wc = ' '
   END IF                      
   LET g_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",tm.q,";",tm.p,";",tm.c    #No.FUN-860026   add tm.c
              ,";",g_aza.aza131         #DEV-D30028

   #FUN-BA0078  START 
     LET g_cr_table = l_table
     #LET g_cr_gcx01 = "asmi300"   #TQC-C10039 mark---
     LET g_cr_apr_key_f = "sfp01"
#TQC-C10039--start--mark---
     #LET l_ii = 1

     #CALL g_cr_apr_key.clear()  

     #FOREACH r501_cs4 INTO l_key.* 
      #IF STATUS THEN CALL cl_err('for l_key:',STATUS,1) 
      #   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      #   EXIT PROGRAM 
      #END IF
      #LET g_cr_apr_key[l_ii].v1 = l_key.v1
      #LET l_ii = l_ii + 1 
     #END FOREACH
#TQC-C10039--end--mark---
  #FUN-BA0078  END

  #CALL cl_prt_cs3('asfr501',g_sql,g_str)  #TQC-730088
  #CALL cl_prt_cs3('asfr501','asfr501',g_sql,g_str) 
   IF tm.p = 'N' THEN   #不依倉管員跳頁
      IF g_sma.sma541 = 'Y' THEN                                   #FUN-A60027
         CALL cl_prt_cs3('asfr501','asfr501_4',g_sql,g_str)        #FUN-A60027
      ELSE                                                         #FUN-A60027 
         CALL cl_prt_cs3('asfr501','asfr501',g_sql,g_str) 
      END IF                                                       #FUN-A60027	
   ELSE
      IF g_sma.sma541 = 'Y' THEN                                   #FUN-A60027
         CALL cl_prt_cs3('asfr501','asfr501_5',g_sql,g_str)        #FUN-A60027
      ELSE                                                         #FUN-A60027
         CALL cl_prt_cs3('asfr501','asfr501_1',g_sql,g_str) 
      END IF                                                       #FUN-A60027
   END IF
  #FINISH REPORT r501_rep
  #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  #No.FUN-710082--end  
END FUNCTION
 
#No.FUN-710082--begin
#REPORT r501_rep(l_sfp, sr)
#  DEFINE
#     l_item        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_gen02       LIKE gen_file .gen02,
#     l_cnt,l_count LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#     l_sql         LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
##     l_t1          VARCHAR(3),
#     l_t1          LIKE oay_file.oayslip,        #No.FUN-680121 VARCHAR(5)#No.FUN-550067
#     l_desc        LIKE smy_file.smydesc,        #No.MOD-590022
#     l_ima02       LIKE ima_file.ima02,          #No.FUN-680121 VARCHAR(30)	
#         l_sfb		RECORD LIKE sfb_file.*,
#         l_sfp		RECORD LIKE sfp_file.*,
#         l_sfq		RECORD LIKE sfq_file.*,
#         sr  RECORD
#             order1	LIKE sfs_file.sfs03,        #No.FUN-680121 VARCHAR(20)
#             order2	LIKE sfs_file.sfs04,        #No.FUN-680121 VARCHAR(20)
#             sfs02	LIKE sfs_file.sfs02,
#             sfs03	LIKE sfs_file.sfs03,
#             sfs04	LIKE sfs_file.sfs04,
#             sfs05	LIKE sfs_file.sfs05,
#             sfs06	LIKE sfs_file.sfs06,
#             sfs07	LIKE sfs_file.sfs07,
#             sfs08	LIKE sfs_file.sfs08,
#             sfs09	LIKE sfs_file.sfs09,
#             sfs10	LIKE sfs_file.sfs10,
#             sfs26	LIKE sfs_file.sfs26,
#             ima02	LIKE ima_file.ima02,
#             ima23	LIKE ima_file.ima23,
#             img10	LIKE img_file.img10
#             END RECORD
 
##No:8088,8112,8242
# OUTPUT TOP MARGIN 0
#        LEFT MARGIN g_left_margin
#    #   BOTTOM MARGIN 0
#        BOTTOM MARGIN 5 #FUN-5A0140 印簽核
#        PAGE LENGTH g_page_line
##
 
# ORDER BY sr.ima23, l_sfp.sfp01, sr.order1, sr.order2,sr.sfs02
 
# FORMAT
#  PAGE HEADER
##No.FUN-590110  --begin
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#     PRINT
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF cl_null(g_towhom)
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     LET l_t1=l_sfp.sfp01[1,3]
#     CALL s_get_doc_no(l_sfp.sfp01) RETURNING  l_t1      #No.FUN-550067
#     SELECT smydesc INTO l_desc FROM smy_file WHERE smyslip=l_t1
#     IF cl_null(l_desc) THEN
##        PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     ELSE
##        PRINT (g_len-FGL_WIDTH(l_desc))/2 SPACES,l_desc
#        PRINT COLUMN ((g_len-FGL_WIDTH(l_desc))/2)+1,l_desc
#     END IF
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<'
##     PRINT g_head CLIPPED,pageno_total
#     PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-14),'FROM:',g_user CLIPPED;
#     PRINT COLUMN g_len-7,g_x[3] CLIPPED,pageno_total USING '<<<'
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     LET g_no = g_no + 1
##     PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
#  #  IF l_sfp.sfp05='Y' THEN             #bugno:4746
#  #     PRINT '  ',g_x[29] CLIPPED;
#  #  ELSE
##        PRINT ' ';
#  #  END IF
##     PRINT COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
##MOD-4B0217 mark
##     IF tm.p='Y' THEN
#        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.ima23
#        IF STATUS THEN LET l_gen02=' ' END IF
##     ELSE
##        LET l_gen02=' '
##     END IF
##
#     PRINT g_dash[1,g_len]
##No.FUN-550067 --start--
#    PRINT g_x[12] CLIPPED,l_sfp.sfp01,' ',
#          COLUMN 27,g_x[13] CLIPPED,l_sfp.sfp02,'   ',
#          COLUMN 48,g_x[14] CLIPPED,l_sfp.sfp03,' ',   #FUN-5A0140 對齊PBI:
#          COLUMN 73,g_x[11] CLIPPED,l_gen02
#     PRINT g_x[15] CLIPPED,l_sfp.sfp07,' ',
#          COLUMN 27,g_x[16] CLIPPED,l_sfp.sfp06,' ',r501_sfp06(l_sfp.sfp06),
#          COLUMN 47,' PBI:',l_sfp.sfp08,'    ',
#          COLUMN 73,g_x[18] CLIPPED,l_sfp.sfp04
#     PRINT g_dash2
#     IF g_no=1 THEN
#      #FUN-5A0140-begin
#      #  PRINT g_x[21] CLIPPED,
#      #       COLUMN 44,g_x[22]
#      # PRINT "---------------- -- --------------------",
#      #        " ---------- ---------- ---------- =========="
#         PRINT
#         PRINT COLUMN  1, g_x[53],
#               COLUMN 18, g_x[54],
#               COLUMN 23, g_x[55],
#               COLUMN 39, g_x[56],
#               COLUMN 55, g_x[57],
#               COLUMN 71, g_x[58]
#         PRINT COLUMN  1, g_x[59]
#         PRINT COLUMN  1, g_x[60]
#         PRINT "---------------- ---  ---------------",
#              " --------------  --------------  =============="
#      #FUN-5A0140-end
#     ELSE
##       PRINT g_x[23],
##             COLUMN 26,g_x[34] CLIPPED,
##             COLUMN 47,g_x[24] CLIPPED,
##              COLUMN 87,g_x[33] CLIPPED
##        PRINT "--- -------------------- ---------------- ---- ",
##              "---- ------------ ---------------  ---------------",
##              "  -----------"
#      #FUN-5A0140-begin
#      # PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],
#      #                g_x[45],g_x[46],g_x[47],g_x[48],g_x[49]
#        PRINTX name=H1 g_x[41],g_x[43],g_x[44],g_x[45],g_x[46],g_x[51],g_x[52]
#        PRINTX name=H2 g_x[61],g_x[47],g_x[48],g_x[49]
#        PRINTX name=H3 g_x[62],g_x[42]
#        PRINTX name=H4 g_x[63],g_x[50]
#      #FUN-5A0140-end
#       PRINT g_dash1
#     END IF
#     LET l_last_sw = 'n'     #FUN-550124
 
#   BEFORE GROUP OF sr.ima23
#     IF tm.p='Y' THEN SKIP TO TOP OF PAGE END IF
#   BEFORE GROUP OF l_sfp.sfp01
#     SKIP TO TOP OF PAGE
#      #MOD-490250
#     DECLARE r501_cs3 CURSOR FOR
#                  SELECT sfq_file.*, sfb_file.*
#                    FROM sfq_file,OUTER sfb_file
#                   WHERE sfq01=l_sfp.sfp01
#                     AND  sfq_file.sfq02=sfb_file.sfb01 
#     FOREACH r501_cs3 INTO l_sfq.*, l_sfb.*
#       IF SQLCA.SQLCODE THEN CONTINUE FOREACH END IF
#       LET l_ima02=''
#       SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=l_sfb.sfb05
#     #--
 
#     #FUN-5A0140-begin
#     # PRINT COLUMN 01,l_sfq.sfq02,
#     #       COLUMN 17,l_sfq.sfq04 USING '##&',
#     #       COLUMN 21,l_sfb.sfb05 CLIPPED,
#     #       COLUMN 42,l_sfb.sfb08  USING '##,###,##&',
#     #       COLUMN 53,l_sfb.sfb081 USING '###,###,##&',
#     #      COLUMN 64,l_sfb.sfb09  USING '##,###,##&',
#     #      COLUMN 75,l_sfq.sfq03  USING '##,###,##&'
#     # PRINT COLUMN 21,l_ima02 CLIPPED
#       PRINT COLUMN  1,l_sfq.sfq02,
#             COLUMN 18,l_sfq.sfq04 USING '##&',
#             COLUMN 23,l_sfb.sfb08  USING '###,###,###,##&',
#             COLUMN 38,l_sfb.sfb081 USING '###,###,###,##&',
#             COLUMN 54,l_sfb.sfb09  USING '###,###,###,##&',
#             COLUMN 70,l_sfq.sfq03  USING '###,###,###,##&'
#       PRINT COLUMN  1,l_sfb.sfb05 CLIPPED
#       PRINT COLUMN  1,l_ima02 CLIPPED
#     #FUN-5A0140-end
#     END FOREACH
#     PRINT g_dash2
##     PRINT g_x[23] CLIPPED,
##            COLUMN 26,g_x[34] CLIPPED,
##           COLUMN 47,g_x[24] CLIPPED,
##           COLUMN 87,g_x[33] CLIPPED
##     PRINT "--- -------------------- ---------------- ---- ",
##           "---- ------------ ---------------  ---------------",
##           "  -----------"
#     #FUN-5A0140-begin
#     #TQC-710045
#     NEED 5 LINES
#     IF g_no=1 THEN
#        #PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],
#        #               g_x[45],g_x[46],g_x[47],g_x[48],g_x[49]
#        PRINTX name=H1 g_x[41],g_x[43],g_x[44],g_x[45],g_x[46],g_x[51],g_x[52]
#        PRINTX name=H2 g_x[61],g_x[47],g_x[48],g_x[49]
#        PRINTX name=H3 g_x[62],g_x[42]
#        PRINTX name=H4 g_x[63],g_x[50]
#        #FUN-5A0140-end
#        PRINT g_dash1
#     END IF
#     #END TQC-710045
#     SELECT COUNT(*) INTO g_cnt FROM sfq_file WHERE sfq01=l_sfp.sfp01
 
#   AFTER GROUP OF l_sfp.sfp01
#     UPDATE sfp_file SET sfp05='Y' WHERE sfp01=l_sfp.sfp01
#     IF STATUS OR SQLCA.sqlerrd[3]=0
#        THEN
##        CALL cl_err('upd sfp_file',STATUS,1)   #No.FUN-660128
#        CALL cl_err3("upd","sfp_file",l_sfp.sfp01,"",STATUS,"","upd sfp_file",1)    #No.FUN-660128
#     END IF
#     LET g_no=0   ##不同發料單,頁次重新計算
 
#    ON EVERY ROW #MOD-490250
 
##No:8112
##     PRINT COLUMN 01,sr.sfs02 USING '##&',' ',
##           COLUMN 05,sr.sfs04 CLIPPED,' ',
##           COLUMN 26,sr.sfs03,
##          COLUMN 43,sr.sfs10 CLIPPED,' ',     #No:8112
##          COLUMN 48,sr.sfs06 CLIPPED,' ',
##          COLUMN 53,sr.sfs07 CLIPPED,
##          COLUMN 66,sr.img10 USING '---,---,--&.---',         #No:8088
##          COLUMN 83,sr.sfs05 USING '---,---,--&.---',         #No:8088
##          COLUMN 99,sr.sfs26
##     PRINT COLUMN 05,sr.ima02 CLIPPED,
##          COLUMN 54,sr.sfs08,' ',sr.sfs09 CLIPPED,
##          COLUMN 100,'___________'
 
##FUN-5A0140-begin
##      PRINT COLUMN g_c[41],sr.sfs02 USING '##&',
##            COLUMN g_c[42],sr.sfs04 CLIPPED,
##            COLUMN g_c[43],sr.sfs03,
##            COLUMN g_c[44],sr.sfs10 CLIPPED,
##            COLUMN g_c[45],sr.sfs06 CLIPPED,
##            COLUMN g_c[46],sr.sfs07 CLIPPED,
##            COLUMN g_c[47],cl_numfor(sr.img10,47,3),
##            COLUMN g_c[48],cl_numfor(sr.sfs05,48,3),
##            COLUMN g_c[49],sr.sfs26
##      PRINT COLUMN g_c[42],sr.ima02,
##            COLUMN g_c[46],sr.sfs08,' ',sr.sfs09 CLIPPED,
##            COLUMN g_c[49],g_x[35]
#     PRINTX name=D1 COLUMN g_c[41],sr.sfs02 USING '###&', #FUN-590118
#           COLUMN g_c[43],sr.sfs03,
#           COLUMN g_c[44],sr.sfs10 CLIPPED,
#           COLUMN g_c[45],sr.sfs06 CLIPPED,
#           COLUMN g_c[46],sr.sfs07 CLIPPED,
#           COLUMN g_c[51],sr.sfs08 CLIPPED,
#           COLUMN g_c[52],sr.sfs09 CLIPPED
#     PRINTX name=D2 COLUMN g_c[47],cl_numfor(sr.img10,47,3),
#           COLUMN g_c[48],cl_numfor(sr.sfs05,48,3),
#           COLUMN g_c[49],g_x[35]
#     PRINTX name=D3 COLUMN g_c[62],sr.sfs26,
#           COLUMN g_c[42],sr.sfs04 CLIPPED
#     PRINTX name=D4 COLUMN g_c[50],sr.ima02
##FUN-5A0140-end
##
##No.FUN-590110  --end
 
#   AFTER GROUP OF sr.order1
#     IF tm.q='1' THEN
#        IF g_cnt>1 THEN
#           PRINT COLUMN 56, 'SubTotal:',  #FUN-5A0140 66->56
#              #  GROUP SUM(sr.img10) USING '--,---,--&',   #No.3206
##No:8088
#                COLUMN 76,     #FUN-5A0140 82->76
##NO.FUN-550067 --end--
#                 GROUP SUM(sr.sfs05) USING '---,---,--&.---'
##
#        END IF
#        PRINT ' '
#     END IF
### FUN-550124
#   ON LAST ROW
#     LET l_last_sw = 'y'
 
#   PAGE TRAILER
#     PRINT g_dash[1,g_len]
#     PRINT '(asfr501)'
#     SKIP 1 LINE
#     #PRINT g_x[5] CLIPPED,g_x[6] CLIPPED
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[5]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[5]
#            PRINT g_memo
#     END IF
## END FUN-550124
#END REPORT
 
#FUNCTION r501_sfp06(p_sfp06)
#   DEFINE p_sfp06	LIKE ima_file.ima34        #No.FUN-680121 VARCHAR(10)
#   DEFINE l_str	LIKE ima_file.ima34        #No.FUN-680121 VARCHAR(08)
#   #-----97/08/15 modify by sophia
#    CASE WHEN p_sfp06='1' LET l_str=g_x[25] CLIPPED
#         WHEN p_sfp06='2' LET l_str=g_x[26] CLIPPED
#         WHEN p_sfp06='3' LET l_str=g_x[27] CLIPPED
#         WHEN p_sfp06='4' LET l_str=g_x[28] CLIPPED
#         WHEN p_sfp06='6' LET l_str=g_x[29] CLIPPED
#         WHEN p_sfp06='7' LET l_str=g_x[30] CLIPPED
#         WHEN p_sfp06='8' LET l_str=g_x[31] CLIPPED
#         WHEN p_sfp06='9' LET l_str=g_x[32] CLIPPED
#    END CASE
#   RETURN l_str
#END FUNCTION
##Patch....NO.TQC-610037 <> #
#No.FUN-710082--end  
