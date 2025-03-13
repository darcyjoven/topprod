# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: afap120.4gl
# Descriptions...: 折舊傳票底稿產生
# Date & Author..: 96/11/07 by nick
# Modify.........: No.MOD-4A0184 04/10/13 By Kitty 若金額為0則不INSERT
# Modify.........: No.FUN-570144 06/03/02 By yiting 批次作業背景執行
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/22 By day 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710028 07/01/16 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-740026 07/04/11 By mike   會計科目加帳套
# Modify.........: No.MOD-7B0173 07/11/21 By Smapmin 調整帳別抓取
# Modify.........: No.MOD-7C0123 07/12/18 By Smapmin 修改變數定義
# Modify.........: No.MOD-8A0084 08/10/08 By Sarah 語言別切換有問題
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-920103 09/02/07 By Sarah 產生分錄時應判斷科目做不做部門管理,要的話再寫入部門欄位
# Modify.........: No.MOD-930080 09/03/06 By shiwuying Order by 調整
# Modify.........: No.MOD-970073 09/07/09 By mike npp02的值應抓會計期間的截止日期    
# Modify.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0005 09/10/07 By Smapmin 異動碼預設為NULL而非一個空白
# Modify.........: No.TQC-9B0039 09/11/10 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:CHI-A30029 10/03/25 by Summer 資料過濾條件增加 fan19 IS NOT NULL 
# Modify.........: No:CHI-A40046 10/05/03 by Summer 延續CHI-A30029,若單據編號改成已經產生過的單號,
#                                                   則會因為fan19已有資料而無法重新產生 
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,使用npptype判斷使用g_bookno1,g_bookno2給予npp02
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-AC0143 10/12/17 By Carrier 调整DROP语句的位置,以便其不影响TRANSACTION的完整性
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:CHI-B50013 11/05/13 By Dido 次帳別幣別應為 aaa03
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:MOD-B80302 11/08/30 By Dido 單別會與12類衝突,因此單別前增加10區隔
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No.FUN-D10065 13/01/17 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE tm RECORD
        fan03    LIKE fan_file.fan03,
       fan04    LIKE fan_file.fan04,
       v_no     LIKE npp_file.npp01
       END RECORD
DEFINE g_fan   RECORD LIKE fan_file.*
DEFINE g_npp   RECORD LIKE npp_file.*
DEFINE g_npq   RECORD LIKE npq_file.*
DEFINE p_row,p_col      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_flag           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
       g_change_lang   LIKE type_file.chr1,                 #No.FUN-570144 是否有做語言切換       #No.FUN-680070 VARCHAR(01)
       ls_date         STRING                  #No.FUN-570144
DEFINE g_bookno1        LIKE aza_file.aza81          #No.FUN-740026
DEFINE g_bookno2        LIKE aza_file.aza82          #No.FUN-740026 
DEFINE g_bookno         LIKE aza_file.aza82          #No.FUN-D40118   Add 
DEFINE g_flag           LIKE type_file.chr1          #No.FUN-740026 
DEFINE begin_no         LIKE type_file.chr1          #NO.CHI-A30029
DEFINE g_wc1    string     #No:FUN-AB0088
DEFINE g_aaa03  LIKE aaa_file.aaa03                  #CHI-B50013

MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0069
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
#->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)
   LET tm.fan03 = ARG_VAL(2)
   LET tm.fan04 = ARG_VAL(3)
   LET tm.v_no  = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF
#->No.FUN-570144 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570144 START---
#   OPEN WINDOW p120_w AT p_row,p_col WITH FORM "afa/42f/afap120"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
#NO.FUN-570144 END---
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
#NO.FUN-570144 START---
#   BEGIN WORK 
#   WHILE TRUE 
#     LET g_success='Y'
#     CALL p120()
#     IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
#     #IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
#           IF g_success='Y' THEN
#              COMMIT WORK
#              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#           ELSE
#              ROLLBACK WORK
#              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#           END IF
#           IF l_flag THEN
#              CONTINUE WHILE
#           ELSE
#              EXIT WHILE
#           END IF
#   END WHILE
#   CLOSE WINDOW p120_w
   WHILE TRUE
     IF g_bgjob = "N" THEN
        CALL p120()
        IF cl_sure(18,20) THEN
           LET g_success = 'Y'
           BEGIN WORK
           #No.FUN-680028--begin
#          CALL p120_process()
           CALL p120_process('0')
           ##----No.FUN-B60140 mark----
        #  #IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
           #IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #No:FUN-AB0088 
           ##  CALL p120_process('1')
           #   LET g_wc1= cl_replace_str(g_wc,'fan','fbn')   #No:FUN-AB0088
           #   CALL p120_process1('1')   #No:FUN-AB0088 
           #END IF
           ##----No.FUN-B60140 mark---end----
           #No.FUN-680028--end  
           CALL s_showmsg()          #No.FUN-710028
           IF g_success='Y' THEN
              COMMIT WORK
              DROP TABLE p120_tmp    #No.FUN-680028
              #DROP TABLE p120_tmp1   #No:FUN-AB0088 #No:FUN-B60140 mark
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              #No.MOD-AC0143  --Begin
              #DROP TABLE p120_tmp    #No.FUN-680028
              ROLLBACK WORK
              DROP TABLE p120_tmp
              #DROP TABLE p120_tmp1   #No:FUN-AB0088 #No:FUN-B60140 Mark
              #No.MOD-AC0143  --End  
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p120_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        #No.FUN-680028--begin
#       CALL p120_process()
        CALL p120_process('0')
     #  IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
        ##-----No:FUN-B60140 Mark-----
        #IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #No:FUN-AB0088 
        ##  CALL p120_process('1')
        #   LET g_wc1= cl_replace_str(g_wc,'fan','fbn')   #No:FUN-AB0088
        #   CALL p120_process1('1')   #No:FUN-AB0088
        #END IF
        ##-----No:FUN-B60140 Mark END-----
        #No.FUN-680028--end  
        CALL s_showmsg()          #No.FUN-710028
        IF g_success = "Y" THEN
           COMMIT WORK
	   DROP TABLE p120_tmp    #No.FUN-680028
           #DROP TABLE p120_tmp1   #No:FUN-AB0088 #No:FUN-B60140 mark
        ELSE
           ROLLBACK WORK
	   DROP TABLE p120_tmp    #No.FUN-680028
           #DROP TABLE p120_tmp1   #No:FUN-AB0088  #No:FUN-B60140 mark
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
#->No.FUN-570144 ---end---
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p120()
   DEFINE   l_name    LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
   DEFINE   l_cmd     LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(30)
   DEFINE   l_str     LIKE type_file.chr20           #No.FUN-680070 VARCHAR(10)
   DEFINE   l_yy      LIKE type_file.chr4            #No.FUN-680070 VARCHAR(4)
   DEFINE   l_mm      LIKE type_file.chr2            #No.FUN-680070 VARCHAR(2)
   DEFINE   l_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_max     LIKE type_file.num20,     #No:8065          #No.FUN-680070 VARCHAR(10)   #MOD-7C0123
            l_aag05   LIKE aag_file.aag05,
            l_date    LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE   sr        RECORD
            order1    LIKE fan_file.fan121,       #No.FUN-680070 VARCHAR(30)
            fan       RECORD LIKE fan_file.*,
            faj54     LIKE faj_file.faj54      #累積折舊
                      END RECORD
 
   DEFINE   li_result LIKE type_file.num5         #No.FUN-570144       #No.FUN-680070 SMALLINT
   DEFINE   lc_cmd    LIKE type_file.chr1000     #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
 
    #No.MOD-470568
   DROP TABLE p120_tmp    #No.FUN-680028
   #No.TQC-9B0039  --Begin
   #SELECT 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' order1, fan_file.*, faj54
   #       ,fan06 fan061,fan06 fan062,                 #MOD-920103 add
   #       'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' order2   #MOD-920103 add
   #  FROM fan_file,faj_file
   # WHERE fan01 = faj02 AND fan02=faj022
   #   AND fan01 = '@@@@@'
   #  INTO TEMP p120_tmp
   SELECT chr50 order1, fan_file.*, faj54
          ,fan06 fan061,fan06 fan062,                 #MOD-920103 add
          chr50 order2   #MOD-920103 add
     FROM fan_file,faj_file,type_file
    WHERE fan01 = faj02 AND fan02=faj022
      AND 1=0
      AND fan01 = '@@@@@'
     INTO TEMP p120_tmp
   #No.TQC-9B0039  --End  
   IF STATUS THEN
#     CALL cl_err('create tmp120',STATUS,1)   #No.FUN-660136
      CALL cl_err3("sel","fan_file,faj_file,","","",STATUS,"","create tmp120",1)   #No.FUN-660136
   END IF
   DELETE FROM p120_tmp
    #No.MOD-470568 (end)
 
   ##-----No:FUN-B60140 Mark-----
   #-----No:FUN-AB0088-----
   #DROP TABLE p120_tmp1
   #SELECT 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' order1, fbn_file.*, faj54
   #       ,fbn06 fbn061,fbn06 fbn062,
   #       'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' order2
   #  FROM fbn_file,faj_file
   # WHERE fbn01 = faj02 AND fbn02=faj022
   #   AND fbn01 = '@@@@@'
   #  INTO TEMP p120_tmp1
   #IF STATUS THEN
   #   CALL cl_err3("sel","fan_file,faj_file,","","",STATUS,"","create tmp1201",1)
   #END IF
   #DELETE FROM p120_tmp1
   ##-----No:FUN-AB0088 END-----
   ##-----No:FUN-B60140 Mark END-----

   CLEAR FORM
   CALL cl_opmsg('w')
 
#->No.FUN-570144 --start--
   OPEN WINDOW p120_w AT p_row,p_col WITH FORM "afa/42f/afap120"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
#->No.FUN-570144 ---end---
 
   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON fan01,fan02 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
         LET g_action_choice = "locale"   #MOD-8A0084 mark回復
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE        #->No.FUN-570144
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
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT CONSTRUCT
  
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
#      IF INT_FLAG THEN
#         RETURN 
#      END IF
#      IF g_wc = ' 1=1' THEN
#         CALL cl_err('','9046',0) CONTINUE WHILE
#      ELSE
#         EXIT WHILE
#      END IF
#   END WHILE
 
   CALL cl_opmsg('a')
   SELECT faa07,faa08 INTO tm.fan03,tm.fan04 FROM faa_file WHERE faa00='0'
   DISPLAY BY NAME tm.fan03,tm.fan04           #No.MOD-4A0184
 
  #->No.FUN-570144 --start--
   LET g_bgjob = "N"
   IF g_bgjob = 'N' THEN LET tm.v_no = '' END IF   #MOD-B80302
   INPUT BY NAME tm.fan03,tm.fan04,tm.v_no,g_bgjob WITHOUT DEFAULTS
  #->No.FUN-570144 ---end---
#   INPUT BY NAME tm.fan03,tm.fan04,tm.v_no WITHOUT DEFAULTS 
 
 
## No:2374   modify 1998/07/17 ---------------------
       BEFORE INPUT                          #No.MOD-4A0184 
         IF cl_null(tm.v_no) THEN 
            LET l_yy = tm.fan03
            LET l_mm = tm.fan04 using '&&'
           #LET l_str= l_yy,l_mm,'0001'        #MOD-B80302 mark
            LET l_str= '10',l_yy,l_mm,'0001'   #MOD-B80302
            LET tm.v_no=l_str 
            #NO:8065 031009 modify
            #-->check 是否存在
            SELECT count(*) INTO l_cnt FROM npp_file
             WHERE npp01 = tm.v_no AND nppsys = 'FA' and npp00 = 10
               AND npp011 = 1
               AND npptype = '0'   #No.FUN-680028
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
            IF l_cnt > 0 THEN
               LET l_str = tm.v_no[1,8]     #MOD-B80302 mod 6 -> 9
               SELECT MAX(npp01) INTO l_max FROM npp_file
                WHERE npp01[1,8] = l_str AND nppsys = 'FA' and npp00 = 10 #MOD-B80302 mod 6 -> 8 
                  AND npp011 = 1
                  AND npptype = '0'   #No.FUN-680028
               LET l_max = l_max +1
               LET tm.v_no = l_max
            END IF
            #NO:8065 end
            DISPLAY BY NAME tm.v_no 
         END IF
 
      AFTER FIELD v_no   # default value for v_no by 10-yymmxxxx
         IF cl_null(tm.v_no) THEN
            NEXT FIELD FORMONLY.v_no 
         END IF
         #-->check 是否存在
         SELECT count(*) INTO l_cnt FROM npp_file
          WHERE npp01 = tm.v_no AND nppsys = 'FA' and npp00 = 10
            AND npp011 = 1
	    AND npptype = '0'   #No.FUN-680028
         IF cl_null(l_cnt) THEN
            LET l_cnt = 0 
         END IF
         IF l_cnt > 0 THEN 
            CALL cl_err(tm.v_no,'afa-368',0)
         END IF 
#### -----------------------------------------------
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         call cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION locale
            LET g_change_lang = TRUE               #No.FUN-570144
            EXIT INPUT
   
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
  
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   #->No.FUN-570144 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
#--移到p120_process()---
#   IF INT_FLAG THEN
#      RETURN 
#   END IF
#   IF NOT cl_sure(0,0) THEN
#      RETURN 
#   END IF
#   #---->(1-1)insert 單頭
#   LET g_npp.nppsys ='FA'
#   LET g_npp.npp00  = 10  
#   LET g_npp.npp01  =tm.v_no
#   LET g_npp.npp011 = 1
#   #no.4529 LET npp02 =畫面所設定期別的最後一天
#   LET l_date = MDY(tm.fan04,1,tm.fan03)
#   CALL s_last(l_date) RETURNING l_date
#   LET g_npp.npp02 = l_date
#   #LET g_npp.npp02  = g_today 
#   #no.4529(end)
#   LET g_npp.npp03  = NULL
#   LET g_npp.nppglno= NULL
#   DELETE FROM npp_file WHERE nppsys = 'FA' and npp00 = 10
#                          and npp01= tm.v_no and npp011 = 1
#                          AND (nppglno=' ' OR nppglno IS NULL)
#   INSERT INTO npp_file VALUES(g_npp.*)
#   # IF SQLCA.SQLERRD[3]=0 THEN LET g_success = 'N' RETURN END IF
#   #IF STATUS THEN                        #CHI-A70049 mark
#      #DISPLAY "npp_file INSERT:",status  #CHI-A70049 mark
#      #LET g_success = 'N'                #CHI-A70049 mark
#      #RETURN                             #CHI-A70049 mark
#   #END IF                                #CHI-A70049 mark
#   message  g_npp.npp01
#   CALL ui.Interface.refresh() 
#   #---->(1-1)insert 單身
#   DELETE FROM npq_file WHERE npqsys = 'FA' and npq00 = 10 and npq01= tm.v_no and npq011 = 1
#   IF STATUS THEN
#      LET g_success = 'N' RETURN 
#   END IF
#   LET g_npq.npqsys ='FA'
#   LET g_npq.npq00  = 10
#   LET g_npq.npq01  =tm.v_no
#   LET g_npq.npq011 = 1
#   LET g_sql="SELECT '',fan_file.*,faj54 FROM fan_file LEFT OUTER JOIN faj_file ON fan01 = faj_file.faj02 AND fan02 = faj_file.faj022",
#            " WHERE ",g_wc CLIPPED,
#            "   AND fan05 IN ('1','3') ",
#            "   AND fan03=",tm.fan03," AND fan04=",tm.fan04,
#            "   AND fan041 = '1'"
#
#   PREPARE p120_prepare FROM g_sql
#   DECLARE p120_cs CURSOR WITH HOLD FOR p120_prepare
#   CALL cl_outnam('afap120') RETURNING l_name
#   START REPORT afap120_rep TO l_name
#
#   FOREACH p120_cs INTO sr.*
#      IF STATUS THEN 
#         CALL cl_err('p120(foreach):',STATUS,1) EXIT FOREACH 
#      END IF
#      IF sr.fan.fan07 = 0 THEN 
#         CONTINUE FOREACH
#      END IF
#      LET l_aag05 = NULL
#      SELECT aag05 INTO l_aag05 FROM aag_file
#       WHERE aag01 = sr.fan.fan12
#      IF cl_null(l_aag05) THEN
#         LET l_aag05 = ' ' 
#      END IF
#      IF l_aag05 = 'Y' THEN     #要作部門管理
#         LET sr.order1= sr.fan.fan12,sr.fan.fan06
#      ELSE
#         LET sr.order1 = sr.fan.fan12
#         LET sr.fan.fan06 = ' '
#      END IF
#      IF cl_null(sr.faj54) THEN
#         LET sr.faj54 = ' '
#      END IF
#      INSERT INTO p120_tmp VALUES(sr.order1,sr.fan.*,sr.faj54)
#      IF SQLCA.SQLCODE THEN
#         CALL cl_err('sr Ins:',STATUS,1)
#      END IF
#   END FOREACH
#
#   DECLARE p120_tmpcs CURSOR FOR
#   SELECT * FROM p120_tmp ORDER BY faj54,order1
#
#   FOREACH p120_tmpcs INTO sr.*
#      IF STATUS THEN
#         CALL cl_err('order1:',STATUS,1)
#         EXIT FOREACH
#      END IF
#      OUTPUT TO REPORT afap120_rep(sr.*)
#   END FOREACH
#
#   FINISH REPORT afap120_rep
#   #No.+366 010705 plum
#   LET l_cmd = "chmod 777 ", l_name
#   RUN l_cmd
#   #No.+366..end
#   DROP TABLE p120_tmp
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW p120_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
  IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "afap120"
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('afap120','9031',1)  
     ELSE
        LET g_wc=cl_replace_str(g_wc, "'", "\"")
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",g_wc CLIPPED,"'",
                     " '",tm.fan03 CLIPPED,"'",
                     " '",tm.fan04 CLIPPED,"'",
                     " '",tm.v_no  CLIPPED,"'",
                     " '",g_bgjob  CLIPPED,"'"
        CALL cl_cmdat('afap120',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p120_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
   END IF
   EXIT WHILE
  #->No.FUN-570144 ---end---
END WHILE
END FUNCTION
   
#No.FUN-680028--begin
#REPORT afap120_rep(sr)
REPORT afap120_rep(sr,p_npqtype)
#No.FUN-680028--end  
   DEFINE p_npqtype    LIKE npq_file.npqtype     #No.FUN-680028
   DEFINE l_last_sw    LIKE type_file.chr1,      #No.FUN-680070 VARCHAR(1)
          l_aag05      LIKE aag_file.aag05,
          sr     RECORD
             order1  LIKE type_file.chr1000,     #No.FUN-680070 VARCHAR(30)
             fan     RECORD LIKE fan_file.*,
             faj54   LIKE faj_file.faj54,        #累積折舊
             fan061  LIKE fan_file.fan06,        #折舊科目部門  #MOD-920103 add
             fan062  LIKE fan_file.fan06,        #累折科目部門  #MOD-920103 add
             order2  LIKE type_file.chr1000                     #MOD-920103 add
                 END RECORD,
          l_faj54   LIKE faj_file.faj54
   DEFINE l_aag44    LIKE aag_file.aag44   #No.FUN-D40118   Add
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
 #ORDER EXTERNAL BY sr.faj54,sr.order1   #MOD-920103 mark
# ORDER EXTERNAL BY sr.order1,sr.order2  #MOD-920103      #No.MOD-930080
  ORDER EXTERNAL BY sr.order2,sr.order1                   #No.MOD-930080
 
  FORMAT
   #AFTER GROUP OF sr.faj54   #累折科目  #MOD-920103 mark
    AFTER GROUP OF sr.order2  #累折科目  #MOD-920103
      LET g_npq.npq02=g_npq.npq02+1
      LET g_npq.npq03=sr.faj54   #科目(累積折舊)
      LET g_npq.npq04=NULL
      #No.FUN-740026  --BEGIN--
      #CALL s_get_bookno(tm.fan03) RETURNING g_bookno1,g_bookno2,g_flag   #MOD-7B0173
      CALL s_get_bookno(tm.fan03) RETURNING g_flag,g_bookno1,g_bookno2    #MOD-7B0173
      IF g_flag="1" THEN  #抓不到帳套
         CALL cl_err(tm.fan03,'aoo-081',1)
      END IF
      #No.FUN-740026 --END--
     #str MOD-920103 mod
     #SELECT aag02 INTO g_npq.npq04 FROM aag_file
     # WHERE aag01=sr.faj54 AND aag00 = g_bookno1
      IF p_npqtype = '0' THEN
         SELECT aag02 INTO g_npq.npq04 FROM aag_file
          WHERE aag01=sr.faj54 AND aag00 = g_bookno1
         LET g_bookno = g_bookno1   #No.FUN-D40118   Add
      ELSE
         SELECT aag02 INTO g_npq.npq04 FROM aag_file
        #  WHERE aag01=sr.faj54 AND aag00 = g_bookno2
           WHERE aag01=sr.faj54 AND aag00 = g_faa.faa02c   #No:FUN-AB0088
         LET g_bookno = g_faa.faa02c   #No.FUN-D40118   Add
      END IF
     #end MOD-920103 mod
      IF SQLCA.sqlcode THEN LET g_npq.npq04 = ' ' END IF
     #str MOD-920103 mark
     #LET l_aag05 = NULL
     #SELECT aag05 INTO l_aag05 FROM aag_file
     # WHERE aag01 = sr.faj54
     #   AND aag00 = g_bookno1                    #No.FUN-740026
     #IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF
     #IF l_aag05 = 'N' THEN     #不要作部門管理
     #   LET sr.fan.fan06 = ' '
     #END IF
     #end MOD-920103 mark
     #LET g_npq.npq05  = sr.fan.fan06   #MOD-920103 mark
      LET g_npq.npq05  = sr.fan062      #MOD-920103
      LET g_npq.npq06  = '2' 
      LET g_npq.npq07f = GROUP SUM(sr.fan.fan07)
      LET g_npq.npq07  = g_npq.npq07f 
      LET g_npq.npq08  = ' '   LET g_npq.npq11  = ''   #MOD-9A0005
      LET g_npq.npq12  = ''    LET g_npq.npq13  = ''   #MOD-9A0005
      LET g_npq.npq14  = ''    LET g_npq.npq15  = ' '  #MOD-9A0005
      LET g_npq.npq21  = ' '    LET g_npq.npq22  = ' ' 
      LET g_npq.npq23  = NULL
      LET g_npq.npq24  = g_aza.aza17 
      LET g_npq.npq25  = 1 
      IF g_npq.npq07<>0 THEN                    #No.MOD-4A0184
         #FUN-D10065--add--str--
         CALL s_def_npq3(g_bookno1,g_npq.npq03,g_prog,g_npq.npq01,'','')
         RETURNING g_npq.npq04
         #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(g_npq.*)
         IF g_bgjob = 'N' THEN   #FUN-570144
            message  g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
            CALL ui.Interface.refresh()
         END IF
#CHI-A70049---mark---start---
         #IF STATUS THEN         #No.MOD-4A0184
           #LET g_success='N' 
           #DISPLAY "npq_file INSERT:",status
         #END IF
#CHI-A70049---mark---end---
      END IF 
   
    AFTER GROUP OF sr.order1  #折舊科目
      LET g_npq.npq02=g_npq.npq02+1
      #No.FUN-680028--begin
#     LET g_npq.npq03=sr.fan.fan12  #折舊科目 
      IF p_npqtype = '0' THEN
         LET g_npq.npq03=sr.fan.fan12  #折舊科目 
      ELSE
         LET g_npq.npq03=sr.fan.fan121 #折舊科目 
      END IF
      #No.FUN-680028--end  
      LET g_npq.npq04=NULL
     #str MOD-920103 mod
     #SELECT aag02 INTO g_npq.npq04 FROM aag_file
     # WHERE aag01=sr.fan.fan12 AND aag00 = g_bookno1
      IF p_npqtype = '0' THEN
         SELECT aag02 INTO g_npq.npq04 FROM aag_file
          WHERE aag01=sr.fan.fan12 AND aag00 = g_bookno1
      ELSE
         SELECT aag02 INTO g_npq.npq04 FROM aag_file
        #  WHERE aag01=sr.fan.fan121 AND aag00 = g_bookno2
           WHERE aag01=sr.fan.fan121 AND aag00 = g_faa.faa02c   #No:FUN-AB0088
      END IF
     #end MOD-920103 mod
      IF SQLCA.sqlcode THEN LET g_npq.npq04 = ' ' END IF
     #str MOD-920103 mark
     #SELECT aag05 INTO l_aag05 FROM aag_file
     # WHERE aag01 = sr.fan.fan12
     #   AND aag00 = g_bookno1                    #No.FUN-740026
     #IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF #plum 010705
     #IF l_aag05 = 'N' THEN     #不要作部門管理
     #   LET sr.fan.fan06 = ' '
     #END IF
     #end MOD-920103 mark
     #LET g_npq.npq05  = sr.fan.fan06  #部門   #MOD-920103 mark
      LET g_npq.npq05  = sr.fan061     #部門   #MOD-920103
      LET g_npq.npq06  = '1'         
      LET g_npq.npq07f = GROUP SUM(sr.fan.fan07)
      LET g_npq.npq07  = g_npq.npq07f 
      LET g_npq.npq08  = ' '   LET g_npq.npq11  = ''   #MOD-9A0005
      LET g_npq.npq12  = ''    LET g_npq.npq13  = ''   #MOD-9A0005
      LET g_npq.npq14  = ''    LET g_npq.npq15  = ' '  #MOD-9A0005
      LET g_npq.npq21  = ' '    LET g_npq.npq22  = ' ' 
      LET g_npq.npq23  = NULL
      LET g_npq.npq24  = g_aza.aza17 
      LET g_npq.npq25  = 1 
      IF g_npq.npq07<>0 THEN                        #No.MOD-4A0184 
         IF g_bgjob = 'N' THEN   #FUN-570144
            message  g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
            CALL ui.Interface.refresh()
         END IF
         #FUN-D10065--add--str--
         CALL s_def_npq3(g_bookno1,g_npq.npq03,g_prog,g_npq.npq01,'','')
         RETURNING g_npq.npq04
         #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(g_npq.*)
#CHI-A70049---mark---start---
         #IF STATUS THEN         #No.MOD-4A0184
            #LET g_success='N'
            #DISPLAY "npq_file2 INSERT:",status
         #END IF
#CHI-A70049---mark---end---
       END IF
 
END REPORT
 
#No.FUN-680028--begin
#FUNCTION p120_process()
FUNCTION p120_process(p_npptype)
#No.FUN-680028--end  
   DEFINE p_npptype LIKE npp_file.npptype       #No.FUN-680028
   DEFINE l_name    LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
   DEFINE l_cmd     LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(30)
   DEFINE l_str     LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
   DEFINE l_yy      LIKE type_file.chr4         #No.FUN-680070 VARCHAR(4)
   DEFINE l_mm      LIKE type_file.chr2         #No.FUN-680070 VARCHAR(2)
   DEFINE l_cnt     LIKE type_file.num5,        #No.FUN-680070 SMALLINT
          l_max     LIKE type_file.chr20,       #No:8065          #No.FUN-680070 VARCHAR(10)
          l_aag05   LIKE aag_file.aag05,
          l_date    LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE sr        RECORD
           order1    LIKE type_file.chr1000,    #No.FUN-680070 VARCHAR(30)
           fan       RECORD LIKE fan_file.*,
           faj54     LIKE faj_file.faj54,       #累積折舊
           fan061    LIKE fan_file.fan06,       #折舊科目部門   #MOD-920103 add
           fan062    LIKE fan_file.fan06,       #累折科目部門   #MOD-920103 add
           order2    LIKE type_file.chr1000                     #MOD-920103 add
                    END RECORD
   DEFINE l_flag    LIKE type_file.chr1, #MOD-970073                                                                                
          l_bdate   LIKE type_file.dat,  #MOD-970073                                                                                
          l_edate   LIKE type_file.dat   #MOD-970073    
 
   #CHI-A40046 add --start--
   LET l_cnt = 0
   SELECT count(*) INTO l_cnt FROM npp_file
    WHERE npp01 = tm.v_no AND nppsys = 'FA' and npp00 = 10
      AND npp011 = 1
      AND npptype = '0'
   IF l_cnt > 0 THEN 
      UPDATE fan_file SET fan19 = ''
       WHERE fan05 IN ('1','3')
         AND fan03 = tm.fan03 AND fan04 = tm.fan04
         AND fan041 = '1'
         AND fan19 = tm.v_no
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd fan19:',SQLCA.SQLCODE,1)
         LET g_success = 'N' RETURN
      END IF
   END IF
   #CHI-A40046 add --end--

   #---->(1-1)insert 單頭
   LET g_npp.npptype = p_npptype #No.FUN-680028
   LET g_npq.npqtype = p_npptype #No.FUN-680028
   LET g_npp.nppsys ='FA'
   LET g_npp.npp00  = 10  
   LET g_npp.npp01  = tm.v_no
   LET g_npp.npp011 = 1
   #no.4529 LET npp02 =畫面所設定期別的最後一天
#MOD-970073   ---START       
  #LET l_date = MDY(tm.fan04,1,tm.fan03)
  #CALL s_last(l_date) RETURNING l_date
  #LET g_npp.npp02 = l_date
  #CALL s_azm(tm.fan03,tm.fan04) RETURNING l_flag,l_bdate,l_edate #CHI-A60036 mark
  #CHI-A60036 add --start--
  CALL s_get_bookno(tm.fan03)
         RETURNING g_flag,g_bookno1,g_bookno2
# IF g_aza.aza63 = 'Y' THEN
  IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
     IF p_npptype = '0' THEN
        CALL s_azmm(tm.fan03,tm.fan04,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
     ELSE
      # CALL s_azmm(tm.fan03,tm.fan04,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
        CALL s_azmm(tm.fan03,tm.fan04,g_plant,g_faa.faa02c) RETURNING l_flag,l_bdate,l_edate   #No:FUN-AB0088
     END IF
  ELSE
     CALL s_azm(tm.fan03,tm.fan04) RETURNING l_flag,l_bdate,l_edate
  END IF
  #CHI-A60036 add --end--
   LET g_npp.npp02 = l_edate                                                                                                        
#MOD-970073   ---END        
  #LET g_npp.npp02  = g_today 
   #no.4529(end)
   LET g_npp.npp03  = NULL
   LET g_npp.nppglno= NULL
   LET g_npp.npplegal= g_legal #FUN-980003 add
   DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 10
                          AND npp01= tm.v_no AND npp011 = 1
                          AND (nppglno=' ' OR nppglno IS NULL)
                          AND npptype = p_npptype #No.FUN-680028
   INSERT INTO npp_file VALUES(g_npp.*)
  #IF SQLCA.SQLERRD[3]=0 THEN LET g_success = 'N' RETURN END IF
#CHI-A70049---mark---start---
   #IF STATUS THEN
      #DISPLAY "npp_file INSERT:",status
      #LET g_success = 'N'
      #RETURN
   #END IF
#CHI-A70049---mark---end---
   IF g_bgjob = 'N' THEN  #NO.FUN-570144 
      message  g_npp.npp01
      CALL ui.Interface.refresh() 
   END IF
   #---->(1-1)insert 單身
   DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 10
                          AND npq01= tm.v_no AND npq011 = 1
                          AND npqtype = p_npptype #No.FUN-680028
   IF STATUS THEN LET g_success = 'N' RETURN END IF

   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = tm.v_no
   IF STATUS THEN LET g_success = 'N' RETURN END IF
   #FUN-B40056--add--end--

   LET g_npq.npqsys ='FA'
   LET g_npq.npq00  = 10
   LET g_npq.npq01  = tm.v_no
   LET g_npq.npq011 = 1
   LET g_npq.npq02 = 0   #No.FUN-680028
   LET g_npq.npqlegal= g_legal #FUN-980003 add
   LET begin_no = 'N' #NO.CHI-A30029

   #No.FUN-680028--begin
   IF p_npptype = '0' THEN
      LET g_sql="SELECT '',fan_file.*,faj54,'','',''",   #MOD-920103 add '','',''
                "  FROM fan_file LEFT OUTER JOIN faj_file ON fan01 = faj_file.faj02 AND fan02 = faj_file.faj022",
                " WHERE ",g_wc CLIPPED,
                "   AND fan05 IN ('1','3') ",
                "   AND fan03=",tm.fan03," AND fan04=",tm.fan04,
                "   AND fan041 = '1'",
                "   AND fan19 IS NULL "   #NO.CHI-A30029  add
   ELSE
      LET g_sql="SELECT '',fan_file.*,faj541,'','',''",  #MOD-920103 add '','',''
                "  FROM fan_file LEFT OUTER JOIN faj_file ON fan01 = faj_file.faj02 AND fan02 = faj_file.faj022",
                " WHERE ",g_wc CLIPPED,
                "   AND fan05 IN ('1','3') ",
                "   AND fan03=",tm.fan03," AND fan04=",tm.fan04,
                "   AND fan041 = '1'",
                "   AND fan19 IS NULL "   #NO.CHI-A30029  add
   END IF
   #No.FUN-680028--end  
 
   PREPARE p120_prepare FROM g_sql
   DECLARE p120_cs CURSOR WITH HOLD FOR p120_prepare
   CALL cl_outnam('afap120') RETURNING l_name
   START REPORT afap120_rep TO l_name
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH p120_cs INTO sr.*
      IF STATUS THEN 
        #CALL cl_err('p120(foreach):',STATUS,1) EXIT FOREACH  #No.FUN-710028
        #CALL s_errmsg('','','p120(foreach):',STATUS,0) EXIT FOREACH  #No.FUN-710028  #No.FUN-8A0086
         CALL s_errmsg('','','p120(foreach):',STATUS,0)
         LET g_success = 'N'   
         EXIT FOREACH
      END IF
#No.FUN-710028 --begin       
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                    
#No.FUN-710028 -end  
      IF sr.fan.fan07 = 0 THEN 
         CONTINUE FOREACH
      END IF
      #-----MOD-7B0173---------
      CALL s_get_bookno(tm.fan03) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag="1" THEN  
         CALL cl_err(tm.fan03,'aoo-081',1)
      END IF
      #-----END MOD-7B0173-----
      LET sr.fan061 = sr.fan.fan06   #MOD-920103 add
      LET sr.fan062 = sr.fan.fan06   #MOD-920103 add
      IF cl_null(sr.faj54) THEN
         LET sr.faj54 = ' '
      END IF
      IF p_npptype = '0' THEN   #MOD-920103 add
         LET l_aag05 = NULL
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01 = sr.fan.fan12
            AND aag00 = g_bookno1                    #No.FUN-740026
         IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF
         IF l_aag05 = 'Y' THEN     #要作部門管理
           #LET sr.order1= sr.fan.fan12,sr.fan.fan06
            LET sr.order1= sr.fan.fan12,sr.fan061      #MOD-920103
         ELSE
            LET sr.order1 = sr.fan.fan12
           #LET sr.fan.fan06 = ' '  #MOD-920103 mark
            LET sr.fan061 = ' '     #MOD-920103 add
         END IF
        #str MOD-920103 add
         LET l_aag05 = NULL
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01 = sr.faj54
            AND aag00 = g_bookno1                    #No.FUN-740026
         IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF
         IF l_aag05 = 'Y' THEN     #要作部門管理
            LET sr.order2= sr.faj54,sr.fan062
         ELSE
            LET sr.order2= sr.faj54
            LET sr.fan062 = ' '
         END IF
        #end MOD-920103 add
     #str MOD-920103 add
      ELSE
         LET l_aag05 = NULL   #MOD-920103 add
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01 = sr.fan.fan121
         #  AND aag00 = g_bookno2                    #No.FUN-740026
            AND aag00 = g_faa.faa02c   #No:FUN-AB0088 
         IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF
         IF l_aag05 = 'Y' THEN     #要作部門管理
           #LET sr.order1= sr.fan.fan121,sr.fan.fan06
            LET sr.order1= sr.fan.fan121,sr.fan061      #MOD-920103
         ELSE
            LET sr.order1 = sr.fan.fan121
           #LET sr.fan.fan06 = ' '  #MOD-920103 mark
            LET sr.fan061 = ' '     #MOD-920103 add
         END IF
        #str MOD-920103 add
         LET l_aag05 = NULL
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01 = sr.faj54
          # AND aag00 = g_bookno2                    #No.FUN-740026
            AND aag00 = g_faa.faa02c   #No:FUN-AB0088
         IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF
         IF l_aag05 = 'Y' THEN     #要作部門管理
            LET sr.order2= sr.faj54,sr.fan062
         ELSE
            LET sr.order2= sr.faj54
            LET sr.fan062 = ' '
         END IF
        #end MOD-920103 add
      END IF
     #end MOD-920103 add
      INSERT INTO p120_tmp VALUES
     #(sr.order1,sr.fan.*,sr.faj54)                               #MOD-920103 mark
      (sr.order1,sr.fan.*,sr.faj54,sr.fan061,sr.fan062,sr.order2) #MOD-920103
      IF SQLCA.SQLCODE THEN
         LET g_success = 'N'   
#        CALL cl_err('sr Ins:',STATUS,1)         #No.FUN-660136
#        CALL cl_err3("ins","p120_tmp",sr.order1,sr.fan.fan01,STATUS,"","sr Ins:",1)   #No.FUN-660136 #No.FUN-710028
         CALL s_errmsg('','','sr Ins:',STATUS,0) #No.FUN-710028  
      END IF
      
     #NO.CHI-A30029---start--------------
      UPDATE fan_file set fan19 = tm.v_no 
        WHERE fan01 = sr.fan.fan01 AND fan02 = sr.fan.fan02 
          AND fan03 = sr.fan.fan03 AND fan04 = sr.fan.fan04
          AND fan041 = sr.fan.fan041 AND fan05 = sr.fan.fan05
          AND fan06 = sr.fan.fan06

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         LET g_success = 'N'   
         CALL s_errmsg('','','fan upd:',SQLCA.SQLCODE,0)  
      END IF

     IF begin_no ='N' THEN
        LET begin_no = 'Y' 
     END IF


     #NO.CHI-A30029---end----------------

   END FOREACH
#No.FUN-710028 --begin
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
#No.FUN-710028 --end
 
   DECLARE p120_tmpcs CURSOR FOR
   SELECT * FROM p120_tmp ORDER BY faj54,order1
 
   FOREACH p120_tmpcs INTO sr.*
      IF STATUS THEN
#        CALL cl_err('order1:',STATUS,1)          #No.FUN-710028
         CALL s_errmsg('','','order1:',STATUS,0)  #No.FUN-710028
         EXIT FOREACH
      END IF
      #No.FUN-680028--begin
#     OUTPUT TO REPORT afap120_rep(sr.*)
      OUTPUT TO REPORT afap120_rep(sr.*,p_npptype)
      #No.FUN-680028--end  
   END FOREACH
 
   FINISH REPORT afap120_rep
   #No.+366 010705 plum
#  LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009 
#  RUN l_cmd                                          #No.FUN-9C0009 
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009  add by dxfwo
   #No.+366..end
#  DROP TABLE p120_tmp    #No.FUN-680028
   DELETE FROM p120_tmp   #No.FUN-680028

#NO.CHI-A30029---start---
     IF begin_no ='N' THEN
        LET g_success = 'N'  
        CALL s_errmsg('fan01',begin_no,'','aap-129',1)
     END IF
#NO.CHI-A30029---end-----
   CALL s_flows('3',g_faa.faa02b,g_npq.npq01,g_npq.npq02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
END FUNCTION
#NO.FUN-570144 END------------


##-----No:FUN-B60140 Mark-----
#-----No:FUN-AB0088-----
#REPORT afap120_rep1(sr,p_npqtype)
#   DEFINE p_npqtype    LIKE npq_file.npqtype
#   DEFINE l_last_sw    LIKE type_file.chr1,
#          l_aag05      LIKE aag_file.aag05,
#          sr     RECORD
#             order1  LIKE type_file.chr1000,
#             fbn     RECORD LIKE fbn_file.*,
#             faj54   LIKE faj_file.faj54,        #累積折舊
#             fbn061  LIKE fbn_file.fbn06,        #折舊科目部門
#             fbn062  LIKE fbn_file.fbn06,        #累折科目部門
#             order2  LIKE type_file.chr1000
#                 END RECORD,
#          l_faj54   LIKE faj_file.faj54
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER EXTERNAL BY sr.order2,sr.order1
#
#  FORMAT
#    AFTER GROUP OF sr.order2  #累折科目
#      LET g_npq.npq02=g_npq.npq02+1
#      LET g_npq.npq03=sr.faj54   #科目(累積折舊)
#      LET g_npq.npq04=NULL
#
#      CALL s_get_bookno(tm.fan03) RETURNING g_flag,g_bookno1,g_bookno2
#      IF g_flag="1" THEN  #抓不到帳套
#         CALL cl_err(tm.fan03,'aoo-081',1)
#      END IF
#
#      SELECT aag02 INTO g_npq.npq04 FROM aag_file
#       WHERE aag01=sr.faj54 AND aag00 = g_faa.faa02c
#
#      IF SQLCA.sqlcode THEN LET g_npq.npq04 = ' ' END IF
#      LET g_npq.npq05  = sr.fbn062
#      LET g_npq.npq06  = '2'
#      LET g_npq.npq07f = GROUP SUM(sr.fbn.fbn07)
#      LET g_npq.npq07  = g_npq.npq07f
#      LET g_npq.npq08  = ' '   LET g_npq.npq11  = ''
#      LET g_npq.npq12  = ''    LET g_npq.npq13  = ''
#      LET g_npq.npq14  = ''    LET g_npq.npq15  = ' '
#      LET g_npq.npq21  = ' '    LET g_npq.npq22  = ' '
#      LET g_npq.npq23  = NULL
#     #LET g_npq.npq24  = g_aza.aza17    #CHI-B50013 mark
#      LET g_npq.npq24  = g_aaa03        #CHI-B50013
#      LET g_npq.npq25  = 1
#      IF g_npq.npq07<>0 THEN
#         INSERT INTO npq_file VALUES(g_npq.*)
#         IF g_bgjob = 'N' THEN
#            message  g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
#            CALL ui.Interface.refresh()
#         END IF
#         IF STATUS THEN
#            LET g_success='N'
#         END IF
#      END IF
#
#    AFTER GROUP OF sr.order1  #折舊科目
#      LET g_npq.npq02=g_npq.npq02+1
#      LET g_npq.npq03=sr.fbn.fbn12  #折舊科目
#      LET g_npq.npq04=NULL
#      SELECT aag02 INTO g_npq.npq04 FROM aag_file
#       WHERE aag01=sr.fbn.fbn12 AND aag00 = g_faa.faa02c
#      IF SQLCA.sqlcode THEN LET g_npq.npq04 = ' ' END IF
#      LET g_npq.npq05  = sr.fbn061     #部門
#      LET g_npq.npq06  = '1'
#      LET g_npq.npq07f = GROUP SUM(sr.fbn.fbn07)
#      LET g_npq.npq07  = g_npq.npq07f
#      LET g_npq.npq08  = ' '   LET g_npq.npq11  = ''
#      LET g_npq.npq12  = ''    LET g_npq.npq13  = ''
#      LET g_npq.npq14  = ''    LET g_npq.npq15  = ' '
#      LET g_npq.npq21  = ' '    LET g_npq.npq22  = ' '
#      LET g_npq.npq23  = NULL
#     #LET g_npq.npq24  = g_aza.aza17    #CHI-B50013 mark
#      LET g_npq.npq24  = g_aaa03        #CHI-B50013
#      LET g_npq.npq25  = 1
#      IF g_npq.npq07<>0 THEN
#         IF g_bgjob = 'N' THEN
#            message  g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
#            CALL ui.Interface.refresh()
#         END IF
#         INSERT INTO npq_file VALUES(g_npq.*)
#         IF STATUS THEN
#            LET g_success='N'
#         END IF
#       END IF
#
#END REPORT
#
#FUNCTION p120_process1(p_npptype)
#   DEFINE p_npptype LIKE npp_file.npptype
#   DEFINE l_name    LIKE type_file.chr20
#   DEFINE l_cmd     LIKE type_file.chr1000
#   DEFINE l_str     LIKE type_file.chr20
#   DEFINE l_yy      LIKE type_file.chr4
#   DEFINE l_mm      LIKE type_file.chr2
#   DEFINE l_cnt     LIKE type_file.num5,
#          l_max     LIKE type_file.chr20,
#          l_aag05   LIKE aag_file.aag05,
#          l_date    LIKE type_file.dat
#   DEFINE sr        RECORD
#           order1    LIKE type_file.chr1000,
#           fbn       RECORD LIKE fbn_file.*,
#           faj54     LIKE faj_file.faj54,       #累積折舊
#           fbn061    LIKE fbn_file.fbn06,       #折舊科目部門
#           fbn062    LIKE fbn_file.fbn06,       #累折科目部門
#           order2    LIKE type_file.chr1000
#                    END RECORD
#   DEFINE l_flag    LIKE type_file.chr1,
#          l_bdate   LIKE type_file.dat,
#          l_edate   LIKE type_file.dat
#
#   #---->(1-1)insert 單頭
#   LET g_npp.npptype = p_npptype
#   LET g_npq.npqtype = p_npptype
#   LET g_npp.nppsys ='FA'
#   LET g_npp.npp00  = 10
#   LET g_npp.npp01  = tm.v_no
#   LET g_npp.npp011 = 1
#
#   CALL s_get_bookno(tm.fan03) RETURNING g_flag,g_bookno1,g_bookno2
#
#   CALL s_azmm(tm.fan03,tm.fan04,g_plant,g_faa.faa02c) RETURNING l_flag,l_bdate,l_edate   #No:FUN-AB
#
#  #-CHI-B50013-add-
#   SELECT aaa03 INTO g_aaa03 
#     FROM aaa_file
#    WHERE aaa01 = g_faa.faa02c 
#  #-CHI-B50013-end-
#
#   LET g_npp.npp02 = l_edate
#   LET g_npp.npp03  = NULL
#   LET g_npp.nppglno= NULL
#
#   DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 10
#                          AND npp01= tm.v_no AND npp011 = 1
#                          AND (nppglno=' ' OR nppglno IS NULL)
#                          AND npptype = p_npptype
#   INSERT INTO npp_file VALUES(g_npp.*)
#   IF STATUS THEN
#      LET g_success = 'N'
#      RETURN
#   END IF
#   IF g_bgjob = 'N' THEN
#      message  g_npp.npp01
#      CALL ui.Interface.refresh()
#   END IF
#
#   #---->(1-1)insert 單身
#   DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 10
#                          AND npq01= tm.v_no AND npq011 = 1
#                          AND npqtype = p_npptype
#   IF STATUS THEN LET g_success = 'N' RETURN END IF
#
#   #FUN-B40056--add--str--
#   DELETE FROM tic_file WHERE tic04 = tm.v_no
#   IF STATUS THEN LET g_success = 'N' RETURN END IF
#   #FUN-B40056--add--end--
#
#   LET g_npq.npqsys ='FA'
#   LET g_npq.npq00  = 10
#   LET g_npq.npq01  = tm.v_no
#   LET g_npq.npq011 = 1
#   LET g_npq.npq02 = 0
#
#   LET g_sql="SELECT '',fbn_file.*,faj541,'','',''",
#             "  FROM fbn_file,OUTER faj_file",
#             " WHERE ",g_wc1 CLIPPED,
#             "   AND fbn01 = faj02",
#             "   AND fbn02 = faj022",
#             "   AND fbn05 IN ('1','3') ",
#             "   AND fbn03=",tm.fan03," AND fbn04=",tm.fan04,
#             "   AND fbn041 = '1'"
#
#   PREPARE p120_prepare1 FROM g_sql
#   DECLARE p120_cs1 CURSOR WITH HOLD FOR p120_prepare1
#   CALL cl_outnam('afap120') RETURNING l_name
#   START REPORT afap120_rep1 TO l_name
#   CALL s_showmsg_init()
#
#   FOREACH p120_cs1 INTO sr.*
#      IF STATUS THEN
#         CALL s_errmsg('','','p120(foreach):',STATUS,0)
#         LET g_success = 'N'
#         EXIT FOREACH
#      END IF
#      IF g_success='N' THEN
#         LET g_totsuccess='N'
#         LET g_success="Y"
#      END IF
#      IF sr.fbn.fbn07 = 0 THEN
#         CONTINUE FOREACH
#      END IF
#      CALL s_get_bookno(tm.fan03) RETURNING g_flag,g_bookno1,g_bookno2
#      IF g_flag="1" THEN
#         CALL cl_err(tm.fan03,'aoo-081',1)
#      END IF
#      LET sr.fbn061 = sr.fbn.fbn06
#      LET sr.fbn062 = sr.fbn.fbn06
#      IF cl_null(sr.faj54) THEN
#         LET sr.faj54 = ' '
#      END IF
#
#      LET l_aag05 = NULL
#      SELECT aag05 INTO l_aag05 FROM aag_file
#       WHERE aag01 = sr.fbn.fbn12
#         AND aag00 = g_faa.faa02c
#
#      IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF
#      IF l_aag05 = 'Y' THEN     #要作部門管理
#         LET sr.order1= sr.fbn.fbn12,sr.fbn061
#      ELSE
#         LET sr.order1 = sr.fbn.fbn12
#         LET sr.fbn061 = ' '
#      END IF
#
#      LET l_aag05 = NULL
#      SELECT aag05 INTO l_aag05 FROM aag_file
#       WHERE aag01 = sr.faj54
#         AND aag00 = g_faa.faa02c
#
#      IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF
#      IF l_aag05 = 'Y' THEN     #要作部門管理
#         LET sr.order2= sr.faj54,sr.fbn062
#      ELSE
#         LET sr.order2= sr.faj54
#         LET sr.fbn062 = ' '
#      END IF
#
#      INSERT INTO p120_tmp1 VALUES
#      (sr.order1,sr.fbn.*,sr.faj54,sr.fbn061,sr.fbn062,sr.order2)
#      IF SQLCA.SQLCODE THEN
#         CALL s_errmsg('','','sr Ins:',STATUS,0)
#      END IF
#   END FOREACH
#   IF g_totsuccess="N" THEN
#      LET g_success="N"
#   END IF
#
#   DECLARE p120_tmp1cs CURSOR FOR
#   SELECT * FROM p120_tmp1 ORDER BY faj54,order1
#
#   FOREACH p120_tmp1cs INTO sr.*
#      IF STATUS THEN
#         CALL s_errmsg('','','order1:',STATUS,0)
#         EXIT FOREACH
#      END IF
#      OUTPUT TO REPORT afap120_rep1(sr.*,p_npptype)
#   END FOREACH
#   CALL s_flows('3',g_faa.faa02c,g_npq.npq01,g_npq.npq02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021
#   FINISH REPORT afap120_rep1
#   LET l_cmd = "chmod 777 ", l_name
#   RUN l_cmd
#
#   DELETE FROM p120_tmp1
#
#END FUNCTION
##-----No:FUN-AB0088 END-----
##-----No:FUN-B60140 Mark END-----

