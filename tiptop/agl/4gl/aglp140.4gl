# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: aglp140.4gl
# Descriptions...: 內部成本分錄產生作業
# Date & Author..: 06/07/20 By Sarah
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/18 By yjkhero 錯誤訊息匯整 
# Modify.........: No.FUN-740020 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.FUN-8A0086 08/10/20 By zhaijie添加LET g_success = 'N'
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0005 09/10/07 By Smapmin 異動碼預設為NULL而非一個空白
# Modify.........: No.CHI-9A0021 09/10/16 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法 
# Modify.........: No.FUN-A60056 10/07/08 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056問題
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.CHI-C30119 12/04/24 By belle SQL資料來源改取tlfc_file
# Modify.........: No:MOD-C50128 12/05/18 By Polly 調整抓取發料單、退料單sql抓取
# Modify.........: No.FUN-D10065 13/01/17 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/22 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.FUN-D40105 13/08/22 By yangtt sr數組少加了一个欄位


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql      STRING       
DEFINE tm RECORD
       yy              LIKE type_file.num5,           #年度 #No.FUN-680098    SMALLINT     
       mm              LIKE type_file.num5,           #月份  #No.FUN-680098   SMALLINT       
       v_no            LIKE npp_file.npp01  #單據號碼
       END RECORD
DEFINE g_npp           RECORD LIKE npp_file.*
DEFINE g_npq           RECORD LIKE npq_file.*
DEFINE g_cnt           LIKE type_file.num5          #No.FUN-680098    SMALLINT     
DEFINE g_i             LIKE type_file.num5          #No.FUN-680098    SMALLINT
DEFINE g_flag          LIKE type_file.chr1          #No.FUN-680098    VARCHAR(1)
DEFINE g_gl            LIKE type_file.chr1          #No.FUN-680098    VARCHAR(1)     
DEFINE l_flag          LIKE type_file.chr1,         #No.FUN-680098    VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,         #No.FUN-680098    VARCHAR(1)     
       ls_date         STRING 
DEFINE g_bookno1       LIKE aza_file.aza81   #No.FUN-740020
DEFINE g_bookno2       LIKE aza_file.aza82   #No.FUN-740020
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy   = ARG_VAL(1)                      
   LET tm.mm   = ARG_VAL(2)                      
   LET tm.v_no = ARG_VAL(3)                      
   LET g_bgjob = ARG_VAL(4)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   #No.FUN-740020  --Begin
   CALL s_get_bookno(tm.yy)
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(tm.yy,'aoo-081',1)
   END IF
   #No.FUN-740020  --End  
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = "N" THEN
         CALL p140_ask()
         IF cl_sure(18,20) THEN 
            BEGIN WORK
            CALL p140()
            CALL s_showmsg()               #NO.FUN-710023
            CASE
                 WHEN g_success = 'Y' AND g_gl = 'Y'
                      COMMIT WORK
                      CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
                 WHEN g_success = 'Y' AND g_gl = 'N'
                      ROLLBACK WORK
                      CALL cl_err('','axc-034',1)             #無資料產生
                      CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
                 OTHERWISE
                      ROLLBACK WORK
                      CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END CASE
         ELSE
            CONTINUE WHILE
         END IF
     
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p140_w
            EXIT WHILE
         END IF
         CLOSE WINDOW p140_w
      ELSE
         BEGIN WORK
         CALL p140()
         CALL s_showmsg()                #NO.FUN-710023 
         CASE
             WHEN g_success = 'Y' AND g_gl = 'Y'
                  COMMIT WORK
             OTHERWISE
                  ROLLBACK WORK
         END CASE
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION p140_ask()
   DEFINE l_za05        LIKE za_file.za05             #No.FUN-680098 VARCHAR(40)
   DEFINE l_cnt         LIKE type_file.num5           #No.FUN-680098 SMALLINT
   DEFINE lc_cmd        LIKE type_file.chr1000        #No.FUN-680098 VARCHAR(500)               
   DEFINE l_str         LIKE type_file.chr20          #No.FUN-680098 VARCHAR(10)        
  #DEFINE l_max         LIKE npp_file.npp01           #CHI-C30119 mark #No.FUN-680098 VARCHAR(10)        
   DEFINE l_max         LIKE type_file.num20          #CHI-C30119        
 
   OPEN WINDOW p140_w WITH FORM "agl/42f/aglp140"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CLEAR FORM
   #讀取成本現行結算年月
   SELECT ccz01,ccz02 INTO tm.yy,tm.mm FROM ccz_file
    WHERE ccz00='0'
   LET g_bgjob = 'N'
   WHILE TRUE
      INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS HELP 1
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               NEXT FIELD yy
            END IF
         AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               NEXT FIELD mm
            END IF
           #IF cl_null(tm.v_no) THEN       #CHI-C30119 mark
               LET l_str= tm.yy USING '&&&&',tm.mm USING '&&','0001'
               LET tm.v_no=l_str
               #-->check 是否存在
               SELECT COUNT(*) INTO l_cnt FROM npp_file
                WHERE npp01 = tm.v_no AND nppsys = 'CC' AND npptype= '0'
                  AND npp00 = 1       AND npp011= 1
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt > 0 THEN
                  LET l_str = tm.v_no[1,6]
                  SELECT MAX(npp01) INTO l_max FROM npp_file
                   WHERE npp01[1,6] = l_str AND nppsys = 'CC' AND npptype= '0'
                     AND npp00 = 1          AND npp011 = 1
                  LET l_max = l_max +1
                  LET tm.v_no = l_max
               END IF
           #END IF    #CHI-C30119 mark
            DISPLAY BY NAME tm.v_no #ATTRIBUTE(YELLOW)   #TQC-8C0076
            IF NOT cl_null(tm.v_no) THEN
               #-->check 是否存在
               SELECT COUNT(*) INTO l_cnt FROM npp_file
                WHERE npp00  = 1
                  AND npp01  = tm.v_no
                  AND npp011 = 1
                  AND nppsys = 'CC'
                  AND npptype= '0'
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt > 0 THEN
                  CALL cl_err(tm.v_no,'afa-368',0)
               END IF
            END IF
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
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
 
         ON ACTION locale                          #FUN-570153
            LET g_change_lang = TRUE
            EXIT INPUT                      
 
      END INPUT
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         CLOSE WINDOW p140_w     
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM           
      END IF
 
      #No.FUN-740020  --Begin
      CALL s_get_bookno(tm.yy)
           RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag =  '1' THEN  #抓不到帳別
         CALL cl_err(tm.yy,'aoo-081',1)
      END IF
      #No.FUN-740020  --End  
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = "aglp140"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('aglp140','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.yy CLIPPED ,"'",
                         " '",tm.mm CLIPPED ,"'",
                         " '",tm.v_no CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aglp140',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p140()
   DEFINE sr   RECORD
                tlf01   LIKE tlf_file.tlf01,
                tlf06   LIKE tlf_file.tlf06,
                tlf13   LIKE tlf_file.tlf13,
                tlf902  LIKE tlf_file.tlf902,
                tlf930  LIKE tlf_file.tlf930,
                amt     LIKE npq_file.npq07, 
                tlfccost LIKE tlfc_file.tlfccost  #FUN-D40105 add
               END RECORD
   DEFINE sr1  RECORD
                npq03   LIKE npq_file.npq03,   #科目
                npq04   LIKE npq_file.npq04,   #摘要
                npq05   LIKE npq_file.npq05,   #部門
                npq06   LIKE npq_file.npq06,   #借貸(1/2)
                npq07f  LIKE npq_file.npq07f,  #原幣金額
                npq07   LIKE npq_file.npq07    #本幣金額
               END RECORD
   DEFINE l_amt         LIKE npq_file.npq07
   DEFINE l_bdate       LIKE type_file.dat     #CHI-9A0021 add
   DEFINE l_edate       LIKE type_file.dat     #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1    #CHI-9A0021 add
   DEFINE l_azw01       LIKE azw_file.azw01    #FUN-A60056
   DEFINE l_ahi06       LIKE ahi_file.ahi06    #CHI-C30119
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
 
   IF cl_null(tm.v_no) THEN
      LET tm.v_no = tm.yy USING '&&&&',tm.mm USING '&&','0001'
   END IF
 
   #建立TempTable
   DROP TABLE p140_tmp
#FUN-680098-BEGING
   CREATE TEMP TABLE p140_tmp(
      npq03 LIKE npq_file.npq03,
      npq04 LIKE npq_file.npq04,
      npq05 LIKE npq_file.npq05,
      npq06 LIKE npq_file.npq06,
      npq07f LIKE npq_file.npq07f,
      npq07 LIKE npq_file.npq07)
#FUN-680098-END    
   #insert npp_file 單頭資料 --------------------------------
   LET g_npp.nppsys = 'CC'        #成本中心
   LET g_npp.npp00  = 1           #1.內部成本   
   LET g_npp.npp01  = tm.v_no
   LET g_npp.npp011 = 1
   LET g_npp.npp02  = g_today
   LET g_npp.npp03  = NULL
   LET g_npp.npp06  = g_plant
   LET g_npp.nppglno= NULL
   LET g_npp.npptype= '0'
   LET g_npp.npplegal= g_legal  #FUN-980003 add g_legal
 
   DELETE FROM npp_file
    WHERE nppsys = 'CC'
      AND npp00  = 1
      AND npp01  = tm.v_no
      AND npp011 = 1
      AND npptype= '0'
      AND (nppglno=' ' OR nppglno IS NULL)
 
   INSERT INTO npp_file VALUES(g_npp.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      LET g_success = 'N' RETURN
   END IF
   IF g_bgjob = 'N' THEN
      MESSAGE g_npp.npp01
   END IF
 
   #insert npq_file 單身資料 --------------------------------
   DELETE FROM npq_file
    WHERE npqsys = 'CC'
      AND npq00  = 1
      AND npq01  = tm.v_no
      AND npq011 = 1
      AND npqtype= '0'
   IF STATUS THEN LET g_success = 'N' RETURN END IF
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = tm.v_no
   IF STATUS THEN LET g_success = 'N' RETURN END IF
   #FUN-B40056--add--end--
 
  #當月起始日與截止日
   #CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add #CHI-A70007 mark
   #CHI-A70007 add --start--
   CALL s_get_bookno(tm.yy) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_aza.aza63 = 'Y' THEN
      IF g_npp.npptype = '0' THEN
         CALL s_azmm(tm.yy,tm.mm,g_plant,g_bookno1) RETURNING l_correct,l_bdate,l_edate
      ELSE
         CALL s_azmm(tm.yy,tm.mm,g_plant,g_bookno2) RETURNING l_correct,l_bdate,l_edate
      END IF
   ELSE
      CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_bdate,l_edate
   END IF
   #CHI-A70007 add --end--
 
  #FUN-A60056--add--str--
   LET g_sql = "SELECT azw01 FROM azw_file",
               " WHERE azwacti = 'Y' AND azw02 = '",g_legal,"'"
   PREPARE sel_azw_pre FROM g_sql
   DECLARE sel_azw_cur CURSOR FOR sel_azw_pre
   FOREACH sel_azw_cur INTO l_azw01
  #FUN-A60056--add--end
  #CHI-C30119--
  #LET g_sql="SELECT tlf01,tlf06,tlf13,tlf902,tlf930,SUM(tlf10*tlf60*tlf907*ahi05)",
  #         #FUN-A60056--mod--str--
  #         #"  FROM tlf_file LEFT OUTER JOIN ahi_file ON YEAR(tlf06) =ahi_file.ahi01 AND MONTH(tlf06)=ahi_file.ahi02 AND tlf01=ahi_file.ahi03",
  #          "  FROM ",cl_get_target_table(l_azw01,'tlf_file'),
  #          "  LEFT OUTER JOIN ahi_file ON YEAR(tlf06) =ahi_file.ahi01 AND MONTH(tlf06)=ahi_file.ahi02 AND tlf01=ahi_file.ahi03",
  #         #FUN-A60056--mod--end
  #         #CHI-9A0021 -- begin
  #         #" WHERE YEAR(tlf06) =",tm.yy,
  #         #"   AND MONTH(tlf06)=",tm.mm,
  #          " WHERE tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
  #         #CHI-9A0021 -- end
  #          "   AND (tlf13 LIKE 'asfi51*'  OR",   #領料
  #          "        tlf13 LIKE 'asfi52*'  OR",   #退料
  #          "        tlf13 LIKE 'asri21*'  OR",   #領料
  #          "        tlf13 LIKE 'asri22*'  OR",   #退料
  #          "        tlf13 = 'asft6201'       OR",   #生產入庫
  #          "        tlf13 = 'asrt320'        OR",   #生產入庫
  #          "        tlf13 = 'axmt620'        OR",   #銷貨
  #          "        tlf13 = 'axmt650'        OR",   #銷貨
  #          "        tlf13 = 'aomt800')",            #銷退
  #          " GROUP BY tlf01,tlf06,tlf13,tlf902,tlf930",
  #          " ORDER BY tlf01,tlf06,tlf13,tlf902,tlf930"
   SELECT ahi06 INTO l_ahi06 FROM ahi_file WHERE ahi01 = tm.yy AND ahi02 = tm.mm
   IF cl_null(l_ahi06) THEN LET l_ahi06 = '1' END IF
   LET g_sql="SELECT tlf01,tlf06,tlf13,tlf902,tlf930,SUM(tlf10*tlf60*tlf907*ahi05),tlfccost",
          "  FROM ",cl_get_target_table(l_azw01,'tlfc_file'),",",cl_get_target_table(l_azw01,'tlf_file'),
          "  LEFT OUTER JOIN ahi_file ON YEAR(tlf06) =ahi_file.ahi01 AND MONTH(tlf06)=ahi_file.ahi02 AND tlf01=ahi_file.ahi03",
          " WHERE tlf06 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
         #-------------------------MOD-C50128-----------------------(S)
         #"   AND (tlf13 LIKE 'asfi51*'  OR",   #領料  #MOD-C50128 mark
         #"        tlf13 LIKE 'asfi52*'  OR",   #退料  #MOD-C50128 mark
         #"        tlf13 LIKE 'asri21*'  OR",   #領料  #MOD-C50128 mark
         #"        tlf13 LIKE 'asri22*'  OR",   #退料  #MOD-C50128 mark
          "   AND (tlf13 LIKE 'asfi51%'  OR",   #領料
          "        tlf13 LIKE 'asfi52%'  OR",   #退料
          "        tlf13 LIKE 'asri21%'  OR",   #領料
          "        tlf13 LIKE 'asri22%'  OR",   #退料
         #-------------------------MOD-C5012i8-----------------------(E)
          "        tlf13 = 'asft6201'    OR",   #生產入庫
          "        tlf13 = 'asrt320'     OR",   #生產入庫
          "        tlf13 = 'axmt620'     OR",   #銷貨
          "        tlf13 = 'axmt650'     OR",   #銷貨
          "        tlf13 = 'aomt800')",         #銷退
          "   AND tlf01  = tlfc01  AND tlf02  = tlfc02  AND tlf03 = tlfc03",
          "   AND tlf06  = tlfc06  AND tlf13  = tlfc13  AND tlf902 = tlfc902",
          "   AND tlf903 = tlfc903 AND tlf904 = tlfc904 AND tlf905 = tlfc905",
          "   AND tlf906 = tlfc906 AND tlf907 = tlfc907",
          "   AND tlfctype = '",l_ahi06,"'",
          " GROUP BY tlf01,tlf06,tlf13,tlf902,tlf930,tlfccost",
          " ORDER BY tlf01,tlf06,tlf13,tlf902,tlf930,tlfccost"
  #CHI-C30119--
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A60056
   CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql   #FUN-A60056 
   PREPARE p140_prepare FROM g_sql
   DECLARE p140_cs CURSOR WITH HOLD FOR p140_prepare
   IF g_bgjob = 'N' THEN 
      MESSAGE 'Working!! Wait Moment..'
   END IF
   CALL s_showmsg_init()                       #NO.FUN-710023
   FOREACH p140_cs INTO sr.*
      IF STATUS THEN
        CALL cl_err('p140(foreach):',STATUS,1)
        LET g_success ='N'       #FUN-8A0086
        EXIT FOREACH
      END IF
#NO.FUN-710023--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710023--END 
      IF cl_null(sr.tlf930) THEN CONTINUE FOREACH END IF
      #Dr  內部成本
      LET sr1.npq03 = g_aaz.aaz91   #利潤中心內部成本科目
      CASE 
         WHEN sr.tlf13[1,6]='asfi51' OR sr.tlf13[1,6]='asfi52' OR
              sr.tlf13[1,6]='asri21' OR sr.tlf13[1,6]='asri22'
              CALL cl_getmsg('agl-931',g_lang) RETURNING sr1.npq04   #領用
              LET sr1.npq05 = sr.tlf930
         WHEN sr.tlf13='asft6201' OR sr.tlf13='asrt320'
              CALL cl_getmsg('asf-851',g_lang) RETURNING sr1.npq04   #入庫
              SELECT imd16 INTO sr1.npq05 FROM imd_file
               WHERE imd01 = sr.tlf902
              IF cl_null(sr1.npq05) THEN LET sr1.npq05=' ' END IF
         WHEN sr.tlf13='axmt620' OR sr.tlf13='axmt650' OR sr.tlf13='aomt800'
              CALL cl_getmsg('agl-932',g_lang) RETURNING sr1.npq04   #銷售
              LET sr1.npq05 = sr.tlf930
      END CASE
      CALL p140_chk_aag05(sr1.npq03,sr1.npq05) RETURNING sr1.npq05
      LET sr1.npq06 = '1'   #借 
      IF sr.amt < 0 THEN 
         LET l_amt = sr.amt*-1
      ELSE
         LET l_amt = sr.amt
      END IF
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      LET sr1.npq07f = l_amt     
      LET sr1.npq07  = l_amt     
      INSERT INTO p140_tmp VALUES(sr1.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         IF g_bgjob= 'N' THEN
            ERROR 'error d1' 
         END IF
      END IF
 
      #Cr  內部收入
      LET sr1.npq03 = g_aaz.aaz92   #利潤中心內部收入科目
      CASE 
         WHEN sr.tlf13[1,6]='asfi51' OR sr.tlf13[1,6]='asfi52' OR
              sr.tlf13[1,6]='asri21' OR sr.tlf13[1,6]='asri22'
              CALL cl_getmsg('agl-931',g_lang) RETURNING sr1.npq04   #領用
              SELECT imd16 INTO sr1.npq05 FROM imd_file
               WHERE imd01 = sr.tlf902
              IF cl_null(sr1.npq05) THEN LET sr1.npq05=' ' END IF
         WHEN sr.tlf13='asft6201' OR sr.tlf13='asrt320'
              CALL cl_getmsg('asf-851',g_lang) RETURNING sr1.npq04   #入庫
              LET sr1.npq05 = sr.tlf930
         WHEN sr.tlf13='axmt620' OR sr.tlf13='axmt650' OR sr.tlf13='aomt800'
              CALL cl_getmsg('agl-932',g_lang) RETURNING sr1.npq04   #銷售
              SELECT imd16 INTO sr1.npq05 FROM imd_file
               WHERE imd01 = sr.tlf902
              IF cl_null(sr1.npq05) THEN LET sr1.npq05=' ' END IF
      END CASE
      CALL p140_chk_aag05(sr1.npq03,sr1.npq05) RETURNING sr1.npq05
      LET sr1.npq06 = '2'   #貸 
      IF sr.amt < 0 THEN 
         LET l_amt = sr.amt*-1
      ELSE
         LET l_amt = sr.amt
      END IF
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      LET sr1.npq07f = l_amt     
      LET sr1.npq07  = l_amt     
      INSERT INTO p140_tmp VALUES(sr1.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         IF g_bgjob= 'N' THEN
            ERROR 'error d2' 
         END IF
      END IF
 
      #FUN-A70139--add--str--
      IF cl_null(sr.amt) THEN 
         LET sr.amt = 0
      END IF 
      #FUN-A70139--add--end
      #將sr.amt寫入tlf931
     #FUN-A60056--mod--str--
     #UPDATE tlf_file SET tlf931 = sr.amt
     # WHERE tlf01=sr.tlf01 AND tlf06 =sr.tlf06 
     #   AND tlf13=sr.tlf13 AND tlf902=sr.tlf902
      LET g_sql = "UPDATE ",cl_get_target_table(l_azw01,'tlf_file'),
                 #"   SET tlf931 = '",sr.amt,"'",   #FUN-A70084
                  "   SET tlf931 = ",sr.amt,        #FUN-A70084
                  " WHERE tlf01='",sr.tlf01,"' AND tlf06 ='",sr.tlf06,"'",
                  "   AND tlf13='",sr.tlf13,"' AND tlf902='",sr.tlf902,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql
      PREPARE upd_tlf FROM g_sql
      EXECUTE upd_tlf
     #FUN-A60056--mod--end
   END FOREACH
 END FOREACH    #FUN-A60056
#NO.FUN-710023--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710023--END
 
 
   DECLARE p140_tmp_cs CURSOR FOR
      SELECT npq03,npq04,npq05,npq06,SUM(npq07f),SUM(npq07)
        FROM p140_tmp
       GROUP BY npq06,npq04,npq03,npq05
       ORDER BY npq04,npq06,npq03,npq05
 
   INITIALIZE sr1.* TO NULL
   LET g_gl = 'N'
 
   LET g_npq.npq02  = 0
   FOREACH p140_tmp_cs INTO sr1.*
      IF STATUS THEN
#        CALL cl_err('foreach temp table',STATUS,1)           #NO.FUN-710023
         CALL s_errmsg(' ',' ','foreach temp table',STATUS,1) #NO.FUN-710023 
         EXIT FOREACH
      END IF
      LET g_gl = 'Y'   #判斷有無產生成本分錄資料
 
      LET g_npq.npqsys = 'CC'
      LET g_npq.npq00  = 1
      LET g_npq.npq01  = tm.v_no
      LET g_npq.npq011 = 1
      LET g_npq.npq02  = g_npq.npq02+1
      LET g_npq.npq03  = sr1.npq03   #科目
      LET g_npq.npq04  = NULL                 #FUN-D10065  add
      #LET g_npq.npq04  = sr1.npq04   #摘要   #FUN-D10065  mark
      LET g_npq.npq05  = sr1.npq05   #部門
      LET g_npq.npq06  = sr1.npq06   #借/貸
      CALL cl_digcut(sr1.npq07f,g_azi04) RETURNING g_npq.npq07f
      IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
      CALL cl_digcut(sr1.npq07 ,g_azi04) RETURNING g_npq.npq07
      IF cl_null(g_npq.npq07)  THEN LET g_npq.npq07  = 0 END IF
      LET g_npq.npq08  = ' '
      LET g_npq.npq11  = ''   #MOD-9A0005
      LET g_npq.npq12  = ''   #MOD-9A0005
      LET g_npq.npq13  = ''   #MOD-9A0005
      LET g_npq.npq14  = ''   #MOD-9A0005
      LET g_npq.npq15  = ' '
      LET g_npq.npq21  = ' '
      LET g_npq.npq22  = ' '
      LET g_npq.npq23  = NULL
      LET g_npq.npq24  = g_aza.aza17    #本幣幣別
      LET g_npq.npq25  = 1
      LET g_npq.npq30  = g_plant
      LET g_npq.npqtype= '0'
      LET g_npq.npqlegal= g_legal #FUN-980003 add g_legal

      #FUN-D10065--add--str--
      CALL s_def_npq3(g_bookno1,g_npq.npq03,g_prog,g_npq.npq01,'','')
      RETURNING g_npq.npq04
      IF cl_null(g_npq.npq04) THEN
         LET g_npq.npq04  = sr1.npq04
      END IF
      #FUN-D10065--add--end--
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno1
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno1) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES(g_npq.*)
      IF STATUS THEN
         DISPLAY 'INSERT npq_file Fail..'
         IF g_bgjob = 'N' THEN
            DISPLAY 'INSERT npq_file Fail..'
         END IF
      END IF
   END FOREACH
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
   IF g_bgjob = 'N' THEN 
      DISPLAY ' '
   END IF 
END FUNCTION
 
FUNCTION p140_chk_aag05(l_npq03,l_npq05)
    DEFINE l_npq03 LIKE npq_file.npq03
    DEFINE l_npq05 LIKE npq_file.npq05
    DEFINE l_aag05 LIKE aag_file.aag05
 
    #本科目是否作部門明細管理
    LET l_aag05 = ''
    SELECT aag05 INTO l_aag05 FROM aag_file
     WHERE aag01 = l_npq03 
       AND aag00 = g_bookno1  #No.FUN-740020
    IF cl_null(l_aag05) THEN LET l_aag05 = NULL END IF
    IF l_aag05 = 'N' THEN
       LET l_npq05=NULL
    END IF
 
    RETURN l_npq05
END FUNCTION
