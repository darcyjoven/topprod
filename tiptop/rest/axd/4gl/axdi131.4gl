# Prog. Version..: '5.10.00-08.01.04(00003)'     #
#
# Pattern name...: axdi131.4gl
# Descriptions...: 料件銷售預測資料維護作業
# Date & Author..: 04/03/10 By Elva
# Modify.........: No:MOD-4A0333 04/10/29 By Carrier 
# Modify.........: No.MOD-4B0067 04/11/15 By Elva 將變數用Like方式定義,報表拉成一行 
# Modify.........: No:FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No:MOD-530665 05/03/26 By Elva 進入單身報錯
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE   
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
#
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No:TQC-720032 07/03/01 By johnray 修正期別檢核方式

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    g_ima           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
     ima01       LIKE ima_file.ima01,  
        ima02       LIKE ima_file.ima02, 
        ima131      LIKE ima_file.ima131,
        ima96       LIKE ima_file.ima96,
        desc        LIKE type_file.chr8,   #No.FUN-680108 VARCHAR(08)
        ima97       LIKE ima_file.ima97
                    END RECORD,
    g_ima_t         RECORD                 #程式變數 (舊值)
     ima01       LIKE ima_file.ima01,  
        ima02       LIKE ima_file.ima02, 
        ima131      LIKE ima_file.ima131,
        ima96       LIKE ima_file.ima96,
        desc        LIKE type_file.chr8,   #No.FUN-680108 VARCHAR(08)
        ima97       LIKE ima_file.ima97
                    END RECORD,
     g_wc2,g_sql     string,  #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數               #No.FUN-680108 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT    #No.FUN-680108 SMALLINT
    p_row,p_col     LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE NOWAIT SQL                    
DEFINE   g_cnt           LIKE type_file.num10                                   #No.FUN-680108 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose   #No.FUN-680108 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5                                 #No.FUN-680108 SMALLINT

MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0091

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
     OPTIONS INSERT KEY F20

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

    LET p_row = 5 LET p_col = 25

    OPEN WINDOW i131_w AT p_row,p_col WITH FORM "axd/42f/axdi131"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL g_x.clear()
    LET g_wc2 = '1=1' CALL i131_b_fill(g_wc2)
    CALL i131_menu()  
    CLOSE WINDOW i131_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

FUNCTION i131_menu()
   WHILE TRUE                                                                   
      CALL i131_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i131_q()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i131_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i131_out()                                                  
            END IF  
 #MOD-4A0333  --begin
         WHEN "patch_generate_1"
            IF cl_chk_act_auth() THEN                                           
               CALL i131_gen("1")                                                  
            END IF 
         WHEN "patch_generate_2"
            IF cl_chk_act_auth() THEN                                           
               CALL i131_gen("2")                                                  
            END IF  
 #MOD-4A0333  --end                                                                                
         WHEN "help"                                                            
            CALL cl_show_help()                                                    
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"                                                        
            CALL cl_cmdask()
      END CASE                                                                  
   END WHILE  
END FUNCTION

FUNCTION i131_q()
   CALL i131_b_askkey()
END FUNCTION

FUNCTION i131_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT#No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用      #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否      #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                      #No.FUN-680108 VARCHAR(01)                                               
    l_allow_delete  LIKE type_file.chr1                       #No.FUN-680108 VARCHAR(01)      

    LET g_action_choice = ""        
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

     LET g_forupd_sql = "SELECT ima01,ima02,ima131,ima96,'',ima97 ",#MOD-530665 By Elva
                       "  FROM ima_file WHERE ima01 = ? FOR UPDATE NOWAIT"

    DECLARE i131_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*
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
        LET p_cmd=' '
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT                                 

        IF g_rec_b >=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_ima_t.* = g_ima[l_ac].*  #BACKUP
           OPEN i131_bcl USING g_ima_t.ima01          #表示更改狀態
           IF STATUS THEN                                                  
              CALL cl_err("OPEN i131_bcl:", STATUS, 1)                     
              LET l_lock_sw = "Y"                                          
           ELSE
              FETCH i131_bcl INTO g_ima[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ima_t.ima01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              CALL i131_desc()
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF

        AFTER FIELD ima96                       # 所有權                        
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_ima[l_ac].ima96) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_apm.apm04
            IF g_azm.azm02 = 1 THEN
               IF g_ima[l_ac].ima96 > 12 OR g_ima[l_ac].ima96 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD ima96
               END IF
            ELSE
               IF g_ima[l_ac].ima96 > 13 OR g_ima[l_ac].ima96 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD ima96
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
            IF NOT cl_null(g_ima[l_ac].ima96) THEN 
               IF g_ima[l_ac].ima96 MATCHES "[123]" THEN 
                  CALL i131_desc()
               END IF 
            END IF

        ON ROW CHANGE                                                           
        DISPLAY "ON ROW CHANGE"
        IF INT_FLAG THEN                 #新增程式段                            
           CALL cl_err('',9001,0)                                               
           LET INT_FLAG = 0                                                     
           LET g_ima[l_ac].* = g_ima_t.*                                        
           CLOSE i131_bcl                                                       
           ROLLBACK WORK                                                        
           EXIT INPUT                                                           
        END IF                                                                  
        IF l_lock_sw="Y" THEN                                                   
           CALL cl_err(g_ima[l_ac].ima01,-263,0)                              
           LET g_ima[l_ac].* = g_ima_t.*                                        
        ELSE             
           UPDATE ima_file 
              SET ima01=g_ima[l_ac].ima01,ima02=g_ima[l_ac].ima02,
                  ima131=g_ima[l_ac].ima131,ima96=g_ima[l_ac].ima96,
                  ima97=g_ima[l_ac].ima97                        
            WHERE ima01 = g_ima_t.ima01
           IF SQLCA.sqlcode THEN                                   
              CALL cl_err(g_ima[l_ac].ima01,SQLCA.sqlcode,0)      
              LET g_ima[l_ac].* = g_ima_t.*                       
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
                 LET g_ima[l_ac].* = g_ima_t.*
              END IF
              CLOSE i131_bcl            # 新增                           
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i131_bcl            # 新增                      
           COMMIT WORK 

        ON ACTION CONTROLN
            CALL i131_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(ima01) AND l_ac > 1 THEN
                LET g_ima[l_ac].* = g_ima[l_ac-1].*
                NEXT FIELD ima01
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

    CLOSE i131_bcl
    COMMIT WORK 
END FUNCTION

FUNCTION i131_b_askkey()
    CLEAR FORM
    CALL g_ima.clear()
 CONSTRUCT g_wc2 ON ima01,ima02,ima131,ima96,ima97
            FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima131,
                 s_ima[1].ima96,s_ima[1].ima97
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
    CALL i131_b_fill(g_wc2)
END FUNCTION

FUNCTION i131_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT ima01,ima02,ima131,",
        " ima96,'',ima97",
        " FROM ima_file",
        " WHERE ", p_wc2 CLIPPED,          #單身
        " ORDER BY ima01"
    PREPARE i131_pb FROM g_sql
    DECLARE ima_curs CURSOR FOR i131_pb
 
    CALL g_ima.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ima_curs INTO g_ima[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    CASE g_ima[g_cnt].ima96
       WHEN  '1' CALL cl_getmsg('axm-024',g_lang) RETURNING g_ima[g_cnt].desc   
       WHEN  '2' CALL cl_getmsg('axm-025',g_lang) RETURNING g_ima[g_cnt].desc 
       WHEN  '3' CALL cl_getmsg('axm-026',g_lang) RETURNING g_ima[g_cnt].desc  
       OTHERWISE  LET g_ima[g_cnt].desc = ''    
    END CASE      
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ima.deleteElement(g_cnt)  
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
END FUNCTION

FUNCTION i131_bp(p_ud)
DEFINE
   p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                      
                                                                                
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
 #MOD-4A0333  --begin         
      ON ACTION patch_generate_1                                                          
         LET g_action_choice="patch_generate_1"                                           
         EXIT DISPLAY
      ON ACTION patch_generate_2                                                          
         LET g_action_choice="patch_generate_2"                                           
         EXIT DISPLAY
 #MOD-4A0333  --end                                                                                   
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

FUNCTION i131_desc()
     CASE g_ima[l_ac].ima96
       WHEN  '1' CALL cl_getmsg('axm-024',g_lang) RETURNING g_ima[l_ac].desc   
       WHEN  '2' CALL cl_getmsg('axm-025',g_lang) RETURNING g_ima[l_ac].desc 
       WHEN  '3' CALL cl_getmsg('axm-026',g_lang) RETURNING g_ima[l_ac].desc  
       OTHERWISE  LET g_ima[l_ac].desc = ''    
     END CASE      
END FUNCTION                               

 #MOD-4A0333  --begin
FUNCTION i131_gen(p_code)
  DEFINE p_code     LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)
         
    CASE p_code
         WHEN '1'   #generate all no matter whether it was setted or not
              UPDATE ima_file  SET ima96 = (SELECT oba08 FROM oba_file 
                     WHERE ima131=oba01),
                                     ima97 = (SELECT oba09 FROM oba_file 
                     WHERE ima131=oba01)
         WHEN '2'   #generate all that hasn't been setted
              UPDATE ima_file  SET ima96 = (SELECT oba08 FROM oba_file 
                     WHERE ima131=oba01),
                                     ima97 = (SELECT oba09 FROM oba_file 
                     WHERE ima131=oba01)
               WHERE ima96 IS NULL 
    END CASE                
    CALL i131_b_fill(" 1=1")
END FUNCTION
 #MOD-4A0333  --end

FUNCTION i131_out()
    DEFINE
        sr              RECORD 
               ima01    LIKE ima_file.ima01,
               ima02    LIKE ima_file.ima02,
               ima021   LIKE ima_file.ima021,
               ima131   LIKE ima_file.ima131,
               ima96    LIKE ima_file.ima96,
               l_desc   LIKE type_file.chr8,   #No.FUN-680108 VARCHAR(08)
               ima97    LIKE ima_file.ima97
                        END RECORD,
        l_i             LIKE type_file.num5,   #No.FUN-680108 SMALLINT
        l_name          LIKE type_file.chr20,  # External(Disk) file name   #No.FUN-680108 VARCHAR(20)
         l_za05         LIKE za_file.za05      #NO.MOD-4B0067
   
#No.TQC-710076 -- begin --
#    IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF cl_null(g_wc2) THEN
      CALL cl_err("","9057",0)
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL cl_wait()
    CALL cl_outnam('axdi131') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ima01,ima02,ima131,ima96,'',ima97 FROM ima_file ",
              " WHERE ",g_wc2 CLIPPED
    PREPARE i131_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i131_co                           # CURSOR
        CURSOR FOR i131_p1

    START REPORT i131_rep TO l_name

    FOREACH i131_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        CASE WHEN sr.ima96 = '1'          
                CALL cl_getmsg('axm-024',g_lang) RETURNING sr.l_desc    
             WHEN sr.ima96 = '2'                                          
                CALL cl_getmsg('axm-025',g_lang) RETURNING sr.l_desc  
             WHEN sr.ima96 = '3'   
                CALL cl_getmsg('axm-026',g_lang) RETURNING sr.l_desc    
             OTHERWISE  LET sr.l_desc = ''                               
        END CASE
        OUTPUT TO REPORT i131_rep(sr.*)
    END FOREACH

    FINISH REPORT i131_rep

    CLOSE i131_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i131_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
        sr              RECORD                                                  
               ima01    LIKE ima_file.ima01,                                    
               ima02    LIKE ima_file.ima02,                                    
               ima021   LIKE ima_file.ima021,
               ima131   LIKE ima_file.ima131,                                   
               ima96    LIKE ima_file.ima96,                                    
               l_desc   LIKE type_file.chr8,   #No.FUN-680108 VARCHAR(08)                                             
               ima97    LIKE ima_file.ima97                                     
                        END RECORD
        
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.ima01

    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     

            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]

            PRINT g_x[31],g_x[32],g_x[33],g_x[34], g_x[35],g_x[36],g_x[37]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'

        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.ima01,
                  COLUMN g_c[32],sr.ima02,
                  COLUMN g_c[33],sr.ima021,
                  COLUMN g_c[34],sr.ima131, 
                  COLUMN g_c[35],sr.ima96  USING "<",
                  COLUMN g_c[36],sr.l_desc,
                  COLUMN g_c[37],sr.ima97 USING '--------'

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
