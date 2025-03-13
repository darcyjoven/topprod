# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp551.4gl
# Descriptions...: 採購單結案作業
# Date & Author..: 91/09/27 By Wu
#           Note : 委外採購不可在此結案
# Modify         : No:8358 92/09/26 By Melody 移除 UPDATE sfb_file...程式段
# Modify ........: No:9787 04/07/22 By Wiky 加入權限控管
# Modify ........: No.MOD-640305 06/04/11 By kim 加入QBE查詢條件功能
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-710030 07/01/19 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-740117 07/04/20 By rainy GP5.0整合測試
# Modify.........: No.FUN-740131 07/04/23 By Claire mfg3209改apm-049,要顯示已結案而非沒資料
# Modify.........: No.TQC-880009 08/08/05 By chenyu 在結案的時候增加一個判斷，如果在收貨單中有未審核的采購單則不能結案
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A10177 10/01/27 By Dido 應排除多角單據
# Modify.........: No:MOD-A20023 10/02/03 By Dido 開窗調整 
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-B10168 11/01/21 By Summer 改判斷無採購單時出現的訊息
# Modify.........: No:CHI-B30030 11/04/19 By Smapmin 採購單如已有預付，要結案時應提醒使用者已有預付單據是否真的要結案。
# Modify.........: No:MOD-B50246 11/06/15 By Summer 還原MOD-A10177,要是多角且已拋轉的單據才可執行
# Modify.........: No:MOD-BB0263 11/11/23 By Vampire 確認碼為Y已確認,且狀況碼為2發出採購單、6結案者才可做結案還原,單身只要有一筆是未結案的,單頭狀況碼就會是2發出採購單
# Modify.........: No:MOD-D60021 13/06/04 By SunLM 采購單有對應采購變更單，變更單未審核，未發出，采購單不可以結案
# Modify.........: No.18010101   by shawn    添加SCM结案接口

DATABASE ds

 
GLOBALS "../../config/top.global"
 
DEFINE
   tm RECORD
      pmm01      LIKE pmm_file.pmm01,     #請購單號
      pmm09      LIKE pmm_file.pmm09,     #廠商編號
      y          LIKE type_file.chr1      #已結案資料是否顯示 #No.FUN-680136 VARCHAR(1)
   END RECORD,
   g_pmn    DYNAMIC ARRAY OF RECORD
        sure     LIKE type_file.chr1,     # 確定否     #No.FUN-680136 VARCHAR(1)
        pmn02    LIKE pmn_file.pmn02,     # 項次
        pmn04    LIKE pmn_file.pmn04,     # 料號
        pmn16    LIKE pmn_file.pmn16,     # 目前狀況   #No.FUN-680136 VARCHAR(15)
        qty      LIKE pmn_file.pmn50      # 未移轉數量 #No.FUN-680136 DECIMAL(13,3)
        END RECORD,
    g_cmd        LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(60)
    g_rec_b      LIKE type_file.num5,     #No.FUN-680136 SMALLINT
    g_flag       LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
    l_ac,l_sl    LIKE type_file.num5      #No.FUN-680136 SMALLINT
DEFINE  l_sql    LIKE type_file.chr1000   #No.9787 #No.FUN-680136 VARCHAR(600)
DEFINE  g_cnt    LIKE type_file.num10     #No.FUN-680136 INTEGER

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL p551_tm()
   CLOSE WINDOW p551_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p551_tm()
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE l_no          LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE
          l_pmn20       LIKE pmn_file.pmn20,
          l_pmn09       LIKE pmn_file.pmn09,
          l_pmn50       LIKE pmn_file.pmn20,
          l_pmn011      LIKE pmn_file.pmn011,
          l_pmn41       LIKE pmn_file.pmn41,
          l_pmn55       LIKE pmn_file.pmn55,
          l_wc          LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(200)
          l_sql         LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(600)
          l_cnt         LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          g_sta         LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01          #MOD-640305
   DEFINE l_msg         LIKE type_file.chr100   #CHI-B30030
#No.18010101   #add closePurchaseOrder interface  -- begin --  
   DEFINE l_data DYNAMIC ARRAY OF RECORD 
                poNo        LIKE pmn_file.pmn01,
                serNo       LIKE pmn_file.pmn02,
                groupCode   LIKE type_file.chr100,
                sta      LIKE type_file.chr1
                 END RECORD 
   DEFINE l_j    LIKE type_file.num5 
   DEFINE l_ret        RECORD
             success   LIKE type_file.chr1,
             code      LIKE type_file.chr10,
             msg       STRING
                       END RECORD
   DEFINE  l_return_msg  STRING 
   #No.18010101 --end 
   LET p_row = 2 LET p_col = 19
 
   OPEN WINDOW p551_w AT p_row,p_col WITH FORM "apm/42f/apmp551"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
   IF s_shut(0) THEN RETURN END IF
 
   WHILE TRUE
      CLEAR FORM
      CALL g_pmn.clear()
      INITIALIZE tm.* TO NULL            # Default condition
      LET tm.y = 'N'
      ERROR ''
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
      INPUT BY NAME tm.pmm01,tm.y     WITHOUT DEFAULTS
 
         #MOD-640305...............begin
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #MOD-640305...............end
 
         AFTER FIELD pmm01            #請購單號
            IF NOT cl_null(tm.pmm01) THEN
               CALL p551_pmm01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.pmm01,g_errno,0)
                  NEXT FIELD pmm01
               END IF
            END IF
 
         AFTER FIELD y               #已結案資料是否顯示
            IF NOT cl_null(tm.y) THEN
               IF tm.y NOT MATCHES "[YNyn]"  THEN
                  NEXT FIELD y
               END IF
            END IF
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmm01) #單號
#FUN-4A0068
#                 CALL q_pmm2(FALSE,TRUE,tm.pmm01,'2') RETURNING tm.pmm01
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_pmm12"          #MOD-A20023 mark    
                  LET g_qryparam.form = "q_pmm02"          #MOD-A20023 
                  CALL cl_create_qry() RETURNING tm.pmm01
                  DISPLAY BY NAME tm.pmm01
                  CALL p551_pmm01()
                  NEXT FIELD pmm01
##
               OTHERWISE EXIT CASE
            END CASE
         #MOD-640305...............begin
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #MOD-640305...............end
 
         ON ACTION qry_po_detail
            #CALL  cl_cmdrun("apmt540 ")      #FUN-660216 remark
            CALL  cl_cmdrun_wait("apmt540 ")  #FUN-660216 add
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION locale                    #genero
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
      END INPUT
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      LET g_success = 'Y'
      CALL p551_b_fill()
      IF g_success = 'N' THEN
         CONTINUE WHILE
      END IF
 
      CALL  p551_sure()         #確定否
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CONTINUE WHILE
      END IF
 
      IF cl_sure(0,0) THEN
         BEGIN WORK
         LET g_success='Y'
        #NO.18010101  --begin ---
         INITIALIZE l_ret TO NULL
         LET l_j = 1
         LET l_return_msg = " "
         #NO.18010101   --END 
         CALL cl_wait()
         CALL s_showmsg_init()        #No.FUN-710030
         FOR l_no = 1 TO g_rec_b
#No.FUN-710030 -- begin --
            IF g_success="N" THEN
               LET g_totsuccess="N"
               LET g_success="Y"
            END IF
#No.FUN-710030 -- end --
            IF g_pmn[l_no].sure = 'Y' THEN
               #No.TQC-880009 --add--begin---
               SELECT COUNT(*) INTO l_cnt FROM rva_file,rvb_file
                WHERE rva01 = rvb01
                  AND rvaconf = 'N'
                  AND rvb03 = g_pmn[l_no].pmn02
                  AND rvb04 = tm.pmm01
               IF l_cnt > 0 THEN
                  LET g_totsuccess = 'N'
                  CALL cl_err('','apm-949',1)
                  EXIT FOR
               END IF 
               #No.TQC-880009 --add---end----
       #MOD-D60021 add begin------
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM pna_file,pnb_file 
                WHERE pna01 = tm.pmm01
                  AND pna01 = pnb01
                  AND pnb03 = g_pmn[l_no].pmn02
                  AND (pna05='N' OR (pna05='Y' AND pnaconf='N' ))
               IF l_cnt > 0 THEN 
                  LET g_success = 'N'
                  CALL cl_err('pmm01','apm-454',1)
                  EXIT FOR 
               END IF     
       #MOD-D60021 add end--------                
               #-----CHI-B30030---------
               LET l_cnt = 0 
               SELECT COUNT(*) INTO l_cnt FROM apa_file,apb_file
                 WHERE apa01 = apb01 
                   AND apa00 = '15'
                   AND apb06 = tm.pmm01
                   AND apb07 = g_pmn[l_no].pmn02
                   AND apa42 = 'N'
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt > 0 THEN
                  CALL cl_getmsg('apm1055',g_lang) RETURNING l_msg
                  LET l_msg = tm.pmm01,'-',g_pmn[l_no].pmn02,l_msg
                  IF NOT cl_confirm(l_msg) THEN  
                     CONTINUE FOR
                  END IF
               END IF
               #-----END CHI-B30030-----
               CALL p551_sta(l_no) RETURNING g_sta
               UPDATE pmn_file SET pmn16 = g_sta,pmn57 = g_pmn[l_no].qty
                  WHERE pmn01 = tm.pmm01 AND pmn02 = g_pmn[l_no].pmn02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  LET g_success='N'
#                 CALL cl_err('(p551:ckp#3)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                  CALL cl_err3("upd","pmn_file",tm.pmm01,g_pmn[l_no].pmn02,SQLCA.sqlcode,"","(p551:ckp#3)",1)  #No.FUN-660129
#                  EXIT FOR
                  IF g_bgerr THEN
                     LET g_showmsg = tm.pmm01,"/",g_pmn[l_no].pmn02
                     CALL s_errmsg("pmn01,pmn02",g_showmsg,"(p551:ckp#3)",SQLCA.sqlcode,1)
                     CONTINUE FOR
                  ELSE
                     CALL cl_err3("upd","pmn_file",tm.pmm01,g_pmn[l_no].pmn02,SQLCA.sqlcode,"","(p551:ckp#3)",1)
                     EXIT FOR
                  END IF
#No.FUN-710030 -- end --
	              #No.18010101   #add closePurchaseOrder interface  -- begin --  
	               ELSE
	                   LET l_data[l_j].poNo = tm.pmm01
	                   LET l_data[l_j].serNo = g_pmn[l_no].pmn02
	                   LET l_data[l_j].sta = g_sta
	                   LET l_data[l_j].groupCode = g_plant
	                   LET l_j = l_j + 1
	               #No.18010101 --end 
               END IF
               # MODIFY BY MAY 92/01/10
               SELECT pmn20,pmn50,pmn55,pmn09,pmn011,pmn41
                  INTO l_pmn20,l_pmn50,l_pmn55,l_pmn09,l_pmn011,l_pmn41
                  FROM pmn_file
                  WHERE pmn01 = tm.pmm01 AND pmn02 = g_pmn[l_no].pmn02
               IF SQLCA.sqlcode THEN
                  LET l_pmn09 = 1    LET l_pmn20 = 0
                  LET l_pmn50 = 0
                  LET l_pmn55 = 0
               END IF
            END IF
         END FOR
#No.FUN-710030 -- begin --
         IF g_totsuccess="N" THEN
            LET g_success="N"
         END IF
#No.FUN-710030 -- end --
      END IF
       #NO.18010101  --BEGIN --
        IF cl_getscmparameter() THEN
             FOR l_no=1 TO l_j-1
                 CALL cjc_zmx_json_closepmnorder(l_data[l_no].poNo,l_data[l_no].serNo,l_data[l_no].sta) RETURNING l_ret.*
                 IF l_ret.success <> 'Y' THEN
                     LET l_return_msg = l_ret.msg,"   ",l_data[l_no].poNo CLIPPED,"/",l_data[l_no].serNo CLIPPED
                 END IF
             END FOR
            IF NOT cl_null(l_return_msg) THEN
                LET l_return_msg = l_return_msg,"同步失败"
                CALL cl_err(l_return_msg,'!',1)
                LET g_success = 'N'
            END IF
        END IF
         #NO.18010101  ---END ---
      CALL p551_hu()               #update 單身狀況碼
      CALL s_showmsg()       #No.FUN-710030
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
      ELSE
         ROLLBACK WORK
         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
      END IF
 
      IF g_flag THEN
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
   END WHILE
   ERROR ""
 
END FUNCTION
 
FUNCTION p551_pmm01()
   DEFINE l_n           LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE l_pmm09       LIKE pmm_file.pmm09,
          l_pmm25       LIKE pmm_file.pmm25,
          l_pmn01       LIKE pmn_file.pmn01,
          l_pmm01       LIKE pmm_file.pmm01,
          l_pmm02       LIKE pmm_file.pmm02,
          l_pmc03       LIKE pmc_file.pmc03
   DEFINE l_pmn 	RECORD LIKE pmn_file.*
 
   LET g_errno=' '
   LET l_pmm09=NULL
   LET l_pmc03=NULL
   SELECT pmm01,pmm02,pmm09,pmm25 INTO l_pmm01,l_pmm02,l_pmm09,l_pmm25
     FROM pmm_file 
    WHERE pmm01 = tm.pmm01
     #AND pmm02 NOT IN ('TRI','TAP') AND pmm901 = 'N'    #MOD-A10177 #MOD-B50246 mark 
      AND pmm905 != 'Y'    #MOD-B50246 add 
      AND pmm18 = 'Y'      #MOD-BB0263 add
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3207'
      WHEN l_pmm25 matches '[01]' LET g_errno = 'mfg3208'
      WHEN l_pmm25 = '6'   #單頭狀況碼為'已結案'
            #---------check 單身是否有資料------------
               select pmn_file.* into l_pmn.* from pmn_file,pmm_file
               where pmn01=l_pmm01
               and pmm25='6'
               and pmn01=pmm01
          IF cl_null(l_pmn01) THEN    #無單身資料
             #LET g_errno = 'mfg3209'  #FUN-740131 mark
              LET g_errno = 'apm-049'  #FUN-740131 
          ELSE
             LET g_errno = ' '
             INITIALIZE l_pmn.* TO NULL
          end if
      WHEN l_pmm25 = '9' LET g_errno = 'mfg3210'
      OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
 
   IF l_pmm02 ='SUB' THEN
      LET g_errno ='mfg9311'
   END IF
 
   SELECT COUNT(*) INTO l_n FROM pmn_file
    WHERE pmn01 = tm.pmm01 AND pmn51 <= 0
   IF l_n = 0 THEN
      LET g_errno = 'mfg9171'
   END IF
   #No.9787
   LET l_sql =" SELECT COUNT(*) ",
              "  FROM pmm_file WHERE pmm01 =?"
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET l_sql = l_sql clipped," AND pmmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET l_sql = l_sql clipped," AND pmmgrup MATCHES '",
   #                  g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET l_sql = l_sql clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET l_sql = l_sql CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
   #End:FUN-980030
 
   PREPARE pmm_curs FROM l_sql
   EXECUTE pmm_curs USING tm.pmm01 INTO l_n
   IF l_n = 0 THEN LET g_errno = 'agl-199' END IF #MOD-B10168 mod agl-126->agl-199
   #No.9787(end)
   IF cl_null(g_errno) THEN
      SELECT pmc03 INTO l_pmc03 FROM pmc_file
       WHERE pmc01 = l_pmm09
   END IF
 
   DISPLAY l_pmm09 TO FORMONLY.pmm09
   DISPLAY l_pmc03 TO FORMONLY.pmc03
 
END FUNCTION
 
FUNCTION p551_b_fill()
   DEFINE
        l_pmn50       LIKE pmn_file.pmn20,
        l_pmn011      LIKE pmn_file.pmn011,
        l_pmn41       LIKE pmn_file.pmn41,
	l_pmn55       LIKE pmn_file.pmn55,
        l_pmm18       LIKE pmm_file.pmm18,
        l_pmmmksg     LIKE pmm_file.pmmmksg,
        l_wc          LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(200)
        l_sql         LIKE type_file.chr1000,     # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(600)
        l_no,l_cnt    LIKE type_file.num5,        #No.FUN-680136 SMALLINT
        g_sta         LIKE type_file.chr1         #No.FUN-680136
 
#NO:3064  99/03/30 modify by Carol:超短交量=pmn50-pmn20-pmn55
   LET l_sql = " SELECT 'N',pmn02,pmn04,pmn16,",
               " nvl(pmn50-pmn20-pmn55-pmn58,0),pmn011,pmn41,pmm18,pmmmksg ", #darcy:2024/07/05 add -pmn58
               "  FROM pmn_file,pmm_file",
               " WHERE pmn51 <= 0 AND pmn011 !='SUB' AND pmn01=pmm01"
 
   IF tm.y matches'[yY]' THEN
      LET l_wc   = "  AND pmn01 = '",tm.pmm01,"' AND pmn16 !='9' ",
                   "  ORDER BY pmn02 "
   ELSE
      LET l_wc   = "  AND pmn01 = '",tm.pmm01,"' AND ",
                   "  pmn16  not IN ('6','7','8','9') ",
                   "  ORDER BY pmn02 "
   END IF
   LET l_sql = l_sql clipped,l_wc clipped
#display "l_sql:",l_sql                    #CHI-A70049 mark
 
   PREPARE p551_prepare FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('cannot perpare ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   DECLARE p551_cur CURSOR FOR p551_prepare
   IF SQLCA.sqlcode THEN
      CALL cl_err('cannot declare ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_ac = 1
   LET g_rec_b = 0
 
   FOREACH p551_cur INTO g_pmn[l_ac].*,l_pmn011,l_pmn41,l_pmm18,l_pmmmksg
      IF SQLCA.sqlcode THEN
         CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
     #TQC-740117 remark begin
      #CALL s_pmmsta('pmm',g_pmn[l_ac].pmn16,l_pmm18,l_pmmmksg)
      #     RETURNING g_pmn[l_ac].pmn16
     #TQC-740117 remark end
      LET l_ac = l_ac + 1
 
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pmn.deleteElement(l_ac)
 
   LET g_rec_b = l_ac - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
 
   IF g_rec_b = 0 THEN     #單身無資料
      CALL cl_err(tm.pmm01,'mfg9171',1)
      LET g_success = "N"
      RETURN
   END IF
 
   DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        EXIT DISPLAY
   END DISPLAY
 
END FUNCTION
 
FUNCTION p551_sure()
    DEFINE l_cnt,l_i        LIKE type_file.num5          #No.FUN-680136 SMALLINT
    DEFINE l_ac             LIKE type_file.num5,         #No.FUN-680136 SMALLINT
            l_allow_insert  LIKE type_file.num5,         #可新增否 #No.FUN-680136 SMALLINT
            l_allow_delete  LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    LET l_ac = 1
    INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
              LET g_pmn[l_i].sure="Y"
          END FOR
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       AFTER FIELD sure
          IF NOT cl_null(g_pmn[l_ac].sure) THEN
             IF g_pmn[l_ac].sure NOT MATCHES "[YN]" THEN
                NEXT FIELD sure
             END IF
          END IF
 
       ON ACTION select_all
          FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
              LET g_pmn[l_i].sure="Y"
          END FOR
          LET l_cnt = g_rec_b
          DISPLAY g_rec_b TO FORMONLY.cn3
 
       ON ACTION cancel_all
          FOR l_i = 1 TO g_rec_b      #將所有的設為取消
              LET g_pmn[l_i].sure="N"
          END FOR
          LET l_cnt = 0
          DISPLAY 0 TO FORMONLY.cn3
 
       AFTER ROW
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
       AFTER INPUT
          LET l_cnt = 0
          FOR l_i =1 TO g_rec_b
             IF g_pmn[l_i].sure = 'Y' AND
                NOT cl_null(g_pmn[l_i].pmn02)  THEN
                LET l_cnt = l_cnt + 1
             END IF
          END FOR
          DISPLAY l_cnt TO FORMONLY.cn3
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
    END INPUT
 
END FUNCTION
 
FUNCTION p551_hu()
   DEFINE l_cnt     LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
      LET l_cnt = 0
 
      SELECT COUNT(*) INTO l_cnt FROM  pmn_file
       WHERE pmn01 = tm.pmm01 AND pmn16 NOT IN ('6','7','8','9')
 
      IF l_cnt = 0 THEN    #此筆單頭無尚未結案&結束的單身資料
         UPDATE pmm_file SET pmm25 = '6', pmm27 = g_today
          WHERE pmm01 = tm.pmm01
         IF SQLCA.sqlcode THEN
            LET g_success='N'
#           CALL cl_err('(p551_hu)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("upd","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","(p551_hu)",1)  #No.FUN-660129
            IF g_bgerr THEN
               CALL s_errmsg("pmm01",tm.pmm01,"(p551_hu)",SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","(p551_hu)",1)
            END IF
#No.FUN-710030 -- end --
         END IF
      END IF
 
END FUNCTION
 
FUNCTION p551_sta(l_ac)
   DEFINE l_sta    LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
          l_ac     LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   CASE
      WHEN g_pmn[l_ac].qty = 0 LET  l_sta = '6'
      WHEN g_pmn[l_ac].qty > 0 LET  l_sta = '7'
      WHEN g_pmn[l_ac].qty < 0 LET  l_sta = '8'
      OTHERWISE EXIT CASE
   END CASE
   RETURN l_sta
END FUNCTION
