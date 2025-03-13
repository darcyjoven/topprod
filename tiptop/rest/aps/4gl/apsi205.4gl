# Prog. Version..: '5.10.05-08.12.18(00003)'     #
#
# Pattern name...: apsi205.4gl
# Descriptions...: 週行事曆資料維護作業
# Date & Author..: No:FUN-4B0037 04/11/10 By ching
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No:FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No:FUN-720043 07/03/19 By Mandy APS相關調整程式內所有apswcm改成aps_wcm

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_aps_wcm           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables) #FUN-720043程式內所有apswcm改成aps_wcm
        wcaln_id        LIKE aps_wcm.wcaln_id,
        mon_wmid           LIKE aps_wcm.mon_wmid,
        tue_wmid           LIKE aps_wcm.tue_wmid,
        wed_wmid           LIKE aps_wcm.wed_wmid,
        thu_wmid           LIKE aps_wcm.thu_wmid,
        fri_wmid           LIKE aps_wcm.fri_wmid,
        sat_wmid           LIKE aps_wcm.sat_wmid,
        sun_wmid           LIKE aps_wcm.sun_wmid,
        mon_exhr           LIKE aps_wcm.mon_exhr,
        tue_exhr           LIKE aps_wcm.tue_exhr,
        wed_exhr           LIKE aps_wcm.wed_exhr,
        thu_exhr           LIKE aps_wcm.thu_exhr,
        fri_exhr           LIKE aps_wcm.fri_exhr,
        sat_exhr           LIKE aps_wcm.sat_exhr,
        sun_exhr           LIKE aps_wcm.sun_exhr
                    END RECORD,
    g_aps_wcm_t         RECORD                 #程式變數 (舊值)
        wcaln_id        LIKE aps_wcm.wcaln_id,
        mon_wmid           LIKE aps_wcm.mon_wmid,
        tue_wmid           LIKE aps_wcm.tue_wmid,
        wed_wmid           LIKE aps_wcm.wed_wmid,
        thu_wmid           LIKE aps_wcm.thu_wmid,
        fri_wmid           LIKE aps_wcm.fri_wmid,
        sat_wmid           LIKE aps_wcm.sat_wmid,
        sun_wmid           LIKE aps_wcm.sun_wmid,
        mon_exhr           LIKE aps_wcm.mon_exhr,
        tue_exhr           LIKE aps_wcm.tue_exhr,
        wed_exhr           LIKE aps_wcm.wed_exhr,
        thu_exhr           LIKE aps_wcm.thu_exhr,
        fri_exhr           LIKE aps_wcm.fri_exhr,
        sat_exhr           LIKE aps_wcm.sat_exhr,
        sun_exhr           LIKE aps_wcm.sun_exhr
                    END RECORD,
     g_wc2,g_sql    string,  #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl            LIKE type_file.num5    #No.FUN-690010 SMALLINT    # 目前處理的SCREEN LINE

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_before_input_done      LIKE type_file.num5            #No.FUN-570110  #No.FUN-690010 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER

MAIN
DEFINE l_time        LIKE type_file.chr8,                 #計算被使用時間  #No.FUN-690010 VARCHAR(8)
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
    LET p_row = 4 LET p_col = 9
    OPEN WINDOW i205_w AT p_row,p_col WITH FORM "aps/42f/apsi205"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()


    LET g_wc2 = '1=1' CALL i205_b_fill(g_wc2)
    CALL i205_menu()
    CLOSE WINDOW i205_w                 #結束畫面
      CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818
        RETURNING l_time
END MAIN

FUNCTION i205_menu()

   WHILE TRUE
      CALL i205_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i205_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i205_b()
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

FUNCTION i205_q()
   CALL i205_b_askkey()
END FUNCTION

FUNCTION i205_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #No.FUN-690010CHAR(01),
    l_allow_delete  LIKE type_file.chr1    #No.FUN-690010CHAR(01)

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT wcaln_id, " ,
                       " mon_wmid, tue_wmid, wed_wmid, thu_wmid,  ",
                       " fri_wmid, sat_wmid, sun_wmid,            ",
                       " mon_exhr, tue_exhr, wed_exhr, thu_exhr,  ",
                       " fri_exhr, sat_exhr, sun_exhr ",
                       " FROM aps_wcm ",
                       "WHERE wcaln_id = ?  FOR UPDATE NOWAIT "

    DECLARE i205_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

        INPUT ARRAY g_aps_wcm WITHOUT DEFAULTS FROM s_aps.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET g_aps_wcm_t.* = g_aps_wcm[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
#No.FUN-570110--begin
               LET g_before_input_done = FALSE
               CALL i205_set_entry_b(p_cmd)
               CALL i205_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570110--end
               LET g_aps_wcm_t.* = g_aps_wcm[l_ac].*  #BACKUP
               BEGIN WORK
               OPEN i205_bcl USING g_aps_wcm_t.wcaln_id
               IF STATUS THEN
                  CALL cl_err("OPEN i205_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i205_bcl INTO g_aps_wcm[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD wcaln_id

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin
            LET g_before_input_done = FALSE
            CALL i205_set_entry_b(p_cmd)
            CALL i205_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110--end
            INITIALIZE g_aps_wcm[l_ac].* TO NULL
            LET g_aps_wcm_t.* = g_aps_wcm[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD wcaln_id

      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO aps_wcm(wcaln_id, #No.MOD-470041
                            mon_wmid,
                            tue_wmid,
                            wed_wmid,
                            thu_wmid,
                            fri_wmid,
                            sat_wmid,
                            sun_wmid,
                            mon_exhr,
                            tue_exhr,
                            wed_exhr,
                            thu_exhr,
                            fri_exhr,
                            sat_exhr,
                            sun_exhr)
             VALUES(g_aps_wcm[l_ac].wcaln_id,
                    g_aps_wcm[l_ac].mon_wmid,
                    g_aps_wcm[l_ac].tue_wmid,
                    g_aps_wcm[l_ac].wed_wmid,
                    g_aps_wcm[l_ac].thu_wmid,
                    g_aps_wcm[l_ac].fri_wmid,
                    g_aps_wcm[l_ac].sat_wmid,
                    g_aps_wcm[l_ac].sun_wmid,
                    g_aps_wcm[l_ac].mon_exhr,
                    g_aps_wcm[l_ac].tue_exhr,
                    g_aps_wcm[l_ac].wed_exhr,
                    g_aps_wcm[l_ac].thu_exhr,
                    g_aps_wcm[l_ac].fri_exhr,
                    g_aps_wcm[l_ac].sat_exhr,
                    g_aps_wcm[l_ac].sun_exhr)

         IF SQLCA.sqlcode THEN
  #           CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
             CALL cl_err3("ins","aps_wcm",g_aps_wcm[l_ac].wcaln_id,"",SQLCA.sqlcode,"","",1) # FUN-660095
             LET g_aps_wcm[l_ac].* = g_aps_wcm_t.*
             DISPLAY g_aps_wcm[l_ac].* TO s_aps[l_sl].*
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

        AFTER FIELD wcaln_id                #check 編號是否重複
            IF NOT cl_null(g_aps_wcm[l_ac].wcaln_id) THEN
            IF (g_aps_wcm_t.wcaln_id != g_aps_wcm[l_ac].wcaln_id )  OR
               p_cmd='a' THEN
                SELECT count(*) INTO l_n FROM aps_wcm
                 WHERE wcaln_id = g_aps_wcm[l_ac].wcaln_id
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_aps_wcm[l_ac].wcaln_id = g_aps_wcm_t.wcaln_id
                    DISPLAY g_aps_wcm[l_ac].wcaln_id TO s_aps[l_sl].wcaln_id
                    NEXT FIELD wcaln_id
                END IF
            END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_aps_wcm_t.wcaln_id) THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM aps_wcm
                 WHERE wcaln_id = g_aps_wcm_t.wcaln_id
                IF SQLCA.sqlcode THEN
  #                 CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
                   CALL cl_err3("del","aps_wcm",g_aps_wcm_t.wcaln_id,"",SQLCA.sqlcode,"","",1) # FUN-660095
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i205_bcl
                COMMIT WORK
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_aps_wcm[l_ac].* = g_aps_wcm_t.*
              CLOSE i205_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_aps_wcm[l_ac].wcaln_id,-263,1)
              LET g_aps_wcm[l_ac].* = g_aps_wcm_t.*
           ELSE
              UPDATE aps_wcm SET wcaln_id = g_aps_wcm[l_ac].wcaln_id,
                                mon_wmid = g_aps_wcm[l_ac].mon_wmid,
                                tue_wmid = g_aps_wcm[l_ac].tue_wmid,
                                wed_wmid = g_aps_wcm[l_ac].wed_wmid,
                                thu_wmid = g_aps_wcm[l_ac].thu_wmid,
                                fri_wmid = g_aps_wcm[l_ac].fri_wmid,
                                sat_wmid = g_aps_wcm[l_ac].sat_wmid,
                                sun_wmid = g_aps_wcm[l_ac].sun_wmid,
                                mon_exhr = g_aps_wcm[l_ac].mon_exhr,
                                tue_exhr = g_aps_wcm[l_ac].tue_exhr,
                                wed_exhr = g_aps_wcm[l_ac].wed_exhr,
                                thu_exhr = g_aps_wcm[l_ac].thu_exhr,
                                fri_exhr = g_aps_wcm[l_ac].fri_exhr,
                                sat_exhr = g_aps_wcm[l_ac].sat_exhr,
                                sun_exhr = g_aps_wcm[l_ac].sun_exhr
               WHERE CURRENT OF i205_bcl

              IF SQLCA.sqlcode THEN
  #                CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660095
            CALL cl_err3("upd","aps_wcm",g_aps_wcm_t.wcaln_id,"",SQLCA.sqlcode,"","",1) # FUN-660095
                  LET g_aps_wcm[l_ac].* = g_aps_wcm_t.*
                  DISPLAY g_aps_wcm[l_ac].* TO s_aps[l_sl].*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i205_bcl
                  COMMIT WORK
              END IF
           END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aps_wcm[l_ac].* = g_aps_wcm_t.*
               END IF
               CLOSE i205_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i205_bcl
            COMMIT WORK

        ON ACTION CONTROLN
            CALL i205_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(wcaln_id) AND l_ac > 1 THEN
                LET g_aps_wcm[l_ac].* = g_aps_wcm[l_ac-1].*
                DISPLAY g_aps_wcm[l_ac].* TO s_aps[l_sl].*
                NEXT FIELD wcaln_id
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

    CLOSE i205_bcl
    COMMIT WORK
    OPTIONS
        INSERT KEY F1,
        DELETE KEY F2
END FUNCTION

FUNCTION i205_b_askkey()
    CLEAR FORM
    CALL g_aps_wcm.clear()
    CONSTRUCT g_wc2 ON wcaln_id,
                       mon_wmid,
                       tue_wmid,
                       wed_wmid,
                       thu_wmid,
                       fri_wmid,
                       sat_wmid,
                       sun_wmid,
                       mon_exhr,
                       tue_exhr,
                       wed_exhr,
                       thu_exhr,
                       fri_exhr,
                       sat_exhr,
                       sun_exhr
            FROM s_aps[1].wcaln_id,
                 s_aps[1].mon_wmid,
                 s_aps[1].tue_wmid,
                 s_aps[1].wed_wmid,
                 s_aps[1].thu_wmid,
                 s_aps[1].fri_wmid,
                 s_aps[1].sat_wmid,
                 s_aps[1].sun_wmid,
                 s_aps[1].mon_exhr,
                 s_aps[1].tue_exhr,
                 s_aps[1].wed_exhr,
                 s_aps[1].thu_exhr,
                 s_aps[1].fri_exhr,
                 s_aps[1].sat_exhr,
                 s_aps[1].sun_exhr
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
    CALL i205_b_fill(g_wc2)
END FUNCTION

FUNCTION i205_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(500)

    LET g_sql =
        "SELECT wcaln_id, ",
        " mon_wmid,tue_wmid,wed_wmid,thu_wmid,fri_wmid,sat_wmid,sun_wmid, ",
        " mon_exhr,tue_exhr,wed_exhr,thu_exhr,fri_exhr,sat_exhr,sun_exhr ",
        "  FROM aps_wcm",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1,2"
    PREPARE i205_pb FROM g_sql
    DECLARE aps_wcm_curs CURSOR FOR i205_pb

    CALL g_aps_wcm.clear()
    LET g_cnt = 1
    FOREACH aps_wcm_curs INTO g_aps_wcm[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_aps_wcm.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION i205_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aps_wcm TO s_aps.* ATTRIBUTE(COUNT=g_rec_b)

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
FUNCTION i205_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("wcaln_id",TRUE)
   END IF
END FUNCTION
 
FUNCTION i205_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("wcaln_id",FALSE)
   END IF
END FUNCTION
#No.FUN-570110--end
#Patch....NO:TQC-610036 <001> #
