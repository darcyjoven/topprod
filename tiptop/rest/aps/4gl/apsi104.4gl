# Prog. Version..: '5.10.05-08.12.18(00003)'     #
#
# Pattern name...: apsi104.4gl
# Descriptions...: 工作模式資料維護作業
# Date & Author..: 02/03/14 By Mandy
 # Modify.........: 04/07/19 By Wiky Bugno:MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
#
# Modify.........: No:FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No:FUN-720043 07/03/21 By Mandy APS相關調整

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_aps_sae           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        wm_id           LIKE aps_sae.wm_id,
        st_t            LIKE type_file.num10,#FUN-720043 限制不能輸入小數數位
        ed_t            LIKE type_file.num10,#FUN-720043
        wk_type         LIKE aps_sae.wk_type,
        wm_name         LIKE aps_sae.wm_name,
        wm_des          LIKE aps_sae.wm_des
                    END RECORD,
    g_aps_sae_t         RECORD                 #程式變數 (舊值)
        wm_id           LIKE aps_sae.wm_id,
        st_t            LIKE type_file.num10,#FUN-720043
        ed_t            LIKE type_file.num10,#FUN-720043
        wk_type         LIKE aps_sae.wk_type,
        wm_name         LIKE aps_sae.wm_name,
        wm_des          LIKE aps_sae.wm_des
                    END RECORD,
    g_wc2,g_sql     string,  #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_before_input_done LIKE type_file.num5      #No.FUN-570110  #No.FUN-690010 SMALLINT
DEFINE   g_cnt               LIKE type_file.num10     #No.FUN-690010 INTEGER
MAIN
DEFINE l_time        LIKE type_file.chr8,   #計算被使用時間  #No.FUN-690010 VARCHAR(8)
       p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF


      CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818
        RETURNING l_time
    LET p_row = 2 LET p_col = 6
    OPEN WINDOW i104_w AT p_row,p_col WITH FORM "aps/42f/apsi104"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()


    LET g_wc2 = '1=1' CALL i104_b_fill(g_wc2)
    CALL i104_menu()
    CLOSE WINDOW i104_w                 #結束畫面
      CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818
        RETURNING l_time
END MAIN

FUNCTION i104_menu()

   WHILE TRUE
      CALL i104_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i104_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i104_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i104_q()
   CALL i104_b_askkey()
END FUNCTION

FUNCTION i104_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用         #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否         #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態           #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1    #No.FUN-690010 VARCHAR(01)

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT wm_id,st_t,ed_t,wk_type,wm_name,wm_des FROM aps_sae WHERE wm_id = ? AND st_t = ? FOR UPDATE NOWAIT"

    DECLARE i104_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

        INPUT ARRAY g_aps_sae WITHOUT DEFAULTS FROM s_aps.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET g_aps_sae_t.* = g_aps_sae[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
#No.FUN-570110--begin
               LET g_before_input_done = FALSE
               CALL i104_set_entry_b(p_cmd)
               CALL i104_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570110--end
               LET g_aps_sae_t.* = g_aps_sae[l_ac].*  #BACKUP
               BEGIN WORK
               OPEN i104_bcl USING g_aps_sae_t.wm_id,g_aps_sae_t.st_t
               IF STATUS THEN
                  CALL cl_err("OPEN i104_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i104_bcl INTO g_aps_sae[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD wm_id

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin
            LET g_before_input_done = FALSE
            CALL i104_set_entry_b(p_cmd)
            CALL i104_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110--end          #No.FUN-570110--begin
            LET g_before_input_done = FALSE
            CALL i104_set_entry_b(p_cmd)
            CALL i104_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110--end
            INITIALIZE g_aps_sae[l_ac].* TO NULL
            #FUN-720043-------add----------str------
            LET g_aps_sae[l_ac].st_t = 0
            LET g_aps_sae[l_ac].ed_t = 0
            LET g_aps_sae[l_ac].wk_type = 0       
            #FUN-720043-------add----------end------
            LET g_aps_sae_t.* = g_aps_sae[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD wm_id

      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO aps_sae(wm_id,st_t,ed_t,wk_type,wm_name,wm_des) #No.MOD-470041
             VALUES(g_aps_sae[l_ac].wm_id,
                    g_aps_sae[l_ac].st_t,
                    g_aps_sae[l_ac].ed_t,
                    g_aps_sae[l_ac].wk_type,
                    g_aps_sae[l_ac].wm_name,
                    g_aps_sae[l_ac].wm_des)
         IF SQLCA.sqlcode THEN
#             CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
            CALL cl_err3("ins","aps_sae",g_aps_sae[l_ac].wm_id,g_aps_sae[l_ac].st_t,SQLCA.sqlcode,"","",1)  # Fun - 660095
             LET g_aps_sae[l_ac].* = g_aps_sae_t.*
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

        AFTER FIELD st_t               #check 編號是否重複
            IF NOT cl_null(g_aps_sae[l_ac].st_t) THEN
            IF (g_aps_sae_t.wm_id != g_aps_sae[l_ac].wm_id OR
                g_aps_sae_t.st_t != g_aps_sae[l_ac].st_t OR
                p_cmd='a') THEN
                SELECT count(*) INTO l_n FROM aps_sae
                 WHERE wm_id      = g_aps_sae[l_ac].wm_id
                   AND st_t = g_aps_sae[l_ac].st_t
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_aps_sae[l_ac].wm_id = g_aps_sae_t.wm_id
                    LET g_aps_sae[l_ac].st_t = g_aps_sae_t.st_t
                    NEXT FIELD st_t
                END IF
            END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_aps_sae_t.wm_id) THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM aps_sae
                 WHERE wm_id = g_aps_sae_t.wm_id
                   AND st_t = g_aps_sae_t.st_t
                IF SQLCA.sqlcode THEN
 #                  CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
                CALL cl_err3("del","aps_sae",g_aps_sae_t.wm_id,g_aps_sae_t.st_t,SQLCA.sqlcode,"","",1)  # Fun - 660095
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i104_bcl
                COMMIT WORK
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_aps_sae[l_ac].* = g_aps_sae_t.*
              CLOSE i104_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_aps_sae[l_ac].wm_id,-263,1)
              LET g_aps_sae[l_ac].* = g_aps_sae_t.*
           ELSE
              UPDATE aps_sae SET wm_id = g_aps_sae[l_ac].wm_id,
                                 st_t  = g_aps_sae[l_ac].st_t,
                                 ed_t = g_aps_sae[l_ac].ed_t,
                                 wk_type = g_aps_sae[l_ac].wk_type,
                                 wm_name = g_aps_sae[l_ac].wm_name,
                                 wm_des = g_aps_sae[l_ac].wm_des
               WHERE CURRENT OF i104_bcl
              IF SQLCA.sqlcode THEN
 #                 CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
                CALL cl_err3("upd","aps_sae",g_aps_sae_t.wm_id,g_aps_sae_t.st_t,SQLCA.sqlcode,"","",1)  # Fun - 660095
                  LET g_aps_sae[l_ac].* = g_aps_sae_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i104_bcl
                  COMMIT WORK
              END IF
           END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aps_sae[l_ac].* = g_aps_sae_t.*
               END IF
               CLOSE i104_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i104_bcl
            COMMIT WORK

        ON ACTION CONTROLN
            CALL i104_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(wm_id) AND l_ac > 1 THEN
                LET g_aps_sae[l_ac].* = g_aps_sae[l_ac-1].*
                NEXT FIELD wm_id
            END IF

        ON ACTION CONTROLZ
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

    CLOSE i104_bcl
    COMMIT WORK
    OPTIONS
        INSERT KEY F1,
        DELETE KEY F2
END FUNCTION

FUNCTION i104_b_askkey()
    CLEAR FORM
    CALL g_aps_sae.clear()
    CONSTRUCT g_wc2 ON wm_id,st_t,ed_t,wk_type,wm_name,wm_des
            FROM s_aps[1].wm_id,  s_aps[1].st_t, s_aps[1].ed_t,
                 s_aps[1].wk_type,s_aps[1].wm_name,    s_aps[1].wm_des
              #No:FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No:FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i104_b_fill(g_wc2)
END FUNCTION

FUNCTION i104_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(500)

    LET g_sql =
        "SELECT wm_id,st_t,ed_t,wk_type,wm_name,wm_des,'' ",
        "  FROM aps_sae",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY wm_id"
    PREPARE i104_pb FROM g_sql
    DECLARE aps_sae_curs CURSOR FOR i104_pb

    CALL g_aps_sae.clear()
    LET g_cnt = 1
    FOREACH aps_sae_curs INTO g_aps_sae[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aps_sae.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION i104_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aps_sae TO s_aps.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
 

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-570110--begin
FUNCTION i104_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("wm_id,st_t",TRUE)
   END IF
END FUNCTION
 
FUNCTION i104_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("wm_id,st_t",FALSE)
   END IF
END FUNCTION
#No.FUN-570110--end
#Patch....NO:TQC-610036 <001> #
