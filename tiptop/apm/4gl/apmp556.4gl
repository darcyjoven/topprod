# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: apmp556.4gl
# Descriptions...: 採購單凍結還原作業
# Date & Author..: 03/05/05 By Nicola
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-710030 07/01/19 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B60114 11/06/16 By lixiang 修改狀態碼的顯示問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          pmm01      LIKE pmm_file.pmm01,     #請購單號
          pmm09      LIKE pmm_file.pmm09      #廠商編號
          END RECORD,
        g_pmn DYNAMIC ARRAY OF RECORD
            sure     LIKE type_file.chr1,     # 確定否   #No.FUN-680136 VARCHAR(1)
            pmn02    LIKE pmn_file.pmn02,     # 項次
            pmn04    LIKE pmn_file.pmn04,     # 料號
         #  pmn16    LIKE pmn_file.pmn16,     # 目前狀況 #No.FUN-680136 VARCHAR(1)
            pmn16    LIKE type_file.chr10,    # 目前狀況 #No.TQC-B60114 VARCHAR(10)
            pmn20    LIKE pmn_file.pmn20      # 訂購量   
        END RECORD,
        g_cmd        LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(60)
        g_rec_b      LIKE type_file.num5,     #No.FUN-680136 SMALLINT
        l_exit_sw    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
        g_sh         LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
        l_ac,l_sl    LIKE type_file.num5      #No.FUN-680136 SMALLINT
DEFINE  g_flag       LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
DEFINE  g_chr        LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
DEFINE  g_cnt        LIKE type_file.num10     #No.FUN-680136 INTEGER

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   CALL p556_tm()				# 
   CLOSE WINDOW p556_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p556_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680136 SMALLINT 
          l_no,l_cnt    LIKE type_file.num5           #No.FUN-680136 SMALLINT
   DEFINE l_pmm18       LIKE pmm_file.pmm18
   DEFINE l_pmmmksg     LIKE pmm_file.pmmmksg
 
   LET p_row = 2 LET p_col = 19
 
   OPEN WINDOW p556_w AT p_row,p_col WITH FORM "apm/42f/apmp556" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
   IF s_shut(0) THEN RETURN END IF
 
 WHILE TRUE
   CLEAR FORM 
   CALL g_pmn.clear()
   INITIALIZE tm.* TO NULL			# Default condition
   ERROR ''
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT BY NAME tm.pmm01     WITHOUT DEFAULTS 
 
      AFTER FIELD pmm01            #請購單號
         IF NOT cl_null(tm.pmm01) THEN 
            CALL p556_pmm01()
            IF g_chr='E' THEN
               CALL cl_err(tm.pmm01,'mfg9133',0)
               NEXT FIELD pmm01
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmm01) #單號
               CALL q_pmm8(FALSE,TRUE,tm.pmm01,'012') RETURNING tm.pmm01
#               CALL FGL_DIALOG_SETBUFFER( tm.pmm01 )
               DISPLAY tm.pmm01 TO pmm01 
               CALL p556_pmm01()
               NEXT FIELD pmm01
            OTHERWISE EXIT CASE
         END CASE
       
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
 
   LET g_success='Y'
   CALL p556_b_fill()      #bugno:7207
   IF g_success = 'N' THEN
      CONTINUE WHILE
   END IF
 
   CALL p556_sure() 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CONTINUE WHILE
   END IF
     
   IF cl_sure(0,0) THEN 
      BEGIN WORK
      LET g_success='Y'
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
            UPDATE pmn_file SET pmn11 = 'N' 
               WHERE pmn01 = tm.pmm01 AND pmn02 = g_pmn[l_no].pmn02 
            IF SQLCA.sqlcode THEN 
               LET g_success='N' 
#No.FUN-710030 -- begin --
#               CALL cl_err('(p556:ckp#2)',SQLCA.sqlcode,1)
#               RETURN
               IF g_bgerr THEN
                  LET g_showmsg = tm.pmm01,"/",g_pmn[l_no].pmn02
                  CALL s_errmsg("pmn01,pmn02",g_showmsg,"(p556:ckp#2)",SQLCA.sqlcode,1)
                  CONTINUE FOR
               ELSE
                  CALL cl_err3("upd","pmn_file",tm.pmm01,g_pmn[l_no].pmn02,SQLCA.sqlcode,"","(p556:ckp#2)",1)
                  EXIT FOR
               END IF
#No.FUN-710030 -- end --
            END IF
         END IF
      END FOR 
#No.FUN-710030 -- begin --
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
      CALL s_showmsg()
#No.FUN-710030 -- end --
 
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
 
 END WHILE
 ERROR ""
 
END FUNCTION
 
FUNCTION p556_pmm01()
   DEFINE l_pmm09       LIKE pmm_file.pmm09,
          l_pmc03       LIKE pmc_file.pmc03
 
   LET g_chr=' '
   SELECT UNIQUE(pmm09) INTO l_pmm09
          FROM  pmm_file, pmn_file
          WHERE pmm01 = tm.pmm01  AND pmm01 = pmn01
            AND pmm25 IN ('0','1','2') AND pmn11 NOT IN ('N','n')
   IF SQLCA.sqlcode THEN
       LET g_chr='E'
       LET l_pmm09=NULL
       LET l_pmc03=NULL
   ELSE
       SELECT pmc03 INTO l_pmc03 FROM pmc_file
                    WHERE pmc01 = l_pmm09
       DISPLAY l_pmm09 TO pmm09
       DISPLAY l_pmc03 TO pmc03
   END IF
END FUNCTION       
 
FUNCTION p556_b_fill()
   DEFINE l_wc   	LIKE type_file.chr1000,   # RDSQL STATEMENT        #No.FUN-680136 VARCHAR(200)
          l_sql 	LIKE type_file.chr1000,	  # RDSQL STATEMENT        #No.FUN-680136 VARCHAR(600)
          l_no,l_cnt    LIKE type_file.num5       #No.FUN-680136 SMALLINT
   DEFINE l_pmm18       LIKE pmm_file.pmm18
   DEFINE l_pmmmksg     LIKE pmm_file.pmmmksg
 
     LET l_sql = " SELECT 'N',pmn02,pmn04,pmn16,pmn20,pmm18,pmmmksg",
                 "  FROM pmn_file,pmm_file",
                 "  WHERE pmn01 = '",tm.pmm01,"'",
                 "    AND pmn16 IN ('0','1','2') ",
                 "    AND pmn11 NOT IN ('N','n')",
                 "    AND pmn01=pmm01 ",
                 "  ORDER BY pmn02 "
     LET l_sql = l_sql clipped,l_wc clipped
     PREPARE p556_prepare FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('cannot prepare ',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        RETURN
     END IF
     DECLARE p556_cur CURSOR FOR p556_prepare
     IF SQLCA.sqlcode THEN 
        CALL cl_err('cannot declare ',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        RETURN
     END IF
 
     LET l_ac    = 1
     LET g_rec_b = 0
     LET l_cnt   = 0 
     FOREACH p556_cur INTO g_pmn[l_ac].*,l_pmm18,l_pmmmksg 
        IF SQLCA.sqlcode THEN 
           CALL cl_err('cannot foreach ',SQLCA.sqlcode,1) 
           LET g_success = 'N'
           EXIT FOREACH
        END IF
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
    DISPLAY l_cnt   TO FORMONLY.cn3
 
    IF g_rec_b = 0 THEN     #單身無資料
       CALL cl_err(tm.pmm01,'mfg0039',1) 
       LET g_success = 'N'
       RETURN 
    END IF
 
    DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE( COUNT= g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
 
END FUNCTION
   
FUNCTION p556_sure() 
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
             LET l_cnt = 0 
             FOR l_i = 1 TO g_rec_b 
                 IF g_pmn[l_ac].sure = 'Y' THEN
                    LET l_cnt = l_cnt + 1
                 END IF
             END FOR
             DISPLAY l_cnt TO FORMONLY.cn3
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
          END FOR
          LET l_cnt = g_rec_b
          DISPLAY g_rec_b TO FORMONLY.cn3 
 
       ON ACTION cancel_all
          FOR l_i = 1 TO g_rec_b     #將所有的設為選擇
              LET g_pmn[l_i].sure="N"
          END FOR
          LET l_cnt = 0
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
    END INPUT 
END FUNCTION
