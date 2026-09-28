DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm          RECORD
               #wc   LIKE type_file.chr1000, # Head Where condition  #No.FUN-690026 VARCHAR(500)   #MOD-B90146 mark
               #wc2  LIKE type_file.chr1000  # Body Where condition  #No.FUN-690026 VARCHAR(500)   #MOD-B90146 mark
                wc   STRING,                 #MOD-B90146
                wc2  STRING                  #MOD-B90146
                END RECORD
DEFINE l_count   LIKE type_file.num5
DEFINE l_sql     STRING
DEFINE g_sfv_1   DYNAMIC ARRAY OF RECORD
        sfv04    LIKE sfv_file.sfv04,   #料号
        ima02    LIKE ima_file.ima02,   #品名
        ima021   LIKE ima_file.ima021,  #规格
        sum_sfv09 LIKE sfv_file.sfv09       #数量合计
                 END RECORD

DEFINE g_wc            STRING
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_argv1         LIKE sfv_file.sfv01
DEFINE g_argv2         LIKE gec_file.gec07 
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_sfv00         LIKE sfv_file.sfv01   #add by huanglf161114
DEFINE g_sfv07         LIKE sfv_file.sfv07
DEFINE g_sql           STRING 
DEFINE g_gec07         LIKE gec_file.gec07 
DEFINE l_ac            LIKE type_file.num5
DEFINE g_rec_b         LIKE type_file.num5 
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0084
   DEFINE       l_sl   LIKE type_file.num5       #No.FUN-690026 SMALLINT
 
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
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580ET 088  HCN 20050818  #No.FUN-6A0084
         RETURNING g_time    #No.FUN-6A0084

    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW cxmq008_w AT p_row,p_col
         WITH FORM "cxm/42f/cxmq008"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
  LET g_argv1 = ARG_VAL(1)
  LET g_argv2 = ARG_VAL(2)
 IF NOT cl_null(g_argv1) THEN 
   LET g_sfv00 = g_argv1
   LET g_gec07 = g_argv2
   CALL q008_q()
 END IF  
   CALL q008_menu()

    CLOSE WINDOW cxmq008_w
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0084
    RETURNING g_time    #No.FUN-6A0084
END MAIN
  
 
FUNCTION q008_menu()
 
   WHILE TRUE
      CALL q008_bp("G")
      CASE g_action_choice
         WHEN "query"
         IF cl_null(g_argv1) THEN 
               CALL q008_q()
         END IF 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfv_1),'','')
            END IF
         
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION q008_q()    
    CLEAR FORM
    CALL g_sfv_1.clear()
    IF NOT cl_null(g_argv1) THEN 
      LET g_wc = "1=1"
    ELSE 
     CONSTRUCT g_wc ON                     # 螢幕上取條件  #huanglf161104
        sfv04,ima02,ima021 
        FROM s_sfv_1[1].sfv04,s_sfv_1[1].ima02,s_sfv_1[1].ima021
        BEFORE CONSTRUCT
          CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(sfv11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima00"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfv04
                 NEXT FIELD sfv04
              
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
    END IF 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q008_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION q008_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_i       LIKE type_file.num5
DEFINE l_rec_b   LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sfv11   LIKE sfv_file.sfv11,
       l_sfv13   LIKE sfv_file.sfv13,
       l_sfv18   LIKE sfv_file.sfv18,
       l_flag    LIKE type_file.chr1,
       t_azi04   LIKE azi_file.azi04
DEFINE  l_sum1   LIKE sfv_file.sfv09
DEFINE l_sql1 STRING 
DEFINE p_wc2  STRING
 IF cl_null(p_wc2) THEN
    LET p_wc2 = "1=1" 
 END IF 
 
 LET l_sql1 = "SELECT sfv04,ima02,ima021,sum(sfv09) FROM 
               sfv_file,sfu_file,ima_file 
               WHERE sfv01 = '",g_sfv00,"' ",
               " AND sfv04=ima01 AND sfv01=sfu01 AND  ",p_wc2 CLIPPED, 
               " GROUP BY sfv04,ima02,ima021"
 PREPARE sel_sfv1_pre FROM l_sql1
 DECLARE sel_sfv1_cur CURSOR FOR sel_sfv1_pre
 LET l_i=1
 LET l_sum1=0
 FOREACH sel_sfv1_cur INTO g_sfv_1[l_i].*


    LET l_sum1=l_sum1+g_sfv_1[l_i].sum_sfv09
    LET l_i=l_i+1
          

 END FOREACH 
  DISPLAY l_sum1 TO FORMONLY.sum1

  
 


END FUNCTION

 FUNCTION q008_bp(p_ud)
 DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfv_1 TO s_sfv_1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
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
 
