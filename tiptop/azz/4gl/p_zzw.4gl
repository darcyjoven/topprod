# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: p_zzw.4gl
# Descriptions...: 報表輸出格式參數設定作業
# Date & Author..: 99/10/21 By Frank871
# Modify.........: No.MOD-580056 05/08/05 By yiitng key可更改
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_zzw           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        zzw01       LIKE zzw_file.zzw01,
        zzw02       LIKE zzw_file.zzw02,
        zzw03       LIKE zzw_file.zzw03,
        zzw04       LIKE zzw_file.zzw04,
        zzw05       LIKE zzw_file.zzw05,
        zzw06       LIKE zzw_file.zzw06,
        zzw07       LIKE zzw_file.zzw07,
        zzw08       LIKE zzw_file.zzw08
                    END RECORD,
    g_zzw_t         RECORD                     #程式變數 (舊值)
        zzw01       LIKE zzw_file.zzw01,
        zzw02       LIKE zzw_file.zzw02,
        zzw03       LIKE zzw_file.zzw03,
        zzw04       LIKE zzw_file.zzw04,
        zzw05       LIKE zzw_file.zzw05,
        zzw06       LIKE zzw_file.zzw06,
        zzw07       LIKE zzw_file.zzw07,
        zzw08       LIKE zzw_file.zzw08
                    END RECORD,
     g_wc2,g_sql    string,                    #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,       #單身筆數  #No.FUN-680135 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
 
DEFINE   g_cnt      LIKE type_file.num10       #No.FUN-680135 INTEGER
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
 DEFINE   g_before_input_done LIKE type_file.num5    #NO.MOD-580056  #No.FUN-680135 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0096
   DEFINE    p_row,p_col   LIKE type_file.num5       #No.FUN-680135  SMALLINT 
   OPTIONS                                     #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
   LET p_row = 4 LET p_col =18
   OPEN WINDOW i110_w AT p_row,p_col WITH FORM "azz/42f/p_zzw"
   ATTRIBUTE (STYLE = "sm1")
 
    CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL i110_b_fill(g_wc2)
   CALL i110_menu()
   CLOSE WINDOW i110_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION i110_menu()
   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
           WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL i110_q()
            END IF
           WHEN "detail"
            IF cl_chk_act_auth() THEN
                CALL i110_b()
            ELSE
               LET g_action_choice = NULL
            END IF
          WHEN  "help"
            CALL cl_show_help()
          WHEN  "exit"
            EXIT WHILE
          WHEN  "controlg"
          CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i110_q()
 
   CALL i110_b_askkey()
#  CALL i110_bp('D')
 
END FUNCTION
 
FUNCTION i110_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680135 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680135 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態          #No.FUN-680135 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,      #可新增否          #No.FUN-680135 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否          #No.FUN-680135 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT zzw01,zzw02,zzw03,zzw04,zzw05,zzw06,zzw07,zzw08",
                      "  FROM zzw_file",
                      " WHERE zzw01=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_zzw WITHOUT DEFAULTS FROM s_zzw.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      {
      BEOFRE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
      }
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_zzw_t.* = g_zzw[l_ac].*  #BACKUP
 #No.MOD-580056 --start
            LET g_before_input_done = FALSE
            CALL p_zzw_set_entry_b(p_cmd)
            CALL p_zzw_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 #No.MOD-580056 --end
 
            OPEN i110_bcl USING g_zzw_t.zzw01
            FETCH i110_bcl INTO g_zzw[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_zzw_t.zzw01,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_zzw[l_ac].* TO NULL      #900423
         LET g_zzw[l_ac].zzw03='N'
         LET g_zzw_t.* = g_zzw[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 #No.MOD-580056 --start
         LET g_before_input_done = FALSE
         CALL p_zzw_set_entry_b(p_cmd)
         CALL p_zzw_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
 #No.MOD-580056 --end
         NEXT FIELD zzw01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO zzw_file(zzw01,zzw02,zzw03,zzw04,zzw05,zzw06,zzw07,zzw08)
              VALUES(g_zzw[l_ac].zzw01,g_zzw[l_ac].zzw02,g_zzw[l_ac].zzw03,
                     g_zzw[l_ac].zzw04,g_zzw[l_ac].zzw05,g_zzw[l_ac].zzw06,
                     g_zzw[l_ac].zzw07,g_zzw[l_ac].zzw08)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_zzw[l_ac].zzw01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","zzw_file",g_zzw[l_ac].zzw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      AFTER FIELD zzw01                        #check 編號是否重複
         IF g_zzw[l_ac].zzw01 != g_zzw_t.zzw01 OR
            (g_zzw[l_ac].zzw01 IS NOT NULL AND g_zzw_t.zzw01 IS NULL) THEN
            SELECT count(*) INTO l_n FROM zzw_file
             WHERE zzw01 = g_zzw[l_ac].zzw01
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_zzw[l_ac].zzw01 = g_zzw_t.zzw01
               NEXT FIELD zzw01
            END IF
 
            SELECT COUNT(*) INTO l_n FROM zz_file
             WHERE zz01 = g_zzw[l_ac].zzw01
            IF l_n = 0 THEN
               CALL cl_err(g_zzw[l_ac].zzw01,'mfg9335',0)
               LET g_zzw[l_ac].zzw01 = g_zzw_t.zzw01
               NEXT FIELD zzw01
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_zzw_t.zzw01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM zzw_file WHERE zzw01 = g_zzw_t.zzw01
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zzw_t.zzw01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zzw_file",g_zzw_t.zzw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_zzw[l_ac].* = g_zzw_t.*
            CLOSE i110_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_zzw[l_ac].zzw01,-263,1)
            LET g_zzw[l_ac].* = g_zzw_t.*
         ELSE
            UPDATE zzw_file SET zzw01 = g_zzw[l_ac].zzw01,
                                zzw02 = g_zzw[l_ac].zzw02,
                                zzw03 = g_zzw[l_ac].zzw03,
                                zzw04 = g_zzw[l_ac].zzw04,
                                zzw05 = g_zzw[l_ac].zzw05,
                                zzw06 = g_zzw[l_ac].zzw06,
                                zzw07 = g_zzw[l_ac].zzw07,
                                zzw08 = g_zzw[l_ac].zzw08
             WHERE zzw01=g_zzw_t.zzw01
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_zzw[l_ac].zzw01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","zzw_file",g_zzw_t.zzw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_zzw[l_ac].* = g_zzw_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_zzw[l_ac].* = g_zzw_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_zzw.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i110_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add
         CLOSE i110_bcl
         COMMIT WORK
 
#     ON KEY(CONTROLN)
#        CALL i110_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(zzw01)
         CALL cl_init_qry_var()
         LET g_qryparam.form = "q_zz"
         LET g_qryparam.default1 = g_zzw[l_ac].zzw01
         CALL cl_create_qry() RETURNING g_zzw[l_ac].zzw01
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(zzw01) AND l_ac > 1 THEN
            LET g_zzw[l_ac].* = g_zzw[l_ac-1].*
            NEXT FIELD zzw01
         END IF
 
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
 
   CLOSE i110_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i110_b_askkey()
 
   CLEAR FORM
   CALL g_zzw.clear()
 
   CONSTRUCT g_wc2 ON zzw01,zzw02,zzw03 FROM s_zzw[1].zzw01,s_zzw[1].zzw02,s_zzw[1].zzw03
#TQC-860017 start
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#TQC-860017 end
 
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
   CALL i110_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i110_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(1000)
 
   LET g_sql = "SELECT zzw01,zzw02,zzw03,zzw04,zzw05,zzw06,zzw07,zzw08",
               " FROM zzw_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE i110_pb FROM g_sql
   DECLARE zzw_curs CURSOR FOR i110_pb
 
   CALL g_zzw.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH zzw_curs INTO g_zzw[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_sma.sma115 THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_zzw.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #No.FUN-680135 VARCHAR(1)
 
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_zzw TO s_zzw.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         LET l_ac = 1
 
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
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
     ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_zzw_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("zzw01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_zzw_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("zzw01",FALSE)
   END IF
 
END FUNCTION
 #No.MOD-580056 --end
 
#Patch....NO.TQC-610037 <001> #
