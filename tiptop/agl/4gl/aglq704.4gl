# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aglq704.4gl
# Descriptions...: 遞延收入各期金額查詢作業
# Date & Author..: #FUN-AB0105 11/01/14 By vealxu 
# Modify.........: No:FUN-B60079 11/06/21 by belle 單頭增加QBE欄位(oct01),單身增加oct01,oct02,各期餘額加入SQL條件
# Modify.........: No:TQC-B80032 11/08/08 by belle 修改傳遞至aglq700的參數

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE 
    tm    RECORD
          oct00     LIKE oct_file.oct00,
          oct09     LIKE oct_file.oct09,
          oct10     LIKE oct_file.oct10,
          oct11     LIKE oct_file.oct11,
          oct23     LIKE oct_file.oct23,
          oct24     LIKE oct_file.oct24,
          oct01     LIKE oct_file.oct01,       #FUN-B60079
          wc        LIKE type_file.chr1000
          END RECORD
DEFINE
    g_oct DYNAMIC ARRAY OF RECORD
          oct00_2   LIKE oct_file.oct00,
          oct09     LIKE oct_file.oct09,
          oct10     LIKE oct_file.oct10,
          oct01     LIKE oct_file.oct01,       #FUN-B60079
          oct02     LIKE oct_file.oct02,       #FUN-B60079
          oct11     LIKE oct_file.oct11,
          oct23     LIKE oct_file.oct23,
          oct24     LIKE oct_file.oct24,
          oct16     LIKE oct_file.oct16,
          sum5      LIKE type_file.num20_6,
          oct12     LIKE oct_file.oct12,
          sum1      LIKE type_file.num20_6,
          sum2      LIKE type_file.num20_6,
          sum3      LIKE type_file.num20_6,
          sum4      LIKE type_file.num20_6
        END RECORD
DEFINE   g_rec_b  LIKE type_file.num5  	  #單身筆數
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   l_ac           LIKE type_file.num5
DEFINE   g_i            LIKE type_file.num5
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   g_no_ask      LIKE type_file.num5 
DEFINE   g_str          STRING
DEFINE   g_cmd          LIKE type_file.chr1000

MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                         #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW q704_w WITH FORM "agl/42f/aglq704"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL q704_menu()
   CLOSE WINDOW q704_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION q704_cs()
   DEFINE   l_cnt LIKE type_file.num5
   DEFINE   l_sql LIKE type_file.chr1000
   DEFINE   l_buf STRING

   CLEAR FORM #清除畫面
   CALL g_oct.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL		 # Default condition
   CALL cl_set_head_visible("","YES")

   CONSTRUCT BY NAME tm.wc ON
            #oct00,oct09,oct10,oct11,oct23,oct24           #FUN-B60079 mark
             oct00,oct09,oct10,oct11,oct23,oct24,oct01     #FUN-B60079
     
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oct11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oct11"
               LET g_qryparam.state= "c"
               LET g_qryparam.default1 = tm.oct11
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oct11
               NEXT FIELD oct11
            OTHERWISE
               EXIT CASE
         END CASE

      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION qbe_save
         CALL cl_qbe_save()

      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
 
END FUNCTION

FUNCTION q704_menu()

   WHILE TRUE
      CALL q704_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q704_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oct),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION q704_q()

    CALL q704_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q704_b_fill()
END FUNCTION

FUNCTION q704_b_fill()              #BODY FILL UP
   DEFINE l_sql           STRING
   DEFINE l_sum1,l_sum2   LIKE type_file.num20_6
   DEFINE l_oct12_p       LIKE oct_file.oct12
   DEFINE l_a             LIKE oct_file.oct12
   DEFINE l_a_p           LIKE oct_file.oct12
   DEFINE l_b             LIKE oct_file.oct12
   DEFINE l_c             LIKE oct_file.oct12
   DEFINE l_d             LIKE oct_file.oct12
   DEFINE l_yy            LIKE type_file.num5
   DEFINE l_mm            LIKE type_file.num5

  #LET l_sql=" SELECT DISTINCT oct00,oct09,oct10,oct11,",                #FUN-B60079
   LET l_sql=" SELECT DISTINCT oct00,oct09,oct10,oct01,oct02,oct11,",    #FUN-B60079
             "                 oct23,oct24,oct16",
             "   FROM oct_file",
             "  WHERE (oct16='1' OR oct16='3')",
             "    AND ",tm.wc,
             " GROUP BY oct00,oct09,oct10,oct01,oct02,oct11,oct16,oct23,oct24",    #FUN-B60079
             " ORDER BY oct00,oct09,oct10,oct01,oct02,oct16,oct11,oct23,oct24 "    #FUN-B60079
            #" GROUP BY oct00,oct09,oct10,oct11,oct16,oct23,oct24",                #FUN-B60079 mark
            #" ORDER BY oct00,oct09,oct10,oct16,oct11,oct23,oct24 "                #FUN-B60079 mark
   PREPARE q704_pb FROM l_sql
   DECLARE q704_bcs                       #BODY CURSOR
        CURSOR FOR q704_pb


   CALL g_oct.clear()
   LET g_rec_b=0
   LET g_cnt = 1

   FOREACH q704_bcs INTO g_oct[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach",STATUS,1)
         EXIT FOREACH
      END IF

#A.期初遞延未實現餘額=取上期遞延未實現餘額(F)
   #先算前期的年月
   LET l_a = 0
   LET l_a_p = 0
   LET l_b = 0
   LET l_c = 0
   LET l_d = 0

   IF g_oct[g_cnt].oct10 = 1 THEN
       LET l_yy = g_oct[g_cnt].oct09 -1
       LET l_mm = 12
   ELSE
       LET l_yy = g_oct[g_cnt].oct09
       LET l_mm = g_oct[g_cnt].oct10 -1
   END IF
   
   SELECT SUM(oct12) INTO l_a
     FROM oct_file
    WHERE oct00 = g_oct[g_cnt].oct00_2
      AND oct09 = l_yy
      AND oct10 = l_mm
      AND oct11 = g_oct[g_cnt].oct11
      AND oct23 = g_oct[g_cnt].oct23
      AND oct24 = g_oct[g_cnt].oct24
      AND oct16 = g_oct[g_cnt].oct16
      AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
      AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079

      IF g_oct[g_cnt].oct16='1' THEN
         #-本期-
         SELECT SUM(oct14) INTO l_b
           FROM oct_file
          WHERE oct00 = g_oct[g_cnt].oct00_2
            AND oct09 = l_yy
            AND oct10 = l_mm
            AND oct11 = g_oct[g_cnt].oct11
            AND oct23 = g_oct[g_cnt].oct23
            AND oct24 = g_oct[g_cnt].oct24
            AND oct16 ='2'
            AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
            AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079
         #-前期-
         SELECT SUM(oct14) INTO l_c
           FROM oct_file
          WHERE oct00 =g_oct[g_cnt].oct00_2
            AND ((oct09 = l_yy
               AND oct10 < l_mm)
               OR ( oct09 < l_yy
               AND oct10 < l_mm))
            AND oct11 = g_oct[g_cnt].oct11
            AND oct23 = g_oct[g_cnt].oct23
            AND oct24 = g_oct[g_cnt].oct24
            AND oct16 ='2' 
            AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
            AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079
      ELSE
         SELECT SUM(oct15) INTO l_b
           FROM oct_file
          WHERE oct00 = g_oct[g_cnt].oct00_2
            AND oct09 = l_yy
            AND oct10 = l_mm
            AND oct11 = g_oct[g_cnt].oct11
            AND oct23 = g_oct[g_cnt].oct23
            AND oct24 = g_oct[g_cnt].oct24
            AND oct16 ='4'
            AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
            AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079
         #-前期-
         SELECT SUM(oct15) INTO l_c
           FROM oct_file
          WHERE oct00 =g_oct[g_cnt].oct00_2
            AND ((oct09 = l_yy
               AND oct10 < l_mm)
               OR ( oct09 < l_yy
               AND oct10 < l_mm))
            AND oct11 = g_oct[g_cnt].oct11
            AND oct23 = g_oct[g_cnt].oct23
            AND oct24 =g_oct[g_cnt].oct24
            AND oct16 ='4' 
            AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
            AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079
      END IF  
      IF cl_null(l_b) THEN LET l_b = 0 END IF
      IF cl_null(l_c) THEN LET l_c= 0 END IF
      LET l_d = l_b + l_c

      SELECT SUM(oct12) INTO l_a_p
        FROM oct_file
       WHERE oct00 =g_oct[g_cnt].oct00_2
         AND ((oct09 = l_yy
            AND oct10 < l_mm)
            OR ( oct09 < l_yy
            AND oct10 < l_mm))
         AND oct11 = g_oct[g_cnt].oct11
         AND oct23 = g_oct[g_cnt].oct23
         AND oct24 =g_oct[g_cnt].oct24
         AND oct16 = g_oct[g_cnt].oct16
         AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
         AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079
      IF cl_null(l_a_p) THEN LET l_a_p = 0 END IF

      LET g_oct[g_cnt].sum5  = l_a + l_a_p - l_d
      IF cl_null(g_oct[g_cnt].sum5) THEN LET g_oct[g_cnt].sum5 = 0 END IF
 
#B.本期新增遞延(本期oct12) 
   LET g_oct[g_cnt].oct12 = 0
   SELECT SUM(oct12) INTO g_oct[g_cnt].oct12
     FROM oct_file
    WHERE oct00 = g_oct[g_cnt].oct00_2
      AND oct09 = g_oct[g_cnt].oct09
      AND oct10 = g_oct[g_cnt].oct10
      AND oct11 = g_oct[g_cnt].oct11
      AND oct23 = g_oct[g_cnt].oct23
      AND oct24 = g_oct[g_cnt].oct24
      AND oct16 = g_oct[g_cnt].oct16
      AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
      AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079
    
#C.本期新增遞延本期應實現(本期發生沖轉額oct14 or oct15)
      LET l_sum1 = 0 #本期發生額
      LET l_sum2 = 0 #前期發生額

      IF g_oct[g_cnt].oct16='1' THEN
         #-本期-
         SELECT SUM(oct14) INTO l_sum1
           FROM oct_file
          WHERE oct00 = g_oct[g_cnt].oct00_2
            AND oct09 = g_oct[g_cnt].oct09
            AND oct10 = g_oct[g_cnt].oct10
            AND oct11 = g_oct[g_cnt].oct11
            AND oct23 = g_oct[g_cnt].oct23
            AND oct24 = g_oct[g_cnt].oct24
            AND oct16 ='2'
            AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
            AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079
         IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
         LET g_oct[g_cnt].sum1 = l_sum1

         #-前期-
         SELECT SUM(oct14) INTO l_sum2
           FROM oct_file
          WHERE oct00 =g_oct[g_cnt].oct00_2
            AND ((oct09 = g_oct[g_cnt].oct09
               AND oct10 < g_oct[g_cnt].oct10)
               OR ( oct09 < g_oct[g_cnt].oct09
               AND oct10 < g_oct[g_cnt].oct10))
            AND oct11 = g_oct[g_cnt].oct11
            AND oct23 = g_oct[g_cnt].oct23
            AND oct24 =g_oct[g_cnt].oct24
            AND oct16 ='2' 
            AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
            AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079
         IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
#D.前期遞延本期應實現（取上期發生額）
         LET g_oct[g_cnt].sum2 = l_sum2
#E.遞延本期應實現
         LET g_oct[g_cnt].sum3 = l_sum1+ l_sum2
      ELSE
         SELECT SUM(oct15) INTO l_sum1
           FROM oct_file 
          WHERE oct00 = g_oct[g_cnt].oct00_2
            AND oct09 = g_oct[g_cnt].oct09
            AND oct10 = g_oct[g_cnt].oct10
            AND oct23 = g_oct[g_cnt].oct23
            AND oct24 = g_oct[g_cnt].oct24
            AND oct11 = g_oct[g_cnt].oct11
            AND oct16 ='4'
            AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
            AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079
         IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF

         SELECT SUM(oct15) INTO l_sum2 
           FROM oct_file
          WHERE oct00 = g_oct[g_cnt].oct00_2
            AND ((oct09 = g_oct[g_cnt].oct09
               AND oct10 < g_oct[g_cnt].oct10)
               OR ( oct09 < g_oct[g_cnt].oct09
               AND oct10 < g_oct[g_cnt].oct10))
            AND oct11= g_oct[g_cnt].oct11
            AND oct16 ='4'
            AND oct23 = g_oct[g_cnt].oct23
            AND oct24 = g_oct[g_cnt].oct24
            AND oct01 = g_oct[g_cnt].oct01   #FUN-B60079
            AND oct02 = g_oct[g_cnt].oct02   #FUN-B60079
         IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF

#本期新增遞延本期應實現
         LET g_oct[g_cnt].sum1 = l_sum1

#前期遞延本期應實現（取上期發生額）
         LET g_oct[g_cnt].sum2 = l_sum2

#E.遞延本期應實現
         LET g_oct[g_cnt].sum3 = l_sum1 + l_sum2
      END IF

#F.遞延未實現余額
      LET g_oct[g_cnt].sum4 = g_oct[g_cnt].oct12 + g_oct[g_cnt].sum5 - g_oct[g_cnt].sum3
      IF cl_null(g_oct[g_cnt].sum4) THEN LET g_oct[g_cnt].sum4 = 0 END IF

      LET g_cnt=g_cnt+1
      IF g_cnt>g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_oct.DeleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   LET g_cnt = g_rec_b
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION q704_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680098  char(1) 


   IF p_ud <> "G" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oct TO s_oct.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

         CALL cl_show_fld_cont() 

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    

      ON ACTION def_detail
         LET l_ac = ARR_CURR()  #TQC-B80032
         IF l_ac > 0 THEN       #TQC-B80032
        #IF g_cnt > 0 THEN      #TQC-B80032 mark,原程式寫法只會抓最後一筆
        #TQC-B80032--begin--
        #IF g_cnt > 0 THEN
        #   LET g_cmd = "aglq700 ",g_oct[g_cnt].oct09," ",g_oct[g_cnt].oct10,
        #               " '",g_oct[g_cnt].oct00_2,"' '",g_oct[g_cnt].oct11,"'",
        #               " '",g_oct[g_cnt].oct23,"' '",g_oct[g_cnt].oct24,"'"
        #TQC-B80032---end---
            LET g_cmd = "aglq700 ",g_oct[l_ac].oct01," ",g_oct[l_ac].oct02  #TQC-B80032
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF
                        

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-AB0105
