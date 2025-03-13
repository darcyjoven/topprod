# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: aqci600.4gl
# Descriptions...: 管制圖管制作業因數表維護
# Date & Author..: 00/04/24 By Melody
# Modify.........: No.MOD-470041 04/07/22 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
 
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/16 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_qda           DYNAMIC ARRAY OF RECORD
                    qda01         LIKE qda_file.qda01,
                    qda021        LIKE qda_file.qda021,
                    qda022        LIKE qda_file.qda022,
                    qda023        LIKE qda_file.qda023,
                    qda041        LIKE qda_file.qda041,
                    qda042        LIKE qda_file.qda042,
                    qda043        LIKE qda_file.qda043,
                    qda044        LIKE qda_file.qda044,
                    qda045        LIKE qda_file.qda045,
                    qda046        LIKE qda_file.qda046
                    END RECORD,
    g_qda_t         RECORD
                    qda01         LIKE qda_file.qda01,
                    qda021        LIKE qda_file.qda021,
                    qda022        LIKE qda_file.qda022,
                    qda023        LIKE qda_file.qda023,
                    qda041        LIKE qda_file.qda041,
                    qda042        LIKE qda_file.qda042,
                    qda043        LIKE qda_file.qda043,
                    qda044        LIKE qda_file.qda044,
                    qda045        LIKE qda_file.qda045,
                    qda046        LIKE qda_file.qda046
                    END RECORD,
    g_wc2,g_sql,g_cmd    STRING,                        #No.FUN-680104  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
 
DEFINE g_forupd_sql          STRING                     #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570109        #No.FUN-680104 SMALLINT
DEFINE g_cnt                 LIKE type_file.num10       #No.FUN-680104 INTEGER
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0085
DEFINE p_row,p_col   LIKE type_file.num5                #No.FUN-680104 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    LET p_row = 3 LET p_col = 4
    OPEN WINDOW i600_w AT p_row,p_col WITH FORM "aqc/42f/aqci600"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i600_b_fill(g_wc2)
    CALL i600_menu()
    CLOSE WINDOW i600_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
FUNCTION i600_menu()
 
   WHILE TRUE
      CALL i600_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i600_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i600_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "標準差管制界限因數維護"
         WHEN "stnd_deviation_ctrl_limit_factor"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun("aqci6001")
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qda),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i600_q()
   CALL i600_b_askkey()
END FUNCTION
 
FUNCTION i600_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT        #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重複用    #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否    #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態      #No.FUN-680104 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT qda01,qda021,qda022,qda023,qda041,qda042,qda043,qda044,qda045,qda046 FROM qda_file WHERE qda01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_qda WITHOUT DEFAULTS FROM s_qda.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_qda_t.* = g_qda[l_ac].*  #BACKUP
#No.FUN-570109 --start
               LET g_before_input_done = FALSE
               CALL i600_set_entry(p_cmd)
               CALL i600_set_no_entry(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570109 --end
               BEGIN WORK
               OPEN i600_bcl USING g_qda_t.qda01
               IF STATUS THEN
                  CALL cl_err("OPEN i600_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i600_bcl INTO g_qda[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_qda_t.qda01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start
            LET g_before_input_done = FALSE
            CALL i600_set_entry(p_cmd)
            CALL i600_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570109 --end
            INITIALIZE g_qda[l_ac].* TO NULL      #900423
            LET g_qda_t.* = g_qda[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
#           CALL g_qda.deleteElement(l_ac)   # 重要
#           IF g_rec_b != 0 THEN
#             LET g_action_choice = "detail"
#           END IF
#           EXIT INPUT
         END IF
          INSERT INTO qda_file (qda01,qda021,qda022,qda023,qda031,qda032,  #No.MOD-470041
                               qda033,qda034,qda035,qda041,qda042,qda043,
                               qda044,qda045,qda046)
              VALUES(g_qda[l_ac].qda01,g_qda[l_ac].qda021,g_qda[l_ac].qda022,
                     g_qda[l_ac].qda023,0,0,0,0,0,g_qda[l_ac].qda041,
                     g_qda[l_ac].qda042,g_qda[l_ac].qda043,g_qda[l_ac].qda044,
                     g_qda[l_ac].qda045,g_qda[l_ac].qda046)
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_qda[l_ac].qda01,SQLCA.sqlcode,0)   #No.FUN-660115
             CALL cl_err3("ins","qda_file",g_qda[l_ac].qda01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
         END IF
 
        BEFORE FIELD qda021
            IF g_qda[l_ac].qda01 IS NOT NULL THEN
               IF g_qda[l_ac].qda01 != g_qda_t.qda01 OR
                  g_qda_t.qda01 IS NULL THEN
                  SELECT count(*)
                    INTO l_n
                    FROM qda_file
                   WHERE qda01 = g_qda[l_ac].qda01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_qda[l_ac].qda01 = g_qda_t.qda01
                     NEXT FIELD qda01
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_qda_t.qda01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM qda_file
                 WHERE qda01 = g_qda_t.qda01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_qda_t.qda01,SQLCA.sqlcode,0)   #No.FUN-660115
                   CALL cl_err3("del","qda_file",g_qda_t.qda01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                MESSAGE "Delete OK"
                CLOSE i600_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_qda[l_ac].* = g_qda_t.*
              CLOSE i600_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_qda[l_ac].qda01,-263,1)
              LET g_qda[l_ac].* = g_qda_t.*
           ELSE
              UPDATE qda_file SET qda01 = g_qda[l_ac].qda01,
                                  qda021= g_qda[l_ac].qda021,
                                  qda022= g_qda[l_ac].qda022,
                                  qda023= g_qda[l_ac].qda023,
                                  qda041= g_qda[l_ac].qda041,
                                  qda042= g_qda[l_ac].qda042,
                                  qda043= g_qda[l_ac].qda043,
                                  qda044= g_qda[l_ac].qda044,
                                  qda045= g_qda[l_ac].qda045,
                                  qda046= g_qda[l_ac].qda046
              WHERE qda01 = g_qda_t.qda01
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_qda[l_ac].qda01,SQLCA.sqlcode,0)   #No.FUN-660115
                  CALL cl_err3("upd","qda_file",g_qda_t.qda01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
                  LET g_qda[l_ac].* = g_qda_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
          END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qda[l_ac].* = g_qda_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qda.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE i600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i600_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i600_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qda01) AND l_ac > 1 THEN
                LET g_qda[l_ac].* = g_qda[l_ac-1].*
                NEXT FIELD qda01
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
 
    CLOSE i600_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i600_b_askkey()
    CLEAR FORM
    CALL g_qda.clear()
    CONSTRUCT g_wc2 ON qda01,qda021,qda022,qda023,qda041,qda042,qda043,
                       qda044,qda045,qda046
            FROM s_qda[1].qda01,
                 s_qda[1].qda021,s_qda[1].qda022,s_qda[1].qda023,
                 s_qda[1].qda041,s_qda[1].qda042,s_qda[1].qda043,
                 s_qda[1].qda044,s_qda[1].qda045,s_qda[1].qda046
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
    CALL i600_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i600_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    LET g_sql =
        "SELECT qda01,qda021,qda022,qda023,qda041,qda042,qda043,",
        "       qda044,qda045,qda046",
        " FROM qda_file  ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE i600_pb FROM g_sql
    DECLARE qda_curs CURSOR FOR i600_pb
 
    CALL g_qda.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH qda_curs INTO g_qda[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_qda.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qda TO s_qda.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #@ON ACTION 標準差管制界限因數維護
      ON ACTION stnd_deviation_ctrl_limit_factor
         LET g_action_choice="stnd_deviation_ctrl_limit_factor"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-570109 --start
FUNCTION i600_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("qda01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i600_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("qda01",FALSE)
   END IF
END FUNCTION
#No.FUN-570109 --end
#Patch....NO.TQC-610036 <001> #
