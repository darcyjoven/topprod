# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmt402.4gl
# Descriptions...: 特殊說明維護作業
# Input parameter: 
# Date & Author..: 90/09/11 By Wu 
#  程式修改說明..: 1.Copy 時若項次未輸入,仍會複製的問題.
#                    解決:在複製時增加 AFTER INPUT 的必要欄位判斷
#                  2.<^P>截取'常用片語'後,不能重查及上下筆的問題
#                    解決: 增加 Function t402_pshow() ....90/12/23 By Lin 修改
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.MOD-4B0101 04/12/15 By Mandy 在 apmt420 及 apmt540 輸入特別說明時，於說明資料維護時，可輸入 Ctrl+P 將常用特殊說明帶入。
# Modify.........: No.FUN-4C0095 05/01/07 By Mandy 報表轉XML
# Modify.........: NO.FUN-550060 05/05/30 By jackie 單據編號加大
# Modify.........: No.TQC-5A0106 05/11/08 By Nicola 查詢筆數語法修改
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-570078 06/08/15 By rainy 單身輸入說明開窗模式應為'輸入'非'查詢'
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-6A0162 06/11/24 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-710116 07/03/28 By Ray 外部程序call此程序如果無資料打不開窗體
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-820002 08/02/25 By lutingting 報表轉為使用p_query
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0178 09/12/29 By lilingyu 按確定按鈕,先確定畫面,而不是直接退出程序
# Modify.........: No.TQC-AB0038 10/12/06 By vealxu sybase err
# Modify.........: No:CHI-C10013 12/01/06 By Elise 增加控卡pmo05不可小於等於0
# Modify.........: No:MOD-C70275 12/08/15 By Vampire 新增時如有修改，AFTER INSERT 需更新寫入資料庫
# Modify.........: No:FUN-C80046 12/08/22 By bart 複製後停在新資料畫面
# Modify.........: No:TQC-C70195 12/08/30 By zhuhao 增加單身顯示內容
# Modify.........: No:MOD-D10005 13/01/03 By Vampire (1) 在按下複製時,增加輸入資料性質(0.PR 1.PO 2.Blank PO)
#                                                    (2) 依輸入的資料性質調整原mfg3052的Table檢查
# Modify.........: No:FUN-D30034 13/04/17 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_pmo01         LIKE pmo_file.pmo01,   #單號(假單頭)
    g_pmo01_t       LIKE pmo_file.pmo01,   #單號 (舊值)
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
    #MOD-C70275 add start -----
    g_pmo_o         RECORD                 #程式變數 (舊值)
        pmo04       LIKE pmo_file.pmo04,   #列印位置
        pmo05       LIKE pmo_file.pmo05,   #行序
        pmo06       LIKE pmo_file.pmo06    #說明
                    END RECORD,
    #MOD-C70275 add end   -----
     g_wc,g_sql,g_wc2    string,  #No.FUN-580092 HCN
    g_argv1         LIKE type_file.chr1,        #資料性質 	#No.FUN-680136 VARCHAR(1)
#    g_argv2         LIKE apm_file.apm08,       #單號 	        #No.FUN-680136 VARCHAR(10)
    g_argv2         LIKE oea_file.oea01,        #No.FUN-550060 	#No.FUN-680136 VARCHAR(16)
    g_argv3         LIKE type_file.num5,        #項次      	#No.FUN-680136 SMALLINT
    g_show          LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,        #單身筆數       #No.FUN-680136 SMALLINT
    g_flag          LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 =  ARG_VAL(1)              #資料性質
   LET g_argv2 =  ARG_VAL(2)              #單號
   LET g_argv3 =  ARG_VAL(3)              #項次
   LET g_pmo01 = g_argv2                  #單號
   LET g_pmo02 = g_argv1                  #資料性質
   LET g_pmo03 = g_argv3                  #項次
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
 
   IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
      CALL cl_err(g_sma.sma31,'mfg0032',1)
      EXIT PROGRAM  
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   OPEN WINDOW t402_w WITH FORM "apm/42f/apmt402"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv2) THEN
      let g_flag='N'
      CALL t402_q() 
      CALL t402_b()
      WHILE g_flag='Y'
         LET g_flag='N'
         CALL t402b_fill(g_wc)                 #單身
         CALL t402_b()
      END WHILE
#TQC-9C0178 --begin--
      IF g_flag = 'N' THEN
         CALL t402_menu()
      END IF
#TQC-9C0178 --end--
   ELSE
      LET g_pmo02 = '1'             #資料性質
      CALL t402_menu()
   END IF

   CLOSE FORM t402_w                     #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION t402_cs()
   CLEAR FORM                            #清除畫面
   #CALL g_pmo.clear()
    IF NOT cl_null(g_argv2) THEN
      #No.FUN-6A0162------str----    #外部參數傳入後，原本是用g_pmo01 g_pmo03b判斷
      #DISPLAY g_pmo01 TO pmo01      #改由g_argv2、g_argv3做判斷
      #DISPLAY g_pmo03 TO pmo03      #否則在_q()會誤清除傳入的參數
      #LET g_wc = " pmo01='",g_pmo01,"'",
      #          " AND pmo03 ='",g_pmo03,"'"  
      DISPLAY g_argv2 TO pmo01
      DISPLAY g_argv3 TO pmo03
      LET g_wc = " pmo01='",g_argv2,"'",
               # " AND pmo03 ='",g_argv3,"'"     #TQC-AB0038
                 " AND pmo03 = ",g_argv3         #TQC-AB0038  
      #No.FUN-6A0162------end----
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
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF  
 
    LET g_sql= "SELECT UNIQUE pmo01,pmo02,pmo03 FROM pmo_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE t402_prepare FROM g_sql      #預備一下
    DECLARE t402_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t402_prepare
 
    #-----No.TQC-5A0106-----
    DROP TABLE x
    LET g_sql="SELECT pmo01,pmo03 ",
              " FROM pmo_file WHERE ", g_wc CLIPPED,
              " GROUP BY pmo01,pmo03",
              "  INTO TEMP x"
    PREPARE t402_px FROM g_sql
    EXECUTE t402_px
    LET g_sql="SELECT COUNT(*) FROM x"
    #-----No.TQC-5A0106 END-----
    PREPARE t402_precount FROM g_sql
    DECLARE t402_count CURSOR FOR t402_precount
 
END FUNCTION
 
FUNCTION t402_menu()
 
   WHILE TRUE
      CALL t402_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t402_q()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL t402_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t402_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t402_out()
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
 
FUNCTION t402_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pmo.clear()
 
   CALL t402_cs()                         #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN t402_bcs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pmo01 TO NULL
      INITIALIZE g_pmo02 TO NULL
      INITIALIZE g_pmo03 TO NULL
   ELSE
      OPEN t402_count
      FETCH t402_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL t402_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t402_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t402_bcs INTO g_pmo01,g_pmo02,g_pmo03
        WHEN 'P' FETCH PREVIOUS t402_bcs INTO g_pmo01,g_pmo02,g_pmo03
        WHEN 'F' FETCH FIRST    t402_bcs INTO g_pmo01,g_pmo02,g_pmo03
        WHEN 'L' FETCH LAST     t402_bcs INTO g_pmo01,g_pmo02,g_pmo03
        WHEN '/' 
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t402_bcs INTO g_pmo01,g_pmo02,g_pmo03
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_pmo01,SQLCA.sqlcode,0)
#No.TQC-710116 --begin mark
#      INITIALIZE g_pmo01 TO NULL               #No.FUN-6A0162
#      INITIALIZE g_pmo02 TO NULL               #No.FUN-6A0162
#      INITIALIZE g_pmo03 TO NULL               #No.FUN-6A0162
#No.TQC-710116 --end
    ELSE
       CALL t402_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
    
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
FUNCTION t402_show()
  
   DISPLAY g_pmo01 TO pmo01               #單頭
   DISPLAY g_pmo03 TO pmo03               #單頭
 
   CALL t402b_fill(g_wc)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t402_b()
DEFINE
    l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,         #檢查重複用         #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,         #單身鎖住否         #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,         #處理狀態           #No.FUN-680136 VARCHAR(1)
    l_do_insert     LIKE type_file.chr1,         #CALL s_qrypms()後判斷是否要做INSERT #MOD-4B0101 #No.FUN-680136 VARCHAR(1)
    l_do_ok         LIKE type_file.chr1,         #CALL s_qrypms()後是否做正確無誤     #MOD-4B0101 #No.FUN-680136 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,         #可新增否           #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5          #可刪除否           #No.FUN-680136 SMALLINT
 
    LET g_action_choice = ""
    IF cl_null(g_pmo01) THEN
       RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pmo04,pmo05,pmo06 FROM pmo_file",
                       "  WHERE pmo01=? AND pmo02=? AND pmo03=?",
                       "   AND pmo04=? AND pmo05=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t402_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pmo WITHOUT DEFAULTS FROM s_pmo.*
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
              OPEN t402_bcl USING g_pmo01,g_pmo02,g_pmo03,g_pmo_t.pmo04,g_pmo_t.pmo05
              IF STATUS THEN
                 CALL cl_err("OPEN t402_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t402_bcl INTO g_pmo[l_ac].* 
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
           IF l_ac > 1 THEN
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
               INSERT INTO pmo_file(pmo01,pmo02,pmo03,pmo04,pmo05,pmo06,pmoplant,pmolegal) #FUN-980006 add pmoplant,pmolegal
                    VALUES(g_pmo01,g_pmo02,g_pmo03,g_pmo[l_ac].pmo04,
                           g_pmo[l_ac].pmo05,g_pmo[l_ac].pmo06,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_pmo[l_ac].pmo04,SQLCA.sqlcode,0)   #No.FUN-660129
                  CALL cl_err3("ins","pmo_file",g_pmo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                  CANCEL INSERT
               ELSE
                  MESSAGE 'INSERT O.K'
                  COMMIT WORK
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2  
               END IF
           #MOD-C70275 add start -----
           ELSE
              UPDATE pmo_file SET pmo04=g_pmo[l_ac].pmo04,
                                  pmo05=g_pmo[l_ac].pmo05,
                                  pmo06=g_pmo[l_ac].pmo06
                            WHERE pmo01 = g_pmo01
                              AND pmo02 = g_pmo02
                              AND pmo03 = g_pmo03
                              AND pmo04 = g_pmo_o.pmo04
                              AND pmo05 = g_pmo_o.pmo05
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pmo_file",g_pmo01,"",SQLCA.sqlcode,"","",1)
                 LET g_pmo[l_ac].* = g_pmo_o.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           #MOD-C70275 add start -----
           END IF         
 
        BEFORE FIELD pmo04
           IF cl_null(g_pmo[l_ac].pmo04) THEN
              LET g_pmo[l_ac].pmo04 = 1 
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
           IF NOT cl_null(g_pmo[l_ac].pmo05) THEN 
              #CHI-C10013---add---str---
              IF g_pmo[l_ac].pmo05 <= 0 THEN
                   CALL cl_err('','mfg9243',0)
                   NEXT FIELD pmo05
               END IF
              #CHI-C10013---add---str---
              IF g_pmo[l_ac].pmo05 != g_pmo_t.pmo05 OR g_pmo_t.pmo05 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM pmo_file
                  WHERE pmo01 = g_pmo01 AND pmo02 = g_pmo02
                    AND pmo03 = g_pmo03 AND pmo04 = g_pmo[l_ac].pmo04
                    AND pmo05 = g_pmo[l_ac].pmo05
                 IF l_n > 0 THEN
                    CALL cl_err(g_pmo[l_ac].pmo05,-239,0)
                    LET g_pmo[l_ac].pmo05 = g_pmo_t.pmo05
                    NEXT FIELD pmo05
                 END IF
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
#                CALL cl_err(g_pmo_t.pmo04,SQLCA.sqlcode,0)   #No.FUN-660129
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
              CLOSE t402_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pmo[l_ac].pmo04,-263,1)
              LET g_pmo[l_ac].* = g_pmo_t.*
           ELSE
              UPDATE pmo_file SET pmo04=g_pmo[l_ac].pmo04,
                                  pmo05=g_pmo[l_ac].pmo05,
                                  pmo06=g_pmo[l_ac].pmo06
               WHERE pmo01 = g_pmo01
                 AND pmo02 = g_pmo02
                 AND pmo03 = g_pmo03 
                 AND pmo04 = g_pmo_t.pmo04
                 AND pmo05 = g_pmo_t.pmo05
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_pmo[l_ac].pmo04,SQLCA.sqlcode,0)   #No.FUN-660129
                 CALL cl_err3("upd","pmo_file",g_pmo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_pmo[l_ac].* = g_pmo_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac           #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN 
                 LET g_pmo[l_ac].* = g_pmo_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_pmo.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF 
              CLOSE t402_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CALL t402b_fill(" 1=1")      #TQC-C70195 add
           LET l_ac_t = l_ac           #FUN-D30034 add
           CLOSE t402_bcl
           COMMIT WORK
 
#       ON ACTION CONTROLN
#          CALL t402_b_askkey()
#          EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(pmo04) AND l_ac > 1 THEN
              LET g_pmo[l_ac].* = g_pmo[l_ac-1].*
              NEXT FIELD pmo04
           END IF
 
        ON ACTION controlp
           IF INFIELD(pmo06) THEN
               CALL s_qrypms(FALSE,TRUE,g_pmo01,g_pmo02,g_pmo03,g_pmo[l_ac].pmo04) RETURNING l_do_ok #MOD-4B0101
              IF l_do_ok = 'Y' THEN
                  CALL t402_show()
                  LET l_do_insert = 'N'
                  LET g_pmo_o.* = g_pmo[l_ac].*  #MOD-C70275 add
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
 
    CLOSE t402_bcl
    COMMIT WORK
 
END FUNCTION
   
FUNCTION t402_pshow()      #此Function的目的為重新顯示<^P>之後的資料
   MESSAGE ""
   CLEAR FORM
   CALL g_pmo.clear()
   LET g_wc2 = " pmo01='",g_pmo01,"' AND pmo02='",g_pmo02,"' ",
               " AND pmo03 ='",g_pmo03,"'"  
   LET g_sql= "SELECT UNIQUE pmo01,pmo02,pmo03 FROM pmo_file ",
              " WHERE  ", g_wc2 CLIPPED,
              " ORDER BY 1"
   PREPARE t402_pp FROM g_sql      #預備一下
   DECLARE t402_bcs_p                  #宣告成可捲動的
       SCROLL CURSOR FOR t402_pp
 
   OPEN t402_bcs_p                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pmo01 TO NULL
      INITIALIZE g_pmo02 TO NULL
      INITIALIZE g_pmo03 TO NULL
   ELSE
      FETCH FIRST t402_bcs_p INTO g_pmo01,g_pmo02,g_pmo03  #讀取第一筆資料
      OPEN t402_count                #先清除了螢幕,所以必須重新顯示原先
      FETCH t402_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
   DISPLAY g_pmo01 TO pmo01               #單頭
   DISPLAY g_pmo03 TO pmo03               #單頭
 
   CALL t402b_fill("1=1")                 #單身
 
END FUNCTION
 
FUNCTION t402_b_askkey()
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
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   CALL t402b_fill(l_wc)
 
END FUNCTION
 
FUNCTION t402b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
   LET g_sql = "SELECT pmo04,pmo05,pmo06",
               " FROM pmo_file ",
               " WHERE pmo01 = '",g_pmo01,"' AND ",
               " pmo02 ='",g_pmo02,"' AND ",
             # " pmo03 = '",g_pmo03,"' AND ",p_wc CLIPPED ,    #TQC-AB0038
               " pmo03 =  ",g_pmo03,"  AND ",p_wc CLIPPED ,    #TQC-AB0038  
               " ORDER BY 1,2"
   PREPARE t402_prepare2 FROM g_sql      #預備一下
   DECLARE pmo_cs CURSOR FOR t402_prepare2
      
   CALL g_pmo.clear() 
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
 
FUNCTION t402_bp(p_ud)
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
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL t402_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t402_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL t402_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t402_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL t402_fetch('L')
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
 
 
FUNCTION t402_copy()
DEFINE
    l_buf           LIKE ima_file.ima01,        #No.FUN-680136 VARCHAR(40)
    l_newno1,l_oldno1  LIKE pmo_file.pmo01,
    l_newno2,l_oldno2  LIKE pmo_file.pmo03
DEFINE l_chr        LIKE type_file.chr1         #MOD-D10005 add
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_pmo01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    DISPLAY " " TO pmo01 
    DISPLAY " " TO pmo03 
 
    #MOD-D10005 add start ------
    SELECT ze03 INTO g_msg FROM ze_file WHERE ze01 = 'apm1088' AND ze02 = g_lang
    PROMPT g_msg CLIPPED,': ' FOR l_chr
    #MOD-D10005 add end   ------

    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT l_newno1,l_newno2 FROM pmo01,pmo03
 
#No.FUN-550060 --start--
    BEFORE INPUT
        CALL cl_set_docno_format("pmo01")
#No.FUN-550060 ---end---
 
       AFTER FIELD pmo01
          IF NOT cl_null(l_newno1) THEN
            #MOD-D10005 add start ------
             CASE l_chr
                WHEN "0"
            #MOD-D10005 add end   ------
                   SELECT pmk01 FROM pmk_file WHERE pmk01 = l_newno1
                   IF SQLCA.sqlcode THEN
#                     CALL cl_err(l_newno1,'mfg3052',0)   #No.FUN-660129
                      CALL cl_err3("sel","pmk_file",l_newno1,"","mfg3052","","",1)  #No.FUN-660129
                      NEXT FIELD pmo01
                   END IF
            #MOD-D10005 add start ------
                WHEN "1"
                   SELECT pmm01 FROM pmm_file WHERE pmm01 = l_newno1
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("sel","pmm_file",l_newno1,"","aap-006","","",1)
                      NEXT FIELD pmo01
                   END IF
                WHEN "2"
                   SELECT pom01 FROM pom_file WHERE pom01 = l_newno1
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("sel","pom_file",l_newno1,"","apm1089","","",1)
                      NEXT FIELD pmo01
                   END IF
             END CASE
            #MOD-D10005 add end   ------
          END IF
 
       AFTER FIELD pmo03
          IF NOT cl_null(l_newno2) THEN
             SELECT count(*) INTO g_cnt FROM pmo_file
              WHERE pmo01=l_newno1 AND pmo02=g_pmo02 AND pmo03=l_newno2
             IF g_cnt > 0 THEN
                LET g_msg = l_newno1 CLIPPED,'+',l_newno2 CLIPPED
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD pmo01
             END IF
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
 
    DROP TABLE x #MOD-D10005 add

    SELECT * FROM pmo_file
     WHERE pmo01 = g_pmo01 AND pmo02 = g_pmo02 AND pmo03 = g_pmo03  
      INTO TEMP x
 
    UPDATE x SET pmo01=l_newno1,    #資料鍵值
                 pmo03=l_newno2
 
    INSERT INTO pmo_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_buf,SQLCA.sqlcode,0)   #No.FUN-660129
       CALL cl_err3("ins","pmo_file",l_buf,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
    ELSE
       MESSAGE 'ROW(',l_buf,') O.K' 
       LET l_oldno1= g_pmo01
       LET l_oldno2= g_pmo03
       LET g_pmo01 = l_newno1
       LET g_pmo03 = l_newno2
 
       CALL t402_b()
       #---begin
       #LET g_pmo01 = l_oldno1
       #LET g_pmo02 = g_pmo02
       #LET g_pmo03 = l_oldno2
       #CALL t402_show()
       #FUN-C80046---end
    END IF
 
END FUNCTION
 
FUNCTION t402_out()
DEFINE
   l_i             LIKE type_file.num5,           #No.FUN-680136 SMALLINT
   sr              RECORD
       pmo01       LIKE pmo_file.pmo01,           #編號
       pmo02       LIKE pmo_file.pmo02,           #資料性質
       pmo03       LIKE pmo_file.pmo03,           #項次
       pmo04       LIKE pmo_file.pmo04,           #列印位置
       pmo05       LIKE pmo_file.pmo05,           #行序
       pmo06       LIKE pmo_file.pmo06            #說明
                   END RECORD,
   l_name          LIKE type_file.chr20,          #External(Disk) file name   #No.FUN-680136 VARCHAR(20)
   l_za05          LIKE type_file.chr1000         #No.FUN-680136 VARCHAR(40)
DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-820002
 
   IF g_wc IS NULL THEN
      CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
 
#No.FUN-820002 --start-- 
   IF cl_null(g_wc) AND NOT cl_null(g_pmo01) AND NOT cl_null(g_pmo03)THEN                                                           
      LET g_wc = " pmo01 = '",g_pmo01,"' AND pmo03 = '",g_pmo03,"'"                                                                 
   END IF
 
    #報表轉為使用 p_query                                                                                                           
    LET l_cmd = 'p_query "apmt402" "',g_wc CLIPPED,'" "',g_pmo02,'"'                                                                
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN
 
#   CALL cl_wait()
#   CALL cl_outnam('apmt402') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT pmo01,pmo02,pmo03,pmo04,pmo05,pmo06",
#             " FROM pmo_file",  # 組合出 SQL 指令
#             " WHERE pmo02 = '",g_pmo02,"' AND ",g_wc CLIPPED 
#   PREPARE t402_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE t402_curo                         # CURSOR
#       CURSOR FOR t402_p1
 
#   START REPORT t402_rep TO l_name
 
#   FOREACH t402_curo INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)   #No.FUN-660129
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT t402_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT t402_rep
 
#   CLOSE t402_curo
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT t402_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
#    sr              RECORD
#        pmo01       LIKE pmo_file.pmo01,   #編號
#        pmo02       LIKE pmo_file.pmo02,   #資料性質
#        pmo03       LIKE pmo_file.pmo03,   #項次
#        pmo04       LIKE pmo_file.pmo04,   #列印位置
#        pmo05       LIKE pmo_file.pmo05,   #行序
#        pmo06       LIKE pmo_file.pmo06    #說明
#                    END RECORD
 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    ORDER BY sr.pmo02,sr.pmo01,sr.pmo03,sr.pmo04,sr.pmo05
 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno" 
#            PRINT g_head CLIPPED,pageno_total     
#            PRINT 
#            PRINT g_dash
#            PRINT g_x[31],g_x[32],g_x[33],g_x[34]
#            PRINT g_dash1 
#            LET l_trailer_sw = 'y'
#        BEFORE GROUP OF sr.pmo04  #列印位置
#            PRINT COLUMN g_c[31],sr.pmo01,
#                  COLUMN g_c[32],sr.pmo03 USING '###&',
#                  COLUMN g_c[33],sr.pmo04 ;
#        ON EVERY ROW
#            PRINT COLUMN g_c[34],sr.pmo06 CLIPPED
#        AFTER GROUP OF sr.pmo04  #說明性質
#            PRINT g_dash
#        ON LAST ROW
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[34], g_x[7] CLIPPED 
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[34], g_x[6] CLIPPED 
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#FUN-820002-end
