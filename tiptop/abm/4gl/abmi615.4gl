# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abmi615.4gl
# Descriptions...: 縮放比例公式參數維護作業
# Date & Author..: 08/01/10 By jan.
# Modify.........: No.FUN-810017 08/03/21 By jan
# Modify.........: No.FUN-870117 08/09/23 by ve007
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
 
    g_boi           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        boi01       LIKE boi_file.boi01,   #參數代號
        boi02       LIKE boi_file.boi02,   #參數內容
        boi03       LIKE boi_file.boi03,   #參數描述
        boiacti     LIKE boi_file.boiacti  #有效否
                    END RECORD,
 
    g_boi_t         RECORD                 #程式變數 (舊值)
        boi01       LIKE boi_file.boi01,   #參數代號                                                                                
        boi02       LIKE boi_file.boi02,   #參數內容                                                                                
        boi03       LIKE boi_file.boi03,   #參數描述                                                                                
        boiacti     LIKE boi_file.boiacti  #有效否
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
    OPEN WINDOW i615_w AT p_row,p_col WITH FORM "abm/42f/abmi615"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i615_b_fill(g_wc2)
    CALL i615_menu()
    CLOSE WINDOW i615_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
       RETURNING g_time    
END MAIN
 
FUNCTION i615_menu()
 
   WHILE TRUE
      CALL i615_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i615_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i615_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output" 
#            IF cl_chk_act_auth() THEN
#               CALL i615_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_boi),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i615_q()
   CALL i615_b_askkey()
END FUNCTION
 
FUNCTION i615_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
    p_cmd           LIKE type_file.chr1,                #處理狀態     
    l_allow_insert  LIKE type_file.chr1,                #可新增否  
    l_allow_delete  LIKE type_file.chr1,                 #可刪除否 
    l_str           string        #No.FUN-870117
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT boi01,boi02,boi03,boiacti FROM boi_file WHERE boi01=?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i615_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_boi WITHOUT DEFAULTS FROM s_boi.*
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
               LET g_boi_t.* = g_boi[l_ac].*  #BACKUP
               LET p_cmd='u'
               LET g_before_input_done = FALSE                                  
               CALL i615_set_entry(p_cmd)                                       
               CALL i615_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
               BEGIN WORK
               OPEN i615_bcl USING g_boi_t.boi01
               IF STATUS THEN
                  CALL cl_err("OPEN i615_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i615_bcl INTO g_boi[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_boi_t.boi01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                                     
            CALL i615_set_entry(p_cmd)                                          
            CALL i615_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
            INITIALIZE g_boi[l_ac].* TO NULL
            LET g_boi[l_ac].boiacti = 'Y'     
            LET g_boi_t.* = g_boi[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD boi01
 
        AFTER INSERT
           IF INT_FLAG THEN                 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_boi[l_ac].boi03) THEN 
              LET g_boi[l_ac].boi03 = ' '
           END IF
           INSERT INTO boi_file(boi01,boi02,boi03,boiacti)
           VALUES(g_boi[l_ac].boi01,g_boi[l_ac].boi02,
                  g_boi[l_ac].boi03,g_boi[l_ac].boiacti)
           IF SQLCA.sqlcode THEN 
              CALL cl_err3("ins","boi_file",g_boi[l_ac].boi01,"",SQLCA.sqlcode,"","",1) 
              ROLLBACK WORK
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              COMMIT WORK
           END IF
 
        AFTER FIELD boi01                        
            IF g_boi[l_ac].boi01 IS NOT NULL THEN
               IF g_boi[l_ac].boi01 != g_boi_t.boi01 OR
                 (g_boi[l_ac].boi01 IS NOT NULL AND g_boi_t.boi01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM boi_file
                   WHERE boi01 = g_boi[l_ac].boi01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_boi[l_ac].boi01 = g_boi_t.boi01
                     NEXT FIELD boi01
                  END IF
                  #No.FUN-870117
                  LET l_str = g_boi[l_ac].boi01
                  IF l_str.getIndexof('_',1) >0 THEN 
                    CALL cl_err('','abm-036',0)
                    NEXT FIELD boi01
                  END IF
                  #No.FUN-870117  --end--   
               END IF
            END IF
 
        AFTER FIELD boi03
          IF cl_null(g_boi[l_ac].boi03) THEN
             LET g_boi[l_ac].boi03= ' '
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_boi_t.boi01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM boi_file WHERE boi01 = g_boi_t.boi01
                IF SQLCA.sqlcode THEN
                CALL cl_err3("del","boi_file",g_boi_t.boi01,"",SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i615_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_boi[l_ac].* = g_boi_t.*
              CLOSE i615_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_boi[l_ac].boi01,-263,1)
              LET g_boi[l_ac].* = g_boi_t.*
           ELSE
                        UPDATE boi_file SET
                               boi01=g_boi[l_ac].boi01,
                               boi02=g_boi[l_ac].boi02,
                               boi03=g_boi[l_ac].boi03,
                               boiacti=g_boi[l_ac].boiacti
                         WHERE CURRENT OF i615_bcl
                         IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","boi_file",g_boi_t.boi01,"",SQLCA.sqlcode,"","",1)
                           LET g_boi[l_ac].* = g_boi_t.*
                           DISPLAY g_boi[l_ac].* TO s_boi[l_sl].*
                         ELSE
                           MESSAGE 'UPDATE O.K'
                           CLOSE i615_bcl
                           COMMIT WORK
                         END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                                             
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd='u' THEN
                  LET g_boi[l_ac].* = g_boi_t.*                                    
               #FUN-D40030--add--str--
               ELSE
                  CALL g_boi.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i615_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i615_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i615_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(boi01) AND l_ac > 1 THEN
                LET g_boi[l_ac].* = g_boi[l_ac-1].*
                NEXT FIELD boi01
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
 
    CLOSE i615_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i615_b_askkey()
    CLEAR FORM
    CALL g_boi.clear()
    CONSTRUCT g_wc2 ON boi01,boi02,boi03,boiacti
            FROM s_boi[1].boi01,s_boi[1].boi02,s_boi[1].boi03,
                 s_boi[1].boiacti
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
    CALL i615_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i615_b_fill(p_wc2)              #BODY FILL UP
DEFINE
#    p_wc2           LIKE type_file.chr1000 
    p_wc2            STRING         #NO.FUN-910082 
 
    LET g_sql =
        "SELECT boi01,boi02,boi03,boiacti ",
        " FROM boi_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i615_pb FROM g_sql
    DECLARE boi_curs CURSOR FOR i615_pb
 
    CALL g_boi.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH boi_curs INTO g_boi[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_boi.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i615_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_boi TO s_boi.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION i615_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                           
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("boi01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i615_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                           
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("boi01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-810017
