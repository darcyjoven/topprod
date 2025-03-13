# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: aoos031.4gl
# Descriptions...: 帳套週期期間產生作業
# Input parameter: 
# Return code....: 
# Date & Author..: 06/07/13 By cl
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-790009 07/09/04 By Carrier 1.去掉"不使用多帳套"時,run aoos030的內容
#                                                    2.若插入的帳套是aza81,則自動將aznn_file內容插入azn_file
#                                                    3.追單MOD-710070產生前先確認輸入區間存在會計期間資料否則控卡mfg0027訊息
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-A60072 10/06/10 By liuxqa 调整sql语法。
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2) 
# Modify.........: No.MOD-CA0027 12/10/17 By Nina 修正日期區間下多年度,資料產生不全

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          aznn00   LIKE aznn_file.aznn00,
          aznn01_b LIKE aznn_file.aznn01,
          aznn01_e LIKE aznn_file.aznn01
          END RECORD,
          g_azmm      RECORD LIKE azmm_file.*,
          g_buf       LIKE type_file.chr50,          #No.FUN-680102 VARCHAR(45),
          g_year      LIKE type_file.num5,           #No.FUN-680102 SMALLINT,
          g_year1     LIKE type_file.num5,           #No.MOD-A60072,
          g_year2     LIKE type_file.num5,           #No.MOD-A60072,
          g_year_old  LIKE type_file.num5,           #No.FUN-680102 SMALLINT,
          g_year_o    LIKE type_file.num5,           #No.FUN-680102 SMALLINT,
          g_n         LIKE type_file.num5,           #No.FUN-680102 SMALLINT,
          l_aza63     LIKE aza_file.aza63
 
MAIN
 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
  #No.FUN-790009  --Begin  --mark
  ##No.FUN-670040--begin-- --move here
  #  SELECT aza63 INTO l_aza63 from aza_file
  #  IF l_aza63 ='N' THEN
  #     CALL cl_cmdrun('aoos030')
  #     EXIT PROGRAM    
  #  END IF
  ##No.FUN-670040--end-- --move here
  #No.FUN-790009  --End
 
   CALL s031_tm(0,0)				#
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211 
END MAIN
 
FUNCTION s031_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-680102 SMALLINT
            l_chr         LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
            l_cnt         LIKE type_file.num5,          #MOD-710070 add
            l_aaaacti     LIKE  aaa_file.aaaacti,
            l_success     LIKE type_file.chr1          #No.FUN-680102CHAR(01)
 
 
   LET p_row = 6 LET p_col = 14
   OPEN WINDOW s031_w AT p_row,p_col
     WITH FORM "aoo/42f/aoos031"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   IF s_shut(0) THEN
      CLOSE WINDOW s031_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
 
WHILE TRUE
 
   INPUT BY NAME tm.aznn00,tm.aznn01_b,tm.aznn01_e WITHOUT DEFAULTS 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          
      AFTER FIELD aznn00
         IF NOT cl_null(tm.aznn00) THEN
            SELECT aaaacti INTO l_aaaacti FROM aaa_file
             WHERE aaa01=tm.aznn00
            IF SQLCA.SQLCODE=100 THEN
               CALL cl_err3("sel","aaa_file",tm.aznn00,"",100,"","",1)
               NEXT FIELD aznn00
            END IF
            IF l_aaaacti='N' THEN
               CALL cl_err(tm.aznn00,"9028",1)
               NEXT FIELD aznn00
            END IF
         END IF
 
       #-----No.MOD-480270-----  
      AFTER FIELD aznn01_b
         IF NOT cl_null(tm.aznn01_e) THEN
            IF tm.aznn01_b > tm.aznn01_e THEN
               CALL cl_err(tm.aznn01_b,"apj-018",0)
               NEXT FIELD aznn01_b
            END IF
         END IF
      #-----END---------------  
       #MOD-710070-begin-add                                                    
        IF NOT cl_null(tm.aznn01_b) THEN                                         
           LET l_cnt=0   
           LET g_year1 = YEAR(tm.aznn01_b)     #MOD-A60072 add                                                  
           SELECT COUNT(*) INTO l_cnt  FROM azmm_file                            
            #WHERE azmm01=YEAR(tm.aznn01_b)    #MOD-A60072 mark                                    
            WHERE azmm01=g_year1     #MOD-A60072 mod                                   
              AND azmm00=tm.aznn00
           IF l_cnt=0 THEN                                                      
              #CALL cl_err3('sel','azmm_file',tm.aznn00,YEAR(tm.aznn01_b),"mfg0027","","",1)
              CALL cl_err3('sel','azmm_file',tm.aznn00,g_year1,"mfg0027","","",1)   #MOD-A60072 mod
              NEXT FIELD aznn01_b                                                
           END IF                                                               
        END IF                                                                  
       #MOD-710070-end-add 
                
      AFTER FIELD aznn01_e
         IF NOT cl_null(tm.aznn01_e) THEN
            IF tm.aznn01_b > tm.aznn01_e THEN
               CALL cl_err(tm.aznn01_e,"apj-018",0)
               NEXT FIELD aznn01_e
            END IF
         END IF
         #MOD-710070-begin-add                                                
          LET l_cnt=0                                                         
          LET g_year2 = YEAR(tm.aznn01_e)     #MOD-A60072 aad                                                  
          SELECT COUNT(*) INTO l_cnt  FROM azmm_file                           
           #WHERE azmm01=YEAR(tm.aznn01_e)    #MOD-A60072 mark                                   
           WHERE azmm01=g_year2               #MOD-A60072 mod                                       
             AND azmm00=tm.aznn00
          IF l_cnt=0 THEN                                                     
             #CALL cl_err3('sel','azmm_file',tm.aznn00,YEAR(tm.aznn01_e),"mfg0027","","",1)
             CALL cl_err3('sel','azmm_file',tm.aznn00,g_year2,"mfg0027","","",1)   #MOD-A60072 mod
             NEXT FIELD aznn01_e                                               
          END IF                                                              
         #MOD-710070-end-add
                
      ON ACTION controlp
         CASE
           WHEN INFIELD(aznn00)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_aaa"
             CALL cl_create_qry() RETURNING tm.aznn00
             DISPLAY tm.aznn00 TO aznn00
           OTHERWISE EXIT CASE
         END CASE
      
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
      ON ACTION create_period 
         CALL cl_cmdrun("aoos030")
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW s031_w 
      EXIT WHILE
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   ELSE
      IF NOT cl_sure(0,0) THEN
         CONTINUE  WHILE
      END IF
      CALL cl_wait()
      CALL s031() RETURNING l_success
      IF l_success='1' THEN
         INITIALIZE tm.* TO NULL
         DISPLAY BY NAME tm.aznn00,tm.aznn01_b,tm.aznn01_e
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
 
   END IF
 
   ERROR ""
END WHILE
   CLOSE WINDOW s031_w
 
END FUNCTION
 
#      本作業產生每日對應的 [會計期間明細檔] 資料.
 
FUNCTION s031()
    DEFINE  t_date       LIKE type_file.dat,            #No.FUN-680102 DATE, 
            l_weekdayb   LIKE type_file.num10,          #No.FUN-680102 INTEGER,
            l_weekdaye   LIKE type_file.num10,          #No.FUN-680102 INTEGER,
            l_aznn01     LIKE type_file.dat,            #No.FUN-680102 DATE, 
            l_aznn05     LIKE type_file.num5,           #No.FUN-680102 SMALLINT,
            l_aznn       RECORD LIKE aznn_file.*,    #No.MOD-470590
            l_date       LIKE type_file.dat,            #No.FUN-680102 DATE,                  #No.MOD-470590
            l_a          LIKE type_file.num5,           #No.FUN-680102 SMALLINT,                  #No.MOD-470590
            l_w          LIKE type_file.num5,           #No.FUN-680102 SMALLINT,
            l_c          LIKE type_file.num5,           #No.FUN-680102 SMALLINT,
            l_p          LIKE type_file.num10,          #No.FUN-680102 INTEGER,
            l_q          LIKE type_file.num10,          #No.FUN-680102 INTEGER,
            l_n          LIKE type_file.num10,          #No.FUN-680102 INTEGER
            l_success    LIKE type_file.chr1            #No.FUN-680102 VARCHAR(1)
     DEFINE l_str        LIKE type_file.num5            #No.FUN-680102 SMALLINT
 
   LET l_success=NULL
   LET l_a = 0   #No.MOD-470590
   LET l_p = 0
   LET l_q = 0
   LET l_w = 1  #NO.MOD-530124 
   LET l_c = 1  #NO.MOD-530124
   LET t_date = tm.aznn01_b
   LET g_year=YEAR(tm.aznn01_b)
   LET g_year_old = g_year       #保留舊年
   LET g_year_o = NULL 
   WHILE t_date <= tm.aznn01_e
      SELECT aza02 INTO g_aza.aza02 FROM aza_file
       WHERE aza01 ='0'
      IF g_aza.aza02 = '1' THEN
        SELECT azmm01 INTO g_year FROM azmm_file
         WHERE azmm011 <=t_date AND azmm122 >= t_date
           AND azmm00 = tm.aznn00
      ELSE
        SELECT azmm01 INTO g_year FROM azmm_file
         WHERE azmm011 <=t_date AND azmm132 >= t_date
           AND azmm00 = tm.aznn00
      END IF
      #MOD-CA0027 -- add start --
      IF g_year <> g_year_old THEN
         LET g_year_o = NULL
      END IF
      #MOD-CA0027 -- add end --
      MESSAGE t_date
      SELECT * INTO g_azmm.* FROM azmm_file  
       WHERE azmm01 = g_year #No.MOD-600136 YEAR(t_date)
         AND azmm00 = tm.aznn00
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","azmm_file",t_date,"","agl-101","","",1)   
         CALL cl_end2(2) RETURNING l_success 
         RETURN  l_success
      END IF
      IF t_date >= g_azmm.azmm011 AND t_date <= g_azmm.azmm012 THEN
         LET l_p = 1 
         LET l_q = g_azmm.azmm013
      END IF
      IF t_date >= g_azmm.azmm021 AND t_date <= g_azmm.azmm022 THEN 
         LET l_p = 2
         LET l_q = g_azmm.azmm023
      END IF
      IF t_date >= g_azmm.azmm031 AND t_date <= g_azmm.azmm032 THEN
         LET l_p = 3
         LET l_q = g_azmm.azmm033
      END IF
      IF t_date >= g_azmm.azmm041 AND t_date <= g_azmm.azmm042 THEN
         LET l_p = 4
         LET l_q = g_azmm.azmm043
      END IF
      IF t_date >= g_azmm.azmm051 AND t_date <= g_azmm.azmm052 THEN
         LET l_p = 5
         LET l_q = g_azmm.azmm053
      END IF
      IF t_date >= g_azmm.azmm061 AND t_date <= g_azmm.azmm062 THEN
         LET l_p = 6
         LET l_q = g_azmm.azmm063
      END IF
      IF t_date >= g_azmm.azmm071 AND t_date <= g_azmm.azmm072 THEN
         LET l_p = 7
         LET l_q = g_azmm.azmm073
      END IF
      IF t_date >= g_azmm.azmm081 AND t_date <= g_azmm.azmm082 THEN
         LET l_p = 8
         LET l_q = g_azmm.azmm083
      END IF
      IF t_date >= g_azmm.azmm091 AND t_date <= g_azmm.azmm092 THEN
         LET l_p = 9
         LET l_q = g_azmm.azmm093
      END IF
      IF t_date >= g_azmm.azmm101 AND t_date <= g_azmm.azmm102 THEN
         LET l_p = 10 
         LET l_q = g_azmm.azmm103 
      END IF
      IF t_date >= g_azmm.azmm111 AND t_date <= g_azmm.azmm112 THEN 
         LET l_p = 11
         LET l_q = g_azmm.azmm113
      END IF
      IF t_date >= g_azmm.azmm121 AND t_date <= g_azmm.azmm122 THEN
         LET l_p = 12 
         LET l_q = g_azmm.azmm123
      END IF
      IF t_date >= g_azmm.azmm131 AND t_date <= g_azmm.azmm132 THEN 
         LET l_p = 13 
         LET l_q = g_azmm.azmm133 
      END IF
    
      IF (g_year_o IS NULL ) AND (g_year = g_year_old) THEN   
       IF l_a !=0  THEN  #MOD-630102
         IF WEEKDAY(t_date) = 0   THEN    
            LET l_w = l_w + 1 
         END IF
       END IF           #MOD-630102
         LET l_a =1     #MOD-630102
          INSERT INTO aznn_file(aznn00,aznn01,aznn02,aznn03,aznn04,aznn05)  #No.MOD-470041
              VALUES (tm.aznn00,t_date,g_azmm.azmm01,l_q,l_p,l_w)
         IF SQLCA.sqlcode THEN
            UPDATE aznn_file SET aznn02 = g_azmm.azmm01,
                                aznn03 = l_q,
                                aznn04 = l_p,
                                aznn05 = l_w
             WHERE aznn00=tm.aznn00 AND aznn01 = t_date
         END IF 
         #No.FUN-790009  --Begin
         IF tm.aznn00 = g_aza.aza81 THEN
            INSERT INTO azn_file(azn01,azn02,azn03,azn04,azn05)  #No.MOD-470041
            VALUES (t_date,g_azmm.azmm01,l_q,l_p,l_w)
            IF SQLCA.sqlcode THEN
               UPDATE azn_file SET azn02 = g_azmm.azmm01,
                                   azn03 = l_q,
                                   azn04 = l_p,
                                   azn05 = l_w
                WHERE azn01 = t_date
            END IF 
         END IF
         #No.FUN-790009  --End  
         LET g_year_old = g_year
      END IF 
 
       IF (g_year_o IS  NULL) AND  (g_year != g_year_old) THEN #不同一年    
         LET l_a =0     
         LET g_year_o = g_year
         LET g_year_old = g_year 
      END IF  
 
      IF (g_year_o IS NOT NULL) AND (g_year = g_year_old) THEN     
       IF l_a !=0  THEN  #MOD-630102
         IF WEEKDAY(t_date) = 0 THEN
            LET l_c = l_c + 1
         END IF 
       END IF           
         LET l_a =1     
          INSERT INTO aznn_file(aznn00,aznn01,aznn02,aznn03,aznn04,aznn05)  #No.MOD-470041
              VALUES (tm.aznn00,t_date,g_azmm.azmm01,l_q,l_p,l_c)
         IF SQLCA.sqlcode THEN
            UPDATE aznn_file SET aznn02 = g_azmm.azmm01,
                                aznn03 = l_q,
                                aznn04 = l_p,
                                aznn05 = l_c
             WHERE aznn00=tm.aznn00 AND aznn01 = t_date
         END IF
         #No.FUN-790009  --Begin
         IF tm.aznn00 = g_aza.aza81 THEN
            INSERT INTO azn_file(azn01,azn02,azn03,azn04,azn05)  #No.MOD-470041
            VALUES (t_date,g_azmm.azmm01,l_q,l_p,l_c)
            IF SQLCA.sqlcode THEN
               UPDATE azn_file SET azn02 = g_azmm.azmm01,
                                   azn03 = l_q,
                                   azn04 = l_p,
                                   azn05 = l_c
                WHERE azn01 = t_date
            END IF
         END IF
         #No.FUN-790009  --End  
         LET g_year_o = g_year
      END IF  
      LET t_date = t_date + 1 
   END WHILE 
   CALL cl_end2(1) RETURNING l_success
   RETURN l_success
END FUNCTION    
