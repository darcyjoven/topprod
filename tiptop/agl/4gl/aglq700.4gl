# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: aglq700.4gl
# Descriptions...: 遞延收入查詢作業
# Date & Author..: No.FUN-9A0036 10/07/21 By chenmoyan
# Modify.........: NO.FUN-A10005 10/07/21 BY chenmoyan 每期沖轉金額應依幣別取位且無條件捨去不做四捨五入
# Modify.........: No.FUN-A60007 10/07/27 By chanmoyan 1.aglt700改為aglq800
#                                                      2.移除 oct081,oct131,aag02_2, 加入帳別
# Modify.........: No.CHI-A80021 10/08/12 By vealxu 移除單身功能鍵
# Modify.........: No.FUN-A50102 10/09/28 By vealxu 跨db处理 
# Modify.........: No.FUN-AB0105 11/01/19 By vealxu 加傳參，供其他作業調用
# Modify.........: No:TQC-B80032 11/08/08 by belle 修改接受aglq704的參數

DATABASE ds

GLOBALS "../../config/top.global"
#No.FUN-A60007
#模組變數(Module Variables)
DEFINE g_up         LIKE type_file.chr1
#TQC-B80032 --Begin Mark--
#FUN-AB0105 --Begin
#DEFINE g_argv1      LIKE oct_file.oct09
#DEFINE g_argv2      LIKE oct_file.oct10
#DEFINE g_argv3      LIKE oct_file.oct00
#DEFINE g_argv4      LIKE oct_file.oct11
#DEFINE g_argv5      LIKE oct_file.oct23
#DEFINE g_argv6      LIKE oct_file.oct24
#FUN-AB0105 --End
#TQC-B80032 --End Mark--
DEFINE g_argv1      LIKE oct_file.oct01   #TQC-B80032
DEFINE g_argv2      LIKE oct_file.oct02   #TQC-B80032
DEFINE
    g_oct         DYNAMIC ARRAY OF RECORD
                    oct00     LIKE oct_file.oct00,  #FUN-A60007
                    oct17     LIKE oct_file.oct17,
                    oct16     LIKE oct_file.oct16,
                    oct01     LIKE oct_file.oct01,
                    oct02     LIKE oct_file.oct02,
                    oct03     LIKE oct_file.oct03,
                    ima02     LIKE ima_file.ima02,
                    oct18     LIKE oct_file.oct18,
                    oct19     LIKE oct_file.oct19,
                    oct04     LIKE oct_file.oct04,
                    oct05     LIKE oct_file.oct05,
                    oct06     LIKE oct_file.oct06,
                    oct07     LIKE oct_file.oct07,
                    oct08     LIKE oct_file.oct08,
                    #oct081    LIKE oct_file.oct081,  #FUN-A60007
                    oct09     LIKE oct_file.oct09,
                    oct10     LIKE oct_file.oct10,
                    oct11     LIKE oct_file.oct11,
                    ocr02     LIKE ocr_file.ocr02,
                    oct12     LIKE oct_file.oct12,
                    oct12f    LIKE oct_file.oct12f,
                    oct13     LIKE oct_file.oct13,
                    aag02_1   LIKE aag_file.aag02
                    #oct131    LIKE oct_file.oct131,  #FUN-A60007
                    #aag02_2   LIKE aag_file.aag02    #FUN-A60007 
                    END RECORD,
    g_oct_t        RECORD
                    oct00     LIKE oct_file.oct00,    #FUN-A60007
                    oct17     LIKE oct_file.oct17,
                    oct16     LIKE oct_file.oct16,
                    oct01     LIKE oct_file.oct01,
                    oct02     LIKE oct_file.oct02,
                    oct03     LIKE oct_file.oct03,
                    ima02     LIKE ima_file.ima02,
                    oct18     LIKE oct_file.oct18,
                    oct19     LIKE oct_file.oct19,
                    oct04     LIKE oct_file.oct04,
                    oct05     LIKE oct_file.oct05,
                    oct06     LIKE oct_file.oct06,
                    oct07     LIKE oct_file.oct07,
                    oct08     LIKE oct_file.oct08,
                    #oct081    LIKE oct_file.oct081, #FUN-A60007
                    oct09     LIKE oct_file.oct09,
                    oct10     LIKE oct_file.oct10,
                    oct11     LIKE oct_file.oct11,
                    ocr02     LIKE ocr_file.ocr02,
                    oct12     LIKE oct_file.oct12,
                    oct12f    LIKE oct_file.oct12f,
                    oct13     LIKE oct_file.oct13,
                    aag02_1   LIKE aag_file.aag02
#                    oct131    LIKE oct_file.oct131,  #FUN-A60007
#                    aag02_2   LIKE aag_file.aag02    #FUN-A60007
                    END RECORD,
    g_oct1         DYNAMIC ARRAY OF RECORD
                    oct16_l   LIKE oct_file.oct16,
                    oct09_l   LIKE oct_file.oct09,
                    oct10_l   LIKE oct_file.oct10,
                    oct14     LIKE oct_file.oct14,
                    oct14f    LIKE oct_file.oct14f,
                    oct15     LIKE oct_file.oct15,
                    oct15f    LIKE oct_file.oct15f,
                    oct08_l   LIKE oct_file.oct08
                    #oct081_l  LIKE oct_file.oct081 #FUN-A60007
                    END RECORD,
    g_wc1           STRING,
    g_rec_b1        LIKE type_file.num5,          #單身筆數
    g_rec_b2        LIKE type_file.num5,          #單身筆數
    g_sql           STRING,
    l_ac_t     LIKE type_file.num5,
    p_row,p_col     LIKE type_file.num5,
    g_forupd_sql    LIKE type_file.chr1000,
    l_ac1,l_ac2     LIKE type_file.num5
DEFINE g_oct09_s    LIKE oct_file.oct09
DEFINE g_oct09_e    LIKE oct_file.oct10
DEFINE g_oct10_s    LIKE oct_file.oct09
DEFINE g_oct10_e    LIKE oct_file.oct10
DEFINE g_oct01_o    LIKE oct_file.oct01
DEFINE g_oct02_o    LIKE oct_file.oct01
DEFINE g_omb14_n    LIKE omb_file.omb14
DEFINE g_omb16_n    LIKE omb_file.omb16
DEFINE g_omb16      LIKE omb_file.omb16
DEFINE g_oct12_o    LIKE oct_file.oct12
MAIN

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)
  #FUN-AB0105 --Begin
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
  #LET g_argv3 = ARG_VAL(3)   #TQC-B80032 Mark
  #LET g_argv4 = ARG_VAL(4)   #TQC-B80032 Mark
  #LET g_argv5 = ARG_VAL(5)   #TQC-B80032 Mark
  #LET g_argv6 = ARG_VAL(6)   #TQC-B80032 Mark
  #FUN-AB0105 --End 

   #顯示畫面
   LET p_row = 3 LET p_col = 2
   OPEN WINDOW t700_w AT p_row,p_col WITH FORM "agl/42f/aglq700"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
#--FUN-A60007 mark--
#   IF g_aza.aza63 = 'N' THEN
#      CALL cl_set_comp_visible("oct081,oct081_l,oct131,aag02_2",FALSE)
#   END IF
#--FUN-A60007 mark--
   IF NOT cl_null(g_argv1) THEN CALL t700_q() END IF #FUN-AB01

   CALL t700_menu()
   CLOSE WINDOW t700_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #計算使用時間 (退出使間)   #NO.FUN-6A0094 
END MAIN

#QBE 查詢資料
FUNCTION t700_cs()
  CLEAR FORM                             #清除畫面
  CALL g_oct.clear()
  CALL g_oct1.clear()
#FUN-AB0105 --Begin
  IF g_argv1 IS NOT NULL THEN
     LET g_wc1 = " oct01 = '",g_argv1,"' AND oct02 = LTRIM('",g_argv2,"') "   #TQC-B80032
    #TQC-B80032--Begin Mark--
    #LET g_wc1 = " oct09 = ",g_argv1," AND oct10 = ",g_argv2," AND ",
    #            " oct00 = '",g_argv3,"' AND oct11 = '",g_argv4,"' AND"
    #IF g_argv5 IS NOT NULL THEN
    #   LET g_wc1 = g_wc1 ," oct23 = '",g_argv5,"' AND "
    #ELSE
    #   LET g_wc1 = g_wc1," oct23 IS NULL AND "
    #END IF
    #IF g_argv6 IS NOT NULL THEN
    #   LET g_wc1 = g_wc1," oct24 = '",g_argv6,"'"
    #ELSE
    #   LET g_wc1 = g_wc1," oct24 IS NULL "
    #END IF
    #TQC-B80032--End Mark--
  ELSE
#FUN-AB0105 --End

     #CONSTRUCT g_wc1 ON oct17,oct16,oct01,oct02,oct03,oct18,oct19,oct04,
     CONSTRUCT g_wc1 ON oct00,oct17,oct16,oct01,oct02,oct03,oct18,oct19,oct04,  #FUN-A60007
                        #oct05,oct06,oct07,oct08,oct081,oct09,oct10,oct11,
                        #oct12,oct12f,oct13,oct131
                        oct05,oct06,oct07,oct08,oct09,oct10,oct11,
                        oct12,oct12f,oct13
                  #FROM s_oct[1].oct17,s_oct[1].oct16,s_oct[1].oct01,
                  FROM s_oct[1].oct00,s_oct[1].oct17,s_oct[1].oct16,s_oct[1].oct01,  #FUN-A60007
                       s_oct[1].oct02,s_oct[1].oct03,s_oct[1].oct18,
                       s_oct[1].oct19,s_oct[1].oct04,s_oct[1].oct05,
                       s_oct[1].oct06,s_oct[1].oct07,s_oct[1].oct08,
                       #s_oct[1].oct081,s_oct[1].oct09,s_oct[1].oct10,
                       s_oct[1].oct09,s_oct[1].oct10,  #FUN-A60007
                       s_oct[1].oct11,s_oct[1].oct12,s_oct[1].oct12f,
                       #s_oct[1].oct13,s_oct[1].oct131
                       s_oct[1].oct13   #FUN-A60007

           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(oct17)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azp"
                   LET g_qryparam.state = 'c'
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO s_oct[1].oct17
                   NEXT FIELD oct17

#             WHEN INFIELD(oct01)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_oma8"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO s_oct[1].oct01
#                  NEXT FIELD oct01

#             WHEN INFIELD(oct11)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ocs"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO s_oct[1].oct11
#                  NEXT FIELD oct11

#             WHEN INFIELD(oct13)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_m_aag"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO s_oct[1].oct13
#                  NEXT FIELD oct13

#             WHEN INFIELD(oct131)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_m_aag"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
#                  DISPLAY g_qryparam.multiret TO s_oct[1].oct131
#                  NEXT FIELD oct131

                 OTHERWISE EXIT CASE
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
 
     END CONSTRUCT
     IF INT_FLAG THEN
        RETURN
     END IF

     #資料權限的檢查
     IF g_priv2='4' THEN                           #只能使用自己的資料
        LET g_wc1 = g_wc1 CLIPPED," AND oeauser = '",g_user,"'"
     END IF
     IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET g_wc1 = g_wc1 CLIPPED," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     END IF

     IF g_priv3 MATCHES "[5678]" THEN              #群組權限
        LET g_wc1 = g_wc1 CLIPPED," AND oeagrup IN ",cl_chk_tgrup_list()
     END IF
  END IF         #FUN-AB010
END FUNCTION

FUNCTION t700_menu()
   WHILE TRUE
      CALL t700_bp()
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t700_q()
            END IF

       #WHEN "detail"                #CHI-A80021
       #   IF cl_chk_act_auth() THEN #CHI-A80021
       #      CALL t700_b1()         #CHI-A80021  
       #   END IF                    #CHI-A80021

        WHEN "view1"
             CALL t700_bp2()

         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
            LET g_up = 'R'

      END CASE
   END WHILE
END FUNCTION

#Query 查詢
FUNCTION t700_q()
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_oct.clear()
    CALL g_oct1.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    DISPLAY '   ' TO FORMONLY.cn2
    CALL t700_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL t700_b1_fill(g_wc1)
 
    LET l_ac1 = 1
END FUNCTION

FUNCTION t700_b1_fill(p_wc1)
DEFINE  p_wc1        STRING
DEFINE  l_azp03      LIKE azp_file.azp03
DEFINE  l_dbs        LIKE type_file.chr20
DEFINE  l_plant      LIKE azp_file.azp01         #FUN-A50102

    IF cl_null(p_wc1) THEN
       LET p_wc1 = ' 1=1'
    END IF

    #LET g_sql = "SELECT oct17,oct16,oct01,oct02,oct03,' ',oct18,",
    LET g_sql = "SELECT oct00,oct17,oct16,oct01,oct02,oct03,' ',oct18,", #FUN-A60007
                #"       oct19,oct04,oct05,oct06,oct07,oct08,oct081,",
                "       oct19,oct04,oct05,oct06,oct07,oct08,",   #FUN-A60007 mod
                "       oct09,oct10,oct11,' ',oct12,oct12f,oct13,",
                #"       ' ',oct131,' '",
                "        ' '",  #FUN-A60007
                "  FROM oct_file ",
                " WHERE (oct16='1' OR oct16='3')",
                "   AND ",p_wc1 CLIPPED,
                "  ORDER BY oct01,oct02,oct11,oct00 "  #FUN-A60007
    PREPARE t700_pre1 FROM g_sql
    DECLARE t700_cs1 CURSOR FOR t700_pre1

    CALL g_oct.clear()
    LET g_rec_b1 = 1
    DISPLAY ' ' TO FORMONLY.cnt

    FOREACH t700_cs1 INTO g_oct[g_rec_b1].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('b1_fill foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        CALL t700_get_dbs(g_oct[g_rec_b1].oct17) 
           #  RETURNING l_azp03,l_dbs          #FUN-A50102 mark
              RETURNING l_azp03,l_plant        #FUN-A50102

        SELECT ima02 INTO g_oct[g_rec_b1].ima02
          FROM ima_file
         WHERE ima01=g_oct[g_rec_b1].oct03

        SELECT ocr02 INTO g_oct[g_rec_b1].ocr02
          FROM ocr_file
         WHERE ocr01=g_oct[g_rec_b1].oct11

#       CALL t700_chk_acc_entry(g_oct[g_rec_b1].oct13,g_aza.aza81,l_dbs)       #FUN-A50102 mark
        CALL t700_chk_acc_entry(g_oct[g_rec_b1].oct13,g_aza.aza81,l_plant)     #FUN-A50102 
             RETURNING g_oct[g_rec_b1].aag02_1
#        CALL t700_chk_acc_entry(g_oct[g_rec_b1].oct131,g_aza.aza82,l_dbs)  #FUN-A60007 mark
#             RETURNING g_oct[g_rec_b1].aag02_2

        LET g_rec_b1 = g_rec_b1 + 1
        IF g_rec_b1 > g_max_rec THEN
           CALL cl_err('', 9035, 0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oct.deleteElement(g_rec_b1)
    LET g_rec_b1 = g_rec_b1 - 1
    DISPLAY g_rec_b1 TO FORMONLY.cnt
END FUNCTION

FUNCTION t700_b2_fill()
DEFINE  l_i      LIKE type_file.num5

    CALL g_oct1.clear()
    LET g_rec_b2 = 1
    DISPLAY ' ' TO FORMONLY.cn2

    #LET g_sql = "SELECT oct16,oct09,oct10,oct14,oct14f,oct15,oct15f,oct08,oct081 ",
    LET g_sql = "SELECT oct16,oct09,oct10,oct14,oct14f,oct15,oct15f,oct08 ",  #FUN-A60007
                "  FROM oct_file ",
                " WHERE oct01='",g_oct[l_ac1].oct01,"' ",
                "   AND oct02='",g_oct[l_ac1].oct02,"' ",
                "   AND oct11='",g_oct[l_ac1].oct11,"' ",
                "   AND (oct16='2' OR oct16='4') ",
                "   AND oct00='",g_oct[l_ac1].oct00,"'"  #FUN-A60007

    CALL cl_replace_sqldb(g_sql) RETURNING g_sql
    PREPARE t700_pre2 FROM g_sql
    DECLARE t700_cs2 CURSOR FOR t700_pre2

    IF NOT(g_rec_b2 > g_max_rec) THEN
       FOREACH t700_cs2 INTO g_oct1[g_rec_b2].*
          IF SQLCA.SQLCODE THEN
             CALL cl_err('b2_fill foreach1:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF

          LET g_rec_b2 = g_rec_b2 + 1
          IF g_rec_b2 > g_max_rec THEN
             CALL cl_err('',9035,0)
             EXIT FOREACH
          END IF
       END FOREACH
    END IF
    CALL g_oct1.deleteElement(g_rec_b2)

    LET g_rec_b2 = g_rec_b2 - 1
    DISPLAY g_rec_b2 TO FORMONLY.cn2

    CALL t700_bp2_refresh()
END FUNCTION

FUNCTION t700_bp()
   DEFINE   p_ud   LIKE type_file.chr1
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY BY NAME g_oct[1].oct17
   DISPLAY BY NAME g_oct[1].oct16
   CALL t700_b1_fill(g_wc1)
   DISPLAY ARRAY g_oct TO s_oct.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)

      BEFORE DISPLAY
         IF l_ac1 <> 0 THEN
            CALL fgl_set_arr_curr(l_ac1)
         END IF

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         LET l_ac_t = l_ac1
         IF l_ac1 = 0 THEN
            LET l_ac1 = 1
         ELSE
            CALL t700_b2_fill()
         END IF

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

     ON ACTION accept
        LET g_action_choice="detail"
        LET l_ac1 = ARR_CURR()
        EXIT DISPLAY

      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
     ON ACTION view1
        LET g_action_choice = "view1"
        EXIT DISPLAY

    #ON ACTION detail                  #CHI-A80021
    #   LET g_action_choice = "detail" #CHI-A80021
    #   LET l_ac1 = 1                  #CHI-A80021  
    #   EXIT DISPLAY                   #CHI-A80021       

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t700_bp2_refresh()
   DISPLAY ARRAY g_oct1 TO s_oct1.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      #BEFORE DISPLAY
      BEFORE ROW
         DISPLAY g_rec_b2
         CALL ui.interface.refresh() 
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

FUNCTION t700_bp2()
   DEFINE   p_ud   LIKE type_file.chr1

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oct1 TO s_oct1.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)

      BEFORE ROW
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_up = "V"
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()

      #將focus指回單頭
      ON ACTION return
         LET g_up = "R"
         LET g_action_choice="return"
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#CHI-A80021-------- mark start------------
#FUNCTION t700_b1()
#DEFINE
#    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
#    l_n             LIKE type_file.num5,                #檢查重複用
#    l_cnt1,l_cnt    LIKE type_file.num5,
#    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否
#    p_cmd           LIKE type_file.chr1,                 #處理狀態
#    l_allow_insert  LIKE type_file.chr1,                #可新增否
#    l_allow_delete  LIKE type_file.chr1,                #可刪除否
#    l_oma00         LIKE oma_file.oma00,
#    l_omb31         LIKE omb_file.omb31,
#    l_omb32         LIKE omb_file.omb32,
#    l_oma02         LIKE oma_file.oma02,
#    l_azp03         LIKE azp_file.azp03,
#    l_dbs           LIKE type_file.chr20,
#    l_sql           LIKE type_file.chr1000    
#DEFINE 
#    l_plant         LIKE azp_file.azp01             #FUN-A50102
#    LET g_action_choice = ""
# Prog. Version..: '5.30.06-13.03.12(0) THEN RETURN END IF                #檢查權限
#
#    LET l_ac_t=0
#
#    CALL cl_opmsg('b')
#
#    #LET g_forupd_sql = "SELECT oct17,oct16,oct01,oct02,oct03,' ',oct18,",
#    LET g_forupd_sql = "SELECT oct00,oct17,oct16,oct01,oct02,oct03,' ',oct18,",  #FUN-A60007
#                       #"       oct19,oct04,oct05,oct06,oct07,oct08,oct081,",
#                       "       oct19,oct04,oct05,oct06,oct07,oct08,",   #FUN-A60007 
#                       "       oct09,oct10,oct11,' ',oct12,oct12f,oct13,",
#                       #"       ' ',oct131,' '",
#                       "       ' '",    #FUN-A60007
#                       "  FROM oct_file ",
#                       " WHERE oct01 = ? AND oct02 = ? AND oct09 = ? ",
#                       " AND oct10= ? AND oct11=? AND oct16=? ",
#                      " FOR UPDATE "
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#   DECLARE t700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#
#  LET l_allow_insert = cl_detail_input_auth('insert')
#    LET l_allow_delete = cl_detail_input_auth('delete')
#
#   INPUT ARRAY g_oct WITHOUT DEFAULTS FROM s_oct.*
#         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
#                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
#                   APPEND ROW=l_allow_insert)
#
#       BEFORE INPUT
#          IF g_rec_b1!=0 THEN
#             CALL fgl_set_arr_curr(l_ac1)
#           END IF
#
#        BEFORE ROW
#           LET p_cmd=''
#           LET l_ac1 = ARR_CURR()
#           LET l_lock_sw = 'N'            #DEFAULT
#           LET l_n  = ARR_COUNT()
#           BEGIN WORK
#           IF g_rec_b1>=l_ac1 THEN
#     
#              CALL t700_b2_fill()
#              LET p_cmd='u'
#              LET g_oct_t.* = g_oct[l_ac1].*  #BACKUP
#              OPEN t700_bcl USING
#                   g_oct[l_ac1].oct01,g_oct[l_ac1].oct02,
#                   g_oct[l_ac1].oct09,g_oct[l_ac1].oct10,
#                   g_oct[l_ac1].oct11,g_oct[l_ac1].oct16
#                                 
#              IF STATUS THEN
#                 CALL cl_err("OPEN t700_bcl:", STATUS, 1)
#                 LET l_lock_sw = "Y"
#              ELSE
#                 FETCH t700_bcl INTO g_oct[l_ac1].*
#                 IF SQLCA.sqlcode THEN
#3                    CALL cl_err(g_oct_t.oct03,SQLCA.sqlcode,1)
#                    LET l_lock_sw = "Y"
#                 ELSE
#                    SELECT azp03 INTO l_azp03
#                      FROM azp_file
#                     WHERE azp01 = g_oct[l_ac1].oct17
#                    LET l_plant  = g_oct[l_ac1].oct17                #FUN-A50102 add
#                    CALL s_dbstring(l_azp03) RETURNING l_dbs
#                  # CALL t700_ima02(l_dbs,g_oct[l_ac1].oct03)        #FUN-A50102 mark
#                    CALL t700_ima02(l_plant,g_oct[l_ac1].oct03)      #FUN-A50102 
#                         RETURNING g_oct[l_ac1].ima02
#                  # CALL t700_ocr02(l_dbs,g_oct[l_ac1].oct11)        #FUN-A50102 mark
#                    CALL t700_ocr02(l_plant,g_oct[l_ac1].oct11)      #FUN-A50102
#                         RETURNING g_oct[l_ac1].ocr02
#                    CALL t700_chk_acc_entry(g_oct[l_ac1].oct13,g_aza.aza81,l_dbs)
#3                         RETURNING g_oct[l_ac1].aag02_1
##                    CALL t700_chk_acc_entry(g_oct[l_ac1].oct131,g_aza.aza82,l_dbs)  #FUN-A60007 mark
#                         RETURNING g_oct[l_ac1].aag02_2
#                    DISPLAY BY NAME g_oct[l_ac1].ima02,g_oct[l_ac1].ocr02,
#                                    #g_oct[l_ac1].aag02_1,g_oct[l_ac1].aag02_2  #FUN-A60007 mark
#                                    g_oct[l_ac1].aag02_1
#                         
#                 END IF
#              END IF
#              CALL cl_show_fld_cont()
#           ELSE
#              LET p_cmd='a'
#           END IF
#
#        BEFORE INSERT
#           LET l_n = ARR_COUNT()
#           LET p_cmd='a'
#           INITIALIZE g_oct[l_ac1].* TO NULL
#           LET g_oct_t.* = g_oct[l_ac1].*         #新輸入資料
#           CALL cl_show_fld_cont()
#           NEXT FIELD oct17
#
###--FUN-A60007 mark--
##               LET l_sql=" SELECT ocs03,ocs031 ",
#3#                         "   FROM ",l_dbs,"ocs_file,",l_dbs,"ima_file ",
##                         "  WHERE ima01 = '",g_oct[l_ac1].oct03,"'",
##                         "    AND ima131 = ocs01 ",
##                         "    AND ocs02 = '",g_oct[l_ac1].oct11,"'"
##               PREPARE t700_pre10 FROM l_sql
##               DECLARE t700_cs10 SCROLL CURSOR FOR t700_pre10
##               OPEN t700_cs10
##               FETCH t700_cs10 INTO g_oct[l_ac1].oct13,g_oct[l_ac1].oct131
##               CLOSE t700_cs10
##               DISPLAY BY NAME g_oct[l_ac1].oct13,g_oct[l_ac1].oct131
##
##        AFTER INSERT
##           IF INT_FLAG THEN
##              CALL cl_err('',9001,0)
#3#              LET INT_FLAG = 0
##              CANCEL INSERT
##              CLOSE t700_bcl
##           END IF
##           INSERT INTO oct_file (oct01,oct02,oct03,oct04,oct05,
##                                  oct06,oct07,oct08,oct081,oct09,
##                                  oct10,oct11,oct12,oct12f,oct13,oct131,
##                                  oct16,oct17,oct18,oct19)
##           VALUES(
##              g_oct[l_ac1].oct01,g_oct[l_ac1].oct02,g_oct[l_ac1].oct03,
##              g_oct[l_ac1].oct04,g_oct[l_ac1].oct05,g_oct[l_ac1].oct06,
#3#              g_oct[l_ac1].oct07,g_oct[l_ac1].oct08,g_oct[l_ac1].oct081,
##              g_oct[l_ac1].oct09,g_oct[l_ac1].oct10,g_oct[l_ac1].oct11,
##              g_oct[l_ac1].oct12,g_oct[l_ac1].oct12f,g_oct[l_ac1].oct13,
##              g_oct[l_ac1].oct131,g_oct[l_ac1].oct16,g_oct[l_ac1].oct17,
##             g_oct[l_ac1].oct18,g_oct[l_ac1].oct19)
##          IF SQLCA.sqlcode THEN
##             CALL cl_err3("ins","oct_file",g_oct[l_ac1].oct01,g_oct[l_ac1].oct02,SQLCA.sqlcode,"","",1)
##             CANCEL INSERT
##          ELSE
##             COMMIT WORK
##             MESSAGE 'INSERT O.K'
##             LET g_rec_b1=g_rec_b1+1
##             DISPLAY g_rec_b1 TO FORMONLY.cn2
##          END IF
##-FUN-A60007  mark--
#       BEFORE DELETE                            #是否取消單身
#          IF NOT cl_null(g_oct[l_ac1].oct08) THEN
#             CALL cl_err('','afa-973',1)
#             CANCEL DELETE
#          ELSE
#             IF NOT cl_delb(0,0) THEN
#                CANCEL DELETE
#             END IF
#             IF l_lock_sw = "Y" THEN
#                CALL cl_err("", -263, 1)
#                CANCEL DELETE
#             END IF
#             DELETE FROM oct_file
#              WHERE oct01 = g_oct[l_ac1].oct01
#                AND oct02 = g_oct[l_ac1].oct02
#             IF SQLCA.sqlcode THEN
#                CALL cl_err3("del","oct_file",g_oct[l_ac1].oct01,g_oct[l_ac1].oct02,SQLCA.sqlcode,"","",1)
#                ROLLBACK WORK
#                EXIT INPUT
#             ELSE
#                LET g_rec_b1=g_rec_b1-1
#                DISPLAY g_rec_b1 TO FORMONLY.cn2
#                COMMIT WORK
#             END IF
#          END IF

##--FUN-A60007 MARK---
##       ON ROW CHANGE
##          IF INT_FLAG THEN                 #新增程式段
##             CALL cl_err('',9001,0)
##             LET INT_FLAG = 0
##             LET g_oct[l_ac1].* = g_oct_t.*
##             CLOSE t700_bcl
##             ROLLBACK WORK
##             EXIT INPUT
##          END IF
#
##          IF l_lock_sw = 'Y' THEN     # 新增此段
##             CALL cl_err(g_oct[l_ac1].oct02,SQLCA.sqlcode,0)
##             LET g_oct[l_ac1].* = g_oct_t.*
##          ELSE
##             UPDATE oct_file SET oct17 = g_oct[l_ac1].oct17,
##                                 oct16 = g_oct[l_ac1].oct16,
##                                 oct01 = g_oct[l_ac1].oct01,
##                                 oct02 = g_oct[l_ac1].oct02,
#3                                 oct11 = g_oct[l_ac1].oct11,
##                                 oct12 = g_oct[l_ac1].oct12,
##                                 oct12f= g_oct[l_ac1].oct12f,
##                                 oct13 = g_oct[l_ac1].oct13,
##                                 oct131= g_oct[l_ac1].oct131
##              WHERE oct01 = g_oct_t.oct01
##                AND oct02 = g_oct_t.oct02
##                AND oct09 = g_oct_t.oct09
##                AND oct10 = g_oct_t.oct10
##                AND oct11 = g_oct_t.oct11
##                AND oct16 = g_oct_t.oct16
##              IF SQLCA.sqlcode THEN
##                 CALL cl_err3("upd","oct_file",g_oct[l_ac1].oct01,g_oct[l_ac1].oct02,SQLCA.sqlcode,"","",1)
#                  LET g_oct[l_ac1].* = g_oct_t.*
##              ELSE
##                 MESSAGE 'UPDATE O.K'
##                 COMMIT WORK
#                  IF g_oct[l_ac1].oct12 <> g_oct_t.oct12 
#                     OR cl_null(g_oct_t.oct12) THEN
#                     CALL cl_err('','agl-176',1)
#                  END IF
#               END IF
#            END IF
#---FUN-A60007 MARK---

#       AFTER ROW
#          LET l_ac1 = ARR_CURR()         # 新增
#          LET l_ac_t = l_ac1
#          IF INT_FLAG THEN
#             CALL cl_err('',9001,0)
#             LET INT_FLAG = 0
#             IF p_cmd='u' THEN
#                LET g_oct[l_ac1].* = g_oct_t.*
#             END IF
#             CLOSE t700_bcl              # 新增
#             ROLLBACK WORK
#             EXIT INPUT
#             LET g_rec_b1=g_rec_b1-1
#             DISPLAY g_rec_b1 TO FORMONLY.cn2
#          END IF
#          COMMIT WORK

#       ON ACTION CONTROLO                        #沿用所有欄位
#          IF INFIELD(oct02) AND l_ac1 > 1 THEN
#             LET g_oct[l_ac1].* = g_oct[l_ac1-1].*
#             LET g_oct[l_ac1].oct02 = NULL
#             NEXT FIELD oct17
#           END IF

#       ON ACTION controlp
#          CASE
#             WHEN INFIELD(oct17)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_azp"
#                  LET g_qryparam.default1 = g_oct[l_ac1].oct17
#                  CALL cl_create_qry() RETURNING g_oct[l_ac1].oct17
#                  DISPLAY BY NAME g_oct[l_ac1].oct17
#                  NEXT FIELD oct17
#             WHEN INFIELD(oct01)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_oma9"
#                  LET g_qryparam.default1 = g_oct[l_ac1].oct01
#                  LET g_qryparam.arg1 = l_azp03
#                  LET g_qryparam.default1 = g_oct[l_ac1].oct01
#                  CALL cl_create_qry() 
#                      RETURNING g_oct[l_ac1].oct01,g_oct[l_ac1].oct02
#                  DISPLAY BY NAME g_oct[l_ac1].oct01,g_oct[l_ac1].oct02
#                  NEXT FIELD oct01
#             WHEN INFIELD(oct11)
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_ocs"
#                  LET g_qryparam.default1 = g_oct[l_ac1].oct11
#                  LET g_qryparam.arg1 = l_azp03
#                  LET g_qryparam.arg2 = g_oct[l_ac1].oct03
#                  CALL cl_create_qry() RETURNING g_oct[l_ac1].oct11
#                  DISPLAY BY NAME g_oct[l_ac1].oct11
#                  NEXT FIELD oct11

#             WHEN INFIELD(oct13)
#                # CALL q_m_aag(FALSE,TRUE,l_dbs,' ','23',g_aza.aza81)      #FUN-A50102
#                  CALL q_m_aag(FALSE,TRUE,l_plant,' ','23',g_aza.aza81)      #FUN-A50102 
#                     RETURNING g_oct[l_ac1].oct13
#                  DISPLAY BY NAME g_oct[l_ac1].oct13
#                  NEXT FIELD oct13

#--FUN-A60007 mark-
#              WHEN INFIELD(oct131)
#                   CALL q_m_aag(FALSE,TRUE,l_dbs,' ','23',g_aza.aza82)
#                      RETURNING g_oct[l_ac1].oct131
#                   DISPLAY BY NAME g_oct[l_ac1].oct131
#                   NEXT FIELD oct131
#--FUN-A60007 mark
#           END CASE
#       AFTER FIELD oct17
#           LET l_cnt1=0 
#           SELECT COUNT(*) INTO l_cnt1
#             FROM azp_file
#            WHERE azp01=g_oct[l_ac1].oct17
#           IF l_cnt1=0 THEN
#              CALL cl_err(g_oct[l_ac1].oct17,'aap-025',0)
#              NEXT FIELD oct17
#           END IF
#           CALL t700_get_dbs(g_oct[l_ac1].oct17) 
#             RETURNING l_azp03,l_dbs

#       AFTER FIELD oct01
#           IF NOT cl_null(g_oct[l_ac1].oct01) THEN
#              LET l_cnt1 = 0
#              LET l_sql=" SELECT COUNT(*) ",
#                        "   FROM ",l_dbs,"oma_file ",
#                        "  WHERE oma01='",g_oct[l_ac1].oct01,"' ",
#                        "    AND (oma00='12' OR oma00='21') ",
#                        "    AND omaconf = 'Y' "
#                      
#              PREPARE t700_pre3 FROM l_sql
#              DECLARE t700_cs3 SCROLL CURSOR FOR t700_pre3
#              OPEN t700_cs3
#              FETCH t700_cs3 INTO l_cnt1
#              CLOSE t700_cs3
#              IF l_cnt1 = 0 THEN
#                 CALL cl_err('','agl-159',0)
#                 NEXT FIELD oct01
#              END IF
#              
#              LET l_sql=" SELECT aba01 ",
#                        "   FROM ",l_dbs,"aba_file,",l_dbs,"oma_file ",
#                        "  WHERE aba07 = '",g_oct[l_ac1].oct01,"'",
#                        "    AND aba00 = ?"
#              PREPARE t700_pre11 FROM l_sql
#              DECLARE t700_cs11 SCROLL CURSOR FOR t700_pre11
#              OPEN t700_cs11 USING g_aza.aza81
#              FETCH t700_cs11 INTO g_oct[l_ac1].oct08
#              CLOSE t700_cs11
#              #**FUN-A60007 mark**
#              #OPEN t700_cs11 USING g_aza.aza82
#              #FETCH t700_cs11 INTO g_oct[l_ac1].oct081
#              #CLOSE t700_cs11
#              #--FUN-A60007 mark
#           END IF

#       AFTER FIELD oct02
#           IF NOT cl_null(g_oct[l_ac1].oct02) THEN
#              LET l_sql=" SELECT COUNT(*) ",
#                        "   FROM ",l_dbs,"oma_file,",l_dbs,"omb_file",
#                        "  WHERE oma01='",g_oct[l_ac1].oct01,"' ",
#                        "    AND (oma00='12' OR oma00='21') ",
#                        "    AND omb01=oma01",
#                        "    AND omb03='",g_oct[l_ac1].oct02,"' ",
#                        "    AND omaconf = 'Y' "
#                      
#              PREPARE t700_pre16 FROM l_sql
#              DECLARE t700_cs16 SCROLL CURSOR FOR t700_pre16
#              OPEN t700_cs16
#              FETCH t700_cs16 INTO l_cnt1
#              CLOSE t700_cs16
#              IF l_cnt1 = 0 THEN
#                 CALL cl_err('','agl-186',0)
#                 NEXT FIELD oct02
#              ELSE
#                 CALL t700_oct02(l_dbs,g_oct[l_ac1].oct01,g_oct[l_ac1].oct02) 
#                     RETURNING g_oct[l_ac1].ima02,g_oct[l_ac1].oct18,
#                               g_oct[l_ac1].oct19,g_oct[l_ac1].oct03,
#                               g_oct[l_ac1].oct04,g_oct[l_ac1].oct05,
#                               g_oct[l_ac1].oct06,g_oct[l_ac1].oct07,
#                               l_oma02
#                 DISPLAY BY NAME g_oct[l_ac1].oct03
#                 DISPLAY BY NAME g_oct[l_ac1].ima02
#                 DISPLAY BY NAME g_oct[l_ac1].oct04
#                 DISPLAY BY NAME g_oct[l_ac1].oct05
#                 DISPLAY BY NAME g_oct[l_ac1].oct06
#                 DISPLAY BY NAME g_oct[l_ac1].oct07
#                 DISPLAY BY NAME g_oct[l_ac1].oct18
#                 DISPLAY BY NAME g_oct[l_ac1].oct19
#                 LET g_oct[l_ac1].oct09 = YEAR(l_oma02)
#                 LET g_oct[l_ac1].oct10 = MONTH(l_oma02)
#                 DISPLAY BY NAME g_oct[l_ac1].oct09
#                 DISPLAY BY NAME g_oct[l_ac1].oct10  
#              END IF
#           END IF

#       AFTER FIELD oct09
#           IF g_oct[l_ac1].oct09>YEAR(l_oma02) THEN
#              CALL cl_err('','agl-151',0)
#              NEXT FIELD oct09
#           END IF

#       AFTER FIELD oct10
#           IF g_oct[l_ac1].oct10>MONTH(l_oma02) THEN
#              CALL cl_err('','agl-161',0)
#              NEXT FIELD oct10
#           END IF

#       AFTER FIELD oct11
#           IF NOT cl_null(g_oct[l_ac1].oct11) THEN
#              LET l_cnt = 0
#              LET l_sql=" SELECT COUNT(*) ",
#                        "   FROM ",l_dbs,"ocs_file,",l_dbs,"ima_file ",
#                        "  WHERE ima01 = '",g_oct[l_ac1].oct03,"'",
#                        "    AND ima131 = ocs01 ",
#                        "    AND ocs02 = '",g_oct[l_ac1].oct11,"'"
#              PREPARE t700_pre8 FROM l_sql
#              DECLARE t700_cs8 SCROLL CURSOR FOR t700_pre8
#              OPEN t700_cs8
#              FETCH t700_cs8 INTO l_cnt
#              CLOSE t700_cs8
#              IF l_cnt = 0  THEN 
#                 CALL cl_err('','agl-162',0)
#                 NEXT FIELD oct11
#              END IF
#            # CALL t700_ocr02(l_dbs,g_oct[l_ac1].oct11)       #FUN-A50102 mark
#              CALL t700_ocr02(l_plant,g_oct[l_ac1].oct11)       #FUN-A50102 
#                  RETURNING g_oct[l_ac1].ocr02
#              DISPLAY BY NAME g_oct[l_ac1].ocr02

#              LET l_sql=" SELECT ocs03,ocs031 ",
#                        "   FROM ",l_dbs,"ocs_file,",l_dbs,"ima_file ",
#                        "  WHERE ima01 = '",g_oct[l_ac1].oct03,"'",
#                        "    AND ima131 = ocs01 ",
#                        "    AND ocs02 = '",g_oct[l_ac1].oct11,"'"
#              PREPARE t700_pre10 FROM l_sql
#              DECLARE t700_cs10 SCROLL CURSOR FOR t700_pre10
#              OPEN t700_cs10
#              FETCH t700_cs10 INTO g_oct[l_ac1].oct13,g_oct[l_ac1].oct131
#              CLOSE t700_cs10
#              DISPLAY BY NAME g_oct[l_ac1].oct13,g_oct[l_ac1].oct131
#              
#          END IF

#       AFTER FIELD oct13
#          IF NOT cl_null(g_oct[l_ac1].oct13) THEN
#             CALL t700_chk_acc_entry(g_oct[l_ac1].oct13,g_aza.aza81,l_dbs)
#               RETURNING g_oct[l_ac1].aag02_1
#             IF NOT cl_null(g_errno) THEN
#                CALL cl_err('',g_errno,0)
#                NEXT FIELD oct13
#             END IF
#             DISPLAY BY NAME g_oct[l_ac1].aag02_1
#          END IF

#--FUN-A60007 mark-
#        AFTER FIELD oct131
#           IF NOT cl_null(g_oct[l_ac1].oct131) THEN
#              CALL t700_chk_acc_entry(g_oct[l_ac1].oct131,g_aza.aza82,l_dbs)  
#                RETURNING g_oct[l_ac1].aag02_2  
#              IF NOT cl_null(g_errno) THEN
#                 CALL cl_err('',g_errno,0)
#                 NEXT FIELD oct131
#              END IF
#              DISPLAY BY NAME g_oct[l_ac1].aag02_2 
#           END IF
#--FUN-A60007 mark---

#       AFTER FIELD oct12 
#          #IF g_oct[l_ac1].oct12 <> g_oct_t.oct12 
#             #OR cl_null(g_oct_t.oct12) THEN
#          IF NOT cl_null(g_oct[l_ac1].oct12) THEN   #FUN-A10005 mod
#             LET g_oct[l_ac1].oct12 = cl_digcut(g_oct[l_ac1].oct12,g_azi04)  #FUN-A10005 add
#             LET g_oct[l_ac1].oct12f = g_oct[l_ac1].oct12/g_oct[l_ac1].oct19  
#             SELECT azi04 INTO t_azi04 FROM azi_file     
#              WHERE azi01 = g_oct[l_ac1].oct18
#             #LET g_oct[l_ac1].oct12 = cl_digcut(g_oct[l_ac1].oct12,g_azi04)  #FUN-A10005 mark
#             LET g_oct[l_ac1].oct12f = cl_digcut(g_oct[l_ac1].oct12f,t_azi04)  
#             DISPLAY BY NAME g_oct[l_ac1].oct12
#             DISPLAY BY NAME g_oct[l_ac1].oct12f
#          END   IF

#       ON ACTION CONTROLR
#          CALL cl_show_req_fields()

#       ON ACTION CONTROLG
#          CALL cl_cmdask()

#       ON ACTION CONTROLF
#        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
#
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#          CONTINUE INPUT
# 
#      ON ACTION about
#         CALL cl_about()
# 
#      ON ACTION help
#         CALL cl_show_help()
# 
# 
#    END INPUT
#
#    CLOSE t700_bcl
#3
#END FUNCTION

#CHI-A80021------- mark end------------------------



#FUNCTION t700_chk_acc_entry(p_code,p_aag00,p_dbs)     #FUN-A50102 mark
FUNCTION t700_chk_acc_entry(p_code,p_aag00,p_plant)    #fun-a50102
DEFINE p_code     LIKE aag_file.aag01
DEFINE p_aag00    LIKE aag_file.aag00
DEFINE p_dbs      LIKE type_file.chr20
DEFINE p_plant    LIKE azp_file.azp01            #FUN-A50102 
DEFINE l_aagacti  LIKE aag_file.aagacti
DEFINE l_aag07    LIKE aag_file.aag07
DEFINE l_aag09    LIKE aag_file.aag09
DEFINE l_aag03    LIKE aag_file.aag03
DEFINE l_aag02    LIKE aag_file.aag02
DEFINE l_sql      LIKE type_file.chr1000

   LET l_sql=" SELECT aag02,aag03,aag07,aag09,aagacti ",
            #"   FROM ",p_dbs,"aag_file ",                      #FUN-A50102 mark
             "   FROM ",cl_get_target_table(p_plant,'aag_file'),#FUN-A50102  
             "  WHERE aag01='",p_code,"'",
             "    AND aag00='",p_aag00,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A50102 
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A50102
   PREPARE t700_pre15 FROM l_sql
   DECLARE t700_cs15 SCROLL CURSOR FOR t700_pre15
   OPEN t700_cs15
   FETCH t700_cs15 INTO l_aag02,l_aag03,l_aag07,l_aagacti

   CASE WHEN STATUS=100         LET g_errno='agl-001'  
        WHEN l_aagacti= 'N'     LET g_errno='9028'
        WHEN l_aag07  = '1'     LET g_errno = 'agl-015'
        WHEN l_aag03  = '4'     LET g_errno = 'agl-177'
        WHEN l_aag09  = 'N'     LET g_errno = 'agl-214'
        OTHERWISE LET g_errno=SQLCA.sqlcode USING '----------'
   END CASE
   CLOSE t700_cs15
   RETURN l_aag02
END FUNCTION

FUNCTION t700_gen_defr(p_wc)
DEFINE    p_wc            LIKE type_file.chr1000
DEFINE    l_sql,l_sql1    LIKE type_file.chr1000
DEFINE    l_oct    RECORD LIKE oct_file.*
DEFINE    l_oct1   RECORD LIKE oct_file.*
DEFINE    l_ocs    RECORD LIKE ocs_file.*
DEFINE    l_oct08         LIKE oct_file.oct08
DEFINE    l_dbs           LIKE type_file.chr20
DEFINE    l_azp03         LIKE azp_file.azp03
DEFINE    l_oma02         LIKE oma_file.oma02
DEFINE    l_msg,l_msg1    LIKE type_file.chr1000
DEFINE    l_amt2,l_amt2_f   LIKE oct_file.oct14
DEFINE    i,l_cnt         LIKE type_file.num5
DEFINE    tm       RECORD
          oct01           LIKE oct_file.oct01,
          wc              LIKE type_file.chr1000
               END RECORD
DEFINE    l_oct14         LIKE type_file.num20
DEFINE    l_oct15         LIKE type_file.num20
DEFINE    l_oct14f        LIKE type_file.num20
DEFINE    l_oct15f        LIKE type_file.num20
DEFINE    l_cnt1          LIKE type_file.num5
DEFINE    l_cnt2          LIKE type_file.num5
DEFINE    l_c1_c2         LIKE type_file.num5
DEFINE    j               LIKE type_file.num5
DEFINE    l_oma00         LIKE oma_file.oma00
DEFINE    l_omb38         LIKE omb_file.omb38
DEFINE    l_percent       LIKE ocs_file.ocs05
DEFINE    l_plant         LIKE azp_file.azp01       #FUN-A50102

   IF cl_null(p_wc) THEN
      OPEN WINDOW t700_gen_def_w WITH FORM "agl/42f/aglt7001"
      CALL cl_ui_locale("aglt7001")                                                
                                                                               
      CONSTRUCT BY NAME tm.wc ON oct01
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oct01)                                              
                  CALL cl_init_qry_var()                                       
                  LET g_qryparam.form = "q_oct"                              
                  LET g_qryparam.state = 'c'                                   
                  CALL cl_create_qry() RETURNING g_qryparam.multiret           
                  DISPLAY g_qryparam.multiret TO oct01
                  NEXT FIELD oct01
                                                                                  
               OTHERWISE EXIT CASE                                               
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
      END CONSTRUCT
      CLOSE WINDOW t700_gen_def_w
      IF INT_FLAG THEN                                                             
         RETURN                                                                    
      END IF                
         
      LET l_sql = "SELECT * FROM oct_file ",
                  " WHERE (oct16 = '1' OR oct16 = '3')",
                  "   AND ", tm.wc
      LET l_sql1= "DELETE FROM oct_file ",
                  " WHERE (oct16 = '2' OR oct16 = '4')",
                  "   AND ", tm.wc
   ELSE
      LET l_sql = "SELECT * FROM oct_file ",
                  " WHERE oct16 = '1' OR oct16 = '3'",
                  "   AND oct01 = '",g_oct[l_ac1].oct01,"'",
                  "   AND oct02 = '",g_oct[l_ac1].oct02,"'",
                  "   AND oct09 = '",g_oct[l_ac1].oct09,"'",
                  "   AND oct10 = '",g_oct[l_ac1].oct10,"'",
                  "   AND oct11 = '",g_oct[l_ac1].oct11,"'",
                  "   AND oct16 = '",g_oct[l_ac1].oct16,"'"
      LET l_sql1= "DELETE FROM oct_file ",
                  " WHERE oct16 = '2' OR oct16 = '4'",
                  "   AND oct01 = '",g_oct[l_ac1].oct01,"'",
                  "   AND oct02 = '",g_oct[l_ac1].oct02,"'",
                  "   AND oct09 = '",g_oct[l_ac1].oct09,"'",
                  "   AND oct10 = '",g_oct[l_ac1].oct10,"'",
                  "   AND oct11 = '",g_oct[l_ac1].oct11,"'",
                  "   AND oct16 = '",g_oct[l_ac1].oct16,"'"
   END IF
   PREPARE t700_pre12 FROM l_sql
   DECLARE t700_cs12 CURSOR FOR t700_pre12
   PREPARE t700_pre17 FROM l_sql1
   EXECUTE t700_pre17
  
   FOREACH t700_cs12 INTO l_oct1.*        
      LET l_oct.* = l_oct1.*
      IF l_oct.oct16='1' THEN 
         LET l_oct.oct16='2' 
      ELSE
         LET l_oct.oct16='4'
      END IF
      SELECT azi04 INTO t_azi04 FROM azi_file
       WHERE azi01=l_oct1.oct18 AND aziacti = 'Y'
      IF STATUS THEN
         LET t_azi04 = 0 
      END IF    
      
      CALL t700_get_dbs(l_oct1.oct17) 
       # RETURNING l_azp03,l_dbs             #FUN-A50102 mark
         RETURNING l_azp03,l_plant           #FUN-A50102   
      LET l_sql=" SELECT oma02 ",
               #"   FROM ",l_dbs,"oma_file ",                       #FUN-A50102
                "   FROM ",cl_get_target_table(l_plant,'oma_file'), #FUN-A50102
                "  WHERE oma01 = '",l_oct1.oct01,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql          #FUN-A50102 
      PREPARE t700_pre13 FROM l_sql
      DECLARE t700_cs13 SCROLL CURSOR FOR t700_pre13
      OPEN t700_cs13
      FETCH t700_cs13 INTO l_oma02
      CLOSE t700_cs13
      LET l_sql = " SELECT * ",
                # "   FROM ",l_dbs,"ocs_file,",l_dbs,"ima_file ",                  #FUN-A50102
                  "   FROM ",cl_get_target_table(l_plant,'ocs_file'),",",          #FUN-A50102
                             cl_get_target_table(l_plant,'ima_file'),              #FUN-A50102  
                  "  WHERE ima01 = '",l_oct1.oct03,"'",
                  "    AND ima131 = ocs01 ",
                  "    AND ocs02  = '",l_oct1.oct11,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql       #FUN-A50102
      PREPARE t700_pre14 FROM l_sql
      DECLARE t700_cs14 CURSOR FOR t700_pre14
      FOREACH t700_cs14 INTO l_ocs.*

          #-先判斷此張AR單據性質為'12' AND omb38 = '3'銷退 或是'21'折讓類
          #-如果為'12'and omb38 = '3'本身即為來源AR單號
          SELECT oma00,omb38 INTO l_oma00,l_omb38 
            FROM oma_file,omb_file
           WHERE oma01 = omb01
             AND omb01 = l_oct1.oct01
             AND omb03 = l_oct1.oct02
          IF l_oma00 = '21' THEN
              #折讓類應收每期沖轉數計算：
              #例:總遞延金額60元/分攤期數12期=每期5元 
              #(但要先檢查來源來據總遞延金額是否有異動與原本百分比計算金額不符)
              #來源出貨應收97/11月立帳，截止期別為98年10月
              #銷退日期為98/5月，至目前期別剩10-5 =5期,5期*每期沖轉5元=25
              #總遞延金額60元-25元=35元，為折讓當期沖轉金額
            
              SELECT oct01,oct02,oct09,oct10,oct12
                INTO g_oct01_o,g_oct02_o,g_oct09_s,g_oct10_s,g_oct12_o  #來源AR立帳年度/月份/總遞延金額 
                FROM oct_file  
               WHERE oct04 = l_oct1.oct04
                 AND oct05 = l_oct1.oct05
                 AND oct16 = '1'  
              SELECT omb16 INTO g_omb16   
                FROM omb_file
               WHERE omb01 = g_oct01_o 
                 AND omb03 = g_oct02_o
              LET l_percent = g_omb16/g_oct12_o  #重新計算來源AR售貨動作百分比
              IF NOT cl_null(l_percent) THEN
                  SELECT omb14,omb16 INTO g_omb14_n,g_omb16_n
                    FROM omb_file 
                   WHERE omb01 = l_oct1.oct01
                     AND omb03 = l_oct1.oct02   
                  LET l_oct15  = ((g_omb16_n * l_percent)/100)/l_ocs.ocs05
                  LET l_oct15f = ((g_omb14_n * l_percent)/100)/l_ocs.ocs05
                  LET l_oct15  = cl_digcut(l_oct15,g_azi04)
                  LET l_oct15f = cl_digcut(l_oct15f,t_azi04)
              ELSE
                  LET l_oct15  = (l_oct1.oct12 / l_ocs.ocs05)
                  LET l_oct15f = (l_oct1.oct12f / l_ocs.ocs05)
                  LET l_oct15  = cl_digcut(l_oct15,g_azi04)
                  LET l_oct15f = cl_digcut(l_oct15f,t_azi04)
              END IF
              #--沖轉截止年度期別---#
              LET i = 0
              FOR i = 1 TO l_ocs.ocs05
                  IF i = 1 THEN
                      LET g_oct09_e = g_oct09_s 
                      LET g_oct10_e = g_oct10_s
                      IF g_oct10_e >12 THEN 
                          LET g_oct09_e = g_oct09_e + 1 
                          LET g_oct10_e = 1
                      END IF
                  ELSE
                      LET g_oct09_e = g_oct09_e
                      LET g_oct10_e = g_oct10_e + 1
                      IF g_oct10_e >12 THEN 
                          LET g_oct09_e = g_oct09_e + 1 
                          LET g_oct10_e = 1
                      END IF
                  END IF
              END FOR   
              LET l_cnt1 = (g_oct09_e *12 ) + g_oct10_e  
              LET l_cnt2 = (l_oct1.oct09 * 12) + l_oct1.oct10
              LET l_c1_c2 = (l_cnt1 - l_cnt2 )   #折讓期別~截止期別差距期數 
              LET j = 0 
              FOR j = 1 TO l_c1_c2 +1 
                  IF j = 1 THEN 
                      LET l_oct.oct09 = l_oct1.oct09
                      LET l_oct.oct10 = l_oct1.oct10
                      LET l_oct.oct15 = l_oct1.oct12 - (l_c1_c2 * l_oct15)
                      LET l_oct.oct15f = l_oct1.oct12f - (l_c1_c2 * l_oct15f)
                  ELSE
                      IF l_oct.oct10 <> 12 THEN
                         LET l_oct.oct10 = l_oct.oct10 + 1
                         LET l_oct.oct09 = l_oct.oct09      
                      ELSE
                         LET l_oct.oct10 = 1
                         LET l_oct.oct09 = l_oct.oct09 + 1    
                      END IF
                      LET l_oct.oct15 = l_oct15
                      LET l_oct.oct15f = l_oct15f
                  END IF
                  LET l_oct.oct15  = cl_digcut(l_oct.oct15,g_azi04)
                  LET l_oct.oct15f = cl_digcut(l_oct.oct15,t_azi04)
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt 
                    FROM oct_file 
                   WHERE oct01 = l_oct.oct01
                     AND oct02 = l_oct.oct02
                     AND oct09 = l_oct.oct09
                     AND oct10 = l_oct.oct10
                     AND oct11 = l_oct.oct11
                     AND oct16 = l_oct.oct16
                     AND oct08 IS NULL
                  IF l_cnt > 0 THEN
                      CALL cl_getmsg('agl-961',g_lang) RETURNING l_msg1
                      LET l_msg=l_msg1 CLIPPED,l_oct.oct01,'/'
                      CALL cl_getmsg('agl-172',g_lang) RETURNING l_msg1
                      LET l_msg=l_msg CLIPPED,l_msg1 CLIPPED,l_oct.oct09,'/'
                      CALL cl_getmsg('agl-173',g_lang) RETURNING l_msg1
                      LET l_msg=l_msg CLIPPED,l_msg1 CLIPPED,l_oct.oct10
                      CALL cl_getmsg('agl-169',g_lang) RETURNING l_msg1
                      LET l_msg=l_msg CLIPPED,l_msg1
                      IF cl_confirm(l_msg) THEN
                          UPDATE oct_file SET oct15 = l_oct.oct15
                           WHERE oct01 = l_oct.oct01
                             AND oct02 = l_oct.oct02
                             AND oct09 = l_oct.oct09
                             AND oct10 = l_oct.oct10
                             AND oct11 = l_oct.oct11
                             AND oct16 = l_oct.oct16
                          UPDATE oct_file SET oct15f = l_oct.oct15f
                           WHERE oct01 = l_oct.oct01
                             AND oct02 = l_oct.oct02
                             AND oct09 = l_oct.oct09
                             AND oct10 = l_oct.oct10
                             AND oct11 = l_oct.oct11
                             AND oct16 = l_oct.oct16
                      ELSE
                         CONTINUE FOREACH
                      END IF
                  ELSE
                     SELECT oct08 INTO l_oct08
                       FROM oct_file
                      WHERE oct01 = l_oct.oct01
                        AND oct02 = l_oct.oct02
                        AND oct09 = l_oct.oct09
                        AND oct10 = l_oct.oct10
                        AND oct11 = l_oct.oct11
                       AND oct16 = l_oct.oct16
                     IF NOT cl_null(l_oct08) THEN
                        LET g_showmsg = l_oct.oct01,'/',l_oct.oct02,'/',l_oct.oct09,'/',l_oct.oct10,'/',l_oct.oct11
                        CALL s_errmsg('oct01,oct02,oct09,oct10,oct11',g_showmsg,'','agl-175',1)
                        CONTINUE FOREACH
                     ELSE
                        INSERT INTO oct_file VALUES(l_oct.*)
                        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                           CALL s_errmsg('oct01,oct02,oct09,oct10,oct11','ins oct','',SQLCA.SQLCODE,1)                      
                        END IF
                     END IF
                  END IF
              END FOR
          ELSE    #出貨類oct16 = '1' or oma00 = '12' AND omb38 = '3'銷退
              LET i = 0 
              FOR i = 1 TO l_ocs.ocs05   
                 IF i = 1 THEN   
                    LET l_oct.oct10 = l_oct1.oct10
                    LET l_oct.oct09 = l_oct1.oct09
                 ELSE
                    IF l_oct.oct10 <> 12 THEN
                       LET l_oct.oct10 = l_oct.oct10 + 1
                       LET l_oct.oct09 = l_oct.oct09      
                    ELSE
                       LET l_oct.oct10 = 1
                       LET l_oct.oct09 = l_oct.oct09 + 1    
                    END IF
                 END IF

                IF i = l_ocs.ocs05 THEN     #最後一期
                    IF l_oma00 = '12' AND l_omb38 = '2' THEN
                        SELECT SUM(oct14),SUM(oct14f) INTO l_amt2,l_amt2_f 
                          FROM oct_file 
                         WHERE oct01 = l_oct1.oct01
                           AND oct02 = l_oct1.oct02
                           AND oct11 = l_oct1.oct11
                           AND (oct16 <> '1' AND oct16 <> '3')
                        LET l_oct.oct14 = l_oct1.oct12 - l_amt2
                        LET l_oct.oct14f = l_oct1.oct12f - l_amt2_f
                    ELSE
                        SELECT SUM(oct15),SUM(oct15f) INTO l_amt2,l_amt2_f 
                          FROM oct_file 
                         WHERE oct01 = l_oct1.oct01
                           AND oct02 = l_oct1.oct02
                           AND oct11 = l_oct1.oct11
                           AND (oct16 <> '1' AND oct16 <> '3')
                        LET l_oct.oct15 = l_oct1.oct12 - l_amt2
                        LET l_oct.oct15f = l_oct1.oct12f - l_amt2_f
                    END IF
                ELSE
                    IF l_oma00 = '12' AND l_omb38 = '2' THEN
                        LET l_oct.oct14 = (l_oct1.oct12 / l_ocs.ocs05) 
                        LET l_oct.oct14f = (l_oct1.oct12f / l_ocs.ocs05) 
                    ELSE
                        LET l_oct.oct15 = (l_oct1.oct12 / l_ocs.ocs05) 
                        LET l_oct.oct15f = (l_oct1.oct12f / l_ocs.ocs05)
                    END IF
                END IF
                #FUN-A10005 產生每期沖轉金額時，應依幣別小數位取位且無條件取去不四捨五入--
                #LET l_oct.oct14  = cl_digcut(l_oct.oct14,g_azi04)
                #LET l_oct.oct14f = cl_digcut(l_oct.oct14f,t_azi04)
                #LET l_oct.oct15  = cl_digcut(l_oct.oct15,g_azi04)
                #LET l_oct.oct15f = cl_digcut(l_oct.oct15f,t_azi04)
                CALL t700_cut(l_oct.oct14,g_azi04) RETURNING l_oct.oct14
                CALL t700_cut(l_oct.oct14f,t_azi04) RETURNING l_oct.oct14f
                CALL t700_cut(l_oct.oct15,g_azi04) RETURNING l_oct.oct15
                CALL t700_cut(l_oct.oct15f,t_azi04) RETURNING l_oct.oct15f
                #FUN-A10005 end-----------------

                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt 
                  FROM oct_file 
                 WHERE oct01 = l_oct.oct01
                   AND oct02 = l_oct.oct02
                   AND oct09 = l_oct.oct09
                   AND oct10 = l_oct.oct10
                   AND oct11 = l_oct.oct11
                   AND oct16 = l_oct.oct16
                   AND oct08 IS NULL
                IF l_cnt > 0 THEN
                   CALL cl_getmsg('agl-961',g_lang) RETURNING l_msg1
                   LET l_msg=l_msg1 CLIPPED,l_oct.oct01,'/'
                   CALL cl_getmsg('agl-172',g_lang) RETURNING l_msg1
                   LET l_msg=l_msg CLIPPED,l_msg1 CLIPPED,l_oct.oct09,'/'
                   CALL cl_getmsg('agl-173',g_lang) RETURNING l_msg1
                   LET l_msg=l_msg CLIPPED,l_msg1 CLIPPED,l_oct.oct10
                   CALL cl_getmsg('agl-169',g_lang) RETURNING l_msg1
                   LET l_msg=l_msg CLIPPED,l_msg1
                   IF cl_confirm(l_msg) THEN
                      IF l_oct.oct16 = '2' THEN 
                         UPDATE oct_file SET oct14 = l_oct.oct14
                          WHERE oct01 = l_oct.oct01
                            AND oct02 = l_oct.oct02
                            AND oct09 = l_oct.oct09
                            AND oct10 = l_oct.oct10
                            AND oct11 = l_oct.oct11
                            AND oct16 = l_oct.oct16
                         UPDATE oct_file SET oct14f = l_oct.oct14f
                          WHERE oct01 = l_oct.oct01
                            AND oct02 = l_oct.oct02
                            AND oct09 = l_oct.oct09
                            AND oct10 = l_oct.oct10
                            AND oct11 = l_oct.oct11
                            AND oct16 = l_oct.oct16
                      ELSE
                         UPDATE oct_file SET oct15 = l_oct.oct15
                          WHERE oct01 = l_oct.oct01
                            AND oct02 = l_oct.oct02
                            AND oct09 = l_oct.oct09
                            AND oct10 = l_oct.oct10
                            AND oct11 = l_oct.oct11
                            AND oct16 = l_oct.oct16
                         UPDATE oct_file SET oct15f = l_oct.oct15f
                          WHERE oct01 = l_oct.oct01
                            AND oct02 = l_oct.oct02
                            AND oct09 = l_oct.oct09
                            AND oct10 = l_oct.oct10
                            AND oct11 = l_oct.oct11
                            AND oct16 = l_oct.oct16
                      END IF
                   ELSE
                      CONTINUE FOREACH
                   END IF
                ELSE
                   SELECT oct08 INTO l_oct08
                     FROM oct_file
                    WHERE oct01 = l_oct.oct01
                      AND oct02 = l_oct.oct02
                      AND oct09 = l_oct.oct09
                      AND oct10 = l_oct.oct10
                      AND oct11 = l_oct.oct11
                     AND oct16 = l_oct.oct16
                   IF NOT cl_null(l_oct08) THEN
                      LET g_showmsg = l_oct.oct01,'/',l_oct.oct02,'/',l_oct.oct09,'/',l_oct.oct10,'/',l_oct.oct11
                      CALL s_errmsg('oct01,oct02,oct09,oct10,oct11',g_showmsg,'','agl-175',1)
                      CONTINUE FOREACH
                   ELSE
                      INSERT INTO oct_file VALUES(l_oct.*)
                      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                         CALL s_errmsg('oct01,oct02,oct09,oct10,oct11','ins oct','',SQLCA.SQLCODE,1)                      
                      END IF
                   END IF
                END IF
             END FOR
          END IF
      END FOREACH
   END FOREACH
END FUNCTION

FUNCTION t700_get_dbs(p_oct17)
DEFINE p_oct17     LIKE oct_file.oct17
DEFINE l_azp03     LIKE azp_file.azp03
DEFINE l_dbs       LIKE type_file.chr20
DEFINE l_sql       LIKE type_file.chr1000
DEFINE l_plant     LIKE azp_file.azp01           #FUN-A50102

   SELECT azp03 INTO l_azp03                                           
     FROM azp_file                                                     
    WHERE azp01=p_oct17                                     
   LET l_plant = p_oct17                         #FUN-A50102  
   CALL s_dbstring(l_azp03) RETURNING l_dbs
  #RETURN l_azp03,l_dbs               #FUN-A50102
   RETURN l_azp03,l_plant             #FUN-A50102
END FUNCTION
#FUNCTION t700_ima02(p_dbs,p_oct03)            #FUN-A50102 mark
FUNCTION t700_ima02(p_plant,p_oct03)           #FUN-A50102  
DEFINE p_plant   LIKE azp_file.azp01           #FUN-A50102 
DEFINE p_dbs     LIKE type_file.chr20
DEFINE p_oct03   LIKE oct_file.oct03
DEFINE l_sql     LIKE type_file.chr1000
DEFINE l_ima02   LIKE ima_file.ima02
   LET l_sql=" SELECT ima02 ",
            #"   FROM ",p_dbs,"ima_file ",                   #FUN-A50102 
             "   FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102  
             "  WHERE ima01 = '",p_oct03,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                  #FUN-A50102 
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql          #FUN-A50102 
   PREPARE t700_pre5 FROM l_sql
   DECLARE t700_cs5 SCROLL CURSOR FOR t700_pre5
   OPEN t700_cs5
   FETCH t700_cs5 INTO l_ima02
   CLOSE t700_cs5
   RETURN l_ima02
END FUNCTION

#FUNCTION t700_oct02(p_dbs,p_oct01,p_oct02)             #FUN-A50102 mark
FUNCTION t700_oct02(p_plant,p_oct01,p_oct02)            #FUN-A50102 add 
DEFINE p_dbs     LIKE type_file.chr20
DEFINE p_plant   LIKE azp_file.azp01                    #FUN-A50102 
DEFINE p_oct01   LIKE oct_file.oct01
DEFINE p_oct02   LIKE oct_file.oct02
DEFINE l_sql     LIKE type_file.chr1000
DEFINE l_oma00   LIKE oma_file.oma00
DEFINE l_ima02   LIKE ima_file.ima02
DEFINE l_oma02   LIKE oma_file.oma02
DEFINE l_oct18   LIKE oct_file.oct18
DEFINE l_oct19   LIKE oct_file.oct19
DEFINE l_oct03   LIKE oct_file.oct03
DEFINE l_omb31   LIKE omb_file.omb31
DEFINE l_omb32   LIKE omb_file.omb32
   LET l_sql=" SELECT oma00,oma02,oma23,oma24,omb04 ",
            #"   FROM ",p_dbs,"oma_file,",p_dbs,"omb_file ",         #FUN-A50102 mark
             "   FROM ",cl_get_target_table(p_plant,'oma_file'),",", #FUN-A50102
                        cl_get_target_table(p_plant,'omb_file'),     #FUN-A50102 
             "  WHERE omb01=oma01 ",
             "    AND omb01='",p_oct01,"'",
             "    AND omb03='",p_oct02,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql       #FUN-A50102
   PREPARE t700_pre4 FROM l_sql
   DECLARE t700_cs4 SCROLL CURSOR FOR t700_pre4
   OPEN t700_cs4
   FETCH t700_cs4 INTO l_oma00,l_oma02,
       l_oct18,l_oct19,l_oct03
   CLOSE t700_cs4
 # CALL t700_ima02(p_dbs,l_oct03) RETURNING l_ima02          #FUN-A50102
   CALL t700_ima02(p_plant,l_oct03) RETURNING l_ima02        #FUN-A50102
   IF l_oma00 = '12' THEN
      LET l_sql=" SELECT omb31,omb32 ",
               #"   FROM ",p_dbs,"omb_file ",                        #FUN-A50102 mark
                "   FROM ",cl_get_target_table(p_plant,'omb_file'),  #FUN-A50102 
                "  WHERE omb01 = '",p_oct01,"'",
                "    AND omb03 = '",p_oct02,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql                   #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql           #FUN-A50102
      PREPARE t700_pre6 FROM l_sql
      DECLARE t700_cs6 SCROLL CURSOR FOR t700_pre6
      OPEN t700_cs6
      FETCH t700_cs6 INTO l_omb31,l_omb32
      CLOSE t700_cs6
      RETURN l_ima02,l_oct18,l_oct19,l_oct03,l_omb31,l_omb32,' ',' ',l_oma02
   ELSE
      LET l_sql=" SELECT ohb31,ohb32 ",
               #"   FROM ",p_dbs,"ohb_file ",                               #FUN-A50102 
                "   from ",cl_get_target_table(p_plant,'ohb_file'),         #FUN-A50102 add
                "  WHERE ohb01 = '",p_oct01,"' ",
                "    AND ohb03 = '",p_oct02,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql               #FUN-A50102
      CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql       #FUN-A50102 
      PREPARE t700_pre7 FROM l_sql 
      DECLARE t700_cs7 SCROLL CURSOR FOR t700_pre7
      OPEN t700_cs7
      FETCH t700_cs7 INTO l_omb31,l_omb32
      CLOSE t700_cs7
      RETURN l_ima02,l_oct18,l_oct19,l_oct03,' ',' ',l_omb31,l_omb32,l_oma02
   END IF
END FUNCTION
#FUNCTION t700_ocr02(p_dbs,p_oct11)                #FUN-A50102
FUNCTION t700_ocr02(p_plant,p_oct11)                #FUN-A50102
DEFINE p_plant        LIKE azp_file.azp01           #FUN-A50102 
DEFINE p_dbs          LIKE type_file.chr20
DEFINE p_oct11        LIKE oct_file.oct11
DEFINE l_ocr02        LIKE ocr_file.ocr02
DEFINE l_sql     LIKE type_file.chr1000
   LET l_sql=" SELECT ocr02 ",
            #"   FROM ",p_dbs,"ocr_file ",             #FUN-A50102 mark
             "   FROM ",cl_get_target_table(p_plant,'ocr_file'),  #FUN-A50102 	   
             "  WHERE ocr01 = '",p_oct11,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql                   #FUN-A50102
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql           #FUN-A50102
   PREPARE t700_pre9 FROM l_sql
   DECLARE t700_cs9 SCROLL CURSOR FOR t700_pre9
   OPEN t700_cs9
   FETCH t700_cs9 INTO l_ocr02
   CLOSE t700_cs9
   RETURN l_ocr02
END FUNCTION
#No.FUN-9A0036

#--FUN-A10005 start----
FUNCTION t700_cut(p_str,p_azi04)
DEFINE p_str     STRING
DEFINE l_dot     STRING
DEFINE l_integer STRING
DEFINE l_str     STRING
DEFINE l_a       LIKE type_file.num5
DEFINE l_b       LIKE type_file.num5
DEFINE l_fillin  STRING
DEFINE l_dot_length LIKE type_file.num5
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_length  LIKE type_file.num5
DEFINE p_azi04   LIKE azi_file.azi04
DEFINE l_num     LIKE oct_file.oct14

   LET l_fillin = p_str
   LET l_length = l_fillin.getLength()   #總長度
   LET l_a = l_fillin.getIndexOf('.',1)  #小數點所在位置 
   IF l_a <> 0 THEN  #有小數
       LET l_dot = l_fillin.subString(l_a+1,l_length)   #小數值
       LET l_integer = l_fillin.subString(1,l_a-1)      #整數值
       LET l_dot_length = l_dot.getLength()             #小數位長度
       LET l_dot = l_dot.subString(1,p_azi04)   #小數值
       LET l_fillin = l_integer.trim(),'.',l_dot.trim()
   ELSE
      LET l_fillin = l_integer
   END IF
   LET l_num = l_fillin
   RETURN l_num
END FUNCTION
#--FUN-A10005 end-------------


