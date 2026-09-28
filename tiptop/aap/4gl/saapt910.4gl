# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: saapt910.4gl
# Descriptions...: 費用分攤作業
# Date & Author..: NO.FUN-C70093 12/07/24 BY minpp
# Modify.........: No.TQC-CA0027 12/10/11 By lujh t910_aqb02( 此FUNCTION中對會計年期的檢查有問題,應放在賬款日期取出來值之後再做檢查,現在檢查不到年期
# Modify.........: No.FUN-C90126 12/10/16 By xuxz 目的批次開窗，目的賬款可多次分攤
# Modify.........: No.FUN-CA0100 12/10/17 By minpp 1.目的单身，分摊后金额-分摊前金额=分摊金额，加栏位名称
# .................................................2.修改目的类型为入库时的金额取值 
# Modify.........: No.FUN-D10142 13/01/31 By yangtt 帳款目的單身的賬款編號開窗中添加供應商編號和簡稱apa06和apa07
# Modify.........: No:FUN-D20035 13/02/20 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:MOD-D30224 13/03/28 By Alberti  l_aqc08 未給予預設值與判斷如為 null 給予 0
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/22 By lixiang 修改FUN-D30032 BUG
# Modify.........: No.MOD-D80200 13/08/29 By yinhy 單價和本幣金額做截位處理

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_azi           RECORD LIKE azi_file.*,       #原幣幣別 record
    g_apa           RECORD LIKE apa_file.*,       #付款單   (假單頭)
    g_aqa           RECORD LIKE aqa_file.*,       #付款單   (假單頭)
    g_aqa_t         RECORD LIKE aqa_file.*,       #付款單   (舊值)
    g_aqa_o         RECORD LIKE aqa_file.*,       #付款單   (舊值)
    g_aqa01_t       LIKE aqa_file.aqa01,   # Pay No.     (舊值)
    g_aqb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aqb02           LIKE aqb_file.aqb02,
        apa02           LIKE apa_file.apa02,
        apa51           LIKE apa_file.apa51,
        apa511          LIKE apa_file.apa511, 
        apa06           LIKE apa_file.apa06,
        apa07           LIKE apa_file.apa07,
        aqb03           LIKE aqb_file.aqb03,
        aqb04           LIKE aqb_file.aqb04,
        aqbud01 LIKE aqb_file.aqbud01,
        aqbud02 LIKE aqb_file.aqbud02,
        aqbud03 LIKE aqb_file.aqbud03,
        aqbud04 LIKE aqb_file.aqbud04,
        aqbud05 LIKE aqb_file.aqbud05,
        aqbud06 LIKE aqb_file.aqbud06,
        aqbud07 LIKE aqb_file.aqbud07,
        aqbud08 LIKE aqb_file.aqbud08,
        aqbud09 LIKE aqb_file.aqbud09,
        aqbud10 LIKE aqb_file.aqbud10,
        aqbud11 LIKE aqb_file.aqbud11,
        aqbud12 LIKE aqb_file.aqbud12,
        aqbud13 LIKE aqb_file.aqbud13,
        aqbud14 LIKE aqb_file.aqbud14,
        aqbud15 LIKE aqb_file.aqbud15
                    END RECORD,
    g_aqb_t         RECORD                 #程式變數 (舊值)
        aqb02           LIKE aqb_file.aqb02,
        apa02           LIKE apa_file.apa02,
        apa51           LIKE apa_file.apa51,
        apa511          LIKE apa_file.apa511, 
        apa06           LIKE apa_file.apa06,
        apa07           LIKE apa_file.apa07,
        aqb03           LIKE aqb_file.aqb03,
        aqb04           LIKE aqb_file.aqb04,
        aqbud01 LIKE aqb_file.aqbud01,
        aqbud02 LIKE aqb_file.aqbud02,
        aqbud03 LIKE aqb_file.aqbud03,
        aqbud04 LIKE aqb_file.aqbud04,
        aqbud05 LIKE aqb_file.aqbud05,
        aqbud06 LIKE aqb_file.aqbud06,
        aqbud07 LIKE aqb_file.aqbud07,
        aqbud08 LIKE aqb_file.aqbud08,
        aqbud09 LIKE aqb_file.aqbud09,
        aqbud10 LIKE aqb_file.aqbud10,
        aqbud11 LIKE aqb_file.aqbud11,
        aqbud12 LIKE aqb_file.aqbud12,
        aqbud13 LIKE aqb_file.aqbud13,
        aqbud14 LIKE aqb_file.aqbud14,
        aqbud15 LIKE aqb_file.aqbud15
                    END RECORD,
    g_aqc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aqc02           LIKE aqc_file.aqc02,
        aqc03           LIKE aqc_file.aqc03,
        aqc09           LIKE aqc_file.aqc09,
        ima02           LIKE ima_file.ima02,
        aqc11           LIKE aqc_file.aqc11,
        aag02           LIKE aag_file.aag02,
        aqc111          LIKE aqc_file.aqc111,
        aag02_1         LIKE aag_file.aag02,
        aqc04           LIKE aqc_file.aqc04,
        aqc05           LIKE aqc_file.aqc05,
        aqc06           LIKE aqc_file.aqc06,
        aqc07           LIKE aqc_file.aqc07,
        aqc08           LIKE aqc_file.aqc08,
        aqcud01 LIKE aqc_file.aqcud01,
        aqcud02 LIKE aqc_file.aqcud02,
        aqcud03 LIKE aqc_file.aqcud03,
        aqcud04 LIKE aqc_file.aqcud04,
        aqcud05 LIKE aqc_file.aqcud05,
        aqcud06 LIKE aqc_file.aqcud06,
        aqcud07 LIKE aqc_file.aqcud07,
        aqcud08 LIKE aqc_file.aqcud08,
        aqcud09 LIKE aqc_file.aqcud09,
        aqcud10 LIKE aqc_file.aqcud10,
        aqcud11 LIKE aqc_file.aqcud11,
        aqcud12 LIKE aqc_file.aqcud12,
        aqcud13 LIKE aqc_file.aqcud13,
        aqcud14 LIKE aqc_file.aqcud14,
        aqcud15 LIKE aqc_file.aqcud15
 
                    END RECORD,
    g_aqc_t         RECORD
        aqc02           LIKE aqc_file.aqc02,
        aqc03           LIKE aqc_file.aqc03,
        aqc09           LIKE aqc_file.aqc09,
        ima02           LIKE ima_file.ima02,
        aqc11           LIKE aqc_file.aqc11,
        aag02           LIKE aag_file.aag02,
        aqc111          LIKE aqc_file.aqc111,
        aag02_1         LIKE aag_file.aag02,
        aqc04           LIKE aqc_file.aqc04,
        aqc05           LIKE aqc_file.aqc05,
        aqc06           LIKE aqc_file.aqc06,
        aqc07           LIKE aqc_file.aqc07,
        aqc08           LIKE aqc_file.aqc08,
        aqcud01 LIKE aqc_file.aqcud01,
        aqcud02 LIKE aqc_file.aqcud02,
        aqcud03 LIKE aqc_file.aqcud03,
        aqcud04 LIKE aqc_file.aqcud04,
        aqcud05 LIKE aqc_file.aqcud05,
        aqcud06 LIKE aqc_file.aqcud06,
        aqcud07 LIKE aqc_file.aqcud07,
        aqcud08 LIKE aqc_file.aqcud08,
        aqcud09 LIKE aqc_file.aqcud09,
        aqcud10 LIKE aqc_file.aqcud10,
        aqcud11 LIKE aqc_file.aqcud11,
        aqcud12 LIKE aqc_file.aqcud12,
        aqcud13 LIKE aqc_file.aqcud13,
        aqcud14 LIKE aqc_file.aqcud14,
        aqcud15 LIKE aqc_file.aqcud15
                    END RECORD,
    g_aps           RECORD LIKE aps_file.*,
    g_wc,g_wc2      STRING,                    
    g_wc3,g_wc4           STRING,                    
    g_sql,g_sql1    STRING,                    
    g_rec_b,g_rec_b2    LIKE type_file.num5,            
    m_aqa           RECORD LIKE aqa_file.*,
    m_aqb           RECORD LIKE aqb_file.*,
    m_aqc           RECORD LIKE aqc_file.*,
    g_buf           LIKE type_file.chr1000,             
    g_aptype        LIKE type_file.chr2,       
    g_dbs_nm        LIKE type_file.chr21,       
    g_net           LIKE apv_file.apv04,  
    g_aqa03         LIKE aqa_file.aqa03,  
    g_tot1          LIKE type_file.num20_6,     
    g_tot2          LIKE type_file.num20_6,     
    g_tot3          LIKE type_file.num20_6,    
    g_tot4          LIKE type_file.num20_6,     
    g_tot5          LIKE type_file.num20_6,     
    g_tot           LIKE type_file.num20_6,     
    g_apa51         LIKE apa_file.apa51,
    g_statu         LIKE type_file.chr1,        
    gl_no_b         LIKE abb_file.abb01,      
    gl_no_e         LIKE abb_file.abb01,     
    g_note_days     LIKE type_file.num5,                 #最大票期
    g_add           LIKE type_file.chr1,                 #是否為 Add Mode
    g_t1            LIKE oay_file.oayslip,               #單別  
    g_dbs_gl        LIKE type_file.chr21,                #工廠編號
    g_argv1         LIKE aqa_file.aqa01,                 #付款單號
    g_argv2         STRING,                
    g_argv3         STRING,               
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT
    l_ac2           LIKE type_file.num5,          
    i               LIKE type_file.num5                 #目前處理的SCREEN LINE  
DEFINE g_add_entry  LIKE type_file.chr1        
DEFINE g_system         LIKE type_file.chr2        
DEFINE g_zero           LIKE type_file.num20_6     
DEFINE g_N              LIKE type_file.chr1        
DEFINE g_y              LIKE type_file.chr1       
DEFINE l_table      STRING                        
DEFINE l_table1     STRING                       
DEFINE g_aqc10      LIKE aqc_file.aqc10
DEFINE g_aqc10_t    LIKE aqc_file.aqc10
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5     
DEFINE   g_msg           LIKE type_file.chr1000 
DEFINE   g_row_count    LIKE type_file.num10   
DEFINE   g_curs_index   LIKE type_file.num10   
DEFINE   g_jump         LIKE type_file.num10  
DEFINE   mi_no_ask      LIKE type_file.num5    
DEFINE  g_str           STRING    
DEFINE  g_wc_gl         STRING         
DEFINE  g_flag1          LIKE  type_file.chr1    
DEFINE  g_void          LIKE type_file.chr1 
DEFINE g_bookno1        LIKE aza_file.aza81                                                                       
DEFINE g_bookno2        LIKE aza_file.aza82                                                                         
DEFINE g_bookno3        LIKE aza_file.aza82    
DEFINE g_flag           LIKE type_file.chr1
DEFINE g_b_flag         LIKE type_file.num5       
 
FUNCTION t910(p_argv1,p_argv2,p_argv3)    
DEFINE p_row,p_col    LIKE type_file.num5    
DEFINE
   p_type        LIKE type_file.chr2,        
   p_plant       LIKE type_file.chr20,       
   l_dbs         LIKE type_file.chr21,       
   p_argv1       LIKE aqa_file.aqa01,
   p_argv2       STRING,          
   p_argv3       STRING          
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_sql="aqa01.aqa_file.aqa01,aqa02.aqa_file.aqa02,aqa03.aqa_file.aqa03,",
             "aqa05.aqa_file.aqa05,apa00.apa_file.apa00,apa01.apa_file.apa01,",
             "apa02.apa_file.apa02,apa51.apa_file.apa51,apa06.apa_file.apa06,",
             "apa07.apa_file.apa07,aqb03.aqb_file.aqb03,aqb04.aqb_file.aqb04,",
             "aqb01.aqb_file.aqb01,aqb02.aqb_file.aqb02"
 #  LET l_table = cl_prt_temptable('aapt910',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    
      EXIT PROGRAM 
   END IF
 
   LET g_sql="aqc01.aqc_file.aqc01,aqc02.aqc_file.aqc02,aqc03.aqc_file.aqc03,",
             "apb12.apb_file.apb12,aqc05.aqc_file.aqc05,aqc04.aqc_file.aqc04,",
             "aqc06.aqc_file.aqc06,aqc07.aqc_file.aqc07,aqc08.aqc_file.aqc08"
 #  LET l_table1 = cl_prt_temptable('aapt9101',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    
      EXIT PROGRAM 
   END IF
 
   LET g_argv1 = p_argv1          
   LET g_argv2 = p_argv2          
   LET g_argv3 = p_argv3         
 
   LET g_forupd_sql = "SELECT * FROM aqa_file WHERE aqa01 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t910_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET g_aptype = '41'
   LET g_add_entry='N'
 
   LET p_row = 1 LET p_col = 8
   OPEN WINDOW t910_w33 AT p_row,p_col WITH FORM "aap/42f/aapt910"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    IF g_aza.aza63 = 'N' THEN #不使用多帳套
       CALL cl_set_comp_visible("apa511",FALSE)
       CALL cl_set_comp_visible("aqc111,aag02_1",FALSE)
       CALL cl_set_act_visible("entry_sheet2",FALSE)
    ELSE
       CALL cl_set_comp_visible("apa511",TRUE)
       CALL cl_set_comp_visible("aqc111,aag02_1",TRUE)
       CALL cl_set_act_visible("entry_sheet2",TRUE)
    END IF
  
    CALL cl_set_comp_visible("aqbud01,aqbud02,aqbud03,aqbud04,aqbud05,aqbud06,
                              aqbud07,aqbud08,aqbud09,aqbud10,aqbud11,aqbud12,aqbud13,
                              aqbud14,aqbud15",FALSE) 
    CALL cl_set_comp_visible("aqcud01,aqcud02,aqcud03,aqcud04,aqcud05,aqcud06,
                              aqcud07,aqcud08,aqcud09,aqcud10,aqcud11,aqcud12,aqcud13,
                              aqcud14,aqcud15",FALSE)  
    CALL t910_show0()
    IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv3) THEN   #TQC-750121
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t910_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t910_a()
            END IF
         OTHERWISE
            CALL t910_q()
      END CASE
   END IF
   WHILE TRUE
     LET g_action_choice = ""
     CALL t910_menu()
     IF g_action_choice = 'exit' THEN EXIT WHILE END IF
   END WHILE
   CLOSE WINDOW t910_w33
END FUNCTION
 
FUNCTION t910_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
   CLEAR FORM                             #清除畫面
   CALL g_aqb.clear()
   CALL g_aqc.clear()
 
    IF NOT cl_null(g_argv3) THEN
       LET g_wc = g_argv3
       LET g_wc2=" 1=1 "
       LET g_wc3=" 1=1 "  
    ELSE  
       IF g_argv1<>' ' THEN
          LET g_wc=" aqa01='",g_argv1,"'"
          LET g_wc2=" 1=1 "
          LET g_wc3=" 1=1 "   
       ELSE
          CALL cl_set_head_visible("","YES")     	
          INITIALIZE g_aqa.* TO NULL
          INITIALIZE g_aqc10 TO NULL 
          DIALOG ATTRIBUTES(UNBUFFERED)     
          CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
              aqa01, aqa02, aqainpd, aqa04, aqaconf, aqauser, 
              aqagrup, aqamodu, aqadate, aqaacti,
              aqaud01,aqaud02,aqaud03,aqaud04,aqaud05,
              aqaud06,aqaud07,aqaud08,aqaud09,aqaud10,
              aqaud11,aqaud12,aqaud13,aqaud14,aqaud15
            BEFORE CONSTRUCT
             CALL cl_qbe_init()
          END CONSTRUCT
 
          CONSTRUCT g_wc2 ON aqb02 
                        ,aqbud01,aqbud02,aqbud03,aqbud04,aqbud05
                        ,aqbud06,aqbud07,aqbud08,aqbud09,aqbud10
                        ,aqbud11,aqbud12,aqbud13,aqbud14,aqbud15
                    FROM s_aqb[1].aqb02
                        ,s_aqb[1].aqbud01,s_aqb[1].aqbud02,s_aqb[1].aqbud03,s_aqb[1].aqbud04,s_aqb[1].aqbud05
                        ,s_aqb[1].aqbud06,s_aqb[1].aqbud07,s_aqb[1].aqbud08,s_aqb[1].aqbud09,s_aqb[1].aqbud10
                        ,s_aqb[1].aqbud11,s_aqb[1].aqbud12,s_aqb[1].aqbud13,s_aqb[1].aqbud14,s_aqb[1].aqbud15
 
           	BEFORE CONSTRUCT
           	   CALL cl_qbe_display_condition(lc_qbe_sn)
             
          END CONSTRUCT

          CONSTRUCT g_wc3 ON aqc10,aqc02,aqc09,aqc11,aqc111 
                        ,aqcud01,aqcud02,aqcud03,aqcud04,aqcud05
                        ,aqcud06,aqcud07,aqcud08,aqcud09,aqcud10
                        ,aqcud11,aqcud12,aqcud13,aqcud14,aqcud15
                    FROM aqc10,s_aqc[1].aqc02,s_aqc[1].aqc09,s_aqc[1].aqc11,s_aqc[1].aqc111
                        ,s_aqc[1].aqcud01,s_aqc[1].aqcud02,s_aqc[1].aqcud03,s_aqc[1].aqcud04,s_aqc[1].aqcud05
                        ,s_aqc[1].aqcud06,s_aqc[1].aqcud07,s_aqc[1].aqcud08,s_aqc[1].aqcud09,s_aqc[1].aqcud10
                        ,s_aqc[1].aqcud11,s_aqc[1].aqcud12,s_aqc[1].aqcud13,s_aqc[1].aqcud14,s_aqc[1].aqcud15
             BEFORE CONSTRUCT
                CALL cl_qbe_display_condition(lc_qbe_sn)
            END CONSTRUCT
        
          ON ACTION controlp
                CASE
                   WHEN INFIELD(aqa01) #查詢單据
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_aqa1"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO aqa01

                   WHEN INFIELD(aqb02)
                      CALL cl_init_qry_var()
                      CALL q_apa6(TRUE,TRUE,'aapt910',g_aqb[1].aqb02,l_ac,g_rec_b) RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO aqb02
                      NEXT FIELD aqb02
                   WHEN INFIELD(aqc02)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_aqc"                             #FUN-D10142
                      LET g_qryparam.default1 = g_aqc[1].aqc02                 #FUN-D10142
                      CALL cl_create_qry() RETURNING g_qryparam.multiret       #FUN-D10142
                     #CALL q_aqc1(TRUE,TRUE,'') RETURNING g_qryparam.multiret  #FUN-D10142
                      DISPLAY g_qryparam.multiret TO aqc02
                   OTHERWISE
                      EXIT CASE
                END CASE     
          
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
            
         ON ACTION accept
            EXIT DIALOG

        ON ACTION qbe_save
           CALL cl_qbe_save()


         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION cancel
            LET INT_FLAG = TRUE 
            EXIT DIALOG
      END DIALOG
      
       END IF
    END IF 
    
    IF cl_null(g_wc2) THEN
      LET g_wc2 =' 1=1'
   END IF
   IF cl_null(g_wc3) THEN
      LET g_wc3 =' 1=1'
   END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aqauser', 'aqagrup') 
    
    IF g_wc3 = " 1=1" THEN                           # 若單身未輸入條件   #CHI-B20013 add
       IF g_wc2 = " 1=1" THEN                           # 若單身未輸入條件
          LET g_sql = "SELECT aqa01 FROM aqa_file ",
                      " WHERE ", g_wc CLIPPED,
                      "   AND  aqa00='2' ", 
                      " ORDER BY 1"
       ELSE                                        # 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE aqa01 ",
                      "  FROM aqa_file, aqb_file ",
                      " WHERE aqa01 = aqb01",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                      "   AND aqa00='2' ",
                      " ORDER BY 1"
       END IF
    ELSE
       IF g_wc2 = " 1=1" THEN                           # 若單身未輸入條件
          LET g_sql = "SELECT UNIQUE aqa01 ",
                      "  FROM aqa_file, aqc_file ",
                      " WHERE aqa01 = aqc01",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                      "   AND aqa00= '2'",
                      " ORDER BY 1"
       ELSE                                        # 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE aqa01 ",
                      "  FROM aqa_file, aqb_file, aqc_file",
                      " WHERE aqa01 = aqb01",
                      "   AND aqa01 = aqc01",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED,
                      "   AND aqa00='2' ",
                      " ORDER BY 1"
       END IF
    END IF
 
    PREPARE t910_prepare FROM g_sql
    DECLARE t910_cs                        #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t910_prepare
 
    IF g_wc3 = " 1=1" THEN                         # 取合乎條件筆數   #CHI-B20013 add
       IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
          LET g_sql="SELECT COUNT(*) FROM aqa_file WHERE ",g_wc CLIPPED,
                                                    "AND aqa00='2'  "
       ELSE
          LET g_sql="SELECT COUNT(DISTINCT aqa01) FROM aqa_file,aqb_file WHERE ",
                    "aqb01=aqa01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    " AND aqa00='2'  "
       END IF
    ELSE
       IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
          LET g_sql="SELECT COUNT(DISTINCT aqa01) FROM aqa_file,aqc_file WHERE ",
                    "aqc01=aqa01 AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED,
                    " AND aqa00='2'  "
       ELSE
          LET g_sql="SELECT COUNT(DISTINCT aqa01) FROM aqa_file,aqb_file,aqc_file WHERE ",
                    "aqb01=aqa01 AND aqc01=aqa01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED,
                    " AND aqa00='2'  "
       END IF
    END IF
    PREPARE t910_precount FROM g_sql
    DECLARE t910_count CURSOR FOR t910_precount
END FUNCTION
 
FUNCTION t910_menu()
 
   WHILE TRUE
      CALL t910_bp("G")
      CASE g_action_choice
         WHEN "insert"
            LET g_add = 'Y'
            IF cl_chk_act_auth() THEN
               CALL t910_a()
            END IF
            LET g_add = NULL
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t910_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t910_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t910_u()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t910_o()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "detail"
           IF cl_chk_act_auth() THEN 
              CALL t910_b()
              IF g_action_choice != 'detail' THEN  #FUN-D30032 add
                 IF g_flag1='2' THEN
                    CALL t910_v('')
                 END IF
              END IF                              #FUN-D30032 add
           END IF    
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_aqb)
                                           ,base.TypeInfo.create(g_aqc),'')
             END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t910_y()
               IF g_aqa.aqaconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti) 
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t910_z()
               IF g_aqa.aqaconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti)  
            END IF

         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t910_x ()                   #FUN-D20035
               CALL t910_x (1)                   #FUN-D20035
               IF g_aqa.aqaconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti)
            END IF

         #FUN-D20035----add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t910_x(2)
               IF g_aqa.aqaconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti)
            END IF
         #FUN-D20035---add---end

         WHEN "apportion"                 #分攤
            IF cl_chk_act_auth() THEN
               CALL t910_s()
            END IF
         WHEN "refirm"                    #取消分攤
            IF cl_chk_act_auth() THEN
               CALL t910_t()
            END IF
         WHEN "gen_entry"                 #產生分錄
            CALL t910_v('4')
         WHEN "entry_sheet"               #分錄底稿一
            CALL s_fsgl('AP',4,g_aqa.aqa01,0,g_apz.apz02b,1,g_aqa.aqaconf,'0',g_apz.apz02p)  
            CALL t910_npp02('0')
         WHEN "entry_sheet2"              #分錄底稿二
            CALL s_fsgl('AP',4,g_aqa.aqa01,0,g_apz.apz02b,1,g_aqa.aqaconf,'1',g_apz.apz02p)  
            CALL t910_npp02('1')
         WHEN "carry_voucher"             #拋轉總帳
            IF cl_chk_act_auth() THEN
               IF g_aqa.aqaconf = 'Y' THEN
                  CALL t910_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF
            END IF
         WHEN "undo_carry_voucher"       #拋轉還原
            IF cl_chk_act_auth() THEN
               IF g_aqa.aqaconf = 'Y' THEN
                  CALL t910_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_aqa.aqa01 IS NOT NULL THEN
                 LET g_doc.column1 = "aqa01"
                 LET g_doc.value1 = g_aqa.aqa01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t910_a()
DEFINE  li_result LIKE type_file.num5    
   IF s_aapshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_aqb.clear()
   CALL g_aqc.clear()
   INITIALIZE g_aqa.* LIKE aqa_file.*             #DEFAULT 設定
   LET g_aqa01_t = NULL
   #預設值及將數值類變數清成零
   LET g_aqa.aqa00='2'           #費用分攤
   LET g_aqa.aqa02=g_today
   LET g_aqa.aqainpd=g_today
   LET g_aqa_o.* = g_aqa.*
   LET g_aqa.aqauser= g_user
   LET g_aqa.aqaoriu = g_user 
   LET g_aqa.aqaorig = g_grup 
   LET g_aqa.aqagrup= g_grup
   LET g_aqa.aqadate= g_today
   LET g_aqa.aqaacti= 'Y'             #資料有效
   LET g_aqa.aqa03  = 0
   LET g_aqa.aqa04  = 'N'
   LET g_aqa.aqaconf= 'N'             
   LET g_aqa.aqalegal= g_legal  
   LET g_note_days = 0
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t910_i("a")                #輸入單頭
      IF INT_FLAG THEN                #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_aqa.* TO NULL
         EXIT WHILE
      END IF
      IF g_aqa.aqa01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
      CALL s_auto_assign_no("aap",g_aqa.aqa01,g_aqa.aqa02,"41","aqa_file","aqa01","","","")
      RETURNING li_result,g_aqa.aqa01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_aqa.aqa01
      INSERT INTO aqa_file VALUES (g_aqa.*)
 
      IF SQLCA.sqlcode THEN                           #置入資料庫不成功
         CALL cl_err3("ins","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)  
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_aqa.aqa01,'I')
      END IF
      SELECT aqa01 INTO g_aqa.aqa01 FROM aqa_file
       WHERE aqa01 = g_aqa.aqa01
      LET g_aqa01_t = g_aqa.aqa01        #保留舊值
      LET g_aqa_t.* = g_aqa.*
      CALL g_aqb.clear()
      LET g_rec_b = 0                   
      LET g_add_entry='Y'
     #SELECT COUNT(*) INTO g_cnt FROM aqb_file WHERE aqb01 = g_aqa.aqa01
     #IF g_cnt = 0 THEN RETURN END IF
      CALL g_aqc.clear()
      LET g_rec_b2 = 0                   
      CALL t910_b()                   #輸入單身
      CALL t910_v('')
      LET g_t1=s_get_doc_no(g_aqa.aqa01)
      SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t910_u()
   IF s_aapshut(0) THEN RETURN END IF
   IF g_aqa.aqa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_aqa.* FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   IF g_aqa.aqa04 = 'Y' THEN CALL cl_err('','mfg-060',0) RETURN END IF  
   IF g_aqa.aqaconf = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
   IF g_aqa.aqaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_aqa.aqa01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_aqa01_t = g_aqa.aqa01
   LET g_aqa_o.* = g_aqa.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t910_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_aqa.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,1)      # 資料被他人LOCK
       CLOSE t910_cl
       ROLLBACK WORK RETURN
   END IF
   CALL t910_show()
   WHILE TRUE
      LET g_aqa01_t = g_aqa.aqa01
      LET g_aqa.aqamodu=g_user
      LET g_aqa.aqadate=g_today
      CALL t910_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         LET g_aqa.*=g_aqa_t.*
         CALL t910_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_aqa.aqa01 != g_aqa01_t THEN            # 更改單號
         UPDATE aqb_file SET aqb01 = g_aqa.aqa01
          WHERE aqb01 = g_aqa01_t
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN   #TQC-6B0087
            CALL cl_err3("upd","aqb_file",g_aqa01_t,"",SQLCA.sqlcode,"","aqb",1)  
            CONTINUE WHILE
         END IF
      END IF
      UPDATE aqa_file SET aqa_file.* = g_aqa.*
       WHERE aqa01 = g_aqa01_t
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN   #TQC-6B0087
         CALL cl_err3("upd","aqa_file",g_aqa01_t,"",SQLCA.sqlcode,"","",1) 
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t910_cl
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aqa.aqa01,'U')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
#處理INPUT
FUNCTION t910_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入  
    p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改  
    l_paydate       LIKE type_file.dat,    #  
    li_result   LIKE type_file.num5        
    CALL cl_set_head_visible("","YES")     		
 
    INPUT BY NAME g_aqa.aqa01,g_aqa.aqa02,g_aqa.aqainpd, g_aqa.aqaoriu,g_aqa.aqaorig,
                  g_aqa.aqa04,g_aqa.aqaconf,g_aqa.aqauser,
                  g_aqa.aqagrup,g_aqa.aqamodu,g_aqa.aqadate,g_aqa.aqaacti,
                          g_aqa.aqaud01,g_aqa.aqaud02,g_aqa.aqaud03,g_aqa.aqaud04,
                          g_aqa.aqaud05,g_aqa.aqaud06,g_aqa.aqaud07,g_aqa.aqaud08,
                          g_aqa.aqaud09,g_aqa.aqaud10,g_aqa.aqaud11,g_aqa.aqaud12,
                          g_aqa.aqaud13,g_aqa.aqaud14,g_aqa.aqaud15 
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t910_set_entry(p_cmd)
         CALL t910_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("aqa01")
         CALL cl_set_comp_entry ("aqaconf",FALSE)
        AFTER FIELD aqa01                  #帳款編號
            IF NOT cl_null(g_aqa.aqa01) THEN
                CALL s_check_no("aap",g_aqa.aqa01,g_aqa01_t,"41","aqa_file","aqa01","")
                RETURNING li_result,g_aqa.aqa01
                DISPLAY BY NAME g_aqa.aqa01
                IF (NOT li_result) THEN
                    LET g_aqa.aqa01=g_aqa_o.aqa01
                    NEXT FIELD aqa01
                END IF
           END IF
 
        AFTER FIELD aqa02                  #付款日期不可小於關帳日期
            IF NOT cl_null(g_aqa.aqa02) THEN 
               #重新抓取關帳日期
               SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
               IF g_aqa.aqa02 <= g_apz.apz57 THEN
                  CALL cl_err(g_aqa.aqa02,'aap-176',0)
               END IF
            END IF
            
          
        AFTER FIELD aqaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_aqa.aqauser = s_get_data_owner("aqa_file") 
           LET g_aqa.aqagrup = s_get_data_group("aqa_file") 
           LET l_flag='N'
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD aqa01
           END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aqa01) #查詢單据
                 LET g_t1=s_get_doc_no(g_aqa.aqa01)    
                 CALL q_apy(FALSE,FALSE,g_t1,g_aptype,'AAP') RETURNING g_t1  #TQC-670008
                 LET g_aqa.aqa01 = g_t1
                 DISPLAY BY NAME g_aqa.aqa01
                 NEXT FIELD aqa01
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about() 
 
      ON ACTION help          
         CALL cl_show_help() 
    END INPUT
END FUNCTION
 
FUNCTION t910_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aqa.* TO NULL            
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_aqb.clear()
   CALL g_aqc.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t910_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t910_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aqa.* TO NULL
   ELSE
      OPEN t910_count
      FETCH t910_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t910_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t910_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t910_cs INTO g_aqa.aqa01
      WHEN 'P' FETCH PREVIOUS t910_cs INTO g_aqa.aqa01
      WHEN 'F' FETCH FIRST    t910_cs INTO g_aqa.aqa01
      WHEN 'L' FETCH LAST     t910_cs INTO g_aqa.aqa01
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t910_cs INTO g_aqa.aqa01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      INITIALIZE g_aqa.* TO NULL  
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
   SELECT * INTO g_aqa.* FROM aqa_file WHERE aqa01 = g_aqa.aqa01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aqa_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_aqa.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_aqa.aqauser     
      LET g_data_group = g_aqa.aqagrup     
      CALL t910_show()
   END IF
END FUNCTION
 
FUNCTION t910_show()
   LET g_aqa_t.* = g_aqa.*                #保存單頭舊值
   INITIALIZE g_aqc10 TO  NULL
   SELECT aqc10 INTO g_aqc10 FROM aqc_file WHERE aqc01=g_aqa.aqa01
   DISPLAY g_aqc10 TO FORMONLY.aqc10
   CALL t910_show0()
   DISPLAY BY NAME g_aqa.aqa01,g_aqa.aqa02,g_aqa.aqa03,g_aqa.aqa04,g_aqa.aqa05, g_aqa.aqaoriu,g_aqa.aqaorig,
                   g_aqa.aqaconf,g_aqa.aqainpd,g_aqa.aqauser,
                   g_aqa.aqagrup,g_aqa.aqamodu,g_aqa.aqadate,g_aqa.aqaacti,
           g_aqa.aqaud01,g_aqa.aqaud02,g_aqa.aqaud03,g_aqa.aqaud04,
           g_aqa.aqaud05,g_aqa.aqaud06,g_aqa.aqaud07,g_aqa.aqaud08,
           g_aqa.aqaud09,g_aqa.aqaud10,g_aqa.aqaud11,g_aqa.aqaud12,
           g_aqa.aqaud13,g_aqa.aqaud14,g_aqa.aqaud15 
   CALL t910_b_fill(g_wc2)                 #單身
   CALL t910_b2_fill(g_wc3)                #單身   #CHI-B20013
   IF g_aqa.aqaconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti)  #CHI-A50028
   CALL cl_show_fld_cont()                   
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t910_r()
   IF s_aapshut(0) THEN RETURN END IF
   IF g_aqa.aqa01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   SELECT * INTO g_aqa.* FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   IF g_aqa.aqa04 = 'Y' THEN CALL cl_err('','mfg-060',1) RETURN END IF 
   IF g_aqa.aqaconf = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
   LET g_success = 'Y'
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t910_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_aqa.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t910_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          
       LET g_doc.column1 = "aqa01"         
       LET g_doc.value1 = g_aqa.aqa01      
       CALL cl_del_doc()                
      DELETE FROM aqb_file WHERE aqb01 = g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","aqb_file",g_aqa.aqa01,"",STATUS,"","del aqb:",1)  
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM aqc_file WHERE aqc01 = g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","aqc_file",g_aqa.aqa01,"",STATUS,"","del aqc:",1)
         ROLLBACK WORK  
         RETURN
      END IF
      DELETE FROM aqa_file WHERE aqa01 = g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","aqa_file",g_aqa.aqa01,"",STATUS,"","del aqa:",1)  
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM npp_file WHERE npp01=g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","npp_file",g_aqa.aqa01,"",STATUS,"","del npp:",1)  
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM npq_file WHERE npq01=g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","apq_file",g_aqa.aqa01,"",STATUS,"","del npq:",1) 
         ROLLBACK WORK
         RETURN
      END IF

      DELETE FROM tic_file WHERE tic04 = g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","tic_file",g_aqa.aqa01,"",STATUS,"","del tic:",1)
         ROLLBACK WORK
         RETURN
      END IF

      INITIALIZE g_aqa.* TO NULL
      CLEAR FORM
      CALL g_aqb.clear()
      CALL g_aqc.clear()
      OPEN t910_count
      IF STATUS THEN
         CLOSE t910_cs
         CLOSE t910_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t910_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t910_cs
         CLOSE t910_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t910_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t910_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t910_fetch('/')
      END IF
   END IF
   CLOSE t910_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aqa.aqa01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

#FUNCTION t910_x()                             #FUN-D20035
FUNCTION t910_x(p_type)                        #FUN-D20035
   DEFINE l_year,l_month  LIKE type_file.num5,
          l_flag          LIKE type_file.chr1,
          l_aqb02         LIKE aqb_file.aqb02,
          l_aqb03         LIKE aqb_file.aqb03,
          l_aqb04         LIKE aqb_file.aqb04,
          l_apa31         LIKE apa_file.apa31,
          l_apa00         LIKE apa_file.apa00,
          l_aqb04_1       LIKE aqb_file.aqb04,
          l_tot_aqb04     LIKE aqb_file.aqb04,
          l_aqc02         LIKE aqc_file.aqc02,
          l_aqc03         LIKE aqc_file.aqc03,
          l_sql           STRING        

   DEFINE p_type     LIKE type_file.chr1               #FUN-D20035
   DEFINE l_flag1    LIKE type_file.chr1               #FUN-D20035

   IF s_aapshut(0) THEN
      RETURN 
   END IF
   IF cl_null(g_aqa.aqa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_aqa.aqaconf='X' THEN 
      LET l_sql = " SELECT aqb02,aqb04 FROM aqb_file",
                  "  WHERE aqb01 = '",g_aqa.aqa01,"'"
      PREPARE t910_pre FROM l_sql
      DECLARE t910_curs CURSOR FOR t910_pre
      FOREACH t910_curs INTO l_aqb02,l_aqb04_1
         LET l_apa31 = 0
         LET l_aqb04 = 0
         SELECT apa31,apa00 INTO l_apa31,l_apa00 FROM apa_file
          WHERE apa01 = l_aqb02
          IF l_apa00 = '23' THEN          
             IF g_apz.apz27 = 'N' THEN
                SELECT apa34-apa35 INTO l_apa31
                  FROM apa_file
                 WHERE apa01 = l_aqb02
             ELSE
                SELECT apa73 INTO l_apa31
                  FROM apa_file
                 WHERE apa01 = l_aqb02
             END IF
          END IF 
          IF l_apa00 <> '23' THEN     
             SELECT SUM(aqb04) INTO l_aqb04 FROM aqa_file,aqb_file      
              WHERE aqb02 = l_aqb02
                AND aqa01 = aqb01 AND aqaconf <> 'X'                  
          ELSE
             SELECT SUM(aqb04) INTO l_aqb04 FROM aqa_file,aqb_file      
              WHERE aqb02 = l_aqb02
                AND aqa01 = aqb01 AND aqaconf = 'N' 
          END IF  
          IF cl_null(l_apa31) THEN LET l_apa31 = 0 END IF
          IF cl_null(l_aqb04) THEN LET l_aqb04 = 0 END IF 

          IF l_aqb04_1 + l_aqb04 > l_apa31 THEN
             CALL cl_err(l_aqb02,'aap-801',1)
             RETURN 
          END IF

          IF g_aqa.aqa03 IS NULL THEN
             LET g_aqa.aqa03=0
          END IF

          CALL t910_aqb04()

          SELECT SUM(aqb04) INTO l_tot_aqb04 FROM aqa_file,aqb_file    #此帳款的總分攤額   
           WHERE aqb02 = l_aqb02
             AND aqb01 <> g_aqa.aqa01
             AND aqa01 = aqb01 AND aqaconf <> 'X'   
          IF cl_null(l_tot_aqb04) THEN
             LET l_tot_aqb04=0
          END IF
          LET l_tot_aqb04 = l_tot_aqb04 + l_aqb04_1
          IF l_tot_aqb04 > l_aqb03 THEN
             CALL cl_err('','mfg-038',0)
             RETURN 
          END IF
      END FOREACH 

      LET l_sql = " SELECT aqc02,aqc03 FROM aqc_file",
                  "  WHERE aqc01 = '",g_aqa.aqa01,"'"
      PREPARE t910_pre_1 FROM l_sql
      DECLARE t910_curs_1 CURSOR FOR t910_pre_1

      FOREACH t910_curs_1 INTO l_aqc02,l_aqc03
         SELECT COUNT(*) INTO g_cnt FROM aqa_file ,aqc_file
          WHERE aqa01 = aqc01
            AND aqc02 = l_aqc02
            AND aqc03 = l_aqc03
            AND aqaconf <> 'X'             
         IF g_cnt>0 THEN
            CALL cl_err(l_aqc02,'aap-035',1) 
            RETURN 
         END IF 
      END FOREACH 
   END IF 
   
   SELECT * INTO g_aqa.* FROM aqa_file WHERE aqa01=g_aqa.aqa01
   IF g_aqa.aqaconf='Y' THEN
      CALL cl_err(g_aqa.aqa01,'anm-105',2)
      RETURN
   END IF
   SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
   IF NOT cl_null(g_aqa.aqa05) THEN
      IF NOT (g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y') THEN
         CALL cl_err(g_aqa.aqa01,'aap-618',0) 
         RETURN
      END IF
   END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_aqa.aqaconf='X' THEN RETURN END IF
   ELSE
      IF g_aqa.aqaconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   LET g_success = 'Y'
   BEGIN WORK
   OPEN t910_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_aqa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_aqa_o.* = g_aqa.*
   LET g_aqa_t.* = g_aqa.*
   CALL t910_show()
  #IF cl_void(0,0,g_aqa.aqaconf) THEN                                   #FUN-D20035
   IF p_type = 1 THEN LET l_flag1 = 'N' ELSE LET l_flag1 = 'X' END IF   #FUN-D20035
   IF cl_void(0,0,l_flag1) THEN                                         #FUN-D20035
     #IF g_aqa.aqaconf='N' THEN    #切換為作廢                          #FUN-D20035
      #作废操作时
      IF p_type = 1 THEN                                                #FUN-D20035
         DELETE FROM npp_file
          WHERE nppsys= 'AP'
            AND npp00=4
            AND npp01 = g_aqa.aqa01
            AND npp011=1
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npp_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","(t910_r:delete npp)",1)
            LET g_success='N'
         END IF
         DELETE FROM npq_file
          WHERE npqsys= 'AP'
            AND npq00=4
            AND npq01 = g_aqa.aqa01
            AND npq011=1
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npq_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","(t910_r:delete npq)",1)
            LET g_success='N'
         END IF

         DELETE FROM tic_file WHERE tic04 = g_aqa.aqa01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tic_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","(t910_r:delete tic)",1)
            LET g_success='N'
         END IF

         LET g_aqa.aqaconf='X'
      ELSE                         #取消作廢
         LET g_aqa.aqaconf='N'
      END IF
      UPDATE aqa_file SET aqaconf=g_aqa.aqaconf
       WHERE aqa01 = g_aqa.aqa01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",STATUS,"","",1)
         LET g_success='N'
      END IF
   END IF
   SELECT aqaconf INTO g_aqa.aqaconf FROM aqa_file
    WHERE aqa01 = g_aqa.aqa01
   DISPLAY BY NAME g_aqa.aqaconf
   CLOSE t910_cl
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_aqa.aqa01,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
#当aqc10='1'时才需要弹窗询问是1.电脑抓取或2.手工录入
FUNCTION t910_g_b1()
   DEFINE l_sql                 LIKE type_file.chr1000 
   DEFINE body_sw               LIKE type_file.chr1    
   DEFINE apa51                 LIKE apa_file.apa51
   DEFINE p05f,p05              LIKE type_file.num20_6 
   DEFINE l_cnt                 LIKE type_file.num10   
   DEFINE l_apa02               LIKE apa_file.apa02    
 
   IF g_aqa.aqa01 IS NULL THEN RETURN END IF
 
 
   OPEN WINDOW t910_g_b_w AT 4,24 WITH FORM "aap/42f/aapt910_2"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("aapt910_2")
   CALL cl_set_head_visible("","YES")     		
 
   INPUT BY NAME body_sw WITHOUT DEFAULTS
      AFTER FIELD body_sw
         IF NOT cl_null(body_sw) THEN
            IF body_sw NOT MATCHES "[12]" THEN
               NEXT FIELD body_sw
            END IF
         END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controlg    
         CALL cl_cmdask()     
 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t910_g_b_w
      RETURN
   END IF
 
   LET g_dbs_new = NULL
   CASE WHEN body_sw = '2'
             CLOSE WINDOW t910_g_b_w
             RETURN
        WHEN body_sw = '1'
 
 
             OPEN WINDOW t910_g_b_w2 AT 10,2 WITH FORM "aap/42f/aapt910_1"
                   ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
             CALL cl_ui_locale("aapt910_1")
             CALL cl_set_head_visible("","YES")    		
 
             CONSTRUCT BY NAME g_wc ON apa01,apa06,apa02,apb12,apb21
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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

   CALL cl_set_head_visible("","YES")     			

   INPUT BY NAME g_apa.apa51 WITHOUT DEFAULTS

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about() 
 
      ON ACTION help        
         CALL cl_show_help()  
 
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
  END INPUT
      CLOSE WINDOW t910_g_b_w2
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t910_g_b_w
         RETURN
      END IF
   END CASE
   CLOSE WINDOW t910_g_b_w
 
 
   LET l_ac2 = 1
   LET g_sql = "SELECT apb01,apb02,apb12,'',apb25,'',apb251,'',apb081,apb09,apb101,apb081,apb101,'N'",
               "  FROM apa_file,apb_file",
               " WHERE ",g_wc CLIPPED,
               "   AND apa01 = apb01",
               "   AND apa41 ='Y'",
               "   AND apaacti = 'Y'",   
               "   AND (apb34 IS NULL OR apb34 = 'N' )",   
               "   AND (apa00 = '11' OR (apa00='16' AND apb21 IS NOT NULL)) ",   
               "   AND apb08=apb081 "   
 

   IF NOT cl_null(g_apa.apa51) THEN
       LET g_sql = g_sql CLIPPED, " AND apa51 = '",g_apa.apa51,"'" 
   END IF
   LET g_sql = g_sql CLIPPED, " ORDER BY apb01,apb02"
   PREPARE t910_g_b_p1 FROM g_sql
   DECLARE t910_g_b_c1 CURSOR WITH HOLD FOR t910_g_b_p1
   FOREACH t910_g_b_c1 INTO g_aqc[l_ac2].*
      IF STATUS THEN
         CALL cl_err('for apc',STATUS,1)
         EXIT FOREACH
      END IF
      #BEGIN WORK
      LET g_success = 'Y'
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM aqa_file ,aqc_file
       WHERE aqa01=aqc01
         AND aqc02=g_aqc[l_ac2].aqc02
         AND aqc03=g_aqc[l_ac2].aqc03
         AND aqaconf <> 'X'             
      IF l_cnt>0 THEN
         CONTINUE FOREACH
      END IF
     SELECT apa02 INTO l_apa02 FROM apa_file
       WHERE apa01=g_aqc[l_ac2].aqc02
     SELECT ima02 INTO g_aqc[l_ac2].ima02 FROM ima_file 
       WHERE ima01=g_aqc[l_ac2].aqc09
     SELECT aag02 INTO g_aqc[l_ac2].aag02 FROM aag_file
      WHERE aag01 = g_aqc[l_ac2].aqc11
        AND aag01 = g_bookno1
    SELECT aag02 INTO g_aqc[l_ac2].aag02_1 FROM aag_file
      WHERE aag01 = g_aqc[l_ac2].aqc11
        AND aag01 = g_bookno2    
     #重新抓取關帳日期
     SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'
     IF (l_apa02 <= g_sma.sma53) OR (l_apa02 > g_aqa.aqa02) THEN    
        CONTINUE FOREACH
     END IF
     LET g_aqc[l_ac2].aqc04 = cl_digcut(g_aqc[l_ac2].aqc04,g_azi03)  #MOD-D80200
     LET g_aqc[l_ac2].aqc06 = cl_digcut(g_aqc[l_ac2].aqc06,g_azi04)  #MOD-D80200
     LET g_aqc[l_ac2].aqc07 = cl_digcut(g_aqc[l_ac2].aqc07,g_azi03)  #MOD-D80200
     LET g_aqc[l_ac2].aqc08 = cl_digcut(g_aqc[l_ac2].aqc08,g_azi04)  #MOD-D80200
      INSERT INTO aqc_file(aqc01,aqc02,aqc03,aqc09,aqc10,aqc11,aqc111,aqc04,aqc05,aqc06,aqc07,aqc08,
                                  aqcud01,aqcud02,aqcud03,
                                  aqcud04,aqcud05,aqcud06,
                                  aqcud07,aqcud08,aqcud09,
                                  aqcud10,aqcud11,aqcud12,
                                  aqcud13,aqcud14,aqcud15,aqclegal) 
       VALUES(g_aqa.aqa01,g_aqc[l_ac2].aqc02,g_aqc[l_ac2].aqc03,g_aqc[l_ac2].aqc09,g_aqc10,
              g_aqc[l_ac2].aqc11,g_aqc[l_ac2].aqc111,g_aqc[l_ac2].aqc04,
              g_aqc[l_ac2].aqc05,g_aqc[l_ac2].aqc06,g_aqc[l_ac2].aqc07,g_aqc[l_ac2].aqc08,
                                  g_aqc[l_ac2].aqcud01,
                                  g_aqc[l_ac2].aqcud02,
                                  g_aqc[l_ac2].aqcud03,
                                  g_aqc[l_ac2].aqcud04,
                                  g_aqc[l_ac2].aqcud05,
                                  g_aqc[l_ac2].aqcud06,
                                  g_aqc[l_ac2].aqcud07,
                                  g_aqc[l_ac2].aqcud08,
                                  g_aqc[l_ac2].aqcud09,
                                  g_aqc[l_ac2].aqcud10,
                                  g_aqc[l_ac2].aqcud11,
                                  g_aqc[l_ac2].aqcud12,
                                  g_aqc[l_ac2].aqcud13,
                                  g_aqc[l_ac2].aqcud14,
                                  g_aqc[l_ac2].aqcud15,g_legal)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","aqc_file",g_aqa.aqa01,g_aqc[l_ac2].aqc02,SQLCA.sqlcode,"","",1)  
         #ROLLBACK WORK
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      LET l_ac = l_ac + 1
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION t910_b()     #雜項
DEFINE
    l_ac_t          LIKE type_file.num5,               
    l_ac_t2         LIKE type_file.num5, 
    l_n,l_n2        LIKE type_file.num5,          
    l_cnt           LIKE type_file.num5,      
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_apa41         LIKE apa_file.apa41,
    l_tot_aqb04     LIKE aqb_file.aqb04,  
    l_tot_aqa03     LIKE aqa_file.aqa03,
    l_apa31         LIKE apa_file.apa31,   
    l_aqb04         LIKE aqb_file.aqb04,  
    l_allow_insert  LIKE type_file.num5,                #可新增否  
    l_allow_delete  LIKE type_file.num5                 #可刪除否  
DEFINE l_apa00      LIKE apa_file.apa00
DEFINE l_aqc08      LIKE aqc_file.aqc08 
DEFINE l_apa02      LIKE apa_file.apa02  
DEFINE l_aqc02      LIKE aqc_file.aqc02
DEFINE l_apb10      LIKE apb_file.apb10
DEFINE l_apb101     LIKE apb_file.apb101
DEFINE lc_qbe_sn    LIKE    gbm_file.gbm01 
DEFINE l_aqc10      LIKE aqc_file.aqc10
DEFINE l_aqb03      LIKE aqb_file.aqb03
DEFINE l_aqb04_1    LIKE aqb_file.aqb04
DEFINE l_tt,l_t     LIKE type_file.chr1000         
   #FUN-C90126-add--str
   DEFINE temp_aqc02 STRING
   DEFINE bst base.StringTokenizer
   DEFINE temptext STRING
   DEFINE l_aqc02_str STRING
   DEFINE l_aqc    RECORD LIKE aqc_file.*
   DEFINE l_errno  LIKE type_file.num10
   DEFINE l_errno2 LIKE type_file.num10
   #FUN-C90126--add--end
 
    LET g_flag1='2'
    LET g_action_choice = ""
    IF s_aapshut(0) THEN
       RETURN
    END IF
    IF g_aqa.aqa01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_aqa.* FROM aqa_file
     WHERE aqa01=g_aqa.aqa01
    IF g_aqa.aqa04 = 'Y' THEN CALL cl_err('','mfg-060',1) LET g_flag1 ='1' RETURN END IF
    IF g_aqa.aqaconf = 'Y' THEN CALL cl_err('','aap-086',1) LET g_flag1 ='1' RETURN END IF
    IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) LET g_flag1 ='1'RETURN END IF  #CHI-A50028 add
    IF g_aqa.aqaacti ='N' THEN
       CALL cl_err(g_aqa.aqa01,'9027',0)
       LET g_flag1 ='1'
       RETURN
    END IF
    CALL cl_set_comp_entry("aqc10",TRUE)     
  
    SELECT COUNT(*) INTO g_rec_b FROM aqb_file WHERE aqb01=g_aqa.aqa01
    IF g_rec_b = 0 THEN
       CALL t910_b_fill(' 1=1')
    END IF

    SELECT COUNT(*) INTO g_rec_b2 FROM aqc_file WHERE aqc01=g_aqa.aqa01
    IF g_rec_b2 = 0 THEN
       CALL t910_b2_fill(' 1=1')
    END IF 

    CALL cl_opmsg('b')
    #来源
    LET g_forupd_sql = "SELECT aqb02,'','','','','',aqb03,aqb04,",
                       "       aqbud01,aqbud02,aqbud03,aqbud04,aqbud05,",
                       "       aqbud06,aqbud07,aqbud08,aqbud09,aqbud10,",
                       "       aqbud11,aqbud12,aqbud13,aqbud14,aqbud15", 
                       " FROM aqb_file", 
                       " WHERE aqb01=? AND aqb02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t910_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    
    #目的
    LET g_forupd_sql = "SELECT aqc02,aqc03,aqc09,'',aqc11,'',aqc111,'',aqc04,aqc05,aqc06,aqc07,aqc08,",
                       "       aqcud01,aqcud02,aqcud03,aqcud04,aqcud05,",
                       "       aqcud06,aqcud07,aqcud08,aqcud09,aqcud10,",
                       "       aqcud11,aqcud12,aqcud13,aqcud14,aqcud15", 
                       "  FROM aqc_file ",
                       " WHERE aqc01=? AND aqc02=? AND aqc03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t910_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
    LET g_aqa.aqamodu=g_user
    LET g_aqa.aqadate=g_today
    DISPLAY BY NAME g_aqa.aqamodu,g_aqa.aqadate
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    IF g_rec_b>0 THEN LET l_ac = 1 END IF     #FUN-D30032 add
    IF g_rec_b2>0 THEN LET l_ac2 = 1 END IF   #FUN-D30032 add

    DIALOG ATTRIBUTES(UNBUFFERED)
    INPUT ARRAY g_aqb  FROM s_aqb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            SELECT DISTINCT aqc10 INTO g_aqc10 FROM aqc_file WHERE aqc01=g_aqa.aqa01
            IF NOT cl_null(g_aqc10) THEN 
               DISPLAY g_aqc10 TO aqc10
            END IF 
            LET g_b_flag = '1'   #FUN-D30032 add 

        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_aqb_t.* = g_aqb[l_ac].*  #BACKUP
              OPEN t910_b2cl USING g_aqa.aqa01,g_aqb_t.aqb02
              IF STATUS THEN
                 CALL cl_err("OPEN t910_b2cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t910_b2cl INTO g_aqb[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aqb_t.aqb02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              LET g_aqb[l_ac].apa02 = g_aqb_t.apa02
              CALL t910_aqb02('d',l_ac)
              CALL cl_show_fld_cont()     
          END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_aqb[l_ac].* TO NULL      #900423
           LET g_aqb_t.* = g_aqb[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD aqb02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           INSERT INTO aqb_file(aqb01,aqb02,aqb03,aqb04,
                                  aqbud01,aqbud02,aqbud03,
                                  aqbud04,aqbud05,aqbud06,
                                  aqbud07,aqbud08,aqbud09,
                                  aqbud10,aqbud11,aqbud12,
                                  aqbud13,aqbud14,aqbud15,aqblegal) 
             VALUES(g_aqa.aqa01,g_aqb[l_ac].aqb02,g_aqb[l_ac].aqb03,
                    g_aqb[l_ac].aqb04,
                                  g_aqb[l_ac].aqbud01,
                                  g_aqb[l_ac].aqbud02,
                                  g_aqb[l_ac].aqbud03,
                                  g_aqb[l_ac].aqbud04,
                                  g_aqb[l_ac].aqbud05,
                                  g_aqb[l_ac].aqbud06,
                                  g_aqb[l_ac].aqbud07,
                                  g_aqb[l_ac].aqbud08,
                                  g_aqb[l_ac].aqbud09,
                                  g_aqb[l_ac].aqbud10,
                                  g_aqb[l_ac].aqbud11,
                                  g_aqb[l_ac].aqbud12,
                                  g_aqb[l_ac].aqbud13,
                                  g_aqb[l_ac].aqbud14,
                                  g_aqb[l_ac].aqbud15,g_legal) 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","aqb_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
              CANCEL INSERT
              ROLLBACK WORK
           END IF

           SELECT SUM(aqb04) INTO g_aqa.aqa03 FROM aqb_file
            WHERE aqb01=g_aqa.aqa01
          
           SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=g_aqb[1].aqb02
           IF l_apa00 MATCHES '2*' THEN                                      #賬款性質為2*,則分攤金額為負 
              LET g_aqa.aqa03=g_aqa.aqa03*-1
           END IF
         
           UPDATE aqa_file SET aqa03=g_aqa.aqa03
            WHERE aqa01=g_aqa.aqa01
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN    #TQC-6B0087
              CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
              ROLLBACK WORK
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              IF g_success='Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
           DISPLAY BY NAME g_aqa.aqa03
 
        AFTER FIELD aqb02
           IF NOT cl_null(g_aqb[l_ac].aqb02) THEN
              LET l_apa31=0
              LET l_aqb04=0
              SELECT apa31,apa00 INTO l_apa31,l_apa00 FROM apa_file
                 WHERE apa01=g_aqb[l_ac].aqb02
              SELECT SUM(aqb04) INTO l_aqb04 FROM aqa_file,aqb_file      
                 WHERE aqb02=g_aqb[l_ac].aqb02 
                   AND aqa01 = aqb01 AND aqaconf <> 'X'                 
              IF cl_null(l_apa31) THEN LET l_apa31 = 0 END IF
              IF cl_null(l_aqb04) THEN LET l_aqb04 = 0 END IF
              LET g_cnt = 0
              SELECT COUNT(*) INTO g_cnt FROM aqa_file,aqb_file
                WHERE aqa01=aqb01 AND aqa01=g_aqa.aqa01 AND
                      aqb02=g_aqb[l_ac].aqb02
                  AND aqaconf <> 'X'                                    
              IF g_aqb_t.aqb02 <> g_aqb[l_ac].aqb02 OR
                    cl_null(g_aqb_t.aqb02) THEN
                 IF g_cnt > 0 THEN
                    CALL cl_err('','-239',0)
                    LET g_aqb[l_ac].aqb02 = g_aqb_t.aqb02
                    DISPLAY BY NAME g_aqb[l_ac].aqb02
                    NEXT FIELD aqb02
                 END IF
                 IF l_apa31=l_aqb04 THEN
                    CALL cl_err('','aap-801',0)
                    LET g_aqb[l_ac].aqb02 = g_aqb_t.aqb02
                    DISPLAY BY NAME g_aqb[l_ac].aqb02
                    NEXT FIELD aqb02
                 END IF
              END IF
              SELECT apa41 INTO l_apa41 FROM apa_file
               WHERE apa01=g_aqb[l_ac].aqb02
              IF l_apa41='N' THEN
                 CALL cl_err('','mfg-043',0)
                 NEXT FIELD aqb02
              END IF
             #檢查來源帳款若有已作廢單號或外購，不可做分攤的動作
             SELECT COUNT(*) INTO g_cnt
               FROM apa_file
              WHERE apa01 = g_aqb[l_ac].aqb02
                AND (apa42 = 'Y' OR apa75 = 'Y')   
             IF g_cnt > 0 THEN
                CALL cl_err('','aap-329',0)
                NEXT FIELD aqb02
             END IF
             LET g_cnt = 0 
             SELECT COUNT(*) INTO g_cnt
               FROM apa_file
              WHERE apa01 = g_aqb[l_ac].aqb02
                AND apa51 = 'UNAP'
             IF g_cnt > 0 THEN
                CALL cl_err('','aap-081',0)
                NEXT FIELD aqb02
             END IF
             LET g_cnt = 0 
             IF g_apz.apz27 = 'N' THEN
                SELECT COUNT(*) INTO g_cnt 
                  FROM apa_file
                 WHERE apa01 = g_aqb[l_ac].aqb02
                   AND (apa34-apa35) = 0 
                   AND apa42 = 'N'
                   AND apa00 = '23'        
             ELSE
                SELECT COUNT(*) INTO g_cnt 
                  FROM apa_file
                 WHERE apa01 = g_aqb[l_ac].aqb02
                   AND apa73 = 0 
                   AND apa42 = 'N'
                   AND apa00 = '23'        
             END IF
             IF g_cnt > 0 THEN
                CALL cl_err('','aco-228',0)
                NEXT FIELD aqb02
             END IF
             #如果單身第一筆資料的賬款性質為1*，則不可錄入性質為2*的資料，反之亦然
	     SELECT apa00 INTO l_apa00  FROM apa_file WHERE apa01=g_aqb[1].aqb02     
             IF l_apa00 MATCHES '1*' THEN
                LET l_tt='1*'
             ELSE
                LET l_tt='2*'
              END IF
              IF NOT cl_null(g_aqb[l_ac].aqb02) THEN
                 SELECT apa00 INTO l_apa00  FROM apa_file WHERE apa01=g_aqb[l_ac].aqb02
                 IF l_apa00 MATCHES '1*' THEN
                   LET l_t='1*'
                ELSE
                   LET l_t='2*'
                END IF
                IF l_tt<>l_t THEN
                   CALL cl_err('','aap-954',0)
                   NEXT FIELD aqb02
                END IF
              END IF  
              CALL t910_aqb02('a',l_ac)
              IF g_success="N" THEN
                 CALL cl_err(g_aqb[l_ac].aqb02,g_errno,0)
                 NEXT FIELD aqb02
              END IF
              IF g_aqb[l_ac].aqb02 != g_aqb_t.aqb02 OR  
                 g_aqb_t.aqb02 IS NULL THEN   
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_aqb[l_ac].aqb02=g_aqb_t.aqb02
                     NEXT FIELD aqb02
                 END IF
              END IF
              IF g_aqb[l_ac].aqb02 != g_aqb_t.aqb02 AND (NOT cl_null(g_aqb_t.aqb02) OR g_aqb_t.aqb02 IS NOT NULL)  THEN
                 SELECT aqb04 INTO l_aqb04_1 FROM aqb_file WHERE aqb01=g_aqa.aqa01 AND aqb02=g_aqb_t.aqb02
                 SELECT apa31 INTO l_aqb03 FROM apa_file
                 WHERE apa01=g_aqb[l_ac].aqb02
                 IF l_aqb04_1>l_aqb03 THEN
                    CALL cl_err('','aap-801',0) 
                    NEXT FIELD aqb04
                 END IF
              END IF
              IF NOT cl_null(g_aqb[l_ac].aqb04) THEN
                 IF  NOT cl_null(g_aqb[l_ac].aqb03) THEN
                     IF g_aqb[l_ac].aqb04 > g_aqb[l_ac].aqb03 THEN
                        CALL cl_err('','aap-801',0)
                        NEXT FIELD aqb04
                     END IF
                 END IF
              END IF
              LET g_aqb[l_ac].aqb03 = cl_digcut(g_aqb[l_ac].aqb03,g_azi04)
           END IF
 
        AFTER FIELD aqb04
           IF g_aqb[l_ac].aqb04<=0 THEN
              CALL cl_err('','axm4011',0)
              NEXT FIELD aqb04
           END IF
           LET l_apa31=0
           LET l_aqb04=0
           SELECT apa31,apa00 INTO l_apa31,l_apa00 FROM apa_file
              WHERE apa01=g_aqb[l_ac].aqb02
           IF l_apa00 = '23' THEN           
              IF g_apz.apz27 = 'N' THEN
                 SELECT apa34-apa35 INTO l_apa31
                   FROM apa_file
                  WHERE apa01=g_aqb[l_ac].aqb02
              ELSE
                 SELECT apa73 INTO l_apa31
                   FROM apa_file
                  WHERE apa01=g_aqb[l_ac].aqb02
              END IF
           END IF                          

           IF l_apa00 <> '23' THEN     
              SELECT SUM(aqb04) INTO l_aqb04 FROM aqa_file,aqb_file      
                 WHERE aqb02=g_aqb[l_ac].aqb02
                   AND aqa01 = aqb01 AND aqaconf <> 'X'                   
           ELSE
              SELECT SUM(aqb04) INTO l_aqb04 FROM aqa_file,aqb_file      
                 WHERE aqb02=g_aqb[l_ac].aqb02
                   AND aqa01 = aqb01 AND aqaconf = 'N' 
           END IF 

           IF cl_null(l_apa31) THEN LET l_apa31 = 0 END IF
           IF cl_null(l_aqb04) THEN LET l_aqb04 = 0 END IF
           IF p_cmd = 'a' THEN
                 IF g_aqb[l_ac].aqb04+l_aqb04 > l_apa31 THEN
                    CALL cl_err('','aap-801',0)
                    NEXT FIELD aqb04
                 END IF
           ELSE
                 IF g_aqb[l_ac].aqb04-g_aqb_t.aqb04+l_aqb04 > l_apa31 THEN
                    CALL cl_err('','aap-801',0)
                    LET g_aqb[l_ac].aqb04 = g_aqb_t.aqb04
                    DISPLAY BY NAME g_aqb[l_ac].aqb04
                    NEXT FIELD aqb04
                 END IF
           END IF
           IF g_aqa.aqa03 IS NULL THEN
              LET g_aqa.aqa03=0
           END IF
           CALL t910_aqb04()
           SELECT SUM(aqb04) INTO l_tot_aqb04 FROM aqa_file,aqb_file    #此帳款的總分攤額   
            WHERE aqb02=g_aqb[l_ac].aqb02
              AND aqb01 <> g_aqa.aqa01
              AND aqa01 = aqb01 AND aqaconf <> 'X'                                         
           IF cl_null(l_tot_aqb04) THEN
              LET l_tot_aqb04=0
           END IF
           LET l_tot_aqb04=l_tot_aqb04+g_aqb[l_ac].aqb04
           IF l_tot_aqb04>g_aqb[l_ac].aqb03 THEN
              CALL cl_err('','mfg-038',0)
              NEXT FIELD aqb04
            END IF
            LET g_aqb[l_ac].aqb04 = cl_digcut(g_aqb[l_ac].aqb04,g_azi04) 

        AFTER FIELD aqbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_aqb_t.aqb02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM aqb_file
               WHERE aqb01 = g_aqa.aqa01
                 AND aqb02 = g_aqb_t.aqb02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","aqb_file",g_aqa.aqa01,g_aqb_t.aqb02,SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              SELECT SUM(aqb04) INTO g_aqa.aqa03 FROM aqb_file
               WHERE aqb01=g_aqa.aqa01
              SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=g_aqb[1].aqb02
              IF l_apa00 MATCHES '2*' THEN                                      #賬款性質為2*,則分攤金額為負 
                 LET g_aqa.aqa03=g_aqa.aqa03*-1
              END IF
              UPDATE aqa_file SET aqa03=g_aqa.aqa03 WHERE aqa01=g_aqa.aqa01
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                 CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              DISPLAY BY NAME g_aqa.aqa03
              CALL t910_aqb04()
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              IF g_success='Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aqb[l_ac].* = g_aqb_t.*
               CLOSE t910_b2cl
               ROLLBACK WORK
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aqb[l_ac].aqb02,-263,1)
               LET g_aqb[l_ac].* = g_aqb_t.*
            ELSE
               UPDATE aqb_file SET aqb02 = g_aqb[l_ac].aqb02,
                                   aqb03 = g_aqb[l_ac].aqb03,
                                   aqb04 = g_aqb[l_ac].aqb04,
                                aqbud01 = g_aqb[l_ac].aqbud01,
                                aqbud02 = g_aqb[l_ac].aqbud02,
                                aqbud03 = g_aqb[l_ac].aqbud03,
                                aqbud04 = g_aqb[l_ac].aqbud04,
                                aqbud05 = g_aqb[l_ac].aqbud05,
                                aqbud06 = g_aqb[l_ac].aqbud06,
                                aqbud07 = g_aqb[l_ac].aqbud07,
                                aqbud08 = g_aqb[l_ac].aqbud08,
                                aqbud09 = g_aqb[l_ac].aqbud09,
                                aqbud10 = g_aqb[l_ac].aqbud10,
                                aqbud11 = g_aqb[l_ac].aqbud11,
                                aqbud12 = g_aqb[l_ac].aqbud12,
                                aqbud13 = g_aqb[l_ac].aqbud13,
                                aqbud14 = g_aqb[l_ac].aqbud14,
                                aqbud15 = g_aqb[l_ac].aqbud15
                WHERE aqb01=g_aqa.aqa01 AND aqb02=g_aqb_t.aqb02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","aqb_file",g_aqb[l_ac].aqb02,"",SQLCA.sqlcode,"","",1)
                  LET g_aqb[l_ac].* = g_aqb_t.*
                  ROLLBACK WORK
               END IF
               
               SELECT SUM(aqb04) INTO g_aqa.aqa03 FROM aqb_file
                WHERE aqb01=g_aqa.aqa01
              
               SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=g_aqb[1].aqb02
               IF l_apa00 MATCHES '2*' THEN                                      #賬款性質為2*,則分攤金額為負
                  LET g_aqa.aqa03=g_aqa.aqa03*-1
               END IF
               UPDATE aqa_file SET aqa03=g_aqa.aqa03
                WHERE aqa01=g_aqa.aqa01
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","aqb_file",g_aqa.aqa01,g_aqb_t.aqb02,SQLCA.sqlcode,"","",1) 
                  LET g_aqb[l_ac].* = g_aqb_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  IF g_success='Y' THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               END IF
               DISPLAY BY NAME g_aqa.aqa03
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aqb[l_ac].* = g_aqb_t.*
               END IF
               CLOSE t910_b2cl
               ROLLBACK WORK
            END IF
            LET l_ac_t = l_ac   #FUN-D30032
            CLOSE t910_b2cl
            COMMIT WORK
            CALL t910_aqb04()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aqb02)
                 CALL q_apa6(FALSE,TRUE,'aapt910',g_aqb[1].aqb02,l_ac,g_rec_b) RETURNING g_aqb[l_ac].aqb02
                 IF cl_null(g_aqb[l_ac].aqb02) THEN
                    LET g_aqb[l_ac].aqb02=g_aqb_t.aqb02
                 END IF
                #DISPLAY g_aqb[l_ac].aqb02 TO aqb02 
                 DISPLAY BY NAME g_aqb[l_ac].aqb02
              OTHERWISE
                 EXIT CASE
           END CASE
    END INPUT
    #目的类型
    INPUT g_aqc10 FROM aqc10
    BEFORE INPUT
    BEFORE FIELD aqc10
       LET l_cnt=0
          SELECT COUNT(*) INTO l_cnt FROM aqc_file WHERE aqc01=g_aqa.aqa01
          IF l_cnt>0 THEN
             CALL cl_set_comp_entry("aqc10",FALSE)
          ELSE
             CALL cl_set_comp_entry("aqc10",TRUE)
          END IF
 
     ON CHANGE aqc10
        CALL t910_show0()
        IF g_aqc10='1' THEN
            SELECT COUNT(*) INTO g_rec_b FROM aqc_file WHERE aqc01=g_aqa.aqa01
            IF g_rec_b = 0 THEN
               CALL t910_g_b1()
              IF g_success='Y' THEN
                 LET g_aqc10_t=g_aqc10     #backup
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
               CALL t910_b2_fill(' 1=1')
            END IF
        END IF
        IF g_aqc10='3'  THEN
           NEXT FIELD aqc09
        ELSE
           NEXT FIELD aqc02
        END IF
      END INPUT 
    #目的单身
       INPUT ARRAY g_aqc  FROM s_aqc.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS = TRUE,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF
            LET g_b_flag = '2'   #FUN-D30032 add
    
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac2 = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n2  = ARR_COUNT()
       
           BEGIN WORK
           IF g_rec_b2 >= l_ac2 THEN
              LET p_cmd='u'
              LET g_aqc_t.* = g_aqc[l_ac2].*  #BACKUP
              OPEN t910_bcl USING g_aqa.aqa01,g_aqc_t.aqc02,g_aqc_t.aqc03
              IF STATUS THEN
                 CALL cl_err("OPEN t910_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t910_bcl INTO g_aqc[l_ac2].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aqc_t.aqc02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              #修改單身2時，換行時附屬欄位依然有值
             LET g_aqc[l_ac2].ima02=g_aqc_t.ima02
             LET g_aqc[l_ac2].aqc11=g_aqc_t.aqc11
             LET g_aqc[l_ac2].aqc111=g_aqc_t.aqc111
             LET g_aqc[l_ac2].aag02=g_aqc_t.aag02
             LET g_aqc[l_ac2].aag02_1=g_aqc_t.aag02_1
              CALL cl_show_fld_cont()     
           END IF
 
        BEFORE INSERT
            LET l_n2 = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_aqc[l_ac2].* TO NULL
            LET g_aqc_t.* = g_aqc[l_ac2].*         #新輸入資料
            CALL cl_show_fld_cont()   
            IF g_aqc10='3' THEN
              NEXT FIELD aqc09
            ELSE
              NEXT FIELD aqc02
            END IF

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF   
           LET g_aqc[l_ac2].aqc04 = cl_digcut(g_aqc[l_ac2].aqc04,g_azi03)  #MOD-D80200
           LET g_aqc[l_ac2].aqc06 = cl_digcut(g_aqc[l_ac2].aqc06,g_azi04)  #MOD-D80200
           LET g_aqc[l_ac2].aqc07 = cl_digcut(g_aqc[l_ac2].aqc07,g_azi03)  #MOD-D80200
           LET g_aqc[l_ac2].aqc08 = cl_digcut(g_aqc[l_ac2].aqc08,g_azi04)  #MOD-D80200
           INSERT INTO aqc_file(aqc01,aqc02,aqc03,aqc09,aqc10,aqc11,aqc111,aqc04,aqc05,aqc06,aqc07,aqc08,
                                  aqcud01,aqcud02,aqcud03,
                                  aqcud04,aqcud05,aqcud06,
                                  aqcud07,aqcud08,aqcud09,
                                  aqcud10,aqcud11,aqcud12,
                                  aqcud13,aqcud14,aqcud15,aqclegal) 
            VALUES(g_aqa.aqa01,g_aqc[l_ac2].aqc02,g_aqc[l_ac2].aqc03,
                   g_aqc[l_ac2].aqc09,g_aqc10,g_aqc[l_ac2].aqc11,g_aqc[l_ac2].aqc111,
                   g_aqc[l_ac2].aqc04,g_aqc[l_ac2].aqc05,g_aqc[l_ac2].aqc06,
                   g_aqc[l_ac2].aqc07,g_aqc[l_ac2].aqc08,
                                  g_aqc[l_ac2].aqcud01,
                                  g_aqc[l_ac2].aqcud02,
                                  g_aqc[l_ac2].aqcud03,
                                  g_aqc[l_ac2].aqcud04,
                                  g_aqc[l_ac2].aqcud05,
                                  g_aqc[l_ac2].aqcud06,
                                  g_aqc[l_ac2].aqcud07,
                                  g_aqc[l_ac2].aqcud08,
                                  g_aqc[l_ac2].aqcud09,
                                  g_aqc[l_ac2].aqcud10,
                                  g_aqc[l_ac2].aqcud11,
                                  g_aqc[l_ac2].aqcud12,
                                  g_aqc[l_ac2].aqcud13,
                                  g_aqc[l_ac2].aqcud14,
                                  g_aqc[l_ac2].aqcud15,g_legal)  
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","aqc_file",g_aqa.aqa01,g_aqc[l_ac2].aqc02,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
              ROLLBACK WORK
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              IF g_success='Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF

        BEFORE FIELD aqc02
          IF cl_null(g_aqc10) OR g_aqc10 IS NULL THEN
              CALL cl_err('','aap-953',0)
              NEXT FIELD aqc10
           END IF
           
           LET l_cnt=0
           SELECT COUNT(*) INTO l_cnt FROM aqc_file WHERE aqc01=g_aqa.aqa01
           IF l_cnt>0 THEN
              CALL cl_set_comp_entry("aqc10",FALSE)
           ELSE
              CALL cl_set_comp_entry("aqc10",TRUE)
           END IF
           
      
        AFTER FIELD aqc02
           IF NOT cl_null(g_aqc[l_ac2].aqc02) THEN
              IF g_aqc10='1' THEN 
                 IF g_aqc[l_ac2].aqc02 != g_aqc_t.aqc02 OR 
                    g_aqc_t.aqc02 IS NULL THEN   
                    #檢查目的帳款若有已作廢單號或外購，不可做分攤的動作
                    SELECT COUNT(*) INTO g_cnt
                      FROM apa_file
                     WHERE apa01 = g_aqc[l_ac2].aqc02
                       AND (apa42 = 'Y' OR apa75 = 'Y')
                     IF g_cnt > 0 THEN
                       CALL cl_err('','aap-330',0)
                       NEXT FIELD aqc02
                     END IF
 
                     #已完成成本結帳帳款不可再做成本分攤
                     SELECT apa02 INTO l_apa02 FROM apa_file
                      WHERE apa01 = g_aqc[l_ac2].aqc02
                      #重新抓取關帳日期
                     SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'
                     IF l_apa02 <= g_sma.sma53 THEN
                        CALL cl_err(g_aqc[l_ac2].aqc02,'axc-194',0)   
                        NEXT FIELD aqc02
                     END IF
                     IF l_apa02 > g_aqa.aqa02 THEN
                        CALL cl_err(g_aqc[l_ac2].aqc02,'aap-102',0)
                        NEXT FIELD aqc02
                     END IF
                     NEXT FIELD aqc03                         
                   END IF
                 ELSE
                   IF g_aqc10='2' THEN
                      IF g_aqc[l_ac2].aqc02 != g_aqc_t.aqc02 OR
                         g_aqc_t.aqc02 IS NULL THEN
                         LET g_cnt=0
                         SELECT COUNT(*) INTO g_cnt FROM rvv_file WHERE rvv01=g_aqc[l_ac2].aqc02
                         IF g_cnt = 0 THEN
                            CALL cl_err('','ask-008',0)
                            NEXT FIELD aqc02
                         END IF
                         #darcy:2023/01/10 add s---
                         #跨月入库单不允许录入，需求来源--财务郑伟花
                         #当前月份第一天 
                         SELECT COUNT(*) INTO g_cnt FROM rvv_file,rvu_file
                          WHERE rvv01=g_aqc[l_ac2].aqc02 and rvv01 = rvu01 
                            AND (
                              (YEAR(rvu03) = YEAR(g_aqa.aqainpd) AND MONTH(rvu03) < MONTH(g_aqa.aqainpd))
                              OR (YEAR(rvu03) < YEAR(g_aqa.aqainpd))
                            )
                         if g_cnt > 0 then
                         # 跨月不允许录入
                            CALL cl_err('','cap-005',0)
                            NEXT FIELD aqc02
                         end if
                         #darcy:2023/01/10 add e---
                     END IF
                   END IF 
                END IF                          
           END IF
 
        AFTER FIELD aqc03
           IF NOT cl_null(g_aqc[l_ac2].aqc03) THEN
             #FUN-C90126--mark--str
             #IF g_aqc[l_ac2].aqc02 IS NOT NULL THEN
             #   IF g_aqc_t.aqc02 IS NULL THEN  # 單身新增
             #      LET g_cnt=0
             #      SELECT COUNT(*) INTO g_cnt FROM aqa_file ,aqc_file
             #       WHERE aqa01=aqc01
             #         AND aqc02=g_aqc[l_ac2].aqc02
             #         AND aqc03=g_aqc[l_ac2].aqc03
             #         AND aqaconf <> 'X'             
             #      IF g_cnt>0 THEN
             #         CALL cl_err('','aap-035',0) 
             #         NEXT FIELD aqc02
             #      END IF
             #   END IF
             #END IF
             #FUN-C90126--mark--end
              IF g_aqc10='1' THEN
                 CALL t910_aqc03(l_ac2)          #应收
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD aqc02
                 END IF
                 IF g_aqc[l_ac2].aqc02 IS NOT NULL THEN
                    IF g_aqc_t.aqc02 IS NOT NULL AND g_success<>'N' THEN
                       CALL t910_apa51()
                       IF g_success='N' THEN
                          INITIALIZE g_aqc[l_ac2].* TO NULL
                          NEXT FIELD aqc02
                       END IF
                    END IF
                 END IF
                 SELECT apb10,apb101 INTO l_apb10,l_apb101 FROM apb_file
                  WHERE apb01=g_aqc[l_ac2].aqc02
                    AND apb02=g_aqc[l_ac2].aqc03
                  LET g_aqc[l_ac2].aqc04 = cl_digcut(g_aqc[l_ac2].aqc04,g_azi03) 
                  LET g_aqc[l_ac2].aqc06 = cl_digcut(g_aqc[l_ac2].aqc06,g_azi04) 
                  LET g_aqc[l_ac2].aqc07 = cl_digcut(g_aqc[l_ac2].aqc07,g_azi03) 
                  LET g_aqc[l_ac2].aqc08 = cl_digcut(g_aqc[l_ac2].aqc08,g_azi04) 
              END IF
              IF g_aqc10='2' THEN
                 CALL t910_aqc03_1(l_ac2)        # 入库单资料
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD aqc02
                 END IF
                 LET g_aqc[l_ac2].aqc04 = cl_digcut(g_aqc[l_ac2].aqc04,g_azi03)
                 LET g_aqc[l_ac2].aqc06 = cl_digcut(g_aqc[l_ac2].aqc06,g_azi04)
                 LET g_aqc[l_ac2].aqc07 = cl_digcut(g_aqc[l_ac2].aqc07,g_azi03)
                 LET g_aqc[l_ac2].aqc08 = cl_digcut(g_aqc[l_ac2].aqc08,g_azi04)
             END IF
         END IF

      AFTER FIELD aqc08
         IF NOT cl_null(g_aqc[l_ac2].aqc08) THEN
            IF g_aqc[l_ac2].aqc08<=0 THEN
               CALL cl_err('','axm4011',0)
               NEXT FIELD aqc08
            END IF
            LET g_aqc[l_ac2].aqc08 = cl_digcut(g_aqc[l_ac2].aqc08,g_azi04)
         END IF

       BEFORE FIELD aqc09
        IF g_aqc10='3' THEN
           LET g_aqc[l_ac2].aqc02=' '
           IF g_aqc[l_ac2].aqc03 IS NULL OR g_aqc[l_ac2].aqc03=0 THEN
              SELECT max(aqc03)+1  INTO g_aqc[l_ac2].aqc03 FROM aqc_file WHERE aqc01=g_aqa.aqa01
              IF g_aqc[l_ac2].aqc03 IS NULL THEN
                 LET g_aqc[l_ac2].aqc03=1
              END IF
            END IF

            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM aqc_file WHERE aqc01=g_aqa.aqa01
            IF l_cnt>0 THEN
               CALL cl_set_comp_entry("aqc10",FALSE)
            ELSE
               CALL cl_set_comp_entry("aqc10",TRUE)
            END IF
         END IF

       AFTER FIELD aqc09
           IF g_aqc10='3' THEN
              IF NOT cl_null(g_aqc[l_ac2].aqc09) THEN
                 IF g_aqc_t.aqc09!=g_aqc[l_ac2].aqc09 OR cl_null(g_aqc_t.aqc09) THEN
                    LET l_cnt=0 
                    SELECT COUNT(*) INTO l_cnt FROM aqc_file WHERE aqc01=g_aqa.aqa01 AND aqc09=g_aqc[l_ac2].aqc09
                    IF l_cnt>0 THEN
                       CALL cl_err('',-239,0)
                       NEXT FIELD aqc09
                    END IF
                 END IF
                 LET l_cnt=0
                 SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE	ima01=g_aqc[l_ac2].aqc09 
                 IF l_cnt=0 THEN
                    CALL cl_err('','ask-008',1) 
                    NEXT FIELD aqc09
                 END IF
                 IF p_cmd='a' OR g_aqc_t.aqc09!=g_aqc[l_ac2].aqc09 OR cl_null(g_aqc_t.aqc09) THEN 
                    SELECT ima02,ima39,ima391  INTO g_aqc[l_ac2].ima02,g_aqc[l_ac2].aqc11,g_aqc[l_ac2].aqc111
                      FROM ima_file WHERE ima01=g_aqc[l_ac2].aqc09
                    CALL t910_aag(g_aqc[l_ac2].aqc11,g_plant,'1') RETURNING g_aqc[l_ac2].aag02
                    CALL t910_aag(g_aqc[l_ac2].aqc111,g_plant,'2') RETURNING g_aqc[l_ac2].aag02_1
                    DISPLAY BY NAME g_aqc[l_ac2].ima02,g_aqc[l_ac2].aqc11,g_aqc[l_ac2].aqc111
                    DISPLAY BY NAME g_aqc[l_ac2].aqc11,g_aqc[l_ac2].aqc111 
                 END IF
              ELSE
                 LET g_aqc[l_ac2].ima02=''
                 DISPLAY BY NAME g_aqc[l_ac2].ima02
              END IF
           END IF 
 
      # BEFORE FIELD aqc11 #科目
      #     IF cl_null(g_aqc[l_ac2].aqc11) THEN
      #         SELECT ima39 INTO g_aqc[l_ac2].aqc11 FROM ima_file
      #          WHERE ima01 = g_aqc[l_ac2].aqc09
      #         CALL t910_aag(g_aqc[l_ac2].aqc11,g_plant,'1') RETURNING g_aqc[l_ac2].aag02
      #         DISPLAY BY NAME g_aqc[l_ac2].aqc11,g_aqc[l_ac].aag02
      #     END IF
 
        AFTER FIELD aqc11
          IF NOT cl_null(g_aqc[l_ac2].aqc11) THEN
             CALL t910_aag(g_aqc[l_ac2].aqc11,g_plant,'1') RETURNING g_aqc[l_ac2].aag02  
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_aqc[l_ac2].aqc11,g_errno,0)
                CALL q_m_aag(FALSE,FALSE,g_plant,g_aqc[l_ac2].aqc11,'23',g_bookno1)
                RETURNING g_aqc[l_ac2].aqc11
                DISPLAY BY NAME g_aqc[l_ac2].aqc11
                NEXT FIELD aqc11
             END IF
                DISPLAY g_aqc[l_ac2].aag02 TO FORMONLY.aag02
          ELSE
             LET g_aqc[l_ac2].aag02=''
             DISPLAY g_aqc[l_ac2].aag02 TO FORMONLY.aag02
          END IF

      # BEFORE FIELD aqc111 #科目
      #     IF cl_null(g_aqc[l_ac2].aqc111) THEN
      #         SELECT ima391 INTO g_aqc[l_ac2].aqc111 FROM ima_file
      #          WHERE ima01 = g_aqc[l_ac2].aqc09
      #         CALL t910_aag(g_aqc[l_ac2].aqc11,g_plant,'2') RETURNING g_aqc[l_ac2].aag02_1
      #         DISPLAY BY NAME g_aqc[l_ac2].aqc111,g_aqc[l_ac].aag02_1
      #     END IF   
        AFTER FIELD aqc111
          IF NOT cl_null(g_aqc[l_ac2].aqc111) THEN
             CALL t910_aag(g_aqc[l_ac2].aqc111,g_plant,'2') RETURNING g_aqc[l_ac2].aag02_1
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_aqc[l_ac2].aqc111,g_errno,0)
                CALL q_m_aag(FALSE,FALSE,g_plant,g_aqc[l_ac2].aqc111,'23',g_bookno2)
                RETURNING g_aqc[l_ac2].aqc111
                DISPLAY BY NAME g_aqc[l_ac2].aqc111
                NEXT FIELD aqc111
             END IF
             DISPLAY g_aqc[l_ac2].aag02_1 TO FORMONLY.aag02_1
          ELSE
             LET g_aqc[l_ac2].aag02_1=''
             DISPLAY g_aqc[l_ac2].aag02_1 TO FORMONLY.aag02_1 
          END IF
           # LET g_aqc_t.aqc111 = g_aqc[l_ac2].aqc111

        
        AFTER FIELD aqcud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        BEFORE DELETE                            #是否取消單身
           IF g_aqc_t.aqc02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              DELETE FROM aqc_file
               WHERE aqc01 = g_aqa.aqa01
                 AND aqc02 = g_aqc_t.aqc02
                 AND aqc03 = g_aqc_t.aqc03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","aqc_file",g_aqa.aqa01,g_aqc_t.aqc02,SQLCA.sqlcode,"","",1)  
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              CALL t910_aqc06_aqc08()   
              CALL t910_aqc08_1()       #目的类型为料号
              LET g_cnt=0
              IF g_success='Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_aqc[l_ac2].* = g_aqc_t.*
              CLOSE t910_bcl
              ROLLBACK WORK
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_aqc[l_ac2].aqc02,-263,1)
              LET g_aqc[l_ac2].* = g_aqc_t.*
           ELSE
              UPDATE aqc_file SET aqc02 = g_aqc[l_ac2].aqc02,
                                  aqc03 = g_aqc[l_ac2].aqc03,
                                  aqc09 = g_aqc[l_ac2].aqc09,
                                  aqc11 = g_aqc[l_ac2].aqc11,
                                  aqc111= g_aqc[l_ac2].aqc111,
                                  aqc04 = g_aqc[l_ac2].aqc04,
                                  aqc05 = g_aqc[l_ac2].aqc05,
                                  aqc06 = g_aqc[l_ac2].aqc06,
                                  aqc07 = g_aqc[l_ac2].aqc07,
                                  aqc08 = g_aqc[l_ac2].aqc08,
                                aqcud01 = g_aqc[l_ac2].aqcud01,
                                aqcud02 = g_aqc[l_ac2].aqcud02,
                                aqcud03 = g_aqc[l_ac2].aqcud03,
                                aqcud04 = g_aqc[l_ac2].aqcud04,
                                aqcud05 = g_aqc[l_ac2].aqcud05,
                                aqcud06 = g_aqc[l_ac2].aqcud06,
                                aqcud07 = g_aqc[l_ac2].aqcud07,
                                aqcud08 = g_aqc[l_ac2].aqcud08,
                                aqcud09 = g_aqc[l_ac2].aqcud09,
                                aqcud10 = g_aqc[l_ac2].aqcud10,
                                aqcud11 = g_aqc[l_ac2].aqcud11,
                                aqcud12 = g_aqc[l_ac2].aqcud12,
                                aqcud13 = g_aqc[l_ac2].aqcud13,
                                aqcud14 = g_aqc[l_ac2].aqcud14,
                                aqcud15 = g_aqc[l_ac2].aqcud15
               WHERE aqc01=g_aqa.aqa01
                 AND aqc02=g_aqc_t.aqc02
                 AND aqc03=g_aqc_t.aqc03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN    
                 CALL cl_err3("upd","aqc_file",g_aqa.aqa01,g_aqc_t.aqc02,SQLCA.sqlcode,"","",1)                   
                 LET g_aqc[l_ac2].* = g_aqc_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                 UPDATE aqa_file SET aqamodu=g_user,aqadate=g_today
                  WHERE aqa01=g_aqa.aqa01

                 

                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
                    LET g_success ='N'
                 END IF
 
                 IF g_success='Y' THEN
                    COMMIT WORK
                 ELSE
                    ROLLBACK WORK
                 END IF
              END IF
           END IF
 
         AFTER ROW
            LET l_ac2 = ARR_CURR()
            #LET l_ac_t2 = l_ac2  #FUN-D30032
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aqc[l_ac2].* = g_aqc_t.*
               END IF
               CLOSE t910_bcl
               ROLLBACK WORK
            END IF
            LET l_ac_t2 = l_ac2  #FUN-D30032
            CLOSE t910_bcl
            COMMIT WORK
            CALL t910_aqc06_aqc08()   
            CALL t910_aqc08_1() 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aqc02) 
                 IF g_aqc10='1' THEN                
                    #FUN-C90126--add--str
                    IF cl_null(g_aqc[l_ac2].aqc02) THEN 
                       LET l_aqc02_str = ''
                       CALL q_apb1(TRUE,TRUE,g_aqa.aqa02,g_aqa.aqa01) RETURNING l_aqc02_str,g_aqc[l_ac2].aqc03
                    ELSE
                    #FUN-C90126--add--end
                       LET g_qryparam.default1 = g_aqc[l_ac2].aqc02 
                       CALL q_apb1(FALSE,TRUE,g_aqa.aqa02,g_aqa.aqa01) RETURNING g_aqc[l_ac2].aqc02,     #FUN-C90126 add aqa01 
                                                     g_aqc[l_ac2].aqc03
                       IF cl_null(g_aqc[l_ac2].aqc02) THEN
                          LET g_aqc[l_ac2].aqc02= g_aqc_t.aqc02
                          LET g_aqc[l_ac2].aqc03=g_aqc_t.aqc03
                       END IF   
                       CALL t910_aqc03(l_ac2)
                       DISPLAY g_aqc[l_ac2].aqc02 TO aqc02
                       DISPLAY g_aqc[l_ac2].aqc03 TO aqc03
                       NEXT FIELD aqc02
                    END IF #FUN-C90126 add
                 ELSE
                    IF g_aqc10='2' THEN
                       #FUN-C90126--add--str
                       IF cl_null(g_aqc[l_ac2].aqc02) THEN
                          LET l_aqc02_str = ''
                          CALL q_m_rvu(TRUE,TRUE,g_aqa.aqa01) RETURNING l_aqc02_str,g_aqc[l_ac2].aqc03   
                       ELSE
                       #FUN-C90126--add--end
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_rvu1_1" 
                          LET g_qryparam.arg1 = '1'
                          LET g_qryparam.where= "rvuconf='Y'" 
                          CALL cl_create_qry() RETURNING g_aqc[l_ac2].aqc02,g_aqc[l_ac2].aqc03
                          IF cl_null(g_aqc[l_ac2].aqc02) THEN
                             LET g_aqc[l_ac2].aqc02= g_aqc_t.aqc02
                          END IF
                          CALL t910_aqc03_1(l_ac2)
                          DISPLAY BY NAME g_aqc[l_ac2].aqc02,g_aqc[l_ac2].aqc03
                          NEXT FIELD aqc02 
                       END IF #FUN-C90126 add
                    END IF
                 END IF
                 #FUN-C90126--add--str
                 IF cl_null(l_aqc02_str) THEN
                    LET g_aqc[l_ac2].aqc02 = g_aqc_t.aqc02
                    LET g_aqc[l_ac2].aqc03 = g_aqc_t.aqc03
                    NEXT FIELD aqc02 
                 END IF
                 LET g_success = 'Y'
                 COMMIT WORK
                 BEGIN WORK
                 LET l_errno = 0
                 LET l_errno2 = 0
                 LET bst= base.StringTokenizer.create(l_aqc02_str,'|')
                 CALL s_showmsg_init()
                 WHILE bst.hasMoreTokens()
                    LET temptext=bst.nextToken()
                    LET g_aqc[l_ac2].aqc02 = temptext.substring(1,temptext.getIndexOf(",",1)-1)
                    LET g_aqc[l_ac2].aqc03=temptext.substring(temptext.getIndexOf(",",1)+1,temptext.getlength())
                    IF g_aqc10 = '1' THEN 
                       CALL t910_aqc03(l_ac2)
                    END IF 
                    IF g_aqc10 = '2' THEN 
                       CALL t910_aqc03_1(l_ac2)
                    END IF 
                    IF NOT cl_null(g_errno) THEN 
                       CALL s_errmsg('aqc02','',g_aqc[l_ac2].aqc02,g_errno,1)
                       LET l_errno = l_errno +1
                    END IF 
                    #INSERT aqc_file
                    INITIALIZE l_aqc.* TO NULL
                    LET l_aqc.aqc01 = g_aqa.aqa01
                    LET l_aqc.aqc02 = g_aqc[l_ac2].aqc02
                    LET l_aqc.aqc03 = g_aqc[l_ac2].aqc03
                    LET l_aqc.aqc04 = g_aqc[l_ac2].aqc04
                    LET l_aqc.aqc05 = g_aqc[l_ac2].aqc05
                    LET l_aqc.aqc06 = g_aqc[l_ac2].aqc06
                    LET l_aqc.aqc07 = g_aqc[l_ac2].aqc07
                    LET l_aqc.aqc08 = g_aqc[l_ac2].aqc08
                    LET l_aqc.aqc09 = g_aqc[l_ac2].aqc09
                    LET l_aqc.aqc10 = g_aqc10
                    LET l_aqc.aqc11 = g_aqc[l_ac2].aqc11
                    LET l_aqc.aqc111 = g_aqc[l_ac2].aqc111
                    LET l_aqc.aqclegal = g_legal
                    
                    LET l_aqc.aqc04 = cl_digcut(l_aqc.aqc04,g_azi03)  #MOD-D80200
                    LET l_aqc.aqc06 = cl_digcut(l_aqc.aqc06,g_azi04)  #MOD-D80200
                    LET l_aqc.aqc07 = cl_digcut(l_aqc.aqc07,g_azi03)  #MOD-D80200
                    LET l_aqc.aqc08 = cl_digcut(l_aqc.aqc08,g_azi04)  #MOD-D80200
                    
                    INSERT INTO aqc_file VALUES(l_aqc.*) 
                    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                       CALL s_errmsg('aqc02','',l_aqc.aqc02,SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       LET l_errno = l_errno +1
                    ELSE
                       LET l_errno2 = l_errno2 +1
                       LET l_ac2 = l_ac2 + 1
                    END IF 
                 END WHILE                 
                 CALL s_showmsg()
                 IF l_errno >0 THEN 
                    ROLLBACK WORK
                 ELSE
                    COMMIT WORK
                 END IF 
                 IF l_errno2 = 0 THEN 
                    NEXT FIELD aqc02 
                 ELSE
                    CALL t910_b_fill(" 1=1")
                    CALL t910_b2_fill(" 1=1")
                    CALL t910_b()
                 END IF 
                 EXIT DIALOG 
                #FUN-C90126--add--end
              

               WHEN INFIELD(aqc09)
                 IF g_aqc10='3' THEN
                    #FUN-C90126--add-s-tr
                    IF cl_null(g_aqc[l_ac2].aqc09) THEN 
                       LET l_aqc02_str = ''
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form = "q_ima"
                       LET g_qryparam.default1 = g_aqc[l_ac2].aqc09
                       CALL cl_create_qry() RETURNING l_aqc02_str 
                    ELSE
                    #FUN-C90126--add--end
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_ima"
                       LET g_qryparam.default1 = g_aqc[l_ac2].aqc09
                       CALL cl_create_qry() RETURNING g_aqc[l_ac2].aqc09
                       DISPLAY BY NAME g_aqc[l_ac2].aqc09
                       NEXT FIELD aqc09
                    END IF #FUN-C90126--add
                 END IF
                 #FUN-C90126--add--str
                 IF cl_null(l_aqc02_str) THEN
                    LET g_aqc[l_ac2].aqc09 = g_aqc_t.aqc09
                    NEXT FIELD aqc09
                 END IF
                 LET g_success = 'Y'
                 COMMIT WORK
                 BEGIN WORK
                 LET l_errno = 0
                 LET l_errno2 = 0
                 LET bst= base.StringTokenizer.create(l_aqc02_str,'|')
                 CALL s_showmsg_init()
                 WHILE bst.hasMoreTokens()
                    LET temptext=bst.nextToken()
                    LET g_aqc[l_ac2].aqc09 = temptext
                    LET l_cnt=0 
                    SELECT COUNT(*) INTO l_cnt FROM aqc_file WHERE aqc01=g_aqa.aqa01 AND aqc09=g_aqc[l_ac2].aqc09
                    IF l_cnt>0 THEN
                       LET g_errno = '-239'
                       CALL s_errmsg('aqc09','',g_aqc[l_ac2].aqc09,g_errno,1)
                       LET l_errno = l_errno +1
                    END IF
                    LET l_cnt=0
                    SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01=g_aqc[l_ac2].aqc09
                    IF l_cnt=0 THEN
                       LET g_errno = 'ask-008'
                       CALL s_errmsg('aqc09','',g_aqc[l_ac2].aqc09,g_errno,1)
                       LET l_errno = l_errno +1
                    END IF
                    LET g_errno = ''
                    SELECT ima02,ima39,ima391  INTO g_aqc[l_ac2].ima02,g_aqc[l_ac2].aqc11,g_aqc[l_ac2].aqc111
                      FROM ima_file WHERE ima01=g_aqc[l_ac2].aqc09
                    CALL t910_aag(g_aqc[l_ac2].aqc11,g_plant,'1') RETURNING g_aqc[l_ac2].aag02
                    IF NOT cl_null(g_errno) THEN
                       CALL s_errmsg('aqc11','',g_aqc[l_ac2].aqc11,g_errno,1)
                       LET l_errno = l_errno +1
                    END IF
                    LET g_errno = ''
                    IF g_aza.aza63 = 'Y' THEN 
                       CALL t910_aag(g_aqc[l_ac2].aqc111,g_plant,'2') RETURNING g_aqc[l_ac2].aag02_1
                       IF NOT cl_null(g_errno) THEN
                          CALL s_errmsg('aqc111','',g_aqc[l_ac2].aqc111,g_errno,1)
                          LET l_errno = l_errno +1
                       END IF
                    END IF 
                    SELECT max(aqc03)+1  INTO g_aqc[l_ac2].aqc03 FROM aqc_file WHERE aqc01=g_aqa.aqa01
                    IF g_aqc[l_ac2].aqc03 IS NULL THEN
                       LET g_aqc[l_ac2].aqc03=1
                    END IF 
                    #INSERT aqc_file
                    INITIALIZE l_aqc.* TO NULL
                    LET l_aqc.aqc01 = g_aqa.aqa01
                    LET l_aqc.aqc02 = ' ' 
                    LET l_aqc.aqc03 = g_aqc[l_ac2].aqc03
                    LET l_aqc.aqc04 = g_aqc[l_ac2].aqc04
                    LET l_aqc.aqc05 = g_aqc[l_ac2].aqc05
                    LET l_aqc.aqc06 = g_aqc[l_ac2].aqc06
                    LET l_aqc.aqc07 = g_aqc[l_ac2].aqc07
                    LET l_aqc.aqc08 = g_aqc[l_ac2].aqc08
                    LET l_aqc.aqc09 = g_aqc[l_ac2].aqc09
                    LET l_aqc.aqc10 = g_aqc10
                    LET l_aqc.aqc11 = g_aqc[l_ac2].aqc11
                    LET l_aqc.aqc111 = g_aqc[l_ac2].aqc111
                    LET l_aqc.aqclegal = g_legal
                    LET l_aqc.aqc04 = cl_digcut(l_aqc.aqc04,g_azi03)  #MOD-D80200
                    LET l_aqc.aqc06 = cl_digcut(l_aqc.aqc06,g_azi04)  #MOD-D80200
                    LET l_aqc.aqc07 = cl_digcut(l_aqc.aqc07,g_azi03)  #MOD-D80200
                    LET l_aqc.aqc08 = cl_digcut(l_aqc.aqc08,g_azi04)  #MOD-D80200
                    INSERT INTO aqc_file VALUES(l_aqc.*)
                    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                       CALL s_errmsg('aqc02','',l_aqc.aqc02,SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       LET l_errno = l_errno +1
                    ELSE
                       LET l_errno2 = l_errno2 +1
                       LET l_ac2 = l_ac2 + 1
                    END IF
                 END WHILE
                 CALL s_showmsg()
                 IF l_errno >0 THEN
                    ROLLBACK WORK
                 ELSE
                    COMMIT WORK
                 END IF
                 IF l_errno2 = 0 THEN
                    NEXT FIELD aqc09
                 ELSE
                    CALL t910_b_fill(" 1=1")
                    CALL t910_b2_fill(" 1=1")
                    CALL t910_b()
                 END IF
                 EXIT DIALOG
                #FUN-C90126--add--end
 
               WHEN INFIELD(aqc11)
                  CALL s_get_bookno1(YEAR(g_aqa.aqa02),g_plant) RETURNING g_flag,g_bookno1,g_bookno2 
                  CALL q_m_aag(FALSE,TRUE,g_plant,g_aqc[l_ac2].aqc11,'23',g_bookno1)
                  RETURNING g_aqc[l_ac2].aqc11
                  IF cl_null(g_aqc[l_ac2].aqc11) THEN
                     LET g_aqc[l_ac2].aqc11=g_aqc_t.aqc11
                  END IF
                  CALL t910_aag(g_aqc[l_ac2].aqc11,g_plant,'1') RETURNING g_aqc[l_ac2].aag02
                  DISPLAY BY NAME g_aqc[l_ac2].aqc11
                  DISPLAY BY NAME g_aqc[l_ac2].aag02
                  NEXT FIELD aqc11
               WHEN INFIELD(aqc111) 
                  CALL s_get_bookno1(YEAR(g_aqa.aqa02),g_plant) RETURNING g_flag,g_bookno1,g_bookno2    
                  CALL q_m_aag(FALSE,TRUE,g_plant,g_aqc[l_ac2].aqc111,'23',g_bookno2)
                  RETURNING g_aqc[l_ac2].aqc111  
                  IF cl_null(g_aqc[l_ac2].aqc111) THEN
                     LET g_aqc[l_ac2].aqc11=g_aqc_t.aqc111
                  END IF
                  CALL t910_aag(g_aqc[l_ac2].aqc11,g_plant,'2') RETURNING g_aqc[l_ac2].aag02_1
                  DISPLAY BY NAME g_aqc[l_ac2].aqc11
                  DISPLAY BY NAME g_aqc[l_ac2].aag02_1
                  NEXT FIELD aqc111
              OTHERWISE
                 EXIT CASE
           END CASE
       END INPUT

       #FUN-D30032---add--begin--- 
       BEFORE DIALOG
           IF g_b_flag ='1' THEN
              NEXT FIELD aqb02
           END IF
           IF g_b_flag ='2' THEN 
              SELECT DISTINCT aqc10 INTO g_aqc10 FROM aqc_file WHERE aqc01=g_aqa.aqa01
              IF g_aqc10='3' THEN
                 NEXT FIELD aqc09
              ELSE
                 NEXT FIELD aqc02
              END IF 
           END IF
       #FUN-D30032---add--end--- 

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
            
         ON ACTION accept
             ACCEPT DIALOG

         ON ACTION EXIT
            LET INT_FLAG=FALSE
            EXIT DIALOG

         ON ACTION cancel
          #FUN-D30032---add--begin---- 
            IF p_cmd = 'a' THEN
              #LET g_action_choice = 'detail'  #TQC-D40025 mark
              #TQC-D40025--add---begin----
               IF g_b_flag = '1' AND g_rec_b != 0 THEN
                  LET g_action_choice = 'detail'
               END IF
               IF g_b_flag = '2' AND g_rec_b2 != 0 THEN
                  LET g_action_choice = 'detail'
               END IF 
              #TQC-D40025--add---end---- 
            END IF 
          #FUN-D30032---add--end----  
            LET INT_FLAG=FALSE
            DISPLAY g_aqc10 TO aqc10
            CALL t910_b_fill("1=1")
            CALL t910_b2_fill("1=1")
            EXIT DIALOG
     END DIALOG
    #aqc10=3时判断sum（aqc08）是否等于来源分摊金额总和，若不等则报错，不可离开单身
     IF g_aqc10='3' THEN 
         LET l_aqc08 = 0                       #MOD-D30224
         SELECT sum(aqc08) INTO l_aqc08 FROM aqc_file WHERE aqc01=g_aqa.aqa01
         IF cl_null(l_aqc08) THEN              #MOD-D30224
            LET l_aqc08 = 0                    #MOD-D30224
         END IF                                #MOD-D30224
         SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=g_aqb[1].aqb02
         IF l_apa00 MATCHES '2*' THEN                                      #賬款性質為2*,則分攤金額
            LET l_aqc08=l_aqc08*-1
         END IF
         IF l_aqc08<>g_aqa.aqa03 THEN 
             CALL cl_err('','aap-950',1)
             CALL t910_b()
        END IF
     END IF
     
    UPDATE aqa_file SET aqamodu = g_aqa.aqamodu,
                        aqadate = g_aqa.aqadate
     WHERE aqa01=g_aqa.aqa01
   IF SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF
    CLOSE t910_b2cl
    CLOSE t910_bcl
    CALL t910_show0()
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION t910_aqb02(p_cmd,l_cnt)
   DEFINE p_cmd           LIKE type_file.chr1    
   DEFINE l_amtf,l_amt    LIKE type_file.num20_6   
   DEFINE l_cnt  LIKE type_file.num5 
   DEFINE l_apa00       LIKE apa_file.apa00
   DEFINE l_apa42       LIKE apa_file.apa42
   DEFINE l_apa75       LIKE apa_file.apa75
   DEFINE l_cnt2 LIKE type_file.num5  
   DEFINE l_apaacti     LIKE apa_file.apaacti  
   DEFINE l_apa41       LIKE apa_file.apa41     
 
   LET g_errno = ' '
   LET g_success = 'Y'
   #TQC-CA0027--mark--str--
   #CALL s_get_bookno(YEAR(g_aqb[l_cnt].apa02))  RETURNING g_flag,g_bookno1,g_bookno2
   #IF g_flag = '1' THEN #抓不到帳別
   #     CALL cl_err(g_aqb[l_cnt].apa02,'aoo-081',1)
   #END IF
   #TQC-CA0027--mark--end--
   LET g_sql = "SELECT apa00,apa01,apa02,apa51,apa511,apa06,apa07,apa31,apa42,apa75,apaacti,apa41",
               "  FROM apa_file WHERE apa01 = ?"
   PREPARE t910_p3 FROM g_sql DECLARE t910_c3 CURSOR FOR t910_p3
   OPEN t910_c3 USING g_aqb[l_cnt].aqb02
 
   FETCH t910_c3 INTO l_apa00,g_aqb[l_cnt].aqb02,g_aqb[l_cnt].apa02,
                      g_aqb[l_cnt].apa51,g_aqb[l_cnt].apa511,g_aqb[l_cnt].apa06, 
                      g_aqb[l_cnt].apa07,g_aqb[l_cnt].aqb03,l_apa42,l_apa75,
                      l_apaacti,l_apa41  
  #FUN-C90126--mark--str
  ##TQC-CA0027--add--str--
  #CALL s_get_bookno(YEAR(g_aqb[l_cnt].apa02))  RETURNING g_flag,g_bookno1,g_bookno2
  #IF g_flag = '1' THEN #抓不到帳別
  #     CALL cl_err(g_aqb[l_cnt].apa02,'aoo-081',1)
  #END IF  
  ##TQC-CA0027--add--end--
  #FUN-C90126--mark--end

   IF p_cmd = 'd' THEN RETURN END IF
   CASE WHEN SQLCA.SQLCODE = 100  LET g_success="N"
                                  LET g_errno = 'mfg-044'
        WHEN l_apa42 = 'Y'        LET g_errno = '9024'
        WHEN l_apa75 = 'Y'        LET g_errno = 'aap-333' #外購已付款Q
        WHEN (l_apa00 !='12' AND l_apa00 !='22' AND l_apa00 !='23' AND
              l_apa00 !='13' AND l_apa00 !='25' AND l_apa00 !='16')
              LET g_success='N' LET g_errno='aap-325'
        WHEN l_apa00 = '16'
             LET l_cnt2 = 0
             SELECT COUNT(*) INTO l_cnt2 FROM apb_file
                WHERE apb01=g_aqb[l_cnt].aqb02
                  AND apb21 IS NOT NULL
             IF l_cnt2 > 0 THEN
                LET g_success='N' LET g_errno='aap-610'
             END IF
        WHEN l_apaacti='N'
             LET g_errno = 'mfg0301'
        WHEN l_apa41='N'
             LET g_errno = '9029'
 
   END CASE
   #FUN-C90126--add--str
   CALL s_get_bookno(YEAR(g_aqb[l_cnt].apa02))  RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN #抓不到帳別
        CALL cl_err(g_aqb[l_cnt].apa02,'aoo-081',1)
   END IF
   #FUN-C90126--add--end
END FUNCTION
 
FUNCTION t910_aqc03(l_cnt)
   DEFINE p_cmd           LIKE type_file.chr1    
   DEFINE l_amtf,l_amt    LIKE type_file.num20_6     
   DEFINE l_apa41         LIKE apa_file.apa41
   DEFINE l_cnt    LIKE type_file.num5   
   DEFINE l_apaacti       LIKE apa_file.apaacti   
   LET g_errno = ' '
   LET g_success = 'Y'
   LET g_sql = "SELECT apb01,apb02,apb12,apb081,apb09,apb101,apb081,apb101,apa41,apaacti",   
               "  FROM apb_file,apa_file",
               "  WHERE apa01 =?",
               "    AND apa01 = apb01 ",
               "    AND (apb34 IS NULL OR apb34 = 'N') ",   
               "    AND apb02 =?",
               "    AND (apa00 = '11' OR (apa00='16' AND apb21 IS NOT NULL)) ",  
               "    AND apb08=apb081"   
   PREPARE t910_p4 FROM g_sql
   DECLARE t910_c4 CURSOR FOR t910_p4
 
   OPEN t910_c4 USING g_aqc[l_cnt].aqc02,g_aqc[l_cnt].aqc03
   FETCH t910_c4 INTO g_aqc[l_cnt].aqc02,g_aqc[l_cnt].aqc03,g_aqc[l_cnt].aqc09,
                      g_aqc[l_cnt].aqc04,
                      g_aqc[l_cnt].aqc05,g_aqc[l_cnt].aqc06,g_aqc[l_cnt].aqc07,
                      g_aqc[l_cnt].aqc08,
                      l_apa41,l_apaacti
  
   IF p_cmd = 'd' THEN RETURN END IF
   CASE WHEN SQLCA.SQLCODE = 100   LET g_errno = 'mfg-044'
        WHEN l_apa41 = 'N'         LET g_errno = '9029' #no.7008
        WHEN l_apaacti='N'         LET g_errno = 'mfg0301'
   END CASE
 
   SELECT ima39,ima391  INTO g_aqc[l_cnt].aqc11,g_aqc[l_cnt].aqc111  FROM ima_file
    WHERE ima01=g_aqc[l_cnt].aqc09
   SELECT aag02 INTO g_aqc[l_cnt].aag02 FROM aag_file WHERE aag01=g_aqc[l_cnt].aqc11 AND aag00=g_bookno1
   SELECT aag02 INTO g_aqc[l_cnt].aag02_1 FROM aag_file WHERE aag01=g_aqc[l_cnt].aqc111 AND aag00=g_bookno2
   
   DISPLAY BY NAME g_aqc[l_cnt].aqc02,g_aqc[l_cnt].aqc03,g_aqc[l_cnt].aqc09,
                   g_aqc[l_cnt].aqc11,g_aqc[l_cnt].aqc111,g_aqc[l_cnt].aqc04,
                   g_aqc[l_cnt].aqc05,g_aqc[l_cnt].aqc06,g_aqc[l_cnt].aqc07,
                   g_aqc[l_cnt].aqc08,g_aqc[l_cnt].aag02,g_aqc[l_cnt].aag02_1
END FUNCTION

#入库单资料
FUNCTION  t910_aqc03_1(l_cnt)
   DEFINE l_cnt               LIKE type_file.num5
   DEFINE p_cmd               LIKE type_file.chr1
   DEFINE l_rvuacti           LIKE rvu_file.rvuacti
   DEFINE l_rvuconf           LIKE rvu_file.rvuconf
   DEFINE l_apa14             LIKE apa_file.apa14
   DEFINE l_rvu03             LIKE rvu_file.rvu03
   DEFINE l_rvu113            LIKE rvu_file.rvu113 
   DEFINE l_rvu02             LIKE rvu_file.rvu02
   DEFINE l_rva02             LIKE rva_file.rva02
   DEFINE l_pmm22             LIKE pmm_file.pmm22
   DEFINE l_rvv36             LIKE rvv_file.rvv36   #add by jiangln 170706


   LET g_errno = ' '
   LET g_success = 'Y'
   LET g_sql= " SELECT rvv01,rvv02,rvv31,rvv38,rvv87,rvv39,rvuacti,rvuconf ",
              "  FROM  rvu_file,rvv_file ",
              " WHERE  rvu01= rvv01 ",
              "   AND  rvv01= ? ",
              "   AND  rvv02= ? "
   PREPARE t910_p4_1 FROM g_sql
   DECLARE t910_c4_1 CURSOR FOR t910_p4_1
   OPEN t910_c4_1 USING g_aqc[l_cnt].aqc02,g_aqc[l_cnt].aqc03
   FETCH t910_c4_1 INTO g_aqc[l_cnt].aqc02,g_aqc[l_cnt].aqc03,g_aqc[l_cnt].aqc09,
                      g_aqc[l_cnt].aqc04,g_aqc[l_cnt].aqc05,g_aqc[l_cnt].aqc06,
                      l_rvuacti,l_rvuconf
   IF p_cmd = 'd' THEN RETURN END IF
   CASE WHEN SQLCA.SQLCODE = 100     LET g_errno = 'asf-700'
        WHEN l_rvuconf = 'N'         LET g_errno = '9029'
        WHEN l_rvuacti='N'           LET g_errno = 'mfg0301'
   END CASE
   SELECT ima39,ima391  INTO g_aqc[l_cnt].aqc11,g_aqc[l_cnt].aqc111  FROM ima_file 
    WHERE ima01=g_aqc[l_cnt].aqc09
   SELECT aag02 INTO g_aqc[l_cnt].aag02 FROM aag_file WHERE aag01=g_aqc[l_cnt].aqc11 AND aag00=g_bookno1
   SELECT aag02 INTO g_aqc[l_cnt].aag02_1 FROM aag_file WHERE aag01=g_aqc[l_cnt].aqc111 AND aag00=g_bookno2
   #入库单時，需將原幣換成本幣
   SELECT rvu03,rvu113 INTO l_rvu03,l_rvu113 FROM rvu_file WHERE rvu01=g_aqc[l_cnt].aqc02
   IF cl_null(l_rvu113) THEN 
      SELECT rvu02 INTO l_rvu02 FROM rvu_file WHERE rvu01=g_aqc[l_cnt].aqc02
      SELECT rva02 INTO l_rva02 FROM rva_file WHERE rva01=l_rvu02
      SELECT pmm22 INTO l_pmm22 FROM pmm_file WHERE pmm01=l_rva02
      LET l_rvu113=l_pmm22
   END IF
#add by jiangln 170706 start-----
   IF cl_null(l_rvu113) THEN 
      SELECT rvv36 INTO l_rvv36 FROM rvv_file WHERE rvv01=g_aqc[l_cnt].aqc02 AND rvv02 = g_aqc[l_cnt].aqc03
      SELECT pmm22 INTO l_pmm22 FROM pmm_file WHERE pmm01=l_rvv36
      LET l_rvu113=l_pmm22
   END IF
#add by jiangln 170706 end-------
   CALL s_curr3(l_rvu113,l_rvu03,g_apz.apz33) RETURNING l_apa14
   SELECT azi07 INTO t_azi07 FROM azi_file where azi01 = l_rvu113
   LET l_apa14 = cl_digcut(l_apa14,t_azi07)
  #LET g_aqc[l_cnt].aqc06= g_aqc[l_cnt].aqc06 * l_apa14                 #FUN-CA0100
   LET g_aqc[l_cnt].aqc04= g_aqc[l_cnt].aqc04 * l_apa14
   LET g_aqc[l_cnt].aqc06= g_aqc[l_cnt].aqc04 * g_aqc[l_cnt].aqc05      #FUN-CA0100
   LET g_aqc[l_cnt].aqc07=g_aqc[l_cnt].aqc04
   LET g_aqc[l_cnt].aqc08=g_aqc[l_cnt].aqc06 
   
   DISPLAY BY NAME g_aqc[l_cnt].aqc02,g_aqc[l_cnt].aqc03,g_aqc[l_cnt].aqc09,
                   g_aqc[l_cnt].aqc11,g_aqc[l_cnt].aqc111,g_aqc[l_cnt].aqc04,
                   g_aqc[l_cnt].aqc05,g_aqc[l_cnt].aqc06,g_aqc[l_cnt].aqc07,
                   g_aqc[l_cnt].aqc08,g_aqc[l_cnt].aag02,g_aqc[l_cnt].aag02_1
END FUNCTION

FUNCTION t910_b_askkey()
    DEFINE l_wc2           LIKE type_file.chr1000
 
    CLEAR azp02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON aqb02 
                  ,aqbud01,aqbud02,aqbud03,aqbud04,aqbud05
                  ,aqbud06,aqbud07,aqbud08,aqbud09,aqbud10
                  ,aqbud11,aqbud12,aqbud13,aqbud14,aqbud15
                 FROM s_aqb[1].aqb02
                     ,s_aqb[1].aqbud01,s_aqb[1].aqbud02,s_aqb[1].aqbud03,s_aqb[1].aqbud04,s_aqb[1].aqbud05
                     ,s_aqb[1].aqbud06,s_aqb[1].aqbud07,s_aqb[1].aqbud08,s_aqb[1].aqbud09,s_aqb[1].aqbud10
                     ,s_aqb[1].aqbud11,s_aqb[1].aqbud12,s_aqb[1].aqbud13,s_aqb[1].aqbud14,s_aqb[1].aqbud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
    CALL t910_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t910_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000 
 
   LET g_sql = "SELECT aqb02,'','','','','',aqb03,aqb04,", 
               "       aqbud01,aqbud02,aqbud03,aqbud04,aqbud05,",
               "       aqbud06,aqbud07,aqbud08,aqbud09,aqbud10,",
               "       aqbud11,aqbud12,aqbud13,aqbud14,aqbud15", 
               " FROM aqb_file",
               " WHERE aqb01 ='",g_aqa.aqa01,"'"

   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF  
   LET g_sql=g_sql CLIPPED," ORDER BY 1 "
   DISPLAY g_sql 
   PREPARE t910_pb FROM g_sql
   DECLARE aqb_curs CURSOR FOR t910_pb
 
   CALL g_aqb.clear()
   LET g_cnt = 1
   LET g_note_days = 0
   FOREACH aqb_curs INTO g_aqb[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_sql = "SELECT apa02,apa51,apa511,apa06,apa07", 
                  " FROM apa_file ",
                  "WHERE apa01 = ? "
      PREPARE t910_str6 FROM g_sql
      IF STATUS THEN
         CALL cl_err('change dbs_6 error',status,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      DECLARE z9_curs CURSOR FOR t910_str6
      OPEN z9_curs USING g_aqb[g_cnt].aqb02
      FETCH z9_curs INTO g_aqb[g_cnt].apa02,g_aqb[g_cnt].apa51,g_aqb[g_cnt].apa511, 
                         g_aqb[g_cnt].apa06, g_aqb[g_cnt].apa07
      CLOSE z9_curs
      CALL t910_aqb02('d',g_cnt)
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_aqb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   CALL t910_aqb04()
END FUNCTION
 
FUNCTION t910_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   CALL cl_set_act_visible("accept,cancel", FALSE)
   LET g_action_choice = " "
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_aqb TO s_aqb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
        LET  g_b_flag='1'
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont() 

      AFTER DISPLAY                              
         CONTINUE DIALOG
      END DISPLAY
      
   
   DISPLAY ARRAY g_aqc TO s_aqc.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         lET g_b_flag='2'

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      AFTER DISPLAY
        CONTINUE DIALOG
         
      END DISPLAY
      
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################

      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT  DIALOG
      ON ACTION first
         CALL t910_fetch('F')
         ACCEPT  DIALOG
         EXIT DIALOG
      ON ACTION previous
         CALL t910_fetch('P')
         ACCEPT DIALOG   
         EXIT DIALOG
      ON ACTION jump
         CALL t910_fetch('/')
         ACCEPT DIALOG   
         EXIT DIALOG
      ON ACTION next
         CALL t910_fetch('N')
         ACCEPT DIALOG   
         EXIT DIALOG
      ON ACTION last
         CALL t910_fetch('L')
         ACCEPT DIALOG   
         EXIT DIALOG
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()             
         IF g_aqa.aqaconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti) 
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
         
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DIALOG   
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG

      #@ON ACTION 分攤
      ON ACTION apportion
         LET g_action_choice="apportion"
         EXIT DIALOG
      #@ON ACTION 取消分攤
      ON ACTION refirm
         LET g_action_choice="refirm"
         EXIT DIALOG
      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DIALOG
      ON ACTION undo_confirm
         LET g_action_choice = "undo_confirm"
         EXIT DIALOG
      ON ACTION void   #作廢
         LET g_action_choice="void"
         EXIT DIALOG

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
      #FUN-D20035---add---end

      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DIALOG
      #@ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DIALOG
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about     
         CALL cl_about()      
 
      ON ACTION carry_voucher #傳票拋轉
         LET g_action_choice="carry_voucher"
         EXIT DIALOG
    
      ON ACTION undo_carry_voucher #傳票拋轉還原
         LET g_action_choice="undo_carry_voucher"
         EXIT DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
      ON ACTION related_document              #相關文件 
         LET g_action_choice="related_document"          
         EXIT DIALOG 
 
      ON ACTION controls                                                                                              
         CALL cl_set_head_visible("","AUTO")  
 
      &include "qry_string.4gl"
 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t910_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000 
 
   LET g_sql = "SELECT aqc02,aqc03,aqc09,'',aqc11,'',aqc111,'',aqc04,aqc05,aqc06,aqc07,aqc08,",
        "       aqcud01,aqcud02,aqcud03,aqcud04,aqcud05,",
        "       aqcud06,aqcud07,aqcud08,aqcud09,aqcud10,",
        "       aqcud11,aqcud12,aqcud13,aqcud14,aqcud15", 
               " FROM aqc_file",
               " WHERE aqc01 ='",g_aqa.aqa01,"'"
  
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
   END IF
   DISPLAY g_sql   

   PREPARE t910_aqc FROM g_sql
   DECLARE t910_aqc1 CURSOR FOR t910_aqc
 
   CALL g_aqc.clear()
   LET g_cnt = 1
   LET g_note_days = 0
   FOREACH t910_aqc1 INTO g_aqc[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      SELECT ima02 INTO g_aqc[g_cnt].ima02 FROM ima_file WHERE ima01=g_aqc[g_cnt].aqc09
      
    # SELECT aag02 INTO g_aqc[g_cnt].aag02 FROM aag_file WHERE aag01=g_aqc[g_cnt].aqc11
    #                                                      AND aag00=g_bookno1
    # SELECT aag02 INTO g_aqc[g_cnt].aag02_1 FROM aag_file WHERE aag01=g_aqc[g_cnt].aqc111
    #                                                        AND aag00=g_bookno2     
      CALL t910_aag(g_aqc[g_cnt].aqc11,g_plant,'1') RETURNING g_aqc[g_cnt].aag02        #科目名稱1
      CALL t910_aag(g_aqc[g_cnt].aqc111,g_plant,'2') RETURNING g_aqc[g_cnt].aag02_1     #科目名稱2 
      LET g_sql = "SELECT aqc04,aqc05,aqc06,aqc07,aqc08",
                  " FROM aqc_file ",
                  "WHERE aqc01 = ? ",
                  "  AND aqc02 = ? ",
                  "  AND aqc03 = ? "
      PREPARE t910_aqc6 FROM g_sql
      IF STATUS THEN
         CALL cl_err('change dbs_6 error',status,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      DECLARE z9_aqcs CURSOR FOR t910_aqc6
      OPEN z9_aqcs USING g_aqa.aqa01,g_aqc[g_cnt].aqc02,g_aqc[g_cnt].aqc03
      FETCH z9_aqcs INTO g_aqc[g_cnt].aqc04,g_aqc[g_cnt].aqc05,
                         g_aqc[g_cnt].aqc06,g_aqc[g_cnt].aqc07,
                         g_aqc[g_cnt].aqc08
      LET g_aqc[g_cnt].aqc04 = cl_digcut(g_aqc[g_cnt].aqc04,g_azi03)   #MOD-D80200
      LET g_aqc[g_cnt].aqc06 = cl_digcut(g_aqc[g_cnt].aqc06,g_azi04)   #MOD-D80200
      LET g_aqc[g_cnt].aqc07 = cl_digcut(g_aqc[g_cnt].aqc07,g_azi03) 
      LET g_aqc[g_cnt].aqc08 = cl_digcut(g_aqc[g_cnt].aqc08,g_azi04)
      CLOSE z9_aqcs
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_aqc.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn4
   CALL t910_aqc06_aqc08()
   CALL t910_aqc08_1()
END FUNCTION
 
FUNCTION t910_aqc08()
 
DEFINE l_n        LIKE type_file.num5    
DEFINE l_j        LIKE type_file.num5  
DEFINE l_aqa03    LIKE aqa_file.aqa03 
DEFINE l_aqc02    LIKE aqc_file.aqc02  
DEFINE l_aqc03    LIKE aqc_file.aqc03  
DEFINE l_aqc08    LIKE aqc_file.aqc08  
DEFINE l_aqc05    LIKE aqc_file.aqc05 
DEFINE l_aqc07    LIKE aqc_file.aqc07  
DEFINE l_diff     LIKE aqa_file.aqa03 

 
   IF g_tot IS NULL THEN LET g_tot=0 END IF
   IF g_tot1 IS NULL THEN LET g_tot1=0 END IF
   IF g_tot2 IS NULL THEN LET g_tot2=0 END IF
   IF g_tot3 IS NULL THEN LET g_tot3=0 END IF
 
   SELECT aqa03 INTO l_aqa03 FROM aqa_file where aqa01=g_aqa.aqa01
   LET l_n=g_rec_b2
 
   FOR i = 1 TO l_n
      LET g_tot=g_tot+g_aqc[i].aqc06
   END FOR
 
   FOR i = 1 TO l_n
      LET g_aqc[i].aqc08=g_aqc[i].aqc06+((g_aqc[i].aqc06/g_tot)*l_aqa03)
      LET g_aqc[i].aqc07=g_aqc[i].aqc08/g_aqc[i].aqc05
      IF g_aqc[i].aqc08 IS NULL THEN
         LET g_aqc[i].aqc08=g_aqc[i].aqc08
      END IF
      IF g_aqc[i].aqc07 IS NULL THEN
         LET g_aqc[i].aqc07=g_aqc[i].aqc07
      END IF
      LET g_aqc[i].aqc04 = cl_digcut(g_aqc[i].aqc04,g_azi03) 
      LET g_aqc[i].aqc06 = cl_digcut(g_aqc[i].aqc06,g_azi04) 
      LET g_aqc[i].aqc07 = cl_digcut(g_aqc[i].aqc07,g_azi03) 
      LET g_aqc[i].aqc08 = cl_digcut(g_aqc[i].aqc08,g_azi04)
      UPDATE aqc_file SET aqc07=g_aqc[i].aqc07,aqc08=g_aqc[i].aqc08
       WHERE aqc01=g_aqa.aqa01 AND aqc02=g_aqc[i].aqc02
         AND aqc03=g_aqc[i].aqc03
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","aqc_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
         LET g_success ='N'
         EXIT FOR
      END IF
      IF STATUS THEN LET g_success = 'N' END IF 
   END FOR
 
 
  SELECT SUM(aqc06) INTO g_tot1 FROM aqc_file where aqc01=g_aqa.aqa01
  SELECT SUM(aqc08) INTO g_tot2 FROM aqc_file where aqc01=g_aqa.aqa01
  LET g_tot3=g_tot2-g_tot1
  LET l_diff = g_tot3 - l_aqa03
  IF l_diff <> 0 THEN
     DECLARE aqc_c SCROLL CURSOR FOR  
     SELECT aqc02,aqc03,aqc08,aqc05  
        FROM aqc_file
        WHERE aqc01=g_aqa.aqa01 AND
              aqc06=(SELECT MAX(aqc06) FROM aqc_file WHERE aqc01=g_aqa.aqa01)
     OPEN aqc_c   
     FETCH FIRST aqc_c INTO l_aqc02,l_aqc03,l_aqc08,l_aqc05   
        LET l_aqc08 = cl_digcut(l_aqc08-l_diff,g_azi04)  
        LET l_aqc07 = cl_digcut((l_aqc08-l_diff)/l_aqc05,g_azi03) 
        UPDATE aqc_file SET aqc08=l_aqc08,aqc07=l_aqc07
           WHERE aqc01=g_aqa.aqa01 AND aqc02=l_aqc02 AND aqc03=l_aqc03
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   
           LET g_success='N'
        ELSE
           SELECT SUM(aqc08) INTO g_tot2 FROM aqc_file where aqc01=g_aqa.aqa01
        END IF
  END IF
  DISPLAY g_tot1 TO FORMONLY.tot1
  DISPLAY g_tot2 TO FORMONLY.tot2
  DISPLAY g_tot3 TO FORMONLY.tot3
  LET g_tot=0
                                                          
  IF g_success ='Y' THEN                                                        
     CALL t910_v('')                                                            
  END IF                                                                        
  
  CALL t910_b2_fill(' 1=1')
END FUNCTION
 
FUNCTION t910_un_aqc08()
 
DEFINE l_n   LIKE type_file.num5   
DEFINE l_j   LIKE type_file.num5    
DEFINE l_aqa03 LIKE aqa_file.aqa03  
 
    IF g_tot IS NULL THEN LET g_tot=0 END IF
    IF g_tot1 IS NULL THEN LET g_tot1=0 END IF
    IF g_tot2 IS NULL THEN LET g_tot2=0 END IF
    IF g_tot3 IS NULL THEN LET g_tot3=0 END IF
 
   SELECT aqa03 INTO l_aqa03 FROM aqa_file where aqa01=g_aqa.aqa01
   LET l_n=g_rec_b2
 
    FOR i = 1 TO l_n
      LET g_tot=g_tot+g_aqc[i].aqc06
    END FOR
 
    FOR i = 1 TO l_n
       LET g_aqc[i].aqc08=g_aqc[i].aqc06
       LET g_aqc[i].aqc07=g_aqc[i].aqc04
       UPDATE aqc_file SET aqc07=g_aqc[i].aqc07,aqc08=g_aqc[i].aqc08
        WHERE aqc01=g_aqa.aqa01 AND aqc02=g_aqc[i].aqc02
          AND aqc03=g_aqc[i].aqc03
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   
          CALL cl_err3("upd","aqc_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1) 
       END IF   
    END FOR
 
  SELECT SUM(aqc06) INTO g_tot1 FROM aqc_file where aqc01=g_aqa.aqa01
  SELECT SUM(aqc08) INTO g_tot2 FROM aqc_file where aqc01=g_aqa.aqa01
  LET g_tot3=g_tot2-g_tot1
  CALL t910_v('')    
  DISPLAY g_tot1 TO FORMONLY.tot1
  DISPLAY g_tot2 TO FORMONLY.tot2
  DISPLAY g_tot3 TO FORMONLY.tot3
  LET g_tot=0
  CALL t910_b2_fill(' 1=1')
END FUNCTION
 
FUNCTION t910_aqb04()
DEFINE l_n LIKE type_file.num5   
DEFINE l_tot  LIKE type_file.num20_6     
DEFINE l_tot4 LIKE type_file.num20_6     
DEFINE l_tot5 LIKE type_file.num20_6     
DEFINE l_tot6 LIKE type_file.num20_6     
DEFINE l_tot_aqb04 LIKE type_file.num20_6      
DEFINE l_apa00     LIKE apa_file.apa00
 
   IF l_tot IS NULL THEN LET l_tot=0 END IF
   IF l_tot4 IS NULL THEN LET l_tot4=0 END IF
   IF l_tot5 IS NULL THEN LET l_tot5=0 END IF
   IF l_tot6 IS NULL THEN LET l_tot6=0 END IF  
   LET l_n=0
   SELECT SUM(aqb04) INTO l_tot FROM aqb_file WHERE aqb01=g_aqa.aqa01
#  IF NOT cl_null(g_aqb[1].aqb02) THEN
#     SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=g_aqb[1].aqb02
#     IF l_apa00 MATCHES '2*' THEN                                      #賬款性質為2*,則分攤金額為負
#        LET l_tot=l_tot*-1
#     END IF
#  END IF 
   SELECT SUM(aqb04) INTO l_tot4 FROM aqb_file,apa_file
    WHERE aqb01=g_aqa.aqa01
      AND apa01=aqb02
      AND (apa00='23' OR apa00='25')    
   IF l_tot4 >0 THEN                                                       #預付(23/25)
      LET l_tot4=l_tot4*-1
   END IF 
   SELECT SUM(aqb04) INTO l_tot5 FROM aqb_file,apa_file
    WHERE aqb01=g_aqa.aqa01
      AND apa01=aqb02
      AND (apa00='12' OR apa00='13' OR apa00='16')     
   SELECT SUM(aqb04) INTO l_tot6 FROM aqb_file,apa_file
    WHERE aqb01=g_aqa.aqa01
      AND apa01=aqb02
      AND apa00='22'
   IF l_tot6 >0 THEN                                                        #DM
      LET l_tot6=l_tot6*-1
   END IF
   LET g_aqa03=0
   IF l_tot4<0 OR l_tot6<0 THEN
      LET l_tot=l_tot*-1
   END IF
   LET g_aqa03=l_tot
   LET g_aqa.aqa03=g_aqa03
   IF l_tot4 IS NULL THEN LET l_tot4=0 END IF
   IF l_tot5 IS NULL THEN LET l_tot5=0 END IF
   IF l_tot6 IS NULL THEN LET l_tot6=0 END IF   
   DISPLAY BY NAME g_aqa.aqa03
   DISPLAY l_tot4 TO FORMONLY.tot4
   DISPLAY l_tot5 TO FORMONLY.tot5
   DISPLAY l_tot6 TO FORMONLY.tot6 
END FUNCTION
 
FUNCTION t910_s()                  
DEFINE l_cnt     LIKE type_file.num5    
DEFINE l_cnt1    LIKE type_file.num5
DEFINE l_cnt2    LIKE type_file.num5    
DEFINE l_apydmy3 LIKE apy_file.apydmy3
DEFINE l_aqa03   LIKE aqa_file.aqa03

   IF cl_null(g_aqa.aqa01) THEN RETURN END IF
   SELECT * INTO g_aqa.* FROM aqa_file
     WHERE aqa01=g_aqa.aqa01
    IF g_aqa.aqa04 = 'Y' THEN RETURN END IF
    IF g_aqa.aqaconf='Y' THEN RETURN END IF     
    IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF 
    IF NOT cl_confirm('mfg-062') THEN RETURN END IF  
   SELECT COUNT(*) INTO l_cnt1 FROM aqb_file
    WHERE aqb01 = g_aqa.aqa01
   SELECT COUNT(*) INTO l_cnt2 FROM aqc_file
    WHERE aqc01 = g_aqa.aqa01
   IF l_cnt1=0 OR l_cnt2=0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   
   #檢查來源、目的帳款若有已作廢單號或外購，不可做分攤的動作
   IF g_aqc10='1' OR g_aqc10='2' THEN 
      SELECT COUNT(*) INTO g_cnt FROM apa_file,aqb_file
       WHERE apa01 = aqb02 AND aqb01 = g_aqa.aqa01
         AND (apa42 = 'Y' OR apa75 = 'Y')
       IF g_cnt > 0 THEN CALL cl_err('','aap-329',0) RETURN END IF
       SELECT COUNT(*) INTO g_cnt FROM apa_file,aqc_file
        WHERE apa01 = aqc02 AND aqc01 = g_aqa.aqa01
          AND (apa42 = 'Y' OR apa75 = 'Y')
       IF g_cnt > 0 THEN CALL cl_err('','aap-330',0) RETURN END IF
       CALL t910_aqc08()
   END IF

   #No:8009 分攤改為按功能鈕攤
   LET g_success='Y'
   BEGIN WORK
   OPEN t910_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_aqa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
 
     UPDATE aqa_file SET aqa04 = 'Y' WHERE aqa01 = g_aqa.aqa01
     IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   
        CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",STATUS,"","upd aqa04:",1)  
        LET g_success='N'
     END IF
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   SELECT aqa04 INTO g_aqa.aqa04 FROM aqa_file
    WHERE aqa01 = g_aqa.aqa01
   DISPLAY BY NAME  g_aqa.aqa04
END FUNCTION
 
FUNCTION t910_t()    #取消分攤 No:8009 add
   IF cl_null(g_aqa.aqa01) THEN RETURN END IF
    SELECT * INTO g_aqa.* FROM aqa_file
     WHERE aqa01=g_aqa.aqa01
   IF g_aqa.aqa04='N' THEN RETURN END IF
   IF g_aqa.aqaconf='Y' THEN RETURN END IF
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  
 
   IF NOT cl_confirm('mfg-061') THEN RETURN END IF
   BEGIN WORK LET g_success = 'Y'
   OPEN t910_cl USING g_aqa.aqa01
   FETCH t910_cl INTO g_aqa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      CLOSE t910_cl
      ROLLBACK WORK RETURN
   END IF
   CALL t910_max()

   IF g_aqc10='1' OR g_aqc10='2' THEN
      CALL t910_un_aqc08()
   END IF

   UPDATE aqa_file SET aqa04 = 'N' WHERE aqa01 = g_aqa.aqa01
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   
      CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",STATUS,"","upd aqa_file",1)  
      LET g_success = 'N'
   END IF
   IF g_success = 'N' THEN ROLLBACK WORK ELSE COMMIT WORK END IF
   SELECT aqa04 INTO g_aqa.aqa04 FROM aqa_file WHERE aqa01 = g_aqa.aqa01
   DISPLAY BY NAME  g_aqa.aqa04
END FUNCTION
 
FUNCTION t910_y()                   #No.8009 新增確認碼
DEFINE l_cnt     LIKE type_file.num5    
DEFINE l_cnt1    LIKE type_file.num5
DEFINE l_cnt2    LIKE type_file.num5    
DEFINE l_apydmy3 LIKE apy_file.apydmy3
DEFINE l_apyglcr LIKE apy_file.apyglcr         
DEFINE l_apygslp LIKE apy_file.apygslp     
DEFINE l_aqa03   LIKE aqa_file.aqa03
DEFINE l_cnt3    LIKE type_file.num5 #add by kuangxj170823

   LET g_success='Y'                         
   IF cl_null(g_aqa.aqa01) THEN RETURN END IF
   IF g_aqa.aqa04 = 'N' THEN CALL cl_err('','aap-951',0)RETURN END IF      
   IF g_aqa.aqaconf = 'Y' THEN RETURN END IF    
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF 
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   SELECT * INTO g_aqa.* FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   IF g_aqc10='1' OR g_aqc10='2'  THEN
      IF g_aqa.aqa04 = 'N' THEN RETURN END IF      #No.8009 未攤不可確認
   END IF
   IF g_aqa.aqaconf = 'Y' THEN RETURN END IF    #No.8009
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  
   #add by kuangxj 170823 begin
   LET l_cnt3=0 
   select count(*) into l_cnt3
   from apa_file ,aqa_file ,aqb_file 
   where aqa01=aqb01 and apa01=aqb02
     and apa02>aqa02 and aqa01=g_aqa.aqa01
   IF l_cnt3 >0 THEN 
     CALL cl_err('','cap-002',1)
     RETURN 
   END IF   
   #add by kuangxj 170823 end
   IF g_tot2=g_tot1 THEN
   #message "分攤前金額與分攤後金額相同!!"
   CALL cl_err('','mfg-045',0)
   RETURN END IF
   SELECT SUM(aqa03) INTO l_aqa03 FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   IF l_aqa03<>g_tot3 THEN
     CALL cl_err('','mfg-046',0)
     RETURN
   END IF
   SELECT * INTO g_aqa.* FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   SELECT COUNT(*) INTO l_cnt1 FROM aqb_file
    WHERE aqb01 = g_aqa.aqa01
   SELECT COUNT(*) INTO l_cnt2 FROM aqc_file
    WHERE aqc01 = g_aqa.aqa01
   IF l_cnt1=0 OR l_cnt2=0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   #檢查來源、目的帳款若有已作廢單號或外購，不可做分攤的動作 modi 01/08/04
   SELECT COUNT(*) INTO g_cnt FROM apa_file,aqb_file
    WHERE apa01 = aqb02 AND aqb01 = g_aqa.aqa01
      AND (apa42 = 'Y' OR apa75 = 'Y')
   IF g_cnt > 0 THEN CALL cl_err('','aap-329',0) RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM apa_file,aqc_file
    WHERE apa01 = aqc02 AND aqc01 = g_aqa.aqa01
      AND (apa42 = 'Y' OR apa75 = 'Y')
   IF g_cnt > 0 THEN CALL cl_err('','aap-330',0) RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM apa_file,aqb_file
    WHERE (apa00 = '22' OR apa00='23' OR apa00='25')  
      AND apa01=aqb_file.aqb02
      AND aqb01=g_aqa.aqa01
   LET g_t1=s_get_doc_no(g_aqa.aqa01)   
   SELECT apydmy3,apyglcr INTO l_apydmy3,l_apyglcr FROM apy_file WHERE apyslip = g_t1  
   IF l_apydmy3 = 'Y' AND l_apyglcr = 'N' THEN 
      #str----- add by dengsy170302
      IF cl_null(g_bookno1) THEN 
        SELECT aaa01 INTO g_bookno1 FROM aaa_file WHERE rownum=1
      END IF
      IF cl_null(g_bookno2) THEN 
        SELECT aaa01 INTO g_bookno2 FROM aaa_file WHERE rownum=1
      END IF 
      #end----- add by dengsy170302
      CALL s_chknpq(g_aqa.aqa01,'AP',1,'0',g_bookno1)      
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_aqa.aqa01,'AP',1,'1',g_bookno2)   
      END IF
   END IF
   IF g_success='N' THEN RETURN END IF
 
 
   LET g_success='Y'
   BEGIN WORK
   OPEN t910_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_aqa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
 
 
   IF l_apydmy3 = 'Y' AND l_apyglcr = 'Y' THEN
      CALL s_get_doc_no(g_aqa.aqa01) RETURNING g_t1
      SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
      SELECT COUNT(*) INTO g_cnt FROM npq_file
       WHERE npq01 =g_aqa.aqa01
         AND npq011=1
         AND npqsys = 'AP'      
         AND npq00=4     
      IF g_cnt =0 THEN       
         CALL t910_gen_glcr(g_aqa.*,g_apy.*)
      END IF
      IF g_success = 'Y' THEN            
         CALL s_chknpq(g_aqa.aqa01,'AP',1,'0',g_bookno1)             
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_aqa.aqa01,'AP',1,'1',g_bookno2)          
         END IF
      END IF
   END IF
   IF g_success ='N' THEN
      CLOSE t910_cl                                                                                                                 
      ROLLBACK WORK                                                                                                                 
      RETURN    
   END IF
 
   UPDATE aqa_file SET aqaconf = 'Y' WHERE aqa01 = g_aqa.aqa01
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   
      CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",STATUS,"","upd aqa04:",1)  
      LET g_success= 'N'
   END IF
   #CALL t910_hu()     #回寫 apa081
   CALL t910_apa35()   #回寫預付 apa35
   CALL t910_ins_axct002()  #向axct002中插资料
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   SELECT aqaconf INTO g_aqa.aqaconf FROM aqa_file
    WHERE aqa01 = g_aqa.aqa01
   DISPLAY BY NAME  g_aqa.aqaconf
   IF l_apydmy3 = 'Y' AND l_apyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_aqa.aqa01,'" AND npp011 = 1'
      LET g_str="aapp400 '",g_wc_gl CLIPPED,"' '",g_aqa.aqauser,"' '",g_aqa.aqauser,"' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_apy.apygslp,"' '",g_aqa.aqa02,"' 'Y' '1' 'Y' '",g_apz.apz02c,"' '",g_apy.apygslp1,"' 'Y'"    
      CALL cl_cmdrun_wait(g_str)
      SELECT aqa05 INTO g_aqa.aqa05 FROM aqa_file
       WHERE aqa01 = g_aqa.aqa01
      CALL s_errmsg('',g_aqa.aqa05,'','','')
      CALL s_showmsg()
      DISPLAY BY NAME g_aqa.aqa05
   END IF
END FUNCTION
 
FUNCTION t910_chk()
DEFINE l_n LIKE type_file.num5   
DEFINE l_d LIKE type_file.num20_6    
DEFINE l_aqa03 LIKE aqa_file.aqa03  
 
   SELECT aqa03 INTO l_aqa03 FROM aqa_file WHERE aqa01=g_aqa.aqa01
   LET l_n=g_rec_b2
   LET l_d=0
   LET l_d=l_aqa03-g_tot3
 
   FOR i = l_n TO l_n
      LET g_aqc[i].aqc08=g_aqc[i].aqc08+l_d
      LET g_aqc[i].aqc08 = cl_digcut(g_aqc[i].aqc08,g_azi04)  
      UPDATE aqc_file SET aqc08=g_aqc[i].aqc08
       WHERE aqc01=g_aqa.aqa01 AND aqc02=g_aqc[i].aqc02
         AND aqc03=g_aqc[i].aqc03
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   
         CALL cl_err3("upd","aqc_file",g_aqa.aqa01,"",STATUS,"","",1) 
      END IF   
   END FOR
 
   SELECT SUM(aqc08) INTO g_tot2 FROM aqc_file where aqc01=g_aqa.aqa01
   LET g_tot3=g_tot2-g_tot1
   DISPLAY g_tot2 TO FORMONLY.tot2
   DISPLAY g_tot3 TO FORMONLY.tot3
END FUNCTION
 
 
FUNCTION t910_z()           #取消确认
   DEFINE  l_aba19        LIKE aba_file.aba19   
   DEFINE  l_dbs          STRING               
   DEFINE  l_sql          STRING               
   DEFINE  l_aqa05        LIKE aqa_file.aqa05
   IF cl_null(g_aqa.aqa01) THEN RETURN END IF
   SELECT * INTO g_aqa.* FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   IF g_aqa.aqaconf='N' THEN RETURN END IF   
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  
 
   SELECT COUNT(*) INTO g_cnt FROM apa_file,aqb_file
    WHERE (apa00 = '22' OR apa00='23' OR apa00='25')   
      AND apa01=aqb_file.aqb02
      AND aqb01=g_aqa.aqa01
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_aqa.aqa01) RETURNING g_t1 
   SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
   IF NOT cl_null(g_aqa.aqa05) THEN
      IF NOT (g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y') THEN
         CALL cl_err(g_aqa.aqa01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' THEN
      LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   
                  "  WHERE aba00 = '",g_apz.apz02b,"'",
                  "    AND aba01 = '",g_aqa.aqa05,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_aqa.aqa05,'axr-071',1)
         RETURN
      END IF
   END IF
 
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t910_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t910_cl:", STATUS, 1)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t910_cl INTO g_aqa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      CLOSE t910_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t910_max()
   UPDATE aqa_file SET aqaconf = 'N' WHERE aqa01 = g_aqa.aqa01
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN LET g_success = 'N' END IF   
   #CALL t910_hu_z()
   CALL t910_apa35t()
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   SELECT aqaconf INTO g_aqa.aqaconf FROM aqa_file WHERE aqa01 = g_aqa.aqa01
   DISPLAY BY NAME  g_aqa.aqaconf   

   SELECT aqa05 INTO l_aqa05 FROM aqa_file WHERE aqa01=g_aqa.aqa01
   IF NOT cl_null(l_aqa05) THEN
      IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' AND g_success = 'Y' THEN
         LET g_str="aapp409 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_aqa.aqa05,"' 'Y'"
         CALL cl_cmdrun_wait(g_str)
         SELECT aqa05 INTO g_aqa.aqa05 FROM aqa_file
          WHERE aqa01 = g_aqa.aqa01
         DISPLAY BY NAME g_aqa.aqa05
      END IF
   END IF
   CALL t910_del_axct002()   #删除插入的资料 
END FUNCTION

 
FUNCTION t910_max()
DEFINE l_aqa02  LIKE aqa_file.aqa02
DEFINE l_n      LIKE type_file.num5    
 
   LET l_n=g_rec_b2
   FOR i = 1 TO l_n
      SELECT MAX(aqa02) INTO l_aqa02
        FROM aqa_file,aqc_file
       WHERE aqa01=aqc01
         AND aqc02=g_aqc[i].aqc02
         AND aqc03=g_aqc[i].aqc03
         AND aqaconf <> 'X' 
	 AND aqa04 ='Y' #add by darcy 221010            
      IF l_aqa02<>g_aqa.aqa02 and g_user<>'tiptop' THEN
         CALL cl_err('','mfg-050',0)
         LET g_success ='N'
         EXIT FOR
      END IF
   END FOR
END FUNCTION
 
FUNCTION t910_apa51()
DEFINE l_apa51 LIKE apa_file.apa51
DEFINE t_apa51 LIKE apa_file.apa51
 
   LET g_cnt=0
   SELECT apa51,COUNT(*) INTO l_apa51,g_cnt
     FROM aqc_file,apa_file
    WHERE aqc01=g_aqa.aqa01
      AND aqc02=apa01
    GROUP BY apa51
   IF cl_null(g_cnt) THEN
      LET g_cnt=0
   END IF
 
   SELECT apa51 INTO t_apa51
     FROM apa_file
    WHERE apa01=g_aqc[l_ac2].aqc02
 
   IF l_apa51 IS NULL THEN
      LET l_apa51=' '
    END IF
   IF t_apa51 IS NULL THEN
      LET t_apa51=' '
   END IF
END FUNCTION
 
FUNCTION t910_apa35()                 #分攤時,回寫來源預付的apa35
DEFINE l_apa00 LIKE apa_file.apa00
DEFINE l_apa01 LIKE apa_file.apa01
DEFINE l_apa34 LIKE apa_file.apa34   
DEFINE l_apa34f LIKE apa_file.apa34f  
DEFINE l_apa35 LIKE apa_file.apa35
DEFINE l_apa35f LIKE apa_file.apa35f
DEFINE l_apa13 LIKE apa_file.apa13    
DEFINE l_apa14 LIKE apa_file.apa14
DEFINE l_n     LIKE type_file.num5    
DEFINE l_apa11 LIKE apa_file.apa11
DEFINE l_sql   STRING
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_pmb03 LIKE pmb_file.pmb03
DEFINE l_pmb05 LIKE pmb_file.pmb05
DEFINE l_apc10 LIKE apc_file.apc10
DEFINE l_apc11 LIKE apc_file.apc11
DEFINE t_azi04_1  LIKE azi_file.azi04 

   LET l_apa35 = 0                
   SELECT COUNT(*) INTO l_n FROM aqa_file,aqb_file
    WHERE aqa01 = aqb01 AND aqb01 = g_aqa.aqa01
 
   FOR i = 1 TO l_n
      SELECT apa00,apa01,apa14,apa11,apa34,apa34f INTO l_apa00,l_apa01,l_apa14,l_apa11,l_apa34,l_apa34f      
        FROM apa_file
       WHERE apa01=g_aqb[i].aqb02
 
      SELECT azi04 INTO t_azi04 
        FROM azi_file 
       WHERE azi01 = l_apa13
  
     SELECT azi04 INTO t_azi04_1
        FROM azi_file
       WHERE azi01 = g_aza.aza17
 

      IF l_apa00='23' OR l_apa00='25' OR l_apa00='22' THEN  
         SELECT aqb04 INTO l_apa35  
           FROM aqa_file,aqb_file
          WHERE aqa01=aqb01
            AND aqa04='Y'
            AND aqaconf = 'Y'        
            AND aqb02=g_aqb[i].aqb02
            AND aqa01=g_aqa.aqa01   
         
         LET l_apa35f=0
         #IF l_apa00='23' THEN                              
          IF l_apa35 = l_apa34 THEN
             LET l_apa35f = l_apa34f
          ELSE
             LET l_apa35f=l_apa35/l_apa14
             LET l_apa35f = cl_digcut(l_apa35f,t_azi04) 
          END IF 
         #END IF                                                
         IF l_apa35 IS NULL THEN
            LET l_apa35=0
         END IF
         
         LET l_apa35 = cl_digcut(l_apa35,t_azi04_1)
         
         CALL t910_comp_oox(g_aqb[i].aqb02) RETURNING g_net
         UPDATE apa_file SET apa35=apa35 + l_apa35,
                             apa35f=apa35f + l_apa35f,
                             apa73=apa73 - l_apa35
          WHERE apa01=g_aqb[i].aqb02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   
            CALL cl_err3("upd","apa_file",g_aqb[i].aqb02,"",SQLCA.sqlcode,"","",1)  
            LET g_success='N'   
            EXIT FOR   
         END IF

         SELECT COUNT(*) INTO l_cnt FROM pmb_file WHERE pmb01=l_apa11
         IF NOT cl_null(l_apa35) AND l_apa35 <> 0 THEN            
            IF l_cnt > 0 THEN
               LET l_sql="SELECT pmb03,pmb05 ",
                         "  FROM pmb_file ",
                         " WHERE pmb01='",l_apa11,"'"
               PREPARE pmb_pl FROM l_sql
               DECLARE pmb_cl CURSOR FOR pmb_pl
               FOREACH pmb_cl INTO l_pmb03,l_pmb05
                  LET l_apc10 = l_apa35f* l_pmb05/100
                  LET l_apc11 = l_apa35 * l_pmb05/100
                  UPDATE apc_file SET apc10 = apc10 + l_apc10,
                                      apc11 = apc11 + l_apc11,
                                      apc13 = apc13 - l_apc11     
                   WHERE apc01=l_apa01 AND apc02=l_pmb03
               END FOREACH
            ELSE
               UPDATE apc_file SET apc10 = apc10 + l_apa35f,
                                   apc11 = apc11 + l_apa35,
                                   apc13 = apc13 - l_apa35        
                WHERE apc01=l_apa01
            END IF
         END IF             
      END IF    
   END FOR       
END FUNCTION
 
FUNCTION t910_apa35t()                 #分攤時,回寫來源預付的apa35
DEFINE l_apa00 LIKE apa_file.apa00
DEFINE l_apa01 LIKE apa_file.apa01
DEFINE l_apa34 LIKE apa_file.apa34    
DEFINE l_apa34f LIKE apa_file.apa34f  
DEFINE l_apa35 LIKE apa_file.apa35
DEFINE l_apa35f LIKE apa_file.apa35f
DEFINE l_apa13 LIKE apa_file.apa13   
DEFINE l_apa14 LIKE apa_file.apa14
DEFINE l_n     LIKE type_file.num5    
DEFINE l_apa11 LIKE apa_file.apa11
DEFINE l_sql   STRING
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_pmb03 LIKE pmb_file.pmb03
DEFINE l_pmb05 LIKE pmb_file.pmb05
DEFINE l_apc10 LIKE apc_file.apc10
DEFINE l_apc11 LIKE apc_file.apc11
 
   LET l_apa35 = 0               
   SELECT COUNT(*) INTO l_n FROM aqa_file,aqb_file
    WHERE aqa01 = aqb01 AND aqb01 = g_aqa.aqa01
 
   FOR i = 1 TO l_n
      SELECT apa00,apa01,apa14,apa11,apa13,apa34,apa34f 
        INTO l_apa00,l_apa01,l_apa14,l_apa11,l_apa13,l_apa34,l_apa34f     
        FROM apa_file
       WHERE apa01=g_aqb[i].aqb02
 
      SELECT azi04 INTO t_azi04 
        FROM azi_file 
       WHERE azi01 = l_apa13 

      IF l_apa00='23' OR l_apa00='25' OR l_apa00='22' THEN   
         SELECT aqb04 INTO l_apa35   
           FROM aqa_file,aqb_file
          WHERE aqb02=g_aqb[i].aqb02
            AND aqa01=aqb01
            AND aqa04='Y'
            AND aqaconf = 'N' 
            AND aqa01 = g_aqa.aqa01   
 
         IF l_apa35 IS NULL THEN LET l_apa35=0 END IF
         LET l_apa35f=0
         #IF l_apa00='23' THEN
            IF l_apa35 = l_apa34 THEN
               LET l_apa35f = l_apa34f
            ELSE
               LET l_apa35f=l_apa35/l_apa14
               LET l_apa35f = cl_digcut(l_apa35f,t_azi04)    
            END IF                                             
         #END IF                                            
         CALL t910_comp_oox(g_aqb[i].aqb02) RETURNING g_net
         UPDATE apa_file SET apa35=apa35 - l_apa35,
                             apa35f=apa35f - l_apa35f,
                             apa73=apa73 + l_apa35
          WHERE apa01=g_aqb[i].aqb02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   
            CALL cl_err3("upd","apa_file",g_aqb[i].aqb02,"",SQLCA.sqlcode,"","",1)  
            LET g_success='N'   
            EXIT FOR   
         END IF

         SELECT COUNT(*) INTO l_cnt FROM pmb_file WHERE pmb01=l_apa11
         IF NOT cl_null(l_apa35) AND l_apa35 <> 0 THEN           
            IF l_cnt > 0 THEN
               LET l_sql="SELECT pmb03,pmb05 ",
                         "  FROM pmb_file ",
                         " WHERE pmb01='",l_apa11,"'"
               PREPARE pmb_p2 FROM l_sql
               DECLARE pmb_c2 CURSOR FOR pmb_p2
               FOREACH pmb_c2 INTO l_pmb03,l_pmb05
                  LET l_apc10 = l_apa35f* l_pmb05/100
                  LET l_apc11 = l_apa35 * l_pmb05/100
                  UPDATE apc_file SET apc10 = apc10 - l_apc10,
                                      apc11 = apc11 - l_apc11,
                                      apc13 = apc13 + l_apc11    
                   WHERE apc01=l_apa01 AND apc02=l_pmb03
               END FOREACH
            ELSE
               UPDATE apc_file SET apc10 = apc10 - l_apa35f,
                                   apc11 = apc11 - l_apa35,
                                   apc13 = apc13 + l_apa35      
                WHERE apc01=l_apa01
            END IF
         END IF              
      END IF       
   END FOR         
END FUNCTION
 
FUNCTION t910_v(p_cmd)
   DEFINE l_wc    LIKE type_file.chr1000 
   DEFINE p_cmd   LIKE type_file.chr1   
   DEFINE l_aqa01 LIKE aqa_file.aqa01
   DEFINE only_one   LIKE type_file.chr1      
   DEFINE l_t1       LIKE apy_file.apyslip                 
   DEFINE l_cnt      LIKE type_file.num5   
   DEFINE l_apydmy3  LIKE type_file.chr1      
   DEFINE l_apa00    LIKE apa_file.apa00

   IF cl_null(g_aqa.aqa01) THEN
      CALL cl_err('',-400,1) 
      RETURN
   END IF

   IF p_cmd = '4' THEN 
      LET g_t1=s_get_doc_no(g_aqa.aqa01)
      SELECT apydmy3 INTO l_apydmy3 FROM apy_file
       WHERE apyslip = g_t1
      IF l_apydmy3 = 'N' THEN 
         CALL cl_err('','mfg9310',1) 
         RETURN 
      END IF 
   END IF 
 
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  
   IF p_cmd  = '4' THEN
      OPEN WINDOW t910_w9 AT 10,10 WITH FORM "aap/42f/aapt910_9"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_locale("aapt910_9")
 
 
      LET only_one = '1'
      CALL cl_set_head_visible("","YES")     			
 
      INPUT BY NAME only_one WITHOUT DEFAULTS
         AFTER FIELD only_one
            IF NOT cl_null(only_one) THEN
               IF only_one NOT MATCHES "[12]" THEN
                  NEXT FIELD only_one
               END IF
            END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg     
         CALL cl_cmdask()
 
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t910_w9
         RETURN
      END IF
      IF only_one = '1' THEN
         LET l_wc = " aqa01 = '",g_aqa.aqa01,"' "
      ELSE
         CALL cl_set_head_visible("","YES")   
 
         CONSTRUCT BY NAME l_wc ON aqa01,aqa02
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              ON ACTION controlp
                 CASE
                    WHEN INFIELD(aqa01) #查詢單据
                  LET g_t1=s_get_doc_no(g_aqa.aqa01)
                       CALL q_apy(FALSE,FALSE,g_t1,g_aptype,'AAP') RETURNING g_t1    
                       LET g_aqa.aqa01=g_t1
                       DISPLAY BY NAME g_aqa.aqa01
                       NEXT FIELD aqa01
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
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW t910_w9
         RETURN
      END IF
      END IF
      CLOSE WINDOW t910_w9
   END IF
 
   LET g_success='Y'
   BEGIN WORK
   MESSAGE "WORKING !"
 
   IF cl_null(l_wc) THEN LET l_wc = " aqa01 = '",g_aqa.aqa01,"' "  END IF  
   LET g_sql = "SELECT aqa01 FROM aqa_file WHERE ",l_wc CLIPPED,
               "   AND (aqa05 IS NULL OR aqa05 = ' ')"
   PREPARE t910_v_p FROM g_sql
   DECLARE t910_v_c CURSOR WITH HOLD FOR t910_v_p
   FOREACH t910_v_c INTO l_aqa01
      IF STATUS THEN EXIT FOREACH END IF
      LET l_t1 = s_get_doc_no(l_aqa01)      
      LET l_apydmy3 = ''
      SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = l_t1
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","apy_file",l_t1,"",STATUS,"","sel apy:",1)  
         LET g_success = 'N'   
         EXIT FOREACH   
      END IF
      IF l_apydmy3 = 'Y' THEN        #是否拋轉傳票
         CALL t910_g_gl(l_aqa01,'0') #產生第一分錄
         IF g_aza.aza63 = 'Y' THEN
            CALL t910_g_gl(l_aqa01,'1') #產生第二分錄
         END IF
      END IF
   END FOREACH
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   MESSAGE " "
END FUNCTION
 
FUNCTION t910_npp02(p_npptype)  
DEFINE p_npptype  LIKE npp_file.npptype 
DEFINE l_n        LIKE type_file.num5
   LET l_n=0
   SELECT COUNT(*) INTO l_n FROM npp_file WHERE npp01=g_aqa.aqa01
                                            AND npp011=1
                                            AND nppsys = 'AP'
                                            AND npp00=4
                                            AND npptype=p_npptype
   IF l_n>0 THEN    
      UPDATE npp_file SET npp02=g_aqa.aqa02
       WHERE npp01=g_aqa.aqa01
         AND npp011=1
         AND nppsys = 'AP'
         AND npp00=4      
         AND npptype=p_npptype  
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   
         CALL cl_err3("upd","npp_file",g_aqa.aqa01,"",STATUS,"","upd npp02:",1)  
      END IF
  END IF
END FUNCTION
 
FUNCTION t910_o()
    DEFINE
        l_i             LIKE type_file.num5,    
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  
        l_za05          LIKE type_file.chr1000,               
        l_sql           LIKE type_file.chr1000, 
        l_apa00         LIKE apa_file.apa00,
        l_apa01         LIKE apa_file.apa01,
        l_apa02         LIKE apa_file.apa02,
        l_apa51         LIKE apa_file.apa51,
        l_apa06         LIKE apa_file.apa06,
        l_apa07         LIKE apa_file.apa07,
        sr        RECORD
                  aqa01 LIKE  aqa_file.aqa01,
                  aqa02 LIKE  aqa_file.aqa02,
                  aqa03 LIKE  aqa_file.aqa03,
                  aqa04 LIKE  aqa_file.aqa04,
                  aqa05 LIKE  aqa_file.aqa05,
                  apa00 LIKE  apa_file.apa00,
                  apa01 LIKE  apa_file.apa01,
                  apa02 LIKE  apa_file.apa02,
                  apa51 LIKE  apa_file.apa51,
                  apa06 LIKE  apa_file.apa06,
                  apa07 LIKE  apa_file.apa07,
                  aqb01 LIKE  aqb_file.aqb01,
                  aqb02 LIKE  aqb_file.aqb02,
                  aqb03 LIKE  aqb_file.aqb03,
                  aqb04 LIKE  aqb_file.aqb04
              END RECORD,
       sr1  RECORD
                  aqc01 LIKE  aqc_file.aqc01,
                  aqc02 LIKE  aqc_file.aqc02,
                  aqc03 LIKE  aqc_file.aqc03,
                  aqc05 LIKE  aqc_file.aqc05,
                  aqc04 LIKE  aqc_file.aqc04,
                  aqc06 LIKE  aqc_file.aqc06,
                  aqc07 LIKE  aqc_file.aqc07,
                  aqc08 LIKE  aqc_file.aqc08
             END RECORD
    DEFINE l_apb12   LIKE apb_file.apb12     
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    
       EXIT PROGRAM
    END IF
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep1 FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep1:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    
       EXIT PROGRAM
    END IF
 
    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1)
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'aapt910'
    IF g_len = 0 OR g_len IS NULL THEN
       LET g_len = 80
    END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET l_sql="SELECT aqc01,aqc02,aqc03,aqc05,aqc04,aqc06,aqc07,aqc08",
               "  FROM aqc_file ",
               " WHERE aqc01='",g_aqa.aqa01,"'"
    PREPARE t910_p1a FROM l_sql
    DECLARE t910_coa CURSOR FOR t910_p1a
 
    LET g_sql="SELECT aqa01,aqa02,aqa03,aqa04,aqa05,'','','',",
              " '','','',aqb01,aqb02,aqb03,aqb04 ",
              " FROM aqa_file,aqb_file",
              " WHERE aqa01='",g_aqa.aqa01,"'",
              "   AND aqa01=aqb01 "
    PREPARE t910_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t910_co                         # SCROLL CURSOR
        SCROLL CURSOR FOR t910_p1
 
    FOREACH t910_co INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
          END IF
       LET l_apa02 = NULL
       SELECT apa00,apa01,apa02,apa51,apa06,apa07
         INTO l_apa00,l_apa01,l_apa02,l_apa51,l_apa06,l_apa07
         FROM apa_file
        WHERE apa01=sr.aqb02
       LET sr.apa00=l_apa00
       LET sr.apa01=l_apa01
       LET sr.apa02=l_apa02
       LET sr.apa51=l_apa51
       LET sr.apa06=l_apa06
       LET sr.apa07=l_apa07
       EXECUTE insert_prep USING sr.aqa01,sr.aqa02,sr.aqa03,sr.aqa05,sr.apa00,
                                 sr.apa01,sr.apa02,sr.apa51,sr.apa06,sr.apa07,
                                 sr.aqb03,sr.aqb04,sr.aqb01,sr.aqb02
 
    END FOREACH
    FOREACH t910_coa INTO sr1.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0)
               EXIT FOREACH
       END IF
       SELECT apb12 INTO l_apb12 FROM apb_file
          WHERE apb01=sr1.aqc02 AND apb02=sr1.aqc03
       EXECUTE insert_prep1 USING sr.aqa01,sr1.aqc02,sr1.aqc03,l_apb12,
                                  sr1.aqc05,sr1.aqc04,sr1.aqc06,sr1.aqc07,
                                  sr1.aqc08
    END FOREACH
 
    CLOSE t910_co
    ERROR ""
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'aqa01, aqa02, aqainpd, aqa04, aqaconf, aqauser, aqagrup, aqamodu,aqadate, aqaacti')
            RETURNING g_wc
       LET g_str=g_wc
    END IF
    LET g_str = g_str,";",g_azi05
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
    CALL cl_prt_cs3('aapt910','aapt910',l_sql,g_str)
END FUNCTION
 
FUNCTION t910_apa51_b()
DEFINE l_n   LIKE type_file.num5    
DEFINE l_j   LIKE type_file.num5  
DEFINE l_apa51 LIKE type_file.num5       
 
   LET g_cnt=0
   LET g_success='Y'
   SELECT UNIQUE apa51 FROM apa_file,aqb_file
    WHERE aqb01=g_aqa.aqa01
      AND apa01=aqb02
      AND (apa00='12' OR apa00='13')  
   INTO TEMP tmpa;
   SELECT COUNT(*) INTO g_cnt FROM tmpa
 
   IF g_cnt>1 THEN
      CALL cl_err('','mfg-035',0)
      LET g_success='N'
   END IF
   DELETE FROM tmpa;
END FUNCTION
 
FUNCTION t910_apa51_b2()
DEFINE l_n   LIKE type_file.num5  
DEFINE l_j   LIKE type_file.num5    
DEFINE l_apa51 LIKE apa_file.apa51
 
   LET g_cnt=0
   LET g_success='Y'
   SELECT UNIQUE apa51 FROM apa_file,aqc_file
    WHERE aqc01=g_aqa.aqa01
      AND apa01=aqc02
      AND apa00='11'
   INTO TEMP tmpb;
   SELECT COUNT(*) INTO g_cnt FROM tmpb
 
   IF g_cnt>1 THEN
      CALL cl_err('','mfg-036',0)
      LET g_success='N'
   END IF
   DELETE FROM tmpb;
END FUNCTION
 
FUNCTION t910_apa51_all()
DEFINE l_apa51 LIKE apa_file.apa51
 
   LET g_success='Y'
   #'12'的借方科目
   SELECT UNIQUE apa51 INTO g_apa51 FROM apa_file,aqb_file
    WHERE aqb01=g_aqa.aqa01
      AND apa01=aqb02
      AND (apa00='12' OR apa00='13')  
   IF g_apa51 IS NULL THEN
      CALL cl_err('g_apa51 null','',0)
      LET g_apa51=' '
   END IF
 
   SELECT UNIQUE apa51 INTO l_apa51 FROM apa_file,aqc_file
    WHERE aqc01=g_aqa.aqa01
      AND apa01=aqc02
      AND apa00='11'
 
   IF l_apa51 IS NULL THEN
      CALL cl_err('l_apa51 null','',0)
      LET l_apa51=' '
   END IF
 
   IF g_apa51<>l_apa51 THEN
      CALL cl_err('','mfg-037',0)
      LET g_success='N'
   END IF
   LET g_apa51=''
   LET l_apa51=''
END FUNCTION
 
FUNCTION t910_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aqa01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t910_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aqa01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t910_comp_oox(p_apv03)
DEFINE l_net     LIKE apv_file.apv04
DEFINE p_apv03   LIKE apv_file.apv03
DEFINE l_apa00   LIKE apa_file.apa00
 
    LET l_net = 0
    IF g_apz.apz27 = 'Y' THEN
       SELECT SUM(oox10) INTO l_net FROM oox_file
        WHERE oox00 = 'AP' AND oox03 = p_apv03
       IF cl_null(l_net) THEN
          LET l_net = 0
       END IF
    END IF
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
 
FUNCTION t910_gen_glcr(p_aqa,p_apy)    #产生分录底稿
  DEFINE p_aqa     RECORD LIKE aqa_file.*
  DEFINE p_apy     RECORD LIKE apy_file.*
 
    IF cl_null(p_apy.apygslp) THEN
       CALL cl_err(p_aqa.aqa01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t910_g_gl(p_aqa.aqa01,'0')    #第一分錄
    IF g_aza.aza63 = 'Y' THEN
       CALL t910_g_gl(p_aqa.aqa01,'1') #產生第二分錄
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t910_carry_voucher()
  DEFINE l_apygslp    LIKE apy_file.apygslp
  DEFINE li_result    LIKE type_file.num5     
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    
 
    IF cl_null(g_aqa.aqa01) THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
 
    IF NOT cl_null(g_aqa.aqa05) OR g_aqa.aqa05 IS NOT NULL THEN
       CALL cl_err(g_aqa.aqa05,'aap-618',1)
       RETURN
    END IF   
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_aqa.aqa01) RETURNING g_t1
    SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
    IF g_apy.apydmy3 = 'N' THEN RETURN END IF
    IF g_apy.apyglcr = 'Y' OR (g_apy.apyglcr ='N' AND NOT cl_null(g_apy.apygslp)) THEN 
       LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),   
                   "  WHERE aba00 = '",g_apz.apz02b,"'",
                   "    AND aba01 = '",g_aqa.aqa05,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_aqa.aqa05,'aap-991',1)
          RETURN
       END IF
 
       LET l_apygslp = g_apy.apygslp
    ELSE
    	 CALL cl_err('','aap-936',1)     
       RETURN
 
    END IF
    IF cl_null(l_apygslp) OR (cl_null(g_apy.apygslp1) AND g_aza.aza63 = 'Y') THEN
       CALL cl_err(g_aqa.aqa01,'axr-070',1)
       RETURN
    END IF
                                          
    LET g_wc_gl = 'npp01 = "',g_aqa.aqa01,'" AND npp011 = 1'
    LET g_str="aapp400 '",g_wc_gl CLIPPED,"' '",g_aqa.aqauser,"' '",g_aqa.aqauser,"' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",l_apygslp,"' '",g_aqa.aqa02,"' 'Y' '1' 'Y' '",g_apz.apz02c,"' '",g_apy.apygslp1,"' 'Y'"    
    CALL cl_cmdrun_wait(g_str)
    SELECT aqa05 INTO g_aqa.aqa05 FROM aqa_file
     WHERE aqa01 = g_aqa.aqa01
    CALL s_errmsg('',g_aqa.aqa05,'','','')
    CALL s_showmsg()
    DISPLAY BY NAME g_aqa.aqa05
    
END FUNCTION
 
FUNCTION t910_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 
  DEFINE l_dbs      STRING
    
    IF cl_null(g_aqa.aqa01) THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF

    IF cl_null(g_aqa.aqa05) OR g_aqa.aqa05 IS NULL THEN
       CALL cl_err(g_aqa.aqa05,'aap-619',1)
       RETURN
    END IF   
    
    IF NOT cl_confirm('aap-988') THEN RETURN END IF 
 
    CALL s_get_doc_no(g_aqa.aqa01) RETURNING g_t1
    SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
    IF g_apy.apydmy3 = 'N' THEN RETURN END IF   
    IF g_apy.apyglcr = 'N' AND cl_null(g_apy.apygslp)THEN 
    	 CALL cl_err('','aap-936',1)   
       RETURN
    END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),  
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_aqa.aqa05,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql 
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_aqa.aqa05,'axr-071',1)
       RETURN
    END IF
    LET g_str="aapp409 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_aqa.aqa05,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT aqa05 INTO g_aqa.aqa05 FROM aqa_file
     WHERE aqa01 = g_aqa.aqa01
    DISPLAY BY NAME g_aqa.aqa05
END FUNCTION

FUNCTION t910_aqc06_aqc08()
   IF g_tot1 IS NULL THEN LET g_tot1=0 END IF
   IF g_tot2 IS NULL THEN LET g_tot2=0 END IF
   IF g_tot3 IS NULL THEN LET g_tot3=0 END IF
   SELECT SUM(aqc06) INTO g_tot1 FROM aqc_file where aqc01=g_aqa.aqa01
   SELECT SUM(aqc08) INTO g_tot2 FROM aqc_file where aqc01=g_aqa.aqa01
   LET g_tot3=g_tot2-g_tot1
   DISPLAY g_tot1   TO FORMONLY.tot1
   DISPLAY g_tot2   TO FORMONLY.tot2
   DISPLAY g_tot3   TO FORMONLY.tot3
END FUNCTION

FUNCTION t910_aqc08_1()   #目的類型為料號時對應的分攤金額匯總
   DEFINE l_aqc08    LIKE aqc_file.aqc08
   IF l_aqc08 IS NULL THEN LET l_aqc08=0 END IF
   SELECT SUM(aqc08) INTO l_aqc08 FROM aqc_file where aqc01=g_aqa.aqa01
   DISPLAY l_aqc08  TO FORMONLY.tot7
END FUNCTION 

FUNCTION t910_show0()
   DEFINE   ls_msg  LIKE type_file.chr1000
   IF g_lang='1' THEN RETURN END IF
   IF cl_null(g_aqc10) OR g_aqc10 IS NULL THEN
      LET g_aqc10='1'
   END IF
   CASE g_aqc10
       WHEN '1'
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'aap-946' AND ze02 = g_lang
         CALL cl_set_comp_att_text("aqc02",ls_msg CLIPPED || "," || ls_msg CLIPPED)
         CALL cl_set_comp_visible("ima02,aqc111,aag02_1,tot7",FALSE)
         CALL cl_set_comp_visible("aqc02,aqc03,aqc09,aqc11,aag02,aqc04,aqc05,aqc06,aqc07,aqc08,tot1,tot2,tot3",TRUE) #FUN-CA0100 del-'-,='
         CALL cl_set_comp_entry("aqc08,aqc09",FALSE)
       WHEN '2'
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'aap-947' AND ze02 = g_lang
         CALL cl_set_comp_att_text("aqc02",ls_msg CLIPPED || "," || ls_msg CLIPPED)
         CALL cl_set_comp_visible("ima02,aqc111,aag02_1,tot7",FALSE)
         CALL cl_set_comp_visible("aqc02,aqc03,aqc09,aqc11,aag02,aqc04,aqc05,aqc06,aqc07,aqc08,tot1,tot2,tot3",TRUE) #FUN-CA0100 del-'-,='
         CALL cl_set_comp_entry("aqc08,aqc09",FALSE)
       WHEN '3'
         SELECT ze03 INTO ls_msg FROM ze_file WHERE ze01 = 'aap-948' AND ze02 = g_lang
         CALL cl_set_comp_att_text("aqc08",ls_msg CLIPPED || "," || ls_msg CLIPPED)
         CALL cl_set_comp_visible("aqc02,aqc03,aqc04,aqc05,aqc06,aqc07,aqc08,
                                   aqcud01,aqcud02,aqcud03,aqcud04,aqcud05,
                                   aqcud06,aqcud07,aqcud08,aqcud09,aqcud10,
                                   aqcud11,aqcud12,aqcud13,aqcud14,aqcud15,tot1,tot2,tot3",FALSE)     #FUN-CA0100 del-'-,='
        IF g_aza.aza63='N' THEN
           CALL cl_set_comp_visible("aqc09,ima02,aqc11,aag02,aqc08,tot7",TRUE)
        ELSE
           CALL cl_set_comp_visible("aqc09,ima02,aqc11,aag02,aqc111,aag02_1,aqc08,tot7",TRUE)
        END IF
        CALL cl_set_comp_entry("aqc08,aqc09",TRUE)
       CALL cl_show_fld_cont()                   
   END CASE  
END FUNCTION

#确认时，往axct002中插入资料
FUNCTION t910_ins_axct002()
DEFINE l_success        LIKE type_file.chr1
DEFINE l_ccb            RECORD LIKE ccb_file.*
DEFINE l_msg            STRING
DEFINE g_t           LIKE ccb_file.ccb06
DEFINE g_tt          LIKE ccb_file.ccb07
DEFINE l_count       LIKE type_file.num5
DEFINE l_aqc08       LIKE aqc_file.aqc08
DEFINE l_aqc06       LIKE aqc_file.aqc06
DEFINE l_aqc09       LIKE aqc_file.aqc09
DEFINE l_aqc10       LIKE aqc_file.aqc10
DEFINE l_apa00       LIKE apa_file.apa00
DEFINE l_pja01       LIKE pja_file.pja01
DEFINE l_imd09       LIKE imd_file.imd09 

    IF cl_null(g_aqa.aqa01) THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF

    IF g_aqc.getLength() = 0 THEN
       RETURN
    END IF

   OPEN WINDOW p910_3_w AT 0,0 WITH FORM "aap/42f/aapt910_3"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("aapt910_3")
    SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'
    LET g_t=g_ccz.ccz28
    DISPLAY BY NAME g_t
    CALL cl_set_comp_entry("g_tt",FALSE)
    INPUT BY NAME g_t,g_tt WITHOUT DEFAULTS

        BEFORE INPUT
            CALL cl_qbe_init()


        AFTER FIELD g_t
          IF g_t IS NOT NULL THEN
            IF g_t NOT MATCHES '[12345]' THEN
               NEXT FIELD g_t
            END IF
            IF g_t MATCHES'[12]' THEN
               CALL cl_set_comp_entry("g_tt",FALSE)
               LET g_tt= ' '
            ELSE
               CALL cl_set_comp_entry("g_tt",TRUE)
            END IF
          END IF


        ON CHANGE g_t
          IF g_t IS NOT NULL THEN
            IF g_t='1'OR g_t='2' THEN 
               CALL cl_set_comp_entry("g_tt",FALSE)
            ELSE 
               CALL cl_set_comp_entry("g_tt",TRUE)
            END IF    
          END IF

        AFTER FIELD g_tt
           IF NOT cl_null(g_tt) OR g_tt != ' '  THEN
               IF g_t='4'THEN
                  SELECT pja01 INTO l_pja01 FROM pja_file WHERE pja01=g_tt
                                             AND pjaclose='N'     
                  IF STATUS THEN
                     CALL cl_err3("sel","pja_file",g_tt,"",STATUS,"","sel pja:",1)
                     NEXT FIELD g_tt
                  END IF
               END IF
               IF g_t='5'THEN
                  SELECT UNIQUE imd09 INTO l_imd09 FROM imd_file WHERE imd09=g_tt
                  IF STATUS THEN
                     CALL cl_err3("sel","imd_file",g_tt,"",STATUS,"","sel imd:",1)     
                     NEXT FIELD g_tt
                  END IF
               END IF
            ELSE
               LET g_tt = ' '
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
         ON ACTION CONTROLP
              CASE WHEN INFIELD(g_tt)
                 IF g_t MATCHES '[45]' THEN
                    CALL cl_init_qry_var()
                 CASE g_t
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"
                    WHEN '5'
                      LET g_qryparam.form = "q_gem4"
                    OTHERWISE EXIT CASE
                 END CASE
                 LET g_qryparam.default1 = g_tt
                 CALL cl_create_qry() RETURNING g_tt
                 DISPLAY BY NAME  g_tt
                 NEXT FIELD g_tt
                 END IF
              END CASE

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

    END INPUT

    IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW p910_3_w RETURN END IF
    CLOSE WINDOW p910_3_w

       LET l_count = 0
       SELECT COUNT(*) INTO l_count
         FROM ccb_file
        WHERE ccb02 = YEAR (g_aqa.aqa02)
          AND ccb03 = MONTH (g_aqa.aqa02)
          AND ccb04 =g_aqa.aqa01
          AND ccb06 = g_t
          AND ccb07 = g_tt
       IF l_count >0  THEN
          CALL cl_err('','axc-706',1)
          RETURN
       END IF

       SELECT apa00 INTO l_apa00 FROM apa_file,aqb_file 
        WHERE apa01=aqb02 AND aqb02=g_aqb[1].aqb02
  
       LET g_sql=" SELECT SUM(aqc08),SUM(aqc06),aqc09,aqc10 FROM aqc_file ",
                 "  WHERE aqc01='",g_aqa.aqa01,"' ",
                 "  GROUP BY aqc09,aqc10 "
       PREPARE ccb_pre FROM g_sql
       DECLARE ccb_cur CURSOR FOR ccb_pre 
       FOREACH ccb_cur INTO l_aqc08,l_aqc06,l_aqc09,l_aqc10
       	IF l_apa00 MATCHES '2*' THEN
           IF l_aqc10='3' THEN
               LET l_aqc08=l_aqc08*-1
           END IF
        END IF
        IF cl_null(l_aqc08) THEN LET l_aqc08 = 0 END IF 
        IF cl_null(l_aqc06) THEN LET l_aqc06 = 0 END IF 
        LET l_ccb.ccb01 = l_aqc09 
        LET l_ccb.ccb02 = YEAR (g_aqa.aqa02)
        LET l_ccb.ccb03 = MONTH (g_aqa.aqa02)
        LET l_ccb.ccb04 = g_aqa.aqa01
        LET l_ccb.ccb05 = cl_getmsg('aap-949',g_lang)
        LET l_ccb.ccb06 = g_t
        IF l_ccb.ccb06 ='1'  OR l_ccb.ccb06='2' THEN
           LET l_ccb.ccb07=' ' 
        ELSE
           LET l_ccb.ccb07 = g_tt
        END IF

        LET l_ccb.ccb22 = l_aqc08-l_aqc06
        LET l_ccb.ccb22a= l_aqc08-l_aqc06
        LET l_ccb.ccb22b= 0
        LET l_ccb.ccb22c= 0
        LET l_ccb.ccb22d= 0
        LET l_ccb.ccb22e= 0
        LET l_ccb.ccb22f= 0
        LET l_ccb.ccb22g= 0
        LET l_ccb.ccb22h= 0
        LET l_ccb.ccbacti = 'Y'
        LET l_ccb.ccbuser = g_user
        LET l_ccb.ccboriu = g_user
        LET l_ccb.ccbgrup = g_grup
        LET l_ccb.ccborig = g_grup
        LET l_ccb.ccblegal= g_legal
        LET l_ccb.ccbdate = g_today
        LET l_ccb.ccb23 = '3'
        INSERT INTO ccb_file VALUES(l_ccb.*)
        IF SQLCA.SQLCODE THEN
           LET g_success = 'N'
           EXIT FOREACH
        END IF
    END FOREACH

END FUNCTION


#取消确认时，删除axct002中相应的资料
FUNCTION t910_del_axct002()
   IF cl_null(g_aqa.aqa01) THEN
       CALL cl_err('',-400,1)
       RETURN
    END IF
    DELETE FROM ccb_file WHERE ccb04=g_aqa.aqa01
                           AND ccb02=YEAR(g_aqa.aqa02) 
                           AND ccb03= MONTH (g_aqa.aqa02)
     IF SQLCA.SQLCODE THEN
         LET g_success = 'N'
     END IF          
END FUNCTION

#科目名称
FUNCTION t910_aag(p_key,p_plant,p_flag)  #No.TQC-A90063
DEFINE
      l_sql      LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(500)
      l_aagacti  LIKE aag_file.aagacti,
      l_aag02    LIKE aag_file.aag02,
      l_aag07    LIKE aag_file.aag07,
      l_aag03    LIKE aag_file.aag03,
      l_aag09    LIKE aag_file.aag09,
      p_key      LIKE aag_file.aag01,
      p_dbs      LIKE type_file.chr21    #No.FUN-680107 VARCHAR(21)
DEFINE  l_flag1        LIKE type_file.chr1       #No.FUN-730032
DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-730032
DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-730032
DEFINE  p_plant        LIKE type_file.chr10      #FUN-980020
DEFINE  p_flag         LIKE type_file.chr1       #No.TQC-A90063
DEFINE  l_bookno3      LIKE aag_file.aag00       #No.TQC-A90063

   CALL s_get_bookno1(YEAR(g_aqa.aqa02),p_plant) RETURNING l_flag1,l_bookno1,l_bookno2   #FUN-980020
   IF l_flag1 = '1' THEN
       LET g_errno = 'aoo-081'
       RETURN ' '
   END IF

    IF p_flag = '1' THEN
       LET l_bookno3 = l_bookno1
    ELSE
       LET l_bookno3 = l_bookno2
    END IF

    LET g_errno = " "
    LET l_sql =
               "SELECT aag02,aagacti,aag07,aag03,aag09 FROM ",cl_get_target_table(p_plant,'aag_file'), 
               " WHERE aag01 = '",p_key,"'",
               "   AND aag00 = '",l_bookno3,"'"  
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql   
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
    PREPARE aag_pre FROM l_sql
    DECLARE aag_cur CURSOR FOR aag_pre
    OPEN aag_cur
    FETCH aag_cur INTO l_aag02,l_aagacti,l_aag07,l_aag03,l_aag09
    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                  LET l_aag02 = NULL
                                  LET l_aagacti = NULL
         WHEN l_aagacti='N'       LET g_errno = '9028'
         WHEN l_aag07  ='1'       LET g_errno = 'agl-131'
         WHEN l_aag03  ='4'       LET g_errno = 'agl-912'
         WHEN l_aag09  ='N'       LET g_errno = 'agl-913'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   RETURN l_aag02
END FUNCTION
#FUN-C70093
