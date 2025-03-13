# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axmp920.4gl
# Descriptions...: 銷售最近/平均單價計算更新作業
# Date & Author..: 00/03/28 By Jason
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.MOD-4B0221 04/11/23 by ching  一併更新 ima33
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-570110 05/07/14 By Nicola 1.程式沒有考慮系統的匯率參數是取每月或每日,直接使用每日統計檔資料.
#                                                   2.程式沒有考慮本幣別匯率為1的狀況. 所以所有的資料全部運算不出來
# Modify.........: No.MOD-540201 06/01/06 By Mandy 1.axmp920正名為銷售平均單價計算更新作業
#                                                  2.取消UPDATE ima33(最近售價),UPDATE ima33 改在saxmt400.4gl  的saxmt400_bu3()內
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710046 07/01/22 By yjkhero 錯誤訊息匯整 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          wc	LIKE type_file.chr1000,      #No.FUN-680137 VARCHAR(200)
          bdate	LIKE type_file.dat,          #No.FUN-680137 DATE
          edate	LIKE type_file.dat           #No.FUN-680137 DATE
          END RECORD
MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   CALL p920_tm(0,0)				#
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN
 
FUNCTION p920_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_flag        LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   OPEN WINDOW p920_w WITH FORM "axm/42f/axmp920" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
 
 WHILE TRUE
   LET g_action_choice = ''
   CLEAR FORM 
   INITIALIZE tm.* TO NULL			# Default condition
   CONSTRUCT BY NAME tm.wc ON ima01,ima08 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
         LET g_action_choice='locale'
         EXIT CONSTRUCT
      ON ACTION exit
         LET INT_FLAG = 1
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
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   INPUT BY NAME tm.bdate,tm.edate WITHOUT DEFAULTS 
      AFTER FIELD bdate
         IF tm.bdate IS NULL THEN NEXT FIELD bdate END IF
      AFTER FIELD edate
         IF tm.edate IS NULL THEN NEXT FIELD edate END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION locale
         LET g_action_choice='locale'
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
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
 
   END INPUT
   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   IF cl_sure(0,0) THEN
      LET g_success = 'Y'
      BEGIN WORK
      CALL cl_wait()
      CALL axmp920()
      CALL s_showmsg()                         #NO.FUN-710046  
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF
 END WHILE
   ERROR ""
   CLOSE WINDOW p920_w
END FUNCTION
 
FUNCTION axmp920()
#     DEFINE   l_time LIKE type_file.chr8                     #No.FUN-6A0094
DEFINE          l_sql	                 LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(500)
           l_ima01                LIKE ima_file.ima01,  #No.MOD-490217
          l_maxdate              LIKE type_file.dat,           #No.FUN-680137 DATE
          l_sum_ogb12            LIKE ogb_file.ogb12,  #FUN-4C0006
          l_price1,l_avg_price   LIKE ogb_file.ogb13   #FUN-4C0006
    DEFINE l_oga02                LIKE oga_file.oga02   #No.MOD-570110
    DEFINE l_oga23                LIKE oga_file.oga23   #No.MOD-570110
    DEFINE l_ogb13                LIKE ogb_file.ogb13   #No.MOD-570110
    DEFINE l_ogb12                LIKE ogb_file.ogb12   #No.MOD-570110
    DEFINE l_ogb15_fac            LIKE ogb_file.ogb15_fac   #No.MOD-570110
    DEFINE l_ogb917               LIKE ogb_file.ogb917  #CHI-B70039 add
    DEFINE l_rate                 LIKE azk_file.azk03   #No.MOD-570110
    DEFINE l_azj02                LIKE azj_file.azj02   #No.MOD-570110
    DEFINE l_price2,l_price3      LIKE ogb_file.ogb13   #No.MOD-570110
 
 
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
     LET l_sql = "SELECT ima01  FROM ima_file",
                 "  WHERE ",tm.wc CLIPPED,
                 "  ORDER BY ima01 "
     PREPARE p920_prepare FROM l_sql
     DECLARE p920_cur CURSOR FOR p920_prepare
 
      #-----No.MOD-570110-----
#    LET l_sql = "SELECT oga02,oga23,ogb13,ogb12,ogb15_fac",          #CHI-B70039 mark
     LET l_sql = "SELECT oga02,oga23,ogb13,ogb12,ogb15_fac,ogb917",   #CHI-B70039
                 "  FROM ogb_file,oga_file",
                 " WHERE ogb04=? ",
                 "   AND ogb01=oga01",
                 "   AND oga02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND ogaconf= 'Y'"
     PREPARE p920_spre FROM l_sql
     DECLARE p920_scur CURSOR FOR p920_spre
      #-----No.MOD-570110 END-----
     CALL s_showmsg_init()          #NO.FUN-710046
     FOREACH p920_cur INTO l_ima01
#NO.FUN-710046--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710046--END
        IF SQLCA.sqlcode THEN 
#          CALL cl_err('p920_cur',SQLCA.sqlcode,0) #NO.FUN-710046
           CALL s_errmsg('','','p920_cur',SQLCA.sqlcode,1)  #NO.FUN-710046
           LET g_success = 'N'
           EXIT FOREACH
        END IF
 
         #-----No.MOD-570110-----
        LET l_price2 = 0
        LET l_price3 = 0
#       FOREACH p920_scur USING l_ima01 INTO l_oga02,l_oga23,l_ogb13,l_ogb12,l_ogb15_fac            #CHI-B70039 mark
        FOREACH p920_scur USING l_ima01 INTO l_oga02,l_oga23,l_ogb13,l_ogb12,l_ogb15_fac,l_ogb917   #CHI-B70039
           LET l_rate = 0
           IF g_aza.aza19 = "1" THEN
              LET l_azj02 = YEAR(l_oga02) USING "&&&&" CLIPPED,MONTH(l_oga02) USING "&&" CLIPPED
              SELECT azj03 INTO l_rate FROM azj_file
               WHERE azj01 = l_oga23
                 AND azj02 = l_azj02
           ELSE
              SELECT azk03 INTO l_rate FROM azk_file
               WHERE azk01 = l_oga23
                 AND azk02='9999/12/31'
           END IF
 
           IF l_rate = 0 OR cl_null(l_rate) THEN
              LET l_rate = 1
           END IF
 
#          LET l_price2 = l_price2 + (l_ogb13 * l_ogb12 * l_ogb15_fac * l_rate)   #CHI-B70039 mark
           LET l_price2 = l_price2 + (l_ogb917 * l_ogb13 * l_ogb15_fac * l_rate)  #CHI-B70039
           LET l_price3 = l_price3 + (l_ogb12 * l_ogb15_fac)
        END FOREACH
 
        LET l_avg_price = l_price2 / l_price3
 
       #SELECT AVG(ogb13*azk03) INTO l_avg_price
       #SELECT SUM(ogb13*ogb12*azk03*ogb15_fac)/SUM(ogb12*ogb15_fac)
       #  INTO l_avg_price
       #  FROM ogb_file, oga_file, azk_file
       #    WHERE ogb04=l_ima01
       #      AND ogb01=oga01
       #      AND oga23=azk01 AND azk02='9999/12/31'
       #      AND oga02 BETWEEN tm.bdate AND tm.edate
       #      AND ogaconf= 'Y'
        #-----No.MOD-570110 END-----
 
        MESSAGE l_ima01,l_price1 
        CALL ui.Interface.refresh()
        IF l_avg_price IS NULL THEN LET l_avg_price=0 END IF
        UPDATE ima_file SET ima98 = l_avg_price,
                           #ima33 = l_avg_price  #MOD-4B0221 #MOD-540201 MARK
                            imadate = g_today     #FUN-C30315 add
                      WHERE ima01=l_ima01
     END FOREACH
#NO.FUN-710046--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710046--END
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
     ERROR ' '
END FUNCTION
