# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp311.4gl
# Descriptions...: 月底投入工時統計及分攤作業
# Date & Author..: 08/01/28 BY Sarah
# Modify.........: No.FUN-7C0028 08/01/28 By Sarah 新增"月底投入工時統計及分攤作業"
# Modify.........: No.MOD-840434 08/04/21 By Sarah cdc05金額應照分攤基礎指標數佔總指標數比例算出
# Modify.........: No.FUN-840181 08/06/12 By Sherry 增加實際機時
# Modify.........: No.FUN-8B0047 08/11/12 By Sherry 增加製費類別,標準產量功能
# Modify.........: No.FUN-960024 09/06/08 By jan 修改程序BUG
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No.FUN-9B0118 09/12/02 By Carrier add cdc11/cdc12/cdc13/cdb11/cdb12/cdb13
# Modify.........: No:MOD-A20087 10/03/29 By Summer axcp311_cur1中ccj01條件應改成用BETWEEN的方式
# Modify.........: No.FUN-A50075 10/05/25 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40028 11/04/12 By xianghui  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-BB0012 11/11/01 By yinhy 已????料，增加提示信息aap-169
# Modify.........: No.CHI-BC0036 11/12/28 By ck2yuan 增加控管年度期別不可小於現行年度期別
# Modify.........: No:MOD-C30820 12/03/23 By ck2yuan 分攤之後產生的尾差,調整至分攤最大筆中
# Modify.........: No:FUN-C80092 12/12/05 By xujing 成本相關作業增加日誌功能
# Modify.........: No:CHI-C80041 13/01/03 By bart 作廢判斷

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_sql           STRING,
       tm RECORD
            yy         LIKE type_file.num5,
            mm         LIKE type_file.num5
          END RECORD
DEFINE g_row,g_col     LIKE type_file.num5
DEFINE l_flag          LIKE type_file.chr1
DEFINE g_change_lang   LIKE type_file.chr1    #是否有做語言切換
DEFINE ls_date         STRING

#MOD-C30820 str add-----
DEFINE g_tot_cdc05     LIKE cdc_file.cdc05,        #總成本
       g_tot_cdc06     LIKE cdc_file.cdc05,        #總分攤數
       g_diff          LIKE cdc_file.cdc05,        #總分攤數
       g_cdc01         LIKE cdc_file.cdc01,        #年度
       g_cdc02         LIKE cdc_file.cdc02,        #月份
       g_cdc03         LIKE cdc_file.cdc03,        #成本中心
       g_cdc04         LIKE cdc_file.cdc04,        #成本項目
       g_cdc041        LIKE cdc_file.cdc041        #成本項目
#MOD-C30820 end add----- 
DEFINE g_cka00         LIKE cka_file.cka00   #FUN-C80092 add
DEFINE g_cka09         LIKE cka_file.cka09   #FUN-C80092 add

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy    = ARG_VAL(1)                      
   LET tm.mm    = ARG_VAL(2)                      
   LET g_bgjob  = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B40028
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CLEAR FORM
         CALL p311_tm(0,0)
         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
         IF cl_sure(18,20) THEN 
            #FUN-C80092--add--str--
            LET g_cka09 = " tm.yy='",tm.yy,"'; tm.mm='",tm.mm,"'; g_bgjob='",g_bgjob,"'"
            CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00
            #FUN-C80092--add--end--
            BEGIN WORK
            LET g_success = 'Y'
            CALL axcp311()
            CALL s_showmsg()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN 
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p311_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p311_w
      ELSE
         #FUN-C80092--add--str--
         LET g_cka09 = " tm.yy='",tm.yy,"'; tm.mm='",tm.mm,"'; g_bgjob='",g_bgjob,"'"
         CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00
         #FUN-C80092--add--end--
         BEGIN WORK
         LET g_success = 'Y'
         CALL axcp311()
         CALL s_showmsg()
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#  CALL cl_used('axcp311',g_time,2) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN
 
FUNCTION p311_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5
   DEFINE l_flag        LIKE type_file.chr1
   DEFINE lc_cmd        LIKE type_file.chr1000
 
   LET g_row = 5 LET g_col = 28
 
   OPEN WINDOW p311_w AT g_row,g_col WITH FORM "axc/42f/axcp311"  
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.yy =g_ccz.ccz01  
      LET tm.mm =g_ccz.ccz02 
      LET g_bgjob = 'N'
      DISPLAY BY NAME tm.yy,tm.mm
 
      INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS  #No.FUN-9B0118
 
         AFTER FIELD yy
            IF tm.yy IS NULL THEN
               NEXT FIELD yy
            END IF
 
         AFTER FIELD mm
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
            IF tm.mm IS NULL THEN
               NEXT FIELD mm
            END IF

         #-----CHI-BC0036 str add-----
         AFTER INPUT
             IF tm.yy*12+tm.mm > g_ccz.ccz01*12+g_ccz.ccz02 THEN
               CALL cl_err('','axc-196','1')
               #ERROR "計算年度期別不可小於現行年期!"
               NEXT FIELD yy
             END IF
         #-----CHI-BC0036 end add-----

 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
    
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION locale #genero
            LET g_change_lang = TRUE
            EXIT INPUT
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p311_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = "axcp311"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('axcp311','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.yy   CLIPPED ,"'",
                         " '",tm.mm   CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axcp311',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p311_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION axcp311()
   DEFINE l_sql      STRING,
          cdb        RECORD LIKE cdb_file.*,
          cdc        RECORD LIKE cdc_file.*,
          l_cci01    LIKE cci_file.cci01,
          l_cci02    LIKE cci_file.cci02,
          l_cdb05    LIKE cdb_file.cdb05,   #MOD-840434 add
          l_cdb06    LIKE cdb_file.cdb06    #MOD-840434 add
   DEFINE l_cci01b   LIKE cci_file.cci01    #CHI-9A0021 add
   DEFINE l_cci01e   LIKE cci_file.cci01    #CHI-9A0021 add
   DEFINE l_correct  LIKE type_file.chr1    #CHI-9A0021 add
   DEFINE l_n        LIKE type_file.num5    #MOD-BB0012 add
   DEFINE l_n1       LIKE type_file.num5    #MOD-BB0012 add
 
   #1.BY成本中心+成本項目 將該指標總數(cdb06)、單位成本(cdb07)更新至cdb_file
   LET l_sql=" SELECT * FROM cdb_file ",
             "  WHERE cdb01='",tm.yy,"' AND cdb02='",tm.mm,"'"
   PREPARE axcp311_pre FROM l_sql 
   IF STATUS THEN 
      CALL cl_err('axcp311_pre',STATUS,1) 
      LET g_success='N' 
   END IF 
   DECLARE axcp311_cur CURSOR FOR axcp311_pre 
   IF STATUS THEN
      CALL cl_err('axcp311_cur',STATUS,1) 
      LET g_success='N' 
   END IF 
 
   #No.MOD-BB0012  --Begin
   SELECT COUNT(*) INTO l_n1 FROM cdb_file WHERE cdb01=tm.yy AND cdb02=tm.mm
   IF l_n1=0 THEN
      CALL cl_err('','aap-129',1)
      LET g_success='N'
   END IF
   SELECT COUNT(*) INTO l_n FROM cdc_file WHERE cdc01=tm.yy AND cdc02=tm.mm
   IF l_n >0 THEN
      IF NOT cl_confirm('aap-169') THEN
        LET g_success='N'
        RETURN
      ELSE
        IF l_n1=0 THEN    #可能删了axct311资料,但cdc未删除导致跑成本异常
           LET g_success='Y' 
        END IF
      END IF
   END IF
   #No.MOD-BB0012  --End

  #FUN-8B0047
   #2.將cdc_file資料刪除
   DELETE FROM cdc_file WHERE cdc01=tm.yy AND cdc02=tm.mm 
  #--
 
   CALL s_showmsg_init()
   FOREACH axcp311_cur INTO cdb.* 
      IF STATUS THEN 
         CALL s_errmsg('','','axcp311_for',STATUS,1)
         LET g_success='N' 
         EXIT FOREACH 
      END IF
      IF g_success='N' THEN  
         LET g_totsuccess='N'  
         LET g_success="Y"   
      END IF 
 
      IF g_bgjob = 'N' THEN
         MESSAGE cl_getmsg('axc-197',g_lang),cdb.cdb03,' ',cdb.cdb04                                                                  
      END IF
      CALL ui.Interface.refresh()
 
      #成本(cdb05)
      IF cdb.cdb05 IS NULL THEN LET cdb.cdb05=0 END IF  
      #統計指標總數(cdb06)
      CALL axcp311_dis(cdb.*) RETURNING cdb.cdb06
      #單位成本(cdb07) = 成本(cdb05) / 分攤基準指標總數(cdb06)
      LET cdb.cdb07 = cdb.cdb05 / cdb.cdb06 
      IF cdb.cdb07 IS NULL THEN LET cdb.cdb07=0 END IF 
 
      UPDATE cdb_file SET cdb06=cdb.cdb06,cdb07=cdb.cdb07
       WHERE cdb01=cdb.cdb01 AND cdb02=cdb.cdb02
         AND cdb03=cdb.cdb03 AND cdb04=cdb.cdb04 AND cdb08=cdb.cdb08 
#        AND cdb00=cdb.cdb00 AND cdb11=cdb.cdb11     #No.FUN-9B0118
         AND cdb11=cdb.cdb11                         #No.FUN-9B0118
      IF STATUS THEN 
         #No.FUN-9B0118  --Begin
        #LET g_showmsg=cdb.cdb01,"/",cdb.cdb02
        #CALL s_errmsg('cdb01,cdb02',g_showmsg,'upd cdb error!',STATUS,1)
#        LET g_showmsg = cdb.cdb00,"/",cdb.cdb01,"/",cdb.cdb02,"/",cdb.cdb03,"/",cdb.cdb04,"/",cdb.cdb08,"/",cdb.cdb11
#        CALL s_errmsg('cdb00,cdb01,cdb02,cdb03,cdb04,cdb08,cdb11',g_showmsg,'upd cdb error!',STATUS,1)
         LET g_showmsg = cdb.cdb01,"/",cdb.cdb02,"/",cdb.cdb03,"/",cdb.cdb04,"/",cdb.cdb08,"/",cdb.cdb11
         CALL s_errmsg('cdb01,cdb02,cdb03,cdb04,cdb08,cdb11',g_showmsg,'upd cdb error!',STATUS,1)
         #No.FUN-9B0118  --End  
         LET g_success='N' 
         CONTINUE FOREACH
      END IF
   END FOREACH   
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF 
 
  #FUN-8B0047
  ##2.將cdc_file資料刪除
  #DELETE FROM cdc_file WHERE cdc01=tm.yy AND cdc02=tm.mm
  #--

   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_cci01b,l_cci01e   #MOD-A20087 add
 
   #3.產生工單分攤明細(cdc_file)
   LET l_sql="SELECT DISTINCT cdb01,cdb02,cdb03,cdb04,ccj04,cdb05,cdb06,0,cdb08,",   #MOD-840434 mod 0->cdb06
             "                '','','','',cdb09,cdb10,cdblegal,cdborig,",   #No.FUN-9B0118  #FUN-A50075 拿掉plant
             "                cdboriu,cdb00,cdb11,cdb12,cdb13 ",                     #No.FUN-9B0118
             "  FROM cdb_file,ccj_file",
            #" WHERE cdb01=YEAR(ccj01) AND cdb02=MONTH(ccj01)",         #MOD-A20087 mark
             " WHERE ccj01 BETWEEN '",l_cci01b,"' AND '",l_cci01e,"'",  #MOD-A20087 add
             "   AND cdb03=ccj02", 
             "   AND cdb01='",tm.yy,"' AND cdb02='",tm.mm,"'"
   PREPARE axcp311_pre1 FROM l_sql 
   IF STATUS THEN 
      CALL cl_err('axcp311_pre1',STATUS,1) 
      LET g_success='N' 
   END IF 
   DECLARE axcp311_cur1 CURSOR FOR axcp311_pre1
   IF STATUS THEN
      CALL cl_err('axcp311_cur1',STATUS,1) 
      LET g_success='N' 
   END IF 
   FOREACH axcp311_cur1 INTO cdc.*
      LET l_cdb05 = cdc.cdc05    #成本                #MOD-840434 add
      LET l_cdb06 = cdc.cdc06    #分攤基礎指標總數    #MOD-840434 add
 
      #統計指標總數(cdc06)
      CALL axcp311_dis1(cdc.*) RETURNING cdc.cdc06
 
      #成本(cdc05)
      #cdc05 = cdb05 * cdc06 / cdb06
      LET cdc.cdc05 = l_cdb05 * cdc.cdc06 / l_cdb06   #MOD-840434 add
      IF cdc.cdc05 IS NULL THEN LET cdc.cdc05=0 END IF  
 
      #單位成本(cdc07) = 成本(cdc05) / 分攤基準指標總數(cdc06)
      LET cdc.cdc07 = cdc.cdc05 / cdc.cdc06 
      IF cdc.cdc07 IS NULL THEN LET cdc.cdc07=0 END IF 
 
      LET cdc.cdcuser   = g_user    #資料所有者
      LET cdc.cdcgrup   = g_grup    #資料所有群
      LET cdc.cdcmodu   = ''        #資料更改者
      LET cdc.cdcdate   = g_today   #最近修改日
     #LET cdc.cdcplant  = g_plant   #FUN-980009 add    #FUN-A50075
      LET cdc.cdclegal  = g_legal   #FUN-980009 add
 
      LET cdc.cdcoriu = g_user      #No.FUN-980030 10/01/04
      LET cdc.cdcorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO cdc_file VALUES(cdc.*)
      IF SQLCA.sqlcode THEN
         LET g_showmsg= cdc.cdc01,"/",cdc.cdc02
         CALL s_errmsg('cdc01,cdc02',g_showmsg,'upd cdc',STATUS,1)
         LET g_success='N'
         CONTINUE FOREACH
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF 

   #MOD-C30820 str add-----
   #抓出cdc_file逐筆計算
   DECLARE axcp311_cdc_pre CURSOR FOR
    SELECT DISTINCT cdc01,cdc02,cdc03,cdc04 FROM cdc_file
     WHERE cdc01=tm.yy
       AND cdc02=tm.mm
   FOREACH axcp311_cdc_pre INTO g_cdc01,g_cdc02,g_cdc03,g_cdc04
      #取出成本金額
      LET l_sql="SELECT cdb05,SUM(cdc05) ",
                "  FROM cdc_file,cdb_file ",
                " WHERE cdc01 = ",g_cdc01,
                "   AND cdc02 = ",g_cdc02,
                "   AND cdc03 ='",g_cdc03,"'",
                "   AND cdc04 ='",g_cdc04,"'",
                "   AND cdc01=cdb01",
                "   AND cdc02=cdb02",
                "   AND cdc03=cdb03",
                "   AND cdc04=cdb04",
                " GROUP BY cdb05"
      PREPARE p311_tot_p FROM l_sql
      DECLARE p311_tot_c CURSOR FOR p311_tot_p
      OPEN p311_tot_c
      FETCH p311_tot_c INTO g_tot_cdc05,g_tot_cdc06
      CLOSE p311_tot_c
      
      #取出成本金額
      LET l_sql="SELECT cdc041 ",
                "  FROM cdc_file",
                " WHERE cdc01 = ",g_cdc01,
                "   AND cdc02 = ",g_cdc02,
                "   AND cdc03 ='",g_cdc03,"'",
                "   AND cdc04 ='",g_cdc04,"'",
                "   AND cdc06=(",
                " SELECT MAX(cdc06) FROM cdc_file",
                "  WHERE cdc01 = ",g_cdc01,
                "    AND cdc02 = ",g_cdc02,
                "    AND cdc03 ='",g_cdc03,"'",
                "    AND cdc04 ='",g_cdc04,"')"
      PREPARE p311_cdc041_p FROM l_sql
      DECLARE p311_cdc041_c CURSOR FOR p311_cdc041_p
      OPEN p311_cdc041_c
      FETCH p311_cdc041_c INTO g_cdc041
      CLOSE p311_cdc041_c
      IF g_tot_cdc05-g_tot_cdc06>0 THEN
         LET g_diff=g_tot_cdc05-g_tot_cdc06
         #更新最大筆分攤工單成本+差異
         UPDATE cdc_file SET cdc05=cdc05+g_diff
          WHERE cdc01=g_cdc01
            AND cdc02=g_cdc02
            AND cdc03=g_cdc03
            AND cdc04=g_cdc04
            AND cdc041=g_cdc041
         IF STATUS OR SQLCA.sqlerrd[3]<>'1'  THEN 
            LET g_showmsg= g_cdc01,"/",g_cdc02,"/",g_cdc03,"/",g_cdc04 
            CALL s_errmsg('cdc01,cdc02,cdc03,cdc04',g_showmsg,'upd cdc_file',STATUS,1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF 
      END IF
   END FOREACH
   #MOD-C30820 end add-----
 
  #當月起始日與截止日
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_cci01b,l_cci01e   #CHI-9A0021 add

   #4.確認當月的每日工時檔(cci_file) 
   DECLARE cci_cur CURSOR FOR 
    SELECT cci01,cci02 FROM cci_file 
    #WHERE YEAR(cci01)=tm.yy AND MONTH(cci01)=tm.mm  #CHI-9A0021
     WHERE cci01 BETWEEN l_cci01b AND l_cci01e       #CHI-9A0021
       AND ccifirm <> 'X'  #CHI-C80041
   FOREACH cci_cur INTO l_cci01,l_cci02 
      IF STATUS THEN 
         CALL s_errmsg('','','cci_for',STATUS,1)
         LET g_success='N'    
         EXIT FOREACH 
      END IF 
      IF g_success='N' THEN  
         LET g_totsuccess='N'  
         LET g_success="Y"   
      END IF 
 
      UPDATE cci_file SET ccifirm='Y' WHERE cci01=l_cci01 AND cci02=l_cci02 
      IF STATUS THEN 
         LET g_showmsg= l_cci01,"/",l_cci02 
         CALL s_errmsg('cci02,cci02',g_showmsg,'upd ccifirm',STATUS,1)
         LET g_success='N'
         CONTINUE FOREACH
      END IF 
   END FOREACH 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF 
 
END FUNCTION
 
FUNCTION axcp311_dis(p_cdb) 
   DEFINE p_cdb         RECORD LIKE cdb_file.* 
   DEFINE l_sum         LIKE ccj_file.ccj05 
   DEFINE l_qty         LIKE ccj_file.ccj06   #生產數量
   DEFINE l_cda07       LIKE cda_file.cda07   #分攤權數
   DEFINE l_cda08       LIKE cda_file.cda08    #FUN-8B0047
   DEFINE l_cda09       LIKE cda_file.cda09    #FUN-8B0047
   DEFINE l_cdb07       LIKE cdb_file.cdb07    #FUN-8B0047
   DEFINE l_cdc         RECORD LIKE cdc_file.*    #FUN-8B0047
   DEFINE l_ccj01b      LIKE ccj_file.ccj01    #CHI-9A0021 add
   DEFINE l_ccj01e      LIKE ccj_file.ccj01    #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1    #CHI-9A0021 add 

  #當月起始日與截止日
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_ccj01b,l_ccj01e   #CHI-9A0021 add
 
   CASE p_cdb.cdb08 
      WHEN '1' #實際工時
              SELECT SUM(ccj05) INTO l_sum FROM ccj_file
              #WHERE YEAR(ccj01)=tm.yy AND MONTH(ccj01)=tm.mm   #CHI-9A0021
               WHERE ccj01 BETWEEN l_ccj01b AND l_ccj01e        #CHI-9A0021
                 AND ccj02=p_cdb.cdb03
      WHEN '2' #標準工時
              SELECT SUM(ccj07) INTO l_sum FROM ccj_file
              #WHERE YEAR(ccj01)=tm.yy AND MONTH(ccj01)=tm.mm   #CHI-9A0021
               WHERE ccj01 BETWEEN l_ccj01b AND l_ccj01e        #CHI-9A0021
                 AND ccj02=p_cdb.cdb03
      WHEN '3' #標準機時
              SELECT SUM(ccj071) INTO l_sum FROM ccj_file
              #WHERE YEAR(ccj01)=tm.yy AND MONTH(ccj01)=tm.mm   #CHI-9A0021
               WHERE ccj01 BETWEEN l_ccj01b AND l_ccj01e        #CHI-9A0021
                 AND ccj02=p_cdb.cdb03
      WHEN '4' #產出數量*分攤權數
              SELECT SUM(ccj06) INTO l_qty FROM ccj_file
              #WHERE YEAR(ccj01)=tm.yy AND MONTH(ccj01)=tm.mm   #CHI-9A0021
               WHERE ccj01 BETWEEN l_ccj01b AND l_ccj01e        #CHI-9A0021
                 AND ccj02=p_cdb.cdb03
              SELECT cda07 INTO l_cda07 FROM cda_file
               WHERE cda01=p_cdb.cdb03 AND cda02=p_cdb.cdb04
              #產出數量*該成本中心之成本項目的分攤係數cda07
              LET l_sum = l_qty * l_cda07
      #FUN-840181
      WHEN '5' #實際機時
              SELECT SUM(ccj051) INTO l_sum FROM ccj_file
              #WHERE YEAR(ccj01)=tm.yy AND MONTH(ccj01)=tm.mm   #CHI-9A0021
               WHERE ccj01 BETWEEN l_ccj01b AND l_ccj01e        #CHI-9A0021
                 AND ccj02=p_cdb.cdb03
      #--
       EXIT CASE 
   END CASE 
   IF l_sum IS NULL THEN LET l_sum=0 END IF 
 
   #FUN-8B0047 start
   LET l_cda08=''
   LET l_cda09=''
   LET l_cda08=p_cdb.cdb09
   LET l_cda09=p_cdb.cdb10
   IF cl_null(l_cda08) THEN LET l_cda08='1' END IF 
   IF cl_null(l_cda09) THEN LET l_cda09=0 END IF 
   IF p_cdb.cdb04 MATCHES '[23456]' AND l_cda08='1' AND
      l_sum < l_cda09 THEN 
      INITIALIZE l_cdc.* TO NULL
      LET l_cdc.cdc01     = p_cdb.cdb01
      LET l_cdc.cdc02     = p_cdb.cdb02
      LET l_cdc.cdc03     = p_cdb.cdb03
      LET l_cdc.cdc04     = p_cdb.cdb04
      LET l_cdc.cdc041    = 'OH-FIXED'
      LET l_cdb07=p_cdb.cdb05/l_cda09
      LET l_cdc.cdc05     = p_cdb.cdb05 - (l_cdb07*l_sum)
      LET l_cdc.cdc06     = 0
      LET l_cdc.cdc07     = 0
      LET l_cdc.cdc08     = p_cdb.cdb08
      LET l_cdc.cdcuser   = g_user    #資料所有者
      LET l_cdc.cdcgrup   = g_grup    #資料所有群
      LET l_cdc.cdcmodu   = ''        #資料更改者
      LET l_cdc.cdcdate   = g_today   #最近修改日
     #LET l_cdc.cdcplant  = g_plant   #FUN-980009 add   #FUN-A50075
      LET l_cdc.cdclegal  = g_legal   #FUN-980009 add
      #No.FUN-9B0118  --Begin
      LET l_cdc.cdc00     = p_cdb.cdb00
      LET l_cdc.cdc11     = p_cdb.cdb11
      LET l_cdc.cdc12     = p_cdb.cdb12
      LET l_cdc.cdc13     = p_cdb.cdb13
      #No.FUN-9B0118  --End  
      LET l_cdc.cdcoriu = g_user      #No.FUN-980030 10/01/04
      LET l_cdc.cdcorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO cdc_file VALUES(l_cdc.*)
      LET l_sum=l_cda09
   END IF
   #FUN-8B0047 end
 
   RETURN l_sum 
END FUNCTION 
 
FUNCTION axcp311_dis1(p_cdc) 
   DEFINE p_cdc         RECORD LIKE cdc_file.* 
   DEFINE l_sum         LIKE ccj_file.ccj05 
   DEFINE l_qty         LIKE ccj_file.ccj06   #生產數量
   DEFINE l_cda07       LIKE cda_file.cda07   #分攤權數
   DEFINE l_ccj01b      LIKE ccj_file.ccj01   #CHI-9A0021 add
   DEFINE l_ccj01e      LIKE ccj_file.ccj01   #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1   #CHI-9A0021 add 

  #當月起始日與截止日
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct,l_ccj01b,l_ccj01e   #CHI-9A0021 add

   CASE p_cdc.cdc08 
      WHEN '1' #實際工時
              SELECT SUM(ccj05) INTO l_sum FROM ccj_file
              #WHERE YEAR(ccj01)=tm.yy AND MONTH(ccj01)=tm.mm  #CHI-9A0021
               WHERE ccj01 BETWEEN l_ccj01b AND l_ccj01e       #CHI-9A0021
                 AND ccj02=p_cdc.cdc03 AND ccj04=p_cdc.cdc041
      WHEN '2' #標準工時
              SELECT SUM(ccj07) INTO l_sum FROM ccj_file
              #WHERE YEAR(ccj01)=tm.yy AND MONTH(ccj01)=tm.mm  #CHI-9A0021
               WHERE ccj01 BETWEEN l_ccj01b AND l_ccj01e       #CHI-9A0021
                 AND ccj02=p_cdc.cdc03 AND ccj04=p_cdc.cdc041
      WHEN '3' #標準機時
              SELECT SUM(ccj071) INTO l_sum FROM ccj_file
              #WHERE YEAR(ccj01)=tm.yy AND MONTH(ccj01)=tm.mm  #CHI-9A0021
               WHERE ccj01 BETWEEN l_ccj01b AND l_ccj01e       #CHI-9A0021
                 AND ccj02=p_cdc.cdc03 AND ccj04=p_cdc.cdc041
      WHEN '4' #產出數量*分攤權數
              SELECT SUM(ccj06) INTO l_qty FROM ccj_file
              #WHERE YEAR(ccj01)=tm.yy AND MONTH(ccj01)=tm.mm  #CHI-9A0021
               WHERE ccj01 BETWEEN l_ccj01b AND l_ccj01e       #CHI-9A0021
                 AND ccj02=p_cdc.cdc03 AND ccj04=p_cdc.cdc041
             #FUN-960024--begin--mod-- 
             #SELECT cda07 INTO l_cda07 FROM cda_file 
             # WHERE cda01=p_cdc.cdc03 AND cda02=p_cdc.cdc04 
              LET g_sql = "SELECT cda07 FROM cda_file ", 
                          " WHERE cda01 = '",p_cdc.cdc03,"' ",
                          "   AND cda02 = '",p_cdc.cdc04,"'" 
               PREPARE p311_cda_prepare FROM g_sql
               DECLARE p311_cda_cs CURSOR FOR p311_cda_prepare 
               FOREACH p311_cda_cs INTO l_cda07 
                   EXIT FOREACH 
               END FOREACH 
              #FUN-960024--end--mod--
              #產出數量*該成本中心之成本項目的分攤係數cda07
              LET l_sum = l_qty * l_cda07
      #FUN-840181
      WHEN '5' #實際機時
              SELECT SUM(ccj051) INTO l_sum FROM ccj_file
              #WHERE YEAR(ccj01)=tm.yy AND MONTH(ccj01)=tm.mm  #CHI-9A0021
               WHERE ccj01 BETWEEN l_ccj01b AND l_ccj01e       #CHI-9A0021
                 AND ccj02=p_cdc.cdc03 AND ccj04=p_cdc.cdc041
      #--
       EXIT CASE 
   END CASE 
   IF l_sum IS NULL THEN LET l_sum=0 END IF 
   RETURN l_sum 
END FUNCTION 
#FUN-7C0028
