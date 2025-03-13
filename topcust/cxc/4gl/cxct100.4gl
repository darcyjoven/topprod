# Pattern name...: cxct100.4gl
# Descriptions...: 出货未开票应收立账作业
# Date & Author..: 150414   by zhouhao 
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE 
       g_wc         STRING,       #NO.FUN-910082
       g_tc_omb001  LIKE tc_omb_file.tc_omb001,     #年度
       g_tc_omb002  LIKE tc_omb_file.tc_omb002,     #月份
       g_tc_omb003  LIKE tc_omb_file.tc_omb003,     #凭证编号
       g_tc_omb902  LIKE tc_omb_file.tc_omb902,     #add by dengsy170212
    
       g_tc_omb    DYNAMIC ARRAY OF RECORD
                 tc_omb005 LIKE tc_omb_file.tc_omb005,
                 tc_omb01 LIKE tc_omb_file.tc_omb01, 
                 tc_omb02 LIKE tc_omb_file.tc_omb02,  
                 tc_omb03 LIKE tc_omb_file.tc_omb03,
                 tc_omb032 LIKE tc_omb_file.tc_omb032,
                 tc_omb04 LIKE tc_omb_file.tc_omb04,         
                 tc_omb042 LIKE tc_omb_file.tc_omb042, 
                 tc_omb05 LIKE tc_omb_file.tc_omb05,
                 gen02    LIKE gen_file.gen02,
                 tc_omb06 LIKE tc_omb_file.tc_omb06,
                 gem02    LIKE gem_file.gem02,
                 tc_omb07 LIKE tc_omb_file.tc_omb07,   
                 tc_omb08 LIKE tc_omb_file.tc_omb08,  
                 tc_omb10 LIKE tc_omb_file.tc_omb10, 
                 tc_omb11 LIKE tc_omb_file.tc_omb11, 
                 tc_omb13 LIKE tc_omb_file.tc_omb13, 
                 tc_ombud01 LIKE tc_omb_file.tc_ombud01, 
                 tc_omb15 LIKE tc_omb_file.tc_omb15, 
                 tc_omb12 LIKE tc_omb_file.tc_omb12, 
                 tc_omb22 LIKE tc_omb_file.tc_omb22, 
                 tc_omb19 LIKE tc_omb_file.tc_omb19, 
                 tc_omb20 LIKE tc_omb_file.tc_omb20, 
                 tc_omb21 LIKE tc_omb_file.tc_omb21, 
                 tc_omb17 LIKE tc_omb_file.tc_omb17, 
                 tc_omb18 LIKE tc_omb_file.tc_omb18, 
                 tc_omb23 LIKE tc_omb_file.tc_omb23, 
                 aag02    LIKE aag_file.aag02,
                 tc_omb903  LIKE tc_omb_file.tc_omb903,   #add by dengsy170212
                 aag02_3    LIKE aag_file.aag02,          #add by dengsy170212
                 tc_omb24 LIKE tc_omb_file.tc_omb24,
                 tc_omb25 LIKE tc_omb_file.tc_omb25,
                 aag02t    LIKE aag_file.aag02,
                 tc_omb904  LIKE tc_omb_file.tc_omb904,  #add by dengsy170212
                 aag02_4    LIKE aag_file.aag02,         #add by dengsy170212
                 tc_omb26 LIKE tc_omb_file.tc_omb26,
                 tc_omb27 LIKE tc_omb_file.tc_omb27,
                  aag02tt    LIKE aag_file.aag02,
                 tc_omb28 LIKE tc_omb_file.tc_omb28,
                 tc_omb29 LIKE tc_omb_file.tc_omb29,
                 tc_omb30 LIKE tc_omb_file.tc_omb30,
                 tc_omb31 LIKE tc_omb_file.tc_omb31
                 ,tc_omb908 LIKE tc_omb_file.tc_omb908,  #add by dengsy170212
                 tc_omb909  LIKE tc_omb_file.tc_omb909   #add by dengsy170212
                END RECORD,
       #str------ add by dengsy170212
       g_tc_omb_t     RECORD
                 tc_omb005 LIKE tc_omb_file.tc_omb005,
                 tc_omb01 LIKE tc_omb_file.tc_omb01, 
                 tc_omb02 LIKE tc_omb_file.tc_omb02,  
                 tc_omb03 LIKE tc_omb_file.tc_omb03,
                 tc_omb032 LIKE tc_omb_file.tc_omb032,
                 tc_omb04 LIKE tc_omb_file.tc_omb04,         
                 tc_omb042 LIKE tc_omb_file.tc_omb042, 
                 tc_omb05 LIKE tc_omb_file.tc_omb05,
                 gen02    LIKE gen_file.gen02,
                 tc_omb06 LIKE tc_omb_file.tc_omb06,
                 gem02    LIKE gem_file.gem02,
                 tc_omb07 LIKE tc_omb_file.tc_omb07,   
                 tc_omb08 LIKE tc_omb_file.tc_omb08,  
                 tc_omb10 LIKE tc_omb_file.tc_omb10, 
                 tc_omb11 LIKE tc_omb_file.tc_omb11, 
                 tc_omb13 LIKE tc_omb_file.tc_omb13, 
                 tc_ombud01 LIKE tc_omb_file.tc_ombud01, 
                 tc_omb15 LIKE tc_omb_file.tc_omb15, 
                 tc_omb12 LIKE tc_omb_file.tc_omb12, 
                 tc_omb22 LIKE tc_omb_file.tc_omb22, 
                 tc_omb19 LIKE tc_omb_file.tc_omb19, 
                 tc_omb20 LIKE tc_omb_file.tc_omb20, 
                 tc_omb21 LIKE tc_omb_file.tc_omb21, 
                 tc_omb17 LIKE tc_omb_file.tc_omb17, 
                 tc_omb18 LIKE tc_omb_file.tc_omb18, 
                 tc_omb23 LIKE tc_omb_file.tc_omb23, 
                 aag02    LIKE aag_file.aag02,
                 tc_omb903  LIKE tc_omb_file.tc_omb903,   #add by dengsy170212
                 aag02_3    LIKE aag_file.aag02,          #add by dengsy170212
                 tc_omb24 LIKE tc_omb_file.tc_omb24,
                 tc_omb25 LIKE tc_omb_file.tc_omb25,
                 aag02t    LIKE aag_file.aag02,
                 tc_omb904  LIKE tc_omb_file.tc_omb904,  #add by dengsy170212
                 aag02_4    LIKE aag_file.aag02,         #add by dengsy170212
                 tc_omb26 LIKE tc_omb_file.tc_omb26,
                 tc_omb27 LIKE tc_omb_file.tc_omb27,
                  aag02tt    LIKE aag_file.aag02,
                 tc_omb28 LIKE tc_omb_file.tc_omb28,
                 tc_omb29 LIKE tc_omb_file.tc_omb29,
                 tc_omb30 LIKE tc_omb_file.tc_omb30,
                 tc_omb31 LIKE tc_omb_file.tc_omb31
                 ,tc_omb908 LIKE tc_omb_file.tc_omb908,  #add by dengsy170212
                 tc_omb909  LIKE tc_omb_file.tc_omb909   #add by dengsy170212
                END RECORD,
       #end------ add by dengsy170212

       g_query_flag    LIKE type_file.num5,        #第一次進入程式時即進入Query之後進入N.下筆
       g_sql           STRING,                     #WHERE CONDITION 
       g_rec_b         LIKE type_file.num5         #單身筆數
DEFINE p_row,p_col     LIKE type_file.num5       
DEFINE g_cnt           LIKE type_file.num10     
DEFINE g_msg           LIKE type_file.chr1000  
DEFINE g_row_count     LIKE type_file.num10   
DEFINE g_curs_index    LIKE type_file.num10     
DEFINE g_jump          LIKE type_file.num10    
DEFINE g_no_ask        LIKE type_file.num5      
DEFINE l_ac            LIKE type_file.num5      
DEFINE g_action_flag   STRING
DEFINE w        ui.Window
DEFINE f        ui.Form
DEFINE page     om.DomNode
#str------ add by dengsy170212
DEFINE g_bookno        LIKE aaa_file.aaa01  
DEFINE l_str1          STRING 
DEFINE g_forupd_sql     STRING  
DEFINE l_aba19          LIKE aba_file.aba19
DEFINE l_abapost        LIKE aba_file.abapost
#end------ add by dengsy170212
 
MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("CXC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time   #計算使用時間 (開始時間) 
 
    LET g_query_flag = 1
    LET p_row = 3 LET p_col = 15
 
    OPEN WINDOW t100_w AT p_row,p_col WITH FORM "cxc/42f/cxct100"
         ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    #str------ add by dengsy170212
    LET g_forupd_sql = "SELECT tc_omb001,tc_omb002,tc_omb003,tc_omb902  ",   
                       "  FROM tc_omb_file WHERE tc_omb001=?  and tc_omb002=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t100_cl CURSOR FROM g_forupd_sql
   LET l_str1='%' CLIPPED 
    #end------ add by dengsy170212
  #  CALL cl_set_comp_visible("cdc06,cdc07",FALSE)
    CALL t100_menu()
    CLOSE WINDOW t100_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) 
END MAIN
 
#QBE 查詢資料
FUNCTION t100_cs()
   DEFINE   l_cnt   LIKE type_file.num5     
 
   LET g_wc = ''

      CLEAR FORM #清除畫面
      CALL g_tc_omb.clear() 
      CALL cl_opmsg('q')
      CALL cl_set_head_visible("","YES")  
 
      INITIALIZE g_tc_omb001 TO NULL  
      INITIALIZE g_tc_omb002 TO NULL  
      INITIALIZE g_tc_omb003 TO NULL 
      INITIALIZE g_tc_omb902 TO NULL  #add by dengsy170212
 
      CONSTRUCT g_wc ON tc_omb001,tc_omb002,tc_omb003,tc_omb902    # 螢幕上取單頭條件  #No.FUN-9B0118 #add tc_omb902 by dengsy170212
                        ,tc_omb01,tc_omb02,tc_omb03
           FROM tc_omb001,tc_omb002,tc_omb003,tc_omb902   #add tc_omb902 by dengsy170212
                ,s_tc_omb[1].tc_omb01,s_tc_omb[1].tc_omb02,s_tc_omb[1].tc_omb03
         
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         #str------- add by dengsy170212
         ON ACTION controlp
           CASE
              WHEN INFIELD(tc_omb003) #傳票編號
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_aba"
                       LET g_qryparam.state = "c"
                       LET g_qryparam.arg1 = g_bookno   #MOD-840538
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO tc_omb003
                       NEXT FIELD tc_omb003

               OTHERWISE EXIT CASE
            END CASE
         #end------- add by dengsy170212
         ON ACTION qbe_select
            CALL cl_qbe_select() 
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT        
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      
   MESSAGE ' WAIT ' ATTRIBUTE(REVERSE,BLINK)
   LET g_sql="SELECT UNIQUE tc_omb001,tc_omb002,tc_omb003,tc_omb902  FROM tc_omb_file ",     #No.FUN-9B0118 #add tc_omb902  by dengsy170212
             " WHERE  ",g_wc CLIPPED ,
             " ORDER BY tc_omb001,tc_omb002,tc_omb003  "                         #No.FUN-9B0118
   PREPARE t100_prepare FROM g_sql
   DECLARE t100_cs SCROLL CURSOR FOR t100_prepare   #SCROLL CURSOR
 
   #取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql="SELECT UNIQUE tc_omb001,tc_omb002,tc_omb003 FROM tc_omb_file ",     #No.FUN-9B0118
             " WHERE  ",g_wc CLIPPED ,
             "  INTO TEMP x"
   DROP TABLE x
   PREPARE t100_precount_x FROM g_sql
   EXECUTE t100_precount_x
   
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE t100_pp FROM g_sql
   DECLARE t100_cnt CURSOR FOR t100_pp
END FUNCTION
 
FUNCTION t100_menu()

DEFINE l_msg  STRING 
DEFINE l_wc   STRING 

   WHILE TRUE
      CALL t100_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t100_q()
            END IF
#str--- add by dengsy150909
        WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL t100_r()
            END IF
#end--- add by dengsy150909
#str----- add by dengsy170212
        WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#end----- add by dengsy170212

#str----add by huanglf170113
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              LET w = ui.Window.getCurrent()  
              LET f = w.getForm()              
              IF cl_null(g_action_flag) OR g_action_flag = "pc6" THEN
                 LET page = f.FindNode("Page","pc6")
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_omb),'','')
              END IF
            END IF
#str----end by huanglf170113  

         WHEN "help" 
            CALL cl_show_help()       
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
    
         WHEN "zpsc" 
            IF cl_chk_act_auth() THEN
             LET l_msg = "cxcp100 "                                
             CALL cl_cmdrun(l_msg)     
            END IF
            
          WHEN "pzpz" 
            IF cl_chk_act_auth() THEN
               IF cl_null(g_tc_omb003) THEN #zhouxm170331 add
                  LET l_msg = "cxcp101 '",g_tc_omb001,"' '",g_tc_omb002,"'"                                      
                  CALL cl_cmdrun_wait(l_msg)     
                  CALL t100_show()
               ELSE                            #zhouxm170331 add
                  CALL cl_err('','aap-991',1)  #zhouxm170331 add
               END IF                          #zhouxm170331 add
            END IF  
          #str------ add by dengsy170212
          WHEN "pzpzdl"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_tc_omb003) THEN
                  LET g_success='Y' 
                  BEGIN WORK
                  LET l_aba19=NULL 
                  LET l_abapost=NULL 
                  SELECT aba19,abapost INTO l_aba19,l_abapost FROM aba_file WHERE aba01=g_tc_omb003
                  IF l_abapost='Y' THEN
                    CALL cl_err('','anm-079',1)
                    LET g_action_choice = NULL
                    LET g_success='N'
                  ELSE 
                     IF l_aba19='Y' THEN 
                        CALL cl_err('','anm-114',1)
                        LET g_action_choice = NULL
                        LET g_success='N'
                     END IF 
                  END IF 
                   ###add by liyjf181220 str
                    IF cl_null(g_tc_omb001) OR cl_null(g_tc_omb002) THEN 
                       CALL cl_err('','cxc-022',1)
                       LET g_success='N'
                    END IF
                   ###add by liyjf181220 end 
                   
                  IF g_success='Y' THEN 
                  DELETE FROM aba_file WHERE aba01=g_tc_omb003
                  IF SQLCA.sqlcode THEN
                   CALL cl_err3("delete","aba_file",g_tc_omb003,"",SQLCA.sqlcode,"","",1)
                    LET g_action_choice = NULL
                    LET g_success='N' 
                  END IF 
                  DELETE FROM abb_file WHERE abb01=g_tc_omb003
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("delete","abb_file",g_tc_omb003,"",SQLCA.sqlcode,"","",1)
                     LET g_action_choice = NULL
                     LET g_success='N'
                  END IF
                    
                  IF g_success='Y' THEN 
                  UPDATE tc_omb_file SET tc_omb003=NULL 
                    WHERE tc_omb001=g_tc_omb001
                    AND tc_omb002=g_tc_omb002
                  COMMIT WORK 
                  CALL cl_err('','cxc-889',1)
                  ELSE 
                     ROLLBACK WORK 
                  END IF 
                  CALL t100_show()
                  END IF 
               ELSE 
                  CALL cl_err('','cxc-887',1)
               END IF 
            END IF
            LET g_action_choice = NULL
            
          WHEN "pzcbpz" 
            IF cl_chk_act_auth() THEN
               IF cl_null(g_tc_omb902) THEN #zhouxm170331 add 
                  LET l_msg = "cxcp102 '",g_tc_omb001,"' '",g_tc_omb002,"'"                                      
                  CALL cl_cmdrun_wait(l_msg)     
                  CALL t100_show()
               ELSE                            #zhouxm170331 add
                  CALL cl_err('','aap-991',1)  #zhouxm170331 add
               END IF                          #zhouxm170331 add
            END IF

          WHEN "pzcbpzdl"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_tc_omb902) THEN
                  LET g_success='Y'
                  BEGIN WORK  
                  LET l_aba19=NULL 
                  LET l_abapost=NULL 
                  SELECT aba19,abapost INTO l_aba19,l_abapost FROM aba_file WHERE aba01=g_tc_omb902
                  IF l_abapost='Y' THEN
                    CALL cl_err('','anm-079',1)
                    LET g_action_choice = NULL
                    LET g_success='N'
                  ELSE 
                     IF l_aba19='Y' THEN 
                        CALL cl_err('','anm-114',1)
                        LET g_action_choice = NULL
                        LET g_success='N'
                     END IF 
                  END IF 
                  IF g_success='Y' THEN 
                  DELETE FROM aba_file WHERE aba01=g_tc_omb902
                  IF SQLCA.sqlcode THEN
                   CALL cl_err3("delete","aba_file",g_tc_omb902,"",SQLCA.sqlcode,"","",1)
                     LET g_success='N'
                     LET g_action_choice = NULL
                  END IF 
                  DELETE FROM abb_file WHERE abb01=g_tc_omb902
                  IF SQLCA.sqlcode THEN
                   CALL cl_err3("delete","abb_file",g_tc_omb902,"",SQLCA.sqlcode,"","",1)
                     LET g_success='N'
                     LET g_action_choice = NULL
                  END IF 
                  UPDATE tc_omb_file SET tc_omb902=NULL 
                    WHERE tc_omb001=g_tc_omb001
                    AND tc_omb002=g_tc_omb002
                  IF g_success='Y' THEN 
                  COMMIT WORK 
                  ELSE 
                    ROLLBACK WORK 
                  END IF 
                  CALL cl_err('','cxc-889',1)
                  CALL t100_show()
                  END IF 
               ELSE 
                  CALL cl_err('','cxc-888',1)
               END IF 
            END IF  
            LET g_action_choice = NULL

         WHEN "jqcb" 
            IF cl_chk_act_auth() THEN
               CALL t100_jqcb() 
               CALL t100_show()  
            END IF
            LET g_action_choice = NULL
          #end------ add by dengsy170212
                                        
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t100_q()
   LET g_row_count = 0                                                        
   LET g_curs_index = 0                                                       
   CALL cl_navigator_setting( g_curs_index, g_row_count )                    
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
   CALL t100_cs()
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      RETURN 
      CALL g_tc_omb.clear() 

      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ") 

   OPEN t100_cs                              # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN t100_cnt
      FETCH t100_cnt INTO g_row_count
      DISPLAY g_row_count TO cnt  #ATTRIBUTE(MAGENTA)
      CALL t100_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION t100_fetch(p_flag)
DEFINE p_flag   LIKE type_file.chr1      #處理方式
DEFINE l_abso   LIKE type_file.num5      #絕對的筆數
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t100_cs INTO g_tc_omb001,g_tc_omb002,g_tc_omb003 ,g_tc_omb902   #add g_tc_omb902 by dengsy170212
      WHEN 'P' FETCH PREVIOUS t100_cs INTO g_tc_omb001,g_tc_omb002,g_tc_omb003 ,g_tc_omb902   #add g_tc_omb902 by dengsy170212  
      WHEN 'F' FETCH FIRST    t100_cs INTO g_tc_omb001,g_tc_omb002,g_tc_omb003 ,g_tc_omb902   #add g_tc_omb902 by dengsy170212
      WHEN 'L' FETCH LAST     t100_cs INTO g_tc_omb001,g_tc_omb002,g_tc_omb003  ,g_tc_omb902   #add g_tc_omb902 by dengsy170212
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
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
         FETCH ABSOLUTE g_jump t100_cs INTO g_tc_omb001,g_tc_omb002,g_tc_omb003, g_tc_omb902    #No.FUN-9B0118 #add g_tc_omb902 by dengsy170212
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tc_omb002,SQLCA.sqlcode,0)
      INITIALIZE g_tc_omb001 TO NULL  
      INITIALIZE g_tc_omb002 TO NULL  
      INITIALIZE g_tc_omb003 TO NULL 

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
   CALL t100_show()
END FUNCTION
 
FUNCTION t100_show()
   DISPLAY g_tc_omb001   TO tc_omb001  
   DISPLAY g_tc_omb002   TO tc_omb002  
   
   SELECT tc_omb003,tc_omb902 INTO g_tc_omb003,g_tc_omb902  #add tc_omb902 by dengsy170212
    FROM tc_omb_file 
     WHERE tc_omb001= g_tc_omb001
        AND  tc_omb002= g_tc_omb002
        
   DISPLAY g_tc_omb003   TO tc_omb003  
  DISPLAY g_tc_omb902   TO tc_omb902  #add by dengsy170212  

   CALL t100_b_fill() #單身
   CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION t100_b_fill()                  #BODY FILL UP
   DEFINE     l_sql    STRING     #NO.FUN-910082   
   DEFINE l_tot     LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044 
DEFINE l_tc_omb002 LIKE tc_omb_file.tc_omb002
DEFINE l_tc_omb001 LIKE tc_omb_file.tc_omb001
#################maoyy20170106
DEFINE l_tot1 LIKE tc_omb_file.tc_omb19
DEFINE l_tot2 LIKE tc_omb_file.tc_omb20 
DEFINE l_tot3 LIKE tc_omb_file.tc_omb21 
DEFINE l_tot4 LIKE tc_omb_file.tc_omb24 
DEFINE l_tot5 LIKE tc_omb_file.tc_omb26 
DEFINE l_tot6 LIKE tc_omb_file.tc_omb28 
DEFINE l_tot7 LIKE tc_omb_file.tc_omb29 
DEFINE l_tot8 LIKE tc_omb_file.tc_omb30 
DEFINE l_tot9 LIKE tc_omb_file.tc_omb31
DEFINE l_tot10 LIKE tc_omb_file.tc_omb909  #add by dengsy170212


 LET l_tot1 = 0
         LET l_tot2 = 0 
           LET l_tot3 = 0 
             LET l_tot4 = 0 
               LET l_tot5 = 0 
                 LET l_tot6 = 0 
                   LET l_tot7 = 0 
                     LET l_tot8 = 0 
                       LET l_tot9 = 0 
                       LET l_tot10= 0 #add by dengsy170212 
                        
#################maoyy20170106

   LET l_sql="SELECT tc_omb005,tc_omb01 ,tc_omb02,tc_omb03,tc_omb032,tc_omb04,tc_omb042,tc_omb05,'',tc_omb06,'',tc_omb07,tc_omb08, ",
             " tc_omb10 ,tc_omb11,tc_omb13,tc_ombud01,tc_omb15,tc_omb12,tc_omb22,tc_omb19,tc_omb20,tc_omb21,tc_omb17,tc_omb18,",
             #" tc_omb23 ,'',tc_omb24,tc_omb25,'',tc_omb26,tc_omb27,'',tc_omb28,tc_omb29,tc_omb30,tc_omb31 ",  #mark by dengsy170212
             " tc_omb23 ,'',tc_omb903,'',tc_omb24,tc_omb25,'',tc_omb904,'',tc_omb26,tc_omb27,'',tc_omb28,tc_omb29,tc_omb30,tc_omb31 ",  #add by dengsy170212
             "   ,tc_omb908,tc_omb909 ",
             "  FROM tc_omb_file ",
             " WHERE tc_omb001 = ",g_tc_omb001,
             "   AND tc_omb002 = ",g_tc_omb002,
             #"   AND tc_omb003 ='",g_tc_omb003,"'",
             "  AND tc_omb21<>0 ",  #add by dengsy150909
             "   AND ",g_wc CLIPPED,
             " ORDER BY tc_omb002"
   PREPARE t100_pb FROM l_sql
   DECLARE t100_bcs CURSOR FOR t100_pb     #BODY CURSOR
 
   CALL g_tc_omb.clear() 
   LET g_rec_b= 0
   LET g_cnt  = 1
   FOREACH t100_bcs INTO g_tc_omb[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT occ02 INTO g_tc_omb[g_cnt].tc_omb032  FROM occ_file WHERE occ01=g_tc_omb[g_cnt].tc_omb03 #maoyy20170106
      SELECT gen02 INTO g_tc_omb[g_cnt].gen02 FROM gen_file WHERE gen01=g_tc_omb[g_cnt].tc_omb05
      SELECT gem02 INTO g_tc_omb[g_cnt].gem02 FROM gem_file WHERE gem01=g_tc_omb[g_cnt].tc_omb06
      SELECT aag02 INTO g_tc_omb[g_cnt].aag02 FROM aag_file WHERE aag01=g_tc_omb[g_cnt].tc_omb23
      SELECT aag02 INTO g_tc_omb[g_cnt].aag02t FROM aag_file WHERE aag01=g_tc_omb[g_cnt].tc_omb25
      SELECT aag02 INTO g_tc_omb[g_cnt].aag02tt  FROM aag_file WHERE aag01=g_tc_omb[g_cnt].tc_omb27
      SELECT aag02 INTO g_tc_omb[g_cnt].aag02_3 FROM aag_file WHERE aag01=g_tc_omb[g_cnt].tc_omb903  #add by dengsy170212
      SELECT aag02 INTO g_tc_omb[g_cnt].aag02_4 FROM aag_file WHERE aag01=g_tc_omb[g_cnt].tc_omb904  #add by dengsy170212
      
      LET g_cnt = g_cnt + 1
     # IF g_cnt > g_max_rec THEN
     #    CALL cl_err('',9035,0)
     #    EXIT FOREACH
     # END IF
       #########maoyy20170106
      
  LET l_tot1 = l_tot1 + g_tc_omb[g_cnt-1].tc_omb19
  LET l_tot2 = l_tot2 + g_tc_omb[g_cnt-1].tc_omb20
   LET l_tot3 = l_tot3 + g_tc_omb[g_cnt-1].tc_omb21
   
   LET l_tot4 = l_tot4 + g_tc_omb[g_cnt-1].tc_omb24
  LET l_tot5 = l_tot5 + g_tc_omb[g_cnt-1].tc_omb26
   LET l_tot6 = l_tot6 + g_tc_omb[g_cnt-1].tc_omb28 
   
    LET l_tot7 = l_tot7 + g_tc_omb[g_cnt-1].tc_omb29
  LET l_tot8 = l_tot8 + g_tc_omb[g_cnt-1].tc_omb30
   LET l_tot9 = l_tot9 + g_tc_omb[g_cnt-1].tc_omb31
   LET l_tot10=l_tot10+g_tc_omb[g_cnt-1].tc_omb909  #add by dengsy170212
                       
       #########maoyy20170106  
   END FOREACH
   CALL g_tc_omb.deleteElement(g_cnt)
   LET g_rec_b=(g_cnt-1)
   DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    ##############maoyy20170106
      DISPLAY l_tot1 TO FORMONLY.tot1  
        DISPLAY l_tot2 TO FORMONLY.tot2   
          DISPLAY l_tot3 TO FORMONLY.tot3
             
            DISPLAY l_tot4 TO FORMONLY.tot4   
              DISPLAY l_tot5 TO FORMONLY.tot5   
                DISPLAY l_tot6 TO FORMONLY.tot6  
                 
                   DISPLAY l_tot7 TO FORMONLY.tot7   
                     DISPLAY l_tot8 TO FORMONLY.tot8  
                       DISPLAY l_tot9 TO FORMONLY.tot9 
                       DISPLAY l_tot10 TO FORMONLY.tot10  #add by dengsy170212
 
    ############maoyy20170106
 
END FUNCTION
 
FUNCTION t100_bp(p_ud)
DEFINE p_ud     LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_omb TO s_tc_omb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()          
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

#str--- add by dengsy150909
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
#end--- add by dengsy150909
      ON ACTION first 
         CALL t100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           
      ON ACTION previous
         CALL t100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY             
      ON ACTION jump 
         CALL t100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
      ON ACTION next
         CALL t100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY 
      ON ACTION last
         CALL t100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              

#str----add by huanglf170113
     ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY
#str----end by huanglf170113
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

 #str----- add by dengsy170212
 ON ACTION detail
     LET g_action_choice="detail"
     LET l_ac = 1
     EXIT DISPLAY
 #end----- add by dengsy170212
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION accept
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
      ON ACTION controls   
         CALL cl_set_head_visible("","AUTO")     

    

      ON ACTION zpsc                            
         LET g_action_choice = 'zpsc'
         EXIT DISPLAY

       ON ACTION pzpz                           
         LET g_action_choice = 'pzpz'
         EXIT DISPLAY  

      #str------- add by dengsy170212
      ON ACTION pzpzdl                           
         LET g_action_choice = 'pzpzdl'
         EXIT DISPLAY 
         
      ON ACTION pzcbpz                           
         LET g_action_choice = 'pzcbpz'
         EXIT DISPLAY 

      ON ACTION pzcbpzdl                          
         LET g_action_choice = 'pzcbpzdl'
         EXIT DISPLAY 

      ON ACTION jqcb
         LET g_action_choice = 'jqcb'
         EXIT DISPLAY 
      #end------- add by dengsy170212  
                
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#str--- add by dengsy150909
FUNCTION t100_r()
DEFINE l_count    LIKE type_file.num5
DEFINE l_tc_omb003 LIKE tc_omb_file.tc_omb003

IF NOT  cl_delh(20,16) THEN 
    RETURN 
END IF 
    LET l_count=0
    select count(*) INTO l_count FROM tc_omb_file
    WHERE tc_omb001=g_tc_omb001 AND tc_omb002=g_tc_omb002 
    #AND tc_omb003 IS NOT NULL  #mark by dengsy170212
    AND (tc_omb003 IS NOT NULL  OR tc_omb902 IS NOT NULL ) #add by dengsy170212

    IF l_count>0 THEN 
        CALL cl_err('','cxc_001',1)
        RETURN 
    END IF 

    #select DISTINCT tc_omb003 INTO l_tc_omb003 FROM tc_omb_file
    #WHERE tc_omb001=tm.yy AND tc_omb002=tm.mm AND tc_omb003 IS NOT NULL 

    DELETE FROM tc_omb_file WHERE tc_omb001=g_tc_omb001 AND tc_omb002=g_tc_omb002

    CALL cl_err('','cxc_002',1)
    CLEAR FORM
       CALL g_tc_omb.clear()
       LET  g_tc_omb001=NULL
       LET  g_tc_omb002=NULL
       LET  g_tc_omb003=null
       MESSAGE ""
    OPEN t100_cnt
    IF STATUS THEN
          CLOSE t100_cs
          CLOSE t100_cnt
          COMMIT WORK
          RETURN
       END IF
       FETCH t100_cnt INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t100_cs
          CLOSE t100_cnt
          COMMIT WORK
          RETURN
       END IF

       LET g_row_count=g_row_count-1
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t100_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t100_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t100_fetch('/')
       END IF
END FUNCTION 
#end--- add by dengsy150909

#str------ add by dengsy170212
FUNCTION t100_b()
   DEFINE
    l_ac_t          LIKE type_file.num5,     
    l_n             LIKE type_file.num5,     
    l_n1            LIKE type_file.num5,     
    l_omf11         LIKE omf_file.omf11,     
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,     
    p_cmd           LIKE type_file.chr1,     
    l_cmd           LIKE type_file.chr1000,  
    l_omf     RECORD LIKE omf_file.*,
    l_ogb12         LIKE ogb_file.ogb12,
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5,
    l_omf16         LIKE omf_file.omf16   #FUN-C60036
    DEFINE l_omf19s LIKE omf_file.omf19,#FUN-C60036
           l_omf19z LIKE omf_file.omf19#FUN-C60036
    DEFINE li_cnt   LIKE type_file.num5 #FUN-C60036 add
    DEFINE l_oha09  LIKE oha_file.oha09 #MOD-CA0092 add
    #FUN-C60036-add--str
    DEFINE temp_omf13 STRING
    DEFINE bst base.StringTokenizer
    DEFINE temptext STRING
    DEFINE l_errno LIKE type_file.num10
    #FUN-C60036--add--end
    DEFINE l_slip   LIKE oay_file.oayslip #MOD-CB0040 add
    DEFINE l_oay13  LIKE oay_file.oay13   #MOD-CB0040 add
    DEFINE l_oay14  LIKE oay_file.oay14   #MOD-CB0040 add     
    DEFINE l_cnt1   LIKE type_file.num5   #No.MOD-CC0087
    DEFINE l_sum    LIKE omf_file.omf19t  #No.MOD-CC0087
    DEFINE l_sql    STRING                #yinhy130510
    DEFINE l_oga02,l_oha02 LIKE oga_file.oga02  #MOD-D60035
    DEFINE li_result   LIKE type_file.chr1    #TQC-D40067 add
    DEFINE l_flag  LIKE type_file.chr1 #MOD-DC0091
    
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_tc_omb001) OR cl_null(g_tc_omb002) THEN
       RETURN
    END IF

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_omb005,tc_omb01 ,tc_omb02,tc_omb03,tc_omb032,tc_omb04,tc_omb042,tc_omb05,'',tc_omb06,'',tc_omb07,tc_omb08, ",
             " tc_omb10 ,tc_omb11,tc_omb13,tc_ombud01,tc_omb15,tc_omb12,tc_omb22,tc_omb19,tc_omb20,tc_omb21,tc_omb17,tc_omb18,",
             " tc_omb23 ,'',tc_omb903,'',tc_omb24,tc_omb25,'',tc_omb904,'',tc_omb26,tc_omb27,'',tc_omb28,tc_omb29,tc_omb30,tc_omb31 ",  #add by dengsy170212
             "   ,tc_omb908,tc_omb909 ",
             "  FROM tc_omb_file ",
             "  WHERE tc_omb001=? AND tc_omb002=? and tc_omb005=? FOR UPDATE "                
                       
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_tc_omb WITHOUT DEFAULTS FROM s_tc_omb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=false,DELETE ROW=false,APPEND ROW=true)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           LET g_success = 'Y'  
           BEGIN WORK #FUN-C60033 add 
           SELECT COUNT(*) INTO l_cnt FROM tc_omb_file WHERE tc_omb001 = g_tc_omb001 AND tc_omb002=g_tc_omb002
           IF l_cnt > 0 THEN 
              OPEN t100_cl USING g_tc_omb001,g_tc_omb002   
              IF STATUS THEN
                 CALL cl_err("OPEN t670_cl:", STATUS, 1)
                 CLOSE t100_cl
                 ROLLBACK WORK
                 RETURN
              END IF 

              FETCH t100_cl INTO g_tc_omb001,g_tc_omb002,g_tc_omb003,g_tc_omb902
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_tc_omb002,SQLCA.sqlcode,0)     # 資料被他人LOCK
                 CLOSE t100_cl
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_omb_t.* = g_tc_omb[l_ac].*  #BACKUP
              OPEN t100_bcl USING g_tc_omb001,g_tc_omb002,g_tc_omb_t.tc_omb005                   #FUN-C60033
              IF STATUS THEN
                 CALL cl_err("OPEN t100_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
                 RETURN 
              ELSE
                 FETCH t100_bcl INTO g_tc_omb[l_ac].*
                 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tc_omb_t.tc_omb005 ,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                  
                 END IF
                 SELECT occ02 INTO g_tc_omb[l_ac].tc_omb032  FROM occ_file WHERE occ01=g_tc_omb[l_ac].tc_omb03 #maoyy20170106
      SELECT gen02 INTO g_tc_omb[l_ac].gen02 FROM gen_file WHERE gen01=g_tc_omb[l_ac].tc_omb05
      SELECT gem02 INTO g_tc_omb[l_ac].gem02 FROM gem_file WHERE gem01=g_tc_omb[l_ac].tc_omb06
                 SELECT aag02 INTO g_tc_omb[l_ac].aag02 FROM aag_file WHERE aag01=g_tc_omb[l_ac].tc_omb23
                SELECT aag02 INTO g_tc_omb[l_ac].aag02t FROM aag_file WHERE aag01=g_tc_omb[l_ac].tc_omb25
                SELECT aag02 INTO g_tc_omb[l_ac].aag02tt  FROM aag_file WHERE aag01=g_tc_omb[l_ac].tc_omb27
                SELECT aag02 INTO g_tc_omb[l_ac].aag02_3 FROM aag_file WHERE aag01=g_tc_omb[l_ac].tc_omb903  #add by dengsy170212
                SELECT aag02 INTO g_tc_omb[l_ac].aag02_4 FROM aag_file WHERE aag01=g_tc_omb[l_ac].tc_omb904  #add by dengsy170212
                 
                 CALL t100_set_entry_b()    #TQC-D20009 add
              END IF
              CALL cl_show_fld_cont() 
          
           END IF
           LET g_tc_omb_t.* = g_tc_omb[l_ac].* #FUN-C60036 add

       AFTER FIELD tc_omb23
          SELECT aag02 INTO g_tc_omb[l_ac].aag02 FROM aag_file WHERE aag01=g_tc_omb[l_ac].tc_omb23
          DISPLAY BY NAME g_tc_omb[l_ac].aag02
          
       AFTER FIELD tc_omb25
         SELECT aag02 INTO g_tc_omb[l_ac].aag02t FROM aag_file WHERE aag01=g_tc_omb[l_ac].tc_omb25
         DISPLAY BY NAME g_tc_omb[l_ac].aag02tt

       AFTER FIELD tc_omb27
            SELECT aag02 INTO g_tc_omb[l_ac].aag02tt  FROM aag_file WHERE aag01=g_tc_omb[l_ac].tc_omb27
            DISPLAY BY NAME g_tc_omb[l_ac].aag02tt

       AFTER FIELD tc_omb903
            SELECT aag02 INTO g_tc_omb[l_ac].aag02_3 FROM aag_file WHERE aag01=g_tc_omb[l_ac].tc_omb903  #add by dengsy170212
            DISPLAY BY NAME g_tc_omb[l_ac].aag02_3

       AFTER FIELD tc_omb904
            SELECT aag02 INTO g_tc_omb[l_ac].aag02_4 FROM aag_file WHERE aag01=g_tc_omb[l_ac].tc_omb904  #add by dengsy170212
            DISPLAY BY NAME g_tc_omb[l_ac].aag02_4
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_tc_omb[l_ac].* = g_tc_omb_t.*
              CLOSE t100_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
           	  CALL cl_err(g_tc_omb[l_ac].tc_omb005,-263,1)
              LET g_tc_omb[l_ac].* = g_tc_omb_t.*
           ELSE
           	  
           	  IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tc_omb[l_ac].tc_omb005,g_errno,0) 
                 NEXT FIELD tc_omb005
              END IF
                
                UPDATE tc_omb_file SET tc_omb23=g_tc_omb[l_ac].tc_omb23,
                                    tc_omb903=g_tc_omb[l_ac].tc_omb903,
                                    tc_omb25=g_tc_omb[l_ac].tc_omb25,
                                    tc_omb904=g_tc_omb[l_ac].tc_omb904,
                                    tc_omb27=g_tc_omb[l_ac].tc_omb27
                   WHERE tc_omb001=g_tc_omb001 
                   AND tc_omb002 = g_tc_omb002
                   AND tc_omb005= g_tc_omb[l_ac].tc_omb005
                
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","tc_omb_file","","",SQLCA.sqlcode,"","",1)
                   LET g_tc_omb[l_ac].* = g_tc_omb_t.*
                   ROLLBACK WORK
                   EXIT INPUT
                ELSE
                  MESSAGE 'UPDATE O.K' 
                  COMMIT WORK 
                END IF              
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tc_omb[l_ac].* = g_tc_omb_t.*
              ELSE
                 CALL g_tc_omb.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 ELSE                   #TQC-D40067 add
                    CLEAR FORM          #TQC-D40067 add
                    CALL g_tc_omb.clear()  #TQC-D40067 add                    
                 END IF
              END IF
              CLOSE t100_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30034 Add
           CLOSE t100_bcl
           COMMIT WORK
 
        ON ACTION controlp
           CASE

              WHEN INFIELD(tc_omb003) #傳票編號
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_aba"
                       LET g_qryparam.state = "c"
                       LET g_qryparam.arg1 = g_bookno   #MOD-840538
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO tc_omb003
                       NEXT FIELD tc_omb003
                       
              WHEN INFIELD(tc_omb23)
                 
                 CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = g_tc_omb[l_ac].tc_omb23
                   LET g_qryparam.arg1 = g_bookno  
                   LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",l_str1 CLIPPED,"'" 
                   CALL cl_create_qry() RETURNING g_tc_omb[l_ac].tc_omb23
                   DISPLAY BY NAME g_tc_omb[l_ac].tc_omb23
                   NEXT FIELD tc_omb23

                WHEN INFIELD(tc_omb903)
                 
                 CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = g_tc_omb[l_ac].tc_omb903
                   LET g_qryparam.arg1 = g_bookno  
                   LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",l_str1 CLIPPED,"'" 
                   CALL cl_create_qry() RETURNING g_tc_omb[l_ac].tc_omb903
                   DISPLAY BY NAME g_tc_omb[l_ac].tc_omb903
                   NEXT FIELD tc_omb903

              WHEN INFIELD(tc_omb25)
                 
                 CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = g_tc_omb[l_ac].tc_omb25
                   LET g_qryparam.arg1 = g_bookno  
                   LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",l_str1 CLIPPED,"'" 
                   CALL cl_create_qry() RETURNING g_tc_omb[l_ac].tc_omb25
                   DISPLAY BY NAME g_tc_omb[l_ac].tc_omb25
                   NEXT FIELD tc_omb25

               WHEN INFIELD(tc_omb904)
                 
                 CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = g_tc_omb[l_ac].tc_omb904
                   LET g_qryparam.arg1 = g_bookno  
                   LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",l_str1 CLIPPED,"'" 
                   CALL cl_create_qry() RETURNING g_tc_omb[l_ac].tc_omb904
                   DISPLAY BY NAME g_tc_omb[l_ac].tc_omb904
                   NEXT FIELD tc_omb904

               WHEN INFIELD(tc_omb27)
                 
                 CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_aag"
                   LET g_qryparam.default1 = g_tc_omb[l_ac].tc_omb27
                   LET g_qryparam.arg1 = g_bookno  
                   LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 ='2' AND aag01 LIKE '",l_str1 CLIPPED,"'" 
                   CALL cl_create_qry() RETURNING g_tc_omb[l_ac].tc_omb27
                   DISPLAY BY NAME g_tc_omb[l_ac].tc_omb27
                   NEXT FIELD tc_omb27

               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
    END INPUT


    CLOSE t100_bcl
    COMMIT WORK

END FUNCTION 

FUNCTION  t100_set_entry_b()
  CALL cl_set_comp_entry("tc_omb005 ,tc_omb01 ,tc_omb02,tc_omb03,tc_omb032,tc_omb04,tc_omb042,
                        tc_omb05,gen02,tc_omb06,gem02,tc_omb07,tc_omb08,tc_omb10,tc_omb11,
                        tc_omb13,tc_ombud01,tc_omb15,tc_omb12,tc_omb22,tc_omb19,tc_omb20,tc_omb21,
                        tc_omb17,tc_omb18,aag02,aag02_3,tc_omb24,aag02t,aag02_4,tc_omb26,aag02tt,
                        tc_omb28,tc_omb29,tc_omb30,tc_omb31,tc_omb908,tc_omb909",false )
   CALL cl_set_comp_entry("tc_omb23,tc_omb903,tc_omb25,tc_omb904,tc_omb27",true)
END FUNCTION 

FUNCTION t100_jqcb()
DEFINE l_success   LIKE type_file.chr1
   #LET l_num=2016*12+12
   LET l_success='Y'
   BEGIN WORK 
   IF NOT cl_null(g_tc_omb001) AND NOT cl_null(g_tc_omb002) THEN 
     UPDATE tc_omb_file SET tc_omb908=0,tc_omb909=0
                        WHERE tc_omb001=g_tc_omb001 AND tc_omb002=g_tc_omb002
    IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","tc_omb_file","","",SQLCA.sqlcode,"","",1)
        LET l_success='N'
     END IF
#170728 luoyb str
      UPDATE tc_omb_file SET tc_omb908=(SELECT tc_ccpc04 FROM tc_ccpc_file
                                         WHERE tc_ccpc01 = tc_omb_file.tc_omb11
                                           AND tc_ccpc02 = year(tc_omb_file.tc_omb02)
                                           AND tc_ccpc03 = month(tc_omb_file.tc_omb02))
       WHERE tc_omb001 = g_tc_omb001 AND tc_omb002=g_tc_omb002
         AND tc_omb02 <= to_date('170131','yymmdd')
      UPDATE tc_omb_file SET tc_omb908=0
       WHERE tc_omb001 = g_tc_omb001 AND tc_omb002=g_tc_omb002
         AND tc_omb908 IS NULL
         AND tc_omb02 <= to_date('170131','yymmdd')
#170728 luoyb end
#      UPDATE tc_omb_file SET tc_omb908=(SELECT ccc23 FROM ccc_file WHERE ccc01=tc_omb11 AND ccc02=year(tc_omb02) AND ccc03=month(tc_omb02) )
       UPDATE tc_omb_file SET tc_omb908=(SELECT ta_ccc23 FROM ta_ccp_file WHERE ta_ccc01=tc_omb11 AND ta_ccc02=year(tc_omb02) AND ta_ccc03=month(tc_omb02))
                             WHERE tc_omb001=g_tc_omb001 AND tc_omb002=g_tc_omb002
#                              AND tc_omb02>to_date('161231','yymmdd')  #170728 luoyb
                               AND tc_omb02>to_date('170131','yymmdd')  #170728 luoyb
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","tc_omb_file","","",SQLCA.sqlcode,"","",1)
        LET l_success='N'
     END IF 
     UPDATE tc_omb_file SET tc_omb908=0
                            WHERE tc_omb001=g_tc_omb001 AND tc_omb002=g_tc_omb002
#                           AND tc_omb02>to_date('161231','yymmdd')  #170728 luoyb
                            AND tc_omb02>to_date('170131','yymmdd')  #170728 luoyb
                            AND (SELECT imd09 FROM ogb_file,imd_file WHERE ogb01=tc_omb01 AND ogb03=tc_omb10 AND imd01=ogb09)='N'
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","tc_omb_file","","",SQLCA.sqlcode,"","",1)
        LET l_success='N' 
     END IF 
     UPDATE tc_omb_file SET tc_omb909=round(tc_omb908*tc_omb21,2)
                        WHERE tc_omb001=g_tc_omb001 AND tc_omb002=g_tc_omb002
    IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","tc_omb_file","","",SQLCA.sqlcode,"","",1)
        LET l_success='N'
     END IF
    IF  l_success='N' THEN
      ROLLBACK WORK
      CALL cl_err('','cxc-902',1)
    ELSE 
     COMMIT WORK 
     CALL cl_err('','cxc-901',1)
    END IF 
   END IF 
END FUNCTION 
#end------ add by dengsy170212
