# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apst900.4gl
# Descriptions...: 鎖定設備變更維護作業
# Input parameter:
# Date & Author..: No:FUN-870092 2008/08/15 By Mandy 
# Modify.........: No:TQC-890064 2008/09/30 By Mandy 資源項次0的部分,應該可以變更(日期),但不能刪除
# Modify.........: No:TQC-8A0013 2008/10/07 By Mandy (1)新增資源編號時,不能新增平行加工裡面已存在的資源編號
#                                                    (2)變更方式為"修改"時,資源項次無法開0的項次資料,但是"刪除"時,資源項次不能開0的項次資料
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:FUN-960105 09/07/06 By Duke 原平行加工變更為鎖定設備
# Modify.........: No:FUN-980080 09/08/20 By Mandy APS多機台鎖定功能調整
# Modify.........: No:FUN-B50020 11/05/09 By Lilan APS GP5.1追版至GP5.25---以上為GP5.1單號
# Modify.........: No:FUN-B50020 11/05/09 By Lilan APS GP5.1追版至GP5.25---以下為GP5.25單號---str---
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B50020 11/05/09 By Lilan APS GP5.1追版至GP5.25----------------------end---

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_vlk_a         RECORD LIKE vlk_file.*,   #頭 #FUN-870092
    g_vlk_a_t       RECORD LIKE vlk_file.*,
    g_snb           RECORD LIKE snb_file.*,
    g_vlk01_t       LIKE vlk_file.vlk01,
    g_vlk02_t       LIKE vlk_file.vlk02,
    g_vlk04_t       LIKE vlk_file.vlk04,
    g_vlk_b         DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
                        vlk03           LIKE vlk_file.vlk03,
                        vlk07           LIKE vlk_file.vlk07,
                       #vlk05           LIKE vlk_file.vlk05,  #FUN-960105 MARK
                        vlk06           LIKE vlk_file.vlk06,
                        vlk13b          LIKE vlk_file.vlk13b,
                        vlk14b          LIKE vlk_file.vlk14b,
                        vlk15b          LIKE vlk_file.vlk15b,
                        vlk16b          LIKE vlk_file.vlk16b,
                        vlk49b          LIKE vlk_file.vlk49b,
                        vlk50b          LIKE vlk_file.vlk50b,
                        vlk51b          LIKE vlk_file.vlk51b,
                        vlk60b          LIKE vlk_file.vlk60b, #FUN-960105 ADD
                        vlk61b          DATETIME YEAR TO MINUTE, #FUN-960015 ADD
                        vlk62b          DATETIME YEAR TO MINUTE, #FUN-960105 ADD
                        vlk13a          LIKE vlk_file.vlk13a,
                        vlk14a          LIKE vlk_file.vlk14a,
                        vlk15a          LIKE vlk_file.vlk15a,
                        vlk16a          LIKE vlk_file.vlk16a,
                        vlk49a          LIKE vlk_file.vlk49a,
                        vlk50a          LIKE vlk_file.vlk50a,
                        vlk51a          LIKE vlk_file.vlk51a,
                        vlk60a          LIKE vlk_file.vlk60a, #FUN-960105 ADD
                        vlk61a          DATETIME YEAR TO MINUTE, #FUN-960015 ADD
                        vlk62a          DATETIME YEAR TO MINUTE, #FUN-960105 ADD
                        desc            LIKE eca_file.eca02
                    END RECORD,
    g_vlk_b_t       RECORD                 #程式變數 (舊值)
                        vlk03           LIKE vlk_file.vlk03,
                        vlk07           LIKE vlk_file.vlk07,
                       #vlk05           LIKE vlk_file.vlk05, #FUN-960105 MARK
                        vlk06           LIKE vlk_file.vlk06,
                        vlk13b          LIKE vlk_file.vlk13b,
                        vlk14b          LIKE vlk_file.vlk14b,
                        vlk15b          LIKE vlk_file.vlk15b,
                        vlk16b          LIKE vlk_file.vlk16b,
                        vlk49b          LIKE vlk_file.vlk49b,
                        vlk50b          LIKE vlk_file.vlk50b,
                        vlk51b          LIKE vlk_file.vlk51b,
                        vlk60b          LIKE vlk_file.vlk60b, #FUN-960105 ADD
                        vlk61b          DATETIME YEAR TO MINUTE, #FUN-960015 ADD
                        vlk62b          DATETIME YEAR TO MINUTE, #FUN-960105 ADD
                        vlk13a          LIKE vlk_file.vlk13a,
                        vlk14a          LIKE vlk_file.vlk14a,
                        vlk15a          LIKE vlk_file.vlk15a,
                        vlk16a          LIKE vlk_file.vlk16a,
                        vlk49a          LIKE vlk_file.vlk49a,
                        vlk50a          LIKE vlk_file.vlk50a,
                        vlk51a          LIKE vlk_file.vlk51a,
                        vlk60a          LIKE vlk_file.vlk60a, #FUN-960105 ADD
                        vlk61a          DATETIME YEAR TO MINUTE, #FUN-960015 ADD
                        vlk62a          DATETIME YEAR TO MINUTE, #FUN-960105 ADD
                        desc            LIKE eca_file.eca02
                    END RECORD,
    g_wc,g_sql          STRING,
    g_wc2               STRING,
    g_argv1         LIKE vlk_file.vlk01,   #工單編號
    g_argv2         LIKE vlk_file.vlk02,   #變更序號
    g_argv3         LIKE vlk_file.vlk04,   #資源型態
    g_rec_b         LIKE type_file.num5,   #單身筆數        
    p_row,p_col     LIKE type_file.num5,   
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT  
   #g_vlk_rowid     LIKE type_file.chr18   #FUN-B50020 mark

#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL    
DEFINE g_before_input_done  LIKE type_file.num5          

DEFINE   g_cnt          LIKE type_file.num10        
DEFINE   g_i            LIKE type_file.num5         
DEFINE   g_msg          LIKE type_file.chr1000      
DEFINE   g_row_count    LIKE type_file.num10        
DEFINE   g_curs_index   LIKE type_file.num10        
DEFINE   g_jump         LIKE type_file.num10        
DEFINE   mi_no_ask      LIKE type_file.num5         
DEFINE   l_vlk61a       LIKE type_file.chr20    #FUN-960105 ADD
DEFINE   l_vlk62a       LIKE type_file.chr20    #FUN-960105 ADD



MAIN

    #FUN-B50020--mod--str--
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    #FUN-B50020--mod--end--

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
         RETURNING g_time    

   LET g_argv1 =ARG_VAL(1)              #工單編號
   LET g_argv2 =ARG_VAL(2)              #資源型態
   LET g_argv3 =ARG_VAL(3)              #製程序號
   LET g_vlk01_t = NULL
   LET g_vlk_a.vlk01 =g_argv1           #工單編號
   LET g_vlk_a.vlk02 =g_argv2           #變更序號
   LET g_vlk_a.vlk04 =g_argv3           #資源型態

   LET p_row = 3 LET p_col = 20
   OPEN WINDOW t900_w AT p_row,p_col
        WITH FORM "aps/42f/apst900"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("vlk13a,vlk13b,vlk14b,vlk14a,vlk15b,vlk15a,vlk16b,vlk16a,vlk49b,vlk49a",FALSE)
   CALL cl_set_comp_visible("dummy04,dummy05,dummy07,dummy08,dummy09",FALSE)
 
   IF NOT cl_null(g_argv1) AND
      NOT cl_null(g_argv2) AND
      NOT cl_null(g_argv3) THEN
        SELECT * INTO g_snb.*
          FROM snb_file
         WHERE snb01 = g_argv1
           AND snb02 = g_argv2
        CALL t900_q()
        LET g_vlk_a.vlk01 =g_argv1           #工單編號
        LET g_vlk_a.vlk02 =g_argv2           #變更序號
        LET g_vlk_a.vlk04 =g_argv3           #資源型態
        CALL t900_menu()
    ELSE
        CALL t900_menu()
    END IF

    CLOSE WINDOW t900_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
          RETURNING g_time  

END MAIN

#QBE 查詢資料
FUNCTION t900_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
   CLEAR FORM                             #清除畫面

   CALL g_vlk_b.clear()

 IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) THEN
     CALL cl_set_head_visible("","YES")    

     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
          vlk01,vlk02,vlk04

     BEFORE CONSTRUCT
            CALL cl_qbe_init()

     ON ACTION controlp
           CASE
              WHEN INFIELD(vlk01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  = "q_sfb"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO vlk01
                   NEXT FIELD vlk01
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 ELSE 
     DISPLAY BY NAME g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04
      LET g_wc = "     vlk01 ='",g_vlk_a.vlk01,"'",
                 " AND vlk02 =",g_vlk_a.vlk02,
                 " AND vlk04 =",g_vlk_a.vlk04
 END IF
 IF INT_FLAG THEN RETURN END IF
##資料權限的檢查
#IF g_priv2='4' THEN                           #只能使用自己的資料
#    LET g_wc = g_wc clipped," AND vlkuser = '",g_user,"'"
#END IF
#IF g_priv3='4' THEN                           #只能使用相同群的資料
#    LET g_wc = g_wc clipped," AND vlkgrup MATCHES '",g_grup CLIPPED,"*'"
#END IF

#IF g_priv3 MATCHES "[5678]" THEN    #群組權限
#    LET g_wc = g_wc clipped," AND vlkgrup IN ",cl_chk_tgrup_list()
#END IF

 IF cl_null(g_argv1) OR cl_null(g_argv2) OR cl_null(g_argv3) THEN
    #FUN-960105 MARK --STR------------------------------------------------
    #CONSTRUCT g_wc2 ON vlk03,vlk07,vlk05,vlk06,vlk13b,vlk14b,vlk15b,vlk16b,vlk49b,vlk50b,vlk51b,                # 螢幕上取單身條件 
    #                                           vlk13a,vlk14a,vlk15a,vlk16a,vlk49a,vlk50a,vlk51a                 # 螢幕上取單身條件 
    #          FROM s_vlk[1].vlk03,s_vlk[1].vlk07,s_vlk[1].vlk05,s_vlk[1].vlk06,
    #               s_vlk[1].vlk13b,s_vlk[1].vlk14b,s_vlk[1].vlk15b,s_vlk[1].vlk16b,s_vlk[1].vlk49b,s_vlk[1].vlk50b,s_vlk[1].vlk51b,
    #               s_vlk[1].vlk13a,s_vlk[1].vlk14a,s_vlk[1].vlk15a,s_vlk[1].vlk16a,s_vlk[1].vlk49a,s_vlk[1].vlk50a,s_vlk[1].vlk51a
    #FUN-960105 MARK --END----------------------------------------------- 

    #FUN-960105 ADD --STR------------------------------------------------
     CONSTRUCT g_wc2 ON vlk03,vlk07,vlk06                
               FROM s_vlk[1].vlk03,s_vlk[1].vlk07,s_vlk[1].vlk06
    #FUN-960105 ADD --END------------------------------------------------

        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)

        ON ACTION controlp
         CASE
            WHEN INFIELD(vlk06)                 #生產站別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state    = "c"
                 IF g_vlk_a.vlk04 = 0 THEN
                     LET g_qryparam.form     = "q_eca1"
                 ELSE
                     LET g_qryparam.form     = "q_eci"
                 END IF
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO vlk06
                 NEXT FIELD vlk06
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
     
        ON ACTION qbe_save
           CALL cl_qbe_save()
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
 ELSE 
     LET g_wc2 = " 1=1"
 END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
          LET g_sql = "SELECT UNIQUE vlk01,vlk02,vlk04 FROM vlk_file ",
                      " WHERE ", g_wc CLIPPED,
                      " ORDER BY vlk01,vlk02,vlk04"
    ELSE					# 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE vlk01,vlk02,vlk04 FROM vlk_file ",
                      "  FROM vlk_file ",
                      " WHERE ",g_wc  CLIPPED, 
                      "   AND ",g_wc2 CLIPPED,
                      " ORDER BY vlk01,vlk02,vlk04"
    END IF

    PREPARE t900_prepare FROM g_sql
    DECLARE t900_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t900_prepare

    LET g_forupd_sql = "SELECT * FROM vlk_file ",
                       " WHERE vlk01 = ? ",
                       "   AND vlk02 = ? ",
                       "   AND vlk04 = ? ",
                      #" FOR UPDATE NOWAIT " #FUN-B50020 mark
                       " FOR UPDATE "        #FUN-B50020 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50020 add

    DECLARE t900_cl CURSOR FROM g_forupd_sql

   LET g_sql= "SELECT vlk01,vlk02,vlk04 FROM vlk_file ",
              " WHERE ",g_wc  CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " GROUP BY vlk01,vlk02,vlk04 ",
              " INTO TEMP x "
   DROP TABLE x
   PREPARE t900_precount_x FROM g_sql
   EXECUTE t900_precount_x

   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE t900_pp FROM g_sql
   DECLARE t900_count CURSOR FOR t900_pp

END FUNCTION

FUNCTION t900_menu()

   WHILE TRUE
      CALL t900_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t900_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t900_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vlk_b),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_vlk_a.vlk01 IS NOT NULL THEN
                LET g_doc.column1 = "vlk01"
                LET g_doc.column2 = "vlk02"
                LET g_doc.column3 = "vlk04"
                LET g_doc.value1 = g_vlk_a.vlk01
                LET g_doc.value2 = g_vlk_a.vlk02
                LET g_doc.value3 = g_vlk_a.vlk04
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION

#Query 查詢
FUNCTION t900_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_vlk_b.clear()
    CALL t900_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN t900_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_vlk_a.* TO NULL
    ELSE
        CALL t900_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN t900_count
        FETCH t900_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION t900_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680073 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     t900_cs INTO g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04
        WHEN 'P' FETCH PREVIOUS t900_cs INTO g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04
        WHEN 'F' FETCH FIRST    t900_cs INTO g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04
        WHEN 'L' FETCH LAST     t900_cs INTO g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t900_cs INTO g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vlk_a.vlk01,SQLCA.sqlcode,0)
        INITIALIZE g_vlk_a.* TO NULL  
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
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vlk_file",g_vlk_a.vlk01,g_vlk_a.vlk02,SQLCA.sqlcode,"","",1) 
        INITIALIZE g_vlk_a.* TO NULL
        RETURN
    ELSE
       #LET g_data_owner = g_vlk_a.vlkuser      
       #LET g_data_group = g_vlk_a.vlkgrup     
        CALL t900_show()
    END IF
END FUNCTION

#將資料顯示在畫面上
FUNCTION t900_show()
    DEFINE l_ecm04    LIKE ecm_file.ecm04
    DEFINE l_ecm45    LIKE ecm_file.ecm45


    LET g_vlk_a_t.* = g_vlk_a.*            #保存單頭舊值
    DISPLAY BY NAME                        #顯示單頭值
        g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04

    LET l_ecm04 = ''
    LET l_ecm45 = ''
    SELECT ecm04,ecm45 
      INTO l_ecm04,l_ecm45
      FROM ecm_file
     WHERE ecm01 = g_vlk_a.vlk01
       AND ecm03 = g_vlk_a.vlk03
   #DISPLAY l_ecm04,l_ecm45 TO ecm04,ecm45

    CALL t900_b_fill(g_wc2)                 #單身

    CALL cl_show_fld_cont()                   
END FUNCTION
#單身
FUNCTION t900_b()
DEFINE l_ecm        RECORD LIKE ecm_file.*
DEFINE l_cnt        LIKE type_file.num5   
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT       
    l_n             LIKE type_file.num5,    #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否       
    p_cmd           LIKE type_file.chr1,    #處理狀態        
    l_allow_insert  LIKE type_file.num5,    #可新增否       
    l_allow_delete  LIKE type_file.num5     #可刪除否      

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF

   #IF cl_null(g_vlk_a.vlk01) OR cl_null(g_vlk_a.vlk02) OR cl_null(g_vlk_a.vlk04) THEN
   #    RETURN
   #END IF
    IF g_snb.snbconf = 'Y' THEN
        #此工單變更已發出 !!
        CALL cl_err('','asf-061',1) RETURN
    END IF

    CALL cl_opmsg('b')

    #FUN-960105 MARK --STR------------------------------------------------
    #LET g_forupd_sql = "SELECT vlk03,vlk07,vlk05,vlk06, ",
    #                   "       vlk13b,vlk14b,vlk15b,vlk16b,vlk49b,vlk50b,vlk51b, ",
    #                   "       vlk13a,vlk14a,vlk15a,vlk16a,vlk49a,vlk50a,vlk51a  ",
    #                   " FROM vlk_file ",
    #                   " WHERE vlk01 = ? ",
    #                   "   AND vlk02 = ? ",
    #                   "   AND vlk04 = ? ",
    #                   "   AND vlk03 = ? ",
    #                   "   AND vlk05 = ? ",
    #                   " FOR UPDATE NOWAIT "
    #FUN-960105 MARK --END------------------------------------------------

    #FUN-960105 ADD --STR-------------------------------------------------
    LET g_forupd_sql = "SELECT vlk03,vlk07,vlk06, ",
                       "       vlk13b,vlk14b,vlk15b,vlk16b,vlk49b,vlk50b,vlk51b,vlk60b,vlk61b,vlk62b, ",
                       "       vlk13a,vlk14a,vlk15a,vlk16a,vlk49a,vlk50a,vlk51a,vlk60a,vlk61a,vlk62a  ",
                       " FROM vlk_file ",
                       " WHERE vlk01 = ? ",
                       "   AND vlk02 = ? ",
                       "   AND vlk04 = ? ",
                       "   AND vlk03 = ? ",
                       "   AND vlk06 = ? ",
                      #" FOR UPDATE NOWAIT " #FUN-B50020 mark
                       " FOR UPDATE "        #FUN-B50020 add
    #FUN-960105 ADD --END-------------------------------------------------
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50020 add

    DECLARE t900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_vlk_b WITHOUT DEFAULTS FROM s_vlk.*
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

            BEGIN WORK

           #OPEN t900_cl USING g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04
           #IF STATUS THEN
           #   CALL cl_err("OPEN t900_cl_b1", STATUS, 1)
           #   CLOSE t900_cl
           #   ROLLBACK WORK
           #   RETURN
           #END IF

           #FETCH t900_cl INTO g_vlk_a.*   # 鎖住將被更改或取消的資料
           #IF SQLCA.sqlcode THEN
           #   CALL cl_err('Fetch t900_cl_b2',SQLCA.sqlcode,1)
           #   CLOSE t900_cl
           #   ROLLBACK WORK
           #   RETURN
           #END IF

            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_vlk_b_t.* = g_vlk_b[l_ac].*  #BACKUP

              #FUN-960105 MARK --STR------------------------------------------
              # OPEN t900_bcl USING g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04,
              #                     g_vlk_b_t.vlk03,g_vlk_b_t.vlk05
              #FUN-960105 MARK --END------------------------------------------

              #FUN-960105 ADD --STR-------------------------------------------
               OPEN t900_bcl USING g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04,
                                   g_vlk_b_t.vlk03,g_vlk_b_t.vlk06
              #FUN-960105 ADD --END-------------------------------------------

               IF STATUS THEN
                  CALL cl_err("OPEN t900_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t900_bcl INTO g_vlk_b[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('Fetch t900_bcl',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      LET g_vlk_b_t.*=g_vlk_b[l_ac].*
                  END IF
               END IF
               CALL cl_show_fld_cont()     
             END IF
             CALL t900_set_entry_b(p_cmd)    
             CALL t900_set_no_entry_b(p_cmd) 
             CALL t900_set_no_required()
             CALL t900_set_required()

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_vlk_b[l_ac].* TO NULL   
            LET g_vlk_b[l_ac].vlk07 =  '1' #新增            #Body default
            LET g_vlk_b_t.* = g_vlk_b[l_ac].*                  #新輸入資料
            CALL cl_show_fld_cont() 
            NEXT FIELD vlk03

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF

            #FUN-960105 ADD --STR--------------------------------------------
            IF l_ecm.ecm61 = 'Y' AND g_vlk_b[l_ac].vlk07 = '1' THEN #新增 #FUN-980080 mod
                SELECT COUNT(*) INTO l_cnt 
                  FROM vne_file
                 WHERE vne01 = g_vlk_a.vlk01
                   AND vne02 = g_vlk_a.vlk01
                   AND vne03 = g_vlk_a.vlk03
                   AND vne05 = g_vlk_a.vlk06
               
                IF l_cnt >0 THEN
                   CALL cl_err('','aps-773',1)
                   CANCEL INSERT
                END IF 
            END IF
            #FUN-960105 ADD --END--------------------------------------------

            #FUN-960105 MARK --STR-------------------------------------------
            #INSERT INTO vlk_file(vlk01,vlk02,vlk04,
            #                     vlk03,vlk05,vlk06,vlk07,
            #                     vlk13b,vlk14b,vlk15b,vlk16b,vlk49b,vlk50b,vlk51b,
            #                     vlk13a,vlk14a,vlk15a,vlk16a,vlk49a,vlk50a,vlk51a)
            #               VALUES(g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04,
            #                      g_vlk_b[l_ac].vlk03,g_vlk_b[l_ac].vlk05,
            #                      g_vlk_b[l_ac].vlk06,g_vlk_b[l_ac].vlk07,
            #                      g_vlk_b[l_ac].vlk13b,g_vlk_b[l_ac].vlk14b,
            #                      g_vlk_b[l_ac].vlk15b,g_vlk_b[l_ac].vlk16b,
            #                      g_vlk_b[l_ac].vlk49b,g_vlk_b[l_ac].vlk50b,
            #                      g_vlk_b[l_ac].vlk51b,
            #                      g_vlk_b[l_ac].vlk13a,g_vlk_b[l_ac].vlk14a,
            #                      g_vlk_b[l_ac].vlk15a,g_vlk_b[l_ac].vlk16a,
            #                      g_vlk_b[l_ac].vlk49a,g_vlk_b[l_ac].vlk50a,
            #                      g_vlk_b[l_ac].vlk51a)
            #FUN-960105 MARK --END--------------------------------------------
            
            #FUN-960105 ADD --STR---------------------------------------------
            INSERT INTO vlk_file(vlk01,vlk02,vlk04,
                                 vlk03,vlk05,vlk06,vlk07,
                                 vlk50b,vlk50a,
                                 vlk51b,vlk51a,
                                 vlk60b,vlk60a,
                                 vlk61b,vlk62b,
                                 vlklegal,vlkplant) #FUN-B50020 add legal,plant
                           VALUES(g_vlk_a.vlk01,g_vlk_a.vlk02,g_vlk_a.vlk04,
                                  g_vlk_b[l_ac].vlk03,0,
                                  g_vlk_b[l_ac].vlk06,g_vlk_b[l_ac].vlk07,
                                  g_vlk_b[l_ac].vlk50b,g_vlk_b[l_ac].vlk50a,
                                  g_vlk_b[l_ac].vlk51b,g_vlk_b[l_ac].vlk51a,
                                  g_vlk_b[l_ac].vlk60b,
                                  g_vlk_b[l_ac].vlk60a,
                                  g_vlk_b[l_ac].vlk61b,
                                  g_vlk_b[l_ac].vlk62b,
                                  g_legal,g_plant ) #FUN-B50020 add legal,plant
            #FUN-960105 ADD --END---------------------------------------------        

            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","vlk_file",g_vlk_a.vlk01,g_vlk_a.vlk02,SQLCA.sqlcode,"","",1)
                CANCEL INSERT
            ELSE
                #FUN-960105 ADD --STR-----------------------------------
                 LET l_vlk61a = g_vlk_b[l_ac].vlk61a
                 LET l_vlk62a = g_vlk_b[l_ac].vlk62a
                 IF NOT cl_null(g_vlk_b[l_ac].vlk61a) AND
                    l_vlk61a[1,4]<>'0000' THEN
                    UPDATE vlk_file
                       SET vlk61a = g_vlk_b[l_ac].vlk61a
                     WHERE vlk01=g_vlk_a.vlk01
                       AND vlk02=g_vlk_a.vlk02
                       AND vlk04=g_vlk_a.vlk04
                       AND vlk03=g_vlk_b[l_ac].vlk03
                       AND vlk06=g_vlk_b[l_ac].vlk06
                 END IF
                 IF l_vlk61a[1,4]='0000' THEN 
                   UPDATE vlk_file
                      SET vlk61a = NULL
                    WHERE vlk01=g_vlk_a.vlk01
                      AND vlk02=g_vlk_a.vlk02
                      AND vlk04=g_vlk_a.vlk04
                      AND vlk03=g_vlk_b[l_ac].vlk03
                      AND vlk06=g_vlk_b[l_ac].vlk06
                 END IF
                 IF NOT cl_null(g_vlk_b[l_ac].vlk62a) AND
                    l_vlk62a[1,4]<>'0000' THEN
                    UPDATE vlk_file
                       SET vlk62a = g_vlk_b[l_ac].vlk62a
                     WHERE vlk01=g_vlk_a.vlk01
                       AND vlk02=g_vlk_a.vlk02
                       AND vlk04=g_vlk_a.vlk04
                       AND vlk03=g_vlk_b[l_ac].vlk03
                       AND vlk06=g_vlk_b[l_ac].vlk06
                 END IF 
                 IF l_vlk62a[1,4]='0000' THEN
                    UPDATE vlk_file
                       SET vlk62a = NULL
                     WHERE vlk01=g_vlk_a.vlk01
                       AND vlk02=g_vlk_a.vlk02
                       AND vlk04=g_vlk_a.vlk04
                       AND vlk03=g_vlk_b[l_ac].vlk03
                       AND vlk06=g_vlk_b[l_ac].vlk06
                 END IF
 
                #FUN-960105 ADD --END-----------------------------------
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        #FUN-960105 ADD --STR-----------------------------------------------
        AFTER FIELD vlk60a
          IF g_vlk_b[l_ac].vlk07 ='1' OR g_vlk_b[l_ac].vlk07 ='3' THEN
             IF g_vlk_b[l_ac].vlk60a = '1'  THEN
                CALL cl_set_comp_entry("vlk61a,vk62a",TRUE)
                CALL cl_set_comp_required("vlk61a",TRUE)
                CALL cl_set_comp_required("vlk62a",FALSE)
             ELSE
                IF g_vlk_b[l_ac].vlk60a = '2'  THEN
                   CALL cl_set_comp_entry("vlk61a,vk62a",TRUE)
                   CALL cl_set_comp_required("vlk62a",TRUE)
                   CALL cl_set_comp_required("vlk61a",FALSE)
                ELSE 
                   IF g_vlk_b[l_ac].vlk60a = '3'  THEN
                      CALL cl_set_comp_entry("vlk61a,vk62a",TRUE)
                      CALL cl_set_comp_required("vlk61a,vlk62a",TRUE)
                   ELSE
                      CALL cl_set_comp_entry("vlk61a,vk62a",TRUE)
                      CALL cl_set_comp_required("vlk61a,vlk62a",FALSE)
                   END IF 
                END IF
             END IF
           END IF

        BEFORE FIELD vlk61a
          #由於日期格式不接受null值,故以 0000-01-01 00:00 表示NULL值
          IF cl_null(g_vlk_b[l_ac].vlk61a) AND
             (g_vlk_b[l_ac].vlk07='1' OR g_vlk_b[l_ac].vlk07='2')  THEN
             LET g_vlk_b[l_ac].vlk61a = '0000-01-01 00:00'
          END IF
          LET l_vlk61a = g_vlk_b[l_ac].vlk61a           

        BEFORE FIELD vlk62a
          #由於日期格式不接受null值,故以 0000-01-01 00:00 表示NULL值 
          IF cl_null(g_vlk_b[l_ac].vlk62a) AND
             (g_vlk_b[l_ac].vlk07='1' OR g_vlk_b[l_ac].vlk07='2')  THEN
             LET g_vlk_b[l_ac].vlk62a = '0000-01-01 00:00'
          END IF
          LET l_vlk62a = g_vlk_b[l_ac].vlk62a

        AFTER FIELD vlk61a
          IF g_vlk_b[l_ac].vlk60a MATCHES '[13]' AND
             (cl_null(g_vlk_b[l_ac].vlk61a) OR g_vlk_b[l_ac].vlk60a='0000-01-01 00:00') THEN
             LET g_vlk_b[l_ac].vlk61a = l_vlk61a CLIPPED
             NEXT FIELD vlk61a
          END IF
        AFTER FIELD vlk62a
          IF g_vlk_b[l_ac].vlk60a MATCHES '[23]' AND
             (cl_null(g_vlk_b[l_ac].vlk62a) OR g_vlk_b[l_ac].vlk60a='0000-01-01 00:00') THEN
             LET g_vlk_b[l_ac].vlk62a = l_vlk62a CLIPPED
             NEXT FIELD vlk62a
         END IF
        #FUN-960105 ADD --END-----------------------------------------------


 
        BEFORE FIELD vlk07 #變更方式
            CALL t900_set_entry_b(p_cmd)
        AFTER FIELD vlk07 #變更方式
            IF NOT cl_null(g_vlk_b[l_ac].vlk07) THEN
                IF g_vlk_b[l_ac].vlk03 != g_vlk_b_t.vlk03 OR cl_null(g_vlk_b_t.vlk03) THEN
                    IF g_vlk_b[l_ac].vlk07 = '1' THEN #新增
                        #==>將一些欄位清空
                        LET g_vlk_b[l_ac].vlk06  = NULL
                        LET g_vlk_b[l_ac].desc   = NULL
                        LET g_vlk_b[l_ac].vlk13b = NULL
                        LET g_vlk_b[l_ac].vlk14b = NULL
                        LET g_vlk_b[l_ac].vlk15b = NULL
                        LET g_vlk_b[l_ac].vlk16b = NULL
                        LET g_vlk_b[l_ac].vlk49b = NULL
                        LET g_vlk_b[l_ac].vlk50b = NULL
                        LET g_vlk_b[l_ac].vlk51b = NULL
                        DISPLAY BY NAME g_vlk_b[l_ac].vlk06,g_vlk_b[l_ac].desc,
                                        g_vlk_b[l_ac].vlk13b,g_vlk_b[l_ac].vlk14b,g_vlk_b[l_ac].vlk15b,g_vlk_b[l_ac].vlk16b,
                                        g_vlk_b[l_ac].vlk49b,g_vlk_b[l_ac].vlk50b,g_vlk_b[l_ac].vlk51b
                        #FUN-960105 MARK --STR-------------------------------
                        ##==>default資源項次
                        #SELECT MAX(vlk05) + 1 
                        #  INTO g_vlk_b[l_ac].vlk05
                        #  FROM vlk_file
                        # WHERE vlk01 = g_vlk_a.vlk01
                        #   AND vlk02 = g_vlk_a.vlk02
                        #   AND vlk04 = g_vlk_a.vlk04
                        #   AND vlk03 = g_vlk_b[l_ac].vlk03
                        #   AND vlk07 = g_vlk_b[l_ac].vlk07
                        #IF cl_null(g_vlk_b[l_ac].vlk05) THEN
                        #    SELECT MAX(vlj05) + 1
                        #      INTO g_vlk_b[l_ac].vlk05
                        #      FROM vlj_file
                        #     WHERE vlj01 = g_vlk_a.vlk01
                        #       AND vlj02 = g_vlk_a.vlk04
                        #       AND vlj03 = g_vlk_b[l_ac].vlk03
                        #    IF cl_null(g_vlk_b[l_ac].vlk05) THEN
                        #        LET g_vlk_b[l_ac].vlk05 = 1
                        #    END IF
                        #END IF
                        #FUN-960105 MARK --END-------------------------------
                    END IF
                END IF
            END IF
            CALL t900_set_no_entry_b(p_cmd)
            CALL t900_set_no_required()
            CALL t900_set_required()

        AFTER FIELD vlk06                  
            IF NOT cl_null(g_vlk_b[l_ac].vlk07) AND 
              #g_vlk_b[l_ac].vlk07 = '1'        AND #新增   #FUN-980080 mark
               NOT cl_null(g_vlk_b[l_ac].vlk06) THEN
                IF g_vlk_b[l_ac].vlk03 != g_vlk_b_t.vlk03 OR cl_null(g_vlk_b_t.vlk03) THEN
                    IF g_vlk_a.vlk04 = 0 THEN 
                        #工作站
                        CALL t900_vlk06_0(l_ac)
                       #FUN-980080 mark--str---
                       #IF l_ecm.ecm06 = g_vlk_b[l_ac].vlk06 THEN
                       #    #不可與原製程追蹤檔的資源編號(工作站/機器編號)相同,請重新輸入!
                       #    LET g_errno = 'aps-018'
                       #END IF
                       #FUN-980080 mark--end---
                    ELSE
                        #機器編號
                        CALL t900_vlk06_1(l_ac)
                       #FUN-980080 mark--str---
                       #IF l_ecm.ecm05 = g_vlk_b[l_ac].vlk06 THEN
                       #    #不可與原製程追蹤檔的資源編號(工作站/機器編號)相同,請重新輸入!
                       #    LET g_errno = 'aps-018'
                       #END IF
                       #FUN-980080 mark--end---
                    END IF
                    #FUN-960105 MARK --STR---------------------------------
                    ##TQC-8A0013---add---str---
                    #IF l_ecm.ecm61 = 'Y' THEN
                    #    SELECT COUNT(*) INTO l_cnt
                    #      FROM vlj_file
                    #     WHERE vlj01 = g_vlk_a.vlk01
                    #       AND vlj02 = g_vlk_a.vlk04
                    #       AND vlj03 = g_vlk_b[l_ac].vlk03
                    #       AND vlj06 = g_vlk_b[l_ac].vlk06
                    #    IF l_cnt >= 1 THEN
                    #        #不能新增平行加工內已存在的資源編號!
                    #        LET g_errno = 'aps-028'
                    #    END IF
                    #END IF
                    ##TQC-8A0013---add---end---
                    #FUN-960105 MARK --END--------------------------------

                    #FUN-960105 ADD --STR---------------------------------
                    #FUN-980080 mod---str----
                    LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt
                      FROM vne_file
                     WHERE vne01 = g_vlk_a.vlk01
                       AND vne02 = g_vlk_a.vlk01
                       AND vne03 = g_vlk_b[l_ac].vlk03
                       AND vne05 = g_vlk_b[l_ac].vlk06
                    IF g_vlk_b[l_ac].vlk07 = '1' THEN #新增 #FUN-980080 mod
                        IF l_cnt >= 1 THEN
                            #不能新增鎖定設備內已存在的資源編號!
                            LET g_errno = 'aps-773'
                        END IF
                    ELSE
                        IF l_cnt <= 0 THEN
                            #需調整鎖定設備內已存在的資源編號!
                            LET g_errno = 'aps-800'
                        END IF
                    END IF
                    #FUN-980080 mod---end----
                    #FUN-960105 ADD --END--------------------------------- 

                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err('vlk06:',g_errno,1)
                        LET g_vlk_b[l_ac].vlk06 = g_vlk_b_t.vlk06
                        DISPLAY BY NAME g_vlk_b[l_ac].vlk06
                        NEXT FIELD vlk06
                    END IF
                    SELECT COUNT(*) INTO l_cnt
                      FROM vlk_file
                     WHERE vlk01 = g_vlk_a.vlk01
                       AND vlk02 = g_vlk_a.vlk02
                       AND vlk04 = g_vlk_a.vlk04
                       AND vlk03 = g_vlk_b[l_ac].vlk03
                       AND vlk06 = g_vlk_b[l_ac].vlk06
                    IF l_cnt >= 1 THEN
                        CALL cl_err('','-239',1)
                        LET g_vlk_b[l_ac].vlk06 = g_vlk_b_t.vlk06
                        DISPLAY BY NAME g_vlk_b[l_ac].vlk06
                        NEXT FIELD vlk06
                    END IF
                    #FUN-980080---add----str---
                    IF g_vlk_b[l_ac].vlk07 MATCHES '[23]' THEN
                        LET g_vlk_b[l_ac].vlk50b = l_ecm.ecm50
                        LET g_vlk_b[l_ac].vlk51b = l_ecm.ecm51
                        DISPLAY BY NAME g_vlk_b[l_ac].vlk50b,g_vlk_b[l_ac].vlk51b
                        LET l_cnt = 0 
                        SELECT COUNT(*) INTO l_cnt
                          FROM vnd_file
                         WHERE  vnd01 = g_vlk_a.vlk01
                           AND  vnd03 = g_vlk_b[l_ac].vlk03
                           AND  vnd05 = g_vlk_b[l_ac].vlk06
                        IF l_cnt >= 1 THEN
                            SELECT vnd06,vnd07,vnd08 
                              INTO g_vlk_b[l_ac].vlk60b,g_vlk_b[l_ac].vlk61b,g_vlk_b[l_ac].vlk62b
                              FROM vnd_file
                             WHERE  vnd01 = g_vlk_a.vlk01
                               AND  vnd03 = g_vlk_b[l_ac].vlk03
                               AND  vnd05 = g_vlk_b[l_ac].vlk06
                            DISPLAY BY NAME g_vlk_b[l_ac].vlk60b,g_vlk_b[l_ac].vlk61b,g_vlk_b[l_ac].vlk62b
                        END IF
                         
                    END IF
                    #FUN-980080---add----end---
                END IF
            END IF
        AFTER FIELD vlk03 #製程序號
            IF NOT cl_null(g_vlk_b[l_ac].vlk03) THEN
                IF g_vlk_b[l_ac].vlk03 != g_vlk_b_t.vlk03 OR cl_null(g_vlk_b_t.vlk03) THEN
                    SELECT COUNT(*) INTO l_cnt
                      FROM ecm_file
                     WHERE ecm01 = g_vlk_a.vlk01
                       AND ecm03 = g_vlk_b[l_ac].vlk03
                    IF l_cnt <= 0 THEN
                        #本單之工單編號無此製程序號,請重新輸入!
                        CALL cl_err(g_vlk_a.vlk01,'aec-085',1) 
                        LET g_vlk_b[l_ac].vlk03 = g_vlk_b_t.vlk03
                        DISPLAY BY NAME g_vlk_b[l_ac].vlk03
                        NEXT FIELD vlk03
                    END IF

                    #==>已有生產日報資料,不可做變更!
                    SELECT * INTO l_ecm.*
                      FROM ecm_file
                     WHERE ecm01 = g_vlk_a.vlk01
                       AND ecm03 = g_vlk_b[l_ac].vlk03
                    IF l_ecm.ecm311 >= 1 THEN
                        #已有生產日報資料,不可變更!
                        CALL cl_err('','aps-020',1)
                        LET g_vlk_b[l_ac].vlk03 = g_vlk_b_t.vlk03
                        DISPLAY BY NAME g_vlk_b[l_ac].vlk03
                        NEXT FIELD vlk03
                    END IF
                END IF
            END IF
        ON CHANGE vlk03 #製程序號
           #IF NOT cl_null(g_vlk_b[l_ac].vlk05) AND  #FUN-960105 MARK
            IF NOT cl_null(g_vlk_b[l_ac].vlk03) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vlk_file
                 WHERE vlk01 = g_vlk_a.vlk01
                   AND vlk02 = g_vlk_a.vlk02
                   AND vlk04 = g_vlk_a.vlk04
                   AND vlk03 = g_vlk_b[l_ac].vlk03
                  #AND vlk05 = g_vlk_b[l_ac].vlk05  #FUN-960105 MARK
                   AND vlk06 = g_vlk_b[l_ac].vlk06  #FUN-960105 ADD
                IF l_cnt >= 1 THEN
                    CALL cl_err('','-239',1)
                    LET g_vlk_b[l_ac].vlk03 = g_vlk_b_t.vlk03
                    DISPLAY BY NAME g_vlk_b[l_ac].vlk03
                    NEXT FIELD vlk03
                END IF
            END IF
        #FUN-960105 MARK --STR----------------------------------
        #ON CHANGE vlk05 #資源項次
        #    IF NOT cl_null(g_vlk_b[l_ac].vlk05) AND 
        #       NOT cl_null(g_vlk_b[l_ac].vlk03) THEN
        #        SELECT COUNT(*) INTO l_cnt
        #          FROM vlk_file
        #         WHERE vlk01 = g_vlk_a.vlk01
        #           AND vlk02 = g_vlk_a.vlk02
        #           AND vlk04 = g_vlk_a.vlk04
        #           AND vlk03 = g_vlk_b[l_ac].vlk03
        #           AND vlk05 = g_vlk_b[l_ac].vlk05
        #        IF l_cnt >= 1 THEN
        #            CALL cl_err('','-239',1)
        #            LET g_vlk_b[l_ac].vlk05 = g_vlk_b_t.vlk05
        #            DISPLAY BY NAME g_vlk_b[l_ac].vlk05
        #            NEXT FIELD vlk05
        #        END IF
        #    END IF
        #AFTER FIELD vlk05 #資源項次
        #    IF NOT cl_null(g_vlk_b[l_ac].vlk05) AND 
        #       NOT cl_null(g_vlk_b[l_ac].vlk03) AND 
        #       NOT cl_null(g_vlk_b[l_ac].vlk07) AND
        #       g_vlk_b[l_ac].vlk07 <> '1' THEN
        #        IF g_vlk_b[l_ac].vlk03 != g_vlk_b_t.vlk03 OR cl_null(g_vlk_b_t.vlk03) THEN
        #            #TQC-890064---mod----str----
        #            IF g_vlk_b[l_ac].vlk05 = 0 AND g_vlk_b[l_ac].vlk07 = '2' THEN #刪除
        #                    #項次為0的資料不可刪除!
        #                    CALL cl_err('','aps-027',1)
        #                    LET g_vlk_b[l_ac].vlk05 = g_vlk_b_t.vlk05
        #                    DISPLAY BY NAME g_vlk_b[l_ac].vlk05
        #                    NEXT FIELD vlk05
        #            END IF
        #            SELECT COUNT(*) INTO l_cnt
        #              FROM vlj_file
        #             WHERE vlj01 = g_vlk_a.vlk01
        #               AND vlj02 = g_vlk_a.vlk04
        #               AND vlj03 = g_vlk_b[l_ac].vlk03
        #               AND vlj05 = g_vlk_b[l_ac].vlk05
        #            IF l_cnt <= 0 THEN
        #                IF g_vlk_b[l_ac].vlk05 = 0 THEN
        #                    IF g_vlk_b[l_ac].vlk07 = '2' THEN #刪除
        #                        #項次為0的資料不可刪除!
        #                        CALL cl_err('','aps-027',1)
        #                        LET g_vlk_b[l_ac].vlk05 = g_vlk_b_t.vlk05
        #                        DISPLAY BY NAME g_vlk_b[l_ac].vlk05
        #                        NEXT FIELD vlk05
        #                    ELSE
        #                        IF g_sma.sma917 = 0 THEN
        #                           #工作站
        #                           SELECT ecm06,ecm50,ecm51 
        #                             INTO g_vlk_b[l_ac].vlk06,g_vlk_b[l_ac].vlk50b,g_vlk_b[l_ac].vlk51b
        #                             FROM ecm_file
        #                            WHERE ecm01 = g_vlk_a.vlk01
        #                              AND ecm03 = g_vlk_b[l_ac].vlk03
        #                            CALL t900_vlk06_0(l_ac) #工作站
        #                        ELSE
        #                           #機器編號
        #                           SELECT ecm05,ecm50,ecm51
        #                             INTO g_vlk_b[l_ac].vlk06,g_vlk_b[l_ac].vlk50b,g_vlk_b[l_ac].vlk51b
        #                             FROM ecm_file
        #                            WHERE ecm01 = g_vlk_a.vlk01
        #                              AND ecm03 = g_vlk_b[l_ac].vlk03
        #                           CALL t900_vlk06_1(l_ac) #機器編號
        #                        END IF
        #                    END IF
        #                ELSE
        #                    LET g_msg = 'Key:',g_vlk_a.vlk01 CLIPPED,' + ',
        #                                       g_vlk_a.vlk04 CLIPPED,' + ',
        #                                       g_vlk_b[l_ac].vlk03 CLIPPED,' + ',
        #                                       g_vlk_b[l_ac].vlk05 CLIPPED
        #                    #輸入資料不存在！請重新輸入
        #                    CALL cl_err(g_msg,'aic-004',1)
        #                    LET g_vlk_b[l_ac].vlk05 = g_vlk_b_t.vlk05
        #                    DISPLAY BY NAME g_vlk_b[l_ac].vlk05
        #                    NEXT FIELD vlk05
        #                END IF
        #            #TQC-890064---mod----end----
        #            ELSE
        #                SELECT vlj06,vlj13,vlj14,vlj15,vlj16,vlj49,vlj50,vlj51
        #                  INTO g_vlk_b[l_ac].vlk06,g_vlk_b[l_ac].vlk13b,g_vlk_b[l_ac].vlk14b,g_vlk_b[l_ac].vlk15b,g_vlk_b[l_ac].vlk16b,
        #                       g_vlk_b[l_ac].vlk49b,g_vlk_b[l_ac].vlk50b,g_vlk_b[l_ac].vlk51b
        #                  FROM vlj_file
        #                 WHERE vlj01 = g_vlk_a.vlk01
        #                   AND vlj02 = g_vlk_a.vlk04
        #                   AND vlj03 = g_vlk_b[l_ac].vlk03
        #                   AND vlj05 = g_vlk_b[l_ac].vlk05
        #                IF g_vlk_a.vlk04 = 0 THEN 
        #                    #工作站
        #                    CALL t900_vlk06_0(l_ac)
        #                ELSE
        #                    #機器編號
        #                    CALL t900_vlk06_1(l_ac)
        #                END IF
        #                DISPLAY BY NAME g_vlk_b[l_ac].vlk06,g_vlk_b[l_ac].vlk13b,g_vlk_b[l_ac].vlk14b,g_vlk_b[l_ac].vlk15b,g_vlk_b[l_ac].vlk16b,
        #                                g_vlk_b[l_ac].vlk49b,g_vlk_b[l_ac].vlk50b,g_vlk_b[l_ac].vlk51b
        #            END IF
        #        END IF
        #    END IF
        #FUN-960105 MARK --END--------------------------------------------

        AFTER FIELD vlk13b                                                                                                           
            IF NOT cl_null(g_vlk_b[l_ac].vlk13b) THEN
                IF g_vlk_b[l_ac].vlk13b<0 THEN                                                                                               
                   CALL cl_err('','aec-992',1) #此欄位不可為負數
                   NEXT FIELD vlk13b                                                                                                  
                END IF
            END IF

        AFTER FIELD vlk14b                                                                                                           
            IF NOT cl_null(g_vlk_b[l_ac].vlk14b) THEN
                IF g_vlk_b[l_ac].vlk14b<0 THEN                                                                                               
                   CALL cl_err('','aec-992',1) #此欄位不可為負數
                   NEXT FIELD vlk14b                                                                                                  
                END IF
            END IF

        AFTER FIELD vlk15b                                                                                                           
            IF NOT cl_null(g_vlk_b[l_ac].vlk15b) THEN
                IF g_vlk_b[l_ac].vlk15b<0 THEN                                                                                               
                   CALL cl_err('','aec-992',1) #此欄位不可為負數
                   NEXT FIELD vlk15b                                                                                                  
                END IF
            END IF

        AFTER FIELD vlk16b                                                                                                           
            IF NOT cl_null(g_vlk_b[l_ac].vlk16b) THEN
                IF g_vlk_b[l_ac].vlk16b<0 THEN                                                                                               
                   CALL cl_err('','aec-992',1) #此欄位不可為負數
                   NEXT FIELD vlk16b                                                                                                  
                END IF
            END IF

        AFTER FIELD vlk49b                                                                                                           
            IF NOT cl_null(g_vlk_b[l_ac].vlk49b) THEN
                IF g_vlk_b[l_ac].vlk49b<0 THEN                                                                                               
                   CALL cl_err('','aec-992',1) #此欄位不可為負數
                   NEXT FIELD vlk49b                                                                                                  
                END IF
            END IF

        AFTER FIELD vlk51b
           IF NOT cl_null(g_vlk_b[l_ac].vlk50b) AND NOT cl_null(g_vlk_b[l_ac].vlk51b) AND g_vlk_b[l_ac].vlk07 = '1' THEN #新增
               IF g_vlk_b[l_ac].vlk51b<g_vlk_b[l_ac].vlk50b THEN
                  CALL cl_err('','aec-993',1) #完工日期不可小於開工日期
                  NEXT FIELD vlk51b
               END IF
           END IF

        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_vlk_b_t.vlk03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM vlk_file
                 WHERE vlk01 = g_vlk_a.vlk01 
                   AND vlk02 = g_vlk_a.vlk02
                   AND vlk04 = g_vlk_a.vlk04 
                   AND vlk03 = g_vlk_b_t.vlk03
                  #AND vlk05 = g_vlk_b_t.vlk05  #FUN-960105 MARK
                   AND vlk06 = g_vlk_b_t.vlk06  #FUN-960106 ADD
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","vlk_file",g_vlk_a.vlk01,g_vlk_a.vlk02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF

                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
             END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_vlk_b[l_ac].* = g_vlk_b_t.*
               CLOSE t900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
              #CALL cl_err(g_vlk_b[l_ac].vlk05,-263,1)  #FUN-960105 MARK
               CALL cl_err(g_vlk_b[l_ac].vlk06,-263,1)  #FUN-960105 ADD
               LET g_vlk_b[l_ac].* = g_vlk_b_t.*
            ELSE
               UPDATE vlk_file 
                  SET 
                      vlk03=g_vlk_b[l_ac].vlk03,
                      vlk07=g_vlk_b[l_ac].vlk07,
                     #vlk05=g_vlk_b[l_ac].vlk05,  #FUN-960105 MARK
                      vlk06=g_vlk_b[l_ac].vlk06,
                      vlk13b=g_vlk_b[l_ac].vlk13b,
                      vlk14b=g_vlk_b[l_ac].vlk14b,
                      vlk15b=g_vlk_b[l_ac].vlk15b,
                      vlk16b=g_vlk_b[l_ac].vlk16b,
                      vlk49b=g_vlk_b[l_ac].vlk49b,
                      vlk50b=g_vlk_b[l_ac].vlk50b,
                      vlk51b=g_vlk_b[l_ac].vlk51b,
                      vlk60b=g_vlk_b[l_ac].vlk60b,  #FUN-960105 ADD
                      vlk61b=g_vlk_b[l_ac].vlk61b,  #FUN-960105 ADD
                      vlk62b=g_vlk_b[l_ac].vlk62b,  #FUN-960105 ADD
                      vlk13a=g_vlk_b[l_ac].vlk13a,
                      vlk14a=g_vlk_b[l_ac].vlk14a,
                      vlk15a=g_vlk_b[l_ac].vlk15a,
                      vlk16a=g_vlk_b[l_ac].vlk16a,
                      vlk49a=g_vlk_b[l_ac].vlk49a,
                      vlk50a=g_vlk_b[l_ac].vlk50a,
                      vlk51a=g_vlk_b[l_ac].vlk51a,
                      vlk60a=g_vlk_b[l_ac].vlk60a  #FUN-960105 ADD
                WHERE vlk01=g_vlk_a.vlk01 
                  AND vlk02=g_vlk_a.vlk02 
                  AND vlk04=g_vlk_a.vlk04 
                  AND vlk03=g_vlk_b_t.vlk03
                 #AND vlk05=g_vlk_b_t.vlk05  #FUN-960105 MARK
                  AND vlk06=g_vlk_b_t.vlk06  #FUN-960105 ADD
               IF SQLCA.sqlcode THEN
                  #CALL cl_err3("upd","vlk_file",g_vlk_a.vlk01,g_vlk_b_t.vlk05,SQLCA.sqlcode,"","",1) #FUN-960105 MARK
                   CALL cl_err3("upd","vlk_file",g_vlk_a.vlk01,g_vlk_b_t.vlk06,SQLCA.sqlcode,"","",1) #FUN-960105 ADD
                   LET g_vlk_b[l_ac].* = g_vlk_b_t.*
               ELSE
                  #FUN-960105 ADD --STR-----------------------------------
                   LET l_vlk61a = g_vlk_b[l_ac].vlk61a
                   LET l_vlk62a = g_vlk_b[l_ac].vlk62a
                   IF NOT cl_null(g_vlk_b[l_ac].vlk61a) AND
                      l_vlk61a[1,4]<>'0000' THEN
                      UPDATE vlk_file
                         SET vlk61a = g_vlk_b[l_ac].vlk61a
                       WHERE vlk01=g_vlk_a.vlk01
                         AND vlk02=g_vlk_a.vlk02
                         AND vlk04=g_vlk_a.vlk04
                         AND vlk03=g_vlk_b_t.vlk03
                         AND vlk06=g_vlk_b_t.vlk06
                   END IF
                   IF l_vlk61a[1,4]='0000' THEN 
                     UPDATE vlk_file
                        SET vlk61a = NULL
                      WHERE vlk01=g_vlk_a.vlk01
                        AND vlk02=g_vlk_a.vlk02
                        AND vlk04=g_vlk_a.vlk04
                        AND vlk03=g_vlk_b_t.vlk03
                        AND vlk06=g_vlk_b_t.vlk06
                   END IF
                   IF NOT cl_null(g_vlk_b[l_ac].vlk62a) AND
                      l_vlk62a[1,4]<>'0000' THEN
                      UPDATE vlk_file
                         SET vlk62a = g_vlk_b[l_ac].vlk62a
                       WHERE vlk01=g_vlk_a.vlk01
                         AND vlk02=g_vlk_a.vlk02
                         AND vlk04=g_vlk_a.vlk04
                         AND vlk03=g_vlk_b_t.vlk03
                         AND vlk06=g_vlk_b_t.vlk06
                   END IF 
                   IF l_vlk62a[1,4]='0000' THEN
                      UPDATE vlk_file
                         SET vlk62a = NULL
                       WHERE vlk01=g_vlk_a.vlk01
                         AND vlk02=g_vlk_a.vlk02
                         AND vlk04=g_vlk_a.vlk04
                         AND vlk03=g_vlk_b_t.vlk03
                         AND vlk06=g_vlk_b_t.vlk06
                   END IF
                  #FUN-960105 ADD --END-----------------------------------

                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_vlk_b[l_ac].* = g_vlk_b_t.*
               END IF
               CLOSE t900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t900_bcl
            COMMIT WORK

        ON ACTION controlp
           CASE
             #FUN-960105 MARK --STR------------------------------------ 
             # WHEN INFIELD(vlk05)
             #      IF g_vlk_b[l_ac].vlk07 <> '1' THEN #不為新增
             #          #TQC-8A0013---mod---str---
             #          CALL cl_init_qry_var()
             #          IF g_vlk_b[l_ac].vlk07 ='2' THEN #刪除
             #              LET g_qryparam.form = "q_vlj01"
             #          END IF
             #          IF g_vlk_b[l_ac].vlk07 ='3' THEN #修改
             #              LET g_qryparam.form = "q_vlj03"
             #          END IF
             #          #TQC-8A0013---mod---end---
             #          LET g_qryparam.default1 = g_vlk_b[l_ac].vlk05
             #          LET g_qryparam.default2 = g_vlk_b[l_ac].vlk06
             #          LET g_qryparam.arg1     = g_vlk_a.vlk01
             #          LET g_qryparam.arg2     = g_vlk_a.vlk04
             #          LET g_qryparam.arg3     = g_vlk_b[l_ac].vlk03
             #          CALL cl_create_qry() RETURNING g_vlk_b[l_ac].vlk05,g_vlk_b[l_ac].vlk06
             #          DISPLAY BY NAME g_vlk_b[l_ac].vlk05,g_vlk_b[l_ac].vlk06
             #          NEXT FIELD vlk05
             #      END IF
             #FUN-960105 MARK --END--------------------------------------
              WHEN INFIELD(vlk06)
                   IF g_vlk_b[l_ac].vlk07 ='1' THEN 
                       #1:新增==>
                       IF g_vlk_a.vlk04 = 0 THEN 
                           #工作站
                           CALL q_eca(FALSE,TRUE,g_vlk_b[l_ac].vlk06) RETURNING g_vlk_b[l_ac].vlk06
                           DISPLAY BY NAME g_vlk_b[l_ac].vlk06     
                           NEXT FIELD vlk06
                       ELSE
                           CALL cl_init_qry_var()
                           LET g_qryparam.form = "q_eci"
                           LET g_qryparam.default1 = g_vlk_b[l_ac].vlk06
                           CALL cl_create_qry() RETURNING g_vlk_b[l_ac].vlk06
                           DISPLAY BY NAME g_vlk_b[l_ac].vlk06     
                           NEXT FIELD vlk06
                       END IF
                   ELSE
                       #2:刪除 3:修改==>
                       CALL cl_init_qry_var()
                       IF g_sma.sma917 = 0 THEN 
                          #資源型態 0:工作站
                          LET g_qryparam.form = "q_vne02"
                       ELSE
                          #資源型態 1:機器編號
                          LET g_qryparam.form = "q_vne01" 
                       END IF
                       LET g_qryparam.arg1 = g_vlk_a.vlk01       #工單編號
                       LET g_qryparam.arg2 = g_vlk_a.vlk01       #途程編號
                       LET g_qryparam.arg3 = g_vlk_b[l_ac].vlk03 #加工序號
                       CALL cl_create_qry() RETURNING g_vlk_b[l_ac].vlk06
                       DISPLAY BY NAME g_vlk_b[l_ac].vlk06     
                       NEXT FIELD vlk06
                   END IF
              WHEN INFIELD(vlk03) #製程序號
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_ecm10"
                       LET g_qryparam.default1 = g_vlk_b[l_ac].vlk03
                       LET g_qryparam.arg1 = g_vlk_a.vlk01
                       CALL cl_create_qry() RETURNING g_vlk_b[l_ac].vlk03
                       DISPLAY BY NAME g_vlk_b[l_ac].vlk03
                       NEXT FIELD vlk03
           END CASE

       #ON ACTION CONTROLO                        #沿用所有欄位
       #    IF INFIELD(vlk05) AND l_ac > 1 THEN
       #        LET g_vlk_b[l_ac].* = g_vlk_b[l_ac-1].*
       #        LET g_vlk_b[l_ac].vlk05 = NULL
       #        LET g_vlk_b[l_ac].vlk06 = NULL
       #        DISPLAY g_vlk_b[l_ac].* TO s_vlk[l_ac].*
       #        NEXT FIELD vlk05
       #    END IF

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
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT

    CLOSE t900_bcl
    COMMIT WORK

END FUNCTION
 
FUNCTION t900_b_fill(p_wc2)              #BODY FILL UP
DEFINE
#    p_wc2           LIKE type_file.chr1000, 
    p_wc2           STRING  ,     #NO.FUN-910082 
    l_flag          LIKE type_file.chr1     
    #FUN-960105 MOD --STR-------------------------------------------
    #LET g_sql =
    #    "SELECT vlk03,vlk07,vlk05,vlk06,",
    #    "       vlk13b,vlk14b,vlk15b,vlk16b,vlk49b,vlk50b,vlk51b, ",
    #    "       vlk13a,vlk14a,vlk15a,vlk16a,vlk49a,vlk50a,vlk51a  ",
    #    "  FROM vlk_file",
    #    " WHERE vlk01 = '",g_vlk_a.vlk01,"'",
    #    "  AND  vlk02 = '",g_vlk_a.vlk02,"'",
    #    "  AND  vlk04 = '",g_vlk_a.vlk04,"'",
    #    "  AND ", p_wc2 CLIPPED,            #單身
    #    "  ORDER BY vlk03,vlk05,vlk07"

    LET g_sql =
        "SELECT vlk03,vlk07,vlk06,",
       #"       vlk13b,vlk14b,vlk15b,vlk16b,vlk49b,vlk50b,vlk51b,vnd06 vlk60b,vnd07 vlk61b,vnd08 vlk62b, ",  #FUN-980080 mark
        "       vlk13b,vlk14b,vlk15b,vlk16b,vlk49b,vlk50b,vlk51b,vlk60b,vlk61b,vlk62b, ",                    #FUN-980080 mod
        "       vlk13a,vlk14a,vlk15a,vlk16a,vlk49a,vlk50a,vlk51a,vlk60a,vlk61a,vlk62a  ",
        "  FROM vlk_file LEFT OUTER JOIN vnd_file ON vlk01 = vnd01 AND vlk03 = vnd03 AND vlk06 = vnd05 ", #FUN-B50020 mod
        " WHERE vlk01 = '",g_vlk_a.vlk01,"'",
        "  AND  vlk02 = '",g_vlk_a.vlk02,"'",
        "  AND  vlk04 = '",g_vlk_a.vlk04,"'",
       #"  AND  vlk01=vnd_file.vnd01 ", #FUN-B50020 mark
       #"  AND  vlk03=vnd_file.vnd03 ", #FUN-B50020 mark
       #"  AND  vlk06=vnd_file.vnd05 ", #FUN-B50020 mark
        "  AND ", p_wc2 CLIPPED,            #單身
        "  ORDER BY vlk03,vlk06,vlk07"
    #FUN-960105 MOD --END--------------------------------------------------


    PREPARE t900_pb FROM g_sql
    DECLARE vlk_cs CURSOR FOR t900_pb            #SCROLL CURSOR
 
    CALL g_vlk_b.clear()

    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH vlk_cs INTO g_vlk_b[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_vlk_a.vlk04 = 0 THEN 
            #工作站
            CALL t900_vlk06_0(g_cnt)
        ELSE
            #機器編號
            CALL t900_vlk06_1(g_cnt)
        END IF
        LET g_cnt = g_cnt + 1

        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_vlk_b.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION t900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vlk_b TO s_vlk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

     #ON ACTION output
     #     LET g_action_choice="output"
     #     EXIT DISPLAY

      ON ACTION first
         CALL t900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY               
 

      ON ACTION previous
         CALL t900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 

      ON ACTION jump
         CALL t900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 
      ON ACTION next
         CALL t900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 

      ON ACTION last
         CALL t900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document                #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t900_vlk06_0(l_n) #工作站
DEFINE
    l_n            LIKE type_file.num5,   #目前的ARRAY CNT  
    p_cmd           LIKE type_file.chr1,  
    l_ecaacti       LIKE eca_file.ecaacti

    LET g_errno = ' '
    SELECT eca02,ecaacti INTO g_vlk_b[l_n].desc,l_ecaacti FROM eca_file
     WHERE eca01 = g_vlk_b[l_n].vlk06

         CASE WHEN SQLCA.SQLCODE = 100  
                   LET g_errno = 'aec-100' #無此工作站
                   LET g_vlk_b[l_n].desc = ' '
                   LET l_ecaacti = ' '
              WHEN l_ecaacti='N' 
                   LET g_errno = '9028'
              OTHERWISE          
                   LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         DISPLAY BY NAME g_vlk_b[l_n].desc

END FUNCTION

FUNCTION t900_vlk06_1(l_n) #機器編號
DEFINE
    l_n            LIKE type_file.num5,   #目前的ARRAY CNT  
    p_cmd           LIKE type_file.chr1,  
    l_eciacti       LIKE eci_file.eciacti

    LET g_errno = ' '
    SELECT eci06,eciacti INTO g_vlk_b[l_n].desc,l_eciacti FROM eci_file
     WHERE eci01 = g_vlk_b[l_n].vlk06

         CASE WHEN SQLCA.SQLCODE = 100  
                   LET g_errno = 'mfg4010' #無此機器編號,請重新輸入
                   LET g_vlk_b[l_n].desc = ' '
                   LET l_eciacti = ' '
              WHEN l_eciacti='N' 
                   LET g_errno = '9028'
              OTHERWISE          
                   LET g_errno = SQLCA.SQLCODE USING '-------'
         END CASE
         DISPLAY BY NAME g_vlk_b[l_n].desc

END FUNCTION

FUNCTION t900_set_entry_b(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1     #處理狀態        
   #CALL cl_set_comp_entry("vlk03,vlk07,vlk05,vlk06",TRUE)     #FUN-960105 MARK
    CALL cl_set_comp_entry("vlk03,vlk07,vlk06",TRUE)     #FUN-960105 ADD
END FUNCTION

FUNCTION t900_set_no_entry_b(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1     #處理狀態        
    IF p_cmd = 'u' THEN
       #CALL cl_set_comp_entry("vlk03,vlk07,vlk05,vlk06",FALSE) #FUN-960105 MARK 
       #CALL cl_set_comp_entry("vlk03,vlk07,vlk06",FALSE) #FUN-960105 ADD 090806 
        CALL cl_set_comp_entry("vlk03,vlk07",FALSE)       #FUN-960105 ADD 090806 
    END IF
    #FUN-960105 MOD --STR---------------------
    #IF g_vlk_b[l_ac].vlk07 = '1' THEN
    #   CALL cl_set_comp_entry("vlk05",FALSE)  
    #ELSE                                   
    #    CALL cl_set_comp_entry("vlk06",FALSE)
    #END IF
     IF g_vlk_b[l_ac].vlk07 = '1' THEN
        CALL cl_set_comp_entry("vlk03,vlk07,vlk06,vlk50a,vlk51a,vlk60a,vlk61a,vlk62a",TRUE)
     ELSE
        IF g_vlk_b[l_ac].vlk07 = '2' THEN
          #CALL cl_set_comp_entry("vlk06,vlk50a,vlk51a,vlk60a,vlk61a,vlk62a",FALSE)     #090806 
           CALL cl_set_comp_entry("vlk50a,vlk51a,vlk60a,vlk61a,vlk62a",FALSE)           #090806 
        ELSE
           CALL cl_set_comp_entry("vlk50a,vlk51a,vlk60a,vlk61a,vlk62a",TRUE)
          #CALL cl_set_comp_entry("vlk06",FALSE) #090806 
        END IF
     END IF
    #FUN-960105 MOD --END----------------------


END FUNCTION

FUNCTION t900_set_required()
    IF g_vlk_b[l_ac].vlk07 = '1' THEN #變更方式為'1'
        CALL cl_set_comp_required("vlk50a,vlk51a",TRUE)
        CALL cl_set_comp_required("vlk50a,vlk51a,vlk60a,vlk61a,vlk62a",TRUE)  #FUN-960105 ADD
    END IF
END FUNCTION

FUNCTION t900_set_no_required()
    CALL cl_set_comp_required("vlk50a,vlk51a",FALSE)
    CALL cl_set_comp_required("vlk60a,vlk61a,vlk62a",FALSE)     #FUN-960105 ADD
END FUNCTION
