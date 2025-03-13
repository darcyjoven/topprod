# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apsq501.4gl
# Descriptions...: APS多階材料用量/前置時間查詢
# Date & Author..: 09/04/17  By  sabrina
# Modify.........: #No:FUN-940100 09/04/17 by sabrina 新建立
# Modify.........: No.FUN-B50050 11/05/11 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B80053 11/08/04 By fengrui  程式撰寫規範修正
DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000,  #CHAR(500)
        	wc2  	LIKE type_file.chr1000   #CHAR(500)
        END RECORD,
    g_bma   RECORD
            bma01 LIKE bma_file.bma01,
            ima02 LIKE ima_file.ima02,
            ima021 LIKE ima_file.ima021,
            ima05 LIKE ima_file.ima05,
            ima08 LIKE ima_file.ima08,
            ima55 LIKE ima_file.ima55,
            bmauser LIKE bma_file.bmauser,
            bmagrup LIKE bma_file.bmagrup,
            bmamodu LIKE bma_file.bmamodu,
            bmadate LIKE bma_file.bmadate,
            bmaacti LIKE bma_file.bmaacti,
            bma06 LIKE bma_file.bma06
            END RECORD,
	g_vdate LIKE type_file.dat,           #DATE
	g_rec_b LIKE type_file.num5,          #SMALLINT
    g_bmb DYNAMIC ARRAY OF RECORD
            x_level   LIKE type_file.num5,      #SMALLINT
            bmb02   LIKE bmb_file.bmb02,
            bmb03   LIKE bmb_file.bmb03,
            ima02_b LIKE ima_file.ima02,     
            ima021_b LIKE ima_file.ima021,  
            bmb06   LIKE bmb_file.bmb06,
            bmb10   LIKE bmb_file.bmb10,
            bmb13   LIKE bmb_file.bmb13,
            ima08_b LIKE ima_file.ima08,
            totime  LIKE type_file.num20_6,
            ima50   LIKE ima_file.ima50,
            ima48   LIKE ima_file.ima48, 
            ima49   LIKE ima_file.ima49,    
            ima491  LIKE ima_file.ima491,     
            ima59   LIKE ima_file.ima59,    
            ima61   LIKE ima_file.ima61    
        END RECORD,
    g_argv1         LIKE bma_file.bma01,      # INPUT ARGUMENT - 1
   #g_bma_rowid     LIKE type_file.chr18,     #FUN-550093        #No.FUN-680096 INT # saki 20070821 rowid chr18 -> num10 #FUN-B50050 mark
    g_sql           string                  
DEFINE p_row,p_col     LIKE type_file.num5    #SMALLINT
DEFINE   g_cnt         LIKE type_file.num10   #INTEGER
DEFINE   g_msg         LIKE ze_file.ze03      #CHAR(72)
DEFINE   g_row_count   LIKE type_file.num10   #INTEGER
DEFINE   g_curs_index  LIKE type_file.num10   #INTEGER
DEFINE   g_jump        LIKE type_file.num10   #INTEGER
DEFINE   mi_no_ask     LIKE type_file.num5    #SMALLINT
DEFINE  lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE   g_seq         LIKE type_file.num5  

MAIN
      DEFINE  # l_time LIKE type_file.chr8 
          l_sl	       LIKE type_file.num5    #SMALLINT

   #FUN-B50050---mod---str---
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP                      # 輸入的方式: 不打轉
   DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
   #FUN-B50050---mod---str---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF


      CALL  cl_used(g_prog,g_time,1) RETURNING g_time
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)
    LET g_vdate      = g_today
    LET p_row = 3 LET p_col = 2

    OPEN WINDOW q501_w AT p_row,p_col WITH FORM "aps/42f/apsq501"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()

    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')

    IF NOT cl_null(g_argv1) THEN CALL q501_q() END IF
    CALL q501_menu()
    CLOSE WINDOW q501_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION q501_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5          #SMALLINT


   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "bma01 = '",g_argv1,"'"
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM                       # 清除畫面
   CALL g_bmb.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")   

   INITIALIZE g_bma.* TO NULL   
      CONSTRUCT BY NAME tm.wc ON bma01,bma06,
                                 bmauser,bmamodu,bmaacti,bmagrup,bmadate    
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

      ON ACTION CONTROLP
        CASE 
         WHEN INFIELD(bma01) #主件
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
      	      LET g_qryparam.form = "q_bmb01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
      	      DISPLAY g_qryparam.multiret TO bma01
      	      NEXT FIELD bma01
         OTHERWISE 
              EXIT CASE
         END CASE
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask()   
 
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL cl_set_head_visible("","YES")   

      INPUT BY NAME g_vdate WITHOUT DEFAULTS
         ON ACTION controlg     
            CALL cl_cmdask()   

         ON IDLE g_idle_seconds  
            CALL cl_on_idle()   
            CONTINUE INPUT     

         ON ACTION about         
            CALL cl_about()      

         ON ACTION help          
            CALL cl_show_help()  
      END INPUT                  

      IF INT_FLAG THEN
         RETURN
      END IF
      CALL q501_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   MESSAGE ' SEARCHING '
   IF tm.wc2 = " 1=1" THEN
     #LET g_sql = " SELECT UNIQUE bma01,bma06,rowid FROM bma_file", #FUN-B50050 mark
      LET g_sql = " SELECT UNIQUE bma01,bma06       FROM bma_file", #FUN-B50050 add
                  "  WHERE ",tm.wc CLIPPED
   ELSE
     #LET g_sql = " SELECT UNIQUE bma01,bma06,bma_file.rowid",      #FUN-B50050 mark
      LET g_sql = " SELECT UNIQUE bma01,bma06 ",                    #FUN-B50050 add
                  " FROM bma_file, bmb_file ",
                  " WHERE ",tm.wc CLIPPED, " AND ", tm.wc2 CLIPPED,
                  "   AND bma06 = bmb29",   
                  "   AND bma01 = bmb01"
   END IF
   #資料權限的檢查
   IF g_priv2='4' THEN#只能使用自己的資料
      LET g_sql = g_sql clipped," AND bmauser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN#只能使用相同群的資料
     LET g_sql = g_sql clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN    #群組權限
     LET g_sql = g_sql clipped," AND bmagrup IN ",cl_chk_tgrup_list()
   END IF

   LET g_sql = g_sql clipped," ORDER BY bma01"
   PREPARE q501_prepare FROM g_sql
   DECLARE q501_cs SCROLL CURSOR FOR q501_prepare

   IF tm.wc2 = " 1=1" THEN
      LET g_sql= " SELECT COUNT(*) FROM bma_file WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql = " SELECT COUNT(*) ",
                  " FROM bma_file, bmb_file ",
                  " WHERE ",tm.wc CLIPPED, " AND ", tm.wc2 CLIPPED,
                  "   AND bma06 = bmb29",  
                  "   AND bma01 = bmb01"
   END IF
   #資料權限的檢查
   IF g_priv2='4' THEN#只能使用自己的資料
      LET g_sql = g_sql clipped," AND bmauser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN#只能使用相同群的資料
     LET g_sql = g_sql clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
   END IF

   IF g_priv3 MATCHES "[5678]" THEN    #群組權限
     LET g_sql = g_sql clipped," AND bmagrup IN ",cl_chk_tgrup_list()
   END IF

   PREPARE q501_pp FROM g_sql
   DECLARE q501_cnt CURSOR FOR q501_pp
END FUNCTION


FUNCTION q501_b_askkey()
   CONSTRUCT tm.wc2 ON bmb02,bmb03 FROM s_bmb[1].bmb02,s_bmb[1].bmb03
              BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
END FUNCTION

FUNCTION q501_menu()

   WHILE TRUE
      CALL q501_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q501_q()
         WHEN "jump"
            CALL q501_fetch('/')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "next"
            CALL q501_fetch('N')
         WHEN "previous"
            CALL q501_fetch('P')
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q501_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q501_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q501_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q501_cnt
       FETCH q501_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q501_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION

FUNCTION q501_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1      #處理方式  

    CASE p_flag
        WHEN 'N' FETCH NEXT     q501_cs INTO g_bma.bma01,g_bma.bma06 #FUN-B50050 移除,g_bma_rowid
        WHEN 'P' FETCH PREVIOUS q501_cs INTO g_bma.bma01,g_bma.bma06 #FUN-B50050 移除,g_bma_rowid
        WHEN 'F' FETCH FIRST    q501_cs INTO g_bma.bma01,g_bma.bma06 #FUN-B50050 移除,g_bma_rowid
        WHEN 'L' FETCH LAST     q501_cs INTO g_bma.bma01,g_bma.bma06 #FUN-B50050 移除,g_bma_rowid
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q501_cs INTO g_bma.bma01,g_bma.bma06 #FUN-B50050 移除,g_bma_rowid
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
        INITIALIZE g_bma.* TO NULL  
       #LET g_bma_rowid = NULL      #FUN-B50050 mark
        RETURN
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
    SELECT bma01,'','','','','',
           bmauser,bmagrup,bmamodu,bmadate,bmaacti,bma06
           INTO g_bma.*
      FROM bma_file 
    #FUN-B50050---mod---str---
    #WHERE rowid=g_bma_rowid
     WHERE bma01 = g_bma.bma01
       AND bma06 = g_bma.bma06
    #FUN-B50050---mod---end---
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","bma_file",g_bma.bma01,"",SQLCA.sqlcode,"","",0) 
        RETURN
    END IF
    SELECT ima02,ima021,' ',ima08,ima55
       INTO g_bma.ima02,g_bma.ima021,g_bma.ima05,g_bma.ima08,g_bma.ima55
       FROM ima_file WHERE ima01=g_bma.bma01
    CALL s_effver(g_bma.bma01,g_vdate) RETURNING g_bma.ima05

    CALL q501_show()
END FUNCTION

FUNCTION q501_show()
   DISPLAY BY NAME g_bma.*

   CALL q501_explosion()
   CALL q501_b_fill() #單身
    CALL cl_show_fld_cont()     
END FUNCTION

FUNCTION q501_explosion()
   MESSAGE " BOM Explosing ! "
   DROP TABLE q501_temp
   CREATE TEMP TABLE q501_temp(
              x_level	 LIKE type_file.num5,
              bmb02      LIKE bmb_file.bmb02,
              bmb03      LIKE bmb_file.bmb03,
              bmb06      LIKE bmb_file.bmb06,
              bmb10      LIKE bmb_file.bmb10,
              bmb13      LIKE bmb_file.bmb13,
              bma01      LIKE bma_file.bma01,
              seq        LIKE type_file.num5)   
   LET g_seq = 0                               
   CALL q501_bom(0,g_bma.bma01,1,g_bma.bma06)
   MESSAGE ""
END FUNCTION

FUNCTION q501_bom(p_level,p_key,p_total,p_bma06)
   DEFINE p_level	LIKE type_file.num5,    #SMALLINT
          p_key		LIKE bma_file.bma01,    #主件料件編號
          p_total       LIKE sfa_file.sfa15,   
          p_bma06       LIKE bma_file.bma06,  
          l_ac,i	LIKE type_file.num5,    #SMALLINT
          arrno		LIKE type_file.num5,    #BUFFER SIZE (可存筆數) SMALLINT
          l_chr,l_cnt   LIKE type_file.chr1,    #CHAR(1)
          l_fac         LIKE csa_file.csa0301,  #DEC(13,5)
          l_ima55       LIKE ima_file.ima55,   
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              x_level	LIKE type_file.num5,    #SMALLINT
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bma01 LIKE bma_file.bma01  
          END RECORD,
          l_sql     LIKE type_file.chr1000  #CHAR(1000)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910   

	IF p_level > 20 THEN
           CALL cl_err('','mfg2733',1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--add--  
           EXIT PROGRAM
	END IF
    LET p_level = p_level + 1
    LET arrno = 600	

    LET l_sql= "SELECT 0, bmb02, bmb03, (bmb06/bmb07), bmb10, bmb13, bmb01",
               "  FROM bmb_file",
               " WHERE bmb01='", p_key,"' AND bmb29='",p_bma06,"'",
               "   AND ",tm.wc2 CLIPPED
    IF g_vdate IS NOT NULL THEN
        LET l_sql=l_sql CLIPPED,
                  " AND (bmb04 <='",g_vdate,"' OR bmb04 IS NULL)",
                  " AND (bmb05 > '",g_vdate,"' OR bmb05 IS NULL)"
    END IF
    CASE
      WHEN g_sma.sma65 = '1' LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
      WHEN g_sma.sma65 = '2' LET l_sql=l_sql CLIPPED," ORDER BY bmb03"
      WHEN g_sma.sma65 = '3' LET l_sql=l_sql CLIPPED," ORDER BY bmb13"
      OTHERWISE              LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
    END CASE
    PREPARE q501_precur FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('P1:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--add--
       EXIT PROGRAM
    END IF
    DECLARE q501_cur CURSOR FOR q501_precur
    LET l_ac = 1
    FOREACH q501_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
        LET l_ima910[l_ac]=''
        SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
        IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
        LET l_ac = l_ac + 1
        IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1    	        	# 讀BUFFER傳給REPORT
        LET sr[i].x_level = p_level
        LET sr[i].bmb06=p_total*sr[i].bmb06
        LET g_seq = g_seq + 1                        
        INSERT INTO q501_temp VALUES (sr[i].*,g_seq) 
        IF sr[i].bma01 IS NOT NULL THEN #若為主件
           CALL q501_bom(p_level,sr[i].bmb03,sr[i].bmb06,l_ima910[i])
        END IF
    END FOR
END FUNCTION

FUNCTION q501_b_fill()              #BODY FILL UP
   DEFINE i	LIKE type_file.num5          #SMALLINT
   DEFINE l_ima08  LIKE ima_file.ima08
   DEFINE l_ima50  LIKE ima_file.ima50
   DEFINE l_ima48  LIKE ima_file.ima48
   DEFINE l_ima49  LIKE ima_file.ima49
   DEFINE l_ima491 LIKE ima_file.ima491
   DEFINE l_ima59  LIKE ima_file.ima59
   DEFINE l_ima61  LIKE ima_file.ima61
    DECLARE q501_bcs CURSOR FOR
                SELECT x_level,bmb02,bmb03,ima02,ima021,
                       bmb06,bmb10,bmb13,ima08 
                  FROM q501_temp, OUTER ima_file
                 WHERE bmb03 = ima_file.ima01
                 ORDER BY seq                        
    CALL g_bmb.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q501_bcs INTO g_bmb[g_cnt].*
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
       IF g_bmb[g_cnt].ima08_b MATCHES "[PpVv]" THEN
          SELECT ima50,ima48,ima49,ima491 INTO l_ima50,l_ima48,l_ima49,l_ima491
            FROM ima_file
           WHERE ima01 = g_bmb[g_cnt].bmb03
          LET g_bmb[g_cnt].ima50 = l_ima50
          LET g_bmb[g_cnt].ima48 = l_ima48
          LET g_bmb[g_cnt].ima49 = l_ima49
          LET g_bmb[g_cnt].ima491 = l_ima491
          LET g_bmb[g_cnt].ima59 = ""
          LET g_bmb[g_cnt].ima61 = ""
          LET g_bmb[g_cnt].totime = l_ima50 + l_ima48 + l_ima49 + l_ima491
       ELSE
          SELECT ima59,ima61 INTO l_ima59,l_ima61
            FROM ima_file
           WHERE ima01 = g_bmb[g_cnt].bmb03
          LET g_bmb[g_cnt].ima50 = ""
          LET g_bmb[g_cnt].ima48 = ""
          LET g_bmb[g_cnt].ima49 = ""
          LET g_bmb[g_cnt].ima491 = ""
          LET g_bmb[g_cnt].ima59 = l_ima59
          LET g_bmb[g_cnt].ima61 = l_ima61
          LET g_bmb[g_cnt].totime = l_ima59 + l_ima61
       END IF
       LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_bmb.deleteElement(g_cnt)   
    LET g_rec_b = g_cnt -1
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2
END FUNCTION

FUNCTION q501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #CHAR(1)


   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      CALL cl_show_fld_cont()                  

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DISPLAY        
 
      ON ACTION jump
         CALL q501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY              

      ON ACTION last
         CALL q501_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	ACCEPT DISPLAY             

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
      ON ACTION next
         CALL q501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY               

      ON ACTION previous
         CALL q501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY               

      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 
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

      ON ACTION controls                                                                                           
         CALL cl_set_head_visible("","AUTO") 

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-940100
