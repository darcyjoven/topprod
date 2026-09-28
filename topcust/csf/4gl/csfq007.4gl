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
            date2     LIKE type_file.dat
        END RECORD,
    g_sfb DYNAMIC ARRAY OF RECORD
            sfb01   LIKE sfb_file.sfb01,
            sfb05   LIKE sfb_file.sfb05,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,
            sfb08   LIKE sfb_file.sfb08,
            imaud09 LIKE ima_file.imaud09,
            sfbud09 LIKE sfb_file.sfbud09,
            sjll    LIKE type_file.num15_3,
            sfs03   LIKE sfs_file.sfs03,
            sfa05   LIKE sfa_file.sfa05,
            ctype   LIKE type_file.chr1,
            sfb01_b LIKE sfb_file.sfb01
            
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
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20070818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
    LET g_query_flag =1
    LET p_row = 4 LET p_col = 2
 
    OPEN WINDOW q007_w AT p_row,p_col
        WITH FORM "csf/42f/csfq007"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

    CALL q007_q() 
    CALL q007_menu()
    CLOSE WINDOW q007_w
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20070818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 

FUNCTION q007_cs()
   DEFINE   l_cnt LIKE type_file.num5         
   CLEAR FORM
   CALL g_sfb.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			
   INITIALIZE g_dat.* TO NULL 
   CALL cl_set_head_visible("","YES")
  
     INPUT g_dat.date1,g_dat.date2 FROM date1,date2
      BEFORE INPUT
      
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

    CALL q007_b_askkey()

END FUNCTION
 


FUNCTION q007_b_askkey()
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

FUNCTION q007_menu()

   WHILE TRUE

      CALL q007_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q007_q()
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
 
FUNCTION q007_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q007_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q007_show()
	MESSAGE ''
END FUNCTION
 

 
FUNCTION q007_show()

   DISPLAY BY NAME g_dat.* 
   CALL q007_b_fill() #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q007_b_fill()              #BODY FILL UP
  DEFINE l_sql,l_sql1,l_sql2,l_sql3    LIKE type_file.chr1000,        #No.FUN-680137  VARCHAR(1000)
         l_oma54t  LIKE oma_file.oma54t,
         l_oma55   LIKE oma_file.oma55,
         l_sfb02   LIKE sfb_file.sfb02,
         l_ac      LIKE type_file.num5

   IF cl_null(tm.wc2) THEN LET tm.wc2="1=1" END IF

  # CALL q007_temp_table()

  LET l_sql1 = " SELECT sfb01,sfb05,ima02,ima021,sfb08,NVL(imaud09,0) imaud09,NVL(sfbud09,0) sfbud09,",
               " '' sjll,sfs03,NVL(SUM(sfs05),0) sfs05,'1','' sfb01_b ",
               " FROM sfb_file LEFT JOIN sfa_file ON sfb01 = sfb01 ",
               "               LEFT JOIN ima_file ON ima01 = sfb05 ",
               "               LEFT JOIN sfs_file ON sfs03 = sfa03 AND sfa01 = sfs04 ",
               "               LEFT JOIN sfp_file ON sfs01 = sfp01 ",
               " WHERE sfb81 BETWEEN to_date( '",g_dat.date1,"','YY/MM/DD') AND to_date ( '",g_dat.date2,"','YY/MM/DD') ",
               " AND ",tm.wc2 CLIPPED," AND sfb04 ! = '8'",
               " AND sfpconf = 'Y' AND sfbconf = 'Y' ",
               " GROUP BY sfb01,sfb05,ima02,ima021,sfb08,imaud09,sfbud09,sfs03 "
  LET l_sql2 = l_sql1," UNION ",
               " SELECT sfb01,sfb05,ima02,ima021,sfb08,NVL(imaud09,0) imaud09,NVL(sfbud09,0) sfbud09,",
               " '' sjll,sfe07 sfs03,NVL(SUM(sfe16),0) sfs05,'1','' sfb01_b ",
               " FROM sfb_file LEFT JOIN sfa_file ON sfa01 = sfb01 ",
               "               LEFT JOIN ima_file ON ima01 = sfb05 ",
               "               LEFT JOIN sfe_file ON sfe07 = sfa03 AND sfa01 = sfe01 ",
               " WHERE sfb81 BETWEEN to_date( '",g_dat.date1,"','YY/MM/DD') AND to_date ( '",g_dat.date2,"','YY/MM/DD') ",
               " AND ",tm.wc2 CLIPPED," AND sfb04 ! = '8'",
               " AND sfbconf = 'Y'",
               " GROUP BY sfb01,sfb05,ima02,ima021,sfb08,imaud09,sfbud09,sfs03 "
  LET l_sql3 = l_sql2," UNION ",
               " SELECT a.sfb01 sfb01,a.sfb05 sfb05,ima02,ima021,a.sfb08,NVL(imaud09,0) imaud09, NVL(sfbud09,0) sfbud09,",
               " '' sjll,sfa03 sfs03,NVL(SUM(sfa05),0) sfs05,'2',b.sfb01 sfb01_b ",
               " FROM sfb_file LEFT JOIN sfa_file ON sfa01 = a.sfb01 ",
               "               LEFT JOIN ima_file ON ima01 = a.sfb05 ",
               "               LEFT JOIN sfb_file b ON a.sfb01 = b.sfbud04 ",
               " WHERE sfb81 BETWEEN to_date( '",g_dat.date1,"','YY/MM/DD') AND to_date ( '",g_dat.date2,"','YY/MM/DD') ",
               " AND ",tm.wc2 CLIPPED," AND a.sfb04 ! = '8'",
               " AND b.sfb01 LIKE '%MSA%'  AND b.sfbconf = 'Y'  AND a.sfbconf = 'Y'",
               " GROUP BY a.sfb01,a.sfb05,ima02,ima021,a.sfb08,simaud09,sfbud09,sfa03,b.sfb01"

   LET l_sql3 = l_sql3," ORDER BY sfb01,sfb05 "

   LET l_sql = " INSERT INTO csfq007_tmp ",
               "   SELECT x.*,ROW_NUMBER() OVER (PARTITION BY sfb01,sfb05 ORDER BY sfb01) ",
               "     FROM (",l_sql3 CLIPPED,") x "
   PREPARE q007_ins FROM l_sql
   EXECUTE q007_ins

   LET l_sql  = " SELECT sfb01,sfb05,ima02,ima021,sfb08,imaud09,sfbud09,'',sfs03,SUM(sfs05),ctype,sfb01_b ",
                " FROM csfq007_tmp ",
                " GROUP BY sfb01,sfb05,ima02,ima021,sfb08,imaud09,sfbud09,sfs03,ctype,sfb01_b "
   PREPARE q007_pb FROM l_sql
   DECLARE q007_bcs CURSOR WITH HOLD FOR q007_pb
    CALL g_sfb.clear()
    LET g_cnt = 1
    FOREACH q007_bcs INTO g_sfb[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
     SELECT (CASE WHEN (sfb12+sfb09) = 0 THEN 0 ELSE (1-(sfb12/(sfb12+sfb09)))*100 END) sjll
     INTO g_sfb[g_cnt].sjll
     FROM sfb_file
     WHERE sfb01 = g_sfb[g_cnt].sfb01
  #  INSERT INTO csfq007_tmp VALUES (g_sfb[g_cnt].*)
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

FUNCTION q007_bp(p_ud)
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



FUNCTION q007_temp_table()
     DROP TABLE csfq007_tmp;
	 CREATE TEMP TABLE csfq007_tmp(
            sfb01   LIKE sfb_file.sfb01,
            sfb05   LIKE sfb_file.sfb05,
            ima02   LIKE ima_file.ima02,
            ima021  LIKE ima_file.ima021,
            sfb08   LIKE sfb_file.sfb08,
            imaud09 LIKE ima_file.imaud09,
            sfbud09 LIKE sfb_file.sfbud09,
            sjll    LIKE type_file.num15_3,
            sfs03   LIKE sfs_file.sfs03,
            sfa05   LIKE sfa_file.sfa05,
            ctype   LIKE type_file.chr1,
            sfb01_b LIKE sfb_file.sfb01);
             
END FUNCTION


