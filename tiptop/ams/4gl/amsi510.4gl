# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: amsi510.4gl
# Descriptions...: MPS 模擬PLM/PLP調整作業
# Date & Author..: 01/01/09
# Modify.........: No.FUN-4B0014 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.TQC-630104 06/03/14 By Smapmin DISPLAY ARRAY無控制單身筆數
# Modify.........: No.No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0150 06/10/27 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750041 07/05/15 By arman   單身PLP/PLM欄位為負沒管控
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790001 07/09/02 By Mandy PK問題
# Modify.........: No.FUN-980005 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_mps01         LIKE mps_file.mps01,   #料號(假單頭)
    g_mps01_t       LIKE mps_file.mps01,   #料號(舊值)
    g_mps_v         LIKE mps_file.mps_v,   #版本
    g_mps_v_t       LIKE mps_file.mps_v,   #版本
    g_mps09         LIKE mps_file.mps09,   #PLM/PLP
    g_mps09_t       LIKE mps_file.mps09,   #PLM/PLP
    g_mps           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        mps00       LIKE mps_file.mps00,   #序號
        mps03       LIKE mps_file.mps03,   #時距日
        mps09       LIKE mps_file.mps09    #PLM/PLP
                    END RECORD,
    g_mps_t         RECORD                 #程式變數 (舊值)
        mps00       LIKE mps_file.mps00,   #序號
        mps03       LIKE mps_file.mps03,   #時距日
        mps09       LIKE mps_file.mps09    #PLM/PLP
                    END RECORD,
     g_wc,g_sql,g_wc2    string,  #No.FUN-580092 HCN
    g_argv3         LIKE type_file.num5,   #項次     #NO.FUN-680101 SMALLINT
    g_show          LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數 #NO.FUN-680101 SMALLINT
    g_flag          LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
    g_ss            LIKE type_file.chr1,   #NO.FUN-680101 VARCHAR(1)
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  #NO.FUN-680101 SMALLINT 
 
#主程式開始
DEFINE   g_cnt           LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #NO.FUN-680101 SMALLINT
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0081
    p_row,p_col   LIKE type_file.num5      #NO.FUN-680101 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
    LET p_row = 2 LET p_col = 26
    OPEN WINDOW i510_w AT p_row,p_col
        WITH FORM "ams/42f/amsi510"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    CALL i510_menu()
 
    CLOSE WINDOW i510_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN
 
#QBE 查詢資料
FUNCTION i510_cs()
    CLEAR FORM                             #清除畫面
    CALL g_mps.clear()
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_mps_v TO NULL    #No.FUN-750051
   INITIALIZE g_mps01 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON mps_v,mps01
        FROM mps_v,mps01
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
    LET g_sql= "SELECT UNIQUE mps_v,mps01 FROM mps_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY 1"
    PREPARE i510_prepare FROM g_sql      #預備一下
    DECLARE i510_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i510_prepare
 
    DROP TABLE x
    SELECT mps_v,mps01 FROM mps_file GROUP BY mps_v,mps01 INTO TEMP x
    LET g_sql= "SELECT COUNT(*) FROM x WHERE ",g_wc CLIPPED
 
   # EXECUTE i510_precount_x
    display g_sql
   # LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i510_precount FROM g_sql
    DECLARE i510_count CURSOR FOR i510_precount
 
END FUNCTION
 
FUNCTION i510_menu()
 
   WHILE TRUE
      CALL i510_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i510_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i510_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0014
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mps),'','')
            END IF
##
        #No.FUN-6A0150-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_mps_v IS NOT NULL THEN
                LET g_doc.column1 = "mps_v"
                LET g_doc.column2 = "mps01"
                LET g_doc.value1 = g_mps_v
                LET g_doc.value2 = g_mps01
                CALL cl_doc()
             END IF 
          END IF
        #No.FUN-6A0150-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i510_mps01(p_cmd,l_mps01)  #職稱代號
   DEFINE l_ima02    LIKE ima_file.ima02,
          l_imaacti  LIKE ima_file.imaacti,
          l_mps01    LIKE mps_file.mps01,
          p_cmd      LIKE type_file.chr1       #NO.FUN-680101 VARCHAR(01) 
 
  LET g_errno = " "
  SELECT ima02,imaacti INTO l_ima02,l_imaacti
     FROM ima_file WHERE ima01 = l_mps01
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                                 LET l_imaacti = NULL
       WHEN l_imaacti='N' LET g_errno = '9028'
  #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------       
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_ima02 TO FORMONLY.ima02
  END IF
END FUNCTION
 
#Query 查詢
FUNCTION i510_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_mps01 TO NULL        #No.FUN-6A0150
    INITIALIZE g_mps_v TO NULL        #No.FUN-6A0150
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_mps.clear()
    DISPLAY '    ' TO FORMONLY.cnt
    CALL i510_cs()                    #取得查詢條件
    IF INT_FLAG THEN                  #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_mps01 TO NULL
        INITIALIZE g_mps_v TO NULL
        RETURN
    END IF
    OPEN i510_bcs                     #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_mps01 TO NULL
        INITIALIZE g_mps_v TO NULL
    ELSE
        OPEN i510_count
        FETCH i510_count INTO g_row_count
        DISPLAY "g_row_count=",g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i510_fetch('F')                        #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i510_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式      #NO.FUN-680101 VARCHAR(01)
    l_abso          LIKE type_file.num10   #絕對的筆數    #NO.FUN-680101 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i510_bcs INTO g_mps_v,g_mps01
        WHEN 'P' FETCH PREVIOUS i510_bcs INTO g_mps_v,g_mps01
        WHEN 'F' FETCH FIRST    i510_bcs INTO g_mps_v,g_mps01
        WHEN 'L' FETCH LAST     i510_bcs INTO g_mps_v,g_mps01
        WHEN '/'
           IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump i510_bcs INTO g_mps_v,g_mps01
           LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_mps01,SQLCA.sqlcode,0)
        INITIALIZE g_mps_v TO NULL  #TQC-6B0105
        INITIALIZE g_mps01 TO NULL  #TQC-6B0105
    ELSE
        CALL i510_show()
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       CALL i510_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i510_show()
    DISPLAY g_mps_v,g_mps01           #單頭
         TO mps_v,mps01
    CALL i510_mps01('d',g_mps01)
    CALL i510_bf(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i510_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT   #NO.FUN-680101 SMALLINT
    l_max           LIKE mps_file.mps00,   #序號
    l_n             LIKE type_file.num5,   #檢查重複用          #NO.FUN-680101 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否          #NO.FUN-680101 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態            #NO.FUN-680101 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,   #可新增否            #NO.FUN-680101 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否            #NO.FUN-680101 SMALLINT
 
    LET g_action_choice = ""
    IF g_mps01 IS NULL OR g_mps01 = ' ' THEN
        RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF
        CALL cl_opmsg('a')
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_mps WITHOUT DEFAULTS  FROM s_mps.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY "l_ac=",l_ac
            IF cl_null(g_mps[l_ac].mps00) THEN
               LET p_cmd = 'a'
            ELSE
               LET p_cmd = 'u'
               LET g_mps_t.* = g_mps[l_ac].*  #BACKUP
            END IF
            DISPLAY 'g_mps[l_ac].mps00=',g_mps[l_ac].mps00
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            CALL cl_show_fld_cont()     #FUN-550037(smin)
{
         AFTER INSERT
            DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF g_mps[l_ac].mps03 IS NULL THEN  #重要欄位空白,無效
               # INITIALIZE g_mps[l_ac].* TO NULL
               NEXT FIELD mps09
            END IF
            SELECT MAX(mps00)+1 INTO l_max FROM mps_file
            WHERE mps_v=g_mps_v
            IF l_max IS NULL THEN LET l_max=1 END IF
            #TQC-790001---add---str-
            IF cl_null(g_mps[l_ac].mps03) THEN 
                LET g_mps[l_ac].mps03 = g_today
            END IF
            #TQC-790001---add---end-
            INSERT INTO mps_file(mps01,mps_v,mps09,mps00,mps03,
                                 mps039,mps041,mps043,mps044,
                                 mps051,mps052,mps053,mps061,
                                 mps062,mps063,mps064,mps065,
                                 mps06_fz,mps071,mps072,mps08,
                                 mps10,mps11,mps12,mpsplant,mpslegal) #FUN-980005 add mpsplant,mpslegal
            VALUES(g_mps01,g_mps_v,g_mps[l_ac].mps09,l_max,
                    g_mps[l_ac].mps03,
                    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'N',NULL,0,g_plant,g_legal  #FUN-980005 add g_plant,g_legal
                   )
            LET g_mps[l_ac].mps00=l_max
            IF SQLCA.sqlcode THEN
      #         CALL cl_err(g_mps[l_ac].mps09,SQLCA.sqlcode,0) #No.FUN-660108
                CALL cl_err3("ins","mps_file",g_mps01,g_mps_v,SQLCA.sqlcode,"","",1)   #No.FUN-660108
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
}
        BEFORE DELETE                            #是否取消單身
            LET p_cmd='d'
            DISPLAY "BEFORE DELETE"
            DISPLAY "p_cmd=",p_cmd
            IF g_mps_t.mps09 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM mps_file
                    WHERE mps01 = g_mps01 AND mps_v = g_mps_v
                      AND mps09 = g_mps_t.mps09
                IF SQLCA.sqlcode THEN
            #       CALL cl_err(g_mps_t.mps09,SQLCA.sqlcode,0) #No.FUN-660108
                    CALL cl_err3("del","mps_file",g_mps01,g_mps_v,SQLCA.sqlcode,"","",1)   #No.FUN-660108                   
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            DISPLAY "ON ROW CHANGE"
            DISPLAY "p_cmd=",p_cmd
            IF p_cmd='u' THEN
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  LET g_mps[l_ac].* = g_mps_t.*
                  ROLLBACK WORK
                  EXIT INPUT
               END IF
               IF l_lock_sw = 'Y' THEN
                  CALL cl_err(g_mps[l_ac].mps03,-263,1)
                  LET g_mps[l_ac].* = g_mps_t.*
               ELSE
                 # IF g_mps[l_ac].mps03 IS NULL THEN  #重要欄位空白,無效
                 #    #INITIALIZE g_mps[l_ac].* TO NULL
                 # END IF
                  #NO.TQC-750041    --begin
                   IF  g_mps[l_ac].mps09 <0 THEN
                       CALL cl_err('','amm-110',0)
                       NEXT FIELD mps09
                   END IF
                  #NO.TQC-750041    --end
                  UPDATE mps_file SET mps09 =g_mps[l_ac].mps09
                  WHERE mps_v=g_mps_v
                    AND mps01=g_mps01
                    AND mps00=g_mps[l_ac].mps00
                   IF SQLCA.SQLCODE THEN
         #              CALL cl_err('mps',SQLCA.SQLCODE,1) #No.FUN-660108
                        CALL cl_err3("upd","mps_file",g_mps_v,g_mps01,SQLCA.sqlcode,"","mps",1)   #No.FUN-660108
                   END IF
 
                  IF SQLCA.sqlcode THEN
          #           CALL cl_err(g_mps[l_ac].mps09,SQLCA.sqlcode,0) #No.FUN-660108
                      CALL cl_err3("upd","mps_file",g_mps_v,g_mps01,SQLCA.sqlcode,"","",1)   #No.FUN-660108
                      LET g_mps[l_ac].* = g_mps_t.*
                  ELSE
                      MESSAGE 'UPDATE O.K'
                  END IF
               END IF
            ELSE
               IF INT_FLAG THEN
                  CALL cl_err('',9001,0)
                  LET INT_FLAG = 0
                  #CANCEL INSERT
               END IF
               IF g_mps[l_ac].mps03 IS NULL THEN  #重要欄位空白,無效
                  # INITIALIZE g_mps[l_ac].* TO NULL
                  NEXT FIELD mps09
               END IF
               SELECT MAX(mps00)+1 INTO l_max FROM mps_file
               WHERE mps_v=g_mps_v
               IF l_max IS NULL THEN LET l_max=1 END IF
               #TQC-790001---add---str-
               IF cl_null(g_mps[l_ac].mps03) THEN 
                   LET g_mps[l_ac].mps03 = g_today
               END IF
               #TQC-790001---add---end-
               INSERT INTO mps_file(mps01,mps_v,mps09,mps00,mps03,
                                    mps039,mps041,mps043,mps044,
                                    mps051,mps052,mps053,mps061,
                                    mps062,mps063,mps064,mps065,
                                    mps06_fz,mps071,mps072,mps08,
                                    mps10,mps11,mps12,mpsplant,mpslegal) #FUN-980005 add mpsplant,mpslegal
               VALUES(g_mps01,g_mps_v,g_mps[l_ac].mps09,l_max,
                       g_mps[l_ac].mps03,
                       0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'N',NULL,0,g_plant,g_legal #FUN-980005 add g_plant,g_legal
                      )
               LET g_mps[l_ac].mps00=l_max
               IF SQLCA.sqlcode THEN
         #         CALL cl_err(g_mps[l_ac].mps09,SQLCA.sqlcode,0) #No.FUN-660108
                   CALL cl_err3("ins","mps_file",g_mps01,g_mps_v,SQLCA.sqlcode,"","",1)   #No.FUN-660108
                   #CANCEL INSERT
               ELSE
                   MESSAGE 'INSERT O.K'
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b TO FORMONLY.cn2
               END IF
           END IF
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_mps[l_ac].* = g_mps_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_mps.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
        END INPUT
 
END FUNCTION
 
FUNCTION i510_bf(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000    #NO.FUN-680101 VARCHAR(200)
 
    LET g_sql =
        "SELECT mps00,mpk_d,mps09",
        " FROM mpk_file LEFT OUTER JOIN mps_file ON mpk_file.mpk_v=mps_file.mps_v AND mpk_file.mpk_d=mps_file.mps03",
        " WHERE mpk_v ='",g_mps_v,"'",
        "   AND mps_file.mps01 ='",g_mps01,"'",
        " ORDER BY 2,1"
 
    PREPARE i510_prepare2 FROM g_sql      #預備一下
    DECLARE mps_cs CURSOR FOR i510_prepare2
    CALL g_mps.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH mps_cs INTO g_mps[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        #-----TQC-630104---------
        IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
        #-----END TQC-630104-----
    END FOREACH
    CALL g_mps.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i510_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mps TO s_mps.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i510_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i510_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i510_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i510_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i510_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
 
#FUN-4B0014
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
      ON ACTION related_document                #No.FUN-6A0150  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610036 <001> #
