# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: atmq500.4gl
# Descriptions...: 預測實際查詢
# Date & Author..: No.FUN-740017 07/04/04 By rainy
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-780002 07/08/01 By kim 加入可以切換至單身的功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AC0096 10/12/08 By houlia 查詢時程序當初，數組錯誤，調整
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
DEFINE g_odg1 RECORD
               odg01    LIKE odg_file.odg01,
               odg02    LIKE odg_file.odg02
              END RECORD
 
DEFINE g_odg   DYNAMIC ARRAY OF RECORD
                  odh03     LIKE odh_file.odh03,    
                  ima02     LIKE ima_file.ima02,
                  ima021    LIKE ima_file.ima021
               END RECORD
DEFINE g_odg_t RECORD
                  odh03     LIKE odh_file.odh03,    
                  ima02     LIKE ima_file.ima02,
                  ima021    LIKE ima_file.ima021
               END RECORD
 
DEFINE g_odh   DYNAMIC ARRAY OF RECORD
                  odh04     LIKE odh_file.odh04,
                  odh05     LIKE odh_file.odh05,
                  so_qty    LIKE oeb_file.oeb12,
                  del_qty   LIKE ogb_file.ogb12,
                  odh06     LIKE odh_file.odh06,
                  so_amt    LIKE oeb_file.oeb14t,    
                  del_amt   LIKE ogb_file.ogb14t
               END RECORD
DEFINE g_wc,g_wc2    STRING
DEFINE g_sql   STRING,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac1          LIKE type_file.num5,         
       l_ac1_t        LIKE type_file.num5,         
       l_ac           LIKE type_file.num5          
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE mi_need_cons   LIKE type_file.num5
DEFINE g_row_count    LIKE type_file.num10       
DEFINE g_curs_index   LIKE type_file.num10         
DEFINE g_jump         LIKE type_file.num10         
DEFINE mi_no_ask      LIKE type_file.num5          
DEFINE g_msg          STRING
DEFINE g_draw_base,g_draw_maxy      LIKE type_file.num10   
DEFINE g_draw_day          LIKE type_file.dat               #畫統計圖用的日期
DEFINE g_draw_x,g_draw_y,g_draw_dx,g_draw_dy,
       g_draw_width,g_draw_multiple LIKE type_file.num10   
DEFINE g_draw_start_y               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5             #No.FUN-680130 SMALLINT #縱刻度數目 =>10
DEFINE g_renew   LIKE   type_file.num5
DEFINE g_page    LIKE   type_file.num5
DEFINE g_bpsw    STRING  #CHI-780002
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
   OPEN WINDOW q500_w AT p_row,p_col WITH FORM "atm/42f/atmq500"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   LET g_bpsw='bp' #CHI-780002
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   LET g_renew = 1
   LET g_page = 0
   CALL q500()
 
   CLOSE WINDOW q500_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
FUNCTION q500_cs()
   INITIALIZE g_odg1.* TO NULL    #No.FUN-750051
   CONSTRUCT g_wc2 ON odg01,odg02
                 FROM odg01,odg02
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(odg01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_odb"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO odg01
                    NEXT FIELD odg01
 
               WHEN INFIELD(odg02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqb"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO odg02
                    NEXT FIELD odg02
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('odguser', 'odggrup') #FUN-980030
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   LET g_sql = "SELECT  DISTINCT odg01,odg02 FROM odg_file ",
              " WHERE ",g_wc2
 
   PREPARE q500_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE q500_cs SCROLL CURSOR WITH HOLD FOR q500_prepare
 
   LET g_sql = " SELECT COUNT(DISTINCT odg01||odg02) FROM odg_file WHERE ",g_wc2 CLIPPED
   PREPARE q500_precount FROM g_sql
   DECLARE q500_count CURSOR FOR q500_precount
END FUNCTION
 
 
FUNCTION q500()
   CLEAR FORM
   WHILE TRUE
      IF g_bpsw='bp' THEN  #CHI-780002
         CALL q500_bp()
      ELSE
         CALL q500_bp1() #CHI-780002
      END IF
      CASE g_action_choice
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL q500_q()
           END IF
        WHEN "exit"
           EXIT WHILE
        WHEN "page01"
           CALL q500_draw("page01")
        WHEN "page02" 
           CALL q500_draw("page02")
        #CHI-780002................begin
        WHEN "bp" 
           CALL q500_bp()
        WHEN "bp1" 
           CALL q500_bp1()
        #CHI-780002................end
      END CASE
   END WHILE
   CLOSE q500_cs
END FUNCTION
 
FUNCTION q500_bp()
  LET g_action_choice = " "
  CALL cl_set_act_visible("accept,cancel", FALSE)
 
  DISPLAY ARRAY g_odg TO s_odg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #顯示並進行選擇
     BEFORE ROW
         IF g_renew = 1 THEN
           LET l_ac1 = ARR_CURR()
           IF l_ac1 = 0 THEN
              LET l_ac1 = 1
           END IF
         END IF
         CALL fgl_set_arr_curr(l_ac1)
         CALL cl_show_fld_cont()
         LET g_renew = 1
         LET l_ac1_t = l_ac1
         LET g_odg_t.* = g_odg[l_ac1].*
 
         IF g_rec_b > 0 THEN
           CALL q500_b_fill_1()  
           CALL q500_bp2_1()
          CASE g_page
            WHEN 1
              CALL q500_draw("page01")
            WHEN 2
              CALL q500_draw("page02")
          END CASE
         END IF
 
     ON ACTION query
        LET g_action_choice="query"
        EXIT DISPLAY
    
 
     ON ACTION first
        CALL q500_fetch('F')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
        END IF
 
     ON ACTION previous
        CALL q500_fetch('P')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
        END IF
 
     ON ACTION jump
        CALL q500_fetch('/')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
        END IF
 
     ON ACTION next
        CALL q500_fetch('N')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
        END IF
 
     ON ACTION last
        CALL q500_fetch('L')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
        END IF
 
     
     ON ACTION help
        CALL cl_show_help()
        EXIT DISPLAY
 
     ON ACTION controlg
        CALL cl_cmdask()
 
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
 
     ON ACTION exit
        LET g_action_choice="exit"
        EXIT DISPLAY
 
     ON ACTION cancel
        LET g_action_choice="exit"
        EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
     ON ACTION page01
         LET g_page = 1
         LET g_renew = 0
         LET g_action_choice="page01"
         EXIT DISPLAY
 
     ON ACTION page02
         LET g_page = 2
         LET g_renew = 0
         LET g_action_choice="page02"
         EXIT DISPLAY
 
     #CHI-780002.................begin
     ON ACTION bp1
         LET g_bpsw='bp1'
         LET g_action_choice='bp1'
         EXIT DISPLAY
     #CHI-780002.................end
 
     ON ACTION about
        CALL cl_about()
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#CHI-780002.................begin
FUNCTION q500_bp1()
  LET g_action_choice = " "
  CALL cl_set_act_visible("accept,cancel", FALSE)
 
  DISPLAY ARRAY g_odh TO s_odh.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED) #顯示並進行選擇
     BEFORE ROW
         IF g_renew = 1 THEN
           LET l_ac1 = ARR_CURR()
           IF l_ac1 = 0 THEN
              LET l_ac1 = 1
           END IF
         END IF
         CALL fgl_set_arr_curr(l_ac1)
         CALL cl_show_fld_cont()
         LET g_renew = 1
         LET l_ac1_t = l_ac1
         LET g_odg_t.* = g_odg[l_ac1].*
 
        #CHI-780002.................begin
        #IF g_rec_b > 0 THEN
        #  CALL q500_b_fill_1()  
        #  CALL q500_bp2_1()
        # CASE g_page
        #   WHEN 1
        #     CALL q500_draw("page01")
        #   WHEN 2
        #     CALL q500_draw("page02")
        # END CASE
        #END IF
        #CHI-780002.................end
 
     ON ACTION query
        LET g_action_choice="query"
        EXIT DISPLAY
    
 
     ON ACTION first
        CALL q500_fetch('F')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
        END IF
 
     ON ACTION previous
        CALL q500_fetch('P')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
        END IF
 
     ON ACTION jump
        CALL q500_fetch('/')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
        END IF
 
     ON ACTION next
        CALL q500_fetch('N')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
        END IF
 
     ON ACTION last
        CALL q500_fetch('L')
        CALL cl_navigator_setting(g_curs_index, g_row_count)
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
        END IF
 
     
     ON ACTION help
        CALL cl_show_help()
        EXIT DISPLAY
 
     ON ACTION controlg
        CALL cl_cmdask()
 
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
 
     ON ACTION exit
        LET g_action_choice="exit"
        EXIT DISPLAY
 
     ON ACTION cancel
        LET g_action_choice="exit"
        EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
     ON ACTION page01
         LET g_page = 1
         LET g_renew = 0
         LET g_action_choice="page01"
        #EXIT DISPLAY #CHI-780002
 
     ON ACTION page02
         LET g_page = 2
         LET g_renew = 0
         LET g_action_choice="page02"
        #EXIT DISPLAY #CHI-780002
 
     #CHI-780002.................begin
     ON ACTION bp
         LET g_bpsw='bp'
         LET g_action_choice='bp'
         EXIT DISPLAY
     #CHI-780002.................end
 
     ON ACTION about
        CALL cl_about()
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#CHI-780002.................end
 
FUNCTION q500_q()
   CLEAR FORM
   LET g_renew = 1
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_odg1.* TO NULL             
   CALL g_odg.clear()
   CALL g_odh.clear()
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cn
 
   CALL q500_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      INITIALIZE g_odg1.* TO NULL
      RETURN
   END IF
   MESSAGE " SEARCHING ! " 
   OPEN q500_count
   FETCH q500_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cn
 
   OPEN q500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_odg1.odg01,SQLCA.sqlcode,0)
      INITIALIZE g_odg1.* TO NULL
   ELSE
      CALL q500_fetch('F')                 # 讀出TEMP第一筆并顯示
   END IF
   MESSAGE ""
 
END FUNCTION
 
 
 
FUNCTION q500_fetch(p_fltsk)
   DEFINE
      p_fltsk         LIKE type_file.chr1,             
      l_abso          LIKE type_file.num10   
          
   LET g_renew = 1
 
   CASE p_fltsk
      WHEN 'N' FETCH NEXT     q500_cs INTO g_odg1.odg01,g_odg1.odg02
      WHEN 'P' FETCH PREVIOUS q500_cs INTO g_odg1.odg01,g_odg1.odg02
      WHEN 'F' FETCH FIRST    q500_cs INTO g_odg1.odg01,g_odg1.odg02
      WHEN 'L' FETCH LAST     q500_cs INTO g_odg1.odg01,g_odg1.odg02
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
         FETCH ABSOLUTE g_jump q500_cs INTO g_odg1.odg01,g_odg1.odg02
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_odg1.odg01,SQLCA.sqlcode,0)
      INITIALIZE g_odg1.* TO NULL      
      RETURN
   ELSE
      CASE p_fltsk
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
 
   #SELECT odg01,odg02 INTO g_odg1.odg01,g_odg1.odg02 FROM odg_file       # 重讀DB,因TEMP有不被更新特性
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err3("sel","odg_file",g_odg1.odg01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
   #   INITIALIZE g_odg1.* TO NULL           
   #ELSE                                   
      CALL q500_show()                      # 重新顯示
   #END IF
END FUNCTION
 
 
FUNCTION q500_show()
  DEFINE l_odb02  LIKE odb_file.odb02
  DEFINE l_tqb02  LIKE tqb_file.tqb02
   
   #LET g_odg1_t.* = g_odg1.*
   DISPLAY BY NAME
      g_odg1.odg01,g_odg1.odg02
 
   SELECT odb02 INTO l_odb02 FROM odb_file
    WHERE odb01 = g_odg1.odg01
   SELECT tqb02 INTO l_tqb02 FROM tqb_file
    WHERE tqb01 = g_odg1.odg02
 
   DISPLAY l_odb02 TO FORMONLY.odb02
   DISPLAY l_tqb02 TO FORMONLY.tqb02
 
   CALL q500_b1_fill()
  
END FUNCTION
 
 
FUNCTION q500_b1_fill()
 
   LET g_sql = "SELECT odg03,'','' ",
               "  FROM odg_file ",
               " WHERE odg01 ='",g_odg1.odg01 CLIPPED,"'",
               "   AND odg02 ='",g_odg1.odg02 CLIPPED,"'",
               " ORDER BY odg03"
 
   PREPARE q500_pb1 FROM g_sql
   DECLARE odg_curs CURSOR FOR q500_pb1
  
   CALL g_odg.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH odg_curs INTO g_odg[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
         EXIT FOREACH
      END IF
 
      SELECT ima02,ima021 INTO g_odg[g_cnt].ima02,g_odg[g_cnt].ima021
        FROM ima_file
       WHERE ima01 = g_odg[g_cnt].odh03
 
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL  g_odg.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
#TQC-AC0096 --add
   IF g_renew = 1 THEN
     LET l_ac1 = ARR_CURR()
     IF l_ac1 = 0 THEN
        LET l_ac1 = 1
     END IF
   END IF
   LET l_ac1_t = l_ac1
#TQC-A0096 --end
   LET g_odg_t.* = g_odg[l_ac1].*
 
   CALL q500_b_fill_1()  
   CALL q500_bp2_1()
   CASE g_page
      WHEN 1
        CALL q500_draw("page01")
      WHEN 2
        CALL q500_draw("page02")
   END CASE
END FUNCTION
 
 
FUNCTION q500_b_fill_1()
   DEFINE l_day1 LIKE odh_file.odh04,
          l_day2 LIKE odh_file.odh04
   DEFINE l_odb  RECORD LIKE odb_file.*
   DEFINE l_i    LIKE type_file.num5
 
 
   LET g_sql = " SELECT odh04,odh05,0,0,odh06,0,0 ",
        " FROM odh_file ",
        " WHERE odh01 ='",g_odg1.odg01,"'",  
        "   AND odh02 ='",g_odg1.odg02,"'",
        "   AND odh03 ='", g_odg_t.odh03 ,"'",
        " ORDER BY odh04"
 
   PREPARE q500_pb FROM g_sql
   DECLARE odh_curs CURSOR FOR q500_pb
  
   CALL g_odh.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH odh_curs INTO g_odh[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
 
   END FOREACH
 
   CALL g_odh.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b1 TO FORMONLY.cn3
   LET g_cnt = 0
 
 
   SELECT * INTO l_odb.* FROM odb_file 
                        WHERE odb01=g_odg1.odg01
   IF NOT cl_null(l_odb.odb04) THEN 
      FOR l_i = 1 TO g_rec_b1
        LET l_day1 = g_odh[l_i].odh04
        IF l_i < g_rec_b1 THEN
          LET l_day2 = g_odh[l_i+1].odh04
        ELSE
          CASE l_odb.odb09
             WHEN '1' #季
                LET l_day2 = l_day1 + 3 UNITS MONTH
             WHEN '2' #月
                LET l_day2 = l_day1 + 1 UNITS MONTH
             WHEN '3' #旬
                LET l_day2 = l_day1 + 10 UNITS DAY
             WHEN '4' #週
                LET l_day2 = l_day1 + 7 UNITS DAY
             WHEN '5' #天
                LET l_day2 = l_day1 + 1 UNITS DAY
          END CASE
        END IF
        #訂單數量/金額
         SELECT SUM(oeb12) INTO g_odh[l_i].so_qty
           FROM oea_file,oeb_file,occ_file
          WHERE oea01=oeb01
            AND oeb04 NOT LIKE 'MISC%'
            AND occ01=oea03 
            AND occ1005 = g_odg1.odg02
            AND oeb04   = g_odg_t.odh03
            AND oea02 >=l_day1
            AND oea02 < l_day2
            AND oeaconf='Y' 
         IF cl_null(g_odh[l_i].so_qty) THEN LET g_odh[l_i].so_qty = 0 END IF
 
         SELECT SUM(oeb12*oeb13) INTO g_odh[l_i].so_amt
           FROM oea_file,oeb_file,occ_file
          WHERE oea01=oeb01
            AND oeb04 NOT LIKE 'MISC%'
            AND occ01=oea03 
            AND occ1005 = g_odg1.odg02
            AND oeb04   = g_odg_t.odh03
            AND oea02 >=l_day1
            AND oea02 < l_day2
            AND oeaconf='Y' 
         IF cl_null(g_odh[l_i].so_amt) THEN LET g_odh[l_i].so_amt = 0 END IF
          
        #出單數量/金額
         SELECT SUM(ogb12*ogb05_fac) INTO g_odh[l_i].del_qty
           FROM oga_file,ogb_file,occ_file
          WHERE oga01=ogb01
            AND ogb04 NOT LIKE 'MISC%'
            AND occ01=oga03 
            AND occ1005 = g_odg1.odg02
            AND ogb04   = g_odg_t.odh03
            AND oga02 >=l_day1
            AND oga02 < l_day2
            AND ogaconf='Y' 
            AND ogapost='Y'
            AND oga09 IN ('2','3','4','6','8') 
         IF cl_null(g_odh[l_i].del_qty) THEN LET g_odh[l_i].del_qty = 0 END IF
 
         SELECT SUM(ogb12*ogb05_fac*ogb13) INTO g_odh[l_i].del_amt
           FROM oga_file,ogb_file,occ_file
          WHERE oga01=ogb01
            AND ogb04 NOT LIKE 'MISC%'
            AND occ01=oga03 
            AND occ1005 = g_odg1.odg02
            AND ogb04   = g_odg_t.odh03
            AND oga02 >=l_day1
            AND oga02 < l_day2
            AND ogaconf='Y' 
            AND ogapost='Y'
            AND oga09 IN ('2','3','4','6','8') 
         IF cl_null(g_odh[l_i].del_amt) THEN LET g_odh[l_i].del_amt = 0 END IF
      END FOR
   END IF
END FUNCTION
 
FUNCTION q500_bp2_1()
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_odh TO s_odh.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION about
         CALL cl_about()
      ON ACTION help    
         CALL cl_show_help()
      ON ACTION controlg 
         CALL cl_cmdask()
   END DISPLAY
END FUNCTION
 
 
 
#取數量最大值的碼數-1
#若最大值為10萬,則回傳1萬;
#若最大值為 8888 則回傳 880
FUNCTION q500_getbase(p_action)
DEFINE l_sql,l_str        STRING
DEFINE p_action           STRING
DEFINE l_feld             LIKE type_file.chr5
DEFINE l_i,l_j,l_base     LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_odh05,l_rest,l_act     LIKE odh_file.odh06
 
   IF g_odh.getlength()=0 THEN
      RETURN 0
   END IF
   CASE p_action
      WHEN "page01"      
         LET l_feld="odh05"
      WHEN "page02"
         LET l_feld="odh06"
   END CASE
   LET l_sql =
       "SELECT MAX(",l_feld,")",
       " FROM odh_file",
       " WHERE odh01 ='",g_odg1.odg01,"'",
       "   AND odh02 ='",g_odg1.odg02,"'",
       "   AND odh03 ='",g_odg_t.odh03,"'",
       "   AND ",g_wc2 CLIPPED
   PREPARE q500_getbase_p FROM l_sql
   DECLARE q500_getbase_c CURSOR FOR q500_getbase_p
   OPEN q500_getbase_c
   FETCH q500_getbase_c INTO l_odh05
   IF SQLCA.sqlcode OR cl_null(l_odh05) THEN
      LET l_odh05=0
   END IF
   
 
   CASE p_action
      WHEN "page01"      
         LET l_act = 0
         FOR l_i = 1 TO g_rec_b1
            IF g_odh[l_i].so_qty > l_act THEN
              LET l_act = g_odh[l_i].so_qty
            END IF
         END FOR
      WHEN "page02"
         LET l_act = 0
         FOR l_i = 1 TO g_rec_b1
            IF g_odh[l_i].so_amt > l_act THEN
              LET l_act = g_odh[l_i].so_amt
            END IF
         END FOR
   END CASE
   
   LET l_rest=l_act
   
   IF l_odh05>l_act THEN
      LET l_rest=l_odh05
   END IF
   IF l_rest<=0 THEN
      RETURN 0
   END IF
   LET l_i=l_rest
   LET l_str=l_i
   LET l_str=l_str.trim()
   LET l_j=l_str.getlength()-2
   IF l_j<0 THEN
      LET l_j=1
   END IF
   LET l_base=1
   FOR l_i=1 TO l_j
      LET l_base=l_base*10
   END FOR
   LET l_i=l_rest/l_base
   LET l_i=l_i*l_base/g_i
   IF l_i<1 THEN
      LET l_i=1
   END IF
   RETURN l_i
END FUNCTION
 
FUNCTION q500_draw_axis(p_action) #座標
DEFINE p_action        STRING
DEFINE id,l_h          LIKE type_file.num10   #No.FUN-680130INTEGER
DEFINE l_i             LIKE type_file.num5    #No.FUN-680130SMALLINT
DEFINE l_msg           STRING
DEFINE l_draw_multiple LIKE type_file.num10     #縱刻度一個刻度的寬度  #No.FUN-680130 INTEGER
DEFINE l_dist          LIKE type_file.num10,    #每個圖例說明的間距    #No.FUN-680130 INTEGER
       l_draw_x        LIKE type_file.num10,    #每個圖例說明的x軸位置 #No.FUN-680130 INTEGER
       l_draw_y        LIKE type_file.num10,    #每個圖例說明的y軸位置 #No.FUN-680130 INTEGER
       l_base          LIKE type_file.num10                            #No.FUN-680130 INTEGER
       
  CALL DrawFillColor("black")
  LET id=DrawRectangle(g_draw_start_y-5,60,5,940) #(橫軸)
  LET id=DrawRectangle(g_draw_start_y-5,60,850,2)  #(縱軸)
  LET l_draw_multiple=35*2.3
  LET l_h=(g_draw_start_y-5)+l_draw_multiple
  FOR l_i=1 TO g_i #(縱軸刻度)
    CALL DrawFillColor("black")
    LET id=DrawRectangle(l_h,60,8,6)
    CALL DrawFillColor("black")
    LET id=DrawText(l_h-30,30,l_i*g_draw_base)
    LET l_h=l_h+l_draw_multiple
  END FOR
 
  LET g_draw_maxy=l_h-(g_draw_start_y-5)-g_draw_y #當比例為1:1的時候,長條圖在最高刻度(g_i)的長度
  
  CALL DrawFillColor("black")
  LET id=DrawText((g_draw_start_y-5)/4-10,970,"(DATE)") #日期
  CALL DrawFillColor("black")
  IF p_action = "page01" THEN
    LET id=DrawText(940,35,"(QTY)") #數量
  ELSE
    LET id=DrawText(940,35,"(AMT)") #金額
  END IF
  
  #圖例
  #模擬
  LET l_dist=60
  LET l_draw_x=(g_draw_start_y-5)/4
  LET l_draw_y=g_draw_y
  CALL DrawFillColor("blue")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  IF p_action = "page01" THEN
     CALL cl_getmsg('atm-505',g_lang) RETURNING l_msg
  ELSE
     CALL cl_getmsg('atm-507',g_lang) RETURNING l_msg
  END IF
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-20,l_draw_y,l_msg)
 
  #實際
  LET l_draw_y=l_draw_y+l_dist
  CALL DrawFillColor("red")
  LET id=DrawRectangle(l_draw_x,l_draw_y,20,20)
  
  LET l_draw_y=l_draw_y+l_dist
  IF p_action = "page01" THEN
    CALL cl_getmsg('atm-506',g_lang) RETURNING l_msg
  ELSE
    CALL cl_getmsg('atm-508',g_lang) RETURNING l_msg
  END IF
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(l_draw_x-20,l_draw_y,l_msg)
END FUNCTION
 
FUNCTION q500_draw(p_action)
  DEFINE p_action STRING
  DEFINE id      LIKE type_file.num10   #No.FUN-680130 INTEGER
  DEFINE l_str   STRING
  DEFINE l_flag  LIKE type_file.num5    #No.FUN-680130 SMALLINT
  DEFINE l_i     LIKE type_file.num5
  DEFINE l_odb04 LIKE odb_file.odb04 #期數
  DEFINE day_y,day_oy  LIKE type_file.num10
  DEFINE l_x,l_y,l_dx,l_dy,l_r LIKE type_file.num10
  DEFINE l_line_width  LIKE type_file.num5
 
  LET g_i=10 #縱刻度數目
  CASE p_action
     WHEN "page01"
        CALL drawselect("c01")
        CALL drawClear()
        LET g_draw_base=q500_getbase("page01") #縱軸刻度基數;刻度比例
     WHEN "page02"
        CALL drawselect("c02")
        CALL drawClear()
        LET g_draw_base=q500_getbase("page02") #縱軸刻度基數;刻度比例
  END CASE
 
  IF g_draw_base=0 THEN #無單身資料
     RETURN
  END IF
  
  SELECT odb04 INTO l_odb04 FROM odb_file 
                           WHERE odb01=g_odg1.odg01
  LET g_draw_x=0   #起始x軸位置
  LET g_draw_y=65  #起始y軸位置
  LET g_draw_dx=0  #起始dx軸位置
  LET g_draw_dy=10 #起始dy軸位置
  CASE l_odb04  
     WHEN "5"  #日
        LET g_draw_width=15 #每條長條圖寬度
        LET l_line_width = 12
       OTHERWISE
        LET g_draw_width=(850-15)/(g_odh.getlength()+1)-60 #每條長條圖寬度
        IF g_draw_width<35 THEN	
           LET g_draw_width=35
        END IF	
        LET l_line_width = 20
  END CASE
 
  LET g_draw_multiple=1 #時間的放大倍數(在長條圖上的刻度比例)
  LET g_draw_start_y=120      #起始y軸位置
  CALL q500_draw_axis(p_action)
 
  FOR l_i=1 TO g_odh.getlength()
    LET g_draw_day=g_odh[l_i].odh04
    CALL DrawFillColor("black")
    LET day_y=g_draw_y+g_draw_width
    IF l_odb04='5' THEN	  
       LET id=DrawText(60,day_y,DAY(g_draw_day)) #日期
    ELSE  
       LET id=DrawText(60,day_y,g_draw_day) #日期
    END IF
    LET g_draw_x=g_draw_start_y #起始x軸位置
    LET g_draw_dx=0
    
    #IF l_odb04<>"5" THEN #日週期太密集,圓點會太擠,所以不畫
    #IF g_odh.getlength()<=8 THEN
       #模擬
       CALL DrawFillColor("blue")
       CASE p_action
          WHEN "page01"
             LET l_x  = g_odh[l_i].odh05*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))-3      
             LET l_str=g_odh[l_i].odh05
          WHEN "page02"
             LET l_x  = g_odh[l_i].odh06*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))-3      
             LET l_str=g_odh[l_i].odh06
       END CASE
       
       LET l_y  = day_y-8
       LET l_r = 25
       LET id=DrawRectangle(g_draw_start_y,l_y,l_x,l_line_width)
       LET l_str=l_str.trim()
       CALL drawSetComment(id,l_str)
       
       #實際
       CALL DrawFillColor("red")
       CASE p_action
          WHEN "page01"
             LET l_x  = g_odh[l_i].so_qty*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))-3      
             LET l_str=g_odh[l_i].so_qty
          WHEN "page02"
             #LET l_x  = g_draw_start_y-5+g_odh[l_i].so_amt*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))+12      
             LET l_x  = g_odh[l_i].so_amt*g_draw_multiple*(g_draw_maxy/(g_i*g_draw_base))-3      
             LET l_str=g_odh[l_i].so_amt
       END CASE
       
       LET l_y  = day_y-8
       LET l_r = 25
       #LET id=Drawcircle(l_x,l_y,l_r)
       LET id=DrawRectangle(g_draw_start_y,l_y+l_line_width,l_x,l_line_width)
       LET l_str=l_str.trim()
       CALL drawSetComment(id,l_str)
    #END IF
 
    LET g_draw_x=g_draw_start_y #起始x軸位置
    LET g_draw_dx=0
    LET g_draw_y=g_draw_y+g_draw_width
 
    LET g_draw_y=g_draw_y+g_draw_width
    LET day_oy=day_y
  END FOR
END FUNCTION
 
#FUN-740017
