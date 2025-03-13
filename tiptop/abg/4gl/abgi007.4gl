# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: abgi007.4gl
# Descriptions...: 費用項目資料維護作業
# Date & Author..: 02/09/24 By qazzaq
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/14 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/07 By baogui 結束位置調整
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780047 07/07/16 By destiny 報表由p_query產出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_bgs          DYNAMIC ARRAY of RECORD #程式變數(Program Variables)
     bgs01      LIKE bgs_file.bgs01,    #費用項目
        bgs02      LIKE bgs_file.bgs02,    #費用項目說明
        bgs03      LIKE bgs_file.bgs03     #計調否
                   END RECORD,
    g_bgs_t        RECORD                  #程式變數 (舊值)
     bgs01      LIKE bgs_file.bgs01,    #費用項目
        bgs02      LIKE bgs_file.bgs02,    #費用項目說明
        bgs03      LIKE bgs_file.bgs03     #計調否
                   END RECORD,
    g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b        LIKE type_file.num5,    #單身筆數 #No.FUN-680061 SMALLINT
    l_ac           LIKE type_file.num5     #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
 
DEFINE g_forupd_sql         STRING                #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5   #FUN-680061 SMALLINT
 
DEFINE g_cnt                LIKE type_file.num10  #No.FUN-680061 INTEGER
DEFINE g_i                  LIKE type_file.num5   #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_msg                LIKE ze_file.ze03     #No.FUN-680061 VARCHAR(72)
DEFINE p_row,p_col          LIKE type_file.num5   #No.FUN-680061 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0056
DEFINE p_row,p_col   LIKE type_file.num5   #No.FUN-680061 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log                                          
                                                                                
    IF (NOT cl_setup("ABG")) THEN                                               
       EXIT PROGRAM                                                             
    END IF            
      CALL  cl_used(g_prog,g_time,1)        #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
 
    LET p_row = 4 LET p_col = 10
 
    OPEN WINDOW i007_w AT p_row,p_col WITH FORM "abg/42f/abgi007"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)  #No.FUN-580092 HCN
     CALL cl_ui_init()
 
 #   CALL i007_b_fill(' 1=1')
 #   CALL i007_bp('D')
    CALL i007_menu()    #中文
 
    CLOSE WINDOW i007_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
FUNCTION i007_menu()
DEFINE l_cmd  LIKE type_file.chr1000      #No.FUN-780047
   WHILE TRUE                                                                   
      CALL i007_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i007_q()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i007_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
#               CALL i007_out()                             #No.FUN-780047
            #No.FUN-780047 --start--
            IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF 
            LET l_cmd='p_query "abgi007" "',g_wc2 CLIPPED,'"'    
            CALL cl_cmdrun(l_cmd)                           
            #No.FUN-780047 --end--                           
            END IF                                                              
         WHEN "help"                                                            
            CALL cl_show_help()                                                    
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"       
            CALL cl_cmdask()                                                    
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgs),'','')
            END IF
      END CASE                                                                  
   END WHILE                                                                    
END FUNCTION 
 
FUNCTION i007_q()
   CALL i007_b_askkey()
END FUNCTION
 
FUNCTION i007_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680061 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,   #可新增否          #No.FUN-680061 VARCHAR(1)                      
    l_allow_delete  LIKE type_file.num5    #可刪除否          #No.FUN-680061 VARCHAR(1)
 
    LET g_action_choice = "" 
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql="SELECT bgs01,bgs02,bgs03 FROM bgs_file WHERE bgs01=?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i007_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')  
 
        INPUT ARRAY g_bgs WITHOUT DEFAULTS FROM s_bgs.*
            ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,             
                       INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,   
                       APPEND ROW = l_allow_insert) 
 
        BEFORE INPUT                                                            
            IF g_rec_b != 0 THEN                                                
               CALL fgl_set_arr_curr(l_ac)                                      
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
#No.FUN-570108--begin                                                           
            LET p_cmd='u'
            LET g_before_input_done = FALSE                                 
            CALL i007_set_entry(p_cmd)                                      
            CALL i007_set_no_entry(p_cmd)                                   
            LET g_before_input_done = TRUE                                  
#No.FUN-570108--end          
            BEGIN WORK
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_bgs_t.*=g_bgs[l_ac].*
                OPEN i007_bcl USING g_bgs_t.bgs01
                IF STATUS THEN                                                  
                   CALL cl_err("OPEN i007_bcl:", STATUS, 1)                     
                   LET l_lock_sw = "Y"                                          
                ELSE      
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_bgs_t.bgs01,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   FETCH i007_bcl INTO g_bgs[l_ac].* 
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD bgs01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108--begin                                                           
            LET g_before_input_done = FALSE                                     
            CALL i007_set_entry(p_cmd)                                          
            CALL i007_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108--end        
            INITIALIZE g_bgs[l_ac].* TO NULL      #900423
            LET g_bgs_t.* = g_bgs[l_ac].*         #新輸入資料
            LET g_bgs[l_ac].bgs03='Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bgs01
 
        AFTER INSERT                                                            
           IF INT_FLAG THEN                                                     
              CALL cl_err('',9001,0)                                            
              LET INT_FLAG = 0                                                  
              CANCEL INSERT                                                     
           END IF    
           INSERT INTO bgs_file(bgs01,bgs02,bgs03,bgsoriu,bgsorig)
           VALUES(g_bgs[l_ac].bgs01,g_bgs[l_ac].bgs02,g_bgs[l_ac].bgs03, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgs[l_ac].bgs01,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("ins","bgs_file",g_bgs[l_ac].bgs01,"",SQLCA.sqlcode,"","",1) #FUN-660105
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
               COMMIT WORK
           END IF
 
        AFTER FIELD bgs01                        #check 編號是否重複
            IF NOT cl_null(g_bgs[l_ac].bgs01) THEN
               IF g_bgs[l_ac].bgs01 != g_bgs_t.bgs01 OR
                  cl_null(g_bgs_t.bgs01) THEN
                  SELECT count(*) INTO l_n FROM bgs_file
                   WHERE bgs01 = g_bgs[l_ac].bgs01
                  IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_bgs[l_ac].bgs01 = g_bgs_t.bgs01
                      NEXT FIELD bgs01
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bgs_t.bgs01) THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN                                         
                   CALL cl_err("", -263, 1)                                     
                   CANCEL DELETE                                                
                END IF   
{ckp#1}         DELETE FROM bgs_file WHERE bgs01 = g_bgs_t.bgs01
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bgs_t.bgs01,SQLCA.sqlcode,0) #FUN-660105
                    CALL cl_err3("del","bgs_file",g_bgs_t.bgs01,"",SQLCA.sqlcode,"","",1) #FUN-660105
                    LET l_ac_t = l_ac
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                CLOSE i007_bcl                                                  
            END IF
            COMMIT WORK    
 
        ON ROW CHANGE                                                           
           IF INT_FLAG THEN                 #新增程式段                         
              CALL cl_err('',9001,0)                                            
              LET INT_FLAG = 0                                                  
              LET g_bgs[l_ac].* = g_bgs_t.*                                     
              CLOSE i007_bcl                                                    
              ROLLBACK WORK                                                     
              EXIT INPUT                                                        
           END IF                                                               
                                                                                
           IF l_lock_sw="Y" THEN                                                
              CALL cl_err(g_bgs[l_ac].bgs01,-263,0)                             
              LET g_bgs[l_ac].* = g_bgs_t.*                                     
           ELSE 
      UPDATE bgs_file SET bgs01=g_bgs[l_ac].bgs01,
                          bgs02=g_bgs[l_ac].bgs02,
                          bgs03=g_bgs[l_ac].bgs03
      WHERE CURRENT OF i007_bcl
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_bgs[l_ac].bgs01,SQLCA.sqlcode,0) #FUN-660105
                  CALL cl_err3("upd","bgs_file",g_bgs[l_ac].bgs01,"",SQLCA.sqlcode,"","",1) #FUN-660105
                  LET g_bgs[l_ac].* = g_bgs_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i007_bcl
                  COMMIT WORK
               END IF
          END IF 
              
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
           #LET l_ac_t = l_ac    #FUN-D30032 mark                                               
            IF INT_FLAG THEN                                                    
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN                                              
                  LET g_bgs[l_ac].* = g_bgs_t.*                                 
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgs.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF                                                           
               CLOSE i007_bcl                                                  
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                               
            LET l_ac_t = l_ac    #FUN-D30032 add                               
            CLOSE i007_bcl                                                     
            COMMIT WORK 
 
        ON ACTION CONTROLN
            CALL i007_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(bgs01) AND l_ac > 1 THEN
                LET g_bgs[l_ac].* = g_bgs[l_ac-1].*
                NEXT FIELD bgs01
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
 
    CLOSE i007_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i007_b_askkey()
    CLEAR FORM
    CALL g_bgs.clear()
 CONSTRUCT g_wc2 ON bgs01,bgs02,bgs03 FROM s_bgs[1].bgs01,s_bgs[1].bgs02,
                                              s_bgs[1].bgs03
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
    CALL i007_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i007_b_fill(p_wc2)               #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000#No.FUN-680061 VARCHAR(200)
 
    LET g_sql =
        "SELECT bgs01,bgs02,bgs03",
        " FROM bgs_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY bgs01"
    PREPARE i007_pb FROM g_sql
    DECLARE bgs_curs CURSOR FOR i007_pb
 
    CALL g_bgs.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" ATTRIBUTE(REVERSE)
    FOREACH bgs_curs INTO g_bgs[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bgs.deleteElement(g_cnt) 
 
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i007_bp(p_ud)
DEFINE                                                                          
    p_ud     LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
                                                                                
    IF p_ud <> "G" OR g_action_choice = "detail" THEN                           
                                                                                
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_bgs TO s_bgs.* ATTRIBUTE(COUNT=g_rec_b)                      
                                                                                
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
 
                                                                                
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)                               
END FUNCTION
#No.FUN-780047--start--
{FUNCTION i007_out()
    DEFINE
        l_bgs  RECORD LIKE bgs_file.*,
        l_i    LIKE type_file.num5,    #No.FUN-680061 SMALLINT         
        l_name LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
        l_za05 LIKE type_file.chr1000  #NO.FUN-680061 VARCHAR(40)  
    IF g_wc2 IS NULL THEN 
     # CALL cl_err('',-400,0) 
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT * FROM bgs_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i007_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i007_co                         # SCROLL CURSOR
         CURSOR FOR i007_p1
 
    CALL cl_outnam('abgi007') RETURNING l_name
    START REPORT i007_rep TO l_name
 
    FOREACH i007_co INTO l_bgs.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i007_rep(l_bgs.*)
    END FOREACH
 
    FINISH REPORT i007_rep
 
    CLOSE i007_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i007_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
        sr RECORD LIKE bgs_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bgs01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.bgs01,
                  COLUMN g_c[32],sr.bgs02,
                  COLUMN g_c[33],sr.bgs03
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED     #TQC-6A0088  modify
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED     #TQC-6A0088  modify
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-780047--end--
 
#No.FUN-570108--begin                                                           
FUNCTION i007_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680061 VARCHAR(01)
                                                                               
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("bgs01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                               
FUNCTION i007_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680061 VARCHAR(01)
                                                                               
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("bgs01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108--end   
