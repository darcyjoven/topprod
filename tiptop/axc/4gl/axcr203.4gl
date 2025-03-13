# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axcr203.4gl
# Descriptions...: 領退料明細表
# Date & Author..: 06/03/01 By Sarah
# Modify.........: No.FUN-620066 06/03/01 By Sarah 新增"領退料明細表"
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/01 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-780017 07/08/08 By dxfwo CR報表的制作
# Modify.........: No.FUN-7C0101 08/01/28 By shiwuying 成本改善，CR增加類別編號tlfccost
# Modify.........: No.FUN-830002 08/03/03 By lala    WHERE條件修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-C30012 12/07/27 By bart 金額取位改抓ccz26
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                                     # Print condition RECORD
            wc         LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(600)     # Where condition
            yy         LIKE type_file.num5,           #No.FUN-680122SMALLINT
            mm         LIKE type_file.num5,           #No.FUN-680122SMALLINT
            type       LIKE tlfc_file.tlfctype,       #No.FUN-7C0101 add
            detail_sw  LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
            more       LIKE type_file.chr1            #No.FUN-680122CHAR(1)         # Input more condition(Y/N)
           END RECORD,
       g_bdate         LIKE type_file.dat,            #No.FUN-680122DATE
       g_edate         LIKE type_file.dat,            #No.FUN-680122DATE
       g_tot_bal       LIKE type_file.num20_6         #No.FUN-680122DECIMAL(20,6)   # User defined variable
DEFINE yy,mm           LIKE type_file.num5            #No.FUN-680122SMALLINT 
DEFINE g_i             LIKE type_file.num5            #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE l_table              STRING                    #No.FUN-780017                                                                    
DEFINE g_sql                STRING                    #No.FUN-780017                                                                    
DEFINE g_str                STRING                    #No.FUN-780017 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                   # Supress DEL key function
 
   LET g_pdate  = ARG_VAL(1)                         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET tm.type=ARG_VAL(11)  #No.FUN-7C0101 add 
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
#No.FUN-780017---Begin                                                                                                              
   LET g_sql = " tlf62.tlf_file.tlf62 ,",                                                                                            
               " ima02.ima_file.ima02 ,",
               " ima021.ima_file.ima021 ,",
               " tlfccost.tlfc_file.tlfccost,",    #No.FUN-7C0101 add
               " tlf06.tlf_file.tlf06 ,",
               " tlf905.tlf_file.tlf905 ,",
               " ima13.smy_file.smydesc ,",
               " tlf01.tlf_file.tlf01  ,",
               " l_ima02.ima_file.ima02 ,",
               " l_ima021.ima_file.ima021 ,",
               " tlf10.tlf_file.tlf10  ,",
               " tlf60.tlf_file.tlf60  ,",
               " tlf907.tlf_file.tlf907 ,",
               " ccc23.ccc_file.ccc23  "
   LET l_table = cl_prt_temptable('axcr203',g_sql) CLIPPED                                                                  
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                    
           #    " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)"      #No.FUN-7C0101
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?, ?)"    #No.FUN-7C0101                                                 
   PREPARE insert_prep FROM g_sql                                                                                           
        IF STATUS THEN                                                                                                           
          CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                     
        END IF                                                                                                                   
#No.FUN-780017---End 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL r203_tm(0,0)        # Input print condition
      ELSE CALL r203()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r203_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE 
      LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW r203_w AT p_row,p_col
        WITH FORM "axc/42f/axcr203" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy=year(g_today)
   LET tm.mm=month(g_today)
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101 add
   LET tm.detail_sw='N'
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON tlf62,tlf01,ima57,ima06,ima09,ima10,ima11,ima12
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION controlp                                                                                              
            CASE 
               WHEN INFIELD(tlf62)
                    CALL cl_init_qry_var()                                                                                               
                    LET g_qryparam.form = "q_ima"                                                                                       
                    LET g_qryparam.state = "c"                                                                                           
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
                    DISPLAY g_qryparam.multiret TO tlf62                                                                                 
                    NEXT FIELD tlf62
               WHEN INFIELD(tlf01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ima"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tlf01
                    NEXT FIELD tlf01
            END CASE
 
            IF INFIELD(tlf01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO tlf01                                                                                 
               NEXT FIELD tlf01                                                                                                     
            END IF  
 
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW r203_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
            
      END IF
      LET tm.wc=tm.wc CLIPPED," AND ima01 NOT LIKE 'MISC%'"
 
      INPUT BY NAME tm.type,tm.yy,tm.mm,tm.detail_sw,tm.more WITHOUT DEFAULTS #No.FUN-7C0101 add tm.type
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
 
         AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
         
         AFTER FIELD type                                               #No.FUN-7C0101
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF#No.FUN-7C0101
                
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution
    
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
         LET INT_FLAG = 0 CLOSE WINDOW r203_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file WHERE zz01='axcr203'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axcr203','9031',1)   
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.type CLIPPED,"'" ,            #No.FUN-7C0101 add
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('axcr203',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW axcr203_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r203()
      ERROR ""
   END WHILE
   CLOSE WINDOW r203_w
END FUNCTION
 
FUNCTION r203()
   DEFINE l_name     LIKE type_file.chr20,          #No.FUN-680122CHAR(20)        # External(Disk) file name
#       l_time          LIKE type_file.chr8         #No.FUN-6A0146
          l_sql      STRING,          # RDSQL STATEMENT
          l_slip     LIKE aab_file.aab02,           #No.FUN-680122 VARCHAR(5)
          l_ima02    LIKE ima_file.ima02,           #品名                         #No.FUN-750110
          l_ima021   LIKE ima_file.ima021,          #規格                         #No.FUN-750110
          l_smydmy1  LIKE smy_file.smydmy1,
          l_smydmy2  LIKE smy_file.smydmy2,
          sr         RECORD 
                      tlf62   LIKE tlf_file.tlf62,    #成品編號
                      ima02   LIKE ima_file.ima02,    #品名
                      ima021  LIKE ima_file.ima021,   #規格
                      tlfccost LIKE tlfc_file.tlfccost,#No.FUN-7C0101 add
                      tlf06   LIKE tlf_file.tlf06,    #單據日期 
                      tlf905  LIKE tlf_file.tlf905,   #單號 
                      desc    LIKE smy_file.smydesc,  #單據名稱
                      tlf01   LIKE tlf_file.tlf01,    #異動料件編號     
                      tlf10   LIKE tlf_file.tlf10,    #異動數量
                      tlf60   LIKE tlf_file.tlf60,    #異動單據單位對庫存單位之換算率
                      tlf907  LIKE tlf_file.tlf907,   #入出庫碼 
                      ccc23   LIKE ccc_file.ccc23     #本月平均單價     
                     END RECORD
 
   CALL s_azn01(tm.yy,tm.mm) RETURNING g_bdate,g_edate
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   LET l_sql = "SELECT tlf62,ima02,ima021,tlfccost,tlf06,tlf905,'',", #No.FUN-7C0101 add tlfccost
               "       tlf01,tlf10,tlf60,tlf907,0 ",
               "  FROM tlf_file,ima_file, tlfc_file ",  #No.FUN-7C0101 
               " WHERE tlf62=ima01 ",
               "   AND ima911='Y'",
               "   AND tlf02 BETWEEN 50 AND 59 ",
               "   AND tlf03 >= 60 AND tlf03 <= 69 ",
               "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
               "   AND tlfc_file.tlfc01 = tlf01  AND tlfc_file.tlfc02 = tlf02",
               "   AND tlfc_file.tlfc03 = tlf03  AND tlfc_file.tlfc06 = tlf06",
               "   AND tlfc_file.tlfc13 = tlf13",
               "   AND tlfc_file.tlfc902= tlf902 AND tlfc_file.tlfc903= tlf903",
               "   AND tlfc_file.tlfc904= tlf904 AND tlfc_file.tlfc905= tlf905",
               "   AND tlfc_file.tlfc906= tlf906 AND tlfc_file.tlfc907= tlf907",
               "   AND tlfc_file.tlfctype='",tm.type,"'",
               "   AND ",tm.wc CLIPPED,
               " UNION ",
               "SELECT tlf62,ima02,ima021,tlfccost,tlf06,tlf905,'',", #No.FUN-7C0101 add tlfccost
               "       tlf01,tlf10,tlf60,tlf907,0 ",
               "  FROM tlf_file,ima_file, tlfc_file ",   #No.FUN-7C0101
               " WHERE tlf62=ima01 ",
               "   AND ima911='Y'",
               "   AND tlf03 BETWEEN 50 AND 59 ",
               "   AND tlf02 >= 60 AND tlf03 <= 69 ",
               "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
               "   AND tlfc_file.tlfc01 = tlf01   AND tlfc_file.tlfc02 = tlf02",
               "   AND tlfc_file.tlfc03 = tlf03   AND tlfc_file.tlfc06 = tlf06",
               "   AND tlfc_file.tlfc13 = tlf13",
               "   AND tlfc_file.tlfc902= tlf902  AND tlfc_file.tlfc903= tlf903",
               "   AND tlfc_file.tlfc904= tlf904  AND tlfc_file.tlfc905= tlf905",
               "   AND tlfc_file.tlfc906= tlf906  AND tlfc_file.tlfc907= tlf907",
               "   AND tlfc_file.tlfctype= '",tm.type,"'",
               "   AND ",tm.wc CLIPPED
 
   PREPARE r203_pr FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
   DECLARE r203_cs1 CURSOR FOR r203_pr
 
#  CALL cl_outnam('axcr203') RETURNING l_name    #No.FUN-780017
#  START REPORT r203_rep TO l_name               #No.FUN-780017
   CALL cl_del_data(l_table)                     #No.FUN-780017   
   LET g_pageno = 0
   FOREACH r203_cs1 INTO sr.*
     IF STATUS THEN 
        CALL cl_err('foreach:',STATUS,1)
        EXIT FOREACH 
     END IF
 
     CALL s_get_doc_no(sr.tlf905) RETURNING l_slip
     SELECT smydesc,smydmy1,smydmy2
       INTO sr.desc,l_smydmy1,l_smydmy2 
       FROM smy_file WHERE smyslip = l_slip
     IF l_smydmy1 = 'N' THEN CONTINUE FOREACH END IF
     IF l_smydmy2 != '3' THEN CONTINUE FOREACH END IF
 
     SELECT ccc23 INTO sr.ccc23 FROM ccc_file
      WHERE ccc01=sr.tlf01 AND ccc02=tm.yy AND ccc03=tm.mm
     IF cl_null(sr.ccc23) THEN LET sr.ccc23=0 END IF
 
     SELECT ima02,ima021 INTO l_ima02,l_ima021                                                                                     
       FROM ima_file WHERE ima01=sr.tlf01                                                                                          
     IF STATUS THEN                                                                                                                
        LET l_ima02  = ''                                                                                                          
        LET l_ima021 = ''                                                                                                          
     END IF      
#No.FUN-780017---Begin 
#    OUTPUT TO REPORT r203_rep(sr.*)
     EXECUTE insert_prep USING sr.tlf62,sr.ima02,sr.ima021,sr.tlfccost,sr.tlf06,sr.tlf905,sr.desc,#No.FUN-7C0101 add sr.tlfccost
                               sr.tlf01,l_ima02,l_ima021,sr.tlf10,sr.tlf60,sr.tlf907,
                               sr.ccc23
   END FOREACH
#  FINISH REPORT r203_rep
 
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(tm.wc,'tlf62,tlf01,ima57,ima06,ima09,ima10,ima11,ima12')         
           RETURNING tm.wc                                                     
   END IF
   #LET g_str = tm.wc,";",tm.yy,";",tm.mm,";",g_ccz.ccz27,";",g_azi05,";",tm.type #No.FUN-7C0101 #CHI-C30012
   LET g_str = tm.wc,";",tm.yy,";",tm.mm,";",g_ccz.ccz27,";",g_ccz.ccz26,";",tm.type  #CHI-C30012
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
   
#No.FUN-7C0101-------------BEGIN-----------------
   #CALL cl_prt_cs3('axcr203','axcr203',l_sql,g_str)
   IF tm.type MATCHES '[12]' THEN
      CALL cl_prt_cs3('axcr203','axcr203_1',l_sql,g_str)
   END IF
   IF tm.type MATCHES '[345]' THEN
      CALL cl_prt_cs3('axcr203','axcr203',l_sql,g_str)
   END IF
#No.FUN-7C0101--------------END------------------
#No.FUN-780017---End 
END FUNCTION
{                                                     #No.FUN-780017
REPORT r203_rep(sr)                      
   DEFINE l_last_sw  LIKE type_file.chr1,             #No.FUN-680122CHAR(1)
          l_ima02    LIKE ima_file.ima02,             #品名
          l_ima021   LIKE ima_file.ima021,            #規格
          sr         RECORD 
                      tlf62   LIKE tlf_file.tlf62,    #成品編號
                      ima02   LIKE ima_file.ima02,    #品名
                      ima021  LIKE ima_file.ima021,   #規格
                      tlf06   LIKE tlf_file.tlf06,    #單據日期 
                      tlf905  LIKE tlf_file.tlf905,   #單號 
                      desc    LIKE smy_file.smydesc,  #單據名稱
                      tlf01   LIKE tlf_file.tlf01,    #異動料件編號     
                      tlf10   LIKE tlf_file.tlf10,    #異動數量
                      tlf60   LIKE tlf_file.tlf60,    #異動單據單位對庫存單位之換算率
                      tlf907  LIKE tlf_file.tlf907,   #入出庫碼 
                      ccc23   LIKE ccc_file.ccc23     #本月平均單價     
                     END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY sr.tlf62
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT g_x[9] CLIPPED,tm.yy USING '####',' ',
            g_x[10] CLIPPED,tm.mm USING '##'
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021
        FROM ima_file WHERE ima01=sr.tlf01
      IF STATUS THEN
         LET l_ima02  = ''
         LET l_ima021 = ''
      END IF
      PRINT COLUMN g_c[31],sr.tlf62 CLIPPED,
            COLUMN g_c[32],sr.ima02 CLIPPED,
            COLUMN g_c[33],sr.ima021 CLIPPED,
            COLUMN g_c[34],sr.tlf06 CLIPPED,
            COLUMN g_c[35],sr.tlf905 CLIPPED,
            COLUMN g_c[36],sr.desc CLIPPED,
            COLUMN g_c[37],sr.tlf01 CLIPPED,
            COLUMN g_c[38],l_ima02 CLIPPED,
            COLUMN g_c[39],l_ima021 CLIPPED,
            COLUMN g_c[40],cl_numfor(sr.tlf10*sr.tlf60*sr.tlf907,40,g_ccz.ccz27), #CHI-690007 0->ccz27
            COLUMN g_c[41],cl_numfor(sr.tlf10*sr.tlf60*sr.ccc23,41,2)
     #IF tm.detail_sw='Y' THEN
     #END IF
 
   AFTER GROUP OF sr.tlf62 
      PRINT COLUMN g_c[40],g_x[11] CLIPPED,
            COLUMN g_c[41],cl_numfor(GROUP SUM(sr.tlf10*sr.tlf60*sr.ccc23),41,g_azi05)
      PRINT 
 
   ON LAST ROW
      PRINT g_dash2
      PRINT COLUMN g_c[40],g_x[12] CLIPPED,
            COLUMN g_c[41],cl_numfor(SUM(sr.tlf10*sr.tlf60*sr.ccc23),41,g_azi05)
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
      ELSE 
         SKIP 2 LINE
      END IF
END REPORT  }                                     #No.FUN-780017
             
