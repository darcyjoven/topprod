# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr030.4gl
# Descriptions...: 庫存成本開帳差異表
# Input parameter: 
# Return code....: 
# Date & Author..: 97/03/20 By Nick
# Modify ........: No:8741 03/11/25 By Melody 修改PRINT段
# Modify ........: No.MOD-4A0252 04/10/21 By Smapmin 新增抬頭編號開窗
# Modify.........: No.FUN-4C0099 04/12/27 By kim 報表轉XML功能
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.TQC-610051 06/02/13 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/08/31 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/08 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-750093 07/06/26 By arman   報表改為使用crystal report
# Modify.........: No.FUN-750093 07/07/18 By arman   打印條件沒有預設值 
# Modify.........: No.TQC-780062 07/08/20 By wujie   報表名字應該與QBE界面上選擇的一致
# Modify.........: No.FUN-7C0101 08/01/22 By Zhangyajun 成本改善增加成本計算類型(type)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B30046 11/03/04 By yinhy “僅打印有差異者”選項勾選，無差異的資料應該不帶出
# Modify.........: No.TQC-B30069 11/03/04 By yinhy 改為cs3()寫法
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(600)      # Where condition
              yy,mm   LIKE type_file.num5,           #No.FUN-680122SMALLINT
              type    LIKE type_file.chr1,           #No.FUN-7C0101CHAR(1)
              azh01   LIKE azh_file.azh01,           #No.FUN-680122CHAR(10)
              azh02   LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
              d_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
              more    LIKE type_file.chr1            #No.FUN-680122CHAR(1)        # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE ccq_file.ccq03              #No.FUN-680122     # User defined variable
   DEFINE bdate   LIKE type_file.dat                 #No.FUN-680122DATE
   DEFINE edate   LIKE type_file.dat                 #No.FUN-680122DATE
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_str           STRING                       #NO.FUN-750093
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_sql           STRING                      #No.TQC-B30069
DEFINE   l_table         STRING                      #No.TQC-B30069

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
   #No.TQC-B30069 --Begin
   LET g_sql = "cca01.cca_file.cca01,  cca07.cca_file.cca07,", 
               "ima02.ima_file.ima02,  ima021.ima_file.ima021,",
               "ima25.ima_file.ima25,  ccc91.ccc_file.ccc91,", 
               "cca11.cca_file.cca11,  ccc92.ccc_file.ccc92,",
               "cca12.cca_file.cca12" 
   LET l_table = cl_prt_temptable('axcr030',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?, ?,?,?,?)"              
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF              
   #No.TQC-B30069 --End     
          
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610051-begin
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.azh01 = ARG_VAL(10)
   LET tm.azh02 = ARG_VAL(11)
   LET tm.d_sw = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET tm.type = ARG_VAL(16)    #No.FUN-7C0101 ad
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr030_tm(0,0)        # Input print condition
      ELSE CALL axcr030()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr030_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400) 
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axcr030_w AT p_row,p_col
        WITH FORM "axc/42f/axcr030" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
#  LET tm.d_sw = 'Y'                  #NO.FUN-750093
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON cca01,ima08,ima09,ima11,ima57,ima06,ima10,ima12
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp                                                                                              
            IF INFIELD(cca01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO cca01                                                                                 
               NEXT FIELD cca01                                                                                                     
            END IF  
#No.FUN-570240 --end-- 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ccauser', 'ccagrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr030_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.azh01,tm.azh02,tm.d_sw,tm.more WITHOUT DEFAULTS  #No.FUN-7C0101 add tm.type
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      #No.FUN-7C0101--start--
      AFTER FIELD type
         IF tm.type IS NULL OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type
         END IF
      #No.FUN-7C0101---end---
      AFTER FIELD azh01
         SELECT azh02 INTO tm.azh02 FROM azh_file WHERE azh01=tm.azh01
         DISPLAY BY NAME tm.azh02
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLP CASE WHEN INFIELD(azh01)
#                            CALL q_azh(4,4,tm.azh01,tm.azh02)
#                                 RETURNING tm.azh01,tm.azh02
#                            CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#                            CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
################################################################################
# START genero shell script ADD
     CALL cl_init_qry_var()      #MOD-4A0252 抬頭編號開窗
    LET g_qryparam.form = 'q_azh'
#   LET g_qryparam.default1 = tm.azh01
#   LET g_qryparam.default2 = tm.azh02
    CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
#   CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#   CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
# END genero shell script ADD
################################################################################
    DISPLAY BY NAME tm.azh01,tm.azh02
    NEXT FIELD azh01
    END CASE
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr030_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr030'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr030','9031',1)   
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
                         #TQC-610051-begin
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",
                         " '",tm.azh01 CLIPPED,"'",
                         " '",tm.azh02 CLIPPED,"'",
                         " '",tm.d_sw CLIPPED,"'",
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr030',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr030_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr030()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr030_w
END FUNCTION
 
FUNCTION axcr030()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122CHAR(20)        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,     # RDSQL STATEMENT        #No.FUN-680122 VARCHAR(1200)
          l_chr        LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_wc      STRING,                        #No.TQC-B30046 add
          cca	RECORD LIKE cca_file.*,
          ccc	RECORD LIKE ccc_file.*,
          sr	RECORD
              cca01   LIKE cca_file.cca01,         #No.TQC-B30069
              cca07   LIKE cca_file.cca07,         #No.TQC-B30069
            	ima02	  LIKE ima_file.ima02,
            	ima021	LIKE ima_file.ima021,
            	ima25	  LIKE ima_file.ima25,
            	ccc91   LIKE ccc_file.ccc91,         #No.TQC-B30069
            	cca11   LIKE cca_file.cca11,         #No.TQC-B30069
            	ccc92   LIKE ccc_file.ccc92,         #No.TQC-B30069
            	cca12   LIKE cca_file.cca12          #No.TQC-B30069
            	END RECORD
 
#No.TQC-B30069  --Begin    
     CALL cl_del_data(l_table)
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang   
     LET l_sql = "SELECT cca01,cca07,ima02,ima021,ima25,",
               "         ccc91,cca11,ccc92,cca12",
               "    FROM cca_file LEFT OUTER JOIN ccc_file ON cca01=ccc01 AND cca02=ccc02 AND cca03=ccc03 AND cca06=ccc07 AND cca07=ccc08 , ima_file",
               "   WHERE  ",tm.wc CLIPPED, 
               "     AND cca01=ima01",
               "     AND cca02=",tm.yy," AND cca03=",tm.mm,
               "     AND cca06='",tm.type,"'"
              
     PREPARE r030_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('r030_p:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80056   ADD
        EXIT PROGRAM
     END IF
     DECLARE r003_cs1 CURSOR FOR r030_p
     
     FOREACH r003_cs1 INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF sr.ccc91 IS NULL THEN LET sr.ccc91=0 END IF
        IF sr.ccc92 IS NULL THEN LET sr.ccc92=0 END IF
        IF sr.cca11 IS NULL THEN LET sr.cca11=0 END IF
        IF sr.cca12 IS NULL THEN LET sr.cca12=0 END IF
        IF tm.d_sw='Y' AND sr.cca11=sr.ccc91 AND sr.cca12=sr.ccc92 THEN
           CONTINUE FOREACH
        END IF
        EXECUTE insert_prep USING sr.*
     END FOREACH
    
     
#     #No.TQC-B30046  --Begin
#     IF tm.d_sw='Y' THEN
#        LET l_wc=' cca11=ccc91 AND cca12=ccc92'
#     ELSE
#        LET l_wc=' 1=1'
#     END IF
#     #No.TQC-B30046  --End
#     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     LET l_sql = "SELECT cca_file.*,ima02,ima021,ima25, ccc_file.*",
#                 "  FROM cca_file LEFT OUTER JOIN ccc_file ON cca01=ccc01 AND cca02=ccc02 AND cca03=ccc03 AND cca06=ccc07 AND cca07=ccc08 , ima_file",
#                 " WHERE ",tm.wc,
#                 "   AND ",l_wc,                           #No.TQC-B30046
#                 "   AND cca01=ima01",
#                 "   AND cca02=",tm.yy," AND cca03=",tm.mm,
#                 "   AND cca06='",tm.type,"'"              #No.FUN-7C0101
#No.TQC-B30069  --End       
     #NO.FUN-750093    -------begin----------
#    PREPARE axcr030_prepare1 FROM l_sql
#    IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
#       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
#       EXIT PROGRAM 
#    END IF
#    DECLARE axcr030_curs1 CURSOR FOR axcr030_prepare1
 
#    CALL cl_outnam('axcr030') RETURNING l_name
#    START REPORT axcr030_rep TO l_name
#    LET g_pageno = 0
#    FOREACH axcr030_curs1 INTO cca.*, sr.*, ccc.*
#      IF ccc.ccc91 IS NULL THEN LET ccc.ccc91=0 END IF
#      IF ccc.ccc92 IS NULL THEN LET ccc.ccc92=0 END IF
#      IF tm.d_sw='Y' AND cca.cca11=ccc.ccc91 AND cca.cca12=ccc.ccc12 THEN
#         CONTINUE FOREACH
#      END IF
#      OUTPUT TO REPORT axcr030_rep(cca.*, sr.*, ccc.*)
#    END FOREACH
#    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
 
#    FINISH REPORT axcr030_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.TQC-B30069  --Mark Begin
#     #No.TQC-B30046  --Begin
#     IF ccc.ccc91 IS NULL THEN LET ccc.ccc91=0 END IF
#     IF ccc.ccc92 IS NULL THEN LET ccc.ccc92=0 END IF
#     IF cca.cca11 IS NULL THEN LET cca.cca11=0 END IF
#     IF cca.cca12 IS NULL THEN LET cca.cca12=0 END IF
#     #No.TQC-B30046  --End
#No.TQC-B30069  --Mark End
     #LET g_str = g_ccz.ccz27,";",g_azi03,";",tm.yy,";",tm.mm,";",tm.azh02     #No.TQC-780062 #CHI-C30012
     LET g_str = g_ccz.ccz27,";",g_ccz.ccz26,";",tm.yy,";",tm.mm,";",tm.azh02 #CHI-C30012
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #NO.FUN-750093                                                       
     IF g_zz05 = 'Y' THEN                          #NO.FUN-750093                                                           
         CALL cl_wcchp(tm.wc,'cca01,ima08,ima09,ima11,ima57,ima06,ima10,ima12')#NO.FUN-750093                                                    
              RETURNING tm.wc                      #NO.FUN-750093                                                                  
     LET g_str = g_str,";",tm.wc,";",tm.type        #No.FUN-7C0101             #NO.FUN-750093                                                                   
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED        #No.TQC-B30069
     END IF                                        #NO.FUN-750093
     IF tm.type MATCHES '[12]' THEN                #No.FUN-7C0101 
        #CALL cl_prt_cs1('axcr030','axcr030',l_sql,g_str)   #No.TQC-B30069
        CALL cl_prt_cs3('axcr030','axcr030',l_sql,g_str)    #No.TQC-B30069
     #No.FUN-7C0101--start--
     END IF
     IF tm.type MATCHES '[345]' THEN
        #CALL cl_prt_cs1('axcr030','axcr030_1',l_sql,g_str) #No.TQC-B30069
        CALL cl_prt_cs3('axcr030','axcr030_1',l_sql,g_str)  #No.TQC-B30069
     END IF
     #No.FUN-7C0101---end---
     #NO.FUN-750093    ------end -----------
END FUNCTION
#No.8741
#NO.FUN-750093 -----------begin--------------
{REPORT axcr030_rep(cca, sr, ccc)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
          cca	RECORD LIKE cca_file.*,
          ccc	RECORD LIKE ccc_file.*,
          sr	RECORD
            	ima02	LIKE ima_file.ima02,
            	ima021	LIKE ima_file.ima021,
            	ima25	LIKE ima_file.ima25
            	END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY cca.cca01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[10] CLIPPED,tm.yy USING '&&&&',g_x[11] CLIPPED,tm.mm USING '&&'
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
#FUN-4C0099
#     PRINT cca.cca01[1,15],
#           COLUMN 17,ccc.ccc91 USING '------&.&&',
#           cca.cca11 USING '-------&.&&',
#           (cca.cca11-ccc.ccc91) USING '------&.&&',
#           COLUMN 49,cl_numfor(ccc.ccc92,22,g_azi03),   #FUN-570190
#           COLUMN 72,cl_numfor(cca.cca12,22,g_azi03),    #FUN-570190
#           COLUMN 95,cl_numfor((cca.cca12-ccc.ccc92) ,22,g_azi03)    #FUN-570190
#     PRINT '    ',sr.ima25,sr.ima02
      PRINT COLUMN g_c[31],cca.cca01,
            COLUMN g_c[32],sr.ima02,
            COLUMN g_c[33],sr.ima021,
            COLUMN g_c[34],sr.ima25,
            COLUMN g_c[35],cl_numfor(ccc.ccc91,35,g_ccz.ccz27),    #FUN-570190 #CHI-690007 g_azi03->g_ccz.ccz27
            COLUMN g_c[36],cl_numfor(cca.cca11,36,g_ccz.ccz27),    #FUN-570190 #CHI-690007 g_azi03->g_ccz.ccz27
            COLUMN g_c[37],cl_numfor(cca.cca11-ccc.ccc91,37,g_ccz.ccz27),    #FUN-570190 #CHI-690007 g_azi03->g_ccz.ccz27
            COLUMN g_c[38],cl_numfor(ccc.ccc92,38,g_azi03),    #FUN-570190
            COLUMN g_c[39],cl_numfor(cca.cca12,39,g_azi03),    #FUN-570190
            COLUMN g_c[40],cl_numfor((cca.cca12-ccc.ccc92),40,g_azi03)    #FUN-570190
 
   ON LAST ROW
      PRINT
#     PRINT 9 SPACES,g_x[13] CLIPPED,COLUMN 16,
#           SUM(ccc.ccc91) USING '-------&.&&',
#           SUM(cca.cca11) USING '-------&.&&',
#           SUM(cca.cca11-ccc.ccc91) USING '------&.&&',
#           COLUMN 49,cl_numfor(SUM(ccc.ccc92) ,22,g_azi03),    #FUN-570190
#           COLUMN 72,cl_numfor(SUM(cca.cca12),22,g_azi03),    #FUN-570190
#           COLUMN 95,cl_numfor(SUM(cca.cca12-ccc.ccc92),22,g_azi03)    #FUN-570190
      PRINT COLUMN g_c[34],g_x[9],
            COLUMN g_c[35],cl_numfor(SUM(ccc.ccc91),35,g_ccz.ccz27),    #FUN-570190 #CHI-690007 g_azi03->g_ccz.ccz27
            COLUMN g_c[36],cl_numfor(SUM(cca.cca11),36,g_ccz.ccz27),    #FUN-570190 #CHI-690007 g_azi03->g_ccz.ccz27
            COLUMN g_c[37],cl_numfor(SUM(cca.cca11-ccc.ccc91),37,g_ccz.ccz27),    #FUN-570190 #CHI-690007 g_azi03->g_ccz.ccz27
            COLUMN g_c[38],cl_numfor(SUM(ccc.ccc92),38,g_azi03),    #FUN-570190
            COLUMN g_c[39],cl_numfor(SUM(cca.cca12),39,g_azi03),    #FUN-570190
            COLUMN g_c[40],cl_numfor(SUM(cca.cca12-ccc.ccc92),40,g_azi03)    #FUN-570190
 
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT COLUMN g_x[4],g_x[5] CLIPPED, COLUMN g_c[40],g_x[7] CLIPPED
#FUN-4C0099(End)
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash   #FUN-4C0099
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[40], g_x[6] CLIPPED   #FUN-4C0099
         ELSE SKIP 2 LINE
      END IF
#No.8741(END)
END REPORT
} 
#NO.FUN-750093 ------end ---------------
