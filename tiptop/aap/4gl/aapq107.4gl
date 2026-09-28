# Prog. Version..: '5.30.09-13.09.06(00000)'     #
#
# Pattern name...: aapq107.4gl
# Descriptions...: 銷項進行發票查詢作業
# Date & Author..: 13/10/14 By wangrr #FUN-DA0055

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_ome     DYNAMIC ARRAY OF RECORD
       b         LIKE type_file.chr1,
       ome01     LIKE ome_file.ome01,
       ome02     LIKE ome_file.ome02,
       ome04     LIKE ome_file.ome04,
       occ02     LIKE occ_file.occ02,
       ome043    LIKE ome_file.ome043,
       ome211    LIKE ome_file.ome211,
       ome59     LIKE ome_file.ome59,
       ome59x    LIKE ome_file.ome59x,
       ome59t    LIKE ome_file.ome59t
                 END RECORD,
       g_cnt     LIKE type_file.num10,
       g_rec_b   LIKE type_file.num10,
       l_ac      LIKE type_file.num10,
       g_sql     STRING,
       g_b       LIKE type_file.chr1,
       g_wc      STRING,
       l_wc      STRING

MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_b = ARG_VAL(1)
   LET l_wc = ARG_VAL(2)
   LET l_wc = cl_replace_str(l_wc, "\\\"", "'") 

   OPEN WINDOW q107_w WITH FORM "aap/42f/aapq107"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

   IF cl_null(l_wc) THEN 
      CALL q107_q() 
   ELSE
      CALL q107()  
   END IF 
   CALL q107_menu()
   CLOSE WINDOW q107_w               #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q107_q()
   DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01             

   CLEAR FORM #清除畫面
   CALL g_ome.clear()
   CALL cl_opmsg('q')
   LET g_b='3'
   DIALOG ATTRIBUTE(UNBUFFERED)  
      INPUT g_b FROM s_ome[1].b     
         ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
         
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END INPUT  
  
      CONSTRUCT g_wc ON ome01,ome02,ome04,ome211,ome59,
                        ome59x,ome59t
                   FROM s_ome[1].ome01,s_ome[1].ome02,s_ome[1].ome04,s_ome[1].ome211,
                        s_ome[1].ome59,s_ome[1].ome59x,s_ome[1].ome59t
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
  
      END CONSTRUCT
   
      ON ACTION CONTROLP
         CASE
          WHEN INFIELD(ome01)
               CALL q_ome_apk(TRUE,TRUE,g_plant) RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ome01
               NEXT FIELD ome01

          WHEN INFIELD(ome04)
               CALL q_occ_pmc(TRUE,TRUE,g_plant) RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ome04
               NEXT FIELD ome04
         END CASE 
     
      ON ACTION locale
         LET g_action_choice = "locale"
         CALL cl_show_fld_cont()
         CALL cl_dynamic_locale()

      ON ACTION ACCEPT
         LET INT_FLAG = 0
         ACCEPT DIALOG
            
      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT DIALOG 

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG
            
      ON ACTION close
         LET INT_FLAG = 1
         EXIT DIALOG  

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about       
         CALL cl_about()    
 
      ON ACTION help        
         CALL cl_show_help()
 
      ON ACTION controlg    
         CALL cl_cmdask()   
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)

   END DIALOG 
   IF INT_FLAG THEN
      LET INT_FLAG = 0  
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM                                     
   END IF          
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('omeuser', 'omegrup')
   CALL q107()
   
END FUNCTION

FUNCTION q107_menu()
 
   WHILE TRUE
      IF cl_null(g_action_choice) THEN 
         CALL q107_bp('G')
      END IF
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q107_q()
            ELSE                          
               LET g_action_choice = " "  
            END IF
         WHEN "help"
            CALL cl_show_help()
            LET g_action_choice = " " 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            LET g_action_choice = " " 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ome),'','')
            END IF
            LET g_action_choice = " "  
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q107()
DEFINE l_wc1,l_wc2   STRING
DEFINE l_sql         STRING
DEFINE l_sum1        LIKE ome_file.ome59,
       l_sum2        LIKE ome_file.ome59x,
       l_sum3        LIKE ome_file.ome59t,
       l_amt1        LIKE apk_file.apk08,
       l_amt2        LIKE apk_file.apk07,
       l_amt3        LIKE apk_file.apk06

   IF cl_null(l_wc) THEN LET l_wc=' 1=1 ' END IF 
   IF g_b='2' OR g_b='3' THEN
      LET l_wc1=cl_replace_str(g_wc,'ome01','apk03')
      LET l_wc1=cl_replace_str(l_wc1,'ome02','apk05')
      LET l_wc1=cl_replace_str(l_wc1,'ome04','apk04')
      LET l_wc1=cl_replace_str(l_wc1,'ome211','apk29')
      LET l_wc1=cl_replace_str(l_wc1,'ome59x','apk07')
      LET l_wc1=cl_replace_str(l_wc1,'ome59t','apk06')
      LET l_wc1=cl_replace_str(l_wc1,'ome59','apk08')
      
      LET l_wc2=cl_replace_str(l_wc,'ome01','apk03')
      LET l_wc2=cl_replace_str(l_wc2,'ome02','apk05')
      LET l_wc2=cl_replace_str(l_wc2,'ome04','apk04')
      LET l_wc2=cl_replace_str(l_wc2,'ome211','apk29')
      LET l_wc2=cl_replace_str(l_wc2,'ome59x','apk07')
      LET l_wc2=cl_replace_str(l_wc2,'ome59t','apk06')
      LET l_wc2=cl_replace_str(l_wc2,'ome59','apk08')
      LET l_wc2=cl_replace_str(l_wc2,'ome','apk')
   END IF
   CASE
      WHEN g_b='1' 
         LET g_sql="SELECT '1',ome01,ome02,ome04,occ02,ome043,ome211,ome59,ome59x,ome59t ",
                   "  FROM ome_file LEFT OUTER JOIN occ_file ON ome04=occ01 ",
                   " WHERE ",g_wc CLIPPED," AND ",l_wc CLIPPED
         LET l_sql="SELECT SUM(ome59),SUM(ome59x),SUM(ome59t),0,0,0 FROM ome_file ",
                   " WHERE ",g_wc CLIPPED," AND ",l_wc CLIPPED
      WHEN g_b='2'
         LET g_sql="SELECT '2',apk03,apk05,apk04,pmc03,pmc081,apk29,apk08,apk07,apk06 ",
                   "  FROM apk_file LEFT OUTER JOIN pmc_file ON apk04=pmc01 ",
                   " WHERE ",l_wc1 CLIPPED," AND ",l_wc2 CLIPPED
         LET l_sql="SELECT 0,0,0,SUM(apk08),SUM(apk07),SUM(apk06) FROM apk_file ",
                   " WHERE ",l_wc1 CLIPPED," AND ",l_wc2 CLIPPED
      WHEN g_b='3'
         LET g_sql="SELECT '1',ome01,ome02,ome04,occ02,ome043,ome211,ome59,ome59x,ome59t ",
                   "  FROM ome_file LEFT OUTER JOIN occ_file ON ome04=occ01 ",
                   " WHERE ",g_wc CLIPPED," AND ",l_wc CLIPPED,
                   " UNION ALL ",
                   "SELECT '2',apk03,apk05,apk04,pmc03,pmc081,apk29,apk08,apk07,apk06 ",
                   "  FROM apk_file LEFT OUTER JOIN pmc_file ON apk04=pmc01 ",
                   " WHERE ",l_wc1 CLIPPED," AND ",l_wc2 CLIPPED
         LET l_sql="SELECT SUM(sum1),SUM(sum2),SUM(sum3),SUM(amt1),SUM(amt2),SUM(amt3)",
                   "  FROM (",
                   "         SELECT SUM(ome59) sum1,SUM(ome59x) sum2, ",
                   "                SUM(ome59t) sum3,0 amt1,0 amt2,0 amt3 ",
                   "           FROM ome_file ",
                   "          WHERE ",g_wc CLIPPED," AND ",l_wc CLIPPED,
                   "         UNION ALL ",
                   "         SELECT 0 sum1,0 sum2,0 sum3,SUM(apk08) amt1,",
                   "                SUM(apk07) amt2,SUM(apk06) amt3 ",
                   "           FROM apk_file ",
                   "          WHERE ",l_wc1 CLIPPED," AND ",l_wc2 CLIPPED,
                   "        )"
                   
   END CASE
   PREPARE q107_prep FROM g_sql
   DECLARE q107_curs CURSOR FOR q107_prep
   PREPARE q107_prep_sum FROM l_sql
   LET g_cnt=1
   FOREACH q107_curs INTO g_ome[g_cnt].*
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt=g_cnt+1
   END FOREACH
   CALL g_ome.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt
   EXECUTE q107_prep_sum INTO l_sum1,l_sum2,l_sum3,l_amt1,l_amt2,l_amt3
   IF cl_null(l_sum1) THEN LET l_sum1=0 END IF
   IF cl_null(l_sum2) THEN LET l_sum2=0 END IF
   IF cl_null(l_sum3) THEN LET l_sum3=0 END IF
   IF cl_null(l_amt1) THEN LET l_amt1=0 END IF
   IF cl_null(l_amt2) THEN LET l_amt2=0 END IF
   IF cl_null(l_amt3) THEN LET l_amt3=0 END IF
   DISPLAY l_sum1,l_sum2,l_sum3,l_amt1,l_amt2,l_amt3
        TO FORMONLY.sum1,FORMONLY.sum2,FORMONLY.sum3,
           FORMONLY.amt1,FORMONLY.amt2,FORMONLY.amt3
   LET g_action_choice = " "
END FUNCTION

FUNCTION q107_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_ome TO s_ome.* ATTRIBUTE(COUNT=g_rec_b)   
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY  
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
         EXIT DISPLAY 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY  
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY 
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
 
      ON ACTION about   
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
    
      ON ACTION controls                                                                                        	
         CALL cl_set_head_visible("","AUTO")
  
   END DISPLAY 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-DA0055--add
