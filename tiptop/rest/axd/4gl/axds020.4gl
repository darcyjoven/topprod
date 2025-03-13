# Prog. Version..: '5.10.00-08.01.04(00004)'     #
#
# Pattern name...: axds020.4gl
# Descriptions...: 分銷系統參數(二)設定--出貨單
# Date & Author..: 03/12/02 By Carrier
 # Modify.........: No.MOD-4B0067 04/11/10 By Elva 將變數用Like方式定義
# Modify.........: No.FUN-4B0070 04/12/06 By Carrier call s_rate
# Modify.........: No:FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: NO.FUN-550026 05/05/20 By vivien 單據編號加大
# Modify.........: No.MOD-580212 05/09/08 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No:TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-6A0091 06/10/30 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/13 By xumin 稅率、聯數問題更改
# Modify.........: No:TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改

DATABASE ds


GLOBALS "../../config/top.global"
DEFINE
    g_adv           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
     adv01       LIKE adv_file.adv01,   #撥入工廠
        adv02       LIKE adv_file.adv02,   #出貨單別
        adv03       LIKE adv_file.adv03,   #銷售分類
        oab02       LIKE oab_file.oab02,   #業務員
        adv04       LIKE adv_file.adv04,   #業務員姓名
        gen02       LIKE gen_file.gen02,   #出貨部門
        adv05       LIKE adv_file.adv05,   #部門編號
        gem02       LIKE gem_file.gem02,   #部門名稱
        adv06       LIKE adv_file.adv06,   #稅別
        adv07       LIKE adv_file.adv07,   #稅率
        adv08       LIKE adv_file.adv08,   #聯數
        adv09       LIKE adv_file.adv09,   #含稅否
        adv10       LIKE adv_file.adv10,   #幣別
        adv11       LIKE adv_file.adv11,   #匯率
        adv12       LIKE adv_file.adv12,   #發票別
        adv13       LIKE adv_file.adv13,   #科目別
         advacti     LIKE adv_file.advacti  #MOD-4B0067
                    END RECORD,
    g_adv_t         RECORD                 #程式變數 (舊值)
     adv01       LIKE adv_file.adv01,   #撥入工廠
        adv02       LIKE adv_file.adv02,   #出貨單別
        adv03       LIKE adv_file.adv03,   #銷售分類
        oab02       LIKE oab_file.oab02,   #業務員
        adv04       LIKE adv_file.adv04,   #業務員姓名
        gen02       LIKE gen_file.gen02,   #出貨部門
        adv05       LIKE adv_file.adv05,   #部門編號
        gem02       LIKE gem_file.gem02,   #部門名稱
        adv06       LIKE adv_file.adv06,   #稅別
        adv07       LIKE adv_file.adv07,   #稅率
        adv08       LIKE adv_file.adv08,   #聯數
        adv09       LIKE adv_file.adv09,   #含稅否
        adv10       LIKE adv_file.adv10,   #幣別
        adv11       LIKE adv_file.adv11,   #匯率
        adv12       LIKE adv_file.adv12,   #發票別
        adv13       LIKE adv_file.adv13,   #科目別
         advacti     LIKE adv_file.advacti  #MOD-4B0067
                    END RECORD,

    g_argv1            LIKE adv_file.adv01,
     g_wc2,g_sql    string,  #No:FUN-580092 HCN  
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680108 SMALLINT
    g_azp01         LIKE azp_file.azp01,
    g_t1            LIKE oay_file.oayslip, #No.FUN-680108 VARCHAR(05)
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680108 SMALLINT
    g_ss            LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done  LIKE type_file.num5  #No.FUN-680108 SMALLINT

DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(72)
DEFINE   p_row,p_col   LIKE type_file.num5       #No.FUN-680108 SMALLINT


MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0091
    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091

    LET g_adv_t.adv01 = NULL

    LET g_argv1 = ARG_VAL(1)

    LET p_row = 2 LET p_col = 12

    OPEN WINDOW s020_w AT p_row,p_col
         WITH FORM "axd/42f/axds020"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN

    LET g_wc2 = '1=1' CALL s020_b_fill(g_wc2)
    SELECT azp01 INTO g_azp01 FROM azp_file WHERE azp01 = g_plant

    CALL cl_ui_init()

--##
    CALL g_x.clear()
--##

    CALL s020_bp('D')
    CALL s020_menu()

    CLOSE WINDOW s020_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

FUNCTION s020_menu()
   WHILE TRUE
      CALL s020_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL s020_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL s020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL s020_out()
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

FUNCTION s020_q()
   CALL s020_b_askkey()
END FUNCTION

FUNCTION s020_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用        #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否        #No.FUN-680108 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,   #Esc結束INPUT ARRAY 否  #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態        #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #可新增否        #No.FUN-680108 VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1    #可刪除否        #No.FUN-680108 VARCHAR(01)
DEFINE li_result    LIKE type_file.num5    #No.FUN-550026   #No.FUN-680108 SMALLINT
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT adv01,adv02,adv03,'',adv04,'',adv05,'',adv06,",
                       " adv07,adv08,adv09,adv10,adv11,adv12,adv13,advacti ",
                       "  FROM adv_file WHERE adv01=? FOR UPDATE NOWAIT "

    DECLARE s020_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    INPUT ARRAY g_adv WITHOUT DEFAULTS FROM s_adv.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW = l_allow_insert)

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF


    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF g_rec_b >=l_ac THEN
                BEGIN WORK

               LET p_cmd='u'
               LET g_adv_t.* = g_adv[l_ac].*

                OPEN s020_bcl USING g_adv_t.adv01              #表示更改狀態
                IF STATUS THEN
                   CALL cl_err("OPEN s020_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH s020_bcl INTO g_adv[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_adv_t.adv01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                SELECT oab02 INTO g_adv[l_ac].oab02 FROM oab_file
                 WHERE oab01 = g_adv[l_ac].adv03
                SELECT gen02 INTO g_adv[l_ac].gen02 FROM gen_file
                 WHERE gen01 = g_adv[l_ac].adv04
                SELECT gem02 INTO g_adv[l_ac].gem02 FROM gem_file
                 WHERE gem01 = g_adv[l_ac].adv05
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adv[l_ac].* TO NULL      #900423
            LET g_adv[l_ac].advacti = 'Y'         #Body default
            LET g_adv[l_ac].adv12 = '1'           #Body default
            LET g_adv_t.* = g_adv[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adv01

    AFTER INSERT
        DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO adv_file(adv01,adv02,adv03,adv04,adv05,
                       adv06,adv07,adv08,adv09,adv10,adv11,adv12,adv13,
                       advacti,advuser,advgrup,advdate)
            VALUES(g_adv[l_ac].adv01,g_adv[l_ac].adv02,
                   g_adv[l_ac].adv03,g_adv[l_ac].adv04,
                   g_adv[l_ac].adv05,g_adv[l_ac].adv06,
                   g_adv[l_ac].adv07,g_adv[l_ac].adv08,
                   g_adv[l_ac].adv09,g_adv[l_ac].adv10,
                   g_adv[l_ac].adv11,g_adv[l_ac].adv12,
                   g_adv[l_ac].adv13,g_adv[l_ac].advacti,
                   g_user,g_grup,g_today)
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_adv[l_ac].adv01,SQLCA.sqlcode,0)
           CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
           END IF


        AFTER FIELD adv01                        #check 編號是否重複
            IF NOT cl_null(g_adv[l_ac].adv01) THEN
               SELECT * FROM adb_file WHERE adb02 = g_adv[l_ac].adv01
                  AND adb01 = g_azp01
               IF SQLCA.sqlcode = 100 THEN
                  CALL cl_err(g_adv[l_ac].adv01,100,0)
                  NEXT FIELD adv01
               END IF
            END IF
            IF g_adv[l_ac].adv01 != g_adv_t.adv01 OR
               (g_adv[l_ac].adv01 IS NOT NULL AND g_adv_t.adv01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM adv_file
                    WHERE adv01 = g_adv[l_ac].adv01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_adv[l_ac].adv01 = g_adv_t.adv01
                    NEXT FIELD adv01
                END IF
            END IF

        AFTER FIELD adv02   #單別
            IF NOT cl_null(g_adv[l_ac].adv02) THEN
           #No.FUN-550026 --start--
              CALL s_check_no("axm",g_adv[l_ac].adv02,"","50","adv_file","adv02","")
              RETURNING li_result,g_adv[l_ac].adv02
              CALL s_get_doc_no(g_adv[l_ac].adv02) RETURNING g_adv[l_ac].adv02
              DISPLAY BY NAME g_adv[l_ac].adv02
              IF (NOT li_result) THEN
              NEXT FIELD adv021
              END IF
            END IF
           #No.FUN-550026 --start--
#              LET g_t1=g_adv[l_ac].adv02[1,3]
#               CALL s_axmslip(g_t1,'50',g_sys)
#               IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#                  CALL cl_err(g_t1,g_errno,0)
#	          LET g_adv[l_ac].adv02 = g_adv_t.adv02
#                  NEXT FIELD adv02
#               END IF
#            END IF

	AFTER FIELD adv03   #銷售分類
            IF NOT cl_null(g_adv[l_ac].adv03) THEN
               CALL s020_adv03('a')
                    IF NOT cl_null(g_errno)  THEN
                       CALL cl_err('',g_errno,0)
                       LET g_adv[l_ac].adv03 = g_adv_t.adv03
                       #------MOD-5A0095 START----------
                       DISPLAY BY NAME g_adv[l_ac].adv03
                       #------MOD-5A0095 END------------
                       NEXT FIELD adv03
                    END IF
            END IF

        AFTER FIELD adv04   #采購員
	    IF NOT cl_null(g_adv[l_ac].adv04) THEN
   	       CALL s020_adv04('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adv[l_ac].adv04 = g_adv_t.adv04
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adv[l_ac].adv04
                  #------MOD-5A0095 END------------
                  NEXT FIELD adv04
    	       END IF
            END IF
			
        AFTER FIELD adv05   #部門
	    IF NOT cl_null(g_adv[l_ac].adv05) THEN
   	       CALL s020_adv05('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adv[l_ac].adv05 = g_adv_t.adv05
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adv[l_ac].adv05
                  #------MOD-5A0095 END------------
                  NEXT FIELD adv05
    	       END IF
            END IF

        AFTER FIELD adv06   #稅別
	    IF NOT cl_null(g_adv[l_ac].adv06) THEN
   	       CALL s020_adv06()
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adv[l_ac].adv06 = g_adv_t.adv06
                  #------MOD-5A0095 START----------
	          DISPLAY BY NAME g_adv[l_ac].adv06
	          #------MOD-5A0095 END------------
                  NEXT FIELD adv06
    	       END IF
            END IF

        AFTER FIELD adv10   #幣別
	    IF NOT cl_null(g_adv[l_ac].adv10) THEN
   	       CALL s020_adv10()
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adv[l_ac].adv10 = g_adv_t.adv10
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adv[l_ac].adv10
                  #------MOD-5A0095 END------------
                  NEXT FIELD adv10
               ELSE
                  IF g_aza.aza17 = g_adv[l_ac].adv10 THEN   #本幣
                     LET g_adv[l_ac].adv11 = 1
                  ELSE
                     IF g_adv[l_ac].adv10 <> g_adv_t.adv10
                     OR cl_null(g_adv_t.adv10) THEN
                        CALL s_curr3(g_adv[l_ac].adv10,g_today,'S')
                             RETURNING g_adv[l_ac].adv11
                     END IF
                  END IF
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adv[l_ac].adv11
	          #------MOD-5A0095 END------------
    	       END IF
            END IF

        AFTER FIELD adv11  #匯率
           IF NOT cl_null(g_adv[l_ac].adv11) THEN
              IF g_adv[l_ac].adv11 < 0 THEN
 	         LET g_adv[l_ac].adv11 = g_adv_t.adv11
        	 #------MOD-5A0095 START----------
	         DISPLAY BY NAME g_adv[l_ac].adv11
	         #------MOD-5A0095 END------------
                 NEXT FIELD adv11
              END IF
           END IF

        BEFORE FIELD adv12
           LET g_adv[l_ac].adv12 = '1'
       	   #------MOD-5A0095 START----------
	   DISPLAY BY NAME g_adv[l_ac].adv12
	   #------MOD-5A0095 END------------


        AFTER FIELD adv13  #科目別
           IF NOT cl_null(g_adv[l_ac].adv13) THEN
               CALL s020_adv13()
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adv[l_ac].adv13 = g_adv_t.adv13
                  #------MOD-5A0095 START----------
	          DISPLAY BY NAME g_adv[l_ac].adv13
	          #------MOD-5A0095 END------------
                  NEXT FIELD adv13
               END IF
           END IF

	AFTER FIELD advacti
  	   IF g_adv[l_ac].advacti NOT MATCHES '[YN]' OR
	      cl_null(g_adv[l_ac].advacti) THEN
	      LET g_adv[l_ac].advacti = g_adv_t.advacti
              #------MOD-5A0095 START----------
	      DISPLAY BY NAME g_adv[l_ac].advacti
	      #------MOD-5A0095 END------------
              NEXT FIELD advacti
           END IF

        BEFORE DELETE                            #是否取消單身
            IF g_adv_t.adv01 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF

                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

{ckp#1}         DELETE FROM adv_file WHERE adv01 = g_adv_t.adv01
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_adv_t.adv01,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                MESSAGE "Delete OK"
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_adv[l_ac].* = g_adv_t.*
              CLOSE s020_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_adv[l_ac].adv01,-263,0)
              LET g_adv[l_ac].* = g_adv_t.*
           ELSE
              UPDATE adv_file SET(adv01,adv02,adv03,adv04,adv05,adv06,
                                  adv07,adv08,adv09,adv10,adv11,adv12,adv13,
                                  advacti,advmodu,advdate)
                                =(g_adv[l_ac].adv01,g_adv[l_ac].adv02,
                                  g_adv[l_ac].adv03,g_adv[l_ac].adv04,
                                  g_adv[l_ac].adv05,g_adv[l_ac].adv06,
                                  g_adv[l_ac].adv07,g_adv[l_ac].adv08,
                                  g_adv[l_ac].adv09,g_adv[l_ac].adv10,
                                  g_adv[l_ac].adv11,g_adv[l_ac].adv12,
                                  g_adv[l_ac].adv13,g_adv[l_ac].advacti,
                               	 g_user,g_today)
                WHERE adv01 = g_adv_t.adv01

              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adv[l_ac].adv01,SQLCA.sqlcode,0)
                  LET g_adv[l_ac].* = g_adv_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
              END IF
           END IF

    AFTER ROW
        DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac

           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
              LET g_adv[l_ac].* = g_adv_t.*
             END IF
              CLOSE s020_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE s020_bcl            # 新增
           COMMIT WORK

       ON ACTION CONTROLP                       # 沿用所有欄位
           CASE
                WHEN INFIELD(adv01) #order nubmer
                #   CALL q_adb2(9,12,g_adv[l_ac].adv01,g_azp01)
                #        RETURNING g_adv[l_ac].adv01
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adb2"
                    LET g_qryparam.default1=g_adv[l_ac].adv01
                    LET g_qryparam.arg1 = g_plant
                    CALL cl_create_qry() RETURNING g_adv[l_ac].adv01
                    NEXT FIELD adv01
                WHEN INFIELD(adv02) #order nubmer
           #        LET g_t1=g_adv[l_ac].adv02[1,3]
           #        CALL q_oay(9,12,g_t1,'50',g_sys) RETURNING g_t1
           #        LET g_adv[l_ac].adv02[1,3]=g_t1
                    #CALL q_oay(FALSE,FALSE,g_adv[l_ac].adv02,'50','axd')  #TQC-670008
                    CALL q_oay(FALSE,FALSE,g_adv[l_ac].adv02,'50','AXD')   #TQC-670008
                    RETURNING g_adv[l_ac].adv02
#                    CALL FGL_DIALOG_SETBUFFER(g_adv[l_ac].adv02)
                    NEXT FIELD adv02
                WHEN INFIELD(adv03)
                #   CALL q_oab(05,11,g_adv[l_ac].adv03)
                #        RETURNING g_adv[l_ac].adv03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oab"
                    LET g_qryparam.default1 = g_adv[l_ac].adv03
                    CALL cl_create_qry() RETURNING g_adv[l_ac].adv03
#                    CALL FGL_DIALOG_SETBUFFER( g_adv[l_ac].adv03 )
                    NEXT FIELD adv03
                WHEN INFIELD(adv04)
                #   CALL q_gen(8,10,g_adv[l_ac].adv04)
                #        RETURNING g_adv[l_ac].adv04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adv[l_ac].adv04
                    CALL cl_create_qry() RETURNING g_adv[l_ac].adv04
                    CALL s020_adv04('a')
                    NEXT FIELD adv04
                WHEN INFIELD(adv05) #請購DEPT
                #   CALL q_gem(8,10,g_adv[l_ac].adv05)
                #        RETURNING g_adv[l_ac].adv05
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_adv[l_ac].adv05
                    CALL cl_create_qry() RETURNING g_adv[l_ac].adv05
                    CALL s020_adv05('a')
                    NEXT FIELD adv05
                WHEN INFIELD(adv06) #查詢稅別資料檔(gec_file)i
                #   CALL q_gec(10,3,g_adv[l_ac].adv06,'2')
                #        RETURNING g_adv[l_ac].adv06
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gec"
                    LET g_qryparam.default1 = g_adv[l_ac].adv06
                    LET g_qryparam.arg1 = '2'
                    CALL cl_create_qry() RETURNING g_adv[l_ac].adv06
#                    CALL FGL_DIALOG_SETBUFFER( g_adv[l_ac].adv06 )
                    NEXT FIELD adv06
                WHEN INFIELD(adv10) #查詢幣別資料檔
                #    CALL q_azi(10,3,g_adv[l_ac].adv10)
                #         RETURNING g_adv[l_ac].adv10
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azi"
                     LET g_qryparam.default1 = g_adv[l_ac].adv10
                     CALL cl_create_qry() RETURNING g_adv[l_ac].adv10
#                     CALL FGL_DIALOG_SETBUFFER( g_adv[l_ac].adv10 )
                     NEXT FIELD adv10
                #NO.FUN-4B0070  --begin
                WHEN INFIELD(adv11) #
                     CALL s_rate(g_adv[l_ac].adv10,g_adv[l_ac].adv11) RETURNING g_adv[l_ac].adv11
                     NEXT FIELD adv11
                #NO.FUN-4B0070  --end
                WHEN INFIELD(adv13)
                #    CALL q_ool(05,11,g_adv[l_ac].adv13)
                #         RETURNING g_adv[l_ac].adv13
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_ool"
                     LET g_qryparam.default1 = g_adv[l_ac].adv13
                     CALL cl_create_qry() RETURNING g_adv[l_ac].adv13
#                     CALL FGL_DIALOG_SETBUFFER( g_adv[l_ac].adv13 )
                     NEXT FIELD adv13
                OTHERWISE
                    EXIT CASE
            END CASE

      ON ACTION CONTROLN
          CALL s020_b_askkey()
          EXIT INPUT

        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(adv01) AND l_ac > 1 THEN
                LET g_adv[l_ac].* = g_adv[l_ac-1].*
                NEXT FIELD adv01
            END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 

        END INPUT

    CLOSE s020_bcl
    COMMIT WORK
END FUNCTION

FUNCTION s020_adv03(p_cmd)    #銷售分類
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_oab02     LIKE oab_file.oab02 

    LET g_errno = ' '
    SELECT oab02 INTO l_oab02 FROM oab_file
     WHERE oab01 = g_adv[l_ac].adv03

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                   LET g_adv[l_ac].adv03 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_adv[l_ac].oab02 = l_oab02
       #------MOD-5A0095 START----------
       DISPLAY BY NAME g_adv[l_ac].oab02
       #------MOD-5A0095 END------------
    END IF
END FUNCTION

FUNCTION s020_adv04(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gen02     LIKE gen_file.gen02,
        l_genacti   LIKE gen_file.genacti

    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
     WHERE gen01 = g_adv[l_ac].adv04

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                   LET g_adv[l_ac].adv04 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_adv[l_ac].gen02 = l_gen02
       #------MOD-5A0095 START----------
       DISPLAY BY NAME g_adv[l_ac].gen02
       #------MOD-5A0095 END------------
    END IF
END FUNCTION

FUNCTION s020_adv05(p_cmd)    #部門
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gem02     LIKE gem_file.gem02,
        l_gemacti   LIKE gem_file.gemacti

    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
     WHERE gem01 = g_adv[l_ac].adv05

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET g_adv[l_ac].adv05 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_adv[l_ac].gem02 = l_gem02
      #------MOD-5A0095 START----------
       DISPLAY BY NAME g_adv[l_ac].gem02
       #------MOD-5A0095 END------------
    END IF
END FUNCTION

FUNCTION s020_adv06()  #稅別
  DEFINE  l_gec04   LIKE gec_file.gec04,
          l_gec05   LIKE gec_file.gec05,
          l_gec07   LIKE gec_file.gec07,
          l_gecacti LIKE gec_file.gecacti

    LET g_errno = " "
    SELECT gec04,gec05,gec07,gecacti INTO l_gec04,l_gec05,l_gec07,l_gecacti
      FROM gec_file
     WHERE gec01 = g_adv[l_ac].adv06 AND gec011 = '2'
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                   LET l_gec04 = 0
         WHEN l_gecacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(l_gec04) THEN
       LET g_adv[l_ac].adv07 = l_gec04
       LET g_adv[l_ac].adv08 = l_gec05
       LET g_adv[l_ac].adv09 = l_gec07
       #------MOD-5A0095 START----------
       DISPLAY BY NAME g_adv[l_ac].adv07
       DISPLAY BY NAME g_adv[l_ac].adv08
       DISPLAY BY NAME g_adv[l_ac].adv09
       #------MOD-5A0095 END------------
    END IF
END FUNCTION

FUNCTION s020_adv10()  #幣別
  DEFINE l_aziacti LIKE azi_file.aziacti

    LET g_errno = " "
    SELECT aziacti INTO l_aziacti FROM azi_file
     WHERE azi01 = g_adv[l_ac].adv10

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                   LET l_aziacti = NULL
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION s020_adv13()  #科目別
  DEFINE l_ool02 LIKE ool_file.ool02

    LET g_errno = " "
    SELECT ool02 INTO l_ool02 FROM ool_file
     WHERE ool01 = g_adv[l_ac].adv13

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                   LET l_ool02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION s020_b_askkey()
    CLEAR FORM
    CALL g_adv.clear()
 CONSTRUCT g_wc2 ON adv01,adv02,adv03,adv04,adv05,adv06,adv07,
                       adv08,adv09,adv10,adv11,adv12,adv13,advacti
            FROM s_adv[1].adv01,s_adv[1].adv02,s_adv[1].adv03,
                 s_adv[1].adv04,s_adv[1].adv05,s_adv[1].adv06,
                 s_adv[1].adv07,s_adv[1].adv08,s_adv[1].adv09,
                 s_adv[1].adv10,s_adv[1].adv11,s_adv[1].adv12,
                 s_adv[1].adv13,s_adv[1].advacti

       ON ACTION CONTROLP                       # 沿用所有欄位
           CASE
                WHEN INFIELD(adv01) #order nubmer
                #   CALL q_adb2(9,12,g_adv[l_ac].adv01,g_azp01)
                #        RETURNING g_adv[l_ac].adv01
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adb2"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = g_plant
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adv[1].adv01
                    NEXT FIELD adv01
                WHEN INFIELD(adv02) #order nubmer
           #        LET g_t1=g_adv[l_ac].adv02[1,3]
           #        CALL q_oay(9,12,g_t1,'50',g_sys) RETURNING g_t1
           #        LET g_adv[l_ac].adv02[1,3]=g_t1
                   #CALL q_oay(FALSE,TRUE,g_adv[l_ac].adv02,'50','axd')  #TQC-670008
                    CALL q_oay(FALSE,TRUE,g_adv[l_ac].adv02,'50','AXD')  #TQC-670008
               #     RETURNING g_adv[l_ac].adv02
                     RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_adv[1].adv02

                     NEXT FIELD adv02
                WHEN INFIELD(adv03)
                #   CALL q_oab(05,11,g_adv[l_ac].adv03)
                #        RETURNING g_adv[l_ac].adv03
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oab"
                    LET g_qryparam.default1 = g_adv[l_ac].adv03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adv[1].adv03
                    NEXT FIELD adv03
                WHEN INFIELD(adv04)
                #   CALL q_gen(8,10,g_adv[l_ac].adv04)
                #        RETURNING g_adv[l_ac].adv04
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adv[l_ac].adv04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adv[1].adv04
                #   CALL s020_adv04('a')
                    NEXT FIELD adv04
                WHEN INFIELD(adv05) #請購DEPT
                #   CALL q_gem(8,10,g_adv[l_ac].adv05)
                #        RETURNING g_adv[l_ac].adv05
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_adv[l_ac].adv05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adv[1].adv05
                #   CALL s020_adv05('a')
                    NEXT FIELD adv05
                WHEN INFIELD(adv06) #查詢稅別資料檔(gec_file)i
                #   CALL q_gec(10,3,g_adv[l_ac].adv06,'2')
                #        RETURNING g_adv[l_ac].adv06
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gec"
                    LET g_qryparam.default1 = g_adv[l_ac].adv06
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adv[1].adv06
                    NEXT FIELD adv06
                WHEN INFIELD(adv10) #查詢幣別資料檔
                #    CALL q_azi(10,3,g_adv[l_ac].adv10)
                #         RETURNING g_adv[l_ac].adv10
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_azi"
                     LET g_qryparam.default1 = g_adv[l_ac].adv10
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_adv[1].adv10
                     NEXT FIELD adv10
                WHEN INFIELD(adv13)
                #    CALL q_ool(05,11,g_adv[l_ac].adv13)
                #         RETURNING g_adv[l_ac].adv13
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form ="q_ool"
                     LET g_qryparam.default1 = g_adv[l_ac].adv13
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_adv[1].adv13
                     NEXT FIELD adv13
                OTHERWISE
                    EXIT CASE
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
 

    END CONSTRUCT
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL s020_b_fill(g_wc2)
END FUNCTION

FUNCTION s020_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT adv01,adv02,adv03,oab02,adv04,gen02,adv05,gem02,",
        "       adv06,adv07,adv08,adv09,adv10,adv11,adv12,adv13,advacti",
        " FROM adv_file,OUTER gen_file,OUTER gem_file,OUTER oab_file",
        " WHERE adv04 = gen01 AND adv05 = gem01 AND ",p_wc2 CLIPPED,   #單身
        "   AND adv03 = oab01 ",
        " ORDER BY 1"
    PREPARE s020_pb FROM g_sql
    DECLARE adv_curs CURSOR FOR s020_pb

    CALL g_adv.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH adv_curs INTO g_adv[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_adv.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION

FUNCTION s020_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

    IF p_ud <> "G" OR g_action_choice = "detail" THEN

      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adv TO s_adv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
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
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION s020_out()
    DEFINE
        l_adv           RECORD LIKE adv_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680108 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680108 VARCHAR(20)                # External(Disk) file name
         l_za05          LIKE za_file.za05        # MOD-4B0067

    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axds020') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM adv_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE s020_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE s020_co                         # SCROLL CURSOR
         CURSOR FOR s020_p1

    START REPORT s020_rep TO l_name

    FOREACH s020_co INTO l_adv.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        OUTPUT TO REPORT s020_rep(l_adv.*)
    END FOREACH

    FINISH REPORT s020_rep

    CLOSE s020_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT s020_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)
        sr RECORD LIKE adv_file.*,
        l_gem02   LIKE gem_file.gem02,
        l_gen02   LIKE gen_file.gen02,
        l_oab02   LIKE oab_file.oab02,
        l_chr           LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.adv01

    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total

            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]

            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
                  g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
                  g_x[46],g_x[47]
            PRINT g_dash1
            LET l_trailer_sw = 'y'

        ON EVERY ROW
	    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.adv04
	    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.adv05
	    SELECT oab02 INTO l_oab02 FROM oab_file WHERE oab01 = sr.adv03
            SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = sr.adv10   #No.MOD-580212
            PRINT COLUMN g_c[31],sr.adv01,
                  COLUMN g_c[32],sr.adv02,
                  COLUMN g_c[33],sr.adv03,
                  COLUMN g_c[34],l_oab02,
                  COLUMN g_c[35],sr.adv04,
                  COLUMN g_c[36],l_gen02,
                  COLUMN g_c[37],sr.adv05,
                  COLUMN g_c[38],l_gem02,
                  COLUMN g_c[39],sr.adv06,
#                  COLUMN g_c[40],sr.adv07  USING "--.&&",
                  COLUMN g_c[40],cl_numfor(sr.adv07,5,2),    #TQC-6A0095
                  COLUMN g_c[41],cl_numfor(sr.adv08,4,0),      #TQC-6A0095
                  COLUMN g_c[42],sr.adv09,
                  COLUMN g_c[43],sr.adv10,
                  COLUMN g_c[44],cl_numfor(sr.adv11,44,t_azi07),  #No.MOD-580212
                  COLUMN g_c[45],sr.adv12,
                  COLUMN g_c[46],sr.adv13,
                  COLUMN g_c[47],sr.advacti
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
#Patch....NO:MOD-5A0095 <001,002,003,004,005,006,007,008,009,010,011,012,013,014> #
