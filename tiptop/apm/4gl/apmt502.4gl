# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: apmt502.4gl
# Descriptions...: 採購單特殊說明維護作業
# Input parameter: 
# Date & Author..: 90/09/20 By Wu 
#  程式修改說明..: 1.Copy 時若項次未輸入,仍會複製的問題.
#                    解決:在複製時增加 AFTER INPUT 的必要欄位判斷
#                  2.<^P>截取'常用片語'後,不能重查及上下筆的問題
#                    解決: 增加 Function t402_pshow() ....90/12/23 By Lin 修改
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0095 05/01/07 By Mandy 報表轉XML
# Modify.........: NO.FUN-550060 05/05/30 By jackie 單據編號加大
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-6A0162 06/11/16 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 08/02/26 By lutingting 報表轉為使用p_query
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/15 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_pmo01         LIKE pmo_file.pmo01,   #採購單號(假單頭)
    g_pmo01_t       LIKE pmo_file.pmo01,   #採購單號 (舊值)
    g_pmo02         LIKE pmo_file.pmo02,   #資料性質
    g_pmo02_t       LIKE pmo_file.pmo02,   #資料性質
    g_pmo03         LIKE pmo_file.pmo03,   #項次
    g_pmo03_t       LIKE pmo_file.pmo03,   #項次
    g_pmo04_t       LIKE pmo_file.pmo04,
    g_pmo           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pmo04       LIKE pmo_file.pmo04,   #列印位置
        pmo05       LIKE pmo_file.pmo05,   #行序
        pmo06       LIKE pmo_file.pmo06    #說明
                    END RECORD,
    g_pmo_t         RECORD                 #程式變數 (舊值)
        pmo04       LIKE pmo_file.pmo04,   #列印位置
        pmo05       LIKE pmo_file.pmo05,   #行序
        pmo06       LIKE pmo_file.pmo06    #說明
                    END RECORD,
     g_wc,g_sql,g_wc2    string,  #No.FUN-580092 HCN
    g_argv1         LIKE type_file.chr1,         #資料性質 	#No.FUN-680136 VARCHAR(1)
    g_argv2         LIKE oea_file.oea01,         #No.FUN-550057 #No.FUN-680136 VARCHAR(16)
    g_argv3         LIKE type_file.num5,         #項次  	#No.FUN-680136 SMALLINT
    g_show          LIKE type_file.chr1,      	 #No.FUN-680136 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,         #單身筆數      #No.FUN-680136 SMALLINT
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #FUN-4C0056    #No.FUN-680136 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5     #FUN-4C0056    #No.FUN-680136 SMALLINT

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1 =  ARG_VAL(1)              #資料性質
    LET g_argv2 =  ARG_VAL(2)              #採購單號
    LET g_argv3 =  ARG_VAL(3)              #項次
    LET g_pmo01 = g_argv2
    LET g_pmo02 = g_argv1
    LET g_pmo03 = g_argv3
    LET g_pmo01_t = NULL
    LET g_pmo02_t = NULL
    LET g_show = 'N'

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW t502_w WITH FORM "apm/42f/apmt502" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF g_argv2 IS NOT NULL AND g_argv2 != ' ' THEN
        CALL t502_q() 
        CALL t502_b()
    ELSE 
        LET g_pmo02 = '1'             #資料性質
        CALL t502_menu()
    END IF
 
    CLOSE FORM t502_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION t502_cs()
    CLEAR FORM                             #清除畫面
    CALL g_pmo.clear()
    IF g_argv1 IS NOT NULL AND  g_argv1 != ' '
       THEN DISPLAY g_pmo01 TO pmo01
            DISPLAY g_pmo03 TO pmo03
            LET g_wc = " pmo01='",g_pmo01,"'",
                       " AND pmo03 ='",g_pmo03,"'"  
      ELSE 
            CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmo01 TO NULL    #No.FUN-750051
   INITIALIZE g_pmo02 TO NULL    #No.FUN-750051
   INITIALIZE g_pmo03 TO NULL    #No.FUN-750051
            CONSTRUCT g_wc ON pmo01,pmo03,pmo04,pmo05,pmo06    #螢幕上取條件
            FROM pmo01,pmo03,s_pmo[1].pmo04,s_pmo[1].pmo05,s_pmo[1].pmo06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
            END CONSTRUCT
            LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
            IF INT_FLAG THEN RETURN END IF
    END IF  
    LET g_sql= "SELECT UNIQUE pmo01,pmo02,pmo03 FROM pmo_file ",
               " WHERE pmo02 = '1' AND  ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE t502_prepare FROM g_sql      #預備一下
    DECLARE t502_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t502_prepare
 
    LET g_sql="SELECT COUNT(DISTINCT pmo01)  ",
              " FROM pmo_file WHERE ", g_wc CLIPPED
    PREPARE t502_precount FROM g_sql
    DECLARE t502_count CURSOR FOR t502_precount
 
END FUNCTION
 
 
FUNCTION t502_menu()
 
   WHILE TRUE
      CALL t502_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t502_q()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL t502_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t502_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t502_out()      
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmo),'','')
            END IF
 
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_pmo01 IS NOT NULL THEN
                LET g_doc.column1 = "pmo01"
                LET g_doc.column2 = "pmo02"
                LET g_doc.column3 = "pmo03"
                LET g_doc.value1 = g_pmo01
                LET g_doc.value2 = g_pmo02
                LET g_doc.value3 = g_pmo03
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION t502_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pmo01 TO NULL             #No.FUN-6A0162
    INITIALIZE g_pmo02 TO NULL             #No.FUN-6A0162
    INITIALIZE g_pmo03 TO NULL             #No.FUN-6A0162
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_pmo.clear()
    CALL t502_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_pmo01 TO NULL
        INITIALIZE g_pmo02 TO NULL
        INITIALIZE g_pmo03 TO NULL
        FOR g_cnt = 1 TO g_pmo.getLength()           #單身 ARRAY 乾洗
            INITIALIZE g_pmo[g_cnt].* TO NULL
        END FOR
        RETURN
    END IF
    OPEN t502_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_pmo01 TO NULL
        INITIALIZE g_pmo02 TO NULL
        INITIALIZE g_pmo03 TO NULL
    ELSE
        CALL t502_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN t502_count
        FETCH t502_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t502_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,          #處理方式        #No.FUN-680136 VARCHAR(1)
    l_abso          LIKE type_file.num10          #絕對的筆數      #No.FUN-680136 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t502_bcs INTO g_pmo01,g_pmo02,g_pmo03
        WHEN 'P' FETCH PREVIOUS t502_bcs INTO g_pmo01,g_pmo02,g_pmo03
        WHEN 'F' FETCH FIRST    t502_bcs INTO g_pmo01,g_pmo02,g_pmo03
        WHEN 'L' FETCH LAST     t502_bcs INTO g_pmo01,g_pmo02,g_pmo03
        WHEN '/' 
#FUN-4C0056 modify
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t502_bcs INTO g_pmo01,g_pmo02,g_pmo03
            LET g_no_ask = FALSE
    END CASE
##
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_pmo01,SQLCA.sqlcode,0)
       INITIALIZE g_pmo01 TO NULL  #TQC-6B0105
       INITIALIZE g_pmo02 TO NULL  #TQC-6B0105
       INITIALIZE g_pmo03 TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CALL t502_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump      #FUN-4C0056 modify
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t502_show()
  
    DISPLAY g_pmo01 TO pmo01               #單頭
    DISPLAY g_pmo03 TO pmo03               #單頭
    CALL t502_b_fill(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t502_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重複用      #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否      #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態        #No.FUN-680136 VARCHAR(1)
    l_do_insert     LIKE type_file.chr1,         #LET g_qryparam.state = 'c' #FUN-980030
#   l_do_insert     LIKE type_file.chr1,         #LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
#   l_do_insert     LIKE type_file.chr1,         #CALL q_pms()後判斷是否要做INSERT  #No.FUN-680136 VARCHAR(1)
    l_do_ok         LIKE type_file.chr1,         #LET g_qryparam.state = 'c' #FUN-980030
#   l_do_ok         LIKE type_file.chr1,         #LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
#   l_do_ok         LIKE type_file.chr1,         #CALL q_pms()後是否做正確無誤 	    #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否        #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5          #可刪除否        #No.FUN-680136 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_pmo01 IS NULL OR g_pmo01 = ' '  THEN 
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
      " SELECT pmo04,pmo05,pmo06 ",
      "   FROM pmo_file ",
      "   WHERE pmo01 = ? ",
      "    AND pmo02 = ? ",
      "    AND pmo03 = ? ",
      "    AND pmo04 = ? ", 
      "    AND pmo05 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t502_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_pmo
              WITHOUT DEFAULTS
              FROM s_pmo.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_pmo_t.* = g_pmo[l_ac].*  #BACKUP
 
                OPEN t502_bcl USING g_pmo01,'1',g_pmo03,g_pmo_t.pmo04,g_pmo_t.pmo05
                IF STATUS THEN
                    CALL cl_err("OPEN t502_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t502_bcl INTO g_pmo[l_ac].* 
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_pmo_t.pmo04,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        LET g_pmo_t.*=g_pmo[l_ac].*
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_do_insert = 'Y'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pmo[l_ac].* TO NULL      #900423
            LET g_pmo_t.* = g_pmo[l_ac].*         #新輸入資料
            IF l_ac > 1 THEN                      # 沿用欄位
                LET g_pmo[l_ac].pmo04 = g_pmo[l_ac-1].pmo04
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pmo04
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF l_do_insert = 'Y' THEN
                INSERT INTO pmo_file(pmo01,pmo02,pmo03,
                                     pmo04,pmo05,pmo06,pmoplant,pmolegal) #FUN-980006 add pmoplant,pmolegal
                VALUES(g_pmo01,g_pmo02,g_pmo03,
                       g_pmo[l_ac].pmo04,g_pmo[l_ac].pmo05,
                       g_pmo[l_ac].pmo06,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_pmo[l_ac].pmo04,SQLCA.sqlcode,0)   #No.FUN-660129
                   CALL cl_err3("ins","pmo_file",g_pmo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   CANCEL INSERT
                ELSE
                    MESSAGE 'INSERT O.K'
                    COMMIT WORK
                    LET g_rec_b=g_rec_b+1
                    DISPLAY g_rec_b TO FORMONLY.cn2
                END IF
            END IF
 
 
        BEFORE FIELD pmo04
            IF g_pmo[l_ac].pmo04 IS NULL THEN
               LET g_pmo[l_ac].pmo04 = 0 
            END IF
            LET g_pmo04_t = g_pmo[l_ac].pmo04
 
        BEFORE FIELD pmo05                        # dgeeault 序號
            IF g_pmo[l_ac].pmo05 IS NULL or g_pmo[l_ac].pmo05 = 0 
               OR g_pmo[l_ac].pmo04 != g_pmo04_t THEN
                SELECT max(pmo05)+ 1 INTO g_pmo[l_ac].pmo05 FROM pmo_file
                    WHERE pmo01 = g_pmo01 AND pmo02 = g_pmo02 
                      AND pmo03 = g_pmo03 AND pmo04 = g_pmo[l_ac].pmo04
                IF g_pmo[l_ac].pmo05 IS NULL THEN
                    LET g_pmo[l_ac].pmo05 = 1
                END IF
            END IF
            
        AFTER FIELD pmo04               #列印位置
            IF NOT cl_null(g_pmo[l_ac].pmo04) THEN
                IF g_pmo[l_ac].pmo04 NOT MATCHES'[01]' THEN
                    NEXT FIELD pmo04
                END IF
            END IF
 
        AFTER FIELD pmo05                        #check 序號是否重複
            IF g_pmo[l_ac].pmo05 IS NOT NULL AND
               (g_pmo[l_ac].pmo05 != g_pmo_t.pmo05 OR
                g_pmo_t.pmo05 IS NULL) THEN
                SELECT count(*)
                    INTO l_n
                    FROM pmo_file
                    WHERE pmo01 = g_pmo01 AND pmo02 = g_pmo02
                       AND pmo03 = g_pmo03 AND pmo04 = g_pmo[l_ac].pmo04
                       AND pmo05 = g_pmo[l_ac].pmo05
                IF l_n > 0 THEN
                    CALL cl_err(g_pmo[l_ac].pmo04,-239,0)
                    LET g_pmo[l_ac].pmo05 = g_pmo_t.pmo05
                    NEXT FIELD pmo05
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_pmo_t.pmo04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                    CALL cl_err("", -263, 1) 
                    CANCEL DELETE 
                END IF 
                DELETE FROM pmo_file
                    WHERE pmo01 = g_pmo01 AND pmo02 = g_pmo02
                     AND  pmo03 = g_pmo03 AND pmo04 = g_pmo_t.pmo04
                     AND  pmo05 = g_pmo_t.pmo05
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_pmo_t.pmo04,SQLCA.sqlcode,0)   #No.FUN-660129
                    CALL cl_err3("del","pmo_file",g_pmo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pmo[l_ac].* = g_pmo_t.*
               CLOSE t502_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_pmo[l_ac].pmo04,-263,1)
                LET g_pmo[l_ac].* = g_pmo_t.*
            ELSE
                UPDATE pmo_file SET
                              pmo04 = g_pmo[l_ac].pmo04,
                              pmo05 = g_pmo[l_ac].pmo05,
                              pmo06 = g_pmo[l_ac].pmo06
                 WHERE pmo01 = g_pmo01 
                   AND pmo02 = '1' 
                   AND pmo03 = g_pmo03 
                   AND pmo04 = g_pmo_t.pmo04 
                   AND pmo05 = g_pmo_t.pmo05
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_pmo[l_ac].pmo04,SQLCA.sqlcode,0)   #No.FUN-660129
                    CALL cl_err3("upd","pmo_file",g_pmo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    LET g_pmo[l_ac].* = g_pmo_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac  #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN 
                  LET g_pmo[l_ac].* = g_pmo_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_pmo.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF 
               CLOSE t502_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30034
      #     LET g_pmo_t.* = g_pmo[l_ac].*
            CLOSE t502_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL t502_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pmo04) AND l_ac > 1 THEN
                LET g_pmo[l_ac].* = g_pmo[l_ac-1].*
                DISPLAY g_pmo[l_ac].* TO s_pmo[l_ac].*
                NEXT FIELD pmo04
            END IF
 
        ON ACTION CONTROLP
            IF INFIELD(pmo06) THEN
              #CALL q_pms(FALSE,TRUE,g_pmo01,g_pmo[l_ac].pmo06,g_pmo02,g_pmo03,g_pmo[l_ac].pmo04)
              #CALL t502_pshow()      #重新顯示此筆資料
              #CALL t502_b()
               CALL q_pms(0,0,g_pmo01,g_pmo02,g_pmo03,g_pmo[l_ac].pmo04) RETURNING l_do_ok
display "l_do_ok=???",l_do_ok
               IF l_do_ok = 'Y' THEN
                   CALL t502_show()
                   LET l_do_insert = 'N'
               END IF
            END IF
 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
        
        END INPUT
 
    CLOSE t502_bcl
    COMMIT WORK
END FUNCTION
   
FUNCTION t502_pshow()      #此Function的目地為重新顯示<^P>之後的資料
    MESSAGE ""
    CLEAR FORM
    CALL g_pmo.clear()
    LET g_wc2 = " pmo01='",g_pmo01,"' AND pmo02='",g_pmo02,"' ",
                " AND pmo03 ='",g_pmo03,"'"  
    LET g_sql= "SELECT UNIQUE pmo01,pmo02,pmo03 FROM pmo_file ",
               " WHERE  ", g_wc2 CLIPPED,
               " ORDER BY 1"
    PREPARE t502_pp FROM g_sql      #預備一下
    DECLARE t502_bcs_p                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t502_pp
 
    OPEN t502_bcs_p                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660129
        INITIALIZE g_pmo01 TO NULL
        INITIALIZE g_pmo02 TO NULL
        INITIALIZE g_pmo03 TO NULL
    ELSE
        FETCH FIRST t502_bcs_p INTO g_pmo01,g_pmo02,g_pmo03  #讀取第一筆資料
        OPEN t502_count
        FETCH t502_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
    DISPLAY g_pmo01 TO pmo01               #單頭
    DISPLAY g_pmo03 TO pmo03               #單頭
    CALL t502_b_fill("1=1")                 #單身
# genero  script marked     LET g_pmo_pageno = 0
END FUNCTION
 
FUNCTION t502_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    CONSTRUCT l_wc ON pmo04,pmo05,pmo06   #螢幕上取條件
       FROM s_pmo[1].pmo04,s_pmo[1].pmo05,s_pmo[1].pmo06
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL t502_b_fill(l_wc)
END FUNCTION
 
FUNCTION t502_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
    LET g_sql =
       "SELECT pmo04,pmo05,pmo06,''",
       " FROM pmo_file ",
       " WHERE pmo01 = '",g_pmo01,"' AND ",
       " pmo02 ='",g_pmo02,"' AND ",
       " pmo03 = '",g_pmo03,"' AND ",p_wc CLIPPED ,
       " ORDER BY 1,2"
    PREPARE t502_prepare2 FROM g_sql      #預備一下
    DECLARE pmo_cs CURSOR FOR t502_prepare2
    FOR g_cnt = 1 TO g_pmo.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_pmo[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH pmo_cs INTO g_pmo[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pmo.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t502_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmo TO s_pmo.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL t502_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t502_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL t502_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t502_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL t502_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
   ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t502_copy()
DEFINE
    l_buf           LIKE ima_file.ima01,        #No.FUN-680136 VARCHAR(40)
    l_newno1,l_oldno1 LIKE pmo_file.pmo01,
    l_newno2,l_oldno2 LIKE pmo_file.pmo03
 
    IF s_shut(0) THEN RETURN END IF
    IF g_pmo01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    DISPLAY " " TO pmo01 
    DISPLAY " " TO pmo03 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT l_newno1,l_newno2 FROM pmo01,pmo03
#No.FUN-550060 --start--
     BEFORE INPUT
       CALL cl_set_docno_format("pmo01")
#No.FUN-550060 ---end---
        AFTER FIELD pmo01
            IF NOT cl_null(l_newno1) THEN
                SELECT pmk01 FROM pmk_file WHERE pmk01 = l_newno1
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err(l_newno1,'mfg3052',0)   #No.FUN-660129
                     CALL cl_err3("sel","pmk_file",l_newno1,"","mfg3052","","",1)  #No.FUN-660129
                               NEXT FIELD pmo01
                END IF
            END IF
        AFTER FIELD pmo03
            SELECT count(*) INTO g_cnt FROM pmo_file
                WHERE pmo01=l_newno1 AND pmo02 = '1' AND pmo03 = l_newno2
            IF g_cnt > 0 THEN
                LET g_msg = l_newno1 CLIPPED,'+',l_newno2 CLIPPED
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD pmo01
            END IF
        AFTER INPUT
            IF INT_FLAG THEN
                EXIT INPUT  
            END IF
            IF l_newno2 IS NULL THEN
                DISPLAY l_newno2 TO pmo03 
                NEXT FIELD pmo03
            END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY  g_pmo01 TO pmo01 
        DISPLAY  g_pmo03 TO pmo03 
        RETURN
    END IF
    LET l_buf = l_newno1 CLIPPED,'+',l_newno2 CLIPPED
    DROP TABLE x
    SELECT * FROM pmo_file
        WHERE pmo01 = g_pmo01 AND pmo02 = g_pmo02 AND pmo03 = g_pmo03  
        INTO TEMP x
    UPDATE x
        SET pmo01=l_newno1,    #資料鍵值
            pmo03=l_newno2
    INSERT INTO pmo_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_buf,SQLCA.sqlcode,0)   #No.FUN-660129
        CALL cl_err3("ins","pmo_file",l_buf,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
    ELSE
        MESSAGE 'ROW(',l_buf,') O.K' 
        LET l_oldno1= g_pmo01
        LET l_oldno2= g_pmo02
        LET g_pmo01 = l_newno1
        LET g_pmo03 = l_newno2
 
        CALL t502_b()
        #FUN-C80046---begin
        #LET g_pmo01 = l_oldno1
        #LET g_pmo02 = '1'
        #LET g_pmo03 = l_oldno2
        #CALL t502_show()
        #FUN-C80046---end
    END IF
END FUNCTION
 
FUNCTION t502_out()
DEFINE
   l_i             LIKE type_file.num5,          #No.FUN-680136 SMALLINT
   sr              RECORD
       pmo01       LIKE pmo_file.pmo01,   #編號
       pmo02       LIKE pmo_file.pmo02,   #資料性質
       pmo03       LIKE pmo_file.pmo03,   #項次
       pmo04       LIKE pmo_file.pmo04,   #列印位置
       pmo05       LIKE pmo_file.pmo05,   #行序
       pmo06       LIKE pmo_file.pmo06    #說明
                   END RECORD,
   l_name          LIKE type_file.chr20,               #External(Disk) file name   #No.FUN-680136 VARCHAR(20)
   l_za05          LIKE type_file.chr1000              #No.FUN-680136 VARCHAR(40)
 
DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-820002
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
 
#No.FUN-820002--start--
   IF cl_null(g_wc) AND NOT cl_null(g_pmo01) AND NOT cl_null(g_pmo03) THEN                                                          
      LET g_wc = " pmo01 = '",g_pmo01,"' AND pmo03 = '",g_pmo03,"'"                                                                 
   END IF
 
   LET l_cmd = 'p_query "apmt502" "',g_wc CLIPPED,'"'                                                                               
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN
 
#   CALL cl_wait()
#   CALL cl_outnam('apmt502') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT pmo01,pmo02,pmo03,pmo04,pmo05,pmo06",
#             " FROM pmo_file",  # 組合出 SQL 指令
#             " WHERE pmo02 = '1' AND ",g_wc CLIPPED 
#   PREPARE t502_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE t502_co                         # CURSOR
#       CURSOR FOR t502_p1
 
#   START REPORT t502_rep TO l_name
 
#   FOREACH t502_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)   #No.FUN-660129
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT t502_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT t502_rep
 
#   CLOSE t502_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT t502_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#   sr              RECORD
#       pmo01       LIKE pmo_file.pmo01,   #編號
#       pmo02       LIKE pmo_file.pmo02,   #資料性質
#       pmo03       LIKE pmo_file.pmo03,   #項次
#       pmo04       LIKE pmo_file.pmo04,   #列印位置
#       pmo05       LIKE pmo_file.pmo05,   #行序
#       pmo06       LIKE pmo_file.pmo06    #說明
#                   END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.pmo02,sr.pmo01,sr.pmo03,sr.pmo04,sr.pmo05
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno" 
#           PRINT g_head CLIPPED,pageno_total     
#           PRINT 
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34]
#           PRINT g_dash1 
#           LET l_trailer_sw = 'y'
#       BEFORE GROUP OF sr.pmo04  #列印位置
#           PRINT COLUMN g_c[31],sr.pmo01,
#                 COLUMN g_c[32],sr.pmo03 using '###&',
#                 COLUMN g_c[33],sr.pmo04 ;
#       ON EVERY ROW
#           PRINT COLUMN g_c[34],sr.pmo06 CLIPPED
#       AFTER GROUP OF sr.pmo04  #說明性質
#           PRINT g_dash
#       ON LAST ROW
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[34], g_x[7] CLIPPED
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[34], g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end
