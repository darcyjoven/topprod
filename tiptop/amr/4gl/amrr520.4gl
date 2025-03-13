# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: amrr520.4gl
# Descriptions...: MRP 採購/工單建議表(依料號)
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-510046 05/01/25 By pengu 報表轉XML
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: No.TQC-5C0059 05/12/12 By kevin 欄位沒對齊
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-830153 08/07/01 By baofei 報表打印改為CR輸出
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.FUN-B80023 11/08/03 By fengrui  程式撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition  #NO.FUN-680082 VARCHAR(600)                    
              n       LIKE type_file.chr1,          #NO.FUN-680082 VARCHAR(1)
              p       LIKE type_file.chr1,          #NO.FUN-680082 VARCHAR(1)
              ver_no  LIKE mss_file.mss_v,          #NO.FUN-680082 VARCHAR(2)
              s       LIKE type_file.chr3,          #NO.FUN-680082 VARCHAR(3)
              t       LIKE type_file.chr3,          #NO.FUN-680082 VARCHAR(3)
              more    LIKE type_file.chr1           # Input more condition(Y/N)  #NO.FUN-680082 VARCHAR(1)             
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10       #NO.FUN-680082 INTEGER
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose  #NO.FUN-680082 SMALLINT
#No.FUN-830153---Begin                                                                                                              
DEFINE l_table        STRING,                                                                                                       
       l_table1       STRING,                                                                                                       
       g_str          STRING,                                                                                                       
       g_sql          STRING                                                                                                        
#No.FUN-830153---End  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
#No.FUN-830153---Begin                                                                                                              
   LET g_sql = "mss00.mss_file.mss00,",                                                                                             
               "mss01.mss_file.mss01,",                                                                                             
               "mss02.mss_file.mss02,",                                                                                             
               "mss03.mss_file.mss03,",                                                                                             
               "mss09.mss_file.mss09,",                                                                                             
               "mss10.mss_file.mss10,",                                                                                             
               "mss11.mss_file.mss11,",                                                                                             
               "ima02.ima_file.ima02,",                                                                                             
               "ima08.ima_file.ima08,",                                                                                             
               "ima25.ima_file.ima25,",                                                                                             
               "ima43.ima_file.ima43,",                                                                                             
               "ima67.ima_file.ima67,",                                                                                             
               "pmc03.pmc_file.pmc03,",                                                                                             
               "l_cnt.type_file.num5"                                                                                               
   LET l_table = cl_prt_temptable('amrr510',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF            
   LET g_sql = "pmh01.pmh_file.pmh01,",                                                                                             
               "pmh02.pmh_file.pmh02,",                                                                                             
               "pmh12.pmh_file.pmh12,",                                                                                             
               "pmh13.pmh_file.pmh13,",                                                                                             
               "pmc03.pmc_file.pmc03,",                                                                                             
               "azi04.azi_file.azi04"                                                                                               
   LET l_table1 = cl_prt_temptable('amrr5101',g_sql) CLIPPED                                                                        
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                                                                                        
#No.FUN-830153---End    
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610074-begin
   LET tm.n = ARG_VAL(8)
   LET tm.p = ARG_VAL(9)
   LET tm.ver_no = ARG_VAL(10)
   LET tm.s = ARG_VAL(11)
   LET tm.t = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610074-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrr520_tm(0,0)        # Input print condition
      ELSE CALL amrr520()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr520_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000   #NO.FUN-680082 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 14
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amrr520_w AT p_row,p_col
        WITH FORM "amr/42f/amrr520" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.n    = '1'
   LET tm.p    = 'N'
   LET tm.more = 'N'
   LET tm.s    = '123'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
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
   CONSTRUCT BY NAME tm.wc ON mss01,ima67,mss02,mss11,ima08,ima43,mss03 
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp                                                                                                 
         IF INFIELD(mss01) THEN                                                                                                  
            CALL cl_init_qry_var()                                                                                               
            LET g_qryparam.form = "q_ima"                                                                                       
            LET g_qryparam.state = "c"                                                                                           
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
            DISPLAY g_qryparam.multiret TO mss01                                                                                 
            NEXT FIELD mss01                                                                                                     
         END IF                                                            
#No.FUN-570240 --end  
 
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr520_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no, tm.n,tm.p,
                   tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS
  
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD p
         IF tm.p NOT MATCHES '[YN]' THEN
            NEXT FIELD p
         END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr520_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr520'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr520','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #TQC-610074-begin
                         " '",tm.n CLIPPED,"'",
                         " '",tm.p CLIPPED,"'",
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         #TQC-610074-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amrr520',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrr520_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr520()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr520_w
END FUNCTION
 
FUNCTION amrr520()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name       #NO.FUN-680082 VARCHAR(20)      
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT                #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40)
          l_order ARRAY[3] OF LIKE mss_file.mss01,    #FUN-5B0105 20->40   #NO.FUN-680082 VARCHAR(40)
          sr    RECORD
                l_order1 LIKE mss_file.mss01, #FUN-5B0105 20->40      #NO.FUN-680082 VARCHAR(40)
                l_order2 LIKE mss_file.mss01, #FUN-5B0105 20->40      #NO.FUN-680082 VARCHAR(40)
                l_order3 LIKE mss_file.mss01  #FUN-5B0105 20->40      #NO.FUN-680082 VARCHAR(40)
          END RECORD,
          mss	RECORD LIKE mss_file.*,
          ima	RECORD LIKE ima_file.*
   DEFINE l_pmc03      LIKE pmc_file.pmc03     #No.FUN-830153                                                                       
   DEFINE l_cnt        LIKE type_file.num5     #No.FUN-830153                                                                       
   DEFINE l_pmh02     LIKE pmh_file.pmh02      #No.FUN-830153                                                                       
   DEFINE l_pmc031    LIKE pmc_file.pmc03      #No.FUN-830153                                                                       
   DEFINE l_pmh13     LIKE pmh_file.pmh13      #No.FUN-830153                                                                       
   DEFINE l_pmh12     LIKE pmh_file.pmh12      #No.FUN-830153                                                                       
                                                                                                                                    
#No.FUN-830153---Begin                                                                                                              
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "                                                                            
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        #No.FUN-B80023--add--
      EXIT PROGRAM
   END IF                                                                                                                           
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
               " VALUES(?,?,?,?,?, ?) "                                                                                             
   PREPARE insert_prep1 FROM g_sql                                                                                                  
   IF STATUS THEN  
      CALL cl_err('insert_prep1:',status,1)                                                                            
      CALL cl_used(g_prog,g_time,2) RETURNING g_time        #No.FUN-B80023--add--
      EXIT PROGRAM
   END IF                                                                                                                           
     CALL cl_del_data(l_table)                                                                                                      
     CALL cl_del_data(l_table1)                                                                                                     
#No.FUN-830153---End          
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = " SELECT *",
                 " FROM mss_file, ima_file",
                 " WHERE mss01=ima01 AND mss09>0 ",
                 " AND mss_v='",tm.ver_no,"' ",
                 " AND ",tm.wc CLIPPED
 
     PREPARE amrr520_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrr520_curs1 CURSOR FOR amrr520_prepare1
 
#     CALL cl_outnam('amrr520') RETURNING l_name    #No.FUN-830153 
#     START REPORT amrr520_rep TO l_name            #No.FUN-830153 
     LET g_pageno = 0
     FOREACH amrr520_curs1 INTO mss.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF tm.n='1' AND mss.mss10='Y' THEN CONTINUE FOREACH END IF
       IF tm.n='2' AND mss.mss10='N' THEN CONTINUE FOREACH END IF
#No.FUN-830153---Begin 
#       FOR g_cnt = 1 TO 3
#         CASE
#           WHEN tm.s[g_cnt,g_cnt]='1' LET l_order[g_cnt]=mss.mss01
#           WHEN tm.s[g_cnt,g_cnt]='2' LET l_order[g_cnt]=ima.ima08
#           WHEN tm.s[g_cnt,g_cnt]='3' LET l_order[g_cnt]=ima.ima67
#           WHEN tm.s[g_cnt,g_cnt]='4' LET l_order[g_cnt]=ima.ima43
#           WHEN tm.s[g_cnt,g_cnt]='5' LET l_order[g_cnt]=mss.mss02
#           WHEN tm.s[g_cnt,g_cnt]='6' LET l_order[g_cnt]=mss.mss03
#                                                         USING 'yyyymmdd'
#           WHEN tm.s[g_cnt,g_cnt]='7' LET l_order[g_cnt]=mss.mss11
#                                                         USING 'yyyymmdd'
#           OTHERWISE LET l_order[g_cnt]='-'
#         END CASE
#       END FOR
#       LET sr.l_order1=l_order[1]
#       LET sr.l_order2=l_order[2]
#       LET sr.l_order3=l_order[3]
      LET l_pmc03 = ''                                                                                                              
      SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=mss.mss02                                                                 
      IF tm.p='Y' THEN                                                                                                              
         SELECT COUNT(*) INTO l_cnt FROM pmh_file,pmc_file                                                                          
          WHERE pmh02=pmc01 AND pmhacti='Y' AND pmh01= mss.mss01 AND pmh05<>2         
            AND pmh21 = " "                                                            #CHI-860042                                  
            AND pmh22 = '1'                                                            #CHI-860042
            AND pmh23 = ' '                                                            #CHI-960033
            AND pmhacti = 'Y'                                                          #CHI-910021                                              
         IF l_cnt > 0 THEN                                                                                                          
           DECLARE r520_p CURSOR FOR                                                                                                
           SELECT pmh02,pmc03,pmh13,pmh12 FROM pmh_file,pmc_file                                                                    
            WHERE pmh02=pmc01 AND pmhacti='Y' AND pmh01= mss.mss01                                                                  
              AND pmh05<>2                                      
              AND pmh21 = " "                                                          #CHI-860042                                  
              AND pmh22 = '1'                                                          #CHI-860042
              AND pmh23 = ' '                                                            #CHI-960033
              AND pmhacti = 'Y'                                                        #CHI-910021                                                                    
           FOREACH r520_p INTO l_pmh02,l_pmc031,l_pmh13,l_pmh12                                                                     
              IF STATUS THEN                                                                                                        
                 EXIT FOREACH                                                                                                       
              END IF                                                                                                                
           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_pmh13                                                              
           EXECUTE insert_prep1 USING mss.mss01,l_pmh02,l_pmh12,l_pmh13,l_pmc031,t_azi04                                            
           END FOREACH                                                                                                              
         END IF                                                                                                                     
      END IF                                                                                                                        
      EXECUTE insert_prep USING mss.mss00,mss.mss01,mss.mss02,mss.mss03,mss.mss09,                                                  
                                mss.mss10,mss.mss11,ima.ima02,ima.ima08,ima.ima25,                                                  
                                ima.ima43,ima.ima67,l_pmc03,l_cnt   
#       OUTPUT TO REPORT amrr520_rep(sr.*,mss.*, ima.*)
#No.FUN-830153---End  
     END FOREACH
#No.FUN-830153---Begin 
#     FINISH REPORT amrr520_rep
   LET g_str=tm.s[1,1],";", tm.s[2,2],";",                                                                                          
             tm.s[3,3],";",tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",tm.p,";",                                                      
             tm.ver_no,";",tm.n                                                                                                     
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED, "|",                                                         
               "SELECT * FROM ", g_cr_db_str CLIPPED, l_table1 CLIPPED                                                              
   CALL cl_prt_cs3('amrr520','amrr520',l_sql,g_str) 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-830153---End
END FUNCTION
#No.FUN-830153---Begin  
#REPORT amrr520_rep(sr,mss, ima)
#  DEFINE l_last_sw    LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
#  DEFINE l_pmc03      LIKE pmc_file.pmc03      #NO.FUN-680082 VARCHAR(10)
#  DEFINE l_cnt        LIKE type_file.num5      #NO.FUN-680082 SMALLINT
#  DEFINE mss		RECORD LIKE mss_file.*
#  DEFINE ima		RECORD LIKE ima_file.*
#  DEFINE l_pmh02     LIKE pmh_file.pmh02
#  DEFINE l_pmc031    LIKE pmc_file.pmc03
#  DEFINE l_pmh13     LIKE pmh_file.pmh13
#  DEFINE l_pmh12     LIKE pmh_file.pmh12
#  DEFINE sr RECORD
#            l_order1 LIKE mss_file.mss01, #FUN-5B0105 20->40   #NO.FUN-680082    
#            l_order2 LIKE mss_file.mss01, #FUN-5B0105 20->40   #NO.FUN-680082
#            l_order3 LIKE mss_file.mss01  #FUN-5B0105 20->40   #NO.FUN-680082
#         END RECORD 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.l_order1,sr.l_order2,sr.l_order3,mss.mss01,mss.mss02,mss.mss03
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
 
#     PRINT g_dash[1,g_len] CLIPPED
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#           g_x[39] CLIPPED,g_x[40] CLIPPED
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#  
#  BEFORE GROUP OF sr.l_order1
#     IF tm.t[1,1]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#        SKIP TO TOP OF PAGE
#     END IF
#       
#  BEFORE GROUP OF sr.l_order2
#     IF tm.t[2,2]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.l_order3
#     IF tm.t[3,3]='Y' AND (PAGENO > 1 OR LINENO > 9) THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF mss.mss01
#     PRINT COLUMN g_c[31],mss.mss01 CLIPPED,   #FUN-5B0014 [1,20],
#            COLUMN g_c[32],ima.ima02 CLIPPED, #MOD-4A0238
#           COLUMN g_c[33],ima.ima25
#  BEFORE GROUP OF mss.mss02
#     LET l_pmc03 = ''
#     SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01=mss.mss02
#     PRINT COLUMN  g_c[34],mss.mss02[1,6],
#           COLUMN  g_c[35],l_pmc03[1,10];
 
#  ON EVERY ROW
#     PRINT COLUMN g_c[36],mss.mss00 USING '###&',#No.TQC-5C0059 #FUN-590118
#           COLUMN g_c[37],mss.mss03,
#           COLUMN g_c[38],cl_numfor(mss.mss09,38,2), 
#           COLUMN g_c[39],mss.mss10,
#           COLUMN g_c[40],mss.mss11
 
#  AFTER GROUP OF mss.mss01
#     IF tm.p='Y' THEN
#        SELECT COUNT(*) INTO l_cnt FROM pmh_file,pmc_file
#         WHERE pmh02=pmc01 AND pmhacti='Y' AND pmh01= mss.mss01 AND pmh05<>2
#        IF l_cnt > 0 THEN
#          PRINT COLUMN g_c[35],g_x[15] CLIPPED,
#                COLUMN g_c[36],g_x[16] CLIPPED,
#                COLUMN g_c[37],g_x[17] CLIPPED,
#                COLUMN g_c[38],g_x[18] CLIPPED
#          PRINT COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]]
#          DECLARE r520_p CURSOR FOR
#          SELECT pmh02,pmc03,pmh13,pmh12 FROM pmh_file,pmc_file
#           WHERE pmh02=pmc01 AND pmhacti='Y' AND pmh01= mss.mss01
#             AND pmh05<>2
#          FOREACH r520_p INTO l_pmh02,l_pmc031,l_pmh13,l_pmh12
#             IF STATUS THEN
#                EXIT FOREACH
#             END IF
#          SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_pmh13
#             PRINT COLUMN g_c[35],l_pmh02,
#                   COLUMN g_c[36],l_pmc031,
#                   COLUMN g_c[37],l_pmh13,
#                   COLUMN g_c[38],cl_numfor(l_pmh12,38,t_azi04) 
#          END FOREACH
#        END IF
#     END IF
 
#     SKIP 1 LINE
#     PRINT g_dash2[1,g_len] CLIPPED
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     PRINT g_dash[1,g_len] CLIPPED 
#     PRINT g_x[4],COLUMN (g_len-9),g_x[7]
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash2[1,g_len] CLIPPED 
#        PRINT g_x[4],COLUMN (g_len-9),g_x[6] CLIPPED
#     ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-830153---End  
