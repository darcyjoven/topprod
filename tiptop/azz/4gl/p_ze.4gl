# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Program name...: p_ze.4gl
# Descriptions...: 錯誤訊息維護作業
# Date & Author..: 03/12/30 by saki
# Modify.........: No.FUN-510050 05/01/28 By pengu 報表轉XML
# Modify.........: No.MOD-570346 05/07/28 By saki 改寫unload與load功能
# Modify.........: NO.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-940014 09/04/03 By alex 取消 g_max_b
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B90139 11/09/29 By tsai_yen 檢查簡繁字串
# Modify.........: No:FUN-BA0116 11/10/31 By joyce 新增繁簡體資料轉換action
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_ze         DYNAMIC ARRAY OF RECORD
            ze01         LIKE ze_file.ze01,
            ze02         LIKE ze_file.ze02,
            ze03         LIKE ze_file.ze03,
            ze04         LIKE ze_file.ze04,
            ze05         LIKE ze_file.ze05
                        END RECORD,
         g_ze_t       RECORD
            ze01         LIKE ze_file.ze01,
            ze02         LIKE ze_file.ze02,
            ze03         LIKE ze_file.ze03,
            ze04         LIKE ze_file.ze04,
            ze05         LIKE ze_file.ze05
                        END RECORD
 DEFINE  g_sql          string,                       #No.FUN-580092 HCN
         g_cnt          LIKE type_file.num10,         #No.FUN-680135 INTEGER
         l_ac           LIKE type_file.num5,          #No.FUN-680135 SMALLINT
         g_rec_b        LIKE type_file.num5           #No.FUN-680135 SMALLINT
 DEFINE  g_wc2          STRING,                       #No.FUN-580092 HCN
         g_i            LIKE type_file.num5           #No.FUN-680135 SMALLINT
DEFINE   g_forupd_sql   STRING
DEFINE   g_before_input_done   LIKE type_file.num5    #NO.MOD-580056 #No.FUN-680135 SMALLINT
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
        RETURNING g_time    #No.FUN-6A0096
 
   OPEN WINDOW p_ze_w WITH FORM "azz/42f/p_ze"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_set_combo_lang("ze02")
   CALL p_ze_menu()
 
   CLOSE WINDOW p_ze_w
 
   CALL cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
   RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_ze_menu()
   LET g_action_choice = " "
   WHILE TRUE
      CALL p_ze_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_ze_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_ze_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL p_ze_out()
            END IF
         WHEN "load"                          # "L.資料載回"
            IF cl_chk_act_auth() THEN
               CALL p_ze_load()
            END IF
         WHEN "unload"                        # "D.下載資料"
            IF cl_chk_act_auth() THEN
               CALL p_ze_unload()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ze),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_ze_q()
   CALL p_ze_b_askkey()
END FUNCTION
 
FUNCTION p_ze_b()
   DEFINE   l_ac_t           LIKE type_file.num5,          #No.FUN-680135 SMALLINT 
            l_n              LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_lock_sw        LIKE type_file.chr1,          #No.FUN-680135 VARCHAR(1)
            p_cmd            LIKE type_file.chr1,          #No.FUN-680135 VARCHAR(1)
            l_allow_insert   LIKE type_file.num5,          #No.FUN-680135 VARCHAR(1)
            l_allow_delete   LIKE type_file.num5           #No.FUN-680135 VARCHAR(1)
   DEFINE   li_i             LIKE type_file.num5           #暫存用數值   # NO:FUN-BA0116
   DEFINE   lc_target        LIKE gay_file.gay01           #No:FUN-BA0116
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT * FROM ze_file WHERE ze01 = ? AND ze02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_ze_bcl CURSOR FROM g_forupd_sql
 
   INPUT ARRAY g_ze WITHOUT DEFAULTS FROM s_ze.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED=TRUE,   #FUN-940014
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
        #LET g_ze[l_ac].ze05 = "N"
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd = 'u'
            LET g_ze_t.* = g_ze[l_ac].*
 #No.MOD-580056 --start
            LET g_before_input_done = FALSE
            CALL p_auth_as_set_entry_b(p_cmd)
            CALL p_auth_as_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 #No.MOD-580056 --end
 
            OPEN p_ze_bcl USING g_ze_t.ze01,g_ze_t.ze02
            IF STATUS THEN
               CALL cl_err("OPEN p_ze_bcl:",STATUS,1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_ze_bcl INTO g_ze[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ze_t.ze01,SQLCA.sqlcode,1)
                  LET l_lock_sw = 'Y'
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_ze[l_ac].* TO NULL
         LET g_ze[l_ac].ze04 = TODAY
         LET g_ze[l_ac].ze05 = "N"
         LET g_ze_t.* = g_ze[l_ac].*
 #No.MOD-580056 --start
            LET g_before_input_done = FALSE
            CALL p_auth_as_set_entry_b(p_cmd)
            CALL p_auth_as_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 #No.MOD-580056 --end
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD ze01
 
      AFTER FIELD ze02
         IF g_ze[l_ac].ze01 != g_ze_t.ze01 OR 
            g_ze[l_ac].ze02 != g_ze_t.ze02 OR
            (g_ze[l_ac].ze01 IS NOT NULL AND g_ze_t.ze01 IS NULL) OR
            (g_ze[l_ac].ze02 IS NOT NULL AND g_ze_t.ze02 IS NULL) THEN
            SELECT COUNT(*) INTO l_n FROM ze_file
             WHERE ze01 = g_ze[l_ac].ze01
               AND ze02 = g_ze[l_ac].ze02
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_ze[l_ac].ze01 = g_ze_t.ze01
               LET g_ze[l_ac].ze02 = g_ze_t.ze02
               NEXT FIELD ze01
            END IF
         END IF

      ###FUN-B90139 START ###
      AFTER FIELD ze03
         IF NOT cl_unicode_check02(g_ze[l_ac].ze02, g_ze[l_ac].ze03,"1") THEN
            NEXT FIELD ze03
         END IF
      ###FUN-B90139 END ###
 
      BEFORE DELETE
         IF g_ze_t.ze01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err("",-263,1)
               CANCEL DELETE
            END IF
            DELETE FROM ze_file WHERE ze01 = g_ze_t.ze01
               AND ze02 = g_ze_t.ze02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_ze_t.ze01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","ze_file",g_ze_t.ze01,g_ze_t.ze02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ze[l_ac].* = g_ze_t.*
            CLOSE p_ze_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
       
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ze[l_ac].ze01,-263,1)
            LET g_ze[l_ac].* = g_ze_t.*
         ELSE
            UPDATE ze_file SET ze01 = g_ze[l_ac].ze01,
                                 ze02 = g_ze[l_ac].ze02,
                                 ze03 = g_ze[l_ac].ze03,
                                 ze04 = TODAY,
                                 ze05 = g_ze[l_ac].ze05
             WHERE ze01 = g_ze_t.ze01
               AND ze02 = g_ze_t.ze02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_ze[l_ac].ze01,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","ze_file",g_ze_t.ze01,g_ze_t.ze02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_ze[l_ac].* = g_ze_t.*
               ROLLBACK WORK
            ELSE
               MESSAGE 'UPDATE OK'
               COMMIT WORK
            END IF
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE p_ze_bcl
            CANCEL INSERT
         END IF
 
         INSERT INTO ze_file(ze01,ze02,ze03,ze04,ze05)
         VALUES (g_ze[l_ac].ze01,g_ze[l_ac].ze02,
                 g_ze[l_ac].ze03,TODAY,g_ze[l_ac].ze05)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_ze[l_ac].ze01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","ze_file",g_ze[l_ac].ze01,g_ze[l_ac].ze02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT OK'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_ze[l_ac].* = g_ze_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_ze.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE p_ze_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE p_ze_bcl
         COMMIT WORK
 
      # No:FUN-BA0116 ---start---
      ON ACTION translate_zhtw
         LET lc_target = ''
         #確認現在位置，決定待翻譯的目標語言別
         CASE
            WHEN g_ze[l_ac].ze02 = "0" LET lc_target = "2"
            WHEN g_ze[l_ac].ze02 = "2" LET lc_target = "0"
         END CASE

         #搜尋 PK值,找出正確待翻位置
         FOR li_i = 1 TO g_ze.getLength()
            IF li_i = l_ac THEN CONTINUE FOR END IF
            IF g_ze[li_i].ze01 = g_ze[l_ac].ze01 AND
               g_ze[li_i].ze02 = lc_target THEN
               CASE  #決定待翻欄位
                  WHEN INFIELD(ze03)
                     LET g_ze[l_ac].ze03 = cl_trans_utf8_twzh(g_ze[l_ac].ze02,g_ze[li_i].ze03)
                     DISPLAY g_ze[l_ac].ze03 TO ze03
                     EXIT FOR
               END CASE
            END IF
         END FOR
      # No:FUN-BA0116 --- end ---

      ON ACTION CONTROLO
         IF INFIELD(ze01) AND l_ac > 1 THEN
            LET g_ze[l_ac].* = g_ze[l_ac-1].*
            NEXT FIELD ze01
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
 
   CLOSE p_ze_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_ze_b_askkey()
   CLEAR FORM
   CALL g_ze.clear()
   
   CONSTRUCT g_wc2 ON ze01,ze02,ze03,ze04,ze05
        FROM s_ze[1].ze01,s_ze[1].ze02,s_ze[1].ze03,
             s_ze[1].ze04,s_ze[1].ze05
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL p_ze_b_fill(g_wc2)
END FUNCTION
 
FUNCTION p_ze_b_fill(lc_wc2)
   DEFINE   lc_wc2   LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(1000)
 
   LET g_sql = "SELECT ze01,ze02,ze03,ze04,ze05",
               "  FROM ze_file",
               " WHERE ",lc_wc2 CLIPPED,
               " ORDER BY ze01"
   PREPARE p_ze_pb FROM g_sql
   DECLARE ze_curs CURSOR FOR p_ze_pb
 
   CALL g_ze.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
   MESSAGE "Searching!"
   FOREACH ze_curs INTO g_ze[g_cnt].*
      LET g_rec_b = g_rec_b + 1
      IF STATUS THEN
         CALL cl_err('FOREACH:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_ze.deleteElement(g_cnt)
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p_ze_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_ze TO s_ze.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query                  # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail                 # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help                   # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit                   # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice = "detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice = "output"
         EXIT DISPLAY
      ON ACTION load
         LET g_action_choice = "load"
         EXIT DISPLAY
      ON ACTION unload
         LET g_action_choice = "unload"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_ze_out()
   DEFINE   l_ze     RECORD LIKE ze_file.*,
            l_i      LIKE type_file.num5,     #No.FUN-680135 SMALLINT
            l_name   LIKE type_file.chr20,    # External(Disk) file name #No.FUN-680135 VARCHAR(20)
            l_za05   LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(40)
   
 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0) RETURN
    END IF
    CALL cl_wait()
    #LET l_name = 'p_ze.out'
    CALL cl_outnam('p_ze') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM ze_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE p_ze_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_ze_co                         # SCROLL CURSOR
        CURSOR FOR p_ze_p1
 
    START REPORT p_ze_rep TO l_name
 
    FOREACH p_ze_co INTO l_ze.*
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
           END IF
       OUTPUT TO REPORT p_ze_rep(l_ze.*)
    END FOREACH
 
    FINISH REPORT p_ze_rep
 
    CLOSE p_ze_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_ze_rep(sr)
   DEFINE   l_trailer_sw   LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
            sr             RECORD LIKE ze_file.*,
            l_chr          LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.ze01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         LET g_pageno=g_pageno+1
         LET pageno_total=PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT g_dash[1,g_len]
         PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED
         PRINT g_dash1
         LET l_trailer_sw = 'y'
      ON EVERY ROW
         PRINT COLUMN g_c[31],sr.ze01,
               COLUMN g_c[32],sr.ze02,
               COLUMN g_c[33],sr.ze03[1,66]
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
 
 #No.MOD-570346 --start--
FUNCTION p_ze_unload()
   DEFINE   file_name        LIKE type_file.chr20,   #No.FUN-680135 VARCHAR(10)
            file_extension   LIKE type_file.chr20    #No.FUN-680135 VARCHAR(10)
   DEFINE   ls_tempdir       STRING
   DEFINE   lc_channel       base.Channel
   DEFINE   ls_str           STRING
   DEFINE   ls_file          STRING
   DEFINE   ls_cmd           STRING
   DEFINE   lc_msg           LIKE ze_file.ze03
   DEFINE   li_i             LIKE type_file.num10    #No.FUN-680135 INTEGER
 
   IF g_ze.getLength() <= 0 THEN
      CALL cl_err("","axc-034",1)
      RETURN
   END IF
 
   OPEN WINDOW p_ze_2_w WITH FORM "azz/42f/p_ze_2"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_ze_2")
 
   LET file_name = NULL
   LET file_extension = 'ze'
   INPUT BY NAME file_name,file_extension WITHOUT DEFAULTS
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #FUN-860033
 
      ON ACTION controlg      #FUN-860033
         CALL cl_cmdask()     #FUN-860033
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT
   END INPUT
 
   CLOSE WINDOW p_ze_2_w
 
   LET lc_channel = base.Channel.create()
   LET ls_tempdir = FGL_GETENV("TEMPDIR")
   LET ls_file = ls_tempdir,"/",file_name CLIPPED,"_",file_extension CLIPPED,".txt"
   CALL lc_channel.openFile(ls_file,"w")
   IF STATUS THEN
      CALL cl_err(STATUS,"azz-725",1)
      RETURN
   END IF
   CALL lc_channel.setDelimiter("")
   FOR li_i = 1 TO g_ze.getLength()
       LET ls_str = g_ze[li_i].ze01 CLIPPED,"",g_ze[li_i].ze02 CLIPPED,"",
                    g_ze[li_i].ze03 CLIPPED,"",g_ze[li_i].ze04 CLIPPED,"",
                    g_ze[li_i].ze05 CLIPPED
       CALL lc_channel.write(ls_str)
   END FOR
   CALL lc_channel.close()
 
   LET ls_cmd = "chmod 775 ",ls_file
   RUN ls_cmd
 
   SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01 = "azz-076" AND ze02 = g_lang
   MESSAGE lc_msg CLIPPED,":",ls_file
END FUNCTION
 
FUNCTION p_ze_load()
   DEFINE   file_name        LIKE type_file.chr20,  #No.FUN-680135 VARCHAR(10)
            file_extension   LIKE type_file.chr20   #No.FUN-680135 VARCHAR(10)
   DEFINE   lc_channel       base.Channel
   DEFINE   ls_str           STRING
   DEFINE   ls_file          STRING
   DEFINE   li_i             LIKE type_file.num10   #No.FUN-680135 INTEGER
   DEFINE   lst_ze_fields    base.StringTokenizer
   DEFINE   ls_ze_field      STRING
   DEFINE   lr_ze            RECORD LIKE ze_file.*
   DEFINE   ls_msg           STRING
   DEFINE   li_result        LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   lc_msg           LIKE ze_file.ze03
 
 
   OPEN WINDOW p_ze_1_w WITH FORM "azz/42f/p_ze_1"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("p_ze_1")
 
   LET file_name = NULL
   LET file_extension = 'ze'
   INPUT BY NAME file_name,file_extension WITHOUT DEFAULTS
 
   CLOSE WINDOW p_ze_1_w
 
   LET ls_msg = NULL
   LET li_result = TRUE
   LET lc_channel = base.Channel.create()
   LET ls_file = file_name CLIPPED,"_",file_extension CLIPPED,".txt"
   CALL lc_channel.openFile(ls_file,"r")
   IF STATUS THEN
      CALL cl_err(STATUS,"azz-725",1)
      RETURN
   END IF
   CALL lc_channel.setDelimiter("")
   WHILE (lc_channel.read(ls_str))
      LET li_i = 1
      LET lst_ze_fields = base.StringTokenizer.create(ls_str,"")
      WHILE lst_ze_fields.hasMoreTokens()
         LET ls_ze_field = lst_ze_fields.nextToken()
         LET ls_ze_field = ls_ze_field.trimRight()
         CASE li_i
            WHEN 1
               LET lr_ze.ze01 = ls_ze_field
            WHEN 2
               LET lr_ze.ze02 = ls_ze_field
            WHEN 3
               LET lr_ze.ze03 = ls_ze_field
            WHEN 4
               LET lr_ze.ze04 = ls_ze_field
            WHEN 5
               LET lr_ze.ze05 = ls_ze_field
         END CASE
         LET li_i = li_i + 1
      END WHILE
      INSERT INTO ze_file VALUES(lr_ze.*)
      IF SQLCA.sqlcode THEN
         UPDATE ze_file SET ze01 = lr_ze.ze01,ze02 = lr_ze.ze02,
                            ze03 = lr_ze.ze03,ze04 = lr_ze.ze04,
                            ze05 = lr_ze.ze05
                      WHERE ze01 = lr_ze.ze01 AND ze02 = lr_ze.ze02
         IF SQLCA.sqlcode THEN
            LET li_result = FALSE
            IF cl_null(ls_msg) THEN
               LET ls_msg = lr_ze.ze01 CLIPPED,"|",lr_ze.ze02 CLIPPED
            ELSE
               LET ls_msg = ls_msg,",",lr_ze.ze01 CLIPPED,"|",lr_ze.ze02 CLIPPED
            END IF
         END IF
      END IF
   END WHILE
   CALL lc_channel.close()
 
   IF NOT li_result THEN
      CALL cl_err(ls_msg,"azz-724",1)
   ELSE
      SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01 = "9062" AND ze02 = g_lang
      MESSAGE lc_msg CLIPPED
   END IF
END FUNCTION
 #No.MOD-570346 ---end---
 
#FUNCTION p_ze_unload()
#   DEFINE   file_name,file_extension   LIKE cre_file.cre08,  #FUN-680135 
#            l_sql                      LIKE type_file.chr1000#No.FUN-680135
#   DEFINE   l_status                   LIKE type_file.num5   #FUN-680135 
#
#
#   IF s_shut(0) THEN RETURN END IF
#
#   LET p_row = 12 LET p_col = 24
#   OPEN WINDOW p_ze_2_w AT p_row,p_col WITH FORM "azz/42f/p_ze_2"
#   ATTRIBUTE (STYLE = "sm1")
#
#    CALL cl_ui_locale("p_ze_2")
#
#       
#   LET file_name = NULL
#   LET file_extension = 'ze'
#   INPUT BY NAME file_name,file_extension WITHOUT DEFAULTS
#
#   CLOSE WINDOW p_ze_2_w
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
#   MESSAGE ' UNLOAD...... ' 
#   -----------------------------------------------------------------------
#   LET l_sql = 'unload "',file_name CLIPPED,'.',file_extension CLIPPED,
#               ' SELECT * FROM ze_file WHERE ',g_wc2 CLIPPED,'"'
#   RUN l_sql  RETURNING l_status
#   IF l_status THEN CALL cl_err('unload:',STATUS,0) RETURN END IF 
#   MESSAGE ' UNLOADed...... ' 
#END FUNCTION
#
#FUNCTION p_ze_load()
#   DEFINE   file_name,file_extension   VARCHAR(10),
#            l_zet                      RECORD LIKE zet_file.*,
#            l_sql                      LIKE type_file.chr1000       #No.FUN-680135
#
#   IF s_shut(0) THEN RETURN END IF
#
#   LET p_row = 10 LET p_col = 23
#   OPEN WINDOW p_ze_1_w AT p_row,p_col WITH FORM "azz/42f/p_ze_1"
#   ATTRIBUTE (STYLE = "sm1")
#
#    CALL cl_ui_locale("p_ze_1")
#
#       
#   LET file_name = NULL  
#   LET file_extension = 'ze'
#   INPUT BY NAME file_name,file_extension WITHOUT DEFAULTS
#
#   CLOSE WINDOW p_ze_1_w
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
#   MESSAGE ' LOAD...... ' 
#   --------------------------------------------------------------------
#   DELETE FROM zet_file WHERE 1=1
#   LET l_sql = "upload ","zet ",
#                 file_name CLIPPED,".",file_extension CLIPPED
#   RUN l_sql
#{
#   DELETE FROM ze_file WHERE ze01 IN 
#              (SELECT zet01 FROM zet_file WHERE zet01 = ze01) AND
#                             ze02 IN
#              (SELECT zet02 FROM zet_file WHERE zet02 = ze02)
#}
#   DECLARE zet_cur CURSOR FOR
#                   SELECT * FROM zet_file WHERE 1=1
#
#   BEGIN WORK
#   FOREACH zet_cur INTO l_zet.*
#      DELETE FROM ze_file 
#       WHERE ze01=l_zet.zet01
#         AND ze02=l_zet.zet02
#   END FOREACH
#   IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,1)
#      ROLLBACK WORK
#   END IF
#   INSERT INTO ze_file SELECT * FROM zet_file
#   IF STATUS THEN 
#      CALL cl_err('load:',STATUS,0) 
#      ROLLBACK WORK
#      RETURN 
#   END IF 
#   COMMIT WORK
#   MESSAGE ' LOADed...... ' 
#END FUNCTION
 
 #NO.MOD-580056---
FUNCTION p_auth_as_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("ze01,ze02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_auth_as_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("ze01,ze02",FALSE)
   END IF
 
END FUNCTION
 #No.MOD-580056 --end
 
 
