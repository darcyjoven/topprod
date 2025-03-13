# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abmi111.4gl
# Descriptions...: 部位基本資料維護作業
# Date & Author..: 08/01/10 By jan.
# Modify ........: No.FUN-810017 By jan
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
 
    g_bol           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bol01       LIKE bol_file.bol01,   #部位代碼
        bol02       LIKE bol_file.bol02,   #部位說明
        bol03       LIKE bol_file.bol03,   #英文說明
        bol04       LIKE bol_file.bol04,   #部位性質
        bolacti     LIKE bol_file.bolacti  #有效否
                    END RECORD,
 
    g_bol_t         RECORD                 #程式變數 (舊值)
        bol01       LIKE bol_file.bol01,   #部位代碼                                                                                
        bol02       LIKE bol_file.bol02,   #部位說明                                                                                
        bol03       LIKE bol_file.bol03,   #英文說明                                                                                
        bol04       LIKE bol_file.bol04,   #部位性質                                                                                
        bolacti     LIKE bol_file.bolacti  #有效否
                    END RECORD,
    l_za05          LIKE type_file.chr1000,  
    g_wc2,g_sql     STRING,  
    g_rec_b         LIKE type_file.num5,                #單身筆數  
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  
    l_sl            LIKE type_file.num5                 #目前處理的SCREEN LINE
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  
DEFINE p_row,p_col   LIKE type_file.num5    
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
       RETURNING g_time    
    LET p_row = 3 LET p_col = 14
    OPEN WINDOW i111_w AT p_row,p_col WITH FORM "abm/42f/abmi111"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i111_b_fill(g_wc2)
    CALL i111_menu()
    CLOSE WINDOW i111_w                  #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
       RETURNING g_time    
END MAIN
 
FUNCTION i111_menu()
 
   WHILE TRUE
      CALL i111_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i111_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i111_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output" 
#            IF cl_chk_act_auth() THEN
#               CALL i111_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bol),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i111_q()
   CALL i111_b_askkey()
END FUNCTION
 
FUNCTION i111_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
    p_cmd           LIKE type_file.chr1,                #處理狀態     
    l_allow_insert  LIKE type_file.chr1,                #可新增否  
    l_allow_delete  LIKE type_file.chr1                 #可刪除否 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bol01,bol02,bol03,bol04,bolacti FROM bol_file WHERE bol01=?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i111_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_bol WITHOUT DEFAULTS FROM s_bol.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
      BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET g_bol_t.* = g_bol[l_ac].*  #BACKUP
               LET p_cmd='u'
               LET g_before_input_done = FALSE                                  
               CALL i111_set_entry(p_cmd)                                       
               CALL i111_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
               BEGIN WORK
               OPEN i111_bcl USING g_bol_t.bol01
               IF STATUS THEN
                  CALL cl_err("OPEN i111_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i111_bcl INTO g_bol[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bol_t.bol01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                                     
            CALL i111_set_entry(p_cmd)                                          
            CALL i111_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
            INITIALIZE g_bol[l_ac].* TO NULL
            LET g_bol[l_ac].bol04 = "1"
            LET g_bol[l_ac].bolacti = 'Y'     
            LET g_bol_t.* = g_bol[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD bol01
 
        AFTER INSERT
           IF INT_FLAG THEN                 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO bol_file(bol01,bol02,bol03,bol04,bolacti)
           VALUES(g_bol[l_ac].bol01,g_bol[l_ac].bol02,
                  g_bol[l_ac].bol03,g_bol[l_ac].bol04,g_bol[l_ac].bolacti)
           IF SQLCA.sqlcode THEN 
              CALL cl_err3("ins","bol_file",g_bol[l_ac].bol01,"",SQLCA.sqlcode,"","",1) 
              ROLLBACK WORK
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
           END IF
 
        AFTER FIELD bol01                        
            IF g_bol[l_ac].bol01 IS NOT NULL THEN
               IF g_bol[l_ac].bol01 != g_bol_t.bol01 OR
                 (g_bol[l_ac].bol01 IS NOT NULL AND g_bol_t.bol01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM bol_file
                   WHERE bol01 = g_bol[l_ac].bol01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_bol[l_ac].bol01 = g_bol_t.bol01
                     NEXT FIELD bol01
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bol_t.bol01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM bol_file WHERE bol01 = g_bol_t.bol01
                IF SQLCA.sqlcode THEN
                CALL cl_err3("del","bol_file",g_bol_t.bol01,"",SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i111_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_bol[l_ac].* = g_bol_t.*
              CLOSE i111_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_bol[l_ac].bol01,-263,1)
              LET g_bol[l_ac].* = g_bol_t.*
           ELSE
                        UPDATE bol_file SET
                               bol01=g_bol[l_ac].bol01,
                               bol02=g_bol[l_ac].bol02,
                               bol03=g_bol[l_ac].bol03,
                               bol04=g_bol[l_ac].bol04,
                               bolacti=g_bol[l_ac].bolacti
                         WHERE CURRENT OF i111_bcl
                         IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","bol_file",g_bol_t.bol01,"",SQLCA.sqlcode,"","",1)
                           LET g_bol[l_ac].* = g_bol_t.*
                           DISPLAY g_bol[l_ac].* TO s_bol[l_sl].*
                         ELSE
                           MESSAGE 'UPDATE O.K'
                           CLOSE i111_bcl
                           COMMIT WORK
                         END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                                             
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd='u' THEN
                  LET g_bol[l_ac].* = g_bol_t.*                                    
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bol.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i111_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i111_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i111_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bol01) AND l_ac > 1 THEN
                LET g_bol[l_ac].* = g_bol[l_ac-1].*
                NEXT FIELD bol01
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
 
    CLOSE i111_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i111_b_askkey()
    CLEAR FORM
    CALL g_bol.clear()
    CONSTRUCT g_wc2 ON bol01,bol02,bol03,bol04,bolacti
            FROM s_bol[1].bol01,s_bol[1].bol02,s_bol[1].bol03,
                 s_bol[1].bol04,s_bol[1].bolacti
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
    CALL i111_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i111_b_fill(p_wc2)              #BODY FILL UP
DEFINE
#    p_wc2           LIKE type_file.chr1000 
     p_wc2           STRING         #No.FUN-910082
 
    LET g_sql =
        "SELECT bol01,bol02,bol03,bol04,bolacti ",
        " FROM bol_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i111_pb FROM g_sql
    DECLARE bol_curs CURSOR FOR i111_pb
 
    CALL g_bol.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH bol_curs INTO g_bol[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_bol.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i111_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bol TO s_bol.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
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
 
{
FUNCTION i020_out()
    DEFINE
        l_rmk           RECORD LIKE rmk_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #  #No.FUN-690010 VARCHAR(40)
   
    INITIALIZE l_rmk.* TO NULL      #900423
    IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('armi020') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang #No.TQC-5C0064
    LET g_sql="SELECT * FROM rmk_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED 
    PREPARE i020_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i020_co                         # SCROLL CURSOR
        CURSOR FOR i020_p1
 
    START REPORT i020_rep TO l_name
 
    FOREACH i020_co INTO l_rmk.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i020_rep(l_rmk.*)
    END FOREACH
 
    FINISH REPORT i020_rep
 
    CLOSE i020_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i020_rep(sr)
    DEFINE
        l_rmk03         LIKE type_file.chr6,        #No.FUN-690010 VARCHAR(6),
        l_last_sw       LIKE type_file.chr1,        #No.FUN-690010 VARCHAR(1),
        l_n             LIKE type_file.num5,        #No.FUN-690010 SMALLINT
        sr RECORD LIKE rmk_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.rmk03,sr.rmk01
 
    FORMAT
        PAGE HEADER
          PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
          LET g_pageno = g_pageno + 1 
          LET pageno_total = PAGENO USING '<<<',"/pageno" 
          PRINT g_head CLIPPED,pageno_total     
          IF sr.rmk03="1" THEN 
              LET l_rmk03='DEFECT'
          ELSE 
              LET l_rmk03='REPAIR' 
          END IF
          PRINT g_x[9] CLIPPED,' ',l_rmk03
          PRINT g_dash
          PRINT g_x[31],g_x[32],g_x[33],g_x[34]
          PRINT g_dash1 
          LET l_last_sw = 'n'
          #TQC-640100
          IF g_pageno = 1 THEN
               LET l_n = 0                
          END IF
          #END TQC-640100
 
        BEFORE GROUP OF sr.rmk03
            IF l_n=1 THEN PRINT ''  END IF
            SKIP TO TOP OF PAGE
            LET l_n=0
 
        ON EVERY ROW
            IF NOT l_n THEN
               PRINT COLUMN g_c[31],sr.rmk01,
                     COLUMN g_c[32],sr.rmk02;
               LET l_n=1
            ELSE
               PRINT COLUMN g_c[33],sr.rmk01,
                     COLUMN g_c[34],sr.rmk02
               LET l_n=0
            END IF
 
        ON LAST ROW
            IF l_n=1 THEN PRINT ''  END IF
            PRINT g_dash
            PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED #No.TQC-5C0064
            LET l_last_sw = 'y'
 
        PAGE TRAILER
            IF l_last_sw = 'n' THEN
                PRINT ''
                PRINT g_dash
                PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED #No.TQC-5C0064
            ELSE
                SKIP 3 LINE
            END IF
END REPORT}
 
FUNCTION i111_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                           
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("bol01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i111_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                           
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("bol01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-810017
