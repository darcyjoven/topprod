# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: almi550.4gl
# Descriptions...: 卡種維護作業
# Date & Author..: FUN-870015 2008/07/28 By shiwuying
# Modify.........: No:FUN-960134 09/07/14 By shiwuying 市場移植
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:TQC-A10125 10/01/15 By shiwuying 新增时旧值清空
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A60046 10/06/11 By chenmoyan UPDATE日期型為''時,MSV資料有誤
# Modify.........: No.FUN-A80022 10/09/15 BY suncx add lphpos
# Modify.........: No.FUN-A80022 10/10/18 By vealxu mod lph27 ->lphpos 
# Modify.........: No.TQC-AB0335 10/11/30 By huangtao
# Modify.........: No.TQC-AC0079 10/12/08 By huangtao 5.25版前測試
# Modify.........: No.MOD-AC0215 10/12/18 By suncx 當固定代號位數輸入0時，管控固定代號可不輸入
# Modify.........: No.TQC-B30004 11/03/10 By suncx 取消已傳POS否
# Modify.........: No.TQC-B30154 11/03/18 By huangtao 審核時候 若無生效營運中心 則提示請輸入生效範圍，不允許審核
# Modify.........: No.TQC-B30204 11/03/10 By suncx 恢復已傳POS邏輯
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No:TQC-B50033 11/05/10 by destiny 栏位设定管控  
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60207 11/06/20 By baogc 添加指定日欄位的管控
# Modify.........: No.FUN-BC0112 12/01/11 By chenwei 新增欄位以及欄位的控管和位置調整
# Modify.........: No.FUN-BA0070 12/01/17 By pauline 增加lph37,lph38,lph39
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30042 12/03/21 By pauline lph09調整 0.無效期限制  1.指定日期  2.指定長度
# Modify.........: No:FUN-C50014 12/05/04 By pauline 消費金額底限改成不可小於 0
# Modify.........: No:FUN-C50027 12/05/08 By pauline 當設定為"3.指定日期清零"時，則  lph20 為必輸入，且輸入的值要 >=0
# Modify.........: No.FUN-C50058 12/05/15 By pauline 增加每次儲值最高金額以及總儲值金額欄位
# Modify.........: No.FUN-C30176 12/06/14 By pauline 加入 '換卡手續費' (lph45)欄位
# Modify.........: No.FUN-C70077 12/07/18 By baogc 根據代號位數和固定代號位自動帶出數流水號位數
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-C90124 12/09/29 By baogc 積分與延長規則邏輯調整
# Modify.........: No:FUN-CA0103 12/10/26 By xumeimei 添加设置密码否栏位
# Modify.........: No:FUN-D10021 13/01/08 By dongsz mark固定編號不可重複的控管
# Modify.........: No:FUN-D20085 13/03/01 By pauline 增加lph47,lph48欄位
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lph       RECORD LIKE lph_file.*,
       g_lph_t     RECORD LIKE lph_file.*,
       g_lph01_t   LIKE lph_file.lph01,
       g_wc        STRING,
       g_sql       STRING
 
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE g_chr                 LIKE lph_file.lphacti
DEFINE g_void                LIKE type_file.chr1
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask             LIKE type_file.num5
 
MAIN
   DEFINE cb ui.ComboBox
 
   OPTIONS
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_lph.* TO NULL
 
   LET g_forupd_sql="SELECT * FROM lph_file WHERE lph01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i550_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i550_w WITH FORM "alm/42f/almi550"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
  #TQC-B30004 ------mark--begin----------------
  #No.FUN-A80022 Begin--- By shi
    IF g_aza.aza88 = 'Y' THEN
      CALL cl_set_comp_visible("lphpos",TRUE)
    ELSE
      CALL cl_set_comp_visible("lphpos",FALSE)
    END IF
  ##No.FUN-A80022 End-----
  #TQC-B30004 ------mark--end----------------
  #CALL cl_set_comp_visible("lphpos",FALSE)  #TQC-B30004 add  #TQC-B30204 mark
   LET cb = ui.ComboBox.forname("lph24")
   CALL cb.removeitem("X")
   LET g_action_choice = ""
   CALL i550_menu()
   CLOSE WINDOW i550_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i550_curs()
    CLEAR FORM
    INITIALIZE g_lph.* TO NULL
    CONSTRUCT BY NAME g_wc ON lph01,lph02,lphpos,lph04,lph06,lph37,lph38,lph39,lph03,lph36,lph30,lph46,    #FUN-A80022 mod lph27->lphpos  #FUN-CA0103 add lph46
                              lph43,lph44,                                                                 #FUN-C50058 add
                              lph05,lph08,lph07,lph40,lph41,lph42,lph28,lph29,lph17,lph18,lph19,
                              lph31,lph311,lph20,lph24,lph25,lph26,lph09,lph10,lph11,   
                              lph12,lph13,lph14,lph15,lph16,lph32,lph33,lph34,
                              lph35,lph21,lph22,lph23,lph45,lph47,lph48,lphuser,lphgrup,   #FUN-C30176 add lph45  #FUN-D20085 add lph47,lph48
                              lphoriu,lphorig,lphcrat,lphmodu,lphacti,lphdate      #FUN-BC0112 add lph37,lph38,lph39,lph40,lph41,lph42           
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(lph01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lph01"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO lph01
                NEXT FIELD lph01 
            
            #add START 
             WHEN INFIELD(lph47)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lph47"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO lph47
                NEXT FIELD lph47

             WHEN INFIELD(lph48)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lph48"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO lph48
                NEXT FIELD lph48
            #add END
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
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN 
    #            LET g_wc = g_wc clipped," AND lphuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN  
    #        LET g_wc = g_wc clipped," AND lphgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND lphgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lphuser', 'lphgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT lph01 FROM lph_file ",
        " WHERE ",g_wc CLIPPED, 
        " ORDER BY lph01"
    PREPARE i550_prepare FROM g_sql
    DECLARE i550_cs    
        SCROLL CURSOR WITH HOLD FOR i550_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM lph_file WHERE ",g_wc CLIPPED
    PREPARE i550_precount FROM g_sql
    DECLARE i550_count CURSOR FOR i550_precount
END FUNCTION
 
FUNCTION i550_menu()
   DEFINE l_cmd  LIKE type_file.chr1000 
   DEFINE l_msg  LIKE type_file.chr1000
   MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i550_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i550_q()
            END IF
        ON ACTION next
            CALL i550_fetch('N')
        ON ACTION previous
            CALL i550_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i550_u("u")
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i550_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i550_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL i550_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()THEN
           #    CALL i550_out()
            END IF
        ON ACTION confirm 
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
                CALL i550_y()
           END IF 
        ON ACTION undo_confirm  
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i550_z()
            END IF

       #ON ACTION void
       #   LET g_action_choice="void"
       #   IF cl_chk_act_auth() THEN
       #      CALL i550_v()
       #   END IF
        ON ACTION category
           LET g_action_choice="category"
           IF cl_chk_act_auth() THEN
              IF g_lph.lph01 IS NULL THEN
                 CALL cl_err('',-400,0)
              ELSE
                 LET l_msg = "almi551  '",g_lph.lph01 CLIPPED,"'  '1' " 
                 CALL cl_cmdrun_wait(l_msg)
              END IF
           END IF
       #ON ACTION range_query 
       #   LET g_action_choice="range_query"
       #   IF cl_chk_act_auth() THEN
       #      IF g_lph.lph01 IS NULL THEN
       #         CALL cl_err('',-400,0)
       #      ELSE
       #         LET l_msg = "almi5502  '",g_lph.lph01 CLIPPED,"'  '4' "
       #         CALL cl_cmdrun_wait(l_msg)
       #      END IF
       #   END IF
        
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i550_fetch('/')
        ON ACTION first
            CALL i550_fetch('F')
        ON ACTION last
            CALL i550_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
        ON ACTION about
           CALL cl_about()
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE 
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document 
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_lph.lph01 IS NOT NULL THEN
                 LET g_doc.column1 = "lph01"
                 LET g_doc.value1 = g_lph.lph01
                 CALL cl_doc()
              END IF
           END IF
 
     END MENU
     CLOSE i550_cs
END FUNCTION
 
FUNCTION i550_a()
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_lph.* LIKE lph_file.*
    LET g_lph_t.* = g_lph.*  #No.TQC-A10125
    LET g_lph01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lph.lph03 = 'N'
        LET g_lph.lph04 = 'N'
        LET g_lph.lph05 = 'N'
        LET g_lph.lph06 = 'N'
        LET g_lph.lph07 = 'N'
        LET g_lph.lph12 = 'N'
        LET g_lph.lph17 = '0'
        LET g_lph.lph24 = 'N'
        #LET g_lph.lphpos = 'N'         #FUN-A80022 mod lph27 -> lphpos
        LET g_lph.lphpos = '1'          #FUN-B40071
        LET g_lph.lph27  = ' '
        LET g_lph.lph36 = 'N'
        LET g_lph.lph46 = 'N'           #FUN-CA0103
#FUN-BC0112 ------------------STA
        LET g_lph.lph37 = 'N'
        LET g_lph.lph38 = 1
        LET g_lph.lph39 = 1
        LET g_lph.lph41 = 0
        LET g_lph.lph42 = 0
        LET g_lph.lph40 = 'N' 
        LET g_lph.lph45 = 0   #FUN-C30176 add   #換卡手續費 
#FUN-BC0112 ------------------END
        LET g_lph.lphuser = g_user
        LET g_lph.lphoriu = g_user #FUN-980030
        LET g_lph.lphorig = g_grup #FUN-980030
        LET g_lph.lphgrup = g_grup 
        LET g_lph.lphacti = 'Y'
        LET g_lph.lphcrat = g_today
        CALL i550_i("a") 
        IF INT_FLAG THEN 
            INITIALIZE g_lph.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lph.lph01 IS NULL THEN 
            CONTINUE WHILE
        END IF
       #FUN-C50058 add START
        IF g_lph.lph03 = 'N' THEN
           IF cl_null(g_lph.lph43) THEN LET g_lph.lph43 = 0 END IF
           IF cl_null(g_lph.lph44) THEN LET g_lph.lph44 = 0 END IF
        ELSE
           IF cl_null(g_lph.lph43) THEN LET g_lph.lph43 = 9999 END IF
           IF cl_null(g_lph.lph44) THEN LET g_lph.lph44 = 9999 END IF
        END IF 
       #FUN-C50058 add END
        INSERT INTO lph_file VALUES(g_lph.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lph_file",g_lph.lph01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        ELSE
           SELECT * INTO g_lph.* FROM lph_file
                        WHERE lph01 = g_lph.lph01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i550_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_input   LIKE type_file.chr1,
            l_n       LIKE type_file.num5 
   DEFINE   l_gec04   LIKE gec_file.gec04  #FUN-D20085 add
  
   DISPLAY BY NAME
      g_lph.lph24,g_lph.lphuser,g_lph.lphacti,g_lph.lphgrup,
      g_lph.lphdate,g_lph.lphcrat,g_lph.lphpos,g_lph.lph36,g_lph.lph37,g_lph.lph38,g_lph.lph39,           #FUN-A80022 mod lph27 ->lphpos   #FUN-BA0070 add lph38,39
      g_lph.lph45,g_lph.lph47,g_lph.lph48   #FUN-C30176 add   #FUN-D20085 add lph47,lph48 
   INPUT BY NAME g_lph.lphoriu,g_lph.lphorig,
      g_lph.lph01,g_lph.lph02,g_lph.lphpos,g_lph.lph04,g_lph.lph06,g_lph.lph37,g_lph.lph38,g_lph.lph39,g_lph.lph03,   #FUN-A80022 mod lph27 ->lphpos  
      g_lph.lph36,g_lph.lph30,g_lph.lph46,g_lph.lph43,g_lph.lph44,                                                    #FUN-C50058 add lph43,lph44  ##FUN-CA0103 add lph46
      g_lph.lph05,g_lph.lph08,g_lph.lph07,g_lph.lph40,g_lph.lph41,g_lph.lph42,g_lph.lph28,
      g_lph.lph29,g_lph.lph17,g_lph.lph18,g_lph.lph19,g_lph.lph31,g_lph.lph311,g_lph.lph20,                            #FUN-BC0112 add lph37,lph38,lph39,lph40,lph41,lph42
      g_lph.lph09,g_lph.lph10,g_lph.lph11,g_lph.lph12,g_lph.lph13,g_lph.lph14,          
      g_lph.lph15,g_lph.lph16,g_lph.lph32,g_lph.lph33,g_lph.lph34,g_lph.lph35,
      g_lph.lph21,g_lph.lph22,g_lph.lph23,g_lph.lph45,         #FUN-C30176 add lph45 
      g_lph.lph47,g_lph.lph48   #FUN-D20085 add
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i550_set_entry(p_cmd)
          CALL i550_set_no_entry(p_cmd)
          CALL i550_set_entry_lph03()
          CALL i550_set_entry_lph05()
          CALL i550_set_entry_lph06()
          CALL i550_set_entry_lph37()          #FUN-BC0112 add
          CALL i550_set_entry_lph40()          #FUN-BC0112 add
          CALL i550_set_entry_lph36()
          CALL i550_set_entry_lph09()
          CALL i550_set_entry_lph12()
          CALL i550_set_entry_lph13()
          CALL i550_set_entry_lph17()
          CALL i550_set_entry_lph21()
          LET g_before_input_done = TRUE
       #No.FUN-A80022 Begin---
       #  IF g_aza.aza88 = 'Y' THEN
       #     LET g_lph.lph27 = 'Y'
       #  ELSE
       #     LET g_lph.lph27 = 'N'
       #  END IF
       #  DISPLAY BY NAME g_lph.lphpos
       #No.FUN-A80022 End-----
 
      AFTER FIELD lph01
         IF g_lph.lph01 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd="u" AND g_lph.lph01 != g_lph01_t)THEN
               SELECT COUNT(*) INTO l_n FROM lph_file 
                WHERE lph01 = g_lph.lph01 
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD lph01
               END IF
            END IF
         END IF
 
      AFTER FIELD lph03
         IF NOT cl_null(g_lph.lph03) THEN
            CALL i550_set_entry_lph03()
         END IF
     #TQC-B50033--begin
     ON CHANGE lph03
         CALL i550_set_entry_lph03() #TQC-B50033
     #TQC-B50033--end
      BEFORE FIELD lph07 
         LET g_errno = ''
 
       ON CHANGE lph07
          LET g_errno = ''
          
      AFTER FIELD lph07
         IF g_lph.lph07 IS NOT NULL THEN
            IF g_lph.lph03 = '0' AND g_lph.lph07 = 'Y' THEN
               LET g_lph.lph07 = 'N'
               DISPLAY BY NAME g_lph.lph07
               CALL cl_err(g_lph.lph07,'alm-462',0)
               NEXT FIELD lph07
            END IF
         END IF
 
      AFTER FIELD lph08
         IF g_lph.lph08 IS NOT NULL THEN
            IF g_lph.lph08 <0 OR g_lph.lph08 >100 THEN
               CALL cl_err(g_lph.lph08,'mfg4013',0)
               NEXT FIELD lph08
            END IF
         END IF

     #AFTER FIELD lph04
     #   #超市中會員價和可折扣只能選擇其中一種！
     #   IF g_lph.lph04 = 'Y' AND g_lph.lph05 = 'Y' THEN
     #      CALL cl_err('','alm-356',0)
     #      LET g_lph.lph04 = 'N'
     #      NEXT FIELD lph04
     #   END IF
#TQC-AC0079 -----------STA
     ON CHANGE lph04
        IF g_lph.lph36 = 'Y' AND g_lph.lph04 = 'Y' THEN
           CALL cl_err('','alm-356',0)
           LET g_lph.lph04 = 'N'
           NEXT FIELD lph04
         END IF
#TQC-AC0079 -----------END 

#FUN-BC0112---mark------
#      AFTER FIELD lph05
#         IF g_lph.lph05 IS NOT NULL THEN
#         #  IF g_lph.lph04 = 'Y' AND g_lph.lph05 = 'Y' THEN
#         #     CALL cl_err('','alm-356',0)
#         #     LET g_lph.lph05 = 'N'
#         #     NEXT FIELD lph05
#         #  ELSE
#               CALL i550_set_entry_lph05()
#         #  END IF
#         END IF
#     #TQC-B50033--begin
#     ON CHANGE lph05
#         CALL i550_set_entry_lph05() 
#     #TQC-B50033--end 
#
#FUN-BC0112--end---- 
#FUN-BC0112----add---
#     AFTER FIELD lph05
#     IF  NOT cl_null(g_lph.lph05)  THEN
#            CALL i550_set_entry_lph05()
#        END IF
        ON CHANGE lph05
          IF g_lph.lph40 = 'Y' AND g_lph.lph05 = 'Y' THEN
             CALL cl_err('','alm-h08',0)
             LET g_lph.lph05 = 'N'
             NEXT FIELD lph05
          END IF
          IF NOT cl_null(g_lph.lph05) THEN
             CALL i550_set_entry_lph05()
          END IF
#FUN-BC0112---end----     
#     AFTER FIELD lph36
#        IF NOT cl_null(g_lph.lph06) THEN
#           CALL i550_set_entry_lph36()
#        END IF
#TQC-AC0079 -----------STA
       ON CHANGE lph36
          IF g_lph.lph36 = 'Y' AND g_lph.lph04 = 'Y' THEN
             CALL cl_err('','alm-356',0)
             LET g_lph.lph36 = 'N'
             NEXT FIELD lph36
          END IF
          IF NOT cl_null(g_lph.lph06) THEN
             CALL i550_set_entry_lph36()
          END IF
#TQC-AC0079 -----------END
 
      AFTER FIELD lph06
         IF NOT cl_null(g_lph.lph06) THEN
            CALL i550_set_entry_lph06()
           #TQC-C90124 Add Begin ---
            IF NOT cl_null(g_lph.lph13) THEN
               IF g_lph.lph06 = 'N' AND g_lph.lph13 = '0' THEN
                  CALL cl_err('','art1081',0)
                  NEXT FIELD lph06
               END IF
            END IF
           #TQC-C90124 Add End -----
         END IF
#FUN-BC0112-add--start----
      ON CHANGE lph37
         CALL i550_set_entry_lph37()

      ON CHANGE lph40
          IF g_lph.lph40 = 'Y' AND g_lph.lph05 = 'Y' THEN
             CALL cl_err('','alm-h08',0)
             LET g_lph.lph40 = 'N'
             NEXT FIELD lph40
          END IF
          CALL i550_set_entry_lph40()

#FUN-BC0112-add--end---         
     #TQC-B50033--begin
     ON CHANGE lph06
         CALL i550_set_entry_lph06() #TQC-B50033
     #TQC-B50033--end         
 
      AFTER FIELD lph28
         IF NOT cl_null(g_lph.lph28) THEN
            IF g_lph.lph28 <= 0 THEN
               CALL cl_err('lph28:','alm-468',0)
               NEXT FIELD lph28
            END IF
         END  IF
 
      AFTER FIELD lph29
         IF NOT cl_null(g_lph.lph29) THEN
            IF g_lph.lph29 <= 0 THEN
               CALL cl_err('lph29:','alm-468',0)
               NEXT FIELD lph29
            END IF
         END IF
   #TQC-AB0335 ----------------------STA
   #  AFTER FIELD lph09
   #     IF g_lph.lph09 IS NOT NULL THEN
   #        CALL i550_set_entry_lph09()
   #     END IF
      ON CHANGE lph09
         IF g_lph.lph09 IS NOT NULL THEN
            CALL i550_set_entry_lph09()
         END IF
   #TQC-AB0335 ----------------------END
     
      AFTER FIELD lph10
         IF NOT cl_null(g_lph.lph10) THEN
            IF g_lph.lph10 < g_today THEN
               CALL cl_err(g_lph.lph10,'alm-531',0)
               NEXT FIELD lph10
            END IF
         END IF
 
      AFTER FIELD lph11
         IF NOT cl_null(g_lph.lph11) THEN
            IF g_lph.lph11 <= 0 THEN
               CALL cl_err(g_lph.lph10,'alm-468',0)
               NEXT FIELD lph10
            END IF
         END IF
  
#TQC-AB0335------------------STA
#     AFTER FIELD lph12
#        IF g_lph.lph12 IS NOT NULL THEN
#           CALL i550_set_entry_lph12()
#        END IF
      
      ON CHANGE lph12
         IF g_lph.lph12 IS NOT NULL THEN
            CALL i550_set_entry_lph12()
         END IF
#TQC-AB0335 -----------------END
      
      AFTER FIELD lph13
         IF g_lph.lph13 IS NOT NULL THEN
            CALL i550_set_entry_lph13()
           #TQC-C90124 Add Begin ---
            IF NOT cl_null(g_lph.lph06) THEN
               IF g_lph.lph06 = 'N' AND g_lph.lph13 = '0' THEN
                  CALL cl_err('','art1082',0)
                  NEXT FIELD lph13
               END IF
            END IF
           #TQC-C90124 Add End -----
         END IF 
     #TQC-B50033--begin
     ON CHANGE lph13
         CALL i550_set_entry_lph13() 
     #TQC-B50033--end        
      
      AFTER FIELD lph14
         IF g_lph.lph14 IS NOT NULL THEN
            IF g_lph.lph14 <0  THEN
               CALL cl_err(g_lph.lph14,'alm-061',0)
               NEXT FIELD lph14
            END IF
         END IF
         
      AFTER FIELD lph15
         IF g_lph.lph15 IS NOT NULL THEN
            IF g_lph.lph15 <0 THEN
               CALL cl_err(g_lph.lph15,'alm-061',0)
               NEXT FIELD lph15
            END IF
         END IF
         
      AFTER FIELD lph16
         IF g_lph.lph16 IS NOT NULL THEN
            IF g_lph.lph16 <0 THEN
               CALL cl_err(g_lph.lph16,'alm-061',0)
               NEXT FIELD lph16
            END IF
         END IF
      
      AFTER FIELD lph17
         IF g_lph.lph17 IS NOT NULL THEN
            CALL i550_set_entry_lph17()
         END IF
         
     #TQC-B50033--begin
     ON CHANGE lph17
         CALL i550_set_entry_lph17() 
     #TQC-B50033--end    
           
      AFTER FIELD lph18
         IF g_lph.lph18 IS NOT NULL THEN
            IF g_lph.lph18 < 1 THEN
               CALL cl_err(g_lph.lph18,'alm-286',0)
               NEXT FIELD lph18
            END IF
         END IF
      
      AFTER FIELD lph19
         IF g_lph.lph19 IS NOT NULL THEN
            IF g_lph.lph19 < 1 THEN
               CALL cl_err(g_lph.lph19,'alm-286',0)
               NEXT FIELD lph19
            END IF
         END IF
      
      AFTER FIELD lph20
         IF g_lph.lph20 IS NOT NULL THEN
           #IF g_lph.lph20 < 1 THEN  #FUN-C50027 mark
            IF g_lph.lph20 < 0 THEN  #FUN-C50027 add
              #CALL cl_err(g_lph.lph20,'alm-286',0)  #FUN-C50027 mark
               CALL cl_err(g_lph.lph20,'aec-020',0)  #FUN-C50027 add
               NEXT FIELD lph20
            END IF
         END IF
 
#TQC-AB0335 --------------STA     
#     AFTER FIELD lph21
#        IF g_lph.lph21 IS NOT NULL THEN
#           CALL i550_set_entry_lph21()
#        END IF

      ON CHANGE lph21
         IF g_lph.lph21 IS NOT NULL THEN
            CALL i550_set_entry_lph21()
         END IF
#TQC-AB0335 --------------END
      
      AFTER FIELD lph22
         IF g_lph.lph22 IS NOT NULL THEN
           #IF g_lph.lph22 <= 0 THEN  #FUN-C50014 mark 
           #FUN-C50014 add START
            IF g_lph.lph22 = 0 THEN
               IF NOT cl_confirm('alm-h25') THEN
                  NEXT FIELD lph22
               END IF
            END IF
            IF g_lph.lph22 < 0 THEN
           #FUN-C50014 add END    
              #CALL cl_err(g_lph.lph22,'alm-468',0)  #FUN-C50014 mark
               CALL cl_err(g_lph.lph22,'aec-020',0)  #FUN-C50014 add 
               NEXT FIELD lph22
            END IF
         END IF
      
      AFTER FIELD lph23
         IF g_lph.lph23 IS NOT NULL THEN
            IF g_lph.lph23 <  0 THEN
               CALL cl_err(g_lph.lph23,'alm-061',0)
               NEXT FIELD lph23
            END IF
         END IF
 
      AFTER FIELD lph31
         IF NOT cl_null(g_lph.lph31) THEN
         #  IF g_lph.lph31 < 0 OR g_lph.lph31 > 12 THEN     #TQC-B60207 MARK
            IF g_lph.lph31 < 1 OR g_lph.lph31 > 12 THEN     #TQC-B60207 ADD
               CALL cl_err(g_lph.lph31,'aom-580',0)
               NEXT FIELD lph31
            END IF
#-TQC-B60207- ADD - BEGIN ------------------------
            IF NOT cl_null(g_lph.lph311) THEN
               IF g_lph.lph31 = 2 THEN
                  IF g_lph.lph311 > 29 THEN
                     CALL cl_err('','alm-437',0)
                     NEXT FIELD lph311
                  END IF
               END IF
               IF g_lph.lph31 = 4 OR g_lph.lph31 = 6 OR g_lph.lph31 = 9 OR g_lph.lph31 = 11 THEN
                  IF g_lph.lph311 > 30 THEN
                     CALL cl_err('','alm-437',0)
                     NEXT FIELD lph311
                  END IF
               END IF
            END IF
#-TQC-B60207- ADD -  END  ------------------------
         END IF

      AFTER FIELD lph311
         IF NOT cl_null(g_lph.lph311) THEN
         #  IF g_lph.lph311 < 0 OR g_lph.lph311 > 31 THEN   #TQC-B60207 MARK
            IF g_lph.lph311 < 1 OR g_lph.lph311 > 31 THEN   #TQC-B60207 ADD
#               CALL cl_err(g_lph.lph311,'apy-000',0)     #CHI-B40058
               CALL cl_err(g_lph.lph311,'alm-729',0)      #CHI-B40058
               NEXT FIELD lph311
            END IF
#-TQC-B60207- ADD - BEGIN ------------------------
            IF NOT cl_null(g_lph.lph31) THEN
               IF g_lph.lph31 = 2 THEN
                  IF g_lph.lph311 > 29 THEN
                     CALL cl_err('','alm-437',0)
                     NEXT FIELD lph311
                  END IF
               END IF
               IF g_lph.lph31 = 4 OR g_lph.lph31 = 6 OR g_lph.lph31 = 9 OR g_lph.lph31 = 11 THEN
                  IF g_lph.lph311 > 30 THEN
                     CALL cl_err('','alm-437',0)
                     NEXT FIELD lph311
                  END IF
               END IF
            END IF
#-TQC-B60207- ADD -  END  ------------------------
         END IF
 
      AFTER FIELD lph32
         IF NOT cl_null(g_lph.lph32) THEN
            IF g_lph.lph32 < 0 OR g_lph.lph32 > 30 THEN
               CALL cl_err('','alm-576',0)
               NEXT FIELD lph32
            END IF
            CALL i550_lph32(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lph.lph32,g_errno,1)
               LET g_lph.lph32 = g_lph_t.lph32
               NEXT FIELD lph32
            END IF
         END IF
            
      AFTER FIELD lph33
         IF NOT cl_null(g_lph.lph33) THEN
            IF g_lph.lph33 < 0 OR g_lph.lph33 > 30 THEN
               CALL cl_err('','alm-576',0)
               NEXT FIELD lph33
            END IF
            CALL i550_lph32(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lph.lph33,g_errno,1)
               LET g_lph.lph33 = g_lph_t.lph33
               NEXT FIELD lph33
            END IF
            CALL cl_set_comp_entry("lph34",g_lph.lph33 <> 0)    #MOD-AC0215 add

         END IF
 
      AFTER FIELD lph34
         IF NOT cl_null(g_lph.lph34) THEN
            CALL i550_lph32(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lph.lph34,g_errno,1)
               LET g_lph.lph34 = g_lph_t.lph34
               NEXT FIELD lph34
            END IF
         END IF
 
      AFTER FIELD lph35
         IF NOT cl_null(g_lph.lph35) THEN
            IF g_lph.lph35 < 0 OR g_lph.lph35 > 30 THEN
               CALL cl_err('','alm-576',0)
               NEXT FIELD lph35
            END IF
            CALL i550_lph32(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lph.lph35,g_errno,1)
               LET g_lph.lph35 = g_lph_t.lph35
               NEXT FIELD lph35
            END IF
         END IF
#FUN-BA0112-add--start---
    AFTER FIELD lph38
       IF g_lph.lph38 IS NOT NULL THEN
           #IF g_lph.lph38 <0 THEN  #FUN-BA0070 mark
            IF g_lph.lph38 < = 0 THEN  #FUN-BA0070 add
               CALL cl_err(g_lph.lph38,'alm-061',0)
               NEXT FIELD lph38
            END IF
         END IF

    AFTER FIELD lph39
       IF g_lph.lph39 IS NOT NULL THEN
           #IF g_lph.lph39 <0 THEN  #FUN-BA0070 mark
            IF g_lph.lph39 < = 0 THEN  #FUN-BA0070 add
               CALL cl_err(g_lph.lph39,'alm-061',0)
               NEXT FIELD lph39
            END IF
         END IF


    AFTER FIELD lph41
       IF g_lph.lph41 IS NOT NULL THEN
            IF g_lph.lph41 < = 0 THEN
               CALL cl_err(g_lph.lph41,'aec-020',0)
               NEXT FIELD lph41
            END IF
         END IF

    AFTER FIELD lph42
       IF g_lph.lph42 IS NOT NULL THEN
            IF g_lph.lph42 < = 0 THEN
               CALL cl_err(g_lph.lph42,'aec-020',0)
               NEXT FIELD lph42
            END IF
         END IF
#FUN-add-add--end---
     #FUN-C50058 add START
      AFTER FIELD lph43
         IF NOT cl_null(g_lph.lph43) THEN
            IF NOT cl_null(g_lph.lph44) THEN
               IF g_lph.lph44 < g_lph.lph43 THEN
                  CALL cl_err('','alm-h28',0) 
                  NEXT FIELD lph43
               END IF
            END IF
            IF g_lph.lph43 <= 0 THEN
               CALL cl_err('','alm-h29',0)
               NEXT FIELD lph43
            END IF 
         END IF

      AFTER FIELD lph44
         IF NOT cl_null(g_lph.lph44) THEN
            IF NOT cl_null(g_lph.lph43) THEN
               IF g_lph.lph44 < g_lph.lph43 THEN
                  CALL cl_err('','alm-h28',0)
                  NEXT FIELD lph44
               END IF
            END IF
            IF g_lph.lph44 <= 0 THEN
               CALL cl_err('','alm-h29',0)
               NEXT FIELD lph44
            END IF
         END IF
     #FUN-C50058 add END

     #FUN-C30176 add START
      AFTER FIELD lph45 
         IF NOT cl_null(g_lph.lph45) THEN
            IF g_lph.lph45 < 0 THEN
               CALL cl_err('','aec-020',0)
               NEXT FIELD lph45
            END IF
         END IF
     #FUN-C30176 add END

     #FUN-D20085 add START
      AFTER FIELD lph47
         IF NOT cl_null(g_lph.lph47) THEN
            LET l_n = 0 
            SELECT COUNT(*) INTO l_n FROM gec_file
              WHERE gec01 = g_lph.lph47
                AND gec011 = '2'
            IF cl_null(l_n) OR l_n = 0 THEN
               CALL cl_err('','alm-921',0)
               NEXT FIELD lph47 
            END IF 
            CALL i550_lph47("d")
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD lph47
            END IF
         END IF
       
      AFTER FIELD lph48
         IF NOT cl_null(g_lph.lph48) THEN
            LET l_gec04 = 0 
            SELECT gec04 INTO l_gec04 FROM gec_file
              WHERE gec01 = g_lph.lph48
                AND gec011 = '2'
            IF l_gec04 > 0 THEN
               CALL cl_err('','alm-a03',0)
               NEXT FIELD lph48 
            END IF
            CALL i550_lph47("d")
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD lph48
            END IF
         END IF
     #FUN-D20085 add END

      AFTER INPUT
         LET g_lph.lphuser = s_get_data_owner("lph_file") #FUN-C10039
         LET g_lph.lphgrup = s_get_data_group("lph_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_lph.lph01 IS NULL THEN
               DISPLAY BY NAME g_lph.lph01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD lph01
            END IF
        #FUN-C50058 add START
         IF g_lph.lph03 = 'Y' THEN
            IF g_lph.lph43 <= 0 OR cl_null(g_lph.lph43) THEN  
               CALL cl_err('','alm-h29',0) 
               NEXT FIELD lph43
            END IF
            IF g_lph.lph44 <= 0 OR cl_null(g_lph.lph44) THEN
               CALL cl_err('','alm-h29',0)
               NEXT FIELD lph44
            END IF
            IF NOT cl_null(g_lph.lph43) AND NOT cl_null(g_lph.lph44) THEN
               IF g_lph.lph44 < g_lph.lph43 THEN
                  CALL cl_err('','alm-h28',0)
                  NEXT FIELD lph43
               END IF
            END IF
         END IF
        #FUN-C50058 add END 
 #NO.FUN-BC0112---add beg
           IF g_lph.lph40 = 'Y'  THEN
              IF g_lph.lph41 = 0 OR g_lph.lph42 = 0 THEN 
              NEXT FIELD lph41
              END IF
           END IF
 #NO.FUN-BC0112---add end
     #add START
      ON ACTION CONTROLP 
          CASE
             WHEN INFIELD(lph47)         
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gec001"     #FUN-BC0058
                LET g_qryparam.default1 = g_lph.lph47 
                LET g_qryparam.where = " gec011 = '2' " 
                CALL cl_create_qry() RETURNING g_lph.lph47 
                NEXT FIELD lph47                
             WHEN INFIELD(lph48)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gec001"     #FUN-BC0058
                LET g_qryparam.default1 = g_lph.lph48
                LET g_qryparam.where = " gec011 = '2' AND gec04 = 0 "   
                CALL cl_create_qry() RETURNING g_lph.lph48
                NEXT FIELD lph48
      END CASE
     #add END

      ON ACTION CONTROLO  
         IF INFIELD(lph01) THEN
            LET g_lph.* = g_lph_t.*
            CALL i550_show()
            NEXT FIELD lph01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about 
         CALL cl_about() 
 
      ON ACTION help 
         CALL cl_show_help() 
    END INPUT
END FUNCTION
 
FUNCTION i550_lph32(p_cmd)
 DEFINE p_cmd  LIKE type_file.chr1

   LET g_errno = ' '
   IF NOT cl_null(g_lph.lph32) AND NOT cl_null(g_lph.lph33) THEN
      IF g_lph.lph32 < g_lph.lph33 THEN
         LET g_errno = 'alm-573'
      END IF
   END IF
 
   IF NOT cl_null(g_lph.lph34) AND NOT cl_null(g_lph.lph33) THEN
      IF g_lph.lph33 <> LENGTH(g_lph.lph34) THEN
         LET g_errno = 'alm-386'
#FUN-D10021--mark--str---
#     ELSE
#        LET g_cnt = 0
#        IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lph.lph34 <> g_lph_t.lph34) THEN
#           SELECT COUNT(*) INTO g_cnt FROM lph_file
#            WHERE lph34 = g_lph.lph34
#        #     AND lph34 <> g_lph_t.lph34
#        END IF
#        IF g_cnt > 0 THEN
#           LET g_errno = 'alm-707'
#        END IF
#FUN-D10021--mark--end---
      END IF
   END IF
 
   IF NOT cl_null(g_lph.lph32) AND NOT cl_null(g_lph.lph35) THEN
      IF g_lph.lph32 < g_lph.lph35 THEN
         LET g_errno = 'alm-574'
      END IF
   END IF
   
   IF NOT cl_null(g_lph.lph32) AND NOT cl_null(g_lph.lph33) AND
      NOT cl_null(g_lph.lph35) THEN
      IF g_lph.lph33 + g_lph.lph35 <> g_lph.lph32 THEN
         LET g_errno = 'alm-575'
      END IF
   END IF

  #FUN-C70077 Add Begin ---
   IF NOT cl_null(g_lph.lph32) AND NOT cl_null(g_lph.lph33) AND
      cl_null(g_lph.lph35) THEN
      LET g_lph.lph35 = g_lph.lph32 - g_lph.lph33
      DISPLAY BY NAME g_lph.lph35
   END IF 
  #FUN-C70077 Add End -----

END FUNCTION
 
FUNCTION i550_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lph.* TO NULL 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i550_curs() 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i550_count
    FETCH i550_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i550_cs 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lph.lph01,SQLCA.sqlcode,0)
        INITIALIZE g_lph.* TO NULL
    ELSE
        CALL i550_fetch('F')
    END IF
END FUNCTION
 
FUNCTION i550_fetch(p_fllph)
    DEFINE
        p_fllph         LIKE type_file.chr1
 
    CASE p_fllph
       WHEN 'N' FETCH NEXT     i550_cs INTO g_lph.lph01
       WHEN 'P' FETCH PREVIOUS i550_cs INTO g_lph.lph01
       WHEN 'F' FETCH FIRST    i550_cs INTO g_lph.lph01
       WHEN 'L' FETCH LAST     i550_cs INTO g_lph.lph01
       WHEN '/'
           IF (NOT g_no_ask) THEN 
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
           FETCH ABSOLUTE g_jump i550_cs INTO g_lph.lph01
           LET g_no_ask = FALSE  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lph.lph01,SQLCA.sqlcode,0)
        INITIALIZE g_lph.* TO NULL
        RETURN
    ELSE
      CASE p_fllph
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx 
    END IF
 
    SELECT * INTO g_lph.* FROM lph_file 
       WHERE lph01 = g_lph.lph01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lph_file",g_lph.lph01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_lph.lphuser
        LET g_data_group=g_lph.lphgrup
        CALL i550_show()
    END IF
END FUNCTION
 
FUNCTION i550_show()
    LET g_lph_t.* = g_lph.*
    DISPLAY BY NAME g_lph.lph01,g_lph.lph02,g_lph.lph03,g_lph.lph04,g_lph.lph05,
                    g_lph.lph06,g_lph.lph07,g_lph.lph08,g_lph.lph09,g_lph.lph10,
                    g_lph.lph11,g_lph.lph12,g_lph.lph13,g_lph.lph14,g_lph.lph15,
                    g_lph.lph16,g_lph.lph17,g_lph.lph18,g_lph.lph19,g_lph.lph20,
                    g_lph.lph21,g_lph.lph22,g_lph.lph23,g_lph.lph24,g_lph.lph25,
                    g_lph.lph26,g_lph.lph28,g_lph.lph29,g_lph.lph37,g_lph.lph38,
                    g_lph.lph39,g_lph.lph40,g_lph.lph41,g_lph.lph42,g_lph.lphpos,        #FUN-A80022 mod lph27 -> lphpos
                    g_lph.lphuser,g_lph.lphmodu,g_lph.lphgrup,g_lph.lphdate,             #FUN-BC0112 add lph37,lph38,lph39,lph40,lph41,lph42            
                    g_lph.lphacti,g_lph.lphcrat,g_lph.lphoriu,g_lph.lphorig,
                    g_lph.lph30,g_lph.lph31,g_lph.lph32,g_lph.lph33,g_lph.lph34,
                    g_lph.lph35,g_lph.lph36,g_lph.lph311,
                    g_lph.lph43,g_lph.lph44,g_lph.lph45,g_lph.lph46,                     #FUN-C50058 add  #FUN-C30176 add lph45  #FUN-CA0103 add lph46
                    g_lph.lph47,g_lph.lph48  #FUN-D20085 add 
    IF g_lph.lph24='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
    CALL cl_set_field_pic(g_lph.lph24,"","","",g_void,g_lph.lphacti)
    CALL cl_show_fld_cont() 
    CALL i550_lph47("d")   #FUN-D20085 add
END FUNCTION
 
FUNCTION i550_u(p_cmd)
    DEFINE   p_cmd     LIKE type_file.chr1
    IF g_lph.lph01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lph.* FROM lph_file WHERE lph01=g_lph.lph01
    IF g_lph.lphacti = 'N' THEN
       CALL cl_err('',9027,0) 
       RETURN
    END IF
    IF g_lph.lph24 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
    IF g_lph.lph24 = 'X' THEN
       CALL cl_err(g_lph.lph24,'9024',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lph01_t = g_lph.lph01
    BEGIN WORK
 
    OPEN i550_cl USING g_lph.lph01
    IF STATUS THEN
       CALL cl_err("OPEN i550_cl:", STATUS, 1)
       CLOSE i550_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i550_cl INTO g_lph.* 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lph.lph01,SQLCA.sqlcode,1)
        RETURN
    END IF
    IF p_cmd="u" THEN
       LET g_lph.lphmodu=g_user 
       LET g_lph.lphdate = g_today
    END IF
    IF p_cmd="c" THEN
       LET g_lph.lphmodu=NULL
       LET g_lph.lphdate=NULL
    END IF
    CALL i550_show()
    WHILE TRUE
        CALL i550_i("u") 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lph.*=g_lph_t.*
            CALL i550_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        #FUN-A80022 --------------add start---------------------
        IF g_aza.aza88 ='Y' THEN
          #FUN-B40071 --START--
           #LET g_lph.lphpos = 'N'          
           IF g_lph.lphpos = '1' THEN
              LET g_lph.lphpos = '1'
           ELSE
              LET g_lph.lphpos = '2'
           END IF         
        #FUN-B40071 --END--           
           DISPLAY g_lph.lphpos TO lphpos
        END IF 
        #FUN-A80022 -------------add end by vealxu ---------------   
        UPDATE lph_file SET lph_file.* = g_lph.* 
            WHERE lph01 = g_lph01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lph_file",g_lph.lph01,"",SQLCA.sqlcode,"","",0) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i550_cl
    COMMIT WORK
    SELECT * INTO g_lph.* FROM lph_file WHERE lph01=g_lph.lph01
    CALL i550_show()
END FUNCTION
 
FUNCTION i550_x()
    IF g_lph.lph01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lph.* FROM lph_file WHERE lph01=g_lph.lph01
    IF g_lph.lph24 = 'Y' THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF
    IF g_lph.lph24 = 'X' THEN
       CALL cl_err(g_lph.lph24,'9024',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i550_cl USING g_lph.lph01
    IF STATUS THEN
       CALL cl_err("OPEN i550_cl:", STATUS, 1)
       CLOSE i550_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i550_cl INTO g_lph.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lph.lph01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i550_show()
    IF cl_exp(0,0,g_lph.lphacti) THEN
        LET g_chr=g_lph.lphacti
        IF g_lph.lphacti='Y' THEN
            LET g_lph.lphacti='N'
        ELSE
            LET g_lph.lphacti='Y'
        END IF
        UPDATE lph_file
           SET lphacti=g_lph.lphacti,
               lphmodu=g_user,
               lphdate=g_today
         WHERE lph01=g_lph.lph01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_lph.lph01,SQLCA.sqlcode,0)
           LET g_lph.lphacti=g_chr
        ELSE
           LET g_lph.lphmodu=g_user
           LET g_lph.lphdate=g_today
           DISPLAY BY NAME g_lph.lphacti,g_lph.lphmodu,g_lph.lphdate
           CALL cl_set_field_pic("","","","","",g_lph.lphacti)
        END IF
    END IF
    CLOSE i550_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i550_r()
    DEFINE l_cnt LIKE type_file.num5
    IF g_lph.lph01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lph.* FROM lph_file WHERE lph01=g_lph.lph01
    IF g_lph.lphacti = 'N' THEN
       CALL cl_err('',9027,0)
       RETURN
    END IF
    IF g_lph.lph24 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF
    IF g_lph.lph24 = 'X' THEN
       CALL cl_err(g_lph.lph24,'9024',0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i550_cl USING g_lph.lph01
    IF STATUS THEN
       CALL cl_err("OPEN i550_cl:", STATUS, 0)
       CLOSE i550_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i550_cl INTO g_lph.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lph.lph01,SQLCA.sqlcode,0)
       RETURN
    END IF
    #FUN-B40071 --START--
    IF g_aza.aza88 = 'Y' THEN
       IF NOT ((g_lph.lphpos='3' AND g_lph.lphacti='N') 
                 OR (g_lph.lphpos='1'))  THEN                  
         CALL cl_err('','apc-139',0)            
         RETURN
      END IF 
    END IF
    #FUN-B40071 --END--
    CALL i550_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lph01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lph.lph01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lph_file WHERE lph01 = g_lph.lph01
       SELECT count(*) INTO l_cnt FROM lnk_file
        WHERE lnk01 = g_lph.lph01
          AND lnk02 = '1'
       IF l_cnt > 0 THEN
          DELETE FROM lnk_file WHERE lnk01 = g_lph.lph01 AND lnk02 = '1'
       END IF
       CLEAR FORM
       OPEN i550_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i550_cs
          CLOSE i550_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       FETCH i550_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i550_cs
          CLOSE i550_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i550_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i550_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i550_fetch('/')
       END IF
    END IF
    CLOSE i550_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i550_copy()
    DEFINE
        l_newno    LIKE lph_file.lph01,
        l_oldno    LIKE lph_file.lph01,
        p_cmd      LIKE type_file.chr1,
        l_n        LIKE type_file.num5,
        l_input    LIKE type_file.chr1 
 
    IF g_lph.lph01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i550_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM lph01
 
        AFTER FIELD lph01
           IF l_newno IS NOT NULL THEN
              SELECT COUNT(*) INTO l_n FROM lph_file 
                WHERE lph01 = l_newno 
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD lph01
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
        DISPLAY BY NAME g_lph.lph01
        RETURN
    END IF
    DROP TABLE x
    DROP TABLE y
    SELECT * FROM lph_file
        WHERE lph01=g_lph.lph01
        INTO TEMP x
    UPDATE x
        SET lph01=l_newno,
            lph24='N',
            lph25='',
#           lph26='',    #TQC-A60046
            lph26=NULL,  #TQC-A60046
            lph34='',
            lphacti='Y', 
            lphuser=g_user,
            lphgrup=g_grup, 
            lphmodu=NULL,  
            lphdate=NULL, 
            lphcrat=g_today
 
    INSERT INTO lph_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","lph_file",g_lph.lph01,"",SQLCA.sqlcode,"","",0)
    ELSE
        SELECT * FROM lnk_file WHERE lnk01 = g_lph.lph01 AND lnk02 = '1'
          INTO TEMP y

        UPDATE y SET lnk01 = l_newno

        INSERT INTO lnk_file SELECT * FROM y
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lnk_file",g_lph.lph01,"",SQLCA.sqlcode,"","",0)
        END IF
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_lph.lph01
        LET g_lph.lph01 = l_newno
        SELECT lph_file.* INTO g_lph.* FROM lph_file
               WHERE lph01 = l_newno
        CALL i550_u("c")
        #SELECT lph_file.* INTO g_lph.* FROM lph_file  #FUN-C30027
        #       WHERE lph01 = l_oldno                  #FUN-C30027
    END IF
    #LET g_lph.lph01 = l_oldno                         #FUN-C30027
    CALL i550_show()
END FUNCTION
 
FUNCTION i550_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lph01",TRUE)
     END IF
END FUNCTION
 
FUNCTION i550_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lph01",FALSE)
    END IF
    CALL cl_set_comp_entry("lphpos",FALSE)      #FUN-A80022 mod lph27 - >lphpos
END FUNCTION

FUNCTION i550_set_entry_lph03()
   IF g_lph.lph03 = 'Y' THEN
      CALL cl_set_comp_entry("lph05,lph07,lph40",TRUE)
      CALL cl_set_comp_entry("lph43,lph44",TRUE)  #FUN-C50058 add
      CALL cl_set_comp_required("lph43,lph44",TRUE)      #FUN-C50058 add 
      CALL cl_set_comp_entry("lph48",TRUE) #FUN-D20085 add
      CALL cl_set_comp_required("lph48",TRUE)  #FUN-D20085 add
      LET g_lph.lph43 = 9999     #FUN-C50058 add
      LET g_lph.lph44 = 9999     #FUN-C50058 add      
      DISPLAY BY NAME g_lph.lph43,g_lph.lph44    #FUN-C50058 add
   ELSE
#     CALL cl_set_comp_entry("lph05,lph07,lph082",FALSE)  #  FUN-BC0112---mark-----
      CALL cl_set_comp_entry("lph05,lph07,lph08,lph40,lph41,lph42",FALSE)  # FUN-BC0112--add---
      CALL cl_set_comp_entry("lph43,lph44",FALSE)  #FUN-C50058 add
      CALL cl_set_comp_required("lph43,lph44",FALSE)      #FUN-C50058 add
      CALL cl_set_comp_entry("lph48",FALSE) #FUN-D20085 add
      CALL cl_set_comp_required("lph48",FALSE)  #FUN-D20085 add
      LET g_lph.lph48 = ''    #FUN-D20085 add
      LET g_lph.lph43 = 0     #FUN-C50058 add
      LET g_lph.lph44 = 0     #FUN-C50058 add
      LET g_lph.lph05 = 'N'
      LET g_lph.lph07 = 'N'
      LET g_lph.lph08 = NULL
#FUN-BC0112 ------------STA
      LET g_lph.lph40 = 'N'             
      LET g_lph.lph41 =  0
      LET g_lph.lph42 =  0
#FUN-BC0112 ------------END
      DISPLAY BY NAME g_lph.lph05,g_lph.lph07,g_lph.lph08,g_lph.lph40,g_lph.lph41,g_lph.lph42
      DISPLAY BY NAME g_lph.lph43,g_lph.lph44    #FUN-C50058 add
      DISPLAY BY NAME g_lph.lph48  #FUN-D20085 add
      DISPLAY '' TO FORMONLY.lph48_desc  
   END IF
END FUNCTION
 
FUNCTION i550_set_entry_lph05()
   IF g_lph.lph05 = 'Y' THEN
      CALL cl_set_comp_entry("lph08",TRUE)
   ELSE 
      CALL cl_set_comp_entry("lph08",FALSE)
      LET g_lph.lph08 = NULL
      DISPLAY BY NAME g_lph.lph08
   END IF
END FUNCTION
 
FUNCTION i550_set_entry_lph36()
   IF g_lph.lph36 = 'Y' THEN
      CALL cl_set_comp_entry("lph30",TRUE)
      CALL cl_set_comp_required("lph30",TRUE)
   ELSE
      CALL cl_set_comp_entry("lph30",FALSE)
      CALL cl_set_comp_required("lph30",FALSE)
      LET g_lph.lph30 = NULL
      DISPLAY BY NAME g_lph.lph30
   END IF
END FUNCTION
 
FUNCTION i550_set_entry_lph06()
   IF g_lph.lph06 = 'Y' THEN
      CALL cl_set_comp_entry("lph28,lph29,lph17",TRUE)
   ELSE
      CALL cl_set_comp_entry("lph28,lph29,lph17",FALSE)
      LET g_lph.lph28 = NULL
      LET g_lph.lph29 = NULL
      LET g_lph.lph17 = '0'
      DISPLAY BY NAME g_lph.lph17,g_lph.lph28,g_lph.lph29
      CALL i550_set_entry_lph17()
   END IF
END FUNCTION
 
FUNCTION i550_set_entry_lph09()
   IF NOT cl_null(g_lph.lph09) THEN
     #FUN-C30042 add START
      IF g_lph.lph09 = '0' THEN  
         CALL cl_set_comp_entry("lph10",FALSE)
         CALL cl_set_comp_entry("lph11",FALSE)
         CALL cl_set_comp_entry("lph12",FALSE)
         CALL cl_set_comp_entry("lph13",FALSE)
         CALL cl_set_comp_entry("lph14",FALSE)
         CALL cl_set_comp_entry("lph15",FALSE)
         CALL cl_set_comp_entry("lph16",FALSE)
         CALL cl_set_comp_required('lph10',FALSE)   
         CALL cl_set_comp_required('lph11',FALSE)  
         LET g_lph.lph10 = NULL
         LET g_lph.lph11 = NULL
         LET g_lph.lph12 = 'N'
         LET g_lph.lph13 = NULL
         LET g_lph.lph14 = NULL
         LET g_lph.lph15 = NULL
         LET g_lph.lph16 = NULL       
         DISPLAY BY NAME g_lph.lph10,g_lph.lph11,g_lph.lph12,
                         g_lph.lph13,g_lph.lph14,g_lph.lph15,g_lph.lph16
      END IF
     #FUN-C30042 add END 
     #IF g_lph.lph09 = '0' THEN  #FUN-C30042 mark
      IF g_lph.lph09 = '1' THEN  #FUN-C30042 add
         CALL cl_set_comp_entry("lph10",TRUE)
         CALL cl_set_comp_entry("lph11",FALSE)
         CALL cl_set_comp_entry("lph12",TRUE)  #FUN-C30042 add
         CALL cl_set_comp_required('lph10',TRUE)   #FUN-C30042 add
         CALL cl_set_comp_required('lph11',FALSE)  #FUN-C30042 add
         LET g_lph.lph11 = NULL
      END IF
     #IF g_lph.lph09 = '1' THEN  #FUN-C30042 mark
      IF g_lph.lph09 = '2' THEN  #FUN-C30042 add
         CALL cl_set_comp_entry("lph11",TRUE)
         CALL cl_set_comp_entry("lph10",FALSE)
         CALL cl_set_comp_entry("lph12",TRUE)  #FUN-C30042 add 
         CALL cl_set_comp_required('lph11',TRUE)   #FUN-C30042 add
         CALL cl_set_comp_required('lph10',FALSE)  #FUN-C30042 add        
         LET g_lph.lph10 = NULL
      END IF
   ELSE
      CALL cl_set_comp_entry("lph10,lph11",FALSE)
   END IF
   DISPLAY BY NAME g_lph.lph10,g_lph.lph11
END FUNCTION

#FUN-BC0112----add start ----
FUNCTION i550_set_entry_lph37()
   IF g_lph.lph37 = 'Y' THEN
      CALL cl_set_comp_entry("lph38,lph39",TRUE)
      CALL cl_set_comp_required("lph38,lph39",TRUE)  #FUN-BA0070 add
   ELSE
      CALL cl_set_comp_entry("lph38,lph39",FALSE)
      CALL cl_set_comp_required("lph38,lph39",FALSE)  #FUN-BA0070 add
      LET g_lph.lph38 = 1
      LET g_lph.lph39 = 1
      LET g_lph.lph37 = 'N'  #FUN-BA0070 add
      DISPLAY BY NAME g_lph.lph38,g_lph.lph39,g_lph.lph37   #FUN-BA0070 add lph37  
   END IF
END FUNCTION 
FUNCTION i550_set_entry_lph40()
   IF g_lph.lph40 = 'Y' THEN  
      CALL cl_set_comp_entry("lph41,lph42",TRUE)
   ELSE
      CALL cl_set_comp_entry("lph41,lph42",FALSE)
      LET g_lph.lph41 = 0
      LET g_lph.lph42 = 0
      DISPLAY BY NAME g_lph.lph41,g_lph.lph42 
   END IF
END FUNCTION
#FUN-BC0112-----add end --------

FUNCTION i550_set_entry_lph12()
   IF g_lph.lph12 = 'Y' THEN
       CALL cl_set_comp_entry("lph13",TRUE)
    ELSE 
       CALL cl_set_comp_entry("lph13,lph14,lph15,lph16",FALSE)
       LET g_lph.lph13 = NULL
       LET g_lph.lph14 = NULL
       LET g_lph.lph15 = NULL
       LET g_lph.lph16 = NULL
       DISPLAY BY NAME g_lph.lph13,g_lph.lph14,g_lph.lph15,g_lph.lph16
    END IF
END FUNCTION
 
FUNCTION i550_set_entry_lph13()
   IF NOT cl_null(g_lph.lph13) THEN
      IF g_lph.lph13 = '0' THEN
         CALL cl_set_comp_entry("lph14",TRUE)
         CALL cl_set_comp_entry("lph15,lph16",FALSE)
         LET g_lph.lph15 = NULL
         LET g_lph.lph16 = NULL
      END IF
      IF g_lph.lph13 = '1' THEN
         CALL cl_set_comp_entry("lph15",TRUE)
         CALL cl_set_comp_entry("lph14,lph16",FALSE)
         LET g_lph.lph14 = NULL
         LET g_lph.lph16 = NULL
      END IF
      IF g_lph.lph13 = '2' THEN
         CALL cl_set_comp_entry("lph16",TRUE)
         CALL cl_set_comp_entry("lph14,lph15",FALSE)
         LET g_lph.lph14 = NULL
         LET g_lph.lph15 = NULL
      END IF
   ELSE
      CALL cl_set_comp_entry("lph14,lph15,lph16",FALSE)
      LET g_lph.lph14 = NULL
      LET g_lph.lph15 = NULL
      LET g_lph.lph16 = NULL
   END IF
   DISPLAY BY NAME g_lph.lph14,g_lph.lph15,g_lph.lph16
END FUNCTION
 
FUNCTION i550_set_entry_lph17()
   IF g_lph.lph17 = '0' THEN
      CALL cl_set_comp_entry("lph18,lph19,lph31,lph311,lph20",FALSE)
      LET g_lph.lph18 = ''
      LET g_lph.lph19 = ''
      LET g_lph.lph31 = ''
      LET g_lph.lph311 = ''
      LET g_lph.lph20 = ''
   ELSE
      IF g_lph.lph17 = '1' THEN
         CALL cl_set_comp_entry("lph18",TRUE)
         CALL cl_set_comp_entry("lph19,lph31,lph311,lph20",FALSE)
         CALL cl_set_comp_required("lph18",TRUE)
         LET g_lph.lph19 = ''
         LET g_lph.lph31 = ''
         LET g_lph.lph311 = ''
         LET g_lph.lph20 = ''
      END IF
      IF g_lph.lph17 = '2' THEN
         CALL cl_set_comp_entry("lph19",TRUE)
         CALL cl_set_comp_entry("lph18,lph31,lph311,lph20",FALSE)
         CALL cl_set_comp_required("lph19",TRUE)
         LET g_lph.lph18 = ''
         LET g_lph.lph31 = ''
         LET g_lph.lph311 = ''
         LET g_lph.lph20 = ''
      END IF
      IF g_lph.lph17 = '3' THEN
         CALL cl_set_comp_entry("lph31,lph311,lph20",TRUE)
         CALL cl_set_comp_entry("lph18,lph19",FALSE)
         CALL cl_set_comp_required("lph31,lph311",TRUE)
         CALL cl_set_comp_entry("lph20",TRUE)          #FUN-C50027 add
         CALL cl_set_comp_required("lph20",TRUE)       #FUN-C50027 add                   
         LET g_lph.lph18 = ''
         LET g_lph.lph19 = ''
      END IF
   END IF
   DISPLAY BY NAME g_lph.lph18,g_lph.lph19,g_lph.lph31,g_lph.lph20,g_lph.lph311
END FUNCTION
 
FUNCTION i550_set_entry_lph21()
   IF NOT cl_null(g_lph.lph21) THEN
      IF g_lph.lph21 = '0' THEN
         CALL cl_set_comp_entry("lph22",TRUE)
         CALL cl_set_comp_entry("lph23",FALSE)
         LET g_lph.lph23 = NULL
      END IF
      IF g_lph.lph21 = '1' THEN
         CALL cl_set_comp_entry("lph23",TRUE)
         CALL cl_set_comp_entry("lph22",FALSE)
         LET g_lph.lph22 = NULL
      END IF
   ELSE 
      CALL cl_set_comp_entry("lph22,lph23",FALSE)
   END IF
   DISPLAY BY NAME g_lph.lph22,g_lph.lph23
END FUNCTION
 
FUNCTION i550_y()
 DEFINE l_lni10    LIKE lni_file.lni10
 DEFINE l_n        LIKE type_file.num5      #TQC-B30154 add 

   IF cl_null(g_lph.lph01) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
#TQC-B30154 ------------STA
   SELECT COUNT(*) INTO l_n  FROM lnk_file
    WHERE lnk01 = g_lph.lph01
      AND lnk02 = '1'
    IF l_n = 0 THEN
       CALL cl_err('','alm-851',0)
       RETURN
    END IF
#TQC-B30154 ------------END  
   SELECT * INTO g_lph.* FROM lph_file WHERE lph01=g_lph.lph01 
   IF g_lph.lphacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
   
   IF g_lph.lph24='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF
 
   IF g_lph.lph24 = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   
   IF NOT cl_confirm('alm-006') THEN 
        RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i550_cl USING g_lph.lph01
   IF STATUS THEN
      CALL cl_err("OPEN i550_cl:", STATUS, 1)
      CLOSE i550_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i550_cl INTO g_lph.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lph.lph01,SQLCA.sqlcode,0)      
      CLOSE i550_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE lph_file SET lph24 = 'Y',lph25 = g_user,lph26 = g_today
    WHERE lph01 = g_lph.lph01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lph_file",g_lph.lph01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lph.lph24 = 'Y'
      LET g_lph.lph25 = g_user
      LET g_lph.lph26 = g_today
      DISPLAY BY NAME g_lph.lph24,g_lph.lph25,g_lph.lph26
      CALL cl_set_field_pic(g_lph.lph24,"","","","","")
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i550_z()
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_lni03 LIKE lni_file.lni03
   IF cl_null(g_lph.lph01) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   
   SELECT * INTO g_lph.* FROM lph_file WHERE lph01=g_lph.lph01
   IF g_lph.lphacti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF
   
   IF g_lph.lph24='N' THEN 
      CALL cl_err('','9025',0)
      RETURN
   END IF
 
   IF g_lph.lph24='X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF
   
   SELECT COUNT(*) INTO l_cnt FROM lpm_file 
    WHERE lpm04 = g_lph.lph01 
   IF l_cnt > 0 THEN
      CALL cl_err('','alm-363',0)
      RETURN
   END IF
  
 # IF NOT cl_confirm('alm-008') THEN 
 #    RETURN
 # END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i550_cl USING g_lph.lph01
   IF STATUS THEN
      CALL cl_err("OPEN i550_cl:", STATUS, 1)
      CLOSE i550_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i550_cl INTO g_lph.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lph.lph01,SQLCA.sqlcode,0)      
      CLOSE i550_cl
      ROLLBACK WORK
      RETURN
   END IF

 #TQC-AC0079 ----------------STA
   SELECT COUNT(*) INTO l_cnt FROM lta_file ,ltc_file
    WHERE lta01 = ltc01
      AND lta02 = ltc02
      AND lta02 = '1'
      AND ltc03 = g_lph.lph01
   IF l_cnt > 0 THEN
      CALL cl_err('','alm-597',0)
      CLOSE i550_cl
      ROLLBACK WORK
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM lpj_file
    WHERE lpj02 = g_lph.lph01
   IF l_cnt > 0 THEN
     CALL cl_err('','alm-596',0)
     CLOSE i550_cl
     ROLLBACK WORK
     RETURN
   ELSE
     IF NOT cl_confirm('alm-008') THEN
        RETURN
     END IF
 #TQC-AC0079 ----------------END   
     #UPDATE lph_file SET lph24 = 'N',lph25 = '',lph26 = '',          #CHI-D20015 mark
     UPDATE lph_file SET lph24 = 'N',lph25 = g_user,lph26 = g_today,  #CHI-D20015 add
                       lphmodu = g_user,lphdate = g_today
      WHERE lph01 = g_lph.lph01
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","lph_file",g_lph.lph01,"",STATUS,"","",1) 
        LET g_success = 'N'
     ELSE 
 #TQC-AC0079 ----------------mark
 #    SELECT MAX(lni03) INTO l_lni03 FROM lni_file 
 #     WHERE lni01 = g_lph.lph01
 #    IF l_lni03 > 0 THEN
 #       DELETE FROM lni_file 
 #        WHERE lni01 = g_lph.lph01
 #          AND lni13 = 'N'
 #       #  AND lni03 <> l_lni03
 #       IF SQLCA.sqlcode THEN
 #          CALL cl_err3("del","lni_file","","",STATUS,"","",1)
 #          LET g_success = 'N'
 #       ELSE 
 #          UPDATE lni_file SET lni03 = 0
 #           WHERE lni01 = g_lph.lph01
 #          IF SQLCA.sqlcode THEN
 #             CALL cl_err3("upd","lni_file","","",STATUS,"","",1)
 #             LET g_success = 'N'
 #          END IF
 #       END IF
 #    END IF
 #TQC-AC0079 ----------------mark
        LET g_lph.lph24 = 'N'
        #CHI-D20015--modify--str--
        #LET g_lph.lph25 = ''
        #LET g_lph.lph26 = ''
        LET g_lph.lph25 = g_user
        LET g_lph.lph26 = g_today
        #CHI-D20015--modify--end--
        LET g_lph.lphmodu = g_user
        LET g_lph.lphdate = g_today
        DISPLAY BY NAME g_lph.lph24,g_lph.lph25,g_lph.lph26,
                        g_lph.lphmodu,g_lph.lphdate
        CALL cl_set_field_pic(g_lph.lph24,"","","","","")
      END IF                                    #TQC-AC0079
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i550_v()
   IF g_lph.lph01 IS NULL THEN 
      CALL cl_err('','-400',0)
      RETURN 
   END IF
   
   SELECT * INTO g_lph.* FROM lph_file
    WHERE lph01=g_llph.lph01
      
   IF g_lph.lph24='Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_lph.lphacti='N' THEN CALL cl_err('','alm-004',0) RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y' 
 
   OPEN i550_cl USING g_lph.lph01
   IF STATUS THEN
      CALL cl_err("OPEN i550_cl:", STATUS, 1)
      CLOSE i550_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i550_cl INTO g_lph.* 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lph.lph01,SQLCA.sqlcode,0) 
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_lph.lph24) THEN
      IF g_lph.lph24 ='N' THEN
         LET g_lph.lph24='X'
      ELSE
         LET g_lph.lph24='N'
      END IF
      UPDATE lph_file SET
             lph24=g_lph.lph24,
             lphmodu=g_user,
             lphdate=g_today
       WHERE lph01=g_lph.lph01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","lph_file",g_lph.lph01,"","apm-266","","upd lph_file",1)
         LET g_success='N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lph.lph01,'V')
      DISPLAY BY NAME g_lph.lph24
   ELSE
      LET g_lph.lph24= g_lph_t.lph24
      DISPLAY BY NAME g_lph.lph24
      ROLLBACK WORK
   END IF
 
   SELECT lph24,lphmodu,lphdate
     INTO g_lph.lph24,g_lph.lphmodu,g_lph.lphdate FROM lph_file
    WHERE lph01=g_lph.lph01
 
    DISPLAY BY NAME g_lph.lph24,g_lph.lphmodu,g_lph.lphdate
    IF g_lph.lph24='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
    CALL cl_set_field_pic(g_lph.lph24,"","","",g_void,"") 
END FUNCTION
#No.FUN-960134

#FUN-D20085 add START
FUNCTION i550_lph47(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gec02   LIKE gec_file.gec02
   DEFINE l_gecacti LIKE gec_file.gecacti

   LET g_errno = ''

   IF NOT cl_null(g_lph.lph47) THEN
      SELECT gec02,gecacti INTO l_gec02,l_gecacti
        FROM gec_file
       WHERE gec01 = g_lph.lph47
         AND gec011 = '2'
      CASE WHEN SQLCA.sqlcode=100  LET g_errno='alm-921'
                                   LET l_gec02=''
           WHEN l_gecacti<>'Y'     LET g_errno='alm-142'
           OTHERWISE               LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE
      IF cl_null(g_errno) OR p_cmd = 'd' THEN
         DISPLAY l_gec02 TO FORMONLY.lph47_desc 
      END IF
   END IF

   IF NOT cl_null(g_lph.lph48) THEN
      SELECT gec02,gecacti INTO l_gec02,l_gecacti
        FROM gec_file
       WHERE gec01 = g_lph.lph48
         AND gec011 = '2'
      CASE WHEN SQLCA.sqlcode=100  LET g_errno='alm-921'
                                   LET l_gec02=''
           WHEN l_gecacti<>'Y'     LET g_errno='alm-142'
           OTHERWISE               LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE
      IF cl_null(g_errno) OR p_cmd = 'd' THEN
         DISPLAY l_gec02 TO FORMONLY.lph48_desc 
      END IF
   END IF

END FUNCTION
#FUN-D20085 add END 
