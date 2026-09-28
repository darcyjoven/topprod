DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)

type sfv record
   sfu01    like sfu_file.sfu01,
   sfu02    like sfu_file.sfu02,
   sfv03    like sfv_file.sfv03,
   sfv20    like sfv_file.sfv20,
   sfv04    like sfv_file.sfv04,
   ima02    like ima_file.ima02,
   ima021   like ima_file.ima021,
   sfv08    like sfv_file.sfv08,
   sfv09    like sfv_file.sfv09,
   sfv05    like sfv_file.sfv05,
   sfv06    like sfv_file.sfv06,
   sfv07    like sfv_file.sfv07,
   sfv12    like sfv_file.sfv12
end record
DEFINE
    tm          RECORD 
                wc   STRING,                 #MOD-B90146
                wc2  STRING                  #MOD-B90146
                END RECORD,
    g_sfv       DYNAMIC ARRAY OF sfv,
    l_ac        LIKE type_file.num5,
    g_sfv03     LIKE qcs_file.qcs03,
    g_qcu04     LIKE qcu_file.qcu04,
    g_qct08     LIKE qct_file.qct08,
    g_argv1     LIKE imd_file.imd01,      #INPUT ARGUMENT - 1
    g_sql       string,                   #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b     LIKE type_file.num5       #單身筆數  #No.FUN-690066 SMALLINT
DEFINE g_wc            STRING
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690066 SMALLINT
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690066 INTEGER
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690066 VARCHAR(72)
 
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690066 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690066 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690066 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690066 SMALLINT
define g_amt           DECIMAL(20,3) 
MAIN
#     DEFINE   l_time LIKE type_file.chr8     #No.FUN-6A0074
   DEFINE       l_sl   LIKE type_file.num5       #No.FUN-690066 SMALLINT
 
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
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580ET 088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074

    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW csfq036_w AT p_row,p_col
         WITH FORM "csf/42f/csfq036"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL csfq036_q() 
    CALL csfq036_menu()
    CLOSE WINDOW csfq036_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
  
 
FUNCTION csfq036_menu()
 
   WHILE TRUE
      CALL csfq036_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL csfq036_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0006
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfv),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

 
FUNCTION csfq036_q()    
    CLEAR FORM
    CALL g_sfv.clear()
     CONSTRUCT g_wc ON                     
        sfu01,sfv20,sfv04,sfv05,sfv06,sfv07
        FROM s_sfv[1].sfu01,s_sfv[1].sfv20,s_sfv[1].sfv04,s_sfv[1].sfv05,s_sfv[1].sfv06,s_sfv[1].sfv07

        BEFORE CONSTRUCT
           CALL cl_qbe_init()

        ON ACTION controlp
           CASE
              WHEN INFIELD(sfu01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfu"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfu01
                 NEXT FIELD sfu01

              WHEN INFIELD(sfv20)
                  CALL q_shm2(TRUE,TRUE,'','')
                        RETURNING g_sfv[1].sfv20
                  DISPLAY BY NAME g_sfv[1].sfv20
                  NEXT FIELD sfv20
               
               WHEN INFIELD(sfv04)
                  CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima01_2"
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL csfq036_b_fill(g_wc)
END FUNCTION
 
 
FUNCTION csfq036_b_fill(p_wc2)              #BODY FILL UP
  #DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690066 VARCHAR(1000)   #MOD-B90146 mark
   DEFINE l_sql     STRING
   DEFINE l_sql1    STRING
   DEFINE p_wc2  STRING
   DEFINE l_qcs03  LIKE qcs_file.qcs03
   DEFINE l_qce03  LIKE qce_file.qce03
   DEFINE l_qcs09  LIKE qcs_file.qcs09
   DEFINE l_qcu04  LIKE qcu_file.qcu04
   DEFINE l_n      LIKE type_file.num5
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_str   STRING
   DEFINE l_chr   LIKE type_file.chr20
   DEFINE l_tc_shb06  LIKE tc_shb_file.tc_shb06
   DEFINE l_sfb08  LIKE sfb_file.sfb08
   define l_now   string

   LET l_sql = " select sfu01,sfu02,sfv03,sfv20,sfv04,ima02,ima021,sfv08,sfv09,sfv05,sfv06,sfv07,sfv12 ",
               "   from sfu_file,sfv_file,ima_file,tlf_file",
               "  where sfu01 = sfv01 and sfv04 = ima01 ",
               "    and sfupost = 'Y' and tlf905=  sfu01 and tlf906 = sfv03 ",
               "    and ",p_wc2
               
   let l_now = current hour to second 
   if l_now < "08:00" then
      # 如果小于8.00
      let l_sql = l_sql , "  and ((tlf07 = trunc(sysdate) -1 and tlf08 >= '08:00') or",
                          "       (tlf07 = trunc(sysdate) and tlf08 < '08:00' ))"
   else
      let l_sql = l_sql , "  and tlf07 = trunc(sysdate) and tlf08 >= '08:00'"
   end if
   let l_sql = l_sql , "  order by sfu01,sfu02,sfv03,sfv04 "

    PREPARE csfq036_pb FROM l_sql    
    DECLARE csfq036_bcs CURSOR FOR csfq036_pb
    CALL g_sfv.clear()
    LET g_cnt = 1
    let g_amt = 0 
    FOREACH csfq036_bcs INTO g_sfv[g_cnt].*
     
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
      
      let g_amt = g_amt + g_sfv[g_cnt].sfv09
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1 
    END FOREACH
    CALL g_sfv.deleteElement(g_cnt)      #No:MMOD-810252 add
    LET g_rec_b=g_cnt-1                  #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2
    display g_amt to amt
END FUNCTION
 
FUNCTION csfq036_bp(p_ud)
 DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfv TO s_sfv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         display l_ac to cnt
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
         
      ON ACTION exporttoexcel       #FUN-4B0065
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
 
