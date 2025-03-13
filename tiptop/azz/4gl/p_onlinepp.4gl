# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: p_onlinepp.4gl
# Descriptions...: 部門上線人數設定作業
# Date & Author..: 05/08/22 By saki    #FUN-580093
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成mi_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-7A0086 07/11/02 By saki 營運中心上線人數控制
# Modify.........: No.FUN-7B0009 07/11/05 By saki 營運中心與部門上線人數相互check
# Modify.........: No.FUN-920138 09/08/18 By tsai_yen 新增與部門群組資料(p_tgrup)同步，刪除同步在p_tgrup和aooi030處理(執行速度考量)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_gbo               DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gbo01           LIKE gbo_file.gbo01,
        gem02           LIKE gem_file.gem02,
        gbo04           LIKE gbo_file.gbo04,       #類別(1:部門, 2:部門群組)   #FUN-920138
        gbo02           LIKE gbo_file.gbo02,
        gbo03           LIKE gbo_file.gbo03
                        END RECORD,
    g_gbo_t             RECORD                 #程式變數 (舊值)
        gbo01           LIKE gbo_file.gbo01,
        gem02           LIKE gem_file.gem02,
        gbo04           LIKE gbo_file.gbo04,       #類別(1:部門, 2:部門群組)   #FUN-920138
        gbo02           LIKE gbo_file.gbo02,
        gbo03           LIKE gbo_file.gbo03
                        END RECORD,
    g_wc2               STRING,
    g_rec_b             LIKE type_file.num5,         #單身筆數  #No.FUN-680135 SMALLINT
    l_ac                LIKE type_file.num5          #目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   p_row,p_col    LIKE type_file.num5          #No.FUN-680135 SMALLINT 
#主程式開始
DEFINE   g_forupd_sql   STRING                 #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10            #No.FUN-680135 INTEGER
DEFINE   g_before_input_done   LIKE type_file.num5      #No.FUN-680135 SMALLINT
 
 
MAIN
#     DEFINE   l_time   LIKE type_file.chr8            #No.FUN-6A0096
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680135  SMALLINT
 
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
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW online_w AT p_row,p_col WITH FORM "azz/42f/p_onlinepp"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   IF cl_null(g_wc2) THEN
      LET g_wc2 = "1=1"
   END IF
   CALL p_onlinepp_b_fill(g_wc2)
   CALL p_onlinepp_menu()
   CLOSE WINDOW online_w               #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_onlinepp_menu()
 
   WHILE TRUE
      CALL p_onlinepp_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_onlinepp_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_onlinepp_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL p_onlinepp_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_gbo[l_ac].gbo01 IS NOT NULL THEN
                  LET g_doc.column1 = "gbo01"
                  LET g_doc.value1 = g_gbo[l_ac].gbo01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gbo),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_onlinepp_q()
   CALL p_onlinepp_b_askkey()
END FUNCTION
 
FUNCTION p_onlinepp_b()
   DEFINE
      l_ac_t           LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
      l_n              LIKE type_file.num5,    #檢查重複用        #No.FUN-680135 SMALLINT
      l_lock_sw        LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680135 VARCHAR(1)
      p_cmd            LIKE type_file.chr1,    #處理狀態          #No.FUN-680135 VARCHAR(1)
      l_allow_insert   LIKE type_file.num5,    #FUN-680135        VARCHAR(1) #可新增否
      l_allow_delete   LIKE type_file.num5     #FUN-680135        VARCHAR(1) #可刪除否
   DEFINE lc_azp09        LIKE azp_file.azp09           #No.FUN-7B0009
   DEFINE lc_azp10        LIKE azp_file.azp10           #No.FUN-7B0009
   DEFINE ls_msg          STRING                        #No.FUN-7B0009
   ###FUN-920138 START ###
   DEFINE l_zyw01      LIKE zyw_file.zyw01     #部門群組代碼
   DEFINE l_gbo03_chk  LIKE gbo_file.gbo03     #檢查部門上線人數
   DEFINE l_str        STRING     
   DEFINE l_str1       STRING           
   ###FUN-920138 END ###
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET g_forupd_sql = "SELECT gbo01,'',gbo04,gbo02,gbo03",                    #FUN-920138 加gbo04
                      "  FROM gbo_file WHERE gbo01=? AND gbo04=? FOR UPDATE"  #FUN-920138 加gbo04
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_onlinepp_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_gbo WITHOUT DEFAULTS FROM s_gbo.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_rec_b,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'               #DEFAULT
          LET l_n  = ARR_COUNT()
          IF g_rec_b>=l_ac THEN
             BEGIN WORK
             LET p_cmd='u'
             LET g_gbo_t.* = g_gbo[l_ac].*  #BACKUP
 
             OPEN p_onlinepp_bcl USING g_gbo_t.gbo01,g_gbo_t.gbo04   #FUN-920138 加gbo04
             IF STATUS THEN
                CALL cl_err("OPEN p_onlinepp_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE 
                FETCH p_onlinepp_bcl INTO g_gbo[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_gbo_t.gbo01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL p_onlinepp_gem02(g_gbo[l_ac].gbo01,g_gbo[l_ac].gbo04) RETURNING g_gbo[l_ac].gem02   #FUN-920138 加gbo04
             CALL cl_show_fld_cont()
             LET g_before_input_done = FALSE
             CALL p_onlinepp_set_entry()
             CALL p_onlinepp_set_no_entry()
             LET g_before_input_done = TRUE
          END IF
 
      BEFORE FIELD gbo02
         CALL p_onlinepp_set_entry()
 
      AFTER FIELD gbo02
         CALL p_onlinepp_set_no_entry()
 
      #No.FUN-7B0009 --start--
      BEFORE FIELD gbo03
         SELECT azp09,azp10 INTO lc_azp09,lc_azp10 FROM azp_file WHERE azp01=g_plant
         IF lc_azp09 = "Y" THEN
            LET ls_msg = cl_getmsg("azz-747",g_lang)
            LET ls_msg = ls_msg.subString(1,ls_msg.getIndexOf("%1",1)-1)
            MESSAGE ls_msg," ",lc_azp10
         END IF
 
      AFTER FIELD gbo03
         IF NOT cl_null(g_gbo[l_ac].gbo03) THEN
            IF lc_azp09 = "Y" THEN
               IF g_gbo[l_ac].gbo03 > lc_azp10 THEN
                  CALL cl_err_msg("","azz-747",lc_azp10,1)
                  NEXT FIELD gbo03
               END IF
            END IF
            
            ###FUN-920138 START ###   
            #檢查:部門上線人數 <= 部門群組上線人數
            IF g_gbo[l_ac].gbo04 = "1" THEN
                LET l_zyw01 = NULL
                LET l_gbo03_chk = 0
                SELECT zyw01 INTO l_zyw01 FROM zyw_file 
                   WHERE zyw03 = g_gbo[l_ac].gbo01
                #部門群組上線人數
                SELECT gbo03 INTO l_gbo03_chk FROM gbo_file 
                   WHERE gbo01 = l_zyw01 AND gbo02 = "Y" AND gbo04 = "2"
                IF cl_null(l_gbo03_chk) THEN 
                   LET l_gbo03_chk = 0
                END IF
                
                IF l_gbo03_chk > 0 THEN
                   IF g_gbo[l_ac].gbo03 > l_gbo03_chk THEN
                      LET l_str = g_gbo[l_ac].gbo03
                      LET l_str1 = l_gbo03_chk
                      LET l_str = l_str CLIPPED,"|",l_str1 CLIPPED
                      CALL cl_err_msg("","azz1005",l_str,1)
                      NEXT FIELD gbo03
                   END IF
                END IF
            END IF
            
            #檢查:部門群組上線人數 >= 各部門上線人數
            IF g_gbo[l_ac].gbo04 = "2" THEN
               LET l_gbo03_chk = 0
               SELECT MAX(gbo03) INTO l_gbo03_chk
                  FROM gbo_file
                  WHERE gbo04='1' AND gbo02='Y'
                    AND gbo01 IN (select zyw03 from zyw_file where zyw01=g_gbo[l_ac].gbo01)
 
               IF l_gbo03_chk > 0 THEN
                  IF g_gbo[l_ac].gbo03 < l_gbo03_chk THEN
                     LET l_str = g_gbo[l_ac].gbo03
                     LET l_str1 = l_gbo03_chk
                     LET l_str = l_str CLIPPED,"|",l_str1 CLIPPED
                     CALL cl_err_msg("","azz1006",l_str,1)
                     NEXT FIELD gbo03
                  END IF
               END IF
            END IF
            ###FUN-920138 END ###
         END IF
      #No.FUN-7B0009 ---end---
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gbo[l_ac].* = g_gbo_t.*
            CLOSE p_onlinepp_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_gbo[l_ac].gbo01,-263,0)
            LET g_gbo[l_ac].* = g_gbo_t.*
         ELSE
            UPDATE gbo_file
               SET gbo01 = g_gbo[l_ac].gbo01, gbo02 = g_gbo[l_ac].gbo02,
                   gbo03 = g_gbo[l_ac].gbo03,
                   gbo04 = g_gbo[l_ac].gbo04   #FUN-920138
             WHERE gbo01 = g_gbo_t.gbo01
               AND gbo04 = g_gbo_t.gbo04       #FUN-920138
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbo[l_ac].gbo01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gbo_file",g_gbo[l_ac].gbo01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gbo[l_ac].* = g_gbo_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gbo[l_ac].* = g_gbo_t.*
            END IF
            CLOSE p_onlinepp_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE p_onlinepp_bcl
         COMMIT WORK
 
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
 
   CLOSE p_onlinepp_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_onlinepp_b_askkey()
 
   CLEAR FORM
   CALL g_gbo.clear()
 
   CONSTRUCT g_wc2 ON gbo01,gbo02,gbo03,gbo04   #FUN-920138 加gbo04
        FROM s_gbo[1].gbo01,s_gbo[1].gbo02,s_gbo[1].gbo03,s_gbo[1].gbo04   #FUN-920138 加gbo04
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION CONTROLP
         IF INFIELD(gbo01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gem"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO gbo01
            NEXT FIELD gbo01
         END IF
   
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   CALL p_onlinepp_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_onlinepp_b_fill(p_wc2)              #BODY FILL UP
   DEFINE   p_wc2      STRING
   DEFINE   lc_gem01   LIKE gem_file.gem01
   DEFINE   lc_zyw01   LIKE zyw_file.zyw01    #FUN-920138
   DEFINE   lc_gbo01   LIKE gbo_file.gbo01    #FUN-920138
   DEFINE   li_cnt     LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   lc_gaz03   LIKE gaz_file.gaz03
   DEFINE   ls_sql     STRING
 
 
   #部門
   LET ls_sql = "SELECT gem01 FROM gem_file WHERE gemacti = 'Y'" #FUN-920138 加上有效碼gemacti判斷
   PREPARE gem_pre FROM ls_sql
   DECLARE gem_curs CURSOR FOR gem_pre
 
   FOREACH gem_curs INTO lc_gem01
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      SELECT COUNT(*) INTO li_cnt FROM gbo_file WHERE gbo01 = lc_gem01
                                                  AND gbo04 = '1'   #FUN-920138
      IF li_cnt <= 0 THEN
         INSERT INTO gbo_file VALUES(lc_gem01,"N","","1")  #FUN-920138 加gbo04
         IF SQLCA.sqlcode THEN
            CALL cl_get_progname("aooi030",g_lang) RETURNING lc_gaz03
            CALL cl_err_msg(lc_gem01,"azz-727",lc_gaz03 || "(aooi030)",0)
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH
 
   ###FUN-920138 START ###
   #部門群組
   LET ls_sql = "SELECT zyw01 FROM zyw_file"
   PREPARE zyw_pre FROM ls_sql
   DECLARE zyw_curs CURSOR FOR zyw_pre
 
   FOREACH zyw_curs INTO lc_zyw01
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      SELECT COUNT(*) INTO li_cnt FROM gbo_file 
         WHERE gbo01 = lc_zyw01 AND gbo04 = '2'
      IF li_cnt <= 0 THEN   #補齊資料
         INSERT INTO gbo_file VALUES(lc_zyw01,"N","","2")
         IF SQLCA.sqlcode THEN
            CALL cl_get_progname("aooi030",g_lang) RETURNING lc_gaz03
            CALL cl_err_msg(lc_gem01,"azz-727",lc_gaz03 || "(aooi030)",0)
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH
   ###FUN-920138 END ###
   
   LET ls_sql = "SELECT gbo01,'',gbo04,gbo02,gbo03 FROM gbo_file",   #FUN-920138 加gbo04
                " WHERE ", p_wc2 CLIPPED,
                " ORDER BY gbo01"
   PREPARE gbo_pb FROM ls_sql
   DECLARE gbo_curs CURSOR FOR gbo_pb
 
   CALL g_gbo.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH gbo_curs INTO g_gbo[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      ###FUN-920138 START ###
      IF cl_null(g_gbo[g_cnt].gbo04) THEN
         LET g_gbo[g_cnt].gbo04 = "1"   #預設類別(1:部門)
      END IF
      ###FUN-920138 END ###
      
      CALL p_onlinepp_gem02(g_gbo[g_cnt].gbo01,g_gbo[g_cnt].gbo04) RETURNING g_gbo[g_cnt].gem02   #FUN-920138 加gbo04
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gbo.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_onlinepp_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gbo TO s_gbo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         CALL cl_show_fld_cont()
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
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_onlinepp_gem02(p_gbo01,p_gbo04)   #FUN-920138 加gbo04
   DEFINE   p_gbo01    LIKE gbo_file.gbo01
   DEFINE   p_gbo04    LIKE gbo_file.gbo04   #FUN-920138
   DEFINE   lc_gem02   LIKE gem_file.gem02
 
   #部門名稱
   IF p_gbo04 = "1" THEN   #FUN-920138
      SELECT gem02 INTO lc_gem02 FROM gem_file
         WHERE gem01 = p_gbo01
   END IF   #FUN-920138
   
   ###FUN-920138 START ###
   #部門群組名稱
   IF p_gbo04 = "2" THEN   
      SELECT DISTINCT(zyw02) INTO lc_gem02 FROM zyw_file
         WHERE zyw01 = p_gbo01
   END IF
   ###FUN-920138 END ###
 
   RETURN lc_gem02
END FUNCTION
 
FUNCTION p_onlinepp_set_entry()
   IF INFIELD(gbo02) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gbo03",TRUE)
   END IF
END FUNCTION
 
FUNCTION p_onlinepp_set_no_entry()
   IF INFIELD(gbo02) OR (NOT g_before_input_done) THEN
      IF g_gbo[l_ac].gbo02 = "N" THEN
         CALL cl_set_comp_entry("gbo03",FALSE)
         LET g_gbo[l_ac].gbo03 = NULL
      END IF
   END IF
END FUNCTION
 
FUNCTION p_onlinepp_out()
   DEFINE   l_name   LIKE type_file.chr20      # External(Disk) file name        #No.FUN-680135 VARCHAR(20)
   DEFINE   ls_sql   STRING
   DEFINE   sr       RECORD
               gbo01 LIKE gbo_file.gbo01,
               gem02 LIKE gem_file.gem02,
               gbo04 LIKE gbo_file.gbo04,          #類別          #FUN-920138
               gbo04_n LIKE gae_file.gae04,        #類別多語言名稱  #FUN-920138
               gbo02 LIKE gbo_file.gbo02,
               gbo03 LIKE gbo_file.gbo03
                     END RECORD
   DEFINE    l_gae02  LIKE gae_file.gae02          #FUN-920138
 
   
   IF g_wc2 IS NULL THEN 
#      CALL cl_err('',-400,0)    #No.TQC-710076
      CALL cl_err('','9057',0)
      RETURN 
   END IF
   CALL cl_wait()
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET ls_sql="SELECT gbo01,'',gbo04,'',gbo02,gbo03 FROM gbo_file ",       # 組合出 SQL 指令   #FUN-920138 加gbo04,gbo04_n
              " WHERE ",g_wc2 CLIPPED
   PREPARE p_onlinepp_p1 FROM ls_sql           # RUNTIME 編譯
   DECLARE p_onlinepp_co CURSOR FOR p_onlinepp_p1
 
   CALL cl_outnam('p_onlinepp') RETURNING l_name
   START REPORT p_onlinepp_rep TO l_name
 
   FOREACH p_onlinepp_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      ###FUN-920138 START ###
      #類別多語言名稱
      LET l_gae02 = "gbo04_",sr.gbo04 CLIPPED
      SELECT gae04 INTO sr.gbo04_n 
         FROM gae_file
         WHERE gae01 = 'p_onlinepp'
           AND gae02 = l_gae02
           AND gae03 = g_lang      
      ###FUN-920138 END ###
      
      CALL p_onlinepp_gem02(sr.gbo01,sr.gbo04) RETURNING sr.gem02   #FUN-920138 加gbo04
      OUTPUT TO REPORT p_onlinepp_rep(sr.*)
   END FOREACH
 
   FINISH REPORT p_onlinepp_rep
 
   CLOSE p_onlinepp_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_onlinepp_rep(sr)
   DEFINE   l_trailer_sw   LIKE type_file.chr1,    #FUN-680135 VARCHAR(1)
            sr             RECORD 
               gbo01 LIKE gbo_file.gbo01,
               gem02 LIKE gem_file.gem02,
               gbo04 LIKE gbo_file.gbo04,          #類別          #FUN-920138
               gbo04_n LIKE gae_file.gae04,        #類別多語言名稱  #FUN-920138
               gbo02 LIKE gbo_file.gbo02,
               gbo03 LIKE gbo_file.gbo03
                     END RECORD
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
   ORDER BY sr.gbo01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno=g_pageno+1
         LET pageno_total=PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT g_dash[1,g_len]
         PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.gbo01,
               COLUMN g_c[32],sr.gem02,
               COLUMN g_c[35],sr.gbo04_n,   #FUN-920138
               COLUMN g_c[33],sr.gbo02,
               COLUMN g_c[34],sr.gbo03
 
      ON LAST ROW
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         LET l_trailer_sw = 'n'
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
             PRINT g_dash[1,g_len]
             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
             SKIP 2 LINE
         END IF
END REPORT
