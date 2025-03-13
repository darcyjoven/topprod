# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aoos030.4gl
# Descriptions...: 週期期間產生作業
# Input parameter: 
# Return code....: 
# Date & Author..: 91/12/06 By Nora
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-480270 04/08/11 By Nicola 起始日期欄位並沒有做判斷
# Modify.........: No.MOD-470590 04/10/28 By Nicola 產生出來的季別與期別皆有錯,另外產生2005/01的時候,05/01/01都是自己一週,應併到04/12的最後一週,程式應該要考慮到
# Modify.........: No.MOD-530124 05/03/24 By pengu 調整每年的1月1日為該年度的第一週
# Modify.........: No.MOD-600136 06/01/23 By Kevin YEAR(t_date) 應改為 g_year
# Modify.........: No.MOD-630102 06/01/24 By Claire 每年起始1月1日為該年度的第一週
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.MOD-660079 06/07/03 By Claire 依日期取期別
# Modify.........: No.TQC-620021 06/07/11 By Smapmin g_azm已定義於top.global
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.MOD-710070 07/01/23 By Claire 產生前先確認輸入區間存在會計期間資料否則控卡mfg0027訊息
# Modify.........: No.FUN-830064 08/03/18 By lumx 作業執行成功后沒有任何提示信息，直接關掉了程序,加上提示信息，然后通過交互后關閉程序
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2
# Modify.........: No.MOD-CA0027 12/10/04 By Nina 修正日期區間下多年度,資料產生不全
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          azn01_b LIKE azn_file.azn01,
          azn01_e LIKE azn_file.azn01
          END RECORD,
          #g_azm   RECORD LIKE azm_file.*,      #TQC-620021
          g_buf   LIKE type_file.chr50,         #No.FUN-680102 VARCHAR(45),
          g_year  LIKE type_file.num5,          #No.FUN-680102 SMALLINT,
          g_year_old   LIKE type_file.num5,     #No.FUN-680102 SMALLINT,
          g_year_o  LIKE type_file.num5,        #No.FUN-680102 SMALLINT,
          g_n     LIKE type_file.num5,           #No.FUN-680102 SMALLINT
          l_flag   LIKE type_file.chr1          #FUN-830064
 
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
   CALL s030_tm(0,0)				# 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION s030_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-680102 SMALLINT
            l_cnt         LIKE type_file.num5,  #MOD-710070 add
            l_chr         LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
 
   LET p_row = 6 LET p_col = 14
   OPEN WINDOW s030_w AT p_row,p_col
     WITH FORM "aoo/42f/aoos030"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   IF s_shut(0) THEN
      CLOSE WINDOW s030_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
 
   WHILE TRUE    #FUN-830064
   INPUT BY NAME tm.azn01_b,tm.azn01_e WITHOUT DEFAULTS 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
       #-----No.MOD-480270-----  
      AFTER FIELD azn01_b
         IF NOT cl_null(tm.azn01_e) THEN   
            IF tm.azn01_b > tm.azn01_e THEN
               CALL cl_err(tm.azn01_b,"apj-018",0)
               NEXT FIELD azn01_b
            END IF
         END IF
      #-----END---------------  
       #MOD-710070-begin-add
        IF NOT cl_null(tm.azn01_b) THEN   
           LET l_cnt=0 
           SELECT COUNT(*) INTO l_cnt  FROM azm_file
            WHERE azm01=YEAR(tm.azn01_b)
           IF l_cnt=0 THEN
              CALL cl_err(YEAR(tm.azn01_b),"mfg0027",1)
              NEXT FIELD azn01_b
           END IF
        END IF
       #MOD-710070-end-add
                
      AFTER FIELD azn01_e
         IF NOT cl_null(tm.azn01_e) THEN
            IF tm.azn01_b > tm.azn01_e THEN
               CALL cl_err(tm.azn01_e,"apj-018",0)
               NEXT FIELD azn01_e
            END IF
           #MOD-710070-begin-add
            LET l_cnt=0 
            SELECT COUNT(*) INTO l_cnt  FROM azm_file
             WHERE azm01=YEAR(tm.azn01_e)
            IF l_cnt=0 THEN
               CALL cl_err(YEAR(tm.azn01_e),"mfg0027",1)
               NEXT FIELD azn01_e
            END IF
           #MOD-710070-end-add
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
 
   
   END INPUT
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW s030_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
   ELSE
      IF NOT cl_sure(0,0) THEN
         CLOSE WINDOW s030_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      CALL cl_wait()
#FUN-830064--start---
      LET g_success = 'Y'
      BEGIN WORK
      CALL s030()
      IF g_success = 'Y' THEN                                                                                                   
         COMMIT WORK                                                                                                            
         CALL cl_end2(1) RETURNING l_flag                                                                                       
      ELSE                                                                                                                      
         ROLLBACK WORK                                                                                                          
         CALL cl_end2(2) RETURNING l_flag                                                                                       
      END IF                                                                                                                    
                                                                                                                                
      IF l_flag THEN                                                                                                            
         CONTINUE WHILE
      ELSE                                                                                                                      
         EXIT WHILE                                                                                                             
      END IF                                                                                                                    
#FUN-830064---end---
   END IF
   END WHILE  #FUN-830064
 
#  ERROR ""              #FUN-830064
#  CLOSE WINDOW s030_w   #FUN-830064
END FUNCTION
 
#      本作業產生每日對應的 [會計期間明細檔] 資料.
 
FUNCTION s030()
    DEFINE  t_date        LIKE type_file.dat,      #No.FUN-680102 DATE,
            l_weekdayb    LIKE type_file.num10 	,  #No.FUN-680102 INTEGER,
            l_weekdaye    LIKE type_file.num10,    #No.FUN-680102 INTEGER,
            l_azn01       LIKE type_file.dat,      #No.FUN-680102 DATE,
            l_azn05       LIKE type_file.num5,     #No.FUN-680102 SMALLINT,
             l_azn        RECORD LIKE azn_file.*,  #No.MOD-470590
             l_date       LIKE type_file.dat,      #No.FUN-680102 DATE,      #No.MOD-470590
             l_a   LIKE type_file.num5,            #No.FUN-680102 SMALLINT   #No.MOD-470590
            l_w    LIKE type_file.num5,            #No.FUN-680102 SMALLINT 
            l_c    LIKE type_file.num5,            #No.FUN-680102 SMALLINT
            l_p    LIKE type_file.num10,           #No.FUN-680102 INTEGER 
            l_q    LIKE type_file.num10,           #No.FUN-680102 INTEGER 
            l_n    LIKE type_file.num10            #No.FUN-680102 INTEGER
     DEFINE l_str    LIKE type_file.num5           #No.FUN-680102 SMALLINT
 
          
{
     ###將起始日改為該週第一天(星期日),截止日改為該週最後一天(星期六)
     LET l_weekdayb = WEEKDAY(tm.azn01_b)
     LET l_weekdaye = WEEKDAY(tm.azn01_e)
     IF l_weekdayb != 0
         THEN LET tm.azn01_b = tm.azn01_b - l_weekdayb
     END IF
     IF l_weekdaye != 6
         THEN LET tm.azn01_e = tm.azn01_e + ( 6 - l_weekdaye)
     END IF
     ###############
}
 
   LET l_a = 0   #No.MOD-470590
   LET l_p = 0
   LET l_q = 0
   LET l_w = 1  #NO.MOD-530124 
   LET l_c = 1  #NO.MOD-530124
   LET t_date = tm.azn01_b
   LET g_year=YEAR(tm.azn01_b)
   LET g_year_old = g_year       #保留舊年
   LET g_year_o = NULL 
   WHILE t_date <= tm.azn01_e
     #MOD-660079-end
     #LET g_year = YEAR(t_date)
      SELECT aza02 INTO g_aza.aza02 FROM aza_file
       WHERE aza01 ='0'
      IF g_aza.aza02 = '1' THEN
        SELECT azm01 INTO g_year FROM azm_file
         WHERE azm011 <=t_date AND azm122 >= t_date
      ELSE
        SELECT azm01 INTO g_year FROM azm_file
         WHERE azm011 <=t_date AND azm132 >= t_date
      END IF
      #MOD-CA0027 -- add start --
      IF g_year <> g_year_old THEN
         LET g_year_o = NULL
      END IF
      #MOD-CA0027 -- add end --
      MESSAGE t_date
     #MOD-660079-end
      SELECT * INTO g_azm.* FROM azm_file  
       WHERE azm01 = g_year #No.MOD-600136 YEAR(t_date)
      IF SQLCA.sqlcode THEN
#          CALL cl_err(t_date,'aoo-0640',1) #No.+045 010403 by plum   #No.FUN-660131
#        CALL cl_err(t_date,'agl-101',1)   #No.FUN-660131
         CALL cl_err3("sel","azm_file",t_date,"","agl-101","","",1)    #No.FUN-660131
#        CLOSE WINDOW s030_w   #FUN-830064
         LET g_success = 'N'   #FUN-830064
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      IF t_date >= g_azm.azm011 AND t_date <= g_azm.azm012 THEN
         LET l_p = 1 
         LET l_q = g_azm.azm013
      END IF
      IF t_date >= g_azm.azm021 AND t_date <= g_azm.azm022 THEN 
         LET l_p = 2
         LET l_q = g_azm.azm023
      END IF
      IF t_date >= g_azm.azm031 AND t_date <= g_azm.azm032 THEN
         LET l_p = 3
         LET l_q = g_azm.azm033
      END IF
      IF t_date >= g_azm.azm041 AND t_date <= g_azm.azm042 THEN
         LET l_p = 4
         LET l_q = g_azm.azm043
      END IF
      IF t_date >= g_azm.azm051 AND t_date <= g_azm.azm052 THEN
         LET l_p = 5
         LET l_q = g_azm.azm053
      END IF
      IF t_date >= g_azm.azm061 AND t_date <= g_azm.azm062 THEN
         LET l_p = 6
         LET l_q = g_azm.azm063
      END IF
      IF t_date >= g_azm.azm071 AND t_date <= g_azm.azm072 THEN
         LET l_p = 7
         LET l_q = g_azm.azm073
      END IF
      IF t_date >= g_azm.azm081 AND t_date <= g_azm.azm082 THEN
         LET l_p = 8
         LET l_q = g_azm.azm083
      END IF
      IF t_date >= g_azm.azm091 AND t_date <= g_azm.azm092 THEN
         LET l_p = 9
         LET l_q = g_azm.azm093
      END IF
      IF t_date >= g_azm.azm101 AND t_date <= g_azm.azm102 THEN
         LET l_p = 10 
         LET l_q = g_azm.azm103 
      END IF
      IF t_date >= g_azm.azm111 AND t_date <= g_azm.azm112 THEN 
         LET l_p = 11
         LET l_q = g_azm.azm113
      END IF
      IF t_date >= g_azm.azm121 AND t_date <= g_azm.azm122 THEN
         LET l_p = 12 
         LET l_q = g_azm.azm123
      END IF
      IF t_date >= g_azm.azm131 AND t_date <= g_azm.azm132 THEN 
         LET l_p = 13 
         LET l_q = g_azm.azm133 
      END IF
    
     #-----------------------NO.MOD-530124--------------------------------------
      ##-----No.MOD-470590-----
     #IF l_a=0 THEN
     #   IF WEEKDAY(t_date) > 0 THEN
     #      LET l_date = tm.azn01_b -1
     #      SELECT * INTO l_azn.* FROM azn_file  
     #       WHERE azn01 = l_date      
     #      INSERT INTO azn_file(azn01,azn02,azn03,azn04,azn05)
     #           VALUES (t_date,l_azn.azn02,l_azn.azn03,l_azn.azn4,l_azn.azn05)
     #      IF SQLCA.sqlcode THEN
     #         UPDATE azn_file SET azn02 = l_azn.azn02,
     #                             azn03 = l_azn.azn03,
     #                             azn04 = l_azn.azn04,
     #                             azn05 = l_azn.azn05
     #          WHERE azn01 = t_date
     #      END IF
     #   ELSE 
     #      LET l_a =1
     #   #  IF l_w=0 THEN 
     #   #     LET l_w=1 
     #   #  END IF
     #   END IF
     #END IF
      ##-----No.MOD-470590 END-----
   #-----------------------------No.MOD-530124 END--------------------------------
 
     #---------No.MOD-530124----------------------------------
       #IF l_a=1 AND (g_year_o IS NULL ) AND (g_year = g_year_old) THEN   #No.MOD-470590 
      IF (g_year_o IS NULL ) AND (g_year = g_year_old) THEN   
     #---------No.MOD-530124 END------------------------------ 
       IF l_a !=0  THEN  #MOD-630102
         IF WEEKDAY(t_date) = 0   THEN    
            LET l_w = l_w + 1 
         END IF
       END IF           #MOD-630102
         LET l_a =1     #MOD-630102
          INSERT INTO azn_file(azn01,azn02,azn03,azn04,azn05)  #No.MOD-470041
              VALUES (t_date,g_azm.azm01,l_q,l_p,l_w)
         IF SQLCA.sqlcode THEN
            UPDATE azn_file SET azn02 = g_azm.azm01,
                                azn03 = l_q,
                                azn04 = l_p,
                                azn05 = l_w
             WHERE azn01 = t_date
         END IF 
         LET g_year_old = g_year
      END IF 
 
    
     #---------No.MOD-530124----------------------------------
       #IF l_a=1 AND (g_year_o IS  NULL) AND  (g_year != g_year_old) THEN #不同一年   #No.MOD-470590 
       IF (g_year_o IS  NULL) AND  (g_year != g_year_old) THEN #不同一年    
     #--------No.MOD-530124 END---------------------------------
 
       #MOD-630102-begin-mark
       # IF WEEKDAY(t_date) = 0 THEN 
       #    LET l_c =0    
       # END IF 
       #  INSERT INTO azn_file(azn01,azn02,azn03,azn04,azn05)  #No.MOD-470041
       #      VALUES (t_date,g_azm.azm01,l_q,l_p,l_c)
       # IF SQLCA.sqlcode THEN
       #    UPDATE azn_file SET azn02 = g_azm.azm01,
       #                        azn03 = l_q,
       #                        azn04 = l_p,
       #                        azn05 = l_c
       #     WHERE azn01 = t_date
       # END IF
         LET l_a =0     
       #MOD-630102-end-mark
         LET g_year_o = g_year
         LET g_year_old = g_year 
      END IF  
   #=================================================================
       #將每年第一個遇到得星期日，視為該年度的第一週
 
    # IF l_a=1 AND (g_year_o IS  NULL) AND  (g_year != g_year_old) THEN #不同一年   #No.MOD-470590 
   #   IF WEEKDAY(t_date) > 0 THEN 
   #      LET l_date=t_date-1
   #      SELECT * INTO l_azn.* FROM azn_file
   #          WHERE azn01 = l_date
   #      INSERT INTO azn_file(azn01,azn02,azn03,azn04,azn05)
   #           VALUES (t_date,l_azn.azn02,l_azn.azn03,l_azn.azn04,l_azn.azn05)
   #      IF SQLCA.sqlcode THEN
   #         UPDATE azn_file SET azn02 = l_azn.azn02,
   #                             azn03 = l_azn.azn03,
   #                             azn04 = l_azn.azn04,
   #                             azn05 = l_azn.azn05
   #          WHERE azn01 = t_date
   #      END IF
   #   ELSE 
   #       LET g_year_o = g_year
   #       LET g_year_old = g_year
   #   END IF
   #   LET l_date=NULL
   #  END IF  
   #===========================================================================
 
    #--第二年-------------No.MOD-530124-------------------------------------
      #IF l_a=1 AND (g_year_o IS NOT NULL) AND (g_year = g_year_old) THEN    #No.MOD-470590 
      IF (g_year_o IS NOT NULL) AND (g_year = g_year_old) THEN     
    #---------------------No.MOD-530124 END------------------------------------
       IF l_a !=0  THEN  #MOD-630102
         IF WEEKDAY(t_date) = 0 THEN
            LET l_c = l_c + 1
         END IF 
       END IF           #MOD-630102
         LET l_a =1     #MOD-630102
          INSERT INTO azn_file(azn01,azn02,azn03,azn04,azn05)  #No.MOD-470041
              VALUES (t_date,g_azm.azm01,l_q,l_p,l_c)
         IF SQLCA.sqlcode THEN
            UPDATE azn_file SET azn02 = g_azm.azm01,
                                azn03 = l_q,
                                azn04 = l_p,
                                azn05 = l_c
             WHERE azn01 = t_date
         END IF
         LET g_year_o = g_year
      END IF  
      LET t_date = t_date + 1 
   END WHILE 
END FUNCTION    
