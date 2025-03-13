# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: amsx530.4gl
# Descriptions...: MPS 交期調整表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510036 05/02/15 By pengu 報表轉XML
# Modify.........: No.FUN-550056 05/05/20 By Trisy 單據編號加大
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗 
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610075 06/01/24 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680101 06/08/30 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690116 06/10/16 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-750101 07/05/31 By mike 報表格式改為crystal reports
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-CB0003 12/11/05 By chenjing CR轉XtraGrid
# Modify.........: No.FUN-D30053 13/03/18 By chenying XtraGrid报表修改
# Modify.........: No.FUN-D30053 13/03/18 By yangtt mark grup_field后跳頁失效需還原
# Modify.........: No.FUN-D40129 13/05/14 By yangtt ima08欄位新增開窗

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(600)   # Where condition                                                     
              ver_no  LIKE mps_file.mps_v,  #NO.FUN-680101 VARCHAR(2)                                                                         
              s       LIKE type_file.chr3,  #NO.FUN-680101 VARCHAR(3)                                                                         
              t       LIKE type_file.chr3,  #NO.FUN-680101 VARCHAR(3)                                                                         
              more    LIKE type_file.chr1   #NO.FUN-680101 VARCHAR(1)   # Input more condition(Y/N) 
              END RECORD
 
DEFINE   g_cnt        LIKE type_file.num10  #NO.FUN-680101 INTEGER  
DEFINE   g_i          LIKE type_file.num5   #NO.FUN-680101 SMALLINT
DEFINE   g_sql        STRING                #No.FUN-750101 
DEFINE   l_table      STRING                #No.FUN-750101 
DEFINE   g_str        STRING                #No.FUN-750101
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
#No.FUN-750101  --begin--
   LET g_sql="mps00.mps_file.mps00,",   #序號
             "mps01.mps_file.mps01,",   #料號
             "mps03.mps_file.mps03,",   #日期
             "mps071.mps_file.mps071,", #建議交期重排導至供給減少數量
             "mps072.mps_file.mps072,", #建議交期重排導至供給增加數量
             "ima02.ima_file.ima02,",   #品名
             "ima021.ima_file.ima021,",      #FUN-CB0003 
             "ima08.ima_file.ima08,",   #來源碼
             "ima25.ima_file.ima25,",   #單位
             "ima43.ima_file.ima43,",   #采購員
             "ima67.ima_file.ima67,",   #計劃員
             "mpt07.mpt_file.mpt07,",   #來源料號
             "mpt04.mpt_file.mpt04,",   #供需日期
             "mpt06.mpt_file.mpt06,",   #來源單號
             "mpt061.mpt_file.mpt061,", #項
             "mpt08.mpt_file.mpt08,",     #數量
        #FUN-CB0003--str---
            "amt.type_file.num15_3,",
            "string1.mpt_file.mpt07,",
            "string.mpt_file.mpt07,",
            "l_num.type_file.num5"
        #FUN-CB0003--end---    
   LET l_table=cl_prt_temptable('amsx530',g_sql)  CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"     #FUN-CB0003 add 5?
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
   #TQC-610075-begin
   LET tm.ver_no = ARG_VAL(8)
   LET tm.s = ARG_VAL(9)
   LET tm.t = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610075-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amsx530_tm(0,0)        # Input print condition
      ELSE CALL amsx530()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amsx530_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,  #NO.FUN-680101 SMALLINT
          l_cmd          LIKE type_file.chr1000#NO.FUN-680101 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 17
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amsx530_w AT p_row,p_col
        WITH FORM "ams/42f/amsx530" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
  #LET tm.n    = '1'                  #TQC-610075
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mps01,ima08,ima67,ima43,mps03 
#No.FUN-570240 --start--                                                                                    
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION controlp                                                                                              
            IF INFIELD(mps01) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO mps01                                                                                 
               NEXT FIELD mps01                                                                                                     
            END IF  
#FUN-CB0003--add--str--
            IF INFIELD(ima67) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima67"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima67
               NEXT FIELD ima67
            END IF
            IF INFIELD(ima43) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima43"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima43
               NEXT FIELD ima43
            END IF
#FUN-CB0003--add--end--
#No.FUN-570240 --end-- 
           #FUN-D40129----add---str--
           IF INFIELD(ima08) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima7"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima08
               NEXT FIELD ima08
            END IF
           #FUN-D40129----add---end--
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
      LET INT_FLAG = 0 CLOSE WINDOW amsx530_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no, 
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
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
      AFTER INPUT  
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
      LET INT_FLAG = 0 CLOSE WINDOW amsx530_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amsx530'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amsx530','9031',1)
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
                         #TQC-610075-begin
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         #TQC-610075-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amsx530',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amsx530_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amsx530()
   ERROR ""
END WHILE
   CLOSE WINDOW amsx530_w
END FUNCTION
 
FUNCTION amsx530()
 DEFINE   l_name    LIKE type_file.chr20,  #NO.FUN-680101 VARCHAR(20)   # External(Disk) file name                                               
#       l_time          LIKE type_file.chr8        #No.FUN-6A0081
          l_sql     LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(1000) # RDSQL STATEMENT                                                        
          l_chr     LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)                                                                          
          l_za05    LIKE type_file.chr1000,#NO.FUN-680101 VARCHAR(40)                                                                          
          l_order ARRAY[3] OF   LIKE mps_file.mps01,   #FUN-5B0105 20->40 #NO.FUN-680101 VARCHAR(40)                                     
          sr    RECORD
                mps00    LIKE mps_file.mps00,  #No.FUN-750101      
                mps01    LIKE mps_file.mps01,  #No.FUN-750101
                mps03    LIKE mps_file.mps03,  #No.FUN-750101 
                mps071   LIKE mps_file.mps071, #No.FUN-750101
                mps072   LIKE mps_file.mps072, #No.FUN-750101   
                ima02    LIKE ima_file.ima02,  #No.FUN-750101
                ima08    LIKE ima_file.ima08,  #No.FUN-750101   
                ima25    LIKE ima_file.ima25,  #No.FUN-750101   
                ima43    LIKE ima_file.ima43,  #No.FUN-750101
                ima67    LIKE ima_file.ima67,  #No.FUN-750101
                mpt07    LIKE mpt_file.mpt07,  #No.FUN-750101
                mpt04    LIKE mpt_file.mpt04,  #No.FUN-750101 
                mpt06    LIKE mpt_file.mpt06,  #No.FUN-750101 
                mpt061   LIKE mpt_file.mpt061, #No.FUN-750101
                mpt08    LIKE mpt_file.mpt08,  #No.FUN-750101                                                                                                         
                l_order1 LIKE mps_file.mps01,  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)                                               
                l_order2 LIKE mps_file.mps01,  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)                                                
                l_order3 LIKE mps_file.mps01   #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
          END RECORD,
          mps	RECORD LIKE mps_file.*,
          ima	RECORD LIKE ima_file.*
 DEFINE   mpt   RECORD LIKE mpt_file.*     #No.FUN-750101
 DEFINE   l_string     LIKE mpt_file.mpt07         #NO.FUN-680101 VARCHAR(25)   #No.FUN-750101
 DEFINE   l_string1     LIKE mpt_file.mpt07        #FUN-CB0003  add
 DEFINE   l_flag       STRING                      #No.FUN-750101 
 DEFINE   l_amt        LIKE type_file.num15_3       #FUN-CB0003  add
 DEFINE   l_num        LIKE type_file.num5          #FUN-CB0003  add
#No.FUN-750101  --begin--
     CALL cl_del_data(l_table)  
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog 
#No.FUN-750101  --end--  
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT *",
                 "  FROM mps_file, ima_file",
                 " WHERE ",tm.wc CLIPPED,
                 "   AND mps01=ima01  AND (mps072-mps071)!=0 ",
                 "   AND mps_v='",tm.ver_no,"'"
     PREPARE amsx530_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amsx530_curs1 CURSOR FOR amsx530_prepare1
 
    # CALL cl_outnam('amsx530') RETURNING l_name #No.FUN-750101 
    # START REPORT amsx530_rep TO l_name         #No.FUN-750101
     LET g_pageno = 0
     FOREACH amsx530_curs1 INTO mps.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_amt = mps.mps072-mps.mps071         #FUN-CB0003  add 
       LET l_string1 = mps.mps03 USING 'mm/dd'    #FUN-CB0003  add
       LET l_num = 3
#No.FUN-750101  --BEGIN--
{
    #   FOR g_cnt = 1 TO 3
         CASE
           WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt]=mps.mps01
           WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt]=ima.ima08
           WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt]=ima.ima67
           WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt]=ima.ima43
           WHEN tm.s[g_cnt,g_cnt]='5' LET l_order[g_cnt]=mps.mps03
                                                         USING 'yyyymmdd'
           OTHERWISE LET l_order[g_cnt]='-'
         END CASE
       END FOR
 
 
 
 
       LET sr.l_order1=l_order[1]
       LET sr.l_order2=l_order[2]
       LET sr.l_order3=l_order[3]
}
#No.FUN-750101  --end--
 
#No.FUN-750101  -- BEGIN--
      LET l_flag = 'N'
      IF (mps.mps072-mps.mps071) < 0 THEN                                                                                           
         DECLARE x530_c2 CURSOR FOR                                                                                                 
             SELECT * FROM mpt_file                                                                                                 
              WHERE mpt01=mps.mps01 AND mpt03=mps.mps03                                                                             
                AND mpt_v=mps.mps_v                                                                                                 
                AND mpt05 MATCHES '6*'                                                                                              
                AND (mpt06_fz = 'N' OR mpt06_fz IS NULL)                                                                            
              ORDER BY mpt04,mpt05                                                                                                  
         FOREACH x530_c2 INTO mpt.*                                       
             LET l_flag = 'Y'                                                           
             LET l_string=mpt.mpt07[1,7],'  ',mpt.mpt04 USING 'mm/dd',                                                              
                          '  ',mpt.mpt06        #No.FUN-550056     
             EXECUTE insert_prep USING  mps.mps00,mps.mps01,mps.mps03,mps.mps071,mps.mps072,
                                        ima.ima02,ima.ima08,ima.ima25,ima.ima43,ima.ima67,
                                        mpt.mpt07,mpt.mpt04,mpt.mpt06,mpt.mpt061,mpt.mpt08
                                        ,l_amt,l_string1,l_string,l_num            #FUN-CB0003  add
         END FOREACH       
      ELSE 
         IF l_flag='N' THEN
             LET l_string=mpt.mpt07[1,7],'  ',mpt.mpt04 USING 'mm/dd','  ',mpt.mpt06     #FUN-CB0003  add 
             EXECUTE insert_prep USING   mps.mps00,mps.mps01,mps.mps03,mps.mps071,mps.mps072,                                        
                                        ima.ima02,ima.ima021,ima.ima08,ima.ima25,ima.ima43,ima.ima67,   #FUN-CB0003 add ima.ima021
                                        '','','','',''
                                        ,l_amt,l_string1,l_string,l_num   #FUN-CB0003 add                           
         END IF                  
      END IF      
#No.FUN-750101  --end--                
       #OUTPUT TO REPORT amsx530_rep(sr.*,mps.*, ima.*)   #No.FUN-750101
     END FOREACH
#No.FUN-750101  --begin--
###XtraGrid###     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED 
     LET g_str=''
     #是否打印選擇條件
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'mps01,ima08,ima67,ima43,mps03')
             RETURNING tm.wc
        LET g_str=tm.wc
     END IF
###XtraGrid###     LET g_str=g_str,';',tm.s[1,1],';',tm.s[2,2],';',tm.s[3,3],';',tm.t
###XtraGrid###     CALL cl_prt_cs3('amsx530','amsx530',l_sql,g_str) 
    LET g_xgrid.table = l_table    ###XtraGrid###
#FUN-CB0003---str---
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"mps01,ima08,ima67,ima43,mps03")
    LET g_xgrid.grup_field = cl_get_order_field(tm.s,"mps01,ima08,ima67,ima43,mps03")  #FUN-D30053
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"mps01,ima08,ima67,ima43,mps03")
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
#FUN-CB0003---end---
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-750101   --end--
     #FINISH REPORT amsx530_rep   #No.FUN-750101
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-750101
END FUNCTION
 
#No.FUN-750101  --BEGIN--
{
REPORT amsx530_rep(sr,mps, ima)
   DEFINE l_last_sw    LIKE type_file.chr1         #NO.FUN-680101 VARCHAR(1)
   DEFINE l_pmc03      LIKE pmc_file.pmc03         #NO.FUN-680101 VARCHAR(10)
   DEFINE l_string     LIKE mpt_file.mpt07         #NO.FUN-680101 VARCHAR(25)
   DEFINE mps		RECORD LIKE mps_file.*
   DEFINE mpt		RECORD LIKE mpt_file.*
   DEFINE ima		RECORD LIKE ima_file.*
   DEFINE sr RECORD
             l_order1 LIKE mps_file.mps01,  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
             l_order2 LIKE mps_file.mps01,  #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
             l_order3 LIKE mps_file.mps01   #FUN-5B0105 20->40   #NO.FUN-680101 VARCHAR(40)
          END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin 
       PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,mps.mps01,mps.mps03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.l_order1
      IF tm.t[1,1]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.l_order2
      IF tm.t[2,2]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF sr.l_order3
      IF tm.t[3,3]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
         SKIP TO TOP OF PAGE
      END IF
 
   BEFORE GROUP OF mps.mps01
      PRINT COLUMN g_c[31],mps.mps01,
            COLUMN g_c[32],ima.ima02,
            COLUMN g_c[33],ima.ima25
   ON EVERY ROW
      PRINT COLUMN g_c[34],mps.mps00 USING '###&',' ', #FUN-590118
            COLUMN g_c[35],mps.mps03 USING 'mm/dd',
            COLUMN g_c[36],cl_numfor((mps.mps072-mps.mps071),36,0) 
      IF (mps.mps072-mps.mps071) < 0 THEN
         DECLARE x530_c2 CURSOR FOR
             SELECT * FROM mpt_file
              WHERE mpt01=mps.mps01 AND mpt03=mps.mps03
                AND mpt_v=mps.mps_v
                AND mpt05 MATCHES '6*'
                AND (mpt06_fz = 'N' OR mpt06_fz IS NULL)
              ORDER BY mpt04,mpt05
         FOREACH x530_c2 INTO mpt.*
#            LET l_string=mpt.mpt07[1,7],'  ',mpt.mpt04 USING 'mm/dd',
#                        '  ',mpt.mpt06[1,10]
             LET l_string=mpt.mpt07[1,7],'  ',mpt.mpt04 USING 'mm/dd',                                                              
                         '  ',mpt.mpt06        #No.FUN-550056                          
            PRINT COLUMN g_c[37],l_string,
                  COLUMN g_c[38],mpt.mpt061 USING '###&', #FUN-590118
                  COLUMN g_c[39],cl_numfor( mpt.mpt08,39,0) 
         END FOREACH
      END IF
      PRINT
   AFTER GROUP OF mps.mps01
      PRINT g_dash2[1,g_len] CLIPPED
   ON LAST ROW
      LET l_last_sw = 'y
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED 
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len] CLIPPED
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED 
         ELSE SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-750101  --END--


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
