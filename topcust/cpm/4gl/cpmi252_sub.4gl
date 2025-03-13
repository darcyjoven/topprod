# Prog. Version..: '5.30.06-13.03.19(00006)'     #
#
# Program name...: cpmi255_sub.4gl
# Description....: 提供cpmi255.4gl使用的sub routine
# Date & Author..: 09/02/20 by sabrina
# Modify.........: No.FUN-920106 09/02/20 By sabrina 新建立
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10043 10/01/11 By Lilan 從EasyFlow端簽核時可進行自動確認(不開窗,帶預設值)
# Modify.........: No.FUN-AA0015 10/10/07 By Nicola 預設pmh25 
# Modify.........: No:MOD-AB0166 10/11/17 By Smcpmin 分配比率沒有檢核不可大於100
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-C90034 12/10/22 By Nina 還原 MOD-920027 確認,取消確認時需要更新最近更改者和最近更改日的調整 
# Modify.........: No:CHI-C10039 12/11/16 By jt_chen 增加回寫核准狀態.
# Modify.........: No.CHI-C20012 12/12/06 By pauline 新增pmh_file時增加欄位pmh06核准日期,當狀態為已核准時,pmh06為必輸
# Modify.........: No.FUN-C40009 13/01/10 By Nina 只要程式有UPDATE pmh_file 的任何一個欄位時,多加pmhdate=g_today
# Modify.........: No.MOD-D10199 13/01/31 By jt_chen 新增檢核單身tc_pmx09是否為NULL
# Modify.........: No.MOD-D60113 13/06/13 By SunLM 修改cpmi255a画面,显示料号,且能关闭cpmi255a画面
DATABASE ds

GLOBALS "../../config/top.global"
 
FUNCTION i255sub_y_chk(p_tc_pmw01,p_inTransaction)
define p_inTransaction  like type_file.chr1
DEFINE p_tc_pmw01     LIKE tc_pmw_file.tc_pmw01      #FUN-920106
DEFINE l_cnt       LIKE type_file.num5  
DEFINE l_str       LIKE gfe_file.gfe01  
DEFINE l_pml04     LIKE pml_file.pml04
DEFINE l_imaacti   LIKE ima_file.imaacti
DEFINE l_ima140    LIKE ima_file.ima140
DEFINE l_tc_pmx01     LIKE tc_pmx_file.tc_pmx01 
DEFINE l_tc_pmx02     LIKE tc_pmx_file.tc_pmx02
DEFINE l_pmm01     LIKE pmm_file.pmm01   
DEFINE l_pmm09     LIKE pmm_file.pmm09  
DEFINE l_status    LIKE type_file.chr1
DEFINE l_tc_pmw       RECORD LIKE tc_pmw_file.*    #FUN-920106
DEFINE l_t1        LIKE smy_file.smyslip     #FUN-920106
DEFINE l_tc_pmx09     LIKE tc_pmx_file.tc_pmx09       #MOD-D10199
define l_sql      string
define l_tc_pmx03   like tc_pmx_file.tc_pmx03
define l_tc_pmx031  like tc_pmx_file.tc_pmx031
DEFINE l_tc_pmx           RECORD LIKE tc_pmx_file.*
define l_where    varchar(500)
 
   LET g_success = 'Y'
   IF s_shut(0) THEN RETURN END IF
   IF p_tc_pmw01 IS NULL THEN RETURN END IF     #FUN-920106
#CHI-C30107 ------------ add ------------ begin
   IF l_tc_pmw.tc_pmwconf='X'      THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_pmw.tc_pmwconf='Y'      THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_pmw.tc_pmwacti= 'N' THEN
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
  IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
     g_action_choice CLIPPED = "insert"  THEN
     if cl_null(g_bgjob) or g_bgjob ='N' then
      IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
     end if
  END IF
#CHI-C30107 ------------ add ------------ end
   SELECT * INTO l_tc_pmw.* FROM tc_pmw_file WHERE tc_pmw01 = p_tc_pmw01        #FUN-920106
   IF cl_null(l_tc_pmw.tc_pmw01) THEN CALL cl_err('',-400,0) RETURN END IF
 
   IF l_tc_pmw.tc_pmwconf='X'      THEN
      CALL cl_err('','9024',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_pmw.tc_pmwconf='Y'      THEN
      CALL cl_err('','9023',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF l_tc_pmw.tc_pmwacti= 'N' THEN
       CALL cl_err('','mfg0301',1)
       LET g_success = 'N'
       RETURN
   END IF
 
   LET l_cnt =0
   #控管單身未輸入資料
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM tc_pmx_file
    WHERE tc_pmx01=l_tc_pmw.tc_pmw01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      LET g_success = 'N'
      RETURN
   END IF

   #darcy:2023/06/09 add s---
   # 文件检查，不上传不允许审核/送签
   # bpm上传，ERP不检查
   # LET l_cnt =0
   # let l_where = "tc_pmw01=",l_tc_pmw.tc_pmw01
   # select count(1) into l_cnt from gca_file,gcb_file 
   #  where gca07 = gcb01 and gca01 = l_where
   # if l_cnt = 0 then
   #    call cl_err(l_tc_pmw.tc_pmw01,'cpm-075',1)
   #    let g_success = 'N'
   #    return
   # end if
   #
   #darcy:2023/06/09 add e---
 
   #MOD-D10199 -- add start --
   DECLARE i255_tc_pmx09_cs CURSOR FOR
     SELECT tc_pmx09 FROM tc_pmx_file
      WHERE tc_pmx01 = l_tc_pmw.tc_pmw01
   FOREACH i255_tc_pmx09_cs INTO l_tc_pmx09
      IF cl_null(l_tc_pmx09) THEN
         MESSAGE ''
        # CALL cl_err(l_tc_pmw.tc_pmw01,'apm1092',1)
          CALL cl_err(l_tc_pmw.tc_pmw01,'cpm-059',1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
   #MOD-D10199 -- add end --  

   #darcy:2023/05/24 add s---
   CALL s_showmsg_init()
   declare i252sub_tc_pmx03 cursor for 
      SELECT UNIQUE tc_pmx03 FROM tc_pmx_file WHERE tc_pmx03 !='MISC' and tc_pmx01 = l_tc_pmw.tc_pmw01
   
   foreach i252sub_tc_pmx03 into l_tc_pmx03
      let l_cnt = 0
      select count(1) into l_cnt from tc_pmx_file where tc_pmx01 = l_tc_pmw.tc_pmw01
       and tc_pmx03 = l_tc_pmx03 and tc_pmx20 ='Y'
      if l_cnt = 0 then
         call s_errmsg("tc_pmx03",l_tc_pmx03,l_cnt,'cpm-069',1)
         LET g_success = 'N'
      end if
      if l_cnt > 1 then
         call s_errmsg("tc_pmx03",l_tc_pmx03,l_cnt,'cpm-068',1)
         LET g_success = 'N'
      end if
      
   end foreach
   
   declare i252sub_tc_pmx031 cursor for
      SELECT UNIQUE tc_pmx031 FROM tc_pmx_file WHERE tc_pmx03  ='MISC' and tc_pmx01 = l_tc_pmw.tc_pmw01
   foreach i252sub_tc_pmx031 into l_tc_pmx031
      let l_cnt = 0
      select count(1) into l_cnt from tc_pmx_file where tc_pmx01 = l_tc_pmw.tc_pmw01
       and tc_pmx031 = l_tc_pmx031 and tc_pmx03='MISC' and tc_pmx20 ='Y'
      if l_cnt = 0 then
         call s_errmsg("tc_pmx031",l_tc_pmx031,l_cnt,'cpm-069',1)
         LET g_success = 'N'
      end if
      if l_cnt > 1 then
         call s_errmsg("tc_pmx031",l_tc_pmx031,l_cnt,'cpm-068',1)
         LET g_success = 'N'
      end if
   end foreach
   if cl_null(g_bgjob) or g_bgjob ='N' then
      CALL s_showmsg()
   end if
   #darcy:2023/05/24 add e---


   update tc_pmx_file set tc_pmx21 = 'Y'
    where tc_pmx06 is not null and tc_pmx07 > tc_pmx06
      and tc_pmx01 = l_tc_pmw.tc_pmw01
   
   update tc_pmx_file set tc_pmx21 = 'N'
    where tc_pmx06 is null or tc_pmx07 <= tc_pmx06
      and tc_pmx01 = l_tc_pmw.tc_pmw01

   let l_cnt = 0
   select count(1) into l_cnt from tc_pmx_file
    where tc_pmx06 is not null and tc_pmx07 > tc_pmx06 and tc_pmx20 ='Y'
      and tc_pmx01 = l_tc_pmw.tc_pmw01
   if l_cnt > 0 then
      update tc_pmw_file set tc_pmw05 = 'Y'
       where tc_pmw01 = l_tc_pmw.tc_pmw01
      display 'Y' to tc_pmw05
   #darcy:2023/08/17 remark s---
   # else
   #    update tc_pmw_file set tc_pmw05 = 'N'
   #     where tc_pmw01 = l_tc_pmw.tc_pmw01
   #    display 'N' to tc_pmw05
   #darcy:2023/08/17 remark e---
   end if

END FUNCTION

 
FUNCTION i255sub_lock_cl()
   DEFINE l_forupd_sql STRING
 
   LET l_forupd_sql = "SELECT * FROM tc_pmw_file WHERE tc_pmw01 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE i255sub_cl CURSOR FROM l_forupd_sql
END FUNCTION

 
FUNCTION i255sub_y_upd(l_tc_pmw01,p_action_choice,p_inTransaction)
   define p_inTransaction     like type_file.chr1
   DEFINE  l_tc_pmw01         LIKE tc_pmw_file.tc_pmw01     #FUN-920106
   DEFINE  p_action_choice STRING                  #FUN-920106
   DEFINE  l_tc_pmw           RECORD LIKE tc_pmw_file.*
   DEFINE  l_tc_pmx           RECORD LIKE tc_pmx_file.*
   DEFINE  l_pmh12         LIKE pmh_file.pmh12
   DEFINE  l_pmh19         LIKE pmh_file.pmh19   #No.FUN-610018
   DEFINE  l_cnt           LIKE type_file.num5    #No.FUN-680136 SMALLINT
   WHENEVER ERROR CONTINUE                          #FUN-920106
 
   LET g_success = 'Y'
 
   SELECT * INTO l_tc_pmw.* FROM tc_pmw_file WHERE tc_pmw01 = l_tc_pmw01  #FUN-920106
   IF p_action_choice CLIPPED = "confirm" THEN       #按「確認」時
      IF l_tc_pmw.tc_pmw07='Y' THEN
         IF l_tc_pmw.tc_pmw06 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   END IF
   if not p_inTransaction then
      BEGIN WORK
   end if
 
   CALL i255sub_lock_cl()          #FUN-920106
   OPEN i255sub_cl USING l_tc_pmw01   #FUN-920106
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN i255sub_cl:", STATUS, 1)
      CLOSE i255sub_cl
      if not p_inTransaction then
         ROLLBACK WORK
      end if
      RETURN
   END IF
   FETCH i255sub_cl INTO l_tc_pmw.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(l_tc_pmw.tc_pmw01,SQLCA.sqlcode,0)
      CLOSE i255sub_cl
      if not p_inTransaction then
         ROLLBACK WORK
      end if
      RETURN
   END IF 
   #MOD-920027---Begin 
   #UPDATE tc_pmw_file SET tc_pmwconf='Y' WHERE tc_pmw01=l_tc_pmw.tc_pmw01
    UPDATE tc_pmw_file SET tc_pmwconf='Y'      #MOD-C90034 remove ,
                       #tc_pmwmodu=g_user,  #MOD-C90034 mark
                       #tc_pmwdate=g_today  #MOD-C90034 mark
    WHERE tc_pmw01=l_tc_pmw.tc_pmw01
   #MOD-920027---End
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err('upd tc_pmw_file','apm-266',0)   #No.FUN-660129
      CALL cl_err3("upd","tc_pmw_file",l_tc_pmw.tc_pmw01,"","apm-266","","upd tc_pmw_file",1)  #No.FUN-660129
      LET g_success='N'
   END IF
   IF l_tc_pmw.tc_pmw07 = 'N' AND l_tc_pmw.tc_pmw06 = '0' THEN
      LET l_tc_pmw.tc_pmw06 = '1'
      UPDATE tc_pmw_file SET tc_pmw06 = l_tc_pmw.tc_pmw06 WHERE tc_pmw01 = l_tc_pmw.tc_pmw01
      IF SQLCA.sqlcode THEN
#        CALL cl_err('upd tc_pmw_file','apm-266',0)   #No.FUN-660129
         CALL cl_err3("upd","tc_pmw_file",l_tc_pmw.tc_pmw01,"","apm-266","","upd tc_pmw_file",1)  #No.FUN-660129
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM tc_pmx_file
       WHERE tc_pmx01 = l_tc_pmw.tc_pmw01
      IF l_cnt = 0 AND l_tc_pmw.tc_pmw07 = 'Y' THEN
         CALL cl_err(' ','aws-065',0)
         LET g_success = 'N'
      END IF
   END IF
 
 
   IF g_success = 'Y' THEN
      IF g_success='Y' THEN
         LET l_tc_pmw.tc_pmw06='1'
         LET l_tc_pmw.tc_pmwconf='Y'
         #LET l_tc_pmw.tc_pmwmodu=g_user     #MOD-920027 add #MOD-C90034 mark 
         #LET l_tc_pmw.tc_pmwdate=g_today    #MOD-920027 add #MOD-C90034 mark
         if not p_inTransaction then
            commit WORK
         end if
         # CALL cl_flow_notify(l_tc_pmw.tc_pmw01,'Y')
         # DISPLAY BY NAME l_tc_pmw.tc_pmw06
         # DISPLAY BY NAME l_tc_pmw.tc_pmwconf
         #DISPLAY BY NAME l_tc_pmw.tc_pmwmodu    #MOD-920027 add #MOD-C90034 mark
         #DISPLAY BY NAME l_tc_pmw.tc_pmwdate    #MOD-920027 add #MOD-C90034 mark
      ELSE
         LET l_tc_pmw.tc_pmwconf='N'
         LET g_success = 'N'
         if not p_inTransaction then
         ROLLBACK WORK
      end if
      END IF
   ELSE
      LET l_tc_pmw.tc_pmwconf='N'
      LET g_success = 'N'
      if not p_inTransaction then
         ROLLBACK WORK
      end if
   END IF
 
  #FUN-920106---mark---確認完後統一CALL i255_show()顯示
  ##CKP
  #SELECT * INTO g_tc_pmw.* FROM tc_pmw_file WHERE tc_pmw01 = g_tc_pmw.tc_pmw01
  #IF g_tc_pmw.tc_pmwconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #IF g_tc_pmw.tc_pmw06='1' OR
  #   g_tc_pmw.tc_pmw06='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #IF g_tc_pmw.tc_pmw06='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
  #CALL cl_set_field_pic(g_tc_pmw.tc_pmwconf,g_chr2,"",g_chr3,g_chr,g_tc_pmw.tc_pmwacti)
  #FUN-920106---mark---end---
END FUNCTION
 
FUNCTION i255sub_tc_pmx03_add(p_tc_pmx03,p_tc_pmx05,p_tc_pmx12,p_tc_pmx10,l_tc_pmw,p_tc_pmx13)
   DEFINE l_pmh     RECORD LIKE pmh_file.*,
          l_ima54   LIKE ima_file.ima54,
          p_tc_pmx03   LIKE tc_pmx_file.tc_pmx03,
          p_tc_pmx05   LIKE tc_pmx_file.tc_pmx05
   DEFINE p_tc_pmx12   LIKE tc_pmx_file.tc_pmx12
   DEFINE p_tc_pmx10   LIKE tc_pmx_file.tc_pmx10
   DEFINE m_pmh11   LIKE pmh_file.pmh11  #No.MOD-8B0235 add
   DEFINE l_tc_pmw     RECORD LIKE tc_pmw_file.*   #FUN-920106
   DEFINE p_row,p_col  LIKE type_file.num5   #FUN-920106
   DEFINE p_tc_pmx13   LIKE tc_pmx_file.tc_pmx13      #FUN-920106

   INITIALIZE l_pmh.* TO NULL
   LET l_pmh.pmh01=p_tc_pmx03         #料件編號
   LET l_pmh.pmh02=l_tc_pmw.tc_pmw03               #廠商編號
   LET l_pmh.pmh13=p_tc_pmx05         #幣別
   LET l_pmh.pmh22=p_tc_pmx12  #No.FUN-670099
   LET l_pmh.pmh21=p_tc_pmx10  #No.FUN-670099
   LET l_pmh.pmhacti='Y'
   LET l_pmh.pmhgrup=g_grup
   LET l_pmh.pmhuser=g_user
   LET l_pmh.pmh06=''
   LET l_pmh.pmh12=0
   LET l_pmh.pmh14=1
   LET l_pmh.pmhdate=g_today
  #LET l_pmh.pmh23=p_tc_pmx[l_ac].tc_pmx13   #No.FUN-810017
   LET l_pmh.pmh23=p_tc_pmx13      #FUN-920106 
   LET l_pmh.pmh06 = g_today    #CHI-C20012 add
   #No.FUN-610018 --start--
   LET l_pmh.pmh19=0
   SELECT pmc47,gec04
     INTO l_pmh.pmh17,l_pmh.pmh18
     FROM pmc_file,gec_file
    WHERE pmc01 = l_tc_pmw.tc_pmw03
      AND gec011 = '1'
      AND gec01 = pmc47
   #No.FUN-610018 --end--
   #是否為主要供應商
   #SELECT ima54 INTO l_ima54 FROM ima_file WHERE ima01=g_tc_pmx[l_ac].tc_pmx03
   #No.B433 010423 BY ANN CHEN

   SELECT ima54,ima100,ima24,ima101,ima102   
     INTO l_ima54,l_pmh.pmh09,l_pmh.pmh08,l_pmh.pmh15,l_pmh.pmh16   
     FROM ima_file
    WHERE ima01=p_tc_pmx03


   IF l_tc_pmw.tc_pmw03=l_ima54 THEN
      LET l_pmh.pmh03='Y'
   ELSE
      LET l_pmh.pmh03='N'
   END IF
 
   IF g_aza.aza17 = l_pmh.pmh13 THEN   #本幣
      LET l_pmh.pmh14 = 1
   ELSE
     #CALL s_curr3(l_pmh.pmh13,g_tc_pmw.tc_pmw02,'S') #FUN-640012
      CALL s_curr3(l_pmh.pmh13,l_tc_pmw.tc_pmw02,g_sma.sma904) #FUN-640012
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
            CALL i255sub_pmh13(l_pmh.pmh13)
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
FUNCTION i255sub_refresh(p_tc_pmw01)
DEFINE p_tc_pmw01 LIKE tc_pmw_file.tc_pmw01
DEFINE l_tc_pmw RECORD LIKE tc_pmw_file.*
 
SELECT * INTO l_tc_pmw.* FROM tc_pmw_file WHERE tc_pmw01=p_tc_pmw01
RETURN l_tc_pmw.*
END FUNCTION
#FUN-920106---add---end-----
 
 
