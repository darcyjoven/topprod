# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: apmp560.4gl
# Descriptions...: 委外製程採購單結案作業
# Date & Author..: 99/11/08 By plum
# MODIFY.........: NO.MOD-580136 By Rosayu 05/08/17 mfg3209錯誤訊息改成mfg3219
# Modify.........: No.MOD-660029 06/06/12 By Pengu 修改超短交量的計算，應該為pmn57=pmn50-pmn20-pmn55
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-710030 07/01/19 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A60011 10/06/07 By Carrier ecm321更新时,要检查是否对ecm52做更新
# Modify.........: No:TQC-C70154 12/07/23 By zhuhao s_update_ecm52傳參錯誤
# Modify.........: No:MOD-C70229 12/07/25 By Vampire 條件增加製程序號,ecm03=pmn43的條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   tm RECORD
      pmm01    LIKE pmm_file.pmm01,     #請購單號
      pmm09    LIKE pmm_file.pmm09,     #廠商編號
      y        LIKE type_file.chr1      #已結案資料是否顯示 #No.FUN-680136 VARCHAR(1)
   END RECORD,
   g_pmn    DYNAMIC ARRAY OF RECORD
      sure     LIKE type_file.chr1,     # 確定否     #No.FUN-680136 VARCHAR(1)
      pmn02    LIKE pmn_file.pmn02,     # 項次
      pmn04    LIKE pmn_file.pmn04,     # 料號
      pmn432   LIKE ecm_file.ecm04,     # 作業編號   
      pmn16    LIKE pmn_file.pmn16,     # 目前狀況   #No.FUN-680136 VARCHAR(15)
      qty      LIKE pmn_file.pmn20      # 未移轉數量 #No.FUN-680136 DEC(13,3)
            END RECORD,
    g_cmd      LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(60)
    g_rec_b    LIKE type_file.num5,     #No.FUN-680136 SMALLINT
    g_flag     LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
    l_ac,l_sl  LIKE type_file.num5      #No.FUN-680136 SMALLINT 
DEFINE g_cnt   LIKE type_file.num10     #No.FUN-680136 INTEGER
DEFINE l_pmn43 LIKE pmn_file.pmn43      #MOD-C70229 add
 
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
 
   CALL p560_tm()
   CLOSE WINDOW p560_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p560_tm()
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680136 SMALLINT
          l_pmm18       LIKE pmm_file.pmm18,
          l_pmmmksg     LIKE pmm_file.pmmmksg,
          l_pmn09       LIKE pmn_file.pmn09,
          l_pmn20       LIKE pmn_file.pmn20,
          l_pmn50       LIKE pmn_file.pmn20,
          l_pmn46       LIKE pmn_file.pmn46,
          l_pmn011      LIKE pmn_file.pmn011,
          l_pmn41       LIKE pmn_file.pmn41,
          l_pmn55       LIKE pmn_file.pmn55,
          l_short       LIKE pmn_file.pmn50,
          l_no          LIKE type_file.num5,          #No.FUN-680136 SMALLINT 
          g_sta         LIKE type_file.chr1           #No.FUN-680136  VARCHAR(1)
   DEFINE l_flag        LIKE type_file.num5     #No.FUN-A60011
   DEFINE l_pmn012      LIKE pmn_file.pmn012    #No.FUN-A60011
 
   LET p_row = 3 LET p_col = 4
 
   OPEN WINDOW p560_w AT p_row,p_col WITH FORM "apm/42f/apmp560" 
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
 
         AFTER FIELD pmm01            #請購單號
            IF NOT cl_null(tm.pmm01) THEN
               CALL p560_pmm01()
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
                  CALL q_pmm2(FALSE,TRUE,tm.pmm01,'2') RETURNING tm.pmm01
#                  CALL FGL_DIALOG_SETBUFFER( tm.pmm01 )
                  DISPLAY tm.pmm01 TO pmm01 
                  CALL p560_pmm01()
                  NEXT FIELD pmm01
               OTHERWISE EXIT CASE
            END CASE
 
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
      CALL p560_b_fill()
      IF g_success = 'N' THEN 
         CONTINUE WHILE 
      END IF 
 
      CALL p560_sure()
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CONTINUE WHILE
      END IF
 
      IF NOT cl_sure(0,0) THEN
         CONTINUE WHILE
      END IF
 
      LET g_success='Y'
      BEGIN WORK
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
            CALL p560_sta(l_no) RETURNING g_sta
            {ckp#2}
            UPDATE pmn_file SET pmn16 = g_sta,
                                pmn57 = g_pmn[l_no].qty
               WHERE pmn01 = tm.pmm01 AND pmn02 = g_pmn[l_no].pmn02
            IF SQLCA.sqlcode THEN
               LET g_success='N'
#No.FUN-710030 -- begin --
#               CALL cl_err('(p560:ckp#2)',SQLCA.sqlcode,1)
#                RETURN
               IF g_bgerr THEN
                  LET g_showmsg = tm.pmm01,"/",g_pmn[l_no].pmn02
                  CALL s_errmsg("pmn01,pmn02",g_showmsg,"(p560:ckp#2)",SQLCA.sqlcode,1)
                  CONTINUE FOR
               ELSE
                  CALL cl_err3("upd","pmn_file",tm.pmm01,g_pmn[l_no].pmn02,SQLCA.sqlcode,"","(p560:ckp#2)",1)
                  EXIT FOR
               END IF
#No.FUN-710030 -- end --
             END IF
             SELECT pmn20,pmn50,pmn46,pmn55,pmn09,pmn011,pmn41,pmn012,pmn43                 #No.FUN-A60011 #MOD-C70229 add pmn43
             INTO l_pmn20,l_pmn50,l_pmn46,l_pmn55,l_pmn09,l_pmn011,l_pmn41,l_pmn012,l_pmn43 #No.FUN-A60011 #MOD-C70229 add l_pmn43
             FROM pmn_file
             WHERE pmn01 = tm.pmm01 AND pmn02 = g_pmn[l_no].pmn02
             IF SQLCA.sqlcode THEN
                LET l_pmn09 = 1    LET l_pmn20 = 0
                LET l_pmn50 = 0    LET l_pmn46 = 0
                LET l_pmn55 = 0
             END IF
             IF l_pmn20-l_pmn50+l_pmn55 >0 THEN     #No.MOD-660029 modify
                UPDATE ecm_file set ecm321=ecm321-(l_pmn20-l_pmn50+l_pmn55)   #No.MOD-660029 modify
                 WHERE ecm01=l_pmn41 AND ecm04=g_pmn[l_no].pmn432
                   AND ecm012=l_pmn012         #No.FUN-A60011
                   AND ecm03=l_pmn43           #MOD-C70229 add
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#No.FUN-710030 -- begin --
#                   CALL cl_err('up ecm321_2! ',SQLCA.SQLCODE,0)
#                   LET g_success='N'
#                   RETURN
                   LET g_success='N'
                   IF g_bgerr THEN
                      LET g_showmsg = l_pmn41,"/",g_pmn[l_no].pmn432
                      CALL s_errmsg("ecm01,ecm04",g_showmsg,"up ecm321_2! ",SQLCA.sqlcode,1)
                      CONTINUE FOR
                   ELSE
                      CALL cl_err3("upd","ecm_file",l_pmn41,g_pmn[l_no].pmn432,SQLCA.sqlcode,"","up ecm321_2! ",1)
                      EXIT FOR
                   END IF
#No.FUN-710030 -- end --
                 END IF
                 #No.FUN-A60011  --Begin
                #CALL s_update_ecm52(l_pmn41,l_pmn012,g_pmn[l_no].pmn432)     #TQC-C70154 mark
                 CALL s_update_ecm52(l_pmn41,l_pmn012,l_pmn46)                #TQC-C70154 add
                      RETURNING l_flag
                 IF NOT l_flag THEN
                    LET g_success = 'N'
                    CALL cl_err3('upd','ecm_file',l_pmn41,g_pmn[l_no].pmn432,SQLCA.sqlcode,'','update ecm52',1)
                 END IF
                 #No.FUN-A60011  --End  
             END IF
          END IF
      END FOR
#No.FUN-710030 -- begin --
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
#No.FUN-710030 -- end --
      IF g_success = 'Y' THEN 
         CALL p560_hu()               #update 單身狀況碼
      END IF
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
 
FUNCTION p560_pmm01()
   DEFINE l_n           LIKE type_file.num5          #No.FUN-680136 SMALLINT
   DEFINE m_pmn41,l_pmn41 LIKE pmn_file.pmn41,
          l_pmm09       LIKE pmm_file.pmm09,
          l_pmm25       LIKE pmm_file.pmm25,
          l_pmn01       LIKE pmn_file.pmn01,
          l_pmm01       LIKE pmm_file.pmm01,
          l_pmm02       LIKE pmm_file.pmm02,
          l_pmc03       LIKE pmc_file.pmc03
   DEFINE l_pmn         RECORD LIKE pmn_file.*
 
   LET g_errno=' '
   LET l_pmm09=NULL
   LET l_pmc03=NULL
   SELECT pmm01,pmm02,pmm09,pmm25 INTO l_pmm01,l_pmm02,l_pmm09,l_pmm25
          FROM pmm_file WHERE pmm01 = tm.pmm01
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'mfg3207'
      WHEN l_pmm25 matches '[01]' LET g_errno = 'mfg3208'
      WHEN l_pmm25 = '6'   #單頭狀況碼為'已結案'
          IF tm.y='N' THEN 
              LET g_errno = 'mfg3219' #MOD-580136
          END IF
      WHEN l_pmm25 = '7' LET g_errno = 'mfg3215'
      WHEN l_pmm25 = '8' LET g_errno = 'mfg3216'
      WHEN l_pmm25 = '9' LET g_errno = 'mfg3210'
      OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
   END CASE
   IF l_pmm02 !='SUB' THEN LET g_errno ='apm-189' END IF
   IF NOT cl_null(g_errno) THEN
      DISPLAY l_pmm09,l_pmc03 TO FORMONLY.pmm09,FORMONLY.pmc03
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM pmn_file WHERE pmn01 = tm.pmm01 AND pmn51 <= 0
   IF l_n = 0 THEN LET g_errno = 'mfg9171' END IF
   IF NOT cl_null(g_errno) THEN
      DISPLAY l_pmm09,l_pmc03 TO FORMONLY.pmm09,FORMONLY.pmc03
      RETURN
   END IF
   LET m_pmn41 = ' ' LET l_n=0
   DECLARE p560_sfb1 CURSOR WITH HOLD FOR
    SELECT pmn41 FROM pmn_file WHERE pmn01=tm.pmm01
   FOREACH p560_sfb1 INTO l_pmn41
     IF m_pmn41 != l_pmn41 THEN
        SELECT COUNT(*) INTO l_n FROM sfb_file
         WHERE sfb01=l_pmn41 AND (sfb06 IS NOT NULL OR sfb06!=' ')
           AND sfb24='Y' AND sfb87!='X'
        IF l_n =0 THEN
           LET g_errno='asf-679'
        END IF
     END IF
     LET m_pmn41 = l_pmn41
   END FOREACH
   IF cl_null(g_errno) THEN
       SELECT pmc03 INTO l_pmc03 FROM pmc_file WHERE pmc01 = l_pmm09
   END IF
   DISPLAY l_pmm09,l_pmc03 TO FORMONLY.pmm09,FORMONLY.pmc03
END FUNCTION
 
FUNCTION p560_b_fill()
   DEFINE
   l_pmm18       LIKE pmm_file.pmm18,
   l_pmmmksg     LIKE pmm_file.pmmmksg,
   l_pmn09       LIKE pmn_file.pmn09,
   l_pmn20       LIKE pmn_file.pmn20,
   l_pmn50       LIKE pmn_file.pmn20,
   l_pmn46       LIKE pmn_file.pmn46,
   l_pmn011      LIKE pmn_file.pmn011,
   l_pmn41       LIKE pmn_file.pmn41,
   l_pmn55       LIKE pmn_file.pmn55,
   l_short       LIKE pmn_file.pmn50,
   l_wc          LIKE type_file.chr1000,        # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(200)
   l_sql         LIKE type_file.chr1000         # RDSQL STATEMENT  #No.FUN-680136 VARCHAR(600)
 
  #超短交量=pmn50-pmn20-pmn55
 
   LET l_sql = " SELECT 'N',pmn02,pmn04,ecm04,pmn16,",
             #------------No.MOD-660029 modify
              #" (pmn20-pmn50),pmn011,pmn41,pmm18,pmmmksg ",
               " (pmn50-pmn20-pmn55),pmn011,pmn41,pmm18,pmmmksg ",
             #------------No.MOD-660029 end
               "  FROM pmn_file,pmm_file,sfb_file,ecm_file",
               " WHERE pmn51 <= 0 AND pmn011 ='SUB' AND pmn01=pmm01",
               "   AND pmm25 NOT IN ('6','7','8','9') ",
               "   AND sfb01=pmn41 AND (sfb06 IS NOT NULL OR sfb06 !=' ' ) ",
               "   AND sfb24='Y' AND sfb87!='X' ",
               "   AND pmn41=ecm01",
               "   AND pmn43=ecm03",
               "   AND pmn012=ecm012"   #No.FUN-A60011
 
   IF tm.y MATCHES'[yY]' THEN
      LET l_wc   = "  AND pmn01 = '",tm.pmm01,"'",
                   "  ORDER BY pmn02 "
   ELSE
      LET l_wc   = "  AND pmn01 = '",tm.pmm01,"' AND ",
                   "  pmn16 NOT IN ('6','7','8','9') ",
                   "  ORDER BY pmn02 "
   END IF
   LET l_sql = l_sql CLIPPED,l_wc CLIPPED
 
   PREPARE p560_pre FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('cannot prepare ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p560_cur CURSOR FOR p560_pre
   IF SQLCA.sqlcode THEN
      CALL cl_err('cannot declare ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN 
   END IF
 
   LET l_ac = 1 
   LET g_rec_b=0
   FOREACH p560_cur INTO g_pmn[l_ac].*,l_pmn011,l_pmn41,l_pmm18,l_pmmmksg
      IF SQLCA.sqlcode THEN
         CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF cl_null(l_pmn50) THEN LET l_pmn50=0 END IF
      IF cl_null(l_pmn20) THEN LET l_pmn20=0 END IF
      CALL s_pmmsta('pmm',g_pmn[l_ac].pmn16,l_pmm18,l_pmmmksg)
           RETURNING g_pmn[l_ac].pmn16
      LET l_ac = l_ac + 1
 
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pmn.deleteElement(l_ac)
 
   LET g_rec_b=l_ac - 1
   DISPLAY g_rec_b TO FORMONLY.cn2  
 
   IF g_rec_b = 0 THEN     #單身無資料
      CALL cl_err(tm.pmm01,'mfg9171',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   DISPLAY ARRAY g_pmn TO s_pmn.*  ATTRIBUTE(COUNT= g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
END FUNCTION
 
FUNCTION p560_sure()
   DEFINE l_i       LIKE type_file.num5,          #No.FUN-680136 SMALLINT
          l_cnt     LIKE type_file.num5,          #No.FUN-680136 SMALLINT
          l_allow_insert  LIKE type_file.num5,    #可新增否 #No.FUN-680136 SMALLINT
          l_allow_delete  LIKE type_file.num5     #No.FUN-680136 SMALLINT
 
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
 
      ON ACTION select_all           
         FOR l_i = 1 TO g_rec_b      #將所有的設為選擇
             LET g_pmn[l_i].sure="Y"
             LET g_cnt = g_rec_b
         END FOR
         DISPLAY g_rec_b TO FORMONLY.cn3 
 
      ON ACTION cancel_all
         FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
             LET g_pmn[l_i].sure="N"
         END FOR
         LET g_cnt = 0      
         DISPLAY 0 TO FORMONLY.cn3
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END INPUT  
 
END FUNCTION
   
FUNCTION p560_hu()
   DEFINE l_cnt     LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
   SELECT COUNT(*) INTO l_cnt FROM  pmn_file
    WHERE pmn01 = tm.pmm01 AND pmn16 NOT IN ('6','7','8','9')
   IF l_cnt = 0 THEN    #此筆單身無尚未結案&結束的單身資料
      UPDATE pmm_file SET pmm25 = '6', pmm27 = g_today
       WHERE pmm01 = tm.pmm01
      IF SQLCA.sqlcode THEN
         LET g_success='N'
#No.FUN-710030 -- begin --
#         CALL cl_err('(p560_hu:ckp#22)',SQLCA.sqlcode,1)
      IF g_bgerr THEN
         CALL s_errmsg("pmm01",tm.pmm01,"(p560_hu:ckp#22)",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("upd","pmm_file",tm.pmm01,"",SQLCA.sqlcode,"","(p560_hu:ckp#22)",1)
      END IF
#No.FUN-710030 -- end --
         RETURN
      END IF
   END IF
 
END FUNCTION
   
FUNCTION p560_sta(l_ac)
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
