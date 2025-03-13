# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: aglq009.4gl
# Descriptions...: 現金流量表直接法查询资料
# Date & Author..: 2010/11/12 By wuxj   
# Modify.........: NO.FUN-B40104 By jll   合并报表作业
# Modify.........: No.TQC-B70141 By guoch 查詢時，合并帳套取值錯誤

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE   g_aep      RECORD LIKE aep_file.*
DEFINE   g_aep_t    RECORD LIKE aep_file.*
DEFINE   g_aep01_1  LIKE axa_file.axa02
DEFINE   g_aep01_2  LIKE axa_file.axa03
DEFINE   g_aep1     DYNAMIC ARRAY OF RECORD
          aep05      LIKE aep_file.aep05,
          aep05_1    LIKE nml_file.nml02,
          line       LIKE type_file.num5,
          aep02_1    LIKE aep_file.aep02,
          aep02_2    LIKE aep_file.aep02,
          aep02_3    LIKE aep_file.aep02,
          aep02_4    LIKE aep_file.aep02,
          aep02_5    LIKE aep_file.aep02,
          aep02_6    LIKE aep_file.aep02,
          aep02_7    LIKE aep_file.aep02,
          aep02_8    LIKE aep_file.aep02,
          aep02_9    LIKE aep_file.aep02,
          aep02_10   LIKE aep_file.aep02,
          aep02_11   LIKE aep_file.aep02,
          aep02_12   LIKE aep_file.aep02,
          aep02_13   LIKE aep_file.aep02,
          aep02_14   LIKE aep_file.aep02,
          aep02_15   LIKE aep_file.aep02,
          aep02_16   LIKE aep_file.aep02,
          aep02_17   LIKE aep_file.aep02,
          aep02_18   LIKE aep_file.aep02,
          aep02_19   LIKE aep_file.aep02,
          aep02_20   LIKE aep_file.aep02,
          aeq08      LIKE aeq_file.aeq08,
          sum        LIKE aeq_file.aeq08
                    END RECORD
DEFINE   g_aep1_t   RECORD
          aep05      LIKE aep_file.aep05,
          aep05_1    LIKE nml_file.nml02,
          line       LIKE type_file.num5,
          aep02_1    LIKE aep_file.aep02,
          aep02_2    LIKE aep_file.aep02,
          aep02_3    LIKE aep_file.aep02,
          aep02_4    LIKE aep_file.aep02,
          aep02_5    LIKE aep_file.aep02,
          aep02_6    LIKE aep_file.aep02,
          aep02_7    LIKE aep_file.aep02,
          aep02_8    LIKE aep_file.aep02,
          aep02_9    LIKE aep_file.aep02,
          aep02_10   LIKE aep_file.aep02,
          aep02_11   LIKE aep_file.aep02,
          aep02_12   LIKE aep_file.aep02,
          aep02_13   LIKE aep_file.aep02,
          aep02_14   LIKE aep_file.aep02,
          aep02_15   LIKE aep_file.aep02,
          aep02_16   LIKE aep_file.aep02,
          aep02_17   LIKE aep_file.aep02,
          aep02_18   LIKE aep_file.aep02,
          aep02_19   LIKE aep_file.aep02,
          aep02_20   LIKE aep_file.aep02,
          aeq08      LIKE aeq_file.aeq08,
          sum        LIKE aeq_file.aeq08
                    END RECORD
DEFINE    p_cmd      LIKE type_file.chr1 
DEFINE    l_table    STRING 
DEFINE    g_str      STRING
DEFINE    g_sql      STRING
DEFINE    g_rec_b    LIKE type_file.num10
DEFINE    g_wc       STRING 
DEFINE    l_ac       LIKE type_file.num5
DEFINE    g_sql_tmp  STRING
DEFINE    g_msg1     STRING
DEFINE    g_msg2     STRING 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5   
DEFINE   g_cnt           LIKE type_file.num10    
DEFINE   g_cnt1          LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5    
DEFINE   g_msg           LIKE ze_file.ze03     
DEFINE   g_row_count     LIKE type_file.num10 
DEFINE   g_curs_index    LIKE type_file.num10
DEFINE   g_jump          LIKE type_file.num10 
DEFINE   mi_no_ask       LIKE type_file.num5  
DEFINE   g_dbs_axz03     LIKE axz_file.axz03  #TQC-B70141 add

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT          

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   OPEN WINDOW q009_w AT 5,10
        WITH FORM "agl/42f/aglq009" ATTRIBUTE(STYLE = g_win_style)              
   CALL cl_set_comp_visible("aep02_1,aep02_2,aep02_3,aep02_4,aep02_5,aep02_6,
                            aep02_7,aep02_8,aep02_9,aep02_10,aep02_11,aep02_12,
                            aep02_13,aep02_14,aep02_15,aep02_16,aep02_17,aep02_18,
                            aep02_19,aep02_20",FALSE)                                                                              
   CALL cl_ui_init()                                                           

   CALL q009_menu()                                                            
   CLOSE WINDOW q009_w 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q009_cs()
   CLEAR FORM                                   #清除畫面
   CALL g_aep1.clear()
   CALL cl_set_head_visible("","YES")     

   CONSTRUCT g_wc ON aep01,aep03,aep04,aep07 FROM aep01,aep03,aep04,aep07

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp                 # 沿用所有欄位
         CASE
          WHEN INFIELD(aep01)                                                                                                 
             CALL cl_init_qry_var()                                                                                           
             LET g_qryparam.state = "c"                                                                                       
             LET g_qryparam.form ="q_aep01"                                                                                   
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aep01                                                                             
             NEXT FIELD aep01
          WHEN INFIELD(aep07)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_aep07"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aep07
             NEXT FIELD aep07
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


                #No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
                   CALL cl_qbe_select()
                 ON ACTION qbe_save
                   CALL cl_qbe_save()
                #No:FUN-580031 --end--       HCN
   END CONSTRUCT

   IF INT_FLAG THEN RETURN END IF
   LET g_sql="SELECT UNIQUE aep01,aep03,aep04,aep07 FROM aep_file ",
             " WHERE ", g_wc CLIPPED 
           # " ORDER BY aep01,aep03,aep04,aep07 "
   PREPARE q009_prepare FROM g_sql              #預備一下
   DECLARE q009_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR q009_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE aep01,aep03,aep04,aep07 FROM aep_file ",                                                     
                  " WHERE ",g_wc CLIPPED,                                                                                     
                  "   INTO TEMP x"                                                                                            
   DROP TABLE x                                                                                                               
   PREPARE q009_pre_x FROM g_sql_tmp
   EXECUTE q009_pre_x                                                                                                         
   LET g_sql = "SELECT COUNT(*) FROM x"                                                                                       
   PREPARE q009_precount FROM g_sql
   DECLARE q009_count CURSOR FOR q009_precount
END FUNCTION

FUNCTION q009_menu()
   WHILE TRUE
      CALL q009_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q009_q() 
            END IF
         WHEN "save"
            IF cl_chk_act_auth() THEN
               CALL q009_s()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
          #    CALL q009_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aep1),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q009_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_aep.* TO NULL      

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL q009_cs()                         #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN q009_b_cs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aep.* TO NULL
   ELSE
      CALL q009_fetch('F')               #讀出TEMP第一筆並顯示
      OPEN q009_count
      FETCH q009_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION

FUNCTION q009_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 INTEGER

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     q009_b_cs INTO g_aep.aep01,g_aep.aep03,g_aep.aep04,g_aep.aep07                                
       WHEN 'P' FETCH PREVIOUS q009_b_cs INTO g_aep.aep01,g_aep.aep03,g_aep.aep04,g_aep.aep07                                
       WHEN 'F' FETCH FIRST    q009_b_cs INTO g_aep.aep01,g_aep.aep03,g_aep.aep04,g_aep.aep07                   
       WHEN 'L' FETCH LAST     q009_b_cs INTO g_aep.aep01,g_aep.aep03,g_aep.aep04,g_aep.aep07                   
       WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q009_b_cs INTO g_aep.aep01,g_aep.aep03,g_aep.aep04,g_aep.aep07                    
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_aep.aep01,SQLCA.sqlcode,0)   
      INITIALIZE g_aep.* TO NULL 
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

   CALL q009_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION q009_show()
DEFINE l_axa02    LIKE axa_file.axa02
DEFINE l_axa03    LIKE axa_file.axa03
DEFINE g_aaw01    LIKE aaw_file.aaw01  #TQC-B70141
   SELECT axa02,axa03 INTO l_axa02,l_axa03 FROM axa_file WHERE axa01 = g_aep.aep01 AND axa04 = 'Y'
   LET g_aep01_1 = l_axa02
   LET g_aep01_2 = l_axa03
   DISPLAY l_axa02 TO FORMONLY.aep01_1
#   DISPLAY l_axa03 TO FORMONLY.aep01_2  #TQC-B70141 mark
  #TQC-B70141 --begin--
   CALL s_aaz641_dbs(g_aep.aep01,l_axa02) RETURNING g_dbs_axz03
   CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
   DISPLAY g_aaw01 TO FORMONLY.aep01_2
  #TQC-B70141 --end--
 # DISPLAY BY NAME g_aep.*              
   DISPLAY g_aep.aep01,g_aep.aep03,g_aep.aep04,g_aep.aep07 TO aep01,aep03,aep04,aep07              

   CALL q009_b_fill(g_wc)             #單身
   CALL cl_show_fld_cont()  
END FUNCTION

FUNCTION q009_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            STRING,        
   l_flag          LIKE type_file.chr1,              #有無單身筆數     
   l_sql           STRING,
   l_sum0          LIKE aeq_file.aeq08,
   l_sum1          LIKE aeq_file.aeq08,
   l_sum2          LIKE aeq_file.aeq08,
   l_sum3          LIKE aeq_file.aeq08,
   l_sum4          LIKE aeq_file.aeq08,
#----zhangweib---add---Begin---2011/03/35
   l_sum5          LIKE aet_file.aet07,
   l_sum6          LIKE aet_file.aet07, 
#----zhangweib---add---End-----2011/03/35
   l_axz02         LIKE axz_file.axz02 
DEFINE l_aep       DYNAMIC ARRAY OF RECORD
         aep02     LIKE aep_file.aep02
                   END RECORD,
       l_aep1      DYNAMIC ARRAY OF RECORD
         aep02     LIKE aep_file.aep02,
         aep06     LIKE aep_file.aep06
                   END RECORD,
       l_n         LIKE type_file.num5,
       l_i         LIKE type_file.num5,
       l_m0        LIKE type_file.num5,
       l_m1        LIKE type_file.num5

   LET l_sql = "SELECT DISTINCT aep02 FROM aep_file WHERE aep01 = '",g_aep.aep01,"'",
               "   AND aep03 = '",g_aep.aep03,"'",
               "   AND aep04 = '",g_aep.aep04,"'",
               "   AND aep07 = '",g_aep.aep07,"'",
               "   AND ",p_wc CLIPPED,
               " ORDER BY aep02"
   PREPARE aep_pre0 FROM l_sql
   DECLARE aep_cs0 CURSOR FOR aep_pre0 
   LET l_i = 1
   FOREACH aep_cs0 INTO l_aep[l_i].aep02
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_i = l_i + 1
   END FOREACH
   LET l_i = l_i - 1

   LET l_sql = "SELECT DISTINCT aep05,nml02,'','','','','','','','','','','','','','','','','','','','','','' ",
               "  FROM aep_file,OUTER nml_file",
               " WHERE aep01 = '",g_aep.aep01,"'",     
               "   AND aep03 = '",g_aep.aep03,"'",                       
               "   AND aep04 = '",g_aep.aep04,"'",
               "   AND aep07 = '",g_aep.aep07,"'",
               "   AND aep05 = nml_file.nml01 ",
               "   AND aep05 != ' ' ", 
               "   AND ",p_wc CLIPPED, 
               " ORDER BY aep05 "
   PREPARE aep_pre1 FROM l_sql
   DECLARE aep_cs1 CURSOR FOR aep_pre1

   LET l_sql = "SELECT aep02,SUM(aep06) FROM aep_file ",
               " WHERE aep01 = '",g_aep.aep01,"'",
               "   AND aep03 = '",g_aep.aep03,"'",
               "   AND aep04 = '",g_aep.aep04,"'",
               "   AND aep07 = '",g_aep.aep07,"'",
               "   AND aep12 NOT IN(SELECT axa02 FROM axa_file WHERE axa01 = '",g_aep.aep01,"')",
               "   AND aep12 NOT IN(SELECT axb04 FROM axb_file WHERE axb01 = '",g_aep.aep01,"')", 
               "   AND aep05 = ? ",
               " GROUP BY aep02"
   PREPARE aep_pre2 FROM l_sql
   DECLARE aep_cs2 CURSOR FOR aep_pre2 
    
   CALL g_aep1.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH aep_cs1 INTO g_aep1[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_aep1[g_cnt].line = g_cnt 
      LET g_cnt1 = 1
      FOREACH aep_cs2 USING g_aep1[g_cnt].aep05 INTO l_aep1[g_cnt1].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         FOR l_n = 1 TO l_i 
            IF l_aep1[g_cnt1].aep02 = l_aep[l_n].aep02 THEN
               CASE l_n 
                  WHEN 1
                     LET g_aep1[g_cnt].aep02_1 = l_aep1[g_cnt1].aep06
                  WHEN 2
                     LET g_aep1[g_cnt].aep02_2 = l_aep1[g_cnt1].aep06
                  WHEN 3
                     LET g_aep1[g_cnt].aep02_3 = l_aep1[g_cnt1].aep06
                  WHEN 4
                     LET g_aep1[g_cnt].aep02_4 = l_aep1[g_cnt1].aep06
                  WHEN 5
                     LET g_aep1[g_cnt].aep02_5 = l_aep1[g_cnt1].aep06
                  WHEN 6
                     LET g_aep1[g_cnt].aep02_6 = l_aep1[g_cnt1].aep06
                  WHEN 7
                     LET g_aep1[g_cnt].aep02_7 = l_aep1[g_cnt1].aep06
                  WHEN 8
                     LET g_aep1[g_cnt].aep02_8 = l_aep1[g_cnt1].aep06
                  WHEN 9
                     LET g_aep1[g_cnt].aep02_9 = l_aep1[g_cnt1].aep06
                  WHEN 10
                     LET g_aep1[g_cnt].aep02_10= l_aep1[g_cnt1].aep06
                  WHEN 11
                     LET g_aep1[g_cnt].aep02_11= l_aep1[g_cnt1].aep06
                  WHEN 12
                     LET g_aep1[g_cnt].aep02_12= l_aep1[g_cnt1].aep06
                  WHEN 13
                     LET g_aep1[g_cnt].aep02_13= l_aep1[g_cnt1].aep06
                  WHEN 14
                     LET g_aep1[g_cnt].aep02_14= l_aep1[g_cnt1].aep06
                  WHEN 15
                     LET g_aep1[g_cnt].aep02_15= l_aep1[g_cnt1].aep06
                  WHEN 16
                     LET g_aep1[g_cnt].aep02_16= l_aep1[g_cnt1].aep06
                  WHEN 17
                     LET g_aep1[g_cnt].aep02_17= l_aep1[g_cnt1].aep06
                  WHEN 18
                     LET g_aep1[g_cnt].aep02_18= l_aep1[g_cnt1].aep06
                  WHEN 19
                     LET g_aep1[g_cnt].aep02_19= l_aep1[g_cnt1].aep06
                  WHEN 20
                     LET g_aep1[g_cnt].aep02_20= l_aep1[g_cnt1].aep06
               END CASE
            END IF 
         END FOR
         LET g_cnt1 = g_cnt1 + 1  
      END FOREACH  

      IF cl_null(g_aep1[g_cnt].aep02_1) THEN 
         LET g_aep1[g_cnt].aep02_1 = 0
      END IF 
      IF cl_null(g_aep1[g_cnt].aep02_2) THEN
         LET g_aep1[g_cnt].aep02_2 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_3) THEN
         LET g_aep1[g_cnt].aep02_3 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_4) THEN
         LET g_aep1[g_cnt].aep02_4 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_5) THEN
         LET g_aep1[g_cnt].aep02_5 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_6) THEN
         LET g_aep1[g_cnt].aep02_6 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_7) THEN
         LET g_aep1[g_cnt].aep02_7 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_8) THEN
         LET g_aep1[g_cnt].aep02_8 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_9) THEN
         LET g_aep1[g_cnt].aep02_9 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_10) THEN
         LET g_aep1[g_cnt].aep02_10 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_11) THEN
         LET g_aep1[g_cnt].aep02_11 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_12) THEN
         LET g_aep1[g_cnt].aep02_12 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_13) THEN
         LET g_aep1[g_cnt].aep02_13 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_14) THEN
         LET g_aep1[g_cnt].aep02_14 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_15) THEN
         LET g_aep1[g_cnt].aep02_15 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_16) THEN
         LET g_aep1[g_cnt].aep02_16 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_17) THEN
         LET g_aep1[g_cnt].aep02_17 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_18) THEN
         LET g_aep1[g_cnt].aep02_18 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_19) THEN
         LET g_aep1[g_cnt].aep02_19 = 0
      END IF
      IF cl_null(g_aep1[g_cnt].aep02_20) THEN
         LET g_aep1[g_cnt].aep02_20 = 0
      END IF
        
      SELECT SUM(aeq08) INTO l_sum1 FROM aeq_file WHERE aeq01 = g_aep.aep01
         AND aeq04 = g_aep.aep03 
         AND aeq05 <= g_aep.aep04 AND aeq06 = g_aep1[g_cnt].aep05
         AND aeq07 = '+'
      SELECT SUM(aeq08) INTO l_sum2 FROM aeq_file WHERE aeq01 = g_aep.aep01
         AND aeq04 = g_aep.aep03
         AND aeq05 = g_aep.aep04 AND aeq06 = g_aep1[g_cnt].aep05
         AND aeq07 = '-'
      SELECT SUM(aeq08) INTO l_sum3 FROM aeq_file WHERE aeq01 = g_aep.aep01
         AND aeq04 = g_aep.aep03
         AND aeq05 = g_aep.aep04 AND aeq09 = g_aep1[g_cnt].aep05
         AND aeq10 = '+'
      SELECT SUM(aeq08) INTO l_sum4 FROM aeq_file WHERE aeq01 = g_aep.aep01
         AND aeq04 = g_aep.aep03
         AND aeq05 = g_aep.aep04 AND aeq09 = g_aep1[g_cnt].aep05
         AND aeq10 = '-'
#----zhangweib---add---Begin--2011/03/25--
      SELECT SUM(aet07) INTO l_sum5 FROM aet_file 
       WHERE aet01 = g_aep.aep01 AND aet02 = g_aep.aep03 AND aet03 = g_aep.aep04
         AND aet05 = g_aep1[g_cnt].aep05
         AND aet06 = '+'
      SELECT SUM(aet07) INTO l_sum6 FROM aet_file
       WHERE aet01 = g_aep.aep01 AND aet02 = g_aep.aep03 AND aet03 = g_aep.aep04
         AND aet05 = g_aep1[g_cnt].aep05
         AND aet06 = '-'
      IF cl_null(l_sum5) THEN
         LET l_sum5 = 0
      END IF
      IF cl_null(l_sum6) THEN
         LET l_sum6 = 0
      END IF
#----zhangweib---add---End----2011/03/25--
      IF cl_null(l_sum1) THEN
         LET l_sum1 = 0
      END IF 
      IF cl_null(l_sum2) THEN
         LET l_sum2 = 0
      END IF
      IF cl_null(l_sum3) THEN
         LET l_sum3 = 0
      END IF
      IF cl_null(l_sum4) THEN
         LET l_sum4 = 0
      END IF
#     LET g_aep1[g_cnt].aeq08 = l_sum1 - l_sum2 + l_sum3 - l_sum4   #Mark  By zhangweib 2011/03/25
      LET g_aep1[g_cnt].aeq08 = l_sum1 - l_sum2 + l_sum3 - l_sum4 + l_sum5 - l_sum6   #Add   By zhangweib 2011/03/25
      LET g_aep1[g_cnt].sum = g_aep1[g_cnt].aep02_1 + g_aep1[g_cnt].aep02_2 + g_aep1[g_cnt].aep02_3 +
                              g_aep1[g_cnt].aep02_4 + g_aep1[g_cnt].aep02_5 + g_aep1[g_cnt].aep02_6 +
                              g_aep1[g_cnt].aep02_7 + g_aep1[g_cnt].aep02_8 + g_aep1[g_cnt].aep02_9 +
                              g_aep1[g_cnt].aep02_10+g_aep1[g_cnt].aep02_11+g_aep1[g_cnt].aep02_12+
                              g_aep1[g_cnt].aep02_13+g_aep1[g_cnt].aep02_14+g_aep1[g_cnt].aep02_15+
                              g_aep1[g_cnt].aep02_16+g_aep1[g_cnt].aep02_17+g_aep1[g_cnt].aep02_18+
                              g_aep1[g_cnt].aep02_19+g_aep1[g_cnt].aep02_20+g_aep1[g_cnt].aeq08
      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH

   FOR l_m0 = 1 TO l_i
       SELECT axz02 INTO l_axz02 
         FROM axz_file
        WHERE axz01 = l_aep[l_m0].aep02 

       LET g_msg1= l_axz02 CLIPPED
       LET g_msg2= "aep02_",l_m0 USING "<<<<<"
       CALL cl_set_comp_visible(g_msg2,TRUE)
       CALL cl_set_comp_att_text(g_msg2,g_msg1 CLIPPED)
   END FOR

   FOR l_m1 = l_i + 1  TO 20
       LET g_msg2= "aep02_",l_m1 USING "<<<<<"
       CALL cl_set_comp_visible(g_msg2,FALSE)
   END FOR

   CALL g_aep1.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION


FUNCTION q009_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1 

   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_aep1 TO s_aep1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL q009_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY      
 
      ON ACTION previous
         CALL q009_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL q009_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION next
         CALL q009_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION last
         CALL q009_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION save
         LET g_action_choice="save"
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

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
       # LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q009_s()
DEFINE l_aer   RECORD LIKE aer_file.*
DEFINE l_sum   LIKE aer_file.aer06
DEFINE l_i     LIKE type_file.num5
DEFINE l_n     LIKE type_file.num5 

   LET g_success = 'Y'
   LET l_aer.aer01 = g_aep.aep01 
   LET l_aer.aer02 = g_aep01_1
   LET l_aer.aer03 = g_aep.aep03
   LET l_aer.aer04 = g_aep.aep04
   LET l_aer.aer07 = g_aep.aep07
   LET l_aer.aerlegal =g_legal       #NO.FUN-B40104
   LET l_sum = 0 
   FOR l_i = 1 TO g_rec_b
      IF NOT cl_null(g_aep1[l_i].aep05) THEN 
         LET l_aer.aer05 = g_aep1[l_i].aep05
         LET l_aer.aer06 = g_aep1[l_i].sum 
         SELECT COUNT(*) INTO l_n FROM aer_file WHERE aer01 = l_aer.aer01
            AND aer02 = l_aer.aer02 AND aer03 = l_aer.aer03
            AND aer04 = l_aer.aer04 AND aer05 = l_aer.aer05
         IF l_n > 0 THEN 
            DELETE FROM aer_file WHERE aer01 = l_aer.aer01
               AND aer02 = l_aer.aer02 AND aer03 = l_aer.aer03
               AND aer04 = l_aer.aer04 AND aer05 = l_aer.aer05
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("del","aer_file",l_aer.aer01,l_aer.aer05,SQLCA.sqlcode,"","",1)
               LET g_success = 'N' 
               EXIT FOR
            END IF 
         END IF 
         IF g_success = 'Y' THEN 
            INSERT INTO aer_file VALUES(l_aer.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","aer_file",l_aer.aer01,l_aer.aer05,SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               EXIT FOR 
            END IF
         END IF
      END IF  
   END FOR 
   IF g_success = 'N' THEN 
      CALL cl_err(l_aer.aer01,'agl038',1)
   ELSE
      CALL cl_err(l_aer.aer01,'agl037',1)
   END IF 
END FUNCTION
#NO.FUN-B40104
