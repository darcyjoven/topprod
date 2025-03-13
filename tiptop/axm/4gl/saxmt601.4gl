# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: saxmt601.4gl
# Date & Author..: 99/05/26 By Carol 
# Modify.........: No.FUN-4B0038 04/11/16 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.MOD-620016 06/02/09 By Nicola 序號整批產生修改
# Modify.........: No.TQC-630107 06/03/10 By Alexstar 單身筆數限制
# Modify.........: No.FUN-660167 06/06/26 By wujie cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710016 07/01/19 By kim t600_5->t601_5
# Modify.........: No.FUN-710040 07/01/22 By rainy 1.新增序號查詢功能(只能查不可修改)
#                                                  2.整批產生序號時參考axmi121
# Modify.........: No.FUN-710046 07/02/01 By cheunl 錯誤訊息匯整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740305 07/04/26 By Lynn 查詢序號按鈕帶出的axmt600s離開動能不可行
# Modify.........: No.TQC-740305 07/04/26 By Lynn 查詢序號按鈕帶出的axmt600s離開動能不可行
# Modify.........: No.TQC-750119 07/05/25 By rainy 單身Action "維護序號",用"整批產生"的方式欲產生序號資料時,結果hold住,無法產生資料
# Modify.........: No.TQC-750185 07/05/28 By kim "查詢序號"無法正確串出正確的資料,且串出去的畫面axmt600s,出貨單號錯誤
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-980010 09/08/25 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0066 09/12/08 By Smapmin 匯出excel功能修正
# Modify.........: No:MOD-AC0380 10/12/29 By chenying 出貨通知單單身點”維護序號”功能，右方有非常多的Action (btn_01~20)
# Modify.........: No:MOD-B50069 11/05/13 By Summer 整批功能在輸入起迄序號時,輸入的內容要為[0-9]
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ogbb_paogbbo   LIKE type_file.num5,        # No.FUN-680137 SMALLINT    #頁數
       g_ogbb           DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
                           ogbb02   LIKE ogbb_file.ogbb02    #序號
                        END RECORD,
       g_ogbb_t         RECORD                 #程式變數 (舊值)
                           ogbb02   LIKE ogbb_file.ogbb02    #序號
                        END RECORD,
       g_wc2,g_sql      string, #No.FUN-580092 HCN
       g_cmd            LIKE type_file.chr1000,       #No.FUN-680137  VARCHAR(80)
       g_ogbb01         LIKE ogbb_file.ogbb01,
       g_ogbb012        LIKE ogbb_file.ogbb012,
       tm               RECORD
                           bno   LIKE oea_file.oea01,      # No.FUN-680137 VARCHAR(15) 
                           eno   LIKE oea_file.oea01      # No.FUN-680137 VARCHAR(15)
                        END RECORD, 
       g_rec_b          LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
       l_ac             LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE g_forupd_sql  STRING #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE g_cnt           LIKE type_file.num10            #No.FUN-680137 INTEGER
DEFINE g_ogb03         LIKE ogb_file.ogb03   #FUN-710040 add
DEFINE g_msg           STRING                #FUN-710040
DEFINE g_jump          LIKE type_file.num5   #SMALLINT #FUN-710040
DEFINE g_curs_index_2  LIKE type_file.num5   #SMALLINT #FUN-710040
DEFINE g_row_count_2   LIKE type_file.num5   #SMALLINT #FUN-710040
 
#FUN-710040--begin
FUNCTION t6005_cs()
 LET g_sql = "SELECT ogb01,ogb03 FROM ogb_file  WHERE ogb01 = '", g_ogbb01 ,"'"
 PREPARE t6005_prepare FROM g_sql
 DECLARE t6005_cs                         #SCROLL CURSOR
     SCROLL CURSOR WITH HOLD FOR t6005_prepare
 LET g_sql = "SELECT COUNT(*) FROM ogb_file WHERE ogb01 = '", g_ogbb01, "'"
 PREPARE t6005_precount FROM g_sql
 DECLARE t6005_count CURSOR FOR t6005_precount
 
END FUNCTION
#FUN-710040--end
 
 
FUNCTION t601_5(p_ogb01,p_ogb03) #FUN-710016
   DEFINE p_ogb01    LIKE ogb_file.ogb01 
   DEFINE p_ogb03    LIKE ogb_file.ogb03 
   DEFINE l_oga09    LIKE oga_file.oga09  #TQC-750185
   DEFINE l_oga011   LIKE oga_file.oga011 #TQC-750185

   WHENEVER ERROR CONTINUE 
 
   IF ( p_ogb01 IS NULL OR p_ogb01 = ' ' )  THEN                     #FUN-710040
      RETURN 
   END IF 
 
   LET g_ogbb01=p_ogb01 
   LET g_ogbb012=p_ogb03 
   LET g_ogb03 = p_ogb03  #FUN-710040
 
   SELECT oga09,oga011 INTO l_oga09,l_oga011 FROM oga_file WHERE oga01=p_ogb01
   IF (SQLCA.sqlcode=0) AND (NOT cl_null(l_oga011))THEN
      IF l_oga09 MATCHES '[1589]' THEN
         LET g_ogbb01=l_oga011
      END IF
   END IF
 
   OPEN WINDOW t6005_w WITH FORM "axm/42f/axmt600s"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmt600s")
   CALL cl_load_act_list("")
 
  IF cl_null(g_ogb03) THEN
    CALL t6005_cs()
    OPEN t6005_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
      OPEN t6005_count
      FETCH t6005_count INTO g_row_count_2
      CALL t6005_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
  ELSE
    LET g_row_count_2 = 1
    LET g_curs_index_2 = 1
    CALL cl_navigator_setting( g_curs_index_2, g_row_count_2 )
   DISPLAY g_ogbb01  TO FORMONLY.ogb01 
   DISPLAY g_ogbb012 TO FORMONLY.ogb03 
 
   LET g_wc2 = '1=1'
 
   CALL t6005_b_fill(g_wc2)
  END IF
 
   LET g_ogbb_paogbbo = 0                   #現在單身頁次
 
   CALL t6005_menu()
 
   CLOSE WINDOW t6005_w                 #結束畫面
 
END FUNCTION
 
 
 
FUNCTION t6005_fetch(p_flag)
DEFINE
  p_flag          LIKE type_file.chr1
 
  CASE p_flag
      WHEN 'N' FETCH NEXT     t6005_cs INTO g_ogbb01,g_ogbb012
      WHEN 'P' FETCH PREVIOUS t6005_cs INTO g_ogbb01,g_ogbb012
      WHEN 'F' FETCH FIRST    t6005_cs INTO g_ogbb01,g_ogbb012
      WHEN 'L' FETCH LAST     t6005_cs INTO g_ogbb01,g_ogbb012
      WHEN '/'
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                 ON ACTION controlg
                 CALL cl_cmdask()
              END PROMPT
              IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
              END IF
 
          FETCH ABSOLUTE g_jump t6005_cs INTO g_ogbb01,g_ogbb012
  END CASE
 
  IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ogbb01  TO NULL  #TQC-6B0105
      INITIALIZE g_ogbb012 TO NULL  #TQC-6B0105
      RETURN
  ELSE
     CASE p_flag
        WHEN 'F' LET g_curs_index_2 = 1
        WHEN 'P' LET g_curs_index_2 = g_curs_index_2 - 1
        WHEN 'N' LET g_curs_index_2 = g_curs_index_2 + 1
        WHEN 'L' LET g_curs_index_2 = g_row_count_2
        WHEN '/' LET g_curs_index_2 = g_jump
     END CASE
 
     CALL cl_navigator_setting( g_curs_index_2, g_row_count_2 )
  END IF
 
  DISPLAY g_ogbb01  TO FORMONLY.ogb01
  DISPLAY g_ogbb012 TO FORMONLY.ogb03
  LET g_wc2 = '1=1'
  CALL t6005_b_fill(g_wc2)
 
  LET g_ogbb_paogbbo = 0                   #現在單身頁次
END FUNCTION
#FUN-710040--end
 
FUNCTION t6005_menu()
#-----MOD-9C0066---------
DEFINE w ui.Window
DEFINE f ui.Form
DEFINE page om.DomNode
#-----END MOD-9C0066-----
 
   WHILE TRUE
      CALL t6005_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t6005_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t6005_b()
            END IF
            LET g_action_choice = NULL
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "batch_generate"
            IF cl_chk_act_auth() THEN
               CALL t6005_g()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
               #-----MOD-9C0066---------
               LET w = ui.Window.getCurrent()  
               LET f = w.getForm()   
               LET page = f.FindNode("Table","s_ogbb")   
               CALL cl_export_to_excel(page,base.TypeInfo.create(g_ogbb),'','')
               #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ogbb),'','')
               #-----END MOD-9C0066-----
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t6005_g()
   DEFINE l_ogbb   RECORD LIKE ogbb_file.*,
          l_cnt    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          i        LIKE type_file.num20,           # No.FUN-680137 DEC(16,0) #No.MOD-620016
          j        LIKE oea_file.oea01           # No.FUN-680137  VARCHAR(15)
  DEFINE l_ogb04  LIKE ogb_file.ogb04    #FUN-710040
  DEFINE l_ima141 LIKE ima_file.ima141,  #FUN-710040
         l_ima142 LIKE ima_file.ima142,  #FUN-710040
         l_ima143 LIKE ima_file.ima143,  #FUN-710040
         l_ima144 LIKE ima_file.ima144,  #FUN-710040
         l_mask   LIKE ogbb_file.ogbb02, #FUN-710040
         l_i      LIKE type_file.num5,   #SMALLINT#FUN-710040
         l_j      LIKE oea_file.oea01,   #CHAR(15), #FUN-710040
         l_chk_bno LIKE ogbb_file.ogbb02,#FUN-710040
         l_chk_eno LIKE ogbb_file.ogbb02 #FUN-710040
 
        
 
   OPEN WINDOW t6005_g AT 5,3 WITH FORM "axm/42f/axmt600c"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmt600c")
        
   WHILE TRUE  
      INPUT BY NAME tm.bno,tm.eno WITHOUT DEFAULTS 
 
         #MOD-B50069 add --start--
         AFTER FIELD bno
            IF NOT cl_null(tm.bno) THEN 
               IF NOT t601_chk_no(tm.bno) THEN
                  NEXT FIELD bno 
               END IF
            END IF
         #MOD-B50069 add --end--

         AFTER FIELD eno   
            IF NOT cl_null(tm.eno) THEN 
               #MOD-B50069 add --start--
               IF NOT t601_chk_no(tm.eno) THEN
                  NEXT FIELD eno 
               END IF
               #MOD-B50069 add --end--
               IF tm.bno > tm.eno THEN 
                  NEXT FIELD eno
               END IF 
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
         CLOSE WINDOW t6005_g
         RETURN
      END IF 
 
    #FUN-710040-- begin
     LET l_mask = ''
     SELECT ogb04,ima141,ima142,ima143,ima144
       INTO l_ogb04,l_ima141,l_ima142,l_ima143,l_ima144
       FROM ima_file,ogb_file
      WHERE ima01 = ogb04
        AND ogb01 = g_ogbb01 AND ogb03 = g_ogbb012
      IF l_ima141 <> '2' THEN
        LET l_chk_bno = tm.bno
        LET l_chk_eno = tm.eno
      ELSE
        FOR l_i = 1 TO l_ima142-l_ima143
          LET l_mask[l_i,l_i]='&'
        END FOR
        IF Length(l_ima144) > l_ima143 THEN
          LET l_chk_bno = l_ima144[1,l_ima143] CLIPPED, tm.bno
          LET l_chk_eno = l_ima144[1,l_ima143] CLIPPED, tm.eno
        ELSE
          LET l_chk_bno = l_ima144 CLIPPED, tm.bno
          LET l_chk_eno = l_ima144 CLIPPED, tm.eno
        END IF
      END IF
     #FUN-710040--end
 
        
      #檢查是否已有相同序號產生
      SELECT COUNT(*) INTO l_cnt FROM ogbb_file 
       WHERE ogbb01 = g_ogbb01 
         AND ogbb012 = g_ogbb012      
         #AND ogbb02 BETWEEN tm.bno AND tm.eno       #FUN-710040
         AND ogbb02 BETWEEN l_chk_bno AND l_ck_eno   #FUN-710040
 
      IF l_cnt > 0 THEN 
         CALL cl_err('','axm-298',1) 
         CONTINUE WHILE 
      END IF 
 
      EXIT WHILE 
   END WHILE  
 
   IF NOT cl_sure(0,0) THEN 
      CLOSE WINDOW t6005_g
      RETURN
   END IF 
 
   BEGIN WORK
 
   LET g_success = 'Y' 
 
   #-----No.MOD-620016-----
   LET i = tm.bno - 1
   CALL s_showmsg_init()                 #No.FUN-710046
   WHILE TRUE
#No.FUN-710046 ---------Begin-----------------------                                                                                
     IF g_success = "N" THEN                                                                                                        
        LET g_totsuccess = "N"                                                                                                      
        LET g_success = "Y"                                                                                                         
     END IF                                                                                                                         
#No.FUN-710046 ----------End-----------------------
  #FOR i = tm.bno TO tm.eno
      LET i = i + 1
      IF i > tm.eno THEN
        EXIT WHILE              #No.FUN-710046     #TQC-750119
        # CONTINUE WHILE          #No.FUN-710046   #TQC-750119
      END IF
      LET l_ogbb.ogbb01 = g_ogbb01
      LET l_ogbb.ogbb012= g_ogbb012
      LET j = i
 
    #FUN-710040-- begin
     LET l_j = i
     #LET l_ogbb.ogbb02 = j
     IF l_ima141 = '2' THEN   #每次出貨均附予產品序號
        IF cl_null(l_ima142) OR l_ima142 = 0 OR l_ima142 > 15 THEN
#          CALL cl_err('' ,'axm-115',1)            #No.FUN-710046
           CALL s_errmsg('','','',"axm-115",0)     #No.FUN-710046
#          EXIT WHILE              #No.FUN-710046
           CONTINUE WHILE          #No.FUN-710046
        END IF
        IF Length(l_j) > l_ima142-l_ima143 THEN
#          CALL cl_err('','axm-116',1)             #No.FUN-710046
           CALL s_errmsg('','','',"axm-116",0)      #No.FUN-710046
#          EXIT WHILE              #No.FUN-710046
           CONTINUE WHILE          #No.FUN-710046
        END IF
 
        IF Length(l_ima144) > l_ima143 THEN
          LET l_ogbb.ogbb02 = l_ima144[1,l_ima143] CLIPPED, j USING l_mask
        ELSE
          LET l_ogbb.ogbb02 = l_ima144 CLIPPED, j USING l_mask
        END IF
        IF Length(l_ogbb.ogbb02) > 15 THEN
#          CALL cl_err('','axm-116',1)             #No.FUN-710046
           CALL s_errmsg('','','',"axm-116",0)      #No.FUN-710046
#          EXIT WHILE              #No.FUN-710046
           CONTINUE WHILE          #No.FUN-710046
        END IF
 
     ELSE
       LET l_ogbb.ogbb02 = j
     END IF
    #FUN-710040--end
 
      #FUN-980010 add plant & legal 
      LET l_ogbb.ogbbplant = g_plant 
      LET l_ogbb.ogbblegal = g_legal
      #FUN-980010 end plant & legal 
 
      INSERT INTO ogbb_file VALUES (l_ogbb.*)
      IF STATUS THEN
#        CALL cl_err('ins ogbb',STATUS,1)   #No.FUN-660167
#        CALL cl_err3("ins","ogbb_file",l_ogbb.ogbb01,"",STATUS,"","ins ogbb",1)  #No.FUN-660167   #No.FUN-710046
         CALL s_errmsg('ogbb01',l_ogbb.ogbb01,'INS ogbb_file',SQLCA.sqlcode,1)     #No.FUN-710046
         LET g_success = 'N'
      END IF
  #END FOR
   END WHILE
#No.FUN-710046------------------BEGIN---------                                                                                      
     IF g_totsuccess="N" THEN                                                                                                       
        LET g_success="N"                                                                                                           
     END IF                                                                                                                         
     CALL s_showmsg()
#No.FUN-710046-------------------END------------
   #-----No.MOD-620016 END-----
 
   IF g_success = 'Y' THEN 
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF 
 
   CLOSE WINDOW t6005_g 
 
   LET g_wc2 = '1=1' 
 
   CALL t6005_b_fill(g_wc2) 
 
END FUNCTION

#MOD-B50069 add --start--
FUNCTION t601_chk_no(p_no)
   DEFINE p_no      LIKE ogbb_file.ogbb02 
   DEFINE l_no      LIKE ogbb_file.ogbb02 
   DEFINE l_n1      LIKE type_file.num5   
   DEFINE l_n2      LIKE type_file.num5  

   LET l_n2= LENGTH(p_no)
   #判斷是否有非數字存在
   FOR l_n1 = 1 TO l_n2
      LET l_no = p_no[l_n1,l_n1]
      IF l_no NOT MATCHES '[0-9]' THEN
         CALL cl_err(p_no,'azz-543',1)
         RETURN FALSE
      END IF
   END FOR
   RETURN TRUE 
END FUNCTION
#MOD-B50069 add --end--
 
FUNCTION t6005_q()
 
   CALL t6005_b_askkey()
 
   LET g_ogbb_paogbbo = 0
 
END FUNCTION
 
FUNCTION t6005_b()
   DEFINE l_ac_t           LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
          l_n              LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
          l_lock_sw        LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
          p_cmd            LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
          l_allow_insert   LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
          l_allow_delete   LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ogb03) THEN RETURN END IF  #FUN-710040 add
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT ogbb02 FROM ogbb_file ",
                      "  WHERE ogbb01 = ? ",
                      "   AND ogbb012 = ?",
                      "   AND ogbb02 = ? ",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t6005_bcl CURSOR FROM g_forupd_sql
 
   LET g_ogbb_paogbbo = 1
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_ogbb WITHOUT DEFAULTS FROM s_ogbb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd = 'u'
            LET g_ogbb_t.* = g_ogbb[l_ac].*  #BACKUP
 
            OPEN t6005_bcl USING g_ogbb01,g_ogbb012,g_ogbb_t.ogbb02 
            IF STATUS THEN
               CALL cl_err("OPEN t6005_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH t6005_bcl INTO g_ogbb[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ogbb_t.ogbb02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = 'a'
         INITIALIZE g_ogbb[l_ac].* TO NULL      #900423
         LET g_ogbb_t.* = g_ogbb[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO ogbb_file(ogbb01,ogbb012,ogbb02,ogbbplant,ogbblegal) #FUN-980010 add plant & legal 
                        VALUES(g_ogbb01,g_ogbb012,g_ogbb[l_ac].ogbb02,g_plant,g_legal)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_ogbb[l_ac].ogbb02,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","ogbb_file",g_ogbb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
         END IF
 
      AFTER FIELD ogbb02                        #check 編號是否重複
         IF NOT cl_null(g_ogbb[l_ac].ogbb02) THEN
            IF g_ogbb[l_ac].ogbb02 != g_ogbb_t.ogbb02 OR
               cl_null(g_ogbb_t.ogbb02 IS NULL) THEN
               SELECT count(*) INTO l_n FROM ogbb_file
                WHERE ogbb01 = g_ogbb01
                  AND ogbb012 = g_ogbb012 
                  AND ogbb02 = g_ogbb[l_ac].ogbb02
               IF l_n > 0 THEN
                  CALL cl_err('','-239',0)
                  LET g_ogbb[l_ac].ogbb02 = g_ogbb_t.ogbb02
                  NEXT FIELD ogbb02
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_ogbb_t.ogbb02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            
            DELETE FROM ogbb_file 
             WHERE ogbb01 = g_ogbb01
               AND ogbb012 = g_ogbb012
               AND ogbb02 = g_ogbb_t.ogbb02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ogbb_t.ogbb02,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","ogbb_file",g_ogbb01,g_ogbb_t.ogbb02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b = g_rec_b - 1
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ogbb[l_ac].* = g_ogbb_t.*
            CLOSE t6005_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ogbb[l_ac].ogbb02,-263,1)
            LET g_ogbb[l_ac].* = g_ogbb_t.*
         ELSE
            UPDATE ogbb_file SET ogbb02 = g_ogbb[l_ac].ogbb02
             WHERE ogbb01 = g_ogbb01
               AND ogbb012 = g_ogbb012  
               AND ogbb02 = g_ogbb_t.ogbb02 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_ogbb[l_ac].ogbb02,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("upd","ogbb_file",g_ogbb01,g_ogbb_t.ogbb02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               LET g_ogbb[l_ac].* = g_ogbb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30034 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ogbb[l_ac].* = g_ogbb_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_ogbb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE t6005_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30034 Add
         CLOSE t6005_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ogbb02) AND l_ac > 1 THEN
            LET g_ogbb[l_ac].* = g_ogbb[l_ac-1].*
            NEXT FIELD ogbb02
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
   
   END INPUT
 
   CLOSE t6005_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t6005_b_askkey()
 
   CLEAR FORM
   CALL g_ogbb.clear()
   DISPLAY g_ogbb01 TO FORMONLY.ogb01 
   DISPLAY g_ogbb012 TO FORMONLY.ogb03 
 
   CONSTRUCT g_wc2 ON ogbb02 FROM s_ogbb[1].ogbb02
 
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL t6005_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t6005_b_fill(p_wc2)
   DEFINE p_wc2   LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
   LET g_sql = "SELECT ogbb02 FROM ogbb_file ",
               " WHERE ogbb01 = '",g_ogbb01,"' AND ogbb012 = '",g_ogbb012,
               "' AND ", p_wc2 CLIPPED,    #單身
               " ORDER BY ogbb02" CLIPPED 
   PREPARE t6005_pb FROM g_sql
   DECLARE ogbb_curs CURSOR FOR t6005_pb
 
   CALL g_ogbb.clear()
   
   LET g_cnt = 1
   LET g_rec_b = 0
   MESSAGE "Searching!" 
 
   FOREACH ogbb_curs INTO g_ogbb[g_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      #TQC-630107---add---
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      #TQC-630107---end---
   END FOREACH
 
   CALL g_ogbb.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t6005_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
  #CALL cl_set_act_visible("accept,cancel", FALSE)
  #FUN-710040 --begin
   IF cl_null(g_ogb03) THEN
     CALL cl_set_act_visible("accept,cancel", FALSE)
   END IF
  #FUN-710040 --end
   #DISPLAY ARRAY g_ogbb TO s_ogbb.* ATTRIBUTE(COUNT=g_rec_b)           #FUN-710040
   DISPLAY ARRAY g_ogbb TO s_ogbb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #FUN-710040
     #FUN-710040--begin
      BEFORE DISPLAY
        IF cl_null(g_ogb03) THEN
          CALL cl_set_act_visible("batch_generate", FALSE)
        ELSE
          CALL cl_set_act_visible("batch_generate", TRUE)
        END IF
     #FUN-710040--end
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      # No.TQC-740305 ---begin
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      # No.TQC-740305 ---end
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
#@    ON ACTION 整批產生
      ON ACTION batch_generate
         LET g_action_choice="batch_generate"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      
      ON ACTION cancel
         LET INT_FLAG=FALSE          #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
   #FUN-710040--begin
     ON ACTION first
        CALL t6005_fetch('F')
        CALL cl_navigator_setting(g_curs_index_2, g_row_count_2)
        ACCEPT DISPLAY
 
     ON ACTION previous
        CALL t6005_fetch('P')
        CALL cl_navigator_setting(g_curs_index_2, g_row_count_2)
        ACCEPT DISPLAY
 
     ON ACTION jump
        CALL t6005_fetch('/')
        CALL cl_navigator_setting(g_curs_index_2, g_row_count_2)
        ACCEPT DISPLAY
 
     ON ACTION next
        CALL t6005_fetch('N')
        CALL cl_navigator_setting(g_curs_index_2, g_row_count_2)
        ACCEPT DISPLAY
 
     ON ACTION last
        CALL t6005_fetch('L')
        CALL cl_navigator_setting(g_curs_index_2, g_row_count_2)
        ACCEPT DISPLAY
   #FUN-710040--end
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
     #&include "qry_string.4gl"   #MOD-AC0380 mark
  
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
