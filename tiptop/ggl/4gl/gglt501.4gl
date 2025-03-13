# Prog. Version..: '5.30.06-13.04.22(00003)'     #
# Pattern name...: gglt501.4gl
# Descriptions...: 現金流量表直接法资料导入
# Date & Author..: 2010/11/12 By wuxj   
# Modify.........: NO.FUN-B40104 11/05/05 By jll 合并报表作业
# Modify.........: NO.FUN-B70003 11/07/05 By Lujh 新增字段atd16,atd17
# Modify.........: No.TQC-B70138 11/07/19 By guoch 查詢時，合并帳套取值錯誤
# Modify.........: No.FUN-B80135 11/08/22 By lujh  相關日期欄位不可小於關帳日期 
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C60143 12/06/18 By 錄入一筆新資料後直接刪除，總筆數欄位變為-1
#                                            新增一筆資料時報錯
#                                            個體功能幣幣種欄位沒有有效性檢查
# Modify.........: No:FUN-D30032 13/04/02 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"        #FUN-BB0037
DEFINE   g_atd      RECORD LIKE atd_file.*
DEFINE   g_atd_t    RECORD LIKE atd_file.*
DEFINE   g_atd01_1  LIKE asa_file.asa02
DEFINE   g_atd01_2  LIKE asa_file.asa03
DEFINE   g_atd1     DYNAMIC ARRAY OF RECORD
          atd05      LIKE atd_file.atd05,
          #atd05_1    LIKE nml_file.nml02,
          atd16      LIKE atd_file.atd16,     #FUN-B70003   把atd05_1换成atd16
          atd17      LIKE atd_file.atd17,     #FUN-B70003   add atd17
          atd09      LIKE atd_file.atd09,
          atd13      LIKE atd_file.atd13,
          atd06      LIKE atd_file.atd06,
          atd12      LIKE atd_file.atd12 
                    END RECORD
DEFINE   g_atd1_t   RECORD
          atd05      LIKE atd_file.atd05,
          #atd05_1    LIKE nml_file.nml02,
          atd16      LIKE atd_file.atd16,     #FUN-B70003    把atd05_1换成atd16
          atd17      LIKE atd_file.atd17,     #FUN-B70003    add atd17
          atd09      LIKE atd_file.atd09,
          atd06      LIKE atd_file.atd06,
          atd13      LIKE atd_file.atd13,
          atd12      LIKE atd_file.atd12 
                    END RECORD
DEFINE    p_cmd      LIKE type_file.chr1 
DEFINE    l_table    STRING 
DEFINE    g_str      STRING
DEFINE    g_sql      STRING
DEFINE    g_rec_b    LIKE type_file.num10
DEFINE    g_wc       STRING 
DEFINE    l_ac       LIKE type_file.num5
DEFINE    g_sql_tmp  STRING

#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5   
DEFINE   g_cnt           LIKE type_file.num10    
DEFINE   g_i             LIKE type_file.num5    
DEFINE   g_msg           LIKE ze_file.ze03     
DEFINE   g_row_count     LIKE type_file.num10 
DEFINE   g_curs_index    LIKE type_file.num10
DEFINE   g_jump          LIKE type_file.num10 
DEFINE   mi_no_ask       LIKE type_file.num5 
DEFINE   g_dbs_asg03     LIKE asg_file.asg03  #TQC-B70138  
DEFINE   g_aaa07         LIKE aaa_file.aaa07  #No.FUN-B80135
DEFINE   g_year          LIKE type_file.chr4  #No.FUN-B80135
DEFINE   g_month         LIKE type_file.chr2  #No.FUN-B80135

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

   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0' 
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07) 
   #FUN-B80135--add--end
   
   OPEN WINDOW t009_w AT 5,10
        WITH FORM "ggl/42f/gglt501" ATTRIBUTE(STYLE = g_win_style)              
                                                                                
   CALL cl_ui_init()                                                           

   CALL t009_menu()                                                            
   CLOSE WINDOW t009_w 

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t009_cs()
   CLEAR FORM                                   #清除畫面
   CALL g_atd1.clear()
   CALL cl_set_head_visible("","YES")     

   CONSTRUCT g_wc ON atd01,atd02,atd03,atd04,atd07,atd10,atd08,atd11,
                     atd14,atd15, 
                     atd05,atd16,atd17,atd09,atd13,atd06,atd12 
                FROM atd01,atd02,atd03,atd04,atd07,atd10,atd08,atd11,
                     atd14,atd15,
                     s_atd1[1].atd05,s_atd1[1].atd16,s_atd1[1].atd17,s_atd1[1].atd09,s_atd1[1].atd13,s_atd1[1].atd06,s_atd1[1].atd12  #FUN-B70003  add atd16,atd17

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
          WHEN INFIELD(atd02)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_atd02"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atd02           
             NEXT FIELD atd02
          WHEN INFIELD(atd07)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_atd07"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atd07
             NEXT FIELD atd07
          WHEN INFIELD(atd10)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_atd10"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atd10       
             NEXT FIELD atd10
          WHEN INFIELD(atd05)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_atd05"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atd05
             NEXT FIELD atd05
          WHEN INFIELD(atd12)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_asg"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atd12
             NEXT FIELD atd12
          WHEN INFIELD(atd14)                   #FUN-B70003  add
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_azi"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO atd14
             NEXT FIELD atd14
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
   LET g_sql="SELECT UNIQUE atd01,atd02,atd03,atd04 FROM atd_file ",
             " WHERE ", g_wc CLIPPED,
             " ORDER BY atd01,atd02,atd03,atd04 "
   PREPARE t009_prepare FROM g_sql              #預備一下
   DECLARE t009_b_cs                            #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t009_prepare
                                                #計算本次查詢單頭的筆數
   LET g_sql_tmp= "SELECT UNIQUE atd01,atd02,atd03,atd04 FROM atd_file ",                                                     
                  " WHERE ",g_wc CLIPPED,                                                                                     
                  "   INTO TEMP x"                                                                                            
   DROP TABLE x                                                                                                               
   PREPARE t009_pre_x FROM g_sql_tmp
   EXECUTE t009_pre_x                                                                                                         
   LET g_sql = "SELECT COUNT(*) FROM x"                                                                                       
   PREPARE t009_precount FROM g_sql
   DECLARE t009_count CURSOR FOR t009_precount
END FUNCTION

FUNCTION t009_menu()
   WHILE TRUE
      CALL t009_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t009_a()
            END IF
     #   WHEN "modify"
     #      IF cl_chk_act_auth() THEN
     #         CALL t009_u()
     #      END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t009_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t009_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t009_q() 
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
          #    CALL t009_out()
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

FUNCTION t009_a()
   DEFINE li_chk_bookno  LIKE type_file.num5  
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_sw           LIKE type_file.chr1, 
          l_cmd          LIKE type_file.chr1000, 
          l_n            LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF                #檢查權限
   MESSAGE ""
   INITIALIZE g_atd.* TO NULL 
   CLEAR FORM
   CALL g_atd1.clear()
   CALL cl_opmsg('a')

   LET g_atd.atd11 = '2' 
   DISPLAY BY NAME g_atd.atd11  

   WHILE TRUE
      CALL t009_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      CALL g_atd1.clear()
      SELECT COUNT(*) INTO l_n FROM atd_file WHERE atd01=g_atd.atd01
                                               AND atd02=g_atd.atd02 
                                               AND atd03=g_atd.atd03
                                               AND atd04=g_atd.atd04
      LET g_rec_b = 0 
      IF l_n > 0 THEN
         CALL t009_b_fill('1=1')
      END IF
      CALL t009_b()                             #輸入單身
      LET g_atd_t.atd01 = g_atd.atd01           #保留舊值                          
      LET g_atd_t.atd02 = g_atd.atd02           #保留舊值
      LET g_atd_t.atd03 = g_atd.atd03           #保留舊值 
      LET g_atd_t.atd04 = g_atd.atd04           #保留舊值
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION t009_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改 
   l_cnt           LIKE type_file.num5,       
   l_n1,l_n        LIKE type_file.num5,
   l_asa02         LIKE asa_file.asa02,
   l_asa03         LIKE asa_file.asa03       

      CALL cl_set_head_visible("","YES")
      INPUT BY NAME g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04,
                    g_atd.atd10,g_atd.atd08,g_atd.atd14,g_atd.atd15  WITHOUT DEFAULTS
 
         BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t009_set_entry(p_cmd)
            CALL t009_set_no_entry(p_cmd)
            CALL cl_qbe_init()

 
         AFTER FIELD atd01
            IF NOT cl_null(g_atd.atd01) THEN
               SELECT COUNT(*) INTO l_n FROM asa_file WHERE asa01 = g_atd.atd01 AND asa04 = 'Y'
               IF l_n = 0 THEN 
                  CALL cl_err(g_atd.atd01,100,0)
                  NEXT FIELD atd01
               END IF
               SELECT asa02,asa03 INTO l_asa02,l_asa03 FROM asa_file WHERE asa01 = g_atd.atd01 AND asa04 = 'Y' 
               DISPLAY l_asa02 TO FORMONLY.atd01_1
               DISPLAY l_asa03 TO FORMONLY.atd01_2
            ELSE 
               NEXT FIELD atd01
            END IF
 
         AFTER FIELD atd02
            IF NOT cl_null(g_atd.atd02) THEN
               SELECT COUNT(*) INTO l_n FROM asg_file WHERE asg01 = g_atd.atd02
               IF l_n = 0 THEN 
                  CALL cl_err(g_atd.atd02,100,0)
                  NEXT FIELD atd02
               END IF
               IF g_aza.aza04 = 'Y' THEN 
                  SELECT asg06 INTO g_atd.atd07 FROM asg_file,asa_file WHERE asg01 = asa02 AND asa01 = g_atd.atd01 
                  DISPLAY BY NAME g_atd.atd07
               END IF
               SELECT asg06 INTO g_atd.atd10 FROM asg_file WHERE asg01 = g_atd.atd02 
               DISPLAY BY NAME g_atd.atd10 
            END IF

        #No.FUN-B80135--add--str--
        AFTER FIELD atd03
          IF NOT cl_null(g_atd.atd03) THEN
            IF g_atd.atd03 < 0 THEN
               CALL cl_err(g_atd.atd03,'apj-035',0)
              LET g_atd.atd03 = g_atd_t.atd03
              NEXT FIELD atd03
            END IF
            IF g_atd.atd03<g_year THEN
               CALL cl_err(g_atd.atd03,'atp-164',0)
               LET g_atd.atd03 = g_atd_t.atd03
               NEXT FIELD atd03
            ELSE
               IF g_atd.atd03=g_year AND g_atd.atd04<=g_month THEN
                  CALL cl_err('','atp-164',0)
                  NEXT FIELD atd04
               END IF 
            END IF 
          END IF

        AFTER FIELD atd04
          IF NOT cl_null(g_atd.atd04) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_atd.atd03
            IF g_azm.azm02 = 1 THEN
               IF g_atd.atd04 > 12 OR g_atd.atd04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD atd04
               END IF
            ELSE
               IF g_atd.atd04 > 13 OR g_atd.atd04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD atd04
               END IF
            END IF
            IF NOT cl_null(g_atd.atd03) AND g_atd.atd03<=g_year 
               AND g_atd.atd04<=g_month THEN
               CALL cl_err('','atp-164',0)
               NEXT FIELD atd04
            END IF 
          END IF
          #No.FUN-B80135--add--str--
     
        #TQC-C60143--add--str-- 
        AFTER FIELD atd14
           IF g_atd.atd14 IS NOT NULL THEN
              CALL t501_atd14('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 LET g_atd.atd14 = g_atd_t.atd14
                 DISPLAY BY NAME g_atd.atd14
                 NEXT FIELD atd14
              END IF
           END IF           
        #TQC-C60143--add--end--
  
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF

         ON ACTION controlp                 # 沿用所有欄位
            CASE
              WHEN INFIELD(atd01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asa1"
               LET g_qryparam.default1 = g_atd.atd01 
               CALL cl_create_qry() RETURNING g_atd.atd01 
               DISPLAY BY NAME g_atd.atd01
               NEXT FIELD atd01
              WHEN INFIELD(atd02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asg"
               LET g_qryparam.default1 = g_atd.atd02
               CALL cl_create_qry() RETURNING g_atd.atd02
               DISPLAY BY NAME g_atd.atd02
               NEXT FIELD atd02
              WHEN INFIELD(atd10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_atd.atd10
               CALL cl_create_qry() RETURNING g_atd.atd10
               DISPLAY BY NAME g_atd.atd10
               NEXT FIELD atd10
              WHEN INFIELD(atd14)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_atd.atd14
               CALL cl_create_qry() RETURNING g_atd.atd14
               DISPLAY BY NAME g_atd.atd14
               NEXT FIELD atd14
              OTHERWISE 
               EXIT CASE
            END CASE

         ON ACTION CONTROLZ
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
      END INPUT
END FUNCTION

#TQC-C60143--add--str--
FUNCTION t501_atd14(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_azi01    LIKE azi_file.azi01
   DEFINE l_aziacti  LIKE azi_file.aziacti

   LET g_errno=''
   SELECT azi01 INTO l_azi01 FROM azi_file WHERE azi01 = g_atd.atd14

   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aap-002'
                                LET l_azi01=NULL
       WHEN l_aziacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_azi01 TO atd14
   END IF

END FUNCTION
#TQC-C60143--add--end--

FUNCTION t009_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_atd.* TO NULL      

   MESSAGE ""
   CALL cl_opmsg('q')
   CALL t009_cs()                         #取得查詢條件
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t009_b_cs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_atd.* TO NULL
   ELSE
      CALL t009_fetch('F')               #讀出TEMP第一筆並顯示
      OPEN t009_count
      FETCH t009_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
END FUNCTION

FUNCTION t009_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680098 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680098 INTEGER

   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     t009_b_cs INTO g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04                                
       WHEN 'P' FETCH PREVIOUS t009_b_cs INTO g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04                                
       WHEN 'F' FETCH FIRST    t009_b_cs INTO g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04                   
       WHEN 'L' FETCH LAST     t009_b_cs INTO g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04                   
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
            FETCH ABSOLUTE g_jump t009_b_cs INTO g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04                    
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

   CALL t009_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION t009_show()
DEFINE l_asa02    LIKE asa_file.asa02
DEFINE l_asa03    LIKE asa_file.asa03
DEFINE g_asz01    LIKE asz_file.asz01  #TQC-B70138  add
   SELECT asa02,asa03 INTO l_asa02,l_asa03 FROM asa_file WHERE asa01 = g_atd.atd01 AND asa04 = 'Y'
   DISPLAY l_asa02 TO FORMONLY.atd01_1
   DISPLAY l_asa03 TO FORMONLY.atd01_2  #TQC-B70138 mark   #FUN-B70003  
   
   #TQC-B70138 --beatk
  # CALL s_aaz641_asg(g_atd.atd01,l_asa02) RETURNING g_dbs_asg03
  # CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01
  # DISPLAY g_asz01 TO FORMONLY.atd01_2                #FUN-B70003  mark
   #TQC-B70138 --end
   
   SELECT atd07,atd08,atd10,atd11,atd14,atd15 
     INTO g_atd.atd07,g_atd.atd08,g_atd.atd10,g_atd.atd11,
          g_atd.atd14,g_atd.atd15 
     FROM atd_file 
    WHERE atd01 = g_atd.atd01
      AND atd02 = g_atd.atd02
      AND atd03 = g_atd.atd03
      AND atd04 = g_atd.atd04
   DISPLAY BY NAME g_atd.*              
   DISPLAY g_atd.atd01 TO atd01
   DISPLAY g_atd.atd02 TO atd02
   DISPLAY g_atd.atd03 TO atd03
   DISPLAY g_atd.atd04 TO atd04
   DISPLAY g_atd.atd07 TO atd07
   DISPLAY g_atd.atd10 TO atd10
   DISPLAY g_atd.atd08 TO atd08
   DISPLAY g_atd.atd11 TO atd11   
   DISPLAY g_atd.atd14 TO atd14
   DISPLAY g_atd.atd15 TO atd15
   CALL t009_b_fill(g_wc)             #單身
   CALL cl_show_fld_cont()  
END FUNCTION

#單身
FUNCTION t009_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   
   l_n             LIKE type_file.num5,     #檢查重複用    
   l_lock_sw       LIKE type_file.chr1,     #單身鎖住否   
   p_cmd           LIKE type_file.chr1,     #處理狀態    
   l_atd_delyn     LIKE type_file.chr1,     #判斷是否可以刪除單身資料ROW 
   l_chr           LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,     #可新增否     
   l_allow_delete  LIKE type_file.num5      #可刪除否    

   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF        #檢查權限
   IF cl_null(g_atd.atd01) OR cl_null(g_atd.atd02) OR cl_null(g_atd.atd03) OR cl_null(g_atd.atd04) THEN
       RETURN
   END IF

   CALL cl_opmsg('b')                #單身處理的操作提示

  # LET g_forupd_sql = "SELECT atd05,'',atd09,atd13,atd06,atd12 FROM atd_file",
  #                    " WHERE atd01 = ? AND atd02=? AND atd03=? AND atd04=? AND atd05=? AND atd12=?  FOR UPDATE  "  #luttb add atd12 
   LET g_forupd_sql = "SELECT atd05,atd16,atd17,atd09,atd13,atd06,atd12 FROM atd_file ",
                      " WHERE atd01 = ? AND atd02=? AND atd03=? AND atd04=? AND atd05=? AND atd12=?  FOR UPDATE  "   #FUN-B70003 add atd16,atd17
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)

   DECLARE t009_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_atd1 WITHOUT DEFAULTS FROM s_atd1.*
      ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         LET g_action_choice = ""
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         #CALL cl_set_comp_entry("atd05_1",FALSE)
         CALL cl_set_comp_entry("atd16,atd17",FALSE)           #FUN-B70003  把atd05_1换成atd16
         
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET  g_before_input_done = FALSE
            CALL t009_set_entry(p_cmd)
            CALL t009_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            BEGIN WORK
            LET p_cmd='u'
            LET g_atd1_t.* = g_atd1[l_ac].*  #BACKUP
            OPEN t009_bcl USING g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04,
                                g_atd1[l_ac].atd05,g_atd1[l_ac].atd12   #luttb add atd12
            IF STATUS THEN
               CALL cl_err("OPEN t009_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t009_bcl INTO g_atd1[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_atd1_t.atd05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT nml02,nml03 INTO g_atd1[l_ac].atd16,g_atd1[l_ac].atd17 FROM nml_file WHERE nml01 = g_atd1[l_ac].atd05    #FUN-B70003
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_atd1[l_ac].* TO NULL
         LET g_atd1[l_ac].atd09 = 0 
         LET g_atd1[l_ac].atd06 = 0 
         LET g_atd1[l_ac].atd13 = 0
         LET g_atd1_t.* = g_atd1[l_ac].*
         CALL cl_show_fld_cont() 
         NEXT FIELD atd05

      AFTER INSERT
         IF INT_FLAG THEN 
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            CLOSE t009_bcl
         END IF
         #INSERT INTO atd_file VALUES(g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04,g_atd1[l_ac].atd05,
         #                            g_atd1[l_ac].atd06,g_atd.atd07,g_atd.atd08,g_atd1[l_ac].atd09,
         #                            g_atd.atd10,g_atd.atd11,g_atd1[l_ac].atd12,g_atd1[l_ac].atd13,g_atd.atd14,g_atd.atd15,
         #                          #  g_atd1[l_ac].atd16,g_atd1[l_ac].atd17,
         #                            g_legal)  #FUN-B70003 add g_atd1[l_ac].atd16,g_atd1[l_ac].atd17  

         INSERT INTO atd_file VALUES(g_atd.atd01,g_atd.atd02,g_atd.atd03,g_atd.atd04,g_atd1[l_ac].atd05,
                                     g_atd1[l_ac].atd06,g_atd.atd07,g_atd.atd08,g_atd1[l_ac].atd09,
                                     #g_atd.atd10,g_atd.atd11,g_atd1[l_ac].atd12,g_atd1[l_ac].atd13,g_atd.atd14,g_atd.atd15,g_legal,g_atd1[l_ac].atd16,g_atd1[l_ac].atd17)  #FUN-B70003 add g_atd1[l_ac].atd16,g_atd1[l_ac].atd17    #TQC-C60143  mark
                                     g_atd.atd10,g_atd.atd11,g_atd1[l_ac].atd12,g_atd1[l_ac].atd13,g_atd.atd14,g_atd.atd15,g_atd1[l_ac].atd16,g_atd1[l_ac].atd17,g_legal)   #TQC-C60143  add  
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","atd_file",g_atd1[l_ac].atd05,"",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
         END IF

      AFTER FIELD atd05                        #check 編號是否重複
       IF NOT cl_null(g_atd1[l_ac].atd05) THEN
         IF g_atd1[l_ac].atd05 != g_atd1_t.atd05 OR
            cl_null(g_atd1_t.atd05) THEN
            SELECT COUNT(*) INTO l_n FROM nml_file 
             WHERE nml01 = g_atd1[l_ac].atd05
            IF l_n = 0 THEN 
               CALL cl_err(g_atd1[l_ac].atd05,100,0)
               NEXT FIELD atd05
            END IF

            SELECT COUNT(*) INTO l_n FROM atd_file
             WHERE atd01 = g_atd.atd01 AND atd02 = g_atd.atd02   
               AND atd03 = g_atd.atd03 AND atd04 = g_atd.atd04
               AND atd05 = g_atd1[l_ac].atd05      
               AND atd12 = g_atd1[l_ac].atd12   #luttb add atd12 
            IF l_n <> 0 THEN
               LET g_atd1[l_ac].atd05 = g_atd1_t.atd05
               CALL cl_err('','-239',0)
               NEXT FIELD atd05 
            ELSE
               SELECT nml02,nml03 INTO g_atd1[l_ac].atd16,g_atd1[l_ac].atd17 FROM nml_file 
                WHERE nml01 = g_atd1[l_ac].atd05                        #FUN-B70003
            END IF
         END IF
       END IF 
#luttb--add--str--
      AFTER FIELD atd12
         IF g_atd1[l_ac].atd12 != g_atd1_t.atd12 OR
            cl_null(g_atd1_t.atd12) THEN
            SELECT COUNT(*) INTO l_n FROM asg_file
             WHERE asg01 = g_atd1[l_ac].atd12
            IF l_n = 0 THEN
               CALL cl_err(g_atd1[l_ac].atd12,100,0)
               NEXT FIELD atd12
            END IF
            SELECT COUNT(*) INTO l_n FROM atd_file
             WHERE atd01 = g_atd.atd01 AND atd02 = g_atd.atd02
               AND atd03 = g_atd.atd03 AND atd04 = g_atd.atd04
               AND atd05 = g_atd1[l_ac].atd05
               AND atd12 = g_atd1[l_ac].atd12
            IF l_n <> 0 THEN
               LET g_atd1[l_ac].atd12 = g_atd1_t.atd12
               CALL cl_err('','-239',0)
               NEXT FIELD atd12
            END IF
         END IF
#luttb--add--end
      AFTER FIELD atd09 
         IF g_atd1[l_ac].atd09 < 0  THEN 
            CALL cl_err(g_atd1[l_ac].atd09,'',0)
            NEXT FIELD atd09
         ELSE
            #LET g_atd1[l_ac].atd06 = g_atd1[l_ac].atd09 * g_atd.atd08 / 100   #luttb
            LET g_atd1[l_ac].atd13 = g_atd1[l_ac].atd09 * g_atd.atd08
            LET g_atd1[l_ac].atd06 = g_atd1[l_ac].atd13 * g_atd.atd15 
         END IF
         DISPLAY BY NAME g_atd1[l_ac].atd13
         DISPLAY BY NAME g_atd1[l_ac].atd06

      AFTER FIELD atd13
         IF g_atd1[l_ac].atd13 < 0  THEN
            CALL cl_err(g_atd1[l_ac].atd13,'',0)
            NEXT FIELD atd13
         ELSE
            LET g_atd1[l_ac].atd06 = g_atd1[l_ac].atd13 * g_atd.atd15
         END IF
         DISPLAY BY NAME g_atd1[l_ac].atd13

      BEFORE DELETE                            #是否取消單身
         IF g_atd1_t.atd05 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM atd_file
             WHERE atd01 = g_atd.atd01   
               AND atd02 = g_atd.atd02
               AND atd03 = g_atd.atd03
               AND atd04 = g_atd.atd04
               AND atd05 = g_atd1_t.atd05
               AND atd12 = g_atd1_t.atd12   #luttb add
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","atd_file",g_atd1_t.atd05,"",SQLCA.sqlcode,"","",1)
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      ON ROW CHANGE
         IF g_atd1_t.atd05 IS NOT NULL THEN
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_atd1[l_ac].atd05,-263,1)
               LET g_atd1[l_ac].* = g_atd1_t.*
            ELSE
               UPDATE atd_file SET atd05 = g_atd1[l_ac].atd05,
                                   atd16 = g_atd1[l_ac].atd16,  #FUN-B70003
                                   atd17 = g_atd1[l_ac].atd17,  #FUN-B70003 
                                   atd09 = g_atd1[l_ac].atd09,
                                   atd06 = g_atd1[l_ac].atd06,
                                   atd13 = g_atd1[l_ac].atd13,
                                   atd12 = g_atd1[l_ac].atd12 
                WHERE atd01 = g_atd.atd01 AND atd02 = g_atd.atd02 AND atd03 = g_atd.atd03
                  AND atd04 = g_atd.atd04 AND atd05 = g_atd1_t.atd05
                  AND atd12 = g_atd1_t.atd12   #luttb
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","atd_file",g_atd.atd01,g_atd1_t.atd05,SQLCA.sqlcode,"","",1)
                  LET g_atd1[l_ac].* = g_atd1_t.*
               ELSE
                  CALL cl_msg('UPDATE O.K')
               END IF
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #FUN-D30032--mark&add--str--
        #LET l_ac_t = l_ac
         #luttb--add--str--
        #IF INT_FLAG THEN
        #   LET INT_FLAG=0
        #END IF 
         #luttb--add--end
        #IF p_cmd = 'u' THEN
        #   CLOSE t009_bcl
        #END IF  
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_atd1[l_ac].* = g_atd1_t.*
            ELSE
               CALL g_atd1.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE t009_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         CLOSE t009_bcl
         COMMIT WORK 
        #FUN-D30032--mark&add--end--  

      ON ACTION CONTROLP
         CASE
         WHEN INFIELD(atd05)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_nml"
            LET g_qryparam.default1 = g_atd1[l_ac].atd05
            CALL cl_create_qry() RETURNING g_atd1[l_ac].atd05
            NEXT FIELD atd05
         WHEN INFIELD(atd12)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asg"
               LET g_qryparam.default1 = g_atd1[l_ac].atd12
               CALL cl_create_qry() RETURNING g_atd1[l_ac].atd12
               DISPLAY BY NAME g_atd1[l_ac].atd12
               NEXT FIELD atd12
         OTHERWISE
             EXIT CASE
         END CASE
      ON ACTION CONTROLZ
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

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
   END INPUT
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     CLOSE t009_bcl
#     ROLLBACK WORK
#     RETURN
#  END IF

   CLOSE t009_bcl
   COMMIT WORK
END FUNCTION

FUNCTION t009_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            STRING,        
   l_flag          LIKE type_file.chr1,              #有無單身筆數     
   l_sql           STRING       

   #LET l_sql = "SELECT atd05,nml02,atd09,atd13,atd06,atd12 ", 
   LET l_sql = "SELECT atd05,atd16,atd17,atd09,atd13,atd06,atd12 ",   #FUN-B70003 add atd16,atd17
               "  FROM atd_file,OUTER nml_file",
               " WHERE atd01 = '",g_atd.atd01,"'",     
               "   AND atd02 = '",g_atd.atd02,"'",                       
               "   AND atd03 = '",g_atd.atd03,"'",
               "   AND atd04 = '",g_atd.atd04,"'",
               "   AND atd05 = nml_file.nml01 ",
               "   AND ",p_wc CLIPPED, 
               " ORDER BY atd01,atd02,atd03,atd04,atd05 "

   PREPARE atd_pre FROM l_sql
   DECLARE atd_cs CURSOR FOR atd_pre

   CALL g_atd1.clear()
   LET g_cnt = 1
   LET l_flag='N'
   LET g_rec_b=0
   FOREACH atd_cs INTO g_atd1[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET l_flag='Y'
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
   END FOREACH
   CALL g_atd1.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   IF l_flag='N' THEN LET g_rec_b=0 END IF     #無單身時將筆數清為零
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t009_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1  
 
END FUNCTION
 
FUNCTION t009_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1 
 
END FUNCTION

FUNCTION t009_bp(p_ud)
DEFINE
    p_ud   LIKE type_file.chr1 

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
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

      ON ACTION insert 
         LET g_action_choice="insert"
         EXIT DISPLAY

    # ON ACTION modify 
    #    LET g_action_choice="modify"
    #    EXIT DISPLAY
 
      ON ACTION delete 
         LET g_action_choice="delete"
         EXIT DISPLAY  

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL t009_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY      
 
      ON ACTION previous
         CALL t009_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY 

      ON ACTION jump
         CALL t009_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)                         
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION next
         CALL t009_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY            

      ON ACTION last
         CALL t009_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY           

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
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
         LET g_action_choice="detail"
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

FUNCTION t009_r()

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_atd.atd01) AND cl_null(g_atd.atd02) AND cl_null(g_atd.atd03) AND cl_null(g_atd.atd04) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK

   IF cl_delh(0,0) THEN
      DELETE FROM atd_file WHERE atd01=g_atd.atd01 AND atd02=g_atd.atd02  
                             AND atd03=g_atd.atd03 AND atd04=g_atd.atd04
      #TQC-C60143--add--str--
      IF cl_null(g_wc) THEN 
         LET g_wc = "1=1"
      END IF 
      LET g_sql_tmp= "SELECT UNIQUE atd01,atd02,atd03,atd04 FROM atd_file ",
                     " WHERE ",g_wc CLIPPED,
                     "   INTO TEMP x"
      DROP TABLE x
      PREPARE t009_pre_x1 FROM g_sql_tmp
      EXECUTE t009_pre_x1
      DELETE FROM x WHERE atd01=g_atd.atd01 AND atd02=g_atd.atd02
                      AND atd03=g_atd.atd03 AND atd04=g_atd.atd04
      #TQC-C60143--add--end--
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","atd_file",g_atd.atd01,g_atd.atd02,SQLCA.sqlcode,"","",1)
      ELSE
         CLEAR FORM
         CALL g_atd1.clear()
         OPEN t009_count
         FETCH t009_count INTO g_row_count
         #LET g_row_count = g_row_count -1     #刪除完後筆數會算錯(多一筆),所以要減一    #TQC-C60143  mark
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t009_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t009_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE 
            CALL t009_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
#NO.FUN-B40104
