# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: axcp015.4gl
# Descriptions...: 產品分類轉撥計價加成百分比設定作業
# Date & Author..: 00/04/18 By Kammy
# Modify.........: No.FUN-4C0099 05/01/10 By kim 報表轉XML功能
# Modify.........: NO.MOD-590014 05/09/05 By Rosayu 單身刪除後資料沒有被刪除
# Modify.........: No.TQC-5C0030 05/12/07 By kevin 結束位置調整
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-970193 09/07/20 By dxfwo  若沒有新增功能，就把按鈕取消，否則新增只能輸入 加成% 也很奇怪
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_oba           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        oba01       LIKE oba_file.oba01,  
        oba02       LIKE oba_file.oba02, 
        oba07       LIKE oba_file.oba07
                    END RECORD,
    g_oba_t         RECORD                 #程式變數 (舊值)
        oba01       LIKE oba_file.oba01,  
        oba02       LIKE oba_file.oba02, 
        oba07       LIKE oba_file.oba07
                    END RECORD,
    g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW p015_w WITH FORM "axc/42f/axcp015"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL p015_b_fill(g_wc2)
   CALL p015_menu()
   CLOSE WINDOW p015_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0146
END MAIN
 
FUNCTION p015_menu()
   WHILE TRUE
      CALL p015_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL p015_q() 
            END IF
         WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL p015_b() 
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN
               CALL p015_out() 
            END IF
         WHEN "help"  CALL cl_show_help()
         WHEN "exit" EXIT WHILE
         WHEN "controlg" CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p015_q()
   CALL p015_b_askkey()
END FUNCTION
 
FUNCTION p015_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用               #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否              #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態                #No.FUN-680122 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否                 #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否                 #No.FUN-680122 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
      " SELECT oba01,oba02,oba07,'' ",
      " FROM oba_file ",
      " WHERE oba01= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p015_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
#       LET l_allow_insert = cl_detail_input_auth("insert")  #No.TQC-970193
        LET l_allow_insert = false   #No.TQC-970193
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_oba WITHOUT DEFAULTS FROM s_oba.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
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
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
                LET g_oba_t.* = g_oba[l_ac].*  #BACKUP
                LET p_cmd='u'
                OPEN p015_bcl USING g_oba_t.oba01               #表示更改狀態
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_oba_t.oba01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH p015_bcl INTO g_oba[l_ac].* 
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_oba_t.oba01,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                IF cl_null(g_oba[l_ac].oba07) THEN
                    LET  g_oba[l_ac].oba07=0
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
        AFTER FIELD oba01                        #check 編號是否重複
            IF g_oba[l_ac].oba01 != g_oba_t.oba01 OR
               (g_oba[l_ac].oba01 IS NOT NULL AND g_oba_t.oba01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM oba_file
                    WHERE oba01 = g_oba[l_ac].oba01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_oba[l_ac].oba01 = g_oba_t.oba01
                    NEXT FIELD oba01
                END IF
            END IF
        
        AFTER FIELD oba07
            IF cl_null(g_oba[l_ac].oba07) THEN 
               LET g_oba[l_ac].oba07 = 0 
               DISPLAY g_oba[l_ac].oba07 TO oba07
            END IF
 
        BEFORE DELETE
          IF NOT cl_null(g_oba_t.oba01) THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw ="Y" THEN
                CALL cl_err("",-263,1)
                CANCEL DELETE
             END IF
             DELETE FROM oba_file where oba01 = g_oba_t.oba01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_oba_t.oba01,SQLCA.sqlcode,0)   #No.FUN-660127
                CALL cl_err3("del","oba_file",g_oba_t.oba01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660127
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
             MESSAGE "Delete OK"
             CLOSE p015_bcl
             COMMIT WORK
          END IF
        #MOD-590014 end
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oba[l_ac].* = g_oba_t.*
               CLOSE p015_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_oba[l_ac].oba01,-263,1)
                LET g_oba[l_ac].* = g_oba_t.*
            ELSE
                UPDATE oba_file SET oba07  = g_oba[l_ac].oba07
                       WHERE oba01=g_oba[l_ac].oba01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_oba[l_ac].oba01,SQLCA.sqlcode,1)   #No.FUN-660127
                   CALL cl_err3("upd","oba_file",g_oba_t.oba01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660127
                ELSE
                   COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oba[l_ac].* = g_oba_t.*
               END IF
               CLOSE p015_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE p015_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL p015_b_askkey()
      #     EXIT INPUT
 
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
 
        
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        END INPUT
 
    CLOSE p015_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION p015_b_askkey()
    CLEAR FORM
    CALL g_oba.clear()
    CONSTRUCT g_wc2 ON oba01,oba02,oba07
            FROM s_oba[1].oba01,s_oba[1].oba02,s_oba[1].oba07
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
  
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL p015_b_fill(g_wc2)
END FUNCTION
 
FUNCTION p015_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
 
    LET g_sql =
        "SELECT oba01,oba02,oba07,''",
        " FROM oba_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE p015_pb FROM g_sql
    DECLARE oba_curs CURSOR FOR p015_pb
 
    CALL g_oba.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH oba_curs INTO g_oba[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    MESSAGE ""
    CALL g_oba.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p015_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oba TO s_oba.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p015_out()
    DEFINE
        l_oba           RECORD LIKE oba_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),                # External(Disk) file name
        l_za05          LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(40)                 #
   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0) RETURN END IF
#      CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
#   LET l_name = 'axcp015.out'
    CALL cl_outnam('axcp015') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM oba_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE p015_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p015_co CURSOR FOR p015_p1
 
    START REPORT p015_rep TO l_name
 
    FOREACH p015_co INTO l_oba.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT p015_rep(l_oba.*)
    END FOREACH
 
    FINISH REPORT p015_rep
 
    CLOSE p015_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p015_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1), 
        sr RECORD LIKE oba_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.oba01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<','/pageno'
            PRINT g_head CLIPPED,pageno_total
            PRINT 
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33]
            PRINT g_dash1
 
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.oba01,
                  COLUMN g_c[32],sr.oba02,
                  COLUMN g_c[33],sr.oba07 USING "#######&.&&&" #No.TQC-5C0030
 
        ON LAST ROW
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5C0030
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN  (g_len-9), g_x[6] CLIPPED #No.TQC-5C0030
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
