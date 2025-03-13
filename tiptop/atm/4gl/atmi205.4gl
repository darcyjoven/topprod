# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi205.4gl
# Descriptions...: atmi205  地級市代碼維護作業
# Date & Author..: 05/10/19 By day 
# Modify.........: No.FUN-660104 06/06/14 By cl Error Message 調整
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
    g_top           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        top01       LIKE top_file.top01,
        top02       LIKE top_file.top02,
        top03       LIKE top_file.top03,
        too02       LIKE too_file.too02,
        topacti     LIKE top_file.topacti
                    END RECORD,
    g_top_t         RECORD                 #程式變數 (舊值)
        top01       LIKE top_file.top01,
        top02       LIKE top_file.top02,
        top03       LIKE top_file.top03,
        too02       LIKE too_file.too02,
        topacti     LIKE top_file.topacti
                    END RECORD,
    g_wc2,g_sql    string,
    g_rec_b         LIKE type_file.num5,                #單身筆數              #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT   #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680120 SMALLINT
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
    OPEN WINDOW i205_w AT p_row,p_col WITH FORM "atm/42f/atmi205"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    LET g_wc2 = ' 1=1' CALL i205_b_fill(g_wc2)
    CALL i205_bp('D')
    CALL i205_menu()    #中文
    CLOSE WINDOW i205_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i205_menu()
 DEFINE  l_cmd   STRING     #No.FUN-780056
  WHILE TRUE
    CALL i205_bp("G")
    CASE g_action_choice
       WHEN "query"
          IF cl_chk_act_auth() THEN 
             CALL i205_q()
          END IF
       WHEN "detail"
          IF cl_chk_act_auth() THEN 
             CALL i205_b()
          END IF
       WHEN "output"
          IF cl_chk_act_auth() THEN 
             #CALL i205_out()                                   #No.FUN-780056  
             IF cl_null(g_wc2)  THEN LET g_wc2='1=1' END IF     #No.FUN-780056 
             LET l_cmd ='p_query "atmi205" "',g_wc2 CLIPPED,'"' #No.FUN-780056    
             CALL cl_cmdrun(l_cmd)                              #No.FUN-780056    
          END IF
       WHEN "help"
          CALL cl_show_help()
       WHEN "exit"
          EXIT WHILE
       WHEN "controlg"
          CALL cl_cmdask()
       WHEN "exporttoexcel"  
          IF cl_chk_act_auth() THEN
             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_top),'','')
          END IF
     END CASE
   END WHILE
END FUNCTION
 
FUNCTION i205_q()
   CALL i205_b_askkey()
END FUNCTION
 
FUNCTION i205_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680120 SMALLINT
    l_possible      LIKE type_file.num5                 #No.FUN-680120 SMALLINT              #用來設定判斷重複的可能性
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    CALL cl_opmsg('b')
 
   LET g_forupd_sql =
       "SELECT top01,top02,top03,'',topacti",
       " FROM top_file",
       " WHERE top01= ?",
       " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i205_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_top WITHOUT DEFAULTS FROM s_top.*
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
                LET g_top_t.* = g_top[l_ac].*  #BACKUP
	        LET g_before_input_done = FALSE
	        CALL i205_set_entry(p_cmd)
	        CALL i205_set_no_entry(p_cmd)
	        LET g_before_input_done = TRUE
                OPEN i205_bcl USING g_top_t.top01               #表示更改狀態
                IF STATUS THEN
                    CALL cl_err("OPEN i205_bcl:",STATUS,1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i205_bcl INTO g_top[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_top_t.top01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                SELECT too02 INTO g_top[l_ac].too02 FROM too_file
                 WHERE too01 = g_top[l_ac].top03
                END IF
                CALL cl_show_fld_cont()  
              END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
	    LET g_before_input_done = FALSE
	    CALL i205_set_entry(p_cmd)
	    CALL i205_set_no_entry(p_cmd)
	    LET g_before_input_done = TRUE
            INITIALIZE g_top[l_ac].* TO NULL  
            LET g_top[l_ac].topacti = 'Y'         #Body default
            LET g_top_t.* = g_top[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()   
            NEXT FIELD top01
 
        AFTER FIELD top01                        #check 編號是否重複
            IF NOT cl_null(g_top[l_ac].top01) THEN
               IF g_top[l_ac].top01 != g_top_t.top01 OR
                  g_top_t.top01 IS NULL THEN
                   SELECT count(*) INTO l_n FROM top_file
                       WHERE top01 = g_top[l_ac].top01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_top[l_ac].top01 = g_top_t.top01
                       NEXT FIELD top01
                   END IF
               END IF
            END IF
 
        AFTER FIELD top03 
	    IF NOT cl_null(g_top[l_ac].top03) THEN
               SELECT * FROM too_file 
                WHERE too01 = g_top[l_ac].top03
               IF SQLCA.sqlcode = 100 THEN
               #  CALL cl_err(g_top[l_ac].top03,100,0)  #No.FUN-660104
                  CALL cl_err3("sel","too_file",g_top[l_ac].top03,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                  NEXT FIELD top03
   	       ELSE
                  CALL i205_top03('a')
    	          IF NOT cl_null(g_errno)  THEN
	             CALL cl_err('',g_errno,0)
 	             LET g_top[l_ac].top03 = g_top_t.top03
                     NEXT FIELD top03
                  END IF
    	       END IF
            END IF
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO top_file(top01,top02,top03,topacti)
                          VALUES(g_top[l_ac].top01,g_top[l_ac].top02,
                                 g_top[l_ac].top03,
                                 g_top[l_ac].topacti)
           IF SQLCA.sqlcode THEN
            #  CALL cl_err(g_top[l_ac].top01,SQLCA.sqlcode,0)  #No.FUN-660104
               CALL cl_err3("ins","top_file",g_top[l_ac].top01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_top_t.top01 IS NOT NULL THEN
               IF NOT cl_delete() THEN                         
                  CANCEL DELETE                               
               END IF                                               
               IF l_lock_sw = "Y" THEN                       
                  CALL cl_err("", -263, 1)                       
                  CANCEL DELETE                     
               END IF  
               DELETE FROM top_file WHERE top01 = g_top_t.top01
               IF SQLCA.sqlcode THEN
               #   CALL cl_err(g_top_t.top01,SQLCA.sqlcode,0)   #No.FUN-660104
                   CALL cl_err3("del","top_file",g_top_t.top01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
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
              LET g_top[l_ac].* = g_top_t.*            
              CLOSE i205_bcl                                      
              ROLLBACK WORK                                 
              EXIT INPUT                           
           END IF                                                                  
           IF l_lock_sw="Y" THEN                                    
              CALL cl_err(g_top[l_ac].top01,-263,0)                
              LET g_top[l_ac].* = g_top_t.*                 
           ELSE 
              UPDATE top_file SET
                                  top01=g_top[l_ac].top01,
                                  top02=g_top[l_ac].top02,
                                  top03=g_top[l_ac].top03,
                                  topacti=g_top[l_ac].topacti
               WHERE CURRENT OF i205_bcl
              IF SQLCA.sqlcode THEN                                   
              #  CALL cl_err(g_top[l_ac].top01,SQLCA.sqlcode,0)   #No.FUN-660104   
                 CALL cl_err3("upd","top_file",g_top[l_ac].top01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
                 LET g_top[l_ac].* = g_top_t.*                       
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
                  LET g_top[l_ac].* = g_top_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_top.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF       
              CLOSE i205_bcl     
              ROLLBACK WORK     
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i205_bcl      
           COMMIT WORK
           
        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(top03) 
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.form ="q_too2"
                    LET g_qryparam.default1 = g_top[l_ac].top03
                    CALL cl_create_qry() RETURNING g_top[l_ac].top03
                    CALL i205_top03('a')
                    NEXT FIELD top03
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            CALL i205_b_askkey()
 
        ON ACTION CONTROLO
            IF INFIELD(top01) AND l_ac > 1 THEN
                LET g_top[l_ac].* = g_top[l_ac-1].*
                NEXT FIELD top01
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
 
    CLOSE i205_bcl
    COMMIT WORK 
END FUNCTION
 
FUNCTION i205_top03(p_cmd) 
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_too02     LIKE too_file.too02,
        l_tooacti   LIKE too_file.tooacti
 
    LET g_errno = ' '
    SELECT too02,tooacti INTO l_too02,l_tooacti FROM too_file
     WHERE too01 = g_top[l_ac].top03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET g_top[l_ac].top03 = NULL
         WHEN l_tooacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_top[l_ac].too02 = l_too02
    END IF
END FUNCTION
 
FUNCTION i205_b_askkey()
    CLEAR FORM
    CONSTRUCT g_wc2 ON top01,top02,top03,topacti
            FROM s_top[1].top01,s_top[1].top02,s_top[1].top03,
                 s_top[1].topacti
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
             CASE
                WHEN INFIELD(top03) 
                    CALL cl_init_qry_var()                                     
                    LET g_qryparam.form ="q_too2"
                    LET g_qryparam.state = "c"                                  
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO s_top[1].top03
                    NEXT FIELD top03
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
 
    CALL i205_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i205_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT top01,top02,top03,too02,topacti ",
        " FROM top_file,OUTER too_file ",
        " WHERE top_file.top03 = too_file.too01 AND ",p_wc2 CLIPPED,   #單身
        " ORDER BY top01"
    PREPARE i205_pb FROM g_sql
    DECLARE top_curs CURSOR FOR i205_pb
 
    CALL g_top.clear()
    LET g_cnt = 1
    FOREACH top_curs INTO g_top[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt=g_cnt+1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_top.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
        LET g_cnt = 0
END FUNCTION
 
FUNCTION i205_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_top TO s_top.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
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
FUNCTION i205_out()
    DEFINE
        l_top           RECORD LIKE top_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)  
        l_za05          LIKE za_file.za05 
 
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('atmi205') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM top_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i205_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i205_co                           # SCROLL CURSOR
         CURSOR FOR i205_p1
 
    START REPORT i205_rep TO l_name
 
    FOREACH i205_co INTO l_top.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT i205_rep(l_top.*)
    END FOREACH
 
    FINISH REPORT i205_rep
 
    CLOSE i205_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i205_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
        sr RECORD LIKE top_file.*,
        l_too02   LIKE too_file.too02,
        l_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.top01
 
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
	    SELECT too02 INTO l_too02 FROM too_file WHERE too01 = sr.top03
            PRINT COLUMN g_c[31],sr.top01 CLIPPED,
                  COLUMN g_c[32],sr.top02 CLIPPED,
                  COLUMN g_c[33],sr.top03 CLIPPED,
                  COLUMN g_c[34],l_too02 CLIPPED,
                  COLUMN g_c[35],sr.topacti
 
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
 
FUNCTION i205_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("top01",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION i205_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("top01",FALSE) 
    END IF 
 
END FUNCTION
