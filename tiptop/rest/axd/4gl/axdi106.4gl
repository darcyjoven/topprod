# Prog. Version..: '5.10.00-08.01.04(00003)'     #
#
# Pattern name...: axdi106.4gl
# Descriptions...: 車輛類型維護作業
# Date & Author..: 03/12/04 By hawk
# Modify.........: No.MOD-4B0067 04/11/08 By Elva 將變數用Like方式定義
# Modify.........: No:FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制 
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
#
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_obq           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
     obq01       LIKE obq_file.obq01,   #部門編號
        obq02       LIKE obq_file.obq02,   #簡稱
         obqacti     LIKE obq_file.obqacti  #MOD-4B0067
                    END RECORD,
    g_obq_t         RECORD                 #程式變數 (舊值)
     obq01       LIKE obq_file.obq01,   #部門編號
        obq02       LIKE obq_file.obq02,   #簡稱
         obqacti     LIKE obq_file.obqacti  #MOD-4B0067
                    END RECORD,
     g_wc2,g_sql    string,  #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數                  #No.FUN-680108 SMALLINT
    l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT        #No.FUN-680108 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE NOWAIT SQL        
DEFINE   g_cnt           LIKE type_file.num10                                      #No.FUN-680108 INTEGER 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose      #No.FUN-680108 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5                                   #No.FUN-680108 SMALLINT

MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0091
DEFINE p_row,p_col   LIKE type_file.num5                                           #No.FUN-680108 SMALLINT
    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN                                                     
       EXIT PROGRAM                                                             
    END IF                                                                      
                                                                                
    WHENEVER ERROR CALL cl_err_msg_log 

    IF (NOT cl_setup("AXD")) THEN                                               
       EXIT PROGRAM                                                             
    END IF

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
    LET p_row = 6 LET p_col = 33
    OPEN WINDOW i106_w AT p_row,p_col WITH FORM "axd/42f/axdi106"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init() 
    CALL g_x.clear()
    LET g_wc2 = '1=1' CALL i106_b_fill(g_wc2)

    CALL i106_menu()  
    CLOSE WINDOW i106_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

FUNCTION i106_menu()
   WHILE TRUE                                                                   
      CALL i106_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i106_q()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i106_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i106_out()                                                  
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

FUNCTION i106_q()
   CALL i106_b_askkey()
END FUNCTION

FUNCTION i106_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #可新增否          #No.FUN-680108 VARCHAR(01)                       
    l_allow_delete  LIKE type_file.chr1    #可刪除否          #No.FUN-680108 VARCHAR(01)

    LET g_action_choice = ""      
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT obq01,obq02,obqacti FROM obq_file ",
                       " WHERE obq01=? FOR UPDATE NOWAIT "
    DECLARE i106_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')  

    INPUT ARRAY g_obq WITHOUT DEFAULTS FROM s_obq.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,            
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)    


    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN                                                
               CALL fgl_set_arr_curr(l_ac)                                      
            END IF    


    BEFORE ROW
        DISPLAY "BEFORE ROW"
        LET p_cmd=' '
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        IF g_rec_b >= l_ac THEN 
           BEGIN WORK
           LET p_cmd = 'u'
           LET g_obq_t.* = g_obq[l_ac].*  #BACKUP
#No.FUN-570109 --start                                                                                                              
           LET g_before_input_done = FALSE                                                                                          
           CALL i106_set_entry(p_cmd)                                                                                               
           CALL i106_set_no_entry(p_cmd)                                                                                            
           LET g_before_input_done = TRUE                                                                                           
#No.FUN-570109 --end     
           OPEN i106_bcl USING g_obq_t.obq01              #表示更改狀態
           IF STATUS THEN                
              CALL cl_err("OPEN i106_bcl:", STATUS, 1)         
              LET l_lock_sw = "Y"                      
           ELSE 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_obq_t.obq01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH i106_bcl INTO g_obq[l_ac].* 
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
#No.FUN-570109 --start                                                                                                              
           LET g_before_input_done = FALSE                                                                                          
           CALL i106_set_entry(p_cmd)                                                                                               
           CALL i106_set_no_entry(p_cmd)                                                                                            
           LET g_before_input_done = TRUE                                                                                           
#No.FUN-570109 --end     
        INITIALIZE g_obq[l_ac].* TO NULL      #900423
           LET g_obq[l_ac].obqacti = 'Y'       #Body default
           LET g_obq_t.* = g_obq[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD obq01

    AFTER INSERT
        DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN                       
              CALL cl_err('',9001,0)                        
              LET INT_FLAG = 0                 
              CANCEL INSERT
           END IF
           INSERT INTO obq_file(obq01,obq02,obqacti,obquser,obqdate) 
           VALUES(g_obq[l_ac].obq01,g_obq[l_ac].obq02, 
                  g_obq[l_ac].obqacti,g_user,g_today)  
           IF SQLCA.sqlcode THEN                                     
              CALL cl_err(g_obq[l_ac].obq01,SQLCA.sqlcode,0)         
              CANCEL INSERT
           ELSE                                                      
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
           END IF

    AFTER FIELD obq01                        #check 編號是否重複
         IF g_obq[l_ac].obq01 IS NOT NULL THEN
           IF g_obq[l_ac].obq01 != g_obq_t.obq01 OR
              (g_obq[l_ac].obq01 IS NOT NULL AND g_obq_t.obq01 IS NULL) THEN
               SELECT COUNT(*) INTO l_n FROM obq_file
                   WHERE obq01 = g_obq[l_ac].obq01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_obq[l_ac].obq01 = g_obq_t.obq01
                  NEXT FIELD obq01
               END IF
           END IF
         END IF

        BEFORE DELETE                            #是否取消單身
            IF g_obq_t.obq01 IS NOT NULL THEN
               IF NOT cl_delete() THEN                         
                  CANCEL DELETE                               
               END IF                                               
               IF l_lock_sw = "Y" THEN                       
                  CALL cl_err("", -263, 1)                       
                  CANCEL DELETE                     
               END IF  
{ckp#1}        DELETE FROM obq_file WHERE obq01 = g_obq_t.obq01
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_obq_t.obq01,SQLCA.sqlcode,0)
                   EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
           IF INT_FLAG THEN                 #新增程式段                   
              CALL cl_err('',9001,0)                              
              LET INT_FLAG = 0                              
              LET g_obq[l_ac].* = g_obq_t.*            
              CLOSE i106_bcl                                      
              ROLLBACK WORK                                 
              EXIT INPUT                           
           END IF                                                                  
           IF l_lock_sw="Y" THEN                                    
              CALL cl_err(g_obq[l_ac].obq01,-263,0)                
              LET g_obq[l_ac].* = g_obq_t.*                 
           ELSE 
              UPDATE obq_file 
                 SET obq01=g_obq[l_ac].obq01,obq02=g_obq[l_ac].obq02,
                     obqacti=g_obq[l_ac].obqacti,obqmodu=g_user,
                     obqdate=g_today
               WHERE obq01 = g_obq_t.obq01 
#               WHERE CURRENT OF i106_bcl
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_obq[l_ac].obq01,SQLCA.sqlcode,0)
                 LET g_obq[l_ac].* = g_obq_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK 
              END IF
           END IF
               
    AFTER ROW
        DISPLAY "AFTER ROW"
           LET l_ac = ARR_CURR()         # 新增                
           LET l_ac_t = l_ac

           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_obq[l_ac].* = g_obq_t.*
              END IF
              CLOSE i106_bcl            # 新增                 
              ROLLBACK WORK         # 新增                    
              EXIT INPUT
           END IF
           CLOSE i106_bcl            # 新增                 
           COMMIT WORK

        ON ACTION CONTROLN
            CALL i106_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(obq01) AND l_ac > 1 THEN
                LET g_obq[l_ac].* = g_obq[l_ac-1].*
                NEXT FIELD obq01
            END IF

        ON ACTION CONTROLZ
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

    CLOSE i106_bcl
    COMMIT WORK 
END FUNCTION

FUNCTION i106_b_askkey()
    CLEAR FORM
    CALL g_obq.clear()
 CONSTRUCT g_wc2 ON obq01,obq02,obqacti
                  FROM s_obq[1].obq01,s_obq[1].obq02,s_obq[1].obqacti
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
    CALL i106_b_fill(g_wc2)
END FUNCTION

FUNCTION i106_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

LET g_sql = "SELECT obq01,obq02,obqacti,''",                                
                "  FROM obq_file",                                              
                " WHERE ", p_wc2 CLIPPED,                     #單身             
                " ORDER BY obq01"
    PREPARE i106_pb FROM g_sql
    DECLARE obq_curs CURSOR FOR i106_pb

    CALL g_obq.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH obq_curs INTO g_obq[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_obq.deleteElement(g_cnt)      
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION

FUNCTION i106_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_obq TO s_obq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
      BEFORE ROW                                                                
         LET l_ac = ARR_CURR()  
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
                                                                                
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
 

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---


   END DISPLAY                                                                  
   CALL cl_set_act_visible("accept,cancel", TRUE)   

END FUNCTION

FUNCTION i106_out()
    DEFINE
        sr              RECORD LIKE obq_file.*,
        l_i             LIKE type_file.num5,                                #No.FUN-680108 SMALLINT
        l_name          LIKE type_file.chr20,    # External(Disk) file name #No.FUN-680108 VARCHAR(20)
        l_za05          LIKE za_file.za05        # MOD-4B0067
      
    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM obq_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i106_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i106_co                         # SCROLL CURSOR
         CURSOR FOR i106_p1
      
    CALL cl_outnam('axdi106') RETURNING l_name
    START REPORT i106_rep TO l_name
      
    FOREACH i106_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        OUTPUT TO REPORT i106_rep(sr.*)
    END FOREACH
      
    FINISH REPORT i106_rep
      
    CLOSE i106_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i106_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,            #No.FUN-680108 VARCHAR(1)
        sr RECORD LIKE obq_file.*

   OUTPUT
       TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
    ORDER BY sr.obq01
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     

            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]

            PRINT g_x[31],g_x[32],g_x[33]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'

        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.obq01,
                  COLUMN g_c[32],sr.obq02,
                  COLUMN g_c[33],sr.obqacti

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

#No.FUN-570109 --start                                                                                                              
FUNCTION i106_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680108 VARCHAR(01)
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("obq01",TRUE)                                                                                           
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i106_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1             #No.FUN-680108 VARCHAR(01)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("obq01",FALSE)                                                                                          
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-570109 --end       
