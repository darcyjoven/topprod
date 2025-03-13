# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi204.4gl
# Descriptions...: atmi204  省別代碼維護作業
# Date & Author..: 05/10/18 By day 
# Modify.........: No.FUN-660104 06/06/15 By cl Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780056 07/07/20 By mike報表格式修改為p_query 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30033 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_too           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        too01       LIKE too_file.too01,
        too02       LIKE too_file.too02,
        too03       LIKE too_file.too03,
        geo02       LIKE geo_file.geo02,
        tooacti     LIKE too_file.tooacti
                    END RECORD,
    g_too_t         RECORD                 #程式變數 (舊值)
        too01       LIKE too_file.too01,
        too02       LIKE too_file.too02,
        too03       LIKE too_file.too03,
        geo02       LIKE geo_file.geo02,
        tooacti     LIKE too_file.tooacti
                    END RECORD,
    g_wc2,g_sql    string,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680120 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680120
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
    OPEN WINDOW i204_w AT p_row,p_col WITH FORM "atm/42f/atmi204"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    LET g_wc2 = ' 1=1' CALL i204_b_fill(g_wc2)
    CALL i204_bp('D')
    CALL i204_menu()    #中文
    CLOSE WINDOW i204_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i204_menu()
 DEFINE   l_cmd   STRING   #No.FUN-780056 
  WHILE TRUE
    CALL i204_bp("G")
    CASE g_action_choice
       WHEN "query"
          IF cl_chk_act_auth() THEN 
             CALL i204_q()
          END IF
       WHEN "detail"
          IF cl_chk_act_auth() THEN 
             CALL i204_b()
          END IF
       WHEN "output"
          IF cl_chk_act_auth() THEN 
             #CALL i204_out()                                      #No.FUN-780056
             IF cl_null(g_wc2)  THEN LET g_wc2='1=1' END IF        #No.FUN-780056 
             LET l_cmd = 'p_query "atmi204" "',g_wc2 CLIPPED,'"'   #No.FUN-780056 
             CALL cl_cmdrun(l_cmd)                                 #No.FUN-780056 
          END IF
       WHEN "help"
          CALL cl_show_help()
       WHEN "exit"
          EXIT WHILE
       WHEN "controlg"
          CALL cl_cmdask()
       WHEN "exporttoexcel"  
          IF cl_chk_act_auth() THEN
             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_too),'','')
          END IF
     END CASE
   END WHILE
END FUNCTION
 
FUNCTION i204_q()
   CALL i204_b_askkey()
END FUNCTION
 
FUNCTION i204_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680120 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否          #No.FUN-680120 SMALLINT
    l_possible      LIKE type_file.num5                #No.FUN-680120 SMALLINT             #用來設定判斷重複的可能性
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    CALL cl_opmsg('b')
 
   LET g_forupd_sql =
       "SELECT too01,too02,too03,'',tooacti",
       " FROM too_file",
       "  WHERE too01 = ? ",
       " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i204_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_too WITHOUT DEFAULTS FROM s_too.*
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
                LET g_before_input_done = FALSE
                CALL i204_set_entry(p_cmd)
                CALL i204_set_no_entry(p_cmd)
                LET g_before_input_done = TRUE
                LET g_too_t.* = g_too[l_ac].*  #BACKUP
                OPEN i204_bcl USING g_too_t.too01               #表示更改狀態
                IF STATUS THEN
                    CALL cl_err("OPEN i204_bcl:",STATUS,1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i204_bcl INTO g_too[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_too_t.too01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                SELECT geo02 INTO g_too[l_ac].geo02 FROM geo_file
                 WHERE geo01 = g_too[l_ac].too03
                END IF
                CALL cl_show_fld_cont()     
              END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE
            CALL i204_set_entry(p_cmd)
            CALL i204_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            INITIALIZE g_too[l_ac].* TO NULL  
            LET g_too[l_ac].tooacti = 'Y'         #Body default
            LET g_too_t.* = g_too[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()   
            NEXT FIELD too01
 
        AFTER FIELD too01                        #check 編號是否重複
            IF NOT cl_null(g_too[l_ac].too01) THEN
               IF g_too[l_ac].too01 != g_too_t.too01 OR
                  g_too_t.too01 IS NULL THEN
                   SELECT count(*) INTO l_n FROM too_file
                       WHERE too01 = g_too[l_ac].too01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_too[l_ac].too01 = g_too_t.too01
                       NEXT FIELD too01
                   END IF
               END IF
            END IF
 
        AFTER FIELD too03 
	    IF NOT cl_null(g_too[l_ac].too03) THEN
               SELECT * FROM geo_file 
                WHERE geo01 = g_too[l_ac].too03
               IF SQLCA.sqlcode = 100 THEN
               #  CALL cl_err(g_too[l_ac].too03,100,0)  #No.FUN-660104
                  CALL cl_err3("sel","geo_file",g_too[l_ac].too03,"",100,"","",1) #No.FUN-660104
                  NEXT FIELD too03
   	       ELSE
                  CALL i204_too03('a')
    	          IF NOT cl_null(g_errno)  THEN
	             CALL cl_err('',g_errno,0)
 	             LET g_too[l_ac].too03 = g_too_t.too03
                     NEXT FIELD too03
                  END IF
    	       END IF
            END IF
 
    AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO too_file(too01,too02,too03,tooacti)
                          VALUES(g_too[l_ac].too01,g_too[l_ac].too02,
                                 g_too[l_ac].too03,
                                 g_too[l_ac].tooacti)
           IF SQLCA.sqlcode THEN
           #   CALL cl_err(g_too[l_ac].too01,SQLCA.sqlcode,0)  #No.FUN-660104
               CALL cl_err3("ins","too_file",g_too[l_ac].too01,"",SQLCA.sqlcode,"","",1) #No.FUN-660104
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_too_t.too01 IS NOT NULL THEN
               IF NOT cl_delete() THEN                         
                  CANCEL DELETE                               
               END IF                                               
               IF l_lock_sw = "Y" THEN                       
                  CALL cl_err("", -263, 1)                       
                  CANCEL DELETE                     
               END IF  
               DELETE FROM too_file WHERE too01 = g_too_t.too01
               IF SQLCA.sqlcode THEN
               #   CALL cl_err(g_too_t.too01,SQLCA.sqlcode,0)  #No.FUN-660104
                   CALL cl_err3("del","too_file",g_too_t.too01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
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
              LET g_too[l_ac].* = g_too_t.*            
              CLOSE i204_bcl                                      
              ROLLBACK WORK                                 
              EXIT INPUT                           
           END IF                                                                  
           IF l_lock_sw="Y" THEN                                    
              CALL cl_err(g_too[l_ac].too01,-263,0)                
              LET g_too[l_ac].* = g_too_t.*                 
           ELSE 
              UPDATE too_file SET
                                  too01=g_too[l_ac].too01,
                                  too02=g_too[l_ac].too02,
                                  too03=g_too[l_ac].too03,
                                  tooacti=g_too[l_ac].tooacti
               WHERE CURRENT OF i204_bcl
              IF SQLCA.sqlcode THEN                                   
              #  CALL cl_err(g_too[l_ac].too01,SQLCA.sqlcode,0)     #NO.FUN-660104 
                 CALL cl_err3("upd","too_file",g_too[l_ac].too01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_too[l_ac].* = g_too_t.*                       
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
                  LET g_too[l_ac].* = g_too_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_too.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF       
              CLOSE i204_bcl     
              ROLLBACK WORK     
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add   
           CLOSE i204_bcl      
           COMMIT WORK
           
        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(too03) 
                    CALL cl_init_qry_var()                                        
                    LET g_qryparam.form ="q_geo"
                    LET g_qryparam.default1 = g_too[l_ac].too03
                    CALL cl_create_qry() RETURNING g_too[l_ac].too03
                    DISPLAY BY NAME g_too[l_ac].too03
                    CALL i204_too03('a')
                    NEXT FIELD too03
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            CALL i204_b_askkey()
 
        ON ACTION CONTROLO
            IF INFIELD(too01) AND l_ac > 1 THEN
                LET g_too[l_ac].* = g_too[l_ac-1].*
                NEXT FIELD too01
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
 
    CLOSE i204_bcl
    COMMIT WORK 
END FUNCTION
 
FUNCTION i204_too03(p_cmd) 
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680120 VARCHAR(1)
        l_geo02     LIKE geo_file.geo02,
        l_geoacti   LIKE geo_file.geoacti
 
    LET g_errno = ' '
    SELECT geo02,geoacti INTO l_geo02,l_geoacti FROM geo_file
     WHERE geo01 = g_too[l_ac].too03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET g_too[l_ac].too03 = NULL
         WHEN l_geoacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_too[l_ac].geo02 = l_geo02
    END IF
END FUNCTION
 
FUNCTION i204_b_askkey()
    CLEAR FORM
    CONSTRUCT g_wc2 ON too01,too02,too03,tooacti
            FROM s_too[1].too01,s_too[1].too02,s_too[1].too03,
                 s_too[1].tooacti
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
           CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
             CASE
                WHEN INFIELD(too03) 
                    CALL cl_init_qry_var()                                        
                    LET g_qryparam.form ="q_geo"
                    LET g_qryparam.state = "c"                                  
                    CALL cl_create_qry() RETURNING g_qryparam.multiret          
                    DISPLAY g_qryparam.multiret TO s_too[1].too03
                    NEXT FIELD too03
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
    CALL i204_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i204_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT too01,too02,too03,geo02,tooacti ",
        " FROM too_file,OUTER geo_file ",
        " WHERE too_file.too03=geo_file.geo01 AND ",p_wc2 CLIPPED,   #單身
        " ORDER BY too01"
    PREPARE i204_pb FROM g_sql
    DECLARE too_curs CURSOR FOR i204_pb
 
    CALL g_too.clear()
    LET g_cnt = 1
    FOREACH too_curs INTO g_too[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt=g_cnt+1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_too.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
        LET g_cnt = 0
END FUNCTION
 
FUNCTION i204_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_too TO s_too.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
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
FUNCTION i204_out()
    DEFINE
        l_too           RECORD LIKE too_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680120 VARCHAR(20)
        l_za05          LIKE za_file.za05 
 
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('atmi204') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM too_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i204_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i204_co                           # SCROLL CURSOR
         CURSOR FOR i204_p1
 
    START REPORT i204_rep TO l_name
 
    FOREACH i204_co INTO l_too.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT i204_rep(l_too.*)
    END FOREACH
 
    FINISH REPORT i204_rep
 
    CLOSE i204_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i204_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680120 VARCHAR(1)
        sr RECORD LIKE too_file.*,
        l_geo02   LIKE geo_file.geo02,
        l_chr           LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.too01
 
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
	    SELECT geo02 INTO l_geo02 FROM geo_file WHERE geo01 = sr.too03
            PRINT COLUMN g_c[31],sr.too01 CLIPPED,
                  COLUMN g_c[32],sr.too02 CLIPPED,
                  COLUMN g_c[33],sr.too03 CLIPPED,
                  COLUMN g_c[34],l_geo02 CLIPPED,
                  COLUMN g_c[35],sr.tooacti
 
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
 
FUNCTION i204_set_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
      CALL cl_set_comp_entry("too01",TRUE)
    END IF 
 
END FUNCTION
 
FUNCTION i204_set_no_entry(p_cmd) 
  DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680120 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN 
       CALL cl_set_comp_entry("too01",FALSE) 
    END IF 
 
END FUNCTION
