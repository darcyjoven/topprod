# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmp300.4gl
# Descriptions...: 客戶庫存各期異動統計重計作業
# Date & Author..: 06/03/21 BY yiting 
# Modify.........: No.TQC-660050 06/06/12 By Sarah 期初庫存計算有誤,抓上一期期末數量段程式改寫
# Modify.........: No.FUN-660104 06/06/19 By cl    Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-710033 07/01/18 By dxfwo  錯誤訊息匯總顯示修改
# Modify.........: No.FUN-790001 07/09/03 By jamie PK問題
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   #g_cpf          RECORD LIKE cpf_file.*,   #TQC-B90211
         tm             RECORD
                        wc         LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(300)
                        yy         LIKE type_file.num5,             #No.FUN-680120 SMALLINT     
                        mm         LIKE type_file.num5              #No.FUN-680120 SMALLINT
                        END RECORD, 
         g_wc           LIKE type_file.chr1000,                     #No.FUN-680120 VARCHAR(300)
         g_bdate        LIKE type_file.dat,                         #No.FUN-680120 DATE                               
         g_edate        LIKE type_file.dat,                         #No.FUN-680120 DATE  
         g_sql          LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(600)
         g_flag         LIKE type_file.chr1              #No.FUN-680120 VARCHAR(1)
DEFINE   g_argv1        LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
         g_argv2        LIKE azm_file.azm01,             # Prog. Version..: '5.30.06-13.03.12(04)            #TQC-840066
         g_argv3        LIKE ccp_file.ccp02,             #No.FUN-680120 VARCHAR(02) 
         g_argv4        LIKE type_file.chr1000,          #No.FUN-680120 VARCHAR(400)
         g_tur09        LIKE tur_file.tur09
DEFINE   l_flag         LIKE type_file.chr1,             #No.FUN-570154        #No.FUN-680120 VARCHAR(1)
         g_change_lang  LIKE type_file.chr1,             # Prog. Version..: '5.30.06-13.03.12(01)               #是否有做語言切換 No.FUN-570154
         ls_date        STRING                  #->No.FUN-570154
 
MAIN
#     DEFINE  l_time   LIKE type_file.chr8             #No.FUN-6B0014
 
  OPTIONS
      INPUT NO WRAP
  DEFER INTERRUPT
 
  INITIALIZE g_bgjob_msgfile TO NULL
  LET g_argv1 = ARG_VAL(1)         #參數-1 1->atmp300,2->atmp310
  LET g_argv2 = ARG_VAL(2)         #參數-2 年度指標
  LET g_argv3 = ARG_VAL(3)         #參數-3 月份
  LET g_argv4 = ARG_VAL(4)         #參數-4 條件
  LET tm.wc   = ARG_VAL(4)
  LET tm.yy   = ARG_VAL(5)                      
  LET tm.mm   = ARG_VAL(6)                      
  LET g_bgjob = ARG_VAL(7)                
  IF cl_null(g_bgjob) THEN
     LET g_bgjob = "N"
  END IF
 
  CASE g_argv1
     WHEN "1" LET g_prog = 'atmp300'
     WHEN "2" LET g_prog = 'atmp310'
     OTHERWISE 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
     EXIT PROGRAM
        
  END CASE
 
  IF (NOT cl_user()) THEN
     EXIT PROGRAM
  END IF
  
  WHENEVER ERROR CALL cl_err_msg_log
  
  IF (NOT cl_setup("ATM")) THEN
     EXIT PROGRAM
  END IF
  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
  WHILE TRUE
     LET g_success = 'Y'
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' AND cl_null(g_argv2) THEN
        CALL p300_tm()
        IF cl_sure(21,21) THEN
           BEGIN WORK
           CALL p300_p()
           CALL s_showmsg()        #No.FUN-710033 
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
              CLOSE WINDOW p300_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        BEGIN WORK
        CALL p300_p()
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
  END WHILE
  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION p300_tm()
  DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
  DEFINE lc_cmd         LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(500)             #FUN-570154
 
  LET p_row = 5 LET p_col = 12 
 
  OPEN WINDOW p300_w AT p_row,p_col
       WITH FORM "atm/42f/atmp300"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
  CALL cl_ui_init()
  CALL cl_opmsg('p')
  LET tm.yy = YEAR(g_today)
  LET tm.mm = MONTH(g_today)
 
  WHILE TRUE 
     CONSTRUCT BY NAME tm.wc ON tuq01,tuq02,tuq03 
        #No.FUN-580031 --start--
        BEFORE CONSTRUCT
            CALL cl_qbe_init()
        #No.FUN-580031 ---end---
 
        ON ACTION locale                                                           
           LET g_change_lang = TRUE       
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
     IF g_change_lang THEN      
        LET g_change_lang = FALSE
        LET g_action_choice = ""                                                  
        CALL cl_dynamic_locale()                                                  
        CALL cl_show_fld_cont()
        CONTINUE WHILE                                                            
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG=0
        CLOSE WINDOW p300_w     
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM           
     END IF
     IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
     DISPLAY BY NAME tm.yy,tm.mm
     LET g_bgjob = 'N'
     INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS      #FUN-570154
        AFTER FIELD mm    
           IF cl_null(tm.mm) OR tm.mm < 1 OR tm.mm > 13 THEN 
              NEXT FIELD mm 
           END IF
                 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds                                                  
           CALL cl_on_idle()                                                    
           CONTINUE INPUT                                                       
     
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
     
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
     
        #No.FUN-580031 --start--
        ON ACTION qbe_save
           CALL cl_qbe_save()
        #No.FUN-580031 ---end---
 
        ON ACTION locale     
           LET g_change_lang = TRUE
           EXIT INPUT
                                                                                
        ON ACTION exit                                                        
           LET INT_FLAG = 1                                                      
           EXIT INPUT
     END INPUT
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0 
        CLOSE WINDOW p300_w              #FUN-570154
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM                     #FUN-570154
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'atmp300'
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('atmp300','9031',1)
        ELSE
           LET tm.wc = cl_replace_str(tm.wc,"'","\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " ''",
                        " ''",
                        " ''",
                        " '",tm.wc CLIPPED, "'",
                        " '",tm.yy CLIPPED, "'",
                        " '",tm.mm CLIPPED, "'",
                        " '",g_bgjob CLIPPED, "'"
           CALL cl_cmdat('atmp300',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p300_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
        EXIT PROGRAM
     END IF
     EXIT WHILE
  END WHILE
END FUNCTION
 
FUNCTION p300_p()
  DEFINE  l_i      LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
  LET g_wc=tm.wc
  FOR l_i = 1 TO 296
      IF g_wc[l_i,l_i+4] = 'tuq01' THEN LET g_wc[l_i,l_i+4]='tur01' END IF
      IF g_wc[l_i,l_i+4] = 'tuq02' THEN LET g_wc[l_i,l_i+4]='tur02' END IF
      IF g_wc[l_i,l_i+4] = 'tuq03' THEN LET g_wc[l_i,l_i+4]='tur03' END IF
  END FOR
  CALL p300_p1()
END FUNCTION
 
FUNCTION p300_p1()
  DEFINE l_tuq01   LIKE tuq_file.tuq01,
         l_tuq02   LIKE tuq_file.tuq02,
         l_tuq03   LIKE tuq_file.tuq03,
         l_tuq11   LIKE tuq_file.tuq11,       #TQC-660050 add
         l_tuq12   LIKE tuq_file.tuq12,       #TQC-660050 add
         last_yy   LIKE type_file.num5,       #No.FUN-680120 SMALLINT   #上一期年度    #TQC-660050 add
         last_mm   LIKE type_file.num5        #No.FUN-680120 SMALLINT    #上一期月份    #TQC-660050 add
 
  CALL s_azm(tm.yy,tm.mm) RETURNING g_flag,g_bdate,g_edate
  IF g_flag = '1' THEN 
     CALL cl_err('s_azm:error','agl-038',1) 
     LET g_success = 'N'
     RETURN
  END IF
 
 #start TQC-660050 modify
  IF tm.mm = 1 THEN
     LET last_yy = tm.yy - 1
     LET last_mm = 12
  ELSE
     LET last_yy = tm.yy
     LET last_mm = tm.mm - 1
  END IF
 
  LET g_sql = "SELECT tuq01,tuq02,tuq03,tuq11,tuq12",
              "  FROM tuq_file ",
              " WHERE tuq04 BETWEEN '",g_bdate,"' AND '",g_today,"'",
              "   AND ",tm.wc CLIPPED 
  CASE g_argv1
     WHEN "1" LET g_sql = g_sql , "  AND tuq11 = '1'"
     WHEN "2" LET g_sql = g_sql , "  AND tuq11 = '2'"
  END CASE
  LET g_sql = g_sql , " ORDER BY tuq01,tuq02,tuq03,tuq11,tuq12"
  PREPARE p300_pre1 FROM g_sql
  IF STATUS THEN CALL cl_err('p300_pre1',STATUS,0) RETURN END IF 
  DECLARE p300_c1 CURSOR FOR p300_pre1
  IF STATUS THEN CALL cl_err('p300_c1',STATUS,0) RETURN END IF 
  CALL s_showmsg_init()   #NO. FUN-710033
  FOREACH p300_c1 INTO l_tuq01,l_tuq02,l_tuq03,l_tuq11,l_tuq12
     IF STATUS THEN 
#       CALL cl_err('for_p300_c1',STATUS,0)         #NO. FUN-710033
        CALL s_errmsg('','','for_p300_c1',STATUS,0 )#NO. FUN-710033  
    LET g_success='N' EXIT FOREACH 
     END IF 
     #NO. FUN-710033--BEGIN          
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF
     #NO. FUN-710033--END
     LET g_tur09=0   #抓上一期的期末數量
     SELECT tur09 INTO g_tur09 FROM tur_file 
      WHERE tur01=l_tuq01 AND tur02=l_tuq02 AND tur03=l_tuq03
        AND tur04=last_yy AND tur05=last_mm
        AND tur11=l_tuq11 AND tur12=l_tuq12
     IF cl_null(g_tur09) THEN LET g_tur09 = 0 END IF
 
     IF g_bgjob = "N" THEN     #FUN-570154
        MESSAGE l_tuq01 CLIPPED,' ',l_tuq02 CLIPPED,' ',
                l_tuq03 CLIPPED,' ',tm.yy USING "<<<<",' ',tm.mm USING "<<",
                l_tuq11 CLIPPED,' ',l_tuq12 CLIPPED
     END IF
     CALL p300_tur(tm.yy,tm.mm,l_tuq01,l_tuq02,l_tuq03,l_tuq11,l_tuq12)
  END FOREACH
     #NO. FUN-710033--BEGIN
        IF g_totsuccess="N" THEN
           LET g_success="N"
        END IF
     #NO. FUN-710033--END 
 #end TQC-660050 modify
END FUNCTION
 
FUNCTION p300_tur(p_yy,p_mm,p_tuq01,p_tuq02,p_tuq03,p_tuq11,p_tuq12)
  DEFINE p_yy,p_mm LIKE type_file.num5,   #No.FUN-680120  SMALLINT
         p_tuq01   LIKE tuq_file.tuq01,
         p_tuq02   LIKE tuq_file.tuq02,
         p_tuq03   LIKE tuq_file.tuq03,
         p_tuq11   LIKE tuq_file.tuq11,   #TQC-660050 add
         p_tuq12   LIKE tuq_file.tuq12,   #TQC-660050 add
         l_tuq091  LIKE tuq_file.tuq09,
         l_tuq092  LIKE tuq_file.tuq09,
         l_tuq093  LIKE tuq_file.tuq09
 
  CALL s_azm(p_yy,p_mm) RETURNING g_flag,g_bdate,g_edate
  IF g_flag = '1' THEN 
#    CALL cl_err('s_azm:error','agl-038',1)          #NO. FUN-710033
     CALL s_errmsg('','','s_azm:error','agl-038',1)  #NO. FUN-710033
     LET g_success = 'N' 
     RETURN
  END IF
 
  LET g_sql = "DELETE FROM tur_file",
              " WHERE ",g_wc CLIPPED,
              "   AND tur01 = '",p_tuq01,"' AND tur02 = '",p_tuq02,"'",
              "   AND tur03 = '",p_tuq03,"'",
              "   AND tur04 = ",p_yy," AND tur05 = ",p_mm
             ,"   AND tur11 = '",p_tuq11,"' AND tur12 = '",p_tuq12,"'"   #TQC-660050 add
  PREPARE p100_p FROM g_sql 
  EXECUTE p100_p
  
  SELECT SUM(tuq09) INTO l_tuq091 FROM tuq_file   #本期銷售
   WHERE tuq01 = p_tuq01 AND tuq02 = p_tuq02
     AND tuq03 = p_tuq03 AND tuq04 BETWEEN g_bdate AND g_edate
     AND tuq10 = '1'
     AND tuq11 = p_tuq11 AND tuq12 = p_tuq12   #TQC-660050 add
  SELECT SUM(tuq09) INTO l_tuq092 FROM tuq_file   #本期銷退
   WHERE tuq01 = p_tuq01 AND tuq02 = p_tuq02
     AND tuq03 = p_tuq03 AND tuq04 BETWEEN g_bdate AND g_edate
     AND tuq10 = '2'
     AND tuq11 = p_tuq11 AND tuq12 = p_tuq12   #TQC-660050 add
  SELECT SUM(tuq09) INTO l_tuq093 FROM tuq_file   #客戶銷售
   WHERE tuq01 = p_tuq01 AND tuq02 = p_tuq02
     AND tuq03 = p_tuq03 AND tuq04 BETWEEN g_bdate AND g_edate
     AND tuq10 = '3'
     AND tuq11 = p_tuq11 AND tuq12 = p_tuq12   #TQC-660050 add
  IF cl_null(l_tuq091) THEN LET l_tuq091 = 0 END IF
  IF cl_null(l_tuq092) THEN LET l_tuq092 = 0 END IF
  IF cl_null(l_tuq093) THEN LET l_tuq093 = 0 END IF
  IF cl_null(p_tuq11)  THEN LET p_tuq11=' '  END IF   #FUN-790001 add
  LET g_tur09 = g_tur09 + l_tuq091 + l_tuq092 + l_tuq093
  INSERT INTO tur_file (tur01,tur02,tur03,tur04,tur05,
                        tur06,tur07,tur08,tur09,tur11,tur12,
                        turplant,turlegal) #FUN-980009
                VALUES (p_tuq01,p_tuq02,p_tuq03,p_yy,p_mm,
                        l_tuq091,l_tuq092,l_tuq093,g_tur09,p_tuq11,p_tuq12,
                        g_plant,g_legal) #FUN-980009
  IF SQLCA.sqlcode THEN
  #  CALL cl_err('ins tur',SQLCA.sqlcode,0)  #No.FUN-660104
#    CALL cl_err3("ins","tur_file",p_tuq01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660104  #NO. FUN-710033
     CALL s_errmsg('','','',SQLCA.sqlcode,0)        #NO. FUN-710033           
     LET g_success = 'N' 
     RETURN
  END IF
END FUNCTION
