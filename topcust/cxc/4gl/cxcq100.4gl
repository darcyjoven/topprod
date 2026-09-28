DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm          RECORD
                tc_ccc01  LIKE tc_ccc_file.tc_ccc01,                #MOD-B90146
                tc_ccc02  LIKE tc_ccc_file.tc_ccc02                 #MOD-B90146
                END RECORD
DEFINE l_count   LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE g_tc_ccc  DYNAMIC ARRAY OF RECORD
       tc_ccc03             LIKE  tc_ccc_file.tc_ccc03,
       tc_ccc04             LIKE  tc_ccc_file.tc_ccc04,
       ima02                LIKE  ima_file.ima02,
       ima021               LIKE  ima_file.ima021,
       tc_ccc05             LIKE  tc_ccc_file.tc_ccc05,
       tc_ccc06             LIKE  tc_ccc_file.tc_ccc06,
       tc_ccc08             LIKE  tc_ccc_file.tc_ccc08,
       tc_ccc08a            LIKE  tc_ccc_file.tc_ccc08a,
       tc_ccc08b            LIKE  tc_ccc_file.tc_ccc08b,
       tc_ccc08c            LIKE  tc_ccc_file.tc_ccc08c,
       tc_ccc08d            LIKE  tc_ccc_file.tc_ccc08d,
       tc_ccc09             LIKE  tc_ccc_file.tc_ccc09,
       tc_ccc09a            LIKE  tc_ccc_file.tc_ccc09a,
       tc_ccc09b            LIKE  tc_ccc_file.tc_ccc09b,
       tc_ccc09c            LIKE  tc_ccc_file.tc_ccc09c,
       tc_ccc09d            LIKE  tc_ccc_file.tc_ccc09d,
       tc_ccc09e            LIKE  tc_ccc_file.tc_ccc09e,
       tc_ccc11             LIKE  tc_ccc_file.tc_ccc11,
       tc_ccc11a            LIKE  tc_ccc_file.tc_ccc11a,
       tc_ccc11b            LIKE  tc_ccc_file.tc_ccc11b,
       tc_ccc11c            LIKE  tc_ccc_file.tc_ccc11c,
       tc_ccc11d            LIKE  tc_ccc_file.tc_ccc11d,
       tc_ccc12             LIKE  tc_ccc_file.tc_ccc12,
       tc_ccc12a            LIKE  tc_ccc_file.tc_ccc12a,
       tc_ccc12b            LIKE  tc_ccc_file.tc_ccc12b,
       tc_ccc17             LIKE  tc_ccc_file.tc_ccc17,
       tc_ccc18             LIKE  tc_ccc_file.tc_ccc18,
       tc_ccc18a            LIKE  tc_ccc_file.tc_ccc18a,
       tc_ccc18b            LIKE  tc_ccc_file.tc_ccc18b,
       tc_ccc18c            LIKE  tc_ccc_file.tc_ccc18c,
       tc_ccc18d            LIKE  tc_ccc_file.tc_ccc18d
                 END RECORD

DEFINE g_wc            STRING

 
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_argv1         LIKE tc_ool_file.tc_ool01 
DEFINE g_argv2         LIKE type_file.chr30
DEFINE g_argv3         LIKE type_file.chr30
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_sql           STRING 
DEFINE g_gec07         LIKE gec_file.gec07 
DEFINE l_ac            LIKE type_file.num5
DEFINE g_rec_b         LIKE type_file.num5 
DEFINE l_prog          LIKE type_file.chr30
DEFINE g_forupd_sql    STRING
DEFINE g_before_input_done   LIKE type_file.num5

MAIN

   DEFINE       l_sl   LIKE type_file.num5       #No.FUN-690026 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580ET 088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074

    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW cxmq100_w AT p_row,p_col
         WITH FORM "cxc/42f/cxcq100"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init() 

   CALL q100_q() 
   CALL q100_menu()

    CLOSE WINDOW cxmq100_w
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    RETURNING g_time    #No.FUN-6A0074
END MAIN
  
 
FUNCTION q100_menu() 
   WHILE TRUE
      CALL q100_bp("G")  
      CASE g_action_choice    
         WHEN "query"        
           CALL q100_q()        
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ccc),'','')
            END IF
         
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q100_q()    
    CLEAR FORM    
    CALL g_tc_ccc.clear()
    INITIALIZE tm.* TO NULL
    INPUT BY NAME tm.tc_ccc01,tm.tc_ccc02 WITHOUT DEFAULTS   #螢幕上取條件
      AFTER INPUT
        IF cl_null(tm.tc_ccc01) OR cl_null(tm.tc_ccc02) THEN
           CONTINUE INPUT 
        END IF
 
      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()  

      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()  
 
      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()  
 
      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
    END INPUT   
    CONSTRUCT g_wc ON tc_ccc03,tc_ccc04                   # 螢幕上取條件  #huanglf161104         
        FROM s_tc_ccc[1].tc_ccc03,s_tc_ccc[1].tc_ccc04     
        BEFORE CONSTRUCT
          CALL cl_qbe_init()
       
        ON ACTION controlp
           CASE
              WHEN INFIELD(tc_ccc04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_ccc04
                 NEXT FIELD tc_ccc04              
              OTHERWISE
                 EXIT CASE
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q100_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION q100_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_i       LIKE type_file.num5
DEFINE l_rec_b   LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sql STRING 
DEFINE p_wc2  STRING

 IF cl_null(p_wc2) THEN
    LET p_wc2 = "1=1" 
 END IF 
 LET l_i=1 
 LET l_sql = " SELECT tc_ccc03,tc_ccc04,ima02,ima021,tc_ccc05,tc_ccc06,tc_ccc08,tc_ccc08a,",
             " tc_ccc08b,tc_ccc08c,tc_ccc08d,tc_ccc09,tc_ccc09a,tc_ccc09b,tc_ccc09c,tc_ccc09d,",
             " tc_ccc09e,tc_ccc11,tc_ccc11a,tc_ccc11b,tc_ccc11c,tc_ccc11d,tc_ccc12,tc_ccc12a,",
             " tc_ccc12b,tc_ccc17,tc_ccc18,tc_ccc18a,tc_ccc18b,tc_ccc18c,tc_ccc18d ",
             " FROM tc_ccc_file,ima_file WHERE ",p_wc2 CLIPPED," AND tc_ccc04 = ima01",
             " AND tc_ccc01 = ",tm.tc_ccc01," AND tc_ccc02=",tm.tc_ccc02,
             " ORDER BY tc_ccc04" 
 PREPARE sel_omf1_pre FROM l_sql
 DECLARE sel_omf1_cur CURSOR FOR sel_omf1_pre
 FOREACH sel_omf1_cur INTO g_tc_ccc[l_i].*
   LET  l_i=l_i+1
 END FOREACH
END FUNCTION

 FUNCTION q100_bp(p_ud)
 DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ccc TO s_tc_ccc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()
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

      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
         
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                           #No.FUN-6B0032
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
      
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
