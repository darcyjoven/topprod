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
    g_dat   RECORD
            date1     LIKE type_file.dat,
            date2     LIKE type_file.dat,
            s_all     LIKE type_file.chr1,
            s_small   LIKE type_file.chr1,
            s_big     LIKE type_file.chr1
        END RECORD,
    g_sfb DYNAMIC ARRAY OF RECORD
            sfb01   LIKE sfb_file.sfb01,
            sfb05   LIKE sfb_file.sfb05,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,
            bfl     LIKE sfb_file.sfb08,   #期间报废量
            rkl     LIKE sfb_file.sfb08,   #期间入库量
            sjll    LIKE type_file.num15_3,#实际良率
            imaud09 LIKE ima_file.imaud09  #标准良率
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
 
   IF (NOT cl_setup("csf")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag =1
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q005_w AT p_row,p_col
        WITH FORM "csf/42f/csfq005"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

    CALL q005_q() 
    CALL q005_menu()
    CLOSE WINDOW q005_w
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 

FUNCTION q005_cs()
   DEFINE   l_cnt LIKE type_file.num5         
   CLEAR FORM
   CALL g_sfb.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			
   INITIALIZE g_dat.* TO NULL 
   CALL cl_set_head_visible("","YES")
  # INPUT BY NAME g_dat.date1,g_dat.date2,g_dat.s_all,g_dat.s_small,g_dat.s_big WITHOUT DEFAULTS
     INPUT g_dat.date1,g_dat.date2,g_dat.s_all,g_dat.s_small,g_dat.s_big FROM date1,date2,s_all,s_small,s_big	
      BEFORE INPUT
          LET g_dat.s_all = 'Y'
          LET g_dat.s_big = 'N'
          LET g_dat.s_small = 'N'
          DISPLAY BY NAME g_dat.s_all,g_dat.s_small,g_dat.s_big 
      AFTER FIELD s_all

      AFTER FIELD s_small

      AFTER FIELD s_big
      ON CHANGE s_all
          IF g_dat.s_all  = 'Y' THEN
             LET g_dat.s_small = 'N'
             LET g_dat.s_big = 'N'
             DISPLAY BY NAME g_dat.s_small,g_dat.s_big
          END IF 

      ON CHANGE s_small
          IF g_dat.s_small  = 'Y' THEN
             LET g_dat.s_all = 'N'
             LET g_dat.s_big = 'N'
             DISPLAY BY NAME g_dat.s_all,g_dat.s_big
          END IF  

      ON CHANGE s_big
          IF g_dat.s_big  = 'Y' THEN
             LET g_dat.s_all = 'N'
             LET g_dat.s_small = 'N'
             DISPLAY BY NAME g_dat.s_all,g_dat.s_small
          END IF       
    
      
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

    CALL q005_b_askkey()

END FUNCTION
 


FUNCTION q005_b_askkey()
   CLEAR FORM 
   CONSTRUCT tm.wc2 ON sfb01,sfb05
                  FROM s_sfb[1].sfb01,s_sfb[1].sfb05
   BEFORE CONSTRUCT
      CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sfb01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_sfb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb01
               NEXT FIELD sfb01
               
            WHEN INFIELD(sfb05)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ima18"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO sfb05
               NEXT FIELD sfb05
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

FUNCTION q005_menu()

   WHILE TRUE

      CALL q005_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q005_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
  
         WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfb),'','')
           END IF            
          LET g_action_choice = " "  

       END CASE
   END WHILE
END FUNCTION
 
FUNCTION q005_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q005_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q005_show()
	MESSAGE ''
END FUNCTION
 

 
FUNCTION q005_show()

   DISPLAY BY NAME g_dat.* 
   CALL q005_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q005_b_fill()              #BODY FILL UP
  DEFINE l_sql,l_sql1    LIKE type_file.chr1000,        #No.FUN-680137  VARCHAR(1000)
         l_oma54t  LIKE oma_file.oma54t,
         l_oma55   LIKE oma_file.oma55,
         l_sfb02   LIKE sfb_file.sfb02,
         l_ac      LIKE type_file.num5

   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF

  # CALL q005_temp_table()

  LET l_sql1 = " SELECT sfb01,sfb05,ima02,ima021,NVL(SUM(shb112),0) bfl,NVL(SUM(sfv09),0) rkl,",
               " CASE WHEN (NVL(SUM(shb112),0)+ NVL(SUM(sfv09),0)) = 0 THEN 0 ELSE (1-(NVL(SUM(shb112),0)/(NVL(SUM(shb112),0)+ NVL(SUM(sfv09),0))))*100  END sjll,NVL(imaud09,0) imaud09 ",
               " FROM sfb_file LEFT JOIN ima_file ON sfb05 = ima01 ",
               "               LEFT JOIN shb_file ON shb05 = sfb01 ",
               "               LEFT JOIN sfv_file ON sfv11 = sfb01 ",
               "               LEFT JOIN sfu_file ON sfu01 = sfv01 ",
               " WHERE sfb81 BETWEEN to_date( '",g_dat.date1,"','YY/MM/DD') AND to_date ( '",g_dat.date2,"','YY/MM/DD') ",
               " AND ",tm.wc2 CLIPPED," AND sfb43 ! = '9'",
               " AND shbconf = 'Y' AND sfuconf = 'Y' ",
               " GROUP BY sfb01,sfb05,ima02,ima021,imaud09"
    IF g_dat.s_all = 'Y' THEN
       LET l_sql = l_sql1
    END IF 

    IF g_dat.s_big = 'Y' THEN
       LET l_sql = "SELECT * FROM (",l_sql1," )  WHERE sjll > imaud09" 
    END IF     

    IF g_dat.s_small = 'Y' THEN
       LET l_sql = "SELECT * FROM (",l_sql1," )  WHERE sjll < imaud09" 
    END IF 
    PREPARE q005_pb FROM l_sql
    DECLARE q005_bcs CURSOR WITH HOLD FOR q005_pb
    CALL g_sfb.clear()
    LET g_cnt = 1
    LET l_ac = 1
    FOREACH q005_bcs INTO g_sfb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
  #  INSERT INTO csfq005_tmp VALUES (g_sfb[g_cnt].*)
    LET g_cnt = g_cnt + 1
    
     IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_sfb.deleteElement(g_cnt)   #TQC-790065
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION

FUNCTION q005_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 

      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

 
      ON ACTION query
         LET g_action_choice="query"
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION ACCEPT
         LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
      ON ACTION CANCEL
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




--FUNCTION q005_temp_table()
     --DROP TABLE csfq005_tmp;
	 --CREATE TEMP TABLE csfq005_tmp(
            --sfb01   LIKE sfb_file.sfb01,
            --sfb05   LIKE sfb_file.sfb05,
            --ima02   LIKE ima_file.ima02,
            --ima021  LIKE ima_file.ima021,
            --bfl     LIKE sfb_file.sfb08, 
            --rkl     LIKE sfb_file.sfb08, 
            --sjll    LIKE type_file.num15_3,
            --imaud09 LIKE ima_file.imaud09);
             --
--END FUNCTION


