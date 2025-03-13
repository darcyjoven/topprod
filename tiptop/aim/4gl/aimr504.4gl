# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aimr504.4gl
# Descriptions...: 料件 BIN 卡 (依單據日期)
# Date & Author..: 95/02/08 by Roger
# Modify ........: No.FUN-4A0054 04/10/07 By Echo 料件編號, 倉庫編號開窗
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-550029 05/05/30 By day   單據編號加大
# Modify.........: No.FUN-580014 05/08/16 By jackie 轉XML
# Modify.........: No.TQC-5B0019 05/11/07 By Sarah 忘記列印報表名稱
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-7C0007 07/12/03 By baofei  報表輸出至Crystal Reports功能
# Modify.........: No.MOD-840037 08/04/08 By Pengu 有BIN卡資料但卻無法產生報表
# Modify.........: No.MOD-840106 08/04/19 By Pengu 調整異動狀況碼說明
# Modify.........: No.MOD-870158 08/08/05 By liuxqa 報表兩次連續打印時，列印順序不一致
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A10149 10/01/22 By lilingyu l_sql語法錯誤,導致無資料產生
# Modify.........: No.FUN-A20044 10/03/24 By vealxu ima26x 調整
# Modify.........: No.FUN-A90024 10/12/01 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B80070 11/08/08 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.TQC-C40001 12/04/01 By SunLM chr1000--->STRING
# Modify.........: No.TQC-CC0050 12/12/10 By qirl 增加倉庫名稱產品編號欄位後品名規格欄位

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm              RECORD                            # Print condition RECORD
                       #wc        LIKE type_file.chr1000, # Where condition  #No.FUN-690026 VARCHAR(500)
                       wc        STRING,                 #TQC-C40001
                       b_date    LIKE type_file.dat,     #No.FUN-690026 DATE
                       e_date    LIKE type_file.dat,     #No.FUN-690026 DATE
                       tbname    LIKE gat_file.gat01,    #No.FUN-690026 VARCHAR(10)
                       page_skip LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                       more      LIKE type_file.chr1     # Input more condition(Y/N)  #No.FUN-690026 VARCHAR(1)
                       END RECORD,
       g_y,g_m	       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       last_y,last_m   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       g_start,g_end   LIKE type_file.dat      #No.FUN-690026 DATE
 
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
#No.FUN-7C0007---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                   
                                                 
#No.FUN-7C0007---End  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
#No.FUN-7C0007---Begin                                                          
   LET g_sql = "img01.img_file.img01,",
               "img02.img_file.img02,",
               "img03.img_file.img03,",
               "img04.img_file.img04,",
               #--TQC-CC0050--add
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "imd02.imd_file.imd02,",
               #--TQC-CC0050--add
               "imk09.imk_file.imk09"                                                              
   LET l_table = cl_prt_temptable('aimr504',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF 
 
   LET g_sql = "img01.img_file.img01,",                                         
               "img02.img_file.img02,",                                         
               "img03.img_file.img03,",                                         
               "img04.img_file.img04,",                                         
               "imk09.imk_file.imk09,",                                         
               "tlf06.tlf_file.tlf06,",                                         
               "tlf026.tlf_file.tlf026,",
               "tlf027.tlf_file.tlf027,",  #No.MOD-870158 add                                         
               "tlf036.tlf_file.tlf036,",                                         
               "tlf10.tlf_file.tlf10,",                                         
               "img09.img_file.img09,",                                       
               "tlf19.tlf_file.tlf19,",                                       
               "tlf13.type_file.chr50,",    #No.MOD-840106 add                                      
               "l_bal.imk_file.imk09"
               
              
   LET l_table1 = cl_prt_temptable('aimr5041',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                    
#No.FUN-7C0007---End
 
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.b_date = ARG_VAL(8)
   LET tm.e_date = ARG_VAL(9)
   LET tm.tbname = ARG_VAL(10)
   LET tm.page_skip = ARG_VAL(11)
  #LET tm.more = ARG_VAL(12)          #TQC-610072 順序順推
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF g_bgjob='Y' THEN
      CALL aimr504()
    ELSE
      CALL aimr504_tm(0,0)             # Input print condition
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION aimr504_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
       l_n            LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 5 LET p_col = 18
   ELSE
       LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW aimr504_w AT p_row,p_col
        WITH FORM "aim/42f/aimr504"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.page_skip = 'N'
   LET tm.tbname='tlf_file'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   SELECT azn02,azn04 INTO g_y,g_m FROM azn_file WHERE azn01=g_today
   CALL s_azm(g_y,g_m) RETURNING g_chr,tm.b_date,tm.e_date
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON img01,img02,img03,img04,ima23,ima08
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION locale
            #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
         #### No.FUN-4A0054
         ON ACTION CONTROLP
             CASE
              WHEN INFIELD(img01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ima"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO img01
                NEXT FIELD img01
 
              WHEN INFIELD(img02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imd"
                LET g_qryparam.state = 'c'
                LET g_qryparam.arg1     = 'SW'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO img02
                NEXT FIELD img02
           END CASE
      ### END  No.FUN-4A0054
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aimr504_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.b_date,tm.e_date,tm.tbname,tm.page_skip,tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD b_date
         IF cl_null(tm.b_date) THEN NEXT FIELD b_date END IF
         IF cl_null(tm.e_date) THEN
            LET tm.e_date = tm.b_date DISPLAY BY NAME tm.e_date
         END IF
      AFTER FIELD e_date
         IF cl_null(tm.e_date) THEN NEXT FIELD e_date END IF
         IF tm.e_date < tm.b_date THEN NEXT FIELD b_date END IF
      AFTER FIELD tbname
         IF cl_null(tm.tbname) THEN NEXT FIELD tbname END IF
         #BugNo:6597
         #---FUN-A90024---start-----
         #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
         #目前統一用sch_file紀錄TIPTOP資料結構
         #SELECT COUNT(distinct table_name) INTO l_n FROM all_tables WHERE table_name=ltrim(rtrim(upper(tm.tbname)))
         SELECT COUNT(distinct sch01) INTO l_n FROM sch_file WHERE sch01 = trim(tm.tbname)
         #---FUN-A90024---end-------
         IF l_n <= 0 THEN
             CALL cl_err(tm.tbname,'mfg9180',0)
             NEXT FIELD tbname
         END IF
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
   SELECT azn02,azn04 INTO g_y,g_m FROM azn_file WHERE azn01=tm.b_date
   CALL s_azm(g_y,g_m) RETURNING g_chr,g_start,g_end
   LET last_y=g_y LET last_m=g_m
   LET last_m = last_m - 1
   IF last_m = 0 THEN
      LET last_y = last_y - 1
      IF g_aza.aza02='1' THEN LET last_m = 12 ELSE LET last_m = 13 END IF
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aimr504_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aimr504'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimr504','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.b_date CLIPPED,"'" ,
                         " '",tm.e_date CLIPPED,"'" ,
                         " '",tm.tbname CLIPPED,"'" ,
                         " '",tm.page_skip CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'"  ,            #TQC-610072 
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimr504',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aimr504_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aimr504()
   ERROR ""
END WHILE
   CLOSE WINDOW aimr504_w
END FUNCTION
 
FUNCTION aimr504()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          #l_sql     LIKE type_file.chr1000,        #No.FUN-690026 VARCHAR(1000)
          l_sql     STRING,                         #TQC-C40001
          l_za05    LIKE za_file.za05,             #No.FUN-690026 VARCHAR(40)
#         q1,q2     LIKE ima_file.ima26,           #MOD-530179   #FUN-A20044
          q1,q2     LIKE type_file.num15_3,                      #FUN-A20044 
          l_i       LIKE tlf_file.tlf027,          #MOD-870158
          sr        RECORD
                    img01     LIKE img_file.img01,
                    img02     LIKE img_file.img02,
                    img03     LIKE img_file.img03,
                    img04     LIKE img_file.img04,
                    ima02     LIKE ima_file.ima02,
                    ima021    LIKE ima_file.ima021,    #--TQC-CC0050--add
                    imd02     LIKE imd_file.imd02,     #--TQC-CC0050--add
                    imk09     LIKE imk_file.imk09,
                    img09     LIKE img_file.img09 #庫存單位BugNo:4884
                    END RECORD,
#No.FUN-7C0007---Begin
          xx        RECORD
                    tlf06     LIKE tlf_file.tlf06,
                    tlf08     LIKE tlf_file.tlf08,
                    tlf026    LIKE tlf_file.tlf026,
                    tlf027    LIKE tlf_file.tlf027,  #No.MOD-870158 ADD 
                    tlf036    LIKE tlf_file.tlf036,
                    tlf10     LIKE tlf_file.tlf10,
                    tlf11     LIKE tlf_file.tlf11,
                    tlf13     LIKE tlf_file.tlf13,
                    tlf19     LIKE tlf_file.tlf19,
                    tlf031    LIKE tlf_file.tlf031,
                    tlf032    LIKE tlf_file.tlf032,
                    tlf033    LIKE tlf_file.tlf033
                    END RECORD,          
          g_tlf13   LIKE ze_file.ze03,  
          l_bal	    LIKE imk_file.imk09, 
          img_cnt   LIKE type_file.num5 
                  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?) "     #--TQC-CC0050--add3?    
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
      EXIT PROGRAM                         
   END IF  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?) "      #No.MOD-840106 modify #No.MOD-870158 ADD ?
   PREPARE insert_prep1 FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B80070--add--
      EXIT PROGRAM                         
   END IF  
     CALL cl_del_data(l_table)     
     CALL cl_del_data(l_table1)    
#No.FUN-7C0007---End
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog      #No.FUN-7C0007
  
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     LET l_sql="SELECT img01,img02,img03,img04,ima02,ima021,imd02,imk09,img09",#BugNo:4884  #--TQC-CC0050--add
               "  FROM ima_file,img_file,imd_file ,imk_file ",
               " WHERE ",tm.wc CLIPPED," AND img01=ima01",
               "   AND img01=imk01 AND img02=imk02",
               "   AND img03=imk03 AND img04=imk04",
               "   AND img02=imd01", #--TQC-CC0050--add
               "   AND imk05=",last_y," AND imk06=",last_m,
               " ORDER BY 1,2,3,4"
     PREPARE aimr504_prepare1 FROM l_sql
     IF STATUS  THEN CALL cl_err('prep:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE aimr504_curs1 CURSOR FOR aimr504_prepare1
 
#     CALL cl_outnam('aimr504') RETURNING l_name    #No.FUN-7C0007
#No.FUN-550029-begin
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-550029-end
#     START REPORT aimr504_rep TO l_name            #No.FUN-7C0007
 
     LET g_pageno = 0
     FOREACH aimr504_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF sr.imk09 IS NULL THEN LET sr.imk09=0 END IF
       IF tm.b_date > g_start THEN
          LET q1=0 LET q2=0
          SELECT SUM(tlf10*tlf12) INTO q1 FROM tlf_file
               WHERE tlf01=sr.img01
                 AND tlf021=sr.img02 AND tlf022=sr.img03 AND tlf023=sr.img04
                 AND tlf06 >= g_start AND tlf06 < tm.b_date
                 AND (tlf13 != 'asft6001' AND tlf13 != 'apmt1101') #bug no.5005
          SELECT SUM(tlf10*tlf12) INTO q2 FROM tlf_file
               WHERE tlf01=sr.img01
                 AND tlf031=sr.img02 AND tlf032=sr.img03 AND tlf033=sr.img04
                 AND tlf06 >= g_start AND tlf06 < tm.b_date
                 AND (tlf13 != 'asft6001' AND tlf13 != 'apmt1101') #bug no.5005
          IF q1 IS NULL THEN LET q1=0 END IF
          IF q2 IS NULL THEN LET q2=0 END IF
          LET sr.imk09=sr.imk09-q1+q2
       END IF
#No.FUN-7C0007---Begin
      LET l_sql=
        "SELECT tlf06,tlf08,tlf026,tlf027,tlf036,tlf10*tlf12,tlf11,tlf13,tlf19,", #No.MOD-870158
        "       tlf031,tlf032,tlf033",
        " FROM  ",tm.tbname,
        " WHERE tlf01 = '",sr.img01,"'",
      # "   AND tlf06 BETWEEN cast('",tm.b_date,"' as datetime) AND cast('",tm.e_date,"' as datetime)", #TQC-A10149
        "   AND tlf06 BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",  #TQC-A10149
        "   AND (tlf907 <> 0 ) AND tlf902 ='",sr.img02,"'",
        "   AND tlf903 ='",sr.img03,"'",
        "   AND tlf904 ='",sr.img04,"'",
        "   AND tlf13 != 'asft6001' AND tlf13 != 'apmt1101' ",  
 
        " ORDER BY 1,2"
      PREPARE r504_p2 FROM l_sql
      DECLARE r504_c2 CURSOR FOR r504_p2
      LET g_cnt=0
      LET l_bal = sr.imk09
      LET l_i = 1  #No.MOD-870158
      FOREACH r504_c2 INTO xx.*
        IF STATUS THEN EXIT FOREACH END IF
        LET g_cnt=g_cnt+1
 
        IF xx.tlf031=sr.img02 AND xx.tlf032=sr.img03 AND xx.tlf033=sr.img04
           THEN LET xx.tlf10  = xx.tlf10 *  1
           ELSE LET xx.tlf10  = xx.tlf10 * -1
        END IF
        CALL s_command(xx.tlf13) RETURNING g_chr,g_tlf13
        IF cl_null(g_tlf13) THEN LET g_tlf13=xx.tlf13 END IF
        LET l_bal = l_bal + xx.tlf10
         EXECUTE  insert_prep1 USING sr.img01,sr.img02,sr.img03,sr.img04,sr.imk09,xx.tlf06,
                                     xx.tlf026,l_i,xx.tlf036,xx.tlf10,sr.img09,xx.tlf19,g_tlf13,l_bal   #No.MOD-840106 add tlf13 #No.MOD-870158
        LET l_i = l_i + 1 #No.MOD-870158
      END FOREACH
     #-----------No.MOD-840037 modify
     #IF g_cnt=0 AND sr.imk09 != 0 THEN
      IF g_cnt!=0 THEN
     #-----------No.MOD-840037 end
        EXECUTE  insert_prep USING sr.img01,sr.img02,sr.img03,sr.img04,sr.ima02,sr.ima021,sr.imd02,sr.imk09
      END IF
#       OUTPUT TO REPORT aimr504_rep(sr.*)         
#No.FUN-7C0007---End
     END FOREACH
#No.FUN-7C0007---Begin
#     FINISH REPORT aimr504_rep
         IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'img01,img02,img03,img04,ima23,ima08')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc ,";",tm.b_date,";",tm.e_date,";",tm.page_skip,";", g_cnt,";",g_tlf13 
                     
                                                                          
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED          
   CALL cl_prt_cs3('aimr504','aimr504',l_sql,g_str)
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0007---End
END FUNCTION
#No.FUN-7C0007---Begin
 
#REPORT aimr504_rep(sr)
#   DEFINE l_bal	    LIKE imk_file.imk09     #MOD-530179
#   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#          sr        RECORD
#                    img01     LIKE img_file.img01,
#                    img02     LIKE img_file.img02,
#                    img03     LIKE img_file.img03,
#                    img04     LIKE img_file.img04,
#                    ima02     LIKE ima_file.ima02,
#                    imk09     LIKE imk_file.imk09,
#                    img09     LIKE img_file.img09 #庫存單位BugNo:4884
#                    END RECORD,
#          xx        RECORD
#                    tlf06     LIKE tlf_file.tlf06,
#                    tlf08     LIKE tlf_file.tlf08,
#                    tlf026    LIKE tlf_file.tlf026,
#                    tlf036    LIKE tlf_file.tlf036,
#                    tlf10     LIKE tlf_file.tlf10,
#                    tlf11     LIKE tlf_file.tlf11,
#                    tlf13     LIKE tlf_file.tlf13,
#                    tlf19     LIKE tlf_file.tlf19,
#                    tlf031    LIKE tlf_file.tlf031,
#                    tlf032    LIKE tlf_file.tlf032,
#                    tlf033    LIKE tlf_file.tlf033
#                    END RECORD,
#          l_sql     LIKE type_file.chr1000,      #No.FUN-690026 VARCHAR(1000)
#          g_tlf13   LIKE ze_file.ze03,           #No.FUN-690026 VARCHAR(14)
#          l_rowno,img_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.img01,sr.img02,sr.img03,sr.img04
#  FORMAT
#   PAGE HEADER
##No.FUN-580014 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]   #TQC-5B0019
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_x[16] CLIPPED,tm.b_date,'-',tm.e_date
#      PRINT g_dash[1,g_len]
##No.FUN-550029-begin
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#      PRINT g_dash1
 
#   BEFORE GROUP OF sr.img01
#      IF tm.page_skip ='Y' THEN SKIP TO TOP OF PAGE END IF
#      LET img_cnt=0
#   ON EVERY ROW
#      LET l_sql=
#        "SELECT tlf06,tlf08,tlf026,tlf036,tlf10*tlf12,tlf11,tlf13,tlf19,",
#        "       tlf031,tlf032,tlf033",
#        " FROM  ",tm.tbname,
#        " WHERE tlf01 = '",sr.img01,"'",
#        "   AND tlf06 BETWEEN cast('",tm.b_date,"' as datetime) AND cast('",tm.e_date,"' as datetime)",
#    ##--NO:0007 modi:99/04/27--
#        "   AND (tlf907 <> 0 ) AND tlf902 ='",sr.img02,"'",
#        "   AND tlf903 ='",sr.img03,"'",
#        "   AND tlf904 ='",sr.img04,"'",
#        "   AND tlf13 != 'asft6001' AND tlf13 != 'apmt1101' ",  #bug no.5005
#    ##-----
#    #   "   AND (tlf02 BETWEEN 50 AND 59  OR tlf03 BETWEEN 50 AND 59)",
#    #   "   AND ((tlf021 = '",sr.img02,"'",
#    #           " AND tlf022 = '",sr.img03,"'",
#    #           " AND tlf023 = '",sr.img04,"' )",
#    #           " OR ",
#    #           "(tlf031 = '",sr.img02,"'",
#    #           " AND tlf032 = '",sr.img03,"'",
#    #           " AND tlf033 = '",sr.img04,"' ) )",
#        " ORDER BY 1,2"
#      PREPARE r504_p2 FROM l_sql
#      DECLARE r504_c2 CURSOR FOR r504_p2
#      LET g_cnt=0
#      LET l_bal = sr.imk09
#      FOREACH r504_c2 INTO xx.*
#        IF STATUS THEN EXIT FOREACH END IF
#        LET g_cnt=g_cnt+1
#        IF g_cnt=1 THEN
#           LET img_cnt=img_cnt+1
#           PRINTX name=D1
#                 COLUMN g_c[31],g_x[11] CLIPPED,
#                 COLUMN g_c[32],sr.img01 CLIPPED,
#                 COLUMN g_c[33],g_x[12] CLIPPED,sr.img02 CLIPPED,
#                 COLUMN g_c[34],g_x[13] CLIPPED,sr.img03 CLIPPED,
#                 COLUMN g_c[35],g_x[14] CLIPPED,sr.img04[1,10] CLIPPED,
#                 COLUMN g_c[37],g_x[15] CLIPPED,
#                 COLUMN g_c[38],sr.imk09 USING '----------&.&&&'
#           PRINT
#        END IF
#        IF xx.tlf031=sr.img02 AND xx.tlf032=sr.img03 AND xx.tlf033=sr.img04
#           THEN LET xx.tlf10  = xx.tlf10 *  1
#           ELSE LET xx.tlf10  = xx.tlf10 * -1
#        END IF
#        CALL s_command(xx.tlf13) RETURNING g_chr,g_tlf13
#        IF cl_null(g_tlf13) THEN LET g_tlf13=xx.tlf13 END IF
#        LET l_bal = l_bal + xx.tlf10
#        PRINTX name=D1
#              COLUMN g_c[31],xx.tlf06,
#              COLUMN g_c[32],g_tlf13 CLIPPED,
#              COLUMN g_c[33],xx.tlf026,
#              COLUMN g_c[34],xx.tlf036,
#              COLUMN g_c[35],xx.tlf10 USING '----------&.&&&',
#           #BugNo:4884
#           #  COLUMN 63,xx.tlf11,
#           #  因為異動數量為(tlf10*tlf12)
#           #  所以單位應為目的單位即是==>庫存單位img09
#              COLUMN g_c[36],sr.img09 CLIPPED,
#              COLUMN g_c[37],xx.tlf19 CLIPPED,
#              COLUMN g_c[38],l_bal USING '----------&.&&&'
#      END FOREACH
#      IF g_cnt=0 AND sr.imk09 != 0 THEN
#           PRINTX name=D1
#                 COLUMN g_c[31],g_x[11] CLIPPED,
#                 COLUMN g_c[32],sr.img01 CLIPPED,
#                 COLUMN g_c[33],g_x[12] CLIPPED,sr.img02 CLIPPED,
#                 COLUMN g_c[34],g_x[13] CLIPPED,sr.img03 CLIPPED,
#                 COLUMN g_c[35],g_x[14] CLIPPED,sr.img04[1,10] CLIPPED,
#                 COLUMN g_c[37],g_x[15] CLIPPED,
#                 COLUMN g_c[38],sr.imk09 USING '----------&.&&&'
#           PRINT
#      END IF
#      IF g_cnt>0 OR sr.imk09 != 0 THEN
#         PRINTX name=S1 COLUMN g_c[38],g_x[18] CLIPPED
#      END IF
##No.FUN-580014 --end--
##No.FUN-550029-end
#   AFTER GROUP OF sr.img01
#      IF img_cnt>0 THEN
#          PRINT g_dash2[1,g_len]
#      END IF
#   ON LAST ROW
#      LET l_last_sw='y'
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
#      IF l_last_sw='y'
#         THEN PRINT g_x[04],COLUMN 41,g_x[05] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#         ELSE PRINT g_x[04],COLUMN 41,g_x[05] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#      END IF
#END REPORT
#Patch....NO.TQC-610036 <> #
 
#No.FUN-7C0007---End
