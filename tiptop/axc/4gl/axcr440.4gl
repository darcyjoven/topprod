# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr440.4gl
# Descriptions...: 倉庫數量比較表
# Input parameter: 
# Return code....: 
# Date & Author..: 95/10/20 By Nick
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4C0099 04/12/31 By kim 報表轉XML功能
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/13 By ice 修正報表格式錯誤;修正FUN-680122改錯部分
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-750041 07/05/15 By Lynn 制表日期與報表名稱所在的行數顛倒
# Modify.........: No.FUN-750101 07/06/13 By mike 報表格式修改為crystal reports
# Modify.........: No.FUN-7C0101 07/01/24 By ChenMoyan 成本改善報表部分
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No.MOD-A90103 11/02/14 By wujie  数量统一单位计算
# Modify.........: No:MOD-B30534 11/03/17 By Pengu 報表跑不出資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680122CHAR(300)      # Where condition
              yy,mm   LIKE type_file.num5,          #No.FUN-680122SMALLINT
              type    LIKE type_file.chr1,          #No.FUN-7C0101 
              azh01   LIKE azh_file.azh01,            #No.FUN-680122CHAR(10)
              azh02   LIKE azh_file.azh02,        #No.FUN-680122CHAR(40)
              d_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(1)
              more    LIKE type_file.chr1           #No.FUN-680122CHAR(1)        # Input more condition(Y/N)
              END RECORD,
          g_tot_bal LIKE ccq_file.ccq03            #No.FUN-680122 DECIMAL(13,2)    # User defined variable
   DEFINE bdate   LIKE type_file.dat           #No.FUN-680122DATE 
   DEFINE edate   LIKE type_file.dat           #No.FUN-680122DATE 
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_str           LIKE type_file.chr1000  #No.FUN-750101
DEFINE   g_sql           LIKE type_file.chr1000  #No.FUN-750101
DEFINE   l_table         STRING  #No.FUN-750101  #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING
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
#No.FUN-750101  --begin--
   LET g_sql="ima01.ima_file.ima01,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "ima25.ima_file.ima25,",
             "ccc91.ccc_file.ccc91,",
           # "imk09.imk_file.imk09"               #No.FUN-7C0101
             "imk09.imk_file.imk09,",             #No.FUN-7C0101
             "ccc08.ccc_file.ccc08"               #No.FUN-7C0101
   LET l_table=cl_prt_temptable('axcr440',g_sql)
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
           # "  VALUES(?,?,?,?,?,?)"              #No.FUN-7C0101
             "  VALUES(?,?,?,?,?,?,?)"            #No.FUN-7C0101
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM 
   END IF
#No.FUN-750101  --END--
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.type = ARG_VAL(16)
   #TQC-610051-begin
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.azh02 = ARG_VAL(10)
   LET tm.azh01 = ARG_VAL(11)
   LET tm.d_sw = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610051-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axcr440_tm(0,0)        # Input print condition
      ELSE CALL axcr440()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr440_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axcr440_w AT p_row,p_col
        WITH FORM "axc/42f/axcr440" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.d_sw = 'Y'
   LET tm.more = 'N'
   LET tm.yy = YEAR(g_today)          # No.FUN-7C0101
   LET tm.mm = MONTH(g_today)         # No.FUN-7C0101
   LET tm.type = g_ccz.ccz28          # No.FUN-7C0101
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ima01,ima39,ima57,ima08,
                              ima06,ima09,ima10,ima11,ima12
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
        IF INFIELD(ima01) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO ima01                             
           NEXT FIELD ima01                                                 
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr440_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
  #--------------No:MOD-B30534 modify
  #LET tm.wc=tm.wc CLIPPED," AND ima01 NOT MATCHES 'MISC*'"
   LET tm.wc=tm.wc CLIPPED," AND ima01 NOT LIKE 'MISC*' "
  #--------------No:MOD-B30534 end
#  INPUT BY NAME tm.yy,tm.mm,tm.azh01,tm.azh02,tm.d_sw,tm.more WITHOUT DEFAULTS         #No.FUN-7C0101
   INPUT BY NAME tm.yy,tm.mm,tm.type,tm.azh01,tm.azh02,tm.d_sw,tm.more WITHOUT DEFAULTS #No.FUN-7C0101
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF tm.yy IS NULL THEN NEXT FIELD yy END IF
      AFTER FIELD mm
         IF tm.mm IS NULL THEN NEXT FIELD mm END IF
         CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,bdate,edate
      #No.FUN-7C0101 --Begin
      AFTER FIELD type
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF
      #No.FUN-7C0101 --End
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
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_azh'
    LET g_qryparam.default1 = tm.azh01
    LET g_qryparam.default2 = tm.azh02
    CALL cl_create_qry() RETURNING tm.azh01,tm.azh02
#    CALL FGL_DIALOG_SETBUFFER( tm.azh01 )
#    CALL FGL_DIALOG_SETBUFFER( tm.azh02 )
# END genero shell script ADD
################################################################################
                             DISPLAY BY NAME tm.azh01,tm.azh02
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr440_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr440'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr440','9031',1)   
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
                         " '",tm.type CLIPPED,"'",             #No.FUN-7C0101
                         " '",tm.azh02 CLIPPED,"'",
                         " '",tm.azh01 CLIPPED,"'",
                         " '",tm.d_sw CLIPPED,"'",
                         #TQC-610051-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axcr440',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr440_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr440()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr440_w
END FUNCTION
 
FUNCTION axcr440()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_chr        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
   DEFINE sr   	RECORD
            	ima01	LIKE ima_file.ima01,
            	ima02	LIKE ima_file.ima02,
                ima021  LIKE ima_file.ima021,
            	ima25	LIKE ima_file.ima25,
                ccc08   LIKE ccc_file.ccc08,        #No.FUN-7C0101
            	ccc91	LIKE ccc_file.ccc91,
            	imk09	LIKE imk_file.imk09
            	END RECORD
#No.FUN-750101 --begin--
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
#No.FUN-750101  --end--
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#    LET l_sql = "SELECT ima01,ima02,'',ima25,ccc91,SUM(imk09)",       #No.FUN-7C0101
     LET l_sql = "SELECT ima01,ima02,'',ima25,ccc08,ccc91,SUM(imk09)", #No.FUN-7C0101
                 "  FROM ima_file LEFT OUTER JOIN ccc_file ON ima01=ccc01 LEFT OUTER JOIN imk_file ON ima01=imk01",
                 " WHERE ",tm.wc CLIPPED,    #No.TQC-6A0078
                 "   AND ccc_file.ccc02=",tm.yy," AND ccc_file.ccc03=",tm.mm,
                 "   AND ccc07='",tm.type,"'",                         #No.FUN-7C0101
                 "   AND imk_file.imk05=",tm.yy," AND imk_file.imk06=",tm.mm,
                 "   AND imk02 NOT IN (SELECT jce02 FROM jce_file) ", #NO:3556
                 # " GROUP BY ima01,ima02,ima25,ccc91"  #No.FUN-750101
#                "  GROUP BY ima01,ima02,ima25,ccc91"  #No.FUN-750101  #No.FUN-7C0101
                 "  GROUP BY ima01,ima02,ima25,ccc08,ccc91"            #No.FUN-7C0101                                                              
     PREPARE axcr440_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr440_curs1 CURSOR FOR axcr440_prepare1
 
     #CALL cl_outnam('axcr440') RETURNING l_name   #No.FUN-750101
     #TQC-6A0078...............begin                                                                                                
     #IF NOT cl_null(tm.azh02) THEN                #No.FUN-750101                                                                                      
      #  LET g_x[1]=tm.azh02 CLIPPED               #No.FUN-750101                                                                                  
     #END IF                                       #No.FUN-750101                                                                                  
     #TQC-6A0078...............end
     #START REPORT axcr440_rep TO l_name           #No.FUN-750101
     LET g_pageno = 0
     FOREACH axcr440_curs1 INTO sr.*
       SELECT ima021 INTO sr.ima021 FROM ima_file WHERE ima01=sr.ima01   #No.FUN-750101                                                             
       IF SQLCA.sqlcode THEN LET sr.ima021 = NULL END IF                 #No.FUN-750101
       IF sr.ccc91 IS NULL THEN LET sr.ccc91 = 0 END IF
       CALL axcr440_imk09(sr.*) RETURNING sr.imk09    #No.MOD-A90103 
       IF sr.imk09 IS NULL THEN LET sr.imk09 = 0 END IF
       
       IF tm.d_sw='Y' AND sr.ccc91=sr.imk09 THEN CONTINUE FOREACH END IF
       #OUTPUT TO REPORT axcr440_rep(sr.*)         #No.FUN-750101
       EXECUTE insert_prep USING                   #No.FUN-750101
                           sr.ima01,sr.ima02,sr.ima021,     #No.FUN-750101
                           sr.ima25,sr.ccc91,sr.imk09      #No.FUN-750101
                          ,sr.ccc08                         #No.FUN-7C0101
     END FOREACH
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
     #FINISH REPORT axcr440_rep                    #No.FUN-750101
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-750101
#No.FUN-750101  --begin--
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str=''
     #是否打印選擇條件
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'ima01,ima09,ima39,ima10,ima57,ima11,ima08,ima12,ima06')
             RETURNING tm.wc
        LET g_str=tm.wc
     END IF
     LET g_str=g_str,';',tm.azh02,';',g_ccz.ccz27,';',tm.yy,';',tm.mm
               ,';',tm.type                                #No.FUN-7C0101
#No.FUN-750101  --end--
     IF tm.type MATCHES '[12]' THEN                        #No.FUN-7C0101
        CALL cl_prt_cs3('axcr440','axcr440',l_sql,g_str)   #No.FUN-750101
     END IF                                                #No.FUN-7C0101
     IF tm.type MATCHES '[345]' THEN                       #No.FUN-7C0101                                                                
        CALL cl_prt_cs3('axcr440','axcr440_1',l_sql,g_str) #No.FUN-7C0101                                                             
     END IF                                                #No.FUN-7C0101 
END FUNCTION
 
#No.FUN-750101 --begin--
{
REPORT axcr440_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1           #No.FUN-680122CHAR(1)
   DEFINE l_ima021   LIKE ima_file.ima021
   DEFINE sr	RECORD
            	ima01	LIKE ima_file.ima01,
            	ima02	LIKE ima_file.ima02,
            	ima25	LIKE ima_file.ima25,
            	ccc91	LIKE ccc_file.ccc91,
            	imk09	LIKE imk_file.imk09
            	END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.ima01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED,pageno_total     # No.TQC-750041
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED    #NO.TQC-6A0078
      PRINT g_head CLIPPED,pageno_total     # No.TQC-750041
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,
                     g_x[9] CLIPPED,tm.yy USING '&&&&',
                     g_x[10] CLIPPED,tm.mm USING '&&'
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      SELECT ima021 INTO l_ima021 FROM ima_file WHERE ima01=sr.ima01
      IF SQLCA.sqlcode THEN LET l_ima021 = NULL END IF
      PRINT COLUMN g_c[31],sr.ima01,
            COLUMN g_c[32],sr.ima02 CLIPPED,
            COLUMN g_c[33],l_ima021, 
            COLUMN g_c[34],sr.ima25,  #MOD-4A0238
            COLUMN g_c[35],cl_numfor(sr.ccc91,35,g_ccz.ccz27), #CHI-690007 2->ccz27
            COLUMN g_c[36],cl_numfor(sr.imk09,36,g_ccz.ccz27), #CHI-690007 2->ccz27
            COLUMN g_c[37],cl_numfor((sr.ccc91-sr.imk09),37,g_ccz.ccz27)  #CHI-690007 0->ccz27
   ON LAST ROW
      PRINT g_dash[1,g_len]   #No.TQC-6A0078
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED   #No.TQC-6A0078
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]   #No.TQC-6A0078
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED   #No.TQC-6A0078
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-750101  --end--
#No.MOD-A90103 --begin
FUNCTION axcr440_imk09(sr)
DEFINE sr RECORD
         	ima01	  LIKE ima_file.ima01,
         	ima02	  LIKE ima_file.ima02,
          ima021  LIKE ima_file.ima021,
         	ima25  	LIKE ima_file.ima25,
          ccc08   LIKE ccc_file.ccc08,   
         	ccc91	  LIKE ccc_file.ccc91,
         	imk09  	LIKE imk_file.imk09
         	END RECORD
DEFINE    l_sql   LIKE type_file.chr1000    
DEFINE    l_imk09 LIKE imk_file.imk09    
DEFINE    l_imk09_sum LIKE imk_file.imk09  
DEFINE    l_img09 LIKE img_file.img09   
DEFINE    l_flag     LIKE type_file.num5            
DEFINE    l_factor   LIKE type_file.num26_10  	

     #-------------No:MOD-B30534 add
      IF tm.type ='5' THEN 
        LET l_sql = "SELECT img09,imk09",
                    "  FROM imk_file,img_file,imd_file",    
                    " WHERE imk01 = '",sr.ima01,"'",        
                    "   AND imk02 = imd01 ",                
                    "   AND imd09 = '",sr.ccc08,"'" ,       
                    "   AND imk05=",tm.yy," AND imk06=",tm.mm,
                    "   AND imk01 = img01 ",
                    "   AND imk02 = img02 ",
                    "   AND imk03 = img03 ",
                    "   AND imk04 = img04 ",
                    "   AND imk02 NOT IN (SELECT jce02 FROM jce_file) "
      ELSE
     #-------------No:MOD-B30534 end
        LET l_sql = "SELECT img09,imk09",
                    "  FROM imk_file,img_file",
                    " WHERE imk01 = '",sr.ima01,"'",                         
                    "   AND imk05=",tm.yy," AND imk06=",tm.mm,
                    "   AND imk01 = img01 ",
                    "   AND imk02 = img02 ",
                    "   AND imk03 = img03 ",
                    "   AND imk04 = img04 ",
                    "   AND imk02 NOT IN (SELECT jce02 FROM jce_file) "
                                                                            
     END IF              #No:MOD-B30534 add
     PREPARE axcr440_prepare2 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE axcr440_curs2 CURSOR FOR axcr440_prepare2

     LET l_imk09_sum = 0
     FOREACH axcr440_curs2 INTO l_img09,l_imk09
        IF cl_null(l_imk09) THEN
           CONTINUE FOREACH
        END IF
        IF cl_null(l_img09) THEN
           CONTINUE FOREACH
        END IF
        CALL s_umfchk(sr.ima01,sr.ima25,l_img09) RETURNING l_flag,l_factor
        IF l_flag THEN
           CONTINUE FOREACH
        END IF
        LET l_imk09_sum = l_imk09_sum + l_imk09/l_factor   
             
     END FOREACH          
     RETURN l_imk09_sum  	
END FUNCTION
#No.MOD-A90103 --end
