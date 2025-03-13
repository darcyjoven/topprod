# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: apmp456.4gl
# Descriptions...: 採購單整批結案作業
# Date & Author..: 93/05/21 By Felicity  Tseng
# Modify ........: No:8778 04/08/16 By Wiky 建議改成update單頭pmmuser/pmmmodu..
# Modify.........: No.FUN-570138 06/03/09 By yiting 批次背景執行
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-710030 07/01/17 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-840239 08/06/19 By xiaofeizhu 采購單號加入開窗
# Modify.........: NO.FUN-850052 08/05/09 By yiting 加入篩選條件「收入入庫量+驗退量>=採購量」
# Modify.........: No.TQC-930141 09/03/24 By chenyu 如果在收貨單中有未審核的采購單則不能結案
# Modify.........: No.MOD-940288 09/04/22 By Dido 增加條件針對未結案的採購單
# Modify.........: No.MOD-950171 09/05/27 By Smapmin 加入資料權限的檢查
# Modify.........: No.MOD-980211 09/08/26 By Dido 控管比照 apmp551
# Modify.........: No.TQC-980281 09/08/28 By lilingyu 已經結案的采購單應該給出提示訊息,而不應該繼續運行
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:MOD-A20023 10/02/03 By Dido 應排除多角單據 
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B50246 11/06/15 By Summer 還原MOD-A20023,要是多角且已拋轉的單據才可執行
# Modify.........: No:MOD-B60141 11/06/16 By JoHung p456_chk()的sql條件加上排除已結案單據
#                                                   mark 已結案採購單提示訊息而不繼續運行的判斷
# Modify.........: No:MOD-B60212 11/06/24 By JoHung p456_chk()的sql條件加上排除狀況碼為開立、核准、取消
#                                                   mark mfg3208/mfg3210的控卡
# Modify.........: No:MOD-C10049 12/01/06 By Elise 加入外部參數g_flag
# Modify.........: No:MOD-D10065 13/02/22 By Elise (1) 確認單身有未結案資料時，顯示錯誤訊息【單身仍有未結案的資料！】
#                                                  (2) 原 mfg3270 mark
# Modify.........: No:CHI-D10026 13/02/22 By Elise 整批結案輸入多張單時，若其中有單身未全部入庫的不可結案，其他可結案
# Modify.........: No:MOD-D60022 13/06/04 By SunLM 采購單有對應采購變更單，變更單未審核，未發出，采購單不可以結案
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
            wc        LIKE type_file.chr1000    #No.FUN-680136 VARCHAR(100)
          END RECORD 
DEFINE g_pmm01        LIKE pmm_file.pmm01
DEFINE g_pmm04        LIKE pmm_file.pmm04
DEFINE g_pmm12        LIKE pmm_file.pmm12
DEFINE g_pmm25        LIKE pmm_file.pmm25       #MOD-980211
DEFINE p_row,p_col    LIKE type_file.num5       #No.FUN-680136 SMALLINT
DEFINE g_flag         LIKE type_file.chr1       #No.FUN-680136 VARCHAR(1)
DEFINE l_flag         LIKE type_file.chr1,      #No.FUN-570138 #No.FUN-680136 VARCHAR(1)
       g_change_lang  LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
       ls_date        STRING                    #No.FUN-570138 #MOD-D10065 remove ,
#      g_chkno        LIKE pmm_file.pmm01       #MOD-980211    #MOD-D10065 mark
DEFINE g_pmm02        LIKE pmm_file.pmm02       #CHI-D10026 add
DEFINE g_pmm09        LIKE pmm_file.pmm09       #CHI-D10026 add
DEFINE g_pmm18        LIKE pmm_file.pmm18       #CHI-D10026 add
DEFINE g_pmmuser      LIKE pmm_file.pmmuser     #CHI-D10026 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc     = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)
   LET g_flag = ARG_VAL(3)     #MOD-C10049 add
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818
 
   WHILE TRUE
      IF g_bgjob= "N" THEN
         CALL p456_cs()
         IF cl_sure(18,20) THEN
           #BEGIN WORK       #CHI-D10026 mark
            LET g_success = 'Y'
            CALL p456_chk()
            CALL s_showmsg()       #No.FUN-710030
            IF g_success = 'Y' THEN
              #COMMIT WORK   #CHI-D10026 mark
               CALL cl_end2(1) RETURNING l_flag
            ELSE
              #ROLLBACK WORK #CHI-D10026 mark
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p456_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p456_w
      ELSE
        #BEGIN WORK       #CHI-D10026 mark
         LET g_success = 'Y'
         CALL p456_chk()
         CALL s_showmsg()       #No.FUN-710030
         IF g_success = "Y" THEN
           #COMMIT WORK   #CHI-D10026 mark
         ELSE
           #ROLLBACK WORK #CHI-D10026 mark
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION p456_cs()
   DEFINE lc_cmd        LIKE type_file.chr1000    #No.FUN-680136 VARCHAR(500)
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW p456_w AT p_row,p_col WITH FORM "apm/42f/apmp456"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
 WHILE TRUE
 
   INITIALIZE tm.wc TO NULL
   CONSTRUCT BY NAME tm.wc ON pmm01, pmm04, pmm12 
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON ACTION CONTROLP                                                                                                            
           CASE                                                                                                                     
              WHEN INFIELD(pmm01)                                                                                                   
                   CALL cl_init_qry_var()                                                                                           
                   LET g_qryparam.form = "q_pmm02"                                                                                  
                   LET g_qryparam.state = 'c'                                                                                       
                   LET g_qryparam.where = " pmm25 <> '0' AND pmm25 <> '1' AND pmm25 <> '9' "    #MOD-B60212 add
                   CALL cl_create_qry() RETURNING g_qryparam.multiret                                                               
                   DISPLAY g_qryparam.multiret TO pmm01                                                                             
                   NEXT FIELD pmm01
              OTHERWISE EXIT CASE                                                                                                   
           END CASE
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG CALL cl_cmdask()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
     
     ON ACTION locale                    #genero
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
     
     ON ACTION exit              #加離開功能genero
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END CONSTRUCT
 
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p454_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
    LET g_bgjob = "N"          #->No.FUN-570138
    LET g_flag = 'N'           #no.FUN-850052
   #LET g_chkno = NULL         #MOD-980211 #MOD-D10065 mark
 
    INPUT BY NAME g_flag,g_bgjob WITHOUT DEFAULTS   #NO.FUN-850052
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         #BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION locale                    #genero
         LET g_change_lang = TRUE
         EXIT INPUT
 
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
 
   END INPUT
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p456_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "apmp456"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('apmp456','9031',1)   #No.FUN-660129
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")    #"
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.wc CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('apmp456',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p456_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
   EXIT WHILE
 END WHILE
 
END FUNCTION
 
FUNCTION p456_chk()  
   DEFINE 
      l_sql      LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(300)
      sr         RECORD LIKE pmn_file.*,
      l_name     LIKE type_file.chr20,     #No.FUN-680136 VARCHAR(20)
      l_correct  LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
      l_do       LIKE type_file.chr1       #No.FUN-680136 VARCHAR(1)
DEFINE l_update  LIKE type_file.chr1       #no.FUN-850052
DEFINE l_pmn16   LIKE pmn_file.pmn16       #NO.FUN-850052
DEFINE l_cnt     LIKE type_file.num5       #No.TQC-930141 add
DEFINE l_qty     LIKE pmn_file.pmn50       #MOD-980211   
#CHI-D10026---add---S
DEFINE l_pmm     DYNAMIC ARRAY OF RECORD
         pmm01    LIKE pmm_file.pmm01,
         pmm04    LIKE pmm_file.pmm04,
         pmm12    LIKE pmm_file.pmm12,
         pmm02    LIKE pmm_file.pmm02,
         pmm09    LIKE pmm_file.pmm09,
         pmm18    LIKE pmm_file.pmm18,
         pmm25    LIKE pmm_file.pmm25,
         pmmuser  LIKE pmm_file.pmmuser
       END RECORD
DEFINE   i        LIKE type_file.num5,
         l_cnt2   LIKE type_file.num5
#CHI-D10026---add---E
 
  #LET l_sql ="SELECT pmm01,pmm04,pmm12,pmm25 FROM pmm_file ",	#MOD-980211               #CHI-D10026 mark 
   LET l_sql ="SELECT pmm01,pmm04,pmm12,pmm02,pmm09,pmm18,pmm25,pmmuser FROM pmm_file ",  #CHI-D10026
             #" WHERE pmm02 !='SUB' AND pmm18 !='X' AND ",tm.wc CLIPPED      #TQC-980281                   #MOD-A20023 mark 
             #" WHERE pmm02 NOT IN ('SUB','TRI','TAP') AND pmm18 !='X' AND ",tm.wc CLIPPED  #TQC-980281    #MOD-A20023 #MOD-B50246 mark
#             " WHERE pmm02 !='SUB' AND pmm905 !='Y' AND pmm18 !='X' AND ",tm.wc CLIPPED  #MOD-B50246 add  #MOD-B60141 mark
#             " WHERE pmm02 !='SUB' AND pmm905 !='Y' AND pmm18 !='X' AND pmm25 != '6' AND ",tm.wc CLIPPED  #MOD-B60141 #MOD-B60212 mark
              " WHERE pmm02 !='SUB' AND pmm905 !='Y' AND pmm18 !='X' AND pmm25 != '6' AND ",               #MOD-B60212
              " pmm25 != '0' AND pmm25 != '1' AND pmm25 != '9' AND ",                                      #MOD-B60212 add
              tm.wc CLIPPED                                                                                #MOD-B60212
   PREPARE p456_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p456_p1 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
   DECLARE p456_c1 CURSOR FOR p456_p1 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('declare p456_c1 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
 
   LET l_sql = "SELECT * FROM pmn_file ",
              "  WHERE pmn01 = ? " 
   PREPARE p456_p2 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare p456_p2 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
 
   DECLARE p456_c2 CURSOR FOR p456_p2 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('declare p456_c2 error :',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
 
   LET g_success = 'Y'
   CALL s_showmsg_init()        #No.FUN-710030
  #FOREACH p456_c1 INTO g_pmm01, g_pmm04, g_pmm12, g_pmm25     #FOREACH 單頭	#MOD-980211 #CHI-D10026 mark
  #CHI-D10026---add---S
  #調整Transaction架構
  #將FOREACH 單頭的部份搬出來放到陣列後,單身在FOR迴圈處理
   LET l_cnt2 = 1
   FOREACH p456_c1 INTO l_pmm[l_cnt2].*
       IF SQLCA.sqlcode THEN
          IF g_bgerr THEN
             CALL s_errmsg("","","",SQLCA.sqlcode,1)
          ELSE
             CALL cl_err('',SQLCA.sqlcode,1)
          END IF
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       LET l_cnt2 = l_cnt2 + 1
   END FOREACH
   CALL l_pmm.deleteelement(l_cnt2)
   LET l_cnt2 = l_cnt2 - 1
  #CHI-D10026---add---E
  #CHI-D10026---move---S
  #   IF SQLCA.sqlcode THEN 
  #      IF g_bgerr THEN
  #         CALL s_errmsg("","","",SQLCA.sqlcode,1)
  #      ELSE
  #         CALL cl_err('',SQLCA.sqlcode,1)
  #      END IF
  #      LET g_success = 'N'
  #      EXIT FOREACH
  #   END IF
  #CHI-D10026---move---E

   IF l_cnt2 > 0 THEN                  #CHI-D10026 add
      FOR i = 1 TO l_cnt2              #CHI-D10026 add
         BEGIN WORK                    #CHI-D10026 add
         IF g_success="N" THEN
            LET g_totsuccess="N"
            LET g_success="Y"
         END IF
        #CHI-D10026---add---S
         LET g_pmm01   = l_pmm[i].pmm01
         LET g_pmm04   = l_pmm[i].pmm04
         LET g_pmm12   = l_pmm[i].pmm12
         LET g_pmm02   = l_pmm[i].pmm02
         LET g_pmm09   = l_pmm[i].pmm09
         LET g_pmm18   = l_pmm[i].pmm18
         LET g_pmm25   = l_pmm[i].pmm25
         LET g_pmmuser = l_pmm[i].pmmuser
        #CHI-D10026---add---E
#MOD-D60022 add begin------
        LET l_cnt=0
        SELECT COUNT(*) INTO l_cnt FROM pna_file 
         WHERE pna01= g_pmm01
           AND (pna05='N' OR (pna05='Y' AND pnaconf='N' ))
        IF l_cnt > 0 THEN 
           LET g_success = 'N'
           CALL s_errmsg('pmm01',g_pmm01,'','apm-454',1)
        END IF     
#MOD-D60022 add end--------
#MOD-B60212 -- begin -- 
#     IF g_pmm25 MATCHES '[01]' THEN
#         LET g_success = 'N'   
#         CALL s_errmsg('pmm01',g_pmm01,'','mfg3208',1)
#         CONTINUE FOREACH
#     END IF
#     IF g_pmm25 = '9' THEN
#         LET g_success = 'N'   
#         CALL s_errmsg('pmm01',g_pmm01,'','mfg3210',1)
#         CONTINUE FOREACH
#     END IF
#MOD-B60212 -- end --
#MOD-B60141 -- begin --
#     IF g_pmm25 = '6' THEN
#        LET g_success = 'N'
#         CALL s_errmsg('pmm01',g_pmm01,'','apm-049',1)
#         CONTINUE FOREACH         
#     END IF 
#MOD-B60141 -- end --
         FOREACH p456_c2 USING g_pmm01 INTO sr.*                  #FOREACH 單身
           IF SQLCA.sqlcode THEN 
              IF g_bgerr THEN
                 CALL s_errmsg("","","",SQLCA.sqlcode,1)
              ELSE
                 CALL cl_err3("","","","",SQLCA.SQLCODE,"","foreach cursor",1)
              END IF
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           IF g_flag = 'Y' THEN  #只選入庫>=採購量
               IF sr.pmn53 < sr.pmn20 THEN
                   CONTINUE FOREACH
               END IF
           END IF
           LET l_cnt = 0 
           SELECT COUNT(*) INTO l_cnt FROM pmn_file
            WHERE pmn01 = g_pmm01 AND pmn51 <= 0
           IF l_cnt = 0 THEN
               LET g_success = 'N'   
               CALL s_errmsg('pmm01',g_pmm01,'','mfg9171',1)
               CONTINUE FOREACH
           END IF
           LET l_cnt = 0 				#MOD-980211 
           SELECT COUNT(*) INTO l_cnt FROM rva_file,rvb_file
            WHERE rva01 = rvb01
              AND rvaconf = 'N'
              AND rvb03 = sr.pmn02
              AND rvb04 = sr.pmn01
           IF l_cnt > 0 THEN
              CONTINUE FOREACH
           END IF 
           LET l_qty = sr.pmn50 - sr.pmn20 - sr.pmn55	#MOD-980211
           CASE                    
              #正常
              WHEN sr.pmn20 = sr.pmn50 - sr.pmn55
                 UPDATE pmn_file SET pmn16 = '6',pmn57 = l_qty
                  WHERE pmn01 = sr.pmn01 AND pmn02 = sr.pmn02 
                 IF SQLCA.SQLCODE THEN
                    IF g_bgerr THEN
                       LET g_showmsg = sr.pmn01,"/",sr.pmn02
                       CALL s_errmsg("pmn01,pmn02",g_showmsg,"",SQLCA.sqlcode,1)
                    ELSE
                       CALL cl_err3("upd","pmn_file",sr.pmn01,sr.pmn02,SQLCA.sqlcode,"","",1)
                    END IF
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
                 IF SQLCA.SQLERRD[3] = 0 THEN
                    IF g_bgerr THEN
                       CALL s_errmsg("","","","apm-204",1)
                    ELSE
                       CALL cl_err('','apm-204',1)
                    END IF
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
              #結長
              WHEN sr.pmn20 < sr.pmn50 - sr.pmn55
                 UPDATE pmn_file SET pmn16 = '7',pmn57 = l_qty
                  WHERE pmn01 = sr.pmn01 AND pmn02 = sr.pmn02 
                 IF SQLCA.SQLCODE THEN
                    IF g_bgerr THEN
                       LET g_showmsg = sr.pmn01,"/",sr.pmn02
                       CALL s_errmsg("pmn01,pmn02",g_showmsg,"",SQLCA.sqlcode,1)
                    ELSE
                       CALL cl_err3("upd","pmn_file",sr.pmn01,sr.pmn02,SQLCA.sqlcode,"","",1)
                    END IF
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
                 IF SQLCA.SQLERRD[3] = 0 THEN
                    IF g_bgerr THEN
                       CALL s_errmsg("","","","apm-204",1)
                    ELSE
                       CALL cl_err3("","","","","apm-204","","",1)
                    END IF
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
              OTHERWISE
                 UPDATE pmn_file SET pmn16 = '8',pmn57 = l_qty
                  WHERE pmn01 = sr.pmn01 AND pmn02 = sr.pmn02 
                 IF SQLCA.SQLCODE THEN
                    IF g_bgerr THEN
                       LET g_showmsg = sr.pmn01,"/",sr.pmn02
                       CALL s_errmsg("pmn01,pmn02",g_showmsg,"",SQLCA.sqlcode,1)
                    ELSE
                       CALL cl_err3("upd","pmn_file",sr.pmn01,sr.pmn02,SQLCA.sqlcode,"","",1)
                    END IF
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
                 IF SQLCA.SQLERRD[3] = 0 THEN
                    IF g_bgerr THEN
                       CALL s_errmsg("","","","apm-204",1)
                    ELSE
                       CALL cl_err3("","","","","apm-204","","",1)
                    END IF
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
           END CASE
         END FOREACH
         IF g_bgjob = 'N' THEN  #NO.FUN-570138 
             DISPLAY g_pmm01, g_pmm04, g_pmm12 TO a, b, c 
         END IF
# 單身項次全部結案才能更改單頭結案碼
         LET l_sql = "SELECT pmn16 FROM pmn_file ",
                    "  WHERE pmn01 = '",g_pmm01,"' " 
 
         PREPARE p456_pmn16_p FROM l_sql
         IF SQLCA.SQLCODE THEN
            CALL cl_err('prepare p456_pmn16_p error :',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
         DECLARE p456_pmn16_c CURSOR FOR p456_pmn16_p 
         IF SQLCA.SQLCODE THEN
            CALL cl_err('declare p456_pmn16_c error :',SQLCA.SQLCODE,1)
            LET g_success = 'N'
         END IF
         LET l_update = 'Y'
         FOREACH p456_pmn16_c INTO l_pmn16
             IF (l_pmn16 <> '6' AND l_pmn16 <> '7' AND l_pmn16 <> '8') THEN
                 LET l_update = 'N' 
                #MOD-D10065 add start -----
                 LET g_success = 'N'
                 IF g_bgerr THEN
                    CALL s_errmsg("pmm01",g_pmm01,"","apm1090",1)
                    EXIT FOREACH
                 ELSE
                    CALL cl_err3("upd","pmm_file",g_pmm01,"","apm1090","","",1)
                    EXIT FOREACH
                 END IF
                #MOD-D10065 add end   -----
             END IF
         END FOREACH

         IF l_update = 'Y' THEN
             UPDATE pmm_file SET pmm25 = '6',pmmmodu=g_user,pmmdate=g_today  #No.8778
              WHERE pmm01 = g_pmm01
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                LET g_success = 'N'
                IF g_bgerr THEN
                   CALL s_errmsg("pmm01",g_pmm01,"",SQLCA.sqlcode,1)
                  #CONTINUE FOREACH  #CHI-D10026 mark
                ELSE
                   CALL cl_err3("upd","pmm_file",g_pmm01,"",SQLCA.sqlcode,"","",1)
                  #EXIT FOREACH      #CHI-D10026 mark
                END IF
             END IF
            #MOD-D10065 mark start -----
            #IF g_chkno IS NULL THEN
            #   LET g_chkno = g_pmm01
            #END IF
            #MOD-D10065 mark end   -----
         END IF             #no.FUN-850052 add

        #CHI-D10026---add---S 
         IF g_success='Y' THEN 
            COMMIT WORK 
         ELSE         
            ROLLBACK WORK  
         END IF       
        #CHI-D10026---add---E

      END FOR       #CHI-D10026 add
   END IF           #CHI-D10026 add
  #END FOREACH      #CHI-D10026 mark
  #MOD-D10065 mark start -----
  #IF cl_null(g_chkno) THEN
  #   LET g_success = 'N'   
  #   CALL s_errmsg('pmm01',g_chkno,'','mfg3207',1)
  #END IF
  #MOD-D10065 mark end   -----

   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
END FUNCTION       
#No:FUN-9C0071--------精簡程式-----
