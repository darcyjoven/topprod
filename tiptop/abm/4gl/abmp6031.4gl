# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: abmp6031.4gl
# Descriptions...: 低階碼更新巨集作業
# Input parameter: 
# Return code....: 
# Date & Author..: 91/08/19 By Lin
# Modify ........: 92/03/03 增加 [取代料件] (UTE) 的展開
# Modify.........: 92/10/19 目的:五分鐘內執行完本程式 By Apple
# Modify.........: 93/03/07 目的:替代料件的低階碼往後降
# Modify.........: 03/07/15 #No:7591 By Mandy 加上因 ECN變更而生效/失效的排除
# Modify.........: No:FUN-550093 05/06/01 By kim 配方BOM,特性代碼
# Modify.........: No:FUN-5B0085 05/12/13 By Pengu 1.畫面增加計算進度的百分比率，以避免誤認系統當機
                                        #          2.將 PROMPT改CALL cl_confirm()
# Modify.........: No:MOD-560145 05/12/14 By pengu  如果該元件有上階主件,但是已經失效的BOM,就不該再去展階次
# Modify.........: NO.FUN-5C0001 06/01/03 BY yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: No:FUN-610104 06/01/25 By saki 批次作業背景執行功能範例
# Modify.........: No:TQC-660046 06/06/14 By Jackho  cl_err-->cl_err3
# Modify.........: No:TQC-660140 06/07/04 By Pengu 程式中沒有BEGIN WORK 但是卻有 COMMIT WORK
# Modify.........: No:TQC-680091 06/08/21 By kim 程式中沒有BEGIN WORK 但是卻有 COMMIT WORK
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690107 06/10/13 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No:FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No:FUN-710028 07/01/23 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No:TQC-790077 07/09/17 By Carrier '顯示運行過程'='N'時,程序當出
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No:FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No:MOD-8C0066 08/12/08 By claire  msg-028訊息加強顯示
# Modify.........: No:CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No:MOD-950083 09/05/11 By lutingting無法使用p_cron 執行
# Modify.........: No:MOD-930332 09/05/25 By Pengu 料件基本檔有設定主特性代碼時，無法正常算出低階碼
# Modify.........: No:TQC-950184 09/05/31 By xiaofeizhu 調整p603()中l_sw,l_sw_tot的定義
# Modify.........: No:MOD-960049 09/07/22 By lilingyu l_usllc賦值錯誤
# Modify.........: No:TQC-9B0041 09/11/11 By jan 還遠程式
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:MOD-A70205 10/07/28 By Sarah 將p603_cus裡AND (bmd08=? OR bmd08='ALL')條件移除 
# Modify.........: No:TQC-A90011 10/09/03 By lilingyu 低階碼的計算邏輯補充,其中原替代範圍中納入"規格替代範圍"
# Modify.........: No:MOD-AB0050 10/11/05 By sabrina 不管是否勾選顯示歷程，都會出現Error GET: connection refused的錯誤訊息
# Modify.........: No:CHI-A90001 10/11/16 By sabrina 在更新ima_file之前，先將ima_file資料寫入暫存檔裡，以縮短lock時間
# Modify.........: No:MOD-AC0046 10/12/06 By sabrina 不勾選"顯示執行過程"程式會當掉
# Modify.........: No:CHI-B10022 11/03/04 By Pengu 當選則BOM異動才計算時需判斷計算後低階碼是否有小於計算前，若有不允許更新
# Modify.........: No:FUN-B20058 11/03/04 By zhangll 效率优化
# Modify.........: No:MOD-B60046 11/06/08 By Vampire 串到 bma_file 皆須加上 WHERE bmaacti != 'N'
# Modify.........: No:CHI-BC0004 11/12/02 By ck2yuan 使arrno變大  參照aoos010中的最大單身筆數
# Modify.........: No:TQC-BC0193 11/12/30 By zhangll 如果sma845='N'時，tm.a只能等於
# Modify.........: No:MOD-C20076 12/02/08 By ck2yuan 增加index 改善效能
# Modify.........: No:MOD-C20159 12/03/01 By ck2yuan 修改CHI-B10022 bug
# Modify.........: No:TQC-C70210 12/08/03 By suncx 新增abmp6031是abmp603針對Oracle的優化版本，僅適用於oracle數據庫

DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm RECORD
             a          LIKE type_file.chr1,      #No.FUN-680096 CHAR(1)
             max_level  LIKE type_file.num5,      #No.FUN-680096 SMALLINT
             sw         LIKE type_file.chr1       #No.FUN-680096 CHAR(1)
          END RECORD, 
          g_bma01         LIKE bma_file.bma01,    #產品結構單頭
          g_sma18         LIKE sma_file.sma18,    #低階碼是否需重新計算
          g_ans           LIKE type_file.chr1,    #No.FUN-680096 CHAR(1)
          g_date          LIKE type_file.dat,     #No.FUN-680096 DATE
          g_argv1         LIKE type_file.chr1,    #No.FUN-680096 CHAR(1)
          p_row,p_col     LIKE type_file.num5     #No.FUN-680096 SMALLINT

DEFINE   g_chr           LIKE type_file.chr1      #No.FUN-680096 CHAR(1)
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680096 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000   #No.FUN-680096 CHAR(72)
DEFINE   l_flag          LIKE type_file.chr1,     #No.FUN-680096 CHAR(1)
         g_change_lang   LIKE type_file.chr1      #是否有做語言切換 #No.FUN-680096 CHAR(1)
DEFINE   l_ima01         LIKE ima_file.ima01      #CHI-A90001 add
DEFINE   l_ima16         LIKE ima_file.ima16      #CHI-A90001 add
DEFINE   l_ima146        LIKE ima_file.ima146     #CHI-A90001 add
DEFINE   l_ima139        LIKE ima_file.ima139     #CHI-A90001 add
DEFINE   l_ima16_old     LIKE ima_file.ima16      #No:CHI-B10022 add

DEFINE   infor                    STRING
DEFINE   g_logdate,g_logfile      VARCHAR(100)
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				     # Supress DEL key function

   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.a = ARG_VAL(1)
   LET tm.max_level = ARG_VAL(2)
   LET tm.sw = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690107


   IF s_shut(0) THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
      EXIT PROGRAM 
   END IF 


   LET g_date  = TODAY
   
   #建立临时表
   CALL p6031_deal_temp('1')   #add by wangxy 20120724
   
   WHILE TRUE

      LET g_success = 'Y'
     #CHI-A90001---add---start---
      IF g_bgjob = "N" THEN    #No:FUN-610104
         CALL p6031_tm()        #No:FUN-610104
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            #CALL p6031_cur()
            BEGIN WORK         #No:TQC-660140 add
            CALL p6031_t()
            CALL s_showmsg()   #No.FUN-710028
           #CHI-A90001---add---start---
            IF  g_success = 'Y' THEN 
                DECLARE ima603_cur CURSOR FOR 
                SELECT ima01,ima16,ima146,ima139 FROM ima603_tmp
                FOREACH ima603_cur INTO l_ima01,l_ima16,l_ima146,l_ima139
                  IF  SQLCA.sqlcode THEN
                      LET g_success = 'N' 
                      CALL cl_err("FOREACH ima603_cur err",'!','1')
                  END IF 
                 #------------No:CHI-B10022 add
                  IF tm.a = '1' THEN
                     LET l_ima16_old = NULL 
                     SELECT ima16 INTO l_ima16_old FROM ima_file WHERE ima01 = l_ima01
                     IF NOT cl_null(l_ima16_old) THEN 
                        IF l_ima16 < l_ima16_old AND l_ima16_old<>99 THEN  CONTINUE FOREACH END IF  #MOD-C20159 add l_ima16_old<>99
                     END IF
                  END IF
                 #------------No:CHI-B10022 end
                  UPDATE ima_file SET ima16=l_ima16,ima146=l_ima146,ima139=l_ima139
                      WHERE ima01 = l_ima01
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
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CALL p6031_deal_temp('2')   #add by wangxy 20120724
               CONTINUE WHILE
            ELSE
               EXIT WHILE
            END IF
         #fengmy131118---add
         ELSE
            EXIT WHILE
         #fengmy131118---end
         END IF
      ELSE
         #CALL p6031_cur()
         BEGIN WORK #TQC-680091
         CALL p6031_t()
         CALL s_showmsg()   #No.FUN-710028
        #CHI-A90001---add---start---
         IF  g_success = 'Y' THEN 
             DECLARE ima603a_cur CURSOR FOR 
             SELECT ima01,ima16,ima146,ima139 FROM ima603_tmp
             FOREACH ima603a_cur INTO l_ima01,l_ima16,l_ima146,l_ima139
               IF  SQLCA.sqlcode THEN
                   LET g_success = 'N' 
                   CALL cl_err("FOREACH ima603a_cur err",'!','1')
               END IF 
              #------------No:CHI-B10022 add
               IF tm.a = '1' THEN
                  LET l_ima16_old = NULL 
                  SELECT ima16 INTO l_ima16_old FROM ima_file WHERE ima01 = l_ima01
                  IF NOT cl_null(l_ima16_old) THEN 
                     IF l_ima16 < l_ima16_old AND l_ima16_old<>99 THEN  CONTINUE FOREACH END IF   #MOD-C20159 add l_ima16_old<>99
                  END IF
               END IF
              #------------No:CHI-B10022 end
               UPDATE ima_file SET ima16=l_ima16,ima146=l_ima146,ima139=l_ima139
                   WHERE ima01 = l_ima01
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
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   
   CALL p6031_deal_temp('3')   #add by wangxy 20120724
   
   IF g_bgjob = 'N' THEN   #No.MOD-950083                                                                                           
      CLOSE WINDOW p6031_w                                                                                                           
   END IF   #No.MOD-950083 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
END MAIN

FUNCTION p6031_tm()
   DEFINE   lc_cmd   LIKE type_file.chr1000 #No.FUN-680096 CHAR(1000)


   LET p_row = 5 LET p_col = 25

   OPEN WINDOW p6031_w AT p_row,p_col WITH FORM "abm/42f/abmp603" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()
   CLEAR FORM

   INITIALIZE tm.* TO NULL    
   IF g_sma.sma845='Y' THEN 
      LET tm.a='1'
   ELSE 
      LET tm.a='2' 
   END IF
   LET tm.max_level=20   #No.B476 add
   LET tm.sw = 'Y'       #NO.FUN-5C0001 
   LET g_bgjob = "N"     #No:FUN-610104
   #TQC-BC0193 add
   IF g_sma.sma845='N' THEN
      CALL cl_set_comp_entry("a",FALSE)
   END IF
   #TQC-BC0193 add--end
   WHILE TRUE            #No:FUN-610104
      INPUT BY NAME tm.a,tm.max_level,tm.sw,g_bgjob WITHOUT DEFAULTS  #NO.FUN-5B0085 add  #No:FUN-610104 add
      
      
         AFTER FIELD a
            IF tm.a NOT MATCHES "[12]"  OR tm.a IS NULL THEN
               NEXT FIELD a
            END IF
      
         AFTER FIELD max_level 
            IF cl_null(tm.max_level) OR tm.max_level <=0 THEN
               NEXT FIELD max_level
            END IF

         ON CHANGE g_bgjob
            IF g_bgjob = "Y" THEN
               LET tm.sw = "N"
               DISPLAY BY NAME tm.sw
               CALL cl_set_comp_entry("sw",FALSE)
            ELSE
               CALL cl_set_comp_entry("sw",TRUE)
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
        ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
         BEFORE INPUT
             CALL cl_qbe_init()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END INPUT 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p6031_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
         EXIT PROGRAM
      END IF
      SELECT sma18 INTO g_sma18 FROM sma_file WHERE sma00='0'     
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","sma_file",1) # TQC-660046
         LET g_success = 'N'
         EXIT WHILE            #No:FUN-610104
      END IF
      #-->不須再執行重新計算再次確定是否執行
      IF g_sma18='N' THEN  

         IF NOT cl_confirm('mfg2712') THEN
            LET INT_FLAG = 1
            LET g_ans = 'N'   #fengmy131118
         ELSE
            LET INT_FLAG = 0
            LET g_ans = 'Y'
         END IF
#fengmy131118-mark-begin
        #IF INT_FLAG THEN 
        #   LET INT_FLAG = 0 
        #   LET g_ans = 'N'
        #END IF
#fengmy131118-mark-end

         IF g_ans MATCHES "[Nn]" THEN
            CONTINUE WHILE 
         END IF
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "abmp6031"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('abmp6031','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.a CLIPPED,"'",
                         " '",tm.max_level CLIPPED,"'",
                         " '",tm.sw CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abmp6031',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p6031_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
   
FUNCTION p6031_t()
   DEFINE  l_ima01    LIKE ima_file.ima01,
           l_sql      LIKE type_file.chr1000,  #No.FUN-680096 CHAR(200)
           l_success  LIKE type_file.chr1      #No.FUN-680096 CHAR(1)

    IF g_bgjob = "N" THEN
       CALL cl_wait()
    END IF

    CASE tm.a
         WHEN '1'
              SELECT COUNT(*) INTO g_cnt FROM ima_file  
               WHERE ima146='Y' OR ima146='0'
             #CHI-A90001---modify---start---
             #UPDATE ima_file SET ima16=0 
             # WHERE ima146='Y' OR ima146='0'
              DELETE FROM ima603_tmp
              INSERT INTO ima603_tmp
              SELECT ima01,ima16,ima37,ima139,ima146 FROM ima_file
               WHERE ima146='Y' OR ima146='0'
              UPDATE ima603_tmp SET ima16=0 
               WHERE ima146='Y' OR ima146='0'
             #CHI-A90001---modify---end---
              IF STATUS OR sqlca.sqlerrd[3]<>g_cnt
              THEN CALL cl_err('UPDATE ima16',STATUS,1)
                   LET l_success='N'
                   LET g_success="N"    #No:FUN-610104
                   RETURN
              END IF
         WHEN '2'
              SELECT COUNT(*) INTO g_cnt FROM ima_file WHERE 1=1
             #CHI-A90001---modify---start---
             #UPDATE ima_file SET ima16=0 ,ima146='' WHERE 1=1
             #IF STATUS OR sqlca.sqlerrd[3]<>g_cnt
              DELETE FROM ima603_tmp
              INSERT INTO ima603_tmp
              SELECT ima01,ima16,ima37,ima139,ima146 FROM ima_file
               WHERE 1=1 
              UPDATE ima603_tmp SET ima16=0 ,ima146='' WHERE 1=1
             #CHI-A90001---modify---end---
              IF STATUS OR sqlca.sqlerrd[3]<>g_cnt
              THEN CALL cl_err('UPDATE ima16',STATUS,1)
                   LET l_success='N'
                   LET g_success="N"    #No:FUN-610104
                   RETURN
              END IF
         OTHERWISE EXIT CASE
    END CASE
    #-->OPC 為MPS 時將ima139 = 'Y'
   #UPDATE ima_file SET ima139 ='Y' WHERE ima37 = '1'               #CHI-A90001 mark  
    UPDATE ima603_tmp SET ima139 ='Y' WHERE ima37 = '1'             #CHI-A90001 add 
    IF SQLCA.sqlcode 
    THEN 
         CALL cl_err3("upd","ima_file","","",SQLCA.sqlcode,"","update ima139",1)  # TQC-660046
         LET g_success = "N"            #No:FUN-610104
    END IF

    #------------------- 主程開始 ---------------------------
    CALL p6031()
    IF tm.a='1' THEN
      #SELECT COUNT(*) INTO g_cnt FROM ima_file          #CHI-A90001 mark  
       SELECT COUNT(*) INTO g_cnt FROM ima603_tmp        #CHI-A90001 add 
        WHERE ima146='Y'
       IF g_cnt=0 THEN
         #UPDATE ima_file SET ima146='' WHERE ima146='0'         #CHI-A90001 mark  
          UPDATE ima603_tmp SET ima146='' WHERE ima146='0'       #CHI-A90001 add 
       END IF
    END IF
    SET LOCK MODE TO WAIT
    UPDATE sma_file SET sma18='N' WHERE sma00='0' 
    IF SQLCA.sqlcode THEN 
       CALL s_errmsg('sma18','0','sma_file end',SQLCA.sqlcode,1)               #No.FUN-710028
       LET g_success = "N"       #No:FUN-610104
    END IF
END FUNCTION
---------------------mod by chenjpa----------------------------
FUNCTION p6031()
   DEFINE l_sql                                   VARCHAR(2000),            
          l_cnt,l_cnt2,l_cnt3,l_remain_cnt,l_max_level   INTEGER, 
          l_time                                  VARCHAR(8),
          l_level,l_unlock_time                   SMALLINT,
          l_start,l_end                           DATE,
          l_begin,l_tot_begin                     DATETIME HOUR TO SECOND,
          l_cmd                                   STRING,
          l_base_parent,l_base_child              LIKE ima_file.ima01,
          l_yy,l_mm                               INTEGER,
          l_curdate                               STRING,
          l_ty                                    CHAR(4),
          l_ima01                                 LIKE ima_file.ima01,
          l_tm                                    CHAR(2)


   #LET g_logdate = YEAR(CURRENT) USING "####",MONTH(CURRENT) USING "&&",DAY(CURRENT) USING "&&","-",TIME(CURRENT)
   #LET g_logfile = "/u1/out/abmp6031-"||g_user||"-"||g_dbs||"-"||g_logdate||'.log'
   LET infor = ''

   LET l_tot_begin = TIME(CURRENT)
   CALL p6031_log('开始时间 : '||l_tot_begin||'\n从ima_file中获取资料...')
   
   INSERT INTO tmp_ima SELECT ima01 FROM ima603_tmp
   IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
      CALL cl_err('IMA_FILE -> TMP_IMA :',SQLCA.sqlcode,1) 
   END IF
   
   SELECT COUNT(*) INTO l_cnt FROM tmp_ima
   CALL p6031_log(l_cnt||'笔,完毕! 用时:'||TIME(CURRENT)-l_tot_begin||'\n从bmb_file中取得父子关系...')
   LET l_begin = TIME(CURRENT)
 
 
   #从bmb_file中取资料填充父子关系表
   LET l_sql = "INSERT INTO tmp_child ",
               "  SELECT DISTINCT bmb01 parent, bmb03 child, 'BMB' origin ",
               "    FROM bmb_file, bma_file ",
               "   WHERE bmb01 = bma01 ",
               "     AND bma06 = bmb29 ",
               "    AND bmaacti = 'Y' ",
               "    AND (bmb04 <= '",g_today,"' OR bmb04 IS NULL) ",
               "    AND (bmb05 > '",g_today,"' OR bmb05 IS NULL) ",
               "    AND bmb01 <> bmb03 "
   PREPARE p6031_bmb FROM l_sql
   EXECUTE p6031_bmb 
   IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
      CALL cl_err('BMB_FILE -> TMP_CHILD :',SQLCA.sqlcode,1) 
   END IF

   SELECT COUNT(*) INTO l_cnt FROM tmp_child
   CALL p6031_log(l_cnt||'笔,完毕! 用时:'||TIME(CURRENT)-l_begin||'\n从bmd_file中取得父子关系...')
   LET l_begin = TIME(CURRENT)

   #从bmd_file中取资料填充父子关系表
   LET l_sql = " INSERT INTO tmp_child ",
               "   SELECT DISTINCT bmd08 parent, bmd04 child, 'BMD' origin FROM bmd_file ",
               "    WHERE (bmd05 <= '",g_today,"' OR bmd05 IS NULL) ",
               "      AND (bmd06 > '",g_today,"' OR bmd06 IS NULL ) ",
               "      AND bmd08 <> bmd04 ",
               "      AND NOT EXISTS ( SELECT 1 FROM tmp_child WHERE bmd08 = parent AND bmd04 =child ) ",
               "      AND bmdacti='Y' "
   PREPARE p6031_bmd FROM l_sql
   EXECUTE p6031_bmd 
   IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
      CALL cl_err('BMD_FILE -> TMP_CHILD :',SQLCA.sqlcode,1) 
   END IF
  
  #从bon_file,ima_file中取资料填充父子关系表   
   LET l_sql = " INSERT INTO tmp_child ",
               "   SELECT DISTINCT bon02 parent, ima01 child, 'BON' origin ",
               "   FROM ima_file,bon_file",  
               "  WHERE imaacti = 'Y'",
               "    AND bonacti = 'Y'",
               "    AND ima251 = bon06",
               "    AND ima022 BETWEEN bon04 AND bon05",
               "    AND ima109 = bon07", 
               "    AND ima54 = bon08", 
               "    AND ima01 != bon01 ",
               "    AND (bon09 <= '",g_today,"' OR bon09 IS NULL)",
               "    AND (bon10 >  '",g_today,"' OR bon10 IS NULL)",
               "    AND bon02 <> ima01 ",
               "    AND NOT EXISTS ( SELECT 1 FROM tmp_child WHERE bon02 = parent AND ima01 =child ) "
   PREPARE p6031_bon FROM l_sql
   EXECUTE p6031_bon 
   IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
      CALL cl_err('BMD_FILE -> TMP_CHILD :',SQLCA.sqlcode,1) 
   END IF

   #这一步是安全性防范措施
   #因为虽然理论上不会出现在BOM或工单中存在IMA中不存在的料，但如果万一数据中有紊乱，这种状况可能会造成死循环，所以要提前剔除
   DELETE FROM tmp_child WHERE NOT EXISTS
     ( SELECT 1 FROM tmp_ima WHERE t_ima01 = parent )
 
   #add by yf2002 090803 begin
   
   #从0阶料开始展
   LET l_level = 0
   #计算笔数并提示执行过程
   CALL p6031_log('\n开始展第'||l_level||'阶料...')
   LET l_begin = TIME(CURRENT)

   #开始主循环
   #循环内容，剥离顶层料件（即只存在于单头而不存在于单身的料件）
   #被剥离出来的料件被暂存与sub_ima中，并会被从tmp_ima,tmp_bma,tmp_child中删除
   #当某次剥离出来发现结果集为空时，说明已经没有顶层料件，此时如果tmp_ima中为空，则表示低阶码运算结束
   #否则说明有循环存在，tmp_ima中为涉及循环的料件

   LET l_unlock_time = 0    #如果当下面l_cnt = 0 但 tmp_ima数量 <> 0的时候，如果l_unlock_time = 0，表示正常展阶，>0均表示在解套
   
   WHILE TRUE

         #找出有单头无单身的料件
         
         SELECT COUNT(*) INTO l_remain_cnt FROM tmp_ima
         
         INSERT INTO sub_ima SELECT t_ima01 AS s_ima01 FROM tmp_ima
           WHERE NOT EXISTS ( SELECT 1 FROM tmp_child WHERE child = t_ima01 )
           
         INSERT INTO tmp_parent SELECT parent s_parent,ima139 s_ima139
                FROM (SELECT parent,child FROM tmp_child 
                       WHERE EXISTS(SELECT 1 FROM sub_ima WHERE parent=s_ima01)) x,
                     ima603_tmp y
               WHERE x.child=y.ima01 AND y.ima139='Y'  
               
         IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
            CALL cl_err('INSERT INTO sub_ima:',SQLCA.sqlcode,1) 
         END IF
         
         SELECT COUNT(*) INTO l_cnt FROM sub_ima
         CALL p6031_log(l_cnt||'笔')
         
         #如果当前没有了则要判断是出现循环还是全部执行完毕
         
         IF l_cnt =0 THEN
            IF l_remain_cnt = 0 THEN
               LET g_success = 'Y'
            ELSE
               LET g_success = 'N'
               DECLARE ima01_cur CURSOR FOR 
                SELECT t_ima01 FROM tmp_ima
               FOREACH ima01_cur INTO l_ima01
                 CALL s_errmsg('ima01',l_ima01,'p6031_cur',SQLCA.sqlcode,0) 
               END FOREACH
            END IF
            EXIT WHILE
         END IF

        #更新这些料号的低阶码
        UPDATE ima603_tmp set ima16 = l_level,ima146 = ''
          WHERE EXISTS ( SELECT 1 FROM sub_ima WHERE ima01 = s_ima01 ) 
        IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
           CALL cl_err('update_ima:',SQLCA.sqlcode,1) 
        END IF
        
        UPDATE ima603_tmp set ima139='Y'
          WHERE EXISTS ( SELECT 1 FROM tmp_parent WHERE ima01 = s_parent)
            AND ima139!='Y' 
        IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
           CALL cl_err('update_ima:',SQLCA.sqlcode,1) 
        END IF        

        #把这些料号从基准表中剔除掉，同时从关系表中剔除掉以其为父料件的关系记录
        DELETE FROM tmp_ima WHERE EXISTS (SELECT 1 FROM sub_ima WHERE s_ima01 = t_ima01)
        DELETE FROM tmp_child WHERE EXISTS ( SELECT 1 FROM sub_ima WHERE s_ima01 = parent )


        #清空sub_ima
        LET l_sql= "DELETE FROM sub_ima" 
        PREPARE del_sub_ima FROM l_sql
        EXECUTE del_sub_ima

        #清空tmp_parent
        LET l_sql= "DELETE FROM tmp_parent" 
        PREPARE del_tmp_parent FROM l_sql
        EXECUTE del_tmp_parent
        #低阶码循环累加
        LET l_level=l_level+1 

        CALL p6031_log(',完毕! 用时:'||TIME(CURRENT)-l_begin||'\n开始展第'||l_level||'阶料...')
        LET l_begin = TIME(CURRENT)

     END WHILE

     CALL p6031_log(',完毕! 用时:'||TIME(CURRENT)-l_begin||'\n删除临时表...')
     LET l_begin = TIME(CURRENT)

     CALL p6031_log('完毕！用时:'||TIME(CURRENT) - l_begin||'\n本次执行总耗时:'||TIME(CURRENT) - l_tot_begin)


END FUNCTION
 
FUNCTION p6031_deal_temp(p_flag)
   DEFINE p_flag  LIKE type_file.chr1,
          l_sql   STRING     
	   #创建临时表
  
   CASE p_flag
        WHEN '1'
   	         CREATE TEMP TABLE ima603_tmp(
               ima01   LIKE ima_file.ima01,
               ima16   LIKE ima_file.ima16,
               ima37   LIKE ima_file.ima37,
               ima139  LIKE ima_file.ima139,
               ima146  LIKE ima_file.ima146)
             #CHI-A90001---add---end---

             CREATE INDEX ima603_index ON ima603_tmp(ima01)   #MOD-C20076 add
             
             CREATE TEMP TABLE tmp_ima(
             t_ima01 LIKE ima_file.ima01)
             CREATE UNIQUE INDEX tmp_ima_01 ON tmp_ima(t_ima01)
             
             CREATE TEMP TABLE tmp_child(
                parent LIKE ima_file.ima01,
                child LIKE ima_file.ima01,
                origin LIKE type_file.chr3)
             CREATE UNIQUE INDEX tmp_child_01 ON tmp_child(parent,child)
             CREATE INDEX tmp_child_02 ON tmp_child(child)
             
             CREATE TEMP TABLE sub_ima(
             s_ima01 LIKE ima_file.ima01)
             CREATE UNIQUE INDEX sub_ima_01 ON sub_ima(s_ima01)
             
             CREATE TEMP TABLE tmp_parent(
             s_parent LIKE ima_file.ima01,
             s_ima139 LIKE ima_file.ima139)
        WHEN '2'
             #删除临时表中数据
             LET l_sql= "TRUNCATE TABLE ima603_tmp" 
             PREPARE del_ima603_tmp FROM l_sql
             EXECUTE del_ima603_tmp
             
             LET l_sql= "TRUNCATE TABLE sub_ima" 
             PREPARE tru_sub_ima FROM l_sql
             EXECUTE tru_sub_ima
             
             LET l_sql= "TRUNCATE TABLE tmp_ima" 
             PREPARE del_tmp_ima FROM l_sql
             EXECUTE del_tmp_ima
             
             LET l_sql= "TRUNCATE TABLE tmp_child" 
             PREPARE del_tmp_child FROM l_sql
             EXECUTE del_tmp_child
             
             LET l_sql= "TRUNCATE TABLE tmp_parent" 
             PREPARE tru_tmp_parent FROM l_sql
             EXECUTE tru_tmp_parent             
        WHEN '3'
             #drop临时表,之所以先TRUNCATE,是由于TRUNCATE掉数据然后DROP表比本身DROP表速度要快
             LET l_sql= "TRUNCATE TABLE ima603_tmp" 
             PREPARE drop_ima603_tmp FROM l_sql
             EXECUTE drop_ima603_tmp
             DROP TABLE ima603_tmp
             
             LET l_sql= "TRUNCATE TABLE sub_ima" 
             PREPARE drop_sub_ima FROM l_sql
             EXECUTE drop_sub_ima
             DROP TABLE sub_ima
             
             LET l_sql= "TRUNCATE TABLE tmp_ima" 
             PREPARE drop_tmp_ima FROM l_sql
             EXECUTE drop_tmp_ima
             DROP TABLE tmp_ima
             
             LET l_sql= "TRUNCATE TABLE tmp_child" 
             PREPARE drop_tmp_child FROM l_sql
             EXECUTE drop_tmp_child
             DROP TABLE tmp_child   
             
             LET l_sql= "TRUNCATE TABLE tmp_parent" 
             PREPARE drop_tmp_parent FROM l_sql
             EXECUTE drop_tmp_parent
             DROP TABLE tmp_parent
                           
   END CASE
END FUNCTION
 
FUNCTION p6031_log(l_input)
DEFINE l_cmd,l_input  STRING
             
   #如果当前是有界面，则将执行过程显示在界面上
   LET infor = infor,l_input
   IF g_bgjob = 'N' THEN
      MESSAGE infor
      CALL ui.Interface.refresh()
   END IF
   #写日志文件
   #LET l_cmd = "echo '",infor,"' > ",g_logfile
   #RUN l_cmd
END FUNCTION  
#-----------☉ 程式處理邏輯 ☉--------------------1991/08/03(Lee)-
#FUNCTION p6031()
#   DEFINE l_name   LIKE type_file.chr20,  # External(Disk) file name  #No.FUN-680096 CHAR(20)
#          l_sql2   LIKE type_file.chr1000,# RDSQL STATEMENT    #No.FUN-680096 CHAR(200)
#          l_sql    LIKE type_file.chr1000,# RDSQL STATEMENT    #No.FUN-680096 CHAR(600)
#          l_n      LIKE type_file.num10,  # ima_file read count   #No.FUN-680096 INTEGER
#          l_cnt    LIKE type_file.num10,  #No:FUN-5B0085 add   #No.FUN-680096 INTEGER
#          l_cnt1   LIKE type_file.num10,  #No:FUN-5B0085 add   #No.FUN-680096 INTEGER
#          l_sw     LIKE type_file.num10,  #TQC-950184                                                                               
#          l_sw_tot LIKE type_file.num10,  #TQC-950184
#          l_ima16  LIKE ima_file.ima16, 
#          l_ima139 LIKE ima_file.ima139, 
#          l_bmb03  LIKE bmb_file.bmb03,
#          l_bma01  LIKE bma_file.bma01,
#          l_bma06  LIKE bma_file.bma06,   #FUN-550093 
#          l_count  LIKE type_file.num5    #No.FUN-680096 SMALLINT
#
#     # 組合SQL,只讀取 level=0 (最終產品) 的主件資料, 而並非讀取所有的主件
#     # 因為, 只要取得 level=0 的主件, 即可展開全部的相關資料
#     CASE tm.a
#         WHEN '1'
#              LET l_sql2 = " SELECT ima01,ima16,ima139,bma06", #FUN-550093
#                         #"  FROM ima_file, bma_file",           #CHI-A90001 mark   
#                          "  FROM ima603_tmp, bma_file",         #CHI-A90001 add 
#                          "  WHERE ima01 = bma01 AND ima146 ='0' ",
#			  "  AND bmaacti != 'N' ",               #MOD-B60046 add
#                          "  ORDER BY 1"      
#         WHEN '2'
#              LET l_sql2 = " SELECT ima01,ima16,ima139,bma06", #FUN-550093
#                         #"  FROM ima_file, bma_file",           #CHI-A90001 mark   
#                          "  FROM ima603_tmp, bma_file",         #CHI-A90001 add 
#                          "  WHERE ima01 = bma01 AND ima16 =0 ",
#                          #Add No:FUN-B20058
#                          "   AND bmaacti='Y' ",
#                          "   AND ima01 NOT IN(SELECT bmb03 FROM bmb_file,bma_file ",
#                          "                     WHERE bmb01=bma01 AND bmaacti='N' ",
#                          "                       AND (bmb04<='",g_today,"' OR bmb04 IS NULL) ",
#                          "                       AND (bmb05 > '",g_today,"' OR bmb05 IS NULL))",
#                          #End Add No:FUN-B20058
#                          "  ORDER BY 1"      
#     END CASE
#     LET l_cnt=0
#     CASE tm.a
#        WHEN '1' SELECT COUNT(*) INTO l_sw_tot #NO.FUN-5C0001
#                  #FROM ima_file,bma_file WHERE ima01=bma01 AND ima146 ='0'             #CHI-A90001 mark  
#                  #FROM ima603_tmp,bma_file WHERE ima01=bma01 AND ima146 ='0'           #CHI-A90001 add    #MOD-B60046 mark 
#                   FROM ima603_tmp,bma_file WHERE ima01=bma01 AND ima146 ='0' AND bmaacti != 'N'           #MOD-B60046 add 
#        WHEN '2' SELECT COUNT(*) INTO l_sw_tot  #NO.FUN-5C0001
#                  #FROM ima_file,bma_file WHERE ima01=bma01 AND ima146 ='0'             #CHI-A90001 mark  
#                  #Mod No:FUN-B20058
#                  #FROM ima603_tmp,bma_file WHERE ima01=bma01 AND ima146 ='0'           #CHI-A90001 add 
#                   FROM ima603_tmp,bma_file WHERE ima01=bma01 AND ima16 ='0'           #CHI-A90001 add 
#                    AND bmaacti='Y'
#                    AND ima01 NOT IN(SELECT bmb03 FROM bmb_file,bma_file 
#                                      WHERE bmb01=bma01 AND bmaacti='N' 
#                                        AND (bmb04<=g_today OR bmb04 IS NULL) 
#                                        AND (bmb05 >g_today OR bmb05 IS NULL))
#                  #End Mod No:FUN-B20058
#     END CASE
#     IF tm.sw = 'N' AND g_bgjob = "N" THEN      #No:FUN-610104
#         LET l_count = 1  #NO.FUN-5C0001 ADD
#         IF l_sw_tot>0 THEN
#             IF l_sw_tot > 10 THEN
#                 LET l_sw = l_sw_tot /10
#
#                     CALL cl_progress_bar(10)
#              ELSE
#                 CALL cl_progress_bar(l_sw_tot)
#              END IF
#         END IF
#     END IF
#
#     PREPARE p6031_pre FROM l_sql2
#     DECLARE p6031_curs1 
#         SCROLL CURSOR FOR p6031_pre
#     IF SQLCA.sqlcode THEN
#	 CALL cl_err('Declare:',SQLCA.sqlcode,1) 
#         LET g_success = 'N'
#         IF tm.sw = 'N' AND g_bgjob = "N" THEN CALL cl_close_progress_bar() END IF #NO.FUN-5B0085 add   #No:FUN-610104
#         RETURN
#     END IF
# 
#     LET l_sql = "SELECT bmb03 FROM bmb_file ",
#                 " WHERE bmb03 = ? ",
#                 "    AND (bmb04 <='",g_today,
#                 "'    OR bmb04 IS NULL) AND (bmb05 >'",g_today,
#                 "'    OR bmb05 IS NULL)",
#                 " ORDER BY 1 "
#
#     PREPARE p6031_prepare FROM l_sql 
#     DECLARE p6031_cnt   
#         SCROLL CURSOR FOR p6031_prepare
#     IF SQLCA.sqlcode THEN
#	 CALL cl_err('Declare_cnt:',SQLCA.sqlcode,1) 
#         LET g_success = 'N'
#         IF tm.sw = 'N' AND g_bgjob = "N" THEN CALL cl_close_progress_bar() END IF #NO.FUN-5B0085 add  #No:FUN-610104
#         RETURN
#     END IF
#     
#     SET LOCK MODE TO WAIT
#     IF g_argv1 != 'Y' OR g_bgjob = "N" THEN          #No:FUN-610104
#         MESSAGE 'Extract Data...' 
#         CALL ui.Interface.refresh()
#     END IF
#     CALL s_showmsg_init()    #No.FUN-710028
#     FOREACH p6031_curs1 INTO l_bma01,l_ima16,l_ima139,l_bma06 #FUN-550093
#       IF SQLCA.sqlcode THEN
#
#          CALL s_errmsg('','','F1:',SQLCA.sqlcode,0) 
#          LET g_success='N'
#          EXIT FOREACH
#       END IF
#       IF g_success='N' THEN                                                                                                         
#          LET g_totsuccess='N'                                                                                                       
#          LET g_success="Y"                                                                                                          
#       END IF                                                                                                                        
#
#       LET l_cnt1=l_cnt1+1  #NO.FUN-5B0085 add
#       OPEN p6031_cnt USING l_bma01
#       FETCH FIRST p6031_cnt INTO l_bmb03
#       IF SQLCA.sqlcode = 100 THEN
#          LET g_bma01=l_bma01
# Prog. Version..: '5.30.06-13.03.12(0,l_bma01,l_ima139,l_bma06) #FUN-550093
#       END IF
#       IF tm.sw = 'N' AND g_bgjob = "N" THEN    #No:FUN-610104
#          IF l_sw_tot > 10 THEN  #筆數合計
#             IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
#                 CALL cl_progressing(" ")
#             END IF
#             IF (l_cnt1 mod l_sw) = 0 AND l_count < 10 THEN
#                  CALL cl_progressing(" ")
#                  LET l_count = l_count + 1    #No.TQC-790077
#             END IF
#          ELSE
#              IF l_sw_tot > 0 THEN         #MOD-AC0046 add
#                 CALL cl_progressing(" ")
#              END IF                       #MOD-AC0046 add
#          END IF
#       END IF
#
#     END FOREACH
#     IF g_totsuccess="N" THEN                                                                                                        
#        LET g_success="N"                                                                                                            
#     END IF                                                                                                                          
#
#     CLOSE p6031_cnt 
#     
#     IF g_argv1 IS NULL OR g_argv1 !='Y' THEN
#        ERROR ""
#     END IF
#END FUNCTION
#   
#FUNCTION p6031_cur()
# DEFINE  l_cmd   LIKE type_file.chr1000  #No.FUN-680096  CHAR(600)
#
#    LET l_cmd=
#        " SELECT unique bmb03,'0',ima16,ima139 ",
#        "   FROM bmb_file,ima_file",
#        "  WHERE bmb01= ? ",
#        "    AND bmb03 = ima01",
#        "    AND bmb29 = ? ", #FUN-550093
#        "    AND (bmb04 <='",g_today,
#        "'    OR bmb04 IS NULL) AND (bmb05 >'",g_today,
#        "'    OR bmb05 IS NULL)",
#        " ORDER BY 2,1 " CLIPPED
#    PREPARE p6031_ppp FROM l_cmd
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('P1:',SQLCA.sqlcode,1) 
#       LET g_success = 'N'
#       RETURN
#    END IF
#    DECLARE p6031_cur CURSOR WITH HOLD FOR p6031_ppp
# 
#    #--->包含取/替代料件
#    LET l_cmd=
#        " SELECT bmd04,bmd02,ima16 ", 
#       #"   FROM bmd_file,ima_file ",    #MOD-C20076 mark
#        "   FROM bmd_file,ima603_tmp ",  #MOD-C20076 add
#        "  WHERE bmd01= ? ",
#        "    AND (bmd05 <='",g_today,"' OR bmd05 IS NULL) ", #No:6595
#        "    AND (bmd06  >'",g_today,"' OR bmd06 IS NULL) ",
#        "    AND ima16 < ? ",
#        "    AND bmd04=ima01 ",
#       #"    AND (bmd08=? OR bmd08='ALL') ",  #MOD-A70205 mark
#        "    AND bmdacti = 'Y'"                                           #CHI-910021
##TQC-A90011 --begin--
#       ," UNION",
#        " SELECT ima01,bon13,ima16",
#        "   FROM ima_file,bon_file",  
#        "  WHERE imaacti = 'Y'",
#        "    AND bon01 = ? ",
#        "    AND ima16 < ? ",
#        "    AND bonacti = 'Y'",
#        "    AND ima251 = bon06",
#        "    AND ima022 BETWEEN bon04 AND bon05",
#        "    AND ima109 = bon07", 
#        "    AND ima54 = bon08", 
#        "    AND ima01 != bon01 ",
#        "    AND (bon09 <= '",g_today,"' OR bon09 IS NULL)",
#        "    AND (bon10 >  '",g_today,"' OR bon10 IS NULL)"
##TQC-A90011 --end--        
#    PREPARE p6031_pus FROM l_cmd
#    IF SQLCA.sqlcode THEN
#       CALL cl_err('US:',SQLCA.sqlcode,1) 
#       LET g_success = 'N'
#       RETURN
#    END IF
#    DECLARE p6031_cus CURSOR WITH HOLD FOR p6031_pus
#  
#END FUNCTION
#   
#FUNCTION p6031_bom(p_level,p_key,p_ima139,p_acode) #FUN-550093
#   DEFINE p_level   LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          p_key	    LIKE bma_file.bma01,    #主件料件編號
#          p_ima139  LIKE ima_file.ima139,   #MPS 計算否
#          p_acode   LIKE bma_file.bma06,    #FUN-550093
#          l_ac,l_i  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          l_ac2     LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          l_usllc   LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          arrno	    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          b_seq	    LIKE type_file.num5,    #No.FUN-680096 SMALLINT
#          l_chr     LIKE type_file.chr1,    #No.FUN-680096 CHAR(1)
#          sr DYNAMIC ARRAY OF RECORD          #每階存放資料 No.+229 mod
#              bmb03  LIKE bmb_file.bmb03,  #元件料號
#              bmb16  LIKE bmb_file.bmb16,  #是否有取替代
#              ima16  LIKE ima_file.ima16,  #低階碼
#              ima139 LIKE ima_file.ima139  #MPS 計算否
#          END RECORD,
#          l_tot     LIKE type_file.num5,   #No.FUN-680096 SMALLINT
#          l_bma01   LIKE bma_file.bma01,
#          l_bmb03   LIKE bmb_file.bmb03,
#          l_cmd		STRING,        #No.FUN-680096
#          l_n       LIKE type_file.num10         #No.FUN-680096 INTEGER
#   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No:FUN-8B0015 
#
#    LET p_level = p_level + 1
#
#
#    IF p_level > tm.max_level  THEN         #No.B476 mod
#        CALL s_errmsg('bmb03',p_key,'','mfg-028',1) #No.MOD-8C0066
#        LET g_success = 'N'
#        RETURN
#    END IF
#    
#  #LET arrno = 999   #No.+229 mod         #CHI-BC0004 mark
#  SELECT aza34 INTO arrno FROM aza_file   #CHI-BC0004 add
#  WHILE TRUE
#     LET l_ac = 1
#     FOREACH p6031_cur 
#     USING p_key,  #,p_level
#           p_acode #FUN-550093
#     INTO sr[l_ac].*
#        IF SQLCA.sqlcode THEN
#           CALL s_errmsg('','','p6031_cur',SQLCA.sqlcode,0) #No.FUN-710028
#           EXIT FOREACH
#        END IF
#        IF tm.sw ='Y' AND g_bgjob = "N" THEN    #No:FUN-610104
#            message sr[l_ac].bmb03
#            CALL ui.Interface.refresh()
#        END IF
#       #MOD-AB0050---mark---start---
#       #IF g_bgjob = "N" THEN                  #No:FUN-610104
#       #   message sr[l_ac].bmb03
#       #END IF                                 #No:FUN-610104
#       #MOD-AB0050---mark---end---
#        CALL ui.Interface.refresh()
#       #UPDATE ima_file SET ima16=p_level,ima146=''            #CHI-A90001 mark 
#        UPDATE ima603_tmp SET ima16=p_level,ima146=''          #CHI-A90001 add 
#         WHERE ima01=sr[l_ac].bmb03 AND ima16 < p_level 
#         LET l_ima910[l_ac]=''
#         SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
#         IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF 
#        LET l_ac2 = l_ac + 1
#        #-->取替代資料
#       #FOREACH p6031_cus USING sr[l_ac].bmb03,p_level,p_key INTO sr[l_ac2].*  #MOD-A70205 mark
#        FOREACH p6031_cus USING sr[l_ac].bmb03,p_level,sr[l_ac].bmb03,p_level INTO sr[l_ac2].*        #MOD-A70205
#                                                            #TQC-A90011 add bmb03,p_level
#           IF SQLCA.sqlcode THEN
#              CALL s_errmsg('','','p6031_cus',SQLCA.sqlcode,1)  #No.FUN-710028
#              EXIT FOREACH
#    	   END IF
#           IF sr[l_ac2].ima16 > p_level THEN 
#              LET l_usllc = sr[l_ac2].ima16    #MOD-960049
#           ELSE 
#              LET l_usllc = p_level
#           END IF 
#          #UPDATE ima_file SET ima16=l_usllc,ima146=''           #CHI-A90001 mark       
#           UPDATE ima603_tmp SET ima16=l_usllc,ima146=''         #CHI-A90001 add 
#             WHERE ima01=sr[l_ac2].bmb03 AND ima16 < l_usllc 
#            IF tm.sw ='Y' AND g_bgjob = "N" THEN     #No:FUN-610104
#                message sr[l_ac2].bmb03
#                CALL ui.Interface.refresh()
#            END IF
#           #MOD-AB0050---mark---start---
#           #IF g_bgjob = "N" THEN                   #No:FUN-610104
#           #   message sr[l_ac2].bmb03
#           #END IF                                  #No:FUN-610104
#           #MOD-AB0050---mark---end---
#            CALL ui.Interface.refresh()
#           LET l_ima910[l_ac2]=''
#           SELECT ima910 INTO l_ima910[l_ac2] FROM ima_file WHERE ima01=sr[l_ac2].bmb03
#           IF cl_null(l_ima910[l_ac2]) THEN LET l_ima910[l_ac2]=' ' END IF
#            LET l_ac2 = l_ac2 + 1 
#            LET l_ac = l_ac + 1
#            IF l_ac > arrno THEN EXIT FOREACH END IF
#        END FOREACH
# 
#        LET l_ac = l_ac + 1			   # 但BUFFER不宜太大
#        IF l_ac > arrno THEN EXIT FOREACH END IF
#    END FOREACH
#	LET l_tot=l_ac-1
#    FOR l_i = 1 TO l_tot			# 讀BUFFER傳給REPORT
# 
#           IF sr[l_i].ima139 = 'Y' AND p_ima139 != 'Y'
#          #THEN UPDATE ima_file SET ima139 = 'Y' WHERE ima01 = p_key         #CHI-A90001 mark  
#           THEN UPDATE ima603_tmp SET ima139 = 'Y' WHERE ima01 = p_key       #CHI-A90001 add 
#           END IF
#           SELECT count(*) INTO l_n FROM bma_file 
#                           WHERE bma01 = sr[l_i].bmb03
#                                 AND bma06=l_ima910[l_i]
#                                 AND bmaacti != 'N'              #MOD-B60046 add
#           #-->L.L.C 再計算一次(1.主件 2.取代 3.替代)
#           IF l_n !=0  THEN 
#                CALL p6031_bom(p_level,sr[l_i].bmb03,sr[l_i].ima139,l_ima910[l_i]) #FUN-8B0015
#           END IF
#           IF g_success = 'N' THEN EXIT FOR END IF
#     END FOR  
#     IF l_tot < arrno OR l_tot=0 THEN 
#        EXIT WHILE
#     ELSE
#        CALL cl_getmsg('mfg2645',g_lang) RETURNING g_msg
#        LET g_msg  = g_msg  clipped,' part:',g_bma01 clipped
#            LET INT_FLAG = 0  ######add for prompt bug
#        PROMPT  g_msg CLIPPED  FOR l_chr
#           ON IDLE g_idle_seconds
#              CALL cl_on_idle()
# 
#            ON ACTION about         #MOD-4C0121
#               CALL cl_about()      #MOD-4C0121
# 
#            ON ACTION help          #MOD-4C0121
#               CALL cl_show_help()  #MOD-4C0121
# 
#            ON ACTION controlg      #MOD-4C0121
#               CALL cl_cmdask()     #MOD-4C0121
# 
#        END PROMPT
#        IF INT_FLAG THEN
#           LET INT_FLAG = 0
#        END IF
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690107
#        EXIT PROGRAM
#     END IF
#  END WHILE
#END FUNCTION
#No:FUN-9C0077
#TQC-C70210
