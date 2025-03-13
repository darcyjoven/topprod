# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Program name...: p_gr_lang.4gl
# Descriptions...: GR樣版語系維護作業
# Date & Author..: 12/03/19 by janet
# Modify.........: No.FUN-C30205 12/03/19 by janet GR樣版語系維護作業
# Modify.........: No:FUN-D30034 13/04/17 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE   g_gfs         DYNAMIC ARRAY OF RECORD
            gfs01         LIKE gfs_file.gfs01,
            gfs02         LIKE gfs_file.gfs02,
            gfs03         LIKE gfs_file.gfs03
                        END RECORD,
         g_gfs_t       RECORD     #舊值
            gfs01         LIKE gfs_file.gfs01,
            gfs02         LIKE gfs_file.gfs02,
            gfs03         LIKE gfs_file.gfs03
                        END RECORD
 DEFINE  g_sql          string,                       
         g_cnt          LIKE type_file.num10,         
         l_ac           LIKE type_file.num5,          
         g_rec_b        LIKE type_file.num5           
 DEFINE  g_wc2          STRING,                       
         g_i            LIKE type_file.num5           
DEFINE   g_forupd_sql   STRING
DEFINE   g_before_input_done   LIKE type_file.num5    
DEFINE   g_argv1         LIKE gfs_file.gfs01     #傳入的gdw08 
 #FUN-C30205
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   LET g_argv1 = ARG_VAL(1)    #樣版ID
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) # 記錄時間
        RETURNING g_time    #No.FUN-6A0096
 
   OPEN WINDOW p_gr_lang_w WITH FORM "azz/42f/p_gr_lang"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_set_combo_lang("gfs02") #語言別

   IF NOT cl_null(g_argv1) THEN    #若傳入GDW08不是NULL 先查詢
      CALL p_gr_lang_q()
   END IF   
   CALL p_gr_lang_menu()
 
   CLOSE WINDOW p_gr_lang_w
 
   CALL cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
   RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_gr_lang_menu()
   LET g_action_choice = " "
   WHILE TRUE
      CALL p_gr_lang_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_gr_lang_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_gr_lang_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL p_gr_lang_out()
            END IF
         #WHEN "load"                          # "L.資料載回"
            #IF cl_chk_act_auth() THEN
               #CALL p_gr_lang_load()
            #END IF
         #WHEN "unload"                        # "D.下載資料"
            #IF cl_chk_act_auth() THEN
               #CALL p_gr_lang_unload()
            #END IF
        
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gfs),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_gr_lang_q()
   CALL p_gr_lang_b_askkey()
END FUNCTION
 
FUNCTION p_gr_lang_b()
   DEFINE   l_ac_t           LIKE type_file.num5,          
            l_n              LIKE type_file.num5,          
            l_lock_sw        LIKE type_file.chr1,          
            p_cmd            LIKE type_file.chr1,          
            l_allow_insert   LIKE type_file.num5,          
            l_allow_delete   LIKE type_file.num5           
   DEFINE   li_i             LIKE type_file.num5           
   DEFINE   lc_target        LIKE gay_file.gay01           
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
   
   LET g_forupd_sql = "SELECT * FROM gfs_file WHERE gfs01 = ? AND gfs02 = ? FOR UPDATE"
   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gfs_bcl CURSOR FROM g_forupd_sql
 
   INPUT ARRAY g_gfs WITHOUT DEFAULTS FROM s_gfs.*
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

         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd = 'u'
            LET g_gfs_t.* = g_gfs[l_ac].*

            LET g_before_input_done = FALSE
            CALL p_auth_as_set_entry_b(p_cmd)
            CALL p_auth_as_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE

 
            OPEN p_gfs_bcl USING g_gfs_t.gfs01,g_gfs_t.gfs02
            IF STATUS THEN
               CALL cl_err("OPEN p_gfs_bcl:",STATUS,1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_gfs_bcl INTO g_gfs[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gfs_t.gfs01,SQLCA.sqlcode,1)
                  LET l_lock_sw = 'Y'
               END IF
            END IF
            CALL cl_show_fld_cont()   

         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_gfs[l_ac].* TO NULL
         LET g_gfs_t.* = g_gfs[l_ac].*

         
         DISPLAY g_argv1 TO s_gfs[l_ac].gfs01 #將gdw08值帶入gfs01  key值
         LET   g_gfs[l_ac].gfs01= g_argv1
         
         
            LET g_before_input_done = FALSE
            CALL p_auth_as_set_entry_b(p_cmd)
            CALL p_auth_as_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE

         CALL cl_show_fld_cont()     
         #NEXT FIELD gfs01
            NEXT FIELD gfs02
      AFTER FIELD gfs02
         IF g_gfs[l_ac].gfs01 != g_gfs_t.gfs01 OR 
            g_gfs[l_ac].gfs02 != g_gfs_t.gfs02 OR
            (g_gfs[l_ac].gfs01 IS NOT NULL AND g_gfs_t.gfs01 IS NULL) OR
            (g_gfs[l_ac].gfs02 IS NOT NULL AND g_gfs_t.gfs02 IS NULL) THEN
            SELECT COUNT(*) INTO l_n FROM gfs_file
             WHERE gfs01 = g_gfs[l_ac].gfs01
               AND gfs02 = g_gfs[l_ac].gfs02
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_gfs[l_ac].gfs01 = g_gfs_t.gfs01
               LET g_gfs[l_ac].gfs02 = g_gfs_t.gfs02
               NEXT FIELD gfs02
            END IF
         END IF


      AFTER FIELD gfs03
         IF NOT cl_unicode_check02(g_gfs[l_ac].gfs02, g_gfs[l_ac].gfs03,"1") THEN
            
            NEXT FIELD gfs03
         END IF

 
      BEFORE DELETE
         IF g_gfs_t.gfs01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err("",-263,1)
               CANCEL DELETE
            END IF
            DELETE FROM gfs_file WHERE gfs01 = g_gfs_t.gfs01
               AND gfs02 = g_gfs_t.gfs02
            IF SQLCA.sqlcode THEN

               CALL cl_err3("del","gfs_file",g_gfs_t.gfs01,g_gfs_t.gfs02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF

      ON CHANGE  gfs02
         IF g_gfs[l_ac].gfs01 != g_gfs_t.gfs01 OR 
            g_gfs[l_ac].gfs02 != g_gfs_t.gfs02 OR
            (g_gfs[l_ac].gfs01 IS NOT NULL AND g_gfs_t.gfs01 IS NULL) OR
            (g_gfs[l_ac].gfs02 IS NOT NULL AND g_gfs_t.gfs02 IS NULL) THEN
            SELECT COUNT(*) INTO l_n FROM gfs_file
             WHERE gfs01 = g_gfs[l_ac].gfs01
               AND gfs02 = g_gfs[l_ac].gfs02
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_gfs[l_ac].gfs01 = g_gfs_t.gfs01
               LET g_gfs[l_ac].gfs02 = g_gfs_t.gfs02
               NEXT FIELD gfs02
            END IF
         END IF

 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            
            LET g_gfs[l_ac].* = g_gfs_t.*
            
            CLOSE p_gfs_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
       
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gfs[l_ac].gfs01,-263,1)
            LET g_gfs[l_ac].* = g_gfs_t.*
         ELSE
            UPDATE gfs_file SET gfs01 = g_gfs[l_ac].gfs01,
                                 gfs02 = g_gfs[l_ac].gfs02,
                                 gfs03 = g_gfs[l_ac].gfs03
             WHERE gfs01 = g_gfs_t.gfs01
               AND gfs02 = g_gfs_t.gfs02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gfs_file",g_gfs_t.gfs01,g_gfs_t.gfs02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_gfs[l_ac].* = g_gfs_t.*
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
            CLOSE p_gfs_bcl
            CANCEL INSERT
         END IF
 
         INSERT INTO gfs_file(gfs01,gfs02,gfs03)
         VALUES (g_gfs[l_ac].gfs01,g_gfs[l_ac].gfs02,
                 g_gfs[l_ac].gfs03)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gfs_file",g_gfs[l_ac].gfs01,g_gfs[l_ac].gfs02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
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
               LET g_gfs[l_ac].* = g_gfs_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_gfs.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_gfs_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         LET l_ac_t = l_ac
         CLOSE p_gfs_bcl
         COMMIT WORK
 
      
      #ON ACTION translate_zhtw
         #LET lc_target = ''
         #確認現在位置，決定待翻譯的目標語言別
         #CASE
            #WHEN g_gfs[l_ac].gfs02 = "0" LET lc_target = "2"
            #WHEN g_gfs[l_ac].gfs02 = "2" LET lc_target = "0"
         #END CASE
#
         #搜尋 PK值,找出正確待翻位置
         #FOR li_i = 1 TO g_gfs.getLength()
            #IF li_i = l_ac THEN CONTINUE FOR END IF
            #IF g_gfs[li_i].gfs01 = g_gfs[l_ac].gfs01 AND
               #g_gfs[li_i].gfs02 = lc_target THEN
               #CASE  #決定待翻欄位
                  #WHEN INFIELD(gfs03)
                     #LET g_gfs[l_ac].gfs03 = cl_trans_utf8_twzh(g_gfs[l_ac].gfs02,g_gfs[li_i].gfs03)
                     #DISPLAY g_gfs[l_ac].gfs03 TO gfs03
                     #EXIT FOR
               #END CASE
            #END IF
         #END FOR
      # No:FUN-BA0116 --- end ---

      ON ACTION CONTROLO
         IF INFIELD(gfs01) AND l_ac > 1 THEN
            LET g_gfs[l_ac].* = g_gfs[l_ac-1].*
            NEXT FIELD gfs01
         END IF
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
  
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
 
      END INPUT
 
   CLOSE p_gfs_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION p_gr_lang_b_askkey()
   DEFINE  l_gfs03_str   LIKE gfs_file.gfs03 
   DEFINE  l_gfs01       LIKE gfs_file.gfs01
   CLEAR FORM
   CALL g_gfs.clear()
   #若有傳值過來

    LET l_gfs01=g_argv1 CLIPPED #20120321 add
    DISPLAY l_gfs01 TO s_gfs[1].gfs01 #20120321 add
   IF NOT cl_null(g_argv1) THEN
     #LET l_gfs01=g_argv1 CLIPPED 
     LET g_wc2=NULL 
     LET g_wc2 = "gfs01 = '",l_gfs01 CLIPPED,"'"
     
     #DISPLAY l_gfs01 TO s_gfs[1].gfs01 #20120321 add
   ELSE
    CONSTRUCT g_wc2 ON gfs01,gfs02,gfs03
        FROM s_gfs[1].gfs01,s_gfs[1].gfs02,s_gfs[1].gfs03  
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
     END CONSTRUCT 
       LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          RETURN
       END IF   
   END IF


   CALL p_gr_lang_b_fill(g_wc2)
END FUNCTION
 
FUNCTION p_gr_lang_b_fill(lc_wc2)
   DEFINE   lc_wc2   LIKE type_file.chr1000 
 
   LET g_sql = "SELECT gfs01,gfs02,gfs03",
               "  FROM gfs_file",
               " WHERE ",lc_wc2 CLIPPED,
               " ORDER BY gfs01"
   PREPARE p_gfs_pb FROM g_sql
   DECLARE gfs_curs CURSOR FOR p_gfs_pb
 
   CALL g_gfs.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
   MESSAGE "Searching!"
   FOREACH gfs_curs INTO g_gfs[g_cnt].*
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
   CALL g_gfs.deleteElement(g_cnt)
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p_gr_lang_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_gfs TO s_gfs.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
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
          CALL cl_show_fld_cont()                   
 
      ON ACTION exit                   # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice = "detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice = "exit"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice = "output"
         EXIT DISPLAY
      #ON ACTION load
         #LET g_action_choice = "load"
         #EXIT DISPLAY
      #ON ACTION unload
         #LET g_action_choice = "unload"
         #EXIT DISPLAY
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      
      AFTER DISPLAY
         CONTINUE DISPLAY
   
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_gr_lang_out()
   DEFINE   l_gfs     RECORD LIKE gfs_file.*,
            l_i      LIKE type_file.num5,     #No.FUN-680135 SMALLINT
            l_name   LIKE type_file.chr20,    # External(Disk) file name #No.FUN-680135 VARCHAR(20)
            l_za05   LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(40)
            
            
 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0) RETURN
    END IF
    CALL cl_wait()

    CALL cl_outnam('p_gr_lang') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM gfs_file ",          # 組合出 SQL 指令
             " WHERE ",g_wc2 CLIPPED
    PREPARE p_gfs_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_gfs_co                         # SCROLL CURSOR
        CURSOR FOR p_gfs_p1
 
    START REPORT p_gfs_rep TO l_name
 
    FOREACH p_gfs_co INTO l_gfs.*
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
           END IF
       OUTPUT TO REPORT p_gfs_rep(l_gfs.*)
    END FOREACH
 
    FINISH REPORT p_gfs_rep
 
    CLOSE p_gfs_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_gfs_rep(sr)
   DEFINE   l_trailer_sw   LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
            sr             RECORD LIKE gfs_file.*,
            l_chr          LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.gfs01
 
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
         PRINT COLUMN g_c[31],sr.gfs01,
               COLUMN g_c[32],sr.gfs02,
               COLUMN g_c[33],sr.gfs03[1,66]
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
 
 


FUNCTION p_auth_as_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     #CALL cl_set_comp_entry("gfs01,gfs02",TRUE)  #20120321
     CALL cl_set_comp_entry("gfs01",FALSE )
     CALL cl_set_comp_entry("gfs02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_auth_as_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gfs01,gfs02",FALSE)
   END IF
 
END FUNCTION

 
 
