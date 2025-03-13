# Prog. Version..: '5.10.00-08.01.04(00004)'     #
#
# Pattern name...: axds010.4gl
# Descriptions...: 分銷系統參數(一)設定--采購單
# Date & Author..: 03/12/02 By Carrier
 # Modify.........: No.MOD-4B0067 04/11/10 By Elva 將變數用Like方式定義
# Modify.........: No.FUN-4B0070 04/12/06 By Carrier call s_rate
# Modify.........: No:FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: NO.FUN-550026 05/05/20 By vivien 單據編號加大
# Modify.........: NO.FUN-580033 05/08/12 By Carrier 修正單別錯誤
# Modify.........: No.MOD-580212 05/09/08 By ice 小數位數根據azi檔的設置來取位
# Modify.........: No:TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-6A0091 06/10/30 By douzh l_time轉g_time
# Modify.........: No:TQC-6A0095 06/11/10 By xumin 稅率顯示更改
# Modify.........: No:TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_adu           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
     adu01       LIKE adu_file.adu01,   #撥出工廠
        adu02       LIKE adu_file.adu02,   #采購單別
        adu021      LIKE adu_file.adu02,   #收貨單別
        adu03       LIKE adu_file.adu03,   #付款條件
        adu04       LIKE adu_file.adu04,   #價格條件
        adu05       LIKE adu_file.adu05,   #送貨地址
        adu06       LIKE adu_file.adu06,   #采購員
        gen02       LIKE gen_file.gen02,   #采購員姓名
        adu07       LIKE adu_file.adu07,   #部門編號
        gem02       LIKE gem_file.gem02,   #部門名稱
        adu08       LIKE adu_file.adu08,   #稅別
        adu09       LIKE adu_file.adu09,   #稅率
        adu10       LIKE adu_file.adu10,   #幣別
        adu11       LIKE adu_file.adu11,   #匯率
         aduacti     LIKE adu_file.aduacti  #MOD-4B0067
                    END RECORD,
    g_adu_t         RECORD                 #程式變數 (舊值)
     adu01       LIKE adu_file.adu01,   #撥出工廠
        adu02       LIKE adu_file.adu02,   #采購單別
        adu021      LIKE adu_file.adu02,   #收貨單別
        adu03       LIKE adu_file.adu03,   #付款條件
        adu04       LIKE adu_file.adu04,   #價格條件
        adu05       LIKE adu_file.adu05,   #送貨地址
        adu06       LIKE adu_file.adu06,   #采購員
        gen02       LIKE gen_file.gen02,   #采購員姓名
        adu07       LIKE adu_file.adu07,   #部門編號
        gem02       LIKE gem_file.gem02,   #部門名稱
        adu08       LIKE adu_file.adu08,   #稅別
        adu09       LIKE adu_file.adu09,   #稅率
        adu10       LIKE adu_file.adu10,   #幣別
        adu11       LIKE adu_file.adu11,   #匯率
         aduacti     LIKE adu_file.aduacti  #MOD-4B0067
                    END RECORD,
     g_wc2,g_sql    string,  #No:FUN-580092 HCN    
    g_rec_b         LIKE type_file.num5,   #單身筆數              #No.FUN-680108 SMALLINT
    g_azp01         LIKE azp_file.azp01,
    g_t1            LIKE oay_file.oayslip, #No.FUN-550026         #No.FUN-680108 VARCHAR(05)
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT   #No.FUN-680108 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL   
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680108 SMALLINT

DEFINE   g_cnt         LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_i           LIKE type_file.num5     #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg         LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(72)
DEFINE   p_row,p_col   LIKE type_file.num5     #No.FUN-680108 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0091
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680108 SMALLINT
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
    LET p_row = 4 LET p_col = 6
    OPEN WINDOW s010_w AT p_row,p_col WITH FORM "axd/42f/axds010"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
     CALL cl_ui_init()
--##
    CALL g_x.clear()
--##

    LET g_wc2 = '1=1' CALL s010_b_fill(g_wc2)
    SELECT azp01 INTO g_azp01 FROM azp_file WHERE azp01 = g_plant
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_plant,SQLCA.sqlcode,0)
       EXIT PROGRAM
    END IF
    CALL s010_bp('D')
    CALL s010_menu()    #中文
    CLOSE WINDOW s010_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

FUNCTION s010_menu()
   WHILE TRUE
      CALL s010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL s010_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL s010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL s010_out()
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

FUNCTION s010_q()
   CALL s010_b_askkey()
END FUNCTION

FUNCTION s010_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1000, #可新增否          #No.FUN-680108 VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1000  #可刪除否          #No.FUN-680108 VARCHAR(01)
DEFINE  li_result   LIKE type_file.num5     #No.FUN-550026     #No.FUN-680108 SMALLINT
    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql="SELECT adu01,adu02,adu021,adu03,adu04,adu05,adu06,'',",
                     " adu07,'',adu08,adu09,adu10,adu11,aduacti",
                     " FROM adu_file",
                     " WHERE adu01= ?",
                     " FOR UPDATE NOWAIT"
    DECLARE s010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

            INPUT ARRAY g_adu WITHOUT DEFAULTS FROM s_adu.*
            ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                       INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                       APPEND ROW = l_allow_insert)
    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'
            IF g_rec_b >=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_adu_t.* = g_adu[l_ac].*  #BACKUP
                OPEN s010_bcl USING g_adu_t.adu01      #表示更改狀態
                IF STATUS THEN
                   CALL cl_err("OPEN s010_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_adu_t.adu01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   FETCH s010_bcl INTO g_adu[l_ac].*
                END IF
                SELECT gem02 INTO g_adu[l_ac].gem02 FROM gem_file
                 WHERE gem01 = g_adu[l_ac].adu07
                SELECT gen02 INTO g_adu[l_ac].gen02 FROM gen_file
                 WHERE gen01 = g_adu[l_ac].adu06
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adu[l_ac].* TO NULL      #900423
            LET g_adu[l_ac].aduacti = 'Y'       #Body default
            LET g_adu_t.* = g_adu[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adu01

    AFTER INSERT
        DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
              INSERT INTO adu_file(adu01,adu02,adu021,adu03,adu04,
                        adu05,adu06,adu07,adu08,adu09,adu10,adu11,
                        aduacti,aduuser,adugrup,adudate)
              VALUES(g_adu[l_ac].adu01,g_adu[l_ac].adu02,
                     g_adu[l_ac].adu021,
                     g_adu[l_ac].adu03,g_adu[l_ac].adu04,
                     g_adu[l_ac].adu05,g_adu[l_ac].adu06,
                     g_adu[l_ac].adu07,g_adu[l_ac].adu08,
                     g_adu[l_ac].adu09,g_adu[l_ac].adu10,
                     g_adu[l_ac].adu11,g_adu[l_ac].aduacti,
                     g_user,g_grup,g_today)
          IF SQLCA.sqlcode THEN
              CALL cl_err(g_adu[l_ac].adu01,SQLCA.sqlcode,0)
           CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
           END IF


        AFTER FIELD adu01                        #check 編號是否重複
            IF NOT cl_null(g_adu[l_ac].adu01) THEN
               SELECT * FROM adb_file WHERE adb01 = g_adu[l_ac].adu01
                  AND adb02 = g_azp01
               IF SQLCA.sqlcode = 100 THEN
                  CALL cl_err(g_adu[l_ac].adu01,100,0)
                  LET g_adu[l_ac].adu01 = g_adu_t.adu01
                  NEXT FIELD adu01
               END IF
               IF g_adu[l_ac].adu01 != g_adu_t.adu01 OR
                  (g_adu[l_ac].adu01 IS NOT NULL AND g_adu_t.adu01 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM adu_file
                       WHERE adu01 = g_adu[l_ac].adu01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_adu[l_ac].adu01 = g_adu_t.adu01
                       NEXT FIELD adu01
                   END IF
               END IF
            END IF

        AFTER FIELD adu02   #單別
            IF NOT cl_null(g_adu[l_ac].adu02) THEN
	            #No.FUN-550026 --start--
              CALL s_check_no("apm",g_adu[l_ac].adu02,g_adu_t.adu02,"2","adu_file","adu02","")  
              RETURNING li_result,g_adu[l_ac].adu02
              CALL s_get_doc_no(g_adu[l_ac].adu02) RETURNING g_adu[l_ac].adu02 #No.FUN-580033
              DISPLAY BY NAME g_adu[l_ac].adu02
              IF (NOT li_result) THEN
              NEXT FIELD adu02
              END IF
            END IF
#               LET g_t1=g_adu[l_ac].adu02[1,3]
#               CALL s_mfgslip(g_t1,'apm','2')
#               IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#                   CALL cl_err(g_t1,g_errno,0)
#	           LET g_adu[l_ac].adu02 = g_adu_t.adu02
#                   NEXT FIELD adu02
#               END IF
#            END IF
        #No.FUN-550026 --end--  

        AFTER FIELD adu021   #單別
            IF NOT cl_null(g_adu[l_ac].adu021) THEN
	            #No.FUN-550026 --start--
              CALL   s_check_no("apm",g_adu[l_ac].adu021,g_adu_t.adu021,"3","adu_file","adu021","")  
              RETURNING li_result,g_adu[l_ac].adu021
              CALL s_get_doc_no(g_adu[l_ac].adu021) RETURNING g_adu[l_ac].adu021 #No.FUN-580033
              DISPLAY BY NAME g_adu[l_ac].adu021
              IF (NOT li_result) THEN
              NEXT FIELD adu021
              END IF
            END IF

#               LET g_t1=g_adu[l_ac].adu021[1,3]
#               CALL s_mfgslip(g_t1,'apm','3')
#               IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
#                   CALL cl_err(g_t1,g_errno,0)
#	           LET g_adu[l_ac].adu021 = g_adu_t.adu021
#                   NEXT FIELD adu021
#               END IF
#            END IF
        #No.FUN-550026 --end--  

	AFTER FIELD adu03   #付款條件
	    IF NOT cl_null(g_adu[l_ac].adu03) THEN
   	       CALL s010_adu03('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adu[l_ac].adu03 = g_adu_t.adu03
                  NEXT FIELD adu03
    	       END IF
    	    END IF

	AFTER FIELD adu04   #價格條件
	    IF NOT cl_null(g_adu[l_ac].adu04) THEN
   	       CALL s010_adu04('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adu[l_ac].adu04 = g_adu_t.adu04
                  NEXT FIELD adu04
    	       END IF
    	    END IF

	AFTER FIELD adu05   #送貨地址
	    IF NOT cl_null(g_adu[l_ac].adu05) THEN
   	       CALL s010_adu05('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adu[l_ac].adu05 = g_adu_t.adu05
                  NEXT FIELD adu05
    	       END IF
    	    END IF

        AFTER FIELD adu06   #采購員
	    IF NOT cl_null(g_adu[l_ac].adu06) THEN
   	       CALL s010_adu06('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adu[l_ac].adu06 = g_adu_t.adu06
                  NEXT FIELD adu06
    	       END IF
            END IF
			
        AFTER FIELD adu07  #部門
	    IF NOT cl_null(g_adu[l_ac].adu07) THEN
   	       CALL s010_adu07('a')
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adu[l_ac].adu07 = g_adu_t.adu07
                  NEXT FIELD adu07
    	       END IF
            END IF

        AFTER FIELD adu08  #稅別
	    IF NOT cl_null(g_adu[l_ac].adu08) THEN
   	       CALL s010_adu08()
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adu[l_ac].adu08 = g_adu_t.adu08
                  NEXT FIELD adu08
    	       END IF
            END IF

        AFTER FIELD adu09  #稅率
           IF g_adu[l_ac].adu09 < 0 THEN
 	      LET g_adu[l_ac].adu09 = g_adu_t.adu09
              NEXT FIELD adu09
           END IF

        AFTER FIELD adu10  #幣別
	    IF NOT cl_null(g_adu[l_ac].adu10) THEN
   	       CALL s010_adu10()
    	       IF NOT cl_null(g_errno)  THEN
	          CALL cl_err('',g_errno,0)
 	          LET g_adu[l_ac].adu10 = g_adu_t.adu10
                  NEXT FIELD adu10
               ELSE
                  IF g_aza.aza17 = g_adu[l_ac].adu10 THEN   #本幣
                     LET g_adu[l_ac].adu11 = 1
                  ELSE
                     IF g_adu[l_ac].adu10 <> g_adu_t.adu10
                     OR cl_null(g_adu_t.adu10) THEN
                        CALL s_curr3(g_adu[l_ac].adu10,g_today,'S')
                             RETURNING g_adu[l_ac].adu11
                     END IF
                  END IF
    	       END IF
            END IF

        AFTER FIELD adu11  #匯率
           IF g_adu[l_ac].adu11 < 0 THEN
 	      LET g_adu[l_ac].adu11 = g_adu_t.adu11
              NEXT FIELD adu11
           END IF

        BEFORE DELETE                            #是否取消單身
            IF g_adu_t.adu01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

{ckp#1}         DELETE FROM adu_file WHERE adu01 = g_adu_t.adu01
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_adu_t.adu01,SQLCA.sqlcode,0)
                    LET l_ac_t = l_ac
                    EXIT INPUT
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
              LET g_adu[l_ac].* = g_adu_t.*
              CLOSE s010_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_adu[l_ac].adu01,-263,0)
              LET g_adu[l_ac].* = g_adu_t.*
           ELSE
     UPDATE adu_file
SET adu01=g_adu[l_ac].adu01,adu02=g_adu[l_ac].adu02,
    adu021=g_adu[l_ac].adu021,
    adu03=g_adu[l_ac].adu03,adu04=g_adu[l_ac].adu04,
    adu05=g_adu[l_ac].adu05,adu06=g_adu[l_ac].adu06,
    adu07=g_adu[l_ac].adu07,adu08=g_adu[l_ac].adu08,
    adu09=g_adu[l_ac].adu09,adu10=g_adu[l_ac].adu10,
    adu11=g_adu[l_ac].adu11,aduacti=g_adu[l_ac].aduacti,
    adumodu=g_user,adudate=g_today
    WHERE CURRENT OF s010_bcl

              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adu[l_ac].adu01,SQLCA.sqlcode,0)
                  LET g_adu[l_ac].* = g_adu_t.*
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
              LET g_adu[l_ac].* = g_adu_t.*
             END IF
              CLOSE s010_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE s010_bcl            # 新增
           COMMIT WORK


       ON ACTION CONTROLP                       # 沿用所有欄位
           CASE
                WHEN INFIELD(adu01) #order nubmer
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adb1"
                    LET g_qryparam.arg1 =g_azp01
                    LET g_qryparam.default1=g_adu[l_ac].adu01
                    CALL cl_create_qry() RETURNING g_adu[l_ac].adu01
                    NEXT FIELD adu01
                WHEN INFIELD(adu02) #order nubmer
        #            LET g_t1=g_adu[l_ac].adu02[1,3]
                    LET g_t1= s_get_doc_no(g_adu[l_ac].adu02)    #No.FUN-550026
                   #CALL q_smy(FALSE,FALSE,g_t1,'apm','2') RETURNING g_t1  #TQC-670008
                    CALL q_smy(FALSE,FALSE,g_t1,'APM','2') RETURNING g_t1  #TQC-670008
        #            LET g_adu[l_ac].adu02[1,3]=g_t1
                    LET g_adu[l_ac].adu02=g_t1          #No.FUN-550026
                    NEXT FIELD adu02
                WHEN INFIELD(adu021) #order nubmer
        #            LET g_t1=g_adu[l_ac].adu021[1,3]
                    LET g_t1= s_get_doc_no(g_adu[l_ac].adu021)    #No.FUN-550026
                   #CALL q_smy(FALSE,FALSE,g_t1,'apm','3') RETURNING g_t1  #TQC-670008
                    CALL q_smy(FALSE,FALSE,g_t1,'APM','3') RETURNING g_t1  #TQC-670008
        #            LET g_adu[l_ac].adu021[1,3]=g_t1
                    LET g_adu[l_ac].adu021=g_t1          #No.FUN-550026
                    NEXT FIELD adu021
                WHEN INFIELD(adu03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pma"
                    LET g_qryparam.default1 = g_adu[l_ac].adu03
                    CALL cl_create_qry() RETURNING g_adu[l_ac].adu03
                    CALL s010_adu03('a')
                    NEXT FIELD adu03
               WHEN INFIELD(adu04) #價格條件
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oah"
                    LET g_qryparam.default1 = g_adu[l_ac].adu04
                    CALL cl_create_qry() RETURNING g_adu[l_ac].adu04
                    NEXT FIELD adu04
               WHEN INFIELD(adu05) #查詢地址資料檔 (0:表送貨地址)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pme"
                    LET g_qryparam.default1 = g_adu[l_ac].adu05
                    CALL cl_create_qry() RETURNING g_adu[l_ac].adu05
                   NEXT FIELD adu05
                WHEN INFIELD(adu06) #采購員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adu[l_ac].adu06
                    CALL cl_create_qry() RETURNING g_adu[l_ac].adu06
                    CALL s010_adu06('a')
                    NEXT FIELD adu06
                WHEN INFIELD(adu07) #請購DEPT
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_adu[l_ac].adu07
                    CALL cl_create_qry() RETURNING g_adu[l_ac].adu07
                    CALL s010_adu07('a')
                    NEXT FIELD adu07
                WHEN INFIELD(adu08) #查詢稅別資料檔(gec_file)i
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gec"
                    LET g_qryparam.default1 = g_adu[l_ac].adu08
                    LET g_qryparam.arg1 = '1'
                    CALL cl_create_qry() RETURNING g_adu[l_ac].adu08
                    NEXT FIELD adu08
                WHEN INFIELD(adu10) #查詢幣別資料檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azi"
                     LET g_qryparam.default1 = g_adu[l_ac].adu10
                     CALL cl_create_qry() RETURNING g_adu[l_ac].adu10
#                     CALL FGL_DIALOG_SETBUFFER( g_adu[l_ac].adu10 )
                     NEXT FIELD adu10
                #NO.FUN-4B0070  --begin
                WHEN INFIELD(adu11) #
                     CALL s_rate(g_adu[l_ac].adu10,g_adu[l_ac].adu11) RETURNING g_adu[l_ac].adu11
                     NEXT FIELD adu11
                #NO.FUN-4B0070  --end    
                OTHERWISE
                    EXIT CASE
            END CASE

        ON ACTION CONTROLN
            CALL s010_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(adu01) AND l_ac > 1 THEN
                LET g_adu[l_ac].* = g_adu[l_ac-1].*
                NEXT FIELD adu01
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
    CLOSE s010_bcl
    COMMIT WORK
END FUNCTION

FUNCTION s010_adu03(p_cmd)  #付款方式
    DEFINE p_cmd        LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
           l_pma02      LIKE pma_file.pma02,
           l_pmaacti    LIKE pma_file.pmaacti

    LET g_errno = ' '
    SELECT pma02,pmaacti INTO l_pma02,l_pmaacti FROM pma_file
     WHERE pma01 = g_adu[l_ac].adu03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                                   LET l_pmaacti = NULL
                                   LET l_pma02=NULL
         WHEN l_pmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION s010_adu04(p_cmd)  #價格條件
    DEFINE p_cmd        LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)
    DEFINE l_oah02      LIKE oah_file.oah02

    LET g_errno = ' '
    SELECT oah02 INTO l_oah02 FROM oah_file
     WHERE oah01 = g_adu[l_ac].adu04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4101'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION s010_adu05(p_cmd)  #送貨地址
 DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_pme02   LIKE pme_file.pme02,
        l_pmeacti LIKE pme_file.pmeacti

    LET g_errno = ' '
    SELECT pme02,pmeacti INTO l_pme02,l_pmeacti FROM pme_file
     WHERE pme01 = g_adu[l_ac].adu05
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3345'
                                   LET l_pmeacti = NULL
         WHEN l_pmeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION s010_adu06(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gen02     LIKE gen_file.gen02,
        l_genacti   LIKE gen_file.genacti

    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti FROM gen_file
     WHERE gen01 = g_adu[l_ac].adu06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                   LET g_adu[l_ac].adu07 = NULL
         WHEN l_genacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_adu[l_ac].gen02 = l_gen02
    END IF
END FUNCTION

FUNCTION s010_adu07(p_cmd)    #部門
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gem02     LIKE gem_file.gem02,
        l_gemacti   LIKE gem_file.gemacti

    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
     WHERE gem01 = g_adu[l_ac].adu07
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET g_adu[l_ac].adu07 = NULL
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd='a' THEN
       LET g_adu[l_ac].gem02 = l_gem02
    END IF
END FUNCTION

FUNCTION s010_adu08()  #稅別
  DEFINE  l_gec04   LIKE gec_file.gec04,
          l_gecacti LIKE gec_file.gecacti

    LET g_errno = " "
    SELECT gec04,gecacti INTO l_gec04,l_gecacti FROM gec_file
     WHERE gec01 = g_adu[l_ac].adu08 AND gec011 = '1'
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                   LET l_gec04 = 0
         WHEN l_gecacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_adu[l_ac].adu08 <> g_adu_t.adu08 OR cl_null(g_adu_t.adu08) THEN
       LET g_adu[l_ac].adu09 = l_gec04
    END IF
END FUNCTION

FUNCTION s010_adu10()  #幣別
  DEFINE l_aziacti LIKE azi_file.aziacti

    LET g_errno = " "
    SELECT aziacti INTO l_aziacti FROM azi_file
     WHERE azi01 = g_adu[l_ac].adu10
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                   LET l_aziacti = 0
         WHEN l_aziacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION

FUNCTION s010_b_askkey()
    CLEAR FORM
    CALL g_adu.clear()
 CONSTRUCT g_wc2 ON adu01,adu02,adu021,adu03,adu04,adu05,adu06,
                       adu07,adu08,adu09,adu10,adu11,aduacti
            FROM s_adu[1].adu01,s_adu[1].adu02,s_adu[1].adu021,
                 s_adu[1].adu03,s_adu[1].adu04,s_adu[1].adu05,
                 s_adu[1].adu06,s_adu[1].adu07,s_adu[1].adu08,
                 s_adu[1].adu09,s_adu[1].adu10,s_adu[1].adu11,
                 s_adu[1].aduacti
       ON ACTION CONTROLP                       # 沿用所有欄位
           CASE
                WHEN INFIELD(adu01) #order nubmer
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adb1"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1=g_adu[l_ac].adu01
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adu[1].adu01
                    NEXT FIELD adu01
                WHEN INFIELD(adu02) #order nubmer
            #        LET g_t1=g_adu[l_ac].adu02[1,3]
                    LET g_t1= s_get_doc_no(g_adu[l_ac].adu02)     #No.FUN-550026
                   #CALL q_smy(FALSE,TRUE,g_t1,'apm','2') RETURNING g_t1  #TQC-670008
                    CALL q_smy(FALSE,TRUE,g_t1,'APM','2') RETURNING g_t1  #TQC-670008
            #        LET g_adu[l_ac].adu02[1,3]=g_t1
                    LET g_adu[l_ac].adu02=g_t1                    #No.FUN-550026
                    NEXT FIELD adu02
                WHEN INFIELD(adu021) #order nubmer
            #        LET g_t1=g_adu[l_ac].adu021[1,3]
                    LET g_t1= s_get_doc_no(g_adu[l_ac].adu021)    #No.FUN-550026
                   #CALL q_smy(FALSE,TRUE,g_t1,'apm','3') RETURNING g_t1  #TQC-670008
                    CALL q_smy(FALSE,TRUE,g_t1,'APM','3') RETURNING g_t1  #TQC-670008
            #        LET g_adu[l_ac].adu021[1,3]=g_t1
                    LET g_adu[l_ac].adu021=g_t1                   #No.FUN-550026
                    NEXT FIELD adu021
                WHEN INFIELD(adu03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pma"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_adu[l_ac].adu03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adu[1].adu03
                    CALL s010_adu03('a')
                    NEXT FIELD adu03
               WHEN INFIELD(adu04) #價格條件
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oah"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_adu[l_ac].adu04
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adu[1].adu04
                    NEXT FIELD adu04
               WHEN INFIELD(adu05) #查詢地址資料檔 (0:表送貨地址)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_pme"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_adu[l_ac].adu05
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adu[1].adu05
                   NEXT FIELD adu05
                WHEN INFIELD(adu06) #采購員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_adu[l_ac].adu06
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adu[1].adu06
                    CALL s010_adu06('a')
                    NEXT FIELD adu06
                WHEN INFIELD(adu07) #請購DEPT
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.default1 = g_adu[l_ac].adu07
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adu[1].adu07
                    CALL s010_adu07('a')
                    NEXT FIELD adu07
                WHEN INFIELD(adu08) #查詢稅別資料檔(gec_file)i
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gec"
                    LET g_qryparam.default1 = g_adu[l_ac].adu08
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adu[1].adu08
                    NEXT FIELD adu08
                WHEN INFIELD(adu10) #查詢幣別資料檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azi"
                     LET g_qryparam.state = "c"
                     LET g_qryparam.default1 = g_adu[l_ac].adu10
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_adu[1].adu10
                     NEXT FIELD adu10
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
    CALL s010_b_fill(g_wc2)
END FUNCTION

FUNCTION s010_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT adu01,adu02,adu021,adu03,adu04,adu05,adu06,gen02,adu07,",
        "       gem02,adu08,adu09,adu10,adu11,aduacti",
        " FROM adu_file,OUTER gen_file,OUTER gem_file",
        " WHERE adu06=gen_file.gen01 AND adu07=gem_file.gem01 AND ",p_wc2 CLIPPED,   #單身
        " ORDER BY adu01"
    PREPARE s010_pb FROM g_sql
    DECLARE adu_curs CURSOR FOR s010_pb

    CALL g_adu.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" ATTRIBUTE(REVERSE)
    FOREACH adu_curs INTO g_adu[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_adu.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
        DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
        LET g_cnt = 0
END FUNCTION

FUNCTION s010_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

    IF p_ud <> "G" OR g_action_choice = "detail" THEN

      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adu TO s_adu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

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

FUNCTION s010_out()
    DEFINE
        l_adu           RECORD LIKE adu_file.*,
        l_i             LIKE type_file.num5,     #No.FUN-680108 SMALLINT
        l_name          LIKE type_file.chr20,    #No.FUN-680108 VARCHAR(20)       # External(Disk) file name
        l_za05          LIKE za_file.za05        # MOD-4B0067

    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axds010') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM adu_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE s010_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE s010_co                         # SCROLL CURSOR
         CURSOR FOR s010_p1

    START REPORT s010_rep TO l_name

    FOREACH s010_co INTO l_adu.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT s010_rep(l_adu.*)
    END FOREACH

    FINISH REPORT s010_rep

    CLOSE s010_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT s010_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(1)
        sr RECORD LIKE adu_file.*,
        l_gem02   LIKE gem_file.gem02,
        l_gen02   LIKE gen_file.gen02,
        l_chr           LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.adu01

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
                  g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'

        ON EVERY ROW
            SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.adu06
            SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.adu07
            SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01 = sr.adu10   #No.MOD-580212
            PRINT COLUMN g_c[31],sr.adu01,
                  COLUMN g_c[32],sr.adu02,
                  COLUMN g_c[33],sr.adu021,
                  COLUMN g_c[34],sr.adu03,
                  COLUMN g_c[35],sr.adu04,
                  COLUMN g_c[36],sr.adu05,
                  COLUMN g_c[37],sr.adu06,
                  COLUMN g_c[38],l_gen02,
                  COLUMN g_c[39],sr.adu07,
                  COLUMN g_c[40],l_gem02,
                  COLUMN g_c[41],sr.adu08,
#                  COLUMN g_c[42],sr.adu09 USING "--.&&",
                  COLUMN g_c[42],cl_numfor(sr.adu09,42,2),   #TQC-6A0095 
                  COLUMN g_c[43],sr.adu10,
                  COLUMN g_c[44],sr.adu11 USING "-----.&&&&",
                  COLUMN g_c[44],cl_numfor(sr.adu11,44,t_azi07),  #No.MOD-580212
                  COLUMN g_c[45],sr.aduacti
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
