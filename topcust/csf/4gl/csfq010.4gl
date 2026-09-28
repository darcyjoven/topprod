# Prog. Version..: '5.20.01-10.05.01(00000)'     
#
# Pattern name...: 
# Descriptions...: 
# Date & Author..: 


DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE
    tm  RECORD
               wc      LIKE type_file.chr1000,         # Head Where condition  #No.FUN-680137 VARCHAR(500)                                      
               wc2     LIKE type_file.chr1000,         # Body Where condition  #No.FUN-680137 VARCHAR(500)
               wc3     LIKE type_file.chr1000
            END RECORD,
    g_tc_sfa   RECORD
			tc_sfa02	LIKE tc_sfa_file.tc_sfa02,
			tc_sfbud05	LIKE tc_sfb_file.tc_sfbud05,
			tc_sfb06 	LIKE tc_sfb_file.tc_sfb06    #No.FUN-680137 VARCHAR(24)
        END RECORD,
    g_tc_sfb DYNAMIC ARRAY OF RECORD
            tc_sfa02_1   LIKE tc_sfa_file.tc_sfa02,
            tc_sfa01     LIKE tc_sfa_file.tc_sfa01,
            tc_sfbud05_1 LIKE tc_sfb_file.tc_sfbud05,
            tc_sfbud06_1 LIKE tc_sfb_file.tc_sfbud06,
            tc_sfb06_1   LIKE tc_sfb_file.tc_sfb06,
            eca02_1      LIKE eca_file.eca02,
            tc_sfb03     LIKE tc_sfb_file.tc_sfb03,
            tc_sfbud04   LIKE tc_sfb_file.tc_sfbud04,
            tc_sfb04     LIKE tc_sfb_file.tc_sfb04,
            tc_sfbud02   LIKE tc_sfb_file.tc_sfbud02,
            ima02        LIKE ima_file.ima02,
            ima021       LIKE ima_file.ima021,
            tc_sfb08     LIKE tc_sfb_file.tc_sfb08
          END RECORD,
     g_tc_sfb_1 DYNAMIC ARRAY OF RECORD       
            tc_sfa02_2   LIKE tc_sfa_file.tc_sfa02,
            tc_sfa01_1   LIKE tc_sfa_file.tc_sfa01,
            tc_sfbud05_2 LIKE tc_sfb_file.tc_sfbud05,
            tc_sfbud06_2 LIKE tc_sfb_file.tc_sfbud06,
            tc_sfb06_2   LIKE tc_sfb_file.tc_sfb06,
            eca02_2      LIKE eca_file.eca02,
            tc_sfbud02_1 LIKE tc_sfb_file.tc_sfbud02,
            ima02_1      LIKE ima_file.ima02,
            ima021_1     LIKE ima_file.ima021,
            tc_sfb08_1   LIKE tc_sfb_file.tc_sfb08
            
        END RECORD,
   	g_occ261		LIKE occ_file.occ261,
	g_occ29			LIKE occ_file.occ29,
    g_argv1         LIKE occ_file.occ01,
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
    g_sql          STRING, #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b LIKE type_file.num10    #單身筆數  
 
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000,    #No.FUN-680137 VARCHAR(72)
         l_ac            LIKE type_file.num5        #No.FUN-680137 SMALLINT
DEFINE   l_ac1           LIKE type_file.num5
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680137 SMALLINT

DEFINE w        ui.Window
DEFINE f        ui.Form
DEFINE page     om.DomNode
DEFINE g_action_flag LIKE type_file.chr1000
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0094
DEFINE	  l_sl          LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag =1
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q010_w AT p_row,p_col
        WITH FORM "csf/42f/csfq010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

IF NOT cl_null(g_argv1) THEN CALL q010_q() END IF
    CALL q010_q() 
    LET g_action_flag = 'page3'  
    CALL q010_menu()
    CLOSE WINDOW q010_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q010_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
   CALL g_tc_sfb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tc_sfa.* TO NULL    
           CONSTRUCT BY NAME tm.wc ON tc_sfa02,tc_sfbud05,tc_sfb06
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
         WHEN INFIELD(tc_sfbud05)
            CALL cl_init_qry_var()
            LET g_qryparam.state = 'c'
            LET g_qryparam.form ="q_tc_sfbud05"
            CALL cl_create_qry() RETURNING g_tc_sfa.tc_sfbud05
            DISPLAY g_tc_sfa.tc_sfbud05 TO tc_sfbud05
            CALL q010_tc_sfbud05()  
        NEXT FIELD tc_sfbud05

          WHEN INFIELD(tc_sfb06)
            CALL cl_init_qry_var()
            LET g_qryparam.state = 'c'
            LET g_qryparam.form ="q_tc_sfb06"
            CALL cl_create_qry() RETURNING g_tc_sfa.tc_sfb06
            DISPLAY g_tc_sfa.tc_sfb06 TO tc_sfb06
            CALL q010_tc_sfb06()  
        NEXT FIELD tc_sfb06

                        
         END CASE
#No.FUN-930009 --End
 
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
           CALL q010_b_askkey()
           CALL q010_b_askkey2()
           IF INT_FLAG THEN RETURN END IF

         #資料權限的檢查
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('tc_sfauser', 'tc_sfagrup')
    #End:FUN-980030
    LET g_sql="SELECT tc_sfa02 FROM tc_sfa_file,tc_sfb_file ", # 組合出 SQL 指令
        " WHERE ",tm.wc CLIPPED, " and tc_sfa01 = tc_sfb01 ORDER BY tc_sfa02"
    PREPARE q010_prepare FROM g_sql
    DECLARE q010_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q010_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM tc_sfa_file,tc_sfb_file WHERE tc_sfa01=tc_sfb01 and ",tm.wc CLIPPED
    PREPARE q010_precount FROM g_sql
    DECLARE q010_count CURSOR FOR q010_precount
END FUNCTION
 
FUNCTION q010_b_askkey()
    CLEAR FORM 
   CONSTRUCT tm.wc2 ON tc_sfa02,tc_sfa01,tc_sfbud05,tc_sfbud06,tc_sfb06,eca02,tc_sfb03,tc_sfbud04,
                       tc_sfb04,tc_sfbud02,ima02,ima021,tc_sfb08
                  FROM s_tc_sfb[1].tc_sfa02_1,s_tc_sfb[1].tc_sfa01,s_tc_sfb[1].tc_sfbud05_1,
                       s_tc_sfb[1].tc_sfbud06_1,s_tc_sfb[1].tc_sfb06_1,s_tc_sfb[1].eca02_1,
					   s_tc_sfb[1].tc_sfb03,s_tc_sfb[1].tc_sfbud04,s_tc_sfb[1].tc_sfb04,
                       s_tc_sfb[1].tc_sfbud02,s_tc_sfb[1].ima02,s_tc_sfb[1].ima021,
                       s_tc_sfb[1].tc_sfb08

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_sfa01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfa01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfa01
               NEXT FIELD tc_sfa01
            WHEN INFIELD(tc_sfbud05_1)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfbud05"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfbud05_1
               NEXT FIELD tc_sfbud05_1
            WHEN INFIELD(tc_sfb06_1)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfb06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfb06_1
               NEXT FIELD tc_sfb06_1
             WHEN INFIELD(tc_sfb03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfb03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfb03
               NEXT FIELD tc_sfb03
             WHEN INFIELD(tc_sfbud04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfbud04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfbud04
               NEXT FIELD tc_sfbud04
             WHEN INFIELD(tc_sfbud02)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfbud02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfbud02
               NEXT FIELD tc_sfbud02

         END CASE
#No.FUN-930009 --End
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION


FUNCTION q010_b_askkey2()
   CLEAR FORM 
   CONSTRUCT tm.wc3 ON tc_sfa02,tc_sfa01,tc_sfbud05,ecu03,tc_sfb06,eca02,tc_sfbud02,ima02,ima021,tc_sfb08
                  FROM s_tc_sfb_1[1].tc_sfa02_2,s_tc_sfb_1[1].tc_sfa01_1,s_tc_sfb_1[1].tc_sfbud05_2,
                       s_tc_sfb_1[1].tc_sfbud06_2,s_tc_sfb_1[1].tc_sfb06_2,s_tc_sfb_1[1].eca02_2,
					   s_tc_sfb_1[1].tc_sfbud02_1, s_tc_sfb_1[1].ima02_1,s_tc_sfb_1[1].ima021_1,
                       s_tc_sfb_1[1].tc_sfb08_1
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tc_sfa01_1)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfa01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfa01_1
               NEXT FIELD tc_sfa01_1
            WHEN INFIELD(tc_sfbud05_2)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfbud05"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfbud05_2
               NEXT FIELD tc_sfbud05_2
            WHEN INFIELD(tc_sfb06_2)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfb06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfb06_2
               NEXT FIELD tc_sfb06_2
             WHEN INFIELD(tc_sfb03_1)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfb03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfb03_1
               NEXT FIELD tc_sfb03_1
             WHEN INFIELD(tc_sfbud04_1)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfbud04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfbud04_1
               NEXT FIELD tc_sfbud04_1
             WHEN INFIELD(tc_sfbud02_1)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_tc_sfbud02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tc_sfbud02_1
               NEXT FIELD tc_sfbud02_1
         END CASE
#No.FUN-930009 --End
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
END FUNCTION

FUNCTION q010_menu()
   LET g_action_flag ="page3"
   WHILE TRUE
    IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page3" THEN  
            CALL q010_bp("G")
         END IF
         IF g_action_flag = "page4" THEN  
            CALL q010_bp2()
         END IF
      END IF 
      CASE g_action_choice
         WHEN "page3"
            CALL q010_bp("G")
         
         WHEN "page4"
            CALL q010_bp2()
      --CALL q010_bp2()
      --CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q010_q()
            END IF
        LET g_action_choice = " " 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         --WHEN "exporttoexcel"     #FUN-4B0038
            --IF cl_chk_act_auth() THEN
              --CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_sfb),'','')
            --END IF
         WHEN "exporttoexcel"
             LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page3" THEN  
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page3")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_sfb),'','') 
                END IF
             END IF 
             IF g_action_flag = "page4" THEN 
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page4")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_sfb_1),'','') 
                END IF
             END IF 
             LET g_action_choice = " "  

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q010_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q010_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q010_cs                            # 從DB產生合乎條件TEP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE

      OPEN q010_count
      FETCH q010_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      LET g_row_count  = 1
      CALL q010_fetch('F')  
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q010_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 DEFINE   row1            LIKE type_file.num5
    CASE p_flag
        WHEN 'N' FETCH NEXT     q010_cs INTO g_tc_sfa.tc_sfa02
        WHEN 'P' FETCH PREVIOUS q010_cs INTO g_tc_sfa.tc_sfa02
        WHEN 'F' FETCH FIRST    q010_cs INTO g_tc_sfa.tc_sfa02
        WHEN 'L' FETCH LAST     q010_cs INTO g_tc_sfa.tc_sfa02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q010_cs INTO g_tc_sfa.tc_sfa02
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfa.tc_sfa02,SQLCA.sqlcode,0)
        INITIALIZE g_tc_sfa.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
                   LET g_tc_sfa.tc_sfbud05 = ''
                   DISPLAY '' TO ecu03
                   LET g_tc_sfa.tc_sfb06 = '' 
                   DISPLAY '' TO eca02
          WHEN 'N' LET g_curs_index = g_curs_index + 1
                   LET g_tc_sfa.tc_sfbud05 = ''
                   DISPLAY '' TO ecu03
                   LET g_tc_sfa.tc_sfb06 = '' 
                   DISPLAY '' TO eca02
          WHEN 'L' LET g_curs_index = g_row_count
                   LET g_tc_sfa.tc_sfbud05 = ''
                   DISPLAY '' TO ecu03
                   LET g_tc_sfa.tc_sfb06 = '' 
                   DISPLAY '' TO eca02
          WHEN '/' LET g_curs_index = g_jump
                   LET g_tc_sfa.tc_sfbud05 = ''
                   DISPLAY '' TO ecu03
                   LET g_tc_sfa.tc_sfb06 = '' 
                   DISPLAY '' TO eca02
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    
    END IF
   
 
    CALL q010_show()
END FUNCTION
 
FUNCTION q010_show()

   DISPLAY BY NAME g_tc_sfa.*
   CALL q010_tc_sfbud05() 
   CALL q010_tc_sfb06() 
   CALL q010_b_fill() #單身
   CALL q010_b_fill_1()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q010_b_fill()              #BODY FILL UP
  DEFINE l_sql     LIKE type_file.chr1000,        #No.FUN-680137  VARCHAR(1000)
         l_oma54t  LIKE oma_file.oma54t,
         l_oma55   LIKE oma_file.oma55
 
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   LET l_sql =
        "SELECT tc_sfa02,tc_sfa01,tc_sfbud05,tc_sfbud06,tc_sfb06,'',tc_sfb03,tc_sfbud04,
                tc_sfb04,tc_sfbud02,ima02,ima021,tc_sfb08 ",
        "  FROM tc_sfa_file,tc_sfb_file ",
    #    "  left join ecu_file on ecu02 = tc_sfbud05 ",
    #    "  left join eca_file on eca01 = tc_sfb06",
        "  left join ima_file on ima01 = tc_sfbud02",
        " WHERE ",
        "   tc_sfa01 = tc_sfb01 ",#bug no:6480
        "   AND ",tm.wc2 CLIPPED," AND ",tm.wc CLIPPED,
        " ORDER BY tc_sfa02 "
    PREPARE q010_pb FROM l_sql
    DECLARE q010_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q010_pb
    CALL g_tc_sfb.clear()
    LET g_cnt = 1
    FOREACH q010_bcs INTO g_tc_sfb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    --SELECT ecu03 INTO g_tc_sfb[g_cnt].ecu03_1 FROM ecu_file,sfb_file 
    --WHERE ecu02=tc_sfbud05 AND ecu01=g_tc_sfb[g_cnt].tc_sfbud02 AND ecu02=g_tc_sfb[g_cnt].tc_sfbud05_1
    SELECT eca02 INTO g_tc_sfb[g_cnt].eca02_1 FROM eca_file
    WHERE eca01 = g_tc_sfb[g_cnt].tc_sfb06_1 
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_tc_sfb.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b=g_cnt-1
    #CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q010_b_fill_1()              #BODY FILL UP
  DEFINE l_sql1     LIKE type_file.chr1000,        #No.FUN-680137  VARCHAR(1000)
         l_sql2     LIKE type_file.chr1000, 
         l_oma54t  LIKE oma_file.oma54t,
         l_oma55   LIKE oma_file.oma55
        
   IF cl_null(tm.wc3) THEN LET tm.wc3="1=1" END IF
   LET l_sql1 =
        "SELECT '',tc_sfa01,tc_sfbud05,'','','',tc_sfbud02,'','',sum(tc_sfb08) ",
        "  FROM tc_sfa_file,tc_sfb_file ",
        " WHERE ",
        "   tc_sfa01 = tc_sfb01 ",#bug no:6480
        " AND ",tm.wc3 CLIPPED," AND ",tm.wc CLIPPED,
        " group by tc_sfa01,tc_sfbud05,tc_sfbud02"
 
    PREPARE q010_pb1 FROM l_sql1
    DECLARE q010_bcs1                       #BODY CURSOR
        CURSOR WITH HOLD FOR q010_pb1
    CALL g_tc_sfb_1.clear()
    LET g_cnt = 1
    FOREACH q010_bcs1 INTO g_tc_sfb_1[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    SELECT tc_sfa02 INTO g_tc_sfb_1[g_cnt].tc_sfa02_2 FROM tc_sfa_file WHERE tc_sfa01 =  g_tc_sfb_1[g_cnt].tc_sfa01_1
    SELECT tc_sfb06 INTO g_tc_sfb_1[g_cnt].tc_sfb06_2 FROM tc_sfb_file WHERE tc_sfbud05 = g_tc_sfb_1[g_cnt].tc_sfbud05_2
    SELECT tc_sfbud06 INTO g_tc_sfb_1[g_cnt].tc_sfbud06_2 FROM tc_sfb_file 
    WHERE  tc_sfbud05=g_tc_sfb_1[g_cnt].tc_sfbud05_2
    SELECT eca02 INTO g_tc_sfb_1[g_cnt].eca02_2 FROM eca_file,tc_sfb_file
    WHERE eca01 = g_tc_sfb_1[g_cnt].tc_sfb06_2 
    SELECT ima02,ima021 INTO g_tc_sfb_1[g_cnt].ima02_1,g_tc_sfb_1[g_cnt].ima021_1   FROM ima_file WHERE ima01 = g_tc_sfb_1[g_cnt].tc_sfbud02_1
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH

    CALL g_tc_sfb.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b=g_cnt-1
    #CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_flag = 'page3'
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_sfb TO s_tc_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 #  DISPLAY ARRAY g_tc_sfb_1 TO s_tc_sfb_1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 

      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q010_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q010_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q010_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q010_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q010_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

       ON ACTION page3
          LET g_action_choice="page3"
          EXIT DISPLAY
          
	   ON ACTION page4
          LET g_action_choice="page4"
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
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   ON ACTION exporttoexcel       #FUN-4B0038
      LET g_action_choice = 'exporttoexcel'
      EXIT DISPLAY
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q010_bp2()
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)

   LET g_action_flag = 'page4'
   --LET g_action_choice = " "
   --IF g_action_choice = "page1"  AND NOT cl_null(tm.a) AND g_flag != '1' THEN
      --CALL q001_b_fill()
   --END IF
   CALL cl_set_act_visible("accept,cancel", FALSE)
 #  DISPLAY ARRAY g_tc_sfb TO s_tc_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
  DISPLAY ARRAY g_tc_sfb_1 TO s_tc_sfb_1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#huanglf160719--------------------------------------------------------------
   --BEFORE ROW 
      --LET l_ac = ARR_CURR()
            --CALL cl_show_fld_cont() 
#huanglf160719--------------------------------------------------------------  
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 

      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q010_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q010_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q010_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q010_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q010_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

        ON ACTION page3
          LET g_action_choice="page3"
          EXIT DISPLAY
          
	   ON ACTION page4
          LET g_action_choice="page4"
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
 
   ON ACTION ACCEPT
   #huanglf160719--------------------------------------------------------
       LET l_ac1 = ARR_CURR()
         IF NOT cl_null(g_action_choice) AND l_ac1 > 0  THEN
            CALL q010_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page4", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page4", TRUE)
            LET g_action_choice = "page3"
          #  EXIT DIALOG 
          EXIT DISPLAY
         END IF
     
   #huanglf160719---------------------------------------------------------- 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   ON ACTION exporttoexcel       #FUN-4B0038
      LET g_action_choice = 'exporttoexcel'
      EXIT DISPLAY
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q010_tc_sfbud05()  
   DEFINE l_tc_sfbud06    LIKE tc_sfb_file.tc_sfbud06 
   DEFINE l_sql STRING 
   LET g_errno=''
   LET  l_sql ="select to_char(wmsys.wm_concat(distinct tc_sfbud06)) from tc_sfb_file where tc_sfbud05 = '",g_tc_sfa.tc_sfbud05,"'group by tc_sfbud05"
   PREPARE q010_pre2 FROM l_sql
   EXECUTE q010_pre2 INTO l_tc_sfbud06
   DISPLAY l_tc_sfbud06 TO tc_sfbud06
END FUNCTION

FUNCTION q010_tc_sfb06()  
   DEFINE l_eca02    LIKE eca_file.eca02
   DEFINE l_sql STRING  
   LET g_errno=''
   LET  l_sql ="select to_char(wmsys.wm_concat(eca02)) from eca_file where eca01 = '",g_tc_sfa.tc_sfb06,"'group by eca01"
   PREPARE q010_pre3 FROM l_sql
   EXECUTE q010_pre3 INTO l_eca02
   DISPLAY l_eca02 TO eca02
END FUNCTION

FUNCTION q010_detail_fill(p_ac)
   DEFINE p_ac         LIKE type_file.num5,
          l_oga24      LIKE oga_file.oga24,
          l_type       LIKE type_file.chr1,   
          l_sql        STRING, 
          l_tmp        STRING, #FUN-D10105
          l_tmp2       STRING  #FUN-D10105


 LET l_sql =
        "SELECT tc_sfa02,tc_sfa01,tc_sfbud05,tc_sfbud06,tc_sfb06,'',tc_sfb03,tc_sfbud04,
                tc_sfb04,tc_sfbud02,ima02,ima021,tc_sfb08 ",
        "  FROM tc_sfa_file,tc_sfb_file ",
        "  left join ima_file on ima01 = tc_sfbud02",
        " WHERE ",
        "   tc_sfa01 = tc_sfb01 ",#bug no:6480
        #"   AND ",tm.wc2 CLIPPED," AND ",tm.wc CLIPPED,
        " AND tc_sfb06 = '",g_tc_sfb_1[p_ac].tc_sfb06_2,"' AND tc_sfbud02 = '",g_tc_sfb_1[p_ac].tc_sfbud02_1,
        "' ORDER BY tc_sfa02 "     

   PREPARE csfq010_pb_detail FROM l_sql
   DECLARE tc_sfb_curs_detail  CURSOR FOR csfq010_pb_detail        #CURSOR
   --CALL g_tc_sfa.clear()
   CALL g_tc_sfb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   
   FOREACH tc_sfb_curs_detail INTO g_tc_sfb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
    SELECT eca02 INTO g_tc_sfb[g_cnt].eca02_1 FROM eca_file
    WHERE eca01 = g_tc_sfb[g_cnt].tc_sfb06_1 
        LET g_cnt = g_cnt + 1
    
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   
    END FOREACH
    CALL g_tc_sfb.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
   

END FUNCTION 

