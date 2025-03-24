# Prog. Version..: '5.30.06-13.03.19(00006)'     #
#
# Program name...: atc_bmi255_sub.4gl
# Description....: 提供atc_bmi255.4gl使用的sub routine
# Date & Author..: 09/02/20 by sabrina
# Modify.........: No.FUN-920106 09/02/20 By sabrina 新建立
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10043 10/01/11 By Lilan 從EasyFlow端簽核時可進行自動確認(不開窗,帶預設值)
# Modify.........: No.FUN-AA0015 10/10/07 By Nicola 預設pmh25 
# Modify.........: No:MOD-AB0166 10/11/17 By Smatc_bmin 分配比率沒有檢核不可大於100
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-C90034 12/10/22 By Nina 還原 MOD-920027 確認,取消確認時需要更新最近更改者和最近更改日的調整 
# Modify.........: No:CHI-C10039 12/11/16 By jt_chen 增加回寫核准狀態.
# Modify.........: No.CHI-C20012 12/12/06 By pauline 新增pmh_file時增加欄位pmh06核准日期,當狀態為已核准時,pmh06為必輸
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today
# Modify.........: No.MOD-D10199 13/01/31 By jt_chen 新增檢核單身tc_bmj09是否為NULL
# Modify.........: No.MOD-D60113 13/06/13 By SunLM 修改atc_bmi255a画面,显示料号,且能关闭atc_bmi255a画面
DATABASE ds

GLOBALS "../../config/top.global"
 
FUNCTION i255sub_y_chk(p_tc_bmi01)
DEFINE p_tc_bmi01     LIKE tc_bmi_file.tc_bmi01      #FUN-920106
DEFINE l_cnt       LIKE type_file.num5  
DEFINE l_str       LIKE gfe_file.gfe01  
DEFINE l_pml04     LIKE pml_file.pml04
DEFINE l_imaacti   LIKE ima_file.imaacti
DEFINE l_ima140    LIKE ima_file.ima140
DEFINE l_tc_bmj01     LIKE tc_bmj_file.tc_bmj01 
DEFINE l_tc_bmj02     LIKE tc_bmj_file.tc_bmj02
DEFINE l_pmm01     LIKE pmm_file.pmm01   
DEFINE l_pmm09     LIKE pmm_file.pmm09  
DEFINE l_status    LIKE type_file.chr1
DEFINE l_tc_bmi       RECORD LIKE tc_bmi_file.*    #FUN-920106
DEFINE l_t1        LIKE smy_file.smyslip     #FUN-920106
DEFINE l_tc_bmj09     LIKE tc_bmj_file.tc_bmj09       #MOD-D10199
 
   LET g_success = 'Y'
   IF s_shut(0) THEN RETURN END IF
   IF p_tc_bmi01 IS NULL THEN RETURN END IF     #FUN-920106
#CHI-C30107 ------------ add ------------ begin
   IF l_tc_bmi.tc_bmiconf='X'      THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_bmi.tc_bmiconf='Y'      THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_bmi.tc_bmiacti= 'N' THEN
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
  IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
     g_action_choice CLIPPED = "insert"  THEN
     IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
  END IF
#CHI-C30107 ------------ add ------------ end
   SELECT * INTO l_tc_bmi.* FROM tc_bmi_file WHERE tc_bmi01 = p_tc_bmi01        #FUN-920106
   IF cl_null(l_tc_bmi.tc_bmi01) THEN CALL cl_err('',-400,0) RETURN END IF
 
   IF l_tc_bmi.tc_bmiconf='X'      THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_bmi.tc_bmiconf='Y'      THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_bmi.tc_bmiacti= 'N' THEN
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
 
   LET l_cnt =0
   #控管單身未輸入資料
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM tc_bmj_file
    WHERE tc_bmj01=l_tc_bmi.tc_bmi01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   #MOD-D10199 -- add start --
   DECLARE i255_tc_bmj09_cs CURSOR FOR
     SELECT tc_bmj09 FROM tc_bmj_file
      WHERE tc_bmj01 = l_tc_bmi.tc_bmi01
   FOREACH i255_tc_bmj09_cs INTO l_tc_bmj09
      IF cl_null(l_tc_bmj09) THEN
         MESSAGE ''
        # CALL cl_err(l_tc_bmi.tc_bmi01,'apm1092',1)
          CALL cl_err(l_tc_bmi.tc_bmi01,'cpm-059',1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
   #MOD-D10199 -- add end --  
 
    #MOD-530602
   #控管分量計價='N',有單身新單價<=0
   IF l_tc_bmi.tc_bmi05 = 'N' THEN
       LET l_cnt=0
       SELECT COUNT(*) INTO l_cnt
         FROM tc_bmj_file
        WHERE tc_bmj01 = l_tc_bmi.tc_bmi01
          AND (tc_bmj07 IS NULL OR tc_bmj07 <=0)
        IF l_cnt >= 1 THEN #MOD-540067
           CALL cl_err(l_tc_bmi.tc_bmi01,'apm-298',1)
           LET g_success = 'N'
           RETURN
        END IF             #MOD-540067
   ELSE
   #控管分量計價='Y',有單身未輸入分量計價資料
       DECLARE i255c_cnt_pmr CURSOR FOR
         SELECT tc_bmj01,tc_bmj02 FROM tc_bmj_file
          WHERE tc_bmj01 = l_tc_bmi.tc_bmi01
       FOREACH i255c_cnt_pmr INTO l_tc_bmj01,l_tc_bmj02
           LET l_cnt=0
           SELECT COUNT(*) INTO l_cnt FROM pmr_file
            WHERE pmr01 = l_tc_bmj01
              AND pmr02 = l_tc_bmj02
           IF l_cnt <=0 THEN
               CALL cl_err(l_tc_bmi.tc_bmi01,'apm-297',1)
               LET g_success = 'N'
               RETURN
           END IF
       END FOREACH
   END IF
   #MOD-530602(end)
 
   #------FUN-880016 start-------------
   IF g_aza.aza71 MATCHES '[Yy]' THEN   #FUN-8A0054 判斷是否有勾選〝與GPM整合〞，有則做GPM控
      LET l_t1 = s_get_doc_no(l_tc_bmi.tc_bmi01) 
      SELECT * INTO g_smy.* FROM smy_file
       WHERE smyslip=l_t1
      IF NOT cl_null(g_smy.smy64) THEN                                                                                   
         IF g_smy.smy64 != '0' THEN    #要控管GPM
            CALL s_showmsg_init()
            CALL aws_gpmcli_part(l_tc_bmi.tc_bmi01,l_tc_bmi.tc_bmi03,'','6')
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
 
   LET l_forupd_sql = "SELECT * FROM tc_bmi_file WHERE tc_bmi01 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE i255sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

 
FUNCTION i255sub_y_upd(l_tc_bmi01,p_action_choice,l_tc_bmj12)
   DEFINE  l_tc_bmi01         LIKE tc_bmi_file.tc_bmi01     #FUN-920106
   DEFINE  p_action_choice STRING                  #FUN-920106
   DEFINE  l_tc_bmi           RECORD LIKE tc_bmi_file.*
   DEFINE  l_tc_bmj           RECORD LIKE tc_bmj_file.*
   DEFINE  l_pmh12         LIKE pmh_file.pmh12
   DEFINE  l_pmh19         LIKE pmh_file.pmh19   #No.FUN-610018
   DEFINE  l_cnt           LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE  l_tc_bmj12         LIKE tc_bmj_file.tc_bmj12      #FUN-920106
   #darcy:2023/05/23 add s---
   define l_sql      string
   define l_cmd      string
   #darcy:2023/05/23 add e---
   
   WHENEVER ERROR CONTINUE                          #FUN-920106

 
   LET g_success = 'Y'
 
   SELECT * INTO l_tc_bmi.* FROM tc_bmi_file WHERE tc_bmi01 = l_tc_bmi01  #FUN-920106
   IF p_action_choice CLIPPED = "confirm" THEN       #按「確認」時
      IF l_tc_bmi.tc_bmi07='Y' THEN
         IF l_tc_bmi.tc_bmi06 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   END IF
 
   BEGIN WORK
 
   CALL i255sub_lock_cl()          #FUN-920106
   OPEN i255sub_cl USING l_tc_bmi01   #FUN-920106
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN i255sub_cl:", STATUS, 1)
      CLOSE i255sub_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i255sub_cl INTO l_tc_bmi.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(l_tc_bmi.tc_bmi01,SQLCA.sqlcode,0)
      CLOSE i255sub_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   DECLARE i255_y CURSOR FOR SELECT * FROM tc_bmj_file WHERE tc_bmj01=l_tc_bmi.tc_bmi01
   FOREACH i255_y INTO l_tc_bmj.*
      IF STATUS THEN EXIT FOREACH END IF
      #darcy:2025/02/21 add s---
      -- 组装良率不得降低
      if l_tc_bmj.tc_bmj04[7,7] matches '[ABC]' and l_tc_bmj.tc_bmj11 ='1' then
         if l_tc_bmj.tc_bmj07 < l_tc_bmj.tc_bmj06 then
            let g_action_choice = 'confirm_vip'
            if not cl_chk_act_auth() then
               let g_success = 'N'
               call cl_err(l_tc_bmi.tc_bmi01,'cbm-039',0)
               close i255sub_cl
               rollback work
               return
            end if
            let g_action_choice = 'confirm'
         end if
         #darcy:2025/03/12 add s---
         -- 组装良率不得小于98.5%
         if l_tc_bmj.tc_bmj07 < 98.5 then
            let g_success = 'N'
            call cl_err(l_tc_bmi.tc_bmi01,'cbm-041',0) 
            close i255sub_cl
            rollback work
            return
         end if
         #darcy:2025/03/12 add e---
      end if
      #darcy:2025/02/21 add e---
      #No.MOD-880193--begin--
      IF cl_null(l_tc_bmj.tc_bmj10) THEN
         LET l_tc_bmj.tc_bmj10 = ' '
      END IF 
   END FOREACH
 
   #MOD-920027---Begin 
   #UPDATE tc_bmi_file SET tc_bmiconf='Y' WHERE tc_bmi01=l_tc_bmi.tc_bmi01
    UPDATE tc_bmi_file SET tc_bmiconf='Y'      #MOD-C90034 remove ,
                       #tc_bmimodu=g_user,  #MOD-C90034 mark
                       #tc_bmidate=g_today  #MOD-C90034 mark
    WHERE tc_bmi01=l_tc_bmi.tc_bmi01
   #MOD-920027---End
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err('upd tc_bmi_file','apm-266',0)   #No.FUN-660129
      CALL cl_err3("upd","tc_bmi_file",l_tc_bmi.tc_bmi01,"","apm-266","","upd tc_bmi_file",1)  #No.FUN-660129
      LET g_success='N'
   END IF
   IF l_tc_bmi.tc_bmi07 = 'N' AND l_tc_bmi.tc_bmi06 = '0' THEN
      LET l_tc_bmi.tc_bmi06 = '1'
      UPDATE tc_bmi_file SET tc_bmi06 = l_tc_bmi.tc_bmi06 WHERE tc_bmi01 = l_tc_bmi.tc_bmi01
      IF SQLCA.sqlcode THEN
#        CALL cl_err('upd tc_bmi_file','apm-266',0)   #No.FUN-660129
         CALL cl_err3("upd","tc_bmi_file",l_tc_bmi.tc_bmi01,"","apm-266","","upd tc_bmi_file",1)  #No.FUN-660129
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM tc_bmj_file
       WHERE tc_bmj01 = l_tc_bmi.tc_bmi01
      IF l_cnt = 0 AND l_tc_bmi.tc_bmi07 = 'Y' THEN
         CALL cl_err(' ','aws-065',0)
         LET g_success = 'N'
      END IF
   END IF
 
 
   IF g_success = 'Y' THEN
      IF l_tc_bmi.tc_bmi07 = 'Y' THEN
         CASE aws_efapp_formapproval()
            WHEN 0  #呼叫 EasyFlow 簽核失敗
               LET l_tc_bmi.tc_bmiconf="N"
               LET g_success = "N"
               ROLLBACK WORK
               RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
               LET l_tc_bmi.tc_bmiconf="N"
               ROLLBACK WORK
               RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET l_tc_bmi.tc_bmi06='1'
         LET l_tc_bmi.tc_bmiconf='Y'
         #LET l_tc_bmi.tc_bmimodu=g_user     #MOD-920027 add #MOD-C90034 mark 
         #LET l_tc_bmi.tc_bmidate=g_today    #MOD-920027 add #MOD-C90034 mark
         COMMIT WORK
         CALL cl_flow_notify(l_tc_bmi.tc_bmi01,'Y')
         DISPLAY BY NAME l_tc_bmi.tc_bmi06
         DISPLAY BY NAME l_tc_bmi.tc_bmiconf
         #DISPLAY BY NAME l_tc_bmi.tc_bmimodu    #MOD-920027 add #MOD-C90034 mark
         #DISPLAY BY NAME l_tc_bmi.tc_bmidate    #MOD-920027 add #MOD-C90034 mark
      ELSE
         LET l_tc_bmi.tc_bmiconf='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET l_tc_bmi.tc_bmiconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF

   #darcy:2023/05/23 add s---
   #发送邮件
   let l_sql = " create or replace view pqrabm0002 as ",
               "SELECT tc_bmj11,tc_bmj04,tc_bmj03,ROUND(tc_bmj07,2) AS tc_bmj07,ROUND(tc_bmj07t,2) as tc_bmj07t, ",
               " to_char(tc_bmj09,'yy/mm/dd') AS tc_bmj09,gen02,tc_bmj01,tc_bmj02 ",
               "  FROM tc_bmj_file ,tc_bmi_file LEFT JOIN gen_file ON gen01 = tc_bmi09 ",
               "  WHERE tc_bmj01=tc_bmi01 and tc_bmi01 ='",l_tc_bmi01,"'"
   prepare i255sub_crtview from l_sql
   execute i255sub_crtview
   if sqlca.sqlcode then
      call cl_err('crt view',sqlca.sqlcode,1)
      return
   end if
   run "/u1/usr/tiptop/fast/mail --config /u1/usr/tiptop/fast/config.mail.json --mail 新良率提醒 --excel  /u1/out/新良率提醒.xlsx --style"
   #darcy:2023/05/23 add e---
 
  #FUN-920106---mark---確認完後統一CALL i255_show()顯示
  ##CKP
  #SELECT * INTO g_tc_bmi.* FROM tc_bmi_file WHERE tc_bmi01 = g_tc_bmi.tc_bmi01
  #IF g_tc_bmi.tc_bmiconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #IF g_tc_bmi.tc_bmi06='1' OR
  #   g_tc_bmi.tc_bmi06='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #IF g_tc_bmi.tc_bmi06='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
  #CALL cl_set_field_pic(g_tc_bmi.tc_bmiconf,g_chr2,"",g_chr3,g_chr,g_tc_bmi.tc_bmiacti)
  #FUN-920106---mark---end---
END FUNCTION
 
 
 
#FUN-920106---add---start---
FUNCTION i255sub_refresh(p_tc_bmi01)
DEFINE p_tc_bmi01 LIKE tc_bmi_file.tc_bmi01
DEFINE l_tc_bmi RECORD LIKE tc_bmi_file.*
 
SELECT * INTO l_tc_bmi.* FROM tc_bmi_file WHERE tc_bmi01=p_tc_bmi01
RETURN l_tc_bmi.*
END FUNCTION
#FUN-920106---add---end-----

# 元件良率
function i255_get_element_rate(p_bmb01,p_bmb03)
   define p_bmb01    like bmb_file.bmb01
   define p_bmb03    like bmb_file.bmb03

   define l_cnt      integer

   define l_rate     like tc_bmj_file.tc_bmj07
   define l_date     like type_file.dat

   #1.是否能查询到已审核良率维护记录
   SELECT COUNT(*) INTO l_cnt FROM tc_bmi_file,tc_bmj_file
   WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
      AND tc_bmj03 = p_bmb03
      AND tc_bmj04 = p_bmb01
      AND tc_bmj11 = '2'

   if l_cnt > 0 then
      DECLARE newrate_cur2 CURSOR FOR
          SELECT tc_bmj09,tc_bmj07
             FROM tc_bmj_file,tc_bmi_file
             WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
                AND tc_bmj03 = p_bmb03
                AND tc_bmj04 = p_bmb01
                AND tc_bmj11 = '2'
                AND tc_bmj09 = (SELECT MAX(tc_bmj09) FROM tc_bmi_file,tc_bmj_file
                                 WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
                                 AND tc_bmj03 = p_bmb03
                                 AND tc_bmj04 = p_bmb01
                                 AND tc_bmj11 = '2')
            ORDER BY tc_bmi01 desc
       open newrate_cur2
       fetch newrate_cur2 into  l_date,l_rate
       close newrate_cur2
       return l_rate,l_date
   else
      return 0,''
   end if
end function

# 成品良率
function i255_get_roduct_rate(p_bmb01)
   define p_bmb01    like bmb_file.bmb01
   define p_bmb03    like bmb_file.bmb03

   define l_cnt      integer

   define l_rate     like tc_bmj_file.tc_bmj07
   define l_date     like type_file.dat

   #1.是否能查询到已审核良率维护记录
   SELECT COUNT(*) INTO l_cnt FROM tc_bmi_file,tc_bmj_file
   WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
      AND tc_bmj04 = p_bmb01
      AND tc_bmj11 = '1'

   if l_cnt > 0 then
      DECLARE newrate_cur3 CURSOR FOR
          SELECT tc_bmj09,tc_bmj07
             FROM tc_bmj_file,tc_bmi_file
             WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
                AND tc_bmj04 = p_bmb01
                AND tc_bmj11 = '1'
                AND tc_bmj09 = (SELECT MAX(tc_bmj09) FROM tc_bmi_file,tc_bmj_file
                                 WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
                                 AND tc_bmj04 = p_bmb01
                                 AND tc_bmj11 = '1')
            ORDER BY tc_bmi01 desc
       open newrate_cur3
       fetch newrate_cur3 into  l_date,l_rate
       close newrate_cur3
       return l_rate,l_date
   else
      return 0,''
   end if
end function

# 子工单良率
function i255_get_subwo_rate(p_bmb01,p_bmb03)
   define p_bmb01    like bmb_file.bmb01
   define p_bmb03    like bmb_file.bmb03

   define l_cnt      integer

   define l_rate     like tc_bmj_file.tc_bmj07
   define l_date     like type_file.dat

   #1.是否能查询到已审核良率维护记录
   SELECT COUNT(*) INTO l_cnt FROM tc_bmi_file,tc_bmj_file
   WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
      AND tc_bmj03 = p_bmb03
      AND tc_bmj04 = p_bmb01
      AND tc_bmj11 = '3'

   if l_cnt > 0 then
      DECLARE newrate_cur4 CURSOR FOR
          SELECT tc_bmj09,tc_bmj07
             FROM tc_bmj_file,tc_bmi_file
             WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
                AND tc_bmj03 = p_bmb03
                AND tc_bmj04 = p_bmb01
                AND tc_bmj11 = '3'
                AND tc_bmj09 = (SELECT MAX(tc_bmj09) FROM tc_bmi_file,tc_bmj_file
                                 WHERE tc_bmj01=tc_bmi01 AND tc_bmiconf = 'Y'
                                 AND tc_bmj03 = p_bmb03
                                 AND tc_bmj04 = p_bmb01
                                 AND tc_bmj11 = '3')
            ORDER BY tc_bmi01 desc
       open newrate_cur4
       fetch newrate_cur4 into  l_date,l_rate
       close newrate_cur4
       return l_rate,l_date
   else
      return 0,''
   end if
end function
