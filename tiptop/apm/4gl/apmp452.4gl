# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmp452.4gl
# Descriptions...: 請購單重新開啟作業
# Date & Author..: 91/09/27 By Wu 
# Modify.........: 99/04/16 By Carol:modify s_pmksta()  
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.MOD-640579 06/05/15 By pengu 還原時,建議應先判斷請購之採購狀況,而非一律還原為pml16='2'
# Modify.........: No.FUN-660129 06/06/19 By Ray cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-710030 07/01/17 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-840654 07/04/25 By claire 調整FUN-710030,未確認請購單結案後,執行開啟會失敗
# Modify.........: No.MOD-870239 08/07/21 By Smapmin 請購單結案開啟時，不需再考慮請購單頭狀態碼是否為"結案"或"轉採購"
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10034 10/01/10 By hongmei 加上AND pml92<>'Y'的判断 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          pmk01 LIKE pmk_file.pmk01,   #請購單號
          pmk09 LIKE pmk_file.pmk09,   #廠商編號
          y     LIKE type_file.chr1    #已開啟資料是否顯示  #No.FUN-680136 VARCHAR(1)
          END RECORD,
        g_pml DYNAMIC ARRAY OF RECORD
          sure     LIKE type_file.chr1,     # 確定否    #No.FUN-680136 VARCHAR(1)
          pml02    LIKE pml_file.pml02,     # 項次
          pml04    LIKE pml_file.pml04,     # 料號
          pml16    LIKE pml_file.pml16,     # 狀況碼
          pml16_d  LIKE ze_file.ze03        # 目前狀況  #No.FUN-680136 VARCHAR(15) 
        END RECORD,
        g_cmd        LIKE type_file.chr1000,     #No.FUN-680136 VARCHAR(60)
        g_rec_b      LIKE type_file.num5,        #No.FUN-680136 SMALLINT
        l_exit_sw    LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1) 
        l_update_sw  LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1) 
        l_ac,l_sl    LIKE type_file.num5         #No.FUN-680136 SMALLINT
DEFINE  g_chr        LIKE type_file.chr1         #No.FUN-680136 VARCHAR(1)
DEFINE  g_flag       LIKE type_file.chr1         #No.FUN-680136 VARCHAR(1)
DEFINE  g_cnt        LIKE type_file.num10        #No.FUN-680136 INTEGER
DEFINE  g_pmk18      LIKE pmk_file.pmk18         #No.MOD-640579 add
 
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
 
   IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
      CALL cl_err(g_sma.sma31,'mfg0032',1)
      EXIT PROGRAM  
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818

   OPEN WINDOW p452_w WITH FORM "apm/42f/apmp452" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL p452_tm()
   CLOSE WINDOW p452_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION p452_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,       #No.FUN-680136 SMALLINT
          l_pmk09       LIKE pmk_file.pmk09,
          l_pmc03       LIKE pmc_file.pmc03,
          l_no,l_cnt    LIKE type_file.num5,       #No.FUN-680136 SMALLINT
          l_pmk18       LIKE pmk_file.pmk18, 
          l_pml21       LIKE pml_file.pml21,       #No.MOD-640579 add
          l_pmkmksg     LIKE pmk_file.pmkmksg, 
          g_sta         LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
 
 WHILE TRUE
   IF s_shut(0) THEN RETURN END IF
 
   CLEAR FORM 
   CALL g_pml.clear()
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.y = 'N'
   ERROR ''
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT BY NAME tm.pmk01,tm.y     WITHOUT DEFAULTS 
 
      AFTER FIELD pmk01            #請購單號
         IF NOT cl_null(tm.pmk01) THEN 
            CALL p452_pmk01() 
            IF g_chr='E' THEN
               CALL cl_err(tm.pmk01,'mfg3058',0)
               NEXT FIELD pmk01
            END IF
         END IF
 
      AFTER FIELD y               #已開啟資料是否顯示
         IF NOT cl_null(tm.y) THEN 
            IF tm.y NOT MATCHES "[YNyn]" THEN 
               NEXT FIELD y 
            END IF
         END IF
 
      ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmk01) #單號
                    CALL q_pmk1(FALSE,TRUE,tm.pmk01,'26','0') RETURNING tm.pmk01
#                    CALL FGL_DIALOG_SETBUFFER( tm.pmk01 )
                    DISPLAY tm.pmk01 TO pmk01 
                    CALL p452_pmk01()
                    NEXT FIELD pmk01
               OTHERWISE EXIT CASE
            END CASE
       
      ON ACTION qry_pr_detail
            CASE
               WHEN INFIELD(pmk01) #單號
                    #CALL cl_cmdrun("apmt420 ")      #FUN-660216 remark
                    CALL cl_cmdrun_wait("apmt420 ")  #FUN-660216 add
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
 
   LET g_success = 'Y'
   CALL p452_b_fill()
 
   IF g_success = 'N' THEN
      CONTINUE WHILE
   END IF 
 
   CALL p452_sure()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CONTINUE WHILE 
   END IF 
 
   IF cl_sure(0,0) THEN 
      BEGIN WORK
      LET g_success='Y'
      LET l_update_sw = 'n'
 
   #-------------No.MOD-640579 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM pml_file 
             	WHERE pml01 = tm.pmk01
                AND   pml21 != 0
   #-------------No.MOD-640579 end
      CALL s_showmsg_init()        #No.FUN-710030
      FOR l_no = 1 TO g_rec_b
#No.FUN-710030 -- begin --
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success='Y'
         END IF
#No.FUN-710030 -- end --
          IF g_pml[l_no].sure = 'Y' AND NOT cl_null(g_pml[l_no].pml02) THEN 
           #------No.MOD-640579 modify
             SELECT pml21 INTO l_pml21 FROM pml_file
                WHERE pml01=tm.pmk01
                  AND pml02 = g_pml[l_no].pml02 
 
             IF g_pmk18 = 'N' THEN
                UPDATE pml_file SET pml16 = '0'
                 WHERE pml01 = tm.pmk01 
                   AND pml02 = g_pml[l_no].pml02 
                 IF SQLCA.sqlcode THEN              #MOD-840654 cancel mark
                   LET g_success = 'N'
#                  CALL cl_err('(ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                   CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[l_no].pml02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
#                   EXIT FOR 
                   IF g_bgerr THEN
                      LET g_showmsg = tm.pmk01,'/',g_pml[l_no].pml02
                      CALL s_errmsg("pml01,pml02",g_showmsg,"(ckp#2)",SQLCA.sqlcode,1)
                      CONTINUE FOR
                   ELSE
                      CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[l_no].pml02,SQLCA.sqlcode,"","(ckp#2)",1)
                      EXIT FOR
                   END IF
#No.FUN-710030 -- end --
                 END IF                            #MOD-840654 cancel mark
             ELSE
                IF l_pml21 = 0 THEN
                   UPDATE pml_file SET pml16 = '1'
                          WHERE pml01 = tm.pmk01
                          AND pml02 = g_pml[l_no].pml02
                   IF SQLCA.sqlcode THEN
                      LET g_success = 'N'
#                     CALL cl_err('(ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                      CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[l_no].pml02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
#                      EXIT FOR
                      IF g_bgerr THEN
                         LET g_showmsg = tm.pmk01,'/',g_pml[l_no].pml02
                         CALL s_errmsg("pml01,pml02",g_showmsg,"(ckp#2)",SQLCA.sqlcode,1)
                         CONTINUE FOR
                      ELSE
                         CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[l_no].pml02,SQLCA.sqlcode,"","(ckp#2)",1)
                         EXIT FOR
                      END IF
#No.FUN-710030 -- end --
                   END IF
                ELSE
                   UPDATE pml_file SET pml16 = '2'
                          WHERE pml01 = tm.pmk01
                          AND pml02 = g_pml[l_no].pml02
                   IF SQLCA.sqlcode THEN
                      LET g_success = 'N'
#                     CALL cl_err('(ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                      CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[l_no].pml02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
#                      EXIT FOR
                      IF g_bgerr THEN
                         LET g_showmsg = tm.pmk01,'/',g_pml[l_no].pml02
                         CALL s_errmsg("pml01,pml02",g_showmsg,"(ckp#2)",SQLCA.sqlcode,1)
                         CONTINUE FOR
                      ELSE
                         CALL cl_err3("upd","pml_file",tm.pmk01,g_pml[l_no].pml02,SQLCA.sqlcode,"","(ckp#2)",1)
                         EXIT FOR
                      END IF
                   END IF
                END IF
             END IF
           #------No.MOD-640579 end
             LET l_update_sw = 'y'
          END IF
      END FOR 
#No.FUN-710030 -- begin --
      IF g_totsuccess='N' THEN
         LET g_success='N'
      END IF
      CALL s_showmsg()
#No.FUN-710030 -- end --
      IF l_update_sw = 'y' THEN 
        #------No.MOD-640579 modify
         IF g_pmk18 = 'N' THEN
            UPDATE pmk_file SET pmk25 = '0' ,
                                pmk27 = g_today
                   WHERE pmk01 = tm.pmk01
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
#              CALL cl_err('(cko#4)',SQLCA.sqlcode,1)   #No.FUN-660129
               CALL cl_err3("upd","pmk_file",tm.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            END IF
         ELSE
            IF l_cnt > 0 THEN
               UPDATE pmk_file SET pmk25 = '2' ,
                                   pmk27 = g_today
                      WHERE pmk01 = tm.pmk01
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
#                 CALL cl_err('(cko#4)',SQLCA.sqlcode,1)   #No.FUN-660129
                  CALL cl_err3("upd","pmk_file",tm.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               END IF
            ELSE
               UPDATE pmk_file SET pmk25 = '1' ,
                                   pmk27 = g_today
                      WHERE pmk01 = tm.pmk01
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
#                 CALL cl_err('(cko#4)',SQLCA.sqlcode,1)   #No.FUN-660129
                  CALL cl_err3("upd","pmk_file",tm.pmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               END IF
            END IF
         END IF
        #------No.MOD-640579 end
      END IF
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
 
FUNCTION p452_pmk01()
   DEFINE  l_pmk09    LIKE   pmk_file.pmk09,
           l_pmc03    LIKE   pmc_file.pmc03
 
       LET g_chr=' '
       SELECT pmk09 INTO l_pmk09 FROM pmk_file 
        WHERE pmk01 = tm.pmk01  
          #AND pmk25 IN ('2','6')    #MOD-870239
          AND pmkacti = 'Y'
       IF SQLCA.sqlcode THEN
          LET g_chr='E'
          LET l_pmk09=NULL
          LET l_pmc03=NULL
       ELSE
          SELECT pmc03 INTO l_pmc03 FROM pmc_file
           WHERE pmc01 = l_pmk09
          DISPLAY l_pmk09 TO FORMONLY.pmk09
          DISPLAY l_pmc03 TO FORMONLY.pmc03
       END IF
 
END FUNCTION       
 
FUNCTION p452_b_fill()
   DEFINE l_wc          LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(200)
          l_sql 	LIKE type_file.chr1000,	     # RDSQL STATEMENT        #No.FUN-680136 VARCHAR(600)
          l_no,l_cnt    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_pmk18       LIKE pmk_file.pmk18, 
          l_pmkmksg     LIKE pmk_file.pmkmksg, 
          g_sta         LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
     LET l_sql = " SELECT 'N',pml02,pml04,pml16,'',pmk18,pmkmksg ",
                 "  FROM pml_file,pmk_file "
     IF tm.y matches'[Yy]' THEN 
        LET l_wc = "  WHERE pml01 = '",tm.pmk01,"' AND pmk01=pml01",
                   "    AND pml92<>'Y' ",    #FUN-A10034
                   "  ORDER BY pml02 "
     ELSE 
        LET l_wc = "  WHERE pml01 = '",tm.pmk01,"' AND pmk01=pml01 AND ",
                   "  pml16 IN ('6','7','8')",
                   "    AND pml92<>'Y' ",    #FUN-A10034
                   "  ORDER BY pml02 "
     END IF
 
     LET l_sql = l_sql clipped,l_wc clipped
     PREPARE p452_prepare FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('cannot perpare ',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        RETURN
     END IF
 
     DECLARE p452_cs CURSOR FOR p452_prepare
     IF SQLCA.sqlcode THEN 
        CALL cl_err('cannot declare ',SQLCA.sqlcode,1) 
        LET g_success = 'N'
        RETURN
     END IF
 
 
     ##LET l_ac = 1  
     LET g_cnt = 1    # TQC-630105 by Joe
     LET g_rec_b = 0
 
     #FOREACH p452_cs INTO g_pml[l_ac].*,l_pmk18,l_pmkmksg 
     FOREACH p452_cs INTO g_pml[g_cnt].*,l_pmk18,l_pmkmksg # TQC-630105 by Joe
       IF SQLCA.sqlcode THEN 
          CALL cl_err('cannot foreach ',SQLCA.sqlcode,1) 
          LET g_success = 'N'
          EXIT FOREACH
       END IF
  
       #IF NOT cl_null(g_pml[l_ac].pml16) THEN 
       #   CALL s_pmksta('pmk',g_pml[l_ac].pml16,l_pmk18,l_pmkmksg) 
       #        RETURNING g_pml[l_ac].pml16_d
       #END IF 
       #LET l_ac = l_ac + 1 # TQC-630105 by Joe
       # TQC-630105----------start add by Joe
       LET g_pmk18 = l_pmk18    #No.MOD-640579 add
       IF NOT cl_null(g_pml[g_cnt].pml16) THEN  
          CALL s_pmksta('pmk',g_pml[g_cnt].pml16,l_pmk18,l_pmkmksg) 
               RETURNING g_pml[g_cnt].pml16_d
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
       # TQC-630105----------end add by Joe
 
  END FOREACH
  #CALL g_pml.deleteElement(l_ac)
  #LET g_rec_b=l_ac - 1 
  CALL g_pml.deleteElement(g_cnt) # TQC-630105 by Joe
 
  LET g_rec_b = g_cnt - 1
  DISPLAY g_rec_b TO FORMONLY.cn2  
 
  IF g_rec_b = 0 THEN     #單身無資料
     CALL cl_err(tm.pmk01,'mfg0039',1) 
     LET g_flag = 'N'
     RETURN 
  END IF
 
  DISPLAY ARRAY g_pml TO s_pml.* ATTRIBUTE(COUNT=g_rec_b)
     BEFORE DISPLAY
        EXIT DISPLAY
  END DISPLAY
 
END FUNCTION
   
FUNCTION p452_sure()
    DEFINE l_buf           LIKE type_file.chr1000,      #No.FUN-680136 VARCHAR(80)
           l_cnt           LIKE type_file.num5,         #可新增否  #No.FUN-680136 SMALLINT
           g_i             LIKE type_file.num5,         #可新增否  #No.FUN-680136 SMALLINT
           l_allow_insert  LIKE type_file.num5,         #可新增否  #No.FUN-680136 SMALLINT
           l_allow_delete  LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
 
    MESSAGE ''
 
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
             LET l_cnt = 0
             FOR g_i =1 TO g_rec_b
                 IF g_pml[g_i].sure = 'Y' AND
                    NOT cl_null(g_pml[g_i].pml02)  THEN
                    LET l_cnt = l_cnt + 1
                 END IF
              END FOR
              DISPLAY l_cnt TO FORMONLY.cn3
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLP 
          LET l_ac = ARR_CURR()
          LET g_cmd = "apmt401 ",tm.pmk01
          #CALL cl_cmdrun(g_cmd)      #FUN-660216 remark
          CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
 
       ON ACTION select_all           
          FOR g_i = 1 TO g_rec_b     #將所有的設為選擇
              LET g_pml[g_i].sure="Y"
          END FOR
          LET l_cnt = g_rec_b
          DISPLAY g_rec_b TO FORMONLY.cn3 
 
       ON ACTION cancel_all
          FOR g_i = 1 TO g_rec_b     #將所有的設為選擇
              LET g_pml[g_i].sure="N"
          END FOR
          LET l_cnt = 0
          DISPLAY 0 TO FORMONLY.cn3
 
       AFTER ROW
         IF INT_FLAG THEN 
            EXIT INPUT
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
