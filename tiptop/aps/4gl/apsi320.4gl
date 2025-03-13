# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: apsi320.4gl
# Descriptions...: APS 加班資訊明細維護
# Date & Author..: FUN-950108 09/05/27 By DUKE 加班資訊為多筆輸入,並於單身時間判斷是否有重疊 
# Modify.........: FUN-B50004 11/05/06 By Abby GP5.25 追版
DATABASE ds

GLOBALS "../../config/top.global"

#FUN-950108
#模組變數(Module Variables)
DEFINE
    g_vnc01         LIKE vnc_file.vnc01,   #
    g_vnc01_t       LIKE vnc_file.vnc01,   #
    g_vnc02         LIKE vnc_file.vnc02,   #
    g_vnc02_t       LIKE vnc_file.vnc02,   #
    g_vnc03         LIKE vnc_file.vnc03,   #
    g_vnc03_t       LIKE vnc_file.vnc03,   #
    g_vnc06         LIKE vnc_file.vnc06,   #
    g_vnc06_t       LIKE vnc_file.vnc06,   #
    g_vnc07         LIKE vnc_file.vnc07,   #
    g_vnc07_t       LIKE vnc_file.vnc07,   #
    g_vnc08         LIKE vnc_file.vnc08,   #
    g_vnc08_t       LIKE vnc_file.vnc08,   #
    g_vnc09         LIKE vnc_file.vnc09,   #
    g_vnc09_t       LIKE vnc_file.vnc09,   #
    g_vnc10         LIKE vnc_file.vnc10,   #
    g_vnc10_t       LIKE vnc_file.vnc10,   #

    g_vnc03_o       LIKE vnc_file.vnc03,
    g_vnc04_o       LIKE vnc_file.vnc04,
    g_vnc031_o      LIKE vnc_file.vnc031,
    g_vnc041_o      LIKE vnc_file.vnc041,
    g_vnc05_o       LIKE vnc_file.vnc05,

    g_vnc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        vnc031      LIKE vnc_file.vnc031,   
        vnc041      LIKE vnc_file.vnc041, 
        vnc03       LIKE vnc_file.vnc03,   
        vnc04       LIKE vnc_file.vnc04,
        vnc05       LIKE vnc_file.vnc05   
                    END RECORD,
    g_vnc_t         RECORD                 #程式變數 (舊值)
        vnc031      LIKE vnc_file.vnc031,
        vnc041      LIKE vnc_file.vnc041,
        vnc03       LIKE vnc_file.vnc03,
        vnc04       LIKE vnc_file.vnc04,
        vnc05       LIKE vnc_file.vnc05
                    END RECORD,
    g_wc,g_wc2,g_sql    string,            
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數    
    g_rec_b         LIKE type_file.num5,   #單身筆數        
    g_ss            LIKE type_file.chr1,   
    g_argv1         LIKE vnc_file.vnc01,
    g_argv2         LIKE vnc_file.vnc02,
    g_argv3         LIKE vnc_file.vnc03,
    g_argv6         LIKE vnc_file.vnc06,
    g_argv7         LIKE vnc_file.vnc07,
    g_argv8         LIKE vnc_file.vnc08,
    g_argv9         LIKE vnc_file.vnc09,
    g_argv10         LIKE vnc_file.vnc10,
    l_seq           LIKE type_file.num5,
    g_cmd           LIKE type_file.chr1000,      
    g_ls            LIKE type_file.chr1,    
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  
    l_sl            LIKE type_file.num5,   #目前處理的SCREEN LINE  
    l_vzz60         LIKE vzz_file.vzz60
DEFINE p_row,p_col  LIKE type_file.num5    

#主程式開始
DEFINE g_forupd_sql   STRING                 #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt        LIKE type_file.num10   
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose    
DEFINE   g_msg        LIKE ze_file.ze03      
DEFINE   g_row_count  LIKE type_file.num10   
DEFINE   g_curs_index LIKE type_file.num10   
DEFINE   g_jump       LIKE type_file.num10  
DEFINE   mi_no_ask    LIKE type_file.num5    

MAIN
# DEFINE                                        
#       l_time    LIKE type_file.chr8          

    OPTIONS                                #改變一些系統預設值
       #FORM LINE       FIRST + 2,         #畫面開始的位置 #FUN-B50004 mark
       #MESSAGE LINE    LAST,              #訊息顯示的位置 #FUN-B50004 mark
       #PROMPT LINE     LAST,              #提示訊息的位置 #FUN-B50004 mark
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF


      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)   
         RETURNING g_time    
    LET g_vnc01 = NULL                     #清除鍵值
    LET g_vnc01_t = NULL
    LET g_vnc02 = NULL                     #清除鍵值
    LET g_vnc02_t = NULL
    LET g_vnc03 = NULL                     #清除鍵值
    LET g_vnc03_t = NULL
    LET g_vnc06 = NULL                     #清除鍵值
    LET g_vnc06_t = NULL
    LET g_vnc07 = NULL                     #清除鍵值
    LET g_vnc07_t = NULL
    LET g_vnc08 = NULL                     #清除鍵值
    LET g_vnc08_t = NULL
    LET g_vnc09 = NULL                     #清除鍵值
    LET g_vnc09_t = NULL
    LET g_vnc10 = NULL                     #清除鍵值
    LET g_vnc10_t = NULL

	#取得參數
	LET g_argv1 = ARG_VAL(1)	
        LET g_argv2 = ARG_VAL(2)  
        LET g_argv3 = ARG_VAL(3)  
        LET g_argv6 = ARG_VAL(4)
        LET g_argv7 = ARG_VAL(5)
        LET g_argv8 = ARG_VAL(6)
        LET g_argv9 = ARG_VAL(7)
        LET g_argv10 = ARG_VAL(8)


	IF g_argv1=' ' THEN 
           LET g_argv1='' 
           LET g_argv2=''
           LET g_argv3=''
           LET g_argv6=''
           LET g_argv7=''
           LET g_argv8=''
           LET g_argv9=''
           LET g_argv10=''
        ELSE 
           LET g_vnc01 = g_argv1
           LET g_vnc02 = g_argv2 
           LET g_vnc03 = g_argv3
           LET g_vnc06 = g_argv6
           LET g_vnc07 = g_argv7
           LET g_vnc08 = g_argv8
           LET g_vnc09 = g_argv9
           LET g_vnc10 = g_argv10
        END IF
        DISPLAY 'g_vnc01=',g_vnc01
        DISPLAY 'g_vnc02=',g_vnc02
        DISPLAY 'g_vnc03=',g_vnc03
        DISPLAY 'g_vnc06=',g_vnc06
        DISPLAY 'g_vnc07=',g_vnc07
        DISPLAY 'g_vnc08=',g_vnc08
        DISPLAY 'g_vnc09=',g_vnc09
        DISPLAY 'g_vnc10=',g_vnc10

    LET p_row = 2 LET p_col = 2
    OPEN WINDOW i320_w AT p_row,p_col WITH FORM "aps/42f/apsi320"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()

    CALL cl_set_comp_visible("vnc03,vnc04",FALSE)
    CALL cl_set_comp_entry('vnc05',FALSE);


    IF NOT cl_null(g_argv1) THEN CALL i320_q() END IF

    LET g_delete='N'
    CALL i320_menu()
    CLOSE WINDOW i320_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
         RETURNING g_time    
END MAIN

#QBE 查詢資料
FUNCTION i320_cs()
    IF cl_null(g_argv1) THEN
    	CLEAR FORM                             #清除畫面
        CALL g_vnc.clear() 
        CALL cl_set_head_visible("","YES")           
        INITIALIZE g_vnc01 TO NULL    
        INITIALIZE g_vnc02 TO NULL
        INITIALIZE g_vnc03 TO NULL   
        INITIALIZE g_vnc06 TO NULL
        INITIALIZE g_vnc07 TO NULL
        INITIALIZE g_vnc08 TO NULL

    	CONSTRUCT g_wc ON vnc06,vnc07,vnc08,vnc01,vnc02    #螢幕上取條件
        	FROM vnc06,vnc07,vnc08,vnc01,vnc02

              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              AFTER FIELD vnc07
                 LET g_vnc07 = GET_FLDBUF(vnc07)

        ON ACTION controlp
           CASE
              WHEN INFIELD(vnc01)
                   SELECT vzz60 into l_vzz60 FROM vzz_file
                   CALL cl_init_qry_var()
                   IF g_vnc07='0' THEN
                      LET g_qryparam.form      = "q_vmj"
                   ELSE
                      IF g_vnc07='1' THEN
                         LET g_qryparam.form      = "q_vmd"
                      ELSE
                         LET g_qryparam.form      = "q_pmc2"
                      END IF
                   END IF
                   IF g_vnc07 IS NULL THEN
                      CALL cl_err('','aps-706',1)
                      NEXT FIELD vnc07
                   END IF 
                   LET g_qryparam.default1 = g_vnc01
                   #CALL cl_create_qry() RETURNING g_vnc01
                   #DISPLAY BY NAME g_vnc01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO vnc01

                   NEXT FIELD vnc01
           END CASE
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
    	IF INT_FLAG THEN RETURN END IF
      ELSE
      LET g_wc=" vnc01='",g_argv1,"' AND vnc02= '",g_argv2,"' AND vnc06= '",g_argv6,"' AND vnc07= '",g_argv7,"' AND vnc08= '",g_argv8,"' "
    END IF

    LET g_sql="SELECT DISTINCT vnc01,vnc02,vnc06,vnc07,vnc08 FROM vnc_file ",
               " WHERE (vnc03<>vnc04) AND ", g_wc CLIPPED,
               " ORDER BY vnc01,vnc02,vnc06,vnc07,vnc08 "
    PREPARE i320_prepare FROM g_sql      #預備一下
    IF STATUS THEN CALL cl_err('prep:',STATUS,1) END IF
    DECLARE i320_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i320_prepare
    LET g_sql="SELECT DISTINCT vnc01,vnc02,vnc06,vnc07,vnc08 FROM vnc_file WHERE (vnc03<>vnc04) AND ",g_wc CLIPPED
    PREPARE i320_precount FROM g_sql
    DECLARE i320_count CURSOR FOR i320_precount
END FUNCTION


FUNCTION i320_menu()

   WHILE TRUE
      CALL i320_bp("G")
      CASE g_action_choice
         WHEN "query"
               CALL i320_q()
         WHEN "delete"
               CALL i320_r()
         WHEN "detail"
               CALL i320_b()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vnc),'','')
      END CASE
   END WHILE
END FUNCTION


#Query 查詢
FUNCTION i320_q()
  DEFINE l_vnc01  LIKE vnc_file.vnc01,
         l_vnc02  LIKE vnc_file.vnc02,
         l_vnc06  LIKE vnc_file.vnc06,
         l_vnc07  LIKE vnc_file.vnc07,
         l_vnc08  LIKE vnc_file.vnc08,
         l_vnc09  LIKE vnc_file.vnc09,
         l_vnc10  LIKE vnc_file.vnc10,
         l_cnt    LIKE type_file.num10    

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    IF cl_null(g_argv1) THEN
       INITIALIZE g_vnc01 TO NULL        
       INITIALIZE g_vnc02 TO NULL
       INITIALIZE g_vnc06 TO NULL
       INITIALIZE g_vnc07 TO NULL
       INITIALIZE g_vnc08 TO NULL

    END IF

    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i320_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        IF cl_null(g_argv1) THEN
           INITIALIZE g_vnc01 TO NULL
           INITIALIZE g_vnc02 TO NULL
           INITIALIZE g_vnc06 TO NULL
           INITIALIZE g_vnc07 TO NULL
           INITIALIZE g_vnc08 TO NULL
        END IF
        RETURN
    END IF
    OPEN i320_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('open cursor:',SQLCA.sqlcode,0)
        IF cl_null(g_argv1) THEN
           INITIALIZE g_vnc01 TO NULL
           INITIALIZE g_vnc02 TO NULL
           INITIALIZE g_vnc06 TO NULL
           INITIALIZE g_vnc07 TO NULL
           INITIALIZE g_vnc08 TO NULL
        END IF
    ELSE
        FOREACH i320_count INTO l_vnc01,l_vnc02,l_vnc06,l_vnc07,l_vnc08
            LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i320_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i320_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1       #處理方式   

    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i320_bcs INTO g_vnc01,g_vnc02,g_vnc06,g_vnc07,g_vnc08
        WHEN 'P' FETCH PREVIOUS i320_bcs INTO g_vnc01,g_vnc02,g_vnc06,g_vnc07,g_vnc08
        WHEN 'F' FETCH FIRST    i320_bcs INTO g_vnc01,g_vnc02,g_vnc06,g_vnc07,g_vnc08
        WHEN 'L' FETCH LAST     i320_bcs INTO g_vnc01,g_vnc02,g_vnc06,g_vnc07,g_vnc08
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i320_bcs INTO g_vnc01,g_vnc02,g_vnc06,g_vnc07,g_vnc08
    END CASE

    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_vnc01,SQLCA.sqlcode,0)
       IF cl_null(g_argv1) THEN
          INITIALIZE g_vnc01 TO NULL  
          INITIALIZE g_vnc02 TO NULL
          INITIALIZE g_vnc06 TO NULL
          INITIALIZE g_vnc07 TO NULL
          INITIALIZE g_vnc08 TO NULL
       END IF
       #RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i320_show()

END FUNCTION

#將資料顯示在畫面上
FUNCTION i320_show()
    DISPLAY g_vnc01 TO vnc01   #單頭
    DISPLAY g_vnc02 TO vnc02   #單頭
    DISPLAY g_vnc06 TO vnc06   #單頭
    DISPLAY g_vnc07 TO vnc07   #單頭
    DISPLAY g_vnc08 TO vnc08   #單頭
   
    SELECT DISTINCT vnc09,vnc10 INTO g_vnc09,g_vnc10
      FROM vnc_file
     WHERE vnc01 = g_vnc01
       AND vnc02 = g_vnc02
       AND vnc06 = g_vnc06
       AND vnc07 = g_vnc07
       AND vnc08 = g_vnc08

    CALL i320_bf(g_wc)                 #單身
    CALL cl_show_fld_cont()                   
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION i320_r()
  DEFINE l_vnc01  LIKE vnc_file.vnc01,
         l_vnc02  LIKE vnc_file.vnc02,
         l_vnc06  LIKE vnc_file.vnc06,
         l_vnc07  LIKE vnc_file.vnc07,
         l_vnc08  LIKE vnc_file.vnc08

    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnc01 IS NULL OR g_vnc02 IS NULL  OR
       g_vnc06 IS NULL OR g_vnc07 IS NULL  OR
       g_vnc08 IS NULL THEN
       CALL cl_err("",-400,0)                      
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        DELETE FROM vnc_file
         WHERE vnc01=g_vnc01 AND vnc02=g_vnc02 AND vnc06=g_vnc06 AND vnc07=g_vnc07 AND vnc08=g_vnc08
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","vnc_file",g_vnc01,g_vnc02,SQLCA.sqlcode,"","BODY DELETE:",1) 
        ELSE
           INSERT INTO vnc_file
             (vnc01, vnc02, vnc03,vnc04, vnc05, vnc031,vnc041,vnc06,vnc07,vnc08,vnc09,vnc10)
           VALUES(g_vnc01,g_vnc02,0,0,0,'00:00:00','00:00:00',g_vnc06,g_vnc07,g_vnc08,g_vnc09,g_vnc10)

            CLEAR FORM
            CALL g_vnc.clear()
            FOREACH i320_count INTO l_vnc01,l_vnc02,l_vnc06,l_vnc07,l_vnc08
                LET g_row_count = g_row_count + 1
            END FOREACH
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i320_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i320_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i320_fetch('/')
            END IF
            LET g_delete='Y'
            LET g_vnc01 = NULL
            LET g_vnc02 = NULL
            LET g_vnc06 = NULL
            LET g_vnc07 = NULL
            LET g_vnc08 = NULL
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        END IF
    END IF
END FUNCTION


#單身
FUNCTION i320_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   
    l_n             LIKE type_file.num5,     #檢查重複用  
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  
    p_cmd           LIKE type_file.chr1,     #處理狀態    
    l_allow_insert  LIKE type_file.num5,     #可新增否   
    l_allow_delete  LIKE type_file.num5,     #可刪除否   
    l_cnt           LIKE type_file.num5      

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_vnc01 IS NULL OR g_vnc02 IS NULL OR
       g_vnc06 IS NULL OR g_vnc07 IS NULL OR
       g_vnc08 IS NULL THEN  
        RETURN
    END IF

    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT vnc031,vnc041,vnc03,vnc04,vnc05 ",
      " FROM vnc_file ",
      " WHERE vnc01= ? ",
      "   AND vnc02= ? ",
      "   AND vnc03= ? ",
      "   AND vnc06= ? ",
      "   AND vnc07= ? ",
      "   AND vnc08= ? ",
      "   AND (vnc03<>vnc04) ",
      " FOR UPDATE " #FUN-B50004 mod
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50004 add
    DECLARE i320_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0

        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")

        INPUT ARRAY g_vnc
              WITHOUT DEFAULTS
              FROM s_vnc.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_vnc_t.* = g_vnc[l_ac].*  #BACKUP
	        BEGIN WORK

                OPEN i320_bcl USING g_vnc01,g_vnc02,g_vnc[l_ac].vnc03,g_vnc06,g_vnc07,g_vnc08
                IF STATUS THEN
                    CALL cl_err("OPEN i320_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i320_bcl INTO g_vnc[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err("",SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                END IF
                CALL cl_show_fld_cont()     
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO vnc_file
              (vnc01, vnc02, vnc03,
               vnc04, vnc05, vnc031,vnc041,vnc06,vnc07,vnc08,vnc09,vnc10)
            VALUES(g_vnc01,g_vnc02,g_vnc[l_ac].vnc03,
                   g_vnc[l_ac].vnc04,g_vnc[l_ac].vnc05,g_vnc[l_ac].vnc031,
                   g_vnc[l_ac].vnc041,g_vnc06,g_vnc07,g_vnc08,g_vnc09,g_vnc10)

            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","vnc_file",g_vnc01,g_vnc[l_ac].vnc031,SQLCA.sqlcode,"","",1) # TQC-660046
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_vnc[l_ac].* TO NULL      
            LET g_vnc_t.* = g_vnc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD vnc031

        AFTER FIELD vnc041       
           IF  (cl_null(g_vnc[l_ac].vnc041)) OR
               (g_vnc[l_ac].vnc041[3,3]<>':') OR
               (g_vnc[l_ac].vnc041[6,6]<>':') OR
               (cl_null(g_vnc[l_ac].vnc041[8,8])) OR
               (g_vnc[l_ac].vnc041[1,2]<'00' OR g_vnc[l_ac].vnc041[1,2]>'24') OR
               (g_vnc[l_ac].vnc041[4,5]<'00' OR g_vnc[l_ac].vnc041[4,5]>='60') OR
               (g_vnc[l_ac].vnc041[7,8]<'00' OR g_vnc[l_ac].vnc041[7,8]>='60') OR
               (g_vnc[l_ac].vnc041[1,2]='24' AND (g_vnc[l_ac].vnc041[4,5]<>'00' OR g_vnc[l_ac].vnc041[7,8]<>'00')) THEN
               CALL cl_err('','aem-006',0)
               NEXT  FIELD vnc041
           END IF
           LET g_vnc[l_ac].vnc04 = g_vnc[l_ac].vnc041[1,2]*60*60 +
                                   g_vnc[l_ac].vnc041[4,5]*60 +
                                   g_vnc[l_ac].vnc041[7,8]
           #DISPLAY BY NAME g_vnc[l_ac].vnc041   #FUN-950108
           IF not cl_null(g_vnc[l_ac].vnc03) THEN
              IF g_vnc[l_ac].vnc03>g_vnc[l_ac].vnc04 THEN
                 CALL cl_err('','mfg9234',0)
                 NEXT FIELD vnc041
              END IF
           END IF
           LET l_cnt = 0
           IF NOT cl_null(g_vnc_t.vnc03) THEN
              SELECT COUNT(*) INTO l_cnt
                FROM vnc_file
               WHERE vnc01 = g_vnc01
                 AND vnc02 = g_vnc02
                 AND vnc06 = g_vnc06
                 AND vnc07 = g_vnc07
                 AND vnc03<>vnc04
                 AND vnc03<>g_vnc_t.vnc03
                 AND ((vnc03<=g_vnc[l_ac].vnc03 AND vnc04<=g_vnc[l_ac].vnc04 AND vnc04>g_vnc[l_ac].vnc03)
                  OR  (vnc03>=g_vnc[l_ac].vnc03 AND vnc04>=g_vnc[l_ac].vnc04 AND vnc03<g_vnc[l_ac].vnc04)
                  OR  (vnc03>=g_vnc[l_ac].vnc03 AND vnc04<=g_vnc[l_ac].vnc04)
                  OR  (vnc03<=g_vnc[l_ac].vnc03 AND vnc04>=g_vnc[l_ac].vnc04))
           ELSE
              SELECT COUNT(*) INTO l_cnt
                FROM vnc_file
               WHERE vnc01 = g_vnc01
                 AND vnc02 = g_vnc02
                 AND vnc06 = g_vnc06
                 AND vnc07 = g_vnc07
                 AND vnc03<>vnc04
                 AND ((vnc03<=g_vnc[l_ac].vnc03 AND vnc04<=g_vnc[l_ac].vnc04 AND vnc04>g_vnc[l_ac].vnc03)
                  OR  (vnc03>=g_vnc[l_ac].vnc03 AND vnc04>=g_vnc[l_ac].vnc04 AND vnc03<g_vnc[l_ac].vnc04)
                  OR  (vnc03>=g_vnc[l_ac].vnc03 AND vnc04<=g_vnc[l_ac].vnc04)
                  OR  (vnc03<=g_vnc[l_ac].vnc03 AND vnc04>=g_vnc[l_ac].vnc04))
           END IF
           IF l_cnt > 0 THEN
              CALL cl_err('','aps-761',1)
              NEXT FIELD vnc041
           END IF 
           IF (g_vnc_t.vnc04 != g_vnc[l_ac].vnc04) OR
              (g_vnc_t.vnc04 IS NULL)  THEN
              LET g_vnc[l_ac].vnc05 = 0 
           END IF

         AFTER FIELD vnc031
            IF  (cl_null(g_vnc[l_ac].vnc031)) OR
                (g_vnc[l_ac].vnc031[3,3]<>':') OR
                (g_vnc[l_ac].vnc031[6,6]<>':') OR
                (cl_null(g_vnc[l_ac].vnc031[8,8])) OR
                (g_vnc[l_ac].vnc031[1,2]<'00' OR g_vnc[l_ac].vnc031[1,2]>='24') OR
                (g_vnc[l_ac].vnc031[4,5]<'00' OR g_vnc[l_ac].vnc031[4,5]>='60') OR
                (g_vnc[l_ac].vnc031[7,8]<'00' OR g_vnc[l_ac].vnc031[7,8]>='60') THEN
                CALL cl_err('','aem-006',0)
                NEXT  FIELD vnc031
            END IF
            LET g_vnc[l_ac].vnc03 = g_vnc[l_ac].vnc031[1,2]*60*60 +
                                    g_vnc[l_ac].vnc031[4,5]*60 +
                                    g_vnc[l_ac].vnc031[7,8]
            #DISPLAY BY NAME g_vnc[l_ac].vnc031    #FUN-950108 MARK
            IF not cl_null(g_vnc[l_ac].vnc04) THEN
               IF g_vnc[l_ac].vnc03>g_vnc[l_ac].vnc04 THEN
                  CALL cl_err('','mfg9234',0)
                  NEXT FIELD vnc031
               END IF
            END IF
            LET l_cnt = 0
            IF NOT cl_null(g_vnc_t.vnc03) THEN
               SELECT COUNT(*) INTO l_cnt
                 FROM vnc_file
                WHERE vnc01 = g_vnc01
                  AND vnc02 = g_vnc02
                  AND vnc06 = g_vnc06
                  AND vnc07 = g_vnc07
                  AND vnc03<>vnc04
                  AND vnc03<>g_vnc_t.vnc03
                  AND vnc03<=g_vnc[l_ac].vnc03 
                  AND vnc04>g_vnc[l_ac].vnc03
               IF l_cnt=0 THEN 
                  SELECT COUNT(*) INTO l_cnt
                    FROM vnc_file
                   WHERE vnc01 = g_vnc01
                     AND vnc02 = g_vnc02
                     AND vnc06 = g_vnc06
                     AND vnc07 = g_vnc07
                     AND vnc03<>vnc04
                     AND vnc03<>g_vnc_t.vnc03 
                     AND ((vnc03<=g_vnc[l_ac].vnc03 AND vnc04<=g_vnc[l_ac].vnc04 AND vnc04>g_vnc[l_ac].vnc03)
                      OR  (vnc03>=g_vnc[l_ac].vnc03 AND vnc04>=g_vnc[l_ac].vnc04 AND vnc03<g_vnc[l_ac].vnc04)
                      OR  (vnc03>=g_vnc[l_ac].vnc03 AND vnc04<=g_vnc[l_ac].vnc04)
                      OR  (vnc03<=g_vnc[l_ac].vnc03 AND vnc04>=g_vnc[l_ac].vnc04))
               END IF   
            ELSE
               SELECT COUNT(*) INTO l_cnt
                 FROM vnc_file
                WHERE vnc01 = g_vnc01
                  AND vnc02 = g_vnc02
                  AND vnc06 = g_vnc06
                  AND vnc07 = g_vnc07
                  AND vnc03<>vnc04
                  AND vnc03<=g_vnc[l_ac].vnc03
                  AND vnc04>g_vnc[l_ac].vnc03
              IF l_cnt = 0 THEN
                 SELECT COUNT(*) INTO l_cnt
                   FROM vnc_file
                  WHERE vnc01 = g_vnc01
                    AND vnc02 = g_vnc02
                    AND vnc06 = g_vnc06
                    AND vnc07 = g_vnc07
                    AND vnc03<>vnc04
                    AND ((vnc03<=g_vnc[l_ac].vnc03 AND vnc04<=g_vnc[l_ac].vnc04 AND vnc04>g_vnc[l_ac].vnc03)
                     OR  (vnc03>=g_vnc[l_ac].vnc03 AND vnc04>=g_vnc[l_ac].vnc04 AND vnc03<g_vnc[l_ac].vnc04)
                     OR  (vnc03>=g_vnc[l_ac].vnc03 AND vnc04<=g_vnc[l_ac].vnc04)
                     OR  (vnc03<=g_vnc[l_ac].vnc03 AND vnc04>=g_vnc[l_ac].vnc04))
               END IF
            END IF
            IF l_cnt > 0 THEN
              CALL cl_err('','aps-761',1)
              NEXT FIELD vnc031
            END IF
            IF (g_vnc_t.vnc03) != (g_vnc[l_ac].vnc03) OR
               (g_vnc_t.vnc03 IS NULL) THEN
               LET g_vnc[l_ac].vnc05 = 0
            END IF



        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_vnc_t.vnc031) > 0 THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM vnc_file
                    WHERE vnc01 = g_vnc01
                      AND vnc02 = g_vnc02
                      AND vnc06 = g_vnc06
                      AND vnc07 = g_vnc07
                      AND vnc08 = g_vnc08 
                      AND vnc031 = g_vnc_t.vnc031
                
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","vnc_file",g_vnc01,g_vnc02,SQLCA.sqlcode,"","",1)  # TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                LET l_cnt = 0
                SELECT  COUNT(*) INTO l_cnt
                  FROM vnc_file
                 WHERE vnc01 = g_vnc01
                   AND vnc02 = g_vnc02
                   AND vnc06 = g_vnc06
                   AND vnc07 = g_vnc07
                   AND vnc08 = g_vnc08
                IF l_cnt = 0 THEN
                   INSERT INTO vnc_file
                      (vnc01, vnc02, vnc03,vnc04, vnc05, vnc031,vnc041,vnc06,vnc07,vnc08,vnc09,vnc10)
                   VALUES(g_vnc01,g_vnc02,0,0,'0','00:00:00','00:00:00',g_vnc06,g_vnc07,g_vnc08,g_vnc09,g_vnc10)
                END IF
  	        COMMIT WORK
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_vnc[l_ac].* = g_vnc_t.*
               CLOSE i320_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_vnc[l_ac].vnc031,-263,1)
               LET g_vnc[l_ac].* = g_vnc_t.*
            ELSE
                UPDATE vnc_file SET
                             vnc031=g_vnc[l_ac].vnc031,
                             vnc041=g_vnc[l_ac].vnc041,
                             vnc03=g_vnc[l_ac].vnc03,
                             vnc04=g_vnc[l_ac].vnc04,
                             vnc05=g_vnc[l_ac].vnc05
                 WHERE vnc01=g_vnc01
                   AND vnc02=g_vnc02
                   AND vnc06=g_vnc06
                   AND vnc07=g_vnc07
                   AND vnc08=g_vnc08
                   AND vnc031=g_vnc_t.vnc031

                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","vnc_file",g_vnc01,g_vnc02,SQLCA.sqlcode,"","",1) 
                    LET g_vnc[l_ac].* = g_vnc_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
	            COMMIT WORK
                END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_vnc[l_ac].* = g_vnc_t.*
               END IF
               CLOSE i320_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i320_bcl
            COMMIT WORK


        ON ACTION CONTROLR
            CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")       
      
        END INPUT

    CLOSE i320_bcl
	COMMIT WORK
    OPTIONS
        INSERT KEY F1,
        DELETE KEY F2
END FUNCTION
 

FUNCTION i320_bf(p_wc)              #BODY FILL UP
DEFINE p_wc     LIKE type_file.chr1000   
DEFINE i	LIKE type_file.num5      

    LET g_sql =
       "SELECT vnc031,vnc041,vnc03,vnc04,vnc05 ",
       " FROM  vnc_file ",
       " WHERE vnc01 = '",g_vnc01,"'",
       "   AND vnc02 = '",g_vnc02,"'",
       "   AND vnc06 = '",g_vnc06,"'",
       "   AND vnc07 = '",g_vnc07,"'",
       "   AND vnc08 = '",g_vnc08,"'",
       "   AND (vnc03<>vnc04) ",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i320_prepare2 FROM g_sql      #預備一下
    DECLARE vnc_cs CURSOR FOR i320_prepare2
    CALL g_vnc.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH vnc_cs INTO g_vnc[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_vnc.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION


FUNCTION i320_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vnc TO s_vnc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )


      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i320_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 

      ON ACTION previous
         CALL i320_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 

      ON ACTION jump
         CALL i320_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 

      ON ACTION next
         CALL i320_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 

      ON ACTION last
         CALL i320_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
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
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   
         LET g_action_choice="related_document"
         EXIT DISPLAY

      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


#NO:FUN-950108 <> #
