# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: gglq025.4gl
# Descriptions...: 內部交易查詢作業 
# Date & Author..: 11/03/24 By lutingting
# Modify.........: NO.FUN-B40104 11/05/05 By jll    合并报表产品作业
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-BB0036

#模組變數(Module Variables)
DEFINE g_aed    RECORD
                   aed03       LIKE aed_file.aed03,
                   aed04       LIKE aed_file.aed04,
                   asg01_a     LIKE asg_file.asg01,
                   asg01_b     LIKE asg_file.asg01,
                   asg02_a     LIKE asg_file.asg02,
                   asg02_b     LIKE asg_file.asg02,
                   aag01_a     LIKE aag_file.aag01,
                   aag01_b     LIKE aag_file.aag01 
                END RECORD,
       g_aed_1  DYNAMIC ARRAY OF RECORD
                   aag01_1     LIKE aag_file.aag01,    #科目编号
                   aag02_desc1 LIKE aag_file.aag02,    #科目名称
                   aed02_1     LIKE aed_file.aed02,    #关系人
                   amt1_1      LIKE aed_file.aed05,    #期初余额
                   amt2_1d     LIKE aed_file.aed05,    #本期发生额-贷
                   amt2_1c     LIKE aed_file.aed05,    #本期发生额-贷
                   amt3_1      LIKE aed_file.aed05     #期末余额
                END RECORD,
       g_aed_2  DYNAMIC ARRAY OF RECORD
                   aag01_2     LIKE aag_file.aag01,    #科目编号
                   aag02_desc2 LIKE aag_file.aag02,    #科目名称
                   aed02_2     LIKE aed_file.aed02,    #关系人
                   amt1_2      LIKE aed_file.aed05,    #期初余额
                   amt2_2d     LIKE aed_file.aed05,    #本期发生额-借
                   amt2_2c     LIKE aed_file.aed05,    #本期发生额-贷
                   amt3_2      LIKE aed_file.aed05     #期末余额
                END RECORD,
       g_dept   DYNAMIC ARRAY OF RECORD
                   asg01_a     LIKE asg_file.asg01,
                   azp03_a     LIKE azp_file.azp03,
                   asg05_a     LIKE asg_file.asg05,
                   asg01_b     LIKE asg_file.asg01,
                   azp03_b     LIKE azp_file.azp03,
                   asg05_b     LIKE asg_file.asg05
                END RECORD,
       g_wc1,g_sql        STRING,                 #WHERE CONDITION
       g_wc2,g_wc3,g_wc4,g_wc5,g_wc6   STRING,
       p_row,p_col        LIKE type_file.num5,
       g_rec_b            LIKE type_file.num5,     #單身筆數
       g_rec_b1           LIKE type_file.num5   
DEFINE g_cnt              LIKE type_file.num10
DEFINE g_row_count        LIKE type_file.num10
DEFINE g_curs_index       LIKE type_file.num10
DEFINE g_jump             LIKE type_file.num10
DEFINE mi_no_ask          LIKE type_file.num5
DEFINE l_ac,l_ac1         LIKE type_file.num5  
DEFINE g_qbe_aed03        LIKE type_file.chr50
DEFINE g_qbe_aed04        LIKE type_file.chr50
DEFINE g_qbe_aag01_a      LIKE type_file.chr50
DEFINE g_qbe_aag01_b      LIKE type_file.chr50 
DEFINE g_msg              STRING
DEFINE g_no               LIKE type_file.num5
MAIN

   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 1 LET p_col = 1
   OPEN WINDOW q008_w AT p_row,p_col WITH FORM "ggl/42f/gglq025"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL q008_menu()
   CLOSE FORM q008_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q008_cs()
DEFINE i,j,k     LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_azp03_a LIKE azp_file.azp03
DEFINE l_azp03_b LIKE azp_file.azp03
DEFINE l_dept1  DYNAMIC ARRAY OF RECORD
                   asg01       LIKE asg_file.asg01
                END RECORD,
       l_dept2  DYNAMIC ARRAY OF RECORD
                   asg01       LIKE asg_file.asg01
                END RECORD
   CLEAR FORM #清除畫面
   CALL g_aed_1.clear()
   CALL g_aed_2.clear()
   CALL cl_opmsg('q')
   CALL cl_set_head_visible("","YES")

   INITIALIZE g_aed.* TO NULL
   
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc1 ON aed03

         AFTER FIELD aed03
            CALL GET_FLDBUF(aed03) RETURNING g_qbe_aed03

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      CONSTRUCT BY NAME g_wc6 ON aed04

         AFTER FIELD aed04
            CALL GET_FLDBUF(aed04) RETURNING g_qbe_aed04

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT
     
      CONSTRUCT BY NAME g_wc2 ON asg01_a

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      CONSTRUCT BY NAME g_wc3 ON asg01_b

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      CONSTRUCT BY NAME g_wc4 ON aag01_a

         AFTER FIELD aag01_a
            CALL GET_FLDBUF(aag01_a) RETURNING g_qbe_aag01_a

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      CONSTRUCT BY NAME g_wc5 ON aag01_b

         AFTER FIELD aag01_b
            CALL GET_FLDBUF(aag01_b) RETURNING g_qbe_aag01_b

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asg01_a) #公司编号
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_asg"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asg01_a
                 NEXT FIELD asg01_a
            WHEN INFIELD(asg01_b) #公司编号
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_asg"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asg01_b
                 NEXT FIELD asg01_b
            WHEN INFIELD(aag01_a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aag01_a
                 NEXT FIELD aag01_a
            WHEN INFIELD(aag01_b)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aag01_b
                 CALL GET_FLDBUF(aag01_b) RETURNING g_qbe_aag01_b
                 NEXT FIELD aag01_b
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
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION accept
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG
   END DIALOG
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF

   LET g_wc2= cl_replace_str(g_wc2,'asg01_a','asg01')
   LET g_wc3= cl_replace_str(g_wc3,'asg01_b','asg01')
   LET g_wc4= cl_replace_str(g_wc4,'aag01_a','aag01')
   LET g_wc5= cl_replace_str(g_wc5,'aag01_b','aag01')

   IF cl_null(g_wc1) THEN LET g_wc1 = " 1=1" END IF 
   IF cl_null(g_wc4) THEN LET g_wc4 = " 1=1" END IF
   IF cl_null(g_wc5) THEN LET g_wc5 = " 1=1" END IF 


   LET i = 1
   LET g_sql = "SELECT asg01 FROM asg_file ",
               " WHERE ",g_wc2 CLIPPED
   PREPARE sel_asg01_a_pre FROM g_sql
   DECLARE sel_asg01_a_cur CURSOR FOR sel_asg01_a_pre
   FOREACH sel_asg01_a_cur INTO l_dept1[i].*
       LET i = i+1
   END FOREACH
   CALL l_dept1.deleteElement(i)
   LET i = i-1

   LET j=1
   LET g_sql = "SELECT asg01 FROM asg_file ",
               " WHERE ",g_wc3 CLIPPED
   PREPARE sel_asg01_b_pre FROM g_sql
   DECLARE sel_asg01_b_cur CURSOR FOR sel_asg01_b_pre
   FOREACH sel_asg01_b_cur INTO l_dept2[j].*
       LET j = j+1
   END FOREACH
   CALL l_dept2.deleteElement(j)
   LET j = j-1

   DROP TABLE q008_temp
   CREATE TEMP TABLE q008_temp(
      asg01_a  LIKE type_file.chr10,
      asg01_b  LIKE type_file.chr10)
       
   FOR i = 1 TO l_dept1.getLength()   #A公司B公司排列组合
       FOR j =1 TO l_dept2.getLength()
           INSERT INTO q008_temp VALUES(l_dept1[i].asg01,l_dept2[j].asg01)
       END FOR
   END FOR

   LET g_sql=
       " SELECT * FROM q008_temp",
       " ORDER BY asg01_a,asg01_b"
   PREPARE q008_prepare FROM g_sql
   DECLARE q008_cs SCROLL CURSOR WITH HOLD FOR q008_prepare    #SCROLL CURSOR

   DECLARE q008_count CURSOR FOR
   SELECT COUNT(*) FROM q008_temp
END FUNCTION

FUNCTION q008_menu()
DEFINE   l_cmd        LIKE type_file.chr1000
   WHILE TRUE
      CALL q008_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q008_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION q008_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_aed_1.clear()
   CALL g_aed_2.clear()
   CALL q008_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN q008_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q008_count
      FETCH q008_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL q008_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION q008_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式
    l_abso          LIKE type_file.num10   #絕對的筆數

    CASE p_flag
       WHEN 'N' FETCH NEXT     q008_cs INTO g_aed.asg01_a,g_aed.asg01_b
       WHEN 'P' FETCH PREVIOUS q008_cs INTO g_aed.asg01_a,g_aed.asg01_b 
       WHEN 'F' FETCH FIRST    q008_cs INTO g_aed.asg01_a,g_aed.asg01_b
       WHEN 'L' FETCH LAST     q008_cs INTO g_aed.asg01_a,g_aed.asg01_b
       WHEN '/'
           IF (NOT mi_no_ask) THEN
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
           FETCH ABSOLUTE g_jump q008_cs INTO g_aed.asg01_a,g_aed.asg01_b 
           LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_aed.asg01_a,SQLCA.sqlcode,0)
       INITIALIZE g_aed.* TO NULL
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       DISPLAY g_curs_index TO FORMONLY.idx
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    CALL q008_show()
END FUNCTION

FUNCTION q008_show()
   DEFINE l_aag02   LIKE aag_file.aag02

   DISPLAY g_qbe_aed03 TO aed03
   DISPLAY g_qbe_aed04 TO aed04
   DISPLAY g_aed.asg01_a TO FORMONLY.asg01_a
   DISPLAY g_aed.asg01_b TO FORMONLY.asg01_b
   DISPLAY g_qbe_aag01_a TO FORMONLY.aag01_a
   DISPLAY g_qbe_aag01_b TO FORMONLY.aag01_b
 
   SELECT asg02 INTO g_aed.asg02_a FROM asg_file WHERE asg01 = g_aed.asg01_a
   SELECT asg02 INTO g_aed.asg02_b FROM asg_file WHERE asg01 = g_aed.asg01_b
   DISPLAY g_aed.asg02_a TO FORMONLY.asg02_a
   DISPLAY g_aed.asg02_b TO FORMONLY.asg02_b
   CALL q008_b_fill_1()
   CALL q008_b_fill_2()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION q008_b_fill_1()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_azp03   LIKE azp_file.azp03
   DEFINE l_asg05   LIKE asg_file.asg05
   DEFINE l_aag06   LIKE aag_file.aag06
 
   SELECT azp03,asg05 INTO l_azp03,l_asg05 FROM azp_file,asg_file
    WHERE azp01 = asg03 AND asg01 = g_aed.asg01_a
   LET l_azp03 = s_dbstring(l_azp03 CLIPPED)

   LET l_sql = " SELECT aed01,aag02,aed02,'',aed05,aed06,'' ",
               "   FROM ",l_azp03 CLIPPED,"aed_file,",l_azp03 CLIPPED,"aag_file",
               "  WHERE aag01 = aed01 ",
               "    AND aag00 = aed00 ",
               "    AND aed00 = '",l_asg05,"' AND aed011 = '99'",
               "    AND aed02 = '",g_aed.asg01_b,"'",     #异动码
               "    AND aed03 = '",g_qbe_aed03,"' AND aed04 = '",g_qbe_aed04,"'",
               "    AND ",g_wc4 CLIPPED   #科目
   PREPARE q008_pb1 FROM l_sql
   DECLARE q008_bcs1 CURSOR FOR q008_pb1          #BODY CURSOR
   
   CALL g_aed_1.clear()
   LET g_rec_b=0
   LET g_cnt = 1
   
   FOREACH q008_bcs1 INTO g_aed_1[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_sql = "SELECT aag06 FROM ",l_azp03 CLIPPED,"aag_file ",
                  " WHERE aag01 = '",g_aed_1[g_cnt].aag01_1,"'",
                  "   AND aag00 = '",l_asg05,"'"
      PREPARE sel_aag06_1 FROM l_sql
      EXECUTE sel_aag06_1 INTO l_aag06
      IF l_aag06 = '1' THEN   #借余
         LET l_sql = "SELECT SUM(aed05-aed06) FROM ",l_azp03 CLIPPED,"aed_file",  
                     " WHERE aed01 = '",g_aed_1[g_cnt].aag01_1,"'",   #科目
                     "   AND aed02 = '",g_aed.asg01_b,"'",   #异动码
                     "   AND aed03 = '",g_qbe_aed03,"'",     #年度
                     "   AND aed04 = '0' ",                    #期别 
                     "   AND aed00 = '",l_asg05,"'",         #帐套
                     "   AND aed011='99'"
         PREPARE sel_amt1_pre FROM l_sql
         DECLARE sel_amt1_cur CURSOR FOR sel_amt1_pre
         EXECUTE sel_amt1_cur INTO g_aed_1[g_cnt].amt1_1     #期初 

         LET l_sql = "SELECT SUM(aed05-aed06) FROM ",l_azp03 CLIPPED,"aed_file",
                     " WHERE aed01 = '",g_aed_1[g_cnt].aag01_1,"'",   #科目
                     "   AND aed02 = '",g_aed.asg01_b,"'",   #异动码
                     "   AND aed03 = '",g_qbe_aed03,"'",     #年度
                     "   AND aed04 BETWEEN '0' AND '",g_qbe_aed04,"'",     #期别
                     "   AND aed00 = '",l_asg05,"'",         #帐套
                     "   AND aed011='99'"
         PREPARE sel_amt3_pre FROM l_sql
         EXECUTE sel_amt3_pre INTO g_aed_1[g_cnt].amt3_1      #期末
      ELSE
         LET l_sql = "SELECT SUM(aed06-aed05) FROM ",l_azp03 CLIPPED,"aed_file",
                     " WHERE aed01 = '",g_aed_1[g_cnt].aag01_1,"'",   #科目
                     "   AND aed02 = '",g_aed.asg01_b,"'",   #异动码
                     "   AND aed03 = '",g_qbe_aed03,"'",     #年度
                     "   AND aed04 = '0' ",                    #期别
                     "   AND aed00 = '",l_asg05,"'",         #帐套
                     "   AND aed011='99'"
         PREPARE sel_amt1_pre1 FROM l_sql
         DECLARE sel_amt1_cur1 CURSOR FOR sel_amt1_pre1
         EXECUTE sel_amt1_cur1 INTO g_aed_1[g_cnt].amt1_1     #期初

         LET l_sql = "SELECT SUM(aed06-aed05) FROM ",l_azp03 CLIPPED,"aed_file",
                     " WHERE aed01 = '",g_aed_1[g_cnt].aag01_1,"'",   #科目
                     "   AND aed02 = '",g_aed.asg01_b,"'",   #异动码
                     "   AND aed03 = '",g_qbe_aed03,"'",     #年度
                     "   AND aed04 BETWEEN '0' AND '",g_qbe_aed04,"'",     #期别
                     "   AND aed00 = '",l_asg05,"'",         #帐套
                     "   AND aed011='99'"
         PREPARE sel_amt3_pre1 FROM l_sql
         EXECUTE sel_amt3_pre1 INTO g_aed_1[g_cnt].amt3_1  #期末
      END IF 
      IF cl_null(g_aed_1[g_cnt].amt1_1) THEN LET g_aed_1[g_cnt].amt1_1=0 END IF 
      IF cl_null(g_aed_1[g_cnt].amt2_1c) THEN LET g_aed_1[g_cnt].amt2_1c=0 END IF 
      IF cl_null(g_aed_1[g_cnt].amt2_1d) THEN LET g_aed_1[g_cnt].amt2_1d=0 END IF
      IF cl_null(g_aed_1[g_cnt].amt3_1) THEN LET g_aed_1[g_cnt].amt3_1=0 END IF 
      LET g_cnt = g_cnt+1
   END FOREACH
   CALL g_aed_1.DeleteElement(g_cnt)
   LET g_rec_b= g_cnt -1
   DISPLAY g_rec_b TO FORMONLY.cn2
   
END FUNCTION

FUNCTION q008_b_fill_2()              #BODY FILL UP
   DEFINE l_sql     STRING
   DEFINE l_azp03   LIKE azp_file.azp03
   DEFINE l_asg05   LIKE asg_file.asg05
   DEFINE l_aag06   LIKE aag_file.aag06
 
   SELECT azp03,asg05 INTO l_azp03,l_asg05 FROM azp_file,asg_file
    WHERE azp01 = asg03 AND asg01 = g_aed.asg01_b
   LET l_azp03 = s_dbstring(l_azp03 CLIPPED)

   LET l_sql = " SELECT aed01,aag02,aed02,'',aed05,aed06,'' ",
               "   FROM ",l_azp03 CLIPPED,"aed_file,",l_azp03 CLIPPED,"aag_file",
               "  WHERE aag01 = aed01 ",
               "    AND aag00 = aed00 ",
               "    AND aed00 = '",l_asg05,"' AND aed011 = '99'",
               "    AND aed02 = '",g_aed.asg01_a,"'",     #异动码
               "    AND aed03 = '",g_qbe_aed03,"' AND aed04 = '",g_qbe_aed04,"'",
               "    AND ",g_wc5 CLIPPED           #科目
   PREPARE q008_pb2 FROM l_sql
   DECLARE q008_bcs2 CURSOR FOR q008_pb2          #BODY CURSOR
   
   CALL g_aed_2.clear()
   LET g_rec_b1=0
   LET g_cnt = 1
   
   FOREACH q008_bcs2 INTO g_aed_2[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET l_sql = "SELECT aag06 FROM ",l_azp03 CLIPPED,"aag_file ",
                  " WHERE aag01 = '",g_aed_2[g_cnt].aag01_2,"'",
                  "   AND aag00 = '",l_asg05,"'"
      PREPARE sel_aag06_2 FROM l_sql
      EXECUTE sel_aag06_2 INTO l_aag06
      IF l_aag06 = '1' THEN   #借余
         LET l_sql = "SELECT SUM(aed05-aed06) FROM ",l_azp03 CLIPPED,"aed_file",  
                     " WHERE aed01 = '",g_aed_2[g_cnt].aag01_2,"'",   #科目
                     "   AND aed02 = '",g_aed.asg01_a,"'",   #异动码
                     "   AND aed03 = '",g_qbe_aed03,"'",     #年度
                     "   AND aed04 = '0' ",                    #期别 
                     "   AND aed00 = '",l_asg05,"'",         #帐套
                     "   AND aed011='99'"
         PREPARE sel_amt1_pre_2 FROM l_sql
         DECLARE sel_amt1_cur_2 CURSOR FOR sel_amt1_pre_2
         EXECUTE sel_amt1_cur_2 INTO g_aed_2[g_cnt].amt1_2     #期初 

         LET l_sql = "SELECT SUM(aed05-aed06) FROM ",l_azp03 CLIPPED,"aed_file",
                     " WHERE aed01 = '",g_aed_2[g_cnt].aag01_2,"'",   #科目
                     "   AND aed02 = '",g_aed.asg01_a,"'",   #异动码
                     "   AND aed03 = '",g_qbe_aed03,"'",     #年度
                     "   AND aed04 BETWEEN '0' AND '",g_qbe_aed04,"'",     #期别
                     "   AND aed00 = '",l_asg05,"'",         #帐套
                     "   AND aed011='99'"
         PREPARE sel_amt3_pre_2 FROM l_sql
         EXECUTE sel_amt3_pre_2 INTO g_aed_2[g_cnt].amt3_2  #期末
      ELSE
         LET l_sql = "SELECT SUM(aed06-aed05) FROM ",l_azp03 CLIPPED,"aed_file",
                     " WHERE aed01 = '",g_aed_2[g_cnt].aag01_2,"'",   #科目
                     "   AND aed02 = '",g_aed.asg01_a,"'",   #异动码
                     "   AND aed03 = '",g_qbe_aed03,"'",     #年度
                     "   AND aed04 = '0' ",                    #期别
                     "   AND aed00 = '",l_asg05,"'",         #帐套
                     "   AND aed011='99'"
         PREPARE sel_amt1_pre2 FROM l_sql
         DECLARE sel_amt1_cur2 CURSOR FOR sel_amt1_pre2
         EXECUTE sel_amt1_cur2 INTO g_aed_2[g_cnt].amt1_2     #期初

         LET l_sql = "SELECT SUM(aed06-aed05) FROM ",l_azp03 CLIPPED,"aed_file",
                     " WHERE aed01 = '",g_aed_2[g_cnt].aag01_2,"'",   #科目
                     "   AND aed02 = '",g_aed.asg01_a,"'",   #异动码
                     "   AND aed03 = '",g_qbe_aed03,"'",     #年度
                     "   AND aed04 BETWEEN '0' AND '",g_qbe_aed04,"'",     #期别
                     "   AND aed00 = '",l_asg05,"'",         #帐套
                     "   AND aed011='99'"
         PREPARE sel_amt3_pre2 FROM l_sql
         EXECUTE sel_amt3_pre2 INTO g_aed_2[g_cnt].amt3_2  #期末
      END IF 
      IF cl_null(g_aed_2[g_cnt].amt1_2) THEN LET g_aed_2[g_cnt].amt1_2=0 END IF 
      IF cl_null(g_aed_2[g_cnt].amt2_2d) THEN LET g_aed_2[g_cnt].amt2_2d=0 END IF 
      IF cl_null(g_aed_2[g_cnt].amt2_2c) THEN LET g_aed_2[g_cnt].amt2_2c=0 END IF
      IF cl_null(g_aed_2[g_cnt].amt3_2) THEN LET g_aed_2[g_cnt].amt3_2=0 END IF 
      LET g_cnt = g_cnt+1
   END FOREACH
   CALL g_aed_2.DeleteElement(g_cnt)
   LET g_rec_b1= g_cnt -1
   DISPLAY g_rec_b1 TO FORMONLY.cn2
END FUNCTION   

FUNCTION q008_bp(p_ud)
   DEFINE p_ud    LIKE type_file.chr1

   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_aed_1 TO s_aed_1.* ATTRIBUTE(COUNT=g_rec_b) 

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY   
   

   DISPLAY ARRAY g_aed_2 TO s_aed_2.* ATTRIBUTE(COUNT=g_rec_b1) 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()  
   END DISPLAY
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG  

      ON ACTION first
         CALL q008_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG     

      ON ACTION previous
         CALL q008_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DIALOG 
 
      ON ACTION jump
         CALL q008_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG

      ON ACTION next
         CALL q008_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG   
 
      ON ACTION last
         CALL q008_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG  

      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG 

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG  

      ON ACTION accept
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
 
      AFTER DIALOG        
         CONTINUE DIALOG  

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

   END DIALOG     
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-B40104
