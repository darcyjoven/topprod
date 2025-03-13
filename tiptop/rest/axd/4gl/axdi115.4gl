# Prog. Version..: '5.10.00-08.01.04(00004)'     #
#
# Pattern name...: axdi115.4gl
# Descriptions...: 車隊資料維護作業
# Date & Author..: 2003/12/02 By Leagh
 # Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義
# Modify.........: No:FUN-520024 05/02/25 報表轉XML By wujie
 # Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制 
# Modify.........: No.TQC-660099 06/06/21 By Mandy TQC-630166的MARK不要用{}改用#
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
#
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_obz           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
     obz01       LIKE obz_file.obz01,   #車隊代號
        obz02       LIKE obz_file.obz02,   #說明
        obz03       LIKE obz_file.obz03,   #車隊隊長
        obz04       LIKE obz_file.obz04,   #聯系電話一
        obz05       LIKE obz_file.obz05,   #聯系電話二
        obzacti     LIKE obz_file.obzacti  #有效否
                    END RECORD,
    g_obz_t         RECORD              
     obz01       LIKE obz_file.obz01,   #車隊代號
        obz02       LIKE obz_file.obz02,   #說明
        obz03       LIKE obz_file.obz03,   #車隊隊長
        obz04       LIKE obz_file.obz04,   #聯系電話一
        obz05       LIKE obz_file.obz05,   #聯系電話二
        obzacti     LIKE obz_file.obzacti  #有效否
                    END RECORD,
    g_wc2,g_sql     STRING,#TQC-630166 
    g_rec_b         LIKE type_file.num5,   #單身筆數             #No.FUN-680108 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680108 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5                          #No.FUN-680108 SMALLINT 
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE NOWAIT SQL 
DEFINE   g_cnt      LIKE type_file.num10                         #No.FUN-680108 INTEGER                                                   
DEFINE   g_i        LIKE type_file.num5    #count/index for any purpose   #No.FUN-680108 SMALLINT            
DEFINE   g_before_input_done LIKE type_file.num5                 #No.FUN-680108 SMALLINT

MAIN
#     DEFINEl_time LIKE type_file.chr8             #No.FUN-6A0091

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
    LET p_row = 6 LET p_col = 5
    OPEN WINDOW i115_w AT p_row,p_col WITH FORM "axd/42f/axdi115"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL g_x.clear()
    LET g_wc2 = '1=1' CALL i115_b_fill(g_wc2)
    CALL i115_menu() 
    CLOSE WINDOW i115_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

FUNCTION i115_menu()
   WHILE TRUE                                                                   
      CALL i115_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i115_q()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i115_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i115_out()                                                  
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

FUNCTION i115_q()
   CALL i115_b_askkey()
END FUNCTION

FUNCTION i115_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680108 SMALLINT
    l_no            LIKE type_file.num5,   #檢查重複用        #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態          #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #可新增否          #No.FUN-680108 VARCHAR(01)                         
    l_allow_delete  LIKE type_file.chr1    #可刪除否          #No.FUN-680108 VARCHAR(01)

    LET g_action_choice = ""        
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "SELECT obz01,obz02,obz03,obz04,obz05,obzacti ",
                       "  FROM obz_file WHERE obz01=? FOR UPDATE NOWAIT"
    DECLARE i115_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR

    INPUT ARRAY g_obz WITHOUT DEFAULTS FROM s_obz.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,     
                     APPEND ROW = l_allow_insert)                               
                                                                                
    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN                                                
               CALL fgl_set_arr_curr(l_ac)                                      
            END IF          

    BEFORE ROW
        DISPLAY "BEFORE ROW"
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        IF g_rec_b>=l_ac THEN               
           BEGIN WORK
           LET p_cmd='u'
           LET g_obz_t.* = g_obz[l_ac].*  #BACKUP
#No.FUN-570109 --start                                                                                                              
           LET g_before_input_done = FALSE                                                                                          
           CALL i115_set_entry(p_cmd)                                                                                               
           CALL i115_set_no_entry(p_cmd)                                                                                            
           LET g_before_input_done = TRUE                                                                                           
#No.FUN-570109 --end    
           OPEN i115_bcl USING g_obz_t.obz01              #表示更改狀態
           IF STATUS THEN                
              CALL cl_err("OPEN i115_bcl:", STATUS, 1)         
              LET l_lock_sw = "Y"                      
           ELSE 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_obz_t.obz01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH i115_bcl INTO g_obz[l_ac].* 
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
        LET l_n = ARR_COUNT()
        LET p_cmd='a'
#No.FUN-570109 --start                                                                                                              
        LET g_before_input_done = FALSE                                                                                          
        CALL i115_set_entry(p_cmd)                                                                                               
        CALL i115_set_no_entry(p_cmd)                                                                                            
        LET g_before_input_done = TRUE                                                                                           
#No.FUN-570109 --end    
     INITIALIZE g_obz[l_ac].* TO NULL      #900423
        LET g_obz_t.* = g_obz[l_ac].*         #新輸入資料
        LET g_obz[l_ac].obzacti = 'Y'
        CALL cl_show_fld_cont()     #FUN-550037(smin)
        NEXT FIELD obz01

    AFTER INSERT
        DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN                       
              CALL cl_err('',9001,0)                        
              LET INT_FLAG = 0                 
              CANCEL INSERT
           END IF
           INSERT INTO obz_file(obz01,obz02,obz03,obz04,obz05,obzacti)     
           VALUES(g_obz[l_ac].obz01,g_obz[l_ac].obz02,             
                  g_obz[l_ac].obz03,g_obz[l_ac].obz04,             
                  g_obz[l_ac].obz05,g_obz[l_ac].obzacti)           
           IF SQLCA.sqlcode THEN                                   
              CALL cl_err(g_obz[l_ac].obz01,SQLCA.sqlcode,0)      
              CANCEL INSERT
           ELSE                                                    
              MESSAGE 'INSERT O.K'                                
              LET g_rec_b=g_rec_b+1                           
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        AFTER FIELD obz01                        #check 車隊代號是否重複
            IF NOT cl_null(g_obz[l_ac].obz01) THEN
               IF g_obz[l_ac].obz01 != g_obz_t.obz01 OR
                  (g_obz[l_ac].obz01 IS NOT NULL AND g_obz_t.obz01 IS NULL) THEN
                   LET l_no=0
                   SELECT count(*) INTO l_no FROM obz_file
                   WHERE obz01 = g_obz[l_ac].obz01
                   IF l_no > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_obz[l_ac].obz01 = g_obz_t.obz01
                      NEXT FIELD obz01
                   END IF
               END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_obz_t.obz01 IS NOT NULL THEN
               IF NOT cl_delete() THEN                         
                  CANCEL DELETE                               
               END IF                                               
               IF l_lock_sw = "Y" THEN                       
                  CALL cl_err("", -263, 1)                       
                  CANCEL DELETE                     
               END IF  
{ckp#1}        DELETE FROM obz_file WHERE obz01 = g_obz_t.obz01
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_obz_t.obz01,SQLCA.sqlcode,0)
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
              LET g_obz[l_ac].* = g_obz_t.*            
              CLOSE i115_bcl                                      
              ROLLBACK WORK                                 
              EXIT INPUT                           
           END IF                                                                  
           IF l_lock_sw="Y" THEN                                    
              CALL cl_err(g_obz[l_ac].obz01,-263,0)                
              LET g_obz[l_ac].* = g_obz_t.*                 
           ELSE 
              UPDATE obz_file 
                 SET obz01=g_obz[l_ac].obz01,obz02=g_obz[l_ac].obz02,
                     obz03=g_obz[l_ac].obz03,obz04=g_obz[l_ac].obz04,
                     obz05=g_obz[l_ac].obz05,obzacti=g_obz[l_ac].obzacti 
               WHERE CURRENT OF i115_bcl                              
              IF SQLCA.sqlcode THEN                                   
                 CALL cl_err(g_obz[l_ac].obz01,SQLCA.sqlcode,0)      
                 LET g_obz[l_ac].* = g_obz_t.*                       
              ELSE                                                    
                 MESSAGE 'UPDATE O.K'                                
                 COMMIT WORK 
              END IF
           END IF
         
    AFTER ROW
        DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()                                               
            LET l_ac_t = l_ac      

           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_obz[l_ac].* = g_obz_t.*
              END IF
              CLOSE i115_bcl            # 新增                                  
              ROLLBACK WORK         # 新增 
              EXIT INPUT
           END IF
           CLOSE i115_bcl            # 新增                                     
           COMMIT WORK

        ON ACTION CONTROLN
            CALL i115_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                       # 沿用所有欄位
            IF INFIELD(obz01) AND l_ac > 1 THEN
                LET g_obz[l_ac].* = g_obz[l_ac-1].*
                NEXT FIELD obz01
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

    CLOSE i115_bcl
    COMMIT WORK 
END FUNCTION

FUNCTION i115_b_askkey()
    CLEAR FORM
    CALL g_obz.clear() 
 CONSTRUCT g_wc2 ON obz01,obz02,obz03,obz04,obz05,obzacti
            FROM s_obz[1].obz01,s_obz[1].obz02,s_obz[1].obz03,
                 s_obz[1].obz04,s_obz[1].obz05,s_obz[1].obzacti
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
    CALL i115_b_fill(g_wc2)
END FUNCTION

FUNCTION i115_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2          LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT obz01,obz02,obz03,obz04,obz05,obzacti,''",
        " FROM obz_file WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY obz01"
    PREPARE i115_pb FROM g_sql
    DECLARE obz_curs CURSOR FOR i115_pb

    CALL g_obz.clear() 
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH obz_curs INTO g_obz[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_obz.deleteElement(g_cnt)  
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION

FUNCTION i115_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_obz TO s_obz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
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

FUNCTION i115_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680108 SMALLINT
    sr              RECORD
        obz01       LIKE obz_file.obz01,   # 車隊代號
        obz02       LIKE obz_file.obz02,   # 說明
        obz03       LIKE obz_file.obz03,   # 車隊隊長
        obz04       LIKE obz_file.obz04,   # 聯絡電話一
        obz05       LIKE obz_file.obz05,   # 聯絡電話二
        obzacti     LIKE obz_file.obzacti  # 有效否
                    END RECORD,
    l_name          LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-680108 VARCHAR(20)
     l_za05          LIKE za_file.za05      #MOD-4B0067

    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axdi115') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT obz01,obz02,obz03,obz04,obz05,obzacti ",
              " FROM obz_file ",  # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED,
              " ORDER BY obz01 "
    PREPARE i115_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i115_co                         # CURSOR
        CURSOR FOR i115_p1
    START REPORT i115_rep TO l_name
    FOREACH i115_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i115_rep(sr.*)
    END FOREACH
    FINISH REPORT i115_rep
    CLOSE i115_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i115_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
    sr              RECORD
        obz01       LIKE obz_file.obz01,   # 車隊代號
        obz02       LIKE obz_file.obz02,   # 說明
        obz03       LIKE obz_file.obz03,   # 車隊隊長
        obz04       LIKE obz_file.obz04,   # 聯絡電話一
        obz05       LIKE obz_file.obz05,   # 聯絡電話二
        obzacti     LIKE obz_file.obzacti  # 有效否
                    END RECORD 

   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.obz01

    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1                                         
            LET pageno_total = PAGENO USING '<<<',"/pageno"                     
            PRINT g_head CLIPPED,pageno_total 
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]     
            PRINT g_dash1
            LET l_trailer_sw = 'y'

        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.obz01,
                  COLUMN g_c[32],sr.obz02,
                  COLUMN g_c[33],sr.obz03,
                  COLUMN g_c[34],sr.obz04,
                  COLUMN g_c[35],sr.obz05 

        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               PRINT g_dash[1,g_len]

           ##TQC-630166
           #{
        #   IF g_sql[001,080] > ' ' THEN
	   #           PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
           #   IF g_sql[071,140] > ' ' THEN
	   #           PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
           #   IF g_sql[141,210] > ' ' THEN
	   #           PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
           #}
              CALL cl_prt_pos_wc(g_sql)
            #END TQC-630166

            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED

        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT

#No.FUN-570109 --start                                                                                                              
FUNCTION i115_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)                                                                                                           
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("obz01",TRUE)                                                                                           
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i115_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)                                                                                                           
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("obz01",FALSE)                                                                                          
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-570109 --end    
