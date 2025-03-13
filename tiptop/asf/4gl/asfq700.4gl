# Prog. Version..: '5.30.06-13.04.17(00009)'     #
#
# Pattern name...: asfq700.4gl
# Descriptions...: 生產排程檢視
# Date & Author..: 07/03/26 FUN-730043 BY yiting
# Modify.........: NO.TQC-740056 07/04/12 BY yiting 以工單為角度的圖拿掉
# Modify.........: NO.TQC-740056 07/04/13 By yiting 1.甘特圖，改以成本中心+生產線+工單為GROUP 秀圖，一條線代表一張工單,hint資料(工單+生產線) 
#                                                   2.甘特圖，不同成本中心時，應以虛線做為區隔
#                                                   3.以週為時距時，依aooq010時距，秀出週「起始日」及第幾週次 
# Modify.........: NO.MOD-880129 08/08/15 BY claire 先查詢有單身資料,再查詢無單身資料,程式會LOOP
# Modify.........: NO.TQC-880031 08/08/19 BY claire aooq010日期未給值,造成程式會LOOP
# Modify.........: NO.MOD-880200 08/08/26 BY claire 料號無法開窗
# Modify.........: NO.FUN-8A0135 08/12/04 BY jan 單身增加 開單日期， 狀態 欄位
# Modify.........: NO.TQC-8C0061 08/12/23 BY jan 狀態 欄位是 sfb04
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-C30789 12/03/20 By ck2yuan 進單身品名沒撈
# Modify.........: No.FUN-C30245 12/03/28 By Bart QBE查詢移至單身
# Modify.........: No.MOD-C50023 12/05/08 By ck2yuan 增加sfb13 sfb15控卡
# Modify.........: No.TQC-C50228 12/05/29 By fengrui 預計日期參照asfi301進行控卡
# Modify.........: No.FUN-C40082 12/06/15 By bart 單身增加顯示sfb22/sfb221二個欄位，可查詢不可輸入
# Modify.........: No.MOD-C60111 12/07/04 By Elise 判斷筆數大於10時才進判斷有關，改為大於5
# Modify.........: No.CHI-C60021 12/08/13 By ck2yuan g_arr1 週期的資料為空，該筆資料就從array中刪並show錯誤訊息


DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_argv1         LIKE cre_file.cre08,       #FUN-730043
    g_argv2         LIKE type_file.num5,     
    g_arr           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    ln     LIKE type_file.num5,  #項次
                    sfb98  LIKE sfb_file.sfb98,  #工作中心
                    sfb102 LIKE sfb_file.sfb102, #資源項目
                    sfb01  LIKE sfb_file.sfb01,  #工單號碼
                    sfb81  LIKE sfb_file.sfb81,  #FUN-8A0135
                   #sfb02  LIKE sfb_file.sfb02,  #FUN-8A0135
                    sfb04  LIKE sfb_file.sfb04,  #FUN-8C0049
                    sfb05  LIKE sfb_file.sfb05,  #料號
                    ima02  LIKE ima_file.ima02,  #品名
                    sfb13  LIKE sfb_file.sfb13,  #開始生產日
                    sfb15  LIKE sfb_file.sfb15,  #預計完工日
                    sfb08  LIKE sfb_file.sfb08,  #生產數量
                    un_qty LIKE sfb_file.sfb08,   #未完工數
                    sfb22  LIKE sfb_file.sfb22,  #FUN-C40082
                    sfb221 LIKE sfb_file.sfb221  #FUN-C40082
                    END RECORD,
    g_arr_t         RECORD                 #程式變數 (舊值)
                    ln     LIKE type_file.num5,  #項次
                    sfb98  LIKE sfb_file.sfb98,  #工作中心
                    sfb102 LIKE sfb_file.sfb102, #資源項目
                    sfb01  LIKE sfb_file.sfb01,  #工單號碼
                    sfb81  LIKE sfb_file.sfb81,  #FUN-8A0135
                   #sfb02  LIKE sfb_file.sfb02,  #FUN-8A0135
                    sfb04  LIKE sfb_file.sfb04,  #FUN-8C0049
                    sfb05  LIKE sfb_file.sfb05,  #料號
                    ima02  LIKE ima_file.ima02,  #品名
                    sfb13  LIKE sfb_file.sfb13,  #開始生產日
                    sfb15  LIKE sfb_file.sfb15,  #預計完工日
                    sfb08  LIKE sfb_file.sfb08,  #生產數量
                    un_qty LIKE sfb_file.sfb08,   #未完工數
                    sfb22  LIKE sfb_file.sfb22,  #FUN-C40082
                    sfb221 LIKE sfb_file.sfb221  #FUN-C40082
                    END RECORD,
    g_arr1          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    sfb98         LIKE sfb_file.sfb98,  #工作中心
                    sfb102        LIKE sfb_file.sfb102, #資源項目
                    sfb01         LIKE sfb_file.sfb01,
                    sfb13         LIKE sfb_file.sfb13,  #開始生產日
                    sfb15         LIKE sfb_file.sfb15,  #預計完工日
                    sfb13_azn05   LIKE azn_file.azn05,  #NO.TQC-740056
                    sfb15_azn05   LIKE azn_file.azn05,  #NO.TQC-740056
                    azn01_sfb13_b LIKE azn_file.azn01,  #NO.TQC-740056
                    azn01_sfb13_e LIKE azn_file.azn01,  #NO.TQC-740056
                    azn01_sfb15_b LIKE azn_file.azn01,  #NO.TQC-740056
                    azn01_sfb15_e LIKE azn_file.azn01   #NO.TQC-740056
                    END RECORD,
    g_wc,g_wc2,g_sql    string,                 #No.FUN-580092 HCN
    g_cmd               LIKE type_file.chr1000, #No.FUN-680103 VARCHAR(100) 
    g_rec_b             LIKE type_file.num5,    #No.FUN-680103 SMALLINT  #單身筆數
    l_ac                LIKE type_file.num5,    #No.FUN-680103 SMALLINT  #目前處理的ARRAY CNT
    l_n                 LIKE type_file.num5,    #No.FUN-680103 SMALLINT
    l_chr               LIKE type_file.chr1,    #No.FUN-680103 VARCHAR(1)   #確認完成的行序
    l_b                 LIKE type_file.num5     #No.FUN-680103 SMALLINT  #區分確認的input
DEFINE 
   		g_azn_t         RECORD
                                azn05 LIKE azn_file.azn05,
   				azn01 LIKE azn_file.azn01,
				azn02 LIKE azn_file.azn02
			END RECORD,
   		g_azn_o         RECORD
                                azn05 LIKE azn_file.azn05,
   				azn01 LIKE azn_file.azn01,
				azn02 LIKE azn_file.azn02
			END RECORD,
   		g_azn   DYNAMIC ARRAY OF RECORD
                                azn05 LIKE azn_file.azn05,
   				azn01_b LIKE azn_file.azn01,
   				azn01_e LIKE azn_file.azn01,
				azn02  LIKE azn_file.azn02
			END RECORD
 
#主程式開始
DEFINE g_forupd_sql        STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5     #No.FUN-680103 SMALLINT
DEFINE g_cnt               LIKE type_file.num10    #No.FUN-680103 INTEGER
DEFINE g_msg               LIKE type_file.chr1000  #No.FUN-680103 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10    #No.FUN-680103 INTEGER
DEFINE g_curs_index        LIKE type_file.num10    #No.FUN-680103 INTEGER
DEFINE g_jump              LIKE type_file.num10    #No.FUN-680103 INTEGER
DEFINE mi_no_ask           LIKE type_file.num10    #No.FUN-680103 INTEGER
DEFINE g_i                 LIKE type_file.num5      #No.FUN-680103 SMALLINT #縱刻度數目 =>10 
DEFINE g_i1                LIKE type_file.num5      #No.FUN-680103 SMALLINT #縱刻度數目 =>10 
DEFINE g_draw_x,g_draw_y,g_draw_dx,g_draw_dy,
       g_draw_width,g_draw_multiple LIKE type_file.num10       #No.FUN-680103 INTEGER
DEFINE g_draw_x1,g_draw_y1,g_draw_dx1,g_draw_dy1,
       g_draw_width1,g_draw_multiple1 LIKE type_file.num10       #No.FUN-680103 INTEGER
DEFINE g_draw_start_y    LIKE type_file.num10      #No.FUN-680103
DEFINE g_draw_hight      LIKE type_file.num10      #No.FUN-680103 INTEGER #每線條高度
DEFINE g_draw_spec       LIKE type_file.num10      #No.FUN-680103 INTEGER #線條間距
DEFINE g_draw_start_y1   LIKE type_file.num10      #No.FUN-680103
DEFINE g_draw_hight1     LIKE type_file.num10      #No.FUN-680103 INTEGER #每線條高度
DEFINE g_draw_spec1      LIKE type_file.num10      #No.FUN-680103 INTEGER #線條間距
DEFINE g_sfb_sfb01       LIKE sfb_file.sfb01 
DEFINE g_draw_item DYNAMIC ARRAY OF RECORD
                   sfb01  LIKE sfb_file.sfb01,
                   sfb98  LIKE sfb_file.sfb98,
                   sfb102 LIKE sfb_file.sfb102,
                   sfb13  LIKE sfb_file.sfb13,
                   sfb15  LIKE sfb_file.sfb15,
                   ypos   LIKE type_file.num10  #座標
                   END RECORD
DEFINE g_draw_item1 DYNAMIC ARRAY OF RECORD
                    sfb98         LIKE sfb_file.sfb98,    #成本中心
                    sfb102        LIKE sfb_file.sfb102,   #生產線
                    sfb01         LIKE sfb_file.sfb01,    #W/O NO.
                    sfb13         LIKE sfb_file.sfb13,    #開工日
                    sfb15         LIKE sfb_file.sfb15,    #完工日
                    sfb13_azn05   LIKE azn_file.azn05,    #週次   #NO.TQC-740056
                    sfb15_azn05   LIKE azn_file.azn05,    #週次   #NO.TQC-740056
                    azn01_sfb13_b LIKE azn_file.azn01,  #NO.TQC-740056
                    azn01_sfb13_e LIKE azn_file.azn01,  #NO.TQC-740056
                    azn01_sfb15_b LIKE azn_file.azn01,  #NO.TQC-740056
                    azn01_sfb15_e LIKE azn_file.azn01,   #NO.TQC-740056
                    ypos          LIKE type_file.num10    #座標
                    END RECORD
DEFINE g_mindt,g_maxdt   LIKE type_file.dat          #No.FUN-680103 DATE #最小/最大日期
DEFINE g_mindt1,g_maxdt1 LIKE type_file.dat          #No.FUN-680103 DATE #最小/最大日期
DEFINE g_minwk1,g_maxwk1 LIKE type_file.num5         #No.FUN-680103 DATE #最小/最大週期 #NO.TQC-740056
DEFINE g_draw_day      LIKE type_file.dat          #No.FUN-680103 DATE #畫統計圖用的日期
DEFINE g_draw_day1     LIKE type_file.dat          #No.FUN-680103 DATE #畫統計圖用的日期
DEFINE tm RECORD
          range     LIKE type_file.chr1      #時距
          END RECORD
DEFINE tm1 RECORD
          range1     LIKE type_file.chr1      #時距
          END RECORD
DEFINE g_row1       LIKE type_file.num5
DEFINE g_row2       LIKE type_file.num5
DEFINE g_row3       LIKE type_file.num5
DEFINE g_row4       LIKE type_file.num5
DEFINE g_row1_now   LIKE type_file.num5
DEFINE g_row2_now   LIKE type_file.num5
DEFINE g_row3_now   LIKE type_file.num5
DEFINE g_row4_now   LIKE type_file.num5
DEFINE g_tot_cnt    LIKE type_file.num5
DEFINE g_tot_cnt1   LIKE type_file.num5
DEFINE g_wk         LIKE type_file.num5  #NO.TQC-740056
DEFINE g_wk_start   LIKE type_file.num5  #NO.TQC-740056
MAIN
DEFINE
   p_row,p_col         LIKE type_file.num5         #No.FUN-680103 SMALLINT 
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690118
 
 
   LET g_argv1 = ARG_VAL(1)     
   LET g_argv2 = ARG_VAL(2)    
   LET p_row = 3 LET p_col = 15
   OPEN WINDOW q700_w AT p_row,p_col      #顯示畫面
     WITH FORM "asf/42f/asfq700"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * FROM sfb_file WHERE sfb01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE q700_cl CURSOR FROM g_forupd_sql
 
   CALL q700_menu()
   CLOSE WINDOW q700_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690118
END MAIN
 
FUNCTION q700_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                                    #清除畫面
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   LET g_wc=''
 
   #CONSTRUCT BY NAME g_wc ON sfb98,sfb102,sfb01,sfb05,sfb81  #FUN-C30245
   CONSTRUCT BY NAME g_wc ON sfb98,sfb102,sfb01,sfb81,sfb04,sfb05,sfb13,sfb15,sfb08,sfb22,sfb221  #FUN-C40082
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(sfb98)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  IF g_aaz.aaz90='Y' THEN  #FUN-670103
                    LET g_qryparam.form = "q_gem4"  #FUN-670103
                  ELSE
                    LET g_qryparam.form = "q_gem"
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb98  
                  NEXT FIELD sfb98
             WHEN INFIELD(sfb102)                 #機械編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_eci"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb102
                  NEXT FIELD sfb102
             WHEN INFIELD(sfb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb05"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD sfb01
            #WHEN INFIELD(ima01)  #MOD-880200 mark
             WHEN INFIELD(sfb05)  #MOD-880200
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  #DISPLAY g_qryparam.multiret TO ima01 #FUN-C30245
                  DISPLAY g_qryparam.multiret TO sfb05  #FUN-C30245
                  #NEXT FIELD ima01       #FUN-C30245
                  NEXT FIELD sfb05        #FUN-C30245
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
 
   END CONSTRUCT
 
   IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
END FUNCTION
 
FUNCTION q700_menu()
   DEFINE l_cmd   LIKE type_file.chr1000     #No.FUN-680103 VARCHAR(200)
 
   WHILE TRUE
      CALL q700_bp("G")
      CASE g_action_choice
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL q700_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q700_q()
            END IF
#NO.TQC-740056 mark--
#         WHEN "chart1"
#            IF cl_chk_act_auth() THEN
#                CALL q700_view1()
#            ELSE
#               LET g_action_choice = NULL
#            END IF
#NO.TQC-740056 mark--
         WHEN "chart2"
            IF cl_chk_act_auth() THEN
                IF (NOT cl_null(g_row3_now) AND g_row3_now != 0 
                   AND NOT cl_null(g_row4_now) AND g_row4_now != 0) THEN
                       CALL q700_view2()
                END IF
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_arr),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q700_q()
    CALL cl_opmsg('q')
    MESSAGE " "
    CALL q700_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE ' WAIT '
    CALL q700_b_fill() #單身
    CALL q700_group()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
    #CALL q700_draw(g_row1_now,g_row2_now)    #目前array筆數
    #---要單身有值才畫圖---
    IF (NOT cl_null(g_row3_now) AND g_row3_now <> 0 
       AND NOT cl_null(g_row4_now) AND g_row4_now <> 0) THEN
        CALL q700_draw_view2(g_row3_now,g_row4_now) 
    END IF
    #----------------------
    MESSAGE " "
END FUNCTION
 
#單身
FUNCTION q700_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680121 VARCHAR(1)
    l_jump          LIKE type_file.num5,                #No.FUN-680121 SMALLINT #判斷是否跳過AFTER ROW的處理
    li_result       LIKE type_file.num5,                #MOD-C50023 add
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680121 SMALLINT
    l_sfb13_t       LIKE sfb_file.sfb13,                #TQC-C50228 add 
    l_sfb15_t       LIKE sfb_file.sfb15,                #TQC-C50228 add 
    l_sfb22         LIKE sfb_file.sfb22,                #TQC-C50228 add
    l_sfb221        LIKE sfb_file.sfb221,               #TQC-C50228 add 
    l_oeb15         LIKE oeb_file.oeb15                 #TQC-C50228 add
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT '',sfb98,sfb102,sfb01,sfb81,sfb04,sfb05,'',sfb13,sfb15,sfb08,(sfb08-sfb09),sfb22,sfb221",#FUN-8A0135 add sfb81,sfb02 #FUN-8C0049  #FUN-C40082
                       " FROM sfb_file",
                       "  WHERE sfb01= ?",
                       " ORDER BY sfb98,sfb102,sfb01",
                       " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q700_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_arr WITHOUT DEFAULTS FROM s_arr.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL q700_set_required()       #TQC-C50228 add
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            LET l_sfb13_t = ''             #TQC-C50228 add 
            LET l_sfb15_t = ''             #TQC-C50228 add 
 
            BEGIN WORK
 
            OPEN q700_cl USING g_arr[l_ac].sfb01
            IF STATUS THEN
               CALL cl_err("OPEN q700_cl:", STATUS, 1)
               CLOSE q700_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH q700_cl INTO g_sfb_sfb01      # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err('lock sfb:',SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE q700_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_arr_t.* = g_arr[l_ac].*  #BACKUP
                LET l_sfb13_t = g_arr[l_ac].sfb13    #TQC-C50228 add 
                LET l_sfb15_t = g_arr[l_ac].sfb15    #TQC-C50228 add 
                OPEN q700_bcl USING g_arr_t.sfb01
                IF STATUS THEN
                   CALL cl_err("OPEN q700_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE 
                   FETCH q700_bcl INTO g_arr[l_ac].*
		   SELECT ima02 INTO g_arr[l_ac].ima02 FROM ima_file WHERE ima01=g_arr[l_ac].sfb05          #MOD-C30789 add
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_arr_t.ln,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   LET g_arr[l_ac].ln = l_ac
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

       #MOD-C50023 str add-----
        AFTER FIELD sfb13
            IF NOT cl_null(g_arr[l_ac].sfb13) THEN
               IF g_arr[l_ac].sfb13 < g_arr[l_ac].sfb81 THEN
                  LET g_arr[l_ac].sfb13 = g_arr[l_ac].sfb81
                  DISPLAY BY NAME g_arr[l_ac].sfb13
               END IF
               #TQC-C50228--add--str--
               LET li_result = 0
               CALL s_daywk(g_arr[l_ac].sfb13) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(g_arr[l_ac].sfb13,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(g_arr[l_ac].sfb13,'mfg3153',1)
               END IF
               #判斷是否由訂單或MPS轉工單
               LET l_sfb22  = ''
               LET l_sfb221 = ''
               SELECT sfb22,sfb221 INTO l_sfb22,l_sfb221 FROM sfb_file
                WHERE sfb01 = g_arr[l_ac].sfb01
               IF cl_null(l_sfb22) AND cl_null(l_sfb221) THEN
                  IF NOT cl_null(l_sfb13_t) AND g_arr[l_ac].sfb13 != l_sfb13_t THEN   
                     IF cl_confirm("asf-983") THEN
                        CALL q700_time('1')
                        LET l_sfb15_t = g_arr[l_ac].sfb15
                       DISPLAY BY NAME g_arr[l_ac].sfb15
                     END IF
                  END IF
               END IF

               IF NOT cl_null(g_arr[l_ac].sfb15) THEN
                  IF g_arr[l_ac].sfb13>g_arr[l_ac].sfb15 THEN
                     CALL cl_err('','asf-310',0)
                     #LET g_arr[l_ac].sfb15=''
                     #DISPLAY BY NAME g_arr[l_ac].sfb15
                     NEXT FIELD sfb13
                  END IF
               END IF
               #TQC-C50228--add--end--
            END IF
            LET l_sfb13_t = g_arr[l_ac].sfb13                   #TQC-C50228 add

        AFTER FIELD sfb15
            IF NOT cl_null(g_arr[l_ac].sfb15) THEN              #TQC-C50228 add
               LET li_result = 0
               CALL s_daywk(g_arr[l_ac].sfb15) RETURNING li_result
               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(g_arr[l_ac].sfb15,'mfg3152',1)
                  #NEXT FIELD sfb15                             #TQC-C50228 mark
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(g_arr[l_ac].sfb15,'mfg3153',1)
                  #NEXT FIELD sfb15                             #TQC-C50228 mark
               END IF
           #IF NOT cl_null(g_arr[l_ac].sfb15) THEN              #TQC-C50228 mark
               IF NOT cl_null(g_arr[l_ac].sfb13) THEN           #TQC-C50228 add
                  IF g_arr[l_ac].sfb15 < g_arr[l_ac].sfb13 THEN
                     CALL cl_err('','asf1002',0)
                     NEXT FIELD sfb15
                  END IF
               END IF
               #TQC-C50228--add--str--
               #增加顯示asf-382:"工單完工日與訂單預定交貨日不同!!"
               LET l_sfb22  = ''
               LET l_sfb221 = ''
               LET l_oeb15  = ''
               SELECT sfb22,sfb221 INTO l_sfb22,l_sfb221 FROM sfb_file
                WHERE sfb01 = g_arr[l_ac].sfb01
               IF NOT cl_null(l_sfb22) AND NOT cl_null(l_sfb221) THEN
                  SELECT oeb15 INTO l_oeb15 FROM oeb_file
                   WHERE oeb01 = l_sfb22 AND oeb03 = l_sfb221
                  IF g_arr[l_ac].sfb15 != l_oeb15 THEN
                     CALL cl_err('','asf-382',0)
                  END IF
               END IF
               IF NOT cl_null(l_sfb15_t) AND g_arr[l_ac].sfb15 != l_sfb15_t THEN
                  IF cl_confirm("asf-988") THEN  
                     CALL q700_time('2')
                     LET l_sfb13_t = g_arr[l_ac].sfb13
                     DISPLAY BY NAME g_arr[l_ac].sfb13
                  END IF
               END IF
               #TQC-C50228--add--end--
            END IF
            LET l_sfb15_t = g_arr[l_ac].sfb15                   #TQC-C50228 add
       #MOD-C50023 end add----- 

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_arr[l_ac].* = g_arr_t.*
               CLOSE q700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_arr[l_ac].ln,-263,1)
               LET g_arr[l_ac].* = g_arr_t.*
            ELSE
               UPDATE sfb_file SET sfb13 = g_arr[l_ac].sfb13,
                                   sfb15 = g_arr[l_ac].sfb15
                             WHERE sfb01 = g_arr_t.sfb01 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","sfb_file",g_arr_t.sfb01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  LET g_arr[l_ac].* = g_arr_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE sfb_file O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_arr[l_ac].* = g_arr_t.*
               END IF
               CLOSE q700_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE q700_bcl
            COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END      
    END INPUT
 
    CLOSE q700_bcl
END FUNCTION
 
FUNCTION q700_b_fill()              #BODY FILL UP
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            # 只能使用自己的資料
   #       LET g_wc = g_wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                            # 只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET g_wc = g_wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   #End:FUN-980030
 
   LET g_sql = "SELECT '',sfb98,sfb102,sfb01,sfb81,sfb04,sfb05,'',sfb13,sfb15,sfb08,(sfb08-sfb09),sfb22,sfb221",#FUN-8A0135 #FUN-8C0049  #FUN-C40082
               "  FROM sfb_file",
               " WHERE sfb87 = 'Y'",
               "   AND ",g_wc,
               " ORDER BY sfb98,sfb102,sfb01"
   PREPARE q700_pb FROM g_sql
   DECLARE sfb_cs                       #CURSOR
       CURSOR FOR q700_pb
   CALL g_arr.clear()
   LET g_cnt = 1
   FOREACH sfb_cs INTO g_arr[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_arr[g_cnt].ln = g_cnt
      SELECT ima02 INTO g_arr[g_cnt].ima02 FROM ima_file
       WHERE ima01=g_arr[g_cnt].sfb05
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_arr.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b   TO FORMONLY.cnt
 
   LET g_row1 = 1
   LET g_tot_cnt=g_arr.getlength()
   IF g_tot_cnt >=10 THEN LET g_row2 = 10 ELSE LET g_row2 = g_tot_cnt END IF
   #DISPLAY g_row1 TO FORMONLY.row1
   #DISPLAY g_row1 TO FORMONLY.row1
   LET g_row1_now = g_row1
   LET g_row2_now = g_row2
END FUNCTION
 
FUNCTION q700_group()   #以成本中心+生產線+工單為GROUP 
DEFINE  l_cnt           LIKE type_file.num5
DEFINE  l_add           LIKE type_file.chr1
DEFINE  l_azn           LIKE type_file.num10
DEFINE  k               LIKE type_file.num10
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            # 只能使用自己的資料
   #       LET g_wc = g_wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                            # 只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET g_wc = g_wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
　 #取aooq010週期---
   LET g_sql = "SELECT azn05,azn01 FROM azn_file",
               " ORDER BY azn01,azn05"
   PREPARE q700_azn_prepare FROM g_sql
   DECLARE azn_curs CURSOR FOR q700_azn_prepare
   LET l_ac = 1
   FOREACH azn_curs INTO g_azn_t.*
      IF SQLCA.sqlcode != 0 
         THEN 
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
      END IF
      IF WEEKDAY(g_azn_t.azn01) = 0 OR                #星期日
         cl_null(g_azn[l_ac].azn01_b) THEN
         LET g_azn[l_ac].azn05 = g_azn_t.azn05        #週次
         LET g_azn[l_ac].azn01_b = g_azn_t.azn01      #起始日期
      END IF
         
      IF g_azn_o.azn02<>g_azn_t.azn02    #跨年度時
         AND NOT cl_null(g_azn_o.azn02) THEN
         LET g_azn[l_ac].azn01_e = g_azn_o.azn01      #截止日期
         LET g_azn[l_ac].azn02 = g_azn_o.azn02        #年度
         IF WEEKDAY(g_azn_t.azn01) >0 THEN 
            LET l_ac = l_ac + 1
            LET g_azn[l_ac].azn05 = g_azn_t.azn05        #週次
            LET g_azn[l_ac].azn01_b = g_azn_t.azn01      #起始日期
         END IF 
      END IF
      IF WEEKDAY(g_azn_t.azn01) = 6 THEN  # 星期六
         LET g_azn[l_ac].azn01_e = g_azn_t.azn01
         LET g_azn[l_ac].azn02 = g_azn_t.azn02
         LET l_ac = l_ac + 1
      END IF 
      LET g_azn_o.*=g_azn_t.*
   END FOREACH
   LET l_azn =g_azn.getlength()
 
   LET g_sql = "SELECT sfb98,sfb102,sfb01,sfb13,sfb15",
               "  FROM sfb_file ",
               " WHERE ",g_wc,
               "   AND sfb87 = 'Y'",
               " ORDER BY sfb98"
 
  PREPARE q700_pb1 FROM g_sql
  DECLARE sfb_cs1                       #CURSOR
      CURSOR FOR q700_pb1
  CALL g_arr1.clear()
  LET l_cnt = 1
  FOREACH sfb_cs1 INTO g_arr1[l_cnt].*   #單身 ARRAY 填充
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
      END IF
#NO.TQC-740056 start---以目前資料比對aooq010資料，判斷落在哪一個週期，塞進目前arry
      FOR k = 1 TO l_azn 
          IF g_arr1[l_cnt].sfb13 >= g_azn[k].azn01_b THEN
             IF g_arr1[l_cnt].sfb13 <= g_azn[k].azn01_e THEN  #TQC-880031 add '='
                 LET g_arr1[l_cnt].sfb13_azn05 = g_azn[k].azn05
                 LET g_arr1[l_cnt].azn01_sfb13_b = g_azn[k].azn01_b
                 LET g_arr1[l_cnt].azn01_sfb13_e = g_azn[k].azn01_e
                 IF l_cnt = 1 THEN LET g_wk = k END IF #抓最小週期的落點
             END IF
          END IF
      END FOR
      FOR k = 1 TO l_azn 
          IF g_arr1[l_cnt].sfb15 >= g_azn[k].azn01_b THEN
             IF g_arr1[l_cnt].sfb15 <= g_azn[k].azn01_e THEN  #TQC-880031 add '=' 
                 LET g_arr1[l_cnt].sfb15_azn05 = g_azn[k].azn05
                 LET g_arr1[l_cnt].azn01_sfb15_b = g_azn[k].azn01_b
                 LET g_arr1[l_cnt].azn01_sfb15_e = g_azn[k].azn01_e
             END IF
          END IF
      END FOR
#NO.TQC-740056 end-----
 
#NO.TQC-740056 start--  如果遇到成本中心不相同時，塞一個空白array放pink線
      IF l_cnt <> 1 THEN
          IF NOT cl_null(g_arr1[l_cnt].sfb98) THEN 
              IF g_arr1[l_cnt].sfb98 <> g_arr1[l_cnt-1].sfb98 AND
                  NOT cl_null(g_arr1[l_cnt-1].sfb01) THEN
                  LET g_arr1[l_cnt+1].* = g_arr1[l_cnt].*
                  LET g_arr1[l_cnt].sfb98 = ' ' 
                  LET g_arr1[l_cnt].sfb01 = ' '
                  LET g_arr1[l_cnt].sfb102 = ' '
                  LET g_arr1[l_cnt].sfb13 =  ' '
                  LET g_arr1[l_cnt].sfb15 =  ' '
                  LET l_cnt = l_cnt + 1
              END IF 
          END IF
      END IF
      LET l_cnt = l_cnt + 1
#NO.TQC-740056 end----     
      IF l_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   IF g_arr1[l_cnt].sfb01 IS NULL THEN
       CALL g_arr1.deleteElement(l_cnt)
   END IF
  #CHI-C60021 str add-----
   LET l_cnt = g_arr1.getlength()
   CALL s_showmsg_init()
   FOR k=l_cnt TO 1 STEP -1
       IF (g_arr1[k].sfb13_azn05 IS NULL) OR (g_arr1[k].sfb15_azn05 IS NULL) THEN
          CALL s_errmsg('sfb01',g_arr1[k].sfb01,'','asf-391',1)
          CALL g_arr1.deleteElement(k)
       END IF
   END FOR
   CALL s_showmsg()
  #CHI-C60021 end add-----
   LET g_row3_now = 0   #MOD-880129
   LET g_row4_now = 0   #MOD-880129
   #避免完全沒資料時還計算出錯誤的筆數---
   IF g_arr1[1].sfb01 IS NOT NULL THEN
       LET g_row3 = 1
       LET g_tot_cnt1=g_arr1.getlength()
       #IF g_tot_cnt1 >=10 THEN LET g_row4 = 10 ELSE LET g_row4 = g_tot_cnt1 END IF
       IF g_tot_cnt1 >=5 THEN LET g_row4 = 5 ELSE LET g_row4 = g_tot_cnt1 END IF  #NO.TQC-740056
#       DISPLAY g_row3 TO FORMONLY.row3   #NO.TQC-740056 mark
#       DISPLAY g_row4 TO FORMONLY.row4   #NO.TQC-740056 mark
       LET g_row3_now = g_row3
       LET g_row4_now = g_row4
   END IF
   #-------------------------------------:
 
END FUNCTION
 
FUNCTION q700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        #No.FUN-680103 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_arr TO s_arr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
        CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------ 
#NO.TQC-740056 mark--
#     ON ACTION chart1
#        LET g_action_choice="chart1"
#        EXIT DISPLAY
#NO.TQC-740056 mark--
 
     ON ACTION chart2
        LET g_action_choice="chart2"
        EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q700_draw(p_row1_now,p_row2_now)
DEFINE id,l_n,l_draw_y,l_draw_dy LIKE type_file.num10     #No.FUN-680103 INTEGER
DEFINE l_sql,l_str               STRING
DEFINE l_flag                    LIKE type_file.num5      #No.FUN-680103 SMALLINT
DEFINE l_dt1,l_dt2               LIKE type_file.dat       #No.FUN-680103 DATE
DEFINE p_row1_now                LIKE type_file.num5
DEFINE p_row2_now                LIKE type_file.num5
 
  IF cl_null(tm.range) THEN 
     LET tm.range='1' 
     DISPLAY BY NAME tm.range
  END IF
 
  #CALL drawselect("cv3")   #per檔name
  CALL drawselect("cv5")   #per檔name
  CALL drawClear()
  #CALL drawselect("cv3")   #per檔name
  LET g_i=10 #縱刻度數目
  LET g_draw_x=0   #起始x軸位置
  LET g_draw_y=75  #起始y軸位置
  LET g_draw_dx=0  #起始dx軸位置
  LET g_draw_dy=10 #起始dy軸位置
  LET g_draw_width=30 #橫軸每一刻度寬
  LET g_draw_multiple=1 #時間的放大倍數(在長條圖上的刻度比例)
  LET g_draw_start_y=120      #起始y軸位置
  LET g_draw_hight=30 #每一線條高度
  LET g_draw_spec=6 #實際與預估的間距
  CALL q700_set_bound(p_row1_now,p_row2_now) #設定最大最小區間(傳進目前資料區間)
  IF (g_maxdt=0) OR (g_mindt=0) THEN #OR (g_maxdt=g_mindt) THEN
     RETURN
  END IF
  CALL q700_draw_axis(p_row1_now,p_row2_now)
  LET g_draw_day=g_mindt
  #LET g_i=g_draw_item.getlength()
  LET g_draw_dx=10
  #FOR l_n=1 TO g_i
  FOR l_n=p_row1_now TO p_row2_now
     CASE tm.range
        WHEN '1' #月
           #預估
           IF (NOT cl_null(g_draw_item[l_n].sfb13)) AND
              (NOT cl_null(g_draw_item[l_n].sfb15)) THEN
              LET l_draw_y=g_draw_y+
                           ((g_draw_item[l_n].sfb13-g_mindt)/30*g_draw_width)+
                           ((g_mindt-s_getfirstday(g_mindt))/30*g_draw_width) #如果起始日非當月1日,則必須加上日期                           
              
              LET l_draw_dy=(g_draw_item[l_n].sfb15-g_draw_item[l_n].sfb13)/30*g_draw_width
              CALL DrawFillColor("blue")
              LET id=DrawRectangle(g_draw_item[l_n].ypos+10,l_draw_y,g_draw_hight,l_draw_dy) #(Y軸起點,X軸起點,線高度,線寬度)
             #LET l_str=g_draw_item[l_n].sfb98 CLIPPED,"  ",g_draw_item[l_n].sfb102 CLIPPED
              LET l_str=g_draw_item[l_n].sfb01 CLIPPED
              LET l_str=g_draw_item[l_n].sfb13," ~ ",g_draw_item[l_n].sfb15," : ",l_str
              CALL drawSetComment(id,l_str)
           END IF
        WHEN '2' #週
           #預估
           IF (NOT cl_null(g_draw_item[l_n].sfb13)) AND
              (NOT cl_null(g_draw_item[l_n].sfb15)) THEN
              LET l_draw_y=g_draw_y+
                           ((g_draw_item[l_n].sfb13-g_mindt)/7*g_draw_width)                        
              LET l_draw_dy=(g_draw_item[l_n].sfb15-g_draw_item[l_n].sfb13)/7*g_draw_width
              CALL DrawFillColor("blue")
              LET id=DrawRectangle(g_draw_item[l_n].ypos+10,l_draw_y,g_draw_hight,l_draw_dy) #(Y軸起點,X軸起點,線高度,線寬度)
              LET l_str=g_draw_item[l_n].sfb01 CLIPPED
              #LET l_str=g_draw_item[l_n].sfb98 CLIPPED,"  ",g_draw_item[l_n].sfb102 CLIPPED
              LET l_str=g_draw_item[l_n].sfb13," ~ ",g_draw_item[l_n].sfb15," : ",l_str
              CALL drawSetComment(id,l_str)
           END IF
        WHEN '3' #日
           #預估
           IF (NOT cl_null(g_draw_item[l_n].sfb13)) AND
              (NOT cl_null(g_draw_item[l_n].sfb15)) THEN
              LET l_draw_y=g_draw_y+
                           ((g_draw_item[l_n].sfb13-g_mindt)*g_draw_width)                        
              LET l_draw_dy=(g_draw_item[l_n].sfb15-g_draw_item[l_n].sfb13)*g_draw_width
              CALL DrawFillColor("blue")
              LET id=DrawRectangle(g_draw_item[l_n].ypos+10,l_draw_y,g_draw_hight,l_draw_dy) #(Y軸起點,X軸起點,線高度,線寬度)
              LET l_str=g_draw_item[l_n].sfb01 CLIPPED
              #LET l_str=g_draw_item[l_n].sfb98 CLIPPED,"  ",g_draw_item[l_n].sfb102 CLIPPED
              LET l_str=g_draw_item[l_n].sfb13," ~ ",g_draw_item[l_n].sfb15," : ",l_str
              CALL drawSetComment(id,l_str)
           END IF
        OTHERWISE
           EXIT FOR
     END CASE
  END FOR
END FUNCTION
 
FUNCTION q700_draw_view2(p_row3_now,p_row4_now)
DEFINE id,l_n,l_draw_y,l_draw_dy LIKE type_file.num10     #No.FUN-680103 INTEGER
DEFINE l_sql,l_str               STRING
DEFINE l_flag                    LIKE type_file.num5      #No.FUN-680103 SMALLINT
DEFINE l_dt1,l_dt2               LIKE type_file.dat       #No.FUN-680103 DATE
DEFINE p_row3_now                LIKE type_file.num5
DEFINE p_row4_now                LIKE type_file.num5
DEFINE k                         LIKE type_file.num5
  IF cl_null(tm1.range1) THEN 
     LET tm1.range1='1' 
     DISPLAY BY NAME tm1.range1
  END IF
 
  CALL drawselect("cv5")   #per檔name
  CALL drawClear()
  LET g_i=10 #縱刻度數目
  LET g_draw_x1=0   #起始x軸位置
  LET g_draw_y1=75  #起始y軸位置
  LET g_draw_dx1=0  #起始dx軸位置
  LET g_draw_dy1=10 #起始dy軸位置
  LET g_draw_width1=30 #橫軸每一刻度寬
  LET g_draw_multiple1=1 #時間的放大倍數(在長條圖上的刻度比例)
  LET g_draw_start_y1=120      #起始y軸位置
  LET g_draw_hight1=30 #每一線條高度
  LET g_draw_spec1=6 #實際與預估的間距
  CALL q700_set_bound_view2(p_row3_now,p_row4_now) #設定最大最小區間(傳進目前資料區間)
  IF (g_maxdt1=0) OR (g_mindt1=0) THEN #OR (g_maxdt1=g_mindt1) THEN
     RETURN
  END IF
  CALL q700_draw_axis_view2(p_row3_now,p_row4_now)
  LET g_draw_day1=g_mindt1
  LET g_draw_dx1=10
  FOR l_n=p_row3_now TO p_row4_now
     CASE tm1.range1
        WHEN '1' #月
           #預估
#NO.TQC-740056 start-
           IF cl_null(g_draw_item1[l_n].sfb01) THEN
               LET l_draw_y = 45
               CALL DrawFillColor("pink")
               FOR k = 1 TO 65 
                   LET l_draw_y = l_draw_y + 15
                   #LET id=DrawRectangle(g_draw_item1[l_n].ypos+10,l_draw_y,10,10) #(Y軸起點,X軸起點,線高度,線寬度)
                   LET id=DrawRectangle(g_draw_item1[l_n].ypos+10,l_draw_y,5,10) #(Y軸起點,X軸起點,線高度,線寬度)
                   CALL drawSetComment(id,'') 
               END FOR
           END IF
#NO.TQC-740056 end--
           IF (NOT cl_null(g_draw_item1[l_n].sfb13)) AND
              (NOT cl_null(g_draw_item1[l_n].sfb15)) THEN
              LET l_draw_y=g_draw_y1+
                           ((g_draw_item1[l_n].sfb13-g_mindt1)/30*g_draw_width1)+
                           ((g_mindt1-s_getfirstday(g_mindt1))/30*g_draw_width1) #如果起始日非當月1日,則必須加上日期                           
              
              LET l_draw_dy=(g_draw_item1[l_n].sfb15-g_draw_item1[l_n].sfb13)/30*g_draw_width1
              CALL DrawFillColor("blue")
              LET id=DrawRectangle(g_draw_item1[l_n].ypos+10,l_draw_y,g_draw_hight1,l_draw_dy) #(Y軸起點,X軸起點,線高度,線寬度)
              LET l_str=g_draw_item1[l_n].sfb01 CLIPPED," ",g_draw_item1[l_n].sfb102 CLIPPED
              LET l_str=g_draw_item1[l_n].sfb13," ~ ",g_draw_item1[l_n].sfb15," : ",l_str
              CALL drawSetComment(id,l_str) 
          END IF
        WHEN '2' #週
#NO.TQC-740056 start-
           IF cl_null(g_draw_item1[l_n].sfb01) THEN
               LET l_draw_y = 45
               CALL DrawFillColor("pink")
               FOR k = 1 TO 65 
                   LET l_draw_y = l_draw_y + 15
                   #LET id=DrawRectangle(g_draw_item1[l_n].ypos+10,l_draw_y,10,10) #(Y軸起點,X軸起點,線高度,線寬度)
                   LET id=DrawRectangle(g_draw_item1[l_n].ypos+10,l_draw_y,5,10) #(Y軸起點,X軸起點,線高度,線寬度)
                   CALL drawSetComment(id,'') 
               END FOR
           END IF
#NO.TQC-740056 end--
           #預估
           IF (NOT cl_null(g_draw_item1[l_n].sfb13)) AND
              (NOT cl_null(g_draw_item1[l_n].sfb15)) THEN
              LET l_draw_y=g_draw_y1+
                           ((g_draw_item1[l_n].sfb13-g_mindt1)/7*g_draw_width1)                        
              LET l_draw_dy=(g_draw_item1[l_n].sfb15-g_draw_item1[l_n].sfb13)/7*g_draw_width1
              CALL DrawFillColor("blue")
              LET id=DrawRectangle(g_draw_item1[l_n].ypos+10,l_draw_y,g_draw_hight1,l_draw_dy) #(Y軸起點,X軸起點,線高度,線寬度)
              LET l_str=g_draw_item1[l_n].sfb01 CLIPPED," ",g_draw_item1[l_n].sfb102 CLIPPED
              LET l_str=g_draw_item1[l_n].sfb13," ~ ",g_draw_item1[l_n].sfb15," : ",l_str
              CALL drawSetComment(id,l_str)
           END IF
        WHEN '3' #日
#NO.TQC-740056 start-
           IF cl_null(g_draw_item1[l_n].sfb01) THEN
               LET l_draw_y = 45
               CALL DrawFillColor("pink")
               FOR k = 1 TO 65 
                   LET l_draw_y = l_draw_y + 15
                   #LET id=DrawRectangle(g_draw_item1[l_n].ypos+10,l_draw_y,10,10) #(Y軸起點,X軸起點,線高度,線寬度)
                   LET id=DrawRectangle(g_draw_item1[l_n].ypos+10,l_draw_y,5,10) #(Y軸起點,X軸起點,線高度,線寬度)
                   CALL drawSetComment(id,'') 
               END FOR
           END IF
#NO.TQC-740056 end--
           #預估
           IF (NOT cl_null(g_draw_item1[l_n].sfb13)) AND
              (NOT cl_null(g_draw_item1[l_n].sfb15)) THEN
              LET l_draw_y=g_draw_y1+
                           ((g_draw_item1[l_n].sfb13-g_mindt1)*g_draw_width1)                        
              LET l_draw_dy=(g_draw_item1[l_n].sfb15-g_draw_item1[l_n].sfb13)*g_draw_width1
              CALL DrawFillColor("blue")
              LET id=DrawRectangle(g_draw_item1[l_n].ypos+10,l_draw_y,g_draw_hight1,l_draw_dy) #(Y軸起點,X軸起點,線高度,線寬度)
              LET l_str=g_draw_item1[l_n].sfb01 CLIPPED," ",g_draw_item1[l_n].sfb102 CLIPPED
              LET l_str=g_draw_item1[l_n].sfb13," ~ ",g_draw_item1[l_n].sfb15," : ",l_str
              CALL drawSetComment(id,l_str)
           END IF
        OTHERWISE
           EXIT FOR
     END CASE
  END FOR
END FUNCTION
 
FUNCTION q700_draw_axis(p_row1_now,p_row2_now) #座標
DEFINE id,l_h,l_x,l_i  LIKE type_file.num10       #No.FUN-680103 INTEGER
DEFINE l_msg,l_msg1    STRING
DEFINE l_draw_multiple LIKE type_file.num10       #No.FUN-680103 INTEGER  #縱刻度一個刻度的寬度
DEFINE l_dist LIKE type_file.num10,               #No.FUN-680103 INTEGER  #每個圖例說明的間距
       l_draw_x LIKE type_file.num10,             #No.FUN-680103 INTEGER  #每個圖例說明的x軸位置
       l_draw_y LIKE type_file.num10,             #No.FUN-680103 INTEGER  #每個圖例說明的y軸位置
       l_vmax,l_hmax LIKE type_file.num10,        #No.FUN-680103 INTEGER  #橫軸最大/縱軸最大
       l_hight LIKE type_file.num10               #No.FUN-680103 INTEGER  #橫軸高度
DEFINE l_m,l_y,l_year,l_week LIKE type_file.num5      #No.FUN-680103 SMALLINT
DEFINE l_day LIKE type_file.dat                   #No.FUN-680103 DATE
DEFINE l_hcnt LIKE type_file.num5                 #No.FUN-680103 SMALLINT #橫軸刻度數量
DEFINE p_row1_now  LIKE type_file.num5
DEFINE p_row2_now  LIKE type_file.num5
       
  CALL DrawFillColor("black")
  LET l_hmax=920
  LET l_vmax=820
  LET l_hight=60
  LET l_hcnt=q700_set_hcnt()
  LET id=DrawRectangle(g_draw_start_y1-5,l_hight,6,l_hmax)  #(橫軸)
  LET id=DrawRectangle(g_draw_start_y1-5,l_hight,l_vmax,3)  #(縱軸)
  CALL g_draw_item.clear()
  #判斷總資料是否大於十筆
 #MOD-C60111---S---
 #IF g_tot_cnt > 10 THEN 
  IF g_tot_cnt > 5 THEN 
     #LET g_i = 10
      LET g_i = 5 
 #MOD-C60111---E---
  ELSE
      LET g_i = g_tot_cnt
  END IF 
  IF g_i>0 THEN
     IF g_i=1 THEN
        LET l_draw_multiple=(l_hmax-(g_draw_start_y-5))/2
     ELSE
        LET l_draw_multiple=(l_hmax-(g_draw_start_y-5))/g_i
     END IF
     LET l_h=(g_draw_start_y-5)+l_draw_multiple
     FOR l_i=p_row1_now TO p_row2_now #(縱軸刻度)  #一次拆十筆來秀
       CALL DrawFillColor("black")
       #LET l_msg=g_arr[l_i].sfb01
       LET l_x=l_h-30
       LET id=DrawText(l_x,30,l_msg)
       LET g_draw_item[l_i].sfb01 = g_arr[l_i].sfb01
       LET g_draw_item[l_i].sfb98 = g_arr[l_i].sfb98
       LET g_draw_item[l_i].sfb102= g_arr[l_i].sfb102
       LET g_draw_item[l_i].sfb13 = g_arr[l_i].sfb13
       LET g_draw_item[l_i].sfb15 = g_arr[l_i].sfb15
       LET g_draw_item[l_i].ypos = l_x
       LET l_h=l_h+l_draw_multiple
     END FOR
  END IF
 
  CASE tm.range
     WHEN '1' LET l_msg=cl_getmsg('apj-023',g_lang)
     WHEN '2' LET l_msg=cl_getmsg('apj-024',g_lang)
     WHEN '3' LET l_msg=cl_getmsg('apj-025',g_lang)
  END CASE
  LET l_msg="(",l_msg,")"
  CALL DrawFillColor("black")
  LET id=DrawText((g_draw_start_y-5)/4-30,l_hmax+50,l_msg) #日期
  CALL DrawFillColor("black")
  LET l_msg=cl_getmsg('asf1001',g_lang)
  LET l_msg="(",l_msg,")"
  LET id=DrawText(l_vmax+120,35,l_msg) #工作項目
  
  #橫軸刻度
  LET l_draw_y=g_draw_y
  LET g_draw_width=l_hmax/l_hcnt
  IF g_draw_width<15 THEN #避免刻度太擠,最小為15,小於的會重疊
     LET g_draw_width=15
  END IF
  LET l_y=YEAR(g_mindt)
  LET l_m=MONTH(g_mindt)
  LET l_year=TRUE
  LET l_week=1
  LET l_day=g_mindt
  WHILE TRUE
     CASE tm.range
        WHEN '1' #月
           IF l_m>12 THEN
              LET l_m=l_m MOD 12
              LET l_y=l_y+1
           END IF
           LET id=DrawText(l_hight-10,l_draw_y+5,l_m)
           IF l_year OR (l_m=1) AND (l_draw_y<l_hmax-g_draw_hight) THEN #一月下面加show西元年
              LET id=DrawText(l_hight-60,l_draw_y+5,l_y)
           END IF
           LET l_m=l_m+1
           
        WHEN '2' #週
           LET id=DrawText(l_hight-10,l_draw_y+5,l_week)
           IF l_year OR l_m<>MONTH(l_day) THEN   #當月第一週下面加show西元年/月
              LET l_msg=MONTH(l_day)
              LET l_msg=l_msg.trim()
              LET l_msg1=YEAR(l_day)
              LET l_msg1=l_msg1.trim()
              LET l_msg=l_msg1,'/',l_msg
              LET id=DrawText(l_hight-60,l_draw_y+5,l_msg)
              LET l_m=MONTH(l_day)
           END IF
           LET l_day=l_day+7
           LET l_week=l_week+ 1
 
        WHEN '3' #日
           LET id=DrawText(l_hight-10,l_draw_y+5,DAY(l_day))
           IF DAY(l_day)=1 AND (l_draw_y<l_hmax-g_draw_hight) THEN #一日下面加show西元年/月
              LET l_msg=MONTH(l_day)
              LET l_msg=l_msg.trim()
              LET l_msg1=YEAR(l_day)
              LET l_msg1=l_msg1.trim()
              LET l_msg=l_msg1,'/',l_msg
              LET id=DrawText(l_hight-60,l_draw_y+5,l_msg)
           END IF 
           LET l_day=l_day+1
     END CASE
     LET l_draw_y=l_draw_y+g_draw_width
     IF l_draw_y>(l_hmax+70) THEN
        EXIT WHILE
     END IF
     LET l_year=FALSE
  END WHILE
  
  #圖例
  #預估
  LET l_dist=60
  LET l_draw_x=(g_draw_start_y-5)/4
  LET l_draw_y=g_draw_y
  CALL DrawFillColor("blue")
  LET id=DrawRectangle(85,35,20,20) #(Y軸起點,X軸起點,線高度,線寬度)
  
  LET l_msg=cl_getmsg("apj-027",g_lang)
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(70,20,l_msg)
END FUNCTION
 
FUNCTION q700_draw_axis_view2(p_row3_now,p_row4_now) #座標
DEFINE id,l_h,l_x,l_i  LIKE type_file.num10       #No.FUN-680103 INTEGER
DEFINE l_msg,l_msg1    STRING
DEFINE l_msg2          STRING   #no.TQC-740056
DEFINE l_draw_multiple LIKE type_file.num10       #No.FUN-680103 INTEGER  #縱刻度一個刻度的寬度
DEFINE l_dist LIKE type_file.num10,               #No.FUN-680103 INTEGER  #每個圖例說明的間距
       l_draw_x LIKE type_file.num10,             #No.FUN-680103 INTEGER  #每個圖例說明的x軸位置
       l_draw_y LIKE type_file.num10,             #No.FUN-680103 INTEGER  #每個圖例說明的y軸位置
       l_vmax,l_hmax LIKE type_file.num10,        #No.FUN-680103 INTEGER  #橫軸最大/縱軸最大
       l_hight LIKE type_file.num10               #No.FUN-680103 INTEGER  #橫軸高度
DEFINE l_m,l_y,l_year,l_week LIKE type_file.num5      #No.FUN-680103 SMALLINT
DEFINE l_day LIKE type_file.dat                   #No.FUN-680103 DATE
DEFINE l_hcnt LIKE type_file.num5                 #No.FUN-680103 SMALLINT #橫軸刻度數量
DEFINE p_row3_now  LIKE type_file.num5
DEFINE p_row4_now  LIKE type_file.num5
       
  CALL DrawFillColor("black")
  LET l_hmax=920
  LET l_vmax=820
  LET l_hight=60
  LET l_hcnt=q700_set_hcnt_view2()
  LET id=DrawRectangle(g_draw_start_y1-5,l_hight,6,l_hmax)  #(橫軸)
  LET id=DrawRectangle(g_draw_start_y1-5,l_hight,l_vmax,3)  #(縱軸)
  CALL g_draw_item1.clear()
  #判斷總資料是否大於十筆
 #MOD-C60111---S---
 #IF g_tot_cnt1 > 10 THEN 
  IF g_tot_cnt1 > 5 THEN 
     #LET g_i1 = 10
      LET g_i1 = 5 
 #MOD-C60111---E---
  ELSE
      LET g_i1 = g_tot_cnt1
  END IF 
  IF g_i1>0 THEN
     IF g_i1=1 THEN
        LET l_draw_multiple=(l_hmax-(g_draw_start_y1-5))/2
     ELSE
        LET l_draw_multiple=(l_hmax-(g_draw_start_y1-5))/g_i
     END IF
     LET l_h=(g_draw_start_y1-5)+l_draw_multiple
     FOR l_i=p_row3_now TO p_row4_now #(縱軸刻度)  #一次拆十筆來秀
       CALL DrawFillColor("black")
       #LET l_msg=g_arr1[l_i].sfb98 CLIPPED,' ',g_arr1[l_i].sfb102
       LET l_msg=g_arr1[l_i].sfb98 CLIPPED
       LET l_x=l_h-30
       LET id=DrawText(l_x,30,l_msg)
       LET g_draw_item1[l_i].sfb01 = g_arr1[l_i].sfb01  #NO.TQC-740056
       LET g_draw_item1[l_i].sfb98 = g_arr1[l_i].sfb98
       LET g_draw_item1[l_i].sfb102= g_arr1[l_i].sfb102
       LET g_draw_item1[l_i].sfb13 = g_arr1[l_i].sfb13
       LET g_draw_item1[l_i].sfb15 = g_arr1[l_i].sfb15
#NO.TQC-740056 start--
       LET g_draw_item1[l_i].sfb13_azn05 = g_arr1[l_i].sfb13_azn05      #週期
       LET g_draw_item1[l_i].sfb15_azn05 = g_arr1[l_i].sfb15_azn05      #週期
       LET g_draw_item1[l_i].azn01_sfb13_b = g_arr1[l_i].azn01_sfb13_b  #週期起時日
       LET g_draw_item1[l_i].azn01_sfb15_b = g_arr1[l_i].azn01_sfb15_b  #週期起時日
       LET g_draw_item1[l_i].azn01_sfb13_e = g_arr1[l_i].azn01_sfb13_e  #週期結束日
       LET g_draw_item1[l_i].azn01_sfb13_e = g_arr1[l_i].azn01_sfb15_e  #週期結束日
#NO.TQC-740056 end---
       LET g_draw_item1[l_i].ypos  = l_x
       LET l_h=l_h+l_draw_multiple
     END FOR
  END IF
 
  CASE tm1.range1
     WHEN '1' LET l_msg=cl_getmsg('apj-023',g_lang)
     WHEN '2' LET l_msg=cl_getmsg('apj-024',g_lang)
     WHEN '3' LET l_msg=cl_getmsg('apj-025',g_lang)
  END CASE
  LET l_msg="(",l_msg,")"
  CALL DrawFillColor("black")
  LET id=DrawText((g_draw_start_y1-5)/4-30,l_hmax+50,l_msg) #日期
  CALL DrawFillColor("black")
  LET l_msg=cl_getmsg('asf1000',g_lang)
  LET l_msg="(",l_msg,")"
  LET id=DrawText(l_vmax+120,35,l_msg) #工作項目
  
  #橫軸刻度
  LET l_draw_y=g_draw_y1
  LET g_draw_width1=l_hmax/l_hcnt
  IF g_draw_width1<15 THEN #避免刻度太擠,最小為15,小於的會重疊
     LET g_draw_width1=15
  END IF
  LET l_y=YEAR(g_mindt1)
  LET l_m=MONTH(g_mindt1)
  LET l_year=TRUE
  LET l_week=g_minwk1   #no.TQC-740056
  #LET l_week=1
  LET l_day=g_mindt1
  WHILE TRUE
     CASE tm1.range1
        WHEN '1' #月
           IF l_m>12 THEN
              LET l_m=l_m MOD 12
              LET l_y=l_y+1
           END IF
           LET id=DrawText(l_hight-10,l_draw_y+5,l_m)
           IF l_year OR (l_m=1) AND (l_draw_y<l_hmax-g_draw_hight1) THEN #一月下面加show西元年
              LET id=DrawText(l_hight-60,l_draw_y+5,l_y)
           END IF
           LET l_m=l_m+1
           
        WHEN '2' #週
           LET id=DrawText(l_hight-10,l_draw_y+5,l_week)
           IF l_year OR l_m<>MONTH(l_day) THEN   #當月第一週下面加show西元年/月
              LET l_msg=MONTH(l_day)
              LET l_msg=l_msg.trim()
              LET l_msg1=YEAR(l_day)
              LET l_msg1=l_msg1.trim()
              #LET l_msg=l_msg1,'/',l_msg
              LET l_msg=l_day   #NO.TQC-740056  秀週期起始日期
              LET id=DrawText(l_hight-60,l_draw_y+5,l_msg)
              LET l_m=MONTH(l_day)
           END IF
           LET l_day=l_day+7
           #NO.TQC-740056 start--
           #LET l_week=l_week+ 1
           LET g_wk_start = g_wk_start + 1
           LET l_week=g_azn[g_wk_start].azn05
           #NO.TQC-740056 end-----
           
        WHEN '3' #日
           LET id=DrawText(l_hight-10,l_draw_y+5,DAY(l_day))
           IF DAY(l_day)=1 AND (l_draw_y<l_hmax-g_draw_hight1) THEN #一日下面加show西元年/月
              LET l_msg=MONTH(l_day)
              LET l_msg=l_msg.trim()
              LET l_msg1=YEAR(l_day)
              LET l_msg1=l_msg1.trim()
              LET l_msg=l_msg1,'/',l_msg
              LET id=DrawText(l_hight-60,l_draw_y+5,l_msg)
           END IF 
           LET l_day=l_day+1
     END CASE
     LET l_draw_y=l_draw_y+g_draw_width1
     IF l_draw_y>(l_hmax+70) THEN
        EXIT WHILE
     END IF
     LET l_year=FALSE
  END WHILE
  
  #圖例
  #預估
  LET l_dist=60
  LET l_draw_x=(g_draw_start_y1-5)/4
  LET l_draw_y=g_draw_y1
  CALL DrawFillColor("blue")
  LET id=DrawRectangle(85,35,20,20) #(Y軸起點,X軸起點,線高度,線寬度)
  
  LET l_msg=cl_getmsg("apj-027",g_lang)
  LET l_msg=l_msg.trim()
  CALL DrawFillColor("black")
  LET id=DrawText(70,20,l_msg)
END FUNCTION
 
FUNCTION q700_view1()
  IF cl_null(tm.range) THEN 
     LET tm.range='1' 
     DISPLAY BY NAME tm.range 
  END IF
  CALL q700_draw(g_row1_now,g_row2_now)   #目前array筆數
  CALL cl_set_act_visible("accept,cancel", FALSE)   #FUN-C30245
 
  WHILE TRUE
  INPUT BY NAME tm.range WITHOUT DEFAULTS
  
     ON CHANGE range
        CALL q700_draw(g_row1_now,g_row2_now)
        IF (g_maxdt=0) OR (g_mindt=0) THEN #OR (g_maxdt=g_mindt) THEN
           CALL cl_err('','asf-026',0)
        END IF
 
     ON ACTION prev_cnt
       #IF g_row1 > 10 THEN #MOD-C60111 mark
        IF g_row1 > 5 THEN  #MOD-C60111
            LET g_action_choice="prev_cnt"
               CALL q700_prev_cnt()
               CALL q700_draw(g_row1_now,g_row2_now)   #目前array筆數
               CONTINUE WHILE
        END IF
 
     ON ACTION next_cnt
       #IF g_tot_cnt > 10 AND g_row2_now < g_tot_cnt THEN  #MOD-C60111 mark
        IF g_tot_cnt > 5 AND g_row2_now < g_tot_cnt THEN   #MOD-C60111
            LET g_action_choice="next_cnt"
            CALL q700_next_cnt()
            CALL q700_draw(g_row1_now,g_row2_now)   #目前array筆數
            CONTINUE WHILE
        END IF
 
     ON ACTION CONTROLR
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
        
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
  END INPUT
  IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
END WHILE
END FUNCTION
 
FUNCTION q700_view2()
  IF cl_null(tm1.range1) THEN 
     LET tm1.range1='1' 
     DISPLAY BY NAME tm1.range1
  END IF
  CALL q700_draw_view2(g_row3_now,g_row4_now)   
  CALL cl_set_act_visible("accept,cancel", FALSE)   #FUN-C30245
  
  WHILE TRUE
  INPUT BY NAME tm1.range1 WITHOUT DEFAULTS
  
     ON CHANGE range1
        CALL q700_draw_view2(g_row3_now,g_row4_now)
        IF (g_maxdt1=0) OR (g_mindt1=0) THEN #OR (g_maxdt1=g_mindt1) THEN
           CALL cl_err('','asf-026',0)
        END IF
 
     ON ACTION prev_cnt1
        #IF g_row3 > 10 THEN
        IF g_row3 > 5 THEN   #NO.TQC-740056
            LET g_action_choice="prev_cnt"
               CALL q700_prev_cnt1()
               CALL q700_draw_view2(g_row3_now,g_row4_now)   #目前array筆數
               CONTINUE WHILE
        END IF
 
     ON ACTION next_cnt1
        #IF g_tot_cnt1 > 10 AND g_row3_now < g_tot_cnt1 THEN
       #IF g_tot_cnt1 > 10 AND g_row4_now < g_tot_cnt1 THEN  #MOD-C60111 mark
        IF g_tot_cnt1 > 5 AND g_row4_now < g_tot_cnt1 THEN   #MOD-C60111
            LET g_action_choice="next_cnt"
            CALL q700_next_cnt1()
            CALL q700_draw_view2(g_row3_now,g_row4_now)   #目前array筆數
            CONTINUE WHILE
        END IF
 
     ON ACTION CONTROLR
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
        
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
  END INPUT
  IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
END WHILE
END FUNCTION
 
FUNCTION q700_prev_cnt()
  LET g_row1 = g_row1_now-10
  LET g_row2 = g_row1 + 9
  DISPLAY g_row1 TO FORMONLY.row1
  DISPLAY g_row2 TO FORMONLY.row2
  LET g_row1_now = g_row1
  LET g_row2_now = g_row2
END FUNCTION
 
FUNCTION q700_next_cnt()
  LET g_row1 = g_row2_now +1
  IF g_row1 >= g_tot_cnt THEN LET g_row1 = g_tot_cnt END IF
  LET g_row2 = g_row1 + 9
  IF g_row2 >= g_tot_cnt THEN LET g_row2 = g_tot_cnt END IF
  DISPLAY g_row1 TO FORMONLY.row1
  DISPLAY g_row2 TO FORMONLY.row2
  LET g_row1_now = g_row1
  LET g_row2_now = g_row2
END FUNCTION
 
FUNCTION q700_prev_cnt1()
  #LET g_row3 = g_row3_now-10
  LET g_row3 = g_row3_now-5  #NO.TQC-740056
  #LET g_row4 = g_row3 + 10
  LET g_row4 = g_row3 + 4    #TQC-740056
  #DISPLAY g_row3 TO FORMONLY.row3  #NO.TQC-740056
  #DISPLAY g_row4 TO FORMONLY.row4  #NO.TQC-740056
  LET g_row3_now = g_row3
  LET g_row4_now = g_row4
END FUNCTION
 
FUNCTION q700_next_cnt1()
  LET g_row3 = g_row4_now +1
  IF g_row3 >= g_tot_cnt1 THEN LET g_row3 = g_tot_cnt1 END IF
  LET g_row4 = g_row3 + 4    #NO.TQC-740056
  #LET g_row4 = g_row3 + 9        
  IF g_row4 >= g_tot_cnt1 THEN LET g_row4 = g_tot_cnt1 END IF
  #DISPLAY g_row3 TO FORMONLY.row3   #NO.TQC-740056 mark
  #DISPLAY g_row4 TO FORMONLY.row4   #NO.TQC-740056 mark
  LET g_row3_now = g_row3
  LET g_row4_now = g_row4
END FUNCTION
 
FUNCTION q700_cur_max(p_field)
DEFINE l_sql      STRING 
DEFINE p_field    LIKE sfb_file.sfb01      #No.FUN-680103 VARCHAR(10)
DEFINE l_max_dt   LIKE type_file.dat
DEFINE l_max_dt_t LIKE type_file.dat
 
   LET l_sql="SELECT MAX(",p_field,") FROM sfb_file ",
                                    " WHERE ",g_wc,
                                    "   AND sfb87 = 'Y'",
                                    " GROUP BY sfb98,sfb102"                                   
   PREPARE q700_cur_max_pre FROM l_sql
   DECLARE q700_cur_max_c CURSOR FOR q700_cur_max_pre
   FOREACH q700_cur_max_c INTO l_max_dt
      IF l_max_dt_t > l_max_dt THEN
          LET l_max_dt = l_max_dt_t 
      END IF
      LET l_max_dt_t =  l_max_dt
   END FOREACH
   RETURN l_max_dt 
END FUNCTION
 
FUNCTION q700_cur_min(p_field)
DEFINE l_sql STRING
DEFINE p_field LIKE sfb_file.sfb01      #No.FUN-680103 VARCHAR(10)
DEFINE l_min_dt   LIKE type_file.dat
DEFINE l_min_dt_t LIKE type_file.dat
 DEFINE i LIKE type_file.num5
 
   LET i =  0
   LET l_sql="SELECT MIN(",p_field,") FROM sfb_file ",
                                    " WHERE ",g_wc,                                
                                    "   AND sfb87 = 'Y'",
                                    " GROUP BY sfb98,sfb102"                                   
   PREPARE q700_cur_min_pre FROM l_sql
   DECLARE q700_cur_min_c CURSOR FOR q700_cur_min_pre
   FOREACH q700_cur_min_c INTO l_min_dt
      LET i = i + 1
      IF i <> 1 AND l_min_dt_t < l_min_dt THEN
          LET l_min_dt = l_min_dt_t 
      END IF
      LET l_min_dt_t =  l_min_dt
   END FOREACH
   RETURN l_min_dt 
END FUNCTION
 
FUNCTION q700_set_bound(p_row1_now,p_row2_now) #設定最大與最小日
DEFINE l_sfb13 LIKE sfb_file.sfb13,
       l_sfb15 LIKE sfb_file.sfb15
DEFINE j,i     LIKE type_file.num5
DEFINE p_row1_now LIKE type_file.num5
DEFINE p_row2_now LIKE type_file.num5
DEFINE l_sfb15_t  LIKE sfb_file.sfb15
DEFINE l_sfb13_t  LIKE sfb_file.sfb13
 
  #程式每次進來只抓g_arr裡1-10筆的資料，如果有翻上/下十筆時再重算最大最小日
  LET g_maxdt=0
  FOR i=p_row1_now TO p_row2_now 
      LET l_sfb15 = g_arr[i].sfb15
      IF l_sfb15_t > l_sfb15 THEN LET l_sfb15 = l_sfb15_t END IF
      LET l_sfb15_t = l_sfb15
  END FOR
  FOR i=p_row1_now TO p_row2_now
      LET l_sfb13 = g_arr[i].sfb13
      IF l_sfb13_t > l_sfb13 THEN LET l_sfb13 = l_sfb13_t END IF
      LET l_sfb13_t = l_sfb13
  END FOR
 
 
  IF l_sfb13>g_maxdt THEN LET g_maxdt=l_sfb13 END IF
  IF l_sfb15>g_maxdt THEN LET g_maxdt=l_sfb15 END IF
 
  LET g_mindt=g_maxdt
  FOR i=p_row1_now TO p_row2_now 
      LET l_sfb15 = g_arr[i].sfb15
      IF l_sfb15_t < l_sfb15 THEN LET l_sfb15 = l_sfb15_t END IF
      LET l_sfb15_t = l_sfb15
  END FOR
  FOR i=p_row1_now TO p_row2_now
      LET l_sfb13 = g_arr[i].sfb13
      IF l_sfb13_t < l_sfb13 THEN LET l_sfb13 = l_sfb13_t END IF
      LET l_sfb13_t = l_sfb13
  END FOR
  IF NOT cl_null(l_sfb13) AND (l_sfb13<g_mindt) THEN
     LET g_mindt=l_sfb13
  END IF
  IF NOT cl_null(l_sfb15) AND (l_sfb15<g_mindt) THEN
     LET g_mindt=l_sfb15
  END IF
END FUNCTION
 
FUNCTION q700_set_bound_view2(p_row3_now,p_row4_now) #設定最大與最小日
DEFINE l_sfb13 LIKE sfb_file.sfb13,
       l_sfb15 LIKE sfb_file.sfb15
DEFINE j,i     LIKE type_file.num5
DEFINE p_row3_now LIKE type_file.num5
DEFINE p_row4_now LIKE type_file.num5
DEFINE l_sfb15_t  LIKE sfb_file.sfb15
DEFINE l_sfb13_t  LIKE sfb_file.sfb13
 
  LET g_maxdt1=0
  LET g_mindt1=g_maxdt1
  LET g_wk_start=g_wk
  #NO.TQC-740056 應以目前的的資料區間找出最大/最小日(依aooq010週期)
  LET g_mindt1 = g_arr1[1].azn01_sfb13_b 
  LET g_minwk1 = g_arr1[1].sfb13_azn05
  LET g_maxwk1 = g_arr1[1].sfb15_azn05
  LET g_maxdt1 = g_arr1[1].azn01_sfb15_e
  FOR i = 1 TO g_tot_cnt1
      IF i <> 1 THEN
          IF g_mindt1 > g_arr1[i].azn01_sfb13_b THEN
              LET g_mindt1 = g_arr1[i].azn01_sfb13_b
              LET g_minwk1 = g_arr1[i].sfb13_azn05
          END IF
      END IF
  END FOR
 
  FOR i = 1 TO g_tot_cnt1
      IF i <> 1 THEN
          IF g_maxdt1 < g_arr1[i].azn01_sfb15_e THEN
              LET g_maxdt1 = g_arr1[i].azn01_sfb15_e
              LET g_maxwk1 = g_arr1[i].sfb15_azn05 
          END IF
      END IF
  END FOR
  #CALL q700_cur_max("sfb15") RETURNING l_sfb15
  #CALL q700_cur_min("sfb13") RETURNING l_sfb13
  #IF NOT cl_null(l_sfb13) THEN
  #   LET g_mindt1=l_sfb13
  #END IF
  #IF NOT cl_null(l_sfb15) THEN
  #   LET g_maxdt1=l_sfb15
  #END IF
END FUNCTION
 
FUNCTION q700_set_hcnt() #設定橫軸刻度數量
DEFINE l_hcnt LIKE type_file.num5        #No.FUN-680103 SMALLINT
   CASE tm.range
      WHEN '1'
         LET l_hcnt=(YEAR(g_maxdt)-YEAR(g_mindt))*12+
                    (MONTH(g_maxdt)-MONTH(g_mindt))
         LET l_hcnt=s_abs(l_hcnt)+1
      WHEN '2'
         LET l_hcnt=(g_maxdt-g_mindt)/7
         LET l_hcnt=s_abs(l_hcnt)+1
      WHEN '3'
         LET l_hcnt=s_abs(g_maxdt-g_mindt)
   END CASE
   RETURN l_hcnt
END FUNCTION
 
FUNCTION q700_set_hcnt_view2() #設定橫軸刻度數量
DEFINE l_hcnt LIKE type_file.num5        #No.FUN-680103 SMALLINT
   CASE tm1.range1
      WHEN '1'
         LET l_hcnt=(YEAR(g_maxdt1)-YEAR(g_mindt1))*12+
                    (MONTH(g_maxdt1)-MONTH(g_mindt1))
         LET l_hcnt=s_abs(l_hcnt)+1
      WHEN '2'
         LET l_hcnt=(g_maxdt1-g_mindt1)/7
         LET l_hcnt=s_abs(l_hcnt)+1
      WHEN '3'
         LET l_hcnt=s_abs(g_maxdt1-g_mindt1)
   END CASE
   RETURN l_hcnt
END FUNCTION
 
#TQC-C50228--add--str-- 
FUNCTION q700_set_required()
   IF l_ac > 0 THEN
      CALL cl_set_comp_required("sfb13,sfb15",TRUE) 
   END IF
END FUNCTION

FUNCTION q700_time(p_cmd)

DEFINE p_cmd      LIKE type_file.chr1  #'1'代表推算預計完工日
                                       #'2'代表推算預計開工日
DEFINE l_ima59    LIKE ima_file.ima59
DEFINE l_ima60    LIKE ima_file.ima60
DEFINE l_ima601   LIKE ima_file.ima601  
DEFINE l_ima61    LIKE ima_file.ima61
DEFINE l_time     LIKE sfb_file.sfb13
DEFINE li_result  LIKE type_file.num5  
DEFINE l_day      LIKE type_file.num5

   IF cl_null(g_arr[l_ac].sfb05) OR cl_null(g_arr[l_ac].sfb08) THEN
      #OR cl_null(g_arr[l_ac].sfb13) THEN
      RETURN
   END IF

   SELECT ima59,ima60,ima601,ima61,ima56 INTO l_ima59,l_ima60,l_ima601,l_ima61  
      FROM ima_file WHERE ima01=g_arr[l_ac].sfb05
   
   IF p_cmd = '1' THEN
      LET l_time = g_arr[l_ac].sfb13
       LET l_day = (l_ima59+l_ima60/l_ima601*g_arr[l_ac].sfb08+l_ima61)   
      WHILE TRUE
         LET li_result = 0
         CALL s_daywk(l_time) RETURNING li_result
         CASE
           WHEN li_result = 0  #0:非工作日
             LET l_time = l_time + 1
             CONTINUE WHILE 
           WHEN li_result = 1  #1:工作日
             EXIT WHILE
           WHEN li_result = 2  #2:無設定
             CALL cl_err(l_time,'mfg3153',0)
             EXIT WHILE
           OTHERWISE EXIT WHILE
         END CASE
      END WHILE
      LET g_arr[l_ac].sfb15 = l_time
      CALL s_aday(g_arr[l_ac].sfb15,1,l_day) RETURNING g_arr[l_ac].sfb15  
      RETURN
   ELSE
      LET l_time = g_arr[l_ac].sfb15
       LET l_day = (l_ima59+l_ima60/l_ima601*g_arr[l_ac].sfb08+l_ima61)  
      
      WHILE TRUE
         LET li_result = 0
         CALL s_daywk(l_time) RETURNING li_result
         CASE
           WHEN li_result = 0  #0:非工作日
             LET l_time = l_time + 1
             CONTINUE WHILE
           WHEN li_result = 1  #1:工作日
             EXIT WHILE
           WHEN li_result = 2  #2:無設定
             CALL cl_err(l_time,'mfg3153',0)
             EXIT WHILE
           OTHERWISE EXIT WHILE
         END CASE
      END WHILE
      LET g_arr[l_ac].sfb13 = l_time
      CALL s_aday(g_arr[l_ac].sfb13,-1,l_day) RETURNING g_arr[l_ac].sfb13   
      RETURN
   END IF
 
END FUNCTION

#TQC-C50228--add--end--
