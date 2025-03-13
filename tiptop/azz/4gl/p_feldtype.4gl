# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: p_feldtype.4gl
# Descriptions...: 欄位屬性維護
# Date & Author..: 06/08/07 By rainy
# Modify.........: No.FUN-680031 08/08/11 By rainy 新增欄位:修改者(gck05),修改日(gck06
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_gck           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gck01       LIKE gck_file.gck01,   #欄位屬性代碼
        gck02       LIKE gck_file.gck02,   #屬性簡稱
        gck03       LIKE gck_file.gck03,   #資料型態
        gck04       LIKE gck_file.gck04,   #說明
        gck05       LIKE gck_file.gck05,   #修改者  #FUN-680031
        zx02        LIKE zx_file.zx02,     #姓名    #FUN-680031
        gck06       LIKE gck_file.gck06    #修改日  #FUN-680031
                    END RECORD,
    g_gck_t         RECORD                 #程式變數 (舊值)
        gck01       LIKE gck_file.gck01,   #欄位屬性代碼
        gck02       LIKE gck_file.gck02,   #屬性簡稱
        gck03       LIKE gck_file.gck03,   #資料型態
        gck04       LIKE gck_file.gck04,   #說明
        gck05       LIKE gck_file.gck05,   #修改者  #FUN-680031
        zx02        LIKE zx_file.zx02,     #姓名    #FUN-680031
        gck06       LIKE gck_file.gck06    #修改日  #FUN-680031
                    END RECORD,
    g_wc2,g_sql    string,  
    g_rec_b         LIKE type_file.num5,   #單身筆數 #No.FUN-680135 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680135 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5   #No.FUN-680135 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0096
DEFINE p_row,p_col   LIKE type_file.num5           #No.FUN-680135 SMALLINT 
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
 
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET p_row = 4 LET p_col = 27
   OPEN WINDOW p_feldtype_w AT p_row,p_col WITH FORM "azz/42f/p_feldtype"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL p_feldtype_b_fill(g_wc2)
 
   CALL p_feldtype_menu()
 
   CLOSE WINDOW p_feldtype_w           #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_feldtype_menu()
 
   WHILE TRUE
      CALL p_feldtype_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL p_feldtype_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_feldtype_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL p_feldtype_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_gck[l_ac].gck01 IS NOT NULL THEN
                  LET g_doc.column1 = "gck01"
                  LET g_doc.value1 = g_gck[l_ac].gck01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gck),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_feldtype_q()
   CALL p_feldtype_b_askkey()
END FUNCTION
 
FUNCTION p_feldtype_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680135 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680135 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680135 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #FUN-680135        VARCHAR(01) #可新增否
    l_allow_delete  LIKE type_file.num5     #FUN-680135        VARCHAR(01) #可刪除否
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT gck01,gck02,gck03,gck04,gck05,'',gck06 FROM gck_file",
                       " WHERE gck01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_feldtype_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_gck WITHOUT DEFAULTS FROM s_gck.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
 
        BEFORE ROW
            LET p_cmd='' 
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
                                                   
               LET g_before_input_done = FALSE                                  
               CALL p_feldtype_set_entry(p_cmd)                                       
               CALL p_feldtype_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
      
               LET g_gck_t.* = g_gck[l_ac].*  #BACKUP
               OPEN p_feldtype_bcl USING g_gck_t.gck01
               IF STATUS THEN
                  CALL cl_err("OPEN p_feldtype_bcl:", STATUS, 1)    
                   LET l_lock_sw = "Y"
               ELSE
                  FETCH p_feldtype_bcl INTO g_gck[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_gck_t.gck01,SQLCA.sqlcode,1)   
                     LET l_lock_sw = "Y"
                  #FUN-680031 add--start
                  ELSE
                   IF NOT cl_null(g_gck[l_ac].gck05) THEN
                      SELECT zx02 INTO g_gck[l_ac].zx02 FROM zx_file
                       WHERE zx01 = g_gck[l_ac].gck05
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("sel","zx_file",g_gck[l_ac].gck05,"",SQLCA.sqlcode,"","",0) 
                      END IF
                   END IF
                  #FUN-680031 add--end 
                  END IF
               END IF
               CALL cl_show_fld_cont()     
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
                                                          
           LET g_before_input_done = FALSE                                      
           CALL p_feldtype_set_entry(p_cmd)                                           
           CALL p_feldtype_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
   
           INITIALIZE g_gck[l_ac].* TO NULL      
           LET g_gck_t.* = g_gck[l_ac].*       #新輸入資料
           CALL cl_show_fld_cont()     
           LET g_gck[l_ac].gck05 = g_user  #FUN-680031
           LET g_gck[l_ac].gck06 = g_today #FUN-680031
           DISPLAY BY NAME g_gck[l_ac].gck05,g_gck[l_ac].gck06  #FUN-680031
           NEXT FIELD gck01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE p_feldtype_bcl
              CANCEL INSERT
           END IF
 
 
           INSERT INTO gck_file(gck01,gck02,gck03,gck04,gck05,gck06)  #FUN-680031 add gck05,gck06
                         VALUES(g_gck[l_ac].gck01,g_gck[l_ac].gck02,
                                g_gck[l_ac].gck03,g_gck[l_ac].gck04,g_gck[l_ac].gck05,g_gck[l_ac].gck06)  #FUN-680031
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","gck_file",g_gck[l_ac].gck01,"",SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD gck01                        #check 編號是否重複
            IF NOT cl_null(g_gck[l_ac].gck01) THEN
               IF g_gck[l_ac].gck01 != g_gck_t.gck01 OR
                  g_gck_t.gck01 IS NULL THEN
                   SELECT count(*) INTO l_n FROM gck_file
                       WHERE gck01 = g_gck[l_ac].gck01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_gck[l_ac].gck01 = g_gck_t.gck01
                       NEXT FIELD gck01
                   END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_gck_t.gck01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "gck01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_gck[l_ac].gck01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM gck_file WHERE gck01 = g_gck_t.gck01
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","gck_file",g_gck_t.gck01,"",SQLCA.sqlcode,"","",1)  
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
              LET g_gck[l_ac].* = g_gck_t.*
              CLOSE p_feldtype_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_gck[l_ac].gck01,-263,0)
               LET g_gck[l_ac].* = g_gck_t.*
           ELSE
               UPDATE gck_file SET gck01=g_gck[l_ac].gck01,
                                   gck02=g_gck[l_ac].gck02,
                                   gck03=g_gck[l_ac].gck03,
                                   gck04=g_gck[l_ac].gck04,
                                   gck05=g_user,  #FUN-680031
                                   gck06=g_today  #FUN-680031
                WHERE gck01 = g_gck_t.gck01
              
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","gck_file",g_gck_t.gck01,"",SQLCA.sqlcode,"","",1)  
                  LET g_gck[l_ac].* = g_gck_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()            # 新增
          #LET l_ac_t = l_ac      #FUN-D30034 mark
 
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_gck[l_ac].* = g_gck_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_gck.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF
              CLOSE p_feldtype_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30034 add
           CLOSE p_feldtype_bcl
           COMMIT WORK
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(gck01) AND l_ac > 1 THEN
                LET g_gck[l_ac].* = g_gck[l_ac-1].*
                NEXT FIELD gck01
            END IF
 
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
 
    CLOSE p_feldtype_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION p_feldtype_b_askkey()
 
   CLEAR FORM
   CALL g_gck.clear()
 
    CONSTRUCT g_wc2 ON gck01,gck02,gck03,gck04
         FROM s_gck[1].gck01,s_gck[1].gck02,s_gck[1].gck03,s_gck[1].gck04
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL p_feldtype_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION p_feldtype_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000     #No.FUN-680135 VARCHAR(200)
 
    LET g_sql =
        "SELECT gck01,gck02,gck03,gck04,gck05,'',gck06",  #FUN-680031 add gck05,'',gck06
        " FROM gck_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE p_feldtype_pb FROM g_sql
    DECLARE gck_curs CURSOR FOR p_feldtype_pb
 
    CALL g_gck.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
 
    FOREACH gck_curs INTO g_gck[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1) 
           EXIT FOREACH 
        END IF
       #FUN-680031 add--start
        IF NOT cl_null(g_gck[g_cnt].gck05) THEN
           SELECT zx02 INTO g_gck[g_cnt].zx02 FROM zx_file
            WHERE zx01 = g_gck[g_cnt].gck05
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","zx_file",g_gck[g_cnt].gck05,"",SQLCA.sqlcode,"","",0) 
           END IF
        END IF
       #FUN-680031 add--end 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gck.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_feldtype_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_gck TO s_gck.* ATTRIBUTE(COUNT=g_rec_b)
 
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
   
# ON ACTION 相關文件  
      ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_feldtype_out()
    DEFINE
        l_gck           RECORD LIKE gck_file.*,
        l_i             LIKE type_file.num5,      #No.FUN-680135 SMALLINT
        l_name          LIKE type_file.chr20      # External(Disk) file name        #No.FUN-680135 VARCHAR(20)
        
   
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN 
    END IF
 
    CALL cl_wait()
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT * FROM gck_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE p_feldtype_p1 FROM g_sql              # RUNTIME 編譯
    DECLARE p_feldtype_co                         # SCROLL CURSOR
         CURSOR FOR p_feldtype_p1
 
    CALL cl_outnam('p_feldtype') RETURNING l_name
    START REPORT p_feldtype_rep TO l_name
 
    FOREACH p_feldtype_co INTO l_gck.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)    
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT p_feldtype_rep(l_gck.*)
    END FOREACH
 
    FINISH REPORT p_feldtype_rep
 
    CLOSE p_feldtype_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_feldtype_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #FUN-680135 VARCHAR(1)
        sr RECORD LIKE gck_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.gck01
 
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
            PRINT COLUMN g_c[31],sr.gck01,
                  COLUMN g_c[32],sr.gck02,
                  COLUMN g_c[33],sr.gck03,
                  COLUMN g_c[34],sr.gck04
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
                                                          
FUNCTION p_feldtype_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("gck01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION p_feldtype_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("gck01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
      
