# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: asfi3016.4gl
# Date & Author..: 99/05/26 By Carol 
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.MOD-840547 08/04/22 By kim GP5.1顧問測試修改
# Modify.........: No.TQC-920027 09/02/12 By alex 移除本作業內的cl_used
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0147 09/11/23 By lilingyu 維護產品序號時,在輸入完第一個產品序號后,光標跳到另外一行時,程序當出
# Modify.........: No.FUN-A80102 10/08/24 By kim GP5.25號機管理
# Modify.........: No.FUN-A90057 10/09/27 By kim GP5.25號機管理
# Modify.........: No.TQC-B60306 11/06/23 By lixh1 增加對號機管理的控管
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_she           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        she02          LIKE she_file.she02      #序號
                       END RECORD 
DEFINE g_she_t         RECORD                   #程式變數 (舊值)
        she02          LIKE she_file.she02      #序號
                       END RECORD 
DEFINE g_wc2,g_sql     STRING   
DEFINE g_cmd           LIKE type_file.chr1000   #No.FUN-680121 VARCHAR(80)
DEFINE g_she01         LIKE she_file.she01
DEFINE g_rec_b         LIKE type_file.num5      #單身筆數        #No.FUN-680121 SMALLINT
DEFINE l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
DEFINE g_forupd_sql    STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5 #No.FUN-680121 SMALLINT
DEFINE g_cnt           LIKE type_file.num10     #No.FUN-680121 INTEGER
 
FUNCTION i301_6(p_sfb01)
 
    DEFINE p_sfb01    LIKE sfb_file.sfb01 
 
    LET g_she01=p_sfb01 
 
    OPEN WINDOW i3016_w WITH FORM "asf/42f/asfi301s"   #TQC-920027
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_locale("asfi301s")
 
    DISPLAY g_she01 TO FORMONLY.sfb01 
    LET g_wc2 = '1=1' CALL i3016_b_fill(g_wc2)
    #FUN-A80102(S)
    IF g_sma.sma1424='Y' THEN
       CALL cl_set_act_visible("gen_machine",TRUE)
    ELSE
       CALL cl_set_act_visible("gen_machine",FALSE)
    END IF
    #FUN-A80102(E)
    CALL i3016_menu()
 
    CLOSE WINDOW i3016_w                 #結束畫面
 
END FUNCTION
 
 
 
FUNCTION i3016_menu()
 
   WHILE TRUE
      CALL i3016_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i3016_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i3016_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #FUN-A80102(S)
         WHEN "gen_machine"
            IF cl_chk_act_auth() THEN
               CALL i3016_gen_machine()
            END IF
         #FUN-A80102(E)
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i3016_q()
   CALL i3016_b_askkey()
END FUNCTION
 
FUNCTION i3016_b()
DEFINE
    l_ac_t           LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_n              LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw        LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd            LIKE type_file.chr1,                 #處理狀態        #No.FUN-680121 VARCHAR(1)
    l_allow_insert   LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete   LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT she02 FROM she_file ",
                       " WHERE she01= ? AND she02= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i3016_bcl CURSOR FROM g_forupd_sql   
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b=0 THEN CALL g_she.clear() END IF
 
    INPUT ARRAY g_she WITHOUT DEFAULTS FROM s_she.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK  #MOD-9B0147
            IF g_rec_b >= l_ac THEN
           #    BEGIN WORK  #MOD-9B0147
               LET p_cmd='u'
               LET g_she_t.* = g_she[l_ac].*         #BACKUP
               OPEN i3016_bcl USING g_she01,g_she[l_ac].she02
               IF STATUS THEN
                  CALL cl_err("OPEN i3016_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i3016_bcl INTO g_she[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_she_t.she02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF 
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO she_file(she01,she02,sheplant,shelegal)             #FUN-980008 add
                          VALUES(g_she01,g_she[l_ac].she02,g_plant,g_legal) #FUN-980008 add
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_she[l_ac].she02,SQLCA.sqlcode,0)   #No.FUN-660128
                CALL cl_err3("ins","she_file",g_she01,g_she[l_ac].she02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_she[l_ac].* TO NULL      #900423
            LET g_she_t.* = g_she[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD she02
 
        AFTER FIELD she02                        #check 編號是否重複
            IF NOT cl_null(g_she[l_ac].she02) 
               AND (g_she[l_ac].she02!=g_she_t.she02) AND g_she_t.she02 is not null THEN
                   SELECT count(*) INTO l_n FROM she_file
                    WHERE she01=g_she01 AND she02=g_she[l_ac].she02
                   IF l_n > 0 THEN
                      CALL cl_err('','-239',0)
                      LET g_she[l_ac].she02 = g_she_t.she02
                      NEXT FIELD she02
                   END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_she_t.she02 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               DELETE FROM she_file 
                WHERE she01=g_she01 AND she02 = g_she_t.she02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_she_t.she02,SQLCA.sqlcode,0)   #No.FUN-660128
                  CALL cl_err3("del","she_file",g_she01,g_she_t.she02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
              # COMMIT WORK  #MOD-9B0147
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_she[l_ac].* = g_she_t.*
               CLOSE i3016_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_she[l_ac].she02,-263,1)
               LET g_she[l_ac].* = g_she_t.*
            ELSE
               UPDATE she_file SET she02=g_she[l_ac].she02
                WHERE she01=g_she01 AND she02=g_she_t.she02 
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_she[l_ac].she02,SQLCA.sqlcode,0)   #No.FUN-660128
                  CALL cl_err3("upd","she_file",g_she01,g_she_t.she02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  LET g_she[l_ac].* = g_she_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                 # COMMIT WORK  #MOD-9B0147
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_she[l_ac].* = g_she_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_she.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i3016_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE i3016_bcl
           #COMMIT WORK           #FUN-D40030 Mark
 
#       ON ACTION CONTROLN
#           CALL i3016_b_askkey()
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(she02) AND l_ac > 1 THEN
               LET g_she[l_ac].* = g_she[l_ac-1].*
               NEXT FIELD she02
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
    
    END INPUT
 
    CLOSE i3016_bcl
  #  COMMIT WORK   #MOD-9B0147
 
END FUNCTION
 
FUNCTION i3016_b_askkey()
    CLEAR FORM
    CALL g_she.clear()
    DISPLAY g_she01 TO FORMONLY.sfb01 
    CONSTRUCT g_wc2 ON she02 FROM s_she[1].she02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i3016_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i3016_b_fill(p_wc2)              #BODY FILL UP
    DEFINE p_wc2  STRING 
 
    LET g_sql =
        "SELECT she02 FROM she_file ",
        " WHERE she01 = '",g_she01,"' AND ", p_wc2 CLIPPED,    #單身
        " ORDER BY 1" CLIPPED 
    PREPARE i3016_pb FROM g_sql
    DECLARE she_curs CURSOR FOR i3016_pb
 
    CALL g_she.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH she_curs INTO g_she[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_she.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i3016_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE) #MOD-840547 解除mark
   DISPLAY ARRAY g_she TO s_she.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   #FUN-A80102(S)
   ON ACTION gen_machine
      LET g_action_choice="gen_machine"
      EXIT DISPLAY 
   #FUN-A80102(E)
 
   ON ACTION cancel
      LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION

#FUN-A80102
FUNCTION i3016_gen_machine()
   DEFINE lm RECORD 
                ssn  LIKE she_file.she02
             END RECORD
   DEFINE l_sfb05 LIKE sfb_file.sfb05
   DEFINE l_she02 LIKE she_file.she02
   DEFINE l_sfb08 LIKE sfb_file.sfb08
   DEFINE l_sum_sfb08,l_tol_sfb08 LIKE type_file.num20
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE l_slot,l_elot LIKE shm_file.shm18
   DEFINE lr_sfb919 LIKE sfb_file.sfb919

#TQC-B60306 -------Begin--------
    IF g_sma.sma1424 = 'N' OR cl_null(g_sma.sma1424) THEN
       RETURN
    END IF
#TQC-B60306 -------End----------
    OPEN WINDOW i301h_w WITH FORM "asf/42f/asfi301h"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_locale("asfi301h")
    
    DISPLAY BY NAME lm.ssn
    INPUT BY NAME lm.ssn WITHOUT DEFAULTS
    CLOSE WINDOW i301h_w
    IF lm.ssn IS NOT NULL AND g_she01 IS NOT NULL THEN
       SELECT sfb05,sfb08 INTO l_sfb05,l_sfb08
         FROM sfb_file
        WHERE sfb01=g_she01
       IF l_sfb08 >= 1 THEN
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM she_file WHERE she01=g_she01
          IF l_cnt > 0 THEN
             IF NOT cl_confirm('agl-400') THEN RETURN END IF
          END IF
          DELETE FROM she_file WHERE she01 = g_she01
          LET l_tol_sfb08 = l_sfb08
          LET l_sum_sfb08 = 0
          LET l_cnt = lm.ssn
          WHILE l_sum_sfb08 < l_tol_sfb08
             LET l_sum_sfb08 = l_sum_sfb08 + 1
             INSERT INTO she_file (she01,she02,sheplant,shelegal)
                           VALUES (g_she01,l_cnt,g_plant,g_legal)
             LET l_cnt = l_cnt + 1
          END WHILE
          CALL i3016_b_fill(" 1=1")
          IF g_sma.sma1424='Y' THEN
             LET l_slot = s_machine_en_code(l_sfb05,lm.ssn)
             LET l_elot = s_machine_en_code(l_sfb05,l_cnt-1)  #FUN-A90057
             LET lr_sfb919=l_slot CLIPPED
             IF NOT cl_null(l_elot) THEN
                LET lr_sfb919 = lr_sfb919 , '-', l_elot CLIPPED                
             END IF
             UPDATE sfb_file set sfb919= lr_sfb919 WHERE sfb01=g_she01
          END IF
       END IF
    END IF
END FUNCTION
