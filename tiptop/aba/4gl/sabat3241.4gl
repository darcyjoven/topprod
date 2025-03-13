# Prog. Version..: '5.30.06-13.04.22(00001)'     #
# PROG. VERSION..: '5.25.04-11.09.14(00000)'     #
#
# PATTERN NAME...: sabat3241
# DESCRIPTIONS...: 條碼跨庫調撥維護作業
# DATE & AUTHOR..: 12/11/18 By Mandy #DEV-CB0021
# Modify.........: No:DEV-CC0007 13/01/02 當出/入庫的倉/儲不一致時,齊套數(出/入)計算有誤
# Modify.........: No.DEV-D30025 13/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---

 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"
 
DEFINE 
 
    tm   RECORD    #程式變數(Program Variables)
        box01   LIKE box_file.box01
         END  RECORD,
    g_box    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         box11  LIKE  box_file.box11,   #配货类型
         box12  LIKE  box_file.box12,   #系列
         box08  LIKE  box_file.box08,   #安库否
         box02  LIKE  box_file.box02,   #出货通知单项次
         box04  LIKE  box_file.box04,   #料件
         ima02      LIKE  ima_file.ima02,          #品名
         ima021     LIKE  ima_file.ima021,         #规格
         box06  LIKE  box_file.box06,   #预计出货数量
         sets       LIKE  box_file.box06,   #齐套数量
         sets_i     LIKE  box_file.box06    #齐套数量
           END  RECORD,
    g_box_t    RECORD    #程式變數(Program Variables)
         box11  LIKE  box_file.box11,   #配货类型
         box12  LIKE  box_file.box12,   #系列
         box08  LIKE  box_file.box08,   #安库否
         box02  LIKE  box_file.box02,   #出货通知单项次
         box04  LIKE  box_file.box04,   #料件
         ima02      LIKE  ima_file.ima02,         #品名
         ima021     LIKE  ima_file.ima021,        #规格
         box06  LIKE  box_file.box06,   #预计出货数量
         sets       LIKE  box_file.box06,   #齐套数量
         sets_i     LIKE  box_file.box06    #齐套数量
           END  RECORD,
    g_imgb    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        imgb01    LIKE imgb_file.imgb01,   #条码
        ibb05     LIKE ibb_file.ibb05,     #包号
        imgb02    LIKE imgb_file.imgb02,   #仓库
        imgb03    LIKE imgb_file.imgb03,   #库位     
        imgb04    LIKE imgb_file.imgb04,   #批号
        imgb05    LIKE imgb_file.imgb05,   #数量
        more      LIKE imgb_file.imgb05,   #多
        less      LIKE imgb_file.imgb05    #缺
            END  RECORD,
    g_imgb_i    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        imgb01_i    LIKE imgb_file.imgb01,   #条码
        ibb05_i     LIKE ibb_file.ibb05,     #包号
        imgb02_i    LIKE imgb_file.imgb02,   #仓库
        imgb03_i    LIKE imgb_file.imgb03,   #库位     
        imgb04_i    LIKE imgb_file.imgb04,   #批号
        imgb05_i    LIKE imgb_file.imgb05,   #数量
        more_i      LIKE imgb_file.imgb05,   #多
        less_i      LIKE imgb_file.imgb05    #缺
            END  RECORD,
    g_sets      DYNAMIC ARRAY OF RECORD 
        sets LIKE imgb_file.imgb05    #单身齐套数量
            END  RECORD, 
    g_wc                 STRING,  
    g_sql                STRING,
    g_cmd                STRING,
    g_rec_b         LIKE type_file.num10,                #單身筆數  
    g_rec_b2        LIKE type_file.num10,                #單身筆數  
    g_rec_b3        LIKE type_file.num10,
    g_row_count     LIKE type_file.num5,
    g_curs_index    LIKE type_file.num5,
    mi_no_ask       LIKE type_file.num5,
    g_jump          LIKE type_file.num5,
    l_ac            LIKE type_file.num10,                 #目前處理的ARRAY CNT  
    l_ac2           LIKE type_file.num10,                 #目前處理的ARRAY CNT  
    l_ac3           LIKE type_file.num10,
    g_chr           LIKE type_file.chr1,
    g_flag          LIKE type_file.chr1,
    g_msg           STRING

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_cnt           LIKE type_file.num10      
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  
DEFINE i               LIKE type_file.num5     #count/index for any purpose  
DEFINE p_row,p_col     LIKE type_file.num5    
DEFINE g_zz01          LIKE zz_file.zz01
DEFINE g_form          LIKE type_file.chr1
DEFINE g_argv1         LIKE type_file.chr10
 
FUNCTION sabat3241(p_argv1)
  DEFINE p_argv1  LIKE  type_file.chr10
  
  WHENEVER ERROR CALL cl_err_msg_log
    
   LET g_argv1 = p_argv1
   
   SELECT * INTO g_ibd.* FROM ibd_file WHERE 1=1
   
    LET p_row = 3 LET p_col = 14
    OPEN WINDOW sabat3241_w AT p_row,p_col WITH FORM "aba/42f/sabat3241"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    CALL sabat3241_ui_init()
    CALL t3241_temp()
    CALL sabat3241_menu()
    CLOSE WINDOW sabat3241_w                  #結束畫面

END FUNCTION 

FUNCTION t3241_temp()
    DROP TABLE sabat3241_temp
    SELECT boxb04,boxb05,boxb06,boxb07,boxb08,boxb09,boxb09 a
      FROM boxb_file WHERE 1=2 INTO TEMP sabat3241_temp
    IF SQLCA.sqlcode THEN
       CALL cl_err('sabat3241_temp',-261,1)
       EXIT PROGRAM
    END IF
END FUNCTION

FUNCTION sabat3241_ui_init()

  CALL cl_set_act_visible("undo_confirm,undo_post",FALSE) 

  CALL cl_set_comp_visible('box12,more,less,more_i,less_i',FALSE)         
  
  DISPLAY "<font size='26' color='RED'>出</font>"  TO  FORMONLY.trans_o
  
  DISPLAY "<font size='26' color='RED'>入</font>"  TO  FORMONLY.trans_i

END FUNCTION 
 
FUNCTION sabat3241_menu()
DEFINE l_slip  LIKE oga_file.oga01
 
   WHILE TRUE
      CALL sabat3241_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL sabat3241_q()
            END IF  
        #WHEN "undo_confirm"
        #   IF cl_chk_act_auth() THEN 
        #      CALL sabat3241_z()
        #   END IF 
         WHEN "transfer_post" #調撥扣帳
            IF cl_chk_act_auth() THEN 
               CALL sabat3241_post()
            END IF 
        #WHEN "undo_post"
        #   IF cl_chk_act_auth() THEN 
        #      CALL sabat3241_undo_post()
        #   END IF  
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION sabat3241_q()

   MESSAGE ""
   CALL sabat3241_cs()
   LET g_sql = "SELECT DISTINCT box01 FROM box_file ",
               " WHERE ",g_wc,
               "   AND box14 IN('aimt324') ",
               " ORDER BY box01 "
   PREPARE sabat3241_prep FROM g_sql
   DECLARE sabat3241_cs SCROLL CURSOR WITH HOLD FOR sabat3241_prep
   
   LET g_sql = "SELECT COUNT(DISTINCT box01) FROM box_file ",
               " WHERE ",g_wc,
               "   AND box14 IN('aimt324') ",
               " ORDER BY box01 "
   PREPARE sabat3241_prepcount FROM g_sql
   DECLARE sabat3241_count CURSOR FOR sabat3241_prepcount
   OPEN sabat3241_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE tm.* TO NULL
   ELSE
      OPEN sabat3241_count
      FETCH sabat3241_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL sabat3241_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION


FUNCTION sabat3241_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
  #CLEAR FORM 
      CALL cl_set_head_visible("","YES")
      INITIALIZE tm.* TO NULL
      CALL g_box.CLEAR()
      CALL g_imgb.CLEAR()
      DIALOG ATTRIBUTES(UNBUFFERED)
       
      CONSTRUCT BY NAME g_wc ON box01
                
         BEFORE CONSTRUCT 
             CALL cl_qbe_display_condition(lc_qbe_sn)
             
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION HELP
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION accept
            EXIT DIALOG
           
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION exit
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION close
            LET INT_FLAG = TRUE
            EXIT DIALOG
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(box01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_box04"
                  LET g_qryparam.where = " box14 = 'aimt324' " #box14配貨來源:aimt324
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO box01
                  NEXT FIELD box01
            END CASE
      END CONSTRUCT 
   END DIALOG 

   IF INT_FLAG THEN 
       LET INT_FLAG = FALSE
       RETURN 
   END IF 
   IF cl_null(g_wc) THEN LET g_wc = " 1=1 " END IF 
 
END FUNCTION

FUNCTION sabat3241_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1    #處理方式  
DEFINE l_slip          LIKE oay_file.oayslip  #

   CASE p_flag
       WHEN 'N' FETCH NEXT     sabat3241_cs INTO tm.box01
       WHEN 'P' FETCH PREVIOUS sabat3241_cs INTO tm.box01
       WHEN 'F' FETCH FIRST    sabat3241_cs INTO tm.box01
       WHEN 'L' FETCH LAST     sabat3241_cs INTO tm.box01
       WHEN '/'
           IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump

                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()

                 ON ACTION about         #MOD-4C0121
                    CALL cl_about()      #MOD-4C0121

                 ON ACTION help          #MOD-4C0121
                    CALL cl_show_help()  #MOD-4C0121

                 ON ACTION controlg      #MOD-4C0121
                    CALL cl_cmdask()     #MOD-4C0121

              END PROMPT

              IF INT_FLAG THEN
                 LET INT_FLAG = 0
                 EXIT CASE
              END IF
           END IF
           FETCH ABSOLUTE g_jump sabat3241_cs INTO tm.box01
           LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err('not found',SQLCA.sqlcode,0)
      INITIALIZE tm.* TO NULL   
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      DISPLAY g_curs_index TO idx
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
   CALL sabat3241_show()
END FUNCTION


FUNCTION sabat3241_show()
DEFINE  l_ima02   LIKE ima_file.ima02
DEFINE  l_ima021  LIKE ima_file.ima021  
   
   DISPLAY BY NAME tm.box01
             
   CALL sabat3241_b_fill(tm.box01)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION sabat3241_b_fill(p_box01)
DEFINE p_wc2      STRING
DEFINE p_box01    LIKE box_file.box01
DEFINE l_sets     LIKE box_file.box06
DEFINE s_sets     LIKE box_file.box06
DEFINE l_iba01    LIKE iba_file.iba01
DEFINE l_box09    LIKE box_file.box09
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_sum1     LIKE box_file.box06
DEFINE l_sum2     LIKE box_file.box06 
DEFINE l_tlfb01   LIKE tlfb_file.tlfb01
DEFINE l_sabat3241_temp    RECORD
             boxb04     LIKE boxb_file.boxb04,
             boxb05     LIKE boxb_file.boxb05,
             boxb06     LIKE boxb_file.boxb06,
             boxb07     LIKE boxb_file.boxb07,
             boxb08     LIKE boxb_file.boxb08,
             boxb09     LIKE boxb_file.boxb09,
             a          LIKE boxb_file.boxb09
                          END RECORD  
   LET g_sql = "SELECT DISTINCT box11,box12,box08,box02,box04,ima02,ima021,box06,'','' ",
               "  FROM box_file,ima_file ",
              #"  FROM box_file,ima_file,imm_file ",
               " WHERE box04 = ima01 ",
               "   AND box01 = '",p_box01,"' ",
               "   AND box14 IN('aimt324') ",
              #"   AND immcont = 'Y' ", #已確認
              #"   AND imm03 = 'N' ",   #未過帳
              #"   AND imm01 = box01 ",
               " ORDER BY box11,box12,box02 "
               
   PREPARE sabat3241_pb FROM g_sql
   DECLARE box_cs CURSOR FOR sabat3241_pb
 
   CALL g_box.clear()
   CALL g_sets.CLEAR()
   LET g_cnt = 1
 
   FOREACH box_cs INTO g_box[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       IF g_box[g_cnt].box11 = '2' OR   #2:工單成品類
          g_box[g_cnt].box11 = '3' THEN #3:外購成品類
          LET g_sql = "SELECT MIN(SUM(tlfb05*tlfb06) * -1 )", 
                      "  FROM tlfb_file ",
                      " WHERE tlfb11 = 'abat0341' ",
                      "   AND tlfb07 = '",p_box01,"'",
                      "   AND NOT(tlfb02 = '",g_ibd.ibd03,"'  ",
                      "       AND tlfb03 = '",g_ibd.ibd04,"') "
          IF g_box[g_cnt].box11 = '3' THEN
              LET g_sql = g_sql CLIPPED,
                      "   AND tlfb01 LIKE '%",g_box[g_cnt].box04,"%' "
          END IF
          LET g_sql = g_sql CLIPPED,
                  "   AND tlfb01 IN (SELECT boxb05 FROM boxb_file ",
                  "                   WHERE boxb01 = '",p_box01,"'",             #配貨單號 
                  "                     AND boxb02 = ",g_box[g_cnt].box02,")",   #配貨項次
                 #" GROUP BY tlfb01,tlfb02,tlfb03,tlfb04 " #DEV-CC0007 mark
                  " GROUP BY tlfb01 "                      #DEV-CC0007 add
          PREPARE t3241_pre_sets FROM g_sql
          DECLARE t3241_cs_sets CURSOR FOR t3241_pre_sets
          EXECUTE t3241_cs_sets INTO g_box[g_cnt].sets
          IF cl_null(g_box[g_cnt].sets) THEN
              LET g_box[g_cnt].sets = 0
          END IF
       END IF 

       #齐套数（入） 
       #3:外購成品類
       IF g_box[g_cnt].box11 = '2' OR   #2:工單成品類
          g_box[g_cnt].box11 = '3' THEN #3:外購成品類
          LET g_sql = "SELECT MIN(SUM(tlfb05*tlfb06)) ", 
                      "  FROM tlfb_file ",
                      " WHERE tlfb11 = 'abat0342' ",
                      "   AND tlfb07 = '",p_box01,"'",
                      "   AND NOT(tlfb02 = '",g_ibd.ibd03,"'  ",
                      "       AND tlfb03 = '",g_ibd.ibd04,"') "
          IF g_box[g_cnt].box11 = '3' THEN
              LET g_sql = g_sql CLIPPED,
                      "   AND tlfb01 LIKE '%",g_box[g_cnt].box04,"%' "
          END IF
          LET g_sql = g_sql CLIPPED,
                  "   AND tlfb01 IN (SELECT boxb05 FROM boxb_file ",
                  "                   WHERE boxb01 = '",p_box01,"'",             #配貨單號 
                  "                     AND boxb02 = ",g_box[g_cnt].box02,")",   #配貨項次
                 #" GROUP BY tlfb01,tlfb02,tlfb03,tlfb04 " #DEV-CC0007 mark
                  " GROUP BY tlfb01 "                      #DEV-CC0007 add
          PREPARE t3241_pre_sets_i FROM g_sql
          DECLARE t3241_cs_sets_i CURSOR FOR t3241_pre_sets_i
          EXECUTE t3241_cs_sets_i INTO g_box[g_cnt].sets_i
          IF cl_null(g_box[g_cnt].sets_i) THEN
              LET g_box[g_cnt].sets_i = 0
          END IF
       END IF 

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_box.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO idx2
   LET g_cnt = 0
   
END FUNCTION


FUNCTION sabat3241_d1_fill(p_box11,p_oba01,p_slip,p_seq,p_box04)  
DEFINE l_ibb      RECORD LIKE ibb_file.*
DEFINE p_slip     LIKE  box_file.box01
DEFINE p_seq      LIKE  box_file.box02
DEFINE p_oba01    LIKE  box_file.box12
DEFINE p_box11    LIKE  box_file.box11
DEFINE s_sets     LIKE  box_file.box06
DEFINE p_box04    LIKE  box_file.box04  
DEFINE l_m        LIKE  type_file.num5
DEFINE l_sql      STRING

   IF p_box11 = '2' OR   #'2':工單成品類
      p_box11 = '3' THEN #'3':外購成品類
      LET g_sql = "SELECT tlfb01,''   ,tlfb02,tlfb03,tlfb04,SUM(tlfb05*tlfb06) * -1 ", 
                  #         條碼,包號 ,倉庫  ,儲位  ,批號  ,異動數量
                  "  FROM tlfb_file ",
                  " WHERE tlfb11 = 'abat0341' ",
                  "   AND tlfb07 = '",p_slip,"' ",
                  "   AND NOT(tlfb02 = '",g_ibd.ibd03,"'  ",
                  "       AND tlfb03 = '",g_ibd.ibd04,"') "
      IF p_box11 = '3' THEN
          LET g_sql = g_sql CLIPPED,
                  "   AND tlfb01 LIKE '%",p_box04,"%' "
      END IF

      LET g_sql = g_sql CLIPPED,
                  "   AND tlfb01 IN (SELECT boxb05 FROM boxb_file ",
                  "                   WHERE boxb01 = '",p_slip,"'", #配貨單號 
                  "                     AND boxb02 = ",p_seq,")",   #配貨項次
                  " GROUP BY tlfb01,tlfb02,tlfb03,tlfb04 "

   END IF 
               
   PREPARE sabat3241_pb_d FROM g_sql
   DECLARE imgb_cs CURSOR FOR sabat3241_pb_d
 
   CALL g_imgb.clear()

   LET g_cnt = 1
   FOREACH imgb_cs INTO g_imgb[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF 
      
       IF p_box11 = '2' THEN 
           #包號
           SELECT ibb05 INTO g_imgb[g_cnt].ibb05
             FROM iba_file,ibb_file
            WHERE iba01 = ibb01
              AND ibb01= g_imgb[g_cnt].imgb01
              AND ibb03 IN (SELECT MAX(ibb03) 
                              FROM ibb_file 
                             WHERE ibb01= g_imgb[g_cnt].imgb01)
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_imgb.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO idx3
   LET g_cnt = 0

END FUNCTION

FUNCTION sabat3241_d2_fill(p_box11,p_oba01,p_slip,p_seq,p_box04)  
DEFINE l_ibb      RECORD LIKE ibb_file.*
DEFINE p_slip     LIKE  box_file.box01
DEFINE p_seq      LIKE  box_file.box02
DEFINE p_oba01    LIKE  box_file.box12
DEFINE p_box11    LIKE  box_file.box11
DEFINE s_sets     LIKE  box_file.box06
DEFINE p_box04    LIKE  box_file.box04  
DEFINE l_m        LIKE type_file.num5
DEFINE l_sql      STRING
  
   #'2':工單成品類
   IF p_box11 = '2' OR   #'2':工單成品類
      p_box11 = '3' THEN #'3':外購成品類
      LET g_sql = "SELECT tlfb01,''   ,tlfb02,tlfb03,tlfb04,SUM(tlfb05*tlfb06) ", 
                  #         條碼,包號 ,倉庫  ,儲位  ,批號  ,異動數量
                  "  FROM tlfb_file ",
                  " WHERE tlfb11 = 'abat0342' ",
                  "   AND tlfb07 = '",p_slip,"' ",
                  "   AND NOT(tlfb02 = '",g_ibd.ibd03,"'  ",
                  "       AND tlfb03 = '",g_ibd.ibd04,"') "
      IF p_box11 = '3' THEN
          LET g_sql = g_sql CLIPPED,
                  "   AND tlfb01 LIKE '%",p_box04,"%' "
      END IF
      LET g_sql = g_sql CLIPPED,
                  "   AND tlfb01 IN (SELECT boxb05 FROM boxb_file ",
                  "                   WHERE boxb01 = '",p_slip,"'", #配貨單號 
                  "                     AND boxb02 = ",p_seq,")",   #配貨項次
                  " GROUP BY tlfb01,tlfb02,tlfb03,tlfb04 "
   END IF 
               
   PREPARE sabat3241_pbi_d FROM g_sql
   DECLARE imgbi_cs CURSOR FOR sabat3241_pbi_d
 
   CALL g_imgb_i.clear()

   LET g_cnt = 1
   FOREACH imgbi_cs INTO g_imgb_i[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF p_box11 = '2' THEN 
           #包號
           SELECT ibb05 INTO g_imgb_i[g_cnt].ibb05_i
             FROM iba_file,ibb_file
            WHERE iba01 = ibb01
              AND ibb01= g_imgb_i[g_cnt].imgb01_i
              AND ibb03 IN (SELECT MAX(ibb03) 
                              FROM ibb_file 
                             WHERE ibb01= g_imgb_i[g_cnt].imgb01_i)
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_imgb_i.deleteElement(g_cnt)
   LET g_rec_b3=g_cnt-1
   DISPLAY g_rec_b3 TO idx4
   LET g_cnt = 0

END FUNCTION
  
FUNCTION sabat3241_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
   DEFINE   l_sql  STRING
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,close", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
    
      DISPLAY ARRAY g_box TO s_box.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY 
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF 
            
          BEFORE ROW 
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN
               #非安库可以具体到工单条码
               #IF g_box[l_ac].box08 = 'N' THEN 
                   CALL sabat3241_d1_fill(g_box[l_ac].box11,g_box[l_ac].box12,tm.box01,
                                    g_box[l_ac].box02,g_box[l_ac].box04)
                   CALL sabat3241_d2_fill(g_box[l_ac].box11,g_box[l_ac].box12,tm.box01,
                                    g_box[l_ac].box02,g_box[l_ac].box04)                 
              # ELSE 
              ##安库的话抓所有的配货单条码
              #    CALL sabat3241_d1_fill(g_box[l_ac].box11,g_box[l_ac].box12,tm.box01,'',
              #                     g_box[l_ac].box04)
              #    CALL sabat3241_d2_fill(g_box[l_ac].box11,g_box[l_ac].box12,tm.box01,'',
              #                     g_box[l_ac].box04)
              # END IF 
             END IF 
      END DISPLAY 
     
      
      DISPLAY ARRAY g_imgb TO s_imgb.* ATTRIBUTE(COUNT=g_rec_b2)
          BEFORE DISPLAY 
            IF l_ac2 > 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF 
            
          BEFORE ROW 
             LET l_ac2  = ARR_CURR()
             IF l_ac2  > 0 THEN
             
             END IF 
      END DISPLAY 
      
      DISPLAY ARRAY g_imgb_i TO s_imgb_i.* ATTRIBUTE(COUNT=g_rec_b3)
          BEFORE DISPLAY 
            IF l_ac3 > 0 THEN
               CALL fgl_set_arr_curr(l_ac3)
            END IF 
            
          BEFORE ROW 
             LET l_ac3  = ARR_CURR()
             IF l_ac3  > 0 THEN
             
             END IF 
      END DISPLAY 
      
      BEFORE DIALOG 
         IF l_ac > 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF 


     ON ACTION query
        LET g_action_choice="query"
        EXIT DIALOG

    #ON ACTION undo_confirm
    #   LET g_action_choice="undo_confirm"
    #   EXIT DIALOG

     ON ACTION transfer_post
        LET g_action_choice="transfer_post"
        EXIT DIALOG
        
    #ON ACTION undo_post
    #   LET g_action_choice="undo_post"
    #   EXIT DIALOG

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
         LET g_action_choice = 'locale'
         EXIT DIALOG 

      ON ACTION EXIT
         LET g_action_choice="exit"
         EXIT DIALOG 
         
      ON ACTION first
         CALL sabat3241_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1) 
           END IF
           ACCEPT DIALOG                


      ON ACTION previous
         CALL sabat3241_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1) 
           END IF
       	ACCEPT DIALOG                


      ON ACTION jump
         CALL sabat3241_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1) 
           END IF
	       ACCEPT DIALOG                 


      ON ACTION next
         CALL sabat3241_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	       ACCEPT DIALOG                 


      ON ACTION last
         CALL sabat3241_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
           END IF
	       ACCEPT DIALOG                  
         
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION controls                          
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION CANCEL
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel,close", TRUE)
END FUNCTION

FUNCTION sabat3241_z()
  
   IF g_rec_b = 0 THEN  RETURN END IF 
   CALL sabat3241_z_pre_chk()
   IF g_success = 'N' THEN RETURN END IF 
   LET g_cmd = "aimt324 '",tm.box01,"' 'query' ' ' '",g_argv1,"'"
   CALL cl_cmdrun_wait(g_cmd)
 
END FUNCTION 

FUNCTION sabat3241_z_pre_chk()
DEFINE s_quantity  LIKE  tlfb_file.tlfb05
DEFINE l_box01 LIKE  box_file.box01
DEFINE l_box02 LIKE  box_file.box02

   LET g_success = 'Y'
   LET g_sql = "SELECT box01,box02 ",
               "  FROM box_file ",
               " WHERE box01 = '",tm.box01,"' "
   PREPARE z_chk_prep FROM g_sql
   DECLARE z_chk_cs CURSOR FOR z_chk_prep
   FOREACH z_chk_cs INTO l_box01,l_box02
      IF SQLCA.SQLCODE THEN 
         CALL cl_err('',SQLCA.SQLCODE,0)
         LET g_success = 'N'
         RETURN 
      END IF 
      LET s_quantity = 0
      SELECT SUM(tlfb05*tlfb06) INTO s_quantity 
        FROM tlfb_file
       WHERE tlfb07 = l_box01
         AND tlfb08 = l_box02
      IF cl_null(s_quantity) THEN LET s_quantity = 0 END IF 
      IF s_quantity > 0 THEN 
         CALL cl_err(l_box01||'-'||l_box02,'aba041',0)
         LET g_success = 'N'
         RETURN 
      END IF 
   END FOREACH 

END FUNCTION 


FUNCTION sabat3241_post()

   IF g_rec_b = 0 THEN RETURN END IF 
   CALL sabat3241_post_pre_chk()
   IF g_success = 'N' THEN RETURN END IF 
   LET g_cmd = "aimt324 '",tm.box01,"' ' ' 'query' 'abat3241' "
   CALL cl_cmdrun_wait(g_cmd)

END FUNCTION 

FUNCTION sabat3241_post_pre_chk()
  DEFINE l_cnt   LIKE type_file.num5
  DEFINE l_des   STRING
  DEFINE l_imn10 LIKE imn_file.imn10
  DEFINE l_imn22 LIKE imn_file.imn22
  
  	LET g_success = 'Y'
  	FOR l_cnt = 1 TO g_rec_b
  	    SELECT imn10,imn22 INTO l_imn10,l_imn22 FROM imn_file
  	     WHERE imn01 = tm.box01
  	       AND imn02 = g_box[l_cnt].box02
  	    IF g_box[l_cnt].sets != l_imn10 THEN 
  	       LET g_success = 'N'
  	       LET l_des = "项次",g_box[l_cnt].box02," 调拨出数量 与 齐套出数量不匹配\n"
  	    END IF 
  	    IF g_box[l_cnt].sets_i != l_imn22 THEN 
  	       LET g_success = 'N'
  	       LET l_des = "项次",g_box[l_cnt].box02," 调拨入数量 与 齐套入数量不匹配\n"
  	    END IF  	    
  	    IF g_box[l_cnt].sets != g_box[l_cnt].sets_i THEN 
  	       LET g_success = 'N'
  	       LET l_des = "项次",g_box[l_cnt].box02," 齐套出入数量不匹配\n"
  	    END IF 
  	    IF g_success = 'N' THEN 
  	       CALL cl_err(l_des,'!',1)
  	       RETURN 
  	    END IF 
  	END FOR 
   

END FUNCTION 

FUNCTION sabat3241_undo_post()

   IF g_rec_b = 0 THEN RETURN END IF 
   CALL sabat3241_undo_post_pre_chk()
   IF g_success = 'N' THEN RETURN END IF 
   LET g_cmd = "aimt324 '",tm.box01,"' ' ' 'query' "
   CALL cl_cmdrun_wait(g_cmd)

END FUNCTION 

FUNCTION sabat3241_undo_post_pre_chk()
 DEFINE l_imm03 LIKE imm_file.imm03
   
   LET g_success = 'Y'
   SELECT imm03 INTO l_imm03 FROM imm_file
    WHERE imm01 = tm.box01
   
   IF l_imm03 = 'N' THEN 
      CALL cl_err(tm.box01,'aba-042',0)
      LET g_success = 'N'
      RETURN 
   END IF 

END FUNCTION 
#DEV-CB0021
#DEV-D30025--add

