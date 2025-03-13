# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: p_zz_name.4gl
# Descriptions...: 程式模組名稱資料維護作業
# Date & Author..: 03/03/12 alex
# Modify.........: 04/10/08 Echo 增加gaz05客製欄位          
# Modify.........: No.MOD-530130 05/03/17 By Carrier 查詢筆數錯誤
# Modify.........: No.MOD-530886 05/03/31 By alex 增加轉出單身到 excel 功能
# Modify.........; NO.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........; NO.TQC-770020 05/08/05 By alexstar 增加更新 gazdate,gazgrup,gazmodu,gazuser
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-760179 07/07/12 By rainy 新增欄位(報表列印抬頭gaz06)
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.TQC-8C0038 09/03/04 By Sarah 拿掉列印功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gaz     DYNAMIC ARRAY OF RECORD 
            gaz01          LIKE gaz_file.gaz01,  
            gaz02          LIKE gaz_file.gaz02,  
            gaz03          LIKE gaz_file.gaz03,
            gaz06          LIKE gaz_file.gaz06,  #TQC-760179
            gaz05          LIKE gaz_file.gaz05
                      END RECORD,
         g_gaz_t           RECORD 
            gaz01          LIKE gaz_file.gaz01,  
            gaz02          LIKE gaz_file.gaz02,  
            gaz03          LIKE gaz_file.gaz03,
            gaz06          LIKE gaz_file.gaz06,  #TQC-760179
            gaz05          LIKE gaz_file.gaz05
                      END RECORD,
         g_wc2            string,                #No.FUN-580092 HCN
         g_sql            string,                #No.FUN-580092 HCN
         g_rec_b          LIKE type_file.num5,   # 單身筆數 #No.FUN-680135 SMALLINT
         l_ac             LIKE type_file.num5,   # 目前處理的ARRAY CNT    #No.FUN-680135 SMALLINT
         l_sl             LIKE type_file.num5    # 目前處理的SCREEN LINE  #No.FUN-680135 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose #No.FUN-680135 SMALLINT
DEFINE   g_forupd_sql    STRING
DEFINE   g_before_input_done LIKE type_file.num5    #NO.MOD-580056  #No.FUN-680135 SMALLINT
 
MAIN
   OPTIONS                                     # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW p_zz_name_w WITH FORM "azz/42f/p_zz_name"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gaz02")
   CALL p_zz_name_menu()
 
   CLOSE WINDOW p_zz_name_w                            # 結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0096
END MAIN
 
 
FUNCTION p_zz_name_menu()
 
   WHILE TRUE
      CALL p_zz_name_bp("G")
      CASE g_action_choice
 
      WHEN "query"
         IF cl_chk_act_auth() THEN
            CALL p_zz_name_q()
         END IF
 
      WHEN "detail"                            # "B.單身"
         IF cl_chk_act_auth() THEN
            CALL p_zz_name_b()
         ELSE
            LET g_action_choice = " "
         END IF
 
      WHEN "help"
         CALL cl_show_help()
 
      WHEN "exit"
         EXIT WHILE
 
      WHEN "controlg"                          # KEY(CONTROL-G)
         CALL cl_cmdask()
 
       WHEN "exporttoexcel"    #MOD-530886
         IF cl_chk_act_auth() THEN
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gaz),'','')
         END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p_zz_name_q()
   CALL p_zz_name_b_askkey()
END FUNCTION
 
 
FUNCTION p_zz_name_b()
 
DEFINE   l_ac_t          LIKE type_file.num5,    # 未取消的ARRAY CNT    #No.FUN-680135 SMALLINT 
         l_n             LIKE type_file.num5,    # 檢查重複用           #No.FUN-680135 SMALLINT
         l_modify_flag   LIKE type_file.chr1,    # 單身更改否           #No.FUN-680135 VARCHAR(1)
         l_lock_sw       LIKE type_file.chr1,    # 單身鎖住否           #No.FUN-680135 VARCHAR(1)
         l_exit_sw       LIKE type_file.chr1,    # Esc結束INPUT ARRAY 否#No.FUN-680135 VARCHAR(1)
         p_cmd           LIKE type_file.chr1,    # 處理狀態             #No.FUN-680135 VARCHAR(1)
         l_allow_insert  LIKE type_file.num5,    # 可否新增             #No.FUN-680135 SMALLINT
         l_allow_delete  LIKE type_file.num5,    # 可否刪除             #No.FUN-680135 SMALLINT
         l_jump          LIKE type_file.num5     # 判斷是否跳過AFTER ROW的處理 #No.FUN-680135 SMALLINT
 
   LET g_action_choice = ""
   CALL cl_opmsg('b')
 
   IF s_shut(0) THEN 
      RETURN 
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = " SELECT gaz01,gaz02,gaz03,gaz06,gaz05 ",   #TQC-760179 add gaz06
                        " FROM gaz_file  WHERE gaz01 = ? AND gaz02= ? AND gaz05= ? ",
                         " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_zz_name_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_gaz WITHOUT DEFAULTS FROM s_gaz.*
      ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec, UNBUFFERED,
                INSERT ROW=l_allow_insert, DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET g_gaz_t.* = g_gaz[l_ac].*  #BACKUP
            LET p_cmd='u'
 #No.MOD-580056 --start
            LET g_before_input_done = FALSE
            CALL p_zz_name_set_entry_b(p_cmd)
            CALL p_zz_name_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 #No.MOD-580056 --end
 
            OPEN p_zz_name_bcl USING g_gaz_t.gaz01, g_gaz_t.gaz02, g_gaz_t.gaz05
            IF SQLCA.sqlcode THEN
               CALL cl_err('OPEN p_zz_name_bcl',SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_zz_name_bcl INTO g_gaz[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_zz_name_bcl',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_gaz[l_ac].* TO NULL      #900423
          LET g_gaz[l_ac].gaz05 = 'N' 
 #No.MOD-580056 --start
          LET g_before_input_done = FALSE
          CALL p_zz_name_set_entry_b(p_cmd)
          CALL p_zz_name_set_no_entry_b(p_cmd)
          LET g_before_input_done = TRUE
 #No.MOD-580056 --end
 
          LET g_gaz_t.* = g_gaz[l_ac].*         #新輸入資料
 
          DISPLAY g_gaz[l_ac].* TO s_gaz[l_sl].* 
          CALL cl_show_fld_cont()     #FUN-550037(smin)
 
       AFTER FIELD gaz05
          IF g_gaz[l_ac].gaz01 != g_gaz_t.gaz01 OR g_gaz[l_ac].gaz02 != g_gaz_t.gaz02
          OR g_gaz[l_ac].gaz05 != g_gaz_t.gaz05
          OR (g_gaz[l_ac].gaz01 IS NOT NULL AND g_gaz_t.gaz01 IS NULL) 
          OR (g_gaz[l_ac].gaz02 IS NOT NULL AND g_gaz_t.gaz02 IS NULL) 
          OR (g_gaz[l_ac].gaz05 IS NOT NULL AND g_gaz_t.gaz05 IS NULL) THEN
             SELECT count(*) INTO l_n FROM gaz_file
              WHERE gaz01 = g_gaz[l_ac].gaz01
                AND gaz02 = g_gaz[l_ac].gaz02 
                AND gaz05 = g_gaz[l_ac].gaz05
            display "gaz05=",g_gaz[l_ac].gaz05
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_gaz[l_ac].gaz01 = g_gaz_t.gaz01
                LET g_gaz[l_ac].gaz02 = g_gaz_t.gaz02
                LET g_gaz[l_ac].gaz05 = g_gaz_t.gaz05
                DISPLAY g_gaz[l_ac].gaz01 TO s_gaz[l_sl].gaz01
                DISPLAY g_gaz[l_ac].gaz02 TO s_gaz[l_sl].gaz02
                DISPLAY g_gaz[l_ac].gaz05 TO s_gaz[l_sl].gaz05
                NEXT FIELD gaz01
             END IF
          END IF
        
       BEFORE FIELD gaz03
          LET l_modify_flag = 'Y'
          IF l_lock_sw = 'Y' THEN            #已鎖住
             LET l_modify_flag = 'N'
          END IF
          IF l_modify_flag = 'N' THEN
             LET g_gaz[l_ac].gaz01 = g_gaz_t.gaz01
             LET g_gaz[l_ac].gaz02 = g_gaz_t.gaz02
             LET g_gaz[l_ac].gaz05 = g_gaz_t.gaz05
             DISPLAY g_gaz[l_ac].gaz01 TO s_gaz[l_sl].gaz01
             DISPLAY g_gaz[l_ac].gaz02 TO s_gaz[l_sl].gaz02
             DISPLAY g_gaz[l_ac].gaz05 TO s_gaz[l_sl].gaz05
             NEXT FIELD gaz01
          END IF
 
       BEFORE DELETE                            #是否取消單身
          IF g_gaz_t.gaz01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
             DELETE FROM gaz_file WHERE gaz01 = g_gaz_t.gaz01
                AND gaz02 = g_gaz_t.gaz02 AND gaz05 = g_gaz_t.gaz05
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gaz_t.gaz01,SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("del","gaz_file",g_gaz_t.gaz01,g_gaz_t.gaz02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                ROLLBACK WORK 
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             MESSAGE "Delete OK"
             CLOSE p_zz_name_bcl
             COMMIT WORK 
          END IF
 
      AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO gaz_file(gaz01,gaz02,gaz03,gaz05,gazuser,gazgrup,gazmodu,gazdate,gaz06,gazoriu,gazorig)   #TQC-770020   #TQC-760179
               VALUES (g_gaz[l_ac].gaz01,g_gaz[l_ac].gaz02,
                       g_gaz[l_ac].gaz03,g_gaz[l_ac].gaz05,g_user,g_grup,g_user,g_today,g_gaz[l_ac].gaz06, g_user, g_grup)   #TQC-770020   #TQC-760179        #No.FUN-980030 10/01/04  insert columns oriu, orig
          IF SQLCA.sqlcode THEN
             #CALL cl_err(g_gaz[l_ac].gaz01,SQLCA.sqlcode,0)  #No.FUN-660081
             CALL cl_err3("ins","gaz_file",g_gaz[l_ac].gaz01,g_gaz[l_ac].gaz02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
          END IF
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gaz[l_ac].* = g_gaz_t.*
             CLOSE p_zz_name_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gaz[l_ac].gaz01,-263,1)
             LET g_gaz[l_ac].* = g_gaz_t.*
          ELSE
             UPDATE gaz_file SET gaz01 = g_gaz[l_ac].gaz01,
                                 gaz02 = g_gaz[l_ac].gaz02,
                                 gaz03 = g_gaz[l_ac].gaz03,
                                 gaz06 = g_gaz[l_ac].gaz06,   #TQC-760179
                                 gaz05 = g_gaz[l_ac].gaz05,
                                 gazmodu = g_user,   #TQC-770020
                                 gazdate = g_today   #TQC-770020
              WHERE CURRENT OF p_zz_name_bcl
             IF SQLCA.sqlcode THEN
                #CALL cl_err(g_gaz[l_ac].gaz01,SQLCA.sqlcode,0)  #No.FUN-660081
                CALL cl_err3("upd","gaz_file",g_gaz_t.gaz01,g_gaz_t.gaz02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                LET g_gaz[l_ac].* = g_gaz_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE p_zz_name_bcl
                COMMIT WORK 
             END IF
          END IF
 
      AFTER ROW
 
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_gaz[l_ac].* = g_gaz_t.*
             #FUN-D30034--add--begin--
             ELSE
                CALL g_gaz.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034--add--end----
             END IF
             CLOSE p_zz_name_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac
          CLOSE p_zz_name_bcl
          COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(gaz01) AND l_ac > 1 THEN
             LET g_gaz[l_ac].* = g_gaz[l_ac-1].*
             DISPLAY g_gaz[l_ac].* TO s_gaz[l_sl].* 
             NEXT FIELD gaz01
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
 
   CLOSE p_zz_name_bcl
   COMMIT WORK 
END FUNCTION
 
 
 
FUNCTION p_zz_name_b_askkey()
    CLEAR FORM
    CALL g_gaz.clear()
    CONSTRUCT g_wc2 ON gaz01,gaz02,gaz03,gaz06,gaz05   #TQC-760179
         FROM s_gaz[1].gaz01,s_gaz[1].gaz02,s_gaz[1].gaz03,s_gaz[1].gaz06,s_gaz[1].gaz05  #TQC-760179
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('gazuser', 'gazgrup') #FUN-980030
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL p_zz_name_b_fill(g_wc2)
END FUNCTION
 
 
 
FUNCTION p_zz_name_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(1000)
 
    LET g_sql = "SELECT gaz01,gaz02,gaz03,gaz06,gaz05 ",   #TQC-760179 add gaz06
                " FROM gaz_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY gaz01,gaz02 "
 
    PREPARE p_zz_name_pb FROM g_sql
    DECLARE gaz_curs CURSOR FOR p_zz_name_pb
 
    CALL g_gaz.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gaz_curs INTO g_gaz[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.SQLCODE THEN
           CALL cl_err('foreach:',SQLCA.SQLCODE,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_gaz.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
     #No.MOD-530130  --begin
    #DISPLAY g_cnt   TO FORMONLY.cn2  
    DISPLAY g_rec_b TO FORMONLY.cn2  
     #No.MOD-530130  --end   
    LET g_cnt=0
END FUNCTION
 
 
FUNCTION p_zz_name_bp(p_ud)
 
   DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
       RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gaz TO s_gaz.* ATTRIBUTE(COUNT=g_rec_b)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        ON ACTION query                  # Q.查詢
           LET g_action_choice="query"
           EXIT DISPLAY
 
        ON ACTION detail                 # B.單身
           LET g_action_choice="detail"
           EXIT DISPLAY
 
       #str TQC-8C0038 mark
       #ON ACTION output
       #   LET g_action_choice="output"
       #   EXIT DISPLAY
       #end TQC-8C0038 mark
 
        ON ACTION help                   # H.說明
           LET g_action_choice="help"
           EXIT DISPLAY
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
           # 2004/03/24 新增語言別選項
           CALL cl_set_combo_lang("gaz02")
           EXIT DISPLAY
 
        ON ACTION exit                   # Esc.結束
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION accept
           LET g_action_choice="detail"
           LET l_ac = ARR_CURR()
           EXIT DISPLAY
 
        ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice="exit"
           EXIT DISPLAY
 
        ON ACTION controlg
           LET g_action_choice="controlg"
           EXIT DISPLAY
 
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION exporttoexcel  #MOD-530886
           LET g_action_choice="exporttoexcel"
           EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 #No.MOD-580056 --start
FUNCTION p_zz_name_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gaz01,gaz02,gaz05",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_zz_name_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gaz01,gaz02,gaz05",FALSE)
   END IF
 
END FUNCTION
 #No.MOD-580056 --end
 
