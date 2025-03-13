# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: gglq052.4gl
# Descriptions...: 現金流量表直接法查询资料
# Date & Author..: 2010/11/12 By wuxj   
# Modify.........: NO.FUN-B40104 By jll   合并报表作业
# Modify.........: No.TQC-B70141 By guoch 查詢時，合并帳套取值錯誤
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植

DATABASE ds

GLOBALS "../../config/top.global"              #FUN-BB0037
DEFINE   g_atd      RECORD LIKE atd_file.*
DEFINE   g_atd_t    RECORD LIKE atd_file.*
DEFINE   g_atd01_1  LIKE asa_file.asa02
DEFINE   g_atd01_2  LIKE asa_file.asa03
DEFINE   g_atd1     DYNAMIC ARRAY OF RECORD
          atd05      LIKE atd_file.atd05,
          atd05_1    LIKE nml_file.nml02,
          line       LIKE type_file.num5,
          atd02_1    LIKE atd_file.atd02,
          atd02_2    LIKE atd_file.atd02,
          atd02_3    LIKE atd_file.atd02,
          atd02_4    LIKE atd_file.atd02,
          atd02_5    LIKE atd_file.atd02,
          atd02_6    LIKE atd_file.atd02,
          atd02_7    LIKE atd_file.atd02,
          atd02_8    LIKE atd_file.atd02,
          atd02_9    LIKE atd_file.atd02,
          atd02_10   LIKE atd_file.atd02,
          atd02_11   LIKE atd_file.atd02,
          atd02_12   LIKE atd_file.atd02,
          atd02_13   LIKE atd_file.atd02,
          atd02_14   LIKE atd_file.atd02,
          atd02_15   LIKE atd_file.atd02,
          atd02_16   LIKE atd_file.atd02,
          atd02_17   LIKE atd_file.atd02,
          atd02_18   LIKE atd_file.atd02,
          atd02_19   LIKE atd_file.atd02,
          atd02_20   LIKE atd_file.atd02,
          ate08      LIKE ate_file.ate08,
          sum        LIKE ate_file.ate08
                    END RECORD
DEFINE   g_atd1_t   RECORD
          atd05      LIKE atd_file.atd05,
          atd05_1    LIKE nml_file.nml02,
          line       LIKE type_file.num5,
          atd02_1    LIKE atd_file.atd02,
          atd02_2    LIKE atd_file.atd02,
          atd02_3    LIKE atd_file.atd02,
          atd02_4    LIKE atd_file.atd02,
          atd02_5    LIKE atd_file.atd02,
          atd02_6    LIKE atd_file.atd02,
          atd02_7    LIKE atd_file.atd02,
          atd02_8    LIKE atd_file.atd02,
          atd02_9    LIKE atd_file.atd02,
          atd02_10   LIKE atd_file.atd02,
          atd02_11   LIKE atd_file.atd02,
          atd02_12   LIKE atd_file.atd02,
          atd02_13   LIKE atd_file.atd02,
          atd02_14   LIKE atd_file.atd02,
          atd02_15   LIKE atd_file.atd02,
          atd02_16   LIKE atd_file.atd02,
          atd02_17   LIKE atd_file.atd02,
          atd02_18   LIKE atd_file.atd02,
          atd02_19   LIKE atd_file.atd02,
          atd02_20   LIKE atd_file.atd02,
          ate08      LIKE ate_file.ate08,
          sum        LIKE ate_file.ate08
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
DEFINE   g_dbs_asg03     LIKE asg_file.asg03  #TQC-B70141 add

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT          

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   OPEN WINDOW q009_w AT 5,10
        WITH FORM "ggl/42f/gglq052" ATTRIBUTE(STYLE = g_win_style)              
   CALL cl_set_comp_visible("atd02_1,atd02_2,atd02_3,atd02_4,atd02_5,atd02_6,
                            atd02_7,atd02_8,atd02_9,atd02_10,atd02_11,atd02_12,
                            atd02_13,atd02_14,atd02_15,atd02_16,atd02_17,atd02_18,
                            atd02_19,atd02_20",FALSE)                                                                              
   CALL cl_ui_init()                                                           

   CALL q009_menu()                                                            
   CLOSE WINDOW q009_w 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q009_cs()
   CLEAR FORM                                   #清除畫面
   CALL g_atd1.clear()
   CALL cl_set_head_visible("","YES")     

   CONSTRUCT g_wc ON atd01,atd03,atd04,atd07 FROM atd01,atd03,atd04,atd07

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION controlp                 # 沿用所有欄位
         CASE
          WHEN INFIELD(atd01)                                                                                                 
             CALL cl_init_qry_var()                                                                                           
             LET g_qryparam.state = "c"                                                                                       
             LET g_qryparam.form ="q_atd01"                                                                                   
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atd01                                                                             
             NEXT FIELD atd01
          WHEN INFIELD(atd07)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_atd07"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atd07
             NEXT FIELD atd07
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
   LET g_sql="SELECT UNIQUE atd01,atd03,atd04,atd07 FROM atd_file ",
             " WHERE ", g_wc CLIPPED 
           # " ORDER BY atd01,atd03,atd04,atd07 "
   PREPARE q009_prepare FROM g_sql              #預備一下
   DECLARE q009_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR q009_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE atd01,atd03,atd04,atd07 FROM atd_file ",                                                     
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_atd1),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q009_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_atd.* TO NULL      

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
      INITIALIZE g_atd.* TO NULL
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
       WHEN 'N' FETCH NEXT     q009_b_cs INTO g_atd.atd01,g_atd.atd03,g_atd.atd04,g_atd.atd07                                
       WHEN 'P' FETCH PREVIOUS q009_b_cs INTO g_atd.atd01,g_atd.atd03,g_atd.atd04,g_atd.atd07                                
       WHEN 'F' FETCH FIRST    q009_b_cs INTO g_atd.atd01,g_atd.atd03,g_atd.atd04,g_atd.atd07                   
       WHEN 'L' FETCH LAST     q009_b_cs INTO g_atd.atd01,g_atd.atd03,g_atd.atd04,g_atd.atd07                   
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
            FETCH ABSOLUTE g_jump q009_b_cs INTO g_atd.atd01,g_atd.atd03,g_atd.atd04,g_atd.atd07                    
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_atd.atd01,SQLCA.sqlcode,0)   
      INITIALIZE g_atd.* TO NULL 
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
DEFINE l_asa02    LIKE asa_file.asa02
DEFINE l_asa03    LIKE asa_file.asa03
DEFINE g_asz01    LIKE asz_file.asz01  #TQC-B70141
   SELECT asa02,asa03 INTO l_asa02,l_asa03 FROM asa_file WHERE asa01 = g_atd.atd01 AND asa04 = 'Y'
   LET g_atd01_1 = l_asa02
   LET g_atd01_2 = l_asa03
   DISPLAY l_asa02 TO FORMONLY.atd01_1
#   DISPLAY l_asa03 TO FORMONLY.atd01_2  #TQC-B70141 mark
  #TQC-B70141 --beatk--
   CALL s_aaz641_asg(g_atd.atd01,l_asa02) RETURNING g_dbs_asg03
   CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01
   DISPLAY g_asz01 TO FORMONLY.atd01_2
  #TQC-B70141 --end--
 # DISPLAY BY NAME g_atd.*              
   DISPLAY g_atd.atd01,g_atd.atd03,g_atd.atd04,g_atd.atd07 TO atd01,atd03,atd04,atd07              

   CALL q009_b_fill(g_wc)             #單身
   CALL cl_show_fld_cont()  
END FUNCTION

FUNCTION q009_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            STRING,        
   l_flag          LIKE type_file.chr1,              #有無單身筆數     
   l_sql           STRING,
   l_sum0          LIKE ate_file.ate08,
   l_sum1          LIKE ate_file.ate08,
   l_sum2          LIKE ate_file.ate08,
   l_sum3          LIKE ate_file.ate08,
   l_sum4          LIKE ate_file.ate08,
#----zhangweib---add---Beatk---2011/03/35
   l_sum5          LIKE ati_file.ati07,
   l_sum6          LIKE ati_file.ati07, 
#----zhangweib---add---End-----2011/03/35
   l_asg02         LIKE asg_file.asg02 
DEFINE l_atd       DYNAMIC ARRAY OF RECORD
         atd02     LIKE atd_file.atd02
                   END RECORD,
       l_atd1      DYNAMIC ARRAY OF RECORD
         atd02     LIKE atd_file.atd02,
         atd06     LIKE atd_file.atd06
                   END RECORD,
       l_n         LIKE type_file.num5,
       l_i         LIKE type_file.num5,
       l_m0        LIKE type_file.num5,
       l_m1        LIKE type_file.num5

   LET l_sql = "SELECT DISTINCT atd02 FROM atd_file WHERE atd01 = '",g_atd.atd01,"'",
               "   AND atd03 = '",g_atd.atd03,"'",
               "   AND atd04 = '",g_atd.atd04,"'",
               "   AND atd07 = '",g_atd.atd07,"'",
               "   AND ",p_wc CLIPPED,
               " ORDER BY atd02"
   PREPARE atd_pre0 FROM l_sql
   DECLARE atd_cs0 CURSOR FOR atd_pre0 
   LET l_i = 1
   FOREACH atd_cs0 INTO l_atd[l_i].atd02
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_i = l_i + 1
   END FOREACH
   LET l_i = l_i - 1

   LET l_sql = "SELECT DISTINCT atd05,nml02,'','','','','','','','','','','','','','','','','','','','','','' ",
               "  FROM atd_file,OUTER nml_file",
               " WHERE atd01 = '",g_atd.atd01,"'",     
               "   AND atd03 = '",g_atd.atd03,"'",                       
               "   AND atd04 = '",g_atd.atd04,"'",
               "   AND atd07 = '",g_atd.atd07,"'",
               "   AND atd05 = nml_file.nml01 ",
               "   AND atd05 != ' ' ", 
               "   AND ",p_wc CLIPPED, 
               " ORDER BY atd05 "
   PREPARE atd_pre1 FROM l_sql
   DECLARE atd_cs1 CURSOR FOR atd_pre1

   LET l_sql = "SELECT atd02,SUM(atd06) FROM atd_file ",
               " WHERE atd01 = '",g_atd.atd01,"'",
               "   AND atd03 = '",g_atd.atd03,"'",
               "   AND atd04 = '",g_atd.atd04,"'",
               "   AND atd07 = '",g_atd.atd07,"'",
               "   AND atd12 NOT IN(SELECT asa02 FROM asa_file WHERE asa01 = '",g_atd.atd01,"')",
               "   AND atd12 NOT IN(SELECT asb04 FROM asb_file WHERE asb01 = '",g_atd.atd01,"')", 
               "   AND atd05 = ? ",
               " GROUP BY atd02"
   PREPARE atd_pre2 FROM l_sql
   DECLARE atd_cs2 CURSOR FOR atd_pre2 
    
   CALL g_atd1.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH atd_cs1 INTO g_atd1[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_atd1[g_cnt].line = g_cnt 
      LET g_cnt1 = 1
      FOREACH atd_cs2 USING g_atd1[g_cnt].atd05 INTO l_atd1[g_cnt1].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         FOR l_n = 1 TO l_i 
            IF l_atd1[g_cnt1].atd02 = l_atd[l_n].atd02 THEN
               CASE l_n 
                  WHEN 1
                     LET g_atd1[g_cnt].atd02_1 = l_atd1[g_cnt1].atd06
                  WHEN 2
                     LET g_atd1[g_cnt].atd02_2 = l_atd1[g_cnt1].atd06
                  WHEN 3
                     LET g_atd1[g_cnt].atd02_3 = l_atd1[g_cnt1].atd06
                  WHEN 4
                     LET g_atd1[g_cnt].atd02_4 = l_atd1[g_cnt1].atd06
                  WHEN 5
                     LET g_atd1[g_cnt].atd02_5 = l_atd1[g_cnt1].atd06
                  WHEN 6
                     LET g_atd1[g_cnt].atd02_6 = l_atd1[g_cnt1].atd06
                  WHEN 7
                     LET g_atd1[g_cnt].atd02_7 = l_atd1[g_cnt1].atd06
                  WHEN 8
                     LET g_atd1[g_cnt].atd02_8 = l_atd1[g_cnt1].atd06
                  WHEN 9
                     LET g_atd1[g_cnt].atd02_9 = l_atd1[g_cnt1].atd06
                  WHEN 10
                     LET g_atd1[g_cnt].atd02_10= l_atd1[g_cnt1].atd06
                  WHEN 11
                     LET g_atd1[g_cnt].atd02_11= l_atd1[g_cnt1].atd06
                  WHEN 12
                     LET g_atd1[g_cnt].atd02_12= l_atd1[g_cnt1].atd06
                  WHEN 13
                     LET g_atd1[g_cnt].atd02_13= l_atd1[g_cnt1].atd06
                  WHEN 14
                     LET g_atd1[g_cnt].atd02_14= l_atd1[g_cnt1].atd06
                  WHEN 15
                     LET g_atd1[g_cnt].atd02_15= l_atd1[g_cnt1].atd06
                  WHEN 16
                     LET g_atd1[g_cnt].atd02_16= l_atd1[g_cnt1].atd06
                  WHEN 17
                     LET g_atd1[g_cnt].atd02_17= l_atd1[g_cnt1].atd06
                  WHEN 18
                     LET g_atd1[g_cnt].atd02_18= l_atd1[g_cnt1].atd06
                  WHEN 19
                     LET g_atd1[g_cnt].atd02_19= l_atd1[g_cnt1].atd06
                  WHEN 20
                     LET g_atd1[g_cnt].atd02_20= l_atd1[g_cnt1].atd06
               END CASE
            END IF 
         END FOR
         LET g_cnt1 = g_cnt1 + 1  
      END FOREACH  

      IF cl_null(g_atd1[g_cnt].atd02_1) THEN 
         LET g_atd1[g_cnt].atd02_1 = 0
      END IF 
      IF cl_null(g_atd1[g_cnt].atd02_2) THEN
         LET g_atd1[g_cnt].atd02_2 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_3) THEN
         LET g_atd1[g_cnt].atd02_3 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_4) THEN
         LET g_atd1[g_cnt].atd02_4 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_5) THEN
         LET g_atd1[g_cnt].atd02_5 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_6) THEN
         LET g_atd1[g_cnt].atd02_6 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_7) THEN
         LET g_atd1[g_cnt].atd02_7 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_8) THEN
         LET g_atd1[g_cnt].atd02_8 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_9) THEN
         LET g_atd1[g_cnt].atd02_9 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_10) THEN
         LET g_atd1[g_cnt].atd02_10 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_11) THEN
         LET g_atd1[g_cnt].atd02_11 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_12) THEN
         LET g_atd1[g_cnt].atd02_12 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_13) THEN
         LET g_atd1[g_cnt].atd02_13 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_14) THEN
         LET g_atd1[g_cnt].atd02_14 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_15) THEN
         LET g_atd1[g_cnt].atd02_15 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_16) THEN
         LET g_atd1[g_cnt].atd02_16 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_17) THEN
         LET g_atd1[g_cnt].atd02_17 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_18) THEN
         LET g_atd1[g_cnt].atd02_18 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_19) THEN
         LET g_atd1[g_cnt].atd02_19 = 0
      END IF
      IF cl_null(g_atd1[g_cnt].atd02_20) THEN
         LET g_atd1[g_cnt].atd02_20 = 0
      END IF
        
      SELECT SUM(ate08) INTO l_sum1 FROM ate_file WHERE ate01 = g_atd.atd01
         AND ate04 = g_atd.atd03 
         AND ate05 <= g_atd.atd04 AND ate06 = g_atd1[g_cnt].atd05
         AND ate07 = '+'
      SELECT SUM(ate08) INTO l_sum2 FROM ate_file WHERE ate01 = g_atd.atd01
         AND ate04 = g_atd.atd03
         AND ate05 = g_atd.atd04 AND ate06 = g_atd1[g_cnt].atd05
         AND ate07 = '-'
      SELECT SUM(ate08) INTO l_sum3 FROM ate_file WHERE ate01 = g_atd.atd01
         AND ate04 = g_atd.atd03
         AND ate05 = g_atd.atd04 AND ate09 = g_atd1[g_cnt].atd05
         AND ate10 = '+'
      SELECT SUM(ate08) INTO l_sum4 FROM ate_file WHERE ate01 = g_atd.atd01
         AND ate04 = g_atd.atd03
         AND ate05 = g_atd.atd04 AND ate09 = g_atd1[g_cnt].atd05
         AND ate10 = '-'
#----zhangweib---add---Beatk--2011/03/25--
      SELECT SUM(ati07) INTO l_sum5 FROM ati_file 
       WHERE ati01 = g_atd.atd01 AND ati02 = g_atd.atd03 AND ati03 = g_atd.atd04
         AND ati05 = g_atd1[g_cnt].atd05
         AND ati06 = '+'
      SELECT SUM(ati07) INTO l_sum6 FROM ati_file
       WHERE ati01 = g_atd.atd01 AND ati02 = g_atd.atd03 AND ati03 = g_atd.atd04
         AND ati05 = g_atd1[g_cnt].atd05
         AND ati06 = '-'
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
#     LET g_atd1[g_cnt].ate08 = l_sum1 - l_sum2 + l_sum3 - l_sum4   #Mark  By zhangweib 2011/03/25
      LET g_atd1[g_cnt].ate08 = l_sum1 - l_sum2 + l_sum3 - l_sum4 + l_sum5 - l_sum6   #Add   By zhangweib 2011/03/25
      LET g_atd1[g_cnt].sum = g_atd1[g_cnt].atd02_1 + g_atd1[g_cnt].atd02_2 + g_atd1[g_cnt].atd02_3 +
                              g_atd1[g_cnt].atd02_4 + g_atd1[g_cnt].atd02_5 + g_atd1[g_cnt].atd02_6 +
                              g_atd1[g_cnt].atd02_7 + g_atd1[g_cnt].atd02_8 + g_atd1[g_cnt].atd02_9 +
                              g_atd1[g_cnt].atd02_10+g_atd1[g_cnt].atd02_11+g_atd1[g_cnt].atd02_12+
                              g_atd1[g_cnt].atd02_13+g_atd1[g_cnt].atd02_14+g_atd1[g_cnt].atd02_15+
                              g_atd1[g_cnt].atd02_16+g_atd1[g_cnt].atd02_17+g_atd1[g_cnt].atd02_18+
                              g_atd1[g_cnt].atd02_19+g_atd1[g_cnt].atd02_20+g_atd1[g_cnt].ate08
      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH

   FOR l_m0 = 1 TO l_i
       SELECT asg02 INTO l_asg02 
         FROM asg_file
        WHERE asg01 = l_atd[l_m0].atd02 

       LET g_msg1= l_asg02 CLIPPED
       LET g_msg2= "atd02_",l_m0 USING "<<<<<"
       CALL cl_set_comp_visible(g_msg2,TRUE)
       CALL cl_set_comp_att_text(g_msg2,g_msg1 CLIPPED)
   END FOR

   FOR l_m1 = l_i + 1  TO 20
       LET g_msg2= "atd02_",l_m1 USING "<<<<<"
       CALL cl_set_comp_visible(g_msg2,FALSE)
   END FOR

   CALL g_atd1.deleteElement(g_cnt)
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
   DISPLAY ARRAY g_atd1 TO s_atd1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
DEFINE l_atf   RECORD LIKE atf_file.*
DEFINE l_sum   LIKE atf_file.atf06
DEFINE l_i     LIKE type_file.num5
DEFINE l_n     LIKE type_file.num5 

   LET g_success = 'Y'
   LET l_atf.atf01 = g_atd.atd01 
   LET l_atf.atf02 = g_atd01_1
   LET l_atf.atf03 = g_atd.atd03
   LET l_atf.atf04 = g_atd.atd04
   LET l_atf.atf07 = g_atd.atd07
   LET l_atf.atflegal =g_legal       #NO.FUN-B40104
   LET l_sum = 0 
   FOR l_i = 1 TO g_rec_b
      IF NOT cl_null(g_atd1[l_i].atd05) THEN 
         LET l_atf.atf05 = g_atd1[l_i].atd05
         LET l_atf.atf06 = g_atd1[l_i].sum 
         SELECT COUNT(*) INTO l_n FROM atf_file WHERE atf01 = l_atf.atf01
            AND atf02 = l_atf.atf02 AND atf03 = l_atf.atf03
            AND atf04 = l_atf.atf04 AND atf05 = l_atf.atf05
         IF l_n > 0 THEN 
            DELETE FROM atf_file WHERE atf01 = l_atf.atf01
               AND atf02 = l_atf.atf02 AND atf03 = l_atf.atf03
               AND atf04 = l_atf.atf04 AND atf05 = l_atf.atf05
            IF SQLCA.sqlcode THEN 
               CALL cl_err3("del","atf_file",l_atf.atf01,l_atf.atf05,SQLCA.sqlcode,"","",1)
               LET g_success = 'N' 
               EXIT FOR
            END IF 
         END IF 
         IF g_success = 'Y' THEN 
            INSERT INTO atf_file VALUES(l_atf.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","atf_file",l_atf.atf01,l_atf.atf05,SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               EXIT FOR 
            END IF
         END IF
      END IF  
   END FOR 
   IF g_success = 'N' THEN 
      CALL cl_err(l_atf.atf01,'agl038',1)
   ELSE
      CALL cl_err(l_atf.atf01,'agl037',1)
   END IF 
END FUNCTION
#NO.FUN-B40104
