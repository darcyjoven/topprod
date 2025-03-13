# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmp457.4gl
# Descriptions...: 採購單凍結還原作業
# Date & Author..: 03/05/05 By Nicola
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-640132 06/04/17 By Nicola 單身多show到庫日期
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-710030 07/01/17 By johnray 錯誤訊息匯總顯示修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          pmk01 LIKE pmk_file.pmk01,   #採購單號
          pmk09 LIKE pmk_file.pmk09    #廠商編號
          END RECORD,
        g_pml DYNAMIC ARRAY OF RECORD
            sure     LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
            pml02    LIKE pml_file.pml02,     # 項次
            pml04    LIKE pml_file.pml04,     # 料號
            pml16    LIKE pml_file.pml16,     # 目前狀況 #No.FUN-680136 VARCHAR(10)
            pml20    LIKE pml_file.pml20,     # 訂購量   
            pml18    LIKE pml_file.pml18,     # MRP 需求日
            pml35    LIKE pml_file.pml35      #No.TQC-640132
        END RECORD,
        g_cmd        LIKE type_file.chr1000,  #No.FUN-680136 VARCHAR(60)
        g_rec_b      LIKE type_file.num5,     #No.FUN-680136 SMALLINT
        l_exit_sw    LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
        g_sh         LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
        l_ac,l_sl    LIKE type_file.num5      #No.FUN-680136 SMALLINT
DEFINE  g_chr        LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
DEFINE  g_flag       LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
DEFINE  g_cnt        LIKE type_file.num10     #No.FUN-680136 INTEGER
 
MAIN
 DEFINE l_time	     LIKE type_file.chr8      # Used time for running the job #No.FUN-680136 VARCHAR(8)
 DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680136 SMALLINT
 
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
 
   LET p_row = 2 LET p_col = 19
 
   OPEN WINDOW p457_w AT p_row,p_col WITH FORM "apm/42f/apmp457" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('z')
 
     CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
   CALL p457_tm()				# 
   ERROR ""
   CLOSE WINDOW p457_w
     CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
 
END MAIN
 
FUNCTION p457_tm()
 DEFINE l_i              LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
 WHILE TRUE
   IF s_shut(0) THEN RETURN END IF
   CLEAR FORM 
   CALL g_pml.clear()
   INITIALIZE tm.* TO NULL			# Default condition
   ERROR ''
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT BY NAME tm.pmk01     WITHOUT DEFAULTS 
 
      AFTER FIELD pmk01            #採購單號
         IF NOT cl_null(tm.pmk01) THEN 
            CALL p457_pmk01()
            IF g_chr='E' THEN
               CALL cl_err(tm.pmk01,'mfg3052',0)
               NEXT FIELD pmk01
            END IF
         END IF
 
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pmk01) #單號
                 CALL q_pmk5(FALSE,TRUE,tm.pmk01,'012') RETURNING tm.pmk01
#                 CALL FGL_DIALOG_SETBUFFER( tm.pmk01 )
                 DISPLAY tm.pmk01 TO pmk01 
                 CALL p457_pmk01()
                 NEXT FIELD pmk01
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
 
   CALL p457_b_fill()      #bugno:7207
   IF g_success = 'N' THEN 
      CONTINUE WHILE
   END IF 
 
   CALL p457_sure()         #確定否
   IF INT_FLAG  THEN 
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   IF cl_sure(0,0) THEN 
      CALL cl_wait()
      LET g_success = 'Y'
      BEGIN WORK
      CALL s_showmsg_init()        #No.FUN-710030
      FOR l_i = 1 TO g_rec_b 
#No.FUN-710030 -- begin --
         IF g_success="N" THEN
            LET g_totsuccess="N"
            LET g_success="Y"
         END IF
#No.FUN-710030 -- end --
          IF g_pml[l_i].sure = 'Y' THEN
             UPDATE pml_file SET pml11 = 'N' 
              WHERE pml01 = tm.pmk01 AND pml02 = g_pml[l_i].pml02 
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                LET g_success = 'N'
#               CALL cl_err('(ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[l_i].pml02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                IF g_bgerr THEN
                   LET g_showmsg = tm.pmk01,"/",g_pml[l_i].pml02
                   CALL s_errmsg("pml01,pml02",g_showmsg,"(ckp#2)",SQLCA.sqlcode,1)
                ELSE
                   CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[l_i].pml02,SQLCA.sqlcode,"","(ckp#2)",1)
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
 
END FUNCTION
 
FUNCTION p457_pmk01()
   DEFINE l_pmk09       LIKE pmk_file.pmk09,
          l_pmc03       LIKE pmc_file.pmc03
 
   LET g_chr=' '
   SELECT UNIQUE(pmk09) INTO l_pmk09 
          FROM  pmk_file, pml_file
          WHERE pmk01 = tm.pmk01  AND pmk01 = pml01
            AND pmk25 IN ('0','1','2') AND pml11 NOT IN ('N','n')
   IF SQLCA.sqlcode THEN
       LET g_chr='E'
       LET l_pmk09=NULL
       LET l_pmc03=NULL
   ELSE
       SELECT pmc03 INTO l_pmc03 FROM pmc_file
                    WHERE pmc01 = l_pmk09
       DISPLAY l_pmk09 TO pmk09
       DISPLAY l_pmc03 TO pmc03
   END IF
END FUNCTION       
 
FUNCTION p457_b_fill()
 DEFINE l_wc   	   LIKE type_file.chr1000,    # RDSQL STATEMENT   #No.FUN-680136 VARCHAR(200)
        l_sql 	   LIKE type_file.chr1000,    # RDSQL STATEMENT   #No.FUN-680136 VARCHAR(600)
        l_pmk18    LIKE pmk_file.pmk18,
        l_pmkmksg  LIKE pmk_file.pmkmksg
 
     LET l_sql = " SELECT 'N',pml02,pml04,pml16,pml20,pml18,pml35,pmk18,pmkmksg",   #No.TQC-640132
                 "  FROM pml_file,pmk_file",
                 "  WHERE pml01 = '",tm.pmk01,"' AND pmk01=pml01 ",
                 "    AND pml16 IN ('0','1','2') ",
                 "    AND pml11 NOT IN ('N','n')",
                 "  ORDER BY pml02 "
     LET l_sql = l_sql CLIPPED,l_wc CLIPPED
 
     PREPARE p457_prepare FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('cannot prepare ',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        RETURN 
     END IF
     DECLARE p457_cur CURSOR FOR p457_prepare
     IF SQLCA.sqlcode THEN 
        CALL cl_err('cannot declare ',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        RETURN 
     END IF
 
     #LET l_ac = 1
     LET g_cnt = 1  # TQC-630105 add by Joe  #No.TQC-640132
     LET g_rec_b = 0
     #FOREACH p457_cur INTO g_pml[l_ac].*,l_pmk18,l_pmkmksg 
     FOREACH p457_cur INTO g_pml[g_cnt].*,l_pmk18,l_pmkmksg # TQC-630105 add by Joe
       IF SQLCA.sqlcode THEN 
          CALL cl_err('cannot foreach ',SQLCA.sqlcode,1) 
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       #CALL s_pmksta('pmk',g_pml[l_ac].pml16,l_pmk18,l_pmkmksg) 
       #     RETURNING g_pml[l_ac].pml16
       CALL s_pmksta('pmk',g_pml[g_cnt].pml16,l_pmk18,l_pmkmksg) # TQC-630105 add by Joe
            RETURNING g_pml[g_cnt].pml16
 
#           UPDATE pml_file SET pml11 = 'N'
#            WHERE pml01 = tm.pmk01 
#              #AND pml02 = g_pml[l_ac].pml02
#              AND pml02 = g_pml[g_cnt].pml02 # TQC-630105 add by Joe
#           IF SQLCA.sqlcode THEN
#              LET g_success = 'N'
#              CALL cl_err('(ckp#1)',SQLCA.sqlcode,1)
#           END IF
 
       #LET l_ac = l_ac + 1
       # TQC-630105----------start add by Joe
       LET g_cnt = g_cnt + 1 
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
       # TQC-630105----------end add by Joe
 
     END FOREACH
     CALL g_pml.deleteElement(l_ac)
 
     #LET g_rec_b=l_ac - 1 
     LET g_rec_b=g_cnt - 1 # TQC-630105 add by Joe
     DISPLAY g_rec_b TO FORMONLY.cn2  
 
     IF g_rec_b = 0 THEN     #單身無資料
        CALL cl_err(tm.pmk01,'mfg0066',1) 
        LET g_success = 'N'
     END IF
 
     DISPLAY ARRAY g_pml TO s_pml.*  ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED) 
       BEFORE DISPLAY
         EXIT DISPLAY
     END DISPLAY
 
END FUNCTION
 
FUNCTION p457_sure() 
    DEFINE l_cnt,g_i        LIKE type_file.num5          #No.FUN-680136 SMALLINT
    DEFINE l_ac             LIKE type_file.num5,         #No.FUN-680136 SMALLINT
           l_allow_insert   LIKE type_file.num5,         #可新增否 #No.FUN-680136 SMALLINT
           l_allow_delete   LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
     LET l_allow_insert = FALSE
     LET l_allow_delete = FALSE 
 
    LET l_ac = 1
    INPUT ARRAY g_pml WITHOUT DEFAULTS FROM s_pml.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
 
       AFTER FIELD sure
          IF NOT cl_null(g_pml[l_ac].sure) THEN
             IF g_pml[l_ac].sure NOT MATCHES "[YN]" THEN
                NEXT FIELD sure
             END IF
          END IF
 
       AFTER INPUT
          LET l_cnt  = 0 
          FOR g_i =1 TO g_rec_b
             IF g_pml[g_i].sure = 'Y' AND 
                NOT cl_null(g_pml[g_i].pml02)  THEN
                LET l_cnt = l_cnt + 1
             END IF
          END FOR
          DISPLAY l_cnt TO FORMONLY.cn3 
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION select_all           
          FOR g_i = 1 TO g_rec_b
              LET g_pml[g_i].sure="Y"
          END FOR
          LET l_cnt = g_rec_b 
 
          DISPLAY g_rec_b TO FORMONLY.cn3 
          LET l_ac = ARR_CURR()
 
       ON ACTION cancel_all
          FOR g_i = 1 TO g_rec_b
              LET g_pml[g_i].sure="N"
          END FOR
          LET l_cnt = 0 
          DISPLAY 0 TO FORMONLY.cn3
          LET l_ac = ARR_CURR()
 
       AFTER ROW
         IF INT_FLAG THEN 
            EXIT INPUT
         END IF 
   
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    
    END INPUT
 
END FUNCTION
