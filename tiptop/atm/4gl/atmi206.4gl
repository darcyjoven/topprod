# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi206.4gl
# Descriptions...: atmi206  地級市代碼維護作業
# Date & Author..: 05/10/19 By day 
# Modify.........: No.FUN-660104 06/06/15 By cl  Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780056 07/07/20 By mike 報表格式修改為p_query
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30033 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_toq           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        toq01       LIKE toq_file.toq01,
        toq02       LIKE toq_file.toq02,
        toq03       LIKE toq_file.toq03,
        top02       LIKE top_file.top02,
        toqacti     LIKE toq_file.toqacti
                    END RECORD,
    g_toq_t         RECORD                 #程式變數 (舊值)
        toq01       LIKE toq_file.toq01,
        toq02       LIKE toq_file.toq02,
        toq03       LIKE toq_file.toq03,
        top02       LIKE top_file.top02,
        toqacti     LIKE toq_file.toqacti
                    END RECORD,
    g_wc2,g_sql    string,
    g_rec_b         LIKE type_file.num5,                #單身筆數             #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000          #No.FUN-680120 VARCHAR(72)
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680120 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ATM")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
    LET p_row = 4 LET p_col = 6
    OPEN WINDOW i206_w AT p_row,p_col WITH FORM "atm/42f/atmi206"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    LET g_wc2 = ' 1=1' CALL i206_b_fill(g_wc2)
    CALL i206_bp('D')
    CALL i206_menu()    #中文
    CLOSE WINDOW i206_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i206_menu()
 DEFINE  l_cmd    STRING    #No.FUN-780056  
  WHILE TRUE
    CALL i206_bp("G")
    CASE g_action_choice
       WHEN "query"
          IF cl_chk_act_auth() THEN 
             CALL i206_q()
          END IF
       WHEN "detail"
          IF cl_chk_act_auth() THEN 
             CALL i206_b()
          END IF
       WHEN "output"
          IF cl_chk_act_auth() THEN 
             #CALL i206_out()                                  #No.FUN-780056
             IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF     #No.FUN-780056
             LET l_cmd='p_query "atmi206" "',g_wc2 CLIPPED,'"' #No.FUN-780056
             CALL cl_cmdrun(l_cmd)                             #No.FUN-780056
          END IF
       WHEN "help"
          CALL cl_show_help()
       WHEN "exit"
          EXIT WHILE
       WHEN "controlg"
          CALL cl_cmdask()
       WHEN "exporttoexcel"  
          IF cl_chk_act_auth() THEN
             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_toq),'','')
          END IF
     END CASE
   END WHILE
END FUNCTION
 
FUNCTION i206_q()
   CALL i206_b_askkey()
END FUNCTION
 
FUNCTION i206_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680120 SMALLINT
    l_possible      LIKE type_file.num5             #No.FUN-680120 SMALLINT              #用來設定判斷重複的可能性
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    CALL cl_opmsg('b')
 
   LET g_forupd_sql =
       "SELECT toq01,toq02,toq03,'',toqacti",
       " FROM toq_file",
       "  WHERE toq01= ? ",
       " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i206_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_toq WITHOUT DEFAULTS FROM s_toq.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
            END IF
 
    BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
               BEGIN WORK
                LET p_cmd='u'
                LET g_toq_t.* = g_toq[l_ac].*  #BACKUP
                LET g_before_input_done = FALSE
                CALL i206_set_entry(p_cmd)
                CALL i206_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
                OPEN i206_bcl USING g_toq_t.toq01               #表示更改狀態
                IF STATUS THEN
                    CALL cl_err("OPEN i206_bcl:",STATUS,1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i206_bcl INTO g_toq[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_toq_t.toq01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                SELECT top02 INTO g_toq[l_ac].top02 FROM top_file
                 WHERE top01 = g_toq[l_ac].toq03
                END IF
                CALL cl_show_fld_cont()    
              END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL i206_set_entry(p_cmd)
            CALL i206_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_toq[l_ac].* TO NULL  
            LET g_toq[l_ac].toqacti = 'Y'         #Body default
            LET g_toq_t.* = g_toq[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()   
            NEXT FIELD toq01
 
        AFTER FIELD toq01                        #check 編號是否重複
            IF NOT cl_null(g_toq[l_ac].toq01) THEN
               IF g_toq[l_ac].toq01 != g_toq_t.toq01 OR
                  g_toq_t.toq01 IS NULL THEN
                   SELECT count(*) INTO l_n FROM toq_file
                       WHERE toq01 = g_toq[l_ac].toq01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_toq[l_ac].toq01 = g_toq_t.toq01
                       NEXT FIELD toq01
                   END IF
               END IF
            END IF
 
        AFTER FIELD toq03 
	    IF NOT cl_null(g_toq[l_ac].toq03) THEN
               SELECT * FROM top_file 
                WHERE top01 = g_toq[l_ac].toq03
               IF SQLCA.sqlcode = 100 THEN
               #  CALL cl_err(g_toq[l_ac].toq03,100,0)  #No.FUN-660104
                  CALL cl_err3("sel","top_file",g_toq[l_ac].toq03,"",100,"","",1) #No.FUN-660104
                  NEXT FIELD toq03
   	       ELSE
                  CALL i206_toq03('a')
    	          IF NOT cl_null(g_errno)  THEN
	             CALL cl_err('',g_errno,0)
 	             LET g_toq[l_ac].toq03 = g_toq_t.toq03
                     NEXT FIELD toq03
                  END IF
    	       END IF
            END IF
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO toq_file(toq01,toq02,toq03,toqacti)
                          VALUES(g_toq[l_ac].toq01,g_toq[l_ac].toq02,
                                 g_toq[l_ac].toq03,
                                 g_toq[l_ac].toqacti)
           IF SQLCA.sqlcode THEN
           #   CALL cl_err(g_toq[l_ac].toq01,SQLCA.sqlcode,0)   #No.FUN-660104
               CALL cl_err3("ins","toq_file",g_toq[l_ac].toq01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_toq_t.toq01 IS NOT NULL THEN
               IF NOT cl_delete() THEN                         
                  CANCEL DELETE                               
               END IF                                               
               IF l_lock_sw = "Y" THEN                       
                  CALL cl_err("", -263, 1)                       
                  CANCEL DELETE                     
               END IF  
               DELETE FROM toq_file WHERE toq01 = g_toq_t.toq01
               IF SQLCA.sqlcode THEN
               #   CALL cl_err(g_toq_t.toq01,SQLCA.sqlcode,0)  #No.FUN-660104
                   CALL cl_err3("del","toq_file",g_toq_t.toq01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                   EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
            COMMIT WORK
 
    ON ROW CHANGE
           IF INT_FLAG THEN        
              CALL cl_err('',9001,0)                              
              LET INT_FLAG = 0                              
              LET g_toq[l_ac].* = g_toq_t.*            
              CLOSE i206_bcl                                      
              ROLLBACK WORK                                 
              EXIT INPUT                           
           END IF                                                                  
           IF l_lock_sw="Y" THEN                                    
              CALL cl_err(g_toq[l_ac].toq01,-263,0)                
              LET g_toq[l_ac].* = g_toq_t.*                 
           ELSE 
              UPDATE toq_file SET
                         toq01 = g_toq[l_ac].toq01,
                         toq02 = g_toq[l_ac].toq02,
                         toq03 = g_toq[l_ac].toq03,
                         toqacti = g_toq[l_ac].toqacti
               WHERE CURRENT OF i206_bcl
              IF SQLCA.sqlcode THEN                                   
              #  CALL cl_err(g_toq[l_ac].toq01,SQLCA.sqlcode,0)     #No.FUN-660104 
                 CALL cl_err3("upd","toq_file",g_toq[l_ac].toq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_toq[l_ac].* = g_toq_t.*                       
              ELSE                                                    
                 MESSAGE 'UPDATE O.K'                                
                 COMMIT WORK 
              END IF
           END IF
         
    AFTER ROW
           LET l_ac = ARR_CURR()  #FUN-D30033 add
           IF INT_FLAG THEN       
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN   
                  LET g_toq[l_ac].* = g_toq_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_toq.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF       
              CLOSE i206_bcl     
              ROLLBACK WORK     
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i206_bcl      
           COMMIT WORK
           
        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(toq03) 
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.form ="q_top3"
                    LET g_qryparam.default1 = g_toq[l_ac].toq03
                    CALL cl_create_qry() RETURNING g_toq[l_ac].toq03
                    CALL i206_toq03('a')
                    NEXT FIELD toq03
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            CALL i206_b_askkey()
 
        ON ACTION CONTROLO
            IF INFIELD(toq01) AND l_ac > 1 THEN
                LET g_toq[l_ac].* = g_toq[l_ac-1].*
                NEXT FIELD toq01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
          
           ON IDLE g_idle_seconds     
              CALL cl_on_idle()            
              CONTINUE INPUT   
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help     
         CALL cl_show_help()
 
        END INPUT
 
    CLOSE i206_bcl
    COMMIT WORK 
END FUNCTION
 
FUNCTION i206_toq03(p_cmd) 
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_top02     LIKE top_file.top02,
        l_topacti   LIKE top_file.topacti
 
    LET g_errno = ' '
    SELECT top02,topacti INTO l_top02,l_topacti FROM top_file
     WHERE top01 = g_toq[l_ac].toq03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET g_toq[l_ac].toq03 = NULL
         WHEN l_topacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_toq[l_ac].top02 = l_top02
    END IF
END FUNCTION
 
FUNCTION i206_b_askkey()
    CLEAR FORM
    CONSTRUCT g_wc2 ON toq01,toq02,toq03,toqacti
            FROM s_toq[1].toq01,s_toq[1].toq02,s_toq[1].toq03,
                 s_toq[1].toqacti
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
             CASE
                WHEN INFIELD(toq03) 
                    CALL cl_init_qry_var()                                     
                    LET g_qryparam.form ="q_top3"
                    LET g_qryparam.state = "c"                                  
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO s_toq[1].toq03
                    NEXT FIELD toq03
                OTHERWISE
                    EXIT CASE
            END CASE
 
       ON IDLE g_idle_seconds                               
          CALL cl_on_idle()                            
          CONTINUE CONSTRUCT 
 
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
           CALL cl_qbe_select() 
       ON ACTION qbe_save
           CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION about    
          CALL cl_about()
  
       ON ACTION help   
          CALL cl_show_help()
  
       ON ACTION controlg   
          CALL cl_cmdask() 
 
    END CONSTRUCT       
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- end --
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i206_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i206_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT toq01,toq02,toq03,top02,toqacti ",
        " FROM toq_file,OUTER top_file ",
        " WHERE toq_file.toq03 = top_file.top01 AND ",p_wc2 CLIPPED,   #單身
        " ORDER BY toq01"
    PREPARE i206_pb FROM g_sql
    DECLARE toq_curs CURSOR FOR i206_pb
 
    CALL g_toq.clear()
    LET g_cnt = 1
    FOREACH toq_curs INTO g_toq[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt=g_cnt+1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_toq.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
        LET g_cnt = 0
END FUNCTION
 
FUNCTION i206_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_toq TO s_toq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
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
 
      ON ACTION close
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
       ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE DISPLAY   
 
      ON ACTION about        
         CALL cl_about()    
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)   
 
END FUNCTION
 
#No.FUN-780056 -str
{
FUNCTION i206_out()
    DEFINE
        l_toq           RECORD LIKE toq_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)
        l_za05          LIKE za_file.za05 
 
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('atmi206') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM toq_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i206_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i206_co                           # SCROLL CURSOR
         CURSOR FOR i206_p1
 
    START REPORT i206_rep TO l_name
 
    FOREACH i206_co INTO l_toq.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT i206_rep(l_toq.*)
    END FOREACH
 
    FINISH REPORT i206_rep
 
    CLOSE i206_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i206_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
        sr RECORD LIKE toq_file.*,
        l_top02   LIKE top_file.top02,
        l_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.toq01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     
 
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
 
            PRINT g_x[31], g_x[32],g_x[33],g_x[34], g_x[35]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
	    SELECT top02 INTO l_top02 FROM top_file WHERE top01 = sr.toq03
            PRINT COLUMN g_c[31],sr.toq01 CLIPPED,
                  COLUMN g_c[32],sr.toq02 CLIPPED,
                  COLUMN g_c[33],sr.toq03 CLIPPED,
                  COLUMN g_c[34],l_top02 CLIPPED,
                  COLUMN g_c[35],sr.toqacti
 
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
}
#No.FUN-780056 -end
 
FUNCTION i206_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("toq01",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION i206_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("toq01",FALSE) 
    END IF 
 
END FUNCTION
