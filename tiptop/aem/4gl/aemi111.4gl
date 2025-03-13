# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: aemi111.4gl
# Descriptions...: 設備保修規模維護作業 
# Date & Author..: 04/07/07 By Elva
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.MOD-540141 05/04/20 By vivien  刪除HELP FILE 
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改 #
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680072 06/08/23 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0093 06/11/09 By Carrier 打印字段后加CLIPPED
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780037 07/06/29 By sherry 報表格式修改為p_query 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_fja           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
     fja01       LIKE fja_file.fja01,  
        fja02       LIKE fja_file.fja02, 
        fjaacti     LIKE fja_file.fjaacti
                    END RECORD,
    g_fja_t         RECORD                 #程式變數 (舊值)
     fja01       LIKE fja_file.fja01,  
        fja02       LIKE fja_file.fja02, 
        fjaacti     LIKE fja_file.fjaacti
                    END RECORD,
    g_wc2,g_sql     STRING,  #No.FUN-580092 HCN  
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680072 SMALLINT
    l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
DEFINE   p_row,p_col     LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10                                                         #No.FUN-680072 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose                        #No.FUN-680072 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE   l_cmd           LIKE type_file.chr1000       #No.FUN-780037   
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0068
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log 
 
    IF (NOT cl_setup("AEM")) THEN                                               
       EXIT PROGRAM                                                             
    END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
    LET p_row = 6 LET p_col = 35 
 
    OPEN WINDOW i111_w AT p_row,p_col WITH FORM "aem/42f/aemi111"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init() 
    CALL g_x.clear()
    LET g_wc2 = '1=1' CALL i111_b_fill(g_wc2)
    CALL i111_menu() 
    CLOSE WINDOW i111_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
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
               IF g_rec_b= 0 THEN                                               
                  CALL g_fja.deleteElement(1)                                   
               END IF
               CALL i111_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
            #No.FUN-760058---Begin 
            #  CALL i111_out()  
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                 
               LET l_cmd = 'p_query "aemi111" "',g_wc2 CLIPPED,'"'              
               CALL cl_cmdrun(l_cmd)        
            #No.FUN-760058---End                                           
            END IF                                                              
         WHEN "help"                                                            
            CALL cl_show_help()                                                    
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"                                                        
            CALL cl_cmdask()
      END CASE                                                                  
   END WHILE  
END FUNCTION
 
FUNCTION i111_q()
   CALL i111_b_askkey()
END FUNCTION
 
FUNCTION i111_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT    #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重復用           #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否           #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態             #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                         #No.FUN-680072 VARCHAR(1)              
    l_allow_delete  LIKE type_file.chr1                          #No.FUN-680072 VARCHAR(1)
 
    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fja01,fja02,fjaacti FROM fja_file ",
                       " WHERE fja01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i111_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR
 
 
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    INPUT ARRAY g_fja WITHOUT DEFAULTS FROM s_fja.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,            
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)   
 
 
    BEFORE INPUT
        IF g_rec_b != 0 THEN                                                
           CALL fgl_set_arr_curr(l_ac)                                      
        END IF    
 
 
    BEFORE ROW
        LET p_cmd = ''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
 
        IF g_rec_b >= l_ac THEN                                             
           LET p_cmd='u'                                                                   LET g_fja_t.* = g_fja[l_ac].*  #BACKUP  
 
#No.FUN-570110 --start--                                                                                                            
           LET g_before_input_done = FALSE                                                                                          
           CALL i111_set_entry_b(p_cmd)                                                                                             
           CALL i111_set_no_entry_b(p_cmd)                                                                                          
           LET g_before_input_done = TRUE                                                                                           
#No.FUN-570110 --end--  
           BEGIN WORK
           OPEN i111_bcl USING g_fja_t.fja01              #表示更改狀態
           IF STATUS THEN                
              CALL cl_err("OPEN i111_bcl:", STATUS, 1)         
              LET l_lock_sw = "Y"                      
           ELSE 
              FETCH i111_bcl INTO g_fja[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_fja_t.fja01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                          
            CALL i111_set_entry_b(p_cmd)                                                                                             
            CALL i111_set_no_entry_b(p_cmd)                                                                                          
            LET g_before_input_done = TRUE                                                                                           
#No.FUN-570110 --end--  
         INITIALIZE g_fja[l_ac].* TO NULL      #900423
            LET g_fja_t.* = g_fja[l_ac].*         #新輸入資料
            LET g_fja[l_ac].fjaacti = 'Y'       #Body default
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fja01
 
    AFTER INSERT
           IF INT_FLAG THEN                       
              CALL cl_err('',9001,0)                        
              LET INT_FLAG = 0                 
              CANCEL INSERT
           END IF
           INSERT INTO fja_file(fja01,fja02,fjaacti,fjaoriu,fjaorig)
           VALUES(g_fja[l_ac].fja01,g_fja[l_ac].fja02,g_fja[l_ac].fjaacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_fja[l_ac].fja01,SQLCA.sqlcode,0)   #No.FUN-660092
              CALL cl_err3("ins","fja_file",g_fja[l_ac].fja01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1                           
              DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
           END IF 
 
        AFTER FIELD fja01                        #check 編號是否重復
          IF NOT cl_null(g_fja[l_ac].fja01) THEN
            IF g_fja[l_ac].fja01 != g_fja_t.fja01 OR g_fja_t.fja01 IS NULL THEN
                SELECT count(*) INTO l_n FROM fja_file
                    WHERE fja01 = g_fja[l_ac].fja01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fja[l_ac].fja01 = g_fja_t.fja01
                    NEXT FIELD fja01
                END IF
            END IF
          END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fja_t.fja01 IS NOT NULL THEN
               IF NOT cl_delete() THEN                         
                  CANCEL DELETE                               
               END IF                                               
               IF l_lock_sw = "Y" THEN                       
                  CALL cl_err("", -263, 1)                       
                  CANCEL DELETE                     
               END IF  
{ckp#1}        DELETE FROM fja_file WHERE fja01 = g_fja_t.fja01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fja_t.fja01,SQLCA.sqlcode,0) #No.FUN-660092
                  CALL cl_err3("del","fja_file",g_fja_t.fja01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
                  EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               COMMIT WORK 
            END IF
 
    ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段                   
              CALL cl_err('',9001,0)                              
              LET INT_FLAG = 0                              
              LET g_fja[l_ac].* = g_fja_t.*            
              CLOSE i111_bcl                                      
              ROLLBACK WORK                                 
              EXIT INPUT                           
           END IF                                                                  
           IF l_lock_sw="Y" THEN                                    
              CALL cl_err(g_fja[l_ac].fja01,-263,0)                
              LET g_fja[l_ac].* = g_fja_t.*                 
           ELSE 
              UPDATE fja_file
                 SET fja01=g_fja[l_ac].fja01,fja02=g_fja[l_ac].fja02,
                     fjaacti=g_fja[l_ac].fjaacti
               WHERE fja01 = g_fja_t.fja01  
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_fja[l_ac].fja01,SQLCA.sqlcode,0)   #No.FUN-660092
                 CALL cl_err3("upd","fja_file",g_fja_t.fja01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
                 LET g_fja[l_ac].* = g_fja_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i111_bcl 
                 COMMIT WORK 
              END IF
           END IF
 
       AFTER ROW
           LET l_ac = ARR_CURR()         # 新增                
           #LET l_ac_t = l_ac  #FUN-D40030
 
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_fja[l_ac].* = g_fja_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_fja.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i111_bcl            # 新增                 
              ROLLBACK WORK         # 新增                    
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D40030
           CLOSE i111_bcl            # 新增                    
           COMMIT WORK 
 
        ON ACTION CONTROLN 
            CALL i111_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(fja01) AND l_ac > 1 THEN
                LET g_fja[l_ac].* = g_fja[l_ac-1].*
                NEXT FIELD fja01
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
 #No.MOD-540141--begin
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913              
 #No.MOD-540141--end  
 
 
        ON IDLE g_idle_seconds                                               
              CALL cl_on_idle()                                                 
              CONTINUE INPUT   
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
        END INPUT
 
    CLOSE i111_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i111_b_askkey()
    CLEAR FORM
    CALL g_fja.clear()
 CONSTRUCT g_wc2 ON fja01,fja02,fjaacti
                  FROM s_fja[1].fja01,s_fja[1].fja02,s_fja[1].fjaacti
    ON IDLE g_idle_seconds                                                   
          CALL cl_on_idle()                                                     
          CONTINUE CONSTRUCT                                                    
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    END CONSTRUCT 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i111_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i111_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    LET g_sql =
        "SELECT fja01,fja02,fjaacti",
        " FROM fja_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY fja01"
    PREPARE i111_pb FROM g_sql
    DECLARE fja_curs CURSOR FOR i111_pb
 
    CALL g_fja.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH fja_curs INTO g_fja[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fja.deleteElement(g_cnt)  
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i111_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_fja TO s_fja.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
      BEFORE ROW                                                                
         LET l_ac = ARR_CURR()  
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
                                                                                
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit" 
         EXIT DISPLAY 
 
      ON ACTION close
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
 
#No.FUN-780037---Begin
{
FUNCTION i111_out()
    DEFINE
        l_fja           RECORD LIKE fja_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680072 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680072 VARCHAR(20)
        l_za05          LIKE type_file.chr1000   #No.FUN-680072 VARCHAR(40)
   
    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('aemi111') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM fja_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i111_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i111_co                         # CURSOR
        CURSOR FOR i111_p1
 
    START REPORT i111_rep TO l_name
 
    FOREACH i111_co INTO l_fja.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i111_rep(l_fja.*)
    END FOREACH
 
    FINISH REPORT i111_rep
 
    CLOSE i111_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i111_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680072 VARCHAR(1)
        sr RECORD LIKE fja_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.fja01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED             
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<', "/pageno"                    
            PRINT g_head CLIPPED, pageno_total                                  
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1, g_x[1] CLIPPED  #No.TQC-6A0093
            PRINT
            PRINT g_dash[1,g_len]                                               
            PRINT g_x[31], g_x[32], g_x[33]                                     
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.fja01,                                      
                  COLUMN g_c[32],sr.fja02,                                      
                  COLUMN g_c[33],sr.fjaacti
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #No.TQC-6A0093
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED  #No.TQC-6A0093
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-780037---End
#No.FUN-570110 --start--                                                                                                            
FUNCTION i111_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1              #No.FUN-680072 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("fja01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i111_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1              #No.FUN-680072 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("fja01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end-- 
