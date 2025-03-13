# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: ammt100_a.4gl
# Descriptions...: 其他費用資料維護
# Date & Author..: 01/09/19 BY Wiky
# Modify.........: No.FUN-4B0036 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-750220 07/05/28 By jamie mark action"export" 
# Modify.........: No.FUN-980004 09/08/28 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_mmn           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        mmn03       LIKE mmn_file.mmn03,
        mmn04       LIKE mmn_file.mmn04,
        mmn05       LIKE mmn_file.mmn05
                    END RECORD,
    g_mmn_t         RECORD                 #程式變數 (舊值)
        mmn03       LIKE mmn_file.mmn03,
        mmn04       LIKE mmn_file.mmn04,
        mmn05       LIKE mmn_file.mmn05
                    END RECORD,
    g_argv1         LIKE mmg_file.mmg01,
    g_argv2         LIKE mmg_file.mmg02,
    g_wc2,g_sql     STRING,  #No.FUN-580092 HCN        #No.FUN-680100
    g_rec_b         LIKE type_file.num5,               #單身筆數        #No.FUN-680100 SMALLINT
    l_ac            LIKE type_file.num5,               #目前處理的ARRAY CNT        #No.FUN-680100 SMALLINT
    l_sl            LIKE type_file.num5,         #No.FUN-680100 SMALLINT#目前處理的SCREEN LINE
    p_row,p_col     LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680100
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680100 INTEGER
 
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0076
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
    LET g_argv1 =ARG_VAL(1)
    LET g_argv2 =ARG_VAL(2)
    LET p_row = 4 LET p_col = 12
    OPEN WINDOW t100_a_w AT p_row,p_col WITH FORM "amm/42f/ammt100_a"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
     IF NOT cl_null(g_argv1) THEN
        LET g_wc2 = " mmn01 = '",g_argv1,"' AND mmn02 = '",g_argv2,"'"
        CALL t100_a_b_fill(g_wc2)
    ELSE
        LET g_wc2 = '1=1' CALL t100_a_b_fill(g_wc2)
    END IF
    CALL t100_a_menu()
    CLOSE WINDOW t100_a_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
 
FUNCTION t100_a_menu()
 
   WHILE TRUE
      CALL t100_a_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t100_a_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t100_a_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     #FUN-4B0036
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mmn),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t100_a_q()
   CALL t100_a_b_askkey()
END FUNCTION
 
FUNCTION t100_a_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680100 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680100 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680100 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680100 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #No.FUN-680100 VARCHAR(1)#可新增否
    l_allow_delete  LIKE type_file.chr1                 #No.FUN-680100 VARCHAR(1)#可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT mmn03,mmn04,mmn05 FROM mmn_file ",
                       "  WHERE mmn01=?                         ",
                       "    AND mmn02=?                         ",
                       "    AND mmn03=?             FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t100_a_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_mmn WITHOUT DEFAULTS FROM s_mmn.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_mmn_t.* = g_mmn[l_ac].*  #BACKUP
 
                OPEN t100_a_bcl USING g_argv1,g_argv2,g_mmn_t.mmn03
                IF STATUS THEN
                   CALL cl_err("OPEN t100_a_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                FETCH t100_a_bcl INTO g_mmn[l_ac].*
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_mmn_t.mmn03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD mmn03
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_mmn[l_ac].* TO NULL      #900423
            LET g_mmn_t.* = g_mmn[l_ac].*         #新輸入資料
            DISPLAY g_mmn[l_ac].* TO s_mmn[l_sl].*
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD mmn03
 
        AFTER INSERT
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE t100_a_bcl
              CANCEL INSERT
           END IF
           INSERT INTO mmn_file(mmn01,mmn02,mmn03,mmn04,mmn05,mmnplant,mmnlegal) #FUN-980004 add mmnplant,mmnlegal
                         VALUES(g_argv1,g_argv2,g_mmn[l_ac].mmn03,
                                g_mmn[l_ac].mmn04,g_mmn[l_ac].mmn05,g_plant,g_legal) #FUN-980004 add g_plant,g_legal
           IF SQLCA.sqlcode THEN
#               CALL cl_err(g_mmn[l_ac].mmn03,SQLCA.sqlcode,0) #No.FUN-660094
                CALL cl_err3("ins","mmn_file",g_argv1,g_mmn[l_ac].mmn03,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
               LET g_mmn[l_ac].* = g_mmn_t.*
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
           END IF
 
        BEFORE FIELD mmn03
             IF g_mmn[l_ac].mmn03 IS NULL or g_mmn[l_ac].mmn03 = 0 THEN
                SELECT max(mmn03)+1 INTO g_mmn[l_ac].mmn03 FROM mmn_file
                    WHERE mmn01 = g_argv1
                      AND mmn02 = g_argv2
                IF g_mmn[l_ac].mmn03 IS NULL THEN
                    LET g_mmn[l_ac].mmn03 = 1
                END IF
              END IF
 
        AFTER FIELD mmn03                        #check 編號是否重複
            IF g_mmn[l_ac].mmn03 != g_mmn_t.mmn03 OR
               (g_mmn[l_ac].mmn03 IS NOT NULL AND g_mmn_t.mmn03 IS NULL) THEN
                SELECT count(*) INTO l_n FROM mmn_file
                    WHERE mmn01 =g_argv1
                      AND mmn02 =g_argv2
                      AND mmn03 = g_mmn[l_ac].mmn03
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_mmn[l_ac].mmn03 = g_mmn_t.mmn03
                    NEXT FIELD mmn03
                END IF
            END IF
 
        AFTER FIELD mmn05
            IF g_mmn[l_ac].mmn05<0 THEN NEXT FIELD mmn05 END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_mmn_t.mmn03 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
{ckp#1}         DELETE FROM mmn_file
                 WHERE mmn01 = g_argv1
                   AND mmn02 = g_argv2
                   AND mmn03 = g_mmn_t.mmn03
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_mmn_t.mmn03,SQLCA.sqlcode,0) #No.FUN-660094
                     CALL cl_err3("del","mmn_file",g_argv1,g_mmn_t.mmn03,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                MESSAGE "Delete OK"
                CLOSE t100_a_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_mmn[l_ac].* = g_mmn_t.*
            CLOSE t100_a_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_mmn[l_ac].mmn03,-263,1)
             LET g_mmn[l_ac].* = g_mmn_t.*
         ELSE
             UPDATE mmn_file SET mmn03=g_mmn[l_ac].mmn03,
                                 mmn04=g_mmn[l_ac].mmn04,
                                 mmn05=g_mmn[l_ac].mmn05
              WHERE CURRENT OF t100_a_bcl
             IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_mmn[l_ac].mmn03,SQLCA.sqlcode,0) #No.FUN-660094
                  CALL cl_err3("upd","mmn_file",g_argv1,g_mmn[l_ac].mmn03,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
                 LET g_mmn[l_ac].* = g_mmn_t.*
             ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE t100_a_bcl
                 COMMIT WORK
             END IF
         END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_mmn[l_ac].* = g_mmn_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_mmn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t100_a_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE t100_a_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(mmn03) AND l_ac > 1 THEN
                LET g_mmn[l_ac].* = g_mmn[l_ac-1].*
                DISPLAY g_mmn[l_ac].* TO s_mmn[l_sl].*
                NEXT FIELD mmn03
            END IF
 
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
 
    CLOSE t100_a_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION t100_a_b_askkey()
    CLEAR FORM
   CALL g_mmn.clear()
    CONSTRUCT g_wc2 ON mmn03,mmn04,mmn05
            FROM s_mmn[1].mmn03,s_mmn[1].mmn04,s_mmn[1].mmn05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t100_a_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t100_a_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2         LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(200)
 
    LET g_sql =
        "SELECT mmn03,mmn04,mmn05",
        " FROM mmn_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE t100_a_pb FROM g_sql
    DECLARE mmn_curs CURSOR FOR t100_a_pb
 
    CALL g_mmn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH mmn_curs INTO g_mmn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_mmn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t100_a_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mmn TO s_mmn.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         LET l_ac = 1
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
 
      #TQC-750220 str
      #ON ACTION export
      #   CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mmn),'','')
      #   EXIT DISPLAY
      #TQC-750220 end
 
      ON ACTION exporttoexcel       #FUN-4B0036
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
 
END FUNCTION
#Patch....NO.TQC-610035 <> #
