# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: anmt601.4gl
# Descriptions...: 票券外匯投資備註維護作業
# Date & Author..: 00/07/13 By Mandy
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/12 By pengu 報表轉XML
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-740501 07/05/02 By kim anmt600串備註資料(anmt601)無法輸入
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-960049 09/06/11 By xiaofeizhu 修改“預設上筆資料”ACTION
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
#   g_argv1        VARCHAR(10),              #專案代號
   g_argv1         LIKE gsd_file.gsd01,   #No.FUN-680107 VARCHAR(16)            #No.FUN-550057
   g_gsd01         LIKE gsd_file.gsd01,   #假單頭
   g_gsd01_t       LIKE gsd_file.gsd01,   #假單頭
   g_gsd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
       gsd02       LIKE gsd_file.gsd02,  
       gsd03       LIKE gsd_file.gsd03   
                   END RECORD,
   g_gsd_t         RECORD                 #程式變數 (舊值)
       gsd02       LIKE gsd_file.gsd02,  
       gsd03       LIKE gsd_file.gsd03   
                   END RECORD,
    g_wc2,g_sql    STRING,  #No.FUN-580092 HCN        
    g_wc           STRING,  #No.FUN-580092 HCN    
   g_rec_b         LIKE type_file.num5,          #單身筆數            #No.FUN-680107 SMALLINT
   l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
   g_ss            LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
   l_flag          LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
DEFINE g_forupd_sql STRING               #SELECT ... FOR UPDATE SQL       
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680107 INTEGER
 
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680107 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0082
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
   OPTIONS
      PROMPT  LINE  LAST,
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
   LET g_argv1 = ARG_VAL(1)               #傳遞的參數:投資編號
   LET g_gsd01 = g_argv1 
 
   INITIALIZE g_gsd_t.* TO NULL
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW t601_w AT p_row,p_col
     WITH FORM "anm/42f/anmt601"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN 
      CALL t601_q()
   END IF
   CALL t601_menu()
   CLOSE WINDOW t601_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
#QBE 查詢資料
FUNCTION t601_cs()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_gsd01=g_argv1 #MOD-740501
      DISPLAY g_gsd01 TO gsd01 
      LET g_wc =" gsd01= '",g_argv1,"' "
      LET g_sql=" SELECT gsd01",
                " FROM gsd_file ",
                " WHERE ",g_wc CLIPPED
   ELSE
      CLEAR FORM                             #清除畫面
      CALL g_gsd.clear()
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_gsd01 TO NULL    #No.FUN-750051
      CONSTRUCT g_wc ON gsd01, gsd02, gsd03
           FROM gsd01,s_gsd[1].gsd02, s_gsd[1].gsd03
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
      LET g_sql= "SELECT  UNIQUE gsd01 FROM gsd_file ",
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY 1"
   END IF
   PREPARE t601_prepare FROM g_sql      #預備一下
   DECLARE t601_b_cs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t601_prepare
   #因主鍵值有兩個故所抓出資料筆數有誤
   DROP TABLE x
   LET g_sql="SELECT DISTINCT gsd01",
             " FROM gsd_file WHERE ", g_wc CLIPPED," INTO TEMP x"
   PREPARE t601_precount_x  FROM g_sql
   EXECUTE t601_precount_x 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE t601_precount FROM g_sql
   DECLARE t601_count CURSOR FOR  t601_precount
END FUNCTION
 
FUNCTION t601_menu()
 
   WHILE TRUE
      CALL t601_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t601_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t601_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth()
               THEN CALL t601_out()
            END IF 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gsd),'','')
            END IF
         #No.FUN-6A0011-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_gsd01 IS NOT NULL THEN
                 LET g_doc.column1 = "gsd01"
                 LET g_doc.value1 = g_gsd01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0011-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t601_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,         #a:輸入 u:更改        #No.FUN-680107 VARCHAR(1)
   l_n             LIKE type_file.num5,         #No.FUN-680107 SMALLINT
   l_str           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(40)
 
   LET g_ss='Y'
   DISPLAY  g_gsd01 TO gsd01 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_gsd01 WITHOUT DEFAULTS 
 
      AFTER FIELD gsd01   
         IF NOT cl_null(g_gsd01) THEN              
            IF g_gsd01 != g_gsd01_t OR g_gsd01_t IS NULL THEN
               SELECT UNIQUE gsd01
                 FROM gsd_file
                WHERE gsd01 =g_gsd01
               IF SQLCA.sqlcode THEN             #不存在, 新來的
                  IF p_cmd='a' THEN
                     LET g_ss='N'
                  END IF
               ELSE
                  IF p_cmd='u' THEN
                     CALL cl_err(g_gsd01,-239,0)
                     LET g_gsd01=g_gsd01_t
                     NEXT FIELD gsd01
                  END IF
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
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
END FUNCTION
 
FUNCTION t601_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_gsd.clear()
   CALL t601_cs()                            #取得查詢條件
   IF INT_FLAG THEN                          #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_gsd01 TO NULL
      CALL g_gsd.clear()
      RETURN
   END IF
   OPEN t601_b_cs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                     #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_gsd01 TO NULL
   ELSE
      CALL t601_fetch('F')                   #讀出TEMP第一筆並顯示
      OPEN t601_count
      FETCH t601_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t601_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680107 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t601_b_cs INTO g_gsd01
      WHEN 'P' FETCH PREVIOUS t601_b_cs INTO g_gsd01
      WHEN 'F' FETCH FIRST    t601_b_cs INTO g_gsd01
      WHEN 'L' FETCH LAST     t601_b_cs INTO g_gsd01
      WHEN '/' 
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t601_b_cs INTO g_gsd01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_gsd01,SQLCA.sqlcode,0)
      IF cl_null(g_argv1) THEN #MOD-740501
         INITIALIZE g_gsd01 TO NULL               #No.FUN-6A0011
         RETURN
      END IF
   ELSE
      OPEN t601_count
      FETCH t601_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL t601_show()
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
 
#將資料顯示在畫面上
FUNCTION t601_show()
   DISPLAY g_gsd01 TO gsd01               #單頭
   CALL t601_b_fill(' 1=1')                        #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t601_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT     #No.FUN-680107 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用            #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否            #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態              #No.FUN-680107 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否              #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否              #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF g_gsd01 IS NULL THEN RETURN END IF 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT gsd02,gsd03 FROM gsd_file",
                      " WHERE gsd02 = ? AND gsd01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t601_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_gsd WITHOUT DEFAULTS FROM s_gsd.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
       IF g_rec_b!=0 THEN
         CALL fgl_set_arr_curr(l_ac)
       END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gsd_t.* = g_gsd[l_ac].*  #BACKUP
            OPEN t601_bcl USING g_gsd_t.gsd02,g_gsd01 
            IF STATUS THEN
               CALL cl_err("OPEN t601_bcl:", STATUS, 1)
               LET l_lock_sw = "Y" 
            ELSE 
               FETCH t601_bcl INTO g_gsd[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gsd_t.gsd02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y" 
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gsd[l_ac].* TO NULL      #900423
         LET g_gsd_t.* = g_gsd[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
           #CALL g_gsd.deleteElement(l_ac)   #取消 Array Element
           #IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
           #   LET g_action_choice = "detail"
           #   LET l_ac = l_ac_t
           #END IF
           #EXIT INPUT
         END IF
         INSERT INTO gsd_file(gsd01,gsd02,gsd03,gsdlegal)   #FUN-980005 add legal
                       VALUES(g_gsd01,g_gsd[l_ac].gsd02,g_gsd[l_ac].gsd03,g_legal)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_gsd[l_ac].gsd02,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","gsd_file",g_gsd01,g_gsd[l_ac].gsd02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      BEFORE FIELD gsd02                         #check 編號是否重複
          IF cl_null(g_gsd[l_ac].gsd02) OR g_gsd[l_ac].gsd02 = 0 THEN
             SELECT max(gsd02)+1 INTO g_gsd[l_ac].gsd02
               FROM gsd_file WHERE gsd01 = g_gsd01
             IF g_gsd[l_ac].gsd02 IS NULL THEN
                LET g_gsd[l_ac].gsd02 = 1
             END IF
          END IF
 
      AFTER FIELD gsd02               #check 編號是否重複
         IF NOT cl_null(g_gsd[l_ac].gsd02) THEN
            IF g_gsd[l_ac].gsd02 != g_gsd_t.gsd02 OR g_gsd_t.gsd02 IS NULL THEN
               SELECT count(*) INTO l_n FROM gsd_file
                WHERE gsd02 = g_gsd[l_ac].gsd02
                  AND gsd01 = g_gsd01 
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gsd[l_ac].gsd02 = g_gsd_t.gsd02
                  NEXT FIELD gsd02
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_gsd_t.gsd02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gsd_file
             WHERE gsd02 = g_gsd_t.gsd02
               AND gsd01 = g_gsd01 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_gsd_t.gsd02,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","gsd_file",g_gsd01,g_gsd_t.gsd02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gsd[l_ac].* = g_gsd_t.*
            CLOSE t601_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gsd[l_ac].gsd02,-263,1)
            LET g_gsd[l_ac].* = g_gsd_t.*
         ELSE
            UPDATE gsd_file SET gsd01 = g_gsd01,
                                gsd02 = g_gsd[l_ac].gsd02,
                                gsd03 = g_gsd[l_ac].gsd03
              WHERE gsd02 = g_gsd_t.gsd02 AND gsd01 = g_gsd01 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_gsd[l_ac].gsd02,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","gsd_file",g_gsd01,g_gsd_t.gsd02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_gsd[l_ac].* = g_gsd_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac    #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gsd[l_ac].* = g_gsd_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_gsd.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE t601_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac    #FUN-D30032 add
         LET g_gsd_t.* = g_gsd[l_ac].*
         CLOSE t601_bcl
         COMMIT WORK
 
#     ON ACTION CONTROLN
#        CALL t601_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
#        IF INFIELD(gsd01) AND l_ac > 1 THEN    #TQC-960049 Mark                                                                    
         IF INFIELD(gsd02) AND l_ac > 1 THEN    #TQC-960049
            LET g_gsd[l_ac].* = g_gsd[l_ac-1].*
#           NEXT FIELD gsd01                    #TQC-960049 Mark                                                                    
            NEXT FIELD gsd02                    #TQC-960049
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
   
   END INPUT
 
   CLOSE t601_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t601_b_askkey()
   CLEAR FORM
   CALL g_gsd.clear()
   CONSTRUCT g_wc2 ON gsd02,gsd03
        FROM s_gsd[1].gsd02, s_gsd[1].gsd03
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
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CALL t601_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t601_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
   LET g_sql ="SELECT gsd02,gsd03 FROM gsd_file",
              " WHERE gsd01='",g_gsd01,"' AND ",p_wc2 CLIPPED,
              " ORDER BY 1"
   PREPARE t601_pb FROM g_sql
   DECLARE gsd_curs CURSOR FOR t601_pb
 
   CALL g_gsd.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH gsd_curs INTO g_gsd[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH 
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gsd.deleteElement(g_cnt)   #取消 Array Element
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t601_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gsd TO s_gsd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t601_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t601_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL t601_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t601_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL t601_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
   
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION t601_out()
    DEFINE
        l_gsd           RECORD LIKE gsd_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680107 VARCHAR(20)
        l_za05          LIKE type_file.chr1000        #        #No.FUN-680107 VARCHAR(40)
   
    IF g_wc  IS NULL THEN 
       CALL cl_err('','9057',0)
    RETURN END IF
    CALL cl_wait()
    LET l_name = 'anmt601.out'
    CALL cl_outnam('anmt601') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM gsd_file ",          # 組合出 SQL 指令
              " WHERE gsd01= '",g_gsd01,"' AND ",
                 g_wc CLIPPED
    PREPARE t601_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t601_co CURSOR FOR t601_p1
 
    START REPORT t601_rep TO l_name
 
    FOREACH t601_co INTO l_gsd.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT t601_rep(l_gsd.*)
    END FOREACH
 
    FINISH REPORT t601_rep
 
    CLOSE t601_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT t601_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
        sr RECORD LIKE gsd_file.*,
        l_gsd01_t LIKE gsd_file.gsd01
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.gsd01,sr.gsd02
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32]CLIPPED,g_x[33]CLIPPED
            PRINT g_dash1
            LET l_trailer_sw = 'y'
            LET l_gsd01_t = '          '
        ON EVERY ROW
            IF l_gsd01_t <> sr.gsd01 THEN
                PRINT COLUMN g_c[31],sr.gsd01;
            END IF
            PRINT COLUMN g_c[32],sr.gsd02 USING '###&',COLUMN g_c[33],sr.gsd03 #FUN-590118
            LET l_gsd01_t = sr.gsd01 
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
