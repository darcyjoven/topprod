# Prog. Version..: '5.30.06-13.03.12(00001)'     #
 
# Pattern name...: apsq302.4gl
# Descriptions...: APS系統參數查詢
# Date & Author..: 2008/03/31 By Mandy #FUN-830024
# Modify.........: NO.FUN-870099 2008/07/21 By Duke  add  delete action
# Modify.........: NO.TQC-8C0010 2008/12/09 By Mandy 當單身資料只有一筆時,做刪除會不成功
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-BC0040 11/12/13 By Mandy 刪除時,也需一併刪除vlq_file
 
DATABASE ds
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
     DEFINE g_vla DYNAMIC ARRAY OF RECORD    #FUN-830024
           vla01         LIKE vla_file.vla01,
           vla02         LIKE vla_file.vla02
                     END RECORD
    DEFINE g_argv1       LIKE rva_file.rva01    
    DEFINE g_wc,g_sql 	 string                 #WHERE CONDITION  
    DEFINE l_ac          LIKE type_file.num5    #目前處理的ARRAY CNT    
    DEFINE l_sl          LIKE type_file.num5    #目前處理的SCREEN LINE  
 
DEFINE   g_cnt           LIKE type_file.num10,  
         g_rec_b         LIKE type_file.num5    #單身筆數    
MAIN
    DEFINE l_sl		 LIKE type_file.num5    
    DEFINE p_row,p_col   LIKE type_file.num5   
 
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵，由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
 
 
    #計算使用時間 (進入時間)
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
    LET p_row = 4 LET p_col = 4
        
    OPEN WINDOW q302_w AT p_row,p_col WITH FORM "aps/42f/apsq302" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    CALL q302_b_fill()    
    #處理功能選擇
    CALL q302_menu()
 
    CLOSE WINDOW q302_w
 
    #計算使用時間 (退出使間)
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
 
END MAIN
 
# Describe: QBE 查詢資料
 
FUNCTION q302_cs()
 
   DEFINE   l_cnt LIKE type_file.num5           
 
   #清除畫面
   CLEAR FORM
   CALL g_vla.clear()
   CALL cl_opmsg('q')
 
   CONSTRUCT g_wc ON vla01,vla02
       FROM  s_vla[1].vla01,s_vla[1].vla02
 
     BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
     ON ACTION CONTROLP 
            IF INFIELD(vla01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_vlz01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO vla01
               NEXT FIELD vla01
            END IF
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   MESSAGE ' WAIT '
 
END FUNCTION
 
FUNCTION q302_menu()
   DEFINE   l_cmd    LIKE type_file.chr1000   
 
   WHILE TRUE
      CALL q302_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q302_q()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vla),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q302_q()
 
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cnt
 
    CALL q302_cs()
 
    IF INT_FLAG THEN 
        LET INT_FLAG = 0
        RETURN 
    END IF
 
    MESSAGE ''
    CALL q302_b_fill()
 
END FUNCTION
 
# Describe: BODY FILL UP
 
FUNCTION q302_b_fill()
 
    DEFINE #l_sql     LIKE type_file.chr1000  
           l_sql        STRING       #NO.FUN-910082    
    DEFINE l_za02    LIKE type_file.num5       #暫存指標 
    IF cl_null(g_wc) THEN
        LET g_wc = ' 1=1'           
    END IF
    LET g_sql=" SELECT vla01,vla02 ",
              "   FROM vla_file ",
              "  WHERE ",g_wc CLIPPED,
              "  ORDER BY vla01,vla02 "
    
    PREPARE q302_prepare FROM g_sql
    DECLARE q302_cs CURSOR FOR q302_prepare
 
    CALL g_vla.clear()
    LET g_cnt = 1
 
    FOREACH q302_cs INTO g_vla[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    LET g_cnt = g_cnt - 1
    CALL SET_COUNT(g_cnt)                    #告訴I.單身筆數
   #LET g_rec_b=g_cnt-1 #TQC-8C0010 mark
    LET g_rec_b=g_cnt   #TQC-8C0010 mod
    DISPLAY g_cnt TO FORMONLY.cnt 
 
END FUNCTION
 
FUNCTION q302_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vla TO s_vla.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
          #FUN-870099
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
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
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()  
  
      #FUN-870099 By Duke  add
      ON ACTION delete
         IF g_rec_b != 0 THEN
            IF cl_delete() THEN
               DELETE FROM vla_file WHERE vla01 = g_vla[l_ac].vla01
               IF SQLCA.SQLCODE THEN
                  CALL cl_err3("del","vla_file",g_vla[l_ac].vla01,"",SQLCA.sqlcode,"","", 1)
               #FUN-BC0040---add----str----
               ELSE
                   DELETE FROM vlq_file
                    WHERE vlq01 = g_vla[l_ac].vla01
                   IF STATUS THEN CALL cl_err('del_vlq',STATUS,1) END IF
               #FUN-BC0040---add----end----
               END IF
               CALL q302_b_fill()
            END IF
         END IF
 
      ON ACTION cancel                                                          
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
