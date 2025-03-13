# Prog. Version..: '5.10.00-08.01.04(00004)'     #
# Pattern name...: axdr221.4gl
# Descriptions...: 集團間銷售預測稽核表             
# Date & Author..: 04/03/15 By Hawk 
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4B0067 04/11/18 BY Elva 將變數用Like方式定義,放寬ima02
# Modify.........: No:MOD-530870 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP 
# Modify.........: No:TQC-5B0045 05/11/08 By Smapmin 調整報表
# Modify.........: No:MOD-630001 06/03/02 By Vivien “工廠”修改為“營運中心”
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:FUN-680108 06/08/29 By zhuying 欄位形態定義為LIKE
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/10 By xumin 報表序號靠右顯示及表頭格式修改
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD
           wc      LIKE type_file.chr1000,      #No.FUN-680108 VARCHAR(500)
           a       LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
           bdate   LIKE type_file.num10,        #No.FUN-680108 INTEGER                                 
           edate   LIKE type_file.num10,        #No.FUN-680108 INTEGER 
           b       LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
           more    LIKE type_file.chr1          #No.FUN-680108 VARCHAR(01)
           END RECORD
DEFINE     g_yy            LIKE type_file.num5,    #No.FUN-680108 SMALLINT     
           g_mm            LIKE type_file.num5,    #No.FUN-680108 SMALLINT            
           g_wk            LIKE type_file.num5,    #No.FUN-680108 SMALLINT        
           g_xx            LIKE type_file.num5     #No.FUN-680108 SMALLINT
 DEFINE     g_sql    string,    #No:FUN-580092 HCN    
           l_log     LIKE type_file.chr1           #No.FUN-680108 VARCHAR(01)
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT

MAIN
    OPTIONS
       FORM LINE     FIRST + 2,
       MESSAGE LINE  LAST,
       PROMPT LINE   LAST,
       INPUT NO WRAP
    DEFER INTERRUPT
    LET g_pdate  = ARG_VAL(1)
    LET g_towhom = ARG_VAL(2)
    LET g_rlang  = ARG_VAL(3)
    LET g_bgjob  = ARG_VAL(4)
    LET g_prtway = ARG_VAL(5)
    LET g_copies = ARG_VAL(6)
    LET tm.wc    = ARG_VAL(7)
    LET tm.a     = ARG_VAL(8)
 #-------------No:TQC-610088 modify
    LET tm.bdate = ARG_VAL(9)
    LET tm.edate = ARG_VAL(10)
    LET tm.b     = ARG_VAL(11)
   #No:FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No:FUN-570264 ---end---
 #-------------No:TQC-610088 end
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXD")) THEN
      EXIT PROGRAM
   END IF
    IF NOT cl_null(tm.wc) THEN
        CALL r221_out()
    ELSE
       CALL r221_tm(0,0)
    END IF
END MAIN

FUNCTION r221_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No:FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,  #No.FUN-680108 SMALLINT
       l_cmd          LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(1000)
        l_obc021      LIKE obc_file.obc021 #MOD-4B0067 

        LET p_row = 5 LET p_col = 13
    OPEN WINDOW r221_w AT p_row,p_col
         WITH FORM "axd/42f/axdr221"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
    CALL cl_ui_init()

    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL
    LET tm.a     = '1'
    CALL r221_obc021()
    LET tm.b     = 'N'
    LET tm.more  = 'N'
    LET g_pdate  = g_today
    LET g_rlang  = g_lang
    LET g_bgjob  = 'N'
    LET g_copies = '1'
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON obc01,obc04,obc05
               HELP 1

      #No:FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No:FUN-580031 ---end---

      ON ACTION locale                                                          
          #CALL cl_dynamic_locale()                                             
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
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

#No.FUN-570243  --start-                                                                          
      ON ACTION CONTROLP                                                                          
            IF INFIELD(obc01) THEN                                                                
               CALL cl_init_qry_var()                                                             
               LET g_qryparam.form = "q_ima"                                                      
               LET g_qryparam.state = "c"                                                         
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                 
               DISPLAY g_qryparam.multiret TO obc01                                            
               NEXT FIELD obc01                                                                   
            END IF                                                                                
#No.FUN-570243 --end--  

      #No:FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No:FUN-580031 ---end---

 END CONSTRUCT                                                                  
       IF g_action_choice = "locale" THEN                                       
          LET g_action_choice = ""                                              
          CALL cl_dynamic_locale()                                              
          CONTINUE WHILE                                                        
       END IF                                                                   
                        
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW r221_w
        EXIT PROGRAM
    END IF
    IF tm.wc = ' 1=1' THEN
        CALL cl_err('','9046',0) CONTINUE WHILE
    END IF

    DISPLAY BY NAME tm.a,tm.bdate,tm.edate,tm.b,tm.more
    INPUT tm.a,tm.bdate,tm.edate,tm.b,tm.more WITHOUT DEFAULTS
        FROM FORMONLY.a,FORMONLY.bdate,FORMONLY.edate,         
             FORMONLY.b,FORMONLY.more HELP 1

      #No:FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 ---end---

      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[123]' THEN
             NEXT FIELD a
         END IF
         CALL r221_obc021()
         DISPLAY tm.edate To edate

      AFTER FIELD bdate                                                         
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF  
         CALL r221_date(tm.bdate)
         IF l_log = '0' THEN 
             CALL cl_err('','axd-085',0)                            
             NEXT FIELD bdate                                            
         END IF                                                          
            
      AFTER FIELD edate                                                         
         IF cl_null(tm.edate) THEN NEXT FIELD edate END IF                      
         CALL r221_date(tm.edate)
         IF l_log = '0' THEN 
             CALL cl_err('','axd-085',0)                            
             NEXT FIELD bdate                                            
         END IF                                                          
         IF tm.bdate > tm.edate THEN NEXT FIELD bdate END IF
 
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
            NEXT FIELD b
         END IF

      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD FORMONLY.more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG CALL cl_cmdask()  

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

      #No:FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 ---end---

    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW r221_w
        EXIT PROGRAM
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file
         WHERE zz01='axdr221'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('axdr221','9031',1)
        ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd=l_cmd CLIPPED,
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",          #No:TQC-610088 add
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",                             
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No:FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No:FUN-570264
                         " '",g_template CLIPPED,"'"            #No:FUN-570264
            CALL cl_cmdat('axdr221',g_time,l_cmd)
        END IF
        CLOSE WINDOW r221_w
        EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL r221_out()
    ERROR ""
END WHILE
    CLOSE WINDOW r221_w
END FUNCTION

FUNCTION r221_date(l_date)
DEFINE l_date   LIKE  obc_file.obc021
    LET l_log ='1'
    IF tm.a MATCHES '[12]' THEN                                  
        IF l_date > 999999 OR l_date < 100001 THEN          
           LET l_log = '0'      
        END IF                                                          
        LET g_yy = l_date/100                                     
        IF tm.a = '1' THEN                                       
            LET g_mm = l_date-g_yy*100                            
            IF g_mm = 0  THEN
                LET l_log = '0'   
            END IF   
        ELSE 
                LET g_wk = l_date-g_yy*100                           
                IF g_wk = 0 THEN
                    LET l_log = '0'      
                END IF                                      
            END IF  
        END IF
    IF tm.a = '3' THEN                                           
        IF l_date > 99999999 OR l_date < 10000001 THEN      
            LET l_log = '0'      
        END IF                                                          
        LET g_yy = l_date/10000                                   
        LET g_xx = l_date - g_yy*10000                            
        LET g_mm = g_xx/100     
        LET g_xx = g_xx - g_mm * 100    
        IF (g_mm = 0 OR g_xx =0) THEN
            LET l_log = '0'      
        END IF                                      
    END IF                                                            
    IF g_mm > 12 OR g_wk > 53 OR g_xx > 3 THEN
        LET l_log = '0'      
    END IF 
END FUNCTION                                                           

FUNCTION r221_obc021()
DEFINE l_yy  LIKE type_file.num5,         #No.FUN-680108 SMALLINT
       l_mm  LIKE type_file.num5,         #No.FUN-680108 SMALLINT
       l_xx  LIKE type_file.num5,         #No.FUN-680108 SMALLINT
       l_wk  LIKE type_file.num5          #No.FUN-680108 SMALLINT

    LET l_yy = YEAR(g_today)
    LET l_mm = MONTH(g_today)
    LET l_xx = DAY(g_today) 
    LET l_wk = 1
    IF l_xx < 11 THEN 
        LET l_xx = 1
    ELSE
        IF l_xx < 21 THEN LET l_xx = 2
            ELSE LET l_xx = 3
        END IF
    END IF
    CASE tm.a                                                         
       WHEN  '1' LET tm.bdate = l_yy*100+l_mm 
                 LET tm.edate = tm.bdate
       WHEN  '2' LET tm.bdate = l_yy*100+l_wk
                 LET tm.edate = tm.bdate
       WHEN  '3' LET tm.bdate = (l_yy*100+l_mm)*100+l_xx
                 LET tm.edate = tm.bdate
       OTHERWISE LET tm.bdate = ' '
                 LET tm.edate = tm.bdate
    END CASE 
END FUNCTION

FUNCTION r221_out()
DEFINE l_name    LIKE type_file.chr20         # External(Disk) file name     #No.FUN-680108 VARCHAR(20)
#     DEFINEl_time LIKE type_file.chr8        #No.FUN-6A0091
DEFINE l_sql     LIKE type_file.chr1000       # RDSQL STATEMENT    #No.FUN-680108 VARCHAR(500)
DEFINE l_dbs     LIKE type_file.chr20         #No.FUN-680108 VARCHAR(20)
 DEFINE l_za05    LIKE za_file.za05,  #MOD-4B0067
       l_flag    LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
       l_fac     LIKE img_file.img21,
       l_img09   LIKE img_file.img09,
       l_ade04   LIKE ade_file.ade04
DEFINE l_order   ARRAY[5] OF LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(10)
DEFINE sr        RECORD
                    obc   RECORD LIKE obc_file.*,
                    obd   RECORD LIKE obd_file.*,
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021,
                    ima25    LIKE ima_file.ima25,
                    s_obd    LIKE obd_file.obd10,
                    s_ade05  LIKE ade_file.ade05,
                    s_ade15  LIKE ade_file.ade15,
                    s_sum    LIKE obd_file.obd10
                 END RECORD
DEFINE sr1       RECORD
                    obc   RECORD LIKE obc_file.*,
                    obd   RECORD LIKE obd_file.*,
                    obh   RECORD LIKE obh_file.*,
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021,
                    ima25    LIKE ima_file.ima25,
                    s_obd    LIKE obd_file.obd10,
                    s_ade05  LIKE ade_file.ade05,
                    s_ade15  LIKE ade_file.ade15,
                    s_sum    LIKE obd_file.obd10
                 END RECORD  

      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    SELECT zz17,zz05 INTO g_len,g_zz05
      FROM zz_file WHERE zz01 = 'axdr221'
    IF tm.b = 'N' THEN
        LET l_sql = " SELECT obc_file.*,obd_file.*,ima02,ima021,ima25,'','','','' ",
                    "   FROM obc_file,obd_file,OUTER ima_file ",
                    " WHERE obc01 = obd01 ",
                    "   AND obc02 = obd02 ",
                    "   AND obc021= obd021 ",
                    "   AND obc01 = ima_file.ima01 ",
                    "   AND obcacti = 'Y' AND obcconf = 'Y'",
                    "   AND obc021 BETWEEN ",tm.bdate CLIPPED,           
                    "   AND ",tm.edate CLIPPED,
                    "   AND ", tm.wc CLIPPED,
                    " ORDER BY obc021,obc01,obd03"
    ELSE
        LET l_sql = " SELECT obc_file.*,obd_file.*,obh_file.*,ima02,ima021,ima25,",
                    "        0,0,0,0",
                    "   FROM obc_file,obd_file, obh_file,OUTER ima_file ",
                    " WHERE obc01 = obd01 ",
                    "   AND obc02 = obd02 ",
                    "   AND obc021= obd021 ",
                    "   AND obd01 = obh01 ",
                    "   AND obd02 = obh02 ",
                    "   AND obd021= obh021 ",
                    "   AND obd03 = obh03 ",
                    "   AND obc01 = ima_file.ima01 ",
                    "   AND obcacti = 'Y' AND obcconf = 'Y'",
                    "   AND obc021 BETWEEN ",tm.bdate CLIPPED,           
                    "   AND ",tm.edate CLIPPED,
                    "   AND ", tm.wc CLIPPED,
                    " ORDER BY obc021,obc01,obd03,obh04"
    END IF
    PREPARE r221_prepare1 FROM l_sql
    IF SQLCA.sqlcode !=0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        EXIT PROGRAM
    END IF
    DECLARE r221_curs1 CURSOR FOR r221_prepare1
    CALL cl_outnam('axdr221') RETURNING l_name
#     IF tm.b = 'N' THEN LET g_len = 225 ELSE LET g_len = 231 END IF #MOD-4B0067   #TQC-5B0045
     IF tm.b = 'N' THEN LET g_len = 235 ELSE LET g_len = 241 END IF #MOD-4B0067   #TQC-5B0045
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    IF tm.b = 'N' THEN
        START REPORT r221_rep1 TO l_name
        LET g_pageno = 0
        FOREACH r221_curs1 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET sr.s_obd = sr.obd.obd08+sr.obd.obd09+ 
                          sr.obd.obd10+sr.obd.obd11 
           CALL r221_sum(sr.obd.obd01,sr.obd.obd021,sr.obd.obd03,sr.ima25)
                   RETURNING sr.s_ade05,sr.s_ade15
           LET sr.s_sum = sr.s_obd - sr.s_ade15 
           OUTPUT TO REPORT r221_rep1(sr.*)
        END FOREACH
        FINISH REPORT r221_rep1
    ELSE
        START REPORT r221_rep2 TO l_name
        LET g_pageno = 0
        FOREACH r221_curs1 INTO sr1.*
           IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           LET sr1.s_obd = sr1.obd.obd08+sr1.obd.obd09+ 
                       sr1.obd.obd10+sr1.obd.obd11 
           CALL r221_sum(sr1.obd.obd01,sr1.obd.obd021,sr1.obd.obd03,sr1.ima25)
                   RETURNING sr1.s_ade05,sr1.s_ade15
           LET sr1.s_sum = sr1.s_obd - sr1.s_ade15 
           LET sr1.s_sum = sr1.s_obd - sr1.s_ade15 
           OUTPUT TO REPORT r221_rep2(sr1.*)
        END FOREACH
        FINISH REPORT r221_rep2 
    END IF
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END FUNCTION

FUNCTION r221_sum(l_obd01,l_obd021,l_obd03,l_ima25)
DEFINE l_obd01    LIKE obd_file.obd01,
       l_obd021   LIKE obd_file.obd021,
       l_obd03    LIKE obd_file.obd03,
       l_ade04    LIKE ade_file.ade04,
       l_ade05    LIKE ade_file.ade05,
       l_ade15    LIKE ade_file.ade15,
       l_ima25    LIKE ima_file.ima25,
       s_sum05    LIKE ade_file.ade05,
       s_sum15    LIKE ade_file.ade15,
       l_sql      LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(300)
       l_fac      LIKE type_file.num5,          #No.FUN-680108 SMALLINT
       l_flag     LIKE type_file.chr1           #No.FUN-680108 VARCHAR(01)

    LET l_sql = "SELECT ade04,ade05,ade15 FROM ade_file,add_file" ,
                " WHERE ade03 = '",l_obd01,"'", 
                "   AND ade19 = ",l_obd021,   
                "   AND ade20 = ",l_obd03, 
                "   AND add01 = ade01",
                "   AND addacti = 'Y' AND ade13 = 'N'", 
                "   AND add06 ='1' AND add00 = '2'" 
    LET s_sum05 = 0
    LET s_sum15 = 0
    PREPARE r221_pre2 FROM l_sql
    DECLARE r221_curs2 CURSOR FOR r221_pre2
    FOREACH r221_curs2 INTO l_ade04,l_ade05,l_ade15
        IF cl_null(l_ade05) THEN
            LET s_sum05 =0 
            EXIT FOREACH
        END IF
        IF cl_null(l_ade15) THEN 
            LET s_sum15 =0
            EXIT FOREACH
        END IF
     #   SELECT ima25 INTO l_ima25 FROM ima_file
     #    WHERE ima01 = l_obd01
        IF NOT cl_null(l_ade04) THEN
            CALL s_umfchk(l_obd01,l_ade04,l_ima25)
                        RETURNING l_flag,l_fac
            IF l_flag = 1 THEN 
                LET l_fac = 1
            END IF
            LET l_ade05 = l_ade05 * l_fac
            LET l_ade15 = l_ade15 * l_fac
        END IF
        LET s_sum05 = s_sum05 + l_ade05 
        LET s_sum15 = s_sum15 + l_ade05 
    END FOREACH
    RETURN s_sum05,s_sum15
END FUNCTION     


REPORT r221_rep1(sr)
DEFINE l_last_sw    LIKE type_file.chr1,     #No.FUN-680108 VARCHAR(1) 
       l_ade05      LIKE ade_file.ade05,
       l_ade15      LIKE ade_file.ade15
DEFINE sr           RECORD
                    obc   RECORD LIKE obc_file.*,
                    obd   RECORD LIKE obd_file.*,
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021,
                    ima25    LIKE ima_file.ima25,
                    s_obd    LIKE obd_file.obd10,
                    s_ade05  LIKE ade_file.ade05,
                    s_ade15  LIKE ade_file.ade15,
                    s_sum    LIKE obd_file.obd10
                 END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.obc.obc021,sr.obc.obc01,sr.obd.obd03
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#TQC-6A0095--BEGIN
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN 37,g_x[11] CLIPPED;
#      CASE sr.obc.obc02
#            WHEN '1' PRINT COLUMN 47,g_x[21] CLIPPED;
#            WHEN '2' PRINT COLUMN 47,g_x[22] CLIPPED;
#            WHEN '3' PRINT COLUMN 47,g_x[23] CLIPPED;
#      END CASE

 #MOD-4B0067(BEGIN)
#      PRINT sr.obc.obc021 USING '<<<<<<<<<', 
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN 37,g_x[11] CLIPPED;
      CASE sr.obc.obc02
            WHEN '1' PRINT COLUMN 47,g_x[21] CLIPPED;
            WHEN '2' PRINT COLUMN 47,g_x[22] CLIPPED;
            WHEN '3' PRINT COLUMN 47,g_x[23] CLIPPED;
      END CASE
      PRINT sr.obc.obc021 USING '<<<<<<<<<', 
            COLUMN g_len-20,'FROM:',g_user CLIPPED,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      PRINT g_dash[1,g_len]
#TQC-6A0095--END
#TQC-5B0045
#      PRINT COLUMN  07,g_x[12] CLIPPED,
#           COLUMN  65,g_x[24] CLIPPED,
#           COLUMN  84,g_x[13] CLIPPED,
#           COLUMN 109,g_x[14] CLIPPED,
#           COLUMN  154,g_x[15] CLIPPED,
#           COLUMN  198,g_x[19] CLIPPED
      PRINT COLUMN  13,g_x[12] CLIPPED,
            COLUMN  75,g_x[24] CLIPPED,
            COLUMN  94,g_x[13] CLIPPED,
            COLUMN 119,g_x[14] CLIPPED,
            COLUMN  164,g_x[15] CLIPPED,
            COLUMN  208,g_x[19] CLIPPED
#END TQC-5B0045
#      PRINT '-------------------- ------------------------------ ------------------------------ -------- ---- ',   #TQC-5B0045
      PRINT '------------------------------ ------------------------------ ------------------------------ -------- ---- ',   #TQC-5B0045
            '-------- -------------- -------------- -------------- ',
            '-------------- -------------- -------------- ',
            '-------------- --------------'
      LET l_last_sw = 'n'
   
   BEFORE GROUP OF sr.obc.obc021
      SKIP TO TOP OF PAGE

   BEFORE GROUP OF sr.obc.obc01
      PRINT COLUMN 01,sr.obc.obc01 CLIPPED,   #TQC-6A0095
#TQC-5B0045
#           COLUMN 22,sr.ima02,  #MOD-4A0238
#           COLUMN 53,sr.ima021,
#           COLUMN 84,sr.ima25; 
            COLUMN 32,sr.ima02 CLIPPED,  #MOD-4A0238  #TQC-6A0095
            COLUMN 63,sr.ima021 CLIPPED,  #TQC-6A0095
            COLUMN 94,sr.ima25 CLIPPED;    #TQC-6A0095
#END TQC-5B0045
   ON EVERY ROW
#TQC-5B0045
#     PRINT COLUMN 93,sr.obd.obd03 USING '<<<',
#           COLUMN 98,sr.obd.obd04 USING '<<<<<<<<',
#           COLUMN 107,sr.obd.obd08 USING '---------&.&&&',
#           COLUMN 122,sr.obd.obd09 USING '---------&.&&&',
#           COLUMN 137,sr.obd.obd10 USING '---------&.&&&',
#           COLUMN 152,sr.obd.obd11 USING '---------&.&&&';
#  
#  PRINT    COLUMN 167,sr.s_obd USING '---------&.&&&',
#           COLUMN 182,sr.s_ade05 USING "---------&.&&&",
#           COLUMN 197,sr.s_ade15 USING "---------&.&&&",
#           COLUMN 212,sr.s_sum USING "---------&.&&&"

#      PRINT COLUMN 103,sr.obd.obd03 USING '<<<',
      PRINT COLUMN 103,cl_numfor(sr.obd.obd03,4,0),      #TQC-6A0095
            COLUMN 108,sr.obd.obd04 USING '<<<<<<<<',
            COLUMN 117,sr.obd.obd08 USING '---------&.&&&',
            COLUMN 132,sr.obd.obd09 USING '---------&.&&&',
            COLUMN 147,sr.obd.obd10 USING '---------&.&&&',
            COLUMN 162,sr.obd.obd11 USING '---------&.&&&';
   
   PRINT    COLUMN 177,sr.s_obd USING '---------&.&&&',
            COLUMN 192,sr.s_ade05 USING "---------&.&&&",
            COLUMN 207,sr.s_ade15 USING "---------&.&&&",
            COLUMN 222,sr.s_sum USING "---------&.&&&"
#END TQC-5B0045
   AFTER GROUP OF sr.obc.obc01
#      PRINT '                                                             ',   #TQC-5B0045
      PRINT '                                                                       ',   #TQC-5B0045
            '                              -----------------',
            '---------------------------------------------------------------------------------------------------------------------'
#TQC-5B0045
#     PRINT COLUMN 101,g_x[18] CLIPPED,
#           COLUMN 107,GROUP SUM(sr.obd.obd08) USING '---------&.&&&',
#           COLUMN 122,GROUP SUM(sr.obd.obd09) USING '---------&.&&&',
#           COLUMN 137,GROUP SUM(sr.obd.obd10) USING '---------&.&&&',
#           COLUMN 152,GROUP SUM(sr.obd.obd11) USING '---------&.&&&',
#           COLUMN 167,GROUP SUM(sr.s_obd) USING '---------&.&&&', 
#           COLUMN 182,GROUP SUM(sr.s_ade05) USING '---------&.&&&', 
#           COLUMN 197,GROUP SUM(sr.s_ade15) USING '---------&.&&&', 
#           COLUMN 212,GROUP SUM(sr.s_sum) USING "---------&.&&&" 
      PRINT COLUMN 111,g_x[18] CLIPPED,
            COLUMN 117,GROUP SUM(sr.obd.obd08) USING '---------&.&&&',
            COLUMN 132,GROUP SUM(sr.obd.obd09) USING '---------&.&&&',
            COLUMN 147,GROUP SUM(sr.obd.obd10) USING '---------&.&&&',
            COLUMN 162,GROUP SUM(sr.obd.obd11) USING '---------&.&&&',
            COLUMN 177,GROUP SUM(sr.s_obd) USING '---------&.&&&', 
            COLUMN 192,GROUP SUM(sr.s_ade05) USING '---------&.&&&', 
            COLUMN 207,GROUP SUM(sr.s_ade15) USING '---------&.&&&', 
            COLUMN 222,GROUP SUM(sr.s_sum) USING "---------&.&&&" 
#END TQC-5B0045      
      PRINT
 #MOD-4B0067(END)                          
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT

REPORT r221_rep2(sr)
DEFINE l_last_sw    LIKE type_file.chr1      #No.FUN-680108 VARCHAR(1)
DEFINE l_tot        LIKE ima_file.ima26      #No.FUN-680108 DEC(15,3)
DEFINE l_azp02      LIKE azp_file.azp02,
       l_obd08      LIKE obd_file.obd08,
       l_obd09      LIKE obd_file.obd09,
       l_obh05      LIKE obh_file.obh05,
       l_obh06      LIKE obh_file.obh06
DEFINE sr           RECORD
                    obc   RECORD LIKE obc_file.*,
                    obd   RECORD LIKE obd_file.*,
                    obh   RECORD LIKE obh_file.*,
                    ima02    LIKE ima_file.ima02,
                    ima021   LIKE ima_file.ima021,
                    ima25    LIKE ima_file.ima25,
                    s_obd    LIKE obd_file.obd10,
                    s_ade05  LIKE ade_file.ade05,
                    s_ade15  LIKE ade_file.ade15,
                    s_sum    LIKE obd_file.obd10
                    END RECORD

  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.obc.obc021,sr.obc.obc01,sr.obd.obd03,sr.obd.obd04
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
#TQC-6A0095--BEGIN
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN (g_len-24)/2 ,g_x[11] CLIPPED;
      CASE sr.obc.obc02
            WHEN '1' PRINT COLUMN 47,g_x[21] CLIPPED;
            WHEN '2' PRINT COLUMN 47,g_x[22] CLIPPED;
            WHEN '3' PRINT COLUMN 47,g_x[23] CLIPPED;
      END CASE
 #MOD-4B0067(BEGIN)
      PRINT sr.obc.obc021 USING '<<<<<<<<', 
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            COLUMN g_len-20,'FROM:',g_user CLIPPED,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
#TQC-6A0095--END
      PRINT g_dash[1,g_len]
#TQC-5B0045
#     PRINT COLUMN  07,g_x[12] CLIPPED,
#           COLUMN  53,g_x[24] CLIPPED,
#           COLUMN  84,g_x[13] CLIPPED,
#           COLUMN 108,g_x[16] CLIPPED,
#           COLUMN 142,g_x[17] CLIPPED,
#           COLUMN 186,g_x[20] CLIPPED,
#           COLUMN 200,g_x[19] CLIPPED 
      PRINT COLUMN  13,g_x[12] CLIPPED,
            COLUMN  63,g_x[24] CLIPPED,
            COLUMN  94,g_x[13] CLIPPED,
            COLUMN 118,g_x[16] CLIPPED,
#MOD-630001 --start
            COLUMN 156,g_x[17] CLIPPED,
            COLUMN 200,g_x[20] CLIPPED,
            COLUMN 214,g_x[19] CLIPPED 
#MOD-630001 --end 
#END TQC-5B0045
#      PRINT '-------------------- ------------------------------ ',   #TQC-5B0045
      PRINT '------------------------------ ------------------------------ ',   #TQC-5B0045
            '------------------------------ -------- ---- -------- -------------- ----------',  #MOD-630001
            '---------- -------------- -------------- -----',
            '--------- -------------- -------------- --------------'
      LET l_last_sw = 'n'
      LET l_tot = 0

   BEFORE GROUP OF sr.obc.obc021    
      SKIP TO TOP OF PAGE  
 
   BEFORE GROUP OF sr.obc.obc01 
      PRINT COLUMN 01,sr.obc.obc01 CLIPPED,
#TQC-5B0045
#            COLUMN 22,sr.ima02,  #MOD-4A0238
#            COLUMN 53,sr.ima021,
#            COLUMN 84,sr.ima25 CLIPPED;
            COLUMN 32,sr.ima02,  #MOD-4A0238
            COLUMN 63,sr.ima021,
            COLUMN 94,sr.ima25 CLIPPED;
#END TQC-5B0045

   BEFORE GROUP OF sr.obd.obd03 
#TQC-5B0045
#      PRINT COLUMN 93,sr.obd.obd03 USING '<<<<',
#            COLUMN 98,sr.obd.obd04 USING '<<<<<<<<',
#            COLUMN 107,g_plant;
      PRINT COLUMN 103,sr.obd.obd03 USING '<<<<',
            COLUMN 108,sr.obd.obd04 USING '<<<<<<<<',
            COLUMN 117,g_plant;
#END TQC-5B0045
      SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = g_plant
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH',SQLCA.sqlcode,0)
      END IF
#TQC-5B0045
#     PRINT COLUMN 118,l_azp02,      
#           COLUMN 139,sr.obd.obd08 USING "---------&.&&&",
#           COLUMN 154,sr.obd.obd09 USING  "---------&.&&&",
#           COLUMN 169,sr.s_obd USING "---------&.&&&",
#           COLUMN 184,sr.s_ade05 USING "---------&.&&&",
#           COLUMN 199,sr.s_ade15 USING "---------&.&&&",
#           COLUMN 214,sr.s_sum USING "---------&.&&&"
#MOD-630001 --start
      PRINT COLUMN 132,l_azp02,      
            COLUMN 153,sr.obd.obd08 USING "---------&.&&&",
            COLUMN 168,sr.obd.obd09 USING  "---------&.&&&",
            COLUMN 183,sr.s_obd USING "---------&.&&&",
            COLUMN 198,sr.s_ade05 USING "---------&.&&&",
            COLUMN 213,sr.s_ade15 USING "---------&.&&&",
            COLUMN 228,sr.s_sum USING "---------&.&&&"
#MOD-630001 --end  
#END TQC-5B0045
   ON EVERY ROW
#      PRINT COLUMN 107,sr.obh.obh04 CLIPPED;   #TQC-5B0045
      PRINT COLUMN 117,sr.obh.obh04 CLIPPED;   #TQC-5B0045
      SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = sr.obh.obh04
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH',SQLCA.sqlcode,0)
      END IF
#TQC-5B0045
#      PRINT COLUMN 118,l_azp02 CLIPPED,
#            COLUMN 139,sr.obh.obh05 USING "---------&.&&&",
#            COLUMN 154,sr.obh.obh06 USING "---------&.&&&"
#MOD-630001 --start
      PRINT COLUMN 132,l_azp02 CLIPPED,
            COLUMN 153,sr.obh.obh05 USING "---------&.&&&",
            COLUMN 168,sr.obh.obh06 USING "---------&.&&&"
#MOD-630001 --end  
#END TQC-5B0045
            
   AFTER GROUP OF sr.obc.obc01
#      PRINT COLUMN 62,'                              --------------------------------',   #TQC-5B0045
      PRINT COLUMN 62,'                                        --------------------------------',   #TQC-5B0045
#MOD-630001 --start
                       '-----------------------------------------------',
                       '-----------------------------------------------',
#MOD-630001 --end   
                       '--------------'
                                
#      PRINT COLUMN 133,g_x[18] CLIPPED;   #TQC-5B0045
      PRINT COLUMN 147,g_x[18] CLIPPED;    #MOD-630001  #TQC-5B0045
            LET l_obd08 = GROUP SUM (sr.obd.obd08)/2 
            LET l_obd09 = GROUP SUM (sr.obd.obd09)/2 
            LET l_obh05 = GROUP SUM (sr.obh.obh05) 
            LET l_obh06 = GROUP SUM (sr.obh.obh06) 
#TQC-5B0045
#     PRINT COLUMN 139,l_obd08 + l_obh05 USING '---------&.&&&',
#           COLUMN 154,l_obd09 + l_obh06  USING '---------&.&&&',
#           COLUMN 169,GROUP SUM(sr.s_obd)/2 USING '---------&.&&&',
#           COLUMN 184,GROUP SUM(sr.s_ade05)/2 USING '---------&.&&&',    
#           COLUMN 199,GROUP SUM(sr.s_ade15)/2 USING '---------&.&&&', 
#           COLUMN 214,GROUP SUM(sr.s_sum)/2 USING "---------&.&&&"
#MOD-630001 --start
      PRINT COLUMN 153,l_obd08 + l_obh05 USING '---------&.&&&',
            COLUMN 168,l_obd09 + l_obh06  USING '---------&.&&&',
            COLUMN 183,GROUP SUM(sr.s_obd)/2 USING '---------&.&&&',
            COLUMN 198,GROUP SUM(sr.s_ade05)/2 USING '---------&.&&&',    
            COLUMN 213,GROUP SUM(sr.s_ade15)/2 USING '---------&.&&&', 
            COLUMN 228,GROUP SUM(sr.s_sum)/2 USING "---------&.&&&"
#MOD-630001 -end   
#END TQC-5B0045
      PRINT
 #MOD-4B0067(END)
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED,
            COLUMN (g_len-9), g_x[7] CLIPPED

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED,
              COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
