# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmp553.4gl
# Descriptions...: 採購單取消作業
# Date & Author..: 91/09/27 By Nora 
# Modify ........: 當單身已被全部取消時將單頭之狀態碼更改為取消 (By Jones)
# Modify ........: No.MOD-530695 05/03/28 By Mandy 進入第一個欄位"採購單"中，過濾單據不對，應該是未確認的採購單號
# Modify ........: No.FUN-580124 05/08/24 By Kevin 理由碼傳入arg1參數為2
# Modify.........: No.FUN-610018 06/01/17 By ice 新增攔位:含稅總金額pmm40t
# Modify.........: No.TQC-620097 06/02/21 By pengu  確認執行後錯誤訊息Warning(-217)
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-710030 07/01/19 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.TQC-950119 09/05/19 By chenyu 簽核中及已核准的單子，不可以作廢
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0042 09/11/09 By Smapmin 1.由訂單轉入的採購單不做回寫請購單的動作,需加上pmm909<>'3'的條件.
#                                                      另外,當pmm25='9'時,pmm18要update為'X';pmmacti不可變動;且單身的"目前狀況"欄位要顯示出來
#                                                      update pmm_file 的pmm44/pmm44t時,要同apmt540的作法
#                                                    2.已作廢不顯示出來
# Modify.........: No:FUN-BB0083 11/11/22 By xujing 增加數量欄位小數取位
# Modify.........: No:TQC-C70063 12/07/10 By zhuhao 運行程序時重新檢測單號是否審核 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
        tm RECORD
          pmm01 LIKE pmm_file.pmm01,   #採購單號
          pmm27 LIKE pmm_file.pmm27,   #狀況異動日期
          pmm26 LIKE pmm_file.pmm26    #理由碼
          END RECORD,
        g_pmn DYNAMIC ARRAY OF RECORD
            sure     LIKE type_file.chr1,     # 確定否   #No.FUN-680136 VARCHAR(1)
            pmn02    LIKE pmn_file.pmn02,     # 項次
            pmn04    LIKE pmn_file.pmn04,     # 料號
            pmn011   LIKE pmn_file.pmn011,    # 性質
            #pmn16    LIKE pmn_file.pmn16     # 目前狀況 #No.FUN-680136 CHAR(10)   #MOD-9B0042
            pmn16    LIKE type_file.chr20     # 目前狀況 #No.FUN-680136 CHAR(10)   #MOD-9B0042
        END RECORD,
        g_exit       LIKE type_file.chr1,     #判斷ARRAY 是否太大 #No.FUN-680136 VARCHAR(1)
        l_ac         LIKE type_file.num5,     #No.FUN-680136 SMALLINT
        g_rec_b      LIKE type_file.num5,     #No.FUN-680136 SMALLINT
        l_sl         LIKE type_file.num5,     #No.FUN-680136 SMALLINT 
        p_row,p_col  LIKE type_file.num5,     #No.FUN-680136 SMALLINT
        g_pmn16_d    ARRAY[400] of LIKE pmn_file.pmn16   # 狀況碼
DEFINE  g_error      LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
DEFINE  g_flag       LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
DEFINE  g_cnt        LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE  g_msg        LIKE ze_file.ze03        #No.FUN-680136 VARCHAR(72)
 
MAIN
   DEFINE l_i        LIKE type_file.num5      #No.FUN-680136 SMALLINT
 
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
 
   IF s_shut(0) THEN EXIT PROGRAM END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW p553_w WITH FORM "apm/42f/apmp553" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()

   CALL p553_tm()
   CLOSE WINDOW p553_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p553_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,        #No.FUN-680136 SMALLINT 
         l_i,l_n        LIKE type_file.num5         #No.FUN-680136 SMALLINT 
   DEFINE l_azf09       LIKE azf_file.azf09         #No.FUN-930104
   DEFINE l_pmm18       LIKE pmm_file.pmm18         #No.TQC-C70063

   WHILE TRUE
     CLEAR FORM 
     CALL g_pmn.clear()
     INITIALIZE tm.* TO NULL            # Default condition
     LET tm.pmm27 = TODAY                         # Default 
     ERROR ''
     CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
     INPUT BY NAME tm.pmm01,tm.pmm27,tm.pmm26     WITHOUT DEFAULTS 
        AFTER FIELD pmm01            #採購單號
           IF NOT cl_null(tm.pmm01) THEN
              CALL p553_pmm01()
              IF g_error = 'E' THEN
                 CALL cl_err(tm.pmm01,'mfg1006',0)
                 LET tm.pmm01 = NULL
                 DISPLAY BY NAME tm.pmm01
                 NEXT FIELD pmm01
              END IF
           END IF
   
        AFTER FIELD pmm26  # 理由碼
            IF NOT cl_null(tm.pmm26) THEN
               SELECT COUNT(*) INTO l_n FROM azf_file
                WHERE azf01 = tm.pmm26 AND azf02 = '2'  #6818           
               IF l_n = 0 THEN
                  CALL cl_err('','mfg3088',0)
                  LET tm.pmm26 = NULL 
                  DISPLAY tm.pmm26 TO pmm26
                  NEXT FIELD pmm26
               END IF
                #No.FUN-930104 --begin--
                SELECT azf09 INTO l_azf09 FROM azf_file 
                 WHERE azf01 = tm.pmm26 AND azf02 = '2'    
                 IF l_azf09 !='B' THEN 
                  CALL cl_err('','aoo-410',1)
                  LET tm.pmm26 = NULL 
                  DISPLAY tm.pmm26 TO pmm26
                  NEXT FIELD pmm26                     
                 END IF   
                #No.FUN-930104 --end-- 
            END IF
    
        ON ACTION CONTROLP
           CASE 
              WHEN INFIELD(pmm01) 
             #MOD-530695
            #    CALL q_pmm3(FALSE,TRUE,tm.pmm01,'29') RETURNING tm.pmm01
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmm901"
                 LET g_qryparam.default1 = tm.pmm01
                 CALL cl_create_qry() RETURNING tm.pmm01
                 DISPLAY tm.pmm01 TO pmm01
             #MOD-530695
                 CALL p553_pmm01()
                 NEXT FIELD pmm01
              WHEN INFIELD(pmm26) 
                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_azf"             #No.FUN-930104
                 LET g_qryparam.form = "q_azf01a"           #No.FUN-930104
                 LET g_qryparam.default1 = tm.pmm26
#                 LET g_qryparam.arg1 = "2" #No.FUN-580124  #No.FUN-930104
                 LET g_qryparam.arg1 = "B"                  #No.FUN-930104
                 CALL cl_create_qry() RETURNING tm.pmm26
#                 CALL FGL_DIALOG_SETBUFFER( tm.pmm26 )
###### ---------------------------------------------
                 DISPLAY tm.pmm26 TO pmm26
                 NEXT FIELD pmm26
              OTHERWISE EXIT CASE
           END CASE
    
        ON ACTION mntn_reason
           CALL cl_cmdrun("aooi301")  #6818
    
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
     CALL p553_b_fill()   #ARRAY 的填充
     IF g_success = 'N' THEN 
        CONTINUE WHILE 
     END IF
 
     CALL p553_sure()   #選擇欲取消的採購單單身
     IF INT_FLAG THEN 
        LET INT_FLAG = 0
        CONTINUE WHILE
     END IF
 
     IF cl_sure(0,0) THEN
        CALL cl_wait()
        LET g_success='Y'
       #TQC-C70063 -- add -- begin
        SELECT pmm18 INTO l_pmm18 FROM pmm_file
         WHERE pmm01 = tm.pmm01
        IF l_pmm18 <> 'N' THEN
           CALL cl_err(tm.pmm01,'mfg1006',0)
           LET  g_success='N'
        END IF
       #TQC-C70063 -- add -- end
        BEGIN WORK
        CALL p553_cancel()      #更改欲取消之採購單單身狀況碼
 
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
     END IF 
 
     ERROR ""
   END WHILE
 
END FUNCTION
   
FUNCTION p553_pmm01()
    DEFINE  l_pmm03  LIKE  pmm_file.pmm03,
            l_pmm02  LIKE  pmm_file.pmm02,
            l_pmm09  LIKE  pmm_file.pmm09,
            l_pmm25  LIKE  pmm_file.pmm25,
            l_pmc03  LIKE  pmc_file.pmc03
 
    LET g_error = ' '
    SELECT pmm03,pmm02,pmm09,pmm25 
      INTO l_pmm03,l_pmm02,l_pmm09,l_pmm25 FROM pmm_file 
     #WHERE pmm01 = tm.pmm01 AND pmm25 NOT IN ('2','6','7','8','9') #MOD-530695
      WHERE pmm01 = tm.pmm01 AND pmm18 = 'N'                 #MOD-530695
        AND pmm25 NOT MATCHES '[1S]'                         #No.TQC-950119 add
    IF SQLCA.sqlcode THEN
       LET g_error = 'E'
    ELSE
       SELECT pmc03 INTO l_pmc03 FROM pmc_file
              WHERE pmc01 = l_pmm09
       IF SQLCA.sqlcode THEN
          LET l_pmc03 = NULL 
       END IF
    END IF
    
    DISPLAY l_pmm03 TO pmm03
    DISPLAY l_pmm02 TO pmm02
    DISPLAY l_pmm09 TO pmm09
    DISPLAY l_pmc03 TO FORMONLY.pmc03
END FUNCTION
   
FUNCTION p553_b_fill()
    DEFINE l_sql       LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(300)
           l_pmm18     LIKE pmm_file.pmm18,
           l_pmmmksg   LIKE pmm_file.pmmmksg
 
    #-->交貨量必需為零
    LET l_sql = " SELECT 'N',pmn02,pmn04,pmn011,pmn16,pmm18,pmmmksg",
                " FROM pmn_file,pmm_file ",
                " WHERE pmn01 = '",tm.pmm01,"' AND pmn50 = 0 AND pmm01=pmn01 ",
                " ORDER BY 2"                   
    PREPARE p553_prepare FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN 
    END IF
 
    DECLARE p553_cur CURSOR FOR p553_prepare
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN 
    END IF
 
    LET l_ac = 1
    LET g_rec_b = 0  
    FOREACH p553_cur INTO g_pmn[l_ac].*,l_pmm18,l_pmmmksg
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #-----MOD-9B0042---------
      IF g_pmn[l_ac].pmn16 = '9' THEN
         CONTINUE FOREACH
      END IF 
      #-----END MOD-9B0042-----
      LET g_pmn16_d[l_ac] = g_pmn[l_ac].pmn16
      CALL s_pmmsta('pmm',g_pmn16_d[l_ac],l_pmm18,l_pmmmksg)
           RETURNING g_pmn[l_ac].pmn16
 
      LET l_ac = l_ac + 1
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035,1)
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_pmn.deleteElement(l_ac)
 
    LET g_rec_b= l_ac - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
 
    IF g_rec_b = 0 THEN     #單身無資料
       CALL cl_err(tm.pmm01,'mfg0039',1) 
       LET g_success = 'N'
    END IF
 
    DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
        EXIT DISPLAY 
    END DISPLAY 
 
END FUNCTION
   
FUNCTION p553_sure()
    DEFINE l_cnt,l_i        LIKE type_file.num5          #No.FUN-680136 SMALLINT 
    DEFINE l_ac             LIKE type_file.num5,         #No.FUN-680136 SMALLINT
           l_allow_insert   LIKE type_file.num5,         #可新增否 #No.FUN-680136 SMALLINT
           l_allow_delete   LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE 
 
    LET l_ac = 1
    INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
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
 
FUNCTION p553_cancel()
   DEFINE  l_i,l_n    LIKE type_file.num5,        #No.FUN-680136 SMALLINT
        l_cnt         LIKE type_file.num5,        #No.FUN-680136 SMALLINT
        l_prn,l_prn2  LIKE type_file.num5,        #No.FUN-680136 SMALLINT
        l_pmn20       LIKE pmn_file.pmn20,
        l_pmn24       LIKE pmn_file.pmn24,
        l_pmn25       LIKE pmn_file.pmn25,
        l_pmn41       LIKE pmn_file.pmn41,
        l_pmn31       LIKE pmn_file.pmn31,
        l_pmn31t      LIKE pmn_file.pmn31t,       #No.FUN-610018
        l_pml16       LIKE pml_file.pml16,
        l_pml21       LIKE pml_file.pml21,
        l_sql         LIKE type_file.chr1000,     #No.FUN-680136 VARCHAR(100)
        l_pmm909      LIKE pmm_file.pmm909,   #MOD-9B0042
        l_pmn88       LIKE pmn_file.pmn88,    #MOD-9B0042 
        l_pmn88t      LIKE pmn_file.pmn88t    #MOD-9B0042 
        
   CALL s_showmsg_init()        #No.FUN-710030
   FOR l_i = 1 TO g_rec_b
#No.FUN-710030 -- begin --
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
#No.FUN-710030 -- end --
      IF g_pmn[l_i].sure = 'Y' THEN
         IF g_pmn16_d[l_i] != '2' THEN
            IF g_pmn[l_i].pmn011 = 'SUB' THEN
               SELECT pmn41 INTO l_pmn41 FROM pmn_file 
                WHERE pmn01 = tm.pmm01 AND pmn02 = g_pmn[l_i].pmn02
               IF NOT cl_null(l_pmn41) THEN
                  UPDATE pmn_file SET pmn41 = NULL 
                   WHERE pmn01 = tm.pmm01 AND pmn02 = g_pmn[l_i].pmn02
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err('#1.pmn failure:',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                     CALL cl_err3("upd","pmn_file",tm.pmm01,g_pmn[l_i].pmn02,SQLCA.sqlcode,"","#1.pmn failure:",1)  #No.FUN-660129
#                     LET g_success = 'N'
#                     RETURN
                     LET g_success = 'N'
                     IF g_bgerr THEN
                        LET g_showmsg = tm.pmm01,"/",g_pmn[l_i].pmn02
                        CALL s_errmsg("pmn01,pmn02",g_showmsg,"#1.pmn failure:",SQLCA.sqlcode,1)
                        CONTINUE FOR
                     ELSE
                        CALL cl_err3("upd","pmn_file",tm.pmm01,g_pmn[l_i].pmn02,SQLCA.sqlcode,"","#1.pmn failure:",1)
                        RETURN
                     END IF
#No.FUN-710030 -- end --
                  END IF
               END IF
            END IF
 
  {ckp#1}   UPDATE pmn_file SET pmn16 = '9'
             WHERE pmn01 = tm.pmm01 AND pmn02 = g_pmn[l_i].pmn02
            IF SQLCA.sqlcode THEN 
               LET g_success='N' 
#              CALL cl_err('(p553_cancel:ckp#1)',SQLCA.sqlcode,1)
#No.FUN-710030 -- begin --
#               CALL cl_err3("upd","pmn_file",tm.pmm01,g_pmn[l_i].pmn02,SQLCA.sqlcode,"","(p553_cancel:ckp#1)",1)  #No.FUN-660129
#               RETURN
               IF g_bgerr THEN
                  LET g_showmsg = tm.pmm01,"/",g_pmn[l_i].pmn02
                  CALL s_errmsg("pmn01,pmn02",g_showmsg,"(p553_cancel:ckp#1)",SQLCA.sqlcode,1)
                  CONTINUE FOR
               ELSE
                  CALL cl_err3("upd","pmn_file",tm.pmm01,g_pmn[l_i].pmn02,SQLCA.sqlcode,"","(p553_cancel:ckp#1)",1)
                  RETURN
               END IF
#No.FUN-710030 -- end --
            END IF
            SELECT pmn20,pmn31,pmn31t,pmn24,pmn25,pmn88,pmn88t     #No.FUN-610018   #MOD-9B0042 add pmn88/pmn88t
                  INTO l_pmn20,l_pmn31,l_pmn31t,l_pmn24,l_pmn25,l_pmn88,l_pmn88t FROM pmn_file   #MOD-9B0042 add pmn88/pmn88t
            WHERE pmn01 = tm.pmm01 AND pmn02 = g_pmn[l_i].pmn02
            IF SQLCA.sqlcode THEN 
               LET g_success='N' 
#              CALL cl_err('(p553_cancel:ckp#1_1)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#               CALL cl_err3("sel","pmn_file","tm.pmm01","g_pmn[l_i].pmn02",SQLCA.sqlcode,"","(p553_cancel:ckp#1_1)",1)  #No.FUN-660129
#               RETURN
               IF g_bgerr THEN
                  LET g_showmsg = tm.pmm01,"/",g_pmn[l_i].pmn02
                  CALL s_errmsg("pmn01,pmn02",g_showmsg,"(p553_cancel:ckp#1_1)",SQLCA.sqlcode,1)
                  CONTINUE FOR
               ELSE
                  CALL cl_err3("sel","pmn_file",tm.pmm01,g_pmn[l_i].pmn02,SQLCA.sqlcode,"","(p553_cancel:ckp#1_1)",1)
                  RETURN
               END IF
#No.FUN-710030 -- end --
            END IF
            #-----MOD-9B0042---------
            #UPDATE pmm_file SET pmm40 =pmm40 -( l_pmn20 * l_pmn31),
            #                    pmm40t=pmm40t-( l_pmn20 * l_pmn31t)   #No.FUN-610018  #No:TQC-620097 modify l_pmm20 to l_pmn20
            UPDATE pmm_file SET pmm40 =pmm40 - l_pmn88,
                                pmm40t=pmm40t- l_pmn88t   #No.FUN-610018  #No:TQC-620097 modify l_pmm20 to l_pmn20
            #-----END MOD-9B0042-----
              WHERE pmm01 = tm.pmm01
            IF SQLCA.sqlcode THEN 
               LET g_success='N' 
#              CALL cl_err('(p553_cancel:ckp#1_1)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#               CALL cl_err3("upd","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","(p553_cancel:ckp#1_1)",1)  #No.FUN-660129
#               RETURN
               IF g_bgerr THEN
                  CALL s_errmsg("pmm01",tm.pmm01,"(p553_cancel:ckp#1_1)",SQLCA.sqlcode,1)
                  CONTINUE FOR
               ELSE
                  CALL cl_err3("upd","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","(p553_cancel:ckp#1_1)",1)
                  RETURN
               END IF
#No.FUN-710030 -- end --
            END IF
            #採購單身取消時,將請購單之請購轉採購量扣回
            #-----MOD-9B0042---------
            LET l_pmm909 = ''
            SELECT pmm909 INTO l_pmm909 FROM pmm_file
              WHERE pmm01 = tm.pmm01
            #IF NOT cl_null(l_pmn24) THEN   
            IF NOT cl_null(l_pmn24) AND l_pmm909 <> '3' THEN   
            #-----END MOD-9B0042-----
               CALL p553_pml(l_pmn24,l_pmn25)
               IF g_success='N' THEN 
                  CALL cl_err('Update pml21 fail:',SQLCA.sqlcode,1)
                  RETURN
               END IF
               LET l_sql = "pml01='",l_pmn24,"' AND pml02=",l_pmn25
               CALL s_qtychk('pml_file','pml21',l_sql)
               #如果已轉採購量為零,將'已轉採購'改為'已核准'
               SELECT pml21,pml16 INTO l_pml21,l_pml16 FROM pml_file
                WHERE pml01 = l_pmn24 AND pml02 =l_pmn25
               IF l_pml21 = 0 AND l_pml16 = '2' THEN
                  UPDATE pml_file SET pml16 = '1'                
                   WHERE pml01 = l_pmn24 AND pml02 =l_pmn25
                  IF SQLCA.sqlcode THEN 
                     LET g_success='N' 
#                    CALL cl_err('Update pml16 fail:',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                     CALL cl_err3("upd","pml_file",l_pmn24,l_pmn25,SQLCA.sqlcode,"","Update pml16 fail:",1)  #No.FUN-660129
#                     RETURN
                     IF g_bgerr THEN
                        LET g_showmsg = l_pmn24,"/",l_pmn25
                        CALL s_errmsg("pml01,pml02",g_showmsg,"Update pml16 fail:",SQLCA.sqlcode,1)
                        CONTINUE FOR
                     ELSE
                        CALL cl_err3("upd","pml_file",l_pmn24,l_pmn25,SQLCA.sqlcode,"","Update pml16 fail:",1)
                        RETURN
                     END IF
#No.FUN-710030 -- end --
                  END IF
               END IF
                IF l_pml21 >0 AND  l_pml16 >='2' THEN
                  UPDATE pml_file SET pml16 = '2'                
                         WHERE pml01 = l_pmn24 AND pml02 =l_pmn25
                  IF SQLCA.sqlcode THEN 
                     LET g_success='N' 
#                    CALL cl_err('Update pml16 fail:',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                     CALL cl_err3("upd","pml_file",l_pmn24,l_pmn25,SQLCA.sqlcode,"","Update pml16 fail:",1)  #No.FUN-660129
#                     RETURN
                     IF g_bgerr THEN
                        LET g_showmsg = l_pmn24,"/",l_pmn25
                        CALL s_errmsg("pml01,pml02",g_showmsg,"Update pml16 fail:",SQLCA.sqlcode,1)
                        CONTINUE FOR
                     ELSE
                        CALL cl_err3("upd","pml_file",l_pmn24,l_pmn25,SQLCA.sqlcode,"","Update pml16 fail:",1)
                        RETURN
                     END IF
#No.FUN-710030 -- end --
                  END IF
               END IF
            END IF
         END IF
      END IF
   END FOR
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
      RETURN
   END IF
#No.FUN-710030 -- end --
 
    #--->P/R head 
     SELECT COUNT(*) INTO l_prn FROM pml_file 
      WHERE pml01 = l_pmn24 AND pml16 = '2'    
     IF l_prn  > 0 THEN 
        UPDATE pmk_file SET pmk25 = '2'                
         WHERE pmk01 = l_pmn24 
        IF SQLCA.sqlcode THEN 
           LET g_success='N' 
#          CALL cl_err('ckp#1  pmk25 fail:',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#           CALL cl_err3("upd","pmk_file",l_pmn24,"",SQLCA.sqlcode,"","ckp#1  pmk25 fail:",1)  #No.FUN-660129
           IF g_bgerr THEN
              CALL s_errmsg("pmk01",l_pmn24,"ckp#1  pmk25 fail:",SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("upd","pmk_file",l_pmn24,"",SQLCA.sqlcode,"","ckp#1  pmk25 fail:",1)
           END IF
#No.FUN-710030 -- end --
           RETURN
        END IF
     ELSE 
          SELECT COUNT(*) INTO l_prn2 FROM pml_file 
                    WHERE pml01 = l_pmn24 AND pml16 != '1'    
          IF l_prn2 = 0 THEN 
             UPDATE pmk_file SET pmk25 = '2'                
                           WHERE pmk01 = l_pmn24 
                 IF SQLCA.sqlcode THEN 
                     LET g_success='N' 
#                    CALL cl_err('ckp#2  pmk25 fail:',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                     CALL cl_err3("upd","pmk_file",l_pmn24,"",SQLCA.sqlcode,"","ckp#2  pmk25 fail:",1)  #No.FUN-660129
                     IF g_bgerr THEN
                        CALL s_errmsg("pmk01",l_pmn24,"ckp#2  pmk25 fail:",SQLCA.sqlcode,1)
                     ELSE
                        CALL cl_err3("upd","pmk_file",l_pmn24,"",SQLCA.sqlcode,"","ckp#2  pmk25 fail:",1)
                     END IF
#No.FUN-710030 -- end --
                     RETURN
                END IF
         END IF
     END IF
     SELECT COUNT(*) INTO l_n FROM pmn_file
           WHERE pmn01 = tm.pmm01 AND pmn16 != '9' 
    IF l_n = 0 THEN   # 若單身的項次全部被取消時更新單頭的狀態碼為取消
{ckp#2}  UPDATE pmm_file SET (pmm25,pmm18,pmm26,pmm27,pmmmodu,pmmdate)   #MOD-9B0042 add pmm18/del pmmacti
                         = ('9','X',tm.pmm26,tm.pmm27,g_user,TODAY)   #MOD-9B0042 add pmm18/del pmmacti
              WHERE pmm01 = tm.pmm01
           IF SQLCA.sqlcode THEN 
               LET g_success='N' 
#              CALL cl_err('(p553_cancel:ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#               CALL cl_err3("upd","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","(p553_cancel:ckp#2)",1)  #No.FUN-660129
               IF g_bgerr THEN
                  CALL s_errmsg("pmm01",tm.pmm01,"(p553_cancel:ckp#2)",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","(p553_cancel:ckp#2)",1)
               END IF
#No.FUN-710030 -- end --
               RETURN
           END IF
    END IF
END FUNCTION
 
#update 請購單身之已轉採購數量及狀況碼
FUNCTION  p553_pml(p_pmn24,p_pmn25)  
  DEFINE p_pmn24   LIKE pmn_file.pmn24
  DEFINE p_pmn25   LIKE pmn_file.pmn25
  DEFINE l_sum     LIKE pml_file.pml21
  DEFINE l_pml07   LIKE pml_file.pml07         #FUN-BB0083 add
 
      LET l_sum=0
      #          數量/替代率*對請購換算率
      SELECT SUM(pmn20/pmn62*pmn121) INTO l_sum FROM pmn_file
       WHERE pmn24=p_pmn24 AND pmn25=p_pmn25
         AND pmn16<>'9'    #取消(Cancel)
#     UPDATE pml_file SET pml16='2',pml21=l_sum
      SELECT pml07 INTO l_pml07 FROM pml_file     #FUN-BB0083 add
       WHERE pml01=p_pmn24 AND pml02=p_pmn25      #FUN-BB0083 add
       LET l_sum = s_digqty(l_sum,l_pml07)        #FUN-BB0083 add
      UPDATE pml_file SET pml21=l_sum
       WHERE pml01=p_pmn24 AND pml02=p_pmn25
      IF SQLCA.sqlcode THEN
         LET g_success='N'
#        CALL cl_err('upd pml',SQLCA.sqlcode,1)   #No.FUN-660129
         CALL cl_err3("upd","pml_file",p_pmn24,p_pmn25,SQLCA.sqlcode,"","upd pml",1)  #No.FUN-660129
         RETURN
      END IF
END FUNCTION
