# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: apsp840.4gl
# Descriptions...: APS規劃結果鎖定製程時間自動更新作業
# Date & Author..: 08/04/23 By rainy  #FUN-840156
# Modify.........: No:FUN-840209 08/05/22 By Mandy g_dbs =>g_plant
# Modify.........: No:FUN-870042 08/07/08 BY duke change vom to vnd
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:FUN-960126 09/07/10 By Duke 模式調整為整批調整
# Modify.........: No:FUN-9A0042 09/10/13 By Mandy (1)當選擇出來的建議型態無資料時,APS版本及儲存版本的資訊沒有keep住,需再重打才能查詢
#                                                  (2)建議狀態選擇"B" or "C"時,整批調整按鈕改為disable,不可執行
# Modify.........: No:FUN-A70038 10/08/10 By Mandy 當異動碼建議為新增時(vom14='1'),若ERP資料已存在
#                                                  (where vnd01=vom03 and vnd02=vom04 and vnd03=vom05 and vnd04=vom06),則作update動作
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以下為GP5.25的單號---str---
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版----------------------end---

DATABASE ds

GLOBALS "../../config/top.global"
#FUN-840156
#模組變數(Module Variables)
DEFINE
    g_vom01         LIKE vom_file.vom01,
    g_vom02         LIKE vom_file.vom02,
    g_vom01_t       LIKE vom_file.vom01,  #FUN-960126 ADD
    g_vom02_t       LIKE vom_file.vom02,  #FUN-960126 ADD
    g_vom1          DYNAMIC ARRAY OF RECORD #鎖定製程時間 FUN-870042
        vom13          LIKE vom_file.vom13,   #更新否
        vom14          LIKE vom_file.vom14,   #FUN-960126 ADD 異動碼
        vom03          LIKE vom_file.vom03,   #是否外包
        vom04          LIKE vom_file.vom04,   #資源型態
        vom05          LIKE ecm_file.ecm03,   #加工序號
        vom06          LIKE vom_file.vom06,   #加班型態
        vom07          LIKE vom_file.vom07,   #日期
        vom08          LIKE vom_file.vom08,   #開始時間(整數)
       #vom09          LIKE vom_file.vom09,  #開始時間(日期)  #FUN-960126 MARK
        vom09          DATETIME YEAR TO MINUTE,               #FUN-960126 ADD
       #vom10          LIKE vom_file.vom10,   #結束時間(整數) #FUN-960126 MARK
        vom10          DATETIME YEAR TO MINUTE,               #FUN-960126 ADD
        vom11          LIKE vom_file.vom11,  #結束時間(日期)
        vom12          LIKE vom_file.vom12,   #排程
        vom13a         LIKE vom_file.vom13
                    END RECORD,

    #FUN-961026 ADD --STR--------------------------------------
    tm  RECORD  
        wc      LIKE type_file.chr1000,
        hstatus LIKE type_file.chr1
                   END RECORD,
    #FUN-960126 ADD --END--------------------------------------

    g_wc            STRING,  
    g_rec_b1,g_rec_b2,g_rec_b3,g_rec_b4   LIKE type_file.num5,            #單身筆數        #No.FUN-680072 SMALLINT
    g_sql           STRING, 
    g_sql2          STRING,  #FUN-960126 ADD
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
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE  g_msg           LIKE ze_file.ze03        

DEFINE  g_row_count    LIKE type_file.num10         
DEFINE  g_curs_index   LIKE type_file.num10         
DEFINE  g_jump         LIKE type_file.num10         
DEFINE  mi_no_ask      LIKE type_file.num5          
DEFINE  g_void         LIKE type_file.chr1          
DEFINE   g_change_lang      LIKE type_file.chr1  #FUN-960126 ADD


MAIN  
#FUN-B50022--mod--str---
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT	 
#FUN-B50022--mod--end---

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("APS")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   

    LET p_row = 4 LET p_col = 5
    LET g_vom01_t = NULL  #FUN-960126 ADD
    LET g_vom02_t = NULL  #FUN-960126 ADD

    OPEN WINDOW t840_w AT 2,2 WITH FORM "aps/42f/apsp840"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 

    CALL cl_ui_init()

    CALL t840_default()
    CALL t840_menu()

    CLOSE WINDOW t840_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN


#QBE 查詢資料
FUNCTION t840_cs()

 DEFINE  l_type          LIKE type_file.chr2        
 DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01

   CLEAR FORM                             #清除畫面
   CALL g_vom1.clear()

   INITIALIZE g_vom01 TO NULL   
   INITIALIZE g_vom02 TO NULL   
   LET tm.wc = NULL

  #CONSTRUCT BY NAME g_wc ON vom01,vom02  #FUN-960126 MARK
   CONSTRUCT tm.wc ON vom01,vom02 FROM vom01,vom02  #FUN-960126 MARK
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
      #FUN-960126 ADD --STR-------------------------------------------
      IF g_vom01_t IS NOT NULL THEN
         DISPLAY g_vom01_t TO vom01
         DISPLAY g_vom02_t TO vom02
      END IF
      #FUN-960126 ADD --END-------------------------------------------     

   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(vom01)
            CALL cl_init_qry_var()
           #LET g_qryparam.state = "c"   #FUN-960126 MARK
            LET g_qryparam.form ="q_vlz01"
           #CALL cl_create_qry() RETURNING g_qryparam.multiret #FUN-960126 MARK
           #DISPLAY g_qryparam.multiret TO vom01               #FUN-960126 MARK
            CALL cl_create_qry() RETURNING g_vom01,g_vom02
            DISPLAY g_vom01 TO vom01
            DISPLAY g_vom02 TO vom02            
            NEXT FIELD vom01
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030	#FUN-B50022

   IF INT_FLAG THEN RETURN END IF
   IF NOT cl_null(g_vom01) THEN #FUN-9A0042 add if判斷
       LET g_vom01_t = g_vom01   #FUN-960126 ADD
       LET g_vom02_t = g_vom02   #FUN-960126 ADD
   END IF

   #FUN-960126 ADD --STR--------------------------
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
   #FUN-960126 ADD --END------------------------------------

   #FUN-960126 MARK --STR-----------------------------------
   #LET g_sql  = "SELECT UNIQUE vom01,vom02 ",
   #             " FROM vom_file ",
   #             " WHERE ", g_wc CLIPPED,
   #             " ORDER BY vom01,vom02"
   #PREPARE t840_prepare FROM g_sql
   #DECLARE t840_cs SCROLL CURSOR WITH HOLD FOR t840_prepare
   #
   #LET g_sql  = "SELECT COUNT(UNIQUE vom01) ",
   #             " FROM vom_file ",
   #             " WHERE ", g_wc CLIPPED
   #PREPARE t840_precount FROM g_sql
   #DECLARE t840_count CURSOR FOR t840_precount
   #FUN-960126 MARK --END------------------------------------

   #FUN-960126 ADD --STR-------------------------------------
    CASE tm.hstatus
       WHEN 'A' 
          ##整批調整
          LET g_sql  = "SELECT UNIQUE vom01,vom02 ",
                       "  FROM vom_file,ecm_file ",
                       " WHERE vom00 = '",g_plant,"' ",
                       "   AND vom03 = ecm01 ",
                       "   AND vom04 = ecm01 ",
                       "   AND vom05 = ecm03 ",
                       "   AND vom06 = ecm04 ",
                       "   AND ecm61 = 'N' ",
                       "   AND ecm52 = 'N' ",
                       "   AND vom12 = '0' ",
                       "   AND vom14 in ('1','2','3') ",
                       "   AND ", tm.wc CLIPPED,
                       " ORDER BY vom01,vom02"

          LET g_sql2 = "SELECT COUNT(UNIQUE vom01) ",
                       "  FROM vom_file,ecm_file ",
                       " WHERE vom00 = '",g_plant,"' ",
                       "   AND vom03 = ecm01 ",
                       "   AND vom04 = ecm01 ",
                       "   AND vom05 = ecm03 ",
                       "   AND vom06 = ecm04 ",
                       "   AND ecm61 = 'N' ",
                       "   AND ecm52 = 'N' ",
                       "   AND vom12 = '0' ",
                       "   AND vom14 in ('1','2','3') ",
                       "   AND ", tm.wc CLIPPED,
                       " ORDER BY vom01,vom02"

       WHEN 'B'
          ##不可調整(系統狀況改為委外製程)
          LET g_sql  = "SELECT UNIQUE vom01,vom02 ",
                       "  FROM vom_file,ecm_file ",
                       " WHERE vom00 = '",g_plant,"' ",
                       "   AND vom03 = ecm01 ",
                       "   AND vom04 = ecm01 ",
                       "   AND vom05 = ecm03 ",
                       "   AND vom06 = ecm04 ",
                       "   AND ecm52 = 'Y' ",
                       "   AND vom12 = '0' ",
                       "   AND vom14 in ('1','2','3') ",
                       "   AND ", tm.wc CLIPPED,
                       " ORDER BY vom01,vom02"

          LET g_sql2 = "SELECT COUNT(UNIQUE vom01) ",
                       "  FROM vom_file,ecm_file ",
                       " WHERE vom00 = '",g_plant,"' ",
                       "   AND vom03 = ecm01 ",
                       "   AND vom04 = ecm01 ",
                       "   AND vom05 = ecm03 ",
                       "   AND vom06 = ecm04 ",
                       "   AND ecm52 = 'Y' ",
                       "   AND vom12 = '0' ",
                       "   AND vom14 in ('1','2','3') ",
                       "   AND ", tm.wc CLIPPED,
                       " ORDER BY vom01,vom02"

       WHEN 'C'
          ##不可調整(系統狀況改為鎖定設備)
          LET g_sql  = "SELECT UNIQUE vom01,vom02 ",
                       "  FROM vom_file,ecm_file ",
                       " WHERE vom00 = '",g_plant,"' ",
                       "   AND vom03 = ecm01 ",
                       "   AND vom04 = ecm01 ",
                       "   AND vom05 = ecm03 ",
                       "   AND vom06 = ecm04 ",
                       "   AND ecm61 = 'Y' ",
                       "   AND vom12 = '0' ",
                       "   AND vom14 in ('1','2','3') ",
                       "   AND ", tm.wc CLIPPED,
                       " ORDER BY vom01,vom02"

          LET g_sql2 = "SELECT COUNT(UNIQUE vom01) ",
                       "  FROM vom_file,ecm_file ",
                       " WHERE vom00 = '",g_plant,"' ",
                       "   AND vom03 = ecm01 ",
                       "   AND vom04 = ecm01 ",
                       "   AND vom05 = ecm03 ",
                       "   AND vom06 = ecm04 ",
                       "   AND ecm61 = 'Y' ",
                       "   AND vom12 = '0' ",
                       "   AND vom14 in ('1','2','3') ",
                       "   AND ", tm.wc CLIPPED,
                       " ORDER BY vom01,vom02"
    END CASE
    PREPARE t840_prepare FROM g_sql
    DECLARE t840_cs SCROLL CURSOR WITH HOLD FOR t840_prepare
    PREPARE t840_precount FROM g_sql2
    DECLARE t840_count CURSOR FOR t840_precount    
   #FUN-960126 ADD --END-----------------------------------------
END FUNCTION


FUNCTION t840_default()
  CALL cl_set_comp_visible("vom13a",FALSE)

END FUNCTION


FUNCTION t840_menu()

   WHILE TRUE
      CASE
         WHEN (l_action_flag IS NULL) OR (l_action_flag = "page01")  #一般訂單
            CALL t840_bp1("G")
      END CASE

      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t840_q()
            END IF

        #FUN-960126 MARK --STR----------------------------------------------
        # WHEN "detail"
        #    CASE
        #    WHEN (l_action_flag IS NULL) OR (l_action_flag = "page01")  #一般訂單
        #       CALL t840_b1()
        #    END CASE
        #FUN-960126 MARK --END----------------------------------------------

        #FUN-960126 ADD --STR-----------------------------------------------
          WHEN "aps_btadjust"
             IF g_cnt = 0 THEN
                CALL cl_err('','aps-702',1)
             ELSE
                IF tm.hstatus = 'A' THEN
                    BEGIN WORK
                    LET g_success = 'Y'
                    CALL t840_btadjust()
                    IF g_success = 'Y' THEN
                        COMMIT WORK
                        CALL t840_b1_fill(" 1=1")    #單身 
                    ELSE
                        ROLLBACK WORK
                        CALL cl_err('',g_errno,1)
                    END IF
                ELSE
                    #建議狀態錯誤，不可執行!
                    CALL cl_err('','aps-774',1)
                END IF   
             END IF
        #FUN-960126 ADD --END-----------------------------------------------   


         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION


FUNCTION t840_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_vom01 TO NULL   
   INITIALIZE g_vom02 TO NULL   
   CALL g_vom1.clear()

   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   DISPLAY '   ' TO FORMONLY.cnt

   CALL t840_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t840_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      INITIALIZE g_vom01 TO NULL   
      INITIALIZE g_vom02 TO NULL   
      CALL g_vom1.clear()
   ELSE
      OPEN t840_count
      FETCH t840_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t840_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION


#處理資料的讀取
FUNCTION t840_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)

   CASE p_flag
      WHEN 'N' FETCH NEXT     t840_cs INTO g_vom01,g_vom02
      WHEN 'P' FETCH PREVIOUS t840_cs INTO g_vom01,g_vom02
      WHEN 'F' FETCH FIRST    t840_cs INTO g_vom01,g_vom02
      WHEN 'L' FETCH LAST     t840_cs INTO g_vom01,g_vom02
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
         FETCH ABSOLUTE g_jump t840_cs INTO g_vom01,g_vom02 
         LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_vom01,SQLCA.sqlcode,0)
      INITIALIZE g_vom01 TO NULL  
      INITIALIZE g_vom02 TO NULL  
      CLEAR FORM
      CALL g_vom1.clear()
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
   SELECT UNIQUE vom01,vom02 INTO g_vom01,g_vom02 FROM vom_file WHERE vom01 = g_vom01 AND vom02 = g_vom02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","vom_file",g_vom01,g_vom02,SQLCA.sqlcode,"","",1)  
      INITIALIZE g_vom01 TO NULL  
      INITIALIZE g_vom02 TO NULL  
      CALL g_vom1.clear()
      RETURN
   END IF
   CALL t840_show()
END FUNCTION


#將資料顯示在畫面上
FUNCTION t840_show()
   IF NOT cl_null(g_vom01) THEN #FUN-9A0042 add if判斷
       DISPLAY g_vom01 TO vom01
       DISPLAY g_vom02 TO vom02
       LET g_vom01_t = g_vom01   #FUN-960126 ADD
       LET g_vom02_t = g_vom02   #FUN-960126 ADD
   END IF
   CALL t840_b1_fill(" 1=1")    #單身 一般訂單
   CALL cl_show_fld_cont()               
END FUNCTION


#一般訂單
FUNCTION t840_b1()
DEFINE
   l_lock_sw       LIKE type_file.chr1,   #單身鎖住否      
   p_cmd           LIKE type_file.chr1,   #處理狀態       
   l_exit_sw       LIKE type_file.chr1,   
   l_allow_insert  LIKE type_file.num5,   #可新增否       
   l_allow_delete  LIKE type_file.num5,   #可刪除否      
   l_vom13t        LIKE vom_file.vom13,
   l_i             LIKE type_file.num5,            
   g_rec_b         LIKE type_file.num5 

   LET g_action_choice = ""

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_vom01) OR cl_null(g_vom02) THEN RETURN END IF
 
   IF g_rec_b1 = 0 THEN RETURN END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT vom00,vom01, ",
                      "      case when vom13 is null then 0 else vom13 end vom13, ",
                      "      vom03,vom04,vom05,vom06,vom07,vom08,vom09,vom10,vom11,vom12, ",
                      "      case when vom13 is null then 0 else vom13 end vom13a ",
                      " FROM vom_file",
                      " WHERE vom00=? AND vom01=? AND vom02=? AND vom03=? AND vom04=? ",
                      "               AND vom05=? AND vom06=? AND vom07=? FOR UPDATE"  #FUN-B50022 mod
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)									   #FUN-B50022 add
   DECLARE t840_b1_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE

   INPUT ARRAY g_vom1 WITHOUT DEFAULTS FROM s_arr1.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

     BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

     BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT

        BEGIN WORK
        IF g_rec_b1 >= l_ac THEN
           LET p_cmd='u'
           OPEN t840_b1_cl USING g_plant,g_vom01,g_vom02,g_vom1[l_ac].vom03,
                           g_vom1[l_ac].vom04,g_vom1[l_ac].vom05,g_vom1[l_ac].vom06,g_vom1[l_ac].vom07 #FUN-840209
           IF STATUS THEN
              CALL cl_err("OPEN t840_b1_cl:", STATUS, 1)
              LET l_lock_sw = "Y"
           END IF
           LET l_vom13t = g_vom1[l_ac].vom13
           
        END IF


       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_vom1[l_ac].vom13 = l_vom13t
             CLOSE t840_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF

       AFTER FIELD vom13
          IF g_vom1[l_ac].vom13a='1' AND g_vom1[l_ac].vom13=0 THEN 
             CALL cl_err('','aps-708',1)
             LET g_vom1[l_ac].vom13=1
             NEXT FIELD vom13
          END IF

       AFTER ROW
          LET l_ac = ARR_CURR()
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_vom1[l_ac].vom13 = l_vom13t
             END IF
             CLOSE t840_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE t840_b1_cl
          COMMIT WORK

       ON ACTION all_yes
           FOR l_i = 1 TO g_rec_b1
               LET g_vom1[l_i].vom13 = 1
               DISPLAY BY NAME g_vom1[l_i].vom13
           END FOR

       ON ACTION all_no
           FOR l_i = 1 TO g_rec_b1
               IF g_vom1[l_i].vom13a='0' THEN
                  LET g_vom1[l_i].vom13 = 0
                  DISPLAY BY NAME g_vom1[l_i].vom13
               END IF
           END FOR

       ON ACTION accept
          IF g_rec_b1=0 THEN
             RETURN
          ELSE
             CALL i840_upd()
             EXIT INPUT
          END IF 

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION about         
          CALL cl_about()      
 
       ON ACTION help          
          CALL cl_show_help()  
   END INPUT

   CLOSE t840_b1_cl
   COMMIT WORK
END FUNCTION


#一般訂單
FUNCTION t840_b1_fill(p_wc1)
DEFINE
    #p_wc1           LIKE type_file.chr1000 
    p_wc1         STRING     #NO.FUN-910082      

      IF cl_null(p_wc1) THEN  LET  p_wc1 = ' 1=1 ' END IF 


    #FUN-960126 MARK --STR----------------------------------------------- 
    #LET g_sql = "SELECT case when vom13 is null then 0 else vom13 end vom13, ",
    #            "       vom03,vom04,vom05,vom06,vom07,vom08,vom09,vom10,vom11,vom12, ",
    #            "       case when vom13 is null then 0 else vom13 end vom13a ",
    #            "  FROM vom_file ",
    #            "  WHERE vom00 ='",g_plant,"'",  
    #            "   AND vom01 ='",g_vom01,"'",
    #            "   AND vom02 ='",g_vom02,"'",
    #            "   AND ",p_wc1 CLIPPED,
    #            "   ORDER BY vom11,vom03,vom04,vom05 "
    #FUN-960126 MARK --END-----------------------------------------------

    #FUN-960126 ADD --STR------------------------------------------------
     CASE tm.hstatus
        WHEN 'A' 
           LET g_sql = "SELECT case when vom13 is null then 0 else vom13 end vom13, vom14, ",
                       "       vom03,vom04,vom05,vom06,vom07,vom08,vom09,vom10,vom11,vom12, ",
                       "       case when vom13 is null then 0 else vom13 end vom13a ",
                       "  FROM vom_file,ecm_file  ",
                       "  WHERE vom00 ='",g_plant,"'",  
                       "   AND vom01 ='",g_vom01,"'",
                       "   AND vom02 ='",g_vom02,"'",
                       "   AND ",p_wc1 CLIPPED,
                       "   AND vom03 = ecm01 ",
                       "   AND vom04 = ecm01 ",
                       "   AND vom05 = ecm03 ",
                       "   AND vom06 = ecm04 ",
                       "   AND ecm61 = 'N' ",
                       "   AND ecm52 = 'N' ",
                       "   AND vom12 = '0' ",
                       "   AND vom14 in ('1','2','3') ",
                       "   ORDER BY vom11,vom03,vom04,vom05 "

        WHEN 'B'
           LET g_sql = "SELECT case when vom13 is null then 0 else vom13 end vom13, vom14, ",
                       "       vom03,vom04,vom05,vom06,vom07,vom08,vom09,vom10,vom11,vom12, ",
                       "       case when vom13 is null then 0 else vom13 end vom13a ",
                       "  FROM vom_file,ecm_file  ",
                       "  WHERE vom00 ='",g_plant,"'",  
                       "   AND vom01 ='",g_vom01,"'",
                       "   AND vom02 ='",g_vom02,"'",
                       "   AND ",p_wc1 CLIPPED,
                       "   AND vom03 = ecm01 ",
                       "   AND vom04 = ecm01 ",
                       "   AND vom05 = ecm03 ",
                       "   AND vom06 = ecm04 ",
                       "   AND ecm52 = 'Y' ",
                       "   AND vom12 = '0' ",
                       "   AND vom14 in ('1','2','3') ",
                       "   ORDER BY vom11,vom03,vom04,vom05 "

        WHEN 'C'
           LET g_sql = "SELECT case when vom13 is null then 0 else vom13 end vom13, vom14, ",
                       "       vom03,vom04,vom05,vom06,vom07,vom08,vom09,vom10,vom11,vom12, ",
                       "       case when vom13 is null then 0 else vom13 end vom13a ",
                       "  FROM vom_file,ecm_file  ",
                       "  WHERE vom00 ='",g_plant,"'",  
                       "   AND vom01 ='",g_vom01,"'",
                       "   AND vom02 ='",g_vom02,"'",
                       "   AND ",p_wc1 CLIPPED,
                       "   AND vom03 = ecm01 ",
                       "   AND vom04 = ecm01 ",
                       "   AND vom05 = ecm03 ",
                       "   AND vom06 = ecm04 ",
                       "   AND ecm61 = 'Y' ",
                       "   AND vom12 = '0' ",
                       "   AND vom14 in ('1','2','3') ",
                       "   ORDER BY vom11,vom03,vom04,vom05 "
     END CASE
    #FUN-960126 ADD --END------------------------------------------------


    PREPARE t840_pb1 FROM g_sql
    DECLARE vom1_curs1 CURSOR FOR t840_pb1

    CALL g_vom1.clear()
    LET g_cnt= 1
    FOREACH vom1_curs1 INTO g_vom1[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt=g_cnt+1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_vom1.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
END FUNCTION



#一般訂單
FUNCTION t840_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   DISPLAY g_rec_b1 TO FORMONLY.cn2

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)


   DISPLAY ARRAY g_vom1 TO s_arr1.* ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #FUN-9A0042--add----str---
         IF NOT cl_null(tm.hstatus) AND tm.hstatus = 'A' THEN
             CALL cl_set_action_active("aps_btadjust",TRUE)
         ELSE
             #當選擇"B" or "C" ,讓Action "整批調整"灰階
             CALL cl_set_action_active("aps_btadjust",FALSE)
         END IF
         #FUN-9A0042--add----end---

      BEFORE ROW
         LET l_ac = ARR_CURR()


      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

     #FUN-960126 MARK --STR------------------------------------ 
     #ON ACTION detail
     #   LET g_action_choice="detail"
     #   EXIT DISPLAY
     #FUN-960126 MARK --END-----------------------------------

      ON ACTION first
         CALL t840_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b1 != 0 THEN
          CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY

      ON ACTION previous
         CALL t840_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t840_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1) 
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t840_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t840_fetch('L')
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

      #FUN-960126 ADD --STR------------
      #整批調整
      ON ACTION aps_btadjust
         LET g_action_choice="aps_btadjust"
         EXIT DISPLAY
      #FUN-960126 ADD --END-------------


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION i840_upd()
DEFINE    l_i   LIKE type_file.num5
DEFINE    l_i2  LIKE type_file.num5
   
  LET  l_i2 = 0
  FOR  l_i = 1 to g_rec_b1
    IF g_vom1[l_i].vom13=1 THEN
       LET l_i2 = l_i2 + 1
    END IF
  END FOR

  LET l_i = 1

  IF  l_i2 >0 THEN
    IF NOT cl_sure(18,20) THEN
       RETURN
    END IF

  FOR l_i = 1 TO g_rec_b1
      IF g_vom1[l_i].vom13a='0' AND  g_vom1[l_i].vom13=1 THEN
         LET l_i2 = l_i2 + 1
         UPDATE vnd_file set vnd06=g_vom1[l_i].vom08,vnd07=g_vom1[l_i].vom09,
                             vnd08=g_vom1[l_i].vom10,vnd09=g_vom1[l_i].vom11,
                             vnd10=g_vom1[l_i].vom12
           WHERE vnd01=g_vom1[l_i].vom03 AND vnd02=g_vom1[l_i].vom04
             AND vnd03=g_vom1[l_i].vom05 AND vnd04=g_vom1[l_i].vom06
             AND vnd05=g_vom1[l_i].vom07

         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vnd_file",g_vom01,g_vom02,SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
          END IF

         UPDATE vom_file SET vom13 = 1
              WHERE vom00=g_plant  #FUN-840209
                AND vom01=g_vom01
                AND vom02=g_vom02
                AND vom03=g_vom1[l_i].vom03
                AND vom04=g_vom1[l_i].vom04
                AND vom05=g_vom1[l_i].vom05
                AND vom06=g_vom1[l_i].vom06
                AND vom07=g_vom1[l_i].vom07

         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","vom_file",g_vom01,g_vom02,SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
         ELSE
            COMMIT WORK
         END IF
      END IF
  END FOR
  END IF

   IF l_i2 = 0 THEN
      CALL cl_err('','aps-709',1)
   ELSE
      CALL cl_err('',9062,1)
   END IF
 

END FUNCTION



#FUN-960126 ADD --STR------------------------
##整批調整鎖定製程時間
FUNCTION t840_btadjust()
  DEFINE i            LIKE type_file.num5
  DEFINE j            LIKE type_file.num5
  DEFINE g_msg4       LIKE ze_file.ze03
  DEFINE l_cnt        LIKE type_file.num5 #FUN-A70038 add

  LET j = 0
  FOR i = 1 TO g_cnt-1
      IF g_vom1[i].vom13 = 1 THEN
          #已異動過,不可重覆執行
          LET g_errno = 'aps-803'
          LET g_success = 'N'
          RETURN
      END IF
      CASE g_vom1[i].vom14 
          WHEN 3 #修改
               UPDATE vnd_file
                  SET vnd05 = g_vom1[i].vom07,
                      vnd06 = g_vom1[i].vom08,
                      vnd07 = g_vom1[i].vom09,
                      vnd08 = g_vom1[i].vom10,  
                      vnd09 = g_vom1[i].vom11,
                      vnd10 = g_vom1[i].vom12
                WHERE vnd01 = g_vom1[i].vom03
                  AND vnd02 = g_vom1[i].vom04
                  AND vnd03 = g_vom1[i].vom05
                  AND vnd04 = g_vom1[i].vom06
          WHEN 1 #新增
               #FUN-A70038---add------str---
               #當異動碼建議為新增時(vom14='1'),若ERP資料已存在
               #(where vnd01=vom03 and vnd02=vom04 and vnd03=vom05 and vnd04=vom06),則作update動作
               SELECT COUNT(*) INTO l_cnt 
                 FROM vnd_file
                WHERE vnd01 = g_vom1[i].vom03
                  AND vnd02 = g_vom1[i].vom04
                  AND vnd03 = g_vom1[i].vom05
                  AND vnd04 = g_vom1[i].vom06
               IF l_cnt >=1 THEN
                   UPDATE vnd_file
                      SET vnd05 = g_vom1[i].vom07,
                          vnd06 = g_vom1[i].vom08,
                          vnd07 = g_vom1[i].vom09,
                          vnd08 = g_vom1[i].vom10,  
                          vnd09 = g_vom1[i].vom11,
                          vnd10 = g_vom1[i].vom12
                    WHERE vnd01 = g_vom1[i].vom03
                      AND vnd02 = g_vom1[i].vom04
                      AND vnd03 = g_vom1[i].vom05
                      AND vnd04 = g_vom1[i].vom06
               ELSE
               #FUN-A70038---add------end---
                   INSERT INTO vnd_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd06,vnd07,vnd08,vnd09,vnd10,vnd11,
                                        vndlegal,vndplant,vnd012) #FUN-B50022 add
                     VALUES(g_vom1[i].vom03,g_vom1[i].vom04,g_vom1[i].vom05,g_vom1[i].vom06,
                            g_vom1[i].vom07,g_vom1[i].vom08,g_vom1[i].vom09,g_vom1[i].vom10,
                            g_vom1[i].vom11,g_vom1[i].vom12,'',
                            g_legal,g_plant,' ') #FUN-B50022 add
               END IF #FUN-A70038 add
          WHEN 2 #刪除
               DELETE FROM vnd_file
                WHERE vnd01 = g_vom1[i].vom03
                  AND vnd02 = g_vom1[i].vom04
                  AND vnd03 = g_vom1[i].vom05
                  AND vnd04 = g_vom1[i].vom06
      END CASE
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          #異動更新不成功
          LET g_errno = 'lib-028'
          LET g_success = 'N'
          RETURN
      ELSE
          UPDATE vom_file
             SET vom13 = 1 #是否更新，0:否 1:是
           WHERE vom00 = g_plant
             AND vom01 = g_vom01
             AND vom02 = g_vom02
             AND vom03 = g_vom1[i].vom03
             AND vom04 = g_vom1[i].vom04
             AND vom05 = g_vom1[i].vom05
             AND vom06 = g_vom1[i].vom06
             AND vom07 = g_vom1[i].vom07 
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #異動更新不成功
              LET g_errno = 'lib-028'
              LET g_success = 'N'
              RETURN
          ELSE
             #LET g_vom1[i].vom13 = '1'   
              LET j = j + 1   ## 計算成功筆數
          END IF
      END IF
  END FOR  
  #成功筆數：
  CALL cl_getmsg('anm-973',g_lang) RETURNING g_msg4
  LET g_msg4 = g_msg4,j   
  CALL cl_msgany(0,0,g_msg4)  

END FUNCTION
#FUN-960126 ADD --END------------------------

