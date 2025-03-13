# Prog. Version..: '5.30.06-13.03.25(00010)'     #
#
# Pattern name...: axcp270.4gl
# Descriptions...: 成本階計算作業
# Date & Author..: 98/05/16 By Aladin
# Modify.........: 03/05/26 By Jiunn (No.7293)
#                  對應與聯產品的相關調整
#                  a.聯產品成本階認定與主料一樣, 若聯產品對應多主料時, 則以
#                    最小階數為主
#                  b.若當月有聯產品入庫, 則主料 ima905 ='Y'
# Modify.........: No.MOD-4C0087 04/12/15 By day  新增報表功能
# Modify.........: No.MOD-510018 05/01/07 By ching 聯產品階數
# Modify.........: No.FUN-4C0099 05/01/10 By kim 報表轉XML功能
# Modify.........: No.MOD-530689 05/04/01 By ching 印元件階數,重工不印
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670034 06/07/14 By Sarah 
#                  以傳入參數g_argv1判斷,g_argv1=1執行axcp270,以ima16計算ima57
#                                        g_argv1=2執行axcp271,以ima80計算ima57
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0002 06/11/15 By johnray 報表修改
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-750027 07/05/08 By Carol FETCH FIRST前要先將變數清為NULL,以免資料殘留造成異常
# Modify.........: No.CHI-7B0022 07/11/16 By Sarah 判斷當工單的生產料件不是kk.ima01,但入庫料件卻是kk.ima01,表示有入聯產品,要將kk.ima01的ima905改成Y
# Modify.........: No.MOD-8A0180 08/10/21 By wujie 計算成本階時，98階時沒有考慮sfb087='Y'
# Modify.........: No.MOD-980168 09/08/20 By xiaofeizhu 只檢查未結案或結案日期大于等于當前月的工單
# Modify.........: No.FUN-980069 09/08/21 By mike 將年度欄位default ccz01月份欄位default ccz02
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60080 10/07/08 By destiny 增加平行工艺逻辑 
# Modify.........: No:FUN-A20017 10/10/22 By jan 處理委外聯產品的部分
# Modify.........: No:CHI-A90001 10/11/17 By sabrina 在更新ima_file之前，先將ima_file資料寫入暫存檔裡，以縮短lock時間
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B50021 11/05/04 By sabrina 背景作業時，l_cmd少傳一個參數g_argv1
# Modify.........: No:TQC-B90104 11/09/16 By yinhy axcp271作業打開後顯示的卻是axcp270
# Modify.........: No:MOD-C30005 12/03/01 By ck2yuan 若主產品的成本階比聯產品成本階小的話，就以主產品的成本階為主
# Modify.........: No:CHI-C80002 12/10/05 By bart 效能改善
# Modify.........: No:FUN-CA0094 12/10/16 By bart 比對客戶調整後程式修改
# Modify.........: No:FUN-C80092 12/12/05 By xujing 成本相關作業程式日誌
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No:MOD-D30195 13/03/22 By ck2yuan 若是開重工工單，領自己及1階半成品時，成本階會被歸到97，造成成本計算錯誤
# Modify.........: No:MOD-D90118 13/09/23 By SunLM 依發料低階碼計算成本階時,不需要97,98階的情況；當g_argv1=1時候,才走97,98階

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE kk       RECORD
#                 curr_id LIKE type_file.num10,          #No.FUN-680122 INTEGER,  #No.TQC-6B0002
                 curr_id LIKE type_file.chr18,           #No.TQC-6B0002
                 ima01   LIKE ima_file.ima01,
                 ima08   LIKE ima_file.ima08,
                 ima16   LIKE ima_file.ima16,   #低階碼
                 ima57   LIKE ima_file.ima57,
                 ima905  LIKE ima_file.ima905,
                 ima80   LIKE ima_file.ima80    #發料低階碼   #FUN-670034 add
                END RECORD,
       l_bdate  LIKE type_file.dat,            #No.FUN-680122 DATE,
       l_edate  LIKE type_file.dat,            #No.FUN-680122 DATE,
       bmb_cnt  LIKE type_file.num10,          #No.FUN-680122 INTEGER,
       sfb_cnt  LIKE type_file.num10,          #No.FUN-680122 INTEGER,
       ima_cnt  LIKE type_file.num10,          #No.FUN-680122 INTEGER,
       curr_cnt LIKE type_file.num10,          #No.FUN-680122 INTEGER,
       key_code LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),
       tm       RECORD
      #          a   LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),
                 yy  LIKE type_file.num5,           #No.FUN-680122 SMALLINT, 
                 mm  LIKE type_file.num5            #No.FUN-680122 SMALLINT 
                END RECORD,
 #MOD-4C0087--begin
       l_sql    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(300),
       g_sql    STRING,     #No.FUN-580092 HCN
       g_argv1  LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1),     #FUN-670034 add
DEFINE l_flag          LIKE type_file.chr1,                  #No.FUN-570153        #No.FUN-680122 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(01),              #是否有做語言切換 No.FUN-570153
       ls_date         STRING                  #->No.FUN-570153
 
DEFINE g_i             LIKE type_file.num5                  #count/index for any purpose              #No.FUN-680122 SMALLINT
 #MOD-4C0087--end
DEFINE g_flag          LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE l_ima01         LIKE ima_file.ima01         #CHI-A90001 add
DEFINE l_ima57         LIKE ima_file.ima57         #CHI-A90001 add
DEFINE l_ima905        LIKE ima_file.ima905        #CHI-A90001 add
DEFINE g_msg           LIKE type_file.chr1000      #CHI-A90001 add
DEFINE g_cka00         LIKE cka_file.cka00         #FUN-C80092 add
DEFINE g_cka09         LIKE cka_file.cka09         #FUN-C80092 add
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0146
    DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680122 SMALLINT
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #start FUN-670034 add
    LET g_argv1 = ARG_VAL(1)
 
#No.TQC-B90104 去掉mark --Begin
    CASE g_argv1
       WHEN "1" LET g_prog = 'axcp270'
       WHEN "2" LET g_prog = 'axcp271'
       OTHERWISE EXIT PROGRAM
    END CASE
#No.TQC-B90104 去掉mark --End
   #end FUN-670034 add
 
#->No.FUN-570153 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy   = ARG_VAL(2)    #FUN-670034 modify 1->2
   LET tm.mm   = ARG_VAL(3)    #FUN-670034 modify 2->3
   LET g_bgjob = ARG_VAL(4)    #FUN-670034 modify 3->4
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570153 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570153 mark--
#    OPEN WINDOW axcp270_w AT p_row,p_col WITH FORM "axc/42f/axcp270"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#    WHILE TRUE
#       ERROR ''
#       LET g_flag = 'Y'
#       CALL axcp270_cs()
#       IF g_flag = 'N' THEN
#          CONTINUE WHILE
#       END IF
#       IF g_success='Y' THEN
#          COMMIT WORK
#           CALL p270_out() #No.MOD-4C0087
#          CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#       ELSE
#          ROLLBACK WORK
#          CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#       END IF
#       IF g_flag THEN
#          CONTINUE WHILE
#       ELSE
#          EXIT WHILE
#       END IF
#    END WHILE
#    CLOSE WINDOW axcp270_w                    #結束畫面
#NO.FUN-570153
 
#NO.FUN-570153 start--
#  CALL cl_used('axcp270',g_time,1) RETURNING g_time    #No.FUN-6A0146
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   WHILE TRUE
      LET g_success = 'Y'
     #CHI-A90001---add---start---
      CREATE TEMP TABLE ima270_tmp(
        ima01     LIKE ima_file.ima01,
        ima08     LIKE ima_file.ima08,
        ima16     LIKE ima_file.ima16,
        ima57     LIKE ima_file.ima57,
        ima80     LIKE ima_file.ima80,
        ima905    LIKE ima_file.ima905)
      CREATE INDEX ima270_index ON ima270_tmp(ima01)  #CHI-C80002
      CREATE INDEX ima270_i03 ON ima270_tmp (ima57)	  #FUN-CA0094
     #CHI-A90001---add---end---
      #CHI-C80002---begin
     #LET l_sql = " UPDATE ima_file SET ima57=?,ima905=? ",               #FUN-C30315 mark
      LET l_sql = " UPDATE ima_file SET ima57=?,ima905=? ,imadate = ?",   #FUN-C30315 add
                  " WHERE ima01 = ? "
      PREPARE k270_updima_p FROM l_sql             
      #CHI-C80002---end
      IF g_bgjob = "N" THEN
         CALL axcp270_cs()
         IF cl_sure(18,20) THEN 
           LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm,";g_bgjob='",g_bgjob,"'"   #FUN-C80092 add
           CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00   #FUN-C80092 add
           BEGIN WORK        #No.FUN-710027 
            CALL p270_p()
            CALL s_showmsg()        #No.FUN-710027 
           #CHI-A90001---add---start---
            IF  g_success = 'Y' THEN 
                DECLARE ima270_cur CURSOR FOR 
                SELECT ima01,ima57,ima905 FROM ima270_tmp
                FOREACH ima270_cur INTO l_ima01,l_ima57,l_ima905
                  IF  SQLCA.sqlcode THEN
                      LET g_success = 'N' 
                      CALL cl_err("FOREACH ima270_cur err",'!','1')
                  END IF 
                  #UPDATE ima_file SET ima57=l_ima57,ima905=l_ima905  #CHI-C80002
                  #    WHERE ima01 = l_ima01  #CHI-C80002
                 #EXECUTE k270_updima_p USING l_ima57,l_ima905,l_ima01  #CHI-C80002         #FUN-C30315 mark 
                  EXECUTE k270_updima_p USING l_ima57,l_ima905,g_today,l_ima01  #CHI-C80002 #FUN-C30315 add
                  IF  SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
                      LET g_msg = 'update ima_file err ima01=',l_ima01
                      CALL cl_err(g_msg,sqlca.sqlcode,1)
                      LET g_success = 'N' EXIT FOREACH 
                  END IF 
                END FOREACH 
            END IF 
           #CHI-A90001---add---end---
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN 
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW axcp270_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW axcp270_w
      ELSE
        LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm,";g_bgjob='",g_bgjob,"'"      #FUN-C80092 add
        CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00   #FUN-C80092 add
        BEGIN WORK               #No.FUN-710027
         CALL p270_p()         
         CALL s_showmsg()        #No.FUN-710027 
        #CHI-A90001---add---start---
         IF  g_success = 'Y' THEN 
             DECLARE ima270a_cur CURSOR FOR 
             SELECT ima01,ima57,ima905 FROM ima270_tmp
             FOREACH ima270a_cur INTO l_ima01,l_ima57,l_ima905
               IF  SQLCA.sqlcode THEN
                   LET g_success = 'N' 
                   CALL cl_err("FOREACH ima270a_cur err",'!','1')
               END IF 
               #UPDATE ima_file SET ima57=l_ima57,ima905=l_ima905  #CHI-C80002
               #    WHERE ima01 = l_ima01  #CHI-C80002
              #EXECUTE k270_updima_p USING l_ima57,l_ima905,l_ima01  #CHI-C80002         #FUN-C30315 mark
               EXECUTE k270_updima_p USING l_ima57,l_ima905,g_today,l_ima01  #CHI-C80002 #FUN-C30315 add
               IF  SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
                   LET g_msg = 'update ima_file err ima01=',l_ima01
                   CALL cl_err(g_msg,sqlca.sqlcode,1)
                   LET g_success = 'N' EXIT FOREACH 
               END IF 
             END FOREACH 
         END IF 
        #CHI-A90001---add---end---
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   # CLOSE WINDOW axcp270_w                    #結束畫面
#->No.FUN-570153 ---end---
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION axcp270_cs()
   DEFINE   l_cnt      LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE lc_cmd       LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(500)          #No.FUN-570153
 
   LET p_row = 0 LET p_col = 0 
#->No.FUN-570153 ---start---
   OPEN WINDOW axcp270_w AT p_row,p_col WITH FORM "axc/42f/axcp270"
     ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
  #start FUN-670034 add
   CASE g_argv1
      WHEN "1" CALL cl_set_comp_visible("dummy05",FALSE)
               CALL cl_set_comp_visible("dummy01",TRUE)
      WHEN "2" CALL cl_set_comp_visible("dummy01",FALSE)
               CALL cl_set_comp_visible("dummy05",TRUE)
   END CASE
  #end FUN-670034 add
 
#->No.FUN-570153 ---end---
 
   MESSAGE ""
  #LET tm.yy = g_sma.sma51 LET tm.mm = g_sma.sma52 #FUN-980069
   LET tm.yy = g_ccz.ccz01 LET tm.mm = g_ccz.ccz02 #FUN-980069        
   LET g_bgjob = 'N'      # FUN-570153
   WHILE TRUE             #NO.FUN-570153
#   INPUT BY NAME tm.* 
   INPUT BY NAME tm.*,g_bgjob WITHOUT DEFAULTS  
{
      AFTER FIELD a
         IF tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
         IF tm.a = 'N' THEN
            EXIT INPUT
         END IF
}
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN
            NEXT FIELD yy
         END IF
 
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
#No.TQC-720032 -- end --
         IF cl_null(tm.mm) THEN
            NEXT FIELD mm
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION locale #genero
#NO.FUN-570153 MARK
#         LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570153 MARK
         LET g_change_lang = TRUE                   #NO.FUN-570153 
         EXIT INPUT
 
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
 
   END INPUT
#NO.FUN-570153 start--
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW axcp270_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axcp270"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axcp270','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      "'",g_argv1 CLIPPED ,"'",     #MOD-B50021 add
                      " '",tm.yy CLIPPED ,"'",
                      " '",tm.mm CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
        #MOD-B50021---modify---start---
        #CALL cl_cmdat('axcp270',g_time,lc_cmd CLIPPED)     
         IF g_argv1 = '2' THEN                
            CALL cl_cmdat('axcp271',g_time,lc_cmd CLIPPED)     
         ELSE                                                       
            CALL cl_cmdat('axcp270',g_time,lc_cmd CLIPPED)          
         END IF                                                    
        #MOD-B50021---modify---end---
      END IF
      CLOSE WINDOW axcp270_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
  #->No.FUN-570153 ---end---   
 
  # IF tm.a = 'N' THEN
  #    RETURN 
  # END IF
#NO.FUN-570153 mark---
#   CALL s_ymtodate(tm.yy,tm.mm,tm.yy,tm.mm) RETURNING l_bdate,l_edate
#   IF INT_FLAG THEN
#      LET INT_FLAG=0 RETURN
#   END IF
#   
#  #IF cl_sure(20,20) THEN
#      CALL cl_wait()
#      LET g_success = 'Y'
#      SELECT COUNT(*) INTO ima_cnt FROM ima_file
#      LET l_sql= " SELECT ima01,ima08,ima16,ima57 FROM ima_file "
#      PREPARE k270_pre FROM l_sql
#      IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('prepare:',SQLCA.sqlcode,1)
#         EXIT PROGRAM
#      END IF
#      DECLARE k270_curs CURSOR FOR k270_pre
#      INITIALIZE kk.* TO NULL 
#      LET curr_cnt = 0
#      LET bmb_cnt = 0
#      LET sfb_cnt = 0
#      
#      FOREACH k270_curs INTO kk.ima01,kk.ima08,
#                             kk.ima16,kk.ima57,kk.ima905
#         IF SQLCA.sqlcode THEN 
#            CALL cl_err('k270_curs',SQLCA.sqlcode,0)
#            LET g_success='N'
#            EXIT FOREACH 
#         END IF
#         LET curr_cnt = curr_cnt + 1
#         DISPLAY ima_cnt,curr_cnt,kk.ima01 TO notot,no_ok,p2
#          CALL ui.Interface.refresh() #MOD-490270
#         LET kk.ima57 = kk.ima16
#         LET kk.ima905= 'N'
#         #--判斷ima57的調整碼--------
#         IF (kk.ima08 = 'P' OR kk.ima08 = 'V' OR kk.ima08 = 'Z') THEN 
#            LET kk.ima57 = 99
#            SELECT COUNT(*) INTO sfb_cnt FROM sfb_file WHERE sfb05=kk.ima01 
#            IF cl_null(sfb_cnt) THEN
#               LET sfb_cnt = 0 
#            END IF   
#            IF sfb_cnt > 0 THEN
#               LET kk.ima57=98 
#            END IF
#         END IF 
#         #No.7293 03/05/26 By Jiunn Mod.A.b.01 -----
##        UPDATE ima_file SET ima57=kk.ima57
##           WHERE ima01=kk.ima01
#         IF g_sma.sma104 = 'Y' AND kk.ima08 MATCHES '[MT]' THEN
#            LET l_cnt = 0
#            SELECT COUNT(*) INTO l_cnt FROM sfu_file,sfv_file,sfb_file
#             WHERE sfu01=sfv01 AND sfv11=sfb01 AND sfb05=kk.ima01
#               AND sfu02 BETWEEN l_bdate AND l_edate
#               AND sfupost='Y' AND sfb05 <> sfv04
#            IF l_cnt > 0 THEN 
#               LET kk.ima905='Y'
#            END IF
#         END IF
#         UPDATE ima_file SET ima57=kk.ima57,ima905=kk.ima905
#            WHERE ima01=kk.ima01
#         IF SQLCA.sqlcode THEN 
#            CALL cl_err('up_ima',SQLCA.sqlcode,1)
#            LET g_success='N'
#            EXIT FOREACH 
#         END IF
#         #No.7293 End.A.b.01 -----------------------
#      END FOREACH
#      
#      CALL p270_nobom()
#      #No.7293 03/05/26 By Jiunn Add.A.a.01 -----
#      IF g_sma.sma104 = 'Y' THEN
#         CALL p270_setjp()
#      END IF
#  #END IF
#   #No.7293 End.A.a.01 -----------------------
#NO.FUN-5T9135 MARK---
END FUNCTION
 
#NO.FUN-570153 start--
FUNCTION p270_p()
   DEFINE   l_cnt   LIKE type_file.num5          #No.FUN-680122 SMALLINT
   CALL s_ymtodate(tm.yy,tm.mm,tm.yy,tm.mm) RETURNING l_bdate,l_edate
   IF INT_FLAG THEN
      LET INT_FLAG=0 RETURN
   END IF
   
   IF g_bgjob = 'N' THEN   #FUN-570153 ---start--
      CALL cl_wait()
   END IF
      LET g_success = 'Y'
     #CHI-A90001---add---start---
      DELETE FROM ima270_tmp
      INSERT INTO ima270_tmp                                       #tianry add 170213
      SELECT ima01,ima08,ima16,ima57,ima80,ima905 FROM ima_file  #EWHERE ima01='CA0023R5HR' 
     #CHI-A90001---add---end---
     #SELECT COUNT(*) INTO ima_cnt FROM ima_file            #CHI-A90001 mark 
      SELECT COUNT(*) INTO ima_cnt FROM ima270_tmp          #CHI-A90001 add
      LET l_sql= "SELECT ima01,ima08,ima16,ima57,ima905,ima80",  #FUN-670034 add ima80
                #"  FROM ima_file "            #CHI-A90001 mark 
                 "  FROM ima270_tmp "          #CHI-A90001 add 
      PREPARE k270_pre FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)   
         CALL cl_batch_bg_javamail("N")      #FUN-570153 
         CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE k270_curs CURSOR FOR k270_pre
      INITIALIZE kk.* TO NULL 
      LET curr_cnt = 0
      LET bmb_cnt = 0
      LET sfb_cnt = 0
      #CHI-C80002---begin
      LET l_sql = " UPDATE ima270_tmp SET ima57=?,ima905=? ",
                  " WHERE ima01 = ? "
      PREPARE k270_updtmp_p1 FROM l_sql             
      #CHI-C80002---end
      
      CALL s_showmsg_init()   #No.FUN-710027  
      FOREACH k270_curs INTO kk.ima01,kk.ima08,
                             kk.ima16,kk.ima57,kk.ima905,kk.ima80   #FUN-670034 add kk.ima80
         IF SQLCA.sqlcode THEN 
#            CALL cl_err('k270_curs',SQLCA.sqlcode,0)           #No.FUN-710027
            CALL s_errmsg('','','k270_curs',SQLCA.sqlcode,0)    #No.FUN-710027
            LET g_success='N'
            EXIT FOREACH 
         END IF
 
#No.FUN-710027--begin 
         IF g_success='N' THEN  
            LET g_totsuccess='N'  
            LET g_success="Y"   
         END IF 
#No.FUN-710027--end
 
         LET curr_cnt = curr_cnt + 1
         IF g_bgjob = 'N' THEN                           #FUN-570153 ---start---
             DISPLAY ima_cnt,curr_cnt,kk.ima01 TO notot,no_ok,p2
             CALL ui.Interface.refresh() #MOD-490270
         END IF  #NO.FUN-570153 
        #start FUN-670034 modify
        #LET kk.ima57 = kk.ima16
         CASE g_argv1
            WHEN "1" LET kk.ima57 = kk.ima16
            WHEN "2" LET kk.ima57 = kk.ima80
         END CASE
        #end FUN-670034 modify
         LET kk.ima905= 'N'
         #--判斷ima57的調整碼--------
         IF (kk.ima08 = 'P' OR kk.ima08 = 'V' OR kk.ima08 = 'Z') THEN 
            LET kk.ima57 = 99
            SELECT COUNT(*) INTO sfb_cnt FROM sfb_file WHERE sfb05=kk.ima01 
                                                         AND sfb87 ='Y'  #No.MOD-8A0180
            IF cl_null(sfb_cnt) THEN
               LET sfb_cnt = 0 
            END IF   
            #MOD-D90118 add begin------------
            #IF sfb_cnt > 0 THEN
            #   LET kk.ima57=98 
            #END IF
            IF sfb_cnt > 0 THEN 
               IF g_argv1='1' THEN 
                  LET kk.ima57 = 98
               ELSE 
                  LET kk.ima57 = kk.ima80
               END IF 
            END IF          
            #MOD-D90118 add end--------------
         END IF 
         #No.7293 03/05/26 By Jiunn Mod.A.b.01 -----
#        UPDATE ima_file SET ima57=kk.ima57
#           WHERE ima01=kk.ima01
         #sma104:是否使用聯產品    #ima08:來源碼
        #IF g_sma.sma104 = 'Y' AND kk.ima08 MATCHES '[MT]' THEN  #FUN-A20017
         IF g_sma.sma104 = 'Y' AND kk.ima08 MATCHES '[MST]' THEN #FUN-A20017
            LET l_cnt = 0
            #判斷當工單的生產料件是kk.ima01,但入庫料件卻不是kk.ima01,
            #表示有入聯產品
            SELECT COUNT(*) INTO l_cnt 
              #FROM sfu_file,sfv_file,sfb_file  #FUN-CA0094
              FROM sfv_file,sfu_file,sfb_file   #FUN-CA0094
             WHERE sfu01=sfv01 
               AND sfb01=sfv11 
               AND sfb05=kk.ima01
               AND sfu02 BETWEEN l_bdate AND l_edate
               AND sfupost='Y' 
               AND sfb05 <> sfv04   #生產料件<>入庫料件
            IF l_cnt > 0 THEN 
               LET kk.ima905='Y'
            END IF
           #str CHI-7B0022 add
            #判斷當工單的生產料件不是kk.ima01,但入庫料件卻是kk.ima01,
            #表示有入聯產品
            IF l_cnt = 0 THEN
               SELECT COUNT(*) INTO l_cnt 
                 #FROM sfu_file,sfv_file,sfb_file  #FUN-CA0094
                 FROM sfv_file,sfu_file,sfb_file   #FUN-CA0094
                WHERE sfu01=sfv01 
                  AND sfb01=sfv11 
                  AND sfb05!=kk.ima01
                  AND sfu02 BETWEEN l_bdate AND l_edate
                  AND sfupost='Y' 
                  AND sfv04=kk.ima01
               IF l_cnt > 0 THEN 
                  LET kk.ima905='Y'
               END IF
            END IF
           #end CHI-7B0022 add
           #FUN-A20017--begin--add----
           #add 委外聯產品
           #判斷當采購料件是kk.ima01,但入庫料件卻不是kk.ima01
           #表示有入聯產品
           IF l_cnt = 0 THEN
               SELECT COUNT(*) INTO l_cnt 
                 #FROM rvu_file,rvv_file,pmn_file  #FUN-CA0094
                 FROM rvv_file,rvu_file,pmn_file   #FUN-CA0094
                WHERE rvu01=rvv01 
                  AND rvu03 BETWEEN l_bdate AND l_edate
                  AND rvu00 = '1' 
                  AND rvuconf='Y' 
                  AND pmn01 = rvv36 
                  AND pmn02 = rvv37 
                  AND pmn04 = kk.ima01
                  AND pmn04 <> rvv31  #采購料件<>入庫料件
               IF l_cnt > 0 THEN 
                  LET kk.ima905='Y'
               END IF
           END IF
           #判斷當采購料件不是kk.ima01,但入庫料件卻是kk.ima01,
           #表示有入聯產品
           IF l_cnt = 0 THEN
               SELECT COUNT(*) INTO l_cnt 
                 #FROM rvu_file,rvv_file,pmn_file	#FUN-CA0094
                 FROM rvv_file,rvu_file,pmn_file	#FUN-CA0094
                WHERE rvu01=rvv01 
                  AND rvu03 BETWEEN l_bdate AND l_edate
                  AND rvu00 = '1' 
                  AND rvuconf='Y' 
                  AND pmn01 = rvv36 
                  AND pmn02 = rvv37 
                  AND rvv31 = kk.ima01
                  AND pmn04 <> rvv31 #采購料件<>入庫料件
               IF l_cnt > 0 THEN 
                  LET kk.ima905='Y'
               END IF
           END IF
           #FUN-A20017--end--add--------
         END IF
        #UPDATE ima_file SET ima57=kk.ima57,ima905=kk.ima905       #CHI-A90001 mark #CHI-C80002
         #UPDATE ima270_tmp SET ima57=kk.ima57,ima905=kk.ima905     #CHI-A90001 add #CHI-C80002
         #   WHERE ima01=kk.ima01
         EXECUTE k270_updtmp_p1 USING kk.ima57,kk.ima905,kk.ima01  #CHI-C80002
         IF SQLCA.sqlcode THEN 
#           CALL cl_err('up_ima',SQLCA.sqlcode,1)   #No.FUN-660127
#            CALL cl_err3("upd","ima_file",kk.ima01,"",SQLCA.sqlcode,"","up_ima",1)   #No.FUN-660127   #No.FUN-710027
            CALL s_errmsg('ima01',kk.ima01,'up_ima',SQLCA.sqlcode,1)                                                 #No.FUN-710027 
            LET g_success='N'
#            EXIT FOREACH             #No.FUN-710027
            CONTINUE FOREACH          #No.FUN-710027
         END IF
         #No.7293 End.A.b.01 -----------------------
      END FOREACH
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
      #CHI-C80002---begin
      LET l_sql = " UPDATE ima270_tmp SET ima57=? ",
                  " WHERE ima01 = ? "
      PREPARE k270_updtmp_p2 FROM l_sql             
      #CHI-C80002---end
#No.FUN-710027--end 
      IF g_argv1= '1' THEN   #MOD-D90118 add   
         CALL p270_nobom()
      END IF    #MOD-D90118 add 
      #No.7293 03/05/26 By Jiunn Add.A.a.01 -----
      IF g_sma.sma104 = 'Y' THEN
         CALL p270_setjp()
      END IF
END FUNCTION
#NO.FUN-570153 end------------
 
FUNCTION p270_nobom()
   DEFINE l_ima01        LIKE ima_file.ima01,
          l_ima57,l_ima57_n,l_ima57_b,s_ima57  LIKE ima_file.ima57,
          l_sfb01        LIKE sfb_file.sfb01,
          l_cnt,l_bomcnt LIKE type_file.num5           #No.FUN-680122 SMALLINT
 
  #LET l_sql = " SELECT ima57,sfb01 FROM sfa_file,sfb_file,ima_file",           #CHI-A90001 mark    
   LET l_sql = " SELECT ima57,sfb01 FROM sfa_file,sfb_file,ima270_tmp",         #CHI-A90001 add 
               " WHERE sfb01=sfa01 AND ima01=sfb05 AND sfa03=? ", 
               " AND sfb81 <= '",l_edate,"'",
               " AND (sfb38 IS NULL OR sfb38 >='",l_bdate,"')",
               " AND sfb87='Y'",
#No.+064 add by Ostrich 010628
               " AND (sfb02<>'11' AND sfb02 <>'13' AND sfb02 <>'15')",
               " ORDER BY ima57" 
    PREPARE k270_sfbpre FROM l_sql
    DECLARE k270_sfbcurs SCROLL CURSOR FOR k270_sfbpre
 
  #LET l_sql = " SELECT min(ima57) FROM sfa_file,sfb_file,ima_file",                #CHI-A90001 mark 
   LET l_sql = " SELECT min(ima57) FROM sfa_file,sfb_file,ima270_tmp",              #CHI-A90001 add 
               " WHERE sfb01=sfa01 AND ima01=sfa03 AND sfb05=? ", 
               " AND sfb81 <= '",l_edate,"'",
               " AND (sfb38 IS NULL OR sfb38 >='",l_bdate,"')",
#No.+064 add by Ostrich 010628
               " AND (sfb02<>'11' AND sfb02 <>'13' AND sfb02 <>'15')",
               " AND sfb87='Y'"
    PREPARE k270_sfbpre2 FROM l_sql
    DECLARE k270_sfbcurs2 CURSOR FOR k270_sfbpre2
 
   DECLARE p270_nobom_cs CURSOR FOR
     #SELECT ima01 FROM ima_file WHERE ima57 = '0'                 #CHI-A90001 mark    
      SELECT ima01 FROM ima270_tmp WHERE ima57 = '0'               #CHI-A90001 add 
   FOREACH p270_nobom_cs INTO l_ima01
      IF STATUS THEN
         LET g_success='N'
#        CALL cl_err('nobom for:',STATUS,1)          #No.FUN-710027 
         CALL s_errmsg('','','nobom for:',STATUS,1)  #No.FUN-710027 
         EXIT FOREACH
      END IF
      #-->
       SELECT count(*) INTO l_bomcnt
         FROM bma_file WHERE bma01 = l_ima01
       IF l_bomcnt > 0 THEN CONTINUE  FOREACH END IF
        
      LET l_ima57 =''          #MOD-750027 add
      LET l_sfb01 =''          #MOD-750027 add
      OPEN k270_sfbcurs USING l_ima01
      FETCH FIRST k270_sfbcurs INTO l_ima57,l_sfb01
      IF STATUS AND STATUS<>100 THEN  #Bugno.6477
         LET g_success='N'
#        CALL cl_err('k270_sfbcurs',STATUS,1)           #No.FUN-710027 
         CALL s_errmsg('','','k270_sfbcurs',STATUS,1)   #No.FUN-710027      
         LET l_ima57 =''       #MOD-750027 add
         LET l_sfb01 =''       #MOD-750027 add
         EXIT FOREACH
      END IF
      CLOSE k270_sfbcurs
      IF not cl_null(l_sfb01) THEN 
         IF l_bomcnt > 0 THEN EXIT FOREACH END IF
             
         OPEN k270_sfbcurs2 USING l_ima01
         FETCH k270_sfbcurs2 INTO l_ima57_b
         IF SQLCA.sqlcode THEN LET l_ima57_b= ' ' END IF
         CLOSE k270_sfbcurs2 
        #MOD-D30195 str add-----
         IF l_ima57_b=0 THEN 
            LET l_ima57_n=0
         ELSE
        #MOD-D30195 end add-----
            IF l_ima57_b > 0 AND not cl_null(l_ima57_b)
            THEN LET l_ima57_n = l_ima57_b - 1
            ELSE LET l_ima57_n = '97'
            END IF
         END IF   #MOD-D30195 add

         #Add by zm 130703 考虑联产品,同时有多个联产品,有被判定为97阶,就要强制其等于主料成本阶
         IF g_sma.sma104 = 'Y' AND l_ima57_n=97 THEN 
            LET s_ima57=''
            SELECT ima57 INTO s_ima57 FROM bmm_file,ima270_tmp
             WHERE bmm01=ima01 AND bmm03=l_ima01
            IF NOT cl_null(s_ima57) THEN LET l_ima57_n=s_ima57 END IF
         END IF
         #End by zm 130703

        #UPDATE ima_file SET ima57 = l_ima57_n  WHERE ima01 = l_ima01            #CHI-A90001 mark  
         #UPDATE ima270_tmp SET ima57 = l_ima57_n  WHERE ima01 = l_ima01          #CHI-A90001 add  #CHI-C80002
         EXECUTE k270_updtmp_p2 USING l_ima57_n,l_ima01  #CHI-C80002
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0  THEN
#           CALL cl_err('upd ima:',STATUS,1)   #No.FUN-660127
#            CALL cl_err3("upd","ima_file",l_ima01,"",STATUS,"","upd ima:",1)   #No.FUN-660127  #No.FUN-710027 
            CALL s_errmsg('ima01',l_ima01,'upd ima',STATUS,1)                                   #No.FUN-710027 
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF
   END FOREACH
END FUNCTION
 
#No.7293 03/05/26 By Jiunn Add.A.a.02 -----
FUNCTION p270_setjp()
  DEFINE l_ima01    LIKE ima_file.ima01,
         l_ima57    LIKE ima_file.ima57
  DEFINE l_ima57_t  LIKE ima_file.ima57   #MOD-C30005 add
  DEFINE l_sfu02    LIKE sfu_file.sfu02
 
  DECLARE p270_setjp_cs CURSOR FOR
  #SELECT sfv04,ima57 FROM sfu_file,sfv_file,sfb_file,ima_file                #CHI-A90001 mark  
   SELECT sfu02,sfv04,ima57 
     #FROM sfu_file,sfv_file,sfb_file,ima270_tmp              #CHI-A90001 add  #FUN-CA0094
     FROM sfv_file,sfu_file,sfb_file,ima270_tmp   #FUN-CA0094
    WHERE sfu01=sfv01 
      AND sfb01=sfv11 
      AND ima01=sfb05
      #AND sfu02 BETWEEN l_bdate AND l_edate     #MOD-510018
      AND sfupost='Y' 
      AND sfb05 <> sfv04
     GROUP BY sfv04,ima57                        #MOD-510018
    ORDER BY ima57 DESC
  FOREACH p270_setjp_cs INTO l_sfu02,l_ima01,l_ima57
   #MOD-C30005 str add-----
   #抓聯產品的成本階,若主產品的成本階比聯產品成本階小的話,就以主產品的成本階為主
    SELECT ima57 INTO l_ima57_t FROM ima270_tmp
     WHERE ima01 = l_ima01
    IF l_ima57_t < l_ima57 THEN
       LET l_ima57 = l_ima57_t
    END IF
   #MOD-C30005 end add-----
   #Add by zm 130703
   IF l_ima57_t > l_ima57 AND l_sfu02<l_bdate THEN
      LET l_ima57 = l_ima57_t
   END IF
   #Add by zm 130703
   #UPDATE ima_file SET ima57 = l_ima57 WHERE ima01=l_ima01       #CHI-A90001 mark      
    #UPDATE ima270_tmp SET ima57 = l_ima57 WHERE ima01=l_ima01    #CHI-A90001 add #CHI-C80002
    EXECUTE k270_updtmp_p2 USING l_ima57,l_ima01  #CHI-C80002
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0  THEN
#     CALL cl_err('upd ima:',STATUS,1)   #No.FUN-660127
#      CALL cl_err3("upd","ima_file",l_ima01,"",STATUS,"","upd ima:",1)   #No.FUN-660127   #No.FUN-710027 
      CALL s_errmsg('ima01',l_ima01,'upd',STATUS,1)                                        #No.FUN-710027 
      LET g_success='N'
      EXIT FOREACH
    END IF
  END FOREACH
  #FUN-A20017--begin--add---
  #委外入聯產品也要判斷
   DECLARE p270_setjp_cs2 CURSOR FOR
  #SELECT rvv31,ima57 FROM rvu_file,rvv_file,sfb_file,ima_file             #CHI-A90001 mark 
   SELECT rvv31,ima57 
     #FROM rvu_file,rvv_file,sfb_file,ima270_tmp           #CHI-A90001 add  #FUN-CA0094
     FROM rvv_file,rvu_file,sfb_file,ima270_tmp   #FUN-CA0094
    WHERE rvu01=rvv01 
      AND sfb01=rvv18 
      AND ima01=sfb05
      AND rvuconf='Y' 
      AND sfb05 <> rvv31
    GROUP BY rvv31,ima57                
    ORDER BY ima57 DESC
  FOREACH p270_setjp_cs2 INTO l_ima01,l_ima57
   #MOD-C30005 str add-----
   #抓聯產品的成本階,若主產品的成本階比聯產品成本階小的話,就以主產品的成本階為主
    SELECT ima57 INTO l_ima57_t FROM ima270_tmp
     WHERE ima01 = l_ima01
    IF l_ima57_t < l_ima57 THEN
       LET l_ima57 = l_ima57_t
    END IF
   #MOD-C30005 end add-----
   #UPDATE ima_file SET ima57 = l_ima57 WHERE ima01=l_ima01       #CHI-A90001 mark   
    #UPDATE ima270_tmp SET ima57 = l_ima57 WHERE ima01=l_ima01     #CHI-A90001 add  #CHI-C80002
    EXECUTE k270_updtmp_p2 USING l_ima57,l_ima01  #CHI-C80002
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0  THEN
      CALL s_errmsg('ima01',l_ima01,'upd',STATUS,1)                                        #No:FUN-710027 
      LET g_success='N'
      EXIT FOREACH
    END IF
  END FOREACH
  #FUN-A20017--end--add----
END FUNCTION
#No.7293 End.A.a.02 -----------------------
 
 
 #No.MOD-4C0087--begin
FUNCTION p270_out()
    DEFINE
        l_sfb01         LIKE sfb_file.sfb01,
        l_sfb05         LIKE sfb_file.sfb05,
        l_ima57         LIKE ima_file.ima57,
        l_ima57b        LIKE ima_file.ima57,
        l_sfa03         LIKE sfb_file.sfb03,
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),               # External(Disk) file name
        l_za05          LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(40)                #
 
    CALL cl_wait()
    CALL cl_outnam('axcp270') RETURNING l_name 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT sfb01,sfb05,ima57 FROM sfb_file,ima_file ",
              " WHERE ima01=sfb05 AND sfb02!=11 AND sfb02 !=8 ",
              "   AND sfb99='N' ",        #MOD-530689
              "   AND (sfb38 IS NULL OR sfb38 >='",l_bdate,"')"                              #MOD-980168 
    PREPARE p270_p1 FROM g_sql      
    DECLARE p270_co CURSOR FOR p270_p1
 
    #LET g_sql="SELECT sfa03 ,ima57 FROM sfa_file,sfb_file,ima_file ",          #NO.FUN-A60080
    LET g_sql="SELECT DISTINCT sfa03,ima57 FROM sfa_file,sfb_file,ima_file ",   #NO.FUN-A60080
              " WHERE sfb01=sfa01 AND ima01=sfa03 ",
              "   AND sfb02!=11 AND sfb02 !=8",
              "   AND sfa01 = ? AND ima57 <= ? ",  #MOD-530689
              "   AND (sfb38 IS NULL OR sfb38 >='",l_bdate,"')"                              #MOD-980168
    PREPARE p270_p2 FROM g_sql      
    DECLARE p270_co2 CURSOR FOR p270_p2
    CALL cl_outnam('axcp270') RETURNING l_name
 
    START REPORT p270_rep TO l_name
 
    FOREACH p270_co INTO l_sfb01,l_sfb05,l_ima57
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        FOREACH p270_co2 USING l_sfb01,l_ima57 INTO l_sfa03,l_ima57b  #MOD-530689
           IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
           END IF
           OUTPUT TO REPORT p270_rep(l_sfb01,l_sfb05,l_ima57,l_sfa03,l_ima57b)
       END FOREACH
    END FOREACH
 
    FINISH REPORT p270_rep
 
    CLOSE p270_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p270_rep(p_sfb01,p_sfb05,p_ima57,p_sfa03,p_ima57b)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),
        p_sfb01         LIKE sfb_file.sfb01,
        p_sfb05         LIKE sfb_file.sfb05,
        l_ima02         LIKE ima_file.ima02, 
        l_ima021        LIKE ima_file.ima021, 
        l_ima02b        LIKE ima_file.ima02, 
        l_ima021b       LIKE ima_file.ima021, 
        p_ima57         LIKE ima_file.ima57,
        p_ima57b        LIKE ima_file.ima57,
        p_sfa03         LIKE sfb_file.sfb03
        
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<','/pageno'
            PRINT g_head CLIPPED,pageno_total
            PRINT 
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37],g_x[38],g_x[39]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            LET l_ima02 = NULL 
            LET l_ima021 = NULL 
            SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
                WHERE ima01=p_sfb05
            IF SQLCA.sqlcode THEN 
                LET l_ima02 = NULL 
                LET l_ima021 = NULL 
            END IF
 
            LET l_ima02b  = NULL 
            LET l_ima021b = NULL 
            SELECT ima02,ima021 INTO l_ima02b,l_ima021b FROM ima_file 
                WHERE ima01=p_sfa03
            IF SQLCA.sqlcode THEN 
                LET l_ima02b = NULL 
                LET l_ima021b = NULL 
            END IF
 
            PRINT COLUMN g_c[31],p_sfb01 CLIPPED,
                  COLUMN g_c[32],p_sfb05 CLIPPED,
                  COLUMN g_c[33],l_ima02 CLIPPED,
                  COLUMN g_c[34],l_ima021 CLIPPED,
                  COLUMN g_c[35],p_ima57, 
                  COLUMN g_c[36],p_sfa03 CLIPPED,
                  COLUMN g_c[37],l_ima02b CLIPPED,
                  COLUMN g_c[38],l_ima021b CLIPPED,
                  COLUMN g_c[39],p_ima57b
 
        ON LAST ROW
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 #MOD-4C0087--end
