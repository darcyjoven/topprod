# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: p_cateset.4gl
# Descriptions...: udm_tree資料查詢類別設定維謢程式 No.FUN-570225
# Date & Author..: 06/11/03 By Jack Lai
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_gcn           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gcn01       LIKE gcn_file.gcn01,   #類別代碼
        gcn02       LIKE gcn_file.gcn02,   #語言別
        gcn03       LIKE gcn_file.gcn03,   #類別名稱
        gcn04       LIKE gcn_file.gcn04    #備註
                    END RECORD,
    g_gcn_t         RECORD                 #程式變數 (舊值)
        gcn01       LIKE gcn_file.gcn01,   #類別代碼
        gcn02       LIKE gcn_file.gcn02,   #語言別
        gcn03       LIKE gcn_file.gcn03,   #類別名稱
        gcn04       LIKE gcn_file.gcn04    #備註
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680102 VARCHAR(80)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT
 
DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680102 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110  #No.FUN-680102 SMALLINT
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE g_on_change  LIKE type_file.num5      #No.FUN-680102 SMALLINT   #FUN-550077
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680102 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    #No.FUN-570225
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW p_cateset_w AT p_row,p_col WITH FORM "azz/42f/p_cateset"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    
    CALL cl_set_combo_lang("gcn02")
 
    LET g_wc2 = '1=1'
    CALL p_cateset_b_fill(g_wc2)
    CALL p_cateset_menu()
    CLOSE WINDOW p_cateset_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
FUNCTION p_cateset_menu()
 
   WHILE TRUE
      CALL p_cateset_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_cateset_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL p_cateset_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL p_cateset_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_gcn[l_ac].gcn01 IS NOT NULL THEN
                  LET g_doc.column1 = "gcn01"
                  LET g_doc.value1 = g_gcn[l_ac].gcn01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gcn),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_cateset_q()
   CALL p_cateset_b_askkey()
END FUNCTION
 
FUNCTION p_cateset_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT      #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用             #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否             #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態               #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1,                 #No.FUN-680102 VARCHAR(01),              #可刪除否
    v               string
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT gcn01,gcn02,gcn03,gcn04",
                       "  FROM gcn_file WHERE gcn01=? AND gcn02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_cateset_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gcn WITHOUT DEFAULTS FROM s_gcn.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
        LET g_on_change = TRUE         #FUN-550077
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                      
           CALL p_cateset_set_entry(p_cmd)                                           
           CALL p_cateset_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
           LET g_gcn_t.* = g_gcn[l_ac].*  #BACKUP
           OPEN p_cateset_bcl USING g_gcn_t.gcn01, g_gcn_t.gcn02
           IF STATUS THEN
              CALL cl_err("OPEN p_cateset_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH p_cateset_bcl INTO g_gcn[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_gcn_t.gcn01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
 
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                        
         CALL p_cateset_set_entry(p_cmd)                                             
         CALL p_cateset_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_gcn[l_ac].* TO NULL      #900423
 
         LET g_gcn_t.* = g_gcn[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gcn01
 
     AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE p_cateset_bcl
           CANCEL INSERT
        END IF
        
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO gcn_file(gcn01,gcn02,gcn03,gcn04)
               VALUES(g_gcn[l_ac].gcn01,g_gcn[l_ac].gcn02,
               g_gcn[l_ac].gcn03,g_gcn[l_ac].gcn04)
        IF SQLCA.sqlcode THEN
 
           CALL cl_err3("ins","gcn_file",g_gcn[l_ac].gcn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b=g_rec_b+1
           DISPLAY g_rec_b TO FORMONLY.cn2
 
           COMMIT WORK
        END IF
 
#     AFTER FIELD gcn01                        #check 編號是否重複
#        IF NOT cl_null(g_gcn[l_ac].gcn01) THEN
#           IF g_gcn[l_ac].gcn01 != g_gcn_t.gcn01 OR
#              g_gcn_t.gcn01 IS NULL THEN
#              SELECT count(*) INTO l_n FROM gcn_file
#               WHERE gcn01 = g_gcn[l_ac].gcn01
#              IF l_n > 0 THEN
#                  CALL cl_err('',-239,0)
#                  LET g_gcn[l_ac].gcn01 = g_gcn_t.gcn01
#                  NEXT FIELD gcn01
#              END IF
#           END IF
#        END IF
        
     AFTER FIELD gcn02                        #check 類別代碼是否在gcn01中
        IF NOT cl_null(g_gcn[l_ac].gcn02) THEN
            SELECT count(*) INTO l_n FROM gay_file
            WHERE gay01 = g_gcn[l_ac].gcn02
            IF l_n <= 0 THEN
               CALL cl_err('',g_errno,0)
               LET g_gcn[l_ac].gcn02 = g_gcn_t.gcn02
               NEXT FIELD gcn02
            END IF
        END IF
 
     BEFORE DELETE                            #是否取消單身
         IF g_gcn_t.gcn01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE
            END IF
            INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
            LET g_doc.column1 = "gcn01"               #No.FUN-9B0098 10/02/24
            LET g_doc.value1 = g_gcn[l_ac].gcn01      #No.FUN-9B0098 10/02/24
            CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK      #FUN-680010
               CANCEL DELETE 
            END IF 
            DELETE FROM gcn_file WHERE gcn01 = g_gcn_t.gcn01 AND gcn02 = g_gcn_t.gcn02
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_gcn_t.gcn01,SQLCA.sqlcode,0)   #No.FUN-660131
                CALL cl_err3("del","gcn_file",g_gcn_t.gcn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                ROLLBACK WORK      #FUN-680010
                CANCEL DELETE
                EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 #新增程式段
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_gcn[l_ac].* = g_gcn_t.*
          CLOSE p_cateset_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_gcn[l_ac].gcn01,-263,0)
           LET g_gcn[l_ac].* = g_gcn_t.*
        ELSE
 
           UPDATE gcn_file SET gcn01=g_gcn[l_ac].gcn01,
                               gcn02=g_gcn[l_ac].gcn02,
                               gcn03=g_gcn[l_ac].gcn03,
                               gcn04=g_gcn[l_ac].gcn04
           WHERE gcn01 = g_gcn_t.gcn01 AND gcn02 = g_gcn_t.gcn02
           IF SQLCA.sqlcode THEN
 
              CALL cl_err3("upd","gcn_file",g_gcn_t.gcn01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK    #FUN-680010
              LET g_gcn[l_ac].* = g_gcn_t.*
           ELSE
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
           END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            # 新增
       #LET l_ac_t = l_ac      #FUN-D30034 mark 
 
        IF INT_FLAG THEN                 #900423
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_gcn[l_ac].* = g_gcn_t.*
           #FUN-D30034--add--begin--
           ELSE
              CALL g_gcn.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30034--add--end----
           END IF
           CLOSE p_cateset_bcl                # 新增
           ROLLBACK WORK                 # 新增
           EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE p_cateset_bcl                # 新增
         COMMIT WORK
 
   # ON ACTION CONTROLN
   #     CALL p_cateset_b_askkey()
   #     EXIT INPUT
 
     ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gcn01) AND l_ac > 1 THEN
             LET g_gcn[l_ac].* = g_gcn[l_ac-1].*
             NEXT FIELD gcn01
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
 
    CLOSE p_cateset_bcl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION p_cateset_b_askkey()
    CLEAR FORM
    CALL g_gcn.clear()
 
    CONSTRUCT g_wc2 ON gcn01,gcn02,gcn03,gcn04
         FROM s_gcn[1].gcn01,s_gcn[1].gcn02,s_gcn[1].gcn03,s_gcn[1].gcn04
 
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
      ON ACTION qbe_save
         CALL cl_qbe_save()
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
 
    CALL p_cateset_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_cateset_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
 
    LET g_sql = "SELECT gcn01,gcn02,gcn03,gcn04",
                " FROM gcn_file",
                " WHERE ", p_wc2 CLIPPED,           #單身
                " ORDER BY gcn01,gcn02" 
 
    PREPARE p_cateset_pb FROM g_sql
    DECLARE gcn_curs CURSOR FOR p_cateset_pb
 
    CALL g_gcn.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH gcn_curs INTO g_gcn[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_gcn.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_cateset_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gcn TO s_gcn.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
   
#@    ON ACTION 相關文件  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_cateset_out()
    DEFINE
        l_gen           RECORD LIKE gcn_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680102 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680102 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #  #No.FUN-680102 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN 
    #  CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
      RETURN
    END IF
    CALL cl_wait()
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM gcn_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE p_cateset_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE p_cateset_co                         # SCROLL CURSOR
        CURSOR FOR p_cateset_p1
 
    CALL cl_outnam('p_cateset') RETURNING l_name
    START REPORT p_cateset_rep TO l_name
 
    FOREACH p_cateset_co INTO l_gen.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
 
        END IF
        OUTPUT TO REPORT p_cateset_rep(l_gen.*)
    END FOREACH
 
    FINISH REPORT p_cateset_rep
 
    CLOSE p_cateset_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_cateset_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,     #No.FUN-680102 VARCHAR(1),
        sr RECORD LIKE gcn_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.gcn01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[2] CLIPPED,g_x[3] CLIPPED,g_x[4] CLIPPED,g_x[5] CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
#            IF sr.genacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
          PRINT COLUMN g_c[2],sr.gcn01,
                COLUMN g_c[3],sr.gcn02,
                COLUMN g_c[4],sr.gcn03,
                COLUMN g_c[5],sr.gcn04
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
                SKIP 1 LINE
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
#No.FUN-570110 --start                                                          
FUNCTION p_cateset_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("gcn01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION p_cateset_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     #CALL cl_set_comp_entry("gcn01",FALSE)
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-570110 --end          
