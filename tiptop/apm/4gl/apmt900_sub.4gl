# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: apmt900.4gl
# Descriptions...: 请购变更单维护作业
# Date & Author..: 10/08/24 By Carrier  #No.FUN-A80115
# Modify.........: No.MOD-B30274 11/03/12 By wangxin apmt900 新增項次 ( 原請購單不存在者 ) 備註會回寫至請購單身 ( pml06) 
#................:                                           但若原請購項次新增備註卻不會回寫至請購單身。 
# Modify.........: No.FUN-B30076 11/04/21 By suncx 新增取消確認和發出功能
# Modify.........: No.FUN-910088  11/12/05 By chenjing 增加數量欄位小數取位
# Modify.........: No.TQC-C10052 12/01/13 By SunLM 修正到庫前置期（除去非工作日）
# Modify.........: No.TQC-C30173 12/03/14 By lixiang 服飾流通業下變更單的修改(更新母料件的資料)
# Modify.........: No:MOD-C30822 12/03/22 by Vampire 取消發出不應該update pneconf='Y',將更新段搬到t900sub_update_pr中處理
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C70116 12/07/19 By yangtt  數量變更后金額欄位重新計算         
# Modify.........: No.MOD-C80081 12/09/17 By jt_chen 請購變更發出時,請增加回寫已轉請購量
# Modify.........: No.MOD-CB0261 13/02/04 By jt_chen 調整單別設定立即確認時,重新DISPLAY確認否與狀況碼
# Modify.........: No.CHI-CB0002 13/02/25 By Elise 確認段控卡，預算認列

DATABASE ds  #No.FUN-A80115

GLOBALS "../../config/top.global"

#CHI-CB0002---add---S
DEFINE g_bookno1     LIKE aza_file.aza81
DEFINE g_bookno2     LIKE aza_file.aza82
DEFINE g_flag        LIKE type_file.chr1
#CHI-CB0002---add---E

FUNCTION t900sub_lock_cl() #FUN-A60034
   DEFINE l_forupd_sql STRING

   LET l_forupd_sql = "SELECT * FROM pne_file WHERE pne01 = ? AND pne02 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE t900sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

FUNCTION t900sub_y_chk(p_pne01,p_pne02)
   DEFINE p_pne01  LIKE pne_file.pne01
   DEFINE p_pne02  LIKE pne_file.pne02
   DEFINE l_pne    RECORD LIKE pne_file.*
   DEFINE l_cnt2   LIKE type_file.num5
   DEFINE l_pnf03  LIKE pnf_file.pnf03
   DEFINE l_pnf20a LIKE pnf_file.pnf20a
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_pml21  LIKE pml_file.pml21
   DEFINE l_slip   LIKE smy_file.smyslip  #CHI-CB0002 add

   CALL s_showmsg_init()  #CHI-CB0002 add

   LET g_success = 'Y'

   IF s_shut(0) THEN
      LET g_success = 'N'
      RETURN
   END IF

   IF cl_null(p_pne01) OR cl_null(p_pne02) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
#CHI-C30107 ------------ add ------------- begin
   IF l_pne.pne06 = 'Y' THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_pne.pne06 = 'X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_pne.pneacti='N' THEN
      CALL cl_err('','mfg0301',1)
      LET g_success = 'N'
      RETURN
   END IF

   IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"  THEN
      IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF 
   END IF
#CHI-C30107 ------------ add ------------- end
   SELECT * INTO l_pne.* FROM pne_file
    WHERE pne01 = p_pne01
      AND pne02 = p_pne02
   IF l_pne.pne01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_pne.pne06 = 'Y' THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_pne.pne06 = 'X' THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_pne.pneacti='N' THEN
      CALL cl_err('','mfg0301',1)
      LET g_success = 'N'
      RETURN
   END IF

   LET l_cnt2 = 0
   #因為可只變更單頭,故可不輸入單身
   SELECT COUNT(*) INTO l_cnt2 FROM pnf_file
    WHERE pnf01 = l_pne.pne01
      AND pnf02 = l_pne.pne02
   IF cl_null(l_pne.pne09b) AND cl_null(l_pne.pne10b) AND
      cl_null(l_pne.pne11b) AND cl_null(l_pne.pne12b) AND
      cl_null(l_pne.pne13b) AND l_cnt2 = 0 THEN
      CALL cl_err(l_pne.pne01,'apm1020',0)
      LET g_success = 'N'
      RETURN
   END IF

   DECLARE pnf_cur CURSOR FOR
    SELECT pnf03,pnf20a FROM pnf_file
     WHERE pnf01 = l_pne.pne01
       AND pnf02 = l_pne.pne02
   FOREACH pnf_cur INTO l_pnf03,l_pnf20a
      LET l_cnt = 0
      SELECT COUNT(*),pml21 INTO l_cnt,l_pml21 FROM pml_file
       WHERE pml01 = l_pne.pne01
         AND pml02 = l_pnf03
       GROUP BY pml21
      IF l_cnt = 0 THEN
         IF l_pnf20a <= 0 OR cl_null(l_pnf20a) THEN
            CALL cl_err(l_pnf03,'mfg3348',0)
            LET g_success = ' N'
            RETURN
         END IF
      ELSE
         IF l_pnf20a IS NOT NULL THEN
            IF l_pnf20a < l_pml21 THEN
               CALL cl_err(l_pnf03,'apm-178',0)
               LET g_success = ' N'
               RETURN
            END IF
         END IF 
      END IF
     #CHI-CB0002---add---S
      CALL s_get_doc_no(p_pne01) RETURNING l_slip
      SELECT smy59 INTO g_smy.smy59 FROM smy_file
       WHERE smyslip = l_slip
      IF g_smy.smy59 = 'Y' THEN
         CALL t900sub_bud(l_pne.pne01,l_pne.pne02,l_pnf03)
      END IF
     #CHI-CB0002---add---E      
   END FOREACH

   CALL s_showmsg()  #CHI-CB0002 add

END FUNCTION

FUNCTION t900sub_y_upd(p_pne01,p_pne02,p_action_choice)
   DEFINE p_pne01              LIKE pne_file.pne01
   DEFINE p_pne02              LIKE pne_file.pne02
   DEFINE p_action_choice      STRING
   DEFINE l_pne                RECORD LIKE pne_file.*


   SELECT * INTO l_pne.* FROM pne_file WHERE pne01 = p_pne01 AND pne02 = p_pne02

   LET g_success = 'Y'
   IF p_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      p_action_choice CLIPPED = "insert"
   THEN
      IF l_pne.pnemksg='Y'   THEN
         IF l_pne.pne14 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   END IF

   BEGIN WORK

   CALL t900sub_lock_cl()

   OPEN t900sub_cl USING p_pne01,p_pne02
   IF STATUS THEN
      CALL cl_err("OPEN t900sub_cl:", STATUS, 1)
      CLOSE t900sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900sub_cl INTO l_pne.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_pne.pne01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t900sub_cl
      ROLLBACK WORK
      RETURN
   END IF

   #FUN-B30076  mark begin--------------------------發出時才執行更新請購單的操作
   #CALL t900sub_update_pr(l_pne.pne01,l_pne.pne02)
   #IF g_success = 'N' THEN
   #   ROLLBACK WORK
   #   RETURN
   #END IF
   #FUN-B30076  mark -end---------------------------

   UPDATE pne_file SET pne06 = 'Y'
    WHERE pne01 = l_pne.pne01 AND pne02=l_pne.pne02
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','pne_file',l_pne.pne01,l_pne.pne02,SQLCA.sqlcode,'update pne06','',1)
      LET g_success = 'N'
   END IF
   IF l_pne.pnemksg = 'N' AND l_pne.pne14 = '0' THEN
      LET l_pne.pne14 = '1'
      UPDATE pne_file SET pne14 = l_pne.pne14
       WHERE pne01=l_pne.pne01 AND pne02 = l_pne.pne02
      IF SQLCA.sqlcode THEN
         CALL cl_err3('upd','pne_file',l_pne.pne01,l_pne.pne02,SQLCA.sqlcode,'update pne14','',1)
         LET g_success = 'N'
      END IF
   END IF

   IF g_success = 'Y' THEN
      IF l_pne.pnemksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET l_pne.pne06="N"
                  LET g_success = "N"
                  ROLLBACK WORK
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET l_pne.pne06="N"
                  ROLLBACK WORK
                  RETURN
        END CASE
      END IF

      IF g_success = 'Y' THEN
         LET l_pne.pne14='1'        #執行成功, 狀態值顯示為 '1' 已核准
         LET l_pne.pne06='Y'        #執行成功, 確認碼顯示為 'Y' 已確認
         COMMIT WORK
      ELSE
         LET l_pne.pne06 = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      ROLLBACK WORK
   END IF
   #MOD-CB0261 -- add start --
   SELECT pne06,pne14 INTO l_pne.pne06,l_pne.pne14 FROM pne_file
    WHERE pne01 = l_pne.pne01 AND pne02=l_pne.pne02
   DISPLAY l_pne.pne06 TO pne06
   DISPLAY l_pne.pne14 TO pne14
   #MOD-CB0261 -- add end --

END FUNCTION

FUNCTION t900sub_refresh(p_pne01,p_pne02)
   DEFINE p_pne01  LIKE pne_file.pne01
   DEFINE p_pne02  LIKE pne_file.pne02
   DEFINE l_pne    RECORD LIKE pne_file.*

   SELECT * INTO l_pne.* FROM pne_file WHERE pne01 = p_pne01 AND pne02 = p_pne02
   RETURN l_pne.*
END FUNCTION

FUNCTION t900sub_update_pr(p_pne01,p_pne02)
   DEFINE p_pne01      LIKE pne_file.pne01
   DEFINE p_pne02      LIKE pne_file.pne02
   DEFINE l_pne        RECORD LIKE pne_file.*
   DEFINE l_pnf        RECORD LIKE pnf_file.*
   DEFINE l_pmk        RECORD LIKE pmk_file.*
   DEFINE l_pml        RECORD LIKE pml_file.*
   DEFINE l_flag       LIKE type_file.chr1
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_fac        LIKE pml_file.pml09
   DEFINE l_ima49      LIKE ima_file.ima49
   DEFINE l_ima491     LIKE ima_file.ima491
   DEFINE l_ima913     LIKE ima_file.ima913
   DEFINE l_ima914     LIKE ima_file.ima914
   DEFINE l_forupd_sql STRING
   DEFINE l_pmlslk02   LIKE pmlslk_file.pmlslk02,   #TQC-C30173 add
          l_pmlslk04   LIKE pmlslk_file.pmlslk04,   #TQC-C30173 add
          l_pmlslk20   LIKE pmlslk_file.pmlslk20,   #TQC-C30173 add
          l_pmlslk88   LIKE pmlslk_file.pmlslk88,   #TQC-C30173 add
          l_pmlslk88t  LIKE pmlslk_file.pmlslk88t   #TQC-C30173 add
   DEFINE t_azi04      LIKE azi_file.azi04          #TQC-C30173 add
   
   SELECT * INTO l_pne.* FROM pne_file WHERE pne01 = p_pne01 AND pne02 = p_pne02
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','pne_file',p_pne01,p_pne02,SQLCA.sqlcode,'select pne','',1)
      LET g_success = 'N'
      RETURN
   END IF
   #FUN-B30076 add begin------------------
   IF l_pne.pne06 = 'N' OR l_pne.pne06 = 'X' OR l_pne.pneconf = 'Y' THEN
      CALL cl_err(l_pne.pne01,'apm1058', 0)
      LET g_success = 'N'
      RETURN 
   END IF
   IF NOT cl_confirm('art-859') THEN RETURN END IF
   #FUN-B30076 add -end-------------------

   LET l_forupd_sql = "SELECT * FROM pmk_file WHERE pmk01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE t900sub_pmk_cl CURSOR FROM l_forupd_sql

   LET l_forupd_sql = "SELECT * FROM pml_file WHERE pml01 = ? AND pml02 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE t900sub_pml_cl CURSOR FROM l_forupd_sql

  #TQC-C30173--add--begin--
   IF s_industry("slk") AND g_azw.azw04= '2' THEN
      LET l_forupd_sql = "SELECT * FROM pmlslk_file WHERE pmlslk01 = ? AND pmlslk02 = ? FOR UPDATE"
      LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
      DECLARE t900sub_pmlslk_cl CURSOR FROM l_forupd_sql
   END IF
  #TQC-C30173--add--end--

   OPEN t900sub_pmk_cl USING l_pne.pne01
   IF STATUS THEN
      CALL cl_err("OPEN t900sub_pmk_cl:", STATUS, 1)
      CLOSE t900sub_pmk_cl
      LET g_success = 'N'
      RETURN
   END IF
   FETCH t900sub_pmk_cl INTO l_pmk.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_pne.pne01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t900sub_pmk_cl
      LET g_success = 'N'
      RETURN
   END IF

   #币种
   IF NOT cl_null(l_pne.pne09b) THEN
      LET l_pmk.pmk22 = l_pne.pne09b
      IF g_aza.aza17 = l_pmk.pmk22 THEN   #本幣
         LET l_pmk.pmk42 = 1
      ELSE
         CALL s_curr3(l_pmk.pmk22,l_pmk.pmk04,g_sma.sma904)
              RETURNING l_pmk.pmk42
      END IF
   END IF
   #付款条件
   IF NOT cl_null(l_pne.pne10b) THEN
      LET l_pmk.pmk20 = l_pne.pne10b
   END IF
   #价格条件
   IF NOT cl_null(l_pne.pne11b) THEN
      LET l_pmk.pmk41 = l_pne.pne11b
   END IF
   #送货地址
   IF NOT cl_null(l_pne.pne12b) THEN
      LET l_pmk.pmk10 = l_pne.pne12b
   END IF
   #帐单地址
   IF NOT cl_null(l_pne.pne13b) THEN
      LET l_pmk.pmk11 = l_pne.pne13b
   END IF

   LET l_pmk.pmk03 = l_pne.pne02
   LET l_pmk.pmkmodu = g_user
   LET l_pmk.pmkdate = g_today
   UPDATE pmk_file SET * = l_pmk.*
    WHERE pmk01 = l_pmk.pmk01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','pmk_file',l_pmk.pmk01,'',SQLCA.sqlcode,'','',1)
      LET g_success = 'N'
      CLOSE t900sub_pmk_cl
      RETURN
   END IF
   CLOSE t900sub_pmk_cl

   DECLARE t900sub_pnf_cs CURSOR FOR
    SELECT * FROM pnf_file
     WHERE pnf01 = l_pne.pne01
       AND pnf02 = l_pne.pne02
   FOREACH t900sub_pnf_cs INTO l_pnf.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach t900sub_pml_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      SELECT * FROM pml_file WHERE pml01 = l_pne.pne01 AND pml02 = l_pnf.pnf03
      #修改
      IF SQLCA.sqlcode = 0 THEN
         #TQC-C30173--add--begin--
         IF s_industry("slk") AND g_azw.azw04= '2' THEN
            SELECT pmlslk02,pmlslk04 INTO l_pmlslk02,l_pmlslk04 FROM pmlslk_file,pmli_file
                  WHERE pmlslk01=pmli01 AND pmlslk02=pmlislk03 AND pmlslk04=pmlislk02
                    AND pmli01=l_pne.pne01 AND pmli02=l_pnf.pnf03
            OPEN t900sub_pmlslk_cl USING l_pne.pne01,l_pmlslk02
            IF STATUS THEN
               CALL cl_err("OPEN t900sub_pmlslk_cl:", STATUS, 1)
               CLOSE t900sub_pmlslk_cl
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         #TQC-C30173--add--end--
         OPEN t900sub_pml_cl USING l_pne.pne01,l_pnf.pnf03
         IF STATUS THEN
            CALL cl_err("OPEN t900sub_pml_cl:", STATUS, 1)
            CLOSE t900sub_pml_cl
            LET g_success = 'N'
            RETURN
         END IF
         FETCH t900sub_pml_cl INTO l_pml.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(l_pne.pne01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE t900sub_pml_cl
            LET g_success = 'N'
            RETURN
         END IF

     #FUN-910088--add--start--
        IF NOT cl_null(l_pnf.pnf07a) AND cl_null(l_pnf.pnf20a) THEN
           LET l_pnf.pnf20a = s_digqty(l_pnf.pnf20a,l_pnf.pnf07a)
        END IF
        IF NOT cl_null(l_pnf.pnf80a) AND cl_null(l_pnf.pnf82a) THEN
           LET l_pnf.pnf82a = s_digqty(l_pnf.pnf82a,l_pnf.pnf80a)
        END IF
        IF NOT cl_null(l_pnf.pnf83a) AND cl_null(l_pnf.pnf85a) THEN
           LET l_pnf.pnf85a = s_digqty(l_pnf.pnf85a,l_pnf.pnf83a)
        END IF
        IF NOT cl_null(l_pnf.pnf86a) AND cl_null(l_pnf.pnf87a) THEN
           LET l_pnf.pnf87a = s_digqty(l_pnf.pnf87a,l_pnf.pnf86a)
        END IF
     #FUN-910088--add--end--
         #料号
         IF NOT cl_null(l_pnf.pnf04a) THEN
            LET l_pml.pml04 = l_pnf.pnf04a
            SELECT ima25 INTO l_pml.pml08 FROM ima_file
             WHERE ima01 = l_pml.pml04
         END IF
         #品名
         IF NOT cl_null(l_pnf.pnf041a) THEN
            LET l_pml.pml041 = l_pnf.pnf041a
         END IF
         #单位
         IF NOT cl_null(l_pnf.pnf07a) THEN
            LET l_pml.pml07 = l_pnf.pnf07a
         END IF
         IF NOT cl_null(l_pnf.pnf04a) OR NOT cl_null(l_pnf.pnf07a) THEN
            CALL s_umfchk(l_pml.pml04,l_pml.pml07,l_pml.pml08)
                 RETURNING l_i,l_fac
            IF l_i = 1 THEN
               LET l_fac = 1
            END IF
            LET l_pml.pml09 = l_fac
         END IF
         #数量
         IF NOT cl_null(l_pnf.pnf20a) THEN
            LET l_pml.pml20 = l_pnf.pnf20a
       #TQC-C70116--add--begin--
            SELECT azi04 INTO t_azi04 FROM azi_file
                WHERE azi01 = l_pmk.pmk22  AND aziacti= 'Y'  #原幣
            LET l_pml.pml88 = cl_digcut(l_pml.pml20*l_pml.pml31,t_azi04)
            LET l_pml.pml88t= cl_digcut(l_pml.pml20*l_pml.pml31t,t_azi04)
       #TQC-C70116--add--end--
       #TQC-C30173--add--begin--  
            IF s_industry("slk") AND g_azw.azw04 = '2' THEN
               SELECT azi04 INTO t_azi04 FROM azi_file
                   WHERE azi01 = l_pmk.pmk22  AND aziacti= 'Y'  #原幣
               LET l_pml.pml88 = cl_digcut(l_pml.pml20*l_pml.pml31,t_azi04)
               LET l_pml.pml88t= cl_digcut(l_pml.pml20*l_pml.pml31t,t_azi04)  
            END IF
       #TQC-C30173--add--end--    
         END IF
         #单位一
         IF NOT cl_null(l_pnf.pnf80a) THEN
            LET l_pml.pml80 = l_pnf.pnf80a
         END IF
         #单位一转换率
         IF NOT cl_null(l_pnf.pnf81a) THEN
            LET l_pml.pml81 = l_pnf.pnf81a
         END IF
         #单位一数量
         IF NOT cl_null(l_pnf.pnf82a) THEN
            LET l_pml.pml82 = l_pnf.pnf82a
         END IF
         #单位二
         IF NOT cl_null(l_pnf.pnf83a) THEN
            LET l_pml.pml83 = l_pnf.pnf83a
         END IF
         #单位二转换率
         IF NOT cl_null(l_pnf.pnf84a) THEN
            LET l_pml.pml84 = l_pnf.pnf84a
         END IF
         #单位二数量
         IF NOT cl_null(l_pnf.pnf85a) THEN
            LET l_pml.pml85 = l_pnf.pnf85a
         END IF
         #计价单位
         IF NOT cl_null(l_pnf.pnf86a) THEN
            LET l_pml.pml86 = l_pnf.pnf86a
         END IF
         #计价数量
         IF NOT cl_null(l_pnf.pnf87a) THEN
            LET l_pml.pml87 = l_pnf.pnf87a
         END IF
         #PLP-No
         IF NOT cl_null(l_pnf.pnf41a) THEN
            LET l_pml.pml41 = l_pnf.pnf41a
         END IF
         #项目编号
         IF NOT cl_null(l_pnf.pnf12a) THEN
            LET l_pml.pml12 = l_pnf.pnf12a
         END IF
         #WBS编码
         IF NOT cl_null(l_pnf.pnf121a) THEN
            LET l_pml.pml121 = l_pnf.pnf121a
         END IF
         #活动编码
         IF NOT cl_null(l_pnf.pnf122a) THEN
            LET l_pml.pml122 = l_pnf.pnf122a
         END IF
         #交货日期
         IF NOT cl_null(l_pnf.pnf33a) THEN
            LET l_pml.pml33 = l_pnf.pnf33a
            SELECT ima49,ima491 INTO l_ima49,l_ima491 FROM ima_file
             WHERE ima01 = l_pml.pml04
            IF cl_null(l_ima49)  THEN LET l_ima49 = 0 END IF
            IF cl_null(l_ima491) THEN LET l_ima491= 0 END IF
            CALL s_aday(l_pml.pml33,1,l_ima49)  RETURNING l_pml.pml34
            #CALL s_aday(l_pml.pml33,1,l_ima491) RETURNING l_pml.pml35 #TQC-C10052 mark
            CALL s_aday(l_pml.pml34,1,l_ima491) RETURNING l_pml.pml35  #TQC-C10052 add
         END IF
         #update pml_file
         UPDATE pml_file SET * = l_pml.*
          WHERE pml01 = l_pne.pne01
            AND pml02 = l_pnf.pnf03
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3('upd','pml_file',l_pne.pne01,l_pnf.pnf03,SQLCA.sqlcode,'','','1')
            CLOSE t900sub_pml_cl
            LET g_success = 'N'
            RETURN
       #TQC-C30173--add--begin--
         ELSE
            IF s_industry("slk") AND g_azw.azw04 = '2' THEN
               SELECT SUM(pml20),SUM(pml88),SUM(pml88t) INTO l_pmlslk20,l_pmlslk88,l_pmlslk88t FROM pml_file,pmli_file
                   WHERE pml01=pmli01 AND pml02=pmli02 AND pmli01=l_pml.pml01
                     AND pmlislk02=l_pmlslk04 AND pmlislk03=l_pmlslk02
                     AND pmlplant=l_pml.pmlplant
               UPDATE pmlslk_file SET pmlslk20=l_pmlslk20,
                                      pmlslk88=l_pmlslk88,
                                      pmlslk88t=l_pmlslk88t 
                   WHERE pmlslk01=l_pml.pml01
                     AND pmlslk02=l_pmlslk02
                     AND pmlslk04=l_pmlslk04   
                     AND pmlslkplant=l_pml.pmlplant
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3('upd','pmlslk_file',l_pne.pne01,l_pnf.pnf03,SQLCA.sqlcode,'','','1')
                  CLOSE t900sub_pmlslk_cl
                  LET g_success = 'N'
                  RETURN       
               END IF
               CLOSE t900sub_pmlslk_cl
            END IF  
       #TQC-C30173--add--end-- 
         END IF
         CLOSE t900sub_pml_cl
         #MOD-C80081 -- add start--
         IF NOT cl_null(l_pml.pml24) AND NOT cl_null(l_pml.pml25) THEN
            SELECT SUM(pml20) INTO l_pnf.pnf20a
             FROM pml_file,pmk_file
            WHERE pml24 = l_pml.pml24
              AND pml25 = l_pml.pml25
              AND pml01 = pmk01
              AND pmk18 <> 'X'
              AND pml16 <> '9'
            IF cl_null(l_pnf.pnf20a) THEN LET l_pnf.pnf20a = 0 END IF
            UPDATE oeb_file SET oeb28=l_pnf.pnf20a
             WHERE oeb01=l_pml.pml24 AND oeb03= l_pml.pml25
         END IF
         #MOD-C80081 -- add end --
      ELSE
         #新增
         IF SQLCA.sqlcode = 100 THEN
            INITIALIZE l_pml.* TO NULL
            LET l_pml.pml01 = l_pne.pne01
            LET l_pml.pml011= l_pmk.pmk02
            LET l_pml.pml02 = l_pnf.pnf03
            LET l_pml.pml04 = l_pnf.pnf04a
            LET l_pml.pml041= l_pnf.pnf041a
            #LET l_pml.pml06 = l_pnf.pnf50   #MOD-B30274 mark
            LET l_pml.pml07 = l_pnf.pnf07a
            SELECT ima25,ima49,ima491,ima913,ima914
              INTO l_pml.pml08,l_ima49,l_ima491,l_ima913,l_ima914
              FROM ima_file WHERE ima01 = l_pml.pml04
            CALL s_umfchk(l_pml.pml04,l_pml.pml07,l_pml.pml08)
                 RETURNING l_i,l_fac
            IF l_i = 1 THEN
               LET l_fac = 1
            END IF
            LET l_pml.pml09 = l_fac
            LET l_pml.pml10 = 'N'
            LET l_pml.pml11 = 'N'
            LET l_pml.pml12 = l_pnf.pnf12a
            LET l_pml.pml121= l_pnf.pnf121a
            LET l_pml.pml122= l_pnf.pnf122a
            LET l_pml.pml13 = 0
            LET l_pml.pml14 = g_sma.sma886[1,1]
            LET l_pml.pml15 = g_sma.sma886[1,1]
            LET l_pml.pml16 = '1'
            LET l_pml.pml20 = l_pnf.pnf20a
            LET l_pml.pml21 = 0
            LET l_pml.pml23 = 'Y'
            LET l_pml.pml30 = 0
            LET l_pml.pml31 = 0
            LET l_pml.pml32 = 0
            LET l_pml.pml33 = l_pnf.pnf33a
            LET l_pml.pml34 = s_aday(l_pml.pml33,1,l_ima49)
            #LET l_pml.pml35 = s_aday(l_pml.pml33,1,l_ima491)   ##TQC-C10052 mark
            LET l_pml.pml35 = s_aday(l_pml.pml34,1,l_ima491)    #TQC-C10052 add
            LET l_pml.pml38 = 'Y'
            LET l_pml.pml41 = l_pnf.pnf41a
            LET l_pml.pml42 = '0'
            LET l_pml.pml43 = 0
            LET l_pml.pml431= 0
            LET l_pml.pml44 = 0
            LET l_pml.pml80 = l_pnf.pnf80a
            LET l_pml.pml81 = l_pnf.pnf81a
            LET l_pml.pml82 = l_pnf.pnf82a
            LET l_pml.pml83 = l_pnf.pnf83a
            LET l_pml.pml84 = l_pnf.pnf84a
            LET l_pml.pml85 = l_pnf.pnf85a
            LET l_pml.pml86 = l_pnf.pnf86a
            LET l_pml.pml87 = l_pnf.pnf87a
            LET l_pml.pml88 = 0
            LET l_pml.pml88t= 0
            LET l_pml.pml31t= 0
            LET l_pml.pml190= l_ima913
            IF cl_null(l_pml.pml190) THEN LET l_pml.pml190 = 'N' END IF
            LET l_pml.pml191= l_ima914
            LET l_pml.pml192= 'N'
            LET l_pml.pml930= s_costcenter(l_pmk.pmk13)
            LET l_pml.pml91 = 'N'
            LET l_pml.pmlplant = g_plant
            LET l_pml.pmllegal = g_legal
            LET l_pml.pml49 = '1'
            LET l_pml.pml50 = '1'
            LET l_pml.pml54 = '2'
            LET l_pml.pml56 = '1'
            LET l_pml.pml92 = 'N'
            INSERT INTO pml_file VALUES(l_pml.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3('ins','pml_file',l_pml.pml01,l_pml.pml02,SQLCA.sqlcode,'','','1')
               LET g_success = 'N'
               RETURN
            END IF
         #其他错误
         ELSE
            CALL cl_err(l_pnf.pnf03,SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END FOREACH
   #MOD-C30822 ----- add start -----
   UPDATE pne_file SET pneconf = 'Y'
    WHERE pne01=l_pne.pne01 AND pne02=l_pne.pne02
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','pne_file',l_pne.pne01,'',SQLCA.sqlcode,'','',1)
      LET g_success = 'N'
      RETURN
   END IF
   #MOD-C30822 ----- mark end -----
END FUNCTION

#FUN-B30076 add begin--------------------------------
#取消確認
FUNCTION t900_unconfirm(p_pne01,p_pne02)
   DEFINE p_pne01  LIKE pne_file.pne01
   DEFINE p_pne02  LIKE pne_file.pne02
   DEFINE l_pne    RECORD LIKE pne_file.*


   SELECT * INTO l_pne.* FROM pne_file WHERE pne01 = p_pne01 AND pne02 = p_pne02
   LET g_success = 'Y'
   IF l_pne.pne06='N' THEN  RETURN END IF  #未確認
   
   IF (l_pne.pne06='Y' AND l_pne.pneconf = 'Y') OR l_pne.pne06='X' THEN
      CALL cl_err(l_pne.pne01,'apm1057', 0)
      LET g_success = 'N'
      RETURN 
   END IF
   
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   
   BEGIN WORK

   CALL t900sub_lock_cl()
   
   OPEN t900sub_cl USING p_pne01,p_pne02
   IF STATUS THEN
      CALL cl_err("OPEN t900sub_cl:", STATUS, 1)
      CLOSE t900sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900sub_cl INTO l_pne.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_pne.pne01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t900sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE pne_file SET pne06 = 'N',pne14 = '0'
    WHERE pne01 = l_pne.pne01 AND pne02=l_pne.pne02
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','pne_file',l_pne.pne01,l_pne.pne02,SQLCA.sqlcode,'update pne06','',1)
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
#FUN-B30076 add -end---------------------------------

#CHI-CB0002------add------S
FUNCTION t900sub_bud(p_pne01,p_pne02,p_pnf03)
   DEFINE p_pne01      LIKE pne_file.pne01
   DEFINE p_pne02      LIKE pne_file.pne02
   DEFINE p_pnf03      LIKE pnf_file.pnf03
   DEFINE l_pmk42      LIKE pmk_file.pmk42
   DEFINE l_pne        RECORD LIKE pne_file.*
   DEFINE l_pnf        RECORD LIKE pnf_file.*   
   DEFINE l_pmk        RECORD LIKE pmk_file.*
   DEFINE l_pml        RECORD LIKE pml_file.*
   DEFINE l_tmp     RECORD
                       flag   LIKE type_file.chr1,   #a:變更後 b:變更前
                       pne01  LIKE pne_file.pne01,   #採購單號        
                       pne02  LIKE pne_file.pne02,   #序號
                       pnf03  LIKE pnf_file.pnf03,   #項次          
                       pmk42  LIKE pmk_file.pmk42,   #匯率
                       pnf87  LIKE pnf_file.pnf87a,  #數量
                       pml31  LIKE pml_file.pml31,   #未稅單價
                       pml90  LIKE pml_file.pml90,   #費用原因
                       pml40  LIKE pml_file.pml40,   #會計科目
                       pmk31  LIKE pmk_file.pmk31,   #會計年度
                       pnf121 LIKE pnf_file.pnf121a, #WBS
                       pml67  LIKE pml_file.pml67,   #部門編號
                       pnf12  LIKE pnf_file.pnf12a,  #專案代號
                       pmk32  LIKE pmk_file.pmk32    #會計期間
                    END RECORD
   DEFINE p_sum1       LIKE afc_file.afc06
   DEFINE p_sum2       LIKE afc_file.afc06
   DEFINE l_cmd        LIKE type_file.chr1
   DEFINE l_pnf12      LIKE pnf_file.pnf12a
   DEFINE l_pnf121     LIKE pnf_file.pnf121a
   DEFINE l_pnf87      LIKE pnf_file.pnf87a
   DEFINE l_pnf03      LIKE pnf_file.pnf03
   DEFINE l_afb07      LIKE afb_file.afb07
   DEFINE l_flag       LIKE type_file.num5
   DEFINE l_msg        LIKE ze_file.ze03
   DEFINE l_over       LIKE afc_file.afc07

   WHENEVER ERROR CALL cl_err_msg_log

   DROP TABLE tmp_file
   CREATE TEMP TABLE tmp_file(
       flag   LIKE type_file.chr1,
       pne01  LIKE pne_file.pne01,
       pne02  LIKE pne_file.pne02,
       pnf03  LIKE pnf_file.pnf03,
       pmk42  LIKE pmk_file.pmk42,
       pnf87  LIKE pnf_file.pnf87a,
       pml31  LIKE pml_file.pml31,
       pml90  LIKE pml_file.pml90,
       pml40  LIKE pml_file.pml40,
       pmk31  LIKE pmk_file.pmk31,
       pnf121 LIKE pnf_file.pnf121a,
       pml67  LIKE pml_file.pml67,
       pnf12  LIKE pnf_file.pnf12a,
       pmk32  LIKE pmk_file.pmk32)
   DELETE FROM  tmp_file

   LET g_errno = ''
   SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01 = p_pne01

   CALL s_get_bookno(YEAR(l_pmk.pmk04))        #帳套
        RETURNING g_flag,g_bookno1,g_bookno2

   SELECT * INTO l_pne.* FROM pne_file WHERE pne01 = p_pne01 AND pne02 = p_pne02
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('pne01',p_pne01,'SEL pne_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   INITIALIZE l_pnf.* TO NULL
   INITIALIZE l_pml.* TO NULL

  #將每筆項次變更前後的資料，儲存至tmp_table中
   DECLARE t900sub_pnf_instmp_cs CURSOR FOR
    SELECT pnf_file.* FROM pnf_file,pne_file
     WHERE pnf01 = l_pne.pne01
       AND pnf02 = l_pne.pne02
       AND pnf01 = pne01
       AND pnf02 = pne02
       AND pne06 = 'N'
   FOREACH t900sub_pnf_instmp_cs INTO l_pnf.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach t900sub_pnf_instmp_cs',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF

      SELECT * INTO l_pml.* FROM pml_file WHERE pml01 = l_pne.pne01 AND pml02 = l_pnf.pnf03
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pnf03',l_pnf.pnf03,'SEL pml_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF

      #匯率
      IF NOT cl_null(l_pne.pne09b) THEN
         IF g_aza.aza17 = l_pne.pne09b THEN   #本幣
            LET l_pmk42 = 1
         ELSE
            CALL s_curr3(l_pne.pne09b,l_pmk.pmk04,g_sma.sma904)
                 RETURNING l_pmk42
         END IF
      ELSE
         LET l_pmk42 = l_pmk.pmk42
      END IF

      #操作
      IF l_pnf.pnf121b <> l_pnf.pnf121a OR
         l_pnf.pnf12b <> l_pnf.pnf12b THEN
         LET l_cmd = 'a'
      ELSE
         LET l_cmd = 'u'
      END IF

      #數量
      IF NOT cl_null(l_pnf.pnf87a) THEN
         LET l_pnf87 = l_pnf.pnf87a    
      ELSE
         LET l_pnf87 = l_pnf.pnf87b
      END IF

      #WBS
      IF NOT cl_null(l_pnf.pnf121a) THEN
         LET l_pnf121 = l_pnf.pnf121a
      ELSE
         LET l_pnf121 = l_pnf.pnf121b
      END IF

      #專案代號
      IF NOT cl_null(l_pnf.pnf12a) THEN
         LET l_pnf12 = l_pnf.pnf12a
      ELSE
         LET l_pnf12 = l_pnf.pnf12b
      END IF

      INSERT INTO tmp_file VALUES('b',l_pne.pne01,l_pne.pne02,l_pnf.pnf03,l_pmk.pmk42,l_pnf.pnf87b,l_pml.pml31,  #變更前
                                     l_pml.pml90,l_pml.pml40,l_pmk.pmk31,l_pnf.pnf121b,l_pml.pml67,
                                     l_pnf.pnf12b,l_pmk.pmk32)
      INSERT INTO tmp_file VALUES('a',l_pne.pne01,l_pne.pne02,l_pnf.pnf03,l_pmk42,l_pnf87,l_pml.pml31,  #變更後
                                     l_pml.pml90,l_pml.pml40,l_pmk.pmk31,l_pnf121,l_pml.pml67,
                                     l_pnf12,l_pmk.pmk32)
   END FOREACH

   DECLARE t900sub_pnf_seltmp_cs CURSOR FOR
    SELECT * FROM tmp_file
     WHERE pne01 = l_pne.pne01
       AND pne02 = l_pne.pne02
       AND pnf03 = p_pnf03
       AND flag = 'a'

   FOREACH t900sub_pnf_seltmp_cs INTO l_tmp.*
      #變更前
       SELECT SUM(pnf87 * pml31 *pmk42) INTO p_sum1
         FROM tmp_file
        WHERE flag = 'b'
          AND pne01 = l_tmp.pne01
          AND pne02 = l_tmp.pne02
          AND pnf12 = l_tmp.pnf12
          AND pnf121 = l_tmp.pnf121
          AND pml90 = l_tmp.pml90
          AND pml40 = l_tmp.pml40
          AND pmk32 = l_tmp.pmk32
         GROUP BY pnf12,pnf121,pml90,pml40,pml67,pmk32

      #變更後
       SELECT SUM(pnf87 * pml31 *pmk42) INTO p_sum2
         FROM tmp_file
        WHERE flag = 'a'
          AND pne01 = l_tmp.pne01
          AND pne02 = l_tmp.pne02
          AND pnf12 = l_tmp.pnf12
          AND pnf121 = l_tmp.pnf121
          AND pml90 = l_tmp.pml90
          AND pml40 = l_tmp.pml40
          AND pmk32 = l_tmp.pmk32
        GROUP BY pnf12,pnf121,pml90,pml40,pml67,pmk32

      IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
      IF cl_null(p_sum2) THEN LET p_sum2 = 0 END IF

     IF g_aaz.aaz90='Y' THEN
        CALL s_budchk1(g_bookno1,l_tmp.pml90,l_tmp.pml40,
                       l_tmp.pmk31,l_tmp.pnf121,
                       l_pml.pml930,l_tmp.pnf12,
                       l_tmp.pmk32,'0',l_cmd,p_sum1,p_sum2)
             RETURNING l_flag,l_afb07,l_over
        IF l_flag = FALSE THEN
           LET l_msg = g_bookno1,'/',l_tmp.pml90,'/',l_tmp.pml40,'/',
                       l_tmp.pmk31,'/',l_tmp.pnf121,'/',
                       l_pml.pml930,'/',l_tmp.pnf12,'/',
                       l_tmp.pmk32,'/',l_over
           CALL s_errmsg('pnf03',l_tmp.pnf03,l_msg,g_errno,1)
           LET g_success = 'N'
        ELSE
           IF l_afb07 = '2' AND l_over < 0 THEN
           LET l_msg = g_bookno1,'/',l_tmp.pml90,'/',l_tmp.pml40,'/',
                       l_tmp.pmk31,'/',l_tmp.pnf121,'/',
                       l_pml.pml930,'/',l_tmp.pnf12,'/',
                       l_tmp.pmk32,'/',l_over
              CALL s_errmsg('pnf03',l_tmp.pnf03,l_msg,g_errno,1)
              LET g_errno =' '
           END IF
        END IF
     ELSE
        CALL s_budchk1(g_bookno1,l_tmp.pml90,l_tmp.pml40,
                       l_tmp.pmk31,l_tmp.pnf121,
                       l_tmp.pml67,l_tmp.pnf12,
                       l_tmp.pmk32,'0',l_cmd,p_sum1,p_sum2)
             RETURNING l_flag,l_afb07,l_over
        IF l_flag = FALSE THEN
           LET l_msg = g_bookno1,'/',l_tmp.pml90,'/',l_tmp.pml40,'/',
                       l_tmp.pmk31,'/',l_tmp.pnf121,'/',
                       l_tmp.pml67,'/',l_tmp.pnf12,'/',
                       l_tmp.pmk32,'/',l_over
           CALL s_errmsg('pnf03',l_tmp.pnf03,l_msg,g_errno,1)
           LET g_success = 'N'
        ELSE
           IF l_afb07 = '2' AND l_over < 0 THEN
           LET l_msg = g_bookno1,'/',l_tmp.pml90,'/',l_tmp.pml40,'/',
                       l_tmp.pmk31,'/',l_tmp.pnf121,'/',
                       l_tmp.pml67,'/',l_tmp.pnf12,'/',
                       l_tmp.pmk32,'/',l_over
              CALL s_errmsg('pnf03',l_tmp.pnf03,l_msg,g_errno,1)
              LET g_errno =' '
           END IF
        END IF
     END IF
   END FOREACH

END FUNCTION
#CHI-CB0002------add------E


