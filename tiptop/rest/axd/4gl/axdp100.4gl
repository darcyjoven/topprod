# Prog. Version..: '5.10.00-08.01.04(00004)'     #
# Pattern name...: axdp100.4gl
# Descriptions...: 廠商庫存各期異動統計重計作業
# Date & Author..: 03/12/05 By Carrier
# Modify.........: 04/07/19 By Wiky Bugno:MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No:FUN-570154 06/03/15 By yiting 批次作業背景執行功能
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     

# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_cpf          RECORD LIKE cpf_file.*,
         tm             RECORD
                        wc         LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(300)
                        yy         LIKE type_file.num5,   #No.FUN-680108 SMALLINT          
                        mm         LIKE type_file.num5    #No.FUN-680108 SMALLINT
                        END RECORD, 
         g_wc           LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(300)
         g_bdate        LIKE type_file.dat,     #No.FUN-680108 DATE   
         g_edate        LIKE type_file.dat,     #No.FUN-680108 DATE 
         g_sql          LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(600)
         g_flag         LIKE type_file.chr1     #No.FUN-680108 VARCHAR(01)
DEFINE   g_argv1        LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(04)            
         g_argv2        LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(02)
         g_argv3        LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(400)
         g_adr09        LIKE adr_file.adr09
DEFINE   l_flag         LIKE type_file.chr1,    #No:FUN-570154          #No.FUN-680108 VARCHAR(1)
         g_change_lang  LIKE type_file.chr1,    #是否有做語言切換 No:FUN-570154  #No.FUN-680108 VARCHAR(01) 
         ls_date        STRING                  #->No:FUN-570154
MAIN
#     DEFINEl_time   LIKE type_file.chr8             #No.FUN-6A0091

    OPTIONS
        FORM LINE     FIRST + 2,
        MESSAGE LINE  LAST,
        PROMPT LINE   LAST,
        INPUT NO WRAP

   DEFER INTERRUPT

#->No:FUN-570154 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1 = ARG_VAL(1)         #參數-1 年度指標
   LET g_argv2 = ARG_VAL(2)         #參數-2 月份
   LET g_argv3 = ARG_VAL(3)         #參數-3 條件
   LET tm.wc   = ARG_VAL(4)
   LET tm.yy   = ARG_VAL(5)                      
   LET tm.mm   = ARG_VAL(6)                      
   LET g_bgjob = ARG_VAL(7)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No:FUN-570154 ---end---

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091

#NO.FUN-570154 mark--      
#   LET g_argv1 = ARG_VAL(1)         #參數-1 年度指標
#   LET g_argv2 = ARG_VAL(2)         #參數-2 月份
#   LET g_argv3 = ARG_VAL(3)         #參數-2 條件
 
#   IF cl_null(g_argv1) THEN
#      CALL p100_tm()
#   ELSE
#      LET tm.yy    =g_argv1
#      LET tm.mm    =g_argv1
#      LET tm.wc    =g_argv2
#      CALL p100_p()
#NO.FUN-570154 mark--

#NO.FUN-570154 start-
   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' AND cl_null(g_argv1) THEN
         CALL p100_tm()
         IF cl_sure(21,21) THEN
            BEGIN WORK
            CALL p100_p()
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
               CLOSE WINDOW p100_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         CALL p100_p()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No:FUN-570154 ---end---
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END MAIN

FUNCTION p100_tm()
   DEFINE p_row,p_col    LIKE type_file.num5      #No.FUN-680108 SMALLINT
   DEFINE lc_cmd         LIKE type_file.chr1000   #FUN-570154    #No.FUN-680108 VARCHAR(500)

   LET p_row = 5 LET p_col = 12 

   OPEN WINDOW p100_w AT p_row,p_col
        WITH FORM "axd/42f/axdp100"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
  WHILE TRUE 
   CONSTRUCT BY NAME tm.wc ON adq01,adq02,adq03 
         #No:FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No:FUN-580031 ---end---

     ON ACTION locale                                                           
#NO.FUN-570154 start--
#        LET g_action_choice = "locale"                                          
#          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         LET g_change_lang = TRUE          #FUN-570154
#NO.FUN-570154 end--
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
         #No:FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No:FUN-580031 ---end---

  END CONSTRUCT 
#NO.FUN-570154 start--
   IF g_change_lang THEN      
      LET g_change_lang = FALSE
      LET g_action_choice = ""                                                  
      CALL cl_dynamic_locale()                                                  
      CONTINUE WHILE                                                            
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p100_w     
      EXIT PROGRAM           
   END IF

#   IF g_action_choice = "locale" THEN      
#      LET g_action_choice = ""                                                  
#      CALL cl_dynamic_locale()                                                  
#      CONTINUE WHILE                                                            
#   END IF
#   IF INT_FLAG THEN
#      LET INT_FLAG=0 CLOSE WINDOW p100_w RETURN 
#   END IF
#NO.FUN-570154 end---

   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   DISPLAY BY NAME tm.yy,tm.mm

   LET g_bgjob = 'N'  #NO.FUN-570154 
   INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS      #FUN-570154
   #INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS 

         AFTER FIELD mm    
            IF cl_null(tm.mm) OR tm.mm < 1 OR tm.mm > 13 THEN 
               NEXT FIELD mm 
            END IF
               
        ON ACTION CONTROLZ
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
 
         #No:FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 ---end---

#NO.FUN-570154 start--
     ON ACTION locale     
        LET g_change_lang = TRUE
        EXIT INPUT
                                                                                
    ON ACTION exit                                                        
       LET INT_FLAG = 1                                                      
       EXIT INPUT
#NO.FUN-570154 end--

   END INPUT
#NO.FUN-570154 start--
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p100_w              #FUN-570154
      EXIT PROGRAM                     #FUN-570154
   END IF

     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axdp100'
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('axdp100','9031',1)
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
           CALL cl_cmdat('axdp100',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p100_w
        EXIT PROGRAM
     END IF
     EXIT WHILE
END WHILE
#FUN-570154 --end--

#NO.FUN-570154 mark--
#   IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
#   IF cl_sure(18,20) THEN 
#      CALL p100_p() 
#   END IF
# CLOSE WINDOW p100_w
#NO.FUN-570154 mark--
END FUNCTION
 
FUNCTION p100_p()
 DEFINE  l_i      LIKE type_file.num5          #No.FUN-680108 SMALLINT

  LET g_wc=tm.wc
  FOR l_i = 1 TO 296
      IF g_wc[l_i,l_i+4] = 'adq01' THEN LET g_wc[l_i,l_i+4]='adr01' END IF
      IF g_wc[l_i,l_i+4] = 'adq02' THEN LET g_wc[l_i,l_i+4]='adr02' END IF
      IF g_wc[l_i,l_i+4] = 'adq03' THEN LET g_wc[l_i,l_i+4]='adr03' END IF
  END FOR
#  BEGIN WORK             #NO.FUN-570154 MARK
#  LET g_success = 'Y'    #NO.FUN-570154 MARK
  CALL p100_p1()
#NO.FUN-570154 mark--
#  IF g_success='Y' THEN
#     CALL cl_cmmsg(1) COMMIT WORK
#  ELSE
#     CALL cl_rbmsg(1) ROLLBACK WORK
#  END IF
#NO.FUN-570154 mark-
END FUNCTION

FUNCTION p100_p1()
 DEFINE  l_cnt    LIKE type_file.num5,          #No.FUN-680108 SMALLINT
         l_i,l_n  LIKE type_file.num5,          #No.FUN-680108 SMALLINT
         l_y,l_m  LIKE type_file.num5,          #No.FUN-680108 SMALLINT
         l_adq01  LIKE adq_file.adq01,
         l_adq02  LIKE adq_file.adq02,
         l_adq03  LIKE adq_file.adq03 

  CALL s_azm(tm.yy,tm.mm) RETURNING g_flag,g_bdate,g_edate
  IF g_flag = '1' THEN 
      CALL cl_err('s_azm:error','agl-038',1) 
     LET g_success = 'N'
     RETURN
  END IF
  LET g_sql = "SELECT adq01,adq02,adq03",
              "  FROM adq_file ",
              " WHERE adq04 BETWEEN '",g_bdate,"' AND '",g_today,"'",
              "   AND ",tm.wc CLIPPED,
              " GROUP BY adq01,adq02,adq03"
  PREPARE p100_s2_pre1 FROM g_sql
  IF STATUS THEN CALL cl_err('pre_s2',STATUS,0) RETURN END IF 
  DECLARE p100_s2_c CURSOR FOR p100_s2_pre1
  IF STATUS THEN CALL cl_err('dec_s2',STATUS,0) RETURN END IF 

  FOREACH p100_s2_c INTO l_adq01,l_adq02,l_adq03
    IF STATUS THEN 
       CALL cl_err('for_s2',STATUS,0) LET g_success='N' EXIT FOREACH 
    END IF 
    LET g_adr09=0
    SELECT adr09 INTO g_adr09 FROM adr_file 
     WHERE adr01=l_adq01 AND adr02=l_adq02 AND adr03=l_adq03
       AND adr04*12+adr05=tm.yy*12+tm.mm-1
    IF cl_null(g_adr09) THEN LET g_adr09 = 0 END IF
    IF tm.yy < YEAR(g_today) OR 
       tm.yy = YEAR(g_today) AND tm.mm < MONTH(g_today) THEN 
       LET l_n = YEAR(g_today)*12+MONTH(g_today)-tm.yy*12-tm.mm
       LET l_y = tm.yy
       LET l_m = tm.mm-1
       FOR l_i = 0 TO l_n
           LET l_m = l_m + 1
           IF l_m = 13 THEN
              LET l_m = 1
              LET l_y = l_y + 1
           END IF
           IF g_bgjob = "N" THEN     #FUN-570154
               MESSAGE l_adq01 CLIPPED,' ',l_adq02 CLIPPED,' ',
                       l_adq03 CLIPPED,' ',l_y USING "<<<<",' ',l_m USING "<<"
           END IF
           CALL p100_adr(l_y,l_m,l_adq01,l_adq02,l_adq03)
       END FOR
    ELSE
       IF g_bgjob = "N" THEN     #FUN-570154
           MESSAGE l_adq01 CLIPPED,' ',l_adq02 CLIPPED,' ',
                   l_adq03 CLIPPED,' ',tm.yy USING "<<<<",' ',tm.mm USING "<<"
       END IF
       CALL p100_adr(tm.yy,tm.mm,l_adq01,l_adq02,l_adq03)
    END IF
  END FOREACH
END FUNCTION

FUNCTION p100_adr(p_yy,p_mm,p_adq01,p_adq02,p_adq03)
DEFINE   p_yy,p_mm LIKE type_file.num5,   #No.FUN-680108 SMALLINT
         p_adq01   LIKE adq_file.adq01,
         p_adq02   LIKE adq_file.adq02,
         p_adq03   LIKE adq_file.adq03,
         l_adq091  LIKE adq_file.adq09,
         l_adq092  LIKE adq_file.adq09,
         l_adq093  LIKE adq_file.adq09 

    CALL s_azm(p_yy,p_mm) RETURNING g_flag,g_bdate,g_edate
    IF g_flag = '1' THEN 
       CALL cl_err('s_azm:error','agl-038',1) 
       LET g_success = 'N' 
       RETURN
    END IF
    LET g_sql = "DELETE FROM adr_file WHERE ",g_wc CLIPPED,
                "   AND adr01 = '",p_adq01,"' AND adr02 = '",p_adq02,"'",
                "   AND adr03 = '",p_adq03,"'",
                "   AND adr04 = ",p_yy," AND adr05 = ",p_mm
    PREPARE p100_p FROM g_sql 
    EXECUTE p100_p
  
    SELECT SUM(adq09) INTO l_adq091 FROM adq_file   #本期銷售
     WHERE adq01 = p_adq01 AND adq02 = p_adq02
       AND adq03 = p_adq03 AND adq04 BETWEEN g_bdate AND g_edate
       AND adq10 = '1'
    SELECT SUM(adq09) INTO l_adq092 FROM adq_file   #本期銷退
     WHERE adq01 = p_adq01 AND adq02 = p_adq02
       AND adq03 = p_adq03 AND adq04 BETWEEN g_bdate AND g_edate
       AND adq10 = '2'
    SELECT SUM(adq09) INTO l_adq093 FROM adq_file   #客戶銷售
     WHERE adq01 = p_adq01 AND adq02 = p_adq02
       AND adq03 = p_adq03 AND adq04 BETWEEN g_bdate AND g_edate
       AND adq10 = '3'
    IF cl_null(l_adq091) THEN LET l_adq091 = 0 END IF
    IF cl_null(l_adq092) THEN LET l_adq092 = 0 END IF
    IF cl_null(l_adq093) THEN LET l_adq093 = 0 END IF
    LET g_adr09 = g_adr09 + l_adq091 + l_adq092 + l_adq093
     INSERT INTO adr_file(adr01,adr02,adr03,adr04,adr05,adr06,adr07,adr08,adr09) #No.MOD-470041
                  VALUES(p_adq01,p_adq02,p_adq03,p_yy,
       p_mm,l_adq091,l_adq092,l_adq093,g_adr09)
    IF SQLCA.sqlcode THEN
       CALL cl_err('ins adr',SQLCA.sqlcode,0) 
       LET g_success = 'N' 
       RETURN
    END IF
END FUNCTION

