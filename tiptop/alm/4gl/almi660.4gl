# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: almi660.4gl
# Descriptions...: 券類型維護作業
# Date & Author..: FUN-870015 2008/08/20 By shiwuying
# Modify.........: No.FUN-960134 09/07/15 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/10 By Cockroach ADD POS?
# Modify.........: No.FUN-A60052 10/06/17 By lutingting拿掉lpx19,lpx20改為在axri070中維護 
# Modify.........: No.TQC-A60062 10/06/17 By houlia lpx32開窗資料修改 
# Modify.........: No.TQC-A70037 10/07/07 BY houlia lpx32查詢顯示及錄入控管調整
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-AA0059 10/10/29 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.TQC-B30101 11/03/11 By baogc 隱藏簽核欄位,簽核狀態欄位,簽核按鈕
# Modify.........: No.TQC-B40185 11/04/21 By wangxin show函數中加lpxpos的display 
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60241 11/06/21 By baogc 增加確認時的控管
# Modify.........: No.FUN-BC0130 12/01/13 By yangxf 添加栏位lpx33 已開發票禮券稅別 及相关控管

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C30076 12/03/07 by pauline 輸入的稅別必須要與arti120互相控卡
# Modify.........: No.FUN-C50036 12/05/22 By fanbj 增加收券金額(lpx35)、生效日期(lpx03)、截止日期欄位(lpx04)
# Modify.........: No.FUN-C70077 12/07/18 By baogc 根據代號位數和固定代號位自動帶出數流水號位數
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-C80091 12/08/14 By yangxf 券对应产品编号开窗应带出已审核的产品编号
# Modify.........: No:FUN-C90043 12/09/11 By xumm 添加取消审核按钮，拿掉lpx06,lpx09,lpx11,lpx12重新調整畫面
# Modify.........: No:FUN-CB0109 12/11/22 By Lori 增加是否計算遞延金額(lpx36)
# Modify.........: No:FUN-D10040 13/01/18 By xumm 添加折扣券逻辑
# Modify.........: No:FUN-D20085 13/03/01 By pauline 未開發票禮券稅率必須要為0%
# Modify.........: No:FUN-D30050 13/03/18 By dongsz 券面額欄位必輸,券對應產品不可重複
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No.MOD-D70068 13/07/11 By SunLM 调整lpx04为必输栏位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lpx       RECORD LIKE lpx_file.*,
       g_lpx_t     RECORD LIKE lpx_file.*,
       g_lpx01_t   LIKE lpx_file.lpx01,
       g_wc        STRING,
       g_sql       STRING
 
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE g_chr                 LIKE lpx_file.lpxacti
DEFINE g_void                LIKE type_file.chr1
DEFINE g_approve             LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask             LIKE type_file.num5
 
MAIN
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
   INITIALIZE g_lpx.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM lpx_file WHERE lpx01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i660_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i660_w WITH FORM "alm/42f/almi660"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

  #FUN-A30030 ADD-------------------------
   IF g_aza.aza88='Y' THEN
      CALL cl_set_comp_visible('lpxpos',TRUE)
   ELSE
      CALL cl_set_comp_visible('lpxpos',FALSE)
   END IF
  #FUN-A30030 END------------------------ 

   CALL cl_ui_init()
##-TQC-B30101 ADD-BEGIN------
   #CALL cl_set_comp_visible("lpx13,lpx14",FALSE)    #FUN-C90043 mark
   CALL cl_set_act_visible("ef_approval",FALSE) 
##-TQC-B30101 ADD--END-------
  #CALL cl_set_comp_visible("lpx20,aag02_1",g_aza.aza63='Y')    #FUN-A50062
  #CALL cl_set_comp_visible("lpx25",FALSE)    #FUN-A30030 MARK
   LET g_action_choice = ""
   CALL i660_menu()
   CLOSE WINDOW i660_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i660_curs()
    CLEAR FORM
    INITIALIZE g_lpx.* TO NULL
    #FUN-C90043-----mark---str
    #CONSTRUCT BY NAME g_wc ON lpx01,lpx02,lpx05,lpx29,lpx06,lpx07,lpx08,  
    #                        #lpx10,lpx09,lpx11,lpx12,lpx31,lpx19,lpx20,   #FUN-A60052
    #                         #lpx10,lpx09,lpx11,lpx12,lpx31,               #FUN-A60052             #FUN-C50036 mark
    #                         lpx10,lpx35,lpx09,lpx11,lpx12,lpx31,                                  #FUN-C50036 add
    #                         lpx21,lpx22,lpx23,lpx24,lpx26,lpx33,lpx28,   #FUN-BC0130 add lpx33
    #                         #lpx32,lpx13,lpx14,lpx15,lpx16,lpx17,           #FUN-A30030 DEL lpx25 #FUN-C50036 mark
    #                         lpx32,lpx03,lpx04,lpx13,lpx14,lpx15,lpx16,lpx17,                      #FUN-C50036 add
    #                         lpx18,lpxpos,lpxuser,lpxgrup,lpxoriu,lpxorig,  #FUN-A30030 ADD pos
    #                         lpxcrat,lpxmodu,lpxacti,lpxdate
    #FUN-C90043-----mark---end

    #FUN-C90043-----add----str
    CONSTRUCT BY NAME g_wc ON lpx01,lpx02,lpx03,lpx04,lpx21,lpx22,lpx23,
                              #lpx24,lpx26,lpx33,lpx28,lpx32,lpx07,lpx36,lpx31,    #FUN-CB0109 add lpx36  #FUN-D10040 mark
                              lpx24,lpx26,lpx28,lpx37,lpx38,lpx33,lpx32,lpx07,lpx36,lpx31,          #FUN-D10040 add
                              lpx05,lpx29,lpx08,lpx10,lpx35,lpxpos,
                              lpx15,lpx16,lpx17,lpx18,lpxuser,lpxgrup,
                              lpxoriu,lpxorig,lpxcrat,lpxmodu,lpxacti,lpxdate
    #FUN-C90043-----add----end
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(lpx01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lpx01"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO lpx01
                NEXT FIELD lpx01 
           #FUN-A60052--mark--str--
           # WHEN INFIELD(lpx19)
           #    CALL cl_init_qry_var()
           #    LET g_qryparam.form = "q_lpx19"
           #    LET g_qryparam.state = "c"
           #    LET g_qryparam.arg1 = g_aza.aza81
           #    CALL cl_create_qry() RETURNING g_qryparam.multiret
           #    DISPLAY g_qryparam.multiret TO lpx19
           #    NEXT FIELD lpx19
           # WHEN INFIELD(lpx20)
           #    CALL cl_init_qry_var()
           #    LET g_qryparam.form = "q_lpx20"
           #    LET g_qryparam.state = "c"
           #    LET g_qryparam.arg1 = g_aza.aza82
           #    CALL cl_create_qry() RETURNING g_qryparam.multiret
           #    DISPLAY g_qryparam.multiret TO lpx20
           #    NEXT FIELD lpx20
           #FUN-A60052--mark--end
             WHEN INFIELD(lpx28)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lpx28"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO lpx28
                NEXT FIELD lpx28
             WHEN INFIELD(lpx32)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lpx32"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO lpx32
                NEXT FIELD lpx32
#FUN-BC0130 add begin ---
             WHEN INFIELD(lpx33)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lpx33"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO lpx33
                NEXT FIELD lpx33
#FUN-BC0130 add end ---
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
          
       ON ACTION qbe_select
          CALL cl_qbe_select()
          
       ON ACTION qbe_save
	  CALL cl_qbe_save()
    END CONSTRUCT
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN 
    #            LET g_wc = g_wc clipped," AND lpxuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN  
    #        LET g_wc = g_wc clipped," AND lpxgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND lpxgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpxuser', 'lpxgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT lpx01 FROM lpx_file ",
        " WHERE ",g_wc CLIPPED, 
        " ORDER BY lpx01"
    PREPARE i660_prepare FROM g_sql
    DECLARE i660_cs    
        SCROLL CURSOR WITH HOLD FOR i660_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM lpx_file WHERE ",g_wc CLIPPED
    PREPARE i660_precount FROM g_sql
    DECLARE i660_count CURSOR FOR i660_precount
END FUNCTION
 
FUNCTION i660_menu()
   DEFINE l_cmd  LIKE type_file.chr1000 
   DEFINE l_msg  LIKE type_file.chr1000
   MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i660_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i660_q()
            END IF
        ON ACTION next
            CALL i660_fetch('N')
        ON ACTION previous
            CALL i660_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i660_u("u")
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i660_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i660_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL i660_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()THEN
           #    CALL i660_out()
            END if
        ON ACTION ef_approval
           LET g_action_choice="ef_approval"
            IF cl_chk_act_auth() THEN
               CALL i660_ef()
            END IF
        ON ACTION confirm 
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
                CALL i660_y()
           END IF 
    #FUN-C90043-----rmark----str
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i660_z()
            END IF
    #FUN-C90043-----rmark----end
    #   ON ACTION void
    #      LET g_action_choice="void"
    #      IF cl_chk_act_auth() THEN
    #         CALL i660_v()
    #      END IF
        ON ACTION coupons
            LET g_action_choice="coupons"
            IF cl_chk_act_auth() THEN
               IF g_lpx.lpx01 IS NULL THEN
                  CALL cl_err('',-400,0)
               ELSE
                  LET l_msg = "almi551  '",g_lpx.lpx01 CLIPPED,"'  '2' " 
                  CALL cl_cmdrun_wait(l_msg)
               END IF
            END IF
       #ON ACTION range_query 
       #   LET g_action_choice="range_query"
       #   IF cl_chk_act_auth() THEN
       #      IF g_lpx.lpx01 IS NULL THEN
       #         CALL cl_err('',-400,0)
       #      ELSE
       #         LET l_msg = "almi5502  '",g_lpx.lpx01 CLIPPED,"'  '5' "
       #         CALL cl_cmdrun_wait(l_msg)
       #      END IF
       #   END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i660_fetch('/')
        ON ACTION first
            CALL i660_fetch('F')
        ON ACTION last
            CALL i660_fetch('L')
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
              IF g_lpx.lpx01 IS NOT NULL THEN
                 LET g_doc.column1 = "lpx01"
                 LET g_doc.value1 = g_lpx.lpx01
                 CALL cl_doc()
              END IF
           END IF
 
     END MENU
     CLOSE i660_cs
END FUNCTION
 
FUNCTION i660_a()
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_lpx.* LIKE lpx_file.*
    LET g_lpx_t.* = g_lpx.*
    LET g_lpx01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lpx.lpx05 = 'N'
        LET g_lpx.lpx06 = 'N'    
        LET g_lpx.lpx07 = 'N'
        LET g_lpx.lpx08 = 'N'
        LET g_lpx.lpx09 = 'N'
        LET g_lpx.lpx11 = 'N'
        LET g_lpx.lpx12 = 'N'
        LET g_lpx.lpx13 = 'N'
        LET g_lpx.lpx14 = '0'
        LET g_lpx.lpx15 = 'N'
        LET g_lpx.lpx25 = 'N'
        LET g_lpx.lpx34 = '2'   #FUN-BC0130 add 
        #FUN-D10040----add---str
        LET g_lpx.lpx38 = 'N' 
       #FUN-D20085 mark START
       #CALL cl_set_comp_entry("lpx33",FALSE)
       #CALL cl_set_comp_required("lpx33",FALSE)
       #DISPLAY BY NAME g_lpx.lpx33
       #FUN-D20085 mark END
        DISPLAY '' TO gec02
        #FUN-D10040----add---end
 
        #########################
        LET g_lpx.lpx26 = '1'
        LET g_lpx.lpx27 = 'N'
        LET g_lpx.lpx31 = 'N'
        ########################
        #LET g_lpx.lpxpos = 'N'   #FUN-A30030 ADD
        LET g_lpx.lpxpos = '1' #FUN-B40071 
        LET g_lpx.lpxuser = g_user
        LET g_lpx.lpxoriu = g_user #FUN-980030
        LET g_lpx.lpxorig = g_grup #FUN-980030
        LET g_lpx.lpxgrup = g_grup 
        LET g_lpx.lpxacti = 'Y'
        LET g_lpx.lpxcrat = g_today
        LET g_lpx.lpx03 = g_today      #FUN-C50036 add
        LET g_lpx.lpx04 = "2099/12/31" #FUN-C50036 add
        LET g_lpx.lpx36 = 'N'          #FUN-CB0109 add

        CALL i660_i("a") 
        IF INT_FLAG THEN 
            INITIALIZE g_lpx.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lpx.lpx01 IS NULL THEN 
            CONTINUE WHILE
        END IF
        INSERT INTO lpx_file VALUES(g_lpx.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lpx_file",g_lpx.lpx01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        ELSE
           SELECT * INTO g_lpx.* FROM lpx_file
            WHERE lpx01 = g_lpx.lpx01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i660_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_input   LIKE type_file.chr1,
            l_n       LIKE type_file.num5 
 
   #DISPLAY BY NAME g_lpx.lpx05,g_lpx.lpx06,g_lpx.lpx07,g_lpx.lpx08,                        #FUN-C50036 mark
   #FUN-C90043---mark---str
   #DISPLAY BY NAME g_lpx.lpx03,g_lpx.lpx04,g_lpx.lpx05,g_lpx.lpx06,g_lpx.lpx07,g_lpx.lpx08, #FUN-C50036 add
   #                g_lpx.lpx09,g_lpx.lpx11,g_lpx.lpx12,g_lpx.lpx13,
   #                g_lpx.lpx14,g_lpx.lpx15,g_lpx.lpxuser,g_lpx.lpxgrup,
   #                g_lpx.lpxacti,g_lpx.lpxcrat,              #FUN-A30030 mark g_lpx.lpx25,
   #                g_lpx.lpxoriu,g_lpx.lpxorig,g_lpx.lpxpos  #FUN-A30030 ADD POS
   #INPUT BY NAME
   #   g_lpx.lpx01,g_lpx.lpx02,g_lpx.lpx05,g_lpx.lpx29,g_lpx.lpx06,g_lpx.lpx07,
   #   #g_lpx.lpx08,g_lpx.lpx10,g_lpx.lpx09,g_lpx.lpx11,g_lpx.lpx12,g_lpx.lpx31,             #FUN-C50036 mark
   #   g_lpx.lpx08,g_lpx.lpx10,g_lpx.lpx35,g_lpx.lpx09,g_lpx.lpx11,g_lpx.lpx12,g_lpx.lpx31,  #FUN-C50036 add 
   #  #g_lpx.lpx19,g_lpx.lpx20,g_lpx.lpx21,g_lpx.lpx22,g_lpx.lpx23,g_lpx.lpx24,   #FUN-A60052
   #   g_lpx.lpx21,g_lpx.lpx22,g_lpx.lpx23,g_lpx.lpx24,   #FUN-A60052
   #   #g_lpx.lpx26,g_lpx.lpx33,g_lpx.lpx28,g_lpx.lpx32,g_lpx.lpx18           #FUN-A30030 MARK g_lpx.lpx25 #FUN-BC0130 add lpx33 #FUN-C50036 mark
   #   g_lpx.lpx26,g_lpx.lpx33,g_lpx.lpx28,g_lpx.lpx32,g_lpx.lpx03,g_lpx.lpx04,g_lpx.lpx18                              #FUN-C50036 add
   #FUN-C90043---mark---end

   #FUN-C90043---add----str
   DISPLAY BY NAME g_lpx.lpx03,g_lpx.lpx04,g_lpx.lpx05,g_lpx.lpx07,g_lpx.lpx08,
                   g_lpx.lpx15,g_lpx.lpxuser,g_lpx.lpxgrup,g_lpx.lpxacti,g_lpx.lpxcrat,
                   g_lpx.lpx37,g_lpx.lpx38,                                                   #FUN-D10040 add
                   g_lpx.lpxoriu,g_lpx.lpxorig,g_lpx.lpxpos,g_lpx.lpx36                       #FUN-CB0109 add lpx36

   INPUT BY NAME
         g_lpx.lpx01,g_lpx.lpx02,g_lpx.lpx03,g_lpx.lpx04,g_lpx.lpx21,
         #g_lpx.lpx22,g_lpx.lpx23,g_lpx.lpx24,g_lpx.lpx26,g_lpx.lpx33,                        #FUN-D10040 mark
         #g_lpx.lpx28,g_lpx.lpx32,g_lpx.lpx07,g_lpx.lpx31,g_lpx.lpx05,                        #FUN-D10040 mark
         #g_lpx.lpx29,g_lpx.lpx08,g_lpx.lpx10,g_lpx.lpx35,g_lpx.lpx18,                        #FUN-D10040 mark
         #g_lpx.lpx36                                                       #FUN-CB0109 add   #FUN-D10040 mark
         g_lpx.lpx22,g_lpx.lpx23,g_lpx.lpx24,g_lpx.lpx26,g_lpx.lpx28,g_lpx.lpx37,g_lpx.lpx38, #FUN-D10040 add
         g_lpx.lpx33,g_lpx.lpx32,g_lpx.lpx07,g_lpx.lpx36,g_lpx.lpx31,g_lpx.lpx05,             #FUN-D10040 add
         g_lpx.lpx29,g_lpx.lpx08,g_lpx.lpx10,g_lpx.lpx35,g_lpx.lpx18                          #FUN-D10040 add
   #FUN-C90043---add----end
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL i660_set_entry(p_cmd)
          CALL i660_set_no_entry(p_cmd)
          CALL i660_set_entry_lpx08()
          LET g_before_input_done = TRUE
         #IF g_aza.aza88 = 'Y' THEN   #FUN-A30030 MARK ABOUT lpx25
         #   LET g_lpx.lpx25 = 'Y'
         #ELSE
         #   LET g_lpx.lpx25 = 'N'
         #END IF
         #DISPLAY BY NAME g_lpx.lpx25
 
      AFTER FIELD lpx01
         IF g_lpx.lpx01 IS NOT NULL THEN
            IF p_cmd = "a" OR
               (p_cmd="u" AND g_lpx.lpx01 != g_lpx01_t)THEN
               SELECT COUNT(*) INTO l_n FROM lpx_file 
                WHERE lpx01 = g_lpx.lpx01 
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD lpx01
               END IF
            END IF
         END if
 
      AFTER FIELD lpx05
         IF NOT cl_null(g_lpx.lpx05) THEN
            CALL i660_set_entry_lpx05()
         END IF
 
      AFTER FIELD lpx10
         IF NOT cl_null(g_lpx.lpx10) THEN
            IF g_lpx.lpx10 < 0 THEN
               CALL cl_err(g_lpx.lpx10,'alm-061',0)
               NEXT FIELD lpx10
            END IF
         END IF
 
    #FUN-A60052--mark--str--
    # AFTER FIELD lpx19
    #    IF NOT cl_null(g_lpx.lpx19) THEN
    #       CALL i660_lpx19(p_cmd)
    #       IF NOT cl_null(g_errno) THEN
    #          CALL cl_err(g_lpx.lpx19,g_errno,0)
    #          LET g_lpx.lpx19 = g_lpx_t.lpx19
    #          NEXT FIELD lpx19
    #       END IF
    #    END IF
 
    # AFTER FIELD lpx20
    #    IF NOT cl_null(g_lpx.lpx20) THEN
    #       CALL i660_lpx20(p_cmd)
    #       IF NOT cl_null(g_errno) THEN
    #          CALL cl_err(g_lpx.lpx20,g_errno,0)
    #          LET g_lpx.lpx20 = g_lpx_t.lpx20
    #          NEXT FIELD lpx20
    #       END IF
    #    END IF
    #FUN-A60052--mark--end
 
      AFTER FIELD lpx21
         IF NOT cl_null(g_lpx.lpx21) THEN
            IF g_lpx.lpx21 < 1 OR g_lpx.lpx21 > 16 THEN
               CALL cl_err('','alm-359',0)
               NEXT FIELD lpx21
            END IF
            CALL i660_lpx21()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpx.lpx21,g_errno,1)
               LET g_lpx.lpx21 = g_lpx_t.lpx21
               NEXT FIELD lpx21
            END IF
         END IF
 
      AFTER FIELD lpx22
         IF NOT cl_null(g_lpx.lpx22) THEN
            IF g_lpx.lpx22 < 0 OR g_lpx.lpx22 > 16 THEN
               CALL cl_err('','alm-360',0)
               NEXT FIELD lpx22
            END IF
            CALL i660_lpx21()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpx.lpx22,g_errno,1)
               LET g_lpx.lpx22 = g_lpx_t.lpx22
               NEXT FIELD lpx22
            END IF
         END IF
 
      AFTER FIELD lpx23
         IF NOT cl_null(g_lpx.lpx23) THEN
            CALL i660_lpx21()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpx.lpx23,g_errno,1)
               LET g_lpx.lpx23 = g_lpx_t.lpx23
               NEXT FIELD lpx23
            END IF
         END IF
 
      AFTER FIELD lpx24
         IF NOT cl_null(g_lpx.lpx24) THEN
            IF g_lpx.lpx24 < 0 OR g_lpx.lpx24 > 16 THEN
               CALL cl_err('','alm-360',0)
               NEXT FIELD lpx24
            END IF
            CALL i660_lpx21()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpx.lpx24,g_errno,1)
               LET g_lpx.lpx24 = g_lpx_t.lpx24
               NEXT FIELD lpx24
            END IF
         END IF
 
      #FUN-C50036--start mark------------------
      #AFTER FIELD lpx08
      #   IF g_lpx.lpx08 IS NOT NULL THEN
      #      CALL i660_set_entry_lpx08()
      #   END IF
      #FUN-C50036--end mark--------------------

      AFTER FIELD lpx26
         IF NOT cl_null(g_lpx.lpx26) THEN
            IF g_lpx.lpx26 = '1' THEN
               LET g_lpx.lpx30 = '2'
#FUN-BC0130 add begin ---
#              CALL cl_set_comp_entry("lpx33",TRUE)     #FUN-D10040 mark
#              CALL cl_set_comp_required("lpx33",TRUE)  #FUN-D10040 mark
#FUN-BC0130 add end -----   
#FUN-D10040 add str -----
               CALL cl_set_comp_entry("lpx37",FALSE)
               CALL cl_set_comp_required("lpx37",FALSE) 
               CALL cl_set_comp_entry("lpx28",TRUE)
               LET g_lpx.lpx37 = ''
               DISPLAY BY NAME g_lpx.lpx37
#FUN-D10040 add end ----
            ELSE
#FUN-D10040 mark str-----
#FUN-BC0130 add begin ---
#              LET g_lpx.lpx33 = ''
#              DISPLAY BY NAME g_lpx.lpx33
#              DISPLAY '' TO gec02
#              CALL cl_set_comp_entry("lpx33",FALSE)
#              CALL cl_set_comp_required("lpx33",FALSE)  
#FUN-BC0130 add end -----
#FUN-D10040 mark end-----
#FUN-D10040 add str -----
               CALL cl_set_comp_entry("lpx37",TRUE)  
               CALL cl_set_comp_required("lpx37",TRUE)  
               CALL cl_set_comp_entry("lpx28",FALSE)  
               LET g_lpx.lpx28 = ''  
               DISPLAY BY NAME g_lpx.lpx37
#FUN-D10040 add end ----
               LET g_lpx.lpx30 = '4'
            END IF
#FUN-D10040 mark str-----
          ##TQC-C30076 add START
          # CALL i660_chk_lpx33()
          # IF NOT cl_null(g_errno) THEN
          #    CALL cl_err(g_lpx.lpx32,g_errno,0)
          #    LET g_lpx.lpx26 = g_lpx_t.lpx26
          #    LET g_errno = ' '
          #    NEXT FIELD lpx26
          # END IF
          ##TQC-C30076 add END
#FUN-D10040 mark end-----
         END IF
      
#FUN-D10040-------add----str
      AFTER FIELD lpx37
         IF NOT cl_null(g_lpx.lpx37) THEN
            IF g_lpx.lpx26 = '2' THEN
               IF g_lpx.lpx37 < 0 OR g_lpx.lpx37 > 100 THEN
                  CALL cl_err(g_lpx.lpx37,'mfg4013',0)
                  LET g_lpx.lpx37 = g_lpx_t.lpx37
                  NEXT FIELD lpx37
               END IF
            END IF
         END IF

      AFTER FIELD lpx38
         IF NOT cl_null(g_lpx.lpx38) THEN
           #FUN-D20085 mark START
           #IF g_lpx.lpx38 = 'Y' THEN
           #   CALL cl_set_comp_entry("lpx33",TRUE)
           #   CALL cl_set_comp_required("lpx33",TRUE)
           #ELSE
           #   DISPLAY BY NAME g_lpx.lpx33
           #   DISPLAY '' TO gec02
           #   CALL cl_set_comp_entry("lpx33",FALSE)
           #   CALL cl_set_comp_required("lpx33",FALSE)
           #END IF
           #FUN-D20085 mark END
            CALL i660_chk_lpx33()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpx.lpx38,g_errno,0)
               LET g_lpx.lpx38 = g_lpx_t.lpx38
               LET g_errno = ' '
               NEXT FIELD lpx38
            END IF
         END IF
#FUN-D10040-------add----end
         
      AFTER FIELD lpx28
         IF NOT cl_null(g_lpx.lpx28) THEN
            CALL i660_lpx28(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpx.lpx28,g_errno,1)
               LET g_lpx.lpx28 = g_lpx_t.lpx28
               NEXT FIELD lpx28
            END IF
         END IF   

      AFTER FIELD lpx32  #券对应商品
         IF NOT cl_null(g_lpx.lpx32) THEN
           #FUN-D30050--add--str---
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lpx.lpx32 != g_lpx_t.lpx32) THEN
               SELECT COUNT(*) INTO l_n FROM lpx_file WHERE lpx32 = g_lpx.lpx32 AND lpx15 = 'Y'
               IF l_n > 0 THEN
                  CALL cl_err(g_lpx.lpx32,'alm2010',0)
                  LET g_lpx.lpx32= g_lpx_t.lpx32
                  NEXT FIELD lpx32
               END IF
            END IF
           #FUN-D30050--add--end---
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_lpx.lpx32,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_lpx.lpx32= g_lpx_t.lpx32
               NEXT FIELD lpx32
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            CALL i660_lpx32('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpx.lpx32,g_errno,0)
               LET g_lpx.lpx32 = g_lpx_t.lpx32
               NEXT FIELD lpx32
            END IF
           #TQC-C30076 add START
            CALL i660_chk_lpx33()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpx.lpx32,g_errno,0)
               LET g_lpx.lpx32 = g_lpx_t.lpx32
               LET g_errno = ' '
               NEXT FIELD lpx32
            END IF           
           #TQC-C30076 add END
         END IF


#FUN-BC0130 add begin ---
      AFTER FIELD lpx33  #已开发票礼券税别
          IF NOT cl_null(g_lpx.lpx33) THEN
             CALL i660_lpx33(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_lpx.lpx33,g_errno,0)
                LET g_lpx.lpx33 = g_lpx_t.lpx33
                DISPLAY '' TO gec02
                NEXT FIELD lpx33
             END IF
           #TQC-C30076 add START
            CALL i660_chk_lpx33()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpx.lpx32,g_errno,0)
               LET g_lpx.lpx33 = g_lpx_t.lpx33
               LET g_errno = ' '
               NEXT FIELD lpx33
            END IF
           #TQC-C30076 add END
          END IF
#FUN-BC0130 add end -----

      #FUN-C50036--start add--------------------------------------
      ON CHANGE lpx08
         CALL i660_set_entry_lpx08() 
       
      AFTER FIELD lpx35
         IF NOT cl_null(g_lpx.lpx35) THEN
            IF g_lpx.lpx35 < 0 THEN
               CALL cl_err('','alm-342',0)
               LET g_lpx.lpx35 = g_lpx_t.lpx35
               DISPLAY BY NAME g_lpx.lpx35
               NEXT FIELD lpx35
            END IF 
         END IF 

      AFTER FIELD lpx03
         IF NOT cl_null(g_lpx.lpx03) THEN
            IF NOT cl_null(g_lpx.lpx04) THEN
               IF g_lpx.lpx03 > g_lpx.lpx04 THEN
                  CALL cl_err('','alm-402',0)
                  LET g_lpx.lpx03 = g_lpx_t.lpx03
                  DISPLAY BY NAME g_lpx.lpx03
                  NEXT FIELD lpx03
               END IF 
            END IF 
         END IF 

      AFTER FIELD lpx04
         IF NOT cl_null(g_lpx.lpx04) THEN
            IF NOT cl_null(g_lpx.lpx04) THEN
               IF g_lpx.lpx04 < g_lpx.lpx03 THEN
                  CALL cl_err('','alm-403',0)
                  LET g_lpx.lpx04 = g_lpx_t.lpx04
                  DISPLAY BY NAME g_lpx.lpx04
                  NEXT FIELD lpx04
               END IF 
            END IF
         ELSE #MOD-D70068 add begin---
            CALL cl_err('lpx04','azz-550',0)
            NEXT FIELD lpx04   
            #MOD-D70068 add end--- 
         END IF  
      #FUN-C50036--end add----------------------------------------
 
      AFTER INPUT
         LET g_lpx.lpxuser = s_get_data_owner("lpx_file") #FUN-C10039 
         LET g_lpx.lpxgrup = s_get_data_group("lpx_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_lpx.lpx22 > 0 AND cl_null(g_lpx.lpx23) THEN
               CALL cl_err('','alm-520',0)
               NEXT FIELD lpx23
            END IF
            IF g_lpx.lpx01 IS NULL THEN
               DISPLAY BY NAME g_lpx.lpx01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD lpx01
            END IF
 
      ON ACTION CONTROLP
         CASE 
          #FUN-A60052--mark--str--
          # WHEN INFIELD(lpx19)
          #    CALL cl_init_qry_var()
          #    LET g_qryparam.form ="q_aag"
          #    LET g_qryparam.default1 = g_lpx.lpx19
          #    LET g_qryparam.arg1 = g_aza.aza81
          #    CALL cl_create_qry() RETURNING g_lpx.lpx19
          #    DISPLAY BY NAME g_lpx.lpx19
          #    NEXT FIELD lpx19
          # WHEN INFIELD(lpx20)
          #    CALL cl_init_qry_var() 
          #    LET g_qryparam.form ="q_aag" 
          #    LET g_qryparam.default1 = g_lpx.lpx20 
          #    LET g_qryparam.arg1 = g_aza.aza82
          #    CALL cl_create_qry() RETURNING g_lpx.lpx20
          #    DISPLAY BY NAME g_lpx.lpx20
          #    NEXT FIELD lpx20
          #FUN-A60052--mark--end
            WHEN INFIELD(lpx28)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lrz"
               LET g_qryparam.default1 = g_lpx.lpx28
               CALL cl_create_qry() RETURNING g_lpx.lpx28
               DISPLAY BY NAME g_lpx.lpx28
               NEXT FIELD lpx28
            WHEN INFIELD(lpx32)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form="q_ima"
          #  #  LET g_qryparam.where = " ima105 = 'Y' "  #TQC-A60062 -mark
             #  LET g_qryparam.where = " ima154 = 'Y' "  #TQC-A60062 -add
             #  LET g_qryparam.default1 = g_lpx.lpx32
             #  CALL cl_create_qry() RETURNING g_lpx.lpx32
             # CALL q_sel_ima(FALSE, "q_ima", "ima154 = 'Y'", g_lpx.lpx32, "", "", "", "" ,"",'' )  RETURNING g_lpx.lpx32    #TQC-C80091 mark
               CALL q_sel_ima(FALSE, "q_ima", "ima154 = 'Y' AND ima1010 = '1'", g_lpx.lpx32, "", "", "", "" ,"",'' )  RETURNING g_lpx.lpx32    #TQC-C80091 add 
#FUN-AA0059 --End--
               DISPLAY BY NAME  g_lpx.lpx32
               NEXT FIELD lpx32
#FUN-BC0130 add begin ---
            WHEN INFIELD(lpx33)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gec"
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.default1 = g_lpx.lpx33
               CALL cl_create_qry() RETURNING g_lpx.lpx33
               DISPLAY BY NAME g_lpx.lpx33
               CALL i660_lpx33('d')
               NEXT FIELD lpx33
#FUN-BC0130 add end -----
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLO  
         IF INFIELD(lpx01) THEN
            LET g_lpx.* = g_lpx_t.*
            CALL i660_show()
            NEXT FIELD lpx01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
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
 
#FUN-BC0130 add begin ---
FUNCTION i660_lpx33(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_gec02   LIKE gec_file.gec02
   DEFINE l_gecacti LIKE gec_file.gecacti
   SELECT gec02,gecacti INTO l_gec02,l_gecacti
     FROM gec_file
    WHERE gec01 = g_lpx.lpx33
      AND gec011 = '2'
   CASE WHEN SQLCA.sqlcode=100  LET g_errno='alm-921'
                                LET l_gec02=''
        WHEN l_gecacti<>'Y'     LET g_errno='alm-142'
        OTHERWISE               LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE   
   IF cl_null(g_errno) OR p_cmd = 'd' THEN 
      DISPLAY l_gec02 TO gec02
   END IF 
END FUNCTION
#FUN-BC0130 add end -----

#FUN-A60052--mark--str--
#FUNCTION i660_lpx19(p_cmd)
#  DEFINE p_cmd      LIKE type_file.chr1
#  DEFINE l_aag02    LIKE aag_file.aag02
#  DEFINE l_aagacti  LIKE aag_file.aagacti
#  
#  SELECT aag02,aagacti INTO l_aag02,l_aagacti
#    FROM aag_file
#   WHERE aag01 = g_lpx.lpx19
#     AND aag00 = g_aza.aza81
#  CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-088'
#                              LET l_aag02=NULL
#       WHEN l_aagacti='N'     LET g_errno='9028'
#       OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#  END CASE
#  IF cl_null(g_errno) OR p_cmd= 'd'  THEN
#    DISPLAY l_aag02 TO formonly.aag02
#  END IF 
#END FUNCTION
 
#FUNCTION i660_lpx20(p_cmd)
#  DEFINE p_cmd      LIKE type_file.chr1
#  DEFINE l_aag02    LIKE aag_file.aag02
#  DEFINE l_aagacti  LIKE aag_file.aagacti
#  
#  SELECT aag02,aagacti INTO l_aag02,l_aagacti
#    FROM aag_file
#   WHERE aag01 = g_lpx.lpx20
#     AND aag00 = g_aza.aza82
#  CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-088'
#                              LET l_aag02=NULL
#       WHEN l_aagacti='N'     LET g_errno='9028'
#       OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
#  END CASE
#  IF cl_null(g_errno) OR p_cmd= 'd'  THEN
#    DISPLAY l_aag02 TO formonly.aag02_1
#  END IF 
#END FUNCTION
#FUN-A60052--mark--end
 
FUNCTION i660_lpx21()
   LET g_errno = ' '
   IF NOT cl_null(g_lpx.lpx21) AND NOT cl_null(g_lpx.lpx22) THEN
      IF g_lpx.lpx21 < g_lpx.lpx22 THEN
         LET g_errno = 'alm-385'
      END IF
   END IF
 
   IF NOT cl_null(g_lpx.lpx23) AND NOT cl_null(g_lpx.lpx22) THEN
      IF g_lpx.lpx22 <> LENGTH(g_lpx.lpx23) THEN
         LET g_errno = 'alm-386'
       ELSE
         SELECT COUNT(*) INTO g_cnt FROM lpx_file
          WHERE lpx23 = g_lpx.lpx23 
            AND lpx23 <> g_lpx_t.lpx23
         IF g_cnt > 0 THEN
            LET g_errno = 'alm-707'
         END IF
      END IF
   END IF
 
   IF NOT cl_null(g_lpx.lpx21) AND NOT cl_null(g_lpx.lpx24) THEN
      IF g_lpx.lpx21 < g_lpx.lpx24 THEN
         LET g_errno = 'alm-387'
      END IF
   END IF
 
   IF NOT cl_null(g_lpx.lpx21) AND NOT cl_null(g_lpx.lpx22) AND 
      NOT cl_null(g_lpx.lpx24) THEN
      IF g_lpx.lpx22 + g_lpx.lpx24 <> g_lpx.lpx21 THEN
         LET g_errno = 'alm-388'
      END IF
   END IF

  #FUN-C70077 Add Begin ---
   IF NOT cl_null(g_lpx.lpx21) AND NOT cl_null(g_lpx.lpx22) AND
      cl_null(g_lpx.lpx24) THEN
      LET g_lpx.lpx24 = g_lpx.lpx21 - g_lpx.lpx22
      DISPLAY BY NAME g_lpx.lpx24
   END IF
  #FUN-C70077 Add End -----

END FUNCTION

FUNCTION i660_lpx28(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_lrz02    LIKE lrz_file.lrz02
   DEFINE l_lrz03    LIKE lrz_file.lrz03

   SELECT lrz02,lrz03 INTO l_lrz02,l_lrz03
     FROM lrz_file
    WHERE lrz01 = g_lpx.lpx28
   CASE WHEN SQLCA.sqlcode=100 LET g_errno = 'alm-421'
                               LET l_lrz02 = NULL
                               LET l_lrz03 = NULL
        WHEN l_lrz03 = 'N'     LET g_errno = '9028'
        OTHERWISE              LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
     DISPLAY l_lrz02 TO formonly.lrz02
   END IF
END FUNCTION

FUNCTION i660_lpx32(p_cmd)
 DEFINE p_cmd LIKE type_file.chr1
 DEFINE l_ima02 LIKE ima_file.ima02
#DEFINE l_ima105 LIKE ima_file.ima105    #TQC-A60062 -mark
 DEFINE l_ima154 LIKE ima_file.ima154    #TQC-A60062 -add
 DEFINE l_imaacti LIKE ima_file.imaacti
 DEFINE l_ima1010 LIKE ima_file.ima1010

#TQC-A60062 -modify
#   SELECT ima02,ima105,imaacti,ima1010
#     INTO l_ima02,l_ima105,l_imaacti,l_ima1010
    SELECT ima02,ima154,imaacti,ima1010
      INTO l_ima02,l_ima154,l_imaacti,l_ima1010
#TQC-A60062 -end
      FROM ima_file
     WHERE ima01 = g_lpx.lpx32
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='aco-001'
                               LET l_ima02=NULL
        WHEN l_imaacti='N'     LET g_errno='9028'
        WHEN l_ima1010='0'     LET g_errno='art-182'
#       WHEN l_ima105='N'      LET g_errno='alm1562'  #TQC-A60062 -modify
        WHEN l_ima154='N' OR l_ima154 IS NULL    LET g_errno='alm1562'  #TQC-A60062 -modify    #TQC-A70037 add l_ima154 is null
        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
     DISPLAY l_ima02 TO formonly.lpx32_desc
   END IF
END FUNCTION
 
FUNCTION i660_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lpx.* TO NULL 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i660_curs() 
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i660_count
    FETCH i660_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i660_cs 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lpx.lpx01,SQLCA.sqlcode,0)
        INITIALIZE g_lpx.* TO NULL
    ELSE
        CALL i660_fetch('F')
    END IF
END FUNCTION
 
FUNCTION i660_fetch(p_fllpx)
    DEFINE
        p_fllpx         LIKE type_file.chr1
 
    CASE p_fllpx
       WHEN 'N' FETCH NEXT     i660_cs INTO g_lpx.lpx01
       WHEN 'P' FETCH PREVIOUS i660_cs INTO g_lpx.lpx01
       WHEN 'F' FETCH FIRST    i660_cs INTO g_lpx.lpx01
       WHEN 'L' FETCH LAST     i660_cs INTO g_lpx.lpx01
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
           FETCH ABSOLUTE g_jump i660_cs INTO g_lpx.lpx01
           LET g_no_ask = FALSE  
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lpx.lpx01,SQLCA.sqlcode,0)
        INITIALIZE g_lpx.* TO NULL
        RETURN
    ELSE
      CASE p_fllpx
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx 
    END IF
 
    SELECT * INTO g_lpx.* FROM lpx_file 
       WHERE lpx01 = g_lpx.lpx01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lpx_file",g_lpx.lpx01,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_lpx.lpxuser
        LET g_data_group=g_lpx.lpxgrup
        CALL i660_show()
    END IF
END FUNCTION
 
FUNCTION i660_show()
    LET g_lpx_t.* = g_lpx.*
    DISPLAY BY NAME g_lpx.lpx01,g_lpx.lpx02,g_lpx.lpx05,
                    #g_lpx.lpx06,g_lpx.lpx07,g_lpx.lpx08,g_lpx.lpx09,g_lpx.lpx10,               #FUN-C50036 mark 
                    #g_lpx.lpx06,g_lpx.lpx07,g_lpx.lpx08,g_lpx.lpx09,g_lpx.lpx10,g_lpx.lpx35,   #FUN-C50036 add   #FUN-C90043 mark
                    #g_lpx.lpx11,g_lpx.lpx12,g_lpx.lpx13,g_lpx.lpx14,g_lpx.lpx15,               #FUN-C90043 mark
                    g_lpx.lpx07,g_lpx.lpx36,g_lpx.lpx08,g_lpx.lpx10,g_lpx.lpx35,g_lpx.lpx15,    #FUN-C90043 add   #FUN-CB0109 add lpx36
                   #g_lpx.lpx16,g_lpx.lpx17,g_lpx.lpx18,g_lpx.lpx19,g_lpx.lpx20,   #FUN-A60052
                    g_lpx.lpx16,g_lpx.lpx17,g_lpx.lpx18,                           #FUN-A60052 
                    g_lpx.lpxuser,g_lpx.lpxmodu,g_lpx.lpxgrup,g_lpx.lpxdate,
                    g_lpx.lpxacti,g_lpx.lpxcrat,g_lpx.lpxoriu,g_lpx.lpxorig,g_lpx.lpxpos, #TQC-B40185 add lpxpos
                    g_lpx.lpx21,g_lpx.lpx22,g_lpx.lpx23,g_lpx.lpx24,                #FUN-A30030 mark g_lpx.lpx25,
                   #g_lpx.lpx26,g_lpx.lpx28,g_lpx.lpx29,g_lpx.lpx31#,g_lpx.lpx32     #TQC-A70037 modify
                    g_lpx.lpx26,g_lpx.lpx33,g_lpx.lpx28,g_lpx.lpx29,g_lpx.lpx31,g_lpx.lpx32,      #TQC-A70037 add g_lpx.lpx32    #FUN-BC0130 add lpx33
                    g_lpx.lpx03,g_lpx.lpx04,g_lpx.lpx37,g_lpx.lpx38                               #FUN-C50036 add #FUN-D10040 add ,g_lpx.lpx37,g_lpx.lpx38

   #CALL i660_lpx19("d")    #FUN-A60052
   #CALL i660_lpx20("d")    #FUN-A60052
    CALL i660_lpx28("d")
    CALL i660_lpx32("d")
    CALL i660_lpx33("d")    #FUN-BC0130 
    CALL i660_field_pic()
    CALL cl_show_fld_cont() 
END FUNCTION
 
FUNCTION i660_field_pic()
     LET g_void=NULL
     LET g_approve=NULL
     LET g_confirm=NULL
     IF g_lpx.lpx15 MATCHES '[Yy]' THEN
        IF g_lpx.lpx14 MATCHES '[SsRrWw0]' THEN
           LET g_confirm='Y'
           LET g_approve='N'
           LET g_void='N'
        END IF
        IF g_lpx.lpx14 MATCHES '[1]' THEN
           LET g_confirm='Y'
           LET g_approve='Y'
           LET g_void='N'
        END IF
     ELSE
        IF g_lpx.lpx15 ='X' THEN
           LET g_confirm='N'
           LET g_approve='N'
           LET g_void='Y'
        ELSE
           LET g_confirm='N'
           LET g_approve='N'
           LET g_void='N'
        END IF
     END IF
     CALL cl_set_field_pic(g_confirm,g_approve,"","",g_void,g_lpx.lpxacti)
END FUNCTION
 
FUNCTION i660_u(p_cmd)
    DEFINE   p_cmd     LIKE type_file.chr1
    IF g_lpx.lpx01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lpx.* FROM lpx_file WHERE lpx01=g_lpx.lpx01
    IF g_lpx.lpxacti = 'N' THEN
       CALL cl_err('',9027,0) 
       RETURN
    END IF
    IF g_lpx.lpx15 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
    IF g_lpx.lpx15 = 'X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lpx01_t = g_lpx.lpx01
    BEGIN WORK
 
    OPEN i660_cl USING g_lpx.lpx01
    IF STATUS THEN
       CALL cl_err("OPEN i660_cl:", STATUS, 1)
       CLOSE i660_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i660_cl INTO g_lpx.* 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpx.lpx01,SQLCA.sqlcode,1)
        RETURN
    END IF
    IF p_cmd="u" THEN
       LET g_lpx.lpxmodu=g_user 
       LET g_lpx.lpxdate = g_today
       IF g_aza.aza88='Y' THEN        #FUN-A30030 ADD
         #FUN-B40071 --START--
          #LET g_lpx.lpxpos = 'N'      #FUN-A30030 ADD
          IF g_lpx.lpxpos <> '1' THEN
            LET g_lpx.lpxpos = '2'          
          END IF
         #FUN-B40071 --END--
       END IF
    END IF
    IF p_cmd="c" THEN
       LET g_lpx.lpxmodu=NULL
       LET g_lpx.lpxdate=NULL
    END IF
    CALL i660_show()
    WHILE TRUE
        CALL i660_i("u") 
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lpx.*=g_lpx_t.*
            CALL i660_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END if
        
        IF g_lpx.lpx14 MATCHES '[SsWwRr1]' THEN 
           LET g_lpx.lpx14 = '0' 
        END IF
        UPDATE lpx_file SET lpx_file.* = g_lpx.* 
            WHERE lpx01 = g_lpx01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lpx_file",g_lpx.lpx01,"",SQLCA.sqlcode,"","",0) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i660_cl
    COMMIT WORK
    SELECT * INTO g_lpx.* FROM lpx_file WHERE lpx01 = g_lpx.lpx01
    CALL i660_show()
END FUNCTION
 
FUNCTION i660_x()
    IF g_lpx.lpx01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lpx.* FROM lpx_file WHERE lpx01=g_lpx.lpx01
    IF g_lpx.lpx15 = 'Y' THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF
    IF g_lpx.lpx15 = 'X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END if
    IF g_lpx.lpx14 MATCHES '[Ss1]' then
      CALL cl_err('','mfg3557',0)
      return
   END IF
    
    BEGIN WORK
 
    OPEN i660_cl USING g_lpx.lpx01
    IF STATUS THEN
       CALL cl_err("OPEN i660_cl:", STATUS, 1)
       CLOSE i660_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i660_cl INTO g_lpx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpx.lpx01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL i660_show()
    IF cl_exp(0,0,g_lpx.lpxacti) THEN
        LET g_chr=g_lpx.lpxacti
        IF g_lpx.lpxacti='Y' THEN
            LET g_lpx.lpxacti='N'
        ELSE
            LET g_lpx.lpxacti='Y'
        END IF
        UPDATE lpx_file
           SET lpxacti=g_lpx.lpxacti,
               lpxmodu=g_user,
               lpxdate=g_today
         WHERE lpx01=g_lpx.lpx01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_lpx.lpx01,SQLCA.sqlcode,0)
           LET g_lpx.lpxacti=g_chr
        ELSE
           LET g_lpx.lpxmodu=g_user
           LET g_lpx.lpxdate=g_today
           DISPLAY BY NAME g_lpx.lpxacti,g_lpx.lpxmodu,g_lpx.lpxdate
           CALL cl_set_field_pic("","","","","",g_lpx.lpxacti)
        END IF
    END IF
    CLOSE i660_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i660_r()
    DEFINE l_cnt LIKE type_file.num5
    IF g_lpx.lpx01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END if
    SELECT * INTO g_lpx.* FROM lpx_file WHERE lpx01=g_lpx.lpx01
    IF g_lpx.lpxacti = 'N' THEN
       CALL cl_err('',9027,0) 
       RETURN
    END IF
 
    IF g_lpx.lpx15 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF
    IF g_lpx.lpx15 = 'X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
    IF g_lpx.lpx14 MATCHES '[Ss1]' then
      CALL cl_err('','mfg3557',0)
      RETURN 
    END IF
   #FUN-A30030 ADD--------------------
    IF g_aza.aza88 = 'Y' THEN
      #FUN-B40071 --START--
       #IF g_lpx.lpxacti='Y' OR g_lpx.lpxpos='N' THEN
       #   CALL cl_err('','art-648',0)
       #   RETURN
       #END IF
       IF NOT ((g_lpx.lpxpos='3' AND g_lpx.lpxacti='N') 
                 OR (g_lpx.lpxpos='1'))  THEN                  
         CALL cl_err('','apc-139',0)            
         RETURN
      END IF      
      #FUN-B40071 --END--
    END IF 
   #FUN-A30030 END--------------------

    BEGIN WORK
 
    OPEN i660_cl USING g_lpx.lpx01
    IF STATUS THEN
       CALL cl_err("OPEN i660_cl:", STATUS, 0)
       CLOSE i660_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i660_cl INTO g_lpx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpx.lpx01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i660_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lpx01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lpx.lpx01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lpx_file WHERE lpx01 = g_lpx.lpx01
       #SELECT count(*) INTO l_cnt FROM lni_file WHERE lni01 = g_lpx.lpx01                     #FUN-C90043 mark
       SELECT count(*) INTO l_cnt FROM lnk_file WHERE lnk01 = g_lpx.lpx01 AND lnk02 = '2'      #FUN-C90043 add
       IF l_cnt > 0 THEN
          #DELETE FROM lni_file WHERE lni01=g_lpx.lpx01 AND lni02 = '5'  #FUN-C90043 mark
          DELETE FROM lnk_file WHERE lnk01=g_lpx.lpx01 AND lnk02 = '2'   #FUN-C90043 add
       END IF
       CLEAR FORM
       OPEN i660_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE i660_cs
          CLOSE i660_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH i660_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i660_cs
          CLOSE i660_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i660_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i660_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i660_fetch('/')
       END IF
    END IF
    CLOSE i660_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i660_copy()
    DEFINE
        l_newno    LIKE lpx_file.lpx01,
        l_oldno    LIKE lpx_file.lpx01,
        p_cmd      LIKE type_file.chr1,
        l_n        LIKE type_file.num5,
        l_input    LIKE type_file.chr1 
 
    IF g_lpx.lpx01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL i660_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM lpx01
 
        AFTER FIELD lpx01
           IF l_newno IS NOT NULL THEN
              SELECT COUNT(*) INTO l_n FROM lpx_file 
                WHERE lpx01 = l_newno 
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD lpx01
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
        DISPLAY BY NAME g_lpx.lpx01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM lpx_file
        WHERE lpx01 = g_lpx.lpx01
        INTO TEMP x
    UPDATE x
        SET lpx01=l_newno,
            #lpx13='N',   #FUN-C90043 mark
            #lpx14='0',   #FUN-C90043 mark
            lpx15='N',
            lpx16='',
            lpx17='',
            lpx23 = '',
            lpxacti='Y', 
            lpxpos='1',     #FUN-A30030 ADD #NO.FUN-B40071
            lpxuser=g_user,
            lpxgrup=g_grup, 
            lpx03 = g_today,        #FUN-C50036 add
            lpx04 = "2099/12/31",   #FUN-C50036 add
            lpxmodu=NULL,  
            lpxdate=NULL, 
            lpxcrat=g_today
               
 
    INSERT INTO lpx_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","lpx_file",g_lpx.lpx01,"",SQLCA.sqlcode,"","",0)
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_lpx.lpx01
        LET g_lpx.lpx01 = l_newno
        SELECT lpx_file.* INTO g_lpx.* FROM lpx_file
               WHERE lpx01 = l_newno
        CALL i660_u("c")
        #SELECT lpx_file.* INTO g_lpx.* FROM lpx_file #FUN-C30027
        # WHERE lpx01 = l_oldno                       #FUN-C30027
    END IF
    #LET g_lpx.lpx01 = l_oldno                        #FUN-C30027
    CALL i660_show()
END FUNCTION
 
FUNCTION i660_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lpx01",TRUE)
     END IF
     CALL cl_set_comp_required("lpx04",TRUE)  #MOD-D70068 add
END FUNCTION
 
FUNCTION i660_set_no_entry(p_cmd)
 DEFINE   p_cmd     LIKE type_file.chr1
   IF p_cmd = 'u' AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("lpx01",FALSE)
   END IF
#  CALL cl_set_comp_entry("lpx25",FALSE)   #FUN-A30030 MARK
   CALL cl_set_comp_entry("lpxpos",FALSE)  #FUN-A30030 ADD
END FUNCTION
 
FUNCTION i660_set_entry_lpx08()
     IF g_lpx.lpx08 = 'Y' THEN
        CALL cl_set_comp_entry("lpx10",TRUE)
        CALL cl_set_comp_required("lpx10",TRUE)
        CALL cl_set_comp_entry("lpx35",TRUE )     #FUN-C50036 add
     ELSE 
        CALL cl_set_comp_entry("lpx35",FALSE)     #FUN-C50036 add    
        CALL cl_set_comp_entry("lpx10",FALSE)
        CALL cl_set_comp_required("lpx10",FALSE)
        LET g_lpx.lpx10 = NULL
        LET g_lpx.lpx35 = NULL            #FUN-C50036 add
        DISPLAY BY NAME g_lpx.lpx35       #FUN-C50036 add
        DISPLAY BY NAME g_lpx.lpx10
     END IF
END FUNCTION

FUNCTION i660_set_entry_lpx05()
     IF g_lpx.lpx05 = 'Y' THEN
        CALL cl_set_comp_entry("lpx29",TRUE)
        CALL cl_set_comp_required("lpx29",TRUE)
     ELSE
        CALL cl_set_comp_entry("lpx29",FALSE)
        CALL cl_set_comp_required("lpx29",FALSE)
        LET g_lpx.lpx29 = NULL
        DISPLAY BY NAME g_lpx.lpx29
     END IF
END FUNCTION
 
FUNCTION i660_y()
DEFINE l_n    LIKE type_file.num5    #TQC-B60241 ADD

   IF cl_null(g_lpx.lpx01) THEN 
        CALL cl_err('','-400',0) 
        RETURN 
   END IF
   
   SELECT * INTO g_lpx.* FROM lpx_file WHERE lpx01=g_lpx.lpx01
   IF g_lpx.lpxacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
   
   IF g_lpx.lpx15='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF
 
   IF g_lpx.lpx15 = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
  
   #FUN-C90043---mark---str 
   #IF g_lpx.lpx14 != '1' AND g_lpx.lpx13='Y' THEN                                                   
   #   CALL cl_err('','alm-029',0)                                               
   #   RETURN                                                                    
   #END IF
   #FUN-C90043---mark---end

  #TQC-B60241 - ADD - BEGIN -----------------------
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM lnk_file WHERE lnk01 = g_lpx.lpx01 AND lnk02 = '2'
   IF l_n = 0 THEN
      CALL cl_err('','alm-438',0)
      RETURN
   END IF 
  #TQC-B60241 - ADD -  END  -----------------------

  #FUN-D30050--add--str---
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM lpx_file WHERE lpx32 = g_lpx.lpx32 AND lpx15 = 'Y'
   IF l_n > 0 THEN
      CALL cl_err(g_lpx.lpx32,'alm2010',0)
      RETURN
   END IF 
  #FUN-D30050--add--end---
   
   IF NOT cl_confirm('alm-006') THEN 
        RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i660_cl USING g_lpx.lpx01
   IF STATUS THEN
      CALL cl_err("OPEN i660_cl:", STATUS, 1)
      CLOSE i660_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i660_cl INTO g_lpx.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpx.lpx01,SQLCA.sqlcode,0)      
      CLOSE i660_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE lpx_file SET lpx15 = 'Y',lpx16 = g_user,lpx17 = g_today
    WHERE lpx01 = g_lpx.lpx01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lpx_file",g_lpx.lpx01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
      LET g_lpx.lpx15 = 'Y'
      LET g_lpx.lpx16 = g_user
      LET g_lpx.lpx17 = g_today
      DISPLAY BY NAME g_lpx.lpx15,g_lpx.lpx16,g_lpx.lpx17
      CALL i660_field_pic()
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i660_z()
   #DEFINE l_cnt    LIKE type_file.num5   #FUN-C90046 mark
   DEFINE l_lnk03  LIKE lnk_file.lnk03    #FUN-C90043 add

   IF cl_null(g_lpx.lpx01) THEN 
      CALL cl_err('','-400',0) 
      RETURN 
   END IF
   SELECT * INTO g_lpx.* FROM lpx_file WHERE lpx01=g_lpx.lpx01
   IF g_lpx.lpxacti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF
   
   IF g_lpx.lpx15='N' THEN 
      CALL cl_err('','9025',0)
      RETURN
   END IF
 
   IF g_lpx.lpx15='X' THEN 
      CALL cl_err('','9024',0)
      RETURN
   END IF

   #FUN-C90043---mark--str
   #SELECT count(*) INTO l_cnt FROM lpy_file
   # WHERE lpy04 = g_lpx.lpx01
   #IF l_cnt > 0 THEN
   #   CALL cl_err('','alm-364',0)
   #   RETURN
   #END IF
   #FUN-C90043---mark--end
   #FUN-C90043---add---str
   LET g_cnt = 0
   SELECT count(*) INTO g_cnt FROM lqe_file
    WHERE lqe02 = g_lpx.lpx01
   IF g_cnt > 0 THEN
      CALL cl_err('','alm-364',0)
      RETURN
   END IF
   LET g_cnt = 0
   LET g_sql = "SELECT lnk03 FROM lnk_file",
               " WHERE lnk01 = '",g_lpx.lpx01,"'",
               "   AND lnk02 = '2'"
   PREPARE pre_sel_lnk FROM g_sql
   DECLARE pre_sel_lnk_cs CURSOR FOR pre_sel_lnk
   FOREACH pre_sel_lnk_cs INTO l_lnk03
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_lnk03,'lpz_file'),
                  " WHERE lpz02 = '",g_lpx.lpx01,"' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_lnk03) RETURNING g_sql
      PREPARE pre_sel_lpz FROM g_sql
      EXECUTE pre_sel_lpz INTO g_cnt
      IF g_cnt > 0 THEN
         EXIT FOREACH
      ELSE
         CONTINUE FOREACH
      END IF
   END FOREACH
   IF g_cnt > 0 THEN
      CALL cl_err('','alm-364',0)
      RETURN
   END IF
   #FUN-C90043---add---end

   IF NOT cl_confirm('alm-008') THEN 
      RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i660_cl USING g_lpx.lpx01
   IF STATUS THEN
      CALL cl_err("OPEN i660_cl:", STATUS, 1)
      CLOSE i660_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i660_cl INTO g_lpx.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpx.lpx01,SQLCA.sqlcode,0)      
      CLOSE i660_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   #UPDATE lpx_file SET lpx15 = 'N',lpx16 = '',lpx17 = '',         #CHI-D20015 mark
   UPDATE lpx_file SET lpx15 = 'N',lpx16 = g_user,lpx17 = g_today, #CHI-D20015 add 
                       lpxmodu = g_user,lpxdate = g_today
    WHERE lpx01 = g_lpx.lpx01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lpx_file",g_lpx.lpx01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE 
   LET g_lpx.lpx15 = 'N'
   #CHI-D20015--modify--str--
   #LET g_lpx.lpx16 = ''
   #LET g_lpx.lpx17 = ''
   LET g_lpx.lpx16 = g_user
   LET g_lpx.lpx17 = g_today 
   #CHI-D20015--modify--str--
   LET g_lpx.lpxmodu = g_user
   LET g_lpx.lpxdate = g_today
   DISPLAY BY NAME g_lpx.lpx15,g_lpx.lpx16,g_lpx.lpx17,
                   g_lpx.lpxmodu,g_lpx.lpxdate
   CALL i660_field_pic()
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION i660_ef()
   IF g_lpx.lpx01 IS NULL THEN 
      CALL cl_err('','-400',0)
      RETURN 
   END IF
   
   SELECT * INTO g_lpx.* FROM lpx_file WHERE lpx01=g_lpx.lpx01
   IF g_lpx.lpxacti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF
   
   IF g_lpx.lpx15 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END if
 
    IF g_lpx.lpx15 = 'X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
 
   IF g_lpx.lpx14 MATCHES '[Ss1]' THEN 
      CALL cl_err('','mfg3557',0)
      RETURN
   END IF
  
   #FUN-C90043---mark---str
   #IF g_lpx.lpx13='N' THEN 
   #   CALL cl_err('','mfg3549',0)
   #   RETURN
   #END IF
   #FUN-C90043---mark---end
 
   IF g_success = "N" THEN
      RETURN
   END IF
 
   CALL aws_condition()      #瓚剿冞ワ訧蹋
   IF g_success = 'N' THEN
      RETURN
   END IF
 
##########
# CALL aws_efcli2()
##########
 
#  IF aws_efcli2(base.TypeInfo.create(g_lpx),'','','','','')
#  THEN
#      LET g_success = 'Y'
#      LET g_lpx.lpx14 = 'S' 
#      DISPLAY BY NAME g_lpx.lpx14
#  ELSE
#      LET g_success = 'N'
#  END IF
END FUNCTION
#No.FUN-960134
#TQC-C30076 add START
FUNCTION i660_chk_lpx33()
DEFINE l_n       LIKE type_file.num10 
DEFINE l_gec04   LIKE gec_file.gec04  #FUN-D20085 add

   LET g_errno = ' '
   #IF g_lpx.lpx26 = '1' THEN  #已開發票的禮券   #FUN-D10040 mark
   IF g_lpx.lpx38 = 'Y' THEN   #已開發票         #FUN-D10040 add
      IF NOT cl_null(g_lpx.lpx32) AND NOT cl_null(g_lpx.lpx33) THEN
         LET l_n = 0 
         SELECT COUNT(*) INTO l_n FROM lpx_file
           WHERE lpx32 = g_lpx.lpx32
             AND lpx33 <> g_lpx.lpx33
         IF l_n > 0 THEN 
            LET g_errno = 'alm-h19'
            RETURN
         END IF
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM lpx_file
            WHERE lpx32 = g_lpx.lpx32
              AND lpx38 = 'N'          #FUN-D10040 add
              AND lpx01 <> g_lpx.lpx01 #FUN-D10040 add
              #AND lpx26 = '2'         #FUN-D10040 mark
         IF l_n > 0 THEN
            LET g_errno = 'alm-h20'
            RETURN
         END IF
         LET l_n = 0
         SELECT COUNT(*) INTO l_n   #計算在arti120內是否已存在此料件的產品策略
           FROM rte_file
            WHERE rte03 = g_lpx.lpx32
              AND rte07 = 'Y'
         IF l_n > 0 THEN  #判斷稅率是否與arti120內的一致 
            LET l_n = 0
            SELECT COUNT(*) INTO l_n
              FROM rte_file
              WHERE rte03 = g_lpx.lpx32
                AND rte07 = 'Y'
                AND rte08 <> g_lpx.lpx33
            IF l_n > 0 THEN  #存在不同稅率的產品
               LET g_errno = 'alm-h15'
               RETURN
            END IF
         END IF
      END IF
   END IF
   #IF g_lpx.lpx26 = '2' THEN  #未開發票的禮券  #FUN-D10040 mark
   IF g_lpx.lpx38 = 'N' THEN   #未開發票        #FUN-D10040 add
      IF NOT cl_null(g_lpx.lpx32) THEN
         LET l_n = 0 
         SELECT COUNT(*) INTO l_n FROM lpx_file
            WHERE lpx32 = g_lpx.lpx32
              AND lpx38 = 'Y'           #FUN-D10040 add
              AND lpx01 <> g_lpx.lpx01  #FUN-D10040 add
             #AND lpx26 = '1'           #FUN-D10040 mark
         IF l_n > 0 THEN
            LET g_errno = 'alm-h21'
            RETURN
         END IF
         LET l_n = 0
         SELECT COUNT(*) INTO l_n   #計算在arti120內是否已存在此料件的產品策略
           FROM rte_file
            WHERE rte03 = g_lpx.lpx32
              AND rte07 = 'Y'
         IF l_n > 0 THEN  #稅率,稅額必須為0
            LET l_n = 0
            SELECT COUNT(*) INTO l_n  
              FROM rte_file,rvy_file,gec_file
              WHERE rte03 = g_lpx.lpx32
                AND rte07 = 'Y'
                AND rte01 = rvy01
                AND rte02 = rvy02
                AND rvy05 = gec011
                AND gec01 = rvy04
                AND (rvy06 <> 0  OR gec04 <> 0)
            IF l_n > 0 THEN  #存在稅率,稅額不為0的產品策略
               LET g_errno = 'alm-h16'
               RETURN
            END IF
         END IF
      END IF
     #FUN-D20085 add START
     #未開發票禮券輸入的稅率必須要為銷項應稅零稅0%
      LET l_gec04 = 0
      SELECT gec04 INTO l_gec04 FROM gec_file
       WHERE gec01 = g_lpx.lpx33
         AND gec011 = '2'
      IF l_gec04 > 0 THEN
         LET g_errno = 'alm-a02'
         RETURN
      END IF
     #FUN-D20085 add END
   END IF
END FUNCTION

#TQC-C30076 add END
