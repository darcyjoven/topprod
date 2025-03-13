# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: aqci103.4gl
# Descriptions...: C=0檢驗水準樣本代碼資料建立作業
# Date & Author..: 00/12/14 By jacky
# Modify.........: No.MOD-470041 04/07/22 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-710119 07/03/29 By Ray 畫面上增加筆數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A60132 10/07/19 By chenmoyan 鎖表語句不標準
# Modify.........: No:FUN-D30034 13/04/17 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_qcj           DYNAMIC ARRAY OF RECORD
                    qcj01         LIKE qcj_file.qcj01,
                    qcj02         LIKE qcj_file.qcj02,
                    qcj03         LIKE qcj_file.qcj03,
                    qcj04         LIKE qcj_file.qcj04,
                    qcj05         LIKE qcj_file.qcj05
                    END RECORD,
    g_qcj_t         RECORD
                    qcj01         LIKE qcj_file.qcj01,
                    qcj02         LIKE qcj_file.qcj02,
                    qcj03         LIKE qcj_file.qcj03,
                    qcj04         LIKE qcj_file.qcj04,
                    qcj05         LIKE qcj_file.qcj05
                    END RECORD,
    g_wc2,g_sql     STRING,                             #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
 
DEFINE g_forupd_sql STRING                              #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570109        #No.FUN-680104 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10           #No.FUN-680104 INTEGER


MAIN
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
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0085

    OPEN WINDOW i103_w WITH FORM "aqc/42f/aqci103"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i103_b_fill(g_wc2)
    CALL i103_menu()

    CLOSE WINDOW i103_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0085
END MAIN
 
FUNCTION i103_menu()
 
   WHILE TRUE
      CALL i103_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i103_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i103_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcj),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i103_q()
   CALL i103_b_askkey()
END FUNCTION
 
FUNCTION i103_b()
DEFINE
    l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT #No.FUN-680104 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,        #檢查重複用 #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,        #單身鎖住否 #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,        #處理狀態   #No.FUN-680104 VARCHAR(1)
    max_qcj02       LIKE qcj_file.qcj02,
    l_allow_insert  LIKE type_file.chr1,        #No.FUN-680104 VARCHAR(1) #可新增否
    l_allow_delete  LIKE type_file.chr1         #No.FUN-680104 VARCHAR(1) #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT qcj01,qcj02,qcj03,qcj04,qcj05 FROM qcj_file ",
                        " WHERE qcj01 = ? AND qcj02 = ? AND qcj03 = ? AND qcj04 = ? FOR UPDATE "   #TQC-A60132
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

    DECLARE i103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_qcj WITHOUT DEFAULTS FROM s_qcj.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
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
                BEGIN WORK
                LET p_cmd='u'
                LET g_qcj_t.* = g_qcj[l_ac].*  #BACKUP
#No.FUN-570109 --start
                LET g_before_input_done = FALSE
                CALL i103_set_entry(p_cmd)
                CALL i103_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
#No.FUN-570109 --end
                OPEN i103_bcl USING g_qcj_t.qcj01,g_qcj_t.qcj02,
                                    g_qcj_t.qcj03,g_qcj_t.qcj04
                IF STATUS THEN
                   CALL cl_err("OPEN i103_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                END IF
                FETCH i103_bcl INTO g_qcj[l_ac].*
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_qcj_t.qcj01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start
            LET g_before_input_done = FALSE
            CALL i103_set_entry(p_cmd)
            CALL i103_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570109 --end
            INITIALIZE g_qcj[l_ac].* TO NULL      #900423
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            LET g_qcj_t.* = g_qcj[l_ac].*         #新輸入資料
 
        AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE i103_bcl
#            CALL g_qcj.deleteElement(l_ac)
#           IF g_rec_b != 0 THEN
#              LET g_action_choice = "detail"
#              LET l_ac = l_ac_t
#           END IF
#           EXIT INPUT
         END IF
          INSERT INTO qcj_file (qcj01,qcj02,qcj03,qcj04,qcj05)   #No.MOD-470041
              VALUES(g_qcj[l_ac].qcj01,g_qcj[l_ac].qcj02,g_qcj[l_ac].qcj03,
                     g_qcj[l_ac].qcj04,g_qcj[l_ac].qcj05)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_qcj[l_ac].qcj01,SQLCA.sqlcode,0)   #No.FUN-660115
            CALL cl_err3("ins","qcj_file",g_qcj[l_ac].qcj01,g_qcj[l_ac].qcj02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2      #No.TQC-710119
         END IF
 
        BEFORE FIELD qcj01
            IF cl_null(g_qcj[l_ac].qcj01) OR g_qcj[l_ac].qcj01 = 0 THEN
                SELECT max(qcj02) INTO g_qcj[l_ac].qcj01
                  FROM qcj_file
                IF g_qcj[l_ac].qcj01 = 999999 THEN
                   MESSAGE ' '
#                  EXIT WHILE
                END IF
                LET g_qcj[l_ac].qcj01 = g_qcj[l_ac].qcj01 + 1
                IF cl_null(g_qcj[l_ac].qcj01) THEN
                    LET g_qcj[l_ac].qcj01 = 1
                END IF
            END IF
 
        AFTER FIELD qcj02
            IF NOT cl_null(g_qcj[l_ac].qcj02) THEN
               IF g_qcj[l_ac].qcj02 < g_qcj[l_ac].qcj01 THEN
                  NEXT FIELD qcj02
               END IF
            END IF
 
        AFTER FIELD qcj04                        #check 序號是否重複
          IF NOT cl_null(g_qcj[l_ac].qcj04) THEN
            IF g_qcj[l_ac].qcj04 NOT MATCHES '[1234]' THEN
               NEXT FIELD qcj04
            END IF
            IF NOT cl_null(g_qcj[l_ac].qcj03) THEN
               IF g_qcj[l_ac].qcj01 != g_qcj_t.qcj01 OR
                  g_qcj[l_ac].qcj02 != g_qcj_t.qcj02 OR
                  g_qcj[l_ac].qcj03 != g_qcj_t.qcj03 OR
                  g_qcj[l_ac].qcj04 != g_qcj_t.qcj04 OR
                  g_qcj_t.qcj01 IS NULL OR
                  g_qcj_t.qcj02 IS NULL OR
                  g_qcj_t.qcj03 IS NULL OR
                  g_qcj_t.qcj04 IS NULL THEN
                  SELECT count(*) INTO l_n FROM qcj_file
                   WHERE qcj01 = g_qcj[l_ac].qcj01
                     AND qcj02 = g_qcj[l_ac].qcj02
                     AND qcj03 = g_qcj[l_ac].qcj03
                     AND qcj04 = g_qcj[l_ac].qcj04
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_qcj[l_ac].qcj01 = g_qcj_t.qcj01
                     LET g_qcj[l_ac].qcj02 = g_qcj_t.qcj02
                     LET g_qcj[l_ac].qcj03 = g_qcj_t.qcj03
                     LET g_qcj[l_ac].qcj04 = g_qcj_t.qcj04
                     NEXT FIELD qcj01
                  END IF
               END IF
            END IF
          END IF
 
        AFTER FIELD qcj05
            IF NOT cl_null(g_qcj[l_ac].qcj05) THEN
               IF g_qcj[l_ac].qcj05 < 0 THEN
                  NEXT FIELD qcj05
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_qcj_t.qcj01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM qcj_file
                 WHERE qcj01 = g_qcj_t.qcj01
                   AND qcj02 = g_qcj_t.qcj02
                   AND qcj03 = g_qcj_t.qcj03
                   AND qcj04 = g_qcj_t.qcj04
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_qcj_t.qcj01,SQLCA.sqlcode,0)   #No.FUN-660115
                   CALL cl_err3("del","qcj_file",g_qcj_t.qcj01,g_qcj_t.qcj02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
	           ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2      #No.TQC-710119
                MESSAGE "Delete OK"
                CLOSE i103_bcl
                COMMIT WORK
            END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_qcj[l_ac].* = g_qcj_t.*
            CLOSE i103_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_qcj[l_ac].qcj01,-263,1)
            LET g_qcj[l_ac].* = g_qcj_t.*
         ELSE
            UPDATE qcj_file SET
                  qcj01=g_qcj[l_ac].qcj01,
                  qcj02=g_qcj[l_ac].qcj02,
                  qcj03=g_qcj[l_ac].qcj03,
                  qcj04=g_qcj[l_ac].qcj04,
                  qcj05=g_qcj[l_ac].qcj05
            WHERE qcj01 = g_qcj_t.qcj01
              AND qcj02 = g_qcj_t.qcj02
              AND qcj03 = g_qcj_t.qcj03
              AND qcj04 = g_qcj_t.qcj04
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_qcj[l_ac].qcj01,SQLCA.sqlcode,0)   #No.FUN-660115
               CALL cl_err3("upd","qcj_file",g_qcj_t.qcj01,g_qcj_t.qcj02,SQLCA.sqlcode,"","",1)  #No.FUN-660115
               LET g_qcj[l_ac].* = g_qcj_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i103_bcl
               COMMIT WORK
            END IF
          END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_qcj[l_ac].* = g_qcj_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_qcj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE i103_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i103_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL i103_b_askkey()
#           LET l_exit_sw = "n"
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(qcj01) AND l_ac > 1 THEN
                LET g_qcj[l_ac].* = g_qcj[l_ac-1].*
                NEXT FIELD qcj01
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
 
    CLOSE i103_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_b_askkey()
   CLEAR FORM
   CALL g_qcj.clear()
    CONSTRUCT g_wc2 ON qcj01,qcj02,qcj03,qcj04,qcj05
            FROM s_qcj[1].qcj01,s_qcj[1].qcj02,
                 s_qcj[1].qcj03,s_qcj[1].qcj04,
                 s_qcj[1].qcj05
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
    CALL i103_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i103_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    LET g_sql =
        "SELECT qcj01,qcj02,qcj03,qcj04,qcj05 ",
        " FROM qcj_file  ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 3,1,2"
 
    PREPARE i103_pb FROM g_sql
    DECLARE qcj_curs CURSOR FOR i103_pb
 
    CALL g_qcj.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH qcj_curs INTO g_qcj[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_qcj.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2      #No.TQC-710119
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_qcj TO s_qcj.* ATTRIBUTE(COUNT=g_rec_b)
 
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
FUNCTION i103_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("qcj01,qcj02,qcj03,qcj04",TRUE)
   END IF
END FUNCTION
 
FUNCTION i103_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("qcj01,qcj02,qcj03,qcj04",FALSE)
   END IF
END FUNCTION
#No.FUN-570109 --end
#Patch....NO.TQC-610036 <001> #
