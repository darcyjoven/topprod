# Prog. Version..: '5.30.06-13.03.19(00006)'     #
#
# Program name...: ctc_pmi255_sub.4gl
# Description....: 提供ctc_pmi255.4gl使用的sub routine
# Date & Author..: 16/10/12 by huanglf

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"
 
FUNCTION i255sub_y_chk(p_tc_pmi01)
DEFINE p_tc_pmi01     LIKE tc_pmi_file.tc_pmi01      #FUN-920106
DEFINE l_cnt       LIKE type_file.num5  
DEFINE l_str       LIKE gfe_file.gfe01  
DEFINE l_pml04     LIKE pml_file.pml04
DEFINE l_imaacti   LIKE ima_file.imaacti
DEFINE l_ima140    LIKE ima_file.ima140
DEFINE l_tc_pmj01     LIKE tc_pmj_file.tc_pmj01 
DEFINE l_tc_pmj02     LIKE tc_pmj_file.tc_pmj02
DEFINE l_pmm01     LIKE pmm_file.pmm01   
DEFINE l_pmm09     LIKE pmm_file.pmm09  
DEFINE l_status    LIKE type_file.chr1
DEFINE l_tc_pmi       RECORD LIKE tc_pmi_file.*    #FUN-920106
DEFINE l_t1        LIKE smy_file.smyslip     #FUN-920106
DEFINE l_tc_pmj09     LIKE tc_pmj_file.tc_pmj09       #MOD-D10199
define l_where    varchar(500)
 
   LET g_success = 'Y'
   IF s_shut(0) THEN RETURN END IF
   IF p_tc_pmi01 IS NULL THEN RETURN END IF     #FUN-920106
#CHI-C30107 ------------ add ------------ begin
   IF l_tc_pmi.tc_pmiconf='X'      THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_pmi.tc_pmiconf='Y'      THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_pmi.tc_pmiacti= 'N' THEN
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
  IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
     g_action_choice CLIPPED = "insert"  THEN
     IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
  END IF
#CHI-C30107 ------------ add ------------ end
   SELECT * INTO l_tc_pmi.* FROM tc_pmi_file WHERE tc_pmi01 = p_tc_pmi01        #FUN-920106
   IF cl_null(l_tc_pmi.tc_pmi01) THEN CALL cl_err('',-400,0) RETURN END IF
 
   IF l_tc_pmi.tc_pmiconf='X'      THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_pmi.tc_pmiconf='Y'      THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_pmi.tc_pmiacti= 'N' THEN
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
 
   LET l_cnt =0
 
   #控管單身未輸入資料
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM tc_pmj_file
    WHERE tc_pmj01=l_tc_pmi.tc_pmi01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   #MOD-D10199 -- add start --
   DECLARE i255_tc_pmj09_cs CURSOR FOR
     SELECT tc_pmj09 FROM tc_pmj_file
      WHERE tc_pmj01 = l_tc_pmi.tc_pmi01
   FOREACH i255_tc_pmj09_cs INTO l_tc_pmj09
      IF cl_null(l_tc_pmj09) THEN
         MESSAGE ''
         CALL cl_err(l_tc_pmi.tc_pmi01,'cpm-059',1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
   #MOD-D10199 -- add end --  
 
    #MOD-530602
   #控管分量計價='N',有單身新單價<=0
   IF l_tc_pmi.tc_pmi05 = 'N' THEN
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt
         FROM tc_pmj_file
        WHERE tc_pmj01 = l_tc_pmi.tc_pmi01
          AND (tc_pmj07 IS NULL OR tc_pmj07 <=0)
        IF l_cnt >= 1 THEN #MOD-540067
           CALL cl_err(l_tc_pmi.tc_pmi01,'apm-298',1)
           LET g_success = 'N'
           RETURN
        END IF             #MOD-540067
   ELSE
   #控管分量計價='Y',有單身未輸入分量計價資料
       DECLARE i255c_cnt_pmr CURSOR FOR
         SELECT tc_pmj01,tc_pmj02 FROM tc_pmj_file
          WHERE tc_pmj01 = l_tc_pmi.tc_pmi01
       FOREACH i255c_cnt_pmr INTO l_tc_pmj01,l_tc_pmj02
           LET l_cnt=0
           SELECT COUNT(*) INTO l_cnt FROM pmr_file
            WHERE pmr01 = l_tc_pmj01
              AND pmr02 = l_tc_pmj02
           IF l_cnt <=0 THEN
               CALL cl_err(l_tc_pmi.tc_pmi01,'apm-297',1)
               LET g_success = 'N'
               RETURN
           END IF
       END FOREACH
   END IF
   #MOD-530602(end)
 
   #------FUN-880016 start-------------
   IF g_aza.aza71 MATCHES '[Yy]' THEN   #FUN-8A0054 判斷是否有勾選〝與GPM整合〞，有則做GPM控
      LET l_t1 = s_get_doc_no(l_tc_pmi.tc_pmi01) 
      SELECT * INTO g_smy.* FROM smy_file
       WHERE smyslip=l_t1
      IF NOT cl_null(g_smy.smy64) THEN                                                                                   
         IF g_smy.smy64 != '0' THEN    #要控管GPM
            CALL s_showmsg_init()
            CALL aws_gpmcli_part(l_tc_pmi.tc_pmi01,l_tc_pmi.tc_pmi03,'','6')
	         RETURNING l_status
	    IF l_status = '1' THEN   #回傳結果為失敗
               IF g_smy.smy64 = '1' THEN
	          CALL s_showmsg()
               END IF
	       IF g_smy.smy64 = '2' THEN   
                  LET g_success = 'N'
	          CALL s_showmsg()
                  RETURN
	       END IF
	    END IF
         END IF
      END IF
   END IF                #FUN-8A0054
END FUNCTION

 
FUNCTION i255sub_lock_cl()
   DEFINE l_forupd_sql STRING
 
   LET l_forupd_sql = "SELECT * FROM tc_pmi_file WHERE tc_pmi01 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE i255sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

 
FUNCTION i255sub_y_upd(l_tc_pmi01,p_action_choice,l_tc_pmj12)
   DEFINE  l_tc_pmi01         LIKE tc_pmi_file.tc_pmi01     #FUN-920106
   DEFINE  p_action_choice STRING                  #FUN-920106
   DEFINE  l_tc_pmi           RECORD LIKE tc_pmi_file.*
   DEFINE  l_tc_pmj           RECORD LIKE tc_pmj_file.*
   DEFINE  l_pmh12         LIKE pmh_file.pmh12
   DEFINE  l_pmh19         LIKE pmh_file.pmh19   #No.FUN-610018
   DEFINE  l_cnt           LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE  l_tc_pmj12         LIKE tc_pmj_file.tc_pmj12      #FUN-920106
   WHENEVER ERROR CONTINUE                          #FUN-920106
 
   LET g_success = 'Y'
 
   SELECT * INTO l_tc_pmi.* FROM tc_pmi_file WHERE tc_pmi01 = l_tc_pmi01  #FUN-920106
   IF p_action_choice CLIPPED = "confirm" THEN       #按「確認」時
      IF l_tc_pmi.tc_pmi07='Y' THEN
         IF l_tc_pmi.tc_pmi06 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   END IF
 
   BEGIN WORK
 
   CALL i255sub_lock_cl()          #FUN-920106
   OPEN i255sub_cl USING l_tc_pmi01   #FUN-920106
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN i255sub_cl:", STATUS, 1)
      CLOSE i255sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i255sub_cl INTO l_tc_pmi.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(l_tc_pmi.tc_pmi01,SQLCA.sqlcode,0)
      CLOSE i255sub_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   DECLARE i255_y CURSOR FOR SELECT * FROM tc_pmj_file WHERE tc_pmj01=l_tc_pmi.tc_pmi01
   FOREACH i255_y INTO l_tc_pmj.*
      IF STATUS THEN EXIT FOREACH END IF
      #No.MOD-880193--begin--
      IF cl_null(l_tc_pmj.tc_pmj10) THEN
         LET l_tc_pmj.tc_pmj10 = ' '
      END IF
      #No.MOD-880193---end---
      SELECT pmh12,pmh19 INTO l_pmh12,l_pmh19
        FROM pmh_file
       WHERE pmh01=l_tc_pmj.tc_pmj03
         AND pmh02=l_tc_pmi.tc_pmi03
         AND pmh13=l_tc_pmj.tc_pmj05
         AND pmh21=l_tc_pmj.tc_pmj10    #No.MOD-840074
         AND pmh22=l_tc_pmj12    #No.FUN-670099
         AND pmh23=l_tc_pmj.tc_pmj13    #No.FUN-870124
         AND pmhacti = 'Y'                                           #CHI-910021
      IF STATUS = 100 THEN
         IF l_tc_pmj.tc_pmj03[1,4] !='MISC' THEN  #料號非為MISC才check
            CALL i255sub_tc_pmj03_add(l_tc_pmj.tc_pmj03,l_tc_pmj.tc_pmj05,l_tc_pmj12,l_tc_pmj.tc_pmj10,l_tc_pmi.*,l_tc_pmj.tc_pmj13)  #No.FUN-670099
         END IF
      END IF
      IF g_sma.sma83<>'3' THEN
#        IF ((l_pmh12 > l_tc_pmj.tc_pmj07 AND g_sma.sma83='2') OR
         IF (((l_pmh12 > l_tc_pmj.tc_pmj07 OR l_pmh19 > l_tc_pmj.tc_pmj07t) AND g_sma.sma83='2') OR    #No.FUN-610018
               (g_sma.sma83='1' ) OR l_pmh12=0 ) AND l_tc_pmj.tc_pmj03[1,4] <> 'MISC'  THEN
            IF l_tc_pmi.tc_pmi05 = 'Y' THEN #分量計價
               SELECT MAX(pmr05),MAX(pmr05t)    #No.FUN-610018
                 INTO l_tc_pmj.tc_pmj07,l_tc_pmj.tc_pmj07t  #取最大值
                 FROM pmr_file
                WHERE pmr01 = l_tc_pmj.tc_pmj01
                  AND pmr02 = l_tc_pmj.tc_pmj02
               IF cl_null(l_tc_pmj.tc_pmj07) THEN
                  LET l_tc_pmj.tc_pmj07 = 0
               END IF
            END IF
            UPDATE pmh_file SET pmh12=l_tc_pmj.tc_pmj07,
                                pmh17=l_tc_pmi.tc_pmi08,   #No.FUN-610018
                                pmh18=l_tc_pmi.tc_pmi081,  #No.FUN-610018
                                pmh19=l_tc_pmj.tc_pmj07t,  #No.FUN-610018
                                pmh06=l_tc_pmj.tc_pmj09,  #No.CHI-C10039 add ,
                                pmh05=0,             #No.CHI-C10039 add
                                pmhdate = g_today     #FUN-C40009 add
             WHERE pmh01=l_tc_pmj.tc_pmj03
               AND pmh02=l_tc_pmi.tc_pmi03
               AND pmh13=l_tc_pmj.tc_pmj05
               AND pmh21=l_tc_pmj.tc_pmj10   #No.MOD-840074
               AND pmh22=l_tc_pmj12       #No.MOD-840074
               AND pmh23=l_tc_pmj.tc_pmj13    #No.FUN-870124
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#              CALL cl_err('upd pmh_file','apm-265',0)   #No.FUN-660129
               CALL cl_err3("upd","pmh_file","","","apm-265","","upd pmh_file",1)  #No.FUN-660129
               LET g_success='N'
            END IF
         END IF
      END IF
   END FOREACH
 
   #MOD-920027---Begin 
   #UPDATE tc_pmi_file SET tc_pmiconf='Y' WHERE tc_pmi01=l_tc_pmi.tc_pmi01
    UPDATE tc_pmi_file SET tc_pmiconf='Y'      #MOD-C90034 remove ,
                       #tc_pmimodu=g_user,  #MOD-C90034 mark
                       #tc_pmidate=g_today  #MOD-C90034 mark
    WHERE tc_pmi01=l_tc_pmi.tc_pmi01
   #MOD-920027---End
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err('upd tc_pmi_file','apm-266',0)   #No.FUN-660129
      CALL cl_err3("upd","tc_pmi_file",l_tc_pmi.tc_pmi01,"","apm-266","","upd tc_pmi_file",1)  #No.FUN-660129
      LET g_success='N'
   END IF
   IF l_tc_pmi.tc_pmi07 = 'N' AND l_tc_pmi.tc_pmi06 = '0' THEN
      LET l_tc_pmi.tc_pmi06 = '1'
      UPDATE tc_pmi_file SET tc_pmi06 = l_tc_pmi.tc_pmi06 WHERE tc_pmi01 = l_tc_pmi.tc_pmi01
      IF SQLCA.sqlcode THEN
#        CALL cl_err('upd tc_pmi_file','apm-266',0)   #No.FUN-660129
         CALL cl_err3("upd","tc_pmi_file",l_tc_pmi.tc_pmi01,"","apm-266","","upd tc_pmi_file",1)  #No.FUN-660129
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM tc_pmj_file
       WHERE tc_pmj01 = l_tc_pmi.tc_pmi01
      IF l_cnt = 0 AND l_tc_pmi.tc_pmi07 = 'Y' THEN
         CALL cl_err(' ','aws-065',0)
         LET g_success = 'N'
      END IF
   END IF
 
 
   IF g_success = 'Y' THEN
      IF l_tc_pmi.tc_pmi07 = 'Y' THEN
         CASE aws_efapp_formapproval()
            WHEN 0  #呼叫 EasyFlow 簽核失敗
               LET l_tc_pmi.tc_pmiconf="N"
               LET g_success = "N"
               ROLLBACK WORK
               RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
               LET l_tc_pmi.tc_pmiconf="N"
               ROLLBACK WORK
               RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET l_tc_pmi.tc_pmi06='1'
         LET l_tc_pmi.tc_pmiconf='Y'
         #LET l_tc_pmi.tc_pmimodu=g_user     #MOD-920027 add #MOD-C90034 mark 
         #LET l_tc_pmi.tc_pmidate=g_today    #MOD-920027 add #MOD-C90034 mark
         COMMIT WORK
         CALL cl_flow_notify(l_tc_pmi.tc_pmi01,'Y')
         DISPLAY BY NAME l_tc_pmi.tc_pmi06
         DISPLAY BY NAME l_tc_pmi.tc_pmiconf
         #DISPLAY BY NAME l_tc_pmi.tc_pmimodu    #MOD-920027 add #MOD-C90034 mark
         #DISPLAY BY NAME l_tc_pmi.tc_pmidate    #MOD-920027 add #MOD-C90034 mark
      ELSE
         LET l_tc_pmi.tc_pmiconf='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET l_tc_pmi.tc_pmiconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
  #FUN-920106---mark---確認完後統一CALL i255_show()顯示
  ##CKP
  #SELECT * INTO g_tc_pmi.* FROM tc_pmi_file WHERE tc_pmi01 = g_tc_pmi.tc_pmi01
  #IF g_tc_pmi.tc_pmiconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #IF g_tc_pmi.tc_pmi06='1' OR
  #   g_tc_pmi.tc_pmi06='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #IF g_tc_pmi.tc_pmi06='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
  #CALL cl_set_field_pic(g_tc_pmi.tc_pmiconf,g_chr2,"",g_chr3,g_chr,g_tc_pmi.tc_pmiacti)
  #FUN-920106---mark---end---
END FUNCTION
 
FUNCTION i255sub_tc_pmj03_add(p_tc_pmj03,p_tc_pmj05,p_tc_pmj12,p_tc_pmj10,l_tc_pmi,p_tc_pmj13)
   DEFINE l_pmh     RECORD LIKE pmh_file.*,
          l_ima54   LIKE ima_file.ima54,
          p_tc_pmj03   LIKE tc_pmj_file.tc_pmj03,
          p_tc_pmj05   LIKE tc_pmj_file.tc_pmj05
   DEFINE p_tc_pmj12   LIKE tc_pmj_file.tc_pmj12
   DEFINE p_tc_pmj10   LIKE tc_pmj_file.tc_pmj10
   DEFINE m_pmh11   LIKE pmh_file.pmh11  #No.MOD-8B0235 add
   DEFINE l_tc_pmi     RECORD LIKE tc_pmi_file.*   #FUN-920106
   DEFINE p_row,p_col  LIKE type_file.num5   #FUN-920106
   DEFINE p_tc_pmj13   LIKE tc_pmj_file.tc_pmj13      #FUN-920106

   INITIALIZE l_pmh.* TO NULL
   LET l_pmh.pmh01=p_tc_pmj03         #料件編號
   LET l_pmh.pmh02=l_tc_pmi.tc_pmi03               #廠商編號
   LET l_pmh.pmh13=p_tc_pmj05         #幣別
   LET l_pmh.pmh22=p_tc_pmj12  #No.FUN-670099
   LET l_pmh.pmh21=p_tc_pmj10  #No.FUN-670099
   LET l_pmh.pmhacti='Y'
   LET l_pmh.pmhgrup=g_grup
   LET l_pmh.pmhuser=g_user
   LET l_pmh.pmh06=''
   LET l_pmh.pmh12=0
   LET l_pmh.pmh14=1
   LET l_pmh.pmhdate=g_today
  #LET l_pmh.pmh23=p_tc_pmj[l_ac].tc_pmj13   #No.FUN-810017
   LET l_pmh.pmh23=p_tc_pmj13      #FUN-920106 
   LET l_pmh.pmh06 = g_today    #CHI-C20012 add
   #No.FUN-610018 --start--
   LET l_pmh.pmh19=0
   SELECT pmc47,gec04
     INTO l_pmh.pmh17,l_pmh.pmh18
     FROM pmc_file,gec_file
    WHERE pmc01 = l_tc_pmi.tc_pmi03
      AND gec011 = '1'
      AND gec01 = pmc47
   #No.FUN-610018 --end--
   #是否為主要供應商
   #SELECT ima54 INTO l_ima54 FROM ima_file WHERE ima01=g_tc_pmj[l_ac].tc_pmj03
   #No.B433 010423 BY ANN CHEN

   SELECT ima54,ima100,ima24,ima101,ima102   
     INTO l_ima54,l_pmh.pmh09,l_pmh.pmh08,l_pmh.pmh15,l_pmh.pmh16   
     FROM ima_file
    WHERE ima01=p_tc_pmj03


   IF l_tc_pmi.tc_pmi03=l_ima54 THEN
      LET l_pmh.pmh03='Y'
   ELSE
      LET l_pmh.pmh03='N'
   END IF
 
   IF g_aza.aza17 = l_pmh.pmh13 THEN   #本幣
      LET l_pmh.pmh14 = 1
   ELSE
     #CALL s_curr3(l_pmh.pmh13,g_tc_pmi.tc_pmi02,'S') #FUN-640012
      CALL s_curr3(l_pmh.pmh13,l_tc_pmi.tc_pmi02,g_sma.sma904) #FUN-640012
        RETURNING l_pmh.pmh14
   END IF
   LET l_pmh.pmh09='N'
   LET l_pmh.pmh11=0 #MOD-780186

  #FUN-A10043 add srt ---
   IF g_action_choice = 'efconfirm' THEN    #若執行EF端的自動確認
     LET l_pmh.pmh05 = 0                    #核准狀況='已核准'
   ELSE
  #FUN-A10043 add end ---
     LET p_row = 3 LET p_col = 37
     OPEN WINDOW i255a_w AT p_row,p_col WITH FORM "apm/42f/apmi255a"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_locale("apmi255a")
      DISPLAY l_pmh.pmh01 TO pmh01
      LET l_pmh.pmh05 = 0 
      DISPLAY l_pmh.pmh05 TO pmh05
 
 
     INPUT BY NAME l_pmh.pmh04,l_pmh.pmh13,l_pmh.pmh05,l_pmh.pmh06,l_pmh.pmh07,l_pmh.pmh08,    #CHI-C20012 add pmh06
                   l_pmh.pmh09,l_pmh.pmh14,l_pmh.pmh11 WITHOUT DEFAULTS  #MOD-540202
 
      #MOD-540202................begin
       AFTER FIELD pmh11
         IF NOT cl_null(l_pmh.pmh11) THEN
            IF l_pmh.pmh11 < 0 THEN
               NEXT FIELD pmh11
            END IF
            #No.MOD-8B0235 add --begin
            SELECT SUM(pmh11) INTO m_pmh11 FROM pmh_file
             WHERE pmh01 = l_pmh.pmh01
               AND pmh22 = l_pmh.pmh22
               AND pmhacti = 'Y'                                           #CHI-910021
            IF cl_null(m_pmh11) THEN LET m_pmh11 = 0 END IF   #MOD-AB0166 
            LET m_pmh11 = 100-m_pmh11
            IF l_pmh.pmh11 > m_pmh11 THEN
               CALL cl_err(l_pmh.pmh11,'apm-986',0)
               NEXT FIELD pmh11
            END IF
            #No.MOD-8B0235 add --end
         END IF
      #MOD-540202................end
 
       AFTER FIELD pmh13
         IF NOT cl_null(l_pmh.pmh13) THEN
            CALL i255_pmh13(l_pmh.pmh13)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_pmh.pmh13,g_errno,0)
               NEXT FIELD pmh13
            END IF
         END IF
         
       BEFORE FIELD pmh05
         IF cl_null(l_pmh.pmh05) THEN 
            LET l_pmh.pmh05 = 0 
          END IF 
       AFTER FIELD pmh05
         IF NOT cl_null(l_pmh.pmh05) THEN
            IF l_pmh.pmh05 NOT MATCHES'[012]' THEN
               NEXT FIELD pmh05
            END IF
            CALL cl_set_comp_required("pmh06",l_pmh.pmh05='0')   #CHI-C20012 add
         END IF

       #MOD-530582

       #CHI-C20012 add START
        BEFORE FIELD pmh06
          IF l_pmh.pmh05 = '0' THEN
             CALL cl_set_comp_required("pmh06",TRUE)
          ELSE
             CALL cl_set_comp_required("pmh06",FALSE)
          END IF
       #CHI-C20012 add END

       AFTER FIELD pmh07
         IF NOT cl_null(l_pmh.pmh07) THEN
            SELECT *
              FROM mse_file
             WHERE mse01=l_pmh.pmh07
            IF STATUS THEN
#              CALL cl_err('sel mse:','mfg2603',1)   #No.FUN-660129
               CALL cl_err3("sel","mse_file",l_pmh.pmh07,"","mfg2603","","sel mse:",1)  #No.FUN-660129
               NEXT FIELD pmh07
            END IF
         END IF
       #MOD-530582(end)
 
       AFTER FIELD pmh08
         IF NOT cl_null(l_pmh.pmh08) THEN
            IF l_pmh.pmh08 NOT MATCHES'[yYnN]' THEN
               NEXT FIELD pmh08
            END IF
         END IF
 
       AFTER INPUT #MOD-D60113 add
         IF INT_FLAG THEN
            EXIT INPUT               
         END IF     #sunlm  
         IF cl_null(l_pmh.pmh05) THEN
            DISPLAY BY NAME l_pmh.pmh05
            NEXT FIELD pmh05
         END IF
         IF cl_null(l_pmh.pmh08) THEN
            DISPLAY BY NAME l_pmh.pmh08
            NEXT FIELD pmh08
         END IF
 
       ON ACTION controlp
         CASE
            WHEN INFIELD(pmh13)     #幣別
#              CALL q_azi(4,3,'') RETURNING l_pmh.pmh13
#              CALL FGL_DIALOG_SETBUFFER( l_pmh.pmh13 )
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = ''
               CALL cl_create_qry() RETURNING l_pmh.pmh13
#               CALL FGL_DIALOG_SETBUFFER( l_pmh.pmh13 )
                DISPLAY BY NAME l_pmh.pmh13
                NEXT FIELD pmh13
            #FUN-4B0051
            WHEN INFIELD(pmh14)
               CALL s_rate(l_pmh.pmh13,l_pmh.pmh14) RETURNING l_pmh.pmh14
                DISPLAY BY NAME l_pmh.pmh14
               NEXT FIELD pmh14
            #FUN-4B0051(end)
 
             #MOD-530582
            WHEN INFIELD(pmh07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_mse"
               LET g_qryparam.default1 = ''
               CALL cl_create_qry() RETURNING l_pmh.pmh07
               DISPLAY l_pmh.pmh07 TO pmh07
               NEXT FIELD pmh07
             #MOD-530582(end)
          END CASE
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
         CALL cl_about()       #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
         CALL cl_show_help()   #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()      #MOD-4C0121
     END INPUT
 
     CLOSE WINDOW i255a_w
 
     IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
     END IF  #MOD-D60113
   END IF                      #FUN-A10043 add
 
  #LET l_pmh.pmh11=0 #MOD-540202
 
   #MOD-780186.................begin
   IF cl_null(l_pmh.pmh21) THEN
      LET l_pmh.pmh21=' '
   END IF
   #MOD-780186.................end
   IF cl_null(l_pmh.pmh23) THEN
      LET l_pmh.pmh23=' '
   END IF
   #No.CHI-790003 START
   IF cl_null(l_pmh.pmh13) THEN LET l_pmh.pmh13=' ' END IF
   #No.CHI-790003 END 
   LET l_pmh.pmhoriu = g_user      #No.FUN-980030 10/01/04
   LET l_pmh.pmhorig = g_grup      #No.FUN-980030 10/01/04
   LET l_pmh.pmh25='N'   #No:FUN-AA0015
   INSERT INTO pmh_file VALUES (l_pmh.*)
   IF STATUS THEN
#     CALL cl_err('ins pmh',STATUS,0)   #No.FUN-660129
      CALL cl_err3("ins","pmh_file","","",STATUS,"","ins pmh",1)  #No.FUN-660129
      LET g_errno='N'
   END IF
 
END FUNCTION
 
FUNCTION i255sub_pmh13(l_pmh13)  #幣別
    DEFINE l_azi02   LIKE azi_file.azi02             #No.FUN-550019
    DEFINE l_aziacti LIKE azi_file.aziacti           #No.FUN-550019
    DEFINE l_pmh13   LIKE pmh_file.pmh13
 
    LET g_errno = ' '
    SELECT azi02,aziacti INTO l_azi02,l_aziacti      #No.FUN-550019
      FROM azi_file
     WHERE azi01 = l_pmh13
 
    CASE WHEN STATUS=100          LET g_errno = 'mfg3008' #No.7926
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
    END CASE
 
END FUNCTION
 
#FUN-920106---add---start---
FUNCTION i255sub_refresh(p_tc_pmi01)
DEFINE p_tc_pmi01 LIKE tc_pmi_file.tc_pmi01
DEFINE l_tc_pmi RECORD LIKE tc_pmi_file.*
 
SELECT * INTO l_tc_pmi.* FROM tc_pmi_file WHERE tc_pmi01=p_tc_pmi01
RETURN l_tc_pmi.*
END FUNCTION
#FUN-920106---add---end-----
 
 
