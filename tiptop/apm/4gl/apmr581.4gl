# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmr581.4gl
# Desc/riptions..: 無交期性採購未轉明細表
# Input parameter:
# Return code....:
# Date & Author..: 01/04/03 by Wiky
# Modify.........: No.FUN-4C0095 05/01/04 By Mandy 報表轉XML
# Modify.........: No.FUN-570243 05/07/25 By Trisy 料件編號開窗
# Modify.........: No.FUN-580004 05/08/05 By jackie 雙單位報表修改
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5B0212 05/12/27 By kevin 採購項次對齊
# Modify.........: No.TQC-610085 06/04/04 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-750097 07/06/11 By cheunl報表轉為CR報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80001 10/08/02 By destiny 列印增加截止日期
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580004 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17     #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5     #No.FUN-680136 SMALLINT
END GLOBALS
#No.FUN-580004 --end--
  DEFINE tm  RECORD                             # Print condition RECORD
               #wc       VARCHAR(500),             # Where condition        #TQC-630166 mark
                wc       STRING,                # Where condition        #TQC-630166
                more     LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)   # Input more condition(Y/N)
                a        LIKE type_file.chr1,   #NO.FUN-A80001
                pon19    LIKE pon_file.pon19    #NO.FUN-A80001
             END RECORD
  DEFINE g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
#No.FUN-580004 --start--
  DEFINE g_cnt           LIKE type_file.num10   #No.FUN-680136 INTEGER
  DEFINE g_sma115        LIKE sma_file.sma115
  DEFINE g_sma116        LIKE sma_file.sma116
  DEFINE l_table        STRING                 #No.FUN-750097                                                                         
  DEFINE g_str          STRING                 #No.FUN-750097                                                                         
  DEFINE g_sql          STRING                 #No.FUN-750097
#No.FUN-580004 --end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
#No.FUN-750097 -----------start---------------
    LET g_sql = " pom01.pom_file.pom01,",
                " pon02.pon_file.pon02,",
                " pon04.pon_file.pon04,",
                " pon07.pon_file.pon07,",
                " pon20.pon_file.pon20,",
                " pon21.pon_file.pon21,",
                " ima02.ima_file.ima02,",
                " ima021.ima_file.ima021,",
                " ima906.ima_file.ima906,",
                " pon80.pon_file.pon80,",
                " pon82.pon_file.pon82,",
                " pon83.pon_file.pon83,",
                " pon85.pon_file.pon85,",  
                " pon19.pon_file.pon19 " #NO.FUN-A80001 
 
    LET l_table = cl_prt_temptable('apmr581',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF  l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ? , ?, ?, ?,? )"    #NO.FUN-A80001  add pon19                                                                              
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#No.FUN-750097---------------end------------
 
   LET g_pdate = ARG_VAL(1)                  # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#-------------No.TQC-610085 modify
  #LET tm.more  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#-------------No.TQC-610085 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r581_tm(0,0)            # Input print condition
      ELSE CALL apmr581()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION r581_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd         LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 6 LET p_col = 16
 
   OPEN WINDOW r581_w AT p_row,p_col WITH FORM "apm/42f/apmr581"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   DISPLAY BY NAME tm.more
   CONSTRUCT BY NAME tm.wc ON pom01,pom04,pom12,pon04
#No.FUN-570243 --start--
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION CONTROLP
            IF INFIELD(pon04) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pon04
               NEXT FIELD pon04
            END IF
#No.FUN-570243 --end--
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r581_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM         
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   
   LET tm.a='N'           #NO.FUN-A80001
   DISPLAY BY NAME tm.a   #NO.FUN-A80001
   INPUT BY NAME tm.a,tm.pon19,tm.more WITHOUT DEFAULTS  #NO.FUN-A80001 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
      #NO.FUN-A80001--begin 
      AFTER FIELD a
         IF tm.a='N' THEN 
            CALL cl_set_comp_entry("pon19",FALSE)
            LET tm.pon19=NULL
            DISPLAY tm.pon19 TO pon19
         ELSE 
            CALL cl_set_comp_entry("pon19",TRUE)
            LET tm.pon19=g_today 
         END IF 
         
      ON CHANGE a
         IF tm.a='N' THEN 
            CALL cl_set_comp_entry("pon19",FALSE)
            LET tm.pon19=NULL
            DISPLAY tm.pon19 TO pon19
         ELSE 
            CALL cl_set_comp_entry("pon19",TRUE)
            LET tm.pon19=g_today 
         END IF     
                  
      BEFORE FIELD pon19
         IF tm.a='N' THEN 
            CALL cl_set_comp_entry("pon19",FALSE)
            LET tm.pon19=NULL
            DISPLAY tm.pon19 TO pon19
         ELSE 
            CALL cl_set_comp_entry("pon19",TRUE)
            LET tm.pon19=g_today 
         END IF          
      #NO.FUN-A80001--end
      AFTER FIELD more
         IF cl_null(tm.more) OR tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW r581_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='apmr581'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('apmr581','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,  #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                     #----------No.TQC-610085 modify
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     #----------No.TQC-610085 end
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('apmr581',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r581_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL apmr581()
   ERROR ""
END WHILE
   CLOSE WINDOW r581_w
END FUNCTION
 
FUNCTION apmr581()
   DEFINE l_name        LIKE type_file.chr20,         # External(Disk) file name           #No.FUN-680136 VARCHAR(20)
          l_name1       LIKE type_file.chr20,         # VARCHAR(20)
          l_time        LIKE type_file.chr8,          # Used time for running the job      #No.FUN-680136 VARCHAR(8)
         #l_sql         LIKE type_file.chr1000,       # RDSQL STATEMENT   #TQC-630166 mark #No.FUN-680136 VARCHAR(1000)
          l_sql         STRING,                       # RDSQL STATEMENT   #TQC-630166
          l_chr         LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
      #   l_order       ARRAY[6] OF  LIKE apm_file.apm08,                 #No.FUN-680136 VARCHAR(10)  #No.TQC-6A0079
          i             LIKE type_file.num5,          #No.FUN-580004      #No.FUN-680136 SMALLINT
          sr            RECORD
                               pom01  LIKE pom_file.pom01,       # 採構單號
                               pon02  LIKE pon_file.pon02,       # 項次
                               pon04  LIKE pon_file.pon04,       # 料號
                               pon07  LIKE pon_file.pon07,       # 單位
                               pon20  LIKE pon_file.pon20,       # 申請數量
                               pon21  LIKE pon_file.pon21,       # 已轉數量
                               notpon LIKE pon_file.pon21,       # 未轉數量
                               ima02  LIKE ima_file.ima02,       # 品名
                               ima021 LIKE ima_file.ima021,      # 規格
#No.FUN-580004 --start--
                               pon80 LIKE pon_file.pon80,
                               pon82 LIKE pon_file.pon82,
                               pon83 LIKE pon_file.pon83,
                               pon85 LIKE pon_file.pon85,
                               pon19 LIKE pon_file.pon19    #NO.FUN-A80001
                        END RECORD
     DEFINE l_i,l_cnt          LIKE type_file.num5          #No.FUN-680136 SMALLINT
     DEFINE l_zaa02            LIKE zaa_file.zaa02
     DEFINE l_ima906    LIKE ima_file.ima906
     DEFINE l_str2      LIKE type_file.chr1000
     DEFINE l_pon82     LIKE pon_file.pon82 
     DEFINE l_pon85     LIKE pon_file.pon85 
#No.FUN-580004 --end--
 
     CALL cl_del_data(l_table)                                   #No.FUN-750097   
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-750097
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file   #FUN-580004
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND pomuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND pomgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND pomgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pomuser', 'pomgrup')
     #End:FUN-980030
 
     LET l_sql = " SELECT pom01,pon02,pon04,pon07,pon20,pon21,'',",
                 " ima02,ima021,pon80,pon82,pon83,pon85,pon19 ",   #No.FUN-580004  #NO.FUN-A80001
                 " FROM pom_file,pon_file, ima_file",
                 " WHERE pom01 = pon01 AND pon04=ima01",
                 "   AND pon20-pon21 > 0 ",
                 "   AND ",tm.wc CLIPPED
     #NO.FUN-A80001--begin 
     IF tm.a='Y' THEN  
        LET l_sql=l_sql," AND pon19 <= '",tm.pon19,"' "
     END IF 
     #NO.FUN-A80001--end
     PREPARE r581_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
        EXIT PROGRAM
           
     END IF
     DECLARE r581_cs1 CURSOR FOR r581_prepare1
     LET l_name = 'apmr581.out'
#No.FUN-750097-Begin
#    CALL cl_outnam('apmr581') RETURNING l_name
#No.FUN-580004  --start
#    IF g_sma115 = "Y" THEN
#           LET g_zaa[40].zaa06 = "N"
#    ELSE
#           LET g_zaa[40].zaa06 = "Y"
#    END IF
     CALL cl_prt_pos_len()
     IF g_sma115 = "Y" THEN
            LET l_name1 = 'apmr581'
     ELSE
            LET l_name1 = 'apmr581_1' 
     END IF
#No.FUN-580004 --end--
#    START REPORT r581_rep TO l_name
#No.FUN-750097-end  
 
     LET g_pageno = 0
     FOREACH r581_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
#No.FUN-750097-Begin
#      OUTPUT TO REPORT r581_rep(sr.*)
       SELECT ima906 INTO l_ima906 FROM ima_file
                          WHERE ima01=sr.pon04
       LET l_str2 = ""
       IF g_sma115 = "Y" THEN
          CASE l_ima906
             WHEN "2"
                CALL cl_remove_zero(sr.pon85) RETURNING l_pon85
                LET l_str2 = l_pon85 , sr.pon83 CLIPPED
                IF cl_null(sr.pon85) OR sr.pon85 = 0 THEN
                    CALL cl_remove_zero(sr.pon82) RETURNING l_pon82
                    LET l_str2 = l_pon82, sr.pon80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pon82) AND sr.pon82 > 0 THEN
                      CALL cl_remove_zero(sr.pon82) RETURNING l_pon82
                      LET l_str2 = l_str2 CLIPPED,',',l_pon82, sr.pon80 CLIPPED
                   END IF
                END IF
             WHEN "3"
                IF NOT cl_null(sr.pon85) AND sr.pon85 > 0 THEN
                    CALL cl_remove_zero(sr.pon85) RETURNING l_pon85
                    LET l_str2 = l_pon85 , sr.pon83 CLIPPED
                END IF
          END CASE
          EXECUTE insert_prep USING
                  sr.pom01,sr.pon02,sr.pon04,sr.pon07,sr.pon20,sr.pon21,
                  sr.ima02,sr.ima021,l_ima906,sr.pon80,sr.pon82,sr.pon83,l_pon85,sr.pon19  #NO.FUN-A80001  
       ELSE
#         LET l_ima906 = ''
#         LET sr.pon80 = ''
#         LET sr.pon82 = ''
#         LET sr.pon83 = ''
#         LET l_pon85  = ''
          EXECUTE insert_prep USING
                  sr.pom01,sr.pon02,sr.pon04,sr.pon07,sr.pon20,sr.pon21,
                  sr.ima02,sr.ima021,l_ima906,sr.pon80,sr.pon82,sr.pon83,l_pon85,sr.pon19  #NO.FUN-A80001 
       END IF
     END FOREACH
 
#    FINISH REPORT r581_rep
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     LET g_str = ''                                                                                                                 
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'pom01,pom04,pom12,pon04')                                                                                                 
             RETURNING tm.wc                                                                                                        
        LET g_str = tm.wc                                                                                                           
     END IF                                                                                                                         
     LET g_str = g_str                                              
     CALL cl_prt_cs3('apmr581',l_name1,l_sql,g_str)
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750097-end
END FUNCTION
 
#No.FUN-750097-Begin
{REPORT r581_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_first       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          sr               RECORD
                               pom01  LIKE pom_file.pom01,       # 採構單號
                               pon02  LIKE pon_file.pon02,       # 項次
                               pon04  LIKE pon_file.pon04,       # 料號
                               pon07  LIKE pon_file.pon07,       # 單位
                               pon20  LIKE pon_file.pon20,       # 申請數量
                               pon21  LIKE pon_file.pon21,       # 已轉數量
                               notpon LIKE pon_file.pon21,       # 未轉數量
                               ima02  LIKE ima_file.ima02,       # 品名
                               ima021 LIKE ima_file.ima021,      # 規格
#No.FUN-580004 --start--
                               pon80 LIKE pon_file.pon80,
                               pon82 LIKE pon_file.pon82,
                               pon83 LIKE pon_file.pon83,
                               pon85 LIKE pon_file.pon85
                        END RECORD
  DEFINE l_ima906       LIKE ima_file.ima906
 #DEFINE l_str2         VARCHAR(100)   #TQC-630166 mark
  DEFINE l_str2         STRING      #TQC-630166
  DEFINE l_pon85        STRING
  DEFINE l_pon82        STRING
#No.FUN-580004 --end--
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.pom01,sr.pon02
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[40],g_x[36],g_x[37],g_x[38],g_x[39]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.pom01
       PRINT COLUMN g_c[31],sr.pom01 CLIPPED;         #採購單號
 
   ON EVERY ROW
       LET sr.notpon=sr.pon20-sr.pon21
 
#No.FUN-580004 --start--
      SELECT ima906 INTO l_ima906 FROM ima_file
                         WHERE ima01=sr.pon04
      LET l_str2 = ""
      IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
                CALL cl_remove_zero(sr.pon85) RETURNING l_pon85
                LET l_str2 = l_pon85 , sr.pon83 CLIPPED
                IF cl_null(sr.pon85) OR sr.pon85 = 0 THEN
                    CALL cl_remove_zero(sr.pon82) RETURNING l_pon82
                    LET l_str2 = l_pon82, sr.pon80 CLIPPED
                ELSE
                   IF NOT cl_null(sr.pon82) AND sr.pon82 > 0 THEN
                      CALL cl_remove_zero(sr.pon82) RETURNING l_pon82
                      LET l_str2 = l_str2 CLIPPED,',',l_pon82, sr.pon80 CLIPPED
                   END IF
                END IF
            WHEN "3"
                IF NOT cl_null(sr.pon85) AND sr.pon85 > 0 THEN
                    CALL cl_remove_zero(sr.pon85) RETURNING l_pon85
                    LET l_str2 = l_pon85 , sr.pon83 CLIPPED
                END IF
         END CASE
      ELSE
      END IF
       PRINT  COLUMN g_c[32],sr.pon02 USING '#######&'  CLIPPED, #No.TQC-5B0212
              COLUMN g_c[33],sr.pon04 CLIPPED,  #FUN-5B0014 [1,20] CLIPPED,  #No.FUN-580004
              COLUMN g_c[34],sr.ima02 CLIPPED,
              COLUMN g_c[35],sr.ima021 CLIPPED,
              COLUMN g_c[40],l_str2 CLIPPED,   #No.FUN-580004
              COLUMN g_c[36],sr.pon07 CLIPPED,
              COLUMN g_c[37],cl_numfor(sr.pon20,37,2),
              COLUMN g_c[38],cl_numfor(sr.pon21,38,2),
              COLUMN g_c[39],cl_numfor(sr.notpon,39,2)
   ON LAST ROW
      IF g_zz05 = 'Y' THEN  # (80)-70,140,210,280   /   (132)-120,240,300
         PRINT g_dash
        #TQC-630166
        #IF tm.wc[001,120] > ' ' THEN                      # for 132
        #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
        #IF tm.wc[121,240] > ' ' THEN
        #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
        #IF tm.wc[241,300] > ' ' THEN
        #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
        CALL cl_prt_pos_wc(tm.wc)
        #END TQC-630166
      END IF
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
    IF l_last_sw = 'n'
        THEN PRINT g_dash
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE SKIP 2 LINES
    END IF
 END REPORT}
#No.FUN-750097-end
