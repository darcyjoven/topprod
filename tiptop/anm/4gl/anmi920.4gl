# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Prog.Version..: '2.00.01-05.10.28(00000)'     #
# Pattern name...: anmi920.4gl
# Descriptions...: 自定義類別設定作業
# Date & Author..: 06/02/22 By Nicola
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-760066 07/06/19 By chenl   打印類別說明，而非代碼。
# Modify.........: No.FUN-790050 07/09/06 By Carrier _out()轉p_query實現
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_nqd        DYNAMIC ARRAY OF RECORD
                       nqd01   LIKE nqd_file.nqd01,
                       nqd02   LIKE nqd_file.nqd02,
                       nqd03   LIKE nqd_file.nqd03
                    END RECORD,
       g_nqd_t      RECORD
                       nqd01   LIKE nqd_file.nqd01,
                       nqd02   LIKE nqd_file.nqd02,
                       nqd03   LIKE nqd_file.nqd03
                    END RECORD,
       g_wc,g_sql   STRING,     
       g_rec_b      LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       l_ac         LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_forupd_sql STRING    
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680107 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
 
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW i920_w AT p_row,p_col
     WITH FORM "anm/42f/anmi920"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i920_menu()
 
   CLOSE WINDOW i920_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
END MAIN
FUNCTION i920_menu()
 
   WHILE TRUE
      CALL i920_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i920_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i920_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i920_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "anmi920" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nqd),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i920_q()
 
   CALL i920_b_askkey()
 
END FUNCTION
 
FUNCTION i920_b()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_anmshut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nqd01,nqd02,nqd03 FROM nqd_file",
                      " WHERE nqd01=? AND nqd04='2' FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i920_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nqd WITHOUT DEFAULTS FROM s_nqd.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_nqd_t.* = g_nqd[l_ac].*
            BEGIN WORK
            OPEN i920_bcl USING g_nqd_t.nqd01
            IF STATUS THEN
               CALL cl_err("OPEN i920_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i920_bcl INTO g_nqd[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_nqd_t.nqd01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nqd[l_ac].* TO NULL
         LET g_nqd[l_ac].nqd03 = "1"
         LET g_nqd_t.* = g_nqd[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD nqd01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO nqd_file (nqd01,nqd02,nqd03,nqd04,nqdoriu,nqdorig)
              VALUES(g_nqd[l_ac].nqd01,g_nqd[l_ac].nqd02,g_nqd[l_ac].nqd03,"2", g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nqd[l_ac].nqd01,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nqd_file",g_nqd[l_ac].nqd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      AFTER FIELD nqd01
         IF NOT cl_null(g_nqd[l_ac].nqd01) THEN
            IF cl_null(g_nqd_t.nqd01) OR g_nqd[l_ac].nqd01 != g_nqd_t.nqd01 THEN
               SELECT COUNT(*) INTO g_cnt FROM nqd_file
                WHERE nqd01 = g_nqd[l_ac].nqd01
               IF g_cnt > 0 THEN
                  CALL cl_err(g_nqd[l_ac].nqd01,"axm-298",0)
                  NEXT FIELD nqd01
               END IF
            END IF
         END IF
 
      BEFORE DELETE
         IF NOT cl_null(g_nqd_t.nqd01) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM nqd_file
             WHERE nqd01 = g_nqd_t.nqd01
               AND nqd04 = "2"
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nqd_t.nqd01,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","nqd_file",g_nqd_t.nqd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            COMMIT WORK
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_nqd[l_ac].* = g_nqd_t.*
            CLOSE i920_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nqd[l_ac].nqd01,-263,1)
            LET g_nqd[l_ac].* = g_nqd_t.*
         ELSE
            UPDATE nqd_file SET nqd01 = g_nqd[l_ac].nqd01,
                                nqd02 = g_nqd[l_ac].nqd02,
                                nqd03 = g_nqd[l_ac].nqd03
             WHERE nqd01 = g_nqd_t.nqd01
               AND nqd04 = "2"
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nqd[l_ac].nqd01,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","nqd_file",g_nqd_t.nqd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_nqd[l_ac].* = g_nqd_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nqd[l_ac].* = g_nqd_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_nqd.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i920_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30032 Add 
         CLOSE i920_bcl
         COMMIT WORK
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
   CLOSE i920_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i920_b_askkey()
 
   CLEAR FORM
   CALL g_nqd.clear()
 
   CONSTRUCT g_wc ON nqd01,nqd02,nqd03
        FROM s_nqd[1].nqd01,s_nqd[1].nqd02,s_nqd[1].nqd03
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
    
      ON ACTION help
         CALL cl_show_help()
    
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
  
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nqduser', 'nqdgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN
#      RETURN
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   CALL i920_b_fill(g_wc)
 
END FUNCTION
 
 
FUNCTION i920_b_fill(p_wc)
   DEFINE p_wc   LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(200)
 
   LET g_sql = "SELECT nqd01,nqd02,nqd03 FROM nqd_file ",
               " WHERE ",p_wc CLIPPED ,
               "   AND nqd04 = '2'",
               " ORDER BY nqd01"
 
   PREPARE i920_prepare2 FROM g_sql
   DECLARE nqd_cs CURSOR FOR i920_prepare2
 
   LET g_cnt = 1
   LET g_rec_b=0
   CALL g_nqd.clear()
 
   FOREACH nqd_cs INTO g_nqd[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_nqd.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i920_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nqd TO s_nqd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#No.FUN-790050  --Begin
#FUNCTION i920_out()
#   DEFINE l_name   LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
#          sr       RECORD     
#                      nqd01    LIKE nqd_file.nqd01,
#                      nqd02    LIKE nqd_file.nqd02,
#                      nqd03    LIKE nqd_file.nqd03
#                   END RECORD 
#
##No.TQC-710076 -- begin --
#   IF cl_null(g_wc) THEN
#      CALL cl_err("","9057",0)
#      RETURN
#   END IF
##No.TQC-710076 -- end --
#   CALL cl_wait()
#   CALL cl_outnam('anmi920') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#
#   LET g_sql = "SELECT nqd01,nqd02,nqd03",
#               "  FROM nqd_file ",
#               " WHERE ",g_wc CLIPPED
#
#   PREPARE i920_p1 FROM g_sql
#   DECLARE i920_curo CURSOR FOR i920_p1
#
#   START REPORT i920_rep TO l_name
#
#   FOREACH i920_curo INTO sr.*   
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#         EXIT FOREACH
#      END IF
#
#      OUTPUT TO REPORT i920_rep(sr.*)
#
#   END FOREACH
#
#   FINISH REPORT i920_rep
#
#   CLOSE i920_curo
#   ERROR ""
#
#   CALL cl_prt(l_name,' ','1',g_len)
#
#END FUNCTION
#
#REPORT i920_rep(sr)
#   DEFINE l_trailer_sw   LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
#          sr             RECORD     
#                            nqd01    LIKE nqd_file.nqd01,
#                            nqd02    LIKE nqd_file.nqd02,
#                            nqd03    LIKE nqd_file.nqd03
#                         END RECORD 
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.nqd01
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno" 
#         PRINT g_head CLIPPED,pageno_total     
#         PRINT 
#         PRINT g_dash
#         PRINT g_x[31],g_x[32],g_x[33]
#         PRINT g_dash1 
#         LET l_trailer_sw = "Y"
#
#      ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.nqd01 CLIPPED,
#               COLUMN g_c[32],sr.nqd02 CLIPPED;
#              #No.TQC-760066--begin--
#              #COLUMN g_c[33],sr.nqd03 CLIPPED
#               IF NOT cl_null(sr.nqd03) THEN 
#                  CASE sr.nqd03
#                       WHEN '1'
#                         PRINT COLUMN g_c[33],g_x[34] CLIPPED 
#                       WHEN '2'
#                         PRINT COLUMN g_c[33],g_x[35] CLIPPED 
#                       WHEN '3'
#                         PRINT COLUMN g_c[33],g_x[36] CLIPPED 
#                       OTHERWISE 
#                         EXIT CASE
#                  END CASE 
#               END IF 
#              #No.TQC-760066--end --
#
#      ON LAST ROW
#         PRINT g_dash
#         PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#         LET l_trailer_sw = "N"
#
#      PAGE TRAILER
#         IF l_trailer_sw = "Y" THEN
#             PRINT g_dash
#             PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE
#             SKIP 2 LINE
#         END IF
#
#END REPORT
#No.FUN-790050  --End  
