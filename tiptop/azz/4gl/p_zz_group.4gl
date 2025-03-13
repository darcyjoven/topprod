# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_zz_group
# Descriptions...: 程式群組維護作業
# Date & Author..: 04/02/26 alex
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4A0082 05/04/20 By alex 新增查看有哪些程式被列入 group 功能
# Modify.........: NO.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_gaw        DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        gaw01       LIKE gaw_file.gaw01,  
        gaw02       LIKE gaw_file.gaw02
                END RECORD,
       g_gaw_t      RECORD                    #程式變數 (舊值)
        gaw01       LIKE gaw_file.gaw01,  
        gaw02       LIKE gaw_file.gaw02
                END RECORD,
       g_wc2,g_sql  STRING,
       g_rec_b      LIKE type_file.num5,      #單身筆數  #No.FUN-680135 SMALLINT
       l_ac         LIKE type_file.num5       #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
DEFINE g_forupd_sql STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680135 INTEGER
DEFINE g_i          LIKE type_file.num5       #count/index for any purpose #No.FUN-680135 SMALLINT
DEFINE  g_before_input_done  LIKE type_file.num5   #NO.MOD-580056  #No.FUN-680135 SMALLINT


MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    
 
   OPEN WINDOW p_zz_group_w WITH FORM "azz/42f/p_zz_group"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
 
   CALL p_zz_group_b_fill(g_wc2)
   CALL p_zz_group_menu()
   CLOSE WINDOW p_zz_group_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_zz_group_menu()
 
   WHILE TRUE
      CALL p_zz_group_bp("G")
      CASE g_action_choice
 
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_zz_group_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN 
               CALL p_zz_group_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit" 
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gaw),'','')
            END IF
 
         WHEN "upd_grp_item"    #FUN-4A0082
            IF cl_chk_act_auth() THEN
               IF cl_null(g_gaw[l_ac].gaw01) THEN
                  CALL cl_err("",-400,0)
               ELSE
                  CALL p_zz_group_item(g_gaw[l_ac].gaw01 CLIPPED)
               END IF
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
 
FUNCTION p_zz_group_q()
   CALL p_zz_group_b_askkey()
END FUNCTION
 
 
 
FUNCTION p_zz_group_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680135 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680135 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680135 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680135 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680135 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT gaw01,gaw02 FROM gaw_file WHERE gaw01= ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_zz_group_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_gaw WITHOUT DEFAULTS FROM s_gaw.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF p_cmd = 'u' THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac  THEN
               LET g_gaw_t.* = g_gaw[l_ac].*  #BACKUP
               LET p_cmd='u'
 #No.MOD-580056 --start
               LET g_before_input_done = FALSE
               CALL p_zz_group_set_entry_b(p_cmd)
               CALL p_zz_group_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
 #No.MOD-580056 --end
 
               BEGIN WORK
               OPEN p_zz_group_bcl USING g_gaw_t.gaw01
               IF STATUS THEN
                  CALL cl_err("OPEN p_zz_group_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH p_zz_group_bcl INTO g_gaw[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_gaw_t.gaw01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD gaw01
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO gaw_file(gaw01,gaw02)
            VALUES(g_gaw[l_ac].gaw01,g_gaw[l_ac].gaw02)
            IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gaw[l_ac].gaw01,SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("ins","gaw_file",g_gaw[l_ac].gaw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gaw[l_ac].* TO NULL      #900423
            LET g_gaw_t.* = g_gaw[l_ac].*         #新輸入資料
 #No.MOD-580056 --start
            LET g_before_input_done = FALSE
            CALL p_zz_group_set_entry_b(p_cmd)
            CALL p_zz_group_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 #No.MOD-580056 --end
 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD gaw01
 
        AFTER FIELD gaw01                        #check 編號是否重複
            IF NOT cl_null(g_gaw[l_ac].gaw01) THEN
               IF g_gaw[l_ac].gaw01 != g_gaw_t.gaw01 OR
                  (g_gaw[l_ac].gaw01 IS NOT NULL AND g_gaw_t.gaw01 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM gaw_file
                    WHERE gaw01 = g_gaw[l_ac].gaw01
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_gaw[l_ac].gaw01 = g_gaw_t.gaw01
                      NEXT FIELD gaw01
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_gaw_t.gaw01 IS NOT NULL THEN
                IF NOT cl_confirm("azz-113") THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
 
                UPDATE zz_file SET zz10="" WHERE zz10=g_gaw_t.gaw01
                IF SQLCA.sqlcode THEN
                   #CALL cl_err(g_gaw_t.gaw01,SQLCA.sqlcode,0)  #No.FUN-660081
                   CALL cl_err3("upd","zz_file",g_gaw_t.gaw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
 
                DELETE FROM gaw_file WHERE gaw01 = g_gaw_t.gaw01
                IF SQLCA.sqlcode THEN
                   #CALL cl_err(g_gaw_t.gaw01,SQLCA.sqlcode,0)  #No.FUN-660081
                   CALL cl_err3("del","gaw_file",g_gaw_t.gaw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE p_zz_group_bcl
                COMMIT WORK 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gaw[l_ac].* = g_gaw_t.*
               CLOSE p_zz_group_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gaw[l_ac].gaw01,-263,1)
               LET g_gaw[l_ac].* = g_gaw_t.*
            ELSE
               UPDATE zz_file SET zz10=g_gaw[l_ac].gaw01
                WHERE zz10=g_gaw_t.gaw01
               IF SQLCA.sqlcode THEN
                  #CALL cl_err(g_gaw_t.gaw01,SQLCA.sqlcode,0)  #No.FUN-660081
                  CALL cl_err3("upd","zz_file",g_gaw_t.gaw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
                  LET g_gaw[l_ac].* = g_gaw_t.*
                  ROLLBACK WORK
               ELSE
                  UPDATE gaw_file SET gaw01=g_gaw[l_ac].gaw01,
                                      gaw02=g_gaw[l_ac].gaw02
                   WHERE gaw01= g_gaw_t.gaw01
                  IF SQLCA.sqlcode THEN
                     #CALL cl_err(g_gaw[l_ac].gaw01,SQLCA.sqlcode,0)  #No.FUN-660081
                     CALL cl_err3("upd","gaw_file",g_gaw_t.gaw01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660081
                     LET g_gaw[l_ac].* = g_gaw_t.*
                  ELSE
                     MESSAGE 'UPDATE O.K'
                     CLOSE p_zz_group_bcl
                     COMMIT WORK
                  END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN 
                  LET g_gaw[l_ac].* = g_gaw_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_gaw.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE p_zz_group_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30034 add
            CLOSE p_zz_group_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL p_zz_group_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(gaw01) AND l_ac > 1 THEN
                LET g_gaw[l_ac].* = g_gaw[l_ac-1].*
                NEXT FIELD gaw01
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
 
    CLOSE p_zz_group_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION p_zz_group_b_askkey()
    CLEAR FORM
    CALL g_gaw.clear()
    CONSTRUCT g_wc2 ON gaw01,gaw02
         FROM s_gaw[1].gaw01,s_gaw[1].gaw02
 
       ON ACTION about         #FUN-860033
          CALL cl_about()      #FUN-860033
 
       ON ACTION controlg      #FUN-860033
          CALL cl_cmdask()     #FUN-860033
 
       ON ACTION help          #FUN-860033
          CALL cl_show_help()  #FUN-860033
 
       ON IDLE g_idle_seconds  #FUN-860033
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL p_zz_group_b_fill(g_wc2)
END FUNCTION
 
FUNCTION p_zz_group_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2       STRING
 
    LET g_sql = "SELECT gaw01,gaw02 ",
                 " FROM gaw_file ",
                " WHERE ", p_wc2 CLIPPED,                     #單身
                " ORDER BY gaw01 "
    PREPARE p_zz_group_pb FROM g_sql
    DECLARE gaw_curs CURSOR FOR p_zz_group_pb
 
    CALL g_gaw.clear()
 
    LET g_cnt = 1
    FOREACH gaw_curs INTO g_gaw[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
 
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_gaw.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_zz_group_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gaw TO s_gaw.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY
 
      ON ACTION upd_grp_item    #FUN-4A0082
         LET g_action_choice = "upd_grp_item"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 #No.MOD-580056 --start
FUNCTION p_zz_group_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gaw01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_zz_group_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gaw01",FALSE)
   END IF
 
END FUNCTION
 #No.MOD-580056 --end
 
