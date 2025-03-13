# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: csfq012.4gl
# Descriptions...: 收貨替代群組維護作業
# Date & Author..: 08/01/11 By jan

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE g_mss_v         LIKE mss_file.mss_v, 
       g_ima06         LIKE ima_file.ima06,
       g_ima08         LIKE ima_file.ima08,
       g_mss_v_t       LIKE mss_file.mss_v,   
       g_ima06_t       LIKE ima_file.ima06,
       g_ima08_t       LIKE ima_file.ima08,
       g_tc_imb_3            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                          tc_imb03_3           LIKE tc_imb_file.tc_imb03,
                          ima02_3              LIKE ima_file.ima02,          #品名
                          ima021_3             LIKE ima_file.ima021,         #规格
                          sgm06                LIKE sgm_file.sgm06,          #工作站
                          sum_3                LIKE img_file.img10
                          d1          LIKE mss_file.mss09,
                          d2          LIKE mss_file.mss09,
                          d3          LIKE mss_file.mss09,
                          d4          LIKE mss_file.mss09,
                          d5          LIKE mss_file.mss09,
                          d6          LIKE mss_file.mss09,
                          d7          LIKE mss_file.mss09,
                          d8          LIKE mss_file.mss09,
                          d9          LIKE mss_file.mss09,
                          d10          LIKE mss_file.mss09,
                          d11         LIKE mss_file.mss09,
                          d12          LIKE mss_file.mss09,
                          d13          LIKE mss_file.mss09,
                          d14          LIKE mss_file.mss09,
                          d15          LIKE mss_file.mss09,
                          d16          LIKE mss_file.mss09,
                          d17          LIKE mss_file.mss09,
                          d18          LIKE mss_file.mss09,
                          d19          LIKE mss_file.mss09,
                          d20          LIKE mss_file.mss09,
                          d21          LIKE mss_file.mss09,
                          d22          LIKE mss_file.mss09, 
                          d23          LIKE mss_file.mss09,
                          d24          LIKE mss_file.mss09,
                          d25          LIKE mss_file.mss09,
                          d26          LIKE mss_file.mss09,
                          d27          LIKE mss_file.mss09,
                          d28          LIKE mss_file.mss09,
                          d29          LIKE mss_file.mss09,
                          d30          LIKE mss_file.mss09
                       END RECORD,
       b_mss           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                          mss_v_1     LIKE mss_file.mss_v,
                          mss01       LIKE mss_file.mss01,
                          ima02       LIKE ima_file.ima02,
                          ima021      LIKE ima_file.ima021,
                          pmh02       LIKE pmh_file.pmh02,
                          pmh11       LIKE pmh_file.pmh11,
                          fpbl        LIKE sfa_file.sfa05,
                          d1          LIKE mss_file.mss09,
                          d2          LIKE mss_file.mss09,
                          d3          LIKE mss_file.mss09,
                          d4          LIKE mss_file.mss09,
                          d5          LIKE mss_file.mss09,
                          d6          LIKE mss_file.mss09,
                          d7          LIKE mss_file.mss09,
                          d8          LIKE mss_file.mss09,
                          d9          LIKE mss_file.mss09,
                          d10          LIKE mss_file.mss09,
                          d11         LIKE mss_file.mss09,
                          d12          LIKE mss_file.mss09,
                          d13          LIKE mss_file.mss09,
                          d14          LIKE mss_file.mss09,
                          d15          LIKE mss_file.mss09,
                          d16          LIKE mss_file.mss09,
                          d17          LIKE mss_file.mss09,
                          d18          LIKE mss_file.mss09,
                          d19          LIKE mss_file.mss09,
                          d20          LIKE mss_file.mss09,
                          d21          LIKE mss_file.mss09,
                          d22          LIKE mss_file.mss09,
                          d23          LIKE mss_file.mss09,
                          d24          LIKE mss_file.mss09,
                          d25          LIKE mss_file.mss09,
                          d26          LIKE mss_file.mss09,
                          d27          LIKE mss_file.mss09,
                          d28          LIKE mss_file.mss09,
                          d29          LIKE mss_file.mss09,
                          d30          LIKE mss_file.mss09
                       END RECORD,      
       g_mss_t         RECORD                 #程式變數 (舊值)
                          mss_v_1     LIKE mss_file.mss_v,
                          mss01       LIKE mss_file.mss01,
                          ima02       LIKE ima_file.ima02,
                          ima021      LIKE ima_file.ima021,
                          pmh02       LIKE pmh_file.pmh02,
                          pmh11       LIKE pmh_file.pmh11,
                          fpbl        LIKE sfa_file.sfa05,
                          d1          LIKE mss_file.mss09,
                          d2          LIKE mss_file.mss09,
                          d3          LIKE mss_file.mss09,
                          d4          LIKE mss_file.mss09,
                          d5          LIKE mss_file.mss09,
                          d6          LIKE mss_file.mss09,
                          d7          LIKE mss_file.mss09,
                          d8          LIKE mss_file.mss09,
                          d9          LIKE mss_file.mss09,
                          d10          LIKE mss_file.mss09,
                          d11         LIKE mss_file.mss09,
                          d12          LIKE mss_file.mss09,
                          d13          LIKE mss_file.mss09,
                          d14          LIKE mss_file.mss09,
                          d15          LIKE mss_file.mss09,
                          d16          LIKE mss_file.mss09,
                          d17          LIKE mss_file.mss09,
                          d18          LIKE mss_file.mss09,
                          d19          LIKE mss_file.mss09,
                          d20          LIKE mss_file.mss09,
                          d21          LIKE mss_file.mss09,
                          d22          LIKE mss_file.mss09,
                          d23          LIKE mss_file.mss09,
                          d24          LIKE mss_file.mss09,
                          d25          LIKE mss_file.mss09,
                          d26          LIKE mss_file.mss09,
                          d27          LIKE mss_file.mss09,
                          d28          LIKE mss_file.mss09,
                          d29          LIKE mss_file.mss09,
                          d30          LIKE mss_file.mss09                    
                       END RECORD,
 
       g_wc,g_sql,g_sql1      STRING,      
       g_rec_b         LIKE type_file.num5,                #單身筆數  
       l_sql           STRING,
       l_ac            LIKE type_file.num5
DEFINE p_row,p_col     LIKE type_file.num5    
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10   
DEFINE g_msg           LIKE ze_file.ze03      
DEFINE g_row_count     LIKE type_file.num10   
DEFINE g_curs_index    LIKE type_file.num10   
DEFINE g_jump          LIKE type_file.num10   
DEFINE g_no_ask        LIKE type_file.num5    
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CMR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
#   LET g_mss01= NULL                   #清除鍵值
#   LET g_mss01_t = NULL
#   LET g_mss02_t = NULL
 
   OPEN WINDOW i304_w WITH FORM "cmr/42f/csfq012"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL i304_menu()
   CLOSE WINDOW i304_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION i304_curs()
 
   CLEAR FORM                             #清除畫面
   CALL g_mss.clear()
   CALL b_mss.clear()
      CONSTRUCT g_wc ON mss_v,ima06,ima08
                   FROM mss_v,ima06,ima08
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(mss_v)     #料號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_mss_v"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO mss_v
                  NEXT FIELD mss_v
               WHEN INFIELD(ima06)     #供應商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_ima06"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima06
                  NEXT FIELD ima06
              WHEN INFIELD(ima06)     #供應商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_ima08"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima08
                  NEXT FIELD ima08
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
 
   LET g_sql= "SELECT UNIQUE mss_v,ima06,ima08 FROM mss_file,ima_file ",
              " WHERE mss01=ima01 AND ", g_wc CLIPPED,
              " ORDER BY mss_v"
   PREPARE i304_prepare FROM g_sql      #預備一下
   DECLARE i304_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i304_prepare
 
   LET g_sql1="SELECT UNIQUE mss_v,ima06,ima08 FROM mss_file,ima_file WHERE mss01=ima01 AND ",g_wc CLIPPED," INTO TEMP x "
   DROP TABLE x
   PREPARE i304_precount_x FROM g_sql1
   EXECUTE i304_precount_x
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i304_precount FROM g_sql
   DECLARE i304_count CURSOR FOR i304_precount
 
END FUNCTION
 
FUNCTION i304_menu()
 
   WHILE TRUE
      CALL i304_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i304_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i304_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mss),'','')
            END IF
         WHEN  "pz"
            IF cl_chk_act_auth() THEN
              CALL q001_pz()
            END IF
   {      WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
            #    IF g_mss01 IS NOT NULL THEN
            #     LET g_doc.column1 = "mss01"
            #     LET g_doc.value1 = g_mss01
                 CALL cl_doc()
                END IF 
              END IF}
      END CASE
   END WHILE
 
END FUNCTION
 
 
 
FUNCTION i304_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL i304_curs()                    #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
#      INITIALIZE g_mss01 TO NULL
      RETURN
   END IF
 
   OPEN i304_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
  #    INITIALIZE g_mss01 TO NULL
   ELSE
      OPEN i304_count
      FETCH i304_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i304_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i304_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式  
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i304_b_curs INTO g_mss_v,g_ima06,g_ima08
       WHEN 'P' FETCH PREVIOUS i304_b_curs INTO g_mss_v,g_ima06,g_ima08
       WHEN 'F' FETCH FIRST    i304_b_curs INTO g_mss_v,g_ima06,g_ima08
       WHEN 'L' FETCH LAST     i304_b_curs INTO g_mss_v,g_ima06,g_ima08
       WHEN '/'
           IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                    CONTINUE PROMPT
 
                  ON ACTION about         #MOD-4C0121
                     CALL cl_about()      #MOD-4C0121
 
                  ON ACTION help          #MOD-4C0121
                     CALL cl_show_help()  #MOD-4C0121
 
                  ON ACTION controlg      #MOD-4C0121
                     CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump i304_b_curs INTO g_mss_v,g_ima06,g_ima08
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_mss_v,SQLCA.sqlcode,0)
      INITIALIZE g_mss_v TO NULL
   ELSE
      CALL i304_show()
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
 
FUNCTION i304_show()
 
   DISPLAY g_mss_v TO mss_v               #單頭
   DISPLAY g_ima06 TO ima06
   DISPLAY g_ima08 TO ima08
   


   CALL i304_b_fill(g_wc)                 #單身
 
   CALL cl_show_fld_cont()                   
 
END FUNCTION
 
 
FUNCTION i304_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
       l_n             LIKE type_file.num5,                #檢查重複用  
       l_n1            LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
       p_cmd           LIKE type_file.chr1,                #處理狀態  
       l_cmd           LIKE type_file.chr1000,             #可新增否  
       l_mss03         LIKE mss_file.mss03,                #最小起始碼
       l_allow_insert  LIKE type_file.num5,                #可新增否  
       l_allow_delete  LIKE type_file.num5                 #可刪除否  
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_mss_v IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql ="SELECT mss_v,mss01,'','','','','','' d1,'' d2,'' d3,'' d4,'' d5,'' d6,'' d7,'' d8,'' d9,'' d10,'' d11,'' d12,",
                     "'' d13,'' d14,'' d15,'' d16,'' d17,'' d18,'' d19,'' d20,'' d21,'' d22,'' d23,'' d24,'' d25,'' d26, ",
                     " '' d27,'' d28,'' d29,'' d30 ",
                      "  FROM mss_file",
                      " WHERE mss01 = ? AND mss02 = ? AND mss03 = ? AND mss04 = ? AND mss05 = ? AND mss06 = ? AND mss07 = ? ",
                      " FOR UPDATE"  
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i304_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 #  LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_mss WITHOUT DEFAULTS FROM s_mss.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         LET g_rec_b  = ARR_COUNT()
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
     
         IF g_rec_b >= l_ac THEN
            #BEGIN WORK
            LET p_cmd='u'
            LET g_mss_t.* = g_mss[l_ac].*  #BACKUP
   {         LET l_sql = "SELECT mss01,mss02,mss03,mss04,mss05,mss06,mss07 FROM mss_file",
                        " WHERE mss01 = '",g_mss01,"' ",
                        "   AND mss02 = '",g_mss02,"' ",
                        "   AND mss03 = '",g_mss_t.mss03,"' ",
                        "   AND mss04 = '",g_mss_t.mss04,"' ",
                        "   AND mss05 = '",g_mss_t.mss05,"' ",
                        "   AND mss06 = '",g_mss_t.mss06,"' ",
                        "   AND mss07 = '",g_mss_t.mss07,"' "
            #No.CHI-950007  --Begin
            PREPARE i304_prepare_r FROM l_sql
           #DECLARE mss_cs_r CURSOR FOR i304_prepare_r
           #EXECUTE mss_cs_r INTO g_mss01,g_mss02,g_mss[l_ac].mss03,g_mss[l_ac].mss04,g_mss[l_ac].mss05,g_mss[l_ac].mss06,g_mss[l_ac].mss07
            EXECUTE i304_prepare_r INTO g_mss01,g_mss02,g_mss[l_ac].mss03,g_mss[l_ac].mss04,g_mss[l_ac].mss05,g_mss[l_ac].mss06,g_mss[l_ac].mss07
            #No.CHI-950007  --End  
            OPEN i304_bcl USING g_mss01,g_mss02,g_mss[l_ac].mss03,g_mss[l_ac].mss04,g_mss[l_ac].mss05,g_mss[l_ac].mss06,g_mss[l_ac].mss07
            IF STATUS THEN
               CALL cl_err("OPEN i304_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i304_bcl INTO g_mss[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_mss02_t,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF  }
            CALL cl_show_fld_cont()     
         END IF
 
{      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_mss[l_ac].* TO NULL      
         LET g_mss_t.* = g_mss[l_ac].*         #新輸入資料
         LET g_mss[l_ac].mss03 = 1
#        LET g_mss_t.* = g_mss[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD mss03
 
      AFTER INSERT
         
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO mss_file(mss01,mss02,mss03,mss04,mss05,mss06,mss07,mss08)
                       VALUES(g_mss01,g_mss02,g_mss[l_ac].mss03,
                              g_mss[l_ac].mss04,g_mss[l_ac].mss05,
                              g_mss[l_ac].mss06,g_mss[l_ac].mss07,
                              g_mss[l_ac].mss08)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","mss_file","","",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
            ROLLBACK WORK
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 }
 {     AFTER FIELD mss03
     }
      ON ROW CHANGE
         
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_mss[l_ac].* = g_mss_t.*
            CLOSE i304_bcl
        #    ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_mss[l_ac].mss01,-263,1)
            LET g_mss[l_ac].* = g_mss_t.*
         ELSE
     #       UPDATE mss_file SET mss03=g_mss[l_ac].mss03,
     #                           mss04=g_mss[l_ac].mss04,
     #                           mss05=g_mss[l_ac].mss05,
     #                           mss06=g_mss[l_ac].mss06,
     #                           mss07=g_mss[l_ac].mss07,
     #     mss08=g_mss[l_ac].mss08
   # WHERE mss01 = g_mss01
   #   AND mss02 = g_mss02
   #   AND mss03 = g_mss_t.mss03
   #   AND mss04 = g_mss_t.mss04
   #   AND mss05 = g_mss_t.mss05
   #   AND mss06 = g_mss_t.mss06
   #   AND mss07 = g_mss_t.mss07
  # IF SQLCA.sqlcode THEN
   #   CALL cl_err3("upd","mss_file","","",SQLCA.sqlcode,"","",1)  
   ##            LET g_mss[l_ac].* = g_mss_t.*
    #           ROLLBACK WORK
    #        ELSE
     #          MESSAGE 'UPDATE O.K'
     #          COMMIT WORK
     #       END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac      #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_mss[l_ac].* = g_mss_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_mss.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i304_bcl
            #ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30034 add
         CLOSE i304_bcl
     #    COMMIT WORK
 
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(mss02) AND l_ac > 1 THEN
            LET g_mss[l_ac].* = g_mss[l_ac-1].*
            NEXT FIELD mss02
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END INPUT
 
   CLOSE i304_bcl
#   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i304_b_askkey()
DEFINE
   #l_wc            LIKE type_file.chr1000 
    l_wc             STRING           #NO.FUN-910082
 
   CONSTRUCT l_wc ON mss03,mss04,mss05,mss06,mss07,mss08
                FROM s_mss[1].mss03,s_mss[1].mss04,s_mss[1].mss05,
                     s_mss[1].mss06,s_mss[1].mss07,s_mss[1].mss08
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
 
   CALL i304_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i304_b_fill(p_wc)              #BODY FILL UP
#DEFINE p_wc            LIKE type_file.chr1000 
 DEFINE p_wc             STRING           #NO.FUN-910082
 DEFINE l_mss03          LIKE mss_file.mss03,
        ll_mss03         LIKE mss_file.mss03,
        ll_mss09         LIKE mss_file.mss09,
        l_cnt            LIKE type_file.num5,
        i                LIKE type_file.num5,
        l_mss09          LIKE mss_file.mss09,
        l_pmn20          LIKE pmn_file.pmn20,
        ll_pmn20         LIKE pmn_file.pmn20,
        l_sum            LIKE pmn_file.pmn20,
        ii               LIKE type_file.num5,
        l_tc_sma011      LIKE tc_sma_file.tc_sma011,
        l_pmn53          LIKE pmn_file.pmn53
 DEFINE l_sql            STRING
 DEFINE  l_mss     DYNAMIC ARRAY OF RECORD
                   mss03 LIKE mss_file.mss03
                   END RECORD
  CALL q001_tmp()  #新建表用来存储料号+时局日+总数量

   LET g_sql = " SELECT mss_v,mss01,ima02,ima021,pmh02,pmh11,0 fpbl,'' d1,'' d2,'' d3,'' d4,'' d5,'' d6,'' d7,'' d8,'' d9,",
               " '' d10,'' d11,'' d12,",
               " '' d13,'' d14,'' d15,'' d16,'' d17,'' d18,'' d19,'' d20,'' d21,'' d22,'' d23,'' d24,'' d25,'' d26, ",
               " '' d27,'' d28,'' d29,'' d30,mss03,mss09 ",
               " FROM mss_file ",
               " ,ima_file ",   # ON ima01=mss01 AND ima06='",g_ima06,"' AND ima08='",g_ima08,"' ",
               " ,pmh_file ",
               " WHERE mss_v='",g_mss_v,"' AND mss01=pmh01(+) ",  #AND pmh11(+)>0 ",
               "   AND ima01=mss01 AND ima06='",g_ima06,"' AND ima08='",g_ima08,"'  ",
               " ORDER BY mss_v,mss01,mss03 "
   PREPARE i304_prepare2 FROM g_sql      #預備一下
   DECLARE mss_curs CURSOR FOR i304_prepare2
   LET g_cnt=1 
   declare sell_mss03_cur  cursor for 
   select distinct  mss03  from mss_file where mss_v=g_mss_v  order by mss03
   LET i=1 
   forEach sell_mss03_cur into l_mss[i].mss03 
      IF g_cnt=1 THEN CALL cl_set_comp_att_text("d1",l_mss[i].mss03) END IF
      IF g_cnt=2 THEN CALL cl_set_comp_att_text("d2",l_mss[i].mss03) END IF
      IF g_cnt=3 THEN CALL cl_set_comp_att_text("d3",l_mss[i].mss03) END IF
      IF g_cnt=4 THEN CALL cl_set_comp_att_text("d4",l_mss[i].mss03) END IF
      IF g_cnt=5 THEN CALL cl_set_comp_att_text("d5",l_mss[i].mss03) END IF
      IF g_cnt=6 THEN CALL cl_set_comp_att_text("d6",l_mss[i].mss03) END IF
      IF g_cnt=7 THEN CALL cl_set_comp_att_text("d7",l_mss[i].mss03) END IF
      IF g_cnt=8 THEN CALL cl_set_comp_att_text("d8",l_mss[i].mss03) END IF
      IF g_cnt=9 THEN CALL cl_set_comp_att_text("d9",l_mss[i].mss03) END IF
      IF g_cnt=10 THEN CALL cl_set_comp_att_text("d10",l_mss[i].mss03) END IF
      IF g_cnt=11 THEN CALL cl_set_comp_att_text("d11",l_mss[i].mss03) END IF
      IF g_cnt=12 THEN CALL cl_set_comp_att_text("d12",l_mss[i].mss03) END IF
      IF g_cnt=13 THEN CALL cl_set_comp_att_text("d13",l_mss[i].mss03) END IF
      IF g_cnt=14 THEN CALL cl_set_comp_att_text("d14",l_mss[i].mss03) END IF
      IF g_cnt=15 THEN CALL cl_set_comp_att_text("d15",l_mss[i].mss03) END IF
      IF g_cnt=16 THEN CALL cl_set_comp_att_text("d16",l_mss[i].mss03) END IF
      IF g_cnt=17 THEN CALL cl_set_comp_att_text("d17",l_mss[i].mss03) END IF
      IF g_cnt=18 THEN CALL cl_set_comp_att_text("d18",l_mss[i].mss03) END IF
      IF g_cnt=19 THEN CALL cl_set_comp_att_text("d19",l_mss[i].mss03) END IF
      IF g_cnt=20 THEN CALL cl_set_comp_att_text("d20",l_mss[i].mss03) END IF
      IF g_cnt=21 THEN CALL cl_set_comp_att_text("d21",l_mss[i].mss03) END IF
      IF g_cnt=22 THEN CALL cl_set_comp_att_text("d22",l_mss[i].mss03) END IF
      IF g_cnt=23 THEN CALL cl_set_comp_att_text("d23",l_mss[i].mss03) END IF
      IF g_cnt=24 THEN CALL cl_set_comp_att_text("d24",l_mss[i].mss03) END IF
      IF g_cnt=25 THEN CALL cl_set_comp_att_text("d25",l_mss[i].mss03) END IF
      IF g_cnt=26 THEN CALL cl_set_comp_att_text("d26",l_mss[i].mss03) END IF
      IF g_cnt=27 THEN CALL cl_set_comp_att_text("d27",l_mss[i].mss03) END IF
      IF g_cnt=28 THEN CALL cl_set_comp_att_text("d28",l_mss[i].mss03) END IF
      IF g_cnt=29 THEN CALL cl_set_comp_att_text("d29",l_mss[i].mss03) END IF
      IF g_cnt=30 THEN CALL cl_set_comp_att_text("d30",l_mss[i].mss03) END IF
      let g_cnt=g_cnt+1
      LET i=i+1
   end foreach 
   CALL g_mss.clear()
   LET g_cnt = 1
#   CREATE TEMP TABLE q001_ttmp
# (mss_v    LIKE mss_file.mss_v,
#  mss01    LIKE ima_file.ima01,
#  mss03    LIKE mss_file.mss03,
#  pmc01    LIKE pmc_file.pmc01,
#  mss09    LIKE mss_file.mss09)
   FOREACH mss_curs INTO b_mss[g_cnt].*,l_mss03,l_mss09   #單身 ARRAY 填充
      INSERT INTO q001_ttmp VALUES (b_mss[g_cnt].mss_v_1,b_mss[g_cnt].mss01,l_mss03,b_mss[g_cnt].pmh02,
                                    b_mss[g_cnt].pmh11,l_mss09)  #记录原始
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
       
   #   LET g_mss[g_cnt].*=b_mss[g_cnt].*
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_mss.deleteElement(g_cnt)
   SELECT tc_sma011 INTO l_tc_sma011 FROM tc_sma_file 
   LET g_rec_b = g_cnt-1
#   DISPLAY g_rec_b TO FORMONLY.cn2
   #
   LET g_cnt=1  
   DECLARE sel_mss_cur  CURSOR FOR 
   SELECT DISTINCT mss_v,mss01,pmc01,pmh11  FROM q001_ttmp  ORDER BY mss_v,mss01
   FOREACH sel_mss_cur INTO g_mss[g_cnt].mss_v_1,g_mss[g_cnt].mss01,g_mss[g_cnt].pmh02
     SELECT ima02,ima021 INTO g_mss[g_cnt].ima02,g_mss[g_cnt].ima021 FROM ima_file WHERE ima01=g_mss[g_cnt].mss01
     SELECT pmh11 INTO g_mss[g_cnt].pmh11 FROM pmh_file WHERE pmh01=g_mss[g_cnt].mss01 
     AND pmh02=g_mss[g_cnt].pmh02 
     IF cl_null(g_mss[g_cnt].pmh11) THEN LET g_mss[g_cnt].pmh11=0 END IF
     #fpbl  此日期的此供应商的采购单数量/采购单中此料件总数量 
    
     #此料号的采购总数量  (未结案的用采购数量 pmn20；已结案的用入库数)
     SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file,pmm_file WHERE pmm01=pmn01 AND pmm18='Y' AND pmn16 NOT IN ('6','7','8') 
     AND pmn04=g_mss[g_cnt].mss01 AND pmm04>l_tc_sma011 AND pmm09=g_mss[g_cnt].pmh02
     IF cl_null(l_pmn20) THEN LET l_pmn20=0 END IF
     #已经结案的使用入库数量
     SELECT SUM(pmn53) INTO l_pmn53 FROM pmn_file,pmm_file WHERE pmm01=pmn01 AND pmm18='Y' AND pmn16 IN ('6','7','8')
     AND pmn04=g_mss[g_cnt].mss01 AND pmm04>l_tc_sma011   AND pmm09=g_mss[g_cnt].pmh02
     IF cl_null(l_pmn53) THEN LET l_pmn53=0 END IF
     LET l_sum=l_pmn20+l_pmn53 
     # 此料件的总采购数量
     SELECT SUM(pmn20) INTO ll_pmn20 FROM pmm_file,pmn_file WHERE pmn01=pmm01 AND pmm18='Y'
     AND pmn04=g_mss[g_cnt].mss01 AND pmm04>l_tc_sma011  #   AND pmm09=g_mss[g_cnt].pmh02
     LET g_mss[g_cnt].fpbl=l_sum/ll_pmn20*100   
     
     DECLARE sel_mss03_cur CURSOR FOR
     SELECT mss03,mss09 FROM q001_ttmp WHERE mss_v=g_mss[g_cnt].mss_v_1 AND mss01=g_mss[g_cnt].mss01
     AND pmc01=g_mss[g_cnt].pmh02  ORDER BY mss03
     LET i=1
    # LET ii=1
     FOREACH sel_mss03_cur INTO ll_mss03,ll_mss09
      LET ii=1
      FOR ii=1 TO 30
          IF l_mss[ii].mss03=ll_mss03 THEN 
             EXIT FOR
          END IF
      END FOR
         IF ii=1 THEN LET g_mss[g_cnt].d1=ll_mss09*g_mss[g_cnt].pmh11/100 END IF
         IF ii=2 THEN LET g_mss[g_cnt].d2=ll_mss09*g_mss[g_cnt].pmh11/100 END IF
         IF ii=3 THEN LET g_mss[g_cnt].d3=ll_mss09*g_mss[g_cnt].pmh11/100 END IF
         IF ii=4 THEN LET g_mss[g_cnt].d4=ll_mss09*g_mss[g_cnt].pmh11/100 END IF
         IF ii=5 THEN LET g_mss[g_cnt].d5=ll_mss09*g_mss[g_cnt].pmh11/100 END IF
         IF ii=6 THEN LET g_mss[g_cnt].d6=ll_mss09*g_mss[g_cnt].pmh11/100 END IF
         IF ii=7 THEN LET g_mss[g_cnt].d7=ll_mss09*g_mss[g_cnt].pmh11/100 END IF
         IF ii=8 THEN LET g_mss[g_cnt].d8=ll_mss09*g_mss[g_cnt].pmh11/100 END IF
         IF ii=9 THEN LET g_mss[g_cnt].d9=ll_mss09*g_mss[g_cnt].pmh11/100 END IF
         IF ii=10 THEN LET g_mss[g_cnt].d10=ll_mss09*g_mss[g_cnt].pmh11/100 END IF 
         IF ii=11 THEN LET g_mss[g_cnt].d11=ll_mss09*g_mss[g_cnt].pmh11/100 END IF 
         IF ii=12 THEN LET g_mss[g_cnt].d12=ll_mss09*g_mss[g_cnt].pmh11/100 END IF 
         IF ii=13 THEN LET g_mss[g_cnt].d13=ll_mss09*g_mss[g_cnt].pmh11/100 END IF 
         IF ii=14 THEN LET g_mss[g_cnt].d14=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=15 THEN LET g_mss[g_cnt].d15=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=16 THEN LET g_mss[g_cnt].d16=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=17 THEN LET g_mss[g_cnt].d17=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=18 THEN LET g_mss[g_cnt].d18=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=19 THEN LET g_mss[g_cnt].d19=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=20 THEN LET g_mss[g_cnt].d20=ll_mss09*g_mss[g_cnt].pmh11/100 END IF 
         IF ii=21 THEN LET g_mss[g_cnt].d21=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=22 THEN LET g_mss[g_cnt].d22=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=23 THEN LET g_mss[g_cnt].d23=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=24 THEN LET g_mss[g_cnt].d24=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=25 THEN LET g_mss[g_cnt].d25=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=26 THEN LET g_mss[g_cnt].d26=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=27 THEN LET g_mss[g_cnt].d27=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=28 THEN LET g_mss[g_cnt].d28=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=29 THEN LET g_mss[g_cnt].d29=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
         IF ii=30 THEN LET g_mss[g_cnt].d30=ll_mss09*g_mss[g_cnt].pmh11/100  END IF 
   #    IF i=31 THEN LET g_mss[g_cnt].d31=ll_mss03 END IF 
   #    IF i=32 THEN LET g_mss[g_cnt].d32=ll_mss03 END IF 
   #    IF i=33 THEN LET g_mss[g_cnt].d33=ll_mss03 END IF 
   #    IF i=3 THEN LET g_mss[g_cnt].d34=ll_mss03 END IF 
   #    IF i=36 THEN LET g_mss[g_cnt].d35=ll_mss03 END IF 
       LET i=i+1
       IF i>30 THEN EXIT FOREACH END IF
   #    LET g_cnt = g_cnt + 1
   #    IF g_cnt > g_max_rec THEN
   #       CALL cl_err( '', 9035, 0 )
   #       EXIT FOREACH
   #    END IF
     END FOREACH    
     LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
 #    LET g_rec_b = g_cnt-1
 #    DISPLAY g_rec_b TO FORMONLY.cn2


   END FOREACH 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i304_bp(p_ud)
   
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mss TO s_mss.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i304_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i304_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i304_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i304_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i304_fetch('L')
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
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
       
       ON ACTION pz 
          LET g_action_choice="pz"
          EXIT DISPLAY       

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
             LET INT_FLAG=FALSE                 #MOD-570244 mars
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
      #TQC-8C0075 --add
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      #TQC-8C0075
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
   {
FUNCTION i304_copy()
DEFINE l_newno,l_oldno1  LIKE mss_file.mss01,
       l_n               LIKE type_file.num5,    #No.FUN-680136 SMALLINT
       l_ima02           LIKE ima_file.ima02,
       l_ima021          LIKE ima_file.ima021,
       l_newno2,l_oldno2 LIKE pnc_file.pnc02    #TQC-8C0075
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_mss01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   #INPUT l_newno FROM mss01 
   INPUT l_newno,l_newno2 FROM mss01,mss02      #TQC-8C0075
 
      AFTER FIELD mss01
         IF NOT cl_null(l_newno) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(l_newno,"") THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD mss01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
            LET l_n = 0
            SELECT count(*) INTO l_n FROM ima_file WHERE ima01 = l_newno
            IF l_n = 0 THEN
               CALL cl_err(l_newno,'mfg3015',0)
               NEXT FIELD mss01
            END IF
            LET l_n = 0
            SELECT count(*) INTO l_n FROM mss_file WHERE mss01 = l_newno AND mss02=l_newno2 #TQC-8C0075
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD mss01
            END IF
         END IF
      #TQC-8C0075 -add-start
      AFTER FIELD mss02
         IF NOT cl_null(l_newno2) THEN
            SELECT count(*) INTO l_n FROM mss_file
                 WHERE mss01=l_newno AND  mss02=l_newno2
            IF l_n > 0 THEN
               LET g_msg = l_newno CLIPPED,'+',l_newno2 CLIPPED
               CALL cl_err(g_msg,-239,0)
               NEXT FIELD mss02
             END IF
          END IF
      #TQC-8C0075 -add -end
 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(mss01)
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_mss01"
#               LET g_qryparam.default1 = l_newno
#               CALL cl_create_qry() RETURNING l_newno
               CALL q_sel_ima(FALSE, "q_mss01","",l_newno,"","","","","",'' ) RETURNING l_newno
#FUN-AA0059---------mod------------end-----------------
               DISPLAY l_newno TO mss01
               NEXT FIELD mss01
#No.FUN-930026 --Begin
            WHEN INFIELD(mss02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pnc02"
               LET g_qryparam.default1 = l_newno2
               CALL cl_create_qry() RETURNING l_newno2
               DISPLAY l_newno2 TO mss02
               NEXT FIELD mss02
#No.FUN-930026 --End
            OTHERWISE EXIT CASE
         END CASE
 
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
      #DISPLAY BY NAME g_mss01
      DISPLAY  g_mss_v TO mss_v    #TQC-8C0075
      DISPLAY  g_ima06 TO ima06    #TQC-8C0075 
      DISPLAY  g_ima08 TO ima08 
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM mss_file WHERE mss01 = g_mss01
                            AND mss02 = g_mss02    
                           INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","mss_file","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET mss01 = l_newno,
                mss02 = l_newno2     #TQC-8C0075
 
   INSERT INTO mss_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","mss_file","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno1= g_mss01
   LET g_mss01=l_newno
   LET l_oldno2= g_mss02   #TQC-8C0075
   LET g_mss02=l_newno2    #TQC-8C0075
#   CALL i304_u()          #TQC-8C0075
   CALL i304_b()           #TQC-8C0075
   #LET g_mss01=l_oldno1   #FUN-C80046
   #LET g_mss02=l_oldno2   #TQC-8C0075  #FUN-C80046
 
   #CALL i304_show()       #FUN-C80046
 
END FUNCTION
   }
FUNCTION q001_tmp()

DROP TABLE q001_ttmp
CREATE TEMP TABLE q001_ttmp
 (mss_v    LIKE mss_file.mss_v,
  mss01    LIKE ima_file.ima01,
  mss03    LIKE mss_file.mss03,
  pmc01    LIKE pmc_file.pmc01,
  pmh11    LIKE pmh_file.pmh11,
  mss09    LIKE mss_file.mss09)

END FUNCTION

FUNCTION q001_pz()
   DEFINE i  LIKE type_file.num5
   DEFINE l_cnt   LIKE type_file.num5,
          l_mss03 LIKE mss_file.mss03
LET g_success='Y' 
BEGIN WORK
IF cl_confirm('cmr-003') THEN
   FOR i= 1 TO g_rec_b
     IF cl_null(g_mss[i].pmh02) THEN
        CONTINUE FOR
     ELSE
        DECLARE ss_mss03_cur CURSOR FOR
        SELECT mss03 FROM q001_ttmp WHERE mss_v=g_mss[i].mss_v_1 AND mss01=g_mss[i].mss01  AND pmc01=g_mss[i].pmh02
        ORDER BY mss03
        LET l_cnt=1 
        FOREACH ss_mss03_cur INTO l_mss03
          IF l_cnt=1 AND g_mss[i].d1>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d1,g_mss[i].pmh02,g_mss[i].d1,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN 
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=2 AND g_mss[i].d2>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d2,g_mss[i].pmh02,g_mss[i].d2,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=3 AND g_mss[i].d3>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d3,g_mss[i].pmh02,g_mss[i].d3,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=4 AND g_mss[i].d4>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d4,g_mss[i].pmh02,g_mss[i].d4,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=5 AND g_mss[i].d5>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d5,g_mss[i].pmh02,g_mss[i].d5,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=6 AND g_mss[i].d6>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d6,g_mss[i].pmh02,g_mss[i].d6,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=7 AND g_mss[i].d7>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d7,g_mss[i].pmh02,g_mss[i].d7,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=8 AND g_mss[i].d8>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d8,g_mss[i].pmh02,g_mss[i].d8,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=9 AND g_mss[i].d9>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d9,g_mss[i].pmh02,g_mss[i].d9,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=10 AND g_mss[i].d10>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d10,g_mss[i].pmh02,g_mss[i].d10,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=11 AND g_mss[i].d11>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d11,g_mss[i].pmh02,g_mss[i].d11,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=12 AND g_mss[i].d12>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d12,g_mss[i].pmh02,g_mss[i].d12,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=13 AND g_mss[i].d13>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d13,g_mss[i].pmh02,g_mss[i].d13,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=14 AND g_mss[i].d14>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d14,g_mss[i].pmh02,g_mss[i].d14,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=15 AND g_mss[i].d15>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d15,g_mss[i].pmh02,g_mss[i].d15,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=16 AND g_mss[i].d16>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d16,g_mss[i].pmh02,g_mss[i].d16,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=17 AND g_mss[i].d17>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d17,g_mss[i].pmh02,g_mss[i].d17,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=18 AND g_mss[i].d18>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d18,g_mss[i].pmh02,g_mss[i].d18,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=19 AND g_mss[i].d19>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d19,g_mss[i].pmh02,g_mss[i].d19,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=20 AND g_mss[i].d20>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d20,g_mss[i].pmh02,g_mss[i].d20,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF 
          IF l_cnt=21 AND g_mss[i].d21>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d21,g_mss[i].pmh02,g_mss[i].d21,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=22 AND g_mss[i].d22>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d22,g_mss[i].pmh02,g_mss[i].d22,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=23 AND g_mss[i].d23>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d23,g_mss[i].pmh02,g_mss[i].d23,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=24 AND g_mss[i].d24>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d24,g_mss[i].pmh02,g_mss[i].d24,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=25 AND g_mss[i].d25>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d25,g_mss[i].pmh02,g_mss[i].d25,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=26 AND g_mss[i].d26>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d26,g_mss[i].pmh02,g_mss[i].d26,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=27 AND g_mss[i].d27>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d27,g_mss[i].pmh02,g_mss[i].d27,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=28 AND g_mss[i].d28>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d28,g_mss[i].pmh02,g_mss[i].d28,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=29 AND g_mss[i].d29>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d29,g_mss[i].pmh02,g_mss[i].d29,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF
          IF l_cnt=30 AND g_mss[i].d30>0 THEN
             INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v_1,g_mss[i].mss01,g_mss[i].d30,g_mss[i].pmh02,g_mss[i].d30,l_mss03,
                                             '','','','','','',g_plant,g_legal)
             IF STATUS THEN
                CALL cl_err('',STATUS,1)
                LET g_success='N'
             END IF
          END IF

          
          LET l_cnt=l_cnt+1

        END FOREACH 
  #      IF g_mss[i].d1>0 THEN
  #         INSERT INTO tc_mss_file VALUES (g_mss[i].mss_v,g_mss[i].mss01,g_mss[i].d1,g_mss[i].pmh02,g_mss[i].d1,
  #      END IF
     END IF
  

   END FOR    

ELSE
END IF

IF g_success='Y' THEN
   COMMIT WORK
   CALL cl_err('','cmr-004',1)
ELSE
   ROLLBACK WORK
   CALL cl_err('','cmr-005',1)

END IF

END FUNCTION
