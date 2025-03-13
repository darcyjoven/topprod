# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aemp200.4gl
# Descriptions...: 設備管理系統成本更新作業
# Date & Author..: 04/07/28 By Elva
# Modify.........: No.MOD-540141 05/04/20 By vivien  刪除HELP FILE
# Modify.........: No.FUN-570143 06/02/27 By yiting 批次作業背景執行功能
# Modify.........: No.FUN-680072 06/08/24 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A10077 10/01/20 By Smapmin UPDATE fil17/fil18/fia23的動作需移至月底成本更新時再做
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.CHI-B60093 11/06/30 By JoHung 畫面加上成本計算類別
#                                                   依成本計算類別取得該料的成本平均
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_fiw          RECORD LIKE fiw_file.*,
         g_fiv          RECORD LIKE fiv_file.*,
         tm             RECORD
                        wc         LIKE type_file.chr1000,    #No.FUN-680072CHAR(300)
                        yy         LIKE type_file.num5,       #No.FUN-680072SMALLINT
                        mm         LIKE type_file.num5,       #No.FUN-680072SMALLINT   #CHI-B60093 add ,
                        type       LIKE type_file.chr1        #CHI-B60093 add
                        END RECORD,
          g_wc           STRING,  #No.FUN-580092 HCN
          g_bdate        LIKE type_file.dat,     #No.FUN-680072DATE
          g_edate        LIKE type_file.dat,     #No.FUN-680072DATE
          g_sql          STRING,  #No.FUN-580092 HCN
          g_flag         LIKE type_file.chr1     #No.FUN-680072 VARCHAR(1)
DEFINE    l_flag         LIKE type_file.chr1,                  #No.FUN-570143        #No.FUN-680072 VARCHAR(1)
          g_change_lang  LIKE type_file.chr1,    #No.FUN-680072CHAR(1)
          ls_date        STRING                  #->No.FUN-570143
 DEFINE   g_argv1        LIKE azm_file.azm01,    #No.FUN-680072CHAR(4) #TQC-840066
          g_argv2        LIKE aba_file.aba18,    #No.FUN-680072CHAR(2)
          g_argv3        LIKE type_file.chr1000  #No.FUN-680072CHAR(400)
 
MAIN
#     DEFINEl_time   LIKE type_file.chr8             #No.FUN-6A0068
 
    OPTIONS
 
        INPUT NO WRAP
   DEFER INTERRUPT
 
 
   LET g_argv1 = ARG_VAL(1)         #參數-1 年度指標
   LET g_argv2 = ARG_VAL(2)         #參數-2 月份
   LET g_argv3 = ARG_VAL(3)         #參數-2 條件
#->No.FUN-570143 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc   = ARG_VAL(4)
   LET tm.yy   = ARG_VAL(5)
   LET tm.mm   = ARG_VAL(6)
   LET g_bgjob = ARG_VAL(7)
   LET tm.type = ARG_VAL(8)   #CHI-B60093 add
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570143 ---end---
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
 
#NO.FUN-570143 START-- 
#   IF cl_null(g_argv1) THEN
#      CALL p200_tm()
#   ELSE
#      LET tm.wc    =g_argv1
#      LET tm.yy    =g_argv2
#      LET tm.mm    =g_argv3
#      CALL p200_p()
#   END IF
   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N'  THEN
         CALL p200_tm()
         IF cl_sure(21,21) THEN
            BEGIN WORK
            CALL p200_p1()
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
               CLOSE WINDOW p200_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         CALL p200_p1()
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570143 ---end---
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
END MAIN
 
FUNCTION p200_tm()
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680072 SMALLINT
   DEFINE lc_cmd         LIKE type_file.chr1000       #No.FUN-680072 VARCHAR(500)
 
    LET p_row = 5 LET p_col = 26
 
   OPEN WINDOW p200_w AT p_row,p_col
        WITH FORM "aem/42f/aemp200" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'
   LET tm.type = g_ccz.ccz28
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON fiw03
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT 
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg 
            CALL cl_cmdask()
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
        #-----END TQC-860018-----
   IF INT_FLAG THEN
      LET INT_FLAG=0 CLOSE WINDOW p200_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM              #FUN-570143
      #RETURN
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#  DISPLAY BY NAME tm.yy,tm.mm            #CHI-B60093 mark
   DISPLAY BY NAME tm.yy,tm.mm,tm.type    #CHI-B60093
   LET g_bgjob = 'N'                      #FUN-570143
 
#FUN-570143 --start--
   #INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS
#  INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570143  #CHI-B60093 mark
   INPUT BY NAME tm.yy,tm.mm,tm.type,g_bgjob WITHOUT DEFAULTS           #CHI-B60093
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
#            IF cl_null(tm.mm) OR tm.mm < 1 OR tm.mm > 13 THEN
#               NEXT FIELD mm
#            END IF
#No.TQC-720032 -- end -- 
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
         #NO.FUN-570143--
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
         #NO.FUN-570143
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT 
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
        #-----END TQC-860018-----
   END INPUT
 
#NO.FUN-570143 START--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
         CONTINUE WHILE
      END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p200_w            
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM                  
   END IF
 
   #IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
   #IF cl_sure(18,20) THEN
   #   CALL p200_p()
   #END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'aemp200'
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aemp200','9031',1)             
        ELSE
           LET tm.wc = cl_replace_str(tm.wc,"'","\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_argv1 CLIPPED, "'",
                        " '",g_argv2 CLIPPED, "'",
                        " '",g_argv3 CLIPPED, "'",
                        " '",tm.wc CLIPPED, "'",
                        " '",tm.yy CLIPPED, "'",
                        " '",tm.mm CLIPPED, "'",
                        " '",g_bgjob CLIPPED, "'"
           CALL cl_cmdat('aemp200',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p200_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
   EXIT WHILE
#FUN-570143 --end--
END WHILE
# CLOSE WINDOW p200_w
END FUNCTION
 
#NO.FUN-570143  MARK+---
#FUNCTION p200_p()
# DEFINE  l_i      LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
#  BEGIN WORK
#  LET g_success = 'Y'
#  CALL p200_p1()
#  IF g_success='Y' THEN
#     CALL cl_cmmsg(1) COMMIT WORK
#  ELSE
#     CALL cl_rbmsg(1) ROLLBACK WORK
#  END IF
#END FUNCTION
#NO.FUN-570143 MARK---
FUNCTION p200_p1()
 DEFINE  l_cnt    LIKE type_file.num5,          #No.FUN-680072 SMALLINT
         l_i,l_n  LIKE type_file.num5,          #No.FUN-680072 SMALLINT
         l_y,l_m  LIKE type_file.num5,          #No.FUN-680072 SMALLINT
         l_fiw01  LIKE fiw_file.fiw01,
         l_fiw02  LIKE fiw_file.fiw02,
         l_fiw03  LIKE fiw_file.fiw03
DEFINE   l_fiw11_1,l_fiw11_2   LIKE fiw_file.fiw11   #MOD-A10077
DEFINE   l_fil03  LIKE fil_file.fil03   #MOD-A10077
 
  CALL s_azm(tm.yy,tm.mm) RETURNING g_flag,g_bdate,g_edate
  IF g_flag = '1' THEN
     CALL cl_err('s_azm:error','agl-038',1)
     LET g_success = 'N'
     RETURN
  END IF
  LET g_sql = "SELECT fiv_file.*,fiw_file.*",
              "  FROM fiw_file,fiv_file",
              " WHERE fiv05 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
              "   AND fiw01 = fiv01 AND fivpost = 'Y' ",
              "   AND fivconf='Y'  ",
              "   AND ",tm.wc CLIPPED,
              " ORDER BY fiv01,fiw02,fiw03"
  PREPARE p200_s2_pre1 FROM g_sql
  IF STATUS THEN CALL cl_err('pre_s2',STATUS,0) RETURN END IF
  DECLARE p200_s2_c CURSOR FOR p200_s2_pre1
  IF STATUS THEN CALL cl_err('dec_s2',STATUS,0) RETURN END IF
 
  FOREACH p200_s2_c INTO g_fiv.*,g_fiw.*
    IF STATUS THEN
       CALL cl_err('for_s2',STATUS,0) LET g_success='N' EXIT FOREACH
    END IF
#   CALL p200(g_fiv.*,g_fiw.*,tm.yy,tm.mm)           #CHI-B60093 mark
    CALL p200(g_fiv.*,g_fiw.*,tm.yy,tm.mm,tm.type)   #CHI-B60093
    #-----MOD-A10077---------
    SELECT SUM(fiw11) INTO l_fiw11_1 FROM fiw_file,fiv_file
     WHERE fiv01=fiw01 AND fiv02=g_fiv.fiv02 AND fiw09='Y' AND fivpost='Y'
       AND fiv00='1'   AND fivconf='Y'
    
    SELECT SUM(fiw11) INTO l_fiw11_2 FROM fiw_file,fiv_file
     WHERE fiv01=fiw01 AND fiv02=g_fiv.fiv02 AND fiw09='Y' AND fivpost='Y'
       AND fiv00='2'   AND fivconf='Y'
    
    IF cl_null(l_fiw11_1) THEN LET l_fiw11_1=0 END IF
    IF cl_null(l_fiw11_2) THEN LET l_fiw11_2=0 END IF
    UPDATE fil_file SET fil17=l_fiw11_1-l_fiw11_2 WHERE fil01=g_fiv.fiv02
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","fil_file",g_fiv.fiv02,"",SQLCA.sqlcode,"","update fil17",1) 
       LET g_success='N'
       EXIT FOREACH
    END IF
    
    SELECT SUM(fiw11) INTO l_fiw11_1 FROM fiw_file,fiv_file
     WHERE fiv01=fiw01 AND fiv02=g_fiv.fiv02 AND fiw09='N' AND fivpost='Y'
       AND fiv00='1'   AND fivconf='Y'
    
    SELECT SUM(fiw11) INTO l_fiw11_2 FROM fiw_file,fiv_file
     WHERE fiv01=fiw01 AND fiv02=g_fiv.fiv02 AND fiw09='N' AND fivpost='Y'
       AND fiv00='2'   AND fivconf='Y'
    
    IF cl_null(l_fiw11_1) THEN LET l_fiw11_1=0 END IF
    IF cl_null(l_fiw11_2) THEN LET l_fiw11_2=0 END IF
    UPDATE fil_file SET fil18=l_fiw11_1-l_fiw11_2 WHERE fil01=g_fiv.fiv02
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","fil_file",g_fiv.fiv02,"",SQLCA.sqlcode,"","update fil18",1) 
       LET g_success='N'
       EXIT FOREACH
    END IF
   
    LET l_fil03 = ''
    SELECT fil03 INTO l_fil03 FROM fil_file WHERE fil01=g_fiv.fiv02 
    UPDATE fia_file SET fia23=(SELECT fil17+fil18 FROM fil_file
                                WHERE fil01=g_fiv.fiv02)
     WHERE fia01 = l_fil03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","fia_file",l_fil03,"",SQLCA.sqlcode,"","update fia23",1)  
       LET g_success='N'
       EXIT FOREACH
    END IF
    #-----END MOD-A10077-----
  END FOREACH
END FUNCTION
#Patch....NO.TQC-610035 <001> #
