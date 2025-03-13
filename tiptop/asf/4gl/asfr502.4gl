# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asfr502.4gl
# Descriptions...: 工單退/領料單列印
# Date & Author..: 94/09/15 By Jackson
# Modify.........: No.FUN-550067  05/06/01 By yoyo 單據編號格式放大
# Modify.........: No.FUN-550124  05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-590022 05/09/07 By will l_desc聲明修改
# Modify.........: No.FUN-590110 05/09/26 By will  報表轉xml格式
# Modify.........: No.FUN-5A0140 05/10/21 By Claire 調整報表格式
# Modify.........: No.MOD-5A0446 05/11/01 By Claire 料號20碼->40碼
# Modify.........: No.TQC-5C0045 05/12/21 By kim 修改料號/品名位置錯誤的問題
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610080 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.TQC-650053 06/05/12 By kim 表尾的接下頁不見了
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-6C0143 06/12/26 By ray 報表問題修改
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-740008 07/04/09 By pengu 增加(ctrl-g)功能
# Modify.........: No.FUN-860026 08/07/21 By baofei 增加子報表-列印批序號明細
# Modify.........: No.MOD-940284 09/04/22 By Pengu 按倉管員分頁時，報表列印卻未分頁
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/17 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-AB0043 10/11/04 By sabrina 退料量的小數部份時，報表不會顯示
# Modify.........: No:MOD-B60071 11/06/08 By zhangll img103->img10
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-BA0078 11/11/04 By minpp  CR报表列印TIPTOP与EASYFLOW签核图片 
# Modify.........: No:TQC-C10039 12/01/15 By wangrr CR报表列印TIPTOP与EASYFLOW签核图片
# Modify.........: No.DEV-D30028 13/03/18 By TSD.JIE 與M-Barcode整合(aza131)='Y',列印單號條碼

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		              # Print condition RECORD
        wc      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Where Condition
        p       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        q       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        r       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        c       LIKE type_file.chr1,          #No.FUN-860026
   	more	LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
        END RECORD,
        g_argv1       LIKE sfp_file.sfp01,
        g_t1          LIKE type_file.chr3        #No.FUN-680121 VARCHAR(03)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-710082--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_table1   STRING                 #No.FUN-860026 
DEFINE  l_str      STRING   
DEFINE  i          LIKE type_file.num5 
DEFINE  j          LIKE type_file.num5 
DEFINE  l_flag     LIKE type_file.num5 
#No.FUN-710082--end  
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
   LET tm.more = 'N'
   LET tm.p='N'
   LET tm.q= '1'
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_argv1  = ARG_VAL(7)  #TQC-610080     #No.TQC-6C0143
#  LET tm.wc    = ARG_VAL(7)  #TQC-610080     #No.TQC-6C0143
   LET tm.p     = ARG_VAL(8)
   LET tm.q     = ARG_VAL(9)
   LET tm.c     = ARG_VAL(14) #No.FUN-860026
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   #No.FUN-710082--begin
   LET g_sql ="sfs02.sfs_file.sfs02,",
              "sfs03.sfs_file.sfs03,",
              "sfs04.sfs_file.sfs04,",
              "sfs05.sfs_file.sfs05,",
              "sfs06.sfs_file.sfs06,",
 
              "sfs07.sfs_file.sfs07,",
              "sfs08.sfs_file.sfs08,",
              "sfs09.sfs_file.sfs09,",
              "sfs10.sfs_file.sfs10,",
              "sfs26.sfs_file.sfs26,",
 
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "ima23.ima_file.ima23,",
              "img10.img_file.img10,",
              "sfp01.sfp_file.sfp01,",
 
              "sfp02.sfp_file.sfp02,",
              "sfp06.sfp_file.sfp06,",
              "sfp03.sfp_file.sfp03,",
              "sfp07.sfp_file.sfp07,",
              "gem02.gem_file.gem02,",
 
              "gen02.gen_file.gen02,",
              "sfp08.sfp_file.sfp08,",
              "sfq02.sfq_file.sfq02,",
              "sfq04.sfq_file.sfq04,",
              "sfb08.sfb_file.sfb08,",
 
              "sfb081.sfb_file.sfb081,",
              "sfb09.sfb_file.sfb09,",
              "sfb05.sfb_file.sfb05,",
              "ima02a.ima_file.ima02,",
              "ima021a.ima_file.ima021,",
 
              "sfq03.sfq_file.sfq03,",
              "j.type_file.num5,",
#              "i.type_file.num5"      #No.FUN-860026
              "i.type_file.num5,",      #No.FUN-860026 
              "flag.type_file.num5,",     #No.FUN-860026 
              "sfs012.sfs_file.sfs012,",  #No.FUN-A60027
              "sfs013.sfs_file.sfs013,",    #No.FUN-A60027
              "gfe03.gfe_file.gfe03,",       #MOD-AB0043 add
              "sign_type.type_file.chr1,",   #簽核方式 #FUN-BA0078 ADD
              "sign_img.type_file.blob,",    #簽核圖檔 #FUN-BA0078 ADD
              "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N) #FUN-BA0078 ADD
              "sign_str.type_file.chr1000"   #TQC-C10039 sign_str
 
   LET l_table = cl_prt_temptable('asfr502',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   #No.FUN-710082--end  
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
               "ima23.ima_file.ima23,",  #No.MOD-940284 add
               "img09.img_file.img09"                                                                                               
   LET l_table1 = cl_prt_temptable('asfr5021',g_sql) CLIPPED                                                                        
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                       
#No.FUN-860026---end    
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN       # If background job sw is off
      #TQC-610080-begin
      #IF cl_null(g_argv1) THEN
      #     CALL r502_tm()
      #ELSE
      #     LET tm.wc=" sfp01 = '",g_argv1,"'"
      #     CALL cl_wait()
      #     CALL r502_out()
      #END IF
           CALL r502_tm()
      #TQC-610080-end
   ELSE                                  	# Read data and create out-file
       LET tm.wc=" sfp01 = '",g_argv1,"'"     #No.TQC-6C0143
       CALL r502_out()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r502_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE l_cmd		LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW r502_w AT p_row,p_col
        WITH FORM "asf/42f/asfr502"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more = 'N'
   LET tm.p='N'
   LET tm.q= '1'
   LET tm.c='N'  #No.FUN-860026 
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_pdate = g_today   #No.FUN-710082
   LET g_copies = '1'
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
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
   ON ACTION CONTROLG CALL cl_cmdask()    #No.TQC-740008 add
 
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
      CLOSE WINDOW asfr502_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.p,tm.q,tm.c,tm.more # Condition    #No.FUN-860026  add tm.c
   INPUT BY NAME tm.p,tm.q,tm.c,tm.more WITHOUT DEFAULTS     #No.FUN-860026  add tm.c
 
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
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON ACTION CONTROLP
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
      LET INT_FLAG = 0 EXIT WHILE
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='asfr502'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr502','9031',1)
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
         CALL cl_cmdat('asfr502',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW r502_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r502_out()
   ERROR ""
END WHILE
   CLOSE WINDOW r502_w
END FUNCTION
 
FUNCTION r502_out()
#     DEFINE   l_time LIKE type_file.chr8       #No.FUN-6A0090
 DEFINE   l_name   LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
          l_sql    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1100)
          l_sql1    LIKE type_file.chr1000,     #No.FUN-860026
          l_sfp		RECORD LIKE sfp_file.*,
          sr  RECORD
              order	LIKE sfs_file.sfs03,   #No.FUN-680121 VARCHAR(40)
              sfs02	LIKE sfs_file.sfs02,
              sfs03	LIKE sfs_file.sfs03,
              sfs04	LIKE sfs_file.sfs04,
              sfs05	LIKE sfs_file.sfs05,
              sfs06	LIKE sfs_file.sfs06,
              sfs07	LIKE sfs_file.sfs07,
              sfs08	LIKE sfs_file.sfs08,
              sfs09	LIKE sfs_file.sfs09,
              sfs10	LIKE sfs_file.sfs10,
              sfs012    LIKE sfs_file.sfs012,  #FUN-A60027
              sfs013    LIKE sfs_file.sfs013,  #FUN-A60027
              ima02	LIKE ima_file.ima02,
              ima021	LIKE ima_file.ima021,  #No.FUN-710082
              ima23	LIKE ima_file.ima23,
              img10	LIKE img_file.img10 
              END RECORD
#No.FUN-710082--begin
DEFINE    l_sfb		RECORD LIKE sfb_file.*,
          l_sfq		RECORD LIKE sfq_file.*
DEFINE    l_gem02       LIKE gem_file.gem02
DEFINE    l_gen02       LIKE gen_file.gen02
DEFINE    l_ima02       LIKE ima_file.ima02         
DEFINE    l_ima021      LIKE ima_file.ima021         
DEFINE    l_desc        LIKE smy_file.smydesc        #No.MOD-590022
DEFINE    l_sfs26       LIKE sfs_file.sfs26          
DEFINE    l_gfe03       LIKE gfe_file.gfe03          #MOD-AB0043 add
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
#FUN-BA0078--START ### 
   DEFINE l_img_blob     LIKE type_file.blob
#TQC-C10039--start--mark---
   #DEFINE l_ii           INTEGER
   #DEFINE l_sql1_1       LIKE type_file.chr1000
   #DEFINE l_key          RECORD                  #主鍵
   #          v1          LIKE sfp_file.sfp01
   #                      END RECORD
#TQC-C10039--end--mark---
  #FUN-BA0078--END ### 

   
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-590110  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr502'
##    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#    LET g_len = 114        #No.FUN-550067
#    FOR g_i = 1 TO g_len-1 LET g_dash[g_i,g_i]='=' END FOR
#    FOR g_i = 1 TO g_len-1 LET g_dash1[g_i,g_i]='-' END FOR
#No.FUN-590110  --end
     LET l_sql = " SELECT * FROM sfp_file",
                 "  WHERE ",tm.wc CLIPPED,
                 "    AND sfp06 IN ('6','7','8','9') AND sfpconf!='X' " #FUN-660106
     LET l_sql=l_sql CLIPPED," ORDER BY sfp01"   #No.FUN-710082
     PREPARE r502_pr1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM 
     END IF
     DECLARE r502_cs1 CURSOR FOR r502_pr1

#TQC-C10039--start--mark---
#FUN-BA0078--ADD--STR--
#     LET l_sql = " SELECT sfp01 FROM sfp_file",
#                 "  WHERE ",tm.wc CLIPPED,
#                 "    AND sfp_file.sfp06 IN ('6','7','8','9') AND sfp_file.sfpconf!='X' "
#     LET l_sql=l_sql CLIPPED," ORDER BY sfp01"
#     PREPARE key_pr1 FROM l_sql
#     IF STATUS THEN CALL cl_err('pr1:',STATUS,1)
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time
#        EXIT PROGRAM
#     END IF
#     DECLARE key_cs1 CURSOR FOR key_pr1
##FUN-BA0078--ADD--END--
#TQC-C10039--end--mark--- 
     #No.FUN-710082--begin
#    CALL cl_outnam('asfr502') RETURNING l_name
 
#    LET g_pageno = 0
#    START REPORT r502_rep TO l_name
 
   CALL cl_del_data(l_table) 
   CALL cl_del_data(l_table1)   #No.FUN-860026          
   LOCATE l_img_blob IN MEMORY #blob初始化 #FUN-BA0078
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?,  ",
               "        ?,?,?,?,?,  ",
               "        ?,?,?,?,?,  ",
#               "        ?,?,?) "        #No.FUN-860026 
               "        ?,?,?,?,?, ?,?,?,?,?,?) "   #No.FUN-860026     #FUN-A60027 add 2? #MOD-AB0043 add ?  #FUN-BA0078 ADD 3? #TQC-C10039 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
#No.FUN-860026---begin                                                                                                              
     LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                               
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"    #No.MOD-940284 add ?                                                                                 
     PREPARE insert_prep1 FROM l_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err("insert_prep1:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
        EXIT PROGRAM                                                                          
     END IF                                                                                                                         
#No.FUN-860026---END  
     FOREACH r502_cs1 INTO l_sfp.*
       IF STATUS THEN CALL cl_err('for sfp:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
          EXIT PROGRAM 
       END IF
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = l_sfp.sfp07 
       IF l_sfp.sfp04='N'
          THEN LET l_sql="SELECT '',sfs02,sfs03,sfs04,sfs05,sfs06,sfs07,",
                        #"          sfs08,sfs09,sfs10,sfs012,sfs013,ima02,ima021,ima23,img103 ",       #FUN-A60027 add sfs012,sfs013
                         "          sfs08,sfs09,sfs10,sfs012,sfs013,ima02,ima021,ima23,img10 ",       #FUN-A60027 add sfs012,sfs013 #MOD-B60071 img103->img10
#                        "          sfs08,sfs09,sfs10,ima02,ima23,img10",
                         "  FROM sfs_file, OUTER ima_file, OUTER img_file",
                         " WHERE sfs01='",l_sfp.sfp01,"'",
                         "   AND  sfs_file.sfs04=ima_file.ima01  AND  sfs_file.sfs04=img_file.img01 ",
                         "   AND  sfs_file.sfs07=img_file.img02  AND  sfs_file.sfs08=img_file.img03  AND  sfs_file.sfs09=img_file.img04 ",
#                        " ORDER BY 2"
                         " ORDER BY sfs02"
          ELSE LET l_sql="SELECT '',sfe28,sfe01,sfe07,sfe16,sfe17,sfe08,",
                         "          sfe09,sfe10,sfe14,sfe012,sfe013,ima02,ima021,ima23,img10 ",      #FUN-A60027 add sfe012,sfe013
#                        "          sfe09,sfe10,sfe14,ima02,ima23,img10",
                         "  FROM sfe_file, OUTER ima_file, OUTER img_file",
                         " WHERE sfe02='",l_sfp.sfp01,"'",
                         "   AND  sfe_file.sfe07=ima_file.ima01  AND  sfe_file.sfe07=img_file.img01 ",
                         "   AND  sfe_file.sfe08=img_file.img02  AND  sfe_file.sfe09=img_file.img03  AND  sfe_file.sfe10=img_file.img04 ",
                         " ORDER BY sfe28"
#                        " ORDER BY 2"
       END IF
       PREPARE r502_pr2 FROM l_sql
       IF STATUS THEN CALL cl_err('prepare2:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
          EXIT PROGRAM 
       END IF
       DECLARE r502_cs2 CURSOR FOR r502_pr2
       LET i=1
       FOREACH r502_cs2 INTO sr.*
          IF tm.p='N' THEN LET sr.ima23=' ' END IF
 
#         CASE tm.q WHEN '1' LET sr.order=sr.sfs04,sr.sfs03
#                   WHEN '2' LET sr.order=sr.sfs03,sr.sfs04
#         END CASE
 
         #MOD-AB0043---add---start---
          SELECT gfe03 INTO l_gfe03 FROM gfe_file 
           WHERE gfe01 = sr.sfs06
          IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
             LET l_gfe03 = 0
          END IF
         #MOD-AB0043---add---end---

      UPDATE sfp_file SET sfp05='Y' WHERE sfp01=l_sfp.sfp01
      IF tm.p='Y' THEN
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.ima23
         IF STATUS THEN LET l_gen02=' ' END IF
      ELSE
         LET l_gen02=' '
      END IF
      LET l_sfs26=''
      LET l_sfq.sfq02=''
      LET l_sfq.sfq04=''
      LET l_sfq.sfq03=''
      LET l_ima02=''
      LET l_ima021=''
      LET l_sfb.sfb05=''
      LET l_sfb.sfb09=''
      LET l_sfb.sfb08=''
      LET l_sfb.sfb081=''
      LET flag = 0 #No.FUN-860026
      DECLARE r502_cs3 CURSOR FOR
                   SELECT sfq02,sfq04,sfq03
                     FROM sfq_file
                    WHERE sfq01=l_sfp.sfp01
           LET j=1
           LET l_flag=0 
      FOREACH r502_cs3 INTO 
                   l_sfq.sfq02,l_sfq.sfq04,l_sfq.sfq03
#                  l_sfb.sfb08,l_sfb.sfb081,l_sfb.sfb09,l_sfb.sfb05
        IF SQLCA.SQLCODE THEN CONTINUE FOREACH END IF
           SELECT sfb08,sfb081,sfb09,sfb05 
             INTO l_sfb.sfb08,l_sfb.sfb081,l_sfb.sfb09,l_sfb.sfb05 FROM sfb_file
            WHERE sfb01=l_sfq.sfq02
           SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
            WHERE ima01=l_sfb.sfb05
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
         EXECUTE insert_prep1 USING  l_sfp.sfp01,sr.sfs02,l_rvbs.rvbs03,                                                            
                                     l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs021,                                                    
                                     sr.ima02,sr.ima021,sr.sfs06,sr.sfs05,                                                          
                                     l_img09                                                                                        
                                                                                                                                    
    END FOREACH                                                                                                                     
#No.FUN-860026---end      
           LET l_flag=1 
 
          LET j=j+1
          EXECUTE insert_prep USING sr.sfs02,sr.sfs03,sr.sfs04,sr.sfs05,sr.sfs06,
                                    sr.sfs07,sr.sfs08,sr.sfs09,sr.sfs10,l_sfs26,
                                    sr.ima02,sr.ima021,sr.ima23,sr.img10,l_sfp.sfp01,
                                    l_sfp.sfp02,l_sfp.sfp06,l_sfp.sfp03,l_sfp.sfp07,l_gem02,
                                    l_gen02,l_sfp.sfp08,
                                    l_sfq.sfq02,l_sfq.sfq04,l_sfb.sfb08,
                                    l_sfb.sfb081,l_sfb.sfb09,l_sfb.sfb05,l_ima02,l_ima021,
                                    l_sfq.sfq03,i,j,flag,sr.sfs012,sr.sfs013,   #No.FUN-860026  add flag   #FUN-A60027 add sfs012,sfs013
                                    l_gfe03,"",l_img_blob,"N",""     #FUN-BA0078 add ,"",l_img_blob,"N"  #MOD-AB0043 add #TQC-C10039 add ""
          LET i=i+1
          END FOREACH
          IF l_flag=0 AND cl_null(l_sfq.sfq02) THEN
#No.FUN-860026---begin                                                                                                              
    SELECT img09 INTO l_img09  FROM img_file WHERE img01 = sr.sfs04                                                                 
               AND img02 = sr.sfs07 AND img03 = sr.sfs08                                                                            
               AND img04 = sr.sfs09                                                                                                 
    DECLARE r920_c  CURSOR  FOR                                                                                                     
           SELECT rvbs03,rvbs04,rvbs06,rvbs021  FROM rvbs_file                                                                      
                  WHERE rvbs01 = l_sfp.sfp01 AND rvbs02 = sr.sfs02                                                                  
                  ORDER BY  rvbs04                                                                                                  
    FOREACH  r920_c INTO l_rvbs.*
         LET flag = 1                                                                                                    
         EXECUTE insert_prep1 USING  l_sfp.sfp01,sr.sfs02,l_rvbs.rvbs03,                                                            
                                     l_rvbs.rvbs04,l_rvbs.rvbs06,l_rvbs.rvbs021,                                                    
                                     sr.ima02,sr.ima021,sr.sfs06,sr.sfs05,sr.ima23,     #No.MOD-940284 add ima23                                                          
                                     l_img09                                                                                        
                                                                                                                                    
    END FOREACH                                                                                                                     
#No.FUN-860026---end  
             EXECUTE insert_prep USING sr.sfs02,sr.sfs03,sr.sfs04,sr.sfs05,sr.sfs06,
                                       sr.sfs07,sr.sfs08,sr.sfs09,sr.sfs10,l_sfs26,
                                       sr.ima02,sr.ima021,sr.ima23,sr.img10,l_sfp.sfp01,
                                       l_sfp.sfp02,l_sfp.sfp06,l_sfp.sfp03,l_sfp.sfp07,l_gem02,
                                       l_gen02,l_sfp.sfp08,
                                       l_sfq.sfq02,l_sfq.sfq04,l_sfb.sfb08,
                                       l_sfb.sfb081,l_sfb.sfb09,l_sfb.sfb05,l_ima02,l_ima021,
                                       l_sfq.sfq03,i,j,flag,sr.sfs012,sr.sfs013,    #No.FUN-860026 add flag    #FUN-A60027 add sfs012,sfs013
                                       l_gfe03,"",l_img_blob,"N",""     #FUN-BA0078 add ,"",l_img_blob,"N"  #MOD-AB0043 add #TQC-C10039 add ""

           LET l_flag=1 
          END IF
 
#         OUTPUT TO REPORT r502_rep(l_sfp.*, sr.*)
       END FOREACH
     END FOREACH
 
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088                    
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CASE tm.q WHEN '1' 
                    LET l_sql1=l_sql CLIPPED," ORDER BY ima23,sfp01,sfs04,sfs03" 
               WHEN '2' 
                    LET l_sql1=l_sql CLIPPED," ORDER BY ima23,sfp01,sfs03,sfs04" 
     END CASE
     LET l_sql =l_sql CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED    #No.FUN-860026                                                          
               
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'sfp01,sfp02,sfp03,sfp06,sfp07')  
        RETURNING tm.wc                                                           
     END IF                      
     LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",tm.q,";",tm.p,";",tm.c   #No.FUN-860026   add tm.c 
                ,";",g_aza.aza131         #DEV-D30028

  #FNN-BA0078--ADD--STR-
     LET g_cr_table = l_table                 #主報表的temp table名稱
     #LET g_cr_gcx01 = "asmi300"              #單別維護程式#TQC-C10039 mark---
     LET g_cr_apr_key_f = "sfp01"             #報表主鍵欄位名稱
#TQC-C10039--start--mark---    
     #LET l_ii = 1
     ##報表主鍵值
     #CALL g_cr_apr_key.clear()                #清空
     #FOREACH key_cs1 INTO l_key.*
     #   LET g_cr_apr_key[l_ii].v1 = l_key.v1
     #   LET l_ii = l_ii + 1
     #END FOREACH
#TQC-C10039--end--mark---  
  #FUN-BA0078--ADD--END- 

   # CALL cl_prt_cs3('asfr502',l_sql,l_str)   #TQC-730088
   # CALL cl_prt_cs3('asfr502','asfr502',l_sql,l_str)            #FUN-A60027
   #FUN-A60027 --------------------start----------------------
     IF g_sma.sma541 = 'Y' THEN
        CALL cl_prt_cs3('asfr502','asfr502_3',l_sql,l_str) 
     ELSE
        CALL cl_prt_cs3('asfr502','asfr502',l_sql,l_str)
     END IF 
  #FUN-A60027 --------------------end------------------------   
#    FINISH REPORT r502_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-710082--end  
END FUNCTION
 
#No.FUN-710082--begin
#REPORT r502_rep(l_sfp, sr)
#  DEFINE
#     l_item        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_gen02       LIKE gen_file .gen02,
#     l_cnt,l_count LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#     l_sql         LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1100)
##     l_t1          VARCHAR(3),
#     l_t1          LIKE aab_file.aab02,          #No.FUN-680121 VARCHAR(5)#No.FUN-550067
#     l_desc        LIKE smy_file.smydesc,        #No.MOD-590022
#     l_ima02       LIKE ima_file.ima02,          #No.FUN-680121 VARCHAR(60)#TQC-5C0045 30->60
#         l_sfb		RECORD LIKE sfb_file.*,
#         l_sfp		RECORD LIKE sfp_file.*,
#         l_sfq		RECORD LIKE sfq_file.*,
#         sr  RECORD
#             order	LIKE sfs_file.sfs03,    #No.FUN-680121 VARCHAR(40)
#             sfs02	LIKE sfs_file.sfs02,
#             sfs03	LIKE sfs_file.sfs03,
#             sfs04	LIKE sfs_file.sfs04,
#             sfs05	LIKE sfs_file.sfs05,
#             sfs06	LIKE sfs_file.sfs06,
#             sfs07	LIKE sfs_file.sfs07,
#             sfs08	LIKE sfs_file.sfs08,
#             sfs09	LIKE sfs_file.sfs09,
 
#             ima02	LIKE ima_file.ima02,
#             ima23	LIKE ima_file.ima23,
#             img10	LIKE img_file.img10
#             END RECORD
 
# OUTPUT TOP  MARGIN 0 LEFT MARGIN g_left_margin BOTTOM MARGIN 6 PAGE LENGTH g_page_line
# ORDER BY sr.ima23, l_sfp.sfp01, sr.order
 
# FORMAT
#  PAGE HEADER
##No.FUN-590110  --begin
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#     PRINT
#      CALL s_get_doc_no(l_sfp.sfp01) RETURNING  l_t1      #No.FUN-550067
#     SELECT smydesc INTO l_desc FROM smy_file WHERE smyslip=l_t1
#     IF cl_null(l_desc) THEN
#        PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED  #No.TQC-6A0087 add CLIPPED
#     ELSE
#        PRINT (g_len-FGL_WIDTH(l_desc))/2 SPACES,l_desc
#        PRINT COLUMN ((g_len-FGL_WIDTH(l_desc))/2)+1,l_desc
#     END IF
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<'
##     PRINT g_head CLIPPED,pageno_total
#     PRINT g_x[2] CLIPPED,TODAY,' ',TIME;
#     IF l_sfp.sfp05='Y' THEN
#        PRINT '  ',g_x[29] CLIPPED;
#     ELSE
#        PRINT ' ';
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-14),'FROM:',g_user CLIPPED;
#     PRINT COLUMN g_len-7,g_x[3] CLIPPED,pageno_total USING '<<<'
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF cl_null(g_towhom)
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     LET l_t1=l_sfp.sfp01[1,3]
#     PRINT ' '
#     IF tm.p='Y' THEN
#        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.ima23
#        IF STATUS THEN LET l_gen02=' ' END IF
#     ELSE
#        LET l_gen02=' '
#     END IF
#     PRINT g_dash[1,g_len]
##No.FUN-550067 --start--
#     PRINT g_x[12] CLIPPED,l_sfp.sfp01,' ',
#           COLUMN 27,g_x[13] CLIPPED,l_sfp.sfp02,'   ',
#           COLUMN 48,g_x[14] CLIPPED,l_sfp.sfp03,' ',  #FUN-5A0140 往後1碼
#           COLUMN 73,g_x[11] CLIPPED,l_gen02
#     PRINT g_x[15] CLIPPED,l_sfp.sfp07,' ',
#           COLUMN 27,g_x[16] CLIPPED,l_sfp.sfp06,' ',r502_sfp06(l_sfp.sfp06),
#           COLUMN 47,' PBI:',l_sfp.sfp08,'    ',
#           COLUMN 73,g_x[18] CLIPPED,l_sfp.sfp04
#     PRINT g_dash2
#     IF g_pageno=1 THEN
#       #FUN-5A0140-begin
#       # PRINT g_x[21],g_x[22]
#       #PRINT "---------------- -- --------------------",
#       #      " ---------- ---------- ---------- =========="
#       PRINT COLUMN  1,g_x[50],
#             COLUMN 18,g_x[51],
#             COLUMN 23,g_x[52],
#             COLUMN 39,g_x[53],
#             COLUMN 55,g_x[54],
#             COLUMN 71,g_x[55]
#       PRINT COLUMN 18,g_x[56]
#       PRINT COLUMN 18,g_x[57]
#       PRINT "---------------- ---- ---------------",
#             " --------------- --------------- ==============="
#       #FUN-5A0140-end
#     ELSE
##       PRINT g_x[23],
##             COLUMN 26,g_x[33],
##             g_x[24]
##       PRINT "--- -------------------- ---------------- ---",
##              " ---- ---------- -------------- ----------------"
#       #FUN-5A0140-begin
#       #PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],
#       #               g_x[45],g_x[46],g_x[47],g_x[48]
#       PRINTX name=H1 g_x[41],g_x[43],g_x[44],g_x[45],g_x[47],g_x[48]
#       PRINTX name=H2 g_x[58],g_x[42],g_x[46]
#       PRINTX name=H3 g_x[59],g_x[49]
#       PRINT g_dash1
#       #FUN-5A0140-end
#     END IF
#     LET l_last_sw = 'n'  #FUN-550124
 
#   BEFORE GROUP OF sr.ima23
#     IF tm.p='Y' THEN SKIP TO TOP OF PAGE END IF
#   BEFORE GROUP OF l_sfp.sfp01
#     LET g_pageno=0   ##不同發料單,頁次重新計算
#     SKIP TO TOP OF PAGE
#     DECLARE r502_cs3 CURSOR FOR
#                  SELECT sfq_file.*, sfb_file.*, ima02
#                    FROM sfq_file,OUTER(sfb_file,OUTER(ima_file))
#                   WHERE sfq01=l_sfp.sfp01
#                     AND sfq02=sfb_file.sfb01 AND sfb05=ima_file.ima01
#     FOREACH r502_cs3 INTO l_sfq.*, l_sfb.*, l_ima02
#       IF SQLCA.SQLCODE THEN CONTINUE FOREACH END IF
#      #FUN-5A0140-begin
#      # PRINT COLUMN 01,l_sfq.sfq02,
#      #      COLUMN 17,l_sfq.sfq04 USING '##&',' ',
#      #      COLUMN 21,l_sfb.sfb05 CLIPPED,
#      #      COLUMN 42,l_sfb.sfb08  USING '##,###,##&',
#      #      COLUMN 53,l_sfb.sfb081 USING '##,###,##&',
#      #      COLUMN 64,l_sfb.sfb09  USING '##,###,##&',
#      #      COLUMN 75,l_sfq.sfq03  USING '##,###,##&'
#      #PRINT COLUMN 21, l_ima02 CLIPPED
#      PRINT COLUMN 01,l_sfq.sfq02 CLIPPED,#No.TQC-6A0087 add CLIPPED
#            COLUMN 19,l_sfq.sfq04  USING '##&',' ',
#            COLUMN 23,l_sfb.sfb08  USING '###,###,###,##&',
#            COLUMN 39,l_sfb.sfb081 USING '###,###,###,##&',
#            COLUMN 55,l_sfb.sfb09  USING '###,###,###,##&',
#            COLUMN 71,l_sfq.sfq03  USING '###,###,###,##&'
#      PRINT COLUMN 18,l_sfb.sfb05 CLIPPED #TQC-5C0045 1->18
#      PRINT COLUMN 18,l_ima02 CLIPPED #TQC-5C0045 1->18
#      #FUN-5A0140-end
#     END FOREACH
#     PRINT g_dash2
##    PRINT g_x[23],
##          COLUMN 26,g_x[33],
##          g_x[24]
##    PRINT "--- -------------------- ---------------- ---",
##           " ---- ---------- ------------- ----------------"
#    #FUN-5A0140-begin
#    #PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],
#    #               g_x[45],g_x[46],g_x[47],g_x[48]
#    PRINTX name=H1 g_x[41],g_x[43],g_x[44],g_x[45],g_x[47],g_x[48]
#    PRINTX name=H2 g_x[58],g_x[42],g_x[46]
#    PRINTX name=H3 g_x[59],g_x[49]
#    #FUN-5A0140-end
#    PRINT g_dash1
 
#   AFTER GROUP OF l_sfp.sfp01
#     UPDATE sfp_file SET sfp05='Y' WHERE sfp01=l_sfp.sfp01
 
#   ON EVERY ROW
##     PRINT COLUMN 01,sr.sfs02 USING '##&',' ',
##           COLUMN 05,sr.sfs04 CLIPPED,' ',
##           COLUMN 26,sr.sfs03 CLIPPED,
##          COLUMN 43,sr.sfs10 USING '##&',' ',
##          COLUMN 48,sr.sfs06 CLIPPED,' ',
##          COLUMN 53,sr.sfs07 CLIPPED,
##          COLUMN 66,sr.img10 USING '--,---,--&',
##           COLUMN 83,sr.sfs05 USING '--,---,--&'
##     PRINT COLUMN 05,sr.ima02 CLIPPED,
##          COLUMN 53,sr.sfs08 CLIPPED,' ',sr.sfs09 CLIPPED
#      #FUN-5A0140-begin
#      #PRINT COLUMN g_c[41],sr.sfs02 USING '##&',
#      #      COLUMN g_c[42],sr.sfs04[1,20] CLIPPED,
#      #      COLUMN g_c[43],sr.sfs03 CLIPPED,
#      #      COLUMN g_c[44],sr.sfs10 USING '##&',
#      #      COLUMN g_c[45],sr.sfs06 CLIPPED,
#      #      COLUMN g_c[46],sr.sfs07 CLIPPED,
#      #      COLUMN g_c[47],cl_numfor(sr.img10,47,0),
#      #      COLUMN g_c[48],cl_numfor(sr.sfs05,48,0)
#      #PRINT COLUMN g_c[42],sr.ima02 CLIPPED,
#      #      COLUMN g_c[46],sr.sfs08 CLIPPED,' ',sr.sfs09 CLIPPED
#     PRINTX name=D1  COLUMN g_c[41],sr.sfs02 USING '###&', #FUN-590118
#           COLUMN g_c[43],sr.sfs03 CLIPPED,
#           COLUMN g_c[44],sr.sfs10 USING '###&', #FUN-590118
#           COLUMN g_c[45],sr.sfs06 CLIPPED,
#           COLUMN g_c[47],cl_numfor(sr.img10,47,0),
#           COLUMN g_c[48],cl_numfor(sr.sfs05,48,0)
#     PRINTX name=D2 COLUMN g_c[42],sr.sfs04 CLIPPED,  #MOD-5A0446 [1,20] CLIPPED,
#           COLUMN g_c[46],sr.sfs07 CLIPPED,' ',sr.sfs08 CLIPPED,' ',sr.sfs09 CLIPPED
#     PRINTX name=D3 COLUMN g_c[49],sr.ima02 CLIPPED
#     #FUN-5A0140-emd
##No.FUN-550067 --end--
## FUN-550124
#No.FUN-590110  --end
#ON LAST ROW
#      LET l_last_sw = 'y'
 
#PAGE TRAILER
#     PRINT g_dash[1,g_len]
#    #TQC-650053...............begin
#    #PRINT '(asfr502)'
#     IF l_last_sw = 'n' THEN 
#        PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[9] CLIPPED
#     ELSE 
#        PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[10] CLIPPED
#     END IF
#     SKIP 1 LINE
#    #TQC-650053...............end
#    #PRINT g_x[5] CLIPPED,g_x[6] CLIPPED
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
 
#FUNCTION r502_sfp06(p_sfp06)
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
