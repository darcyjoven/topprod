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
               wc2     LIKE type_file.chr1000 #,         # Body Where condition  #No.FUN-680137 VARCHAR(500)
            #   wc3     LIKE type_file.chr1000              
            END RECORD,
    g_sfu   RECORD
			tlf06	LIKE sfu_file.sfu02,
			tlf01	LIKE sfv_file.sfv05
        END RECORD,
    g_sfv DYNAMIC ARRAY OF RECORD
          ecb01  LIKE ecb_file.ecb01,
          name1  LIKE ima_file.imaud10,
          ecb02  LIKE ecb_file.ecb02,
          ecb03  LIKE ecb_file.ecb03,
          ecb06  LIKE ecb_file.ecb06,
          ecb08  LIKE ecb_file.ecb08,
          eca03  LIKE eca_file.eca03,
          ecb19  LIKE ecb_file.ecb19,
          ecb21  LIKE ecb_file.ecb21,
          ecbud02  LIKE ecb_file.ecbud02,
          ecb17  LIKE ecb_file.ecb17
          END RECORD,
     g_sfv_1 DYNAMIC ARRAY OF RECORD       
          ecb01  LIKE ecb_file.ecb01,
          name1  LIKE ima_file.imaud10,
          ecb02  LIKE ecb_file.ecb02,
          ecb03  LIKE ecb_file.ecb03,
          ecb06  LIKE ecb_file.ecb06,
          ecb08  LIKE ecb_file.ecb08,
          eca03  LIKE eca_file.eca03,
          ecb19  LIKE ecb_file.ecb19,
          ecb21  LIKE ecb_file.ecb21,
          ecbud02  LIKE ecb_file.ecbud02,
          ecb17  LIKE ecb_file.ecb17
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
DEFINE g_date   DATE
 
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
 
    OPEN WINDOW q001_w AT p_row,p_col
        WITH FORM "csf/42f/csfq361"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

IF NOT cl_null(g_argv1) THEN CALL q001_q() END IF
    #CALL q001_q() 
    LET g_action_flag = 'page3'  
    CALL q001_menu()
    CLOSE WINDOW q001_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q001_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
   CLEAR FORM
   CALL g_sfv.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sfu.* TO NULL 

           CONSTRUCT BY NAME tm.wc ON sfu02
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              AFTER FIELD sfu02
                LET g_sfu.tlf06 = GET_FLDBUF(sfu02)
                #LET g_sfu.tlf06 = sfu02
                
      --ON ACTION CONTROLP
         --CASE
         --WHEN INFIELD(sfv05)
            --CALL cl_init_qry_var()
            --LET g_qryparam.state = 'c'
            --LET g_qryparam.form ="cq_sfv05"
            --CALL cl_create_qry() RETURNING g_sfu.tlf01
            --DISPLAY g_sfu.tlf01 TO sfv05
            --NEXT FIELD sfv05
        --NEXT FIELD sfv05

         --END CASE
#str---end by huanglf161027
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
           #CALL q001_b_askkey()
           #CALL q001_b_askkey2()
           #IF INT_FLAG THEN RETURN END IF

         #資料權限的檢查
       IF cl_null(g_sfu.tlf06) THEN LET tm.wc='1=2' ELSE LET tm.wc = g_sfu.tlf06 END IF
   # LET tm.wc = g_sfu.tlf06 # CLIPPED,cl_get_extra_cond('g_user', 'g_grup')
    #End:FUN-980030
    LET g_sql="SELECT  unique tlf06 FROM tlf_file", # 組合出 SQL 指令
        #" WHERE tlf06 between to_date('",g_sfu.tlf06 CLIPPED, "','yy/MM/dd')-7 and to_date('",g_sfu.tlf06 CLIPPED, "','yy/MM/dd') ORDER BY tlf06"  #add by huanglf161027
        " WHERE to_char(tlf06,'yy/MM')=substr('",g_sfu.tlf06 CLIPPED, "',0,5) "  

   PREPARE q001_prepare FROM g_sql
    DECLARE q001_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR q001_prepare
        #CURSOR FOR q001_prepare
    #LET g_sql=
    #    "SELECT COUNT(*) FROM sfu_file,sfv_file WHERE sfu01=sfv01 and sfuconf !='X' and sfv05 = 'P001'  and ",tm.wc CLIPPED
    #PREPARE q001_precount FROM g_sql
    #DECLARE q001_count CURSOR FOR q001_precount
END FUNCTION
 
{ FUNCTION q001_b_askkey()
    CLEAR FORM 
   CONSTRUCT tm.wc2 ON sfu01,sfv20,sfv11,sfv04,sfv08,sfv09,oea23,sfvud07
                  FROM s_sfv[1].sfu01,s_sfv[1].sfv20,
                       s_sfv[1].sfv11,s_sfv[1].sfv04,s_sfv[1].sfv08,
					   s_sfv[1].sfv09,s_sfv[1].oea23,s_sfv[1].sfvud07

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sfu01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_sfu"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfu01
               NEXT FIELD sfu01
               
            WHEN INFIELD(sfv20)
               CALL q_shm2(TRUE,TRUE,'','')   
               RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfv20
               NEXT FIELD sfv20

            WHEN INFIELD(sfv17)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="cq_sfv17"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfv17
               NEXT FIELD sfv17
               
            WHEN INFIELD(sfv11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="cq_sfv11"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfv11
               NEXT FIELD sfv11
               
             WHEN INFIELD(sfv04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="cq_sfv04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfv04
               NEXT FIELD sfv04
        
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


FUNCTION q001_b_askkey2()
   CLEAR FORM 
   CONSTRUCT tm.wc3  ON sfu01,sfv11,sfv04,sfv08,sfv09,oea23,sfvud07
                  FROM s_sfv_1[1].sfu01_1,
                       s_sfv_1[1].sfv11_1,s_sfv_1[1].sfv04_1,s_sfv_1[1].sfv08_1,
					   s_sfv_1[1].sfv09_1,s_sfv_1[1].oea23_1,s_sfv_1[1].sfvud07_1
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sfu01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_sfu"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfu01
               NEXT FIELD sfu01
               
            WHEN INFIELD(sfv20)
               CALL q_shm2(TRUE,TRUE,'','')   
               RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfv20
               NEXT FIELD sfv20

            WHEN INFIELD(sfv17)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="cq_sfv17"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfv17
               NEXT FIELD sfv17
               
            WHEN INFIELD(sfv11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="cq_sfv11"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfv11
               NEXT FIELD sfv11
               
             WHEN INFIELD(sfv04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="cq_sfv04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfv04
               NEXT FIELD sfv04
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
END FUNCTION  }

FUNCTION q001_menu()
   LET g_action_flag ="page3"
   WHILE TRUE
    IF cl_null(g_action_choice) THEN 
         IF g_action_flag = "page3" THEN  
            CALL q001_bp("G")
         END IF
       #  IF g_action_flag = "page4" THEN  
       #     CALL q001_bp2()
       #  END IF
      END IF 
      CASE g_action_choice
         WHEN "page3"
            CALL q001_bp("G")
         
        # WHEN "page4"
        #    CALL q001_bp2()
    
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q001_q()
            END IF
        LET g_action_choice = " " 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
  
         WHEN "exporttoexcel"
             LET w = ui.Window.getCurrent()
             LET f = w.getForm()
             IF g_action_flag = "page3" THEN  
                IF cl_chk_act_auth() THEN
                   LET page = f.FindNode("Page","page3")
                   CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfv),'','') 
                END IF
             END IF 
             #IF g_action_flag = "page4" THEN 
             #   IF cl_chk_act_auth() THEN
             #      LET page = f.FindNode("Page","page4")
             #      CALL cl_export_to_excel(page,base.TypeInfo.create(g_sfv_1),'','') 
             #   END IF
             #END IF 
             LET g_action_choice = " "  

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q001_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q001_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q001_cs                            # 從DB產生合乎條件TEP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE

      #OPEN q001_count
      #FETCH q001_count INTO g_row_count
      #DISPLAY g_row_count TO FORMONLY.cnt
      LET g_row_count  = 1
      CALL q001_show()  #CALL q001_fetch('F')  
    END IF
	MESSAGE ''
END FUNCTION
 
FUNCTION q001_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 DEFINE   row1            LIKE type_file.num5
    CASE p_flag
        WHEN 'N' FETCH NEXT     q001_cs INTO g_sfu.tlf06,g_sfu.tlf01
        WHEN 'P' FETCH PREVIOUS q001_cs INTO g_sfu.tlf06,g_sfu.tlf01
        WHEN 'F' FETCH FIRST    q001_cs INTO g_sfu.tlf06,g_sfu.tlf01
        WHEN 'L' FETCH LAST     q001_cs INTO g_sfu.tlf06,g_sfu.tlf01
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
            FETCH ABSOLUTE g_jump q001_cs INTO g_sfu.tlf06
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfu.tlf06,SQLCA.sqlcode,0)
        INITIALIZE g_sfu.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
                   LET g_sfu.tlf06 = ''
                   DISPLAY '' TO tlf06
                   LET g_sfu.tlf01 = '' 
                   DISPLAY '' TO tlf01
          WHEN 'N' LET g_curs_index = g_curs_index + 1
                   LET g_sfu.tlf06 = ''
                   DISPLAY '' TO tlf06
                   LET g_sfu.tlf01 = '' 
                   DISPLAY '' TO tlf01
          WHEN 'L' LET g_curs_index = g_row_count
                   LET g_sfu.tlf06 = ''
                   DISPLAY '' TO tlf06
                   LET g_sfu.tlf01 = '' 
                   DISPLAY '' TO tlf01
          WHEN '/' LET g_curs_index = g_jump
                   LET g_sfu.tlf06 = ''
                   DISPLAY '' TO tlf06
                   LET g_sfu.tlf01 = '' 
                   DISPLAY '' TO tlf01
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    
    END IF
   
 
    CALL q001_show()
END FUNCTION
 
FUNCTION q001_show()

   DISPLAY BY NAME g_sfu.* 
   CALL q001_b_fill() #單身
   #CALL q001_b_fill_1()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q001_b_fill()              #BODY FILL UP
  DEFINE l_sql     string,        #No.FUN-680137  VARCHAR(1000)
         l_oma54t  LIKE oma_file.oma54t,
         l_oma55   LIKE oma_file.oma55,
         l_sfb02   LIKE sfb_file.sfb02,
         l_ac      LIKE type_file.num5,
         m_cnt     LIKE type_file.num5
#str----add by huanglf161014
    DEFINE l_sfb22     LIKE sfb_file.sfb22
    DEFINE l_oea31     LIKE oea_file.oea31
    DEFINE l_oea23     LIKE oea_file.oea23
    DEFINE l_oeb05     LIKE oeb_file.oeb05
    DEFINE l_oea21     LIKE oea_file.oea21
    DEFINE l_year1     LIKE type_file.chr30
    DEFINE l_month1    LIKE type_file.chr30
    DEFINE l_number    LIKE type_file.chr30  
    DEFINE l_sql2       STRING 
    DEFINE l_sfv03     LIKE sfv_file.sfv03
#str----end by huanglf161014
    DEFINE l_sfv11    LIKE sfv_file.sfv11   #tianry add 161221
    DEFINE m_str       STRING    
    DEFINE m_wc        STRING
    DEFINE m_wc1       STRING
    DEFINE m_wc2       STRING
    DEFINE l_n1        SMALLINT
    DEFINE l_n2        SMALLINT
    DEFINE cnt3       LIKE oeb_file.oeb12
    DEFINE cnt4       LIKE oeb_file.oeb12
#add by donghy 170313
   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF
   #DROP TABLE q001_temp;
   #CALL q001_temp_table()
  { LET l_sql =
         "SELECT sfu02,sfu01,sfv20,sfv11,sfv04,ima02,sfv08,sfv09,'',sfvud07,'',sfv03 ",  #MOD-6A0130 modify
        " FROM  sfv_file", 
        " LEFT JOIN ima_file ON sfv04=ima01 ",
        " ,sfu_file",       
        " WHERE ",tm.wc2 CLIPPED," AND ",tm.wc CLIPPED, " AND sfv05 = 'P001' AND sfv01 = sfu01",
        "  AND sfv04 not like '%-%' AND sfuconf!='X' ",
        " ORDER BY sfv11 "
    PREPARE q001_pb FROM l_sql
    DECLARE q001_bcs                       #BODY CURSOR
        CURSOR WITH HOLD FOR q001_pb
    CALL g_sfv.clear()
    LET g_cnt = 1
    LET l_ac = 1
    FOREACH q001_bcs INTO g_sfv[g_cnt].*,l_sfv03
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
   
    #CALL t623_sfvud07_sel(g_sfv[g_cnt].sfu01,l_sfv03) RETURNING g_sfv[g_cnt].sfvud07
    #SELECT oea23 INTO g_sfv[g_cnt].oea23 FROM oea_file WHERE oea01 IN (SELECT sfb22 FROM sfb_file WHERE sfb01=g_sfv[g_cnt].sfv11 )
    #LET g_sfv[g_cnt].sfv_sum = g_sfv[g_cnt].sfv09 * g_sfv[g_cnt].sfvud07
    #INSERT INTO q001_temp VALUES (g_sfv[g_cnt].*)
    #SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01 =  g_sfv[g_cnt].sfv11
    #SELECT COUNT(*) INTO m_cnt FROM sfq_file,sfp_file
    #       WHERE sfp01=sfq01 AND sfq02  = g_sfv[g_cnt].sfv11 AND sfp03=g_date  
    #IF l_sfb02 = '5' AND m_cnt > 0  THEN 
    #   IF l_sfv11!=g_sfv[g_cnt].sfv11 OR g_cnt=1 THEN
    #      IF cl_null(g_sfv[g_cnt].sfvud07) THEN
    #         LET g_sfv[g_cnt].sfvud07 = 0
    #         LET g_sfv[g_cnt].sfv_sum = 0
    #      END IF      
    #      LET l_ac = g_cnt + 1
    #      LET g_sfv[l_ac].* = g_sfv[g_cnt].*
    #      LET g_cnt = g_cnt + 1
    ##      SELECT SUM(sfq03)*(-1) INTO g_sfv[l_ac].sfv09 FROM sfq_file,sfp_file
    #         WHERE sfp01=sfq01 AND sfq02  = g_sfv[l_ac].sfv11         
    #      CALL t623_sfvud07_sel(g_sfv[l_ac].sfu01,l_sfv03) RETURNING g_sfv[l_ac].sfvud07
    #  
    #     SELECT oea23 INTO g_sfv[l_ac].oea23 FROM oea_file WHERE oea01 IN (SELECT sfb22 FROM sfb_file WHERE sfb01=g_sfv[l_ac].sfv11 )
    #     LET g_sfv[l_ac].sfv_sum = g_sfv[l_ac].sfv09 * g_sfv[l_ac].sfvud07
    #     LET  g_sfv[g_cnt].* = g_sfv[l_ac].*
    #   END IF
       
     #  IF cl_null(g_sfv[l_ac].sfvud07) THEN
     #    LET g_sfv[l_ac].sfvud07 = 0
     #  END IF
     #  INSERT INTO q001_temp VALUES (g_sfv[g_cnt].*)
     #  LET l_sfv11=g_sfv[g_cnt].sfv11
    #END IF  
    
    LET g_cnt = g_cnt + 1    
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	     EXIT FOREACH
      END IF
    END FOREACH
    CALL g_sfv.deleteElement(g_cnt)    
    
    LET m_wc = tm.wc
    LET m_str =tm.wc2
    IF NOT cl_null(m_wc) THEN
       CALL cl_replace_str(m_wc,"sfu02","sfp03") RETURNING m_wc
    END IF
    #取工单单号
    IF m_str.getIndexOf("sfv11",1)  THEN #判断是否存在给sfv11下条件 ;
       SELECT INSTR(tm.wc2, "sfv11", 1, 1) INTO l_n1 FROM dual  #确认工单单号的位数      
       SELECT INSTR(tm.wc2, "'", l_n1, 2) INTO l_n2 FROM dual   #确认工单单号后的第二个引号的位置
       LET m_wc1 = m_str.subString(l_n1,l_n2)
       CALL cl_replace_str(m_wc1,"sfv11","sfq02") RETURNING m_wc1
    END IF
    LET l_n1 = 0
    LET l_n2 = 0
    LET cnt3 = 0
    LET cnt4 = 0
    IF m_str.getIndexOf("sfv04",1)  THEN #判断是否存在给sfv04下条件 ;
       SELECT INSTR(tm.wc2, "sfv04", 1, 1) INTO l_n1 FROM dual  #确认料号的位数      
       SELECT INSTR(tm.wc2, "'", l_n1, 2) INTO l_n2 FROM dual   #确认料号后的第二个引号的位置
       LET m_wc2 = m_str.subString(l_n1,l_n2)
       CALL cl_replace_str(m_wc2,"sfv04","sfb05") RETURNING m_wc2
    END IF
    IF cl_null(m_wc) THEN LET m_wc = ' 1=1 ' END IF 
    IF cl_null(m_wc1) THEN LET m_wc1 = ' 1=1 ' END IF
  IF cl_null(m_wc2) THEN LET m_wc2 = ' 1=1 ' END IF}
    CALL g_sfv.clear()
    LET g_cnt = 1
    LET l_sql =
        " SELECT a.sfb05,a.imaud10,a.ecb02,a.ecb03,a.ecb06,a.ecb08,a.eca02,a.ecb19,a.ecb21,' ' ecbud02,ecb17 FROM " ,
        "( SELECT DISTINCT sfb05,imaud10,ecb02,ecb03,ecb06,ecb08,eca02,ecb19,ecb21,ecbud02,ecb17 " ,
        " FROM tlf_file,sfb_file,ima_file,ecu_file,ecb_file,eca_file where sfb05=tlf01 and tlf62=sfb01 and ima01=tlf01 " ,  
        " aND tlf13 like 'asft6%'  AND tlf902 NOT IN (SELECT jce02 FROM jce_file) " ,
        " and ecu01=ecb01(+) and ecu02=ecb02(+) AND ecb08=eca01(+) AND sfb05=ECU01(+) AND SFB06=ECU02(+) AND ECU10(+)='Y'  " ,
        " AND ECUUD02(+)='Y'   " ,
       # "AND tlf06 BETWEEN to_date('",g_sfu.tlf06 CLIPPED, "','yy/MM/dd') and to_date('",g_sfu.tlf06 CLIPPED, "','yy/MM/dd')  ) A " ,
       " AND to_char(tlf06,'yy/MM')=substr('",g_sfu.tlf06 CLIPPED, "',0,5)  ) A " , 
       "LEFT JOIN " ,
        "( SELECT DISTINCT sfb05,imaud10,ecb02,sum(ecb19) ecb19a,sum(ecb21) ecb21a " ,
        " FROM tlf_file,sfb_file,ima_file,ecu_file,ecb_file,eca_file  " ,
        " where sfb05=tlf01 and tlf62=sfb01 and ima01=tlf01   AND tlf13 like 'asft6%' " ,   
        " AND tlf902 NOT IN (SELECT jce02 FROM jce_file) and ecu01=ecb01 and ecu02=ecb02 AND ecb08=eca01 " ,
        " and ecu01=ecb01(+) and ecu02=ecb02(+) AND ecb08=eca01(+) AND sfb05=ECU01(+) AND SFB06=ECU02(+) AND ECU10(+)='Y' " ,
      #  "AND tlf06 BETWEEN to_date('",g_sfu.tlf06 CLIPPED, "','yy/MM/dd') and to_date('",g_sfu.tlf06 CLIPPED, "','yy/MM/dd') " ,
        " AND to_char(tlf06,'yy/MM')=substr('",g_sfu.tlf06 CLIPPED, "',0,5) " , 
       "GROUP BY sfb05,imaud10,ecb02 ) b ON a.sfb05=b.sfb05 AND nvl(a.ecb02,'-')=nvl(b.ecb02,'-')" 
       #, " WHERE nvl(ecb19a,0)=0 AND nvl(ecb21a,0)=0 "
       # " WHERE  nvl(ecb19(+),0)=0 AND nvl(ecb21(+),0)=0 " 
        
        #" AND sfq02 LIKE 'MSC%' AND sfp01 = sfq01 and sfq02 = sfb01 and sfb05=ima01",
       # " AND sfb05 not like '%-%' AND sfp04='Y' ",
       # " ORDER BY sfp03 "
    PREPARE q001_pb2 FROM l_sql
    DECLARE q001_bcs2                       #BODY CURSOR
        #CURSOR WITH HOLD FOR q001_pb2
        CURSOR FOR q001_pb2
    #CALL g_sfv.clear()
    FOREACH q001_bcs2 INTO g_sfv[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
     # CALL t623_sfvud07_sel(g_sfv[g_cnt].sfu01,l_sfv03) RETURNING g_sfv[g_cnt].sfvud07
     # SELECT oea23 INTO g_sfv[g_cnt].oea23 FROM oea_file WHERE oea01 IN (SELECT sfb22 FROM sfb_file WHERE sfb01=g_sfv[g_cnt].sfv11 )
     # LET g_sfv[g_cnt].sfv_sum = g_sfv[g_cnt].sfv09 * g_sfv[g_cnt].sfvud07
     # LET cnt3=cnt3+g_sfv[g_cnt].sfv09;
     # LET cnt4=cnt4+g_sfv[g_cnt].sfv_sum;
     # IF cl_null(g_sfv[l_ac].sfvud07) THEN
     #   LET g_sfv[l_ac].sfvud07 = 0
     # END IF
     # LET g_sfv[g_cnt].sfv09 = g_sfv[g_cnt].sfv09 * -1
     # INSERT INTO q001_temp VALUES (g_sfv[g_cnt].*)
      LET g_cnt = g_cnt + 1 
    END FOREACH
    
    #SELECT SUM(SFV09),SUM(sfv_sum) INTO cnt3,cnt4 FROM q001_temp 
    
   # DISPLAY cnt3 TO FORMONLY.cn1
    #DISPLAY cnt4 TO FORMONLY.cn3
    
    CALL g_sfv.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q001_b_fill_1()              #BODY FILL UP
 { DEFINE l_sql1     LIKE type_file.chr1000,        #No.FUN-680137  VARCHAR(1000)
         l_sql2     LIKE type_file.chr1000, 
         l_oma54t  LIKE oma_file.oma54t,
         l_oma55   LIKE oma_file.oma55
        
   IF cl_null(tm.wc3) THEN LET tm.wc3="1=1" END IF
   --LET l_sql1 =
        --" SELECT sfu01,sfv11,sfv04,ima02,sfv08,sum(sfv09),'',sfvud07,'' ",
        --" FROM  sfv_file", 
        --" LEFT JOIN ima_file ON sfv04=ima01 ",
        --" ,sfu_file",               
        --" WHERE ",tm.wc2 CLIPPED," AND ",tm.wc3 CLIPPED," AND ",tm.wc CLIPPED,
        --" AND sfu01 =sfv01 ",
        --"  AND sfv04 not like '%-%'",
        --" GROUP BY sfu01,sfv11,sfv04,ima02,sfv08,sfvud07"
    LET l_sql1 =
        " SELECT sfu01,sfv11,sfv04,ima02,sfv08,sum(sfv09),'','',''",
        " FROM  q001_temp", 
        " GROUP BY sfu01,sfv11,sfv04,ima02,sfv08"
 
    PREPARE q001_pb1 FROM l_sql1
    DECLARE q001_bcs1                       #BODY CURSOR
        CURSOR WITH HOLD FOR q001_pb1
    CALL g_sfv_1.clear()
    LET g_cnt = 1
    FOREACH q001_bcs1 INTO g_sfv_1[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

    SELECT sfvud07 INTO g_sfv_1[g_cnt].sfvud07_1 FROM sfv_file WHERE sfv01= g_sfv_1[g_cnt].sfu01_1 AND sfv11= g_sfv_1[g_cnt].sfv11_1
    SELECT oea23 INTO g_sfv_1[g_cnt].oea23_1 FROM oea_file WHERE oea01 IN (SELECT sfb22 FROM sfb_file WHERE sfb01=g_sfv_1[g_cnt].sfv11_1 )

    LET g_sfv_1[g_cnt].sfv_sum_1 = g_sfv_1[g_cnt].sfv09_1 * g_sfv_1[g_cnt].sfvud07_1

    IF cl_null(g_sfv_1[g_cnt].sfvud07_1) THEN 
        LET g_sfv_1[g_cnt].sfvud07_1 = 0
        LET g_sfv_1[g_cnt].sfv_sum_1 = 0
    END IF 
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF

      # genero shell add g_max_rec check END
    END FOREACH

    CALL g_sfv_1.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b=g_cnt-1
  DISPLAY g_rec_b TO FORMONLY.cn2}
END FUNCTION
 
FUNCTION q001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_flag = 'page3'
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfv TO s_sfv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 

      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

       ON ACTION page3
          LET g_action_choice="page3"
          EXIT DISPLAY
          
	   #ON ACTION page4
      #    LET g_action_choice="page4"
      #    EXIT DISPLAY
 
 
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

FUNCTION q001_bp2()
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)

   LET g_action_flag = 'page4'

   CALL cl_set_act_visible("accept,cancel", FALSE)

  DISPLAY ARRAY g_sfv_1 TO s_sfv_1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
  
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 

      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

        ON ACTION page3
          LET g_action_choice="page3"
          EXIT DISPLAY
          
	  # ON ACTION page4
     #     LET g_action_choice="page4"
    #      EXIT DISPLAY
 
 
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
            CALL q001_detail_fill(l_ac1)
            CALL cl_set_comp_visible("page4", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page4", TRUE)
            LET g_action_choice = "page3"
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



FUNCTION q001_detail_fill(p_ac)
  DEFINE p_ac         LIKE type_file.num5
   {        l_oga24      LIKE oga_file.oga24,
          l_type       LIKE type_file.chr1,   
          l_sql        STRING, 
          l_tmp        STRING, #FUN-D10105
          l_tmp2       STRING  #FUN-D10105
    

 --LET l_sql =
         --"SELECT sfu02,sfu01,sfv20,sfv11,sfv04,ima02,sfv08,sfv09,'',sfvud07,'' ", 
        --" FROM  sfv_file", 
        --" LEFT JOIN ima_file ON sfv04=ima01 ",
        --" ,sfu_file",       
        --"  WHERE ",tm.wc2 CLIPPED," AND ",tm.wc CLIPPED, " AND sfv01 = sfu01",
        --"  AND sfv11 = '",g_sfv_1[p_ac].sfv11_1,"'",
        --"  AND sfv04 not like '%-%'",
        --" ORDER BY sfv01 " 
 LET l_sql =
        " SELECT sfu02_1,sfu01,sfv20,sfv11,sfv04,ima02,sfv08,sfv09,'',sfvud07,''",
        " FROM  q001_temp", 
        "  WHERE sfv11 = '",g_sfv_1[p_ac].sfv11_1,"'"
   PREPARE csfq001_pb_detail FROM l_sql
   DECLARE sfv_curs_detail  CURSOR FOR csfq001_pb_detail       
   CALL g_sfv.clear()
   LET g_cnt = 1
   LET g_rec_b = 0

   
   FOREACH sfv_curs_detail INTO g_sfv[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    SELECT oea23 INTO g_sfv[g_cnt].oea23 FROM oea_file WHERE oea01 IN (SELECT sfb22 FROM sfb_file WHERE sfb01=g_sfv[g_cnt].sfv11 )
    LET g_sfv[g_cnt].sfv_sum = g_sfv[g_cnt].sfv09 * g_sfv[g_cnt].sfvud07 
  
        LET g_cnt = g_cnt + 1
    
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )

	 EXIT FOREACH
      END IF
   
    END FOREACH
    CALL g_sfv.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b=g_cnt-1
  DISPLAY g_rec_b TO FORMONLY.cn2  }
   

END FUNCTION 


FUNCTION q001_temp_table()

	 CREATE TEMP TABLE q001_temp(
            sfu02_1  LIKE sfu_file.sfu02,
            sfu01  LIKE sfu_file.sfu01,
            sfv20  LIKE sfv_file.sfv20,
            sfv11  LIKE sfv_file.sfv11,
            sfv04  LIKE sfv_file.sfv04,
            ima02  LIKE ima_file.ima02,
            sfv08  LIKE sfv_file.sfv08,
            sfv09  LIKE sfv_file.sfv09,
            oea23  LIKE oea_file.oea23,
            sfvud07 LIKE sfv_file.sfvud07,
            sfv_sum LIKE sfv_file.sfvud07);
             
END FUNCTION

#str----add by huanglf161017
FUNCTION t623_sfvud07_sel(p_sfv01,p_sfv03)
  DEFINE p_sfv01  LIKE sfv_file.sfv01
  DEFINE p_sfv03  LIKE sfv_file.sfv03  
{  DEFINE l_sfv11   LIKE sfv_file.sfv11  #工单单号
  DEFINE l_sfv04   LIKE sfv_file.sfv04  #生产料号
  DEFINE l_sfb22   LIKE sfb_file.sfb22  #订单单号
  DEFINE l_sfb221  LIKE sfb_file.sfb221 #订单项次
  DEFINE l_oea31   LIKE oea_file.oea31  #账款客户编号
  DEFINE l_oea23   LIKE oea_file.oea23  #币种
  DEFINE l_oeb05   LIKE oeb_file.oeb05  #销售单位
  DEFINE l_oea21   LIKE oea_file.oea21  #税种 
  DEFINE l_year1   LIKE type_file.chr30 #年份
  DEFINE l_month1  LIKE type_file.chr30 #月份
  DEFINE l_number  LIKE type_file.chr30 #年月日组合
  DEFINE l_sfvud07 LIKE sfv_file.sfvud07#返回单价
  DEFINE l_xmf05   LIKE xmf_file.xmf05  
  DEFINE l_oea24   LIKE oea_file.oea24
  DEFINE l_oea211  LIKE oea_file.oea211
  DEFINE l_oea213  LIKE oea_file.oea213
  
 #取工单单号
 SELECT sfv11,sfv04 INTO l_sfv11,l_sfv04 FROM sfv_file WHERE sfv01=p_sfv01 AND sfv03=p_sfv03
 #取订单号+订单项次
 SELECT sfb22,sfb221 INTO l_sfb22,l_sfb221 FROM sfb_file WHERE sfb01=l_sfv11
 #取订单基本资料
 SELECT oea31,oea23,oeb05,oea21,oea24,oea211,oea213 
 INTO l_oea31,l_oea23,l_oeb05,l_oea21,l_oea24,l_oea211,l_oea213
 FROM oea_file,oeb_file WHERE oea01 = oeb01 AND oea01 = l_sfb22 AND oeb03=l_sfb221
 #取订单单价
 SELECT oeb13 INTO l_sfvud07 FROM oeb_file WHERE oeb01= l_sfb22 AND oeb03 = l_sfb221 
 IF cl_null(l_sfvud07) THEN LET l_sfvud07 = 0 END IF
 IF cl_null(l_oea24) THEN LET l_oea24 = 1 END IF
 IF cl_null(l_oea211) THEN LET l_oea211 = 1 END IF
 IF l_oea24 > 0 THEN LET l_sfvud07 = l_sfvud07 * l_oea24 END IF
 IF l_oea213 != 'Y' AND l_oea211 > 0 THEN LET l_sfvud07 = l_sfvud07 * (1+(l_oea211/100)) END IF
 IF l_sfvud07 > 0 THEN RETURN l_sfvud07 END IF
 
 #无订单继续取最新核价档
   #取最近的一笔核价日期
 SELECT MAX(xmf05) INTO l_xmf05 FROM xmf_file WHERE  xmf01 = l_oea31 AND xmf02 = l_oea23 AND xmf03 = l_sfv04
    AND xmf04 = l_oeb05 AND ta_xmf02 = l_oea21
    
  SELECT  MAX(xmf07) INTO l_sfvud07 FROM xmf_file  #防止同一天有两笔核价，做个MAX，取最大
    WHERE  xmf01 = l_oea31 AND xmf02 = l_oea23 AND xmf03 = l_sfv04
    AND xmf04 = l_oeb05 AND xmf05 = l_xmf05 AND ta_xmf02 = l_oea21
  IF cl_null(l_sfvud07) THEN LET l_sfvud07 = 0 END IF
  IF l_sfvud07 > 0 THEN RETURN l_sfvud07 END IF

  #取这个月第一笔订单单价
  LET l_year1 = YEAR(g_today)
  LET l_month1 = MONTH(g_today)
  LET l_number = '%',l_year1 CLIPPED,l_month1 CLIPPED,'%'
  LET g_sql =" SELECT oeb13 FROM oeb_file WHERE oeb01 LIKE '",l_number,"'",
             " AND oeb04 = '",l_sfv04,"' ORDER BY oeb01"  
  PREPARE oeb13_pre FROM g_sql
  IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
  END IF
  DECLARE oeb13_cs CURSOR FOR oeb13_pre
  FOREACH oeb13_cs INTO l_sfvud07
    IF l_sfvud07 > 0 THEN
       EXIT FOREACH
    END IF
  END FOREACH

  IF cl_null(l_sfvud07) THEN LET l_sfvud07 = 0 END IF
  IF l_sfvud07 > 0 THEN RETURN l_sfvud07 END IF

  #如果都没单价 取最近一笔订单单价
  SELECT oeb13 INTO l_sfvud07 FROM oea_file,oeb_file 
    WHERE oea01 = oeb01 AND oeb04 = l_sfv04 AND oeb13 > 0
    AND oea02 = (SELECT  MAX(oea02) FROM oea_file,oeb_file 
    WHERE oea01 = oeb01 AND oeb04 = l_sfv04)
    
    IF cl_null(l_sfvud07) THEN LET l_sfvud07 = 0 END IF
  RETURN l_sfvud07  }#不管是不是0 都返回了
END FUNCTION


#str----end by huanglf161017
