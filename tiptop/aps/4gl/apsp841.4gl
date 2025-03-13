# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: apsp841.4gl
# Descriptions...: APS規劃結果鎖定製程時間自動更新作業(委外)
# Date & Author..: No:FUN-9B0079 09/11/16 By Mandy
# Modify.........: No:FUN-A70038 10/08/10 By Mandy 當異動碼建議為新增時(vop15='1'),若ERP資料已存在
#                                                  (vnd01=vop03 and vnd02=vop04 and vnd03=vop05 and vnd04=vop06 and vnd10='0'),則作update動作
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-9B0079
#模組變數(Module Variables)
DEFINE
    g_vop01         LIKE vop_file.vop01,
    g_vop02         LIKE vop_file.vop02,
    g_vop01_t       LIKE vop_file.vop01,  
    g_vop02_t       LIKE vop_file.vop02, 
    g_vop1          DYNAMIC ARRAY OF RECORD   #鎖定製程時間 
        vop16          LIKE vop_file.vop16,   #更新否
        vop15          LIKE vop_file.vop15,   #異動碼
        vop03          LIKE vop_file.vop03,   #是否外包
        vop04          LIKE vop_file.vop04,   #資源型態
        vop05          LIKE ecm_file.ecm03,   #加工序號
        vop06          LIKE vop_file.vop06,   #加班型態
        vop08          LIKE vop_file.vop08,   #開始時間(整數)
        vop09          DATETIME YEAR TO MINUTE,               
        vop10          DATETIME YEAR TO MINUTE,              
        vop11          LIKE vop_file.vop11,  #結束時間(日期)
        vop12          LIKE vop_file.vop12,   #排程
        vop07          LIKE vop_file.vop07    #外包商編號 
                    END RECORD,
    tm  RECORD  
        wc      LIKE type_file.chr1000,
        hstatus LIKE type_file.chr1
                   END RECORD,

    g_wc            STRING,  
    g_rec_b1,g_rec_b2,g_rec_b3,g_rec_b4   LIKE type_file.num5,            #單身筆數        #No.FUN-680072 SMALLINT
    g_sql           STRING, 
    g_sql1          STRING,  
    g_sql2          STRING, 
    g_cmd           LIKE type_file.chr1000,       
    g_t1            LIKE type_file.chr5,          
    l_ac,l_ac2,l_ac3,l_ac4   LIKE type_file.num5     #目前處理的ARRAY CNT      

#主程式開始
DEFINE  p_row,p_col         LIKE type_file.num5          
DEFINE  l_action_flag        STRING
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE  g_before_input_done  LIKE type_file.num5         
DEFINE  g_chr           LIKE type_file.chr1          
DEFINE  g_cnt           LIKE type_file.num10         
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose        
DEFINE  g_msg           LIKE ze_file.ze03        

DEFINE  g_row_count    LIKE type_file.num10         
DEFINE  g_curs_index   LIKE type_file.num10         
DEFINE  g_jump         LIKE type_file.num10         
DEFINE  mi_no_ask      LIKE type_file.num5          
DEFINE  g_void         LIKE type_file.chr1          
DEFINE  g_change_lang  LIKE type_file.chr1  


MAIN
    OPTIONS
       #FORM LINE       FIRST + 2, #FUN-B50022 mark
       #MESSAGE LINE    LAST,      #FUN-B50022 mark
       #PROMPT LINE     LAST,      #FUN-B50022 mark
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   

    LET p_row = 4 LET p_col = 5
    LET g_vop01_t = NULL  
    LET g_vop02_t = NULL 

    OPEN WINDOW p841_w AT 2,2 WITH FORM "aps/42f/apsp841"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    CALL cl_ui_init()

    CALL p841_menu()

    CLOSE WINDOW p841_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN


#QBE 查詢資料
FUNCTION p841_cs()

 DEFINE  l_type          LIKE    type_file.chr2        
 DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01

   CLEAR FORM                             #清除畫面
   CALL g_vop1.clear()

   INITIALIZE g_vop01 TO NULL   
   INITIALIZE g_vop02 TO NULL   
   LET tm.wc = NULL

   CONSTRUCT tm.wc ON vop01,vop02 FROM vop01,vop02  
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
      IF g_vop01_t IS NOT NULL THEN
         DISPLAY g_vop01_t TO vop01
         DISPLAY g_vop02_t TO vop02
      END IF

   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(vop01)
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_vlz01"
            CALL cl_create_qry() RETURNING g_vop01,g_vop02
            DISPLAY g_vop01 TO vop01
            DISPLAY g_vop02 TO vop02            
            NEXT FIELD vop01
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT

   IF INT_FLAG THEN RETURN END IF
   IF NOT cl_null(g_vop01) THEN 
       LET g_vop01_t = g_vop01 
       LET g_vop02_t = g_vop02
   END IF

   LET tm.hstatus = NULL
   INPUT BY NAME tm.hstatus WITHOUT DEFAULTS 

      BEFORE FIELD hstatus
         LET tm.hstatus = 'A'
         DISPLAY BY NAME  tm.hstatus

      AFTER FIELD hstatus
         IF cl_null(tm.hstatus) THEN
            NEXT  FIELD hstatus
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
      ON ACTION qbe_save
         CALL cl_qbe_save()
      ON ACTION locale
        LET g_change_lang = TRUE
        EXIT INPUT
   END INPUT

   IF INT_FLAG THEN
      RETURN
   END IF

   LET g_sql  = "SELECT UNIQUE vop01,vop02 ",
                "  FROM vop_file,ecm_file ",
                " WHERE vop00 = '",g_plant,"' ",
                "   AND vop03 = ecm01 ",
                "   AND vop04 = ecm01 ",
                "   AND vop05 = ecm03 ",
                "   AND vop06 = ecm04 ",
                "   AND vop15 IN ('1','2','3') ",
                "   AND ", tm.wc CLIPPED

   CASE tm.hstatus
      WHEN 'A' 
         ##整批調整
         LET g_sql1 = g_sql CLIPPED,
                      " AND ecm52 = 'Y' ", #ecm52 委外否
                      " ORDER BY vop01,vop02"
         LET g_sql2 = g_sql CLIPPED,
                      " AND ecm52 = 'Y' ", #ecm52 委外否
                      " GROUP BY vop01,vop02 ",
                      "  INTO TEMP x "

      WHEN 'B'
         ##不可調整(系統狀況改為一般製程)
         LET g_sql1 = g_sql CLIPPED, 
                      " AND ecm52 = 'N' ", #ecm52 委外否
                      " ORDER BY vop01,vop02"
         LET g_sql2 = g_sql CLIPPED,
                      " AND ecm52 = 'N' ", #ecm52 委外否
                      " GROUP BY vop01,vop02 ",
                      "  INTO TEMP x "
   END CASE
   PREPARE p841_prepare FROM g_sql1
   DECLARE p841_cs SCROLL CURSOR WITH HOLD FOR p841_prepare

   DROP TABLE x
   PREPARE p841_precount_x FROM g_sql2
   EXECUTE p841_precount_x

   LET g_sql2="SELECT COUNT(*) FROM x "

   PREPARE p841_precount FROM g_sql2
   DECLARE p841_count CURSOR FOR p841_precount    
END FUNCTION



FUNCTION p841_menu()

   WHILE TRUE
      CASE
         WHEN (l_action_flag IS NULL) OR (l_action_flag = "page01")  
            CALL p841_bp1("G")
      END CASE

      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p841_q()
            END IF
         WHEN "aps_btadjust"
            IF g_rec_b1 = 0 THEN
               CALL cl_err('','aps-702',1) #無單身資料可啟動
            ELSE
               IF tm.hstatus = 'A' THEN
                   BEGIN WORK
                   LET g_success = 'Y'
                   CALL p841_btadjust()
                   IF g_success = 'Y' THEN
                       COMMIT WORK
                       CALL p841_b1_fill(" 1=1")    #單身 
                   ELSE
                       ROLLBACK WORK
                       CALL cl_err('',g_errno,1)
                   END IF
               ELSE
                   #建議狀態錯誤，不可執行!
                   CALL cl_err('','aps-774',1)
               END IF   
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


FUNCTION p841_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_vop01 TO NULL   
   INITIALIZE g_vop02 TO NULL   
   CALL g_vop1.clear()

   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY '   ' TO FORMONLY.cnt

   CALL p841_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN p841_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      INITIALIZE g_vop01 TO NULL   
      INITIALIZE g_vop02 TO NULL   
      CALL g_vop1.clear()
   ELSE
      OPEN p841_count
      FETCH p841_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p841_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION


#處理資料的讀取
FUNCTION p841_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        

   CASE p_flag
      WHEN 'N' FETCH NEXT     p841_cs INTO g_vop01,g_vop02
      WHEN 'P' FETCH PREVIOUS p841_cs INTO g_vop01,g_vop02
      WHEN 'F' FETCH FIRST    p841_cs INTO g_vop01,g_vop02
      WHEN 'L' FETCH LAST     p841_cs INTO g_vop01,g_vop02
      WHEN '/'
         IF NOT mi_no_ask THEN
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

            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump p841_cs INTO g_vop01,g_vop02 
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vop01,SQLCA.sqlcode,0)
      INITIALIZE g_vop01 TO NULL  
      INITIALIZE g_vop02 TO NULL  
      CLEAR FORM
      CALL g_vop1.clear()
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   SELECT UNIQUE vop01,vop02 INTO g_vop01,g_vop02 FROM vop_file WHERE vop01 = g_vop01 AND vop02 = g_vop02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","vop_file",g_vop01,g_vop02,SQLCA.sqlcode,"","",1)  
      INITIALIZE g_vop01 TO NULL  
      INITIALIZE g_vop02 TO NULL  
      CALL g_vop1.clear()
      RETURN
   END IF
   CALL p841_show()
END FUNCTION


#將資料顯示在畫面上
FUNCTION p841_show()
   IF NOT cl_null(g_vop01) THEN 
       DISPLAY g_vop01 TO vop01
       DISPLAY g_vop02 TO vop02
       LET g_vop01_t = g_vop01 
       LET g_vop02_t = g_vop02
   END IF
   CALL p841_b1_fill(" 1=1")    #單身 一般訂單
   CALL cl_show_fld_cont()               
END FUNCTION



FUNCTION p841_b1_fill(p_wc1)
DEFINE
    p_wc1         STRING     

      IF cl_null(p_wc1) THEN  LET  p_wc1 = ' 1=1 ' END IF 
           LET g_sql = "SELECT vop16,vop15,vop03,vop04,vop05, ",
                       "       vop06,vop08,vop09,vop10,vop11, ",
                       "       vop12,vop07 ",
                       "  FROM vop_file,ecm_file  ",
                       "  WHERE vop00 ='",g_plant,"'",  
                       "    AND vop01 ='",g_vop01,"'",
                       "    AND vop02 ='",g_vop02,"'",
                       "    AND ",p_wc1 CLIPPED,
                       "    AND vop03 = ecm01 ",
                       "    AND vop04 = ecm01 ",
                       "    AND vop05 = ecm03 ",
                       "    AND vop06 = ecm04 ",
                       "    AND vop15 IN ('1','2','3') "
     CASE tm.hstatus
        WHEN 'A' 
           LET g_sql = g_sql CLIPPED," AND ecm52 = 'Y' "
        WHEN 'B'
           LET g_sql = g_sql CLIPPED," AND ecm52 = 'N' "
     END CASE
     LET g_sql = g_sql CLIPPED," ORDER BY vop16,vop15,vop03,vop04,vop05,vop06 "



    PREPARE p841_pb1 FROM g_sql
    DECLARE vop1_curs1 CURSOR FOR p841_pb1

    CALL g_vop1.clear()
    LET g_cnt= 1
    FOREACH vop1_curs1 INTO g_vop1[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt=g_cnt+1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_vop1.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
END FUNCTION



FUNCTION p841_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   DISPLAY g_rec_b1 TO FORMONLY.cn2

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)


   DISPLAY ARRAY g_vop1 TO s_arr1.* ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF NOT cl_null(tm.hstatus) AND tm.hstatus = 'A' THEN
             CALL cl_set_action_active("aps_btadjust",TRUE)
         ELSE
             #當選擇"B",讓Action "整批調整"灰階
             CALL cl_set_action_active("aps_btadjust",FALSE)
         END IF

      BEFORE ROW
         LET l_ac = ARR_CURR()


      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL p841_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b1 != 0 THEN
          CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY

      ON ACTION previous
         CALL p841_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL p841_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL p841_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL p841_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="page01"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      

      #整批調整
      ON ACTION aps_btadjust
         LET g_action_choice="aps_btadjust"
         EXIT DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


#整批調整鎖定製程時間
FUNCTION p841_btadjust()
  DEFINE l_cnt        LIKE type_file.num5 #FUN-A70038 add
  DEFINE l_vnd06      LIKE vnd_file.vnd06
  DEFINE i            LIKE type_file.num5
  DEFINE j            LIKE type_file.num5
  DEFINE g_msg4       LIKE ze_file.ze03

  LET j = 0
  FOR i = 1 TO g_rec_b1
      IF g_vop1[i].vop16 = 1 THEN #vop16更新否
          #已異動過,不可重覆執行
          LET g_errno = 'aps-803'
          LET g_success = 'N'
          RETURN
      END IF
      IF g_vop1[i].vop08 = 2 THEN
          LET l_vnd06 = 3
      ELSE
          LET l_vnd06 = 0
      END IF
      CASE g_vop1[i].vop15 
          WHEN 3 #修改
               UPDATE vnd_file
                  SET vnd06 = l_vnd06,
                      vnd07 = g_vop1[i].vop09,
                      vnd08 = g_vop1[i].vop10,  
                      vnd09 = g_vop1[i].vop12,
                      vnd11 = g_vop1[i].vop11
                WHERE vnd01 = g_vop1[i].vop03
                  AND vnd02 = g_vop1[i].vop04
                  AND vnd03 = g_vop1[i].vop05
                  AND vnd04 = g_vop1[i].vop06
                  AND vnd10 = 0 #非鎖定設備
          WHEN 1 #新增
               #FUN-A70038---add------str---
               #當異動碼建議為新增時(vop15='1'),若ERP資料已存在
               #(vnd01=vop03 and vnd02=vop04 and vnd03=vop05 and vnd04=vop06 and vnd10='0'),則作update動作
               SELECT COUNT(*) INTO l_cnt 
                 FROM vnd_file
                WHERE vnd01 = g_vop1[i].vop03
                  AND vnd02 = g_vop1[i].vop04
                  AND vnd03 = g_vop1[i].vop05
                  AND vnd04 = g_vop1[i].vop06
                  AND vnd10 = 0 #非鎖定設備
               IF l_cnt >=1 THEN
                   UPDATE vnd_file
                      SET vnd06 = l_vnd06,
                          vnd07 = g_vop1[i].vop09,
                          vnd08 = g_vop1[i].vop10,  
                          vnd09 = g_vop1[i].vop12,
                          vnd11 = g_vop1[i].vop11
                    WHERE vnd01 = g_vop1[i].vop03
                      AND vnd02 = g_vop1[i].vop04
                      AND vnd03 = g_vop1[i].vop05
                      AND vnd04 = g_vop1[i].vop06
                      AND vnd10 = 0 #非鎖定設備
               ELSE
               #FUN-A70038---add------end---
                   INSERT INTO vnd_file(vnd01,vnd02,vnd03,vnd04,vnd05,
                                        vnd06,vnd07,vnd08,vnd09,vnd10,
                                        vnd11,
                                        vndlegal,vndplant,vnd012) #FUN-B50022 add
                     VALUES(g_vop1[i].vop03,g_vop1[i].vop04,g_vop1[i].vop05,
                            g_vop1[i].vop06,' '            ,l_vnd06        ,
                            g_vop1[i].vop09,g_vop1[i].vop10,g_vop1[i].vop12,
                            0              ,g_vop1[i].vop11,
                            g_legal,g_plant,' ') #FUN-B50022 add
               END IF #FUN-A70038 add
          WHEN 2 #刪除
               DELETE FROM vnd_file
                WHERE vnd01 = g_vop1[i].vop03
                  AND vnd02 = g_vop1[i].vop04
                  AND vnd03 = g_vop1[i].vop05
                  AND vnd04 = g_vop1[i].vop06
                  AND vnd10 = 0 #非鎖定設備
      END CASE
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          #異動更新不成功
          LET g_errno = 'lib-028'
          LET g_success = 'N'
          RETURN
      ELSE
          UPDATE vop_file
             SET vop16 = 1 #是否更新，0:否 1:是
           WHERE vop00 = g_plant
             AND vop01 = g_vop01
             AND vop02 = g_vop02
             AND vop03 = g_vop1[i].vop03
             AND vop04 = g_vop1[i].vop04
             AND vop05 = g_vop1[i].vop05
             AND vop06 = g_vop1[i].vop06
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #異動更新不成功
              LET g_errno = 'lib-028'
              LET g_success = 'N'
              RETURN
          ELSE
              IF g_vop1[i].vop15 = 2 THEN #vop15 異動碼 0:不變，1:新增，2:刪除，3:修改
                  LET j = j + 1   ## 計算成功筆數
              ELSE
                  #vop15 MATCHES "[13]"時
                  UPDATE vmn_file
                     SET vmn18 = g_vop1[i].vop07 #外包商編號 
                   WHERE vmn02 = g_vop1[i].vop03 #途程編號
                     AND vmn03 = g_vop1[i].vop05 #加工序號
                     AND vmn04 = g_vop1[i].vop06 #作業編號
                 #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  IF SQLCA.sqlcode THEN
                      #異動更新不成功
                      LET g_errno = 'lib-028'
                      LET g_success = 'N'
                      RETURN
                  ELSE
                      LET j = j + 1   ## 計算成功筆數
                  END IF
              END IF
          END IF
      END IF
  END FOR  
  #成功筆數：
  CALL cl_getmsg('anm-973',g_lang) RETURNING g_msg4
  LET g_msg4 = g_msg4,j   
  CALL cl_msgany(0,0,g_msg4)  

END FUNCTION
