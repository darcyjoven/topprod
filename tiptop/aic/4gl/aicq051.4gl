# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aicq051.4gl
# Descriptions...: WIP狀態查詢作業
# Date & Author..: FUN-7B0077 08/01/22 By mike
# Modify.........: No.FUN-830066 08/03/21 By mike 補充"相關文件”按鈕
# Modify.........: No.CHI-8C0040 09/02/01 by jan 語法修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模塊變量(Module Variables)
DEFINE
   g_wc             string,  
   g_sort_flag      LIKE type_file.chr1,
   g_ido DYNAMIC ARRAY OF RECORD
      ido02         LIKE  ido_file.ido02,
      pmc03         LIKE  pmc_file.pmc03,
      ido03         LIKE  ido_file.ido03,
      ido04         LIKE  ido_file.ido04,
      ido05         LIKE  ido_file.ido05,
      ido06         LIKE  ido_file.ido06,
      ima02         LIKE  ima_file.ima02,
      ima021        LIKE  ima_file.ima021,
      ido07         LIKE  ido_file.ido07,
      ido08         LIKE  ido_file.ido08,
      ido09         LIKE  ido_file.ido09,
      ido10         LIKE  ido_file.ido10,
      ido11         LIKE  ido_file.ido11,
      ido12         LIKE  ido_file.ido12,
      ido13         LIKE  ido_file.ido13,
      ido14         LIKE  ido_file.ido14,
      ido15         LIKE  ido_file.ido15,
      ido16         LIKE  ido_file.ido16,
      ido17         LIKE  ido_file.ido17,
      ido18         LIKE  ido_file.ido18,
      ido19         LIKE  ido_file.ido19,
      ido20         LIKE  ido_file.ido20,
      ido22         LIKE  ido_file.ido22,
      ido21         LIKE  ido_file.ido21,
      ido23         LIKE  ido_file.ido23,
      ido24         LIKE  ido_file.ido24,
      ido25         LIKE  ido_file.ido25,
      ido01         LIKE  ido_file.ido01,
      idodate       LIKE  ido_file.idodate 
      
      END RECORD,
   g_sql            string,
   g_rec_b          LIKE type_file.num5,  #單身筆數
   l_ac             LIKE type_file.num5   #目前處理的ARRAY CNT 
 
DEFINE   g_cnt      LIKE type_file.num10
 
 
MAIN
   DEFINE l_time        LIKE type_file.chr8  		#計算被使用時間
   DEFINE p_row,p_col   LIKE type_file.num5
 
   OPTIONS                                    #改變一些系統缺省值
      INPUT NO WRAP
   DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry('icd') THEN                                                                                                    
      CALL cl_err('','aic-999',1)                                                                                                   
      EXIT PROGRAM                                                                                                                  
   END IF                 
 
   CALL cl_used(g_prog,l_time,1)            #計算使用時間 (進入時間)
      RETURNING l_time
   LET g_sort_flag='1'
 
   LET p_row = 2 LET p_col = 5
 
   OPEN WINDOW q051_w AT p_row,p_col
        WITH FORM "aic/42f/aicq051"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL q051_menu()
 
   CLOSE WINDOW q051_w
     CALL cl_used(g_prog,l_time,2)       #計算使用時間(退出時間)
        RETURNING l_time
END MAIN
 
FUNCTION q051_menu()
 
   WHILE TRUE
      CALL q051_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q051_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
     
         #No.FUN-830066  --BEGIN
         WHEN "related_document"           #相關文件                                                                                
            IF cl_chk_act_auth() AND l_ac != 0 THEN                                                                                               
               IF g_ido[l_ac].ido02 IS NOT NULL THEN                                                                                          
                  LET g_doc.column1 = "ido02"                                                                                       
                  LET g_doc.value1 = g_ido[l_ac].ido02                                                                                        
                  CALL cl_doc()                                                                                                     
               END IF                                                                                                               
            END IF         
         #No.FUN-830066  --END
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ido),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q051_q()
   CALL cl_opmsg('q')
   MESSAGE " "
   CALL q051_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   MESSAGE ' WAIT '
   CALL q051_show()
   MESSAGE " "
END FUNCTION
 
#QBE 查詢資料
FUNCTION q051_cs()
   DEFINE   l_cnt  LIKE type_file.num5
 
   CLEAR FORM           #清除畫面
   CALL g_ido.clear()
   CALL cl_opmsg('q')
   LET g_wc=''
   CONSTRUCT g_wc ON ido02,pmc03,ido03,ido04,ido05,ido06,ima02,
                     ima021,ido07,ido08,ido09,ido10,ido11,
                     ido12,ido13,ido14,ido15,ido16,ido17,                             
                     ido18,ido19,ido20,ido22,ido21,ido23,
                     ido24,ido25,ido01,idodate FROM
                             
             s_ido[1].ido02,s_ido[1].pmc03,s_ido[1].ido03,s_ido[1].ido04,
             s_ido[1].ido05,s_ido[1].ido06,s_ido[1].ima02,s_ido[1].ima021,
             s_ido[1].ido07,s_ido[1].ido08,s_ido[1].ido09,s_ido[1].ido10,
             s_ido[1].ido11,s_ido[1].ido12,s_ido[1].ido13,s_ido[1].ido14,
             s_ido[1].ido15,s_ido[1].ido16,s_ido[1].ido17,s_ido[1].ido18,
             s_ido[1].ido19,s_ido[1].ido20,s_ido[1].ido22,s_ido[1].ido21,
             s_ido[1].ido23,s_ido[1].ido24,s_ido[1].ido25,s_ido[1].ido01,
             s_ido[1].idodate
      
        BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
END FUNCTION
 
FUNCTION q051_show()
   CALL q051_b_fill() #單身
    CALL cl_show_fld_cont()     
END FUNCTION
 
FUNCTION q051_sort()
   CALL q051_show()
END FUNCTION
 
FUNCTION q051_b_fill()              #BODY FILL UP
   DEFINE #l_sql     LIKE type_file.chr1000,
          l_sql     STRING,         #NO.FUN-910082
          l_cnt     LIKE type_file.num5
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND idouser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                            #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND idogrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #群組權限
   #      LET g_wc = g_wc clipped," AND idogrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('idouser', 'idogrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT ido02,pmc03,ido03,ido04,ido05,ido06,ima02,",
                    "ima021,ido07,ido08,ido09,ido10,ido11,",
                    " ido12,ido13,ido14,ido15,ido16,ido17,",                           
                    " ido18,ido19,ido20,ido22,ido21,ido23,",
                    " ido24,ido25,ido01,idodate  ",
              #" FROM  ido_file LEFT OUTER JOIN ima_file ON(ido06=ima01) LEFT OUTER JOIN pmc_file ON(ido02=pmc01)",             #CHI-8C0040
               " FROM  ido_file,OUTER ima_file,OUTER pmc_file", #CHI-8C0040
              #" WHERE  ", g_wc CLIPPED  #CHI-8C0040
               " WHERE ido02=pmc_file.pmc01 AND ido06=ima_file.ima01 AND ", g_wc CLIPPED        #CHI-8C0040
 
   PREPARE q051_pb FROM l_sql
   DECLARE q051_bcs                       #BODY CURSOR
        CURSOR FOR q051_pb
 
   FOR g_cnt = 1 TO g_ido.getLength()           
      INITIALIZE g_ido[g_cnt].* TO NULL
   END FOR
   LET g_rec_b=0
   LET g_cnt = 1
   FOREACH q051_bcs INTO g_ido[g_cnt].*
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
   CALL SET_COUNT(g_cnt-1)       
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q051_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ido TO s_ido.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
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
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      #No.FUN-830066  --BEGIN
      ON ACTION related_document                                                                                                    
         LET g_action_choice="related_document"                                                                                     
         EXIT DISPLAY        
      #No.FUN-830066  --END
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-7B0077
