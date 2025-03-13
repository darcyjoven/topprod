# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
#
# Pattern name...: atmi183.4gl
# Descriptions...: 派車原因維護作業
# Date & Author..: 2003/12/02 By Leagh
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義
# Modify.........: No.FUN-520024 05/02/25 報表轉XML By wujie
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制 
# Modify.........: No.FUN-650065 06/05/31 By Tracy axd模塊轉atm模塊   
# Modify.........: No.TQC-660029 06/06/07 By Mandy Informix r.c2 不過 因為TQC-630166 用{}mark 改用#
# Modify.........: NO.FUN-660104 06/06/16 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780056 07/07/18 By mike報表格式修改為p_query
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30033 13/04/09 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_adj           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
     adj01       LIKE adj_file.adj01,   #派車原因
        adj02       LIKE adj_file.adj02,   #說明
        adjacti     LIKE adj_file.adjacti  #有效否
                    END RECORD,
    g_adj_t         RECORD              
     adj01       LIKE adj_file.adj01,   #派車原因
        adj02       LIKE adj_file.adj02,   #說明
        adjacti     LIKE adj_file.adjacti  #有效否
                    END RECORD,
    g_wc2,g_sql     STRING,#TQC-630166
    g_rec_b         LIKE type_file.num5,               #單身筆數                #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT     #No.FUN-680120 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5                #No.FUN-680120 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL      
DEFINE   g_cnt           LIKE type_file.num10                                   #No.FUN-680120 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680120 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5       #No.FUN-680120 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6B0014
 
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
 
    LET p_row = 3 LET p_col = 30
    OPEN WINDOW i183_w AT p_row,p_col WITH FORM "atm/42f/atmi183"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init() 
    CALL g_x.clear()
    LET g_wc2 = '1=1' CALL i183_b_fill(g_wc2)
    CALL i183_menu()  
    CLOSE WINDOW i183_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION i183_menu()
  DEFINE    l_cmd    STRING        #No.FUN-780056
   WHILE TRUE                                                                   
      CALL i183_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i183_q()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i183_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               #CALL i183_out()                                      #No.FUN-780056
               IF cl_null(g_wc2) THEN LET g_wc2='1=1' END IF         #No.FUN-780056
               LET l_cmd = 'p_query "atmi183" "',g_wc2 CLIPPED,'"'   #No.FUN-780056
               CALL cl_cmdrun(l_cmd)                                 #No.FUN-780056                                
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
 
FUNCTION i183_q()
   CALL i183_b_askkey()
END FUNCTION
 
FUNCTION i183_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用         #No.FUN-680120 SMALLINT
    l_no            LIKE type_file.num5,                #No.FUN-680120 SMALLINT            #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #No.FUN-680120 VARCHAR(1)             #可新增否                            
    l_allow_delete  LIKE type_file.chr1                 #No.FUN-680120 VARCHAR(1)              #可刪除否 
 
    LET g_action_choice = ""        
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT adj01,adj02,adjacti FROM adj_file ",
                       " WHERE adj01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i183_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR
 
    INPUT ARRAY g_adj WITHOUT DEFAULTS FROM s_adj.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,     
                     APPEND ROW = l_allow_insert)                               
                                                                                
    BEFORE INPUT
            IF g_rec_b != 0 THEN                                                
               CALL fgl_set_arr_curr(l_ac)                                      
            END IF   
 
    BEFORE ROW
        LET p_cmd = ''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        IF g_rec_b >= l_ac THEN                                             
           BEGIN WORK
           LET p_cmd='u' 
           LET g_adj_t.* = g_adj[l_ac].*  #BACKUP
#No.FUN-570109 --start                                                          
           LET g_before_input_done = FALSE                                      
           CALL i183_set_entry(p_cmd)                                           
           CALL i183_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE                                       
#No.FUN-570109 --end           
           OPEN i183_bcl USING g_adj_t.adj01              #表示更改狀態
           IF STATUS THEN                
              CALL cl_err("OPEN i183_bcl:", STATUS, 1)         
              LET l_lock_sw = "Y"                      
           ELSE 
              FETCH i183_bcl INTO g_adj[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_adj_t.adj01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
    BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i183_set_entry(p_cmd)                                          
            CALL i183_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570109 --end     
         INITIALIZE g_adj[l_ac].* TO NULL      #900423
            LET g_adj_t.* = g_adj[l_ac].*         #新輸入資料
            LET g_adj[l_ac].adjacti = 'Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adj01
 
    AFTER INSERT
           IF INT_FLAG THEN                       
              CALL cl_err('',9001,0)                        
              LET INT_FLAG = 0                 
              CANCEL INSERT
           END IF
           INSERT INTO adj_file(adj01,adj02,adjacti,adjoriu,adjorig)                
           VALUES(g_adj[l_ac].adj01,g_adj[l_ac].adj02,
                  g_adj[l_ac].adjacti, g_user, g_grup)                      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN                                    
#             CALL cl_err(g_adj[l_ac].adj01,SQLCA.sqlcode,0)          #No.FUN-660104
              CALL cl_err3("ins","adj_file",g_adj[l_ac].adj01,"",
                            SQLCA.sqlcode,"","",1)  #No.FUN-660104
              CANCEL INSERT
           ELSE                                                     
              MESSAGE 'INSERT O.K'                                  
              LET g_rec_b=g_rec_b+1                              
              DISPLAY g_rec_b TO FORMONLY.cn2 
           END IF
 
        AFTER FIELD adj01                        #check是否重複
           IF g_adj[l_ac].adj01 IS NOT NULL THEN 
            IF g_adj[l_ac].adj01 != g_adj_t.adj01 OR
               (g_adj[l_ac].adj01 IS NOT NULL AND g_adj_t.adj01 IS NULL) THEN
               SELECT COUNT(*) INTO l_no FROM adj_file
                WHERE adj01 = g_adj[l_ac].adj01
                IF l_no > 0 THEN
                    CALL cl_err(g_adj[l_ac].adj01,-239,0)
                    LET g_adj[l_ac].adj01 = g_adj_t.adj01
                    NEXT FIELD adj01
                END IF
            END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_adj_t.adj01 IS NOT NULL THEN
               IF NOT cl_delete() THEN                         
                  CANCEL DELETE                               
               END IF                                               
               IF l_lock_sw = "Y" THEN                       
                  CALL cl_err("", -263, 1)                       
                  CANCEL DELETE                     
               END IF  
{ckp#1}        DELETE FROM adj_file WHERE adj01 = g_adj_t.adj01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_adj_t.adj01,SQLCA.sqlcode,0)  #No.FUN-660104
                  CALL cl_err3("del","adj_file",g_adj_t.adj01,"",
                                SQLCA.sqlcode,"","",1)  #No.FUN-660104
                  EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
            COMMIT WORK 
 
    ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段                   
              CALL cl_err('',9001,0)                              
              LET INT_FLAG = 0                              
              LET g_adj[l_ac].* = g_adj_t.*            
              CLOSE i183_bcl                                      
              ROLLBACK WORK                                 
              EXIT INPUT                           
           END IF                                                                  
           IF l_lock_sw="Y" THEN                                    
              CALL cl_err(g_adj[l_ac].adj01,-263,0)                
              LET g_adj[l_ac].* = g_adj_t.*                 
           ELSE 
              UPDATE adj_file 
                 SET adj01=g_adj[l_ac].adj01,adj02=g_adj[l_ac].adj02,
                     adjacti=g_adj[l_ac].adjacti                
               WHERE CURRENT OF i183_bcl                              
              IF SQLCA.sqlcode THEN                                   
#                CALL cl_err(g_adj[l_ac].adj01,SQLCA.sqlcode,0)        #No.FUN-660104
                 CALL cl_err3("upd","adj_file",g_adj[l_ac].adj01,"",
                               SQLCA.sqlcode,"","",1)  #No.FUN-660104
                 LET g_adj[l_ac].* = g_adj_t.*                       
              ELSE                                                    
                 MESSAGE 'UPDATE O.K'                                
                 COMMIT WORK 
              END IF
           END IF
 
    AFTER ROW
           LET l_ac = ARR_CURR()         # 新增                
          #LET l_ac_t = l_ac   #FUN-D30033 mark
 
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_adj[l_ac].* = g_adj_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_adj.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i183_bcl            # 新增                 
              ROLLBACK WORK         # 新增                    
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add    
           CLOSE i183_bcl            # 新增                 
           COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i183_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       # 沿用所有欄位
            IF INFIELD(adj01) AND l_ac > 1 THEN
                LET g_adj[l_ac].* = g_adj[l_ac-1].*
                NEXT FIELD adj01
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
 
    CLOSE i183_bcl
    COMMIT WORK 
END FUNCTION
 
FUNCTION i183_b_askkey()
    CLEAR FORM
    CALL g_adj.clear() 
 CONSTRUCT g_wc2 ON adj01,adj02,adjacti
            FROM s_adj[1].adj01,s_adj[1].adj02,s_adj[1].adjacti
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
    CALL i183_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i183_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
 
    LET g_sql =
        "SELECT adj01,adj02,adjacti,''",
        " FROM adj_file WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY adj01"
    PREPARE i183_pb FROM g_sql
    DECLARE adj_curs CURSOR FOR i183_pb
 
    CALL g_adj.clear() 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH adj_curs INTO g_adj[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_adj.deleteElement(g_cnt)     
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i183_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_adj TO s_adj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
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
 
#No.FUN-780056 -str
{
FUNCTION i183_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    sr              RECORD
        adj01       LIKE adj_file.adj01,   #派車原因
        adj02       LIKE adj_file.adj02,   #說明
        adjacti     LIKE adj_file.adjacti  #有效否
                    END RECORD,
    l_name          LIKE type_file.chr20,          #No.FUN-680120 VARCHAR(20)             #External(Disk) file name
     l_za05          LIKE za_file.za05      #MOD-4B0067
 
    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('atmi183') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT adj01,adj02,adjacti ",
              " FROM adj_file ",  # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED,
              " ORDER BY adj01 "
    PREPARE i183_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i183_co                         # CURSOR
        CURSOR FOR i183_p1
    START REPORT i183_rep TO l_name
    FOREACH i183_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i183_rep(sr.*)
    END FOREACH
    FINISH REPORT i183_rep
    CLOSE i183_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
}
#No.FUN-780056 -end
 
#No.FUN-780056 -str
#REPORT i183_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
#    sr              RECORD
#        adj01       LIKE adj_file.adj01,   #派車原因
#        adj02       LIKE adj_file.adj02,   #說明
#        adjacti     LIKE adj_file.adjacti  #有效否
#                    END RECORD 
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.adj01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            LET g_pageno = g_pageno + 1                                         
#            LET pageno_total = PAGENO USING '<<<',"/pageno"                     
#            PRINT g_head CLIPPED,pageno_total
#            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            PRINT ' '
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31],g_x[32],g_x[33]  
#            PRINT g_dash1 
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.adj01
#            PRINT COLUMN g_c[31],sr.adj01 CLIPPED;
#
#        ON EVERY ROW
#         PRINT COLUMN g_c[32],sr.adj02 CLIPPED,COLUMN g_c[33],sr.adjacti CLIPPED
#
#        ON LAST ROW
#            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#               PRINT g_dash[1,g_len]
#            #TQC-630166
#           #TQC-660029
#           #{
#        #   IF g_sql[001,080] > ' ' THEN
#	   #           PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#           #   IF g_sql[071,140] > ' ' THEN
#	   #           PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#           #   IF g_sql[141,210] > ' ' THEN
#	   #           PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#           #}
#              CALL cl_prt_pos_wc(g_sql)
#            #END TQC-630166
#            END IF
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-780056 -end
 
#No.FUN-570109 --start                                                          
FUNCTION i183_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1            #No.FUN-680120 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("adj01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i183_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1            #No.FUN-680120 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("adj01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570109 --end                     
