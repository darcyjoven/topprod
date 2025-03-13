# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apsi301.4gl
# Descriptions...: 日行事曆資料維護作業
# Date & Author..: 02/03/14 By Mandy
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-660095 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: NO.FUN-850114 07/12/25 BY yiting apsi103.4gl-->apsi301.4gl
# Modify.........: NO.FUN-890130 08/09/30 BY DUKE 工作模式設定開窗
# Modify.........: No.FUN-8A0004 08/10/03 by duke q_vma02 --> q_vma03
# Modify.........: No.FUN-8A0069 08/10/15 by duke remove message abm-809
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-B80181 11/08/30 By Abby apsi301單身刪除或日行事曆編號改變時,需check 日行事曆編號[vmb01]
#                                                 (1)在apsi303 的日行事曆[vmd03]未被使用,若有被使用則show提示且無法刪除或改變
#                                                 (2)在apsi321 的日行事曆[vmj03]未被使用,若有被使用則show提示且無法刪除或改變
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_vmb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        vmb01       LIKE vmb_file.vmb01,      #FUN-850114
        vmb02       LIKE vmb_file.vmb02,
        vmb03       LIKE vmb_file.vmb03
                    END RECORD,
    g_vmb_t         RECORD                    #程式變數 (舊值)
        vmb01       LIKE vmb_file.vmb01,
        vmb02       LIKE vmb_file.vmb02,
        vmb03       LIKE vmb_file.vmb03
                    END RECORD,
    g_wc2,g_sql    string,  #No.FUN-580092 HCN
    l_vma021        LIKE type_file.chr8,  #FUN-8A0004
    l_vma031        LIKE type_file.chr8,  #FUN-8A0004
    l_vma02         LIKE vma_file.vma02,  #FUN-8A0004
    l_vma03         LIKE vma_file.vma03,  #FUN-8A0004
    g_rec_b         LIKE type_file.num5,         #單身筆數             #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done    LIKE type_file.num5    #No.FUN-570110  #No.FUN-690010 SMALLINT
DEFINE   g_cnt                  LIKE type_file.num10   #No.FUN-690010 INTEGER
 
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW i103_w WITH FORM "aps/42f/apsi301"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1'
    CALL i103_b_fill(g_wc2)
    CALL i103_menu()
    CLOSE WINDOW i103_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
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
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i103_q()
   CALL i103_b_askkey()
END FUNCTION
 
FUNCTION i103_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用     #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否     #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態       #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #No.FUN-690010  VARCHAR(01),
    l_allow_delete  LIKE type_file.chr1    #No.FUN-690010  VARCHAR(01)
DEFINE l_cnt        LIKE type_file.num5    
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT vmb01,vmb02,vmb03 FROM vmb_file ",
                       " WHERE vmb01 = ?  AND vmb02 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_vmb WITHOUT DEFAULTS FROM s_vmb.*
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
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET g_vmb_t.* = g_vmb[l_ac].*  #BACKUP
               LET p_cmd='u'
               LET g_before_input_done = FALSE
               CALL i103_set_entry_b(p_cmd)
               CALL i103_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
               BEGIN WORK
               OPEN i103_bcl USING g_vmb_t.vmb01,g_vmb_t.vmb02
               IF STATUS THEN
                  CALL cl_err("OPEN i103_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i103_bcl INTO g_vmb[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD vmb01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL i103_set_entry_b(p_cmd)
            CALL i103_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_vmb[l_ac].* TO NULL
            LET g_vmb_t.* = g_vmb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD vmb01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
          INSERT INTO vmb_file(vmb01,vmb02,vmb03)    #No.MOD-470041
                      VALUES(g_vmb[l_ac].vmb01,
                             g_vmb[l_ac].vmb02,
                             g_vmb[l_ac].vmb03)
 
         IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vmb",g_vmb[l_ac].vmb01,g_vmb[l_ac].vmb02,SQLCA.sqlcode,"","",1)  # Fun - 660095
             LET g_vmb[l_ac].* = g_vmb_t.*
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

        #FUN-B80181 add str---
         AFTER FIELD vmb01
            IF NOT cl_null(g_vmb[l_ac].vmb01) AND (g_vmb[l_ac].vmb01 != g_vmb_t.vmb01) THEN
               SELECT count(*) INTO l_n FROM vmd_file
                WHERE vmd03 = g_vmb_t.vmb01
               IF l_n > 0 THEN
                   CALL cl_err('','aps-806',0)
                   LET g_vmb[l_ac].vmb01 = g_vmb_t.vmb01
                   NEXT FIELD vmb01
               END IF
               SELECT count(*) INTO l_n FROM vmj_file
                WHERE vmj03 = g_vmb_t.vmb01
               IF l_n > 0 THEN
                   CALL cl_err('','aps-807',0)
                   LET g_vmb[l_ac].vmb01 = g_vmb_t.vmb01
                   NEXT FIELD vmb01
               END IF
            END IF
        #FUN-B80181 add end---
 
        AFTER FIELD vmb02                       #check 編號是否重複
            IF NOT cl_null(g_vmb[l_ac].vmb02) THEN
            IF (g_vmb_t.vmb01 !=
                g_vmb[l_ac].vmb01 )  OR
               (g_vmb_t.vmb02           !=
                g_vmb[l_ac].vmb02           )  OR p_cmd='a' THEN
                SELECT count(*) INTO l_n FROM vmb_file
                 WHERE vmb01 = g_vmb[l_ac].vmb01
                   AND vmb02 = g_vmb[l_ac].vmb02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_vmb[l_ac].vmb01 = g_vmb_t.vmb01
                    LET g_vmb[l_ac].vmb02 = g_vmb_t.vmb02
                    NEXT FIELD vmb01
                END IF
            END IF
            END IF
 
        AFTER FIELD vmb03
            IF NOT cl_null(g_vmb[l_ac].vmb03) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vma_file 
                  WHERE vma01 = g_vmb[l_ac].vmb03
               IF l_cnt = 0 THEN
                   CALL cl_err('','aps-401',0)
                   NEXT FIELD vmb03
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_vmb_t.vmb01) AND
               NOT cl_null(g_vmb_t.vmb02) THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
               #FUN-B80181 add str---
                SELECT count(*) INTO l_n FROM vmd_file
                 WHERE vmd03 = g_vmb_t.vmb01
                IF l_n > 0 THEN
                    CALL cl_err('','aps-806',0)
                    LET g_vmb[l_ac].vmb01 = g_vmb_t.vmb01
                    CANCEL DELETE
                END IF
                SELECT count(*) INTO l_n FROM vmj_file
                 WHERE vmj03 = g_vmb_t.vmb01
                IF l_n > 0 THEN
                    CALL cl_err('','aps-807',0)
                    LET g_vmb[l_ac].vmb01 = g_vmb_t.vmb01
                    CANCEL DELETE
                END IF
               #FUN-B80181 add end---
                DELETE FROM vmb_file
                 WHERE vmb01 = g_vmb_t.vmb01
                   AND vmb02           = g_vmb_t.vmb02
                IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","vmb",g_vmb_t.vmb01,g_vmb_t.vmb02,SQLCA.sqlcode,"","",1)  # Fun - 660095
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i103_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_vmb[l_ac].* = g_vmb_t.*
              CLOSE i103_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_vmb[l_ac].vmb01,-263,1)
              LET g_vmb[l_ac].* = g_vmb_t.*
           ELSE
              UPDATE vmb_file SET 
                             vmb01 = g_vmb[l_ac].vmb01,
                             vmb02 = g_vmb[l_ac].vmb02,
                             vmb03 = g_vmb[l_ac].vmb03
               WHERE CURRENT OF i103_bcl
 
              IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","vmb",g_vmb_t.vmb01,g_vmb_t.vmb02,SQLCA.sqlcode,"","",1)  # Fun - 660095
                   LET g_vmb[l_ac].* = g_vmb_t.*
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
                  LET g_vmb[l_ac].* = g_vmb_t.*
               END IF
               CLOSE i103_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i103_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i103_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(vmb01) AND l_ac > 1 THEN
                LET g_vmb[l_ac].* = g_vmb[l_ac-1].*
                NEXT FIELD vmb01
            END IF
        ON ACTION controlp
           CASE
            WHEN INFIELD(vmb03)                 #機械編號
                 CALL cl_init_qry_var()
                 CALL q_vma03(FALSE,TRUE,g_vmb[l_ac].vmb03)
                   RETURNING  g_vmb[l_ac].vmb03,l_vma021,l_vma031,l_vma02,l_vma03
 
 
                 DISPLAY BY NAME g_vmb[l_ac].vmb03
                 NEXT FIELD vmb03
 
             OTHERWISE
                   EXIT CASE
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
 
    CLOSE i103_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i103_b_askkey()
    CLEAR FORM
    CALL g_vmb.clear()
    CONSTRUCT g_wc2 ON vmb01,vmb02,vmb03
            FROM s_vmb[1].vmb01,
                 s_vmb[1].vmb02,
                 s_vmb[1].vmb03
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(vmb03)
                 CALL cl_init_qry_var()
                 CALL q_vma03(FALSE,TRUE,' ')
                      RETURNING  g_vmb[1].vmb03,l_vma021,l_vma031,l_vma02,l_vma03
                 DISPLAY BY NAME g_vmb[1].vmb03
                 NEXT FIELD vmb03
            OTHERWISE
            EXIT CASE
          END CASE
         
 
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i103_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i103_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(500)
 
    LET g_sql =
        "SELECT vmb01,vmb02,vmb03 ",
        "  FROM vmb_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i103_pb FROM g_sql
    DECLARE vmb_curs CURSOR FOR i103_pb
 
    CALL g_vmb.clear()
    LET g_cnt = 1
    FOREACH vmb_curs INTO g_vmb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_vmb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vmb TO s_vmb.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i103_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("vmb01,vmb02",TRUE)
   END IF
END FUNCTION
 
FUNCTION i103_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("vmb01,vmb02",FALSE)
   END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼
