# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: amri700.4gl
# Descriptions...: 備料地點維護作業
# Date & Author..: 01/08/23  BY Mandy
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4B0013 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-510046 05/01/25 By pengu 報表轉XML
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7C0043 07/12/27 By Cockroach 報表改為p_query實現
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/19 By xumm 修改FUN-D40030遗留问题
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ima           RECORD LIKE ima_file.*,
    g_gem02         LIKE gem_file.gem02,
  # g_msm_pamsmo    SMALLINT,
    g_msm_pamsmo    LIKE type_file.num5,     #No.FUN-680082 SMALLINT 
    g_msm           DYNAMIC ARRAY OF RECORD 
        msm01       LIKE msm_file.msm01,
        ima02       LIKE ima_file.ima02,
        msm02       LIKE msm_file.msm02,
        msm03       LIKE msm_file.msm03,
        msm06       LIKE msm_file.msm06,
        msm07       LIKE msm_file.msm07 
                    END RECORD,
    g_msm_t         RECORD 
        msm01       LIKE msm_file.msm01,
        ima02       LIKE ima_file.ima02,
        msm02       LIKE msm_file.msm02,
        msm03       LIKE msm_file.msm03,
        msm06       LIKE msm_file.msm06,
        msm07       LIKE msm_file.msm07 
                    END RECORD,       
  # g_dbs_gl        VARCHAR(21),
    g_dbs_gl        LIKE type_file.chr21,   #No.FUN-680082 VARCHAR(21)
    g_wc2,g_sql     STRING,                 #No.FUN-580092 HCN     
    g_cmd           LIKE type_file.chr1000, #No.FUN-680082 VARCHAR(80)
    g_rec_b         LIKE type_file.num5,    #單身筆數      #No.FUN-680082 SMALLINT
    p_row,p_col     LIKE type_file.num5,    #No.FUN-680082 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT          #No.FUN-680082 SMALLINT
 
DEFINE   g_forupd_sql        STRING         #SELECT ... FOR UPDATE SQL     
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680082 SMALLINT
DEFINE   g_cnt               LIKE type_file.num10    #No.FUN-680082 INTEGER
DEFINE   g_i                 LIKE type_file.num5     #count/index for any purpose #No.FUN-680082 SMALLINT
 
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0076
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
    LET p_row = 4 LET p_col = 8
    OPEN WINDOW i700_w AT p_row,p_col WITH FORM "amr/42f/amri700"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
#   LET g_plant_new = g_nmz.nmz02p
#   CALL s_getdbs()
#   LET g_dbs_gl = g_dbs_new
 
    LET g_wc2 = '1=1' 
    CALL i700_b_fill(g_wc2)
    LET g_msm_pamsmo = 0                   #現在單身頁次
 
    CALL i700_menu()
    CLOSE WINDOW i700_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
 
FUNCTION i700_menu()
   WHILE TRUE
      CALL i700_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i700_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i700_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i700_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0013
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_msm),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i700_q()
   CALL i700_b_askkey()
   LET g_msm_pamsmo = 0
END FUNCTION
 
FUNCTION i700_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680082 SMALLINT
    l_msm04         LIKE msm_file.msm04,
    l_msm05         LIKE msm_file.msm05,
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680082 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680082 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680082 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,     #可新增否          #No.FUN-680082 VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1      #可刪除否          #No.FUN-680082 VARCHAR(01)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
    "SELECT msm01,' ',msm02,msm03,msm06,msm07 ",
    "  FROM msm_file ",
    " WHERE msm01= ?            ",
    "   AND msm06= ?            ",
    "   FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET g_msm_pamsmo = 1
        INPUT ARRAY g_msm WITHOUT DEFAULTS FROM s_msm.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN 
                BEGIN WORK
                LET p_cmd='u'
                LET g_msm_t.* = g_msm[l_ac].*  #BACKUP
                OPEN i700_bcl USING g_msm_t.msm01,g_msm_t.msm06
                IF STATUS THEN
                   CALL cl_err("OPEN i700_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                FETCH i700_bcl INTO g_msm[l_ac].*
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_msm_t.msm01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                SELECT ima02 INTO g_msm[l_ac].ima02
                  FROM ima_file
                  WHERE ima01 = g_msm[l_ac].msm01
                LET g_before_input_done = FALSE
                CALL i700_set_entry(p_cmd)
                CALL i700_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        BEFORE INSERT
            BEGIN WORK
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_msm[l_ac].* TO NULL      #900423
            LET g_msm_t.* = g_msm[l_ac].*         #新輸入資料
            LET g_before_input_done = FALSE
            CALL i700_set_entry(p_cmd)
            CALL i700_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD msm01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i700_bcl
#           CALL g_msm.deleteElement(l_ac)
#           IF g_rec_b != 0 THEN
#              LET g_action_choice = "detail"
#              LET l_ac = l_ac_t
#           END IF
#           EXIT INPUT
         END IF
         LET l_msm04 = '  '
         LET l_msm05 = '  '
         INSERT INTO msm_file(msm01,msm02,msm03,msm04,msm05,msm06,msm07)
                      VALUES (g_msm[l_ac].msm01,g_msm[l_ac].msm02,
                              g_msm[l_ac].msm03, l_msm04,l_msm05,
                              g_msm[l_ac].msm06,g_msm[l_ac].msm07)
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_msm[l_ac].msm01,SQLCA.sqlcode,0) #No.FUN-660107
             CALL cl_err3("ins","msm_file",g_msm[l_ac].msm01,g_msm[l_ac].msm06,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        BEFORE FIELD msm02
          IF g_msm[l_ac].msm01 != g_msm_t.msm01 OR
             (g_msm[l_ac].msm01 IS NOT NULL AND g_msm_t.msm01 IS NULL) THEN
               SELECT ima02 INTO g_msm[l_ac].ima02
                 FROM ima_file WHERE ima01=g_msm[l_ac].msm01
               IF STATUS THEN
#                  CALL cl_err('sel ima',STATUS,1)  #No.FUN-660107
                   CALL cl_err3("sel","ima_file",g_msm[l_ac].msm01,"",STATUS,"","sel ima",1)       #NO.FUN-660107
                  NEXT FIELD msm01
               END IF
                DISPLAY g_msm[l_ac].ima02 TO ima02         #No.MOD-490371
          END IF
 
        AFTER FIELD msm02
         IF g_msm[l_ac].msm02 IS NOT NULL THEN
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt FROM pme_file
            WHERE pme01 = g_msm[l_ac].msm02
              AND pme02 IS NOT NULL
              AND pme02 != '1'
           IF g_cnt = 0
           THEN
              CALL cl_err('','amr-701',0) #交貨地址資料輸入錯誤 !!
              LET g_msm[l_ac].msm02 = g_msm_t.msm02 
              NEXT FIELD msm02 
           END IF
         END IF
         
        AFTER FIELD msm03
          LET g_cnt = 0
          SELECT COUNT(*) INTO g_cnt FROM imd_file
           WHERE imd01 = g_msm[l_ac].msm03
             AND imdacti = 'Y'
          IF g_cnt = 0
          THEN
             #倉庫資料輸入錯誤 or 倉庫無效, 請檢查 aimi200 !!
             CALL cl_err('','amr-702',0) 
             LET g_msm[l_ac].msm03 = g_msm_t.msm03
#            NEXT FIELD msm03
          END IF
         
        BEFORE FIELD msm06
          CALL i700_set_entry(p_cmd)
 
        AFTER FIELD msm06
         IF g_msm[l_ac].msm06 IS NOT NULL THEN
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt FROM gem_file
            WHERE gem01 = g_msm[l_ac].msm06
              AND gemacti = 'Y'
           IF g_cnt = 0 THEN
              #生產廠資料輸入錯誤 or 生產廠無效, 請檢查 apmi600 !!
              CALL cl_err('','amr-703',0)
              LET g_msm[l_ac].msm06 = g_msm_t.msm06
              NEXT FIELD msm06
           END IF
           LET g_cnt = 0
           SELECT COUNT(*) INTO g_cnt FROM msm_file
            WHERE msm01 = g_msm[l_ac].msm01
              AND msm06 = g_msm[l_ac].msm06
           IF g_cnt >0 THEN
                CALL cl_err('',-239,0)
#               LET g_msm[l_ac].msm01 = g_msm_t.msm01
#               LET g_msm[l_ac].msm06 = g_msm_t.msm06
                NEXT FIELD msm01
           END IF
         END IF
         CALL i700_set_no_entry(p_cmd)
          
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_msm_t.msm01) AND NOT cl_null(g_msm_t.msm06) THEN
                IF NOT cl_delete() THEN
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM msm_file
                 WHERE msm01 = g_msm_t.msm01
                   AND msm06 = g_msm_t.msm06
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_msm_t.msm01,SQLCA.sqlcode,0) #No.FUN-660107
                     CALL cl_err3("del","msm_file",g_msm_t.msm01,g_msm_t.msm06,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_msm[l_ac].* = g_msm_t.*
            CLOSE i700_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_msm[l_ac].msm01,-263,1)
             LET g_msm[l_ac].* = g_msm_t.*
         ELSE
             UPDATE msm_file SET
                    msm01=g_msm[l_ac].msm01,
                    msm02=g_msm[l_ac].msm02,
                    msm03=g_msm[l_ac].msm03,
                    msm06=g_msm[l_ac].msm06,
                    msm07=g_msm[l_ac].msm07
             WHERE CURRENT OF i700_bcl 
             IF SQLCA.sqlcode THEN
#                CALL cl_err(g_msm[l_ac].msm01,SQLCA.sqlcode,0) #No.FUN-660107
                 CALL cl_err3("upd","msm_file",g_msm[l_ac].msm01,g_msm[l_ac].msm06,SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
                LET g_msm[l_ac].* = g_msm_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i700_bcl
                COMMIT WORK
             END IF
        END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_msm[l_ac].* = g_msm_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_msm.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i700_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i700_b_askkey()
#           LET l_exit_sw = "n"
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(msm01) AND l_ac > 1 THEN
                LET g_msm[l_ac].* = g_msm[l_ac-1].*
    #           LET g_msm_t.*     = g_msm[l_ac].*
                NEXT FIELD msm01
            END IF
 
       ON ACTION controlp
           CASE WHEN INFIELD(msm01) #生產
#FUN-AA0059 --Begin--
                  # CALL cl_init_qry_var()
                  # LET g_qryparam.form = "q_ima"
                  # LET g_qryparam.default1 = g_msm[l_ac].msm01
                  # CALL cl_create_qry() RETURNING g_msm[l_ac].msm01
#                 #  CALL FGL_DIALOG_SETBUFFER( g_msm[l_ac].msm01 )
                      CALL q_sel_ima(FALSE, "q_ima", "", g_msm[l_ac].msm01, "", "", "", "" ,"",'' )  RETURNING g_msm[l_ac].msm01
#FUN-AA0059 --End--
                      DISPLAY g_msm[l_ac].msm01 TO msm01            #No.MOD-490371
                     NEXT FIELD msm01
                WHEN INFIELD(msm02) #交貨地址
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.default1 = g_msm[l_ac].msm02
                     LET g_qryparam.default2 = ""
                     LET g_qryparam.arg1 =g_msm[l_ac].msm02 
                     LET g_qryparam.arg2 ="" 
                     CALL cl_create_qry() RETURNING g_msm[l_ac].msm02
#                     CALL FGL_DIALOG_SETBUFFER( g_msm[l_ac].msm02 )
                      DISPLAY g_msm[l_ac].msm02 TO msm02            #No.MOD-490371
                     NEXT FIELD msm02
                WHEN INFIELD(msm03) #倉庫
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_imd"
                     LET g_qryparam.default1 = g_msm[l_ac].msm03
                     #LET g_qryparam.default2 = "A"         #MOD-4A0213
                      LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                     CALL cl_create_qry() RETURNING g_msm[l_ac].msm03
#                     CALL FGL_DIALOG_SETBUFFER( g_msm[l_ac].msm03 )
                      DISPLAY g_msm[l_ac].msm03 TO msm03            #No.MOD-490371
                     NEXT FIELD msm03
                WHEN INFIELD(msm06) #生產
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = g_msm[l_ac].msm06
                     CALL cl_create_qry() RETURNING g_msm[l_ac].msm06
#                     CALL FGL_DIALOG_SETBUFFER( g_msm[l_ac].msm06 )
                      DISPLAY g_msm[l_ac].msm06 TO msm06           #No.MOD-490371
                     NEXT FIELD msm06
                OTHERWISE
           END CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
        
        END INPUT
 
    CLOSE i700_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i700_b_askkey()
    CLEAR FORM
   CALL g_msm.clear()
    CONSTRUCT g_wc2 ON msm01,msm02,msm03,msm06,msm07
            FROM s_msm[1].msm01,s_msm[1].msm02,s_msm[1].msm03,s_msm[1].msm06,
                 s_msm[1].msm07
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION controlp
           CASE WHEN INFIELD(msm01) #生產
#FUN-AA0059 --Begin--
                  #  CALL cl_init_qry_var()
                  #  LET g_qryparam.state="c"
                  #  LET g_qryparam.form = "q_ima"
                  #  LET g_qryparam.default1 = g_msm[1].msm01
                  #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","",g_msm[1].msm01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO msm01          #No.MOD-490371
                     NEXT FIELD msm01
                WHEN INFIELD(msm02) #交貨地址
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.default1 = g_msm[1].msm02
                     LET g_qryparam.default2 = ""
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO msm02         #No.MOD-490371
                     NEXT FIELD msm02
                WHEN INFIELD(msm03) #倉庫
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form = "q_imd"
                     LET g_qryparam.default1 = g_msm[1].msm03
                     #LET g_qryparam.default2 = "A"         #MOD-4A0213
                      LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO msm03         #No.MOD-490371
                     NEXT FIELD msm03
                WHEN INFIELD(msm06) #生產
                     CALL cl_init_qry_var()
                     LET g_qryparam.state="c"
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = g_msm[1].msm06
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO msm06           #No.MOD-490371
                     NEXT FIELD msm06
                OTHERWISE
           END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    LET g_msm_pamsmo = 1
    CALL i700_b_fill(g_wc2)
END FUNCTION
   
FUNCTION i700_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680082 VARCHAR(200)
 
    LET g_sql =
        "SELECT msm01,ima02,msm02,msm03,msm06,msm07 ",
        " FROM msm_file,ima_file",
        " WHERE msm01 = ima01 AND ",p_wc2 clipped,
        " ORDER BY 1"
    PREPARE i700_pb FROM g_sql
    DECLARE msm_curs CURSOR FOR i700_pb
    FOR g_cnt = 1 TO g_msm.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_msm[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH msm_curs INTO g_msm[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    MESSAGE ""
    CALL g_msm.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
    
FUNCTION i700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680082 VARCHAR(1)
 
 
  #IF p_ud <> "G" THEN    #TQC-D40025 MARK
   IF p_ud <> "G" OR g_action_choice = "detail"  THEN #TQC-D40025 Add 
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_msm TO s_msm.*
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
       ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0013
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#NO.FUN-7C0043 --BEGIN-- --MARK--   
FUNCTION i700_out()
#   DEFINE
#       l_msm           RECORD LIKE msm_file.*,
#       l_i             LIKE type_file.num5,     #No.FUN-680082 SMALLINT
#     # l_name          VARCHAR(20),                # External(Disk) file name
#       l_name          LIKE type_file.chr20,    #No.FUN-680082 VARCHAR(20)
#       l_za05          LIKE za_file.za05       
 DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-7C0043                                                                           
                                                                                                                                    
    IF g_wc2 IS NULL THEN                                                                                                           
       CALL cl_err('','9057',0) RETURN                                                                                              
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd = 'p_query "amri700" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                        
#   IF g_wc2 IS NULL THEN 
#   #  CALL cl_err('',-400,0) 
#      CALL cl_err('','9057',0)
#     RETURN
#   END IF
#   CALL cl_wait()
#  # LET l_name = 'amri700.out'
#   CALL cl_outnam('amri700') RETURNING l_name 
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM msm_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i700_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i700_co                         # SCROLL CURSOR
#       CURSOR FOR i700_p1
 
#   START REPORT i700_rep TO l_name
 
#   FOREACH i700_co INTO l_msm.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i700_rep(l_msm.*)
#   END FOREACH
 
#   FINISH REPORT i700_rep
 
#   CLOSE i700_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#   
#REPORT i700_rep(sr)
#   DEFINE
#       l_ima02         LIKE ima_file.ima02,
#       l_gem02         LIKE gem_file.gem02,
#     # l_trailer_sw    VARCHAR(1),
#       l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680082 VARCHAR(1)       
#       sr              RECORD LIKE msm_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.msm01, sr.msm06
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                 g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#         LET l_ima02 = '  '
#         SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = sr.msm01
#         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.msm06
#         PRINT COLUMN g_c[31],sr.msm01 CLIPPED,
#               COLUMN g_c[32],l_ima02,
#               COLUMN g_c[33],sr.msm02 CLIPPED,
#               COLUMN g_c[34],sr.msm03 CLIPPED,
#               COLUMN g_c[35],sr.msm06 CLIPPED,
#               COLUMN g_c[36],l_gem02,
#               COLUMN g_c[37],sr.msm07 CLIPPED
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#NO.FUN-7C0043 --END-- --MARK--
 
FUNCTION i700_set_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680082 VARCHAR(1)
 
  IF (NOT g_before_input_done) OR INFIELD(msm06) THEN
     CALL cl_set_comp_entry("msm01,msm06",TRUE)
  END IF
END FUNCTION
 
FUNCTION i700_set_no_entry(p_cmd)
DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680082 VARCHAR(1)
 
   #MOD-480152
  IF (p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND NOT g_before_input_done  ) OR
     (p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND INFIELD(msm06)  ) THEN
     CALL cl_set_comp_entry("msm01,msm06",FALSE)
  END IF
  #--
END FUNCTION
